# 09 — UAT-ISV: premium master sync from UAT (not applied)

> 🇹🇭 UAT-ISV มี master เบี้ยรถไม่ครบ (Imp_Price_Premium ถูกคัดลอกมาแค่ 130,000 จาก 363,862 แถว) และ `duty_per` ตั้งไว้ 0.004 แทน 0.4
> job นี้เติมเฉพาะแถวที่ smoke ใช้ (3 รุ่นรถ, 36 แถว) + แก้ duty_per (ต้องให้ business ยืนยันก่อน) — ยังไม่ได้รัน
>
> 🇬🇧 UAT-ISV has an incomplete motor premium master (Imp_Price_Premium copied only 130,000 of 363,862 rows) and `duty_per` = 0.004 instead of 0.4.
> This job adds only the rows the smoke suite needs (3 car-years, 36 rows) + fixes duty_per (needs business sign-off). Not run yet.

**Scope:** UAT-ISV only (Cloud SQL `insurverse-uat-isv-db`). Data only, no DDL except the two backup tables. 01/02/99 refuse to run on any other server (`inet_server_addr()` guard). Investigated read-only on 2026-09-25.

## Why

| Smoke failure | Code path | Root cause (data) |
|---|---|---|
| mv-create 1.01, 2.02, 2.21, 3.01, 3.03, 3.05, 3.09; mv-mc-bundle 1.01, 2.08, 3.01, 3.03 → `PUT /api/v1/lead/motor` 400 `8000 Data not found` | go-e-api `createLead` → `loadPremium` (usecase.go:727) → premium-service `loadPremium` → key `Type_GarageType_driver_behavior` missing → `model.DataNotFound` | UAT-ISV has only `3_G_0`,`3_G_1` active for Toyota Yaris 2024 (smoke default car). UAT has 10 groups (1_G, 1_SC, 2+_G, 3_G, 3+_G × behavior 0/1). |
| mv-create 4.01–4.03 "loadPremium has no group 1_SC_0" | smoke `lib.js web-lead` reads raw premium-service `loadPremium` | same missing rows |
| PA 2414.35 vs 2423.35, HI 955.51 vs 958.72 | pa/home services: `duty = CEIL(prem * duty_per / 100)` | `sys_param purchase/duty/duty_per` = 0.004 on UAT-ISV, 0.4 on UAT |

loadPremium SQL (premium-service `controllers/premium.controller.js`): `Imp_Price_Premium` (Brand, Model, Year, Doors, CC, is_active) JOIN `Imp_Discount_Premium` on Brand/Model/Year/Doors and `Usage = fn_comp_to_usage(Comp_Code)`. `Imp_Discount_Premium` rows for the smoke cars and `fn_comp_to_usage` (same md5) are identical on both envs.

Duty maths (premium amounts equal on both envs; only duty and the VAT on duty differ):
- PA: prem 1146 + 1267.35 = 2413.35 → UAT-ISV duty ceil(0.0965)=1 → **2414.35**; UAT duty ceil(9.65)=10 → **2423.35**
- HI: prem 892 → UAT-ISV duty 1, VAT 7 % of 893 = 62.51 → **955.51**; UAT duty ceil(3.568)=4, VAT 62.72 → **958.72**

Which duty_per is "right" is a business decision. 0.4 means 0.4 % under the code's `/100`. 0.004 makes every duty 1 THB. Other callers: premium-service `ta.controller.js` and DB `fn_policy_renewal` (`CEIL(prem * TR_DUTY_PERC / 100)`). At the TA smoke amount (235.40) both values give 1 THB, so TA passes either way.

## Tables and row counts (2026-09-25)

| Table | UAT-ISV | UAT | Notes |
|---|---|---|---|
| `insurverse."Imp_Price_Premium"` total / active | 130,000 / 31,926 | 363,862 / 87,444 | same 80 columns and types; no PK/unique on either |
| active loadPremium keys missing on UAT-ISV | — | 55,634 | 9,711 of 17,581 car-years have no active row on UAT-ISV |
| active keys shared by both envs | 31,810 | 31,810 | all 31,810 identical (full-row md5) |
| UAT-ISV-only active keys | 116 | — | `Toyota Landcruiser Prado` (renamed locally; UAT spells it `Land Cruiser Prado`) |
| `insurverse."Imp_Discount_Premium"` | 23,665 | 23,739 | smoke-car rows identical |
| `insurverse.sys_param` | 159 | 158 | only value difference relevant here: `duty_per` 0.004 vs 0.4 (UAT-ISV also has an empty `para_str`) |

