# isv-test — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/isv-test` (Go module `service_isv_test`).
> Despite the name, this **is** a deployed HTTP service (Echo) with ~90 routes, not a test harness. Generated from route registration (`main.go`, `router/router.go`, `router/initservice.go`) and handler → usecase/service → repository/model code. Swagger `docs/` was not used as a source of truth.
> Spec date: 2026-09-23. Read-only analysis; nothing was executed.

---

## Overview (ภาพรวม)

| Item | Value |
|---|---|
| Purpose | "Util" service for Insurverse (per README): marketing consent & call-back requests, ThaiBulkSMS email campaigns (+ webhook), promo-code / daily / roadside reports by email, BigQuery inserts, payment status checks, **Shopee Open Platform** integration (order push callback, auth tokens, forms, shipping) and the Shopee → Insurverse policy flows (ACT `oauth/token`, MV `mv/submit`, free ACT `mc/policy`), HBD (birthday) free-ACT sync, renewal file processing and batch renewal payment, Facebook CAPI events, Priceza click log, CMI brand/model lookup, WordPress short links, a reverse proxy to the IIA BigQuery API, and several test / scaffolding routes. |
| Framework | Go 1.24 + Echo v4.13.3, `database/sql` + `lib/pq` (raw SQL; README mentions go-jet but it is not in `go.mod`), BigQuery client, excelize, custom `util/client` HTTP client. |
| Port | `HTTP_PORT` (`cfg.Port`; local default 8085 per swagger host). |
| Base path | `/api/v1/isv-test/…` (most routes are registered **without** a leading `/`; Echo adds it). `/healthcheck` at root. |
| DB | PostgreSQL schema `insurverse`; DSN built from `DB_HOST/DB_PORT/DB_USER/DB_PASS/DB_NAME` with `sslmode=disable`. BigQuery dataset `insurverse-uat.RAW_IIA.PolicyDialyLastVersion` (hard-coded, even outside UAT ⚠️). |
| Response envelope | Mixed: `util.SuccessResponseFunc` / `ErrorResponseFunc`, `model.JsonReturn`, `echo.Map`, raw maps, Shopee handlers use `customError.Error`. No single contract. |
| Background jobs | `handleRefreshToken`: at startup and every 3 h 30 min refreshes the Shopee access token (`shopee_app_access_token`). HBD sync runs in a goroutine when triggered. |
| CLIs (not HTTP) | `cmd/create_renew_promocodes/main.go`, `cmd/test_renewal/main.go` — one-off tools (not analysed in depth ⚠️). |

### Environment variables (names only / ชื่อตัวแปรเท่านั้น)

