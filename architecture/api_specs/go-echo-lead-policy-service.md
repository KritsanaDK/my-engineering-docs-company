# go-echo-lead-policy-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-lead-policy-service` (Go module name `go-echo-backoffice-isv`).
> Generated from route registration code (`router/router.go`) → controllers → services → repositories. No swagger docs are generated (the `/swagger/*` route is commented out in `cmd/main.go:51`).
> Every table/column listed here comes from SQL text in the repositories. None of it was checked against a live schema (⚠️ run a Rule 6 check before any change).

---

## Overview

| Item | Value |
|---|---|
| Purpose (หน้าที่) | Back-office API for the ISV insurance back office (Insurverse). Staff use it to search and view leads and policies for MV (voluntary motor), MC (compulsory motor, พ.ร.บ.), TA (travel), PA (personal accident) and HA (home/condo). It also resends policy and endorsement e-mails, sets the car-inspection status, submits CMI real-time requests, reads the activity/history log, changes customer e-mail/password, gives renewal support (claim info, encrypted lead) and stores renewal 2C2P payment links. |
| Framework | Echo v4, `sqlx` + `lib/pq` (raw SQL, no GORM), `gocloak/v13` (Keycloak), `cloud.google.com/go/storage` (GCS) |
| Port | `HTTP_PORT` (default `8080`) |
| Base path | `/api/v1/backoffice-lead-policy/`. One extra root route: `/healthcheck` |
| DB | PostgreSQL, schema `insurverse`. Connection string built in `utils/db.go` with `sslmode=disable lock_timeout=$DB_LOCK_TIMEOUT` |
| Global middleware | `middleware.CORS()` (default = allow all origins), `middleware.Secure()`, `LoggingMiddleware`, `middleware.BodyDump(RequestBodyDumpMiddleWare)`, which logs **full request and response bodies**, and `RecoveryMiddleware` |
| Startup dependencies | DB, Keycloak admin login, and a GCS client. The app panics if any of them fails |

### Environment variables (names only / เฉพาะชื่อตัวแปร)

| Group | Variables |
|---|---|
| Runtime | `HTTP_PORT`, `TZ` (plus `ENV` in helm, not read by the code) |
| Database | `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME`, `DB_LOCK_TIMEOUT` |
| Keycloak | `KEYCLOAK_HOST`, `KC_USER`, `KC_PASS`, `ISV_BACKOFFICE_REALM`, `ISV_BACKOFFICE_MASTER_REALM` (`ISV_BACKOFFICE_ClIENT` is in helm but not read by the code) |
| GCS | `GCS_CREDENTIAL_PATH`, `GCS_BUCKET`, `CONDITION_LEVEL_3_BUCKET`, `CONDITION_LEVEL_3_OBJECT` |
| Encryption | `KEY_AES256` (32 bytes), `IV_AES256` (16 bytes) |
| Outbound URLs | `CMI_SUBMIT_URL`, `CMI_ENDORSE_URL`, `EMAIL_URL`, `CREATE_ACCOUNT_URL`, `CHANGE_MV_EMAIL_SALESFORCE_URL`, `CHANGE_MC_EMAIL_SALESFORCE_URL` |
| Links embedded in e-mails | `LOGIN_URL`, `CONFIRM_POLICY_URL`, `RESET_PASSWORD_URL` |
| E-mail templates (file paths) | `RESEND_POLICY_TMEPLATE` (sic), `RESEND_POLICY_CLASS3_TEMPLATE` (fallback `/template/resend_policy_class3.html`), `RESEND_ENDORSE_TMEPLATE` (sic), `CMI_EMAIL_TEMPLATE`, `RESUBMIT_CMI_EMAIL_TEMPLATE`, `ENDORSE_CMI_EMAIL_TEMPLATE`, `SEND_RESET_PASSWORD_TEMPLATE`, `CHANGE_EMAIL_ALERT_TEMPLATE`, `CHANGE_EMAIL_ALERT_USER_TEMPLATE`, `CHANGE_EMAIL_ALERT_NEW_USER_TEMPLATE`, `CHANGE_PASSWORD_ALERT_TEMPLATE` |

### External / outbound calls (การเรียกระบบภายนอก)

| Target | Env var | Used by | Client |
|---|---|---|---|
| Keycloak: `DecodeAccessToken`, `LoginAdmin`, `GetRealmRole`, `GetUsersByRoleName` | `KEYCLOAK_HOST` | all authenticated routes (middleware), CMI submit/resubmit/endorse, change email/password, `user/permission` | gocloak |
| CMI (compulsory-insurance web service) submit | `CMI_SUBMIT_URL` | `POST cmi`, `POST cmi/resubmit` (policy) | `utils.HTTP` POST JSON |
| CMI endorse | `CMI_ENDORSE_URL` | `POST cmi/endorse`, `POST cmi/resubmit` (endorse) | `utils.HTTP` POST JSON |
| Notification / e-mail service | `EMAIL_URL` | all e-mail-sending routes | `utils.HTTP` POST `{sender,subject,content,email,cc_email,attach}` |
| Account creation service (internal) | `CREATE_ACCOUNT_URL` | `PUT user/email` when the new e-mail has no `sec_user` row | `utils.HTTP` POST `{email,first_name,last_name,mobile}` |
| Salesforce change-email (MV / MC) | `CHANGE_MV_EMAIL_SALESFORCE_URL`, `CHANGE_MC_EMAIL_SALESFORCE_URL` | `PUT user/email` | `utils.HTTP` POST `{id}` |
| Google Cloud Storage | `GCS_BUCKET`, `CONDITION_LEVEL_3_*`, plus buckets parsed from document URLs | `POST leadpolicy/email`, `POST endorsement/email` | GCS client |
| Public media CDN (hard-coded `https://media.insurverse.co.th/...` emergency-service PDF) | none (hard-coded) | `POST leadpolicy/email` (Class 3 / 2+ new policies) | `http.Get` |

---

## Auth & Middleware

Every route under the base path, except the two health checks, has **route-level** middleware:

1. **`ExtractTokenToGlobalVar(kc)`** (`middlewares/jwt_middleware.go`). It reads the `Authorization` header **as-is**, passes it to `KCClient.DecodeAccessToken(ctx, token, $ISV_BACKOFFICE_REALM)`, and stores `accessToken` and `claim` (jwt.MapClaims) in the context. If decoding fails it returns **401** `Unauthorize`.
   - ⚠️ unverified: the header is passed unchanged. Whether a `Bearer ` prefix is accepted depends on gocloak's `DecodeAccessToken`, which was not tested.
