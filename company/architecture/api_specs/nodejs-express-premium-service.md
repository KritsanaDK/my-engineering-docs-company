# nodejs-express-premium-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/nodejs-express-premium-service` (Node.js / Express 4, Sequelize raw SQL).
> Generated from route registration (`services/routing.service.js`), the `fn` dispatcher (`services/utility.service.js:38` `callFunc`), the auth allow-list (`services/middleware.service.js`) and controller code. `README.md` is out of date and was not used as a source.
> Spec date: 2026-09-23. Read-only analysis. Nothing was built or run.

---

## Overview (ภาพรวม)

| Item | Value |
|---|---|
| Purpose | Premium quoting and lead service for Insurverse. It does 4 things: (1) motor voluntary (ภาคสมัครใจ, types 1 / 2+ / 3 / 3+) premium lookup and OIC tariff re-calculation, and it stores leads in `Lead_coverage_premium`; (2) motor compulsory (ACT / พ.ร.บ.) master lookups and leads in `Lead_Car_Act_Discount_Premium`; (3) travel (TA) packages and leads; (4) promo code listing, booking and activation. It also has admin utilities: master-data Excel import/delete, a Cloud Run trigger, and JSON address-file generation. |
| Framework | Express 4 + `body-parser` (JSON and urlencoded, 50 MB limit) + `cors()` (all origins) + `express-session`. Sequelize is used only as a connection (`connection.query` raw SQL, named `:replacements`). Joi validates 4 payloads. |
| Port | `3001`, hard-coded in `services/config.service.js` (Dockerfile `EXPOSE 3001`) |
| Base path | `/api/v1/premium` (`configService.referencesPath`). `/healthcheck` is at the root. |
| Routing style | **RPC-style dispatch.** There are only 4 business routes (`/utilityAPI`, `/premiumAPI`, `/actAPI`, `/taAPI`). Each one accepts GET **and** POST with a JSON body `{ "fn": "<methodName>", "data": { … } }`, and `callFunc` calls `controller[fn](req,res)`. |
| DB | PostgreSQL. Schema and search path `insurverse` (`services/sequelize/index.js`). Pool max 10, min 3. No SSL options are set. |
| Response envelope (dispatcher) | Success: HTTP **201** `{ "status": true, "data": {…} }`. Failure: HTTP **400** `{ "status": false, "msg": … }`. `responseFailureShowModel`: HTTP 400 `{ "status":400, "title", "description", "result": null }`. Auth/injection reject: HTTP **200** `{ "status": false, "msg": "API Reject Request (…)" }`. Unknown `fn`: HTTP 200 `{ "status": true, "msg": { "info": "Function \"x\"' was not found" }, "data": {} }`. |
| Response envelope (direct routes) | Promo routes and `deleteUser` use `BaseController.ok` → HTTP 200 raw JSON. |
| In-memory cache | `node-cache`, 60 s TTL. Used by `loadPremium`, `loadBrand`, `loadModel`, `loadModelYear` and `loadActPremium`. The key is `md5(JSON.stringify(data))`. |

### Environment variables (names only / ชื่อตัวแปรเท่านั้น)

Read in code (`process.env.*`): `DATABASE_HOST`, `DATABASE_NAME`, `DATABASE_USER`, `DATABASE_PASSWORD`, `ENV`, `NODE_ENV`, `LINENOTI`, `ENC_KEY`, `IV`, `Backend_Uam`, `Backend_Consent`, `Backend_Notification`, `Backend_Core`, `SF_ENDPOINT`, `SF_Client_ID`, `SF_Client_Secret`, `SF_UserName`, `SF_Password`, `REMOTE_API_URL` (load-test script only).

Also set in Helm (`helm/helm-uat-isv.yaml`) but not read by this code: `Base_Url`, `Backend_Doc`, `Backend_Auth`, `Backend_File`, `Backend_Purchase`, `Backend_Premium`, `Backend_Saleforce`.

