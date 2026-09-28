#!/bin/bash
# FX-02 E2E — simulated 2C2P payment callback, UAT-ISV sandbox ONLY.
# Exception to Rule 12 approved by the user 2026-09-25 (option ก) for the FX-02 E2E run only,
# while the 2C2P sandbox cannot complete 3DS payments. Results must be reported as "simulated payment".
#
# usage: sim_callback.sh <invoiceNo> [userDefined1(lead no)] [userDefined2]
#   ud1/ud2 are read from the payment tables when omitted.
# The secret is read from the Secret the purchase Deployment references and is never printed.
set -euo pipefail
INV=${1:?invoiceNo}; UD1=${2:-}; UD2=${3:-}
CTX=gke_insurverse-uat_asia-southeast1-a_gke-uat-isv; NS=insurverse; DEP=backend-purchase-service
CALLBACK=https://insurverse-uat-isv-api.insurverse.co.th/api/v1/purchase/callback
K="kubectl --context $CTX -n $NS"

# --- guards: UAT-ISV cluster + sandbox 2C2P only
[ "$(kubectl config current-context)" = "$CTX" ] || { echo "ABORT: kube context is not UAT-ISV"; exit 1; }
ENVJSON=$($K get deploy $DEP -o jsonpath='{.spec.template.spec.containers[0].env}')
URL=$(echo "$ENVJSON" | jq -r '.[] | select(.name=="KEY_2C2P_URL") | .value')
MID=$(echo "$ENVJSON" | jq -r '.[] | select(.name=="KEY_2C2P_MERCHANT_ID") | .value')
case "$URL" in https://sandbox-pgw.2c2p.com*) ;; *) echo "ABORT: KEY_2C2P_URL is not the sandbox"; exit 1;; esac

# --- invoice data from UAT-ISV DB (read-only)
source ~/Code/docs/company/infrastructure/env/uat_isv.env
q(){ PGPASSWORD="$DB_PASSWORD" /opt/homebrew/opt/libpq/bin/psql -h "$DB_PUBLIC_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -At -F'|' -c "$1"; }
case "${INV:0:1}" in
  A) ROW=$(q "select amount, customer_email, act_no, 'ACT', payment_status from insurverse.payment_act where invoice_no='$INV'");;
  P) ROW=$(q "select amount, customer_email, lead_no, 'POLICY', payment_status from insurverse.payment where invoice_no='$INV'");;
  T) ROW=$(q "select amount, customer_email, lead_ta_no, 'TA', payment_status from insurverse.payment_ta where invoice_no='$INV'");;
  *) ROW=$(q "select amount, customer_email, lead_no, lead_type, payment_status from insurverse.payment_transaction where invoice_no='$INV'");;
esac
[ -n "$ROW" ] || { echo "ABORT: invoice $INV not found"; exit 1; }
IFS='|' read -r AMT EMAIL DBUD1 DBUD2 STATUS <<< "$ROW"
[ "$STATUS" = PENDING ] || { echo "ABORT: $INV is $STATUS, not PENDING"; exit 1; }
UD1=${UD1:-$DBUD1}; UD2=${UD2:-$DBUD2}
[ -n "$UD1" ] || { echo "ABORT: userDefined1 (lead no) required for $INV"; exit 1; }

# --- secret: the key the Deployment itself uses for KEY_2C2P_SECRET (value stays in this process)
SREF=$(echo "$ENVJSON" | jq -r '.[] | select(.name=="KEY_2C2P_SECRET") | .valueFrom.secretKeyRef | "\(.name) \(.key)"')
read -r SNAME SKEY <<< "$SREF"
SEC=$($K get secret "$SNAME" -o jsonpath="{.data.$SKEY}" | base64 -d)
[ -n "$SEC" ] || { echo "ABORT: secret empty"; exit 1; }

# --- sign (HS256, same as purchase VerifyCallbackPayload) and post
BODY=$(SEC="$SEC" MID="$MID" python3 - "$INV" "$AMT" "$EMAIL" "$UD1" "$UD2" <<'PY'
import sys, os, json, hmac, hashlib, base64, time
inv, amt, email, ud1, ud2 = sys.argv[1:6]
b = lambda x: base64.urlsafe_b64encode(x).rstrip(b"=").decode()
claims = {"merchantID": os.environ["MID"], "invoiceNo": inv, "cardNo": "555555XXXXXX4444", "cardToken": "",
          "loyaltyPoints": None, "amount": float(amt), "currencyCode": "THB",
          "transactionDateTime": time.strftime("%Y%m%d%H%M%S"), "agentCode": "SIM", "channelCode": "MA",
          "approvalCode": "SIM" + time.strftime("%H%M%S"), "referenceNo": "SIM-" + inv, "tranRef": "SIM-" + inv,
          "respCode": "0000", "respDesc": "Success (FX-02 simulated payment)", "eci": "02",
          "installmentPeriod": 0, "interestType": "", "interestRate": 0,
          "userDefined1": ud1, "userDefined2": ud2, "userDefined3": email, "userDefined4": "", "userDefined5": ""}
h = b(json.dumps({"alg": "HS256", "typ": "JWT"}).encode())
p = b(json.dumps(claims, ensure_ascii=False).encode())
s = b(hmac.new(os.environ["SEC"].encode(), f"{h}.{p}".encode(), hashlib.sha256).digest())
print(json.dumps({"payload": f"{h}.{p}.{s}"}))
PY
)
unset SEC
echo "SIM callback $INV amount=$AMT ud1=$UD1 ud2=$UD2"
echo "$BODY" | curl -s -m 90 -w ' HTTP%{http_code}\n' -X POST "$CALLBACK" -H 'Content-Type: application/json' --data-binary @- | tail -c 300