2. **`CheckPermission(kc, []perm)`** (`middlewares/permission_middleware.go`). It reads `claim.realm_access.roles`, logs in to Keycloak as admin (`KC_USER`/`KC_PASS` @ `ISV_BACKOFFICE_MASTER_REALM`), and fetches each realm role in `ISV_BACKOFFICE_REALM`. The request passes if **any** role's **attributes** contain **any** of the required permission keys. Otherwise it returns **401** (not 403). A Keycloak error returns **500**.
   - This makes one admin login plus N role lookups on every request (performance note).

Handlers read `claim["preferred_username"]` as the audit user (`created_by` / `user_add`).

Permission keys (`constants/role.go`):

| Constant | Key |
|---|---|
| VIEW_LEAD_POLICY_PERMISSION | `view_lead_policy` |
| RESEND_POLICY_PERMISSION | `resend_policy` |
| RESEND_ENDORSE_PERMISSION | `resend_endorse` |
| UPDATE_CAR_INSPECTION_STATUS_PERMISSION | `update_car_inspection_status` |
| CMI_REALTIME_PERMISSION | `cmi_realtime` |
| HISTORY_LOG_PERMISSION | `history_log` |
| EDIT_EMAIL_PERMISSION | `edit_email` |
| EDIT_PASSWORD_PERMISSION | `edit_password` |
| RENEWAL_POLICY_PERMISSION | `renew` |
| RENEWAL_POLICY_INFO_PERMISSION | `renew_info` |

Keycloak roles used to build e-mail alert recipient lists: `super_admin`, `manager`, `it_support`.

### Standard response envelope (`models.JsonResponse`)

```json
{ "status": 200, "title": "Success", "description": "Success", "result": { } }
```

Errors use `title: "Unsuccess"`. Common descriptions are `Bad Request`, `Unauthorize`, `Not Found`, `Internal Server Error`, `Service Unavalable` (sic), `Invalid Parameter <field>`, `Missing Parameter <field>`, and raw validator messages (`Key: '...' Error:Field validation for '...' failed on the 'required' tag`). The HTTP status equals `status`.

Paginated `result` (`utils.Paginate`): `{ "page": 1, "limit": 10, "data": [...], "totalRecord": 0 }`. `page` defaults to 1 and `limit` to 10 when they are missing or ≤ 0. A non-numeric `page`/`limit` returns 400 `Invalid Parameter page|limit`.

---

## Endpoint Summary

Base = `/api/v1/backoffice-lead-policy`. Auth column: **JWT** = `ExtractTokenToGlobalVar`; permissions are listed as keys (any-of).

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | controllers/healthcheck_controller.go:30 `CheckServiceStatus` | Root liveness |
| 2 | GET | `{base}/healthcheck/liveness` | none | controllers/healthcheck_controller.go:30 `CheckServiceStatus` | Liveness probe |
| 3 | GET | `{base}/healthcheck/readiness` | none | controllers/healthcheck_controller.go:22 `PingCheckToDB` | Readiness (`select 1`) |
| 4 | GET | `{base}/leadpolicy` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:30 `GetLeadPolicyList` | Search leads/policies (paginated) |
| 5 | GET | `{base}/leadpolicy/product-type` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:63 `GetProductTypeList` | Product-type dropdown |
| 6 | GET | `{base}/leadpolicy/detail` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:71 `GetLeadPolicyDetail` | Lead/policy detail |
| 7 | GET | `{base}/leadpolicy/product/mv` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:86 `GetMVProductDetail` | MV coverage, car, drivers, inspection images |
| 8 | GET | `{base}/leadpolicy/product/mc` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:100 `GetMCProductDetail` | MC (พ.ร.บ.) car + fixed benefits |
| 9 | GET | `{base}/leadpolicy/product/travel` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:114 `GetTravelProductDetail` | TA destination/objective/benefit |
| 10 | GET | `{base}/leadpolicy/product/home-condo` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:129 `GetHomeCondoProductDetail` | Home/condo detail |
| 11 | GET | `{base}/leadpolicy/product/personal-accident` | JWT + `view_lead_policy` | controllers/lead_policy_controller.go:143 `GetPersonalAccidentProductDetail` | PA benefits |
| 12 | POST | `{base}/leadpolicy/email` | JWT + `resend_policy` | controllers/lead_policy_controller.go:157 `ResendPolicyEmail` | Resend e-policy/receipt e-mail |
| 13 | PUT | `{base}/leadpolicy/inspect` | JWT + `update_car_inspection_status` | controllers/lead_policy_controller.go:182 `UpdateCarInspectionStatus` | Set/clear car inspection status |
| 14 | PUT | `{base}/leadpolicy/inspect/undo` | JWT + `update_car_inspection_status` | controllers/lead_policy_controller.go:202 `UndoCarInspectionStatus` | Restore previous inspection |
| 15 | POST | `{base}/leadpolicy/claim` | JWT + `renew` \| `renew_info` | controllers/lead_policy_controller.go:223 `GetClaimInfo` | Claim history by policy |
| 16 | POST | `{base}/leadpolicy/encrypted` | JWT + `renew` \| `renew_info` | controllers/lead_policy_controller.go:240 `GetEncryptedLead` | Renewal data + AES-256 encrypted lead no |
| 17 | GET | `{base}/cmi` | JWT + `view_lead_policy` | controllers/cmi_controller.go:28 `GetCMIList` | CMI real-time log list |
| 18 | POST | `{base}/cmi` | JWT + `cmi_realtime` | controllers/cmi_controller.go:106 `SubmitToCMI` | Submit policy to CMI |
| 19 | POST | `{base}/cmi/resubmit` | JWT + `cmi_realtime` | controllers/cmi_controller.go:86 `ReSubmitToCMI` | Resubmit policy/endorsement to CMI |
| 20 | POST | `{base}/cmi/endorse` | JWT + `cmi_realtime` | controllers/cmi_controller.go:126 `EndorseToCMI` | Submit endorsement to CMI |
| 21 | GET | `{base}/cmi/resubmit` | JWT + `cmi_realtime` | controllers/cmi_controller.go:59 `GetResubmitCMIData` | Preview CMI payload |
| 22 | GET | `{base}/endorsement` | JWT + `view_lead_policy` | controllers/endorsement_controller.go:28 `GetEndorsementList` | Endorsements of a policy |
| 23 | GET | `{base}/endorsement/endorsement-type` | JWT + `view_lead_policy` | controllers/endorsement_controller.go:62 `GetEndorsementTypeList` | Endorse-type dropdown |
| 24 | POST | `{base}/endorsement/email` | JWT + `resend_endorse` | controllers/endorsement_controller.go:70 `SendEndorseEmail` | Resend e-endorse e-mail |
| 25 | GET | `{base}/history-log` | JWT + `history_log` \| `view_lead_policy` | controllers/history_log_controller.go:27 `GetHistoryLogList` | Activity log (paginated) |
| 26 | GET | `{base}/history-log/log-type` | JWT + `history_log` \| `view_lead_policy` | controllers/history_log_controller.go:60 `GetLogTypeList` | Activity types |
| 27 | POST | `{base}/history-log/view-detail` | JWT + `history_log` \| `view_lead_policy` | controllers/history_log_controller.go:68 `InsertViewDetail` | Audit "viewed detail" |
| 28 | GET | `{base}/user/email/policy` | JWT + `edit_email` | controllers/user_controller.go:28 `CountPolicyFromEmail` | Count leads/policies per e-mail |
| 29 | PUT | `{base}/user/email` | JWT + `edit_email` | controllers/user_controller.go:45 `ChangeEmail` | Change customer e-mail |
| 30 | PUT | `{base}/user/password` | JWT + `edit_password` | controllers/user_controller.go:112 `ChangePassword` | Set customer password |
| 31 | POST | `{base}/user/password/email` | JWT + `edit_password` | controllers/user_controller.go:65 `SendEmailResetPassword` | E-mail reset-password link |
| 32 | POST | `{base}/user/password/link` | JWT + `edit_password` | controllers/user_controller.go:85 `GetLinkResetPassword` | Generate reset-password link |
| 33 | GET | `{base}/user/permission` | JWT only | controllers/user_controller.go:103 `GetPermissionFromKeycloak` | Caller's permission keys |
| 34 | POST | `{base}/renewal-payment` | JWT + `renew` | controllers/renewal_payment_controller.go:26 `CreateRenewalPayment` | Upsert renewal 2C2P link |
| 35 | GET | `{base}/renewal-payment` | JWT + `renew` | controllers/renewal_payment_controller.go:51 `GetRenewalPayment` | Get renewal 2C2P link |