| Var | Used for |
|---|---|
| `ENC_KEY`, `IV` | AES-256-CBC used to encrypt and decrypt `Lead_No`, `Car_Act_Lead_No` and `leadTaNo` (`ase256Encode/Decode`). The client only ever sees the encrypted lead number. |
| `ENV` | Selects the GCP namespace/bucket/credential file (`config/*.js`) and the environment host for the ACT master-data refresh call |
| `LINENOTI` | `"NO"` turns off `sendNotiLog` (the LINE Notify call is commented out anyway) |
| `Backend_Uam` | `POST {Backend_Uam}drop_lead` (budget lead) and AMLO check (the AMLO check can't be reached, see below) |
| `Backend_Consent` | `POST {Backend_Consent}consent-receipt/payment` |
| `Backend_Notification` | `POST {Backend_Notification}push_notification_id` (promo booking) |
| `Backend_Core` | `GET {Backend_Core}update-carmodel-file` after a master import |
| `SF_*` | `services/salesforce.service.js` (Salesforce password grant). ⚠️ No controller imports it, so it is dead code. |

Hard-coded values in source (names/locations only, values not copied): the JWT access and refresh keys in `services/config.service.js`, the `express-session` secret in `services/express.service.js:23`, and the premium checksum salt in `services/utility.service.js` (`premiumCheckSum`).

### External / third-party calls (การเรียกระบบภายนอก)

| Target | Method + path | Caller |
|---|---|---|
| Internal UAM | `POST {Backend_Uam}drop_lead` | `premiumAPI fn=dropLeadBudget` |
| Internal Consent | `POST {Backend_Consent}consent-receipt/payment` | `dropLeadBudget` (`iiaService.accessConsentReceipt`) |
| Internal Notification | `POST {Backend_Notification}push_notification_id` | `POST /promotions-book` |
| Internal Core | `GET {Backend_Core}update-carmodel-file` | `utilityAPI fn=importMasterData` |
| Environment API host (dev/uat/prod hosts hard-coded) | `GET` refresh after the ACT import | `utilityAPI fn=importMasterDataAct` ⚠️ exact path unverified |
| Google Cloud Storage | `bucket(<env bucket>).file("run/runfile-new.xlsx").save()` | `utilityAPI fn=startCloudRun` |
| Google Cloud Run Admin API | `POST https://asia-southeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/{ns}/jobs/oic-task:run` (service-account JWT) | `startCloudRun` |

---

## Auth & Middleware (การยืนยันตัวตน)

Order in `services/express.service.js` and `routing.service.js`:

1. `express-session` (hard-coded secret, default MemoryStore). Nothing in the code reads the session.
2. `cors()`: all origins allowed.
3. `bodyParser.json` / `urlencoded` (50 MB).
4. Routes registered **before** the middleware get no check at all: `/healthcheck`, `GET /promotions-list`, `GET /promotions-list-with-prefix`, `POST /promotions-book`, `POST /promotions-active`, `GET /deleteUser`.
5. `middlewareService.middleware` (`services/middleware.service.js:52`) runs on the 4 dispatch routes:
   - **"Injection detection"**: lower-cases `JSON.stringify(req.body)` and rejects it if it contains `;`, `--` or `'`. It returns HTTP 200 `API Reject Request (Injection Detection)`. It does not check `"`, and it does not decode base64 payloads (Excel uploads).
   - **"Auth"**: this is an allow-list of `fn` names (`skipAuth`, 41 names). If `req.body.fn` is in the list, the request goes through. **There is no token check at all.** `auth.service.js` (JWT) and `auth.controller.js login` exist, but `authController` is not routed and `login` can't be reached.
   - It adds the `res.responseSuccess` / `responseFailure` / `responseFailureShowModel` helpers.

**Effective auth: none.** Every reachable operation below is public. The encrypted lead numbers act as bearer "capability" tokens for lead read and update.

Allow-listed `fn` names with **no matching method** (dead entries): `loadPremiumRenew`, `login` (only on the unrouted auth controller), `saveBudgetLeadCoveragePremium` and `checkBudgetPremium` (commented out), `calculatePromocode`, `getLeadTAPriceza`, `getLeadPAPriceza`, `getLeadHOMEPriceza`. Methods that exist but are **not** allow-listed, so they can't be reached: `checkAMLO` (act and ta), `getLeadTAData`, `excelHeaderValidate`.

Note: `callFunc` only checks the `fn` name, not which route it came in on. An allow-listed `fn` is served by any of the 4 routes whose controller has that method.

---

## Endpoint Summary

Routes (`services/routing.service.js`): **10 routes**. Business operations reachable through `fn`: **32**. Total documented: **38** callable operations.

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | `services/routing.service.js:20` (inline) | Returns `{}` HTTP 200 |
| 2 | GET | `/api/v1/premium/promotions-list` | none | `controllers/promo.controller.js:13` `getListPromocode` | Promo list via `fn_promo_promotion_list` |
| 3 | GET | `/api/v1/premium/promotions-list-with-prefix` | none | `controllers/promo.controller.js:48` `getListPromocodeWithPrefix` | Promo list plus a prefix search on `promo_code` |
| 4 | POST | `/api/v1/premium/promotions-book` | none | `controllers/promo.controller.js:185` `updateBookPromocode` | Book a promo for a user (`fn_update_promo_book`), then push a notification |
| 5 | POST | `/api/v1/premium/promotions-active` | none | `controllers/promo.controller.js:228` `updateActivePromocode` | Activate a promo on a lead (`fn_update_promo_active`) |
| 6 | GET | `/api/v1/premium/deleteUser?email=` | none | `controllers/user.controller.js:9` `deleteUser` | **Deletes `sec_user` and `sec_user_sso` rows by email.** ⚠️ SQL injection |
| 7 | GET/POST | `/api/v1/premium/premiumAPI` `fn=loadPremium` | fn allow-list | `controllers/premium.controller.js:46` | Motor rate rows for a car, plus a checksum |
| 8 | GET/POST | `…/premiumAPI` `fn=saveLeadCoveragePremium` | fn allow-list | `controllers/premium.controller.js:158` | Re-calculate the premium (OIC), then INSERT a motor lead |
| 9 | GET/POST | `…/premiumAPI` `fn=checkTariff` | fn allow-list | `controllers/premium.controller.js:531` | Pure calculation: premium plus tariff breakdown (no DB) |
| 10 | GET/POST | `…/premiumAPI` `fn=updateLeadCoveragePremium` | fn allow-list | `controllers/premium.controller.js:1413` | Re-calculate, then UPDATE the motor lead (promo, referral, drivers) |
| 11 | GET/POST | `…/premiumAPI` `fn=getLeadCoveragePremium` | fn allow-list | `controllers/premium.controller.js:2240` | Read a motor lead by encrypted `Lead_No` |
| 12 | GET/POST | `…/premiumAPI` `fn=getLeadCoveragePremiumRenewal` | fn allow-list | `controllers/premium.controller.js:2370` | Read a renewal lead with the prior policy, user and ACT data |
| 13 | GET/POST | `…/premiumAPI` `fn=dropLeadBudget` | fn allow-list | `controllers/premium.controller.js:2535` | Consent receipt, then UAM `drop_lead` |
| 14 | GET/POST | `…/premiumAPI` `fn=saveLeadRenew` | fn allow-list | `controllers/premium.controller.js:2566` | Create a renewal lead via `fn_policy_renewal` |
| 15 | GET/POST | `…/premiumAPI` `fn=checkCrossExpireDate` | fn allow-list | `controllers/premium.controller.js:2628` | Active MV and MC policy dates by chassis, plus the ACT overlap whitelist |
| 16 | GET/POST | `…/premiumAPI` `fn=checkPremCal` | fn allow-list | `controllers/premium.controller.js:2750` | Batch check of a rate row against the OIC band (`calculatePremium`) |
| 17 | GET/POST | `…/premiumAPI` `fn=updateEditInfoLeadCoveragePremium` | fn allow-list | `controllers/premium.controller.js:2806` | Edit a lead's info (drivers, CCTV, accessories) and re-calculate |
| 18 | GET/POST | `…/actAPI` `fn=loadBrand` | fn allow-list | `controllers/act.controller.js:47` | ACT brands by `Comp_Code` |
| 19 | GET/POST | `…/actAPI` `fn=loadModel` | fn allow-list | `controllers/act.controller.js:83` | ACT models by Brand + `Comp_Code` |
| 20 | GET/POST | `…/actAPI` `fn=loadModelYear` | fn allow-list | `controllers/act.controller.js:119` | ACT rate rows by Brand/Model/`Comp_Code` |
| 21 | GET/POST | `…/actAPI` `fn=loadActPremium` | fn allow-list | `controllers/act.controller.js:160` | ACT price by `Comp_Code` |
| 22 | GET/POST | `…/actAPI` `fn=saveLeadActPremium` | fn allow-list | `controllers/act.controller.js:196` | INSERT an ACT lead |
| 23 | GET/POST | `…/actAPI` `fn=updateLeadActPremium` | fn allow-list | `controllers/act.controller.js:391` | UPDATE an ACT lead (checks the price is unchanged) |
| 24 | GET/POST | `…/actAPI` `fn=updateReferalCodeLeadActPremium` | fn allow-list | `controllers/act.controller.js:641` | Set the referral code on an ACT lead |
| 25 | GET/POST | `…/actAPI` `fn=getLeadActPremium` | fn allow-list | `controllers/act.controller.js:722` | Read an unpaid ACT lead |
| 26 | GET/POST | `…/taAPI` `fn=loadATPackage` | fn allow-list | `controllers/ta.controller.js:230` | TA packages, price, coverages and countries |
| 27 | GET/POST | `…/taAPI` `fn=upsertLeadTA` | fn allow-list | `controllers/ta.controller.js:317` | Create or update a TA lead, participants, add-ons and promo |
| 28 | GET/POST | `…/taAPI` `fn=getLeadTA` | fn allow-list | `controllers/ta.controller.js:1059` | Read a TA lead |
| 29 | GET/POST | `…/utilityAPI` `fn=startCloudRun` | fn allow-list | `controllers/utility.controller.js:49` | Upload an Excel file to GCS and run the Cloud Run job `oic-task` |
| 30 | GET/POST | `…/utilityAPI` `fn=importMasterData` | fn allow-list | `controllers/utility.controller.js:243` | Excel → deactivate and INSERT rows in `Imp_Price_Premium` |
| 31 | GET/POST | `…/utilityAPI` `fn=deleteMasterData` | fn allow-list | `controllers/utility.controller.js:502` | Excel → DELETE rows in `Imp_Price_Premium` |
| 32 | GET/POST | `…/utilityAPI` `fn=importMasterDataAct` | fn allow-list | `controllers/utility.controller.js:651` | **DELETE all rows in `Imp_Discount_Premium`**, then INSERT from Excel |
| 33 | GET/POST | `…/utilityAPI` `fn=genjsonFile` | fn allow-list | `controllers/utility.controller.js:785` | Writes `address.json` to local disk. Never sends a response |
| 34 | GET/POST | `…/utilityAPI` `fn=genjsonArrayFile` | fn allow-list | `controllers/utility.controller.js:827` | Writes `province.json`. Never sends a response |
| 35 | GET/POST | `…/utilityAPI` `fn=genjsonArrayFileMdd` | fn allow-list | `controllers/utility.controller.js:876` | Writes `address.json` (M tables). Never sends a response |
| 36 | GET/POST | `…/utilityAPI` `fn=genjsonZipcodeFile` | fn allow-list | `controllers/utility.controller.js:940` | Writes `zipCode.json`. Never sends a response |
| 37 | GET/POST | `…/utilityAPI` `fn=bypassCarInspection` | fn allow-list | `controllers/utility.controller.js:958` | Marks `Policy_Header.Car_Inspect_Status='success'` |
| 38 | GET/POST | `…/utilityAPI` `fn=decode` | fn allow-list | `controllers/utility.controller.js:976` | **Decrypts any AES text** (lead-number oracle) |

Dispatch route definitions: `/utilityAPI` `routing.service.js:41`, `/premiumAPI` `:46`, `/actAPI` `:50`, `/taAPI` `:54`. All 4 are `.get()` + `.post()`, and the GET form also reads the JSON body.

---

## Premium calculation — inputs / outputs (สรุปการคำนวณเบี้ย)

Core: `UtilityService.OIC(item, isReturntariff=false, purchaseDate=null, FTBOnly=false)` (`services/utility.service.js:131`). There is a second copy for batch checks: `calculatePremium` (`:2654`). Renewal accessory re-pricing uses `recalculateBasicPremium` (`:4552`).

### Flow (motor voluntary)

1. **`loadPremium`**. Input: `{ Brand, Model, Year, Doors, CC }`. It reads `Imp_Price_Premium` (active) JOIN `Imp_Discount_Premium` (for `Prem_ACT`, matching `Usage = fn_comp_to_usage(Comp_Code)`) and `sys_param` (`flag_acc_2plus`, `flag_acc_3plus`). Output: an object keyed `"{Type}_{GarageType}_{driver_behavior}"`. Each entry is the full rate row (`SI_1..5`, `Prem_OD_1..5`, `Prem_FT_1..5`, `SI/Prem_TPBI_1..3`, `SI/Prem_TPPD_1..3`, `SI/Prem_MV01..03_1..3`, `SI/Prem_Access_1..3`, `sc_premium_amt_1..5`, `CCTV`, `Prem_ACT`, …) plus `checkSum` (md5 of the rate fields + salt) and `isShowAccess`.
2. The client picks options (`*_Ans` indexes) and sends the row back with `checkSum` to `saveLeadCoveragePremium` or `updateLeadCoveragePremium`. The server checks `premiumCheckSum(payload) == checkSum` (**"CheckSum Fail"** otherwise), so rate fields can't be changed. The `*_Ans` selections and the discount percentages are not covered by the checksum.
3. `OIC()` re-calculates the premium on the server.

### OIC() inputs

| Input field | Meaning |
|---|---|
| `Type` | `1`, `2+`, `3`, `3+` (selects `tariffCalType1/2/3`, plus `tariffCalType5` for plus types) |
| `CC` | `<=2000` → car-size factor 1.12, `>2000` → 1.00 |
| `Usage` / `carUse` | `110` → 1.00, `120` → 1.05 |
| `driver_behavior_1..5` | min of the non-null values → `driver_behavior_cal` → factor (0:1.05, 1:1.00, 2:0.90, 3:0.80, 4:0.70, 5:0.60) |
| `Year` (+ `purchaseDate`) | car age → factor 1.00 … 1.27 (age >10) |
| `Group` | car group factor |
| `SI_{OD_Ans}` (+ `SI_Access_{SI_Access_Ans}`) | sum insured factor |
| `SI_TPBI_{Ans}`, `SI_TPPD_{Ans}` | third-party limits |
| `Prem_OD/FT_{OD_Ans}`, `Prem_TPBI/TPPD_{Ans}`, `Prem_MV01..03_{Ans}`, `Prem_Access_{Ans}`, `sc_premium_amt_{OD_Ans}` | rate components summed into the gross premium |
| `Fleet_Disc_perc`, `NCB_Disc_perc`, `Other_Disc_perc`, `Flag_CCTV`/`CCTV` | discount percentages (FTB paths) |
| `Flag_Car_Act` + `Prem_ACT` | adds the compulsory premium to the total |
| `basic_premium_v5` | override for the 2+/3+ V5 OD base (default 4500 with accessory, else 3500) |

Rules: the basic premium is clamped to a band per type (`PREMIUM_LIMITS`: `1` 7,600–12,000; `3` 2,200–3,000; `2+` 3,000–5,000; `3+` 2,200–3,000). Duty is `ceil(premium×0.4%)` and VAT is `(premium+duty)×7%`.

### OIC() output

`{ Fleet_Disc_perc, NCB_Disc_perc, Other_Disc_perc, Fleet_Disc_Amt, NCB_Disc_Amt, Other_Disc_Amt, Total_Amt_exclude_mv, Basic_Premium, premium, premium_v5_od, basic_premium_v5, Driver_Discount, driver_behavior_disc_amt, CCTV_Discount, Premium_Before_Other_Dis, duty, vat, [tariff] }`

If `isReturntariff` is set, `tariff` is `{ BasicPremium, Si, CarUse, CarSize, CarAge, DriverBehavior, CarGroup, TPBI, TPBI_P, TPPD, Fleet, NCB, Other, AttachmentPremium, PremiumExDutyExVat, Vat, Duty }`.

Persisted to the lead: `Perm_Amt = premium − duty − vat − (Prem_ACT if Flag_Car_Act='Y')`, `Duty_Amt`, `Vat_Amt`, `Total_Amt = premium − Prem_ACT(if Y)`, `Total_Disc_Amt`, SI limits (`SI_Limit`, `SI_TPBI_Limit`, …, `SI_Access_Limit`), component amounts (`OD_Amt`, `FT_Amt`, `SI_*_Amt`), `car_price` (Type 1: `SI/0.8`; others: derived from the Type-1 row × 0.9^age, min 100,000; rounded up to 10,000) and `oic_version` (`sys_param` Policy/oic_version/current_version).

Promo (in `updateLeadCoveragePremium`): the promo percent from `promo_code.prem_value` is added to `Other_Disc_perc` and the premium is re-calculated. `promo_discount_per`/`promo_discount_amt` are stored. The quota is checked against `promo_code_trans` counts.

`checkPremCal`: input is one full rate row (Joi `premCalRequestSchema`, `allowUnknown:false`). Output is `{ result: { no_oic_count, no_oic_list? } }` (the list is included only when the top-level `detail == true`).

ACT (compulsory): there is **no calculation**. Prices (`Premium, Discount, Net_Premium, Stamp, Vat, Total`) come from `Imp_Discount_Premium` by `Comp_Code`, and the client sends them back when it saves the lead.

TA: the server re-reads `mas_ta_premium.total_amt` by package and day count, and rejects `taPackageTotalAmt is invalid` if the client total differs.

---

## Endpoints

All dispatcher calls use this request shape:

```json
{ "fn": "<name>", "data": { … } }
```

### 1. `GET /healthcheck`
Returns `{}` with HTTP 200.

### 2. `GET /api/v1/premium/promotions-list`
**Query:** `email`, `product_group_type`, `product_sub_type`, `promocode` (all optional).
**200:** `{ "data": <json from fn_promo_promotion_list>, "msg": "success" }`
**DB:** `insurverse.fn_promo_promotion_list(:product_group_type,:product_sub_type,:promocode,:email)`.

### 3. `GET /api/v1/premium/promotions-list-with-prefix`
**Query:** same as #2, plus `codePrefix` and `suggest_status`.
**200:** `{ "data": [...], "msg": "success" }`
**DB:** `fn_promo_promotion_list`, and a SELECT on `promo_code` JOIN `promo_group`. The WHERE clause is built with string interpolation. The code escapes quotes (`'`→`''`), but ⚠️ the query is still not parameterized. If `codePrefix` is missing, `.replace` on null throws and the handler returns a 500 ⚠️ unverified.

### 4. `POST /api/v1/premium/promotions-book`
**Body:** `{ "user_id": <int>, "promo_code_id": <int> }`
**200:** `{ "msg": "success" }`
**DB:** `fn_update_promo_book(:user_id,:promo_code_id)` → `rtn_success, rtn_msg, rtn_promo_code, rtn_app_noti_id`.
**Outbound:** `POST {Backend_Notification}push_notification_id` with `{ id: rtn_app_noti_id }`.
⚠️ The caller can pass any `user_id`, because there is no auth.

### 5. `POST /api/v1/premium/promotions-active`
**Body:** `{ "policy_type": "…", "lead_no": "…" }` (a plain lead number, not encrypted).
**200:** `{ "msg": <rtn_msg> }`
**DB:** `fn_update_promo_active(:policy_type,:lead_no)`.

### 6. `GET /api/v1/premium/deleteUser?email=`
**DB:** `DELETE FROM sec_user WHERE email = '${email}'; DELETE FROM sec_user_sso WHERE email = '${email}';` (string interpolation, multi-statement).
**200:** always `{ "msg": "success" }`. Errors are swallowed.
⚠️ **Critical:** this route is unauthenticated, uses GET, deletes users, and is open to SQL injection. It is registered before the injection filter.

### 7. `fn=loadPremium`
**data:** `Brand` (string), `Model` (string), `Year` (number/string, `.toString()`), `Doors` (number), `CC` (`<=2000` / `>2000`).
```json
{ "fn": "loadPremium", "data": { "Brand": "TOYOTA", "Model": "YARIS", "Year": 2024, "Doors": 4, "CC": "<=2000" } }
```
**201:** `{ "status": true, "data": { "1_G_0": { "Brand": "…", "Type": "1", "GarageType": "G", "SI_1": 500000, "Prem_OD_1": 9000, "…": "…", "Prem_ACT": 645.21, "checkSum": "<md5>", "isShowAccess": true } } }`
**Errors:** 400 `{status:false,msg:{}}`.
**DB:** R `Imp_Price_Premium`, R `Imp_Discount_Premium`, `fn_comp_to_usage`, R `sys_param`.

### 8. `fn=saveLeadCoveragePremium`
**data:** Joi `saveLeadCoveragePremiumRequestSchema` (`controllers/validation/premium_validation.js`, `allowUnknown:true`).

| Field | Type | Req | Notes |
|---|---|---|---|
| Brand, Model, Year, Group, Type, GarageType, CC, Sedan, BodyType, NamedAge | string | no | car and rate keys |
| Doors, Seat, Wg, Usage | number | no | |
| MinSI, MaxSI, Split, SI_1..5, Prem_OD_1..5, Prem_FT_1..5, SI/Prem_TPBI_1..3, SI/Prem_TPPD_1..3, SI/Prem_MV01..03_1..3, SI/Prem_Access_1..3, CCTV, Prem_ACT | number | no | rate row from #7 (checksum-protected) |
| checkSum | string | no (but it is enforced) | must match `premiumCheckSum` |
| SI_Ans, OD_Ans, SI_TPBI_Ans, SI_TPPD_Ans, SI_MV01_Ans, SI_MV02_Ans, SI_MV03_Ans, SI_Access_Ans | number | no | selected option index |
| driver_behavior, driver_behavior_1..5, driver_behavior_cal | number/null | **yes** | |
| driver_behavior_consent_1..5 | bool/null | **yes** | |
| par_citizen_id_1..5, par_driver_license_no_1..5 | string/null | **yes** | if driver N is set, the ID, licence and consent are all required |
| sc_premium_amt_1..5, sc_premium_amt_ans | number/null | **yes** | service-centre (ซ่อมศูนย์) premium |
| prem_version | number | **yes** | |
| Flag_CCTV, Flag_Car_Act, Flag_Access | string | no | `Y`/`N` |
| Email, Mobile, FirstName, LastName, YOB_Driver_1/2 | string | no | Email is lower-cased |
| Access_para_code | string[] | no | stored as JSON |
| Old_Lead_No | string | no | encrypted. Pulls `ref_policy_no` and the renewal dates from `Policy_coverage_premium` / `Policy_Header` |
| affiliate_source/code, referal_source/code | string | no | |

**201:** `data` = `{ Lead_No (encrypted), Type, SI, GarageType, SI_Access, SI_MV01..03, SI_TPBI, SI_TPPD, Premium, CCTV_Discount, Flag_CCTV, Flag_Car_Act, Email, Mobile, FirstName, LastName, Access_para_code, YOB_Driver_1/2, Driver_Discount, driver_behavior_i, par_citizen_id_i, par_driver_license_no_i, par_driver_license_category_i, driver_behavior_consent_i, sc_premium_amt_i, sc_premium_amt_ans, prem_version, driver_behavior, driver_behavior_cal, … }`
**Errors (400):** Joi `error.details`, `CheckSum Fail`, `Driver N requires Citizen id, Driver License and Consent`, `Citizen, License Id and Consent should not have value without driver N`, `Failed to create lead`.
**DB:** R `Policy_coverage_premium` JOIN `Policy_Header`, R `sys_param`, R `Imp_Price_Premium` (car price), W `INSERT Lead_coverage_premium … RETURNING "Lead_No"`. Column names come from the payload keys but are filtered with `/^[A-Za-z_][A-Za-z0-9_]*$/`.

**Lead_No generation — FX-02 (2026-09-24), branch `fix/fx-02-premium` (no contract change):** `INSERT INTO "Lead_coverage_premium" (...) SELECT CASE WHEN MAX("Lead_No") > 0 THEN MAX("Lead_No")+1 ELSE 1 END, ... FROM "Lead_coverage_premium" RETURNING "Lead_No"`. The returned `Lead_No` is this request's own row (before, a separate `SELECT MAX("Lead_No")` after the insert could return another customer's lead under load). On a primary-key clash (`23505`, two concurrent inserts computing the same MAX+1) the insert is retried up to 5 attempts in total with a 20–100 ms random wait (`insertLeadRetryingLeadNo`); after the last attempt, or on any other DB error, the error is thrown to the existing error handling (unchanged).
Note: the `uat-isv` working copy (FX-01 line) instead takes the `Lead_No` default from `insurverse.seq_lead_no` and drops a client-sent `Lead_No`; that variant is not on `fix/fx-02-premium`.

