#!/usr/bin/env python3
"""FX-01 #13 test: N concurrent motor leads through go-e-api -> premium saveLeadCoveragePremium.

Pass when every request gets 200, every Lead_No is distinct, and each returned Lead_No is the row
that carries that request's own email marker (kritsana.w.os+fx02-<run>-<i>@horixon-t8.com, Rule 4).

Needs: ~/Code/docs/company/infrastructure/env/uat_isv.env (UAT-ISV DB, read), psql, python `cryptography`.
Writes N rows into Lead_coverage_premium on UAT-ISV (test identity); cleanup_leads.sql removes them.
Usage: python3 concurrent_save_lead.py [N=50]
"""
import concurrent.futures as cf
import json
import os
import subprocess
import sys
import time
import urllib.request

from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

N = int(sys.argv[1]) if len(sys.argv) > 1 else 50
RUN = time.strftime("%H%M%S") + f"{os.getpid() % 1000:03d}"
API = "https://insurverse-uat-isv-api.insurverse.co.th"
PSQL = "/opt/homebrew/opt/libpq/bin/psql"
KEY, IV = b"38a1722233ef49b2455798a728a2c268", b"d3850f7dc420290e"  # leadno-codec skill


def env():
    out = {}
    for line in open(os.path.expanduser("~/Code/docs/company/infrastructure/env/uat_isv.env")):
        line = line.strip()
        if "=" in line and not line.startswith("#"):
            k, v = line.split("=", 1)
            out[k.replace("export ", "").strip()] = v.strip().strip('"').strip("'")
    return out


E = env()


def sql(query):
    r = subprocess.run([PSQL, "-h", E["DB_PUBLIC_HOST"], "-p", E["DB_PORT"], "-U", E["DB_USER"], "-d", E["DB_NAME"],
                        "-At", "-F", "|", "-c", query], env={**os.environ, "PGPASSWORD": E["DB_PASSWORD"]},
                       capture_output=True, text=True, check=True)
    return [l.split("|") for l in r.stdout.splitlines() if l]


def decode(hexstr):
    d = Cipher(algorithms.AES(KEY), modes.CBC(IV)).decryptor()
    raw = d.update(bytes.fromhex(hexstr)) + d.finalize()
    u = padding.PKCS7(128).unpadder()
    return (u.update(raw) + u.finalize()).decode()


def call(method, path, body=None, token=None):
    req = urllib.request.Request(API + path, method=method, data=json.dumps(body).encode() if body else None,
                                 headers={"Content-Type": "application/json", "User-Agent": "fx02-test/1.0",
                                          **({"Authorization": "Bearer " + token} if token else {})})
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            status, raw = r.status, r.read()
    except urllib.error.HTTPError as e:
        status, raw = e.code, e.read()
    try:
        return status, json.loads(raw or b"{}")
    except ValueError:
        return status, {"status": {"raw": raw[:120].decode(errors="replace")}}


secret = sql("select client_secret from insurverse.mas_partner where partner_code='hbdisv' and is_active")[0][0]
_, tok = call("POST", "/services/oauth/v2/token",
              {"grant_type": "client_credentials", "client_id": "hbdisv", "client_secret": secret})
token = tok["access_token"]

base = {"leadNo": "", "firstName": "กฤษณะ", "lastName": "วัฒนายนนต์", "mobile": "0628696603",
        "brand": "Nissan", "model": "Almera", "year": "2024", "doors": 4, "policyType": "1", "garageType": "G",
        "cc": "<=2000", "flagCctv": "N", "flagCarAct": "N", "flagAccess": "N", "driverBehaviorCal": 0,
        "accessParaCode": []}

# pick the first offered option (its seq) of each coverage for this car's 1_G_0 group
_, prem = call("GET", "/api/v1/motor/premium?brand=Nissan&model=Almera&year=2024&doors=4&cc=%3C%3D2000", None, token)
group = next(g for g in prem["data"]["premiumGroup"] if g["key"] == "1_G_0")
SI_FIELD = {"od": "siAns", "tpbi_p": "siTpbiPAns", "tppd": "siTppdAns",
            "mv01": "siMv01Ans", "mv02": "siMv02Ans", "mv03": "siMv03Ans"}
for cov in group["premiumdetail"]["coverageLists"]:
    if cov["siCode"] in SI_FIELD and cov["options"]:
        base[SI_FIELD[cov["siCode"]]] = cov["options"][0]["seq"]  # *Ans = option seq, not the amount


def one(i):
    email = f"kritsana.w.os+fx02-{RUN}-{i}@horixon-t8.com"
    status, body = call("PUT", "/api/v1/lead/motor", {**base, "email": email}, token)
    lead = (body.get("data") or {}).get("leadNo")
    return i, email, status, body.get("status", {}), lead


t0 = time.time()
with cf.ThreadPoolExecutor(max_workers=N) as ex:
    results = list(ex.map(one, range(N)))
elapsed = time.time() - t0

ok = [r for r in results if r[2] == 200 and r[4]]
print(f"run {RUN}: {N} requests in {elapsed:.1f}s, 200 with leadNo: {len(ok)}")
for r in results:
    if r not in ok:
        print("  FAIL", r[0], r[2], r[3])

returned = {r[1]: int(decode(r[4])) for r in ok}
rows = dict((e.lower(), int(n)) for n, e in
            sql(f"""select "Lead_No", lower("Email") from insurverse."Lead_coverage_premium"
                    where lower("Email") like 'kritsana.w.os+fx02-{RUN}-%@horixon-t8.com'"""))
distinct = len(set(returned.values())) == len(returned)
mismatch = [(e, n, rows.get(e.lower())) for e, n in returned.items() if rows.get(e.lower()) != n]
print(f"distinct Lead_No: {distinct} ({len(set(returned.values()))}/{len(returned)})")
print(f"returned Lead_No is the request's own row: {not mismatch} (mismatches: {len(mismatch)})")
for m in mismatch[:10]:
    print("  MISMATCH email=%s returned=%s row=%s" % m)
print(f"contiguous: {sorted(returned.values())[0]}..{sorted(returned.values())[-1]}" if returned else "")
print("PASS" if len(ok) == N and distinct and not mismatch else "FAIL")
