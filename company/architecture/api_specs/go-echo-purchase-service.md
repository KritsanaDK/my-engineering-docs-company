# go-echo-purchase-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-purchase-service` (Go module `insurverse_payment`).
> Generated from route registration (`main.go`, `router/router.go`) and handler code. `docs/docs.go` (swagger) was used only as a hint; it matches the router for the 19 business routes but does not list `/running` or the probes.
> Spec date: 2026-09-23. Read-only analysis; nothing was executed.

---

## Overview (ภาพรวม)

| Item | Value |
|---|---|
| Purpose | Payment / purchase service for Insurverse: creates 2C2P payment tokens for motor policy (voluntary), motor compulsory (ACT / พ.ร.บ.), travel (TA), personal accident (PA) and home products; receives 2C2P backend callbacks and then runs post-payment work: lead update, policy conversion via DB functions, IIA submission, CMI, document generation queue, Salesforce upsert, promo/point update, push notifications. Also has support / "fix" endpoints to resend policies to IIA and re-push Salesforce payments. |
| Framework | Go + Echo v4 (`github.com/labstack/echo/v4`), `sqlx` + `lib/pq` (PostgreSQL). No GORM — all SQL is raw. |
| Port | `HTTP_PORT` env (default `9000` in code; Helm sets `containerPort: 8080`) |
| Base path | `/api/v1/purchase` (business routes). Probes are at the root (`/healthcheck`, `/livez`, `/readiness`, `/readyz`). |
| DB schema | `insurverse` (PostgreSQL). Pool: max open 100, max idle 10, conn lifetime 1h. |
| Server timeouts | Read 30s, Write 60s, Idle 120s; graceful shutdown 10s. |
| Response envelope | `utils.Response` → `{ "result": bool, "code": int, "message": string, "data": any (omitempty) }` |

### Environment variables (names only / ชื่อตัวแปรเท่านั้น)

