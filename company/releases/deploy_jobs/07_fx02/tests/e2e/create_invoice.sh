#!/bin/bash
# FX-02 E2E — create one lead + PENDING 2C2P invoice on UAT-ISV (web flow, same calls as 2026-09-23).
# usage: [EMAIL=<fixed email>] [NOREG=1] [CAR_PROV=<id>] [CAR_PLATE=<s>] [CAR_SERIAL=<s>] create_invoice.sh mv|bundle|act|pa|home|ta   (NOREG=1: buyer never signs up — no sec_user)
# Test identity: Rule 4 + birth date 2008-01-01 (PDF password 01012008); unique email per case.
# Output (last line): product|invoiceNo|amount|email|webPaymentUrl|encryptedLead
set -uo pipefail
PROD=${1:?mv|bundle|act|pa|home|ta}
cd "$(dirname "$0")/req"
B=https://insurverse-uat-isv-api.insurverse.co.th; H='Content-Type: application/json'
TS=$(date +%H%M%S); EM="${EMAIL:-kritsana.w.os+fx02-${NOREG:+noreg-}$PROD$TS@horixon-t8.com}"; BD=2008-01-01
D1=$(date -v+1d +%Y-%m-%d); D1Y=$(date -v+1d -v+1y -v-1d +%Y-%m-%d)
post(){ curl -s -m 60 -X POST "$1" -H "$H" --data-binary "${2:-@-}"; }
reg(){ [ -n "${NOREG:-}" ] && return 0; curl -s -m 30 -o /dev/null -X POST $B/api/v1/uam/registeraccount_email_auto -H "$H" \
       -d "{\"first_name\":\"กฤษณะ\",\"last_name\":\"วัฒนายนนต์\",\"email\":\"$1\",\"mobile\":\"0628696603\"}"; }
die(){ echo "FAIL $PROD: $*" | cut -c1-300; exit 1; }

case "$PROD" in
  mv|bundle)
    CAR=N; BUNDLE=false; [ "$PROD" = bundle ] && { CAR=Y; BUNDLE=true; }
    R=$(jq --arg em "$EM" --arg c "$CAR" '.data.Email=$em | .data.Flag_Car_Act=$c' a2_req.json | post $B/api/v1/premium/premiumAPI)
    ENC=$(echo "$R" | jq -r '.data.Lead_No // empty'); [ -n "$ENC" ] || die "lead $R"
    reg "$EM"
    AMT=$(post $B/api/v1/premium/premiumAPI "{\"fn\":\"getLeadCoveragePremium\",\"data\":{\"Lead_No\":\"$ENC\"}}" | jq -r '.data.Premium // empty')
    [ -n "$AMT" ] || die "premium"
    P=$(post $B/api/v1/purchase/create-payment "{\"leadNo\":\"$ENC\",\"policyType\":\"1\",\"amount\":$AMT,\"paymentMethod\":\"CC\",\"email\":\"$EM\",\"isIPP\":false,\"bundleFlag\":$BUNDLE,\"productDesc\":\"FX02 E2E $PROD\",\"redirectUrl\":\"https://insurverse-uat-isv-app.insurverse.co.th/\"}");;
  act)
    R=$(jq --arg em "$EM" --arg sn "FX02VIN$TS" --arg lic "9กข$(echo $TS | cut -c3-6)" --arg sd "$D1" --arg bd "$BD" \
        '.data.email=$em | .data.Car_serial_no=$sn | .data.Car_license_no=$lic | .data.Car_license_type="ป้ายขาว" | .data.Start_date=$sd | .data.birth_date=$bd
        | if env.CAR_PROV then .data.Car_license_provice=env.CAR_PROV else . end
        | if env.CAR_PLATE then .data.Car_license_no=env.CAR_PLATE else . end
        | if env.CAR_SERIAL then .data.Car_serial_no=env.CAR_SERIAL else . end' b2_req.json \
        | post $B/api/v1/premium/actAPI)
    ENC=$(echo "$R" | jq -r '.data.Car_Act_Lead_No // empty'); [ -n "$ENC" ] || die "lead $R"
    reg "$EM"
    AMT=$(post $B/api/v1/premium/actAPI "{\"fn\":\"getLeadActPremium\",\"data\":{\"Car_Act_Lead_No\":\"$ENC\"}}" | jq -r '.data.Total // .data[0].Total // empty')
    [ -n "$AMT" ] || die "premium"
    P=$(post $B/api/v1/purchase/create-payment-act "{\"actNo\":\"$ENC\",\"amount\":$AMT,\"paymentMethod\":\"CC\",\"email\":\"$EM\",\"isIPP\":false,\"productDesc\":\"FX02 E2E act\"}");;
  pa|home)
    if [ "$PROD" = pa ]; then
      J=$(jq --arg em "$EM" --arg bd "$BD" --arg s "$D1" --arg e "$D1Y" '.data.email=$em | .data.policyStartdate=$s | .data.policyEnddate=$e | .data.ownerDetails[0].ownerEmail=$em | .data.ownerDetails[0].ownerBirthdate=$bd' lc_req.json)
      R=$(echo "$J" | post $B/api/v1/pa/upsertleadpa); KEY=leadPaNo
    else
      J=$(jq --arg em "$EM" --arg bd "$BD" --arg s "$D1" --arg e "$D1Y" '.data.policyStartdate=$s | .data.policyEnddate=$e | .data.ownerDetails.ownerEmail=$em | .data.ownerDetails.ownerBirthdate=$bd' ld_req.json)
      R=$(echo "$J" | post $B/api/v1/home/upsertleadhome); KEY=leadHomeNo
    fi
    ENC=$(echo "$R" | jq -r ".data.$KEY // empty"); [ -n "$ENC" ] || die "lead $R"
    AMT=$(echo "$R" | jq -r '.data.totalAmt')
    P=$(post $B/api/v1/purchase/create-payment-tran "{\"leadNo\":\"$ENC\",\"leadType\":\"$PROD\",\"amount\":$AMT,\"paymentMethod\":\"CC\",\"email\":\"$EM\",\"isIPP\":false}");;
  ta)
    S=$(date -v+6d +%Y-%m-%d); E=$(date -v+12d +%Y-%m-%d)
    R=$(jq --arg em "$EM" --arg bd "$BD" --arg s "$S" --arg e "$E" '.data.email=$em | .data.policyStartdate=$s | .data.policyEnddate=$e | .data.ownerDetails[0].ownerEmail=$em | .data.ownerDetails[0].ownerBirthdate=$bd' ta_req.json \
        | post $B/api/v1/ta/upsertleadta)
    ENC=$(echo "$R" | jq -r '.data.leadTaNo // empty'); [ -n "$ENC" ] || die "lead $R"
    AMT=$(echo "$R" | jq -r '.data.totalAmt')
    P=$(post $B/api/v1/purchase/create-payment-ta "{\"leadNo\":\"$ENC\",\"amount\":$AMT,\"paymentMethod\":\"CC\",\"email\":\"$EM\",\"isIPP\":false,\"productDesc\":\"FX02 E2E ta\"}");;
  *) die "unknown product";;
esac
INV=$(echo "$P" | jq -r '.data.invoiceNo // empty'); [ -n "$INV" ] || die "payment $P"
echo "$PROD|$INV|$AMT|$EM|$(echo "$P" | jq -r .data.webPaymentUrl)|$ENC"
