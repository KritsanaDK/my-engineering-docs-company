#!/bin/bash
# FX-02 E2E — READ-ONLY check after a (simulated) payment callback on UAT-ISV.
# usage: verify_e2e.sh <invoiceNo> [minutes of purchase logs, default 10]
# Shows: payment row, callback row (no card data), policy + CMI numbers (ACT), purchase log lines for the invoice.
set -uo pipefail
INV=${1:?invoiceNo}; MIN=${2:-10}
case "$INV" in *[!A-Z0-9]*) echo "ABORT: bad invoice"; exit 1;; esac
CTX=gke_insurverse-uat_asia-southeast1-a_gke-uat-isv; NS=insurverse
source ~/Code/docs/company/infrastructure/env/uat_isv.env
q(){ PGPASSWORD="$DB_PASSWORD" /opt/homebrew/opt/libpq/bin/psql -h "$DB_PUBLIC_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
     -At -F' | ' -v ON_ERROR_STOP=1 -c "set default_transaction_read_only=on; $1" | grep -v '^SET$'; }

case "${INV:0:1}" in
  A) T=payment_act; LEADCOL=act_no;; P) T=payment; LEADCOL=lead_no;;
  T) T=payment_ta; LEADCOL=lead_ta_no;;   *) T=payment_transaction; LEADCOL=lead_no;;
esac
echo "== payment ($T)"
q "select invoice_no, payment_status, $LEADCOL, amount, updated_at::timestamp(0) from insurverse.$T where invoice_no='$INV'"
LEAD=$(q "select $LEADCOL from insurverse.$T where invoice_no='$INV'")

echo "== buyer account (sec_user by payment email): email | create_date | sf_account"
q "select u.email, u.create_date::timestamp(0), coalesce(u.sf_account,'(NULL)') from insurverse.$T p left join insurverse.sec_user u on u.email=p.customer_email where p.invoice_no='$INV'"

echo "== callback"
q "select created_at::timestamp(0), callback_type, payment_type, data->>'respCode', data->>'agentCode' from insurverse.payment_callback where invoice_no='$INV'"

if [ -n "$LEAD" ]; then
  case "${INV:0:1}" in
    A) echo "== policy + CMI (Policy_Car_Act_Discount_Premium, act lead $LEAD)"
       q "select \"Car_Act_No\", \"Policy_Status\", coalesce(cmi_reference_number,'-'), coalesce(cmi_receive_number,'-') from insurverse.\"Policy_Car_Act_Discount_Premium\" where \"Car_Act_Lead_No\"=$LEAD";;
    P) echo "== MV policy (Policy_coverage_premium -> Policy_Header, lead $LEAD): Policy_No | status | IIA ref | SF id"
       q "select c.\"Policy_No\", h.\"Policy_Status\", coalesce(h.\"IIA_Ref_no\",'-'), coalesce(h.\"SF_Policy_id\",'-') from insurverse.\"Policy_coverage_premium\" c left join insurverse.\"Policy_Header\" h on h.\"Policy_No\"=c.\"Policy_No\" where c.\"Lead_No\"::text='$LEAD'"
       echo "== bundled ACT (Policy_Car_Act_Discount_Premium, Lead_No $LEAD)"
       q "select \"Car_Act_No\", \"Policy_Status\", coalesce(cmi_reference_number,'-'), coalesce(cmi_receive_number,'-') from insurverse.\"Policy_Car_Act_Discount_Premium\" where \"Lead_No\"::text='$LEAD'";;
    G) echo "== PA policy (policy_pa_premium, lead $LEAD): no | status | IIA code | SF id"
       q "select policy_pa_no, policy_status, coalesce(iia_response_code::text,'-'), coalesce(sf_policy_id,'-') from insurverse.policy_pa_premium where lead_pa_no=$LEAD";;
    H) echo "== Home policy (policy_home_premium, lead $LEAD): no | status | IIA code | SF id"
       q "select policy_home_no, policy_status, coalesce(iia_response_code::text,'-'), coalesce(sf_policy_id,'-') from insurverse.policy_home_premium where lead_home_no=$LEAD";;
    T) echo "== TA policy (policy_ta_premium, lead $LEAD): no | status | IIA code | SF id"
       q "select policy_ta_no, policy_status, coalesce(iia_response_code::text,'-'), coalesce(sf_policy_id,'-') from insurverse.policy_ta_premium where lead_ta_no=$LEAD";;
  esac
fi

echo "== purchase logs (last ${MIN}m)"
for p in $(kubectl --context $CTX -n $NS get pod -o name | grep backend-purchase-service); do
  kubectl --context $CTX -n $NS logs "$p" --since=${MIN}m 2>/dev/null \
    | grep -E "$INV|ACT POLICY ISSUED|CONVERT CAR ACT|REJECTED|ERROR|panic" | cut -c1-200 | tail -12
done