Checked at startup by `utils.CheckEnvReady()` (process panics if any is missing or empty; when `ENV` is `LOCAL` or empty, it loads `local.env` first):
`ENV`, `HTTP_PORT`, `KEY_2C2P_URL`, `KEY_2C2P_MERCHANT_ID`, `KEY_2C2P_SECRET`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME`, `SALEFORCE_AUTH_URL`, `URL_HOST`, `URL_FRONT_APP`, `URL_UAM_SERVICE`, `URL_FILE_SERVICE`, `SALEFORCE_CLIENT_ID`, `SALEFORCE_CLIENT_SECRET`, `SALEFORCE_USERNAME`, `SALEFORCE_PASSWORD`, `Url_IIA`, `IIA_Token`, `Backend_Queue`.

Also read with `os.Getenv` but not checked at startup: `ENVIRONMENT`, `SALEFORCE_GRANT_TYPE`, `Base_Url`, `Backend_Doc`, `Backend_Uam`, `Backend_Notification`, `Url_Fontend` (the typo is in the code), `ENC_KEY`, `IV` (AES-256 lead-number encrypt/decrypt).

| Var | Used for |
|---|---|
| `KEY_2C2P_URL`, `KEY_2C2P_MERCHANT_ID`, `KEY_2C2P_SECRET` | 2C2P PGW base URL, merchant ID, HS256 JWT secret (sign requests and verify callbacks) |
| `URL_HOST` | Builds the 2C2P `backendReturnUrl` = `URL_HOST + "/callback"` |
| `URL_FRONT_APP` | Frontend return URL for POLICY / ACT / renewal |
| `Url_Fontend` | Frontend return URL for TA / PA / HOME |
| `Url_IIA`, `IIA_Token` | IIA (Thai insurance information agency) HealthPolicyWS for TA/PA/Home |
| `Backend_Uam` (fallback `URL_UAM_SERVICE` in renewal only) | Internal UAM service: CMI realtime, IIA for ACT, create policy ACT (Salesforce), renewal policy form |
| `Base_Url` | Internal gateway base: `api/v1/doc/`, `api/v1/notification/…`, `api/v1/queue/…` |
| `Backend_Doc`, `Backend_Queue`, `Backend_Notification` | Document service, task queue service, notification service |
| `SALEFORCE_*` | Salesforce OAuth password grant (token cached in memory) |
| `ENV` / `ENVIRONMENT` | `dev` turns on verbose callback logging; `PRD` turns on the ACT start-date check; passed as the first argument to `fn_*_policy_from_lead` |

### External / third-party calls (การเรียกระบบภายนอก)

| Target | Method + path | Caller |
|---|---|---|
| 2C2P PGW | `POST {KEY_2C2P_URL}/payment/4.1/paymentToken` (JWT HS256 payload) | all `create-payment*` |
| 2C2P PGW | `POST {KEY_2C2P_URL}/payment/4.1/paymentInquiry` | `payment-inquiry` |
| Salesforce | `POST {SALEFORCE_AUTH_URL}` (OAuth token, form-encoded) | lazy, on first SF call |
| Salesforce | `POST {instance_url}/services/apexrest/upsertaccount` | callback (POLICY*/ACT*) |
| Salesforce | `POST {instance_url}/services/apexrest/upsertpaymentpremium` | callback, `update-sf-payment`, `update-sf-payment-act` |
| IIA | `POST {Url_IIA}HealthPolicyWS/Service1.svc/IssuedPolicy` (TA) · `/IssuedPolicyPA` · `/IssuedPolicyHome`, header `Authorization: Bearer {IIA_Token}`, timeout 3 min | callback (TA/PA/HOME), IIA fix endpoints, support resend |
| Internal UAM | `POST {Backend_Uam}cmi_realtime_service` · `iia_act_service` · `create_policy_act` | callback (ACT) |
| Internal UAM | `POST {Backend_Uam or URL_UAM_SERVICE}get_policy_renewal_b2b` → `create_policy_form` | callback (POLICY_RENEWAL, goroutine) |
| Internal queue | `POST {Backend_Queue}create_task_queue` (fallback `{Base_Url}api/v1/queue/create_task_queue`) that wraps `GET {Base_Url}api/v1/doc/act/{carActNo}` · `ta_policy_document/{no}` · `pa_policy_all_document/{no}` · `home_policy_all_document/{no}` | callback |
| Internal notification | `POST {Base_Url}api/v1/notification/push_notification_id` | callback (after `fn_update_point_policy`) |
| Internal notification | `GET {Backend_Notification}email/input_policy/{leadNo}` | callback (POLICY only) |

---

## Auth & Middleware (การยืนยันตัวตน)

Global middleware (`main.go`), applied to **every** route:

1. `middleware.RequestID()` — sets `X-Request-Id`.
2. `middleware.Recover()` — turns panics into HTTP 500.
3. `middleware.CORS()` — default config (allows all origins `*`).
4. `e.Validator = middlewares.NewCustomValidator()` — go-playground validator. Adds a custom `email` rule that uses `net/mail.ParseAddress`.

**No authentication on any route.** `middlewares.ValidateToken` (JWT bearer, HS256) exists in `middlewares/validateToken.go` but is **not registered** on any group or route. The only check on `/callback` is the 2C2P JWT signature, and that check is not enforced (see Notes N1). ⚠️ Every endpoint, including admin/fix/support ones, can be called by anyone who can reach the service. Network isolation (ingress/gateway) could not be verified from this repo.

Error formats:
- Bind failure → `echo.NewHTTPError(400, err)` → Echo default body `{"message":"<bind error>"}`.
- Validation / business error → `utils.Response` with `result:false`.
- Panic → Echo 500 `{"message":"Internal Server Error"}`.

---

## Endpoint Summary

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | `main.go:98` `healthcheck` | Liveness, returns `OK` |
| 2 | GET | `/livez` | none | `main.go:98` `healthcheck` | Liveness alias |
| 3 | GET | `/readiness` | none | `main.go:102` `readinessCheck` | DB ping (2s timeout) |
| 4 | GET | `/readyz` | none | `main.go:102` `readinessCheck` | Readiness alias |
| 5 | GET | `/api/v1/purchase/swagger/*` | none | `echoSwagger.WrapHandler` | Swagger UI |
| 6 | GET | `/api/v1/purchase/env` | none | `controllers/paymentController.go:58` `CheckPaymentEnv` | Shows 2C2P config (URL, merchant ID, masked secret) ⚠️ |
| 7 | POST | `/api/v1/purchase/payment-inquiry` | none | `paymentController.go:667` `CheckPaymentInquiry` | 2C2P payment inquiry by invoice |
| 8 | POST | `/api/v1/purchase/callback` | none (2C2P JWT, see N1) | `paymentController.go:707` `Callback` | 2C2P backend callback and post-payment orchestration |
| 9 | POST | `/api/v1/purchase/create-payment` | none | `paymentController.go:79` `CreatePayment` | Create 2C2P payment, motor policy |
| 10 | POST | `/api/v1/purchase/create-payment-renewal` | none | `paymentController.go:336` `CreatePaymentRenewal` | Create 2C2P payment, motor policy renewal |
| 11 | POST | `/api/v1/purchase/check-payment` | none | `paymentController.go:604` `CheckPayment` | Read `payment` row by invoice |
| 12 | POST | `/api/v1/purchase/create-payment-act` | none | `paymentController.go:1736` `CreatePaymentAct` | Create 2C2P payment, ACT (พ.ร.บ.) |
| 13 | POST | `/api/v1/purchase/check-payment-act` | none | `paymentController.go:1983` `CheckPaymentAct` | Read `payment_act` row by invoice |
| 14 | POST | `/api/v1/purchase/create-payment-ta` | none | `paymentController.go:2051` `CreatePaymentTA` | Create 2C2P payment, travel |
| 15 | POST | `/api/v1/purchase/check-payment-ta` | none | `paymentController.go:2290` `CheckPaymentTA` | Read `payment_ta` row by invoice |
| 16 | POST | `/api/v1/purchase/create-payment-tran` | none | `paymentController.go:2365` `CreatePaymentTransaction` | Create 2C2P payment, PA / HOME |
| 17 | POST | `/api/v1/purchase/check-payment-tran` | none | `paymentController.go:2679` `CheckPaymentTransaction` | Read `payment_transaction` row by invoice |
| 18 | POST | `/api/v1/purchase/update-sf-payment` | none | `controllers/coreController.go:2688` `UpdateSFPaymentPolicy` | Re-push policy payment to Salesforce |
| 19 | POST | `/api/v1/purchase/update-sf-payment-act` | none | `coreController.go:2798` `UpdateSFPaymentAct` | Re-push ACT payment to Salesforce |
| 20 | POST | `/api/v1/purchase/convert-ta-iia` | none | `coreController.go:2905` `TAConvertLeadAndSendIIA` | Convert a TA lead to a policy, then send to IIA |
| 21 | POST | `/api/v1/purchase/policy-ta-send-iia` | none | `coreController.go:2956` `TAPolicySendIIA` | Send an existing TA policy to IIA |
| 22 | POST | `/api/v1/purchase/policy-pa-send-iia` | none | `coreController.go:2999` `PAPolicySendIIA` | Send an existing PA policy to IIA |
| 23 | POST | `/api/v1/purchase/policy-home-send-iia` | none | `coreController.go:3042` `HomePolicySendIIA` | Send an existing Home policy to IIA |
| 24 | POST | `/api/v1/purchase/support/resend-iia` | none | `controllers/supportController.go:128` `ResendIIA` | Batch resend (max 20) of TA/PA/HOME policies to IIA, with audit log |
| 25 | GET | `/api/v1/purchase/running` | none | `paymentController.go:2729` `DebugRunningDT` | Debug: invoice running-number time window |

Total: **25 routes** (21 in `router.go` + 4 probes in `main.go`).

---

## Endpoints

Conventions used below:
- `leadNo` / `actNo` in create requests is the **AES-256 encrypted** lead number (`utils.AES256Decode` with `ENC_KEY`/`IV`), not the raw integer. If it decrypts to an empty string, the handler returns 400.
- Allowed `paymentMethod` values (`thirdparty.CheckPaymentMethod`): `CC`, `PPQR`, `TRUEMONEY`, `LINE`. `isIPP=true` + `CC` is sent to 2C2P as channel `IPP` (installment).
- Invoice number format (`generateInvoiceId`): `{prefix}{YY}{MM}{DD}{random 11–98}{running %04d}`. Prefix: `P` policy, `A` act, `T` TA, `G` PA, `H` HOME. The running number is `count(*)` of that day's rows (UTC+7) in the target table + 1. It is not collision-safe (see N6).
- Amount check: the request `amount` must equal the DB-computed amount formatted `%.2f`; otherwise 400 `Amount does not match`.

### 1–4. Probes — `GET /healthcheck`, `/livez`, `/readiness`, `/readyz`
- `/healthcheck`, `/livez` → `200 text/plain "OK"`.
- `/readiness`, `/readyz` → `200 {"status":"UP","database":"CONNECTED"}`; `503 {"status":"UNHEALTHY","message":"Database not initialized" | "Database ping failed: <err>"}`.
- DB: `PingContext` only.

### 5. `GET /api/v1/purchase/swagger/*`
Swagger UI from `docs/` (generated by swag). It may be out of date.

### 6. `GET /api/v1/purchase/env` — Check 2C2P env ⚠️
Returns the 2C2P config. The secret is partly masked: first 3 and last 4 characters stay visible when the length is over 8.
```json
{ "payment_url": "<KEY_2C2P_URL>", "merchant_id": "<KEY_2C2P_MERCHANT_ID>", "secret_key": "abc*********wxyz" }
```
Not wrapped in `utils.Response`. No DB, no outbound call. ⚠️ Anyone can call it and it leaks part of the secret (N2).

### 7. `POST /api/v1/purchase/payment-inquiry` — 2C2P Payment Inquiry
**Body** (`dto.ReqCheckPaymentInquiry`)
| Field | Type | Required | Validation |
|---|---|---|---|
| invoiceNo | string | yes | `required` |
```json
{ "invoiceNo": "P2609234500001" }
```
**200**
```json
{ "result": true, "code": 200, "message": "Success",
  "data": { "invoiceNo": "P2609234500001", "amount": 1000, "currencyCode": "THB",
            "transactionDateTime": "20260923101500", "agentCode": "…", "channelCode": "…",
            "referenceNo": "…", "cardNo": "411111XXXXXX1111", "respCode": "0000", "respDesc": "Success" } }
```
`merchantID` is declared in the DTO but never filled.
**Errors:** 400 `validate error`; 500 `Error while encrypt payload` / `Error while connect 2C2P` / `Error while parsing body`. ⚠️ If 2C2P returns no `payload`, `DecryptPayload` may return nil and the handler panics; `Recover` turns it into a 500 (N7).
**Outbound:** 2C2P `paymentInquiry`. **DB:** none.

### 8. `POST /api/v1/purchase/callback` — 2C2P backend callback (หัวใจของ flow หลังชำระเงิน)
Called by 2C2P at `URL_HOST + "/callback"`. The address is set in `thirdparty.RequestPaymentToken` and overrides the `BackendReturnUrl` in the DTO.

**Body** (`dto.ReqCallback`)
| Field | Type | Required | Validation |
|---|---|---|---|
| payload | string (JWT HS256 signed with `KEY_2C2P_SECRET`) | yes | `required` |
```json
{ "payload": "<2C2P JWT>" }
```
Claims used (`thirdparty.JwtBodyCallbackClaims`): `merchantID, invoiceNo, installmentPeriod, amount, currencyCode, transactionDateTime (yyyyMMddHHmmss), agentCode, channelCode, referenceNo, cardNo, respCode, respDesc, userDefined1 (lead no, plain), userDefined2 (payment type), userDefined3 (email), ref1, ref2, ref3, isManualUpdate, updatedManualBy`.

**Processing:**
1. Decode the JWT. Return 400 `invalid payment callback token` / `invalid payment callback claims` only when the token or claims are nil. ⚠️ The signature is not enforced (N1).
2. `INSERT insurverse.payment_callback` (json_body, invoice_no, callback_type=`SUCCESS` if `respCode=="0000"` else `OTHER`, payment_type, data). This runs for every callback.
3. If `respCode == "0000"`:
   - Idempotency check: if `payment` or `payment_act` already has this `invoice_no` with `SUCCESS`, return `200 text "OK"` and stop. ⚠️ `payment_ta` and `payment_transaction` are not checked (N5).
   - Branch on `userDefined2` (upper-cased):

| userDefined2 | Steps |
|---|---|
| `POLICY`, `POLICY_RENEWAL`, `POLICY_BUNDLE` | `UPDATE payment` → SUCCESS (by invoice, sets installment_period, ref1-3, is_manual_update, updated_manual_by); `UPDATE payment` → CANCELED for other rows of the same lead_no. `UpdateLead`: calls `fn_policy_book_iia()`, `fn_policy_quatationno_iia()`, `fn_policy_invoiceno_iia()` (plus the `_act` variants when `Flag_Car_Act='Y'`), each only if the column is still empty, and updates `Lead_coverage_premium` (Policy_book/Quatation/Invoice no, Payment_status/channel/No/Ref1/Date). Salesforce: `getSaleforceAccount` (reads `Lead_coverage_premium.SF_Lead` and `sec_user`, upserts the SF account, writes `sec_user.sf_account` if it was empty), reads car data from `Lead_coverage_premium`, then `upsertpaymentpremium`. `POLICY` only: `GET {Backend_Notification}email/input_policy/{leadNo}`. `POLICY_RENEWAL` only: goroutine `CreatePolicyFormInternal` (UAM `get_policy_renewal_b2b` → reads `Policy_Header` for the default-occupation rule → UAM `create_policy_form`). |
| `ACT`, `ACT_RENEWAL` | `UPDATE payment_act` → SUCCESS by invoice; CANCELED for others with the same act_no. `UpdateLeadAct` → `UPDATE Lead_Car_Act_Discount_Premium` (payment fields). `ConvertCarActNo`: skip if `Policy_Car_Act_Discount_Premium` already exists for the lead; may set a default `Occupation` on `Lead_Car_Act_Discount_Premium`; then `SELECT … FROM fn_lead_to_car_act($1::bigint)`. On success: UAM `cmi_realtime_service`, SF account + payment upsert (car data from `Lead_Car_Act_Discount_Premium`), UAM `create_policy_act`, queue ACT document, UAM `iia_act_service`, then a second SF payment upsert from `Policy_Car_Act_Discount_Premium` ⋈ `sec_user` ⋈ `payment_act`. |
| `TA` | `UPDATE payment_ta` → SUCCESS by invoice; CANCELED for others with the same lead_ta_no (errors ignored). `UpdateLeadTA` → `UPDATE lead_ta_premium`. `ConvertMultiTA`: skip if a `policy_ta_premium` row exists; `SELECT … FROM fn_ta_policy_from_lead('<ENV>', lead)`. For each policy: `TAConnectIIA` (IIA `IssuedPolicy`, plus `log_iia_policy` insert) and the TA document queue. |
| `PA` | `UPDATE payment_transaction` → SUCCESS (invoice + lead_type), CANCELED for others. `UpdateLeadPA` → `UPDATE lead_pa_premium`. `ConvertPA` → `fn_pa_policy_from_lead(lower(ENV), lead)` (skip if a `policy_pa_premium` row exists), then `PAConnectIIA` (IIA `IssuedPolicyPA`) and the PA all-document queue. |
| `HOME` | Same as PA using `lead_home_premium`, `fn_home_policy_from_lead`, `policy_home_premium`, IIA `IssuedPolicyHome`, home all-document queue. |

   - Promo / points: policyType is `mv` (POLICY, POLICY_BUNDLE), `mc` (ACT), `ta`, `pa` or `home`. The handler calls `SELECT rtn_success,rtn_msg FROM fn_update_promo_active(policyType, leadNo)`. For non-`mv` types with an issued policyNo it also calls `fn_update_point_policy(policyType, policyNo)`, then `push_notification_id` for `rtn_app_noti_id` / `rtn_ref_app_noti_id`. ⚠️ `POLICY_RENEWAL` and `ACT_RENEWAL` get no policyType, so neither function runs for them (N8).

**Responses:** `200 {"result":true,"code":200,"message":"Success"}` (also for non-0000 callbacks); `200 text "OK"` (duplicate); 400 validation or token errors; 500 `Get car data error` (Salesforce car lookup failed; the payment is already SUCCESS at that point); 500 `Err` (PA/HOME payment update failed); raw error → 500 when a POLICY/ACT DB update fails.

### 9. `POST /api/v1/purchase/create-payment` — Motor policy payment (ประกันรถภาคสมัครใจ)
**Body** (`dto.ReqPayment`)
| Field | Type | Required | Validation / notes |
|---|---|---|---|
| leadNo | string | yes | AES-encrypted Lead_No, must decrypt to an int |
| policyType | string | yes | e.g. `1`, `2+`, `3+`, `3`. `3` + IPP is rejected. IPP periods: `2+`/`3+` → [3]; `1` → [3,4,6,10] ([3] if amount < 10000) |
| productDesc | string | no | default `insurverse` at 2C2P |
| amount | number | yes | must equal `round(Perm_Amt+Duty_Amt+Vat_Amt+(Prem_ACT if Flag_Car_Act='Y'),2)` from `Lead_coverage_premium` |
| isIPP | bool | no | only with `CC` |
| paymentMethod | string | yes | `CC`/`PPQR`/`TRUEMONEY`/`LINE` |
| email | string | yes | `required,email` (+ `mail.ParseAddress`) |
| redirectUrl | string | no | overrides the frontend return URL (`?lead=…&invoiceNo=…&type=POLICY` is appended) |
| remark | string | no | stored |
| paymentChannel | string | no | stored in `payment.payment_channel` |
| salesChannel | int | no | stored in `payment.sales_channel` |
| bundleFlag | bool | no | true → 2C2P `userDefined2 = POLICY_BUNDLE` |
```json
{ "leadNo": "<AES-encrypted lead no>", "policyType": "1", "productDesc": "ประกันรถยนต์ชั้น 1",
  "amount": 15000.00, "isIPP": false, "paymentMethod": "CC", "email": "kritsana.w.os@horixon-t8.com",
  "redirectUrl": "", "remark": "", "paymentChannel": "WEB", "salesChannel": 1, "bundleFlag": false }
```
**200** (`dto.CreatePaymentReturn`)
```json
{ "result": true, "code": 200, "message": "Success",
  "data": { "invoiceNo": "P2609234500001", "webPaymentUrl": "https://<2c2p>/payment/…", "token": "<paymentToken>",
            "amount": 15000, "description": "ประกันรถยนต์ชั้น 1", "method": "CC", "installment": false, "remark": "" } }
```
**Errors (400):** validator message, `Please enter a valid email address.`, `invalid lead_no`, `payment method not allow`, `installment not allow`, `this lead_no has been paid.`, `Lead number not found in database (lead_no: N)`, `convert amount error (…)`, `Amount does not match`. **500:** `2C2P response error => <respDesc>` or a connect/encrypt error.
**DB:** R `payment` (paid check), R `Lead_coverage_premium`, R `payment` count (invoice running), W `INSERT payment` (PENDING). ⚠️ The INSERT error is logged only; the handler still returns 200.
**Outbound:** 2C2P `paymentToken`.

### 10. `POST /api/v1/purchase/create-payment-renewal` — Motor renewal payment
Body: same `dto.ReqPayment` (`bundleFlag`, `redirectUrl`, `remark`, `paymentChannel`, `salesChannel` are ignored). Extra checks: `Lead_coverage_premium.ref_policy_no` must be non-empty (else 400 `this lead_no is not renewal`), and `Policy_Header.Flag_Deli` is read for that ref policy (error → 400 `check flag delivery error …`). Frontend return: `{URL_FRONT_APP}/renew/car-insurverse/purchase/payment_success-2c2p?lead=…&invoiceNo=…`. 2C2P `userDefined2 = POLICY_RENEWAL`; productDesc defaults to `Insurance Policy Renewal Payment`.
**200:** `data` is `dto.ResPayment` (`invoiceNo, webPaymentUrl, token, amount, description, method, installment`).
**Errors:** 400 `validate error`, the same errors as #9, plus `check renewal error …`. 500 for 2C2P errors.
**DB:** R `payment`, R `Lead_coverage_premium`, R `Policy_Header`, W `INSERT payment` (without remark/sales_channel/payment_channel; the error is ignored). **Outbound:** 2C2P.

### 11. `POST /api/v1/purchase/check-payment` — Policy payment status
**Body** `dto.ReqCheckPayment`: `invoiceNo` string, required.
```json
{ "invoiceNo": "P2609234500001" }
```
**200** (`dto.ResCheckPayment`)
```json
{ "result": true, "code": 200, "message": "Success",
  "data": { "paymentId": "1", "invoiceNo": "P2609234500001", "leadNo": 123, "amount": 15000, "method": "CC",
            "description": "…", "isInstallment": false, "installmentPeriod": 3, "urlPay": "https://…", "token": "…",
            "paymentStatus": "PENDING", "customerEmail": "kritsana.w.os@horixon-t8.com", "remark": "", "salesChannel": "1" } }
```
Only rows with status `PENDING` or `SUCCESS` are returned. **Errors:** 400 `validate error`, 400 `not found policy payment`.
**DB:** R `payment`.

### 12. `POST /api/v1/purchase/create-payment-act` — ACT payment (พ.ร.บ.)
**Body** (`dto.ReqPaymentAct`)
| Field | Type | Required | Notes |
|---|---|---|---|
| actNo | string | yes | AES-encrypted `Car_Act_Lead_No` |
| productDesc | string | no | |
| amount | number | yes | must equal `round(Total,2)` from `Lead_Car_Act_Discount_Premium` |
| isIPP | bool | no | must be false (true → 400 `installment not allow`) |
| paymentMethod | string | yes | allowed list |
| email | string | yes | `required,email` |
| paymentChannel, remark | string | no | stored |
| redirectUrl | string | no | ⚠️ accepted but ignored |
| salesChannel | int | no | stored |
```json
{ "actNo": "<AES-encrypted act lead no>", "productDesc": "พ.ร.บ.", "amount": 645.21, "isIPP": false,
  "paymentMethod": "PPQR", "email": "kritsana.w.os@horixon-t8.com", "paymentChannel": "WEB", "remark": "", "salesChannel": 1 }
```
Logic: paid check on `payment_act`. When `ENV=PRD`, the handler rejects the payment if today (UTC+7) is after `Start_date` (`Err | Policy Start Date > Payment Date`). If `ref_policy_no` is set, `userDefined2 = ACT_RENEWAL` and the renew return URL is used; otherwise `ACT`.
**200:** `data` = `dto.ResPayment`. **Errors:** 400 `LeadNo not valid`, `invalid act_no`, `payment method not allow`, `installment not allow`, `this act_no has been paid.`, `Error`, `Amount not valid`, `Amount does not match`, `check renewal error …`; 500 for 2C2P errors or an INSERT failure (`message:""`).
**DB:** R `payment_act`, R `Lead_Car_Act_Discount_Premium`, W `INSERT payment_act`. **Outbound:** 2C2P.

### 13. `POST /api/v1/purchase/check-payment-act`
Body `{ "invoiceNo": "A2609234500001" }` (required). **200** `dto.ResCheckPaymentAct` (same fields as #11, with `actNo` instead of `leadNo`). **Errors:** 400 `validate error`, 400 `not found act payment`, 500 (other DB error, `message:""`). **DB:** R `payment_act`.

### 14. `POST /api/v1/purchase/create-payment-ta` — Travel payment
**Body** (`dto.ReqPaymentTA`)
| Field | Type | Required | Notes |
|---|---|---|---|
| leadNo | string | yes | AES-encrypted `lead_ta_no` |
| productDesc | string | no | |
| amount | number | yes | must equal `round(total_amt,2)` from `lead_ta_premium` |
| isIPP | bool | no | must be false |
| paymentMethod | string | yes | allowed list |
| email | string | no | ⚠️ not validated |
```json
{ "leadNo": "<AES-encrypted lead_ta_no>", "productDesc": "ประกันเดินทาง", "amount": 590.00,
  "isIPP": false, "paymentMethod": "CC", "email": "kritsana.w.os@horixon-t8.com" }
```
Logic: paid check (`payment_ta`). Today (UTC+7) must not be after `policy_startdate` (+7h). Reads `partner_code` (partner return URL) and `ta_travel_type_id` (3 → INBOUND return URL). Return URL base: `Url_Fontend`. `userDefined2 = TA`.
**200:** `data` = `dto.ResPayment`. **Errors:** 400 `validate error`, `invalid or empty lead_no`, `payment method not allow`, `installment not allow`, `this lead_ta_no has been paid.`, `Error`, `Err | Policy Start Date < Payment Date`, `error (lead_ta_no: N)`, `Amount does not match`, `Error | Check partner code`; 500 `Internal server error checking payment status` or 2C2P errors.
**DB:** R `payment_ta`, R `lead_ta_premium` (startdate, total_amt, partner_code, ta_travel_type_id), W `INSERT payment_ta` (error ignored). **Outbound:** 2C2P.

### 15. `POST /api/v1/purchase/check-payment-ta`
Body `{ "invoiceNo": "T2609234500001" }`. **200** `dto.ResCheckPaymentTA` (`paymentId, leadNo (string), invoiceNo, amount, premAmount (lead_ta_premium.perm_amt), method, description, isInstallment, installmentPeriod, urlPay, token, paymentStatus, customerEmail`). **Errors:** 400 `validate error` / `not found ta payment`. **DB:** R `payment_ta` ⋈ `lead_ta_premium`.

### 16. `POST /api/v1/purchase/create-payment-tran` — PA / HOME payment
**Body** (`dto.ReqCreatePayment`)
| Field | Type | Required | Notes |
|---|---|---|---|
| leadNo | string | yes | AES-encrypted lead_pa_no / lead_home_no |
| leadType | string | yes | `pa` or `home` (case-insensitive check; stored and sent to 2C2P as given) |
| productDesc | string | no | |
| amount | number | yes | must equal `round(total_amt,2)` of `lead_pa_premium` / `lead_home_premium` |
| isIPP | bool | no | only with `CC` |
| paymentMethod | string | yes | allowed list |
| email | string | no | not validated |
| userId | string | no | stored in `payment_transaction.user_id` |
```json
{ "leadNo": "<AES-encrypted lead no>", "leadType": "PA", "productDesc": "ประกันอุบัติเหตุ", "amount": 1200.00,
  "isIPP": false, "paymentMethod": "CC", "email": "kritsana.w.os@horixon-t8.com", "userId": "00000000-0000-0000-0000-000000000000" }
```
Logic: paid check (`lead_no` + `lead_type`); start-date check; amount check; then `UPDATE payment_transaction SET CANCELED WHERE lead_no=$1 AND payment_status='PENDING'` (⚠️ not filtered by lead_type, N9). Return URL `{Url_Fontend}/shopping/personal-accident/…` or `/shopping/home/…`.
**200:** `data` = `dto.ResPayment`. **Errors:** 400 `validate error`, `invalid or empty lead_no`, `lead_no must be a valid integer`, `payment method not allow`, `installment not allow`, `lead type not allow`, `this lead_no has been paid.`, `Error`, `Err | Policy Start Date < Payment Date`, `Not found PA Lead No.N` / `Not found Home Lead No.N`, `Amount does not match`; 500 `Internal server error checking payment status`, `Err`, or 2C2P errors.
**DB:** R/W `payment_transaction`, R `lead_pa_premium` or `lead_home_premium`. **Outbound:** 2C2P.

### 17. `POST /api/v1/purchase/check-payment-tran`
Body `{ "invoiceNo": "G2609234500001" }`. **200** `dto.ResCheckPayment` (`remark`/`salesChannel` always `""`). **Errors:** 400 `validate error` / `not found`. **DB:** R `payment_transaction`.

### 18. `POST /api/v1/purchase/update-sf-payment` — Re-push policy payment to Salesforce (fix)
Body `dto.ReqGetPolicyNo`: `policyNo` string, required.
```json
{ "policyNo": "TEST-POLICY-0001" }
```
Builds the payload from `Policy_Header` ⋈ `Policy_coverage_premium` ⋈ `sec_user` (by email) ⋈ `payment` (SUCCESS). If `Car_Act_No` is set, premium = Total_Amt + Prem_ACT; otherwise Total_Amt.
**200** `{"result":true,"code":200,"message":"Update Success"}` · **400** `validate error` / `Not found Policy No.` · **500** `Update Failed`.
**Outbound:** Salesforce `upsertpaymentpremium` (OAuth if needed). ⚠️ Dereferences `*dataUpdate.PolicyNumber`; a NULL there panics → 500.

### 19. `POST /api/v1/purchase/update-sf-payment-act` — Re-push ACT payment to Salesforce (fix)
Body `dto.ReqGetActNo`: `actNo` (the **Car_Act_No**, not encrypted), required.
```json
{ "actNo": "TEST-ACT-0001" }
```
Reads `Policy_Car_Act_Discount_Premium` ⋈ `sec_user` ⋈ `payment_act` (SUCCESS). Responses are the same as #18. **Outbound:** Salesforce `upsertpaymentpremium`.

### 20. `POST /api/v1/purchase/convert-ta-iia` — Convert TA lead → policy → IIA (fix)
Body `dto.ReqLeanTA`: `leadTANo` int, required (plain integer, not encrypted).
```json
{ "leadTANo": 123456 }
```
`ConvertTA`: fails if a `policy_ta_premium` row already exists for the lead. Calls `fn_ta_policy_from_lead('<ENV>', lead)` (single row), then `TAConnectIIA`.
**200** `OK` · **400** `validate error` / `Something Error` (the real reason is only logged).
**DB:** R `policy_ta_premium`, fn `fn_ta_policy_from_lead`, TA IIA payload reads (see DB Usage), W `log_iia_policy`. **Outbound:** IIA `IssuedPolicy`. Unlike the callback, this does **not** queue the TA document.

### 21. `POST /api/v1/purchase/policy-ta-send-iia` — Send TA policy to IIA (fix)
Body `dto.ReqPolicyTA`: `policyTaNo` string, required. `{ "policyTaNo": "TEST-TA-0001" }`
**200** `OK` · **400** `validate error` / `Something Error`. **DB/Outbound:** TA IIA payload queries + `log_iia_policy`; IIA `IssuedPolicy`. ⚠️ `policyTaNo` is inserted into SQL with `fmt.Sprintf` (SQL injection, N3).

### 22. `POST /api/v1/purchase/policy-pa-send-iia` — Send PA policy to IIA (fix)
Body `dto.ReqPolicyPA`: `policyPaNo` string, required. `{ "policyPaNo": "TEST-PA-0001" }`
**200** `IIA Msg => <msg>` · **400** `validate error` / `IIA Msg => <Resultdesc>`. **Outbound:** IIA `IssuedPolicyPA`. ⚠️ SQL injection (N3).

### 23. `POST /api/v1/purchase/policy-home-send-iia` — Send Home policy to IIA (fix)
Body `dto.ReqPolicyHome`: `policyHomeNo` string, required. `{ "policyHomeNo": "TEST-HOME-0001" }`
**200** `OK` · **400** `validate error` / `Something Error`. **Outbound:** IIA `IssuedPolicyHome`. ⚠️ SQL injection (N3).

### 24. `POST /api/v1/purchase/support/resend-iia` — Batch resend to IIA (support)
**Body** (`dto.ReqResendIIA`)
| Field | Type | Required | Validation |
|---|---|---|---|
| policyNos | string[] | yes | `required,min=1,max=20`. Each entry is trimmed; blanks and duplicates are skipped |
| policyType | string | yes | `oneof=TA PA HOME` (trimmed and upper-cased before validation) |
```json
{ "policyType": "TA", "policyNos": ["TEST-TA-0001", "TEST-TA-0002"] }
```
Per policy, sequentially: a bound pre-check (the policy exists in `policy_ta_premium` / `policy_pa_premium` / `policy_home_premium` and has a SUCCESS payment in `payment_ta` / `payment_transaction` with lead_type PA/HOME), then `TAConnectIIA` / `PAConnectIIA` / `HomeConnectIIA`. Each item is audited with `INSERT log_iia_policy` (api_name `ResendIIA-Support`, response_status 200/500, policy_no). The pre-check also blocks SQL injection on this route.
**200** (always, even when every item failed)
```json
{ "result": true, "code": 200, "message": "resend finished: 1 success, 1 failed",
  "data": { "total": 2, "success": 1, "failed": 1,
            "items": [ { "policyNo": "TEST-TA-0001", "success": true },
                       { "policyNo": "TEST-TA-0002", "success": false, "error": "policy has no successful payment; IIA payload cannot be built" } ] } }
```
**400** `validate error`. Does not touch lead status, documents or Salesforce.

### 25. `GET /api/v1/purchase/running` — Debug invoice running window
No input. **200** `{ "result":true,"code":200,"message":"Debug","data":{"current_utc":"…","current_utc+7":"…","running_period_utc":"2026-09-22 17:00:00 - 2026-09-23 16:59:59","running_period_utc+7":"2026-09-23 00:00:00 - 2026-09-23 23:59:59"} }`. No DB.

---

## DB Usage (schema `insurverse`)

| Table / function | R/W | Endpoints |
|---|---|---|
| `payment` | R/W (INSERT PENDING; UPDATE SUCCESS/CANCELED; count for invoice) | #9, #10, #11, #8 (POLICY*), #18 (R) |
| `payment_act` | R/W | #12, #13, #8 (ACT*; idempotency R), #19 (R) |
| `payment_ta` | R/W | #14, #15, #8 (TA), #24 (R pre-check), TA IIA payload (R) |
| `payment_transaction` | R/W | #16, #17, #8 (PA/HOME), #24 (R), PA/Home IIA payload (R) |
| `payment_callback` | W (INSERT) | #8 |
| `Lead_coverage_premium` | R/W (amount, renewal, SF_Lead, car data; UPDATE policy book/quotation/invoice numbers + payment fields) | #9, #10, #8 |
| `Lead_Car_Act_Discount_Premium` | R/W (amount, start date, renewal, car data; UPDATE payment fields, Occupation) | #12, #8 |
| `Policy_Car_Act_Discount_Premium` | R | #8, #19 |
| `Policy_Header` | R | #10, #18, #8 (renewal goroutine) |
| `Policy_coverage_premium` | R | #18 |
| `sec_user` | R/W (UPDATE `sf_account`) | #8, #18, #19 |
| `lead_ta_premium` | R/W (UPDATE payment fields) | #14, #15, #8 |
| `lead_pa_premium` | R/W | #16, #8 |
| `lead_home_premium` | R/W | #16, #8 |
| `policy_ta_premium`, `policy_pa_premium`, `policy_home_premium` | R | #8, #20–#24 |
| `log_iia_policy` | W (INSERT) | #8 (TA/PA/HOME), #20–#24 |
| TA IIA payload reads: `mas_ta_package`, `mas_country`, `lead_ta_participant`, `mas_ta_description`, `lead_ta_package`, `policy_ta_coverage`, `mas_ta_coverage`, `mas_ta_package_coverage`, `mas_state`, `sys_param`, `subdistrict`, `district`, `province` | R | #8 (TA), #20, #21, #24 |
| PA IIA payload reads: `mas_pa_package`, `lead_pa_participant`, `lead_pa_beneficiary`, `lead_pa_coverage`, `mas_pa_coverage`, `mas_ta_description`, `subdistrict`, `district`, `province` | R | #8 (PA), #22, #24 |
| Home IIA payload reads: `lead_home_participant`, `mas_home_building_type`, `lead_home_coverage`, `mas_home_coverage`, `mas_ta_description`, `subdistrict`, `district`, `province` | R | #8 (HOME), #23, #24 |
| `fn_policy_book_iia()` | fn (generates number) | #8 POLICY* |
| `fn_policy_quatationno_iia()` | fn | #8 POLICY* |
| `fn_policy_invoiceno_iia()` | fn | #8 POLICY* |
| `fn_lead_to_car_act(bigint)` | fn (lead → ACT policy) | #8 ACT* |
| `fn_ta_policy_from_lead(text env, int lead)` | fn (lead → TA policy/policies) | #8 TA, #20 |
| `fn_pa_policy_from_lead(text env, int lead)` | fn | #8 PA |
| `fn_home_policy_from_lead(text env, int lead)` | fn | #8 HOME |
| `fn_update_promo_active(policyType, leadNo)` | fn | #8 |
| `fn_update_point_policy(policyType, policyNo)` | fn | #8 (non-mv) |
| `fn_display_country_th(ids)`, `fn_display_country(ids)` | fn (read-only display) | TA IIA payload (#8, #20, #21, #24) |

---

## Notes / ⚠️ unverified items

- **N1 ⚠️ Callback signature not enforced.** `thirdparty.DecryptPayload` throws away the error from `jwt.ParseWithClaims`. `Callback` rejects the request only when the token or claims are nil, and never checks `token.Valid`. With `golang-jwt` a bad signature still returns a token with parsed claims. So a forged payload with `respCode=0000` could mark a payment SUCCESS and trigger policy issuance. The JWT claims also carry `isManualUpdate` / `updatedManualBy`, which are written to the DB. This needs a code fix plus a test on uat-isv only (not changed here).
- **N2 ⚠️ `/env` is public** and returns the 2C2P URL, merchant ID and a partly masked secret.
- **N3 ⚠️ SQL injection:** `TAConnectIIA` / `PAConnectIIA` / `HomeConnectIIA` build their payload SQL with `fmt.Sprintf('%s', policyNo)`. Endpoints #21, #22 and #23 pass user input straight in. Only #24 guards it with a bound pre-check.
- **N4 ⚠️ No auth anywhere.** `ValidateToken` middleware is dead code (not wired). Whether the ingress or gateway restricts the fix/support routes was not checked.
- **N5** Callback idempotency covers only `payment` and `payment_act`. A duplicate TA/PA/HOME callback re-runs the lead update. Policy conversion is guarded by the "policy already exists" checks, but IIA etc. do not re-run only because conversion then fails.
- **N6** Invoice running number = daily `count(*)` + random 2 digits. Two concurrent requests can produce the same invoice number. There is no advisory lock or sequence. Whether `invoice_no` has a unique constraint was not verified.
- **N7** `PaymentInquiry` and `RequestPaymentToken` type-assert claims without nil checks, so a panic is possible (Recover → 500).
- **N8** `POLICY_RENEWAL` / `ACT_RENEWAL` callbacks do not call `fn_update_promo_active` / `fn_update_point_policy` (the policyType mapping has no entry for them). Unclear if this is intentional.
- **N9** `create-payment-tran` cancels PENDING `payment_transaction` rows by `lead_no` only, without `lead_type`, so a PA and a HOME lead with the same number can cancel each other.
- **N10** Several INSERTs (`create-payment`, renewal, TA, tran) ignore the DB error or commit anyway and still return 200 with a 2C2P URL. That leaves an orphan invoice at 2C2P with no local row, so the callback updates 0 rows.
- **N11** `ReqPaymentAct.redirectUrl` and `ReqPayment2c2p.BackendReturnUrl` are accepted but ignored.
- **N12** `CheckDeliveryCreatePolicyRenewal` (coreController.go:3078) and `ConnectActDocument` / `ConnectTADocument` / `APIPaPolicyAllDocument` / `APIHomePolicyAllDocument` are not reachable from any route (dead code).
- **N13** DB function signatures and column types were taken from the SQL text in the Go code only. They were **not** checked against the live schema (`pg_proc` / `information_schema`) — ⚠️ unverified.
- **N14** Required-at-startup env list includes `URL_FILE_SERVICE`, which the code never reads. `Backend_Notification`, `Backend_Uam`, `Base_Url` and `Url_Fontend` are used but not checked at startup.
- **N15** Ingress host/path for this service was not found in `helm/*.yaml` (only probes and `containerPort`). The public URL is ⚠️ unverified. The swagger `@host` annotation names a dev host, which is not reproduced here.
