# FX-02 — go-echo-uam-service (`fix/fx-02-uam`)

Branch from `origin/main --no-track`; one commit per ticket; `uat-isv` = ALIGN + merge in **one** push.
Rules carried over from the other repos: no DB change, no fake defaults, no silent truncation, every ticket has a test prepared before push.

## Tickets in this round

| # | Ticket | Change (on main) | Reference | Test |
|---|---|---|---|---|
| 1 | FX-01 #16 | Notification via in-cluster DNS; stop the hairpin loop; close response bodies; client timeout. `helm-prod.yaml` `Backend_Notification` → internal service (in the MR, pre-flight: service name/port/namespace on Prod) | `3c0d2ed` (notification part) | unit: body closed / timeout; E2E: register or OTP mail arrives on UAT-ISV |
| 2 | FX-01 #23 | OCR failure returns a readable error instead of an empty 500 | `3c0d2ed` (OCR part) | unit with a failing OCR stub; response body not empty |
| 3 | OIC 1SYS0007/0008/0009 | **Seven-field validator before CMI** (same rules as fiber-policy: dates, vehicleTypeCode ≤5, province ≤2, plate ≤20, chassis ≤50, not blank). Failing record: not sent, not altered, logged with the missing fields | replaces `0015a7a` `719ab4a` `bfa64ac` `262c7d3` `d80e208` `74b19c4` `40accb4` (fallbacks/truncation — not used) | unit per field; differential on UAT data: complete records → payload identical; "blocks but OIC accepted" = 0 or explained |
| 4 | OIC 2BUS0004 | `contractDt` never later than `effectiveDt` (q1 policy, q2 endorse) | `a53d255` / `7758378` | differential on UAT: rows that change = only rows where old contractDt > effectiveDt |
| 5 | OIC 2BUS0227 | No main-policy reference number → do not send endorse fields (EndorseFlag stays `N`) | `a9531df` | differential / unit: records with a reference number unchanged |
| 6 | OIC 2SYS0019 | q1 (policy): TQM → `ว00019/2546`, others keep `regist_id` (q2 already does this) | `0e755f7` (SQL CASE only, not the controller refactor) | differential: only TQM rows change, non-TQM identical |
| 7 | Auto-register | Existing email: 200 `{is_new_account:false}` instead of 500; new: 200 `{is_new_account:true}` | `aeff2e3` (not `dfee0a5` SSO auto-link) | API: new email / existing email; web checklist (nextjs already handles both) |
| 8 | WS6-04 | Buyer phone to SF: `COALESCE("Owner_phone", phone)` | `b660737` (phone only) | query diff on UAT: only rows with empty Owner_phone change |
| 9 | WS9 | DB pool from env, defaults = Prod values (80/10/1h/30m) | `f71b25d` (dbConnect only) | unit: no env → Prod defaults |

## Not in this round (waiting)
| # | Ticket | Waiting for |
|---|---|---|
| 10 | WS6-02 SF endorse time +7h | find where the time is sent |
| 11 | WS7-04 occupation read-only on renewal | business |
| 12 | WS8-03 hide expired only on Active Policies query | business / spec |
| 13 | WS9-02 reconcile report + **auth** | business (report has personal data, currently no login) |
| 14 | WS6 cancel → SF still Active | business confirms status value; `'C'` does not exist (UAT: ACT/INC/CS/PC), cancel flow uses `INC` |

## Dropped (on uat-isv, not in plan)
Fallbacks (`1111111111119`, `1.10`, `CL004`, province `'10'`), truncation helper, `dfee0a5` SSO auto-link, `/login` 401 change,
SF upsert non-200 → error, `EndorseFlag X/U`, `28a38b6`, `ws6/ws7_database_patches.sql`, `test/run_all_api_tests.sh`,
`Policy_Status='C'` (removed by `1458623`, and absent from main anyway).

## Order
1. Branch + tickets 9, 2, 1 (infra/robustness, low risk)
2. Tickets 4, 5, 6 (SQL) + differential test on UAT data
3. Ticket 3 (validator) + unit + differential
4. Tickets 7, 8
5. ALIGN uat-isv + merge, one push; deploy; E2E (auto-register with the web, notification mail, OCR)