**Total: 35 endpoints** (34 under the group plus `/healthcheck`). There is 1 `Group` registration. Route registrations are at `router/router.go:15-63`.

---

## Endpoints

### Health (สุขภาพระบบ)

#### 1–2. `GET /healthcheck`, `GET {base}/healthcheck/liveness`
- Purpose: static liveness. No auth, no DB.
- Response 200: `{"status":200,"title":"Success","description":"Success","result":null}`

#### 3. `GET {base}/healthcheck/readiness`
- Purpose: DB ping (`select 1`).
- 200 on success. **503** `Service Unavalable` when the DB query fails.
- DB: `select 1` only.

---

### Lead Policy (ลีด/กรมธรรม์)

#### 4. `GET {base}/leadpolicy`: search leads/policies
Query params:

| Name | Type | Required | Validation / notes |
|---|---|---|---|
| `keyword` | string | no | `max=100`. ILIKE `%kw%` on policy_no, insured_fullname, insured_card_id, invoice_no, insured_email, phone (dashes stripped), car_license_no |
| `productType` | string | no | exact match on `product` |
| `page` | int | no | default 1 |
| `limit` | int | no | default 10 |

Response 200 (`result` = Paginate of `LeadPolicyDBModel`; nulls → `"-"`):
```json
{
  "status": 200, "title": "Success", "description": "Success",
  "result": {
    "page": 1, "limit": 10, "totalRecord": 1,
    "data": [{
      "leadNo": "MVL00000001", "policyStatus": "Active", "product": "Motor", "plan": "ชั้น 1",
      "insuredName": "กฤษณะ วัฒนายนนต์", "insuredEmail": "kritsana.w.os@horixon-t8.com",
      "phoneNumber": "0628696603", "policyNo": "MV0000000001", "refPolicyNo": "-",
      "invoiceNo": "INV0000001", "carLicenseNo": "1กก 1234", "paymentStatus": "SUCCESS",
      "leadDate": "01/01/2026 10:00:00", "issueDate": "01/01/2026 10:05:00"
    }]
  }
}
```
Errors: 400 (invalid page/limit, keyword > 100), 401, 500.
DB: view `insurverse.v_lead_policy_product` (data and count queries run in parallel goroutines).

#### 5. `GET {base}/leadpolicy/product-type`
Response: `result: [{"productNameEn": "Motor"}]`. DB: `insurverse.mas_product_type` (order by id). Errors: 401, 500.

#### 6. `GET {base}/leadpolicy/detail`

| Query | Type | Required | Notes |
|---|---|---|---|
| `leadNo` | string | yes | 400 `Missing Parameter leadNo` |
| `policyNo` | string | no | matched as `coalesce(policy_no,'') = $2`. **An empty value matches only leads with no policy** |

Response 200:
```json
{ "result": {
  "leadPolicyInformation": {"leadDate":"01/01/2026 10:00:00","leadNo":"MVL00000001","issueDate":"-","policyStatus":"-","product":"Motor","policyNo":"MV0000000001","plan":"ชั้น 1","channel":"-","startDate":"-","endDate":"-","promotionCode":"-","policyDocument":"-","receiptDocument":"-"},
  "insuredInformation": {"insuredFullname":"กฤษณะ วัฒนายนนต์","insuredIDCard":"1111111111119","insuredBirthdate":"-","insuredPhoneNumber":"0628696603","deliveryOption":"-","email":"kritsana.w.os@horixon-t8.com","contactAddress":"1 หมู่ 1","deliveryAddress":"1 หมู่ 1"},
  "customerInformation": {"customerName":"-","customerPhone":"-"},
  "beneficiaryInformation": {"beneficiaryType":"-","beneficiaryName":"-","relationship":"-","contact":"-"},
  "paymentInformation": {"paymentStatus":"-","paymentRemark":"-","method":"-","bank":"-","premium":"-","vat":"-","duty":"-","discount":"-","totalAmount":"-","invoiceNumber":"-","taxInvoiceNumber":"-","taxBookNumber":"-","taxDeduction":"-","paymentDate":"-","quotationNo":"-","twoCtwoPEmail":"-","cardNumber":"-","monthlyPayment":"-","installmentPeriod":"-"}
}}
```
Errors: 400 missing leadNo; **404** `Invalid Parameter leadNo or policyNo` when no row matches; 500.
DB: `v_lead_policy_product` (LIMIT 1).

