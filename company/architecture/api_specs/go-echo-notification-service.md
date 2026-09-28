# go-echo-notification-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-notification-service` (Go module `service_notification`).
> Generated from route registration in `router/router.go` and `main.go`, followed into each handler. All line numbers refer to the working copy as read on 2026-09-23.
> Table/function existence was cross-checked read-only against the **UAT-ISV** database (`information_schema.tables`, `pg_proc`). No other environment was queried.
> FX-02 (2026-09-24): branch `fix/fx-02-notification` — `get_noti_policy_expire` fully background (#23), SMTP extra headers (#12).

---

## Overview

| Item | Value |
|---|---|
| Purpose | Central outbound-notification service for Insurverse: SMS (ThaiBulkSMS, legacy AIS/True gateways), e-mail (SMTP and ThaiBulk Email API), push (Firebase Cloud Messaging, OneSignal), in-app notification inbox, endorsement e-mails to TQM, scheduled reminder jobs (car inspection, point expiry, input-policy, policy expiry), the new policy-renewal pipeline (`/renewal/prep` + `/renewal/dispatch`), and ThaiBulk delivery webhooks. |
| Framework | Echo v4 (`github.com/labstack/echo/v4`), `sqlx` + `lib/pq` for PostgreSQL, `firebase.google.com/go` messaging, `gopkg.in/gomail.v2` for SMTP. |
| Port | `HTTP_PORT` env var, default `8080` (`main.go:69-76`). |
| Base path | `/api/v1/notification` for most routes (`router.GenApiVersion`, `router/router.go:32-34`, `constant.ApiVersion = "v1"`). Exceptions: `/api/v1/thaibulk/*`, `/swagger/*`, `/healthcheck`. In-cluster URL (helm): `http://backend-notification-service:8080/api/v1/notification/`. |
| DB | Single PostgreSQL connection pool (`webserver/dbConnect.go`), schema `insurverse`; max open 100, idle 10, lifetime 1h. Service panics at start if DB is unreachable. |
| Swagger | `GET /swagger/*` served from `docs/docs.go` (swag-generated; only a subset of routes is annotated). |

### Environment variables (names only)

| Group | Variables |
|---|---|
| Runtime | `HTTP_PORT`, `ENV`, `LOG_LEVEL` |
| DB | `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME` (fall back to compiled-in constants when empty) |
| URLs | `Base_Url`, `Url_Fontend`, `RENEWAL_PWA_BASE_URL`, `RENEWAL_ISV_TEST_BASE_URL`, `EMAIL_API_URL`, `SMS_API_URL`, `SMS_URL` |
| SMTP / e-mail | `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `EMAIL_BCC`, `SENDER_NOTI`, `SENDER_POLICY`, `SENDER_OTP` |
| SMS / ThaiBulk | `SMS_THAIBULK_KEY`, `SMS_CHARGE`, `SMS_CODE`, `API_KEY`, `API_SECERET` (sic, misspelled in code) |
| Endorsement mail routing | `EMAIL_ENDORSE_EDIT_RECEIVER`, `EMAIL_ENDORSE_EDIT_RECEIVER_CC`, `EMAIL_ENDORSE_CANCEL_RECEIVER`, `EMAIL_ENDORSE_CANCEL_RECEIVER_CC`, `EMAIL_ENDORSE_PROBLEM_RECEIVER`, `EMAIL_ENDORSE_PROBLEM_RECEIVER_CC` |
| Renewal pipeline | `RENEWAL_DISPATCH_WORKERS` (default 5), `RENEWAL_DISPATCH_RATE_PER_SEC` (5), `RENEWAL_DISPATCH_MAX_RETRY` (3), `RENEWAL_DISPATCH_RETRY_BASE_MS` (1000), `RENEWAL_DB_WRITE_ATTEMPTS` (3), `RENEWAL_DB_WRITE_BACKOFF_MS` (500), `EMAIL_RENEWAL_SUMMARY_RECEIVER`, `EMAIL_RENEWAL_SUMMARY_CC`, `RENEWAL_ALLOWED_PARTNERS`, `RENEWAL_EXCLUDED_PROMO_CODES` |

### External / third-party calls

| Target | Used by | Auth | Code |
|---|---|---|---|
| ThaiBulkSMS SMS API v2 (`https://api-v2.thaibulksms.com/sms`, hardcoded) | `/sms`, `/sms/policy`, `/:type/inspection/:day` (sms), queue processor (sms) | Basic, `SMS_THAIBULK_KEY` | `controllers/notificationController.go:126` `SendSmsThaibulkSmsApi` |
| ThaiBulkSMS SMS API v2 (`SMS_API_URL`) with `scheduled_delivery` = 09:05 Bangkok | `/renewal/dispatch` (sms) | Basic, key/secret from DB table `thaibulk_configs` | `controllers/renewal/thaibulk_client.go:111` `SendSmsThaibulkV2` |
| ThaiBulk Email API (`https://tbs-email-api-gateway.omb.to/email/v1/send_template`, hardcoded) | queue processor (email) | Basic, `API_KEY`/`API_SECERET` | `controllers/thaibulkController.go:111` `SendEmailThaibulk` |
| ThaiBulk Email API (`EMAIL_API_URL`) | `/renewal/dispatch` (email) | Basic, key/secret from `thaibulk_configs` | `controllers/renewal/thaibulk_client.go:54` `SendEmailThaibulkV2` |
| SMTP relay (`SMTP_HOST`/`SMTP_PORT`, fallback compiled-in host, port 25) | `/email`, `/tqm/emailendorse`, `/email/input_policy/:lead_no`, `/:type/inspection/:day` (email), `/get_noti_point_expire` | optional `SMTP_USER`/`SMTP_PASS` | `controllers/notificationController.go:277` `SendEmailSMTP` |
| SMTP relay (compiled-in host, port 25, no auth; ignores `SMTP_*` env) | renewal daily summary e-mail | none | `controllers/renewal/thaibulk_client.go:154` |
| Firebase Cloud Messaging (`SendMulticast`) | `/messaging`, `/broadcast`, `/push_notification_id`, `/messaging_fix` | service-account JSON compiled into `constants/constant.go` | `controllers/messagingController.go:14` |
| OneSignal REST (`https://onesignal.com/api/v1/notifications`) | `/app` | compiled-in app id / token | `controllers/notificationController.go:417` |
| True SMS gateway (hardcoded IP, XML, Basic auth compiled-in) | `/sms/true` (test only) | Basic | `controllers/notificationController.go:466` |
| AIS SMS gateway (`SMS_URL`) | not reachable from any route (helper `SendSmsApi` unused by handlers) | form params | `controllers/notificationController.go:91` |
| Internal `backend-isv-test-service` `POST {RENEWAL_ISV_TEST_BASE_URL}/api/v1/isv-test/renewal/summary-link` body `{"policy":"<policy_no>"}` (30 s timeout, forwards `X-Request-ID`) | `/renewal/prep` | none | `controllers/renewal/isv_test_client.go:31` |
| LINE Notify | disabled — `SendLineNotify` only prints to stdout (HTTP call commented out) | — | `controllers/notificationController.go:31` |

### Background work (summary; details in [Background Jobs](#background-jobs))

- No in-process cron / ticker scheduler exists. All periodic work is triggered by an external scheduler (a Cloud Scheduler job is referenced in comments, `controllers/notificationUser.go:1104-1113`) calling HTTP endpoints.
- Goroutines are spawned from handlers: renewal prep/dispatch workers, policy-expire job, fire-and-forget SMS/e-mail/FCM sends, and the request-log writer (every request).

---

## Auth & Middleware

Global middleware, in order (`main.go:42-64`):

| # | Middleware | Behaviour |
|---|---|---|
| 1 | `CustomValidator` | `go-playground/validator`; used only where a handler calls `c.Validate(...)`. On failure returns `echo.HTTPError 400 {"message": "<validator text>"}`. |
| 2 | `middlewares.Recover()` | Recovers panics, logs stack via logx. |
| 3 | `RequestIDWithConfig` | Generates `X-Request-ID` (`helper.NewRequestID`). |
| 4 | `middlewares.SetCtx()` / `LogXMiddleware()` | Attach request-id / start time / structured logger to context; log request/response. |
| 5 | `BodyDumpWithConfig` | For every request except path `/api/v1/notification/email` and `/healthcheck`, spawns a goroutine that INSERTs headers + request body + response body into `insurverse.log_noti_push` (`loggings/logHandler.go`, `loggings/messagingLog.go`). |
| 6 | `CORSWithConfig` (all origins, GET/HEAD/PUT/PATCH/POST/DELETE) and then `CORS()` again | Both applied. |

Route-level auth (only two routes are protected):

| Middleware | File | Applied to | Behaviour |
|---|---|---|---|
| `AuthMiddleware` | `middlewares/Validate.go:59` | `POST /get_app_notification_id` | Parses `Authorization: Bearer <jwt>` (HMAC secret compiled in). On success sets `c.Set("id", claims["id"])`. Errors are **400 text/plain**: `That's not even a token`, `Timing is everything` (expired / not yet valid), `Couldn't handle this token: ...`. No signing-method check. |
| `ValidateToken` | `middlewares/Validate.go:16` | `PUT /noti_token` | Requires `Bearer ` / `bearer ` prefix, HMAC only, checks `exp`. Errors **401 JSON** `{"error":"Invalid token not found" | "Invalid token" | "Token has expired"}`. Stores claims in package-global `JWTClaims` (not request-scoped). |
| `middlewares/jwt.go` | — | — | File contains only `package middlewares` (empty). |

All other routes are **unauthenticated** (including those that mutate user notification state, send broadcasts, or trigger mass e-mail/SMS).

### Common response envelopes

`models.JsonReturn` (legacy handlers):

```json
{ "title": "Success", "status": 200, "description": "", "result": "" }
```

`apicode.Response` (renewal handlers):

```json
{ "code": "ISV0000", "message": "success" }
```

| Code | Message |
|---|---|
| `ISV0000` | `success` |
| `ISV0100` | `Invalid request: field '%s' is invalid` |
| `ISV0300` | `Cannot connect to database` |
| `ISV0530` | `Cannot find business rules configured` (logged only; job fails) |
| `ISV0531` | `Cannot find profile` (defined, unused) |

---

## Endpoint Summary

Prefix `{N}` = `/api/v1/notification`.

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | `main.go:79` `healthcheck` | Liveness, returns `OK`. |
| 2 | GET | `/swagger/*` | none | `router/router.go:37` `echoSwagger.WrapHandler` | Swagger UI. |
| 3 | POST | `/api/v1/thaibulk/template` | none | `controllers/thaibulkController.go:26` `AddThaibulkTemplate` | Insert ThaiBulk e-mail template. |
| 4 | GET | `/api/v1/thaibulk/data` | none | `controllers/thaibulkController.go:71` `GetThaibulkDate` | Debug: prints mock policy data to stdout. |
| 5 | GET | `/api/v1/thaibulk/logs/search` | none | `controllers/thaibulkController.go:280` `GetThaibulkLogsByTemplateName` | Search ThaiBulk send log joined with webhook log. |
| 6 | POST | `{N}/send_policy_renewal_notification` | none | `controllers/notificationUser.go:1114` `RetiredRenewalJob` | RETIRED no-op, always 200. |
| 7 | POST | `{N}/send_policy_thaibulk` | none | `controllers/notificationUser.go:1114` `RetiredRenewalJob` | RETIRED no-op (old name), always 200. |
| 8 | POST | `{N}/tqm/emailendorse` | none | `controllers/notificationController.go:733` `SendEndorseNotification` | Endorsement (edit/cancel/problem) e-mail to TQM. |
| 9 | GET | `{N}/webhook/thaibulk` | none | `controllers/notificationUser.go:1750` `ThaibulkWebhook` | ThaiBulk delivery webhook (query params). |
| 10 | POST | `{N}/webhook/thaibulk` | none | `controllers/notificationUser.go:1750` `ThaibulkWebhook` | Same handler; reads query params only. |
| 11 | POST | `{N}/sms` | none | `controllers/notificationController.go:262` `SendSms` | Send SMS via ThaiBulk to a list of phones. |
| 12 | POST | `{N}/email` | none (BodyLimit 10M) | `controllers/notificationController.go:366` `SendEmail` | Send HTML e-mail via SMTP with attachments. |
| 13 | POST | `{N}/app` | none | `controllers/notificationController.go:457` `SendApp` | OneSignal push. |
| 14 | GET | `{N}/email/input_policy/:lead_no` | none | `controllers/notificationUser.go:355` `GetNotiEmailInputPolicy` | Remind buyer (paid lead without policy) to complete data, by e-mail. |
| 15 | GET | `{N}/sms/policy` | none | `controllers/notificationUser.go:430` `GetNotiSmsPolicy` | Batch SMS: paid 2 days ago, policy not issued. |
| 16 | GET | `{N}/:type/inspection/:day` | none | `controllers/notificationUser.go:522` `GetNotiCarInspection` | Batch car-inspection reminder (sms / email). |
| 17 | GET | `{N}/sms/true` | none | `controllers/notificationController.go:466` `TestTrueSms` | Test SMS through True gateway to a hardcoded number. |
| 18 | POST | `{N}/get_app_notification_id` | `AuthMiddleware` | `controllers/notificationController.go:528` `GetAppNotificationID` | List in-app notifications for JWT user. |
| 19 | POST | `{N}/update_notification_read_flag` | none | `controllers/notificationController.go:564` `UpdateNotificationReadFlag` | Mark one in-app notification read. |
| 20 | POST | `{N}/update_notification_read_flag_all` | none | `controllers/notificationController.go:613` `UpdateNotificationReadFlagAll` | Mark all in-app notifications read for user. |
| 21 | POST | `{N}/push_notification_id` | none | `controllers/notificationController.go:666` `PushNotificationID` | Push a stored in-app notification via FCM. |
| 22 | POST | `{N}/get_noti_point_expire` | none | `controllers/notificationUser.go:717` `GetNotiPointExpire` | Batch e-mail: loyalty points expiring this month. |
| 23 | POST | `{N}/get_noti_policy_expire` | none | `controllers/notificationUser.go:800` `GetNotiPolicyExpire` | Legacy policy-expiry job (background; sending disabled). |
| 24 | POST | `{N}/messaging` | none | `controllers/messagingController.go:59` `SendMessagingByEmail` | FCM push to users by e-mail. |
| 25 | POST | `{N}/broadcast` | none | `controllers/messagingController.go:98` `SendMessagingBroadcast` | FCM push to all registered tokens. |
| 26 | PUT | `{N}/noti_token` | `ValidateToken` | `controllers/messagingController.go:157` `UpdateMessagingNotiToken` | Upsert FCM token for user. |
| 27 | GET | `{N}/messaging_fix` | none | `controllers/messagingUser.go:34` `GetMessagingFix` | Re-push all unsent in-app notifications via FCM. |
| 28 | GET | `{N}/test/rules` | none | `controllers/notificationUser.go:1394` `TestNotificationRules` | Debug: read notification business rules. |
| 29 | POST | `{N}/queue/process` | none | `controllers/notificationUser.go:1455` `ProcessNotificationQueue` | Process up to 10 pending + 10 retry queue items. |
| 30 | POST | `{N}/queue/add` | none | `controllers/notificationUser.go:1512` `AddToNotificationQueue` | Enqueue an e-mail/SMS. |
| 31 | GET | `{N}/queue/stats` | none | `controllers/notificationUser.go:1562` `GetQueueStatistics` | Queue statistics. |
| 32 | GET | `{N}/poc` | none | `controllers/notificationController.go:848` `POC` | Static POC response. |
| 33 | POST | `{N}/renewal/prep` | none | `controllers/renewal/renewal_prep.go:34` `SendPolicyRenewalPrep` | Build today's renewal notification rows (async). |
| 34 | POST | `{N}/renewal/dispatch` | none | `controllers/renewal/renewal_dispatch.go:108` `SendPolicyRenewalDispatch` | Send today's PENDING renewal rows via ThaiBulk (async). |
| 35 | GET | `{N}/renewal/callback` | none | `controllers/renewal/renewal_callback.go:25` `SendPolicyRenewalCallback` | ThaiBulk delivery callback for renewal messages. |

**Total: 35 registered routes** (34 in `router/router.go` including `/swagger/*`, plus `GET /healthcheck` in `main.go`).

---

## Endpoints

### 1. GET `/healthcheck`
- Purpose: liveness probe. Response `200 text/plain` `OK`. No DB. Excluded from request-log insert.

### 2. GET `/swagger/*`
- Serves swag UI / `doc.json` from `docs/docs.go`. Swagger covers only: broadcast, email, email/input_policy, get_app_notification_id, messaging, messaging_fix, noti_token, push_notification_id, sms, sms/policy, update_notification_read_flag(_all), `{type}/inspection/{day}`. Swagger header metadata is the swag "Petstore" template (host `petstore.swagger.io`, basePath `/v2`) and is not accurate.

### 3. POST `/api/v1/thaibulk/template`
- Purpose: add a ThaiBulk e-mail template (used by `SendEmailThaibulk` via `template_code`).
- Request body:

```json
{
  "template_code": "25040415-1859-8d9b-b357-c5c2e22f19a9",
  "template_name": "Noti_30_Legacy",
  "subject_template": "Your policy expires on {{.Policy_exp}}",
  "body_template": "<html>...</html>"
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `template_code` | string | yes | non-empty (manual check) |
| `template_name` | string | no | — |
| `subject_template` | string | yes | non-empty |
| `body_template` | string | yes | non-empty |

- Success `200`: `{"status":"template added successfully"}`
- Errors: `400 {"error":"invalid input format"}`; `400 {"error":"template_code, subject_template, and body_template are required"}`; `500 {"error":"insert failed: <db error>"}`.
- DB: INSERT `insurverse.thaibulk_templates` (`is_active=true`, `created_at = NOW()+7h`).

### 4. GET `/api/v1/thaibulk/data`
- Purpose: debug; iterates `models.MockPolicyData` (in-code mock) and prints lines to stdout.
- Success `200`: `{"status":"processed mock policy data"}`. No DB, no outbound.

### 5. GET `/api/v1/thaibulk/logs/search`
- Query: `template_name` (string, required) — matched with `ILIKE %value%`.
- Success `200` (array, `null` when empty):

```json
[{
  "message_id": "abc", "email_to": "user@example.com", "template_code": "...",
  "template_name": "Noti_30_Legacy", "send_status": "success",
  "webhook_status": "delivered", "reason": "success", "webhook_time": "2026-09-23 10:00:00"
}]
```

- Errors: `400 {"error":"template_name is required"}`; `500 {"error":"query error: ..."}` / `{"error":"scan error: ..."}`.
- DB: SELECT `log_thaibulk_send` JOIN `thaibulk_webhook_logs` on `message_id`, filter `w.reason='success'`.

### 6–7. POST `{N}/send_policy_renewal_notification`, POST `{N}/send_policy_thaibulk`
- Purpose: RETIRED. Kept so the existing external scheduler job still receives 200. Superseded by `/renewal/prep` + `/renewal/dispatch`.
- Request: none read.
- Success `200`:

```json
{ "title": "Success", "status": 200, "description": "retired: superseded by /renewal/prep + /renewal/dispatch", "result": {} }
```

- DB / outbound: none (the request is still written to `log_noti_push` by the body-dump middleware).

### 8. POST `{N}/tqm/emailendorse`
- Purpose: send endorsement e-mail to TQM staff. Subject built with today's Bangkok date `YYYYMMDD` and fixed time range `000000_235959`.
- Request body (`models.EndorseEmailRequest`):

```json
{
  "notiType": "PE",
  "mailSubject": "ignored",
  "content": "<p>detail of the problem</p>",
  "attach": [{ "filename": "detail.pdf", "filebase64": "data:application/pdf;base64,JVBERi0..." }]
}
```

| Field | Type | Required | Validation / behaviour |
|---|---|---|---|
| `notiType` | string | yes | one of `E` (edit ack), `C` (cancel ack), `PE` (problem edit), `PC` (problem cancel), `PM` (problem, unknown type); else 400 |
| `mailSubject` | string | no | not used |
| `content` | string | for `PE`/`PC`/`PM` | HTML body; `E`/`C` use a fixed Thai body |
| `attach[].filename` | string | no | used only for `PE`/`PC`/`PM` |
| `attach[].filebase64` | string | no | must be `data:<mime>;base64,<data>` (split on `,`) |

- Recipients: `E` → `EMAIL_ENDORSE_EDIT_RECEIVER` / `_CC`; `C` → `EMAIL_ENDORSE_CANCEL_RECEIVER` / `_CC`; `P*` → `EMAIL_ENDORSE_PROBLEM_RECEIVER` / `_CC` (comma-separated).
- Success `200`: `{"title":"Success","status":0,"description":"","result":"ส่งอีเมลสำเร็จ"}`
- Errors: `400` result `รูปแบบข้อมูลไม่ถูกต้อง` (bind) or `ประเภทการแจ้งเตือนไม่ถูกต้อง` (bad notiType); `500` result `ไม่สามารถส่งอีเมลได้` (SMTP failure) or timezone load failure.
- DB: none (besides request log). Outbound: SMTP.

### 9–10. GET / POST `{N}/webhook/thaibulk`
- Purpose: ThaiBulk e-mail delivery webhook for legacy sends. Both methods read **query parameters only** (a POST JSON body is ignored).
- Query params:

| Param | Type | Required |
|---|---|---|
| `message_id` | string | yes (non-blank) |
| `recipient` | string | yes (non-blank) |
| `status` | string | yes (non-blank) |
| `reason` | string | no |
| `click_url` | string | no |

- Success `200`: `{"message":"Webhook received successfully"}`
- Errors: `400 {"error":"Missing required query parameters (message_id, recipient, or status)"}`; `400 {"error":"message_id not found in log_thaibulk_send"}`; `500 {"error":"Database connection not initialized" | "Database error" | "Database insert failed"}`.
- DB: SELECT EXISTS `log_thaibulk_send` by `message_id`; INSERT `thaibulk_webhook_logs` (`created_at`/`updated_at` = Bangkok now).

### 11. POST `{N}/sms`
- Purpose: send the same SMS text to each phone via ThaiBulkSMS (`sender=insurverse`, `force=corporate`). Sequential, synchronous.
- Request body (`models.SendSms`):

```json
{ "content": "ข้อความทดสอบ", "phone": ["0628696603"] }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `content` | string | yes (tag) | `validate:"required"` declared but **not enforced** (handler never calls `c.Validate`) |
| `phone` | []string | yes (tag) | same — not enforced; phone sent as-is as `msisdn` |

- Success `200`: `{"title":"Success","status":0,"description":"","result":""}` — returned even if every provider call fails (failures are only printed).
- Errors: `400 text/plain` `bad request` on bind error.
- DB: none. Outbound: ThaiBulkSMS v2.

### 12. POST `{N}/email`
- Purpose: send HTML e-mail via SMTP; one SMTP message per `email[]` recipient. Route-level `BodyLimit("10M")`. Excluded from the `log_noti_push` body dump.
- Request body (`models.SendEmail`):

```json
{
  "sender": "epolicy",
  "subject": "กรมธรรม์ของท่าน",
  "content": "<html><body>...</body></html>",
  "email": ["kritsana.w.os@horixon-t8.com"],
  "cc_email": [],
  "attach": [{ "filename": "policy.pdf", "filebase64": "data:application/pdf;base64,JVBERi0..." }]
}
```

| Field | Type | Required | Validation / behaviour |
|---|---|---|---|
| `sender` | string | tag `required`, not enforced | `notication` → `SENDER_NOTI`; `epolicy` → `SENDER_POLICY`; `otp` → `SENDER_OTP`; other → `SENDER_NOTI`; empty resolved sender → `support@insurverse.co.th` |
| `subject` | string | tag `required`, not enforced | — |
| `content` | string | tag `required`, not enforced | HTML body |
| `email` | []string | tag `required`, not enforced | To (one message each) |
| `cc_email` | []string | no | `Cc` header is overwritten per loop — only the last CC is kept |
| `attach[]` | object[] | no | `filebase64` must contain exactly one `,` (data-URI form) or the attachment is skipped silently |

- `EMAIL_BCC` added as Bcc when set.
- FX-02 (2026-09-24): `SendEmailSMTP` (all SMTP-relay callers, not only this route) adds headers `Reply-To` (= resolved sender address, when non-empty), `Message-ID` (`<unixnano.n@insurverse.co.th>`), `MIME-Version: 1.0`, `X-Priority: 3`, so providers are less likely to file the mail as junk. No request/response change.
- Success `200`: `{"title":"Success","status":0,"description":"","result":""}`
- Errors: `400` JsonReturn `Bad Request` with `result` = read error / `"invalid json body"` / unmarshal error; `400` `{"title":"Unsuccess","status":400,...}` when SMTP send fails (stops at first failing recipient).
- DB: none. Outbound: SMTP.

### 13. POST `{N}/app`
- Purpose: OneSignal push to player ids.
- Request body (`models.SendApp`):

```json
{ "header": "Insurverse", "content": "ข้อความ", "noti_id": ["onesignal-player-id"] }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `header` | string | tag `required`, not enforced | heading (`en`) |
| `content` | string | tag `required`, not enforced | content (`en`) |
| `noti_id` | []string | tag `required`, not enforced | `include_player_ids` |

- Success `200`: `{"title":"Success","status":0,"description":"","result":{"id":"...","recipients":1,"external_id":null}}`
- Errors: `400 text/plain bad request` (bind). A network error on the OneSignal call dereferences a nil response and panics (recovered → 500).
- DB: none. Outbound: OneSignal.

### 14. GET `{N}/email/input_policy/:lead_no`
- Purpose: if the lead is paid (`Payment_status='success'`) but has no issued policy, e-mail the buyer asking to complete data. Template `email_template/noti_input_policy_v1.html` when `Lead.Type = "1"`, else `noti_input_policy_v5.html`; data `BaseUrl` (`Url_Fontend`), `Name`, `Lastname`.
- Path params: `lead_no` (string/int, required).
- Success `200`: `{"title":"Success","status":200,"description":"","result":{}}` (also when no row matches).
- Errors: `400 "Error"` on scan error (preceded by `log.Fatalln`, which terminates the process). Template read error returned as Echo 500.
- DB: SELECT `"Lead_coverage_premium"` LEFT JOIN `"Policy_coverage_premium"` JOIN `sec_user` (mobile non-empty).
- Outbound: SMTP (synchronous).

### 15. GET `{N}/sms/policy`
- Purpose: batch — SMS every buyer whose lead was paid exactly 2 days ago (Bangkok) and still has no policy. Fixed Thai text. Sends in fire-and-forget goroutines.
- Params: none.
- Success `200`: `{"title":"Success","status":200,"description":"","result":{}}`
- Errors: `500 "Database Error"`; `400 "Error"` on scan (after `log.Fatalln`).
- DB: SELECT `"Lead_coverage_premium"`, `"Policy_coverage_premium"`, `sec_user`.
- Outbound: ThaiBulkSMS.

### 16. GET `{N}/:type/inspection/:day`
- Purpose: batch reminder to complete car inspection for class-1 policies (`Policy_Header.Type='1'`, `Car_Inspect_Status != 'success'`).
- Path params:

| Param | Values | Behaviour |
|---|---|---|
| `type` | `sms` or `email` | any other value: query runs, nothing is sent |
| `day` | `7` or `3` | `7`: policies starting in 4–7 days; `3`: starting in exactly 3 days; other → 400 |

- Dedup: skips a policy when `log_noti_renewal` already has `noti_code='car_inspection'` and `car_inspection_email_at` / `car_inspection_sms_at` set.
- `sms`: fixed Thai text with licence plate, ThaiBulkSMS; `email`: template `email_template/noti_car_inspection.html` via SMTP. Both async; on success writes log row.
- Success `200`: `{"title":"Success","status":200,"description":"","result":{}}`
- Errors: `400` JsonReturn with `result.error = "Invalid day parameter. Use 7 for email or 3 for SMS"`; `500 "Database Error"`; `400 "Error"` on scan (after `log.Fatalln`).
- DB: SELECT `"Policy_Header"` JOIN `sec_user`; SELECT/INSERT/UPDATE `log_noti_renewal` (`LogCarInspectionNotification`, `controllers/notificationUser.go:1640`).
- Outbound: ThaiBulkSMS or SMTP.

### 17. GET `{N}/sms/true`
- Purpose: test — sends a fixed Thai message through the True SMS XML gateway to a hardcoded MSISDN.
- Success `200 text/plain`: raw gateway response body. A network error panics (nil response) → recovered 500.
- DB: none. Outbound: True gateway.

### 18. POST `{N}/get_app_notification_id`
- Auth: `AuthMiddleware` (Bearer JWT; claim `id` used as `user_id`). Request body is not read.
- Success `200`:

```json
{
  "title": "Success", "status": 200, "description": "",
  "result": [{
    "source": "system", "noti_type": "policy", "subject": "...", "message": "...",
    "create_date": "2026-09-23T10:00:00Z", "update_date": null, "app_noti_id": 123,
    "icon_type": "info", "user_id": "uuid", "flag_read": false, "flag_read_date": null,
    "redirect_url": null, "image_url": null
  }]
}
```

- Errors: `400 text/plain` from middleware; `500 {"title":"","status":500,...}` on DB error. A token without an `id` string claim panics (recovered → 500).
- DB: SELECT `app_notification` WHERE `is_active=true AND user_id=$1` ORDER BY `create_date DESC`.

### 19. POST `{N}/update_notification_read_flag`
- Request body (`models.UpdateNotificationReadFlag_View`):

```json
{ "id": "user-uuid", "app_noti_id": 123 }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `id` | string (user_id) | yes | `validate:"required"` (enforced) |
| `app_noti_id` | int | yes | `validate:"required"` (enforced; 0 fails) |

- Success `200`: `{"title":"Success","status":200,"description":"","result":[]}`
- Errors: `400 text/plain` (bind); `400 {"result":{"message":"<validator>"}...}`; `400 {"title":"Data not found","status":400,...}` when 0 rows; `500` on DB error.
- DB: UPDATE `app_notification` SET `flag_read=true, flag_read_date=now()` WHERE `user_id` AND `app_noti_id`.
- Note: unauthenticated — any caller can change any user's flags.

### 20. POST `{N}/update_notification_read_flag_all`
- Request body: `{ "id": "user-uuid" }` — `id` string, `validate:"required"` (enforced).
- Success / errors as #19 (`Data not found` when user has no rows; 500 bodies use titles `""`/`"2"`, not-found result `"3"`).
- DB: UPDATE `app_notification` SET `flag_read=true, flag_read_date=now()` WHERE `user_id`.

### 21. POST `{N}/push_notification_id`
- Purpose: push one stored in-app notification (not yet pushed, `noti_date IS NULL`) to all FCM tokens of its owner; on ≥1 success set `noti_date=NOW()`.
- Request body (`models.PushNotificationID_View`): `{ "id": "123" }` — `id` string (app_noti_id), `validate:"required"` (enforced).
- Success `200`: `{"title":"Send notification success","status":200,"description":"","result":null}`
- Errors: `400` (bind text / validator); `400 {"title":"Data not found"}`; `400 {"title":"Failed to send notification"}` (no token / FCM error); `500 {"title":""}` or `{"title":"Update notification failed"}`.
- DB: SELECT `app_notification` JOIN `sec_user`; SELECT `app_notification_token` LEFT JOIN `sec_user`; UPDATE `app_notification.noti_date`.
- Outbound: FCM `SendMulticast`.

### 22. POST `{N}/get_noti_point_expire`
- Purpose: batch — e-mail each user whose loyalty points expire in the current month (net positive), template `email_template/noti_point_expire.html` (`Name`, `Last_name`, `Point_Total`, `Start_Date`, `Expire_Date_Th`, ...). Async SMTP sends. Request body not read.
- Success `200`: `{"title":"Success","status":200,"description":"","result":{}}`
- Errors: `400 "Error"` on scan (after `log.Fatalln`); template error → Echo 500.
- DB: SELECT `sec_user` JOIN `loyalty_point_trans` (aggregations).
- Outbound: SMTP.

### 23. POST `{N}/get_noti_policy_expire`
- Purpose: legacy policy-expiry notification job. Returns immediately; work runs in a background goroutine (concurrency 50). Guarded by an in-process mutex flag (per pod only); the flag is reset (and panics recovered) when the worker ends.
- FX-02 (2026-09-24): the two stored-function queries now run **inside** the background goroutine (before, they ran in the request and the reply carried `notifications_found`). The response no longer has `notifications_found`. A second call while a run is in progress answers `already_running` instead of starting another run. The sending budget is **10 minutes, starting after the queries finish** (no send phase when 0 rows).
- Request body: not read.
- Success `200` (started):

```json
{ "title": "Success", "status": 200, "description": "",
  "result": { "message": "Notification expiration scan and dispatch job started in background", "status": "processing_in_background" } }
```

- Success `200` (already running): `result.status = "already_running"`, title `Already Running`.
- Background work: `select * FROM insurverse."fn_policy_renewal_noti"()` and `select * FROM insurverse."fn_policy_renewal_noti_log"()`; renders `email_template/noti_policy_expire.html`; **the SMTP send and SMS send are commented out**, yet `UpdateGetPolicyExpire` still sets `log_noti_renewal.noti_email_at` (and `noti_sms_at`, always NULL) for every row with an e-mail — rows are marked notified without anything being sent.
- DB: stored functions `fn_policy_renewal_noti` (no args; returns TABLE(rtn_success, rtn_error_code, rtn_msg, rtn_log_noti_id, rtn_noti_code, rtn_expire_count, ...); on UAT-ISV it reads `Policy_Header`, `log_noti_renewal`, `Policy_coverage_premium`, `sec_user`, `province`, calls `fn_policy_renewal(...)` and UPDATEs `log_noti_renewal`), `fn_policy_renewal_noti_log` (read-only on UAT-ISV); UPDATE `log_noti_renewal`.
- Outbound: none effective.

### 24. POST `{N}/messaging`
- Request body (`models.Messaging`):

```json
{ "email": ["kritsana.w.os@horixon-t8.com"], "title": "Insurverse", "body": "ข้อความ" }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | []string | yes | `validate:"required"` (enforced) |
| `title` | string | yes | enforced |
| `body` | string | yes | enforced |

- Success `200`: `{"title":"Success","status":0,"description":"","result":""}` (push sent in background goroutine; result not reported).
- Errors: `400 {"message":"..."}` (bind / validator).
- DB: SELECT `app_notification_token` LEFT JOIN `sec_user` WHERE `sec_user.email = ANY(...)`.
- Outbound: FCM.

### 25. POST `{N}/broadcast`
- Request body (`models.Broadcast`): `{ "title": "...", "body": "..." }` — both `validate:"required"` (enforced).
- Success `200`: `{"title":"Success","status":0,"description":"","result":""}`
- Errors: `400 {"message":"..."}`.
- DB: SELECT all `app_notification_token.noti_token`.
- Outbound: FCM `SendMulticast` with every token in one call. ⚠️ unverified: FCM multicast accepts at most 500 tokens per call; larger token sets would fail (error is discarded in the goroutine).

### 26. PUT `{N}/noti_token`
- Auth: `ValidateToken` (Bearer JWT). The JWT subject is **not** used; the target user comes from the body `email`.
- Request body (`models.UpdateNotiToken`):

```json
{ "email": "kritsana.w.os@horixon-t8.com", "noti_token": "fcm-registration-token" }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | string | yes | enforced |
| `noti_token` | string | yes | enforced |

- Success `200`: `{"title":"Success","status":0,"description":"","result":""}`
- Errors: `401 {"error":...}` from middleware; `400 {"message":...}`; `400 "user not found"` (JSON string).
- DB: SELECT `sec_user` by email; SELECT `app_notification_token` by user_id; INSERT (`create_at=NOW()`) or UPDATE (`update_at=NOW()`) `app_notification_token`.

### 27. GET `{N}/messaging_fix`
- Purpose: batch re-push — for every `app_notification` with `noti_date IS NULL` joined to a token, push via FCM (goroutine per row), then set `noti_date=NOW()` for all selected ids regardless of send result.
- Success `200`: `{"title":"Success","status":200,"description":"","result":{}}`
- Errors: `400 "Error"` on scan (after `log.Fatalln`).
- DB: SELECT `app_notification` JOIN `app_notification_token`; UPDATE `app_notification.noti_date`.
- Outbound: FCM. A failed FCM send calls `log.Fatalln` inside the goroutine (process exit).

### 28. GET `{N}/test/rules`
- Query: `type` (default `policy_renewal`), `days` (int, default `30`).
- Success `200`:

```json
{
  "notification_type": "policy_renewal", "days_before": 30,
  "rules": { "enable_email": true, "enable_sms": false, "email_template_code": "...", "sms_template_code": "..." },
  "sms_template_content": "...", "status": "success"
}
```

- Errors: `400 {"error":"Invalid days parameter"}`; `404 {"message":"No rules found for <type> with <n> days"}`; `500 {"error":"Failed to get rules: ..."}`.
- DB: SELECT `notification_business_rules`; SELECT `notification_templates_extended` (`channel_type='sms'`).
- Note: on UAT-ISV `notification_business_rules` exists but has 0 rows, so this returns 404.

### 29. POST `{N}/queue/process`
- Purpose: synchronously process up to 10 `pending` items (`scheduled_at <= NOW()`) and up to 10 retry-eligible `failed` items. Each item: status → `processing`; e-mail via `SendEmailThaibulk` (ThaiBulk Email API, template from `thaibulk_templates`) or SMS via ThaiBulkSMS (template from `notification_templates_extended`, `{{key}}` replacement); then `sent` or `failed` with backoff `retry_delay_seconds`.
- Request body: none.
- Success `200`:

```json
{ "processed": 3, "errors": 1, "pending_items": 4, "retry_items": 0, "status": "completed" }
```

- Errors: `500 {"error":"Failed to get pending items: ..."}`.
- DB: SELECT/UPDATE `notification_queue`; SELECT `notification_templates_extended`, `thaibulk_templates`; INSERT `log_api_thaibulk`, `log_thaibulk_send`.
- Outbound: ThaiBulk Email API, ThaiBulkSMS.

### 30. POST `{N}/queue/add`
- Request body:

```json
{
  "channel_type": "email",
  "template_code": "25040415-1859-8d9b-b357-c5c2e22f19a9",
  "recipient_data": { "email": "kritsana.w.os@horixon-t8.com" },
  "template_data": { "FirstName": "กฤษณะ" },
  "priority": 1,
  "reference_id": "POLICY-001",
  "reference_type": "policy"
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `channel_type` | string | yes | must be `email` or `sms` (checked) |
| `template_code` | string | yes (tag `binding:"required"`) | gin-style tag, **not enforced** by Echo |
| `recipient_data` | object | yes (same, not enforced) | processor expects `email` (email) or `phone` (sms) key |
| `template_data` | object | yes (same, not enforced) | placeholders |
| `priority` | int | no | 0 → 1; lower is processed first |
| `reference_id` | string | no | — |
| `reference_type` | string | no | — |

- Success `200`: `{"message":"Notification added to queue successfully","status":"queued"}`
- Errors: `400 {"error":"Invalid request format"}`; `400 {"error":"Invalid channel type. Supported: email, sms"}`; `500 {"error":"Failed to add to queue"}`.
- DB: INSERT `notification_queue`.

### 31. GET `{N}/queue/stats`
- Success `200`:

```json
{
  "summary": { "total_pending": 0, "total_failed": 0, "total_sent": 0, "retry_ready": 0 },
  "details": [{ "status": "sent", "channel_type": "email", "count": 10, "oldest": "...", "newest": "..." }],
  "status": "success"
}
```

- Errors: `500 {"error":"Failed to get statistics: ..."}`.
- DB: SELECT aggregates on `notification_queue`.

### 32. GET `{N}/poc`
- Success `200`: `{"title":"POC Success","status":0,"description":"","result":""}`. No DB.

### 33. POST `{N}/renewal/prep`
- Purpose: stage 1 of the renewal pipeline. Creates a `batch_jobs` row (`renewal_prep`, `PENDING`), returns immediately, and in a background goroutine:
  1. Loads active `renewal_template` rows (`notification_type='policy_renewal'`) → map `days_left → channel` and required placeholders per `template_name`. No templates → job FAILED (`ISV0530`).
  2. Computes target expiry dates = `send_date + (days_left - 1)` for each configured day.
  3. Discovers MV (motor voluntary) policies and MC (compulsory / CTPL) policies expiring on those dates (`discoverMVProfile`, `discoverMCProfile`), filtered by `RENEWAL_ALLOWED_PARTNERS` (empty partner_code always allowed), excluding already-renewed policies, active paired MC, and `RENEWAL_EXCLUDED_PROMO_CODES`; groups into scopes `mv`, `mc`, `mvmc`.
  4. Day-0 is only for scope `mc`.
  5. For each recipient calls isv-test `summary-link` to get `link_payment` and `total_amt`; builds link (class `2+`/`3` MV or MVMC → new-plan shopping link under `RENEWAL_PWA_BASE_URL`; else payment link) with UTM params.
  6. Template name: e-mail `EMAIL_RENEWAL_<SCOPE>_D<n>[_C2]`, SMS `SMS_RENEWAL_<SCOPE>_D<n>[_C2]`.
  7. Payload keys: `EMAIL_ADDRESS`, `FIRST_NAME`, `PHONE`, `BIRTHDAY`, `LICENSE_NO`, `POLICY_MV`, `POLICY_MC`, `EXP_MV`, `EXP_MC`, `OPTION_1..4`, `PROVINC`, `LINK_RENEW`; validated against template placeholders. Missing e-mail/phone, link error, or missing placeholders → row status `FAILED` with `error_description`.
  8. Bulk INSERT (batches of 100) into `renewal_notification` with `ON CONFLICT (COALESCE(mc_no,''), COALESCE(mv_no,''), channel, days_left, policy_enddate) WHERE status <> 'FAILED' DO NOTHING` (matches unique partial index `renewal_notification_unique` on UAT-ISV).
  9. Updates `batch_jobs` to `SUCCESS` / `FAILED` (+ `error_message`).
- Request body (optional; empty body allowed):

```json
{ "date": "2026-09-23" }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `date` | string | no | `validate:"omitempty,datetime=2006-01-02"`; must not be in the future (Bangkok); default = today (Bangkok) |

- Success `200`: `{"code":"ISV0000","message":"success"}` (job accepted; outcome only in `batch_jobs` and logs).
- Errors: `400 {"code":"ISV0100","message":"Invalid request: field 'date' is invalid"}`; `500 {"code":"ISV0300","message":"Cannot connect to database"}` if `batch_jobs` insert fails.
- DB: INSERT/UPDATE `batch_jobs`; SELECT `renewal_template`, `"Policy_Header"`, `"Policy_coverage_premium"`, `"Lead_coverage_premium"`, `"Policy_Car_Act_Discount_Premium"`, `"Lead_Car_Act_Discount_Premium"`, `promo_code_trans`, `sec_user`, `province`; INSERT `renewal_notification`.
- Outbound: `backend-isv-test-service` summary-link (per recipient, sequential, 30 s timeout).

### 34. POST `{N}/renewal/dispatch`
- Purpose: stage 2. Creates `batch_jobs` row (`renewal_dispatch`). If the latest `renewal_prep` job (by `updated_at`) is not `SUCCESS`, finishes the dispatch job as SUCCESS and returns 200 without sending. Otherwise, in background:
  1. SELECT `renewal_notification` WHERE `status='PENDING' AND send_date = <date>` (SMS first).
  2. Load ThaiBulk credentials from `thaibulk_configs` (`owner='insurverse'`, active, latest).
  3. Worker pool (`RENEWAL_DISPATCH_WORKERS`) throttled by a shared ticker (`RENEWAL_DISPATCH_RATE_PER_SEC`).
  4. Per row: load `renewal_template` by `template_ref` (body, subject, template_code). E-mail → ThaiBulk Email API (`template_uuid` = template_code, `payload` = stored JSON, subject from template). SMS → Go `text/template` render of body, ThaiBulkSMS v2 with `scheduled_delivery` = today 09:05 Bangkok.
  5. HTTP 429 → retry up to `RENEWAL_DISPATCH_MAX_RETRY` with exponential backoff from `RENEWAL_DISPATCH_RETRY_BASE_MS`.
  6. UPDATE row `SUCCESS` + `message_id`, or `FAILED` + `error_description` (DB writes retried `RENEWAL_DB_WRITE_ATTEMPTS` × `RENEWAL_DB_WRITE_BACKOFF_MS`).
  7. Summary e-mail (HTML from embedded `templates/renewal_summary.html` + CSV attachment of all rows for the date) to `EMAIL_RENEWAL_SUMMARY_RECEIVER` (+ `EMAIL_RENEWAL_SUMMARY_CC`); skipped if receiver empty; subject prefixed `[<ENV>]` outside prod.
  8. UPDATE `batch_jobs` SUCCESS / FAILED.
- Request body: same as #33 (`date`, optional, not future).
- Success `200`: `{"code":"ISV0000","message":"success"}` (also when skipped because prep did not succeed).
- Errors: `400 ISV0100` (date); `500 ISV0300` (batch job insert or prep-status lookup failed).
- DB: INSERT/UPDATE/SELECT `batch_jobs`; SELECT/UPDATE `renewal_notification`; SELECT `renewal_template`, `thaibulk_configs`.
- Outbound: ThaiBulk Email API (`EMAIL_API_URL`), ThaiBulkSMS (`SMS_API_URL`), SMTP (summary).

### 35. GET `{N}/renewal/callback`
- Purpose: ThaiBulk delivery/click callback for renewal-pipeline messages. Stores every call (no required-field check, no existence check).
- Query params: `message_id`, `recipient`, `status`, `reason`, `click_url` — all optional strings; empty → NULL.
- Success `200`: `{"code":"ISV0000","message":"success"}`
- Errors: `500 {"code":"ISV0300","message":"Cannot connect to database"}` on insert failure.
- DB: INSERT `thaibulk_events`.

---

## Background Jobs

No cron library, ticker loop, queue consumer, or scheduler is started from `main.go`. `main.go` only initialises logger, config, the Postgres pool, and the Firebase messaging client, then starts Echo. All "jobs" below are HTTP-triggered by an external scheduler (a Cloud Scheduler job is mentioned in code comments; schedule definitions are not in this repo — ⚠️ unverified schedules).

| Job (trigger endpoint) | Mode | What it does | Tables / functions |
|---|---|---|---|
| Renewal prep (`POST /renewal/prep`) | async goroutine, tracked in `batch_jobs` | Builds renewal notification rows for email days / SMS days configured in `renewal_template` (comment in router: email 90/60/30, sms 15/7/3/0) | `batch_jobs`, `renewal_template`, policy/lead tables, `promo_code_trans`, `sec_user`, `province`, `renewal_notification`; calls isv-test service |
| Renewal dispatch (`POST /renewal/dispatch`) | async goroutine, worker pool + rate limiter, tracked in `batch_jobs` | Sends PENDING rows via ThaiBulk; summary e-mail | `batch_jobs`, `renewal_notification`, `renewal_template`, `thaibulk_configs` |
| Legacy policy expiry (`POST /get_noti_policy_expire`) | async goroutine (queries + send), 10-min send budget after the queries, per-pod mutex (`already_running` on overlap) — FX-02 (2026-09-24) | Calls stored functions, marks `log_noti_renewal.noti_email_at`; sending is commented out | `fn_policy_renewal_noti`, `fn_policy_renewal_noti_log`, `log_noti_renewal` |
| Queue processor (`POST /queue/process`) | synchronous, 10 + 10 items per call | Sends queued e-mail/SMS with retry bookkeeping | `notification_queue`, `notification_templates_extended`, `thaibulk_templates`, `log_api_thaibulk`, `log_thaibulk_send` |
| Car inspection reminder (`GET /:type/inspection/:day`) | handler + per-row goroutines | SMS (day 3) / e-mail (day 7) | `Policy_Header`, `sec_user`, `log_noti_renewal` |
| Paid-but-no-policy SMS (`GET /sms/policy`) | per-row goroutines | SMS 2 days after payment | `Lead_coverage_premium`, `Policy_coverage_premium`, `sec_user` |
| Point expiry e-mail (`POST /get_noti_point_expire`) | per-row goroutines | Monthly point-expiry e-mail | `sec_user`, `loyalty_point_trans` |
| Re-push unsent in-app (`GET /messaging_fix`) | per-row goroutines | FCM re-push, marks `noti_date` | `app_notification`, `app_notification_token` |
| Retired renewal (`POST /send_policy_renewal_notification`, `POST /send_policy_thaibulk`) | no-op | Returns 200 only | — |
| Request logging (every request except `/healthcheck` and `/api/v1/notification/email`) | goroutine per request | Stores request/response dump | `log_noti_push` |

---

## DB Usage

All objects are in schema `insurverse`. Existence confirmed on UAT-ISV (all 25 tables and both functions present).

| Table / function | Read / Write | Endpoints / jobs |
|---|---|---|
| `log_noti_push` | W (INSERT) | all routes via body-dump middleware (except `/healthcheck`, `/email`) |
| `thaibulk_templates` | R/W | W: `POST /api/v1/thaibulk/template`; R: `/queue/process` (email) |
| `log_thaibulk_send` | R/W | W: `/queue/process`; R: `/api/v1/thaibulk/logs/search`, `/webhook/thaibulk` |
| `log_api_thaibulk` | W | `/queue/process` (email) |
| `thaibulk_webhook_logs` | R/W | W: `/webhook/thaibulk`; R: `/api/v1/thaibulk/logs/search` |
| `thaibulk_events` | W | `/renewal/callback` |
| `thaibulk_configs` | R | `/renewal/dispatch` |
| `app_notification` | R/W | R: `/get_app_notification_id`, `/push_notification_id`, `/messaging_fix`; W: `/update_notification_read_flag`, `/update_notification_read_flag_all`, `/push_notification_id`, `/messaging_fix` |
| `app_notification_token` | R/W | R: `/messaging`, `/broadcast`, `/push_notification_id`, `/messaging_fix`, `/noti_token`; W: `/noti_token` |
| `sec_user` | R | `/messaging`, `/push_notification_id`, `/noti_token`, `/email/input_policy/:lead_no`, `/sms/policy`, `/:type/inspection/:day`, `/get_noti_point_expire`, `/renewal/prep` |
| `notification_business_rules` | R | `/test/rules` (0 rows on UAT-ISV) |
| `notification_templates_extended` | R | `/test/rules`, `/queue/process` (sms) |
| `notification_queue` | R/W | `/queue/add`, `/queue/process`, `/queue/stats` |
| `"Lead_coverage_premium"` | R | `/email/input_policy/:lead_no`, `/sms/policy`, `/renewal/prep` |
| `"Policy_coverage_premium"` | R | `/email/input_policy/:lead_no`, `/sms/policy`, `/renewal/prep` |
| `"Policy_Header"` | R | `/:type/inspection/:day`, `/renewal/prep` |
| `"Policy_Car_Act_Discount_Premium"` | R | `/renewal/prep` |
| `"Lead_Car_Act_Discount_Premium"` | R | `/renewal/prep` |
| `promo_code_trans` | R | `/renewal/prep` |
| `province` | R | `/renewal/prep` |
| `loyalty_point_trans` | R | `/get_noti_point_expire` |
| `log_noti_renewal` | R/W | `/:type/inspection/:day` (R/INSERT/UPDATE), `/get_noti_policy_expire` (UPDATE; also written inside `fn_policy_renewal_noti`) |
| `batch_jobs` | R/W | `/renewal/prep`, `/renewal/dispatch` |
| `renewal_template` | R | `/renewal/prep`, `/renewal/dispatch` |
| `renewal_notification` | R/W | W: `/renewal/prep` (INSERT ... ON CONFLICT DO NOTHING); R/W: `/renewal/dispatch` |
| `fn_policy_renewal_noti()` | call (function writes `log_noti_renewal`, nests `fn_policy_renewal`) | `/get_noti_policy_expire` |
| `fn_policy_renewal_noti_log()` | call (read-only on UAT-ISV) | `/get_noti_policy_expire` |

No `CALL` procedures, no advisory locks, no `SELECT ... FOR UPDATE` anywhere in the service. No GORM (raw SQL via sqlx only).

---

## Notes / ⚠️ unverified items

**Commented-out / retired / unrouted code**
- No routes are commented out in `router/router.go`. Two routes are explicitly marked `[RETIRED]` (#6, #7) and map to the no-op `RetiredRenewalJob`.
- Unrouted handlers (dead code): `SendPolicyRenewalNotification` (`controllers/notificationUser.go:1124`, the old renewal job — per code comment it failed at `notification_business_rules`), `HandleThaiBulkSMSWebhook` (`controllers/notificationUser.go:1705`, uses a nil package-level `*sql.DB`), `SendSmsApi` (AIS) and `SendSmsApiTrue` helpers, `SendEmailThaibulkWithRetry` (commented out).
- `SendLineNotify` HTTP call is commented out; it only prints.

**Behavioural risks found while reading**
- `GET/POST /get_noti_policy_expire`: e-mail and SMS sends are commented out but `log_noti_renewal.noti_email_at` is still updated — rows appear notified without delivery.
- `messaging_fix` marks every selected notification as pushed even when FCM fails; failed FCM send calls `log.Fatalln` inside a goroutine (process exit).
- Several batch handlers call `log.Fatalln` on a row scan error (process exit, not a 400).
- `Read()` errors are ignored in `GetNotiTokenByEmail`, `GetAllNotiToken`, `GetMessagingFix`, `GetNotiEmailInputPolicy`, `GetNotiPointExpire` — a DB error yields a nil-pointer panic (recovered → 500).
- `validate:"required"` tags on `SendSms`, `SendEmail`, `SendApp` are not enforced; `binding:"required"` on `/queue/add` is a Gin tag and has no effect in Echo.
- `/email`: multiple `cc_email` entries — only the last is kept (`SetHeader("Cc", ...)` in a loop).
- Read-flag, broadcast, messaging, SMS/e-mail send, queue and renewal trigger endpoints have no authentication. `/noti_token` checks a JWT but writes for the e-mail supplied in the body.
- `ValidateToken` stores claims in a package-global variable (data race across requests).
- Legacy policy-expiry job mutex and renewal jobs are per-pod; with more than one replica the same job can run concurrently (renewal INSERT is protected by the unique partial index; dispatch is not — two dispatch runs could send the same PENDING row twice). ⚠️ unverified replica count.
- Renewal summary e-mail uses its own `SendEmailSMTP` with compiled-in SMTP host/port and no auth (ignores `SMTP_HOST`/`SMTP_PORT`/`SMTP_USER`/`SMTP_PASS`).
- Hardcoded credentials exist in source (`constants/constant.go`: DB fallback credentials, ThaiBulk keys, OneSignal token, Firebase service-account private key; `middlewares/Validate.go`: JWT HMAC secret; `controllers/notificationController.go`: True SMS Basic auth). A `key.json` file is also present at the repo root. Values intentionally not reproduced here; rotation / move to secrets is recommended.

**⚠️ unverified**
- External scheduler (Cloud Scheduler) job names, cron expressions and which endpoints are still scheduled — not defined in this repo.
- `notification_business_rules` is empty on UAT-ISV; the code comment says the table "was never created" (likely refers to another environment). Status on UAT / Prod not checked.
- Response shape of OneSignal / ThaiBulk / isv-test beyond the fields the code parses.
- Exact contents of `renewal_template` rows (days / channels / placeholders) — data-driven, not in code.
- FCM 500-token multicast limit impact on `/broadcast` (depends on token count).
