#!/bin/bash
# FX-02 E2E — after an MV / MV+MC payment, submit the policy form the web success page submits
# (uam POST /api/v1/uam/create_policy_form) so the MV policy is created. Same body as the 2026-09-23 run.
# usage: policy_form.sh mv|bundle <encryptedLead>
# Test identity: Rule 4 + birth date 2008-01-01 (PDF password 01012008).
set -uo pipefail
PROD=${1:?mv|bundle}; ENC=${2:?encryptedLead}
cd "$(dirname "$0")/req"
TS=$(date +%H%M%S); D1=$(date -v+1d +%Y-%m-%d); D1Y=$(date -v+1d -v+1y -v-1d +%Y-%m-%d)
T=a7_req.json; [ "$PROD" = bundle ] && T=a7_bundle.json
jq --arg l "$ENC" --arg s "$D1" --arg e "$D1Y" --arg vin "FX02$(echo "$PROD" | tr a-z A-Z)VIN$TS" --arg reg "7กข$(echo $TS | cut -c3-6)" '
  .car.lead_no=$l | .person.lead_no=$l | .person.birth_date="2008-01-01"
  | .car.cc=""   # uam SanitizeHTML (2024) rejects any body containing "<" or ">", e.g. "<=2000"
  | .car.effective_date_coverage_start=$s | .car.effective_date_coverage_end=$e
  | .car.vin=$vin | .car.vehicle_registration_number=$reg
  | if .car.act then .car.effective_date_rd_start=$s | .car.effective_date_rd_end=$e else . end' "$T" \
| curl -s -m 90 -w ' HTTP%{http_code}\n' -X POST https://insurverse-uat-isv-api.insurverse.co.th/api/v1/uam/create_policy_form \
    -H 'Content-Type: application/json' --data-binary @- | cut -c1-400
