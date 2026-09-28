# go-echo-backoffice-service — API Spec

Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-backoffice-service` (read-only review, 2026-09-23).
Everything below was traced from route registration code (`main.go`, `router/*.go`) through handler, usecase and repository. Items that could not be confirmed from code alone are marked "⚠️ unverified".

---

## Overview

| Item | Value |
|---|---|
| Purpose | Back-office API for the InsurVerse (ISV) admin portal: Keycloak login with e-mail OTP, promotion / loyalty (promo code) management and reports, promo/loyalty cron triggers, TQM broker integration (car inspection, VMI/CMI policy problems, premium table imports), blacklist maker/checker workflow, policy-by-province report, province master data |
| Framework | Go, Echo v4 (`github.com/labstack/echo/v4`), `sqlx` + `lib/pq` (PostgreSQL), `gocloak/v13` (Keycloak), `excelize/v2` (Excel), `cloud.google.com/go/storage` (GCS) |
| Validator | `github.com/go-playground/validator` (v9 API) wrapped in `router.CustomValidator` (validation errors become HTTP 400) |
| Port | `HTTP_PORT` env, default `8080` (`main.go:83-86`; Dockerfile `EXPOSE 8080`) |
| Base path | `constant.API_V_SERVICE` = `/api/v1/backoffice/` (`constants/constant.go:25`). Exceptions: `/healthcheck`, `/swagger/*`, and the admin delete-user route (see below) |
| Global middleware | `middleware.Recover()`; CORS `AllowOrigins: *`, methods GET/PUT/POST/DELETE (`main.go:48-53`). Request logger is commented out |
| Response envelope (legacy + TQM/report) | `models.JsonReturn` = `{ "status": int, "result": any, "title"?: string, "description"?: string }` |
| Response envelope (blacklist) | Plain DTOs on success; errors `{ "errorCode": "BLxxxxx", "errorDescription": "..." }` |

### Environment variables (names only)

Read by code (`os.Getenv`):

| Name | Used for | Notes |
|---|---|---|
| `HTTP_PORT` | listen port | default 8080 |
| `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME` | PostgreSQL connection (`configs/config.go`, `webserver/dbConnect.go`) | fall back to hardcoded constants in `constants/constant.go` if unset |
| `Keycloak_Host` | Keycloak base URL for gocloak client (`webserver/kcConnect.go:40`) | read directly; config.go also reads it into an unused local |
| `KC_USER`, `KC_PASS` | Keycloak master-realm admin login (OTP endpoints) | hardcoded fallback in `configs/config.go` |
| `KEY_AES256`, `IV_AES256` | AES-256-CBC encryption of Keycloak JWTs stored in `insurverse.jwt_tokens` | hardcoded fallback in `configs/config.go` |
| `GCS_BUCKET` | GCS bucket for promotion images and inspection-image signed URLs (`webserver/gcpConnect.go:28`) | |
| `Base_Url` | stored in `configs.Base_UrlEnv` | not referenced by any route |
| `Backend_Notification` | read in `configs/config.go:51` into a local variable only | NOT used: cron endpoints use the hardcoded `constant.Backend_Notification` |
| `BLACKLIST_IT_DSN` | integration test only (`repository/blacklist_integration_test.go`) | not used at runtime |

Helm files (`helm/helm-*.yaml`) additionally inject `ENV`, `Backend_Analytics`, `Backend_Auth`, `Backend_Consent`, `Backend_Core`, `Backend_Doc`, `Backend_File`, `Backend_Premium`, `Backend_Purchase`, `Backend_Saleforce`, `Backend_Uam`, `SF_*`, `Token_EKYC_*`, `URL_CMI_Realtime_Policy*`, `URL_YIP_*`, `Url_Fontend`, `Url_IIA`, `YIP_EKCY` — none of these are read by this service's code.

GCS credentials are read from the file `key.json` in the working directory (`webserver/gcpConnect.go:24`, `utils/utils.go GenerateGCPSignedURL`).

### External / third-party calls

| Target | How | Used by |
|---|---|---|
| Keycloak (realm `isv-backoffice`, client `isv-backoffice-client`) | gocloak `DecodeAccessToken` (every protected request), `Login`, `RefreshToken` | middleware, `/login`, `/refresh_token` |
| Keycloak master realm admin API | gocloak `LoginAdmin` (KC_USER/KC_PASS) then `GetUsers` on realm `isv-backoffice` | `/request_otp`, `/verify_otp`, `/verify_otp_and_return_jwt` |
| SMTP relay | `net/smtp.SendMail` to hardcoded host `mail.dhipaya.co.th:25`, no auth (`utils/email.go:40-100`) | `/request_otp` (OTP e-mail, HTML template) |
| Google Cloud Storage | `UploadFileToGCP` (base64 payload -> object `promotion/<file>`, returns `https://storage.googleapis.com/<bucket>/promotion/<file>`); `GenerateGCPSignedURL` (1 h signed GET URL) | promotion/loyalty create & update; `/tqm/get-car-inspect-list` |
| Notification service | `utils.HTTP` to hardcoded `constant.Backend_Notification` (`https://isv-api-dev.flybkk.com/api/v1/notification/`): `GET messaging_fix`, `POST get_noti_point_expire` | cron endpoints `noti_daily_promo_code`, `update_point_expire`, `update_point_expire_noti` |

### Background jobs

| Job | Where | What |
|---|---|---|
| Expired JWT cleanup | goroutine in `main.go:66-72`, `time.NewTicker(1 * time.Hour)` | `SELECT insurverse.fn_cleanup_expired_jwt()` (`webserver/jwt_db.go:167`) |
| Promo/loyalty cron jobs | NOT scheduled in this service. Four unauthenticated HTTP endpoints are meant to be called by an external scheduler (schedules documented only in code comments, `router/router.go:91-95`) | see "Cron trigger endpoints" |

No queue consumers found.

---

## Auth & Middleware

### `middlewares.ExtractTokenToGlobalVar()` (`middlewares/Validate.go:61`)
- Reads the `Authorization` header and passes it **as-is** to `KCCon_Client.DecodeAccessToken(ctx, token, "isv-backoffice")`. ⚠️ unverified whether the client must send the raw token or `Bearer <token>`: the header value is not stripped of a `Bearer ` prefix; gocloak's decoder behaviour decides.
- On failure: HTTP 401 `{ "status": 401, "result": "<decode error>" }`.
- On success: stores the token and decoded claims into **package-level globals** `middlewares.Access_token` and `middlewares.JwtMapClaims`. Handlers read the username from `JwtMapClaims["preferred_username"]`.
- Concurrency caveat: these are shared globals, not per-request context. Concurrent requests can read another caller's claims (audit fields `create_by` / `update_by` / blacklist `created_by` can be wrong), and handlers that only check `Access_token != ""` pass for any caller once any earlier request succeeded.

### `middlewares.RequireBlacklistRole(roles...)` (`middlewares/blacklist_role.go:36`)
- Must run after `ExtractTokenToGlobalVar`. Reads `realm_access.roles` from `JwtMapClaims`.
- Roles: `blacklist_maker`, `blacklist_checker`.
- Failure: HTTP 403 `{ "errorCode": "BL40301", "errorDescription": "Caller is not allowed to perform this action" }`.

### In-handler check (legacy controllers)
Most `controllers/*` handlers begin with `if middlewares.Access_token == "" -> 401 { "status": 401, "result": "" }`. This is a check of the global, not of the current request.

### Unused middleware
`middlewares.ValidateAdminToken` (HS256 JWT via `utils.ParseClaims`) is defined but not attached to any route.

### Auth legend used below
- **None** — no middleware.
- **Global** — no middleware; handler only checks the `Access_token` global.
- **KC** — `ExtractTokenToGlobalVar`.
- **KC+maker / KC+checker / KC+both** — `ExtractTokenToGlobalVar` + `RequireBlacklistRole`.

---

## Endpoint Summary

Base prefix `P` = `/api/v1/backoffice/`. 53 registered routes (50 business routes + `/healthcheck` + 2 Swagger UI routes).

### Standard / auth (`router/router.go`)

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | None | router/router.go:46 `healthcheck` | Returns plain text `OK` |
| 2 | GET | `/swagger/*` | None | main.go:89 `echoSwagger.WrapHandler` | Swagger UI |
| 3 | GET | `P + swagger/*` | None | router/router.go:52 `echoSwagger.WrapHandler` | Swagger UI (duplicate mount) |
| 4 | POST | `P + login` | None | controllers/keycloakController.go:81 `LoginKeycloak` | Keycloak password login; stores encrypted JWT for OTP step |
| 5 | POST | `P + getuser_info` | KC | controllers/keycloakController.go:127 `GetUserInfo` | Returns decoded token claims |
| 6 | POST | `P + refresh_token` | None | controllers/keycloakController.go:20 `RefreshToken` | Keycloak refresh-token grant |
| 7 | POST | `P + get_product` | Global | controllers/promoController.go:28 `GetProduct` | Product / sub-product tree from `mas_policy_product` |
| 8 | POST | `P + request_otp` | None | controllers/otpController.go:82 `RequestOTP` | Send 6-digit OTP to the Keycloak user's e-mail |
| 9 | POST | `P + verify_otp` | None | controllers/otpController.go:247 `VerifyOTP` | Verify OTP, return locally signed JWT |
| 10 | POST | `P + verify_otp_and_return_jwt` | None | controllers/otpController.go:478 `VerifyOTPAndReturnJWT` | Verify OTP, return the Keycloak JWT stored at login |
| 11 | DELETE | `/v1/api/v1/backoffice/admin/user` | None | controllers/user.go:18 `DeleteUser` | Delete row from `public."User"` |

### Promotion / loyalty (`router/router.go`)

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 12 | POST | `P + get_promotion_id` | KC | controllers/promoController.go:107 `GetPromotionID` | Get one promo_code row |
| 13 | POST | `P + get_promotion` | KC | controllers/promoController.go:149 `GetPromotion` | Paged promo/loyalty search |
| 14 | POST | `P + create_promotion` | KC | controllers/promoController.go:258 `CreatePromotion` | Create promotion (+ unique codes) |
| 15 | POST | `P + update_promotion` | KC | controllers/promoController.go:493 `UpdatePromotion` | Update promotion (+ extra unique codes) |
| 16 | POST | `P + delete_promotion` | KC | controllers/promoController.go:683 `DeletePromotion` | Soft delete (status `INT`) |
| 17 | POST | `P + import_promotion_codes` | KC | controllers/importController.go:21 `ImportPromotionsFromExcel` | Bulk create promotions from Excel |
| 18 | POST | `P + export_promotions` | KC | controllers/exportController.go:30 `ExportPromotionsToExcel` | Download promotions as .xlsx (max 5000) |
| 19 | POST | `P + bulk_update_promotion_status` | KC | controllers/promoController.go:1840 `BulkUpdatePromotionStatus` | Set status ACT/INT for many ids |
| 20 | POST | `P + create_loyalty` | KC | controllers/promoController.go:740 `CreateLoyalty` | Create loyalty (redeemable) promo |
| 21 | POST | `P + update_loyalty` | KC | controllers/promoController.go:952 `UpdateLoyalty` | Update loyalty promo |
| 22 | POST | `P + delete_loyalty` | KC | controllers/promoController.go:1117 `DeleteLoyalty` | Soft delete (status `INT`) |
| 23 | POST | `P + get_loyalty_condition` | KC | controllers/promoController.go:1174 `GetLoyaltyCondition` | Paged `loyalty_condition` search |
| 24 | POST | `P + get_premium_redemption` | KC | controllers/promoController.go:1481 `GetPremiumRedemption` | Paged promo list with redeem/used counts |
| 25 | POST | `P + get_report_promo_code` | KC | controllers/promoController.go:1264 `GetReportPromoCode` | Promotion management report .xlsx |
| 26 | POST | `P + get_report_promo_code_id` | KC | controllers/promoController.go:1350 `GetReportPromoCodeID` | Per-promo code transaction report .xlsx |
| 27 | POST | `P + get_report_loyalty_management` | KC | controllers/promoController.go:1586 `GetReportLoyaltyManagement` | Loyalty management report .xlsx |

### Cron trigger endpoints (`router/router.go`)

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 28 | POST | `P + noti_daily_promo_code` | None | controllers/promoController.go:1659 `NotiDailyPromoCode` | Runs `fn_noti_daily_promo_code()` (comment: daily 10:00) |
| 29 | POST | `P + update_point_expire` | None | controllers/promoController.go:1706 `UpdatePointExpire` | Runs `fn_update_point_expire()` (comment: day 25, 10:00) |
| 30 | POST | `P + update_point_expire_noti` | None | controllers/promoController.go:1752 `UpdatePointExpireNoti` | Runs `fn_update_point_expire_noti()` + notification calls |
| 31 | POST | `P + update_promo_batch` | None | controllers/promoController.go:1804 `UpdatePromoBatch` | Runs `fn_update_promo_batch()` (comment: daily 09:00, expire promotions) |

### TQM (`router/tqm_router.go`, group `P + tqm`, all KC)

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 32 | POST | `P + tqm/update-car-inspect-status` | KC | handler/tqm_handler.go:25 `UpdateCarInspectStatus` | Save inspection images / car detail |
| 33 | POST | `P + tqm/update-policy-problem-vmi` | KC | handler/tqm_handler.go:274 `UpdatePolicyProblemVMI` | Correct VMI lead data |
| 34 | POST | `P + tqm/save-car-inspect` | KC | handler/tqm_handler.go:53 `SaveCarInspect` | Approve / report / reject an inspection |
| 35 | POST | `P + tqm/get-car-inspect-list` | KC | handler/tqm_handler.go:103 `GetCarInspectList` | Paged inspection list with signed image URLs |
| 36 | GET | `P + tqm/get-masterdata-problem` | KC | handler/tqm_handler.go:500 `GetMasterDataProblem` | Brand/model, color, plate-province masters |
| 37 | POST | `P + tqm/get-policy-problem-list` | KC | handler/tqm_handler.go:129 `GetPolicy` | Paged VMI/CMI request list |
| 38 | POST | `P + tqm/update-policy-problem-cmi` | KC | handler/tqm_handler.go:300 `UpdatePolicyProblemCMI` | Correct CMI lead + CMI policy |
| 39 | POST | `P + tqm/import-group-premium` | KC | handler/tqm_handler.go:160 `ImportGroupPremium` | Import group premium Excel |
| 40 | POST | `P + tqm/import-premium-detail` | KC | handler/tqm_handler.go:428 `ImportPremiumDetail` | Import premium detail Excel |

### Blacklist (`router/blacklist_router.go`)

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 41 | POST | `P + blacklist/list` | KC+both | handler/blacklist_handler.go:116 `ListEntries` | Paged blacklist entries |
| 42 | POST | `P + blacklist/detail` | KC+both | handler/blacklist_handler.go:150 `GetEntryDetail` | One entry |
| 43 | POST | `P + blacklist/remove/request` | KC+maker | handler/blacklist_handler.go:181 `CreateRemoveRequest` | Create REMOVE request for an active entry |
| 44 | POST | `P + blacklist-request/list` | KC+both | handler/blacklist_handler.go:211 `ListRequests` | Paged requests |
| 45 | POST | `P + blacklist-request/detail` | KC+both | handler/blacklist_handler.go:245 `GetRequestDetail` | One request |
| 46 | POST | `P + blacklist-request/add` | KC+maker | handler/blacklist_handler.go:262 `AddRequest` | Create ADD request |
| 47 | POST | `P + blacklist-request/edit` | KC+maker | handler/blacklist_handler.go:294 `EditRequest` | Edit own PENDING request |
| 48 | POST | `P + blacklist-request/delete` | KC+maker | handler/blacklist_handler.go:329 `DeleteRequest` | Delete own PENDING request |
| 49 | POST | `P + blacklist-request/resubmit` | KC+maker | handler/blacklist_handler.go:351 `ResubmitRequest` | Resubmit own REJECTED request |
| 50 | POST | `P + blacklist-request/approve` | KC+checker | handler/blacklist_handler.go:388 `ApproveRequest` | Approve PENDING request |
| 51 | POST | `P + blacklist-request/reject` | KC+checker | handler/blacklist_handler.go:415 `RejectRequest` | Reject PENDING request |

### Report and master data (`router/report_router.go`, `router/masterdata_router.go`)

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 52 | POST | `P + report/monthly-policy-by-province` | KC | handler/monthly_policy_province_handler.go:39 `GetReport` | Policies by province in a date window |
| 53 | GET | `P + masterdata/provinces` | KC | handler/masterdata_handler.go:33 `GetProvinces` | Province master |

---

## Endpoints

Conventions: "400 (validator)" means `c.Validate` failure; in legacy controllers this returns `{ "result": <validator error> }` with **HTTP 400 but `status` omitted/0**. `RespondError` (TQM/report/masterdata) returns `{ "status": <code>, "title": "error", "description": "<public msg>" }` and logs the internal error.

### 1. Standard / auth

#### GET `/healthcheck`
Plain text `OK` (200). No DB.

#### GET `/swagger/*` and GET `/api/v1/backoffice/swagger/*`
Swagger UI served from `docs/docs.go`. The generated spec is stale (see Notes).

#### POST `/api/v1/backoffice/login`
Purpose: username/password login against Keycloak realm `isv-backoffice`. The token is **not** returned; it is AES-256-CBC encrypted and stored for 15 min, to be released by `verify_otp_and_return_jwt`.

Request (`models.User`, `models/userModel.go:3`):
```json
{ "username": "backoffice.user", "password": "********" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| username | string | yes | `required` |
| password | string | yes | `required` |
| email, token, firstName, lastName | string | no | ignored |

Success 200:
```json
{ "status": 200, "result": { "success": true, "message": "Login successful, OTP verification required", "username": "backoffice.user" } }
```
Errors: 400 bind error (plain text); 400 validator; **Keycloak login failure returns HTTP 200** with `{ "status": 200, "result": <gocloak error object> }`; 500 `{ "status": 500, "result": "Failed to store JWT: ..." }`.
DB: `insurverse.jwt_tokens` (DELETE by username, INSERT encrypted token, expire_at = now + 15 min).
Outbound: Keycloak `Login` (client `isv-backoffice-client`, empty client secret).

#### POST `/api/v1/backoffice/getuser_info`
Purpose: echo the decoded Keycloak claims. No body read.
Success 200: `{ "status": 200, "result": { "sub": "...", "preferred_username": "...", "realm_access": { "roles": [ ... ] }, ... } }`
Errors: 401 from middleware. DB: none. Outbound: Keycloak token decode.

#### POST `/api/v1/backoffice/refresh_token`
Request (`models.UserInfo`): `{ "token": "<refresh_token>" }` (`token` tagged `required` but `Validate` is not called).
Success 200: `{ "status": 200, "result": { "access_token": "...", "expires_in": 300, "refresh_token": "...", "refresh_expires_in": 1800, "token_type": "Bearer", ... } }` (gocloak `JWT`).
Errors: 400 plain text `bad request params`; 401 `{ "status": 401 }` on Keycloak error.
Outbound: Keycloak `RefreshToken`.

#### POST `/api/v1/backoffice/get_product`
Purpose: active product / sub-product tree. Body ignored.
Auth: no middleware — only checks the `Access_token` global (see Notes).
Success 200:
```json
{ "status": 200, "result": [
  { "productCode": "motor", "productNameTh": "...", "productNameEn": "...", "subProductCode": "", "subProductNameTh": "", "subProductNameEn": "",
    "subProductDetail": "[{\"sub_product_code\":\"...\",\"sub_product_name_th\":\"...\",\"sub_product_name_en\":\"...\",\"priority\":1}]" }
] }
```
`subProductDetail` is a JSON **string** (CAST to TEXT in SQL).
Errors: 401 `{ "status": 401, "result": "" }`; 400 on SQL error.
DB: `insurverse.mas_policy_product` (read, `is_active = true`).

#### POST `/api/v1/backoffice/request_otp`
Purpose: look up the Keycloak user, enforce a per-day OTP quota, create a 6-digit OTP + 8-char ref code (valid 15 min) and e-mail it.

Request (`models.VerifyUsernameAPI`): `{ "username": "backoffice.user" }` — `username` required (checked manually).

Success 200:
```json
{ "status": 200, "result": { "success": true, "message": "OTP has been sent to your email", "ref_code": "AB12CD34", "expiry_minutes": 14.99, "email": "user@example.com" } }
```
Errors (all `JsonReturn`): 400 invalid format / missing username / user has no e-mail; 404 `User not found`; 429 `Daily OTP request limit exceeded`; 500 Keycloak admin login / lookup / DB / e-mail failure (internal error text is included in `result`).
DB: `insurverse.otp_daily_requests` (read count for CURRENT_DATE; upsert +1), `insurverse.otp_settings` (read `otp_max_daily_requests`, default 5), `insurverse.otp_verification` (INSERT) — in one transaction.
Outbound: Keycloak master `LoginAdmin` + `GetUsers` (realm `isv-backoffice`, exact username); SMTP e-mail.

#### POST `/api/v1/backoffice/verify_otp`
Request (`models.VerifyUsernameOtpAPI`):
```json
{ "username": "backoffice.user", "otp": "123456" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| username | string | yes | `required` |
| otp | string | yes | `required` |

Flow: Keycloak user -> e-mail -> unverified `otp_verification` row for that e-mail -> expiry check -> max 3 attempts -> increment `attempt_count` -> on match set `is_verified = TRUE, verified_at`, reset today's `otp_daily_requests.request_count = 0` -> return a **locally signed HS256 JWT** (`utils.NewClaims(email)`, 4320 h expiry, issuer `thaipost`).

Success 200 (note: plain map, not `JsonReturn`):
```json
{ "status": 200, "result": { "success": true, "message": "OTP verification successful", "jwt": "<HS256 token>", "email": "user@example.com", "attempts_left": 2 } }
```
Errors: 400 `{ "status": 400, "message": "..." }` (bind/validate), 400 `{ "success": false, "message": "OTP not found" | "OTP expired", "attempts_left": 0 }` (JsonReturn), 400 `{ "status": 400, "message": "Invalid OTP. OTP will expire in m minutes and s seconds.", "attempts_left": n }`, 404 user not found, 429 `Account is temporarily locked due to too many failed attempts`, 500.
DB: `insurverse.otp_verification` (read, update), `insurverse.otp_daily_requests` (update).
Outbound: Keycloak admin `LoginAdmin` + `GetUsers`.

#### POST `/api/v1/backoffice/verify_otp_and_return_jwt`
Same request and OTP rules as `verify_otp`, but first loads the encrypted Keycloak JWT saved by `/login` (`GetJWTFromDB(username)`, must be unexpired) and, on success, deletes it and returns it.

Success 200:
```json
{ "status": 200, "result": { "success": true, "message": "OTP verification successful",
  "jwt": { "access_token": "...", "expires_in": 300, "refresh_token": "...", "refresh_expires_in": 1800, "token_type": "Bearer", "session_state": "...", "scope": "..." },
  "email": "user@example.com", "attempts_left": 2 } }
```
Errors (JsonReturn): 400 bind/validate/OTP not found/expired/invalid; 404 no stored JWT (login not done or >15 min) or user not found; 429 locked; 500.
DB: `insurverse.jwt_tokens` (read, delete), `insurverse.otp_verification`, `insurverse.otp_daily_requests`.
Outbound: Keycloak admin `LoginAdmin` + `GetUsers`.

#### DELETE `/v1/api/v1/backoffice/admin/user`
Path is built by `GenApiVersion("/api/v1/backoffice/admin/user")` = `"/v1" + path` (`router/router.go:31,98`), so the real path is `/v1/api/v1/backoffice/admin/user`. **No authentication.**
Request (`models.DeleteUserAPI`): `{ "user": "username" }` — `user` required.
Success 200: `{ "status": 200, "title": "Success", "result": "" }` (DB errors are ignored — always 200 after validation).
Errors: 400 plain text.
DB: `public."User"` DELETE WHERE `"uUserName"` = user. ⚠️ unverified: whether `public."User"` exists in the target DB.

### 2. Promotion / loyalty

Common request model for create/update (`models/promoModel.go`):

| Field (json) | Type | Required | Notes |
|---|---|---|---|
| promo_code_status | string | yes | e.g. `ACT`, `INT` |
| promo_code_name | string | yes | |
| promo_code_desc | string | yes | |
| active_start_date | RFC3339 time | yes | |
| active_end_date | RFC3339 time | yes | |
| promo_code_prefix | string | yes | duplicate check when status `ACT` (promotion only) |
| promo_group_id | int | yes (non-zero) | |
| promo_code_type | string | yes | `unique` generates codes into `promo_code_trans` |
| promo_code_id | int | no (create) / used as key (update) | |
| number_quota, number_quota_user | int | no | number_quota = count of generated unique codes on create |
| prem_type, prem_prod_code, prem_prod_qty, prem_prod_name, prem_prod_desc | string | no | |
| prem_value, min_amt | number | no | |
| promo_start_date, promo_end_date | sql.NullTime | no | ⚠️ unverified JSON shape (`sql.NullTime` has no custom JSON unmarshaller; clients must send `{"Time": "...", "Valid": true}`) |
| promo_code_url, cta_url, promo_banner_url | string | no | if non-empty, treated as base64 and uploaded to GCS; replaced with GCS URL on success (failure silently keeps input) |
| suggest_status, flag_auto_code, auto_length, cta_label_button, term_condition_desc, promo_screen_status | string | no | |
| priority | int | no | |
| product_group_type, product_sub_type | string | no | joins to `mas_policy_product` |
| redeem_point | string (create) / *string (update) | no | loyalty points; if set on create, `redeem_status` becomes `ACT` |
| redeem_status | string | no | overwritten server-side on create |
| number_quota_increase | int | update only | if >0 and type `unique`, generates that many extra codes |
| create_by, update_by, create_date, update_date | — | ignored | set server-side from token/now |

#### POST `get_promotion_id`
Request: `{ "promo_code_id": 123 }` (required).
Success 200: `{ "status": 200, "result": { "data": [ { "promo_code_id": 123, "promo_code_prefix": "NEWYEAR", "promo_code_status": "ACT", "...": "all promo_code columns" } ] } }`
Errors: 401 global check; 400 validator / SQL. DB: `insurverse.promo_code` read.

#### POST `get_promotion`
Request (`SearchPromoCodeLoyalty`, no validation tags):
```json
{ "type": "promotion", "page": 1, "limit": 10, "promo_code_prefix": "NEW", "product_group_type": "motor", "product_sub_type": "", "active_start_date": "2026-01-01", "active_end_date": "2026-12-31", "promo_code_name": "" }
```
`type`: `promotion` (redeem fields NULL) / `loyalty` (redeem fields NOT NULL) / other = all. `promo_code_name` is accepted but not used. Date filter applies only if both dates set (overlap test).
Success 200: `{ "status": 200, "result": { "total": 42, "data": [ { "promo_code_id": "1", "promo_code_status": "ACT", "promo_code_name": "...", "product_name_th": "...", "sub_product_name_th": "All", "active_start_date": "...", ... } ] } }`
Errors: 401, 400. DB: `insurverse.promo_code`, `insurverse.mas_policy_product` (read). Security: filter values are string-concatenated into SQL (see Notes).

#### POST `create_promotion`
Request: model above. Flow: validate -> duplicate prefix check (`query_validate_promocode`, overlapping active window, same product) when prefix set and status `ACT` -> GCS uploads -> INSERT `promo_code` RETURNING id -> if `promo_code_type = unique`, generate `number_quota` codes (`utils.GenerateCodePromo`) and bulk INSERT `promo_code_trans` (status `ACT`) via a package-global transaction (`utils.Start_sql_trans` / `utils.Sql_trans`).
Success 200: `{ "status": 200, "result": { "promo_code_status": "ACT", "promo_code_name": "...", "promo_code_id": 0, "...": "echo of inserted fields (id not populated)" } }`
Errors: 401; 400 bind / validator / `{ "status": 400, "title": "Promotion Code มีในระบบแล้ว" }` duplicate / INSERT error text; 500 duplicate-check SQL or code generation failure; username missing in claims -> 400.
DB: `insurverse.promo_code` (read, insert), `insurverse.promo_code_trans` (insert). Outbound: GCS upload.

#### POST `update_promotion`
Request: `UpdatePromoCode` (model above, `promo_code_id` is the key). Flow: duplicate check (as create) -> optional extra unique codes (`number_quota_increase`) -> GCS uploads -> UPDATE all columns incl. `redeem_point`.
Success 200: `{ "status": 200, "title": "Update promotion success", "result": "" }`
Errors: as create. DB: `promo_code` (read, update), `promo_code_trans` (insert). Outbound: GCS.

#### POST `delete_promotion` / POST `delete_loyalty`
Request: `{ "promo_code_id": 123 }` (required).
Effect: `UPDATE promo_code SET promo_code_status='INT', update_date=now, update_by=<user>`.
Success 200: `{ "status": 200, "title": "Delete promotion success", "result": "" }` (same title for loyalty).
Errors: 401, 400. DB: `insurverse.promo_code` write.

#### POST `create_loyalty`
Same as `create_promotion` but: no duplicate prefix check; `redeem_point` string parsed to int and stored (with `redeem_status='ACT'`) when non-empty; always inserts `redeem_point`.
Success 200: `{ "status": 200, "result": { ...inserted fields... } }`. DB: `promo_code`, `promo_code_trans`. Outbound: GCS.

#### POST `update_loyalty`
Same as `update_promotion` without duplicate check. Success 200 `{ "status": 200, "title": "...", "result": "" }` ⚠️ unverified exact title text (not read). DB: `promo_code`, `promo_code_trans`. Outbound: GCS.

#### POST `import_promotion_codes`
Content-Type `multipart/form-data`, field `file` (.xlsx/.xls). First sheet, row 1 = headers (normalised). Required columns: `promo_code_prefix`, `promo_group_id`, `promo_code_name`, `promo_code_desc`, `active_start_date`, `active_end_date`. Optional columns: `promo_code_id, promo_code_status, promo_code_type, number_quota, number_quota_user, prem_type, prem_value, prem_prod_code, prem_prod_qty, prem_prod_name, prem_prod_desc, promo_start_date, promo_end_date, promo_code_url, suggest_status, flag_auto_code, auto_length, redeem_point, min_amt, cta_label_button, cta_url, promo_banner_url, term_condition_desc, priority, product_group_type, product_sub_type, promo_screen_status`.
Each row -> `CreatePromoCode_View` -> validate -> INSERT (`createPromotion`, + `promo_code_trans` for unique). No duplicate-prefix check.
Success 200:
```json
{ "status": 200, "title": "นำเข้าข้อมูลสำเร็จ", "result": { "success": 10, "failed": 1, "failed_rows": [ { "row": 5, "error": "..." } ] } }
```
⚠️ unverified exact keys inside `failed_rows` items.
Errors: 401; 400 missing user / no file / wrong extension / unreadable / empty sheet / missing column (Thai messages); 500.
DB: `promo_code` insert, `promo_code_trans` insert.

#### POST `export_promotions`
Body ignored. Returns `.xlsx` (`promotions_export_YYYYMMDD_HHMMSS.xlsx`) with id, prefix, name, desc, status, active dates, created_by, create_date for up to 5000 rows (newest first).
Errors: 401 `{ "status": 401, "result": "Unauthorized" }`; 500 query/Excel error (error text returned).
DB: `insurverse.promo_code` read.

#### POST `bulk_update_promotion_status`
Request:
```json
{ "promo_code_ids": [101, 102], "status": "INT" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| promo_code_ids | int[] | yes | `required`, non-empty |
| status | string | yes | must be `ACT` or `INT` |

Success 200: `{ "status": 200, "title": "Updated status of 2 promotion codes to INT", "result": { "updated_count": 2, "status": "INT" } }`
Errors: 401; 400 validation / invalid status / empty ids; 500 DB (error text returned).
DB: `insurverse.promo_code` UPDATE (transaction; ids formatted from ints into `IN (...)`).

#### POST `get_loyalty_condition`
Request (`SearchLoyaltyCondition`): `{ "group_type": "", "sub_group_type": "", "loyalty_con_name": "", "loyalty_point_type": "", "loyalty_con_status": "", "effective_startdate": "", "effective_enddate": "", "page": 1, "limit": 10 }`
Success 200: `{ "status": 200, "result": { "total": n, "data": [ { "loyalty_con_id": 1, "loyalty_con_name": "...", "group_type": "...", "amt_min": 0, "amt_max": 0, "amt_per_point": 0, "point_earn": 0, "effective_startdate": "...", "loyalty_point_type": "...", "point_earn_min": 0, "point_earn_max": 0, "loyalty_con_status": "..." } ] } }` ⚠️ unverified exact result wrapper (tail of handler not read in full; pattern matches `get_promotion`).
DB: `insurverse.loyalty_condition` (read), `insurverse.promo_code` (count — see Notes, count is from the wrong table).

#### POST `get_premium_redemption`
Request (`SearchReportPromoCode`): `{ "type": "loyalty", "page": 1, "limit": 10, "promo_code_name": "", "promo_code_prefix": "", "product_group_type": "", "product_sub_type": "", "active_start_date": "", "active_end_date": "" }`
Success 200: `{ "status": 200, "result": { "total": n, "data": [ { "promo_code_id": 1, "...": "promo_code columns", "update_date": "YYYY-MM-DD HH24:MI:SS", "promo_redeem_count": 3, "promo_used_count": 1 } ] } }`
DB: `insurverse.promo_code`, `insurverse.promo_code_trans` (read).

#### POST `get_report_promo_code`
Body ignored. Returns `.xlsx` (`<nanos>_report_promocode.xlsx`) of promotions (redeem fields NULL): row number, product, sub product, names TH/EN, status, name, description, start/end (DD/MM/YYYY, +7 h).
DB: `promo_code`, `mas_policy_product`.

#### POST `get_report_promo_code_id`
Request: `{ "promo_code_id": 123 }` (required). Returns `.xlsx` of code transactions for that promo (booker, payer, owner, policy no, redeem/used dates, product names) using `constant.Report_promo_code_trans`.
DB (read): `promo_code`, `promo_code_trans`, `sec_user`, `mas_policy_product`, `Policy_coverage_premium`, `Policy_Header`, `Policy_Car_Act_Discount_Premium`, `policy_ta_premium`, `lead_ta_participant`, `policy_pa_premium`, `lead_pa_participant`, `policy_home_premium`, `lead_home_participant`.

#### POST `get_report_loyalty_management`
Body ignored. Returns `.xlsx` of loyalty promos (redeem fields NOT NULL). DB: `promo_code`.

### 3. Cron trigger endpoints (no auth, no body)

| Endpoint | DB function | Other DB | Outbound | Success |
|---|---|---|---|---|
| `noti_daily_promo_code` | `SELECT rtn_success, rtn_msg, rtn_json_promo FROM insurverse.fn_noti_daily_promo_code()` | INSERT `insurverse.log_point_expire` (remark `cronjob`) | GET `{Backend_Notification}messaging_fix` | `{ "status": 200, "result": { "data": { ... } } }` |
| `update_point_expire` | `SELECT rtn_success, rtn_msg, rtn_json_point FROM insurverse.fn_update_point_expire()` | INSERT `log_point_expire` | GET `messaging_fix` | `{ "status": 200, "result": { "data": { "prem_prod_name": true, "rtn_msg": "...", "rtn_json_point": "..." } } }` (note: `rtn_success` is serialised under json key `prem_prod_name`) |
| `update_point_expire_noti` | `SELECT insurverse.fn_update_point_expire_noti() AS result` | INSERT `log_point_expire` | GET `messaging_fix`, POST `get_noti_point_expire` | `{ "status": 200, "result": { "data": { "Result": true } } }` |
| `update_promo_batch` | `SELECT * FROM insurverse.fn_update_promo_batch()` (rtn_success, rtn_error_code, rtn_msg, rtn_json_body) | — | — | 200 `{ "status": 200, "result": { "RtnSuccess": true, ... } }`; 500 when `rtn_success = false` |

Errors: 400 `{ "status": 400, "result": "" | "<http error>" }` on DB or notification failures. ⚠️ unverified: DB function signatures / bodies (not inspected in DB).

### 4. TQM (`/api/v1/backoffice/tqm/*`)

Request-status values (`constants/tqm.go`): `WAITING_INSPECTION, INSPECTED, WAITING_DOCUMENT, WAITING_CMI, DOCUMENTED, DATA_PROBLEM, INSPECTION_PROBLEM, SUCCESS, REJECTED, REPORTING, APPROVE, Unqualify, WAITING`. Terminal (updates blocked): `DOCUMENTED, SUCCESS, REJECTED`.

#### POST `tqm/update-car-inspect-status`
Request (`dto.TQMInspectionInput`):
```json
{ "data": {
  "inspectDetail": { "requestId": "SB123456",
    "imageDetailJson": [ { "imageName": "front", "imageType": "car", "imageStatus": "PASS", "imageResaon": "", "imagePartDetail": "", "imagePath": "https://storage.googleapis.com/bucket/x.jpg?X-Goog-Signature=..." } ] },
  "carDetail": { "carBrand": "TOYOTA", "carModel": "YARIS", "carColor": "01", "carLicense": "1กก1234", "carProvince": "กรุงเทพมหานคร",
    "accessParaCode": ["MV01"], "carOptionNotCovered": "" } } }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| data.inspectDetail.requestId | string | yes | `required` |
| data.inspectDetail.imageDetailJson[] | object[] | no | query string is stripped from each `imagePath` |
| data.carDetail.* | string / raw JSON (`accessParaCode`) | no | |

Flow: status of `requestId` (VMI) must not be terminal -> UPDATE `tqm_car_inspect_result` (image_detail_json, car_license, car_band, car_model, car_color, car_province) -> UPDATE `tqm_lead_vmi` (car_option_not_covered, access_para_code) -> if `carOptionNotCovered` non-empty, upsert `tqm_notification_job` (type `INSPECTION_PROBLEM`, status `WAITING`). The request status itself is not changed.
Success 200: `{ "status": 200, "title": "update car inspect status success", "description": "update car inspect status success", "result": null }`
Errors: 400 bind/validate or `update is not allowed for current status`; 500 other.
DB: `tqm_request_status` (read), `tqm_car_inspect_result`, `tqm_lead_vmi`, `tqm_notification_job` (write).

#### POST `tqm/save-car-inspect`
Request: `{ "data": { "requestId": "SB123456", "status": "APPROVE" } }` — both required; `status` (upper-cased) must be `APPROVE`, `REPORTING` or `REJECTED`.
Mapping: APPROVE -> `INSPECTED` (only if current status is `WAITING_INSPECTION`, otherwise silently no-op 200); REPORTING -> `INSPECTION_PROBLEM`; REJECTED -> `REJECTED`. For REPORTING/REJECTED a `tqm_notification_job` upsert ("Reject ยกเลิกใบงาน").
Success 200: `{ "status": 200, "title": "save car inspect success", "description": "save car inspect success", "result": null }`
Errors: 400 `{ "status": 400, "title": "update car inspect status failed", "description": "status is required" | "status must be one of REJECTED, REPORTING, APPROVE" }`; 400 `save car inspect failed` for any usecase error (incl. terminal status).
DB: `tqm_request_status` (read/update, insurance_type `VMI`), `tqm_notification_job` (upsert).

#### POST `tqm/get-car-inspect-list`
Request (no validation): `{ "filter": { "requestId": "", "inspectDate": "", "carLicense": "", "insureFullName": "", "status": "", "pageSize": 10, "pageNumber": 1 } }` — pageSize default 10, max 100.
Success 200:
```json
{ "status": 200, "title": "get car inspect list success", "result": { "totalItems": 1, "pageSize": 10, "pageNumber": 1, "items": [
  { "requestId": "SB123456", "insureFullName": "...", "carLicense": "...", "carBrand": "...", "carModel": "...", "carProvince": "...", "carColor": "...", "inspectDate": "...",
    "imageDetailJson": [ { "imageName": "...", "imageType": "...", "imageStatus": "...", "imageReason": "...", "imagePartDetail": "...", "imagePath": "<1h signed URL>" } ],
    "carDetail": { "carColor": "...", "carLicense": "...", "carProvince": "...", "carBand": "...", "carModel": "...", "carYear": "...", "accessParaCode": ["..."], "carOptionOther": null, "carOption": null, "carOptionNotCovered": null, "status": "..." } } ] } }
```
Errors: 400 bind; 500.
DB: `tqm_request_status`, `tqm_lead_vmi`, `tqm_car_inspect_result`, `mas_cmi_color` (read). Outbound: GCS signed URL per image.

#### GET `tqm/get-masterdata-problem`
Success 200: `{ "status": 200, "title": "get master data success", "result": { "brand": [ { "name": "TOYOTA", "model": ["YARIS"] } ], "color": [ { "colorId": "01", "colorNameTh": "ขาว" } ], "carLicenseProvince": [ { "pvCode": "10", "pvName": "กรุงเทพมหานคร" } ] } }`
DB: `tqm_group_premium` (brand, then one query per brand for models), `mas_cmi_color`, `tqm_car_license_provice`.

#### POST `tqm/get-policy-problem-list`
Request: `{ "filter": { "requestId": "", "requestDate": "", "carLicense": "", "policyType": "VMI", "dataStatus": "DATA_PROBLEM", "insureFullName": "", "pageSize": 10, "pageNumber": 1 } }`
| Field | Validation |
|---|---|
| policyType | `omitempty,oneof=CMI VMI` |
| dataStatus | `omitempty,oneof=WAITING_INSPECTION INSPECTED WAITING_DOCUMENT DOCUMENTED DATA_PROBLEM SUCCESS INSPECTION_PROBLEM` |

Success 200: `{ "status": 200, "title": "get policy list success", "result": { "totalItems": n, "pageSize": 10, "pageNumber": 1, "items": [ { "requestId": "...", "policyType": "VMI", "insureFullName": "...", "carLicense": "...", "requestDate": "...", "dataStatus": "...", "detail": { "...": "VMI or CMI lead detail (built in usecase/tqm_policy.go)" } } ] } }`
DB: `tqm_request_status`, `tqm_lead_vmi`, `tqm_lead_cmi` (read).

#### POST `tqm/update-policy-problem-vmi`
Request: `{ "data": { ...TQMUpdatePolicyProblemVMIData... } }` — ~200 nullable fields (`gonull.Nullable`), none with validation tags. Groups: identifiers (`requestId`, `agentCode`, `notificationNumber`, `policyNumber`, `insuranceType`, `customerType`), insured person and address (`insured*`, `houseNumber` .. `postalCode`, `address*`), dates (`effectDate`, `expiredDate`, `contractDate`, `supplierDate`, `cancelDate`, birthdates — accepted as `YYYY-MM-DD` or `DD/MM/YYYY`, unparseable -> NULL), vehicle (`car*`, `chassisNumber`, `engineNumber`, `registrationYear`, `seatCount`, accessories/decorations), drivers 1..5 (`driverTitleN`, `driverNameN`, ...), coverage and premium (`sumInsured`, `v3rd*`, `deduct`, `basicPremium`, `discount*`, `amount`, `vat`, `duty`, `netAmount`, `installmentPeriod`), EV (`charger*`, `battery*`), misc (`receipt*`, `remark`, `phoneNumber`, `esy`). Full list: `dto/tqm.go:81-267`.
```json
{ "data": { "requestId": "SB123456", "policyNumber": "V-0001", "insuredFirstname": "กฤษณะ", "insuredLastname": "วัฒนายนนต์", "insuredIdentityNumber": "1111111111119", "carLicense": "1กก1234", "carProvince": "กรุงเทพมหานคร", "carBrand": "TOYOTA", "carModel": "YARIS", "carYear": 2022, "effectDate": "2026-10-01" } }
```
Flow: UPDATE `tqm_lead_vmi` by `sale_book_code` -> if a `tqm_car_inspect_result` exists, set its car fields and every image's `imageStatus` = `Unqualify` -> if current status is **not** `WAITING_INSPECTION`, set status `INSPECTED`.
Success 200: `{ "status": 200, "title": "Update policy problem VMI success", "description": "...", "result": null }`
Errors: 400 bind / `invalid input`; 500 `Update policy problem VMI failed`.
DB: `tqm_lead_vmi`, `tqm_car_inspect_result`, `tqm_request_status` (read/write). No terminal-status guard.

#### POST `tqm/update-policy-problem-cmi`
Request (`dto.UpdateLeadCMI`): `{ "data": { "policyNumber": "C-0001", "referenceId": "SB123456", "insurePrefix": "001", "insureName": "...", "insureSurname": "...", "citizenId": "1111111111119", "provinceName": "...", "district": "...", "addressArea": "...", "zipCode": "18110", "policyDate": "01/10/2026", "expiryDate": "01/10/2027", "plateId": "1กก1234", "provinceAbb": "กท", "chasisId": "...", "engineId": "...", "amount": 600, "vat": 42, "duty": 3, "netAmount": 645, ... } }`
| Field | Type | Required | Validation |
|---|---|---|---|
| data.policyNumber | string | yes | `required` |
| data.policyDate, expiryDate, contractDate, policyIssueDate, birthDate, supplierDate, issueDate | string | no | must parse as `DD/MM/YYYY` if present (else 400) |
| all other `data.*` (see `dto/tqm.go:278-336`) | pointer types | no | |

Flow: if `referenceId` set, CMI status must not be terminal -> UPDATE `tqm_lead_cmi` WHERE policy_number, and UPDATE `Policy_Car_Act_Discount_Premium` WHERE `Car_Act_No` (lookups: `tqm_province`->`province`, `tqm_district`->`district`, `tqm_sub_district`->`subdistrict`, `tqm_salutation`, `province` by plate abbreviation) -> if `referenceId` set, status `WAITING_CMI`.
Success 200: `{ "status": 200, "title": "update policy problem CMI success", "result": null }`
Errors: 400 bind/validate/date/`update is not allowed for current status`; 404 intended for unknown policy but unreachable (see Notes) — actual 500.
DB: `tqm_request_status`, `tqm_lead_cmi`, `Policy_Car_Act_Discount_Premium`, `tqm_province`, `tqm_district`, `tqm_sub_district`, `tqm_salutation`, `province`, `district`, `subdistrict`.

#### POST `tqm/import-group-premium`
`multipart/form-data`: `file` (.xlsx/.xls, >0, <=50 MB), `clearExisting` (`strconv.ParseBool`, required: missing -> 400).
Columns by position: 1 level name, 2 repair type, 3 group code, 4 package code, 5 car year min, 6 car year max, 7 brand, 8 model (0-based index 1..8; ⚠️ unverified meaning of column 0).
Behaviour: `clearExisting=true` -> `TRUNCATE tqm_group_premium`; otherwise DELETE rows with matching (brand, model) then upsert ON CONFLICT (group_code, package_code, brand, model).
Success 200: `{ "title": "Success", "status": 200, "description": "TQM Group Premium data imported successfully" }`
Errors: 400 `RespondError`; row/DB errors: `{ "title": "...", "status": 4xx/500, "description": "...", "errors": [ { "row": 3, "column": "...", "message": "Insufficient columns in row" } ] }`.
DB: `tqm_group_premium`.

#### POST `tqm/import-premium-detail`
`multipart/form-data`: `file` (optional, .xls/.xlsx, <=50 MB), `clearExisting` (`true`/`1`/`yes`).
Header row checked against the expected Thai/English header list in `usecase/import_premium_detail.go` (e.g. `Package ID เบี้ยแนบ`, `Package Code`, `Group กลุ่ม`, `CC`, `ปี`, `ทุนประกัน`, `เบี้ยพื้นฐาน`, ... `Deduct`).
Behaviour: `clearExisting` true -> `TRUNCATE tqm_premium` then insert; false -> DELETE matching (package, group, si, year) then upsert ON CONFLICT (package, "group", cc, si, year); ids from `nextval('insurverse.tqm_premium_id_seq')`.
Success 200: `{ "status": 200, "title": "Process Premium data success", "description": "Process Premium data success", "result": null }`
Errors: 400 empty/too large/wrong format/`File is required unless clearing existing records`; 500 `{ "title": "Process Premium data failed", "description": "<error>" }`. See Notes for the inverted file check.
DB: `tqm_premium`, sequence `tqm_premium_id_seq`.

### 5. Blacklist (maker-checker)

Enums (`constants/blacklist.go`): entityType `CITIZEN_ID | PASSPORT_NO | FULL_NAME | VEHICLE_REGISTRATION | CHASSIS_NO`; insuranceType `MOTOR | CMI | TRAVEL | ACCIDENT | HOME_CONDO` (legacy `HEALTH`, `PET` rejected on write); request status `PENDING_APPROVAL | APPROVED | REJECTED | DELETED`; action `ADD | REMOVE`. Page default 20, max 100.

Error codes: `BL40001` 400 validation, `BL40002` 409 duplicate with active or pending, `BL40003` 409 active entry exists, `BL40101` 401 no `preferred_username`, `BL40301` 403 role / not owner, `BL40401` 404 request not found, `BL40402` 404 entry not found, `BL40403` 404 active entry not found at approval, `BL40901` 409 invalid transition, `BL50001` 500.

Payload validation (add/edit/resubmit, `usecase/blacklist_requests.go:18`): entityType valid; entityValue format — CITIZEN_ID 13 digits + Thai checksum, FULL_NAME Thai letters/space only, VEHICLE_REGISTRATION Thai letters/digits, CHASSIS_NO `[A-Za-z0-9-]{1,20}`; at least one valid insuranceType (deduplicated); vehicle entities require exactly `["MOTOR"]`; VEHICLE_REGISTRATION requires `additionalEntityValue.province`; `expiredAt` must be in the future. Duplicate check against active entries and pending requests (same insurance types/entity/province).

#### POST `blacklist/list` (maker or checker)
Request: `{ "insuranceType": "MOTOR", "entityValue": "1111111111119", "status": "ACTIVE", "page": 1, "pageSize": 20 }` — status `omitempty,oneof=ALL ACTIVE EXPIRED`; page `min=1`; pageSize `min=1,max=100`.
Success 200:
```json
{ "data": [ { "blacklistId": "BL-1", "insuranceType": ["MOTOR"], "entityType": "CITIZEN_ID", "entityValue": "1111111111119", "additionalEntityValue": {"province": "..."}, "reason": "...", "expiredAt": null, "createdDt": "2026-09-01T10:00:00Z", "addedBy": "maker.user" } ], "total": 1, "page": 1, "pageSize": 20 }
```
DB: `tbl_blacklist` LEFT JOIN `tbl_blacklist_request` (read).

#### POST `blacklist/detail` (maker or checker)
Request: `{ "blacklistId": "BL-1" }` (required).
Success 200: `{ "blacklistId": "BL-1", "insuranceType": ["MOTOR"], "entityType": "...", "entityValue": "...", "additionalEntityValue": {}, "note": null, "reason": "...", "expiredAt": null, "requestId": "REQ-1", "createdDt": "...", "updatedDt": null, "createdBy": "...", "updatedBy": null, "addedBy": "..." }`
Errors: 404 `BL40402`. DB: `tbl_blacklist`, `tbl_blacklist_request`.

#### POST `blacklist/remove/request` (maker)
Request: `{ "blacklistId": "BL-1", "reason": "...", "note": null }` — blacklistId, reason required.
Rules: entry must be active (else 404 `BL40402`), no pending REMOVE for it (409).
Success **201**: `{ "requestId": "REQ-2", "status": "PENDING_APPROVAL" }`
DB: `tbl_blacklist` (read), `tbl_blacklist_request` (read, insert; id `'REQ-' || nextval('insurverse.seq_blacklist_request_id')`).

#### POST `blacklist-request/list` (maker or checker)
Request: `{ "insuranceType": "", "entityValue": "", "status": "PENDING_APPROVAL", "page": 1, "pageSize": 20 }` — status `oneof=ALL PENDING_APPROVAL APPROVED REJECTED DELETED`.
Success 200: `{ "data": [ { "requestId": "REQ-1", "action": "ADD", "insuranceType": ["MOTOR"], "entityType": "...", "entityValue": "...", "additionalEntityValue": {}, "expiredAt": null, "status": "PENDING_APPROVAL", "reason": "...", "rejectReason": null, "note": null, "blacklistId": null, "decidedAt": null, "createdDt": "...", "updatedDt": null, "createdBy": "...", "updatedBy": null } ], "total": 1, "page": 1, "pageSize": 20 }`
DB: `tbl_blacklist_request`.

#### POST `blacklist-request/detail` (maker or checker)
Request: `{ "requestId": "REQ-1" }` (required). Success 200: one `BlacklistRequestItem` (shape above). Errors: 404 `BL40401`.

#### POST `blacklist-request/add` (maker)
Request:
```json
{ "insuranceType": ["MOTOR"], "entityType": "VEHICLE_REGISTRATION", "entityValue": "1กก1234", "additionalEntityValue": { "province": "กรุงเทพมหานคร" }, "reason": "fraud", "note": null, "expiredAt": "2027-12-31T00:00:00+07:00" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| insuranceType | string[] | yes | `required,min=1` + enum |
| entityType | string | yes | `required` + enum |
| entityValue | string | yes | `required` + format |
| additionalEntityValue | map | conditional | `province` required for VEHICLE_REGISTRATION |
| reason | string | yes | `required` |
| note | string | no | |
| expiredAt | RFC3339 | no | future |

Success **201**: `{ "requestId": "REQ-3", "status": "PENDING_APPROVAL" }`. Errors: 400 `BL40001`, 409 `BL40002`.
DB: `tbl_blacklist`, `tbl_blacklist_request` (read), `tbl_blacklist_request` insert.

#### POST `blacklist-request/edit` (maker)
Request: add payload + `"requestId"` (all add validations apply). Only the creator may edit, only while `PENDING_APPROVAL` (else 403 / 409).
Success 200: `{ "requestId": "REQ-3", "status": "PENDING_APPROVAL" }`. DB: `tbl_blacklist_request` update (+ duplicate checks).

#### POST `blacklist-request/delete` (maker)
Request: `{ "requestId": "REQ-3" }`. Creator only, `PENDING_APPROVAL` only.
Success 200: `{ "requestId": "REQ-3", "status": "DELETED" }`. DB: `tbl_blacklist_request` update.

#### POST `blacklist-request/resubmit` (maker)
Request: `{ "requestId": "REQ-3", ...optional add fields }` — only `requestId` checked by handler; struct validation skipped. Creator only, current status must be `REJECTED`. With no changes: re-validates stored ADD data and duplicates, then marks resubmitted; with changes: missing fields are filled from the stored row and the request is updated.
Success 200: `{ "requestId": "REQ-3", "status": "PENDING_APPROVAL" }`. DB: `tbl_blacklist_request`, `tbl_blacklist` (duplicate checks).

#### POST `blacklist-request/approve` (checker)
Request: `{ "requestId": "REQ-3" }`. Must be `PENDING_APPROVAL`.
ADD: re-check active conflict (409 `BL40003`), then in one transaction INSERT `tbl_blacklist` (id `'BL-' || nextval('insurverse.seq_blacklist_id')`) and set request APPROVED. REMOVE: in one transaction set `tbl_blacklist.expired_at = NOW()` (404 `BL40403` if not active) and set request APPROVED.
Success 200: `{ "requestId": "REQ-3", "status": "APPROVED", "blacklistId": "BL-9" }` (`blacklistId` only for ADD).
Note: there is no check that the approver differs from the maker (a user holding both roles can approve their own request).

#### POST `blacklist-request/reject` (checker)
Request: `{ "requestId": "REQ-3", "reason": "insufficient evidence" }` — both required. Must be `PENDING_APPROVAL`. Stores `reject_reason`.
Success 200: `{ "requestId": "REQ-3", "status": "REJECTED" }`. DB: `tbl_blacklist_request` update.

### 6. Report and master data

#### POST `report/monthly-policy-by-province`
Request (`dto.MonthlyPolicyProvinceRequest`):
```json
{ "filter": { "startDate": "2026-09-01", "endDate": "2026-09-23", "dateField": "issue", "provinceIds": [10], "productType": "motor", "policyType": "1", "policyStatus": "", "pageSize": 50, "pageNumber": 1 } }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| filter.startDate | string `YYYY-MM-DD` | yes | `required`; not earlier than today-30 (Asia/Bangkok); <= endDate |
| filter.endDate | string `YYYY-MM-DD` | yes | `required` |
| filter.dateField | string | no | `oneof=issue payment coverage_start`, default `issue` |
| filter.provinceIds | int[] | yes | `required,min=1` (`insurverse.province` ids) |
| filter.productType | string | no | `oneof=motor cmi home` |
| filter.policyType | string | no | `oneof=1 2+ 3 3+` (motor class) |
| filter.policyStatus | string | no | exact match; cancelled statuses always excluded |
| filter.pageSize | int | no | `min=1,max=500`, default 50 |
| filter.pageNumber | int | no | `min=1`, default 1 |

Success 200:
```json
{ "status": 200, "title": "get monthly policy by province success", "result": {
  "totalItems": 1, "pageSize": 50, "pageNumber": 1, "startDate": "2026-09-01", "endDate": "2026-09-23", "dateField": "issue", "productType": "motor", "policyType": "1",
  "items": [ { "productType": "motor", "policyNo": "...", "leadNo": "...", "policyType": "1", "policyStatus": "...", "paymentStatus": "...", "ownerName": "...", "phone": "...", "email": "...", "carLicenseNo": "...", "sumInsured": 500000,
    "primaryProvinceId": 10, "primaryProvinceName": "...", "ownerProvinceId": 10, "ownerProvinceName": "...", "deliveryProvinceId": 10, "deliveryProvinceName": "...",
    "matchedFields": "...", "partnerCode": "...", "issueDate": "...", "paymentDate": "...", "policyStartDate": "...", "policyEndDate": "...", "inspectStatus": "...", "refPolicyNo": "..." } ] } }
```
Errors: 400 `{ "status": 400, "title": "error", "description": "at least one province is required" | "startDate and endDate are required as YYYY-MM-DD, ..." | "startDate may not be earlier than 30 days ago" | "dateField must be issue, payment or coverage_start" | "Bad request" }`; 500 `Internal server error`.
DB (read, parameterised): `Policy_Header`, `Policy_coverage_premium`, `Lead_coverage_premium`, `Policy_Car_Act_Discount_Premium`, `policy_home_premium`, `lead_home_participant`, `lead_home_coverage`, `province`. Cancelled statuses excluded: `CAN, CANCEL, CANCELLED, CNC, VOID`.

#### GET `masterdata/provinces`
Success 200: `{ "status": 200, "title": "get province master success", "result": { "provinces": [ { "provinceId": 10, "provinceName": "สระบุรี" } ] } }` (example values illustrative).
Errors: 500. DB: `insurverse.province` (read, ordered by provinceid).

---

## DB Usage

All tables are in schema `insurverse` unless stated.

| Table / function / sequence | R/W | Endpoints |
|---|---|---|
| `jwt_tokens` | R/W | login (W), verify_otp_and_return_jwt (R, D); hourly cleanup job |
| `otp_verification` | R/W | request_otp (W), verify_otp, verify_otp_and_return_jwt |
| `otp_daily_requests` | R/W | request_otp, verify_otp, verify_otp_and_return_jwt |
| `otp_settings` | R | request_otp |
| `public."User"` | W (DELETE) | DELETE /v1/api/v1/backoffice/admin/user |
| `mas_policy_product` | R | get_product, get_promotion, get_report_promo_code, get_report_promo_code_id |
| `promo_code` | R/W | all promotion/loyalty endpoints, import/export, bulk status, reports, get_loyalty_condition (count) |
| `promo_code_trans` | R/W | create/update promotion & loyalty (W), import (W), get_premium_redemption, get_report_promo_code_id (R) |
| `loyalty_condition` | R | get_loyalty_condition |
| `log_point_expire` | W | noti_daily_promo_code, update_point_expire, update_point_expire_noti |
| `sec_user` | R | get_report_promo_code_id |
| `Policy_Header` | R | get_report_promo_code_id, report/monthly-policy-by-province |
| `Policy_coverage_premium` | R | get_report_promo_code_id, report/monthly-policy-by-province (repo method `UpdatePolicyCoveragePremium` exists but its call is commented out) |
| `Lead_coverage_premium` | R | report/monthly-policy-by-province |
| `Policy_Car_Act_Discount_Premium` | R/W | get_report_promo_code_id (R), report (R), tqm/update-policy-problem-cmi (W) |
| `policy_ta_premium`, `lead_ta_participant`, `policy_pa_premium`, `lead_pa_participant` | R | get_report_promo_code_id |
| `policy_home_premium`, `lead_home_participant` | R | get_report_promo_code_id, report |
| `lead_home_coverage` | R | report |
| `province` | R | masterdata/provinces, report, tqm/update-policy-problem-cmi |
| `district`, `subdistrict` | R | tqm/update-policy-problem-cmi |
| `tqm_request_status` | R/W | tqm update-car-inspect-status (R), save-car-inspect, update-policy-problem-vmi, update-policy-problem-cmi (R/W); get-car-inspect-list, get-policy-problem-list (R) |
| `tqm_lead_vmi` | R/W | update-car-inspect-status, update-policy-problem-vmi (W); get-car-inspect-list, get-policy-problem-list (R) |
| `tqm_lead_cmi` | R/W | update-policy-problem-cmi (W); get-policy-problem-list (R) |
| `tqm_car_inspect_result` | R/W | update-car-inspect-status, update-policy-problem-vmi (W); get-car-inspect-list (R) |
| `tqm_notification_job` | W (upsert) | update-car-inspect-status, save-car-inspect |
| `mas_cmi_color` | R | get-car-inspect-list, get-masterdata-problem |
| `tqm_group_premium` | R/W (TRUNCATE/DELETE/upsert) | import-group-premium (W), get-masterdata-problem (R) |
| `tqm_premium` | W (TRUNCATE/DELETE/upsert) | import-premium-detail |
| `tqm_car_license_provice` | R | get-masterdata-problem (and repository lookups) |
| `tqm_salutation`, `tqm_province`, `tqm_district`, `tqm_sub_district` | R | update-policy-problem-cmi |
| `tbl_blacklist` | R/W | blacklist list/detail/remove-request (R), approve (W) |
| `tbl_blacklist_request` | R/W | all blacklist endpoints |
| seq `seq_blacklist_request_id` | nextval | blacklist-request/add, blacklist/remove/request |
| seq `seq_blacklist_id` | nextval | blacklist-request/approve (ADD) |
| seq `tqm_premium_id_seq` | nextval | tqm/import-premium-detail |
| fn `fn_cleanup_expired_jwt()` | exec | background goroutine (hourly) |
| fn `fn_noti_daily_promo_code()` | exec | noti_daily_promo_code |
| fn `fn_update_point_expire()` | exec | update_point_expire |
| fn `fn_update_point_expire_noti()` | exec | update_point_expire_noti |
| fn `fn_update_promo_batch()` | exec | update_promo_batch |

No advisory locks and no explicit isolation levels are used anywhere. Transactions: OTP insert (request_otp), bulk status update, blacklist approve (ADD/REMOVE), TQM import/update helpers (`handleTransaction`), promo code generation via package-global `utils.Sql_trans`.

---

## Notes / ⚠️ unverified items

### Route-level findings
1. No commented-out route registrations were found in `main.go` or `router/*.go`.
2. Handlers that exist but are **not routed**: `controllers.CreateUser` (Keycloak master-realm user creation), `controllers.GetOTPSettings`, `controllers.UpdateOTPSetting`, `controllers.UserData`. The Swagger spec (`docs/docs.go`) still documents `/api/v1/backoffice/otp_settings` (GET/PUT) and `/v1/admin/user`, and does not document TQM, blacklist, report or masterdata routes. Swagger metadata is the petstore template (`host petstore.swagger.io`, `BasePath /v2`).
3. The admin delete-user route is actually `/v1/api/v1/backoffice/admin/user` (double version prefix) and has **no authentication**.
4. `RegisterRoutesTQM` / `RegisterRoutesBlacklist` accept a `validateTokenMiddleware` parameter that is never used; the groups attach `ExtractTokenToGlobalVar()` themselves.
5. `/swagger/*` is mounted twice (root and under the base path).

### Security findings (for follow-up; no changes made)
6. Auth state lives in package globals (`Access_token`, `JwtMapClaims`): race between concurrent users; `get_product` has no middleware and passes whenever any earlier request authenticated. Audit fields may record another user's name.
7. Unauthenticated state-changing endpoints: the 4 cron triggers and admin delete-user.
8. SQL built by string concatenation from request fields: `get_promotion`, `get_loyalty_condition`, `get_premium_redemption` (LIKE filters and date CTE). `bulk_update_promotion_status` formats ints only (safe).
9. `verify_otp` returns an HS256 JWT signed with a hardcoded constant key, 180-day expiry.
10. Hardcoded credentials/keys exist in `constants/constant.go` and `configs/config.go` (DB, Keycloak admin, AES key/IV, JWT salt); values deliberately not reproduced here. `key.json` (GCS service account) is present in the repo root.
11. Several error responses return raw internal error text (`err.Error()`, gocloak error objects) to the client.
12. Blacklist approve does not prevent maker == checker.

### Behavioural bugs / quirks observed in code
13. `configs.GetConfigENV`: `if GCSBucketEnv == "" { GCSBucket = GCSBucketEnv }` is inverted (sets empty when unset). The runtime client reads `GCS_BUCKET` directly, so the effect is limited to the unused `configs.GCSBucket`.
14. `Backend_Notification` env var is read but ignored; cron endpoints always call the hardcoded dev notification URL.
15. `/login` returns HTTP 200 on Keycloak authentication failure.
16. `tqm/import-premium-detail`: handler rejects `clearExisting=true` without a file ("File is required unless clearing existing records"), which makes the usecase's clear-only branch unreachable; conversely no file + `clearExisting=false` reaches `data.FileHeader.Open()` on a nil pointer (panic, recovered as 500). The header check iterates actual headers against the expected list (reports unexpected headers, not missing ones).
17. `tqm/update-policy-problem-cmi`: handler maps `err.Error() == "policy Number not found"` to 404, but the repository returns `"no lead found with policyNo ..."` / `"no policy found with policyNo ..."`, so unknown policies return 500.
18. `tqm/update-policy-problem-vmi`: sets status `INSPECTED` when the current status is **not** `WAITING_INSPECTION` and has no terminal-status guard (unlike the other TQM mutations). ⚠️ unverified whether this is intended.
19. `get_loyalty_condition`: `sub_group_type` filter uses the `group_type` value; the total count queries `promo_code` instead of `loyalty_condition`; the date filter references `active_start_date/active_end_date`. ⚠️ unverified whether `loyalty_condition` has those columns (schema not inspected).
20. `update_point_expire` response serialises `rtn_success` under JSON key `prem_prod_name`.
21. Create promotion/loyalty responses echo the insert struct with `promo_code_id: 0` (returned id is not copied back).
22. Promo code generation uses a package-global transaction (`utils.Sql_trans`) — concurrent create/update calls can interfere; on error the handler returns `err` without rollback.

### Unverified
- ⚠️ unverified: exact `Authorization` header format accepted by `DecodeAccessToken` (raw vs `Bearer `).
- ⚠️ unverified: JSON shape for `promo_start_date` / `promo_end_date` (`sql.NullTime`).
- ⚠️ unverified: `update_loyalty` success title, `get_loyalty_condition` result wrapper, `import_promotion_codes` `failed_rows` item keys (handler tails only partially read).
- ⚠️ unverified: bodies/signatures of `fn_cleanup_expired_jwt`, `fn_noti_daily_promo_code`, `fn_update_point_expire`, `fn_update_point_expire_noti`, `fn_update_promo_batch` (not inspected in the database; no DB access was performed for this spec).
- ⚠️ unverified: existence of `public."User"` and column names of all tables — derived from SQL text in code only, not checked against `information_schema`.
- ⚠️ unverified: external scheduler that calls the cron endpoints (not in this repo).
