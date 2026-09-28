#!/usr/bin/env python3
"""FX-02 E2E on UAT-ISV — every HTTP call goes through curl.

Flow per product: partner token (hbdisv) -> create lead (go-e-api) -> payment request (go-e-api -> purchase)
-> pay on the 2C2P *sandbox* with the test card (user-approved 2026-09-24) -> wait for the real 2C2P
callback -> check payment / policy / CMI rows in the UAT-ISV DB (read-only).
Never calls /payment/success and never signs a callback.  Test identity: Rule 4.

Usage: python3 e2e.py mc|mv|mvmc
"""
import datetime as dt
import json
import os
import subprocess
import sys
import time

API = "https://insurverse-uat-isv-api.insurverse.co.th"
PGW = "https://sandbox-pgw.2c2p.com/payment/4.3"
UA = "fx02-e2e/1.0"
PSQL = "/opt/homebrew/opt/libpq/bin/psql"
CARD = {"cardNo": "5555555555554444", "expiryMonth": "12", "expiryYear": "2028", "securityCode": "123"}
PERSON = {"prefixName": "นาย", "firstName": "กฤษณะ", "lastName": "วัฒนายนนต์", "birthDate": "2008-01-01",
          "citizenId": "1111111111119", "email": "kritsana.w.os@horixon-t8.com", "phone": "0628696603",
          "address": "1 หมู่ 1", "provinceId": 10, "districtId": 124, "subdistrictId": 979, "zipcode": "18110"}


def env():
    out = {}
    for line in open(os.path.expanduser("~/Code/docs/company/infrastructure/env/uat_isv.env")):
        line = line.strip()
        if "=" in line and not line.startswith("#"):
            k, v = line.split("=", 1)
            out[k.replace("export ", "").strip()] = v.strip().strip('"').strip("'")
    return out


E = env()


def sql(q):
    r = subprocess.run([PSQL, "-h", E["DB_PUBLIC_HOST"], "-p", E["DB_PORT"], "-U", E["DB_USER"], "-d", E["DB_NAME"],
                        "-At", "-F", "|", "-c", q], env={**os.environ, "PGPASSWORD": E["DB_PASSWORD"]},
                       capture_output=True, text=True)
    return [l.split("|") for l in r.stdout.splitlines() if l]


def curl(method, url, body=None, token=None):
    cmd = ["curl", "-s", "-m", "90", "-X", method, "-A", UA, "-H", "Content-Type: application/json",
           "-w", "\n%{http_code}", url]
    if token:
        cmd[1:1] = ["-H", f"Authorization: Bearer {token}"]
    if body is not None:
        cmd += ["--data-binary", "@-"]
    r = subprocess.run(cmd, input=json.dumps(body, ensure_ascii=False).encode() if body is not None else None,
                       capture_output=True)
    raw, _, code = r.stdout.decode(errors="replace").rpartition("\n")
    try:
        return int(code), json.loads(raw or "{}")
    except ValueError:
        return int(code or 0), {"raw": raw[:200]}


def step(name, ok, detail=""):
    print(f"  {'✅' if ok else '❌'} {name} {detail}")
    if not ok:
        sys.exit(1)


def token():
    secret = sql("select client_secret from insurverse.mas_partner where partner_code='hbdisv' and is_active")[0][0]
    code, d = curl("POST", f"{API}/services/oauth/v2/token",
                   {"grant_type": "client_credentials", "client_id": "hbdisv", "client_secret": secret})
    step("oauth token", code == 200 and d.get("access_token"), f"[{code}]")
    return d["access_token"]


def pay(pay_token):
    """Complete the payment on the 2C2P sandbox (test card, user-approved)."""
    body = {"paymentToken": pay_token, "payment": {"code": {"channelCode": "CC"},
            "data": {"name": "KRITSANA WATTHANIYANON", "email": PERSON["email"], **CARD}}}
    code, d = curl("POST", f"{PGW}/payment", body)
    print(f"  · 2C2P do-payment [{code}] respCode={d.get('respCode')} respDesc={d.get('respDesc')}")
    return d


def mc_lead(tk, start):
    body = {"compCode": "1.10", "brand": "Toyota", "model": "Yaris Ativ", "year": "2026", "startDate": start,
            "carSerialNo": f"FX02E2E{int(time.time())}", "carColor": "CL004", "carLicenseType": "ป้ายขาว",
            "carLicenseNo": "1กข" + str(int(time.time()) % 10000).zfill(4), "carLicenseProvince": "10", "flagDeli": False,
            "deliAddressNo": "", "deliProvinceId": 0, "deliDistrictId": 0, "deliSubdistrictId": 0, "deliZipcode": "",
            "doors": 4, "seat": 7, "cc": 1200, "wg": 0, "bodyType": "เก๋ง 2 ตอน", "group": "0", "sedan": "Sedan",
            "occupation": "พนักงานบริษัท", "occupationCode": "occ_001", **PERSON}
    code, d = curl("PUT", f"{API}/api/v1/lead/comp-motor", body, tk)
    lead = (d.get("data") or {}).get("leadNo")
    step("create compulsory lead", code == 200 and lead, f"[{code}] {d.get('status')}")
    return lead


def payment_request(tk, lead, lead_type, policy_type, amount, desc):
    body = {"leadNo": lead, "leadType": lead_type, "productDesc": desc, "policyType": policy_type, "amount": amount,
            "isIPP": False, "paymentMethod": "CC", "installmentPeriod": 0, "email": PERSON["email"], "remark": "FX02-E2E",
            "redirectUrl": "https://example.com/fx02-e2e", "paymentChannel": "2C2P", "SalesChannel": 1}
    code, d = curl("POST", f"{API}/api/v1/payment/request", body, tk)
    data = d.get("data") or {}
    step("payment request", code == 200 and data.get("token"), f"[{code}] invoice={data.get('invoiceNo')}")
    return data


def wait(label, query, check, seconds=180):
    end = time.time() + seconds
    rows = []
    while time.time() < end:
        rows = sql(query)
        if rows and check(rows):
            return rows
        time.sleep(5)
    return rows


def run_mc():
    print("== MC standalone (พ.ร.บ.)")
    tk = token()
    start = (dt.date.today() + dt.timedelta(days=1)).isoformat()
    lead = mc_lead(tk, start)
    p = payment_request(tk, lead, "mc", "0", 499.05, "พ.ร.บ. FX02 E2E")
    print(f"  · webPaymentUrl {p.get('webPaymentUrl')}")
    pay(p["token"])
    inv = p["invoiceNo"]
    rows = wait("payment_act", f"select payment_status, act_no from insurverse.payment_act where invoice_no='{inv}'",
                lambda r: r[0][0].lower() in ("success", "failed"))
    step("2C2P callback -> payment_act", rows and rows[0][0].lower() == "success", str(rows[:1]))
    act_no = rows[0][1]
    pol = wait("policy", f"""select "Car_Act_No", "Policy_Status", coalesce(cmi_reference_number,''), coalesce(cmi_receive_number,'')
                               from insurverse."Policy_Car_Act_Discount_Premium" where "Car_Act_Lead_No"={int(act_no)}""",
               lambda r: r[0][2] != "", 240)
    step("policy issued", bool(pol), str(pol[:1]))
    step("CMI reference received", bool(pol) and pol[0][2] != "", f"ref={pol[0][2] if pol else ''}")
    return {"product": "MC", "invoice": inv, "policy": pol[0][0] if pol else None}


if __name__ == "__main__":
    what = sys.argv[1] if len(sys.argv) > 1 else "mc"
    res = {"mc": run_mc}[what]()
    print(json.dumps(res, ensure_ascii=False))