### 9. `fn=checkTariff`
**data:** same fields as #8, plus `Purchase_Date` and optional `promocodePercen`.
**201:** `{ CCTV_Discount, Flag_CCTV, Premium, Flag_Car_Act, Brand, Model, Year, Group, Type, SI, GarageType, SI_*, Email, Mobile, FirstName, LastName, …, Purchase_Date, statusPromoCode, promo_discount_amt, Premium_before_discount, tariff: {…} }`. For `CC=">2000"` the tariff `BasicPremium` is adjusted by +12% (Type 1) or −13% (other types).
**DB:** none (the large commented-out block after it is dead code).

### 10. `fn=updateLeadCoveragePremium`
**data:** Joi `updateLeadCoveragePremiumRequestSchema` (the #8 fields plus `Lead_No` required, encrypted). Also `Promocode`, `ProductGroupType`, `ProductSubType`, and `Referral_Code`/`referal_code`.
**201:** same shape as #8, plus `statusPromoCode`, `promo_discount_amt`, `Premium_before_discount`, `driver_behavior_disc_amt/perc` and `sc_premium_amt`.
**Errors (400):** Joi details, `CheckSum Fail`, `Policy paid` (a `payment.payment_status` of SUCCESS exists), `This promocode has already been used.`, driver-consistency errors, referral errors.
**DB:** R `sec_user` + `fn_loyalty_referal_code`, R `payment`, R/W `Lead_coverage_premium` (`UPDATE … SET <dynamic> WHERE "Lead_No" = <decrypted value interpolated>`), R `Policy_coverage_premium`, R `Imp_Price_Premium`, R `promo_code`, R/W `promo_code_trans` (INSERT booking or UPDATE `promo_book_by`), R `sys_param`.
⚠️ The SET-clause column names come straight from the payload keys without the identifier filter that #8 uses. The `"` character is not blocked by the middleware.

### 11. `fn=getLeadCoveragePremium`
**data:** `{ "Lead_No": "<encrypted>" }`
**201:** the lead row (minus `Total_Amt`), plus `isShowAccess`, `BudgetPremium`, selected `SI*`, `Premium`, `Premium_before_discount`, `promo_discount_amt`, `Email/Mobile/FirstName/LastName`, `Payment_status`, `Promocode`, affiliate/referral fields, `sc_premium_amt`, `Lead_No` (re-encrypted) and `checkSum`.
**DB:** R `Lead_coverage_premium` LEFT JOIN `promo_code_trans`/`promo_code`, R `sys_param`.

### 12. `fn=getLeadCoveragePremiumRenewal`
**data:** `{ "Lead_No": "<encrypted>" }`
**201:** prior-policy premium fields with the OIC re-calculation and a checksum. **400** `ไม่พบข้อมูลกรมธรรม์ต่ออายุ` (renewal policy not found).
**DB:** R `Policy_Header`, `Policy_coverage_premium`, `sec_user`, `Policy_Car_Act_Discount_Premium`, `promo_code_trans`, `promo_code`, `Lead_coverage_premium`.

### 13. `fn=dropLeadBudget`
**data:** a consent-receipt payload containing `dsDataElements: { Email, Name, LastName, MobilePhone }`.
**201:** `{}`
**Outbound:** `POST {Backend_Consent}consent-receipt/payment` (the whole payload), then `POST {Backend_Uam}drop_lead` with `{ email, firstname, lastname, mobilePhone, leadSource:"Budget" }` (errors ignored).

### 14. `fn=saveLeadRenew`
**data:** `{ "policyNo": "…", "flagNoti": false, "flagLead": false }`
**201:** `{ policyNo, premAmt, dutyAmt, vatAmt, totalAmt, isCompulsory, leadNo (encrypted), logNotiId, jsonBody, premAct }`
**Errors (400):** `ERROR CODE [<rtn_error_code>]: <rtn_msg>`, `something went wrong`, `{error:<message>}`.
**DB:** `insurverse.fn_policy_renewal(:policy_no,:flag_noti,:flag_lead)`, which returns `rtn_success, rtn_ncb_tier, rtn_error_code, rtn_msg, rtn_policy_no, rtn_prem_amt, rtn_duty_amt, rtn_vat_amt, rtn_total_amt, rtn_is_compulsory, rtn_lead_no, rtn_log_noti_id, rtn_json_body, rtn_prem_act`.
⚠️ Anyone can create renewal leads for any plain policy number and get back an encrypted lead number and `jsonBody`.

### 15. `fn=checkCrossExpireDate`
**data:** `{ "Car_serial_no": "…" }`
**201:** `{ mc: {chasis_no,start_date,end_date}|null, mv: {chasis_no,policy_no,type,start_date,end_date}|null, skip_act_overlap: bool }` (dates +7h). If nothing is found, or on error, it returns HTTP 200 `{status:false,msg:{}}`.
**DB:** R `Policy_Car_Act_Discount_Premium`, R `Policy_Header` (`Policy_Status='ACT'`), R `policy_overlap_whitelist` (`is_active`, `expired_at`).

### 16. `fn=checkPremCal`
**data:** a full rate row (Joi `premCalRequestSchema`, every field required, `allowUnknown:false`). Top-level `detail: true` adds the list to the response.
**200:** `{ "result": { "no_oic_count": n, "no_oic_list": [...] } }` (this response does not use the standard envelope).

### 17. `fn=updateEditInfoLeadCoveragePremium`
**data:** Joi `updateLeadCoveragePremiumRequestSchema` (`Lead_No` encrypted). This is a partial edit: the payload is merged over the stored lead. Changing a driver's `par_citizen_id_i` clears that driver's name, DOB and occupation fields. The CCTV toggle moves `Other_Disc_perc` by ±5.
**201:** re-calculated lead summary. **400:** Joi details, `Lead_No is required`, `Lead not found`.
**DB:** R/W `Lead_coverage_premium`, R `sys_param`. ⚠️ There is no `payment` paid-status check here (#10 has one).

### 18–21. ACT master lookups (`fn=loadBrand|loadModel|loadModelYear|loadActPremium`)
**data:** `Comp_Code` (all four), plus `Brand` (#19, #20) and `Model` (#20).
**201:** #18 `[{Brand}]`, #19 `[{Model}]`, #20 rows `{Brand,Model,Year,Doors,Seat,Wg,Group,Type,Sedan,BodyType,Start_date,Comp_Code,Premium,Discount,Net_Premium,…}`, #21 `{Premium,Discount,Net_Premium,Stamp,Vat,Total}`.
**DB:** R `Imp_Discount_Premium` (60 s cache).

### 22. `fn=saveLeadActPremium`
**data:** Joi `saveLeadActPremiumRequestSchema` (`controllers/validation/act_validation.js`, `allowUnknown:true`).

| Field | Type | Req | Notes |
|---|---|---|---|
| Comp_Code | string ≤5 | **yes** | ACT company/usage code |
| Model | string 1–65 | **yes** | |
| Car_serial_no | string 1–50 | **yes** | chassis |
| Car_color | string 1–65 | **yes** | |
| Car_license_provice | string/number | **yes** | (the typo is in the schema) |
| first_name (≤120), last_name, citizen_id (≤20) | string | **yes** | |
| Premium, Discount, Net_Premium, Stamp, Vat, Total | string | no | **client-supplied prices** |
| Brand, Year, Start_date, Car_Comp_Code, Car_license_type/no, Flag_Deli, prefix_name, birth_date, address, province/district/subdistrict_id, zipcode, Deli_* | mixed | no | |
| Doors, Seat, Wg, hp (1–9999), engineType (`EV`/`ICE`), email, phone, BodyType, Group, Sedan, Type | mixed | no | |
| Occupation, occupation_code, partner_code/partnerCode, customer_id, Referral_Code/referal_code, affiliate_*, referal_source | string | no | |

**201:** `{ Car_Act_Lead_No: "<encrypted>", … }`
**Errors:** 400 Joi details, `ไม่สามารถใช้ ReferralCode ของตัวเองได้` (can't use your own referral code), `ไม่พบ ReferralCode` (referral code not found), `responseFailureShowModel` on DB error.
**DB:** R `sec_user` + `fn_loyalty_referal_code`, R `sys_param`, W `INSERT Lead_Car_Act_Discount_Premium` (`nextval('insurverse.lead_car_act_lead_no_seq')`, dynamic columns from the payload keys **without an identifier filter**).
⚠️ The prices are not checked against `Imp_Discount_Premium` at insert time.

### 23. `fn=updateLeadActPremium`
**data:** Joi `updateLeadActPremiumRequestSchema` (`Car_Act_Lead_No` required and encrypted; the other fields are the #22 fields, optional).
**Errors (400):** `Car_Act_Lead_No Not found.`, `Price change` (the `Total` differs from the stored lead).
**DB:** R/W `Lead_Car_Act_Discount_Premium`, R `sys_param`.

### 24. `fn=updateReferalCodeLeadActPremium`
**data:** `Car_Act_Lead_No` (encrypted), `email`, and a referral code. **Errors:** `Car_Act_Lead_No required`, `email required`.
**DB:** R `sec_user` + `fn_loyalty_referal_code`, W `UPDATE Lead_Car_Act_Discount_Premium SET referal_code`.

### 25. `fn=getLeadActPremium`
**data:** `{ "Car_Act_Lead_No": "<encrypted>" }`
**201:** ACT lead with PII (`citizen_id`, `birth_date`, name, address, licence) and resolved province/district/subdistrict/colour names. **400** `Lead not found or already paid.`
**DB:** R `Lead_Car_Act_Discount_Premium`, `province`, `district`, `subdistrict`, `mas_cmi_color`.

### 26. `fn=loadATPackage`
**data:** `travelStartdate`, `travelEnddate`, `countryID` (number[]).
**201:** array of `{ packageId, packageName, packageDesc, isDefault, isAddon, countDay, totalAmt, coverageItems[], countryItems[] }`.
**DB:** R `mas_ta_package`, `mas_ta_premium`, `mas_ta_coverage`, `mas_country`.
⚠️ **SQL injection:** `countryID` values are concatenated into `WHERE country_id IN (…)` (`ta.controller.js:287`). The middleware blocks `'`, `;` and `--`, but numeric or boolean payloads still get through.

### 27. `fn=upsertLeadTA`
**data:** `leadTaNo` (encrypted, optional → create), `taPackageId`, `taPackageTotalAmt`, `countryIdArray`, `policyStartdate`, `policyEnddate`, `email`, `ownerDetails[]` (`ownerTitleEn, ownerFirstnameEn, ownerLastnameEn, ownerBirthdate, ownerCardType, ownerCardId, ownerPhone, ownerEmail, ownerAddressEn, ownerCountryId, owner{Province,District,Subdistrict}Id, ownerZipcode, bene*`), `addonPackageDetails[]` (`addonPackageId`), `deliFlag`, `deliDetail{deliAddressTh, deliProvinceId, …}`, `promoCode`, `productGroupType`, `productSubType`, `referalCode`/`referal_code`, `referalSource`, `affiliateCode`, `affiliateSource`, `partner_code`, `vatPer`.
**201:** `{ leadTaNo (encrypted), taPackageTotalAmt, addonPackageDetails, addonPackageTotalAmt, premAmt, dutyAmt, vatAmt, vatPer, discountAmt, discountPer, totalAmt, promoCode, ownerDetails, deli*, policyStartdate, policyEnddate, … }`
**Errors (400):** `leadTaNo is invalid`, `taPackageId not found`, `taPackageTotalAmt is invalid`, `addonPackageId N not found`, `ไม่สามารถใช้ ReferralCode ของตัวเองได้` (can't use your own referral code). If the lead is already paid, or the package or countries changed, it creates a new lead instead of updating.
**DB:** R/W `lead_ta_premium`, W `lead_ta_participant`, R/W/DELETE `lead_ta_package`, R `payment_ta`, R `sys_param`, R `mas_ta_package`/`mas_ta_premium`/`mas_ta_coverage`, R `sec_user` + `fn_loyalty_referal_code`, R `promo_code`, R/W `promo_code_trans`.

### 28. `fn=getLeadTA`
**data:** `{ "leadTaNo": "<encrypted>" }`. **201:** same shape as #27. **400:** `leadTaNo is invalid`, `get lead TA fail`.
**DB:** R `lead_ta_premium`, `lead_ta_participant`, `lead_ta_package`, `sys_param`, `promo_code_trans`, `promo_code`.

### 29. `fn=startCloudRun`
**Body:** `{ "fn":"startCloudRun", "fileBase64":"<xlsx>" }`. The header row is validated against the rate-table columns.
**201:** Cloud Run `jobs.run` response. **400:** `fileBase64 is required to trigger Cloud Run.`, header mismatch.
**Outbound:** GCS upload `run/runfile-new.xlsx`, Cloud Run job `oic-task` (service-account key from `credentials/`).

### 30–32. Master data (`fn=importMasterData | deleteMasterData | importMasterDataAct`)
**Body:** `{ "fn": "...", "fileBase64": "<xlsx>" }` (5-minute timeout, temp file `tempmasterdata.xlsx` in the CWD).
**DB:** #30 `UPDATE Imp_Price_Premium SET is_active=false WHERE "Brand"='${…}' …`, then `INSERT Imp_Price_Premium`. #31 `DELETE FROM Imp_Price_Premium WHERE … '${…}'`. #32 `DELETE FROM "Imp_Discount_Premium"` (**whole table**), then `INSERT`.
**Outbound:** #30 `GET {Backend_Core}update-carmodel-file`. #32 GET to a hard-coded dev/uat/prod API host.
⚠️ Excel cell values are interpolated into SQL. The base64 body gets past the quote filter.

### 33–36. `fn=genjsonFile | genjsonArrayFile | genjsonArrayFileMdd | genjsonZipcodeFile`
These read `zipcode`, `province`, `district`, `subdistrict` (and the `provinceM/districtM/subDistrictM/zipcodeM` variants) and write JSON files to the container CWD. ⚠️ **No response is ever sent**, so the request hangs until the client times out.

### 37. `fn=bypassCarInspection`
**data:** `{ "Policy_No": "…" }`. **DB:** `UPDATE Policy_Header SET "Car_Inspect_Status"='success', "Car_inspect_date"=now() WHERE "Policy_No"=:Policy_No AND status empty`. **201** `{}`.
⚠️ This is an unauthenticated business-control bypass.

### 38. `fn=decode`
**data:** `{ "text": "<hex>" }`. **201:** `{ "text": "<AES-decrypted plain text>" }`. ⚠️ This lets anyone turn an encrypted lead number back into the plain value.

---

## DB Usage (schema `insurverse`)

| Table / function | R/W | Endpoints |
|---|---|---|
| `Imp_Price_Premium` | R / W (UPDATE is_active, INSERT, DELETE) | #7, #8, #10, #30, #31 |
| `Imp_Discount_Premium` | R / W (DELETE all + INSERT) | #7, #18–21, #32 |
| `Lead_coverage_premium` | R/W (INSERT, UPDATE) | #8, #10, #11, #12, #17 |
| `Policy_coverage_premium` | R | #8, #10, #12 |
| `Policy_Header` | R / W (`Car_Inspect_Status`) | #8, #12, #15, #37 |
| `Policy_Car_Act_Discount_Premium` | R | #12, #15 |
| `policy_overlap_whitelist` | R | #15 (DDL: `migrations/create_policy_overlap_whitelist.sql`) |
| `payment` | R (paid check) | #10 |
| `payment_ta` | R | #27 |
| `Lead_Car_Act_Discount_Premium` | R/W | #22–25 |
| `lead_ta_premium`, `lead_ta_participant`, `lead_ta_package` | R/W/DELETE | #27, #28 |
| `mas_ta_package`, `mas_ta_premium`, `mas_ta_coverage`, `mas_country` | R | #26, #27 |
| `promo_code`, `promo_group` | R | #3, #10, #11, #12, #27, #28 |
| `promo_code_trans` | R/W | #10, #11, #12, #27, #28 |
| `sys_param` | R (`purchase/premium/flag_acc_*`, `Policy/oic_version/current_version`, TA VAT/duty) | #7, #8, #10, #11, #17, #22, #23, #27, #28 |
| `sec_user` | R / **DELETE** | #10, #12, #22, #24, #27 / #6 |
| `sec_user_sso` | **DELETE** | #6 |
| `province`, `district`, `subdistrict`, `zipcode`, `mas_cmi_color` | R | #25, #33–36 |
| `provinceM`, `districtM`, `subDistrictM`, `zipcodeM` | R | #35 ⚠️ table names as written in code, existence unverified |
| `fn_comp_to_usage(comp_code)` | fn | #7 |
| `fn_loyalty_referal_code(user_id)` | fn | #10, #22, #24, #27 |
| `fn_policy_renewal(policy_no, flag_noti, flag_lead)` | fn | #14 |
| `fn_promo_promotion_list(group, sub, promocode, email)` | fn | #2, #3 |
| `fn_update_promo_book(user_id, promo_code_id)` | fn | #4 |
| `fn_update_promo_active(policy_type, lead_no)` | fn | #5 |
| sequences `seq_lead_no` (column default), `lead_car_act_lead_no_seq` | seq | #8, #22 |

Migration files in the repo: `migrations/20251006061450-alter-imp-price-premium-table.js` (adds `sc_prem_1..5` to `Imp_Price_Premium`) and `migrations/create_policy_overlap_whitelist.sql`. ⚠️ The column names above come from the code only. They were not checked against a live schema (Rule 6 still applies before any change).

---

## Notes / ⚠️ unverified items

### Security findings (ข้อค้นพบด้านความปลอดภัย)
1. **No authentication anywhere.** The "auth" middleware only checks an `fn` allow-list. JWT code exists but is unused, and CORS is `*`.
2. **Critical: `GET /deleteUser?email=`** deletes `sec_user` and `sec_user_sso` rows, is unauthenticated, and is open to SQL injection (string-interpolated, multi-statement). It is registered before the injection filter.
3. **Destructive admin functions are public:** `importMasterDataAct` (wipes `Imp_Discount_Premium`), `importMasterData`, `deleteMasterData` (rate tables), `startCloudRun` (spends GCP resources and writes GCS), `bypassCarInspection` (skips car inspection on any policy).
4. **`fn=decode`** is a decryption oracle for the AES-encrypted lead numbers, which weakens every "encrypted Lead_No" capability check.
5. **SQL injection:** TA `countryID` concatenation (`ta.controller.js:287`), Excel-driven master-data SQL, dynamic column identifiers in `updateLeadCoveragePremium` and `saveLeadActPremium` (payload keys, and `"` is not filtered), and the interpolated `Lead_No` in the UPDATE WHERE clause. The `;`/`--`/`'` body filter is a blacklist and does not cover these.
6. **Mass assignment:** payload keys become columns in the lead INSERT/UPDATE (for example `Perm_Amt`, `Total_Amt`, `Payment_status` or promo columns could be set by the client if they are not overwritten later). ⚠️ Whether payment re-validates the amount is not verified here (purchase-service #9 re-derives the amount from the lead row, so a tampered stored value would be charged).
7. **ACT price tampering:** `saveLeadActPremium` stores the client-sent `Premium…Total` without checking `Imp_Discount_Premium`.
8. **Hard-coded secrets in source:** JWT keys (`config.service.js`), the session secret (`express.service.js`) and the checksum salt (`utility.service.js`). **GCP service-account key files** (dev/uat/prod) sit in `credentials/`, and `GCP_Oauth_keys.json` / `GCP_Storage_keys.json` sit at the repo root. `.gitignore` does not exclude them. ⚠️ Whether they are tracked in git was not checked (no git commands were allowed). `.env` and `.env.uat` exist locally and are git-ignored.
9. Salesforce credentials are sent in the OAuth URL query string (`salesforce.service.js`). That code is dead.
10. `saveLeadRenew` and `getLeadActPremium` return PII or renewal data with no ownership check. `promotions-book` accepts any `user_id`.

### Functional gaps
- 8 allow-listed `fn` names have no implementation. `checkAMLO` (ACT and TA) can't be reached.
- The `genjson*` functions never respond.
- The success status is **201** for reads too, and auth/injection rejects return **200**.
- `checkTariff` contains a large commented-out block (the old `saveBudgetLeadCoveragePremium`/`checkBudgetPremium`).
- The controllers are singletons that keep `self.sqlCmd`/`sqlParams`/`resData` as instance state. It is unused on the main paths, but ⚠️ it is a concurrency hazard if used.
- ⚠️ The exact dev/uat/prod refresh URL path in `importMasterDataAct` was only partly read.