#### 7. `GET {base}/leadpolicy/product/mv`
Query: `leadNo` (required, format `MVL` + 8-digit zero-padded `Lead_No`).
Response 200 (`MVProductCoverage`):
```json
{ "result": {
  "benefitCoverage": [{"type":"ทุนประกัน","sumInsured":"500,000.00","premium":"15,000.00"}],
  "carInformation": {"carLicenseNo":"1กก 1234","province":"สระบุรี","chassisNo":"TESTCHASSIS0001","cc":"1500","licenseType":"-","motorColor":"ขาว","carBrand":"TOYOTA","carModel":"YARIS","carYear":"2024","carWeight":"-","numberOfSeat":"5","flagCamera":"Yes","accessories":"-"},
  "driverInformation": [{"driverLicenseNumber":"-","driverName":"-","driverBirthdate":"-"}],
  "inspection": {"inspectStatus":"success","currentImage":["gs://..."],"historyImage":[],"currentAccessoryImage":[],"historyAccessoryImage":[],"currentCctvImage":[],"historyCctvImage":[]}
}}
```
`benefitCoverage` has 9 fixed rows: sum insured, fire and flood, TPBI per person, TPBI per time (constant), TPPD, MV01, MV02, MV03 and accessories.
Errors: 400 missing leadNo; 500. Unknown leads return 200 with empty sections.
DB (read): `Policy_coverage_premium`, `Policy_Header`, `Lead_coverage_premium`, `mas_cmi_province`, `mas_cmi_color`, `Policy_Regis_Evident` (current: `Policy_No = x`; history: `Policy_No LIKE x%_backup`; sectors car_front/back/left/right/endorse, skirt/wheel/pipe/carry_boy/gas, cctv).

#### 8. `GET {base}/leadpolicy/product/mc`
Query: `leadNo` (required; matches `MCL`+8 digits on `Lead_Car_Act_Discount_Premium` **or** `MVL`+8 digits on `Lead_coverage_premium`).
Response 200:
```json
{ "result": {
  "benefitCoverage": [
    {"description":"ความเสียหายต่อร่างกายหรืออนามัย (THB/Person)","value":"80,000.00"},
    {"description":"การเสียชีวิต หรือทุพพลภาพอย่างถาวรสิ้นเชิง (THB/Person)","value":"500,000.00"},
    {"description":"จำนวนเงินคุ้มครองสูงสุดรวมกันไม่เกิน (THB/Accident)","value":"5,000,000.00"}],
  "carInformation": {"carLicenseNo":"1กก 1234","province":"สระบุรี","chassisNo":"TESTCHASSIS0001","cc":"1500","licenseType":"-","motorColor":"ขาว","carBrand":"TOYOTA","carModel":"YARIS","carYear":"2024","carWeight":"-","numberOfSeat":"5","hp":"-"}
}}
```
Benefits are constants. The max coverage is `10,000,000.00` when `Car_Comp_Code = 1.20A` (van).
DB: `Policy_Car_Act_Discount_Premium`, `Lead_Car_Act_Discount_Premium`, `Lead_coverage_premium`, `mas_cmi_province`, `mas_cmi_color`.
Errors: 400, 500. ⚠️ If `Car_Comp_Code` is NULL, `*carInfo[0].CarCompCode` is dereferenced after the nil→"-" replace, so it is probably safe but unverified.

#### 9. `GET {base}/leadpolicy/product/travel`
Query: `leadNo` (required, `TAL`+8 digits), `policyNo` (optional; required when the lead has more than 1 participant policy).
Response: `{"result":{"destination":"ญี่ปุ่น","objective":"Travel / ท่องเที่ยว","benefitCoverage":[{"description":"...","value":"1,000,000.00"}]}}`
Errors: 400 `Missing Parameter policyNo` (multiple rows); 404 `Invalid Parameter leadNo & policyNo`; 500.
DB: `lead_ta_participant`, `lead_ta_premium`, `mas_country`, `mas_ta_description` (type `travel_reason`), `mas_ta_coverage` (ta_coverage_id = 1 only), `policy_ta_coverage`.

#### 10. `GET {base}/leadpolicy/product/home-condo`
Query: `leadNo` (required, `HAL`+8 digits).
Response: `{"result":{"type":"บ้าน","address":"1 หมู่ 1 ปากเพรียว เมืองสระบุรี สระบุรี 18110","flagOwner":true,"benefitCoverage":[{"description":"สิ่งปลูกสร้าง (ไม่รวมรากฐาน)","value":"1,000,000.00"},{"description":"ทรัพย์สินภายในสิ่งปลูกสร้าง","value":"ไม่คุ้มครอง"}]}}`
Errors: 400; 404 `Invalid Parameter leadNo`; 500.
DB: `lead_home_premium`, `mas_home_resident_type`, `lead_home_coverage`, `mas_home_building_type`, `subdistrict`, `district`, `province`.

#### 11. `GET {base}/leadpolicy/product/personal-accident`
Query: `leadNo` (required, `PAL`+8 digits).
Response: `{"result":{"benefitCoverage":[{"description":"<coverage_name_th>","value":"100,000.00"}]}}`. Uncovered rows show `"ไม่คุ้มครอง"`.
Errors: 400; 404 (only if `mas_pa_coverage` is empty, because of the LEFT JOIN from the master table: ⚠️ an unknown leadNo still returns 200 with all rows "ไม่คุ้มครอง"); 500.
DB: `mas_pa_coverage`, `lead_pa_coverage`.