`constant.InitConfig()` → `getEnv(key, fallback)`:
`ENV`, `HTTP_PORT`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME`, `CORS_ALLOWED_ORIGINS`, `ADMIN_USERNAME`, `ADMIN_PASSWORD` (Basic auth), `KEY_AES256`, `IV_AES256`, `SUMMARY_LINK_KEY`, `SUMMARY_LINK_IV`, `CLIENT_ID`, `CLIENT_SECRET`, `ClientIDBPMC`, `ClientSecretBPMC`, `OAUTH_URL`, `SERVICE_API_URL`, `POLICY_SERVICE_URL`, `Base_Url`, `Backend_Doc`, `Backend_Notification`, `Url_Fontend`, `PWA_BASE_URL`, `RENEWAL_REPORT_EMAILS`, `EMAIL_API_KEY`, `EMAIL_API_SECRET`, `EMAIL_BCC`, `SENDER_NOTI`, `SENDER_OTP`, `SENDER_POLICY`, `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMS_URL`, `SMS_CODE`, `SMS_CHARGE`, `SHOPEE_APP_PARTNER_ID`, `SHOPEE_APP_PARTNER_KEY`, `SHOPEE_APP_SHOP_ID`, `SHOPEE_URL_DOMAIN`, `SHOPEE_TEST_ORDER_PREFIX`, `META_CAPI_URL`, `META_CAPI_PIXEL_ID`, `META_CAPI_ACCESS_TOKEN`, `RECAPTCHA_SECRET_KEY`, `CMIPolicyAPIEnv`, `CMIPolicySecurityHeaderValueEnv`, `WORDPRESS_API_URL`, `WORDPRESS_SHORT_LINK_KEY`, `AnalyticProjectIDEnv`.
Several of these have **non-empty literal fallbacks** in `constant/config.go`, and `constant/constant.go` holds more literals (SMS / OneSignal / SMTP / email-API keys, OAuth client secrets, a `CredentialJson` blob) — see S1.

### External / third-party calls (การเรียกระบบภายนอก)

| Target | Method + path | Caller |
|---|---|---|
| Insurverse OAuth / e-API (`OAUTH_URL`) | `POST /services/oauth/v2/token`, `GET /services/oauth/v2/userinfo`, `POST /api/v1/lead/comp-motor`, `POST /api/v1/lead/motor`, `GET/POST /api/v1/agreement/marketing`, `GET /api/v1/agreement/payment?type=`, `POST /api/v1/payment/request`, `POST /api/v1/payment/success` | `oauth/token`, `mc/policy`, `mv/submit`, `oauth/consent-details` |
| Insurverse gateway (`Base_Url`) | `POST api/v1/user/isvregisterauto` (auto user), `POST api/v1/uam/create_policy_form`, `api/v1/purchase/create-payment-act` · `create-payment-renewal`, `api/v1/premium/actAPI` · `premiumAPI`, `api/v1/backoffice-lead-policy/leadpolicy/encrypted` · `/claim` | Shopee flows, batch payment, renewal, premium test routes |
| Document service (`Backend_Doc`) | `act/{no}`, `act/{no}/receipt`, MV policy / receipt docs | after `oauth/token` / `mv/submit` success |
| Self | `POST {OAUTH_URL}/api/v1/isv-test/mc/policy` | HBD sync (`hbdisv/triger`) |
| Shopee Open Platform (`SHOPEE_URL_DOMAIN`) | `/api/v2/auth/token/get`, `/auth/access_token/get`, `/order/get_order_detail`, `/order/cancel_order`, `/order/send_message`, `/order/get_buyer_invoice_info`, `/logistics/get_shipping_parameter`, `/logistics/ship_order`, `/product/get_item_list`, `/product/get_item_base_info` | `/shopee/*`, Shopee flows |
| ThaiBulkSMS email API | `POST https://tbs-email-api-gateway.omb.to/email/v1/send_template` (key from `email_api_keys`) | `thaibulksms/sendemail`, `emails/send`, `process-and-send`, `send-greeting` |
| SMTP (`SMTP_*`) | send mail (+password-protected ZIP) | `send_email`, reports |
| Google | reCAPTCHA `siteverify`; BigQuery insert | `policy/pdf`; `bigquery_policy_daily` |
| Policy SOAP (`POLICY_SERVICE_URL`) | CheckPolicyData | `policy/pdf` |
| OIC CMI (`CMIPolicyAPIEnv`) | `POST` with security header | `cmi_policy` |
| IIA BigQuery API | `https://thumb--d…/API_IIA_Bigquery/*` (hard-coded) | `proxy/*`, `POST /test` |
| WordPress | short-link endpoint (`WORDPRESS_API_URL`) | `short_link`, renewal links |
| Meta CAPI | `META_CAPI_URL` (pixel, token) | `facebook/capi/send_event` |

---

## Auth & Middleware (การยืนยันตัวตน)

Global (`main.go`): `CORSWithConfig` (origins = `CORS_ALLOWED_ORIGINS`, fallback `*`, `AllowCredentials: true`), `CustomLogger(logs)` (trace id from `X-Request-ID`), `middleware.Secure()`, `middleware.Recover()`. Validator = go-playground (`util.CustomValidator`). Shopee group adds `LoggerMiddleware(ShopeeHandler.Logs)`.

| Mechanism | Where | Behaviour |
|---|---|---|
| `middleware.BasicAuthMiddleware` | `promo_report`, `promo_report_ta`, `send_email`, `cmi_policy` (4 routes) | `Authorization: Basic base64(ADMIN_USERNAME:ADMIN_PASSWORD)`; plain string compare (not constant-time); 401 otherwise. |
| reCAPTCHA v2/v3 | `policy/pdf` | `recaptcha_token` checked with Google. |
| Shopee order state | `oauth/token`, `mv/submit` | **prod only**: order must be ready-to-ship via Shopee API unless `order_sn` has the test prefix (`AllowTestOrderBypass`); dev/uat skip the check. |
| **None** | all other routes | Open. |

No JWT, no roles / permissions model. Swagger is exposed when `ENV` ≠ `prod`.

---

## Endpoint Summary

All paths below are under `/api/v1/isv-test` unless shown from root. Handler file paths are relative to the repo root.

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | `main.go` (inline) | `"healthy"` |
| 2 | GET | `/swagger/*` | none (non-prod) | `echoswagger.WrapHandler` | Swagger UI |
| 3 | POST | `/consent/save` | none | `controller/consent_controller.go:13` `InsertOrUpdateConsentMarketing` | Upsert marketing consent + lead consent |
| 4 | GET | `/consent/all` | none | `consent_controller.go:101` `GetAllConsents` | List all consents (PII) |
| 5 | DELETE | `/consent/:id` | none | `consent_controller.go:113` `DeleteConsentByID` | Delete consent |
| 6 | POST | `/consent/request-contact` | none | `controller/request_contact_controller.go:22` `CreateRequestContact` | "Call me back" request (+consent) |
| 7 | GET | `/consent/request-contact/all` | none | `request_contact_controller.go:114` `GetAllRequestContacts` | List all requests (PII) |
| 8 | DELETE | `/consent/request-contact/:id` | none | `request_contact_controller.go:132` `DeleteRequestContactByID` | Delete request |
| 9–12 | GET | `/thaibulksms/emails/mv` · `/mc` · `/pa` · `/home` | none | `controller/thaibulk_email_control.go:12` / `20` / `36` / `44` | Read paid-customer emails per product |
| 13 | GET | `/thaibulksms/emails/all` | none | `thaibulk_email_control.go:52` `FetchAndSaveEmails` | Fetch MV/MC/PA/HOME emails → `email_logs` |
| 14 | GET | `/thaibulksms/emails/ta` | none | `thaibulk_email_control.go:81` `FetchAndSaveTAEmails` | Fetch TA emails → `email_logs` |
| 15 | POST | `/thaibulksms/emails/send` | none | `controller/email.go:119` `SendEmails` | Send pending `email_logs` via ThaiBulk |
| 16 | POST | `/thaibulksms/emails/data` | none | `thaibulk_email_control.go:143` `CreateEmailLog` | Insert an email log row |
| 17 | DELETE | `/thaibulksms/emails/all` | none | `thaibulk_email_control.go:166` `DeleteAllEmailLogs` | **Delete all** email logs |
| 18 | DELETE | `/thaibulksms/emails/:email` | none | `thaibulk_email_control.go:157` `DeleteEmailLogByEmail` | Delete by email |
| 19 | PUT | `/thaibulksms/emails/:email` | none | `thaibulk_email_control.go:174` `UpdateEmailLog` | Update email log |
| 20 | GET | `/thaibulksms/webhooks` | none | `controller/thaibulk_webhook_control.go:42` `GetAllWebhooks` | List webhooks |
| 21 | GET | `/thaibulksms/webhooks/:message_id` | none | `thaibulk_webhook_control.go:50` | Get webhook |
| 22 | DELETE | `/thaibulksms/webhooks/:message_id` | none | `thaibulk_webhook_control.go:59` | Delete webhook |
| 23 | PUT | `/thaibulksms/webhooks/:message_id` | none | `thaibulk_webhook_control.go:68` `UpdateWebhook` | Update webhook |
| 24 | POST | `/thaibulksms/webhook` | none | `thaibulk_webhook_control.go:12` `HandleThaiBulkSMSWebhook` | ThaiBulk delivery webhook (no signature check) |
| 25 | POST | `/thaibulksms/emails/process-and-send` | none | `thaibulk_email_control.go:99` `ProcessAndSendEmails` | Fetch + send campaign |
| 26 | POST | `/thaibulksms/emails/send-greeting` | none | `thaibulk_email_control.go:121` `SendGreetingEmail` | Fetch + send greeting template |
| 27 | POST | `/thaibulksms/sendemail` | none | `email.go:157` `SendEmailAPI` | Send pending via latest API key |
| 28 | GET | `/thaibulksms/api_keys` | none | `controller/thaibulk_api_key_control.go:11` `GetEmailAPIKeys` | **Returns all API keys + secrets** ⚠️ |
| 29 | POST | `/thaibulksms/api_keys` | none | `thaibulk_api_key_control.go:19` `CreateEmailAPIKey` | Add API key |
| 30 | GET | `/thaibulksms/api_keys/:name` | none | `thaibulk_api_key_control.go:33` `GetAPIKeyByName` | Get latest key by name (with secret) |
| 31 | DELETE | `/thaibulksms/api_keys/all` | none | `thaibulk_api_key_control.go:43` `DeleteAllAPIKeys` | Delete all keys |
| 32 | DELETE | `/thaibulksms/api_keys/:name` | none | `thaibulk_api_key_control.go:73` `DeleteAPIKeyByName` | Delete key |
| 33 | PUT | `/thaibulksms/api_keys/:name` | none | `thaibulk_api_key_control.go:51` `UpdateAPIKeyDetails` | Update key |
| 34 | POST | `/payment/check` | none | `controller/check_payment.go:22` `CheckPayment` | Payment status by invoice + type |
| 35 | POST | `/payment/check-renewal` | none | `check_payment.go:239` `CheckRenewalPolicy` | Is invoice a renewal payment |
| 36 | GET | `/test` | none | `util/util.go:23` `Test` | Returns success |
| 37 | POST | `/encrypted` | none | `controller/encrypted_lead.go:22` `GetEncryptedLead` | Policy / ACT no. → AES-encrypted lead no. + policy info |
| 38 | POST | `/promo_report` | Basic | `controller/report.go:30` `PromocodeReport` | Promo report XLSX → zip → email |
| 39 | POST | `/promo_report_ta` | Basic | `report.go:193` `PromocodeTAReport` | TA promo report → email |
| 40 | POST | `/send_email` | Basic | `email.go:19` `SendEmail` | Send arbitrary SMTP email |
| 41 | POST | `/bigquery_policy_daily` | none | `controller/big_query.go:78` `PostDataPolicyDialyLastVersion` | Insert one row into BigQuery (registered twice, same handler) |
| 42 | POST | `/send_daily_report` | none | `report.go:363` `SendDailyReport` | Daily sales report → email |
| 43 | POST, GET | `/send_roadside_report` | none | `report.go:581` `RoadsideReport` | Roadside activation reports (class 3, 2+) → email |
| 44 | POST | `/renewal/process` | none | `controller/renew_policy_controller.go:29` `ProcessRenewalFile` | Upload renewal Excel (`file`) → batch |
| 45 | GET | `/renewal/batch/:id` | none | `renew_policy_controller.go:37` `GetRenewalBatchDetail` | Batch detail (`page`, `pageSize`) |
| 46 | POST | `/renewal/summary-link` | none | `renew_policy_controller.go:50` `GenerateRenewalSummaryLink` | Encrypted renewal summary link for a policy |
| 47 | POST | `/renewal/excel-links` | none | `renew_policy_controller.go:58` `ProcessRenewalExcelWithLinks` | Excel in → Excel with links out |
| 48 | POST | `/priceza_log` | none | `controller/priceza.go:38` `PricezaLog` | Priceza click log (dedupe) |
| 49 | POST | `/check_date_limit` | none | `controller/date_limite.go:24` `CheckDateLimit` | Purchase cut-off date check |
| 50 | ANY | `/log-request/*` | none | `priceza.go:110` `LogRequestHandler` | Echo request body to log |
| 51 | POST | `/cmi_policy` | Basic | `controller/cmi.go:20` `CMIPolicy` | Map brand/model → send to OIC CMI |
| 52 | POST | `/short_link` | none | `controller/short_link.go:40` `GetShortenedURL` | WordPress short link |
| 53–63 | see below | `/shopee/*` | none | `controller/handler/shopee/handler.go` | Shopee Open Platform (11 routes) |
| 64–66 | POST/PUT/DELETE | `/shopee/form/insert` · `/update/:id` · `/delete/:id` | none | `shopee/handler.go:295` / `332` / `376` | Shopee product form CRUD |
| 67 | GET | `/shopee/selects` | none | `shopee/handler.go:442` `Selects` | Test select |
| 68 | POST | `/facebook/capi/send_event` | none | `controller/handler/facebook/capi/handler.go:34` `SendEvent` | Meta Conversions API event |
| 69 | POST | `/payment_callback/find_by_invoice_no` | none | `controller/handler/paymentcallback/handler.go:35` `FindByInvoiceNo` | Read `payment_callback` by invoice |
| 70 | POST | `/premium/act_api` | none | `controller/handler/premium/handler.go:34` `ActAPIGetLead` | Test: premium actAPI with hard-coded lead |
| 71 | POST | `/premium/premium_api` | none | `premium/handler.go:55` `PremiumApiLoad` | Test: premium API |
| 72 | GET | `/movement/create_table` | none | `controller/handler/movement/handler.go:25` `CreateTable` | **Runs DDL** `CREATE TABLE IF NOT EXISTS` ⚠️ |
| 73 | GET | `/movement/create_table_nm_policy` | none | `movement/handler.go:39` | **Runs DDL** |
| 74 | GET | `/movement/select` | none | `movement/handler.go:53` `Select` | Read movement table |
| 75 | POST | `/test/request-body` | none | `controller/handler/sample/handler.go:32` `ReadRequestBody` | Log raw body |
| 76 | ANY | `/proxy/*` | none | `controller/proxy.go:35` `ReverseProxy` | **Open reverse proxy** to IIA BigQuery API ⚠️ |
| 77 | POST | `/test` | none | `proxy.go:87` `CallAPI` | Calls IIA BigQuery `lastversionpolicies/rowcount` |
| 78 | POST | `/oauth/token` | none (Shopee order check in prod) | `controller/oauth_controller.go:632` `GetOAuthToken` | **Shopee ACT flow**: lead → consent → payment → payment success → docs |
| 79 | POST | `/mc/policy` | **none** | `controller/mc.go:27` `PolicyMCBypass` | **Free ACT issuance** (HBD): lead → payment → payment success ⚠️ |
| 80 | POST | `/oauth/consent-details` | none | `oauth_controller.go:1296` `GetConsentDetails` | Marketing / payment consent text from e-API |
| 81 | POST | `/mv/submit` | none (Shopee order check in prod) | `controller/mv_controller.go:723` `GetMVOAuthToken` | **Shopee MV flow** (voluntary motor) |
| 82 | GET | `/hbdisv/triger` | none | `controller/hbdisv.go:25` `TriggerHBDISVSync` | Start HBD sync (calls #79 per policy) |
| 83 | POST | `/policy/pdf` | reCAPTCHA | `controller/policy_controller.go:62` `GetPolicyPDF` | Policy lookup by ID + policy no. |
| 84 | POST | `/batch/payment/process` | none | `controller/batch_payment_controller.go:96` | Batch: renewal payments → `create_policy_form` |
| 85 | GET | `/batch/payment/status` | none | `batch_payment_controller.go:136` | Batch status |
| 86 | POST | `/batch/payment/retry` | none | `batch_payment_controller.go:161` | Retry failed records |
| 87 | GET | `/batch/payment/count` | none | `batch_payment_controller.go:196` | Count renewal payments |
| 88 | GET | `/batch/payment/status-distribution` | none | `batch_payment_controller.go:220` | Status histogram |
| 89 | POST | `/batch/payment/process/:id` | none | `batch_payment_controller.go:251` | Process one payment |
| 90 | GET | `/batch/payment/errors` | none | `batch_payment_controller.go:284` | Batch errors (`limit`) |

Shopee routes 53–63 (`controller/handler/shopee/handler.go`):

| # | Method | Path | Line | Body / query | Action |
|---|---|---|---|---|---|
| 53 | POST | `/shopee/access_token` | 41 | `{ code* }` | Exchange code → token (`/api/v2/auth/token/get`), store `shopee_app_access_token` |
| 54 | GET | `/shopee/authorize` | 70 | `?code*&shop_id&main_account_id` | Shopee redirect; store `shopee_app_authorized` |
| 55 | POST | `/shopee/callback` | 130 | `{ data:{ordersn,status,completed_scenario,update_time}, shop_id, code, timestamp }` | Shopee push → `callback_logs`, order detail, SMS/short link to buyer |
| 56 | POST | `/shopee/cancel_order` | 193 | `CancelOrderRequest` | `/order/cancel_order` |
| 57 | POST | `/shopee/order_detail` | 237 | `{ order_number* }` | `/order/get_order_detail` |
| 58 | GET | `/shopee/refresh_token` | 272 | – | Refresh access token |
| 59 | POST | `/shopee/message_to_seller` | 404 | `MessageToSellerRequest` | `/order/send_message` |
| 60 | POST | `/shopee/check_order_status` | 467 | `{ order_sn* }` | → `{ is_ready_to_ship, current_status }` |
| 61 | POST | `/shopee/validate_policy_form` | 535 | `ValidatePolicyFormRequest` | Validate buyer form (`policy_form_templates`, `policy_form_submissions`) |
| 62 | GET | `/shopee/get_shipping_parameter` | 586 | `GetShippingParameterRequest` | `/logistics/get_shipping_parameter` |
| 63 | POST | `/shopee/ship_order` | 624 | `ShipOrderRequest` | `/logistics/ship_order` |

Total: **91 unique routes** (`router.go` registers 92 incl. the duplicate `bigquery_policy_daily`; + `/healthcheck` in `main.go`). Row #43 counts GET and POST as one entry.

---

## Endpoints

### 3–8. Consent and call-back requests
`POST /consent/save` (`model.ConsentRequest`)
| Field | Type | Required | Validation |
|---|---|---|---|
| firstname, lastname | string | yes | |
| email | string | no | |
| contact_number | string | yes | |
| consent_flag | string | yes | `oneof=Y N` |
| consent_from | string? | no | source |
| lead_no | string | yes | `min=1` |

Looks up `consent_marketing` by contact / email → insert or update; `INSERT lead_consent`. `POST /consent/request-contact` (`RequestContact`: `firstname*`, `surname`, `contact_number*`, `contact_time_pre*`, `requested_from`, `consent_flag*` Y/N) → `INSERT request_contact` + consent upsert. `GET …/all` return every row; `DELETE …/:id` delete by id (`consent_marketing` + `lead_consent`, or `request_contact`).

### 9–33. ThaiBulkSMS email campaign
- Fetch routes read paid customers: MV `Lead_coverage_premium ⨝ payment`, MC `Lead_Car_Act_Discount_Premium ⨝ payment_act`, PA `lead_pa_participant ⨝ payment_transaction`, HOME `lead_home_participant ⨝ payment_transaction`, TA `lead_ta_participant ⨝ payment_ta`; `/all` and `/ta` save new addresses to `email_logs` (skip existing).
- Send routes read pending `email_logs`, pick the latest row in `email_api_keys`, post to ThaiBulk `send_template`, update status in `email_logs`.
- Webhook `POST /thaibulksms/webhook` body = ThaiBulk event → `INSERT email_webhooks`.
- API-key CRUD on `email_api_keys` (`{ name, api_key, api_secret, webhook_url, is_active }`); GET returns `api_key` and `api_secret` in clear.
Responses: JSON arrays / `{message}`; 400 bad body; 500 DB.

### 34–35. Payment checks
`POST /payment/check` (`dto.ReqCheckPayment`): `invoice_no*`, `type*` (`oneof=MV MC TA PA HOME`) → reads `payment` / `payment_act` / `payment_ta` / `payment_transaction` joined to the lead table → `{ PaymentID, InvoiceNo, LeadNo, Amount, Method, Description, IsInstallment, status… }` ⚠️ exact field list partially read.
`POST /payment/check-renewal`: `{ invoice_no* }` → `payment` + `renewal_payments` → `{ result: bool }`.

### 37. `POST /encrypted`
Body `model.PolicyRequest`: `policy_no` or `car_act_no`. Reads `Policy_Header ⨝ Policy_coverage_premium ⨝ province` (or ACT) → `Aes256Encode(Lead_No)` with `KEY_AES256`/`IV_AES256` → `200 {…policy info, encrypted lead}`; 400 `Lead not found`. Public (S6).

### 38–43. Reports
Basic-auth promo reports build XLSX from `promo_code_trans`, `promo_code`, `Lead_coverage_premium`, `Policy_coverage_premium`, `Policy_Header`, `Policy_endorse_detail`, `payment`, `sec_user`, `province`, `mas_country`, `log_sf_policy_trans`, zip with a password (literal per env in code), send by SMTP. `send_daily_report` (no auth) uses `Policy_Header`, `Policy_Car_Act_Discount_Premium`, leads. Roadside report (`GetRoadsideActivationReport`: `Policy_Header`, `Policy_coverage_premium`, `province`, `district`) for classes `3` and `2+`. Response `{success}` / 500.
`POST /send_email` (Basic): `structs.SendEmail { sender*, subject*, content*, email*[] , cc[], attach[] }` → SMTP.
`POST /bigquery_policy_daily`: `structs.PolicyDialyLastVersion` (≈46 fields: `reportdate_issued, dfpolicyno, new_renew, …, provinceaddress`) → BigQuery `INSERT` with named parameters.

### 44–47. Renewal
`/renewal/process`: multipart `file` (Excel) → `renew_policy_batches`, `renew_policy_records`; per row premium API (`api/v1/premium/premiumAPI`), lead-policy API, purchase `create-payment-renewal` / `create-payment-act`, `renewal_payments`, `renew_promocode_percent`, `promo_code(_trans)`; summary email to `RENEWAL_REPORT_EMAILS`. `/renewal/batch/:id?page&pageSize` → batch + records. `/renewal/summary-link` `{ policy }` → AES link (`SUMMARY_LINK_KEY/IV`, `PWA_BASE_URL`) + WordPress short link. `/renewal/excel-links`: multipart `file` → returns Excel with links ⚠️ response type unverified.

### 48–52. Misc
- `priceza_log` (`structs.RequestData`: `c, t, m, p, v, f, d` (invoice no.), `u` (URL), `clickid` — all strings) → `SELECT EXISTS … log_priceza WHERE d=$1 AND t=$2`, else `INSERT log_priceza (c,t,m,p,v,f,d,u,clickid)`.
- `check_date_limit` (`{ fn, data }`) → `mas_limite_purchase WHERE period_name='MV-MC'` → `{ allowed/limit date }` ⚠️.
- `log-request/*` (any method) → logs body, returns `{message, path}`.
- `cmi_policy` (Basic, `structs.CMIPolicyRequest`: `companyCode, policyNumber, contractDt, effectiveDt, endDt, vehicleTypeCode, registeredProvinceCode, plateNumber, chassisVINNumber, insuredUniqueID, insuredName, insuredSurname, country, agentBrokerLicenseNumber, vehicleColor, vehicleBrandName, vehicleModelName`) → brand/model lookup in `mas_cmi_brand_model` → `POST CMIPolicyAPIEnv` with security header → `JsonReturn`.
- `short_link` `{ url }` → WordPress short link.

### 55. `POST /shopee/callback`
Shopee push (order status). No signature / `Authorization` HMAC verification found (S5). Writes `callback_logs`; for ready orders fetches order detail + buyer invoice info, builds a form link (`short_link_mapping`) and sends SMS.

### 68–71. CAPI, payment callback, premium
`facebook/capi/send_event` (`SendEventInput`: `event_name` `oneof=Purchase Lead GetQuote`, `invoice_no` (required for Purchase), `lead` (for Lead), `fbp*`, `fbc*`; IP / UA from request) → reads `payment_callback` → Meta CAPI.
`payment_callback/find_by_invoice_no` `{ invoice_no* }` → `payment_callback` row(s) (includes 2C2P callback JSON ⚠️).
`premium/act_api` ignores the body and uses a hard-coded lead id; `premium/premium_api` → premium API.

### 76–77. Proxy
`ANY /proxy/*` → `httputil.NewSingleHostReverseProxy("https://thumb--d.insurverse.co.th/API_IIA_Bigquery")` + path; request headers are logged. `POST /test` → fixed POST to `…/lastversionpolicies/rowcount`.

### 78. `POST /oauth/token` — Shopee ACT (พ.ร.บ.) purchase
**Body** (`MotorRequest`, in `oauth_controller.go`): `compCode, brand, model, year, startDate, carSerialNo, carColor, carLicenseType, carLicenseNo, carLicenseProvince, flagDeli, prefixName, firstName, lastName, birthDate, citizenId, deliAddrLine1, deliAddressNo, deliZipcode, deliProvinceId, deliDistrictId, deliSubdistrictId, address, provinceId, districtId, subdistrictId, zipcode, doors, seat, cc, wg, order_sn, email, phone, bodyType, group, sedan, occupationCode, occupation, marketingPurposes[]`.
Steps: ensure `callback_logs` / `policy_form_submissions` row → stop if form already completed → (prod) Shopee order ready check → OAuth client-credentials (`CLIENT_ID/SECRET`) → ensure `sec_user` (direct `INSERT insurverse.sec_user` or `api/v1/user/isvregisterauto`) → userinfo → e-API comp brand/model/year/premium → `lead/comp-motor` → save leadNo → `agreement/marketing` → `payment/request` → save invoiceNo → `payment/success` → find policy → `UPDATE "Policy_Car_Act_Discount_Premium"` → trigger ACT policy + e-Tax receipt docs → mark form completed. All e-API calls logged to `api_flow_log`.
**Responses:** `200 {…lead/policy/invoice info}`; 400 validation / order not ready / already completed; 500 per step `{error:"<step> error: …"}`.

### 79. `POST /mc/policy` — free ACT ("bypass")
Same shape as #78 but uses `ClientIDBPMC/ClientSecretBPMC`, and has **no** Shopee order check, no form-completed check, no auth: lead → consent → `payment/request` → `payment/success` → docs. Called internally by the HBD sync (#82) for birthday promo policies (`hbdisv_event` log). See S2.

### 81. `POST /mv/submit` — Shopee voluntary motor
Body `MVPolicyRequest` (45 JSON fields; car, insured, address, package, order_sn…). Same pattern as #78 with `lead/motor`, premium load, `UPDATE "Policy_coverage_premium"` / `"Policy_Car_Act_Discount_Premium"`, MV + ACT docs.

### 82. `GET /hbdisv/triger`
409 if already running; else 202 and background job: `getNewPolicies` (`Policy_Header`, `Policy_coverage_premium`, `promo_code_trans`, `promo_code`, `payment`), build payload (`Imp_Discount_Premium`, `Lead_coverage_premium`), `INSERT/UPDATE hbdisv_event`, `POST {OAUTH_URL}/api/v1/isv-test/mc/policy`.

### 83. `POST /policy/pdf`
`dto.PolicyRetrievalRequest`: `id_type*`, `id_number*`, `policy_number*`, `recaptcha_token*` → reCAPTCHA → SOAP `CheckPolicyData` (`POLICY_SERVICE_URL`) → `200 {success, message, policy_number, insured_name, product_name, effective_date, expiry_date, url:""}`; 404 not found.

### 84–90. Batch renewal payment
`process` `{ batch_size }` (`min=1,max=1000`, default 100): `renewal_payments` without invoice → match payment by URL (`payment`) → `Policy_Header`/`Lead_coverage_premium` → `POST {Base_Url}api/v1/uam/create_policy_form` → `UpdateRenewalPaymentInvoice`; errors → `batch_payment_errors`. `retry` `{ batch_id* }`, `process/:id`, `status`, `count`, `status-distribution`, `errors?limit=`.

---

## DB Usage (schema `insurverse`)

| Table / function | R/W | Endpoints |
|---|---|---|
| `consent_marketing`, `lead_consent` | R/W/D | #3–#5, #6 |
| `request_contact` | R/W/D | #6–#8 |
| `email_logs` | R/W/D | #13–#19, #15, #25–#27 |
| `email_webhooks` | R/W/D | #20–#24 |
| `email_api_keys` | R/W/D | #27–#33 |
| `Lead_coverage_premium`, `Lead_Car_Act_Discount_Premium`, `lead_pa_participant`, `lead_home_participant`, `lead_ta_participant` | R | #9–#14, #34, #84 |
| `payment`, `payment_act`, `payment_ta`, `payment_transaction` | R | #9–#14, #34, #35, #82, #84 |
| `payment_callback` | R | #68, #69 |
| `Policy_Header`, `Policy_coverage_premium`, `Policy_Car_Act_Discount_Premium`, `Policy_endorse_detail` | R/W (UPDATE after Shopee flows) | #37, #38–#43, #78, #81, #82, #84 |
| `promo_code`, `promo_code_trans`, `sec_user`, `province`, `district`, `subdistrict`, `zipcode`, `mas_country`, `log_sf_policy_trans`, `Imp_Discount_Premium` | R (`sec_user` also INSERT) | reports, #78, #81, #82 |
| `renewal_payments`, `batch_payment_errors` | R/W | #35, #84–#90 |
| `renew_policy_batches`, `renew_policy_records`, `renew_promocode_percent`, `sf_claim_coverage` | R/W | #44–#47 |
| `callback_logs`, `policy_form_submissions`, `policy_form_templates`, `short_link_mapping` | R/W | #55, #61, #78, #79 ⚠️, #81 |
| `shopee_app_authorized`, `shopee_app_access_token`, `shopee_product_form` | R/W | #53, #54, #58, #64–#66, token refresher |
| `api_flow_log` | W | #78–#81 |
| `hbdisv_event` | W | #82 |
| `log_priceza` | R/W | #48 |
| `mas_limite_purchase` | R | #49 |
| `mas_cmi_brand_model` | R | #51 |
| `iia_data_sr_claim_motor_movement`, `iia_data_sr_claim_nonmotor_movement`, `iia_data_sr_nonmotor_claim_lastversion` | DDL + R | #72–#74 |
| BigQuery `insurverse-uat.RAW_IIA.PolicyDialyLastVersion` | W | #41 |
| Stored functions | – | **None called** from Go (no `fn_*` in code). |

Migrations in `migration/`, `migrations/`, `db/migrations/` (Shopee token / form tables, renew policy tables, callback logs, batch payment errors, policy form submissions, email tables) — not executed by the service at startup ⚠️.

---

## Notes / ⚠️ unverified items (security findings first)

- **S1 ⚠️ Hard-coded secrets.** `constant/config.go` fallbacks (e.g. `ADMIN_USERNAME`/`ADMIN_PASSWORD`, `KEY_AES256`, `CLIENT_SECRET`, `SHOPEE_APP_PARTNER_KEY`) and `constant/constant.go` literals (SMS / OneSignal / SMTP / email-API keys, BPMC client secret, `CredentialJson`) are in source; report ZIP passwords are literals in `controller/report.go`. Values not copied here. Rotate + move to secrets.
- **S2 ⚠️ Free policy issuance.** `POST /mc/policy` has no auth and no order / payment check; it calls e-API `payment/request` then `payment/success` with the BPMC client, so any caller can get an ACT (พ.ร.บ.) issued without paying. `oauth/token` and `mv/submit` skip the Shopee order check outside `prod`, and in `prod` accept any `order_sn` with the test prefix. (Whether e-API `payment/success` enforces anything for these clients was not checked — ⚠️ confirm.)
- **S3 ⚠️ Secret disclosure.** `GET /thaibulksms/api_keys` and `/api_keys/:name` return ThaiBulk `api_key` + `api_secret` to anyone; CRUD / delete-all on keys, email logs, webhooks and consents is open.
- **S4 ⚠️ Open reverse proxy** `ANY /proxy/*` to the IIA BigQuery API (hard-coded host) with no auth; request headers are logged.
- **S5** Shopee push `POST /shopee/callback` and ThaiBulk webhook do not verify signatures.
- **S6** PII exposure without auth: `consent/all`, `request-contact/all`, `payment/check`, `payment_callback/find_by_invoice_no`, `encrypted` (turns a policy number into the encrypted lead token used by payment/renewal links).
- **S7** `GET /movement/create_table*` run DDL on the production schema when called.
- **S8** CORS falls back to `*` with `AllowCredentials: true` when `CORS_ALLOWED_ORIGINS` is empty (Echo only reflects the origin if `UnsafeWildcardOriginWithAllowCredentials` is set — ⚠️ behaviour depends on Echo version).
- **S9** Basic auth compares strings with `!=` (timing) and the credentials have literal fallbacks.
- **S10** DB connection uses `sslmode=disable`.
- **N1** `bigquery_policy_daily` is registered twice (same handler); BigQuery table name is hard-coded to the UAT project.
- **N2** Several routes are scaffolding / tests left in the router: `GET /test`, `POST /test`, `/test/request-body`, `/log-request/*`, `/premium/*` (hard-coded lead), `/shopee/selects`, `/movement/*`.
- **N3** `hbdisv/triger` (typo in path) calls this same service over the public `OAUTH_URL` host.
- **N4** Response shapes marked ⚠️ were inferred from code, not observed. Table/column names come from SQL text in Go only; **not** verified against the live schema — ⚠️ unverified.