Smoke cars (active rows): Toyota Yaris 2024 has 4 on UAT-ISV and 20 on UAT. Mitsubishi Attrage 2021 (cases 2.04, 2.11) has 0 and 16. Jeep Wrangler 2010 (cases 2.04, 2.17) has 0 and 4.

## Why minimal and not a whole-table sync
- UAT-ISV has local edits that do not exist on UAT: renamed Prado rows, 712 distinct rows not on UAT (Nissan Frontier inactive history and others). A truncate-and-reload would wipe them. Appending all 234k missing rows would add a second `Land Cruiser Prado` model to the brand/model dropdowns (go-echo-core-service).
- There is no unique key, so any bulk append depends on the NOT EXISTS guard. 36 rows are easy to review. 55k are not.
- The smoke failures need only the three car-years. If full parity is wanted later, run the same NOT-EXISTS-on-active-key pattern for all 55,634 keys, using COPY from UAT into a staging table. That is a separate job.

## Files
| File | Writes? | What |
|---|---|---|
| `00_precheck_readonly.sql` | no (`BEGIN READ ONLY`) | schema hash, counts, smoke-car groups, duplicate-active guard, the exact loadPremium query, duty/vat, backup presence |
| `01_backup.sql` | yes | `insurverse._bk09_imp_price_premium` (all rows of the 3 car-years, expected 17) + `insurverse._bk09_sys_param` (duty_per) |
| `02_sync.sql` | yes | A: insert UAT's 40 active rows for the 3 cars where no active row with the same key exists (expect **36** inserted, 0 on re-run). B: `duty_per` → 0.4 (skip with `-v skip_duty=1`) |
| `99_rollback.sql` | yes | restore the 3 car-years + duty_per from the `_bk09_*` tables |

The rows in 02 are UAT rows serialised with `row_to_json` and re-read with `json_populate_recordset`. The round-trip was checked on UAT: 40/40 identical md5. A dry-run SELECT on UAT-ISV: 36 would insert, 4 already identical.

## How to run (after approval)
```bash
source ~/Code/docs/company/infrastructure/env/uat_isv.env; export PGPASSWORD="$DB_PASSWORD"
C="host=$DB_PUBLIC_HOST port=$DB_PORT user=$DB_USER dbname=$DB_NAME"
PSQL=/opt/homebrew/opt/libpq/bin/psql
$PSQL "$C" -v ON_ERROR_STOP=1 -f 00_precheck_readonly.sql
$PSQL "$C" -v ON_ERROR_STOP=1 -f 01_backup.sql            # expect 17 | 1
$PSQL "$C" -v ON_ERROR_STOP=1 -f 02_sync.sql              # expect ipp_inserted 36, UPDATE 1 (or add -v skip_duty=1)
$PSQL "$C" -v ON_ERROR_STOP=1 -f 00_precheck_readonly.sql # Yaris 20 rows incl. 1_SC_0; Attrage 16; Wrangler 4; duty_per 0.4
```
Wait 60 s (premium-service node-cache TTL for loadPremium) and re-run the smoke suite. Rollback: `99_rollback.sql`.

## Risks / notes
- Part B changes duty for **every** PA/HI/TA lead and MV renewal (`fn_policy_renewal`) on UAT-ISV. Get business sign-off, or run with `skip_duty=1`.
- mv-create **2.02** will still not be green after the sync. go-e-api `b243c3c` (on origin/uat-isv and main, not on uat) defaults the missing driverBehaviorCal to `0`, so on UAT-ISV the lead is created. The test expects the UAT "Data not found" bug and reports "b243c3c reached host". That is a test expectation for this host, not data.
- The pass/fail of the later steps (payment, voluntary/IIA) was not verified; they were blocked by the lead error until now.
- A premium upload (premium-service `utility.controller.js`) on these car-years between 01 and 99 would be undone by the rollback.