#### 12. `POST {base}/leadpolicy/email`: resend e-policy / receipt
Request body:
```json
{ "leadNo": "MVL00000001", "policyNo": "MV0000000001", "email": "kritsana.w.os@horixon-t8.com",
  "policy": true, "receipt": true, "remark": "resend by staff" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| leadNo | string | yes | `required` |
| policyNo | string | no | empty = any policy under the lead (first row used) |
| email | string | yes | `required` (no email format check) |
| policy | bool | cond. | `policy` or `receipt` must be true, else 400 `Policy or receipt must be selected` |
| receipt | bool | cond. | see above |
| remark | string | no | stored in the activity log |
| username | string | ignored | overwritten from the JWT `preferred_username` |

Flow:
1. Load file info from `v_lead_policy_product` ⨝ `Policy_Header`.
2. Download the policy/receipt PDFs from GCS (bucket and object parsed from the document URL path segments 4/5).
3. For MV policies with `Type = 3` paid on or after 2026-02-17, attach the Class 3 conditions PDF (`CONDITION_LEVEL_3_BUCKET/OBJECT`).
4. For non-renewal `ชั้น 3` (paid ≥ 2026-02-17) or `ชั้น 2+` (paid ≥ 2026-03-26) policies, attach the emergency-service PDF from the hard-coded media URL.
5. Insert `Policy_email_confirm` if no unconfirmed row exists.
6. Build the confirm link `CONFIRM_POLICY_URL` + type suffix + `&confirmNo=<AES-ECB(policyNo)>`.
7. Send the e-mail through `EMAIL_URL`, using the class-3 template for non-renew `ชั้น 3`/`ชั้น 2+` plans.
8. Insert an activity log (type 3 `EMAIL_CUSTOMER_POLICY`, detail `mail_to="..."`).

Response: 200 `Success` (no result).
Errors: 400 bind/validate or `Invalid Parameter leadNo` (no file row); 500 on GCS/DB/e-mail failure or a non-200 status from the e-mail service. The log is still written with `fail: <title>`.
DB: read `v_lead_policy_product`, `Policy_Header`. Write `Policy_email_confirm`, `log_activity`, `log_activity_ref`.
Outbound: GCS, `EMAIL_URL`, media CDN.
⚠️ `utils.EncryptAES` requires a 16-byte input (policy numbers must be exactly 16 chars), otherwise it returns 500. It uses a hard-coded key in `utils/hash.go`, which is a security note; the value is not reproduced here.

#### 13. `PUT {base}/leadpolicy/inspect`: set/clear car inspection
```json
{ "status": true, "policyNo": "MV0000000001", "remark": "inspected" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| status | *bool | yes | `required`. ⚠️ With go-playground `required` on `*bool`, `false` passes because the pointer is non-nil |
| policyNo | string | yes | `required` |
| remark | string | no | |

- `status=true`: `UPDATE Policy_Header SET Car_Inspect_Status='success', Car_inspect_date=now()` where the status is null or empty.
- `status=false`: read `Car_inspect_date`, clear the status and date (in a transaction), then rename `Policy_Regis_Evident.Policy_No` to `<policyNo>_dd_mm_yyyy_hh_mm_ss_backup` and commit.
- Writes an activity log (type 10 `EDIT_CAR_INSPECTION_STATUS`, detail `from="No", to="Yes"` or the reverse; on the clear path it also stores `car_inspect_date`).

Response 200 `Success`. Errors: 400, 500.
DB: `Policy_Header` (R/W), `Policy_Regis_Evident` (W), `log_activity`, `log_activity_ref` (W).

#### 14. `PUT {base}/leadpolicy/inspect/undo`
```json
{ "policyNo": "MV0000000001", "remark": "undo" }
```
Validation: `policyNo` required.
Flow:
1. If the policy currently has `Car_Inspect_Status='success'`, return 400 `Cannot undo car inspection for this policy`.
2. Otherwise, in one transaction, set status `success` with the date = `max(log_activity.car_inspect_date)` for the ref.
3. Rename the `_backup` evidence rows back to the policy no.
4. Write an activity log (type 10, detail `from="Yes", to="No"`, as coded).

DB: `Policy_Header`, `log_activity`, `log_activity_ref`, `Policy_Regis_Evident`.
Errors: 400, 500.

#### 15. `POST {base}/leadpolicy/claim`: claim info (renewal)
```json
{ "policy_no": "MV0000000001" }
```
| Field | Type | Required |
|---|---|---|
| policy_no | string | yes (`required`) |

Response 200 (NULL → "-"):
```json
{ "result": [{ "ref_claim_no": "CLM0001", "accident_date": "01/01/2026", "accident_type": "-", "accident_detail": "-", "total_loss_reserve": "0", "responsibility": "-", "status": "Closed", "acc_policy_no": "MV0000000001" }] }
```
DB: `insurverse.sf_claim` LEFT JOIN `insurverse.sf_claim_coverage` (`where acc_policy_no = $1 order by accident_date`). Errors: 400, 500.

#### 16. `POST {base}/leadpolicy/encrypted`: renewal lead data + encrypted lead no
```json
{ "policy_no": "MV0000000001", "car_act_no": "" }
```
| Field | Type | Required | Notes |
|---|---|---|---|
| policy_no | string | one of | tried first |
| car_act_no | string | one of | used when policy_no is empty |

Response: **not wrapped in the envelope**. The handler returns a raw `EncryptedLeadResult`:
```json
{ "car_license_no": "1กก 1234", "lead_no": "1", "car_act_lead_no": "", "car_act_no": "MC0000000001",
  "mv_prem": "15000.00", "prem_act": "645.21", "total_amt": "15645.21", "province": "สระบุรี",
  "encrypted_lead_no": "<hex AES-256-CBC>", "policy_startdate": "2025-01-01", "policy_enddate": "2026-01-01",
  "act_startdate": "2025-01-01", "act_enddate": "2026-01-01", "act_bundled": true,
  "promo_code_prefix": "", "discount": "", "promo_prem_type": "", "promo_prem_value": "", "old_si": "500,000.00" }
```
Logic:
- **By policy.** Reads `Policy_Header` ⨝ `Policy_coverage_premium` ⨝ `Lead_coverage_premium` ⨝ `province` ⨝ `v_lead_policy_product` ⨝ `promo_code`. `Prem_ACT` counts only when `Flag_Car_Act='Y'`.
  - If `Policy_Header.Car_Act_No` is set, `act_bundled=true` and the ACT dates come from `Policy_Car_Act_Discount_Premium` (latest by End_date). If that lookup fails, the service falls back to the by-car-act query and recomputes `total_amt`.
  - Otherwise it looks up an active paid ACT by `Car_serial_no` (display only; `act_bundled=false`).
- **By car act.** Reads `Policy_Car_Act_Discount_Premium` ⨝ `province` ⨝ `v_lead_policy_product` ⨝ `promo_code`.
- `encrypted_lead_no` = AES-256-CBC (`KEY_AES256`/`IV_AES256`, hex) of `lead_no`, or of `car_act_lead_no` when `lead_no` is empty.

Errors:
- 400 `{"error":"At least one of policy_no or car_act_no is required"}` (non-envelope)
- 400 `{"error":"Lead not found"}`
- 404 envelope on `sql.ErrNoRows`
- 500 (including AES key/IV length errors, and `lead not found` from the car-act query)

Stored functions: none. `fn_lead_to_car_act` is referenced only in a code comment (the chassis-match rule mirrors it) and is **not called**.

---

### CMI (ส่งข้อมูล พ.ร.บ. เข้าระบบ CMI)

#### 17. `GET {base}/cmi`: CMI log list
| Query | Type | Required | Validation |
|---|---|---|---|
| policyNo | string | yes | `required`. Matches `request_body.policyNumber` or `Policy_Car_Act_Discount_Premium.Policy_No` |
| keyword | string | no | `max=100`. ILIKE on request/response JSON and remark |
| page, limit | int | no | pagination |

Response `data[]` (`CMIModel`):
```json
{ "id": 1, "type": "Policy", "createdDate": "01/01/2026 10:00:00", "requestBody": {"policyNumber":"MC0000000001"}, "responseBody": {"Result":{"Result":"SUCCESS"}}, "status": "Success", "remark": "-", "policyNo": "MC0000000001", "referenceNo": "", "receiveNo": "", "endorseNo": "" }
```
DB: `log_cmi_realtime` LEFT JOIN `Policy_Car_Act_Discount_Premium`. Errors: 400, 500 (also when a stored body is not valid JSON, e.g. `'-'` for NULL).

#### 18. `POST {base}/cmi`: submit policy to CMI
```json
{ "policyNo": "MC0000000001", "remark": "manual submit" }
```
Validation: `policyNo` required. It matches `Car_Act_No` **or** `Policy_No`.
Flow:
1. Build `CMIWSRequest` from `Policy_Car_Act_Discount_Premium` ⨝ `company_detail` ⨝ `mas_cmi_province` ⨝ `mas_cmi_brand_model` ⨝ `mas_cmi_color`.
2. POST to `CMI_SUBMIT_URL` and insert `log_cmi_realtime`.
3. If the response has `Result.ReferenceNumber`/`ReceiveNumber`, update `Policy_Car_Act_Discount_Premium.cmi_reference_number/cmi_receive_number`. If it has Endorse numbers, update `cmi_endorse_*`.
4. Write an activity log (type 7 `CMI_SUBMIT`; response `Fail` if `Result.Errors` is non-empty).
5. E-mail the Keycloak `manager` + `it_support` users (`CMI_EMAIL_TEMPLATE`).

Response 200: `result` = the raw CMI JSON response.
Errors: 400 validate; 404 `Invalid Parameter policyNo`; 500.
⚠️ Type assertions on `resp["Result"]...` panic (recovered → 500 via `RecoveryMiddleware`, unverified format) if CMI returns an unexpected shape.

CMI outbound payload (JSON keys): `companyCode, policyNumber, contractDt, effectiveDt, endDt, vehicleTypeCode, registeredProvinceCode, plateNumber, chassisVINNumber, insuredUniqueID, insuredName, insuredSurname, country ("THA"), agentBrokerLicenseNumber, vehicleBrand, vehicleModel, vehicleColor[, ReferenceNumber, ReceiveNumber, EndorseEffectiveDt, EndorseRefNumber, EndorseFlag]`.

#### 19. `POST {base}/cmi/resubmit`
```json
{ "id": 1, "policyNo": "MC0000000001", "endorseNo": "", "remark": "retry", "referenceNo": "", "receiveNo": "" }
```
| Field | Type | Required | Notes |
|---|---|---|---|
| id | int | yes | `required` (non-zero). The original `log_cmi_realtime.id` |
| policyNo | string | yes | `required` |
| endorseNo | string | no | when set, uses the endorse payload and `CMI_ENDORSE_URL` |
| remark | string | no | |
| referenceNo / receiveNo | string | no | override values for the endorse payload. Both must end up non-empty, else 400 `main policy must be submitted to CMI first ...` |

Flow: same as #18, plus `UPDATE log_cmi_realtime SET remark = <response JSON> WHERE id = :id`. The activity log type is 6 `CMI_RESUBMIT` with detail `cmi_record_id=<id>,new_cmi_record_id=<newId>`. The e-mail template is `RESUBMIT_CMI_EMAIL_TEMPLATE`.
DB: `Policy_Car_Act_Discount_Premium`, `Policy_endorse_detail`, `company_detail`, `mas_cmi_*`, `log_cmi_realtime` (R/W), `log_activity(_ref)`.
Errors: 400, 404, 500.

#### 20. `POST {base}/cmi/endorse`
```json
{ "endorseNo": "SFPOLICYID0001", "remark": "endorse" }
```
Validation: **none** (the handler does not call the validator). An empty `endorseNo` returns 404 `Invalid Parameter endorseNo`.
The endorse number is `Policy_endorse_detail.SF_Policy_id`. Flow is like #18 using `CMI_ENDORSE_URL` and template `ENDORSE_CMI_EMAIL_TEMPLATE`. `EndorseFlag` = `X` when `doc_type='v0_11'`, else `U`. The main policy must already have `cmi_reference_number`/`cmi_receive_number`, else 400.
The activity log type is 7 (`CMI_SUBMIT`).

#### 21. `GET {base}/cmi/resubmit`: preview CMI payload
| Query | Required | Notes |
|---|---|---|
| type | yes | `Policy` or `Endorsement`, else 400 `Invalid Parameter type` |
| policyNo | when type=Policy | |
| endorseNo | when type=Endorsement | |

Response: `result` = a `CMIWSRequest` object (see the keys above).
Errors: 400 (no row → 400 `Invalid Parameter policyNo|endorseNo`), 500.

---

### Endorsement (สลักหลัง)

#### 22. `GET {base}/endorsement`
Query: `policyNo` (required), `keyword` (max 100; ILIKE on date/endorse_no/invoice/tax invoice/book), `endorseType` (exact), `page`, `limit`.
Response `data[]`: `{"endorseDate":"01/01/2026 10:00:00","endorseNo":"E0001","endorseType":"-","invoiceNo":"-","taxInvoiceNo":"-","taxBookNo":"-","urlInvoice":null,"urlDocument":null}`
DB: view `v_endorse_product`. Errors: 400, 500.

#### 23. `GET {base}/endorsement/endorsement-type`
Response: `result: [{"endorseNameEn":"..."}]` (distinct `endorse_type` from `v_endorse_product`).

#### 24. `POST {base}/endorsement/email`
```json
{ "endorseNo": "E0001", "email": "kritsana.w.os@horixon-t8.com", "remark": "resend" }
```
| Field | Required |
|---|---|
| endorseNo | yes |
| email | yes |
| remark | no (⚠️ accepted but **not** written to the activity log) |

Flow:
1. Read `v_endorse_product`.
2. Download the document from the default `GCS_BUCKET` (object = URL path segment 5).
3. Send the e-mail with template `RESEND_ENDORSE_TMEPLATE`.
4. Write an activity log (type 4 `EMAIL_CUSTOMER_ENDORSE`).

Errors: 400 `Invalid Parameter endorseNo` / `Endorse document does not exist`; 500.

---

### History Log (ประวัติการทำรายการ)

#### 25. `GET {base}/history-log`
Query:
- `keyword` (max 100; ILIKE on reference_no/created_by/detail/remark)
- `logType` (matches the `activity_type.activity_type` text)
- `policyNo` or, if that is absent, `leadNo` (must be in the aggregated reference list)
- `page`, `limit`

Response `data[]`: `{"referenceNo":"MV0000000001, MVL00000001","logType":"...","detail":"mail_to=\"...\"","remark":"-","response":"Success","createdDate":"01/01/2026 10:00:00","createdBy":"staff.user"}`
DB: `log_activity`, `log_activity_ref`, `activity_type`.
⚠️ The `detail` of change-email/change-password logs contains `old_password="<bcrypt hash>"`, so this endpoint exposes old password hashes to anyone with `view_lead_policy`.

#### 26. `GET {base}/history-log/log-type`
Response: `result: [{"id":"1","logType":"..."}]`. DB: `activity_type`.

#### 27. `POST {base}/history-log/view-detail`
```json
{ "refNo": "MVL00000001" }
```
`refNo` is required and must exist as `policy_no` or `lead_no` in `v_lead_policy_product` (else 400 `Invalid Parameter refNO`). The endpoint inserts an activity log of type 5 `VIEW_LEAD_POLICY`.
DB: `v_lead_policy_product` (R), `log_activity`, `log_activity_ref` (W).

---

### User (ผู้ใช้/ลูกค้า)

#### 28. `GET {base}/user/email/policy`
| Query | Required |
|---|---|
| currentEmail | yes |
| newEmail | yes |

Response: two rows (`status` = `current` / `new`, UNION order not guaranteed):
```json
{ "result": [{ "status": "current", "name": "กฤษณะ วัฒนายนนต์", "email": "kritsana.w.os@horixon-t8.com",
  "leadMVCount": 0, "mvCount": 1, "leadMCCount": 0, "mcCount": 1, "leadTravelCount": 0, "travelCount": 0,
  "leadPersonalAccidentCount": 0, "personalAccidentCount": 0, "leadHomeCount": 0, "homeCount": 0 }] }
```
Lead counts cover only paid leads (`payment_callback.callback_type='SUCCESS'`) that have no policy yet.
DB: `sec_user`, `Lead_coverage_premium`, `Policy_coverage_premium`, `Policy_Header`, `payment`, `payment_callback`, `Lead_Car_Act_Discount_Premium`, `Policy_Car_Act_Discount_Premium`, `payment_act`, `lead_ta_premium`, `policy_ta_premium`, `payment_ta`, `lead_pa_premium`, `policy_pa_premium`, `payment_transaction`, `lead_home_premium`, `policy_home_premium`.

#### 29. `PUT {base}/user/email`: change customer e-mail
```json
{ "leadNo": "MVL00000001", "policyNo": "MV0000000001", "currentEmail": "old.test@example.com", "newEmail": "kritsana.w.os@horixon-t8.com", "isMigrate": false }
```
| Field | Type | Required | Notes |
|---|---|---|---|
| leadNo | string | yes | its prefix (`MVL`/`MCL`/`TAL`/`PAL`/`HAL`) picks the lead table |
| policyNo | string | no | its prefix (`MV`/`MC`/`TA`/`PA`/`HI`) picks the policy table |
| currentEmail | string | yes | |
| newEmail | string | yes | |
| isMigrate | bool | no | true = move **all** leads and policies of every product from current to new e-mail |

Flow:
1. Check whether `sec_user` exists for `newEmail`. If not, POST to `CREATE_ACCOUNT_URL`.
2. In a transaction:
   - invalidate old `reset_password` rows and insert a new reset token;
   - `UPDATE ... SET email = lower(new)` on the lead/policy tables, returning ids;
   - commit.
3. `sec_user.hashpassword = ''` for the new e-mail (the old hash is kept in the log detail).
4. POST each MV/MC policy id to the Salesforce change-email URL.
5. Write an activity log (type 1 `EDIT_EMAIL`, or 2 `EDIT_EMAIL_MIGRATE`).
6. E-mail both the current and new address (user/new-user template, including the reset link from `RESET_PASSWORD_URL`).
7. E-mail an alert to `super_admin`/`manager`/`it_support`.

Response 200 `Success`. Errors: 400; 500 on any failure (the error text is not returned).
DB (W): `Lead_coverage_premium`, `Lead_Car_Act_Discount_Premium`, `lead_ta_premium`, `lead_pa_premium`, `lead_home_premium`, `Policy_Header`, `Policy_Car_Act_Discount_Premium`, `policy_ta_premium`, `policy_pa_premium`, `policy_home_premium`, `sec_user`, `reset_password`, `log_activity`, `log_activity_ref`.
Outbound: `CREATE_ACCOUNT_URL`, `CHANGE_MV_EMAIL_SALESFORCE_URL`, `CHANGE_MC_EMAIL_SALESFORCE_URL`, `EMAIL_URL`, Keycloak.
⚠️ If `currentEmail` has no `sec_user` row and `newEmail` is new, `currentUserDetail[0]` panics (index out of range).

#### 30. `PUT {base}/user/password`: set customer password
```json
{ "refNo": "MVL00000001", "email": "kritsana.w.os@horixon-t8.com", "newPassword": "Test@1234" }
```
| Field | Required | Validation |
|---|---|---|
| refNo | yes | reference used in the activity log |
| email | yes | must exist in `sec_user`, else 500 `Invalid Parameter email` (returned as 500) |
| newPassword | yes | `min=8,max=60`, plus `ValidatePassword`: letter + digit + punctuation/symbol, else 400 with the password-rule message |

Flow: bcrypt(password + fixed salt suffix) → `UPDATE sec_user SET hashpassword` (returns the old hash) → activity log type 9 `CHANGE_CUSTOMER_PASSWORD` → e-mail alert to admin roles (`CHANGE_PASSWORD_ALERT_TEMPLATE`).
Errors: 400; 500 with `description` = the raw error text.

#### 31. `POST {base}/user/password/email`
```json
{ "refNo": "MVL00000001", "email": "kritsana.w.os@horixon-t8.com", "remark": "customer request" }
```
`refNo` and `email` are required. The endpoint generates a reset link (see #32), sends it with `SEND_RESET_PASSWORD_TEMPLATE`, and logs type 8 `SEND_EMAIL_RESET_PASSWORD`.
Errors: 400 `Invalid Parameter email` (unknown user); 500.

#### 32. `POST {base}/user/password/link`
```json
{ "email": "kritsana.w.os@horixon-t8.com" }
```
Response: `{"result":{"urlResetPassword":"<RESET_PASSWORD_URL>?reference_id=<random>&expired_at=<unix>"}}`. The link is valid for 2 hours.
DB: `sec_user` (R), `reset_password` (consume the old row with UPDATE, then INSERT, inside a transaction).
Errors: 400 unknown email; 500. On the generate-link error path the raw DB error text goes back in `description`.

#### 33. `GET {base}/user/permission`
JWT only (no permission check). The endpoint returns the union of attribute keys of the caller's realm roles, e.g. `{"result":["view_lead_policy","resend_policy"]}`. It uses Keycloak admin calls and no DB.

---

### Renewal Payment (ลิงก์ชำระเงินต่ออายุ)

#### 34. `POST {base}/renewal-payment`
```json
{ "refPolicyNo": "MV0000000001", "payment2c2pUrl": "https://sandbox-pgw-ui.2c2p.com/payment/4.1/#/token/PLACEHOLDER" }
```
| Field | Required | Validation |
|---|---|---|
| refPolicyNo | yes | `required` |
| payment2c2pUrl | yes | `required,url` |

The endpoint upserts by `ref_policy_no`. It runs INSERT when no row exists, and otherwise UPDATE `payment_2c2p_url`, `invoice = NULL` (⚠️ clears any existing invoice) and `user_add`. `user_add` = JWT `preferred_username`.
Response 200 `Success`. Errors: 400, 500. DB: `renewal_payments` (R/W).

#### 35. `GET {base}/renewal-payment?refPolicyNo=MV0000000001`
Response: `{"result":{"id":1,"refPolicyNo":"MV0000000001","payment2c2pUrl":"https://...","invoice":"INV0000001","createdAt":"...","userAdd":"staff.user"}}`
Errors: 400 `Missing Parameter refPolicyNo`. **500 when no row exists** (`sql.ErrNoRows` is not mapped to 404).
DB: `renewal_payments`.

---

## DB Usage

All objects are in schema `insurverse`. R = read, W = insert/update.

| Table / view / function | R/W | Endpoints (#) |
|---|---|---|
| `v_lead_policy_product` (view) | R | 4, 6, 12, 16, 27 |
| `mas_product_type` | R | 5 |
| `Policy_Header` | R/W | R: 7, 12, 16, 28 · W: 13, 14, 29 |
| `Policy_coverage_premium` | R | 7, 16, 28 |
| `Lead_coverage_premium` | R/W | R: 7, 8, 16, 28 · W: 29 |
| `Policy_Regis_Evident` | R/W | R: 7 · W: 13, 14 |
| `mas_cmi_province` | R | 7, 8, 18–21 |
| `mas_cmi_color` | R | 7, 8, 18–21 |
| `mas_cmi_brand_model` | R | 18–21 |
| `company_detail` | R | 18–21 |
| `Policy_Car_Act_Discount_Premium` | R/W | R: 8, 16, 17, 18–21, 28 · W: 18, 19, 20 (cmi numbers), 29 |
| `Lead_Car_Act_Discount_Premium` | R/W | R: 8, 28 · W: 29 |
| `Policy_endorse_detail` | R | 19, 20, 21 |
| `log_cmi_realtime` | R/W | R: 17 · W: 18, 19, 20 |
| `lead_ta_participant`, `lead_ta_premium`, `mas_country`, `mas_ta_description`, `mas_ta_coverage`, `policy_ta_coverage` | R | 9 (+ `lead_ta_premium` in 28, W in 29) |
| `lead_home_premium`, `lead_home_coverage`, `mas_home_resident_type`, `mas_home_building_type` | R | 10 (+ `lead_home_premium` in 28, W in 29) |
| `subdistrict`, `district` | R | 10 |
| `province` | R | 10, 16 |
| `mas_pa_coverage`, `lead_pa_coverage` | R | 11 |
| `lead_pa_premium` | R/W | R: 28 · W: 29 |
| `policy_ta_premium`, `policy_pa_premium`, `policy_home_premium` | R/W | R: 28 · W: 29 |
| `payment`, `payment_act`, `payment_ta`, `payment_transaction`, `payment_callback` | R | 28 |
| `promo_code` | R | 16 |
| `sf_claim`, `sf_claim_coverage` | R | 15 |
| `Policy_email_confirm` | W (insert-if-absent) | 12 |
| `v_endorse_product` (view) | R | 22, 23, 24 |
| `log_activity` | R/W | R: 14, 25 · W: 12, 13, 14, 18, 19, 20, 24, 27, 29, 30, 31 |
| `log_activity_ref` | R/W | R: 14, 25 · W: same as `log_activity` |
| `activity_type` | R | 25, 26 |
| `sec_user` | R/W | R: 28, 29, 30, 31, 32 · W: 29 (hashpassword=''), 30 |
| `reset_password` | R/W | 29, 31, 32 |
| `renewal_payments` | R/W | 34, 35 |
| **Stored functions / procedures** | none | No `SELECT fn_*`, `CALL`, or advisory locks. `fn_lead_to_car_act` is only mentioned in a comment (lead_policy_repository.go:1014). `insurverse.uuid_generate_v4()` appears only in the unused repo method `CreateNewUserFromEmail`. |

Activity type ids written (`constants/log.go`): 1 edit_email, 2 edit_email_migrate, 3 email_customer_policy, 4 email_customer_endorse, 5 view_lead_policy, 6 cmi_resubmit, 7 cmi_submit, 8 send_email_reset_password, 9 change_customer_password, 10 edit_car_inspection_status.

---

## Notes / ⚠️ unverified items

1. **Schema not verified live.** Table and column names come from SQL strings only. Run an `information_schema.columns` check (Rule 6) before any change.
2. **Shared transaction state (concurrency risk).** Repositories store `DB.Tx` on a single shared struct (`LeadPolicyRepository`, `UserRepository`). Concurrent requests to #13/#14 or #29/#31/#32 can overwrite each other's `Tx`.
3. **Permission denial returns 401**, not 403. The permission check makes a Keycloak admin login on every request.
4. **Old password hashes are written to `log_activity.detail`** (#29, #30) and are readable through #25.
5. **A hard-coded AES key** (for `confirmNo`) and a hard-coded bcrypt salt suffix live in `utils/hash.go`. The values are deliberately not reproduced here.
6. **Request/response bodies are logged in full** by `BodyDump`, including passwords (#30) and customer PII.
7. **The MV benefit row "MV03" uses the MV02 premium** (`SIMV02Amt`) in `lead_policy_service.go`. This looks like a bug.
8. **#16 response is not enveloped** and its 400 errors use the `{"error": "..."}` shape.
9. **#20 has no body validation.** `ReSubmitCMIRequest.Username` has no json tag (it is overwritten by the JWT anyway).
10. **Error-mapping gaps:**
    - #35 returns 500 on not-found.
    - #30 returns an unknown email as 500.
    - #30 and #32 put raw error text in `description`.
    - #29 can panic when the current user row is missing.
    - #18–20 can panic on an unexpected CMI response shape.
11. **#11 returns 200 for unknown leadNo** because the query LEFT JOINs from the master table. #7/#8 also return 200 with empty data for unknown leads.
12. **Class 3 / 2+ cutoff dates are hard-coded** (2026-02-17, 2026-03-26), and the emergency PDF URL is hard-coded to the public media host.
13. **Helm `helm-uat-isv.yaml` does not define** `CONDITION_LEVEL_3_BUCKET`, `CONDITION_LEVEL_3_OBJECT` or `RESEND_POLICY_CLASS3_TEMPLATE`. The Class 3 condition attachment is silently skipped, and the class-3 template falls back to `/template/resend_policy_class3.html` (an absolute path joined to cwd). ⚠️ unverified at runtime.
14. **`Authorization` header format** (with or without `Bearer `) is not confirmed. See Auth.
15. **`scripts/resubmit_batch.go`** (a standalone script) also reads env vars. It is not part of the HTTP API and is not documented here.
