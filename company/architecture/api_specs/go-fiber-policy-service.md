# go-fiber-policy-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-fiber-policy-service` (Go module `policy-tiptanjai-service`).
> Generated from route registration (`internal/server/server.go`, `internal/handler/router.go`) and handler → service → repository code. The repo's own `CLAUDE.md` and swagger `docs/` were used only as hints; every item below was checked in code.
> Spec date: 2026-09-23. Read-only analysis; nothing was executed.

---

## Overview (ภาพรวม)

| Item | Value |
|---|---|
| Purpose | TQM partner channel for motor insurance ("Tiptanjai"). Imports TQM lead files from GCS as drafts, issues **VMI** (voluntary motor, `MV-…`) and **CMI/ACT** (compulsory, พ.ร.บ.) policies in scheduler-triggered batch jobs, pushes them to Salesforce and to IIA (SOAP), sends CMI realtime to OIC, writes return / endorsement files to TQM's SFTP, emails data-problem and reconcile reports, and proxies the OIC driver-behaviour API. Plus tech-support routes to resend / query IIA. |
| Framework | Go 1.25 + Fiber v2.52.8, `pgx/v5` pool + `scany/pgxscan` (raw SQL, no ORM), viper config, zap logger, GCS client, SFTP pool. |
| Port | `HTTP_PORT` (Helm `containerPort` ⚠️ not checked per env). |
| Base path | `/api/v1/policy` (`common.BasePath`). Groups `/tqm`, `/oic`, `/support`. Probes `/live`, `/ready` at root. |
| DB schema | `insurverse` (PostgreSQL); `DATABASE_SCHEMA` env. |
| Server | Read / Write / Idle timeout 3 min. Global limiter: 100 req / 1 min per client IP (Fiber default key). |
| Response envelope | `middleware.ResponseOK` → `{ "statusCode":"0000", "message":"Success", "timestamp":"2006-01-02T15:04:05", "result": any }`. Errors (`HandleError`) → `{ "statusCode":"1000", "message": string, "timestamp" }`; HTTP 500 message is replaced by a generic text. `ResponseErrorWithResult` → `{statusCode:"1000", message:"Error", timestamp, result:[…]}` (per-row validation errors). The two `/oic/*` handlers return the raw `BehaviorDataResponse` in some branches (see #16). |

### Environment variables (names only / ชื่อตัวแปรเท่านั้น)

Loaded by viper (`internal/config/config.go`; env file if present, else `os.Getenv`):
`DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_NAME`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_SCHEMA`, `HTTP_PORT`, `ENV`, `Base_Url`, `TZ`, `ISV_COOKIE_TOKEN` (outbound HTTP client cookie), `CLIENT_TIMEOUT`, `RATE_LIMIT_CONN`, `RATE_LIMIT_WINDOW` (declared, **not used** by the limiter), `SF_ENDPOINT`, `SF_AUTH_USERNAME`, `SF_AUTH_PASSWORD`, `SF_AUTH_CLIENT_ID`, `SF_AUTH_CLIENT_SECRET`, `SF_AUTH_GRANT_TYPE`, `CMI_Realtime_URL`, `CMI_Realtime_Endorse_URL`, `Base_URL_IIA`, `Base_URL_IIA_Reconcile`, `Backend_Doc`, `Backend_Notification`, `ERROR_ALERT_EMAIL`, `TQM_EMAIL`, `FTP_ADDRESS`, `FTP_USER`, `FTP_PASS`, `FTP_CONCURRENCY`, `FTP_POOLSIZE`, `HTLM_ADMIN_TEMPLATE_PATH`, `HTLM_IMPORT_COMPLETE_PATH`, `HTLM_RECONCILE_PROBLEM_PATH`, `PARTNER_COMPANY_CODE`, `CUSTOMER_GROUP_ID`, `OIC_TOKEN`, `OIC_ENDPOINT`.
GCS credentials: file `key.json` resolved from the project root (`external.GetGCSCredential`).

### External / third-party calls (การเรียกระบบภายนอก)

| Target | Method + path | Caller |
|---|---|---|
| GCS | read object from `gs://bucket/object` given in the request (`GetSmartDecodedReaderFromGCS`, Thai encoding then UTF-8 fallback); V4 signed URL for inspection images (`SignImagePath`) | #4, #7, #9, #10 drafts; #5 VMI issue (attachments) |
| Salesforce | OAuth `SF_ENDPOINT`; `POST {instance}/services/apexrest/upsertleadvmi` · `upsertleadcmi` · `upsertpolicy` · `upsertpolicyattachment` · `upsertaccount` · `tqmreconcile` | #5, #8, #12 |
| IIA (SOAP) | `POST {Base_URL_IIA}` (SVToTemp XML) | #5, #8, #18 |
| IIA reconcile / get policy | `POST {Base_URL_IIA_Reconcile}` | #19, #20 |
| OIC CMI realtime | `POST {CMI_Realtime_URL}` | #8 (ACT issue) |
| OIC driver behaviour | `POST {OIC_ENDPOINT}` with `Authorization: Bearer {OIC_TOKEN}` | #17 |
| Internal document | `GET {Backend_Doc}policy/tqm/{policyNo}` (VMI), `GET {Backend_Doc}act/{carActNo}` (ACT) | #5 (VMI), ACT doc ⚠️ (function exists; caller not found) |
| Internal notification | `POST {Backend_Notification}email` | #12, #13, import-failed mails (#4, #9) |
| TQM SFTP | upload via pool (`FTP_ADDRESS` / `FTP_USER` / `FTP_PASS`) | #6, #11, #14 |
| Arbitrary URL | `GET {fileURL}` (`DownloadFileFromURL`) | #11 |

---

## Auth & Middleware (การยืนยันตัวตน)

Global (in order, `internal/server/server.go`):
1. `limiter.New` — 100 requests / minute, key = client IP; over limit → `429 "Too Many Requests"`.
2. `cors.New(DefaultCorsConfig())` — `AllowOrigins: "*"`.
3. `middleware.LogHandler()` — request log (stdout).
4. `healthcheck.New` — `GET /live` (always true), `GET /ready` (DB ping).
5. Swagger `GET /api/v1/policy/swagger/*` — only when `ENV` ≠ `PROD`.
6. `NewLogToDBMiddleware` — async insert of every request (except probe paths) into `insurverse.log_internal_interface`: url, method, **all request headers**, request body, response body, user id / trace id.
7. Validator: go-playground + custom `no_special_char` rule.

**No authentication on any route.** `internal/middleware/validate_token.go` (`ValidateToken`) exists but is not registered. The only check in code is inside `POST /oic/behavior_data`: `Authorization == "Bearer " + OIC_TOKEN`.
No roles / permissions model. Comments in `router.go` say `/support/*` "should be restricted (internal / IT support)", but nothing enforces it in the app; access control is assumed at ingress / network (⚠️ unverified).

---

## Endpoint Summary

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/live` | none | `server.go` `healthcheck.New` | Liveness |
| 2 | GET | `/ready` | none | `server.go` `readinessDatabase` | DB ping |
| 3 | GET | `/api/v1/policy/swagger/*` | none (non-PROD only) | `swagger.HandlerDefault` | Swagger UI |
| 4 | POST | `/api/v1/policy/tqm/vmi` | none | `internal/handler/handler.go:30` `SaveVMIPolicyDraftHandler` | Import VMI lead file from GCS → validate → save draft |
| 5 | GET | `/api/v1/policy/tqm/vmi` | none | `handler.go:96` `IssueVMIPolicyHandler` | **Batch**: issue VMI policies for `INSPECTED` leads (async) |
| 6 | GET | `/api/v1/policy/tqm/vmi/ftp` | none | `handler.go:223` `FTPVMIPolicyHandler` | **Batch**: return-text file to TQM SFTP (async) |
| 7 | POST | `/api/v1/policy/tqm/vmi/validate` | none | `handler.go:65` `ValidateVMILeads` | Validate VMI lead file only (no save) |
| 8 | GET | `/api/v1/policy/tqm/cmi` | none | `handler.go:339` `IssueCMIPolicyHandler` | **Batch**: issue ACT/CMI policies (async) |
| 9 | POST | `/api/v1/policy/tqm/cmi` | none | `handler.go:305` `SaveCMIPolicyDraftHandler` | Import CMI lead file from GCS → save draft |
| 10 | POST | `/api/v1/policy/tqm/cmi/validate` | none | `handler.go:274` `ValidateCMILeads` | Validate CMI lead file, return parsed leads |
| 11 | POST | `/api/v1/policy/tqm/upload-policy` | none | `handler.go:413` `UploadFileToSFTPHandler` | Download a URL and upload it to TQM SFTP ⚠️ |
| 12 | POST | `/api/v1/policy/tqm/reconcile-problem` | none | `handler.go:442` `ReconcileProblem` | Build reconcile-problem XLSX, SF `tqmreconcile`, email |
| 13 | GET | `/api/v1/policy/tqm/notification/data-problem` | none | `handler.go:391` `NotificationDataProblem` | Email pending data-problem notifications |
| 14 | GET | `/api/v1/policy/tqm/endorsement/upload` | none | `handler.go:464` `UploadFileEndorsement` | Upload endorsement docs of a date to SFTP |
| 15 | POST | `/api/v1/policy/tqm/test` | none | `handler.go:374` `Testing` | Test stub (no-op) |
| 16 | POST | `/api/v1/policy/oic/behavior_data` | `Bearer OIC_TOKEN` | `handler.go:577` `BehaviorDataOICHandler` | Mock of OIC behaviour API (dev/uat: fixed test list) |
| 17 | POST | `/api/v1/policy/oic/driver_behavior` | none | `handler.go:491` `BehaviorHandler` | Driver risk level via OIC for consenting drivers |
| 18 | POST | `/api/v1/policy/support/resend-iia` | none | `handler.go:141` `ResendIIAHandler` | Resend issued VMI/ACT policies to IIA (new lot no.) |
| 19 | GET | `/api/v1/policy/support/iia-policy` | none | `handler.go:168` `GetIIAPolicyHandler` | Query one policy from IIA (read-only) |
| 20 | POST | `/api/v1/policy/support/iia-policy/list` | none | `handler.go:196` `GetIIAPolicyListHandler` | Query up to 20 policies from IIA |

Total: **20 routes** (17 in `router.go`, 2 probes + swagger in `server.go`).

---

## Endpoints

### 1–3. Probes and swagger
`/live` → 200 "OK"; `/ready` → 200 if `pgxpool.Ping` ok, else 503 (Fiber healthcheck defaults). Swagger only when `ENV` ≠ `PROD`.

### 4, 7, 9, 10. Draft import / validate (TQM lead files)
**Body** (`model.SavePolicyDraft`)
| Field | Type | Required | Notes |
|---|---|---|---|
| requestDataUrl | string | yes | `gs://<bucket>/<object>` of the TQM file (parsed by `util.ParseGCSURI`) |
| requestType | string | yes | request type label (default constant `POLICY_REQUEST`) ⚠️ allowed values unverified |

```json
{ "requestDataUrl": "gs://<bucket>/tqm/vmi/20260923.txt", "requestType": "POLICY_REQUEST" }
```
Processing: read file from GCS (Thai encoding, UTF-8 fallback) → parse rows (`handlerVMIFTP` / `handlerCMIFTP`) → per-row validation and master-data mapping (`tqm_province`, `tqm_district`, `tqm_sub_district`, `tqm_salutation`, `tqm_car_license_provice`, `tqm_car_mapping`, `tqm_group_premium`, `tqm_premium`, `tqm_package_config`, `province`/`district`/`subdistrict`).
- `POST /tqm/vmi` → `UpsertVMILead` (`INSERT … tqm_lead_vmi`, `INSERT tqm_request_status`), inspection status from `tqm_car_inspect_result`.
- `POST /tqm/cmi` → `SaveCMILeadDraft` (`INSERT tqm_lead_cmi`, `INSERT "Policy_Car_Act_Discount_Premium"`, `tqm_request_status`; ACT number from `policy_no` with `SELECT … FOR UPDATE`).
- `/validate` variants do not save; CMI validate returns the parsed leads in `result`.
**Responses:** `200 {statusCode:"0000"}`; `400 {statusCode:"1000", message:"Error", result:[ListErrorLead…]}` (per-row errors); 4xx/5xx from `CustomError.Status`. On import failure an email is sent (`importFailedNotification`).

### 5. `GET /tqm/vmi` — VMI issue batch
Lock: `UPDATE tqm_allow_process` `AVAILABLE → PROCESSING` for api name `/policy/tqm/vmi`; if not acquired or error → returns `200` and does nothing. Otherwise returns `200` at once and runs in a goroutine (lock reset to `AVAILABLE` in `defer`).
Job (`IssueVMIPolicy`): `ListVMILeadByStatus(INSPECTED)` → SF `upsertleadvmi` per lead → AMLO `amlo_idnumber` blacklist → SF auth → `tqm_package_config` → per lead (`IssueVMIPolicyProcess`): validate fields / tariff (`mas_tariff`) → on problem `DATA_PROBLEM` + `tqm_notification_job`; else `UpsertVMIPolicyHeader` (`INSERT Policy_Header` with `fn_policy_invoiceno_iia()`, `fn_policy_lotno_iia()`; `INSERT Policy_coverage_premium`; `INSERT policy_participant`) → status `WAITING_DOCUMENT` → `sendIiaPolicyNormal` (IIA + `log_iia_policy`) → SF `upsertpolicy` (+`log_sf_policy`) → document service → status `DOCUMENTED` → signed inspection image URLs → SF `upsertpolicyattachment`.
Status machine (`tqm_request_status`): `WAITING_INSPECTION`, `INSPECTED`, `WAITING_DOCUMENT`, `WAITING_CMI`, `DOCUMENTED`, `DATA_PROBLEM`, `INSPECTION_PROBLEM`, `SUCCESS`, `BLACKLIST`, `REJECTED`.
**Response:** always `200 {statusCode:"0000", result:null}` (errors only in logs).

### 6. `GET /tqm/vmi/ftp` — return text to TQM
Same lock pattern (`/policy/tqm/vmi/ftp`). Reads documented leads + `Policy_Header` / `Policy_coverage_premium` / tqm masters (`GetPolicyReturnTextToTQMVMI`), builds text + delivery note, uploads to SFTP (concurrency `FTP_CONCURRENCY`), `UpdateRequestStatus`. Always `200`.

### 8. `GET /tqm/cmi` — ACT issue batch
Lock `/policy/tqm/cmi`. `ListIssueCMIPolicy` → SF auth → per item: validate → `DATA_PROBLEM` or: SF `upsertleadcmi` → **OIC CMI realtime** (`SendCMIRealTime`: `UPDATE Policy_Car_Act_Discount_Premium` CMI fields + `IIA_Lot_No = fn_policy_lotno_iia()`, `INSERT log_cmi_realtime`) → `sendIiaPolicyACT` → status `SUCCESS` → SF `upsertpolicy`. Always `200`.

### 11. `POST /tqm/upload-policy`
**Body** (`model.UploadPolicySFTP`)
| Field | Type | Required | Notes |
|---|---|---|---|
| fileURL | string | not enforced | tag is `required:"true"`, **not** `validate:"required"` |
| targetPath | string | not enforced | e.g. `endorse`; default `etc` |

Downloads `fileURL` with an HTTP GET (any URL) and uploads to SFTP at `{ftpPath}/{targetPath}/{dd-mm-yyyy Thai}/{fileName-from-URL}`. `200`; errors → `CustomError` status (0 → 500 ⚠️). No DB.

### 12. `POST /tqm/reconcile-problem`
No body. `GetListReconcileProblemVMI/CMI` (`Policy_Header`, `Policy_Car_Act_Discount_Premium`, `tqm_lead_vmi`, `tqm_lead_cmi`, `tqm_request_status`) → XLSX → SF `tqmreconcile` → email (`TQM_EMAIL`). `200` / error.

### 13. `GET /tqm/notification/data-problem`
No params. `ListNotificationDataProblem` (`tqm_notification_job`) + `GetVMIDataProblem` / `GetCMIDataProblem` → email → `UpdateNotifyStatusBulk`. `200`.

### 14. `GET /tqm/endorsement/upload?date=<dd-mm-yyyy?>`
Query `date` (optional, default = yesterday, Thai TZ; format ⚠️ unverified). Note: the empty `date` default is applied to the folder name, but the repository call receives the raw `req.Date` (empty). `GetTQMPolicyEndorsementDetail` (`Policy_endorse_detail`, `Policy_Header`, `tqm_lead_vmi`, `tqm_lead_cmi`) → upload files to SFTP → `INSERT tqm_endorse_document_status`. `200`.

### 15. `POST /tqm/test` — calls `service.Testing` (returns nil). `200 {result:null}`.

### 16. `POST /oic/behavior_data` — OIC mock
Header `Authorization: Bearer <OIC_TOKEN>` (exact string compare) else `401`.
**Body** (`BehaviorDataRequest`): `carType` (required here by manual check), `driverLists[]` (non-empty) of `{ driverNo int, idCard, driverLicense, driverBehaviorConsent *bool }`, `effectiveDate`.
`ENV` = `dev`/`uat` → risk level from a hard-coded list of 25 test ID cards (default 1). Otherwise risk 1 if ID/licence present, else -1; discount 0.
**Response (raw, not enveloped):** `200 { "status":"success", "message":"success", "driverRiskLevelLists":[{ "driverNo":1, "riskLevel":1, "discountPct":0 }] }`. No DB.

### 17. `POST /oic/driver_behavior`
**Body:** same `BehaviorDataRequest` with validator tags (`carType` required, `driverLists` required + dive, `driverNo` required, `driverBehaviorConsent` required).
Consenting drivers → `POST {OIC_ENDPOINT}` (3 s timeout). Non-consenting → risk 1 if ID/licence present else -1. Merged and sorted by `driverNo`.
**Response:** `200 {statusCode:"0000", result:{status, message, driverRiskLevelLists:[…]}}`; OIC error → its status. No DB.

### 18. `POST /support/resend-iia`
**Body** (`ResendIIARequest`)
| Field | Type | Required | Validation |
|---|---|---|---|
| policy_nos | []string | yes | `required,min=1,dive,required` (no max) |
| policy_type | string | no | `oneof=VMI ACT`; default `VMI` |

Per policy: `RegenerateIIALotNo` (`UPDATE "Policy_Header"` or `"Policy_Car_Act_Discount_Premium" SET "IIA_Lot_No" = fn_policy_lotno_iia()`) → `sendIiaPolicyNormal` / `sendIiaPolicyACT` (rebuild XML from DB via `GetMotorBO` / `GetMotorBOACT`, send, `log_iia_policy`) → extra audit row in `log_iia_policy`. No lead-status or SF change.
**Response:** `200 { result: { total, success, failed, items:[{ policy_no, … }] } }`.

### 19. `GET /support/iia-policy?policy_no=<no>`
`400 "policy_no is required"`; IIA reconcile/get call (`GetIIAPolicyReconcileRaw`); failure → `502`. `200 {result: GetIIAPolicyResult}`. No DB ⚠️.

### 20. `POST /support/iia-policy/list`
**Body:** `{ "policy_nos": [..] }` (`required,min=1,max=20,dive,required`). Calls #19 per policy (sequential). `200 {result:{total, found, not_found, failed, items[]}}`.

---

## DB Usage (schema `insurverse`)

| Table / function | R/W | Endpoints |
|---|---|---|
| `tqm_allow_process` | R/W (batch lock) | #5, #6, #8 |
| `tqm_lead_vmi` | R/W | #4, #5, #6, #12–14 |
| `tqm_lead_cmi` | R/W | #9, #8, #12–14 |
| `tqm_request_status` | R/W | #4, #5, #6, #8, #9, #12 |
| `tqm_notification_job` | R/W | #5, #8, #13 |
| `tqm_endorse_document_status` | W | #14 |
| `tqm_car_inspect_result` | R | #4, #5 |
| `tqm_province`, `tqm_district`, `tqm_sub_district`, `tqm_salutation`, `tqm_car_license_provice`, `tqm_car_mapping`, `tqm_group_premium`, `tqm_premium`, `tqm_package_config` | R | #4, #7, #9, #10, #5, #6 |
| `Policy_Header` | R/W (INSERT on issue; UPDATE `IIA_Lot_No`) | #5, #6, #12, #14, #18 |
| `Policy_coverage_premium` | R/W | #5, #6, IIA payload |
| `Policy_Car_Act_Discount_Premium` | R/W (INSERT on CMI draft; UPDATE CMI result, lot no.) | #9, #8, #12, #18 |
| `policy_participant` | R/W | #5, SF payload |
| `policy_no` | R/W (`SELECT … FOR UPDATE` + INSERT) | #9 |
| `Policy_endorse_detail` | R | #14 |
| `amlo_idnumber` | R | #5, #8 |
| `mas_tariff`, `mas_partner`, `mas_cmi_color`, `mas_cmi_province`, `mas_cmi_brand_model`, `company_detail`, `sys_param`, `iia_commission`, `payment`, `payment_act`, `promo_code`, `promo_code_trans`, `promo_group`, `sec_user`, `province`, `district`, `subdistrict` | R | IIA / SF / CMI payloads (#5, #8, #18) |
| `log_internal_interface` | W | every request (middleware) |
| `log_iia_policy` | W (async) | #5, #8, #18 |
| `log_sf_policy` | W | #5, #8 |
| `log_cmi_realtime` | W | #8 |
| `fn_policy_lotno_iia()` | fn | #5, #8, #18 |
| `fn_policy_invoiceno_iia()` | fn | #5 |
| `fn_check_sf_account(...)` | fn | SF account (#5 ⚠️, `UpsertPolicy`) |
| `fn_format_utc_timestamp`, `fn_address_clean_dist`, `fn_policy_usage_to_comp`, `fn_policy_comp_to_usage`, `fn_policy_package_iia`, `fn_display_access` | fn (read-only formatting) | IIA / SF payloads |

---

## Notes / ⚠️ unverified items (security findings first)

- **S1 ⚠️ No auth on any route.** Batch triggers (`GET /tqm/vmi`, `/tqm/cmi`, `/tqm/vmi/ftp`), draft imports, SFTP upload and `/support/*` (IIA resend) are open at the app layer. `ValidateToken` is dead code. Ingress restriction not verified.
- **S2 ⚠️ SSRF + arbitrary SFTP write.** `POST /tqm/upload-policy` fetches any `fileURL` from inside the cluster and writes it to the partner SFTP under a client-controlled `targetPath` and URL-derived file name (no validation; `..` not filtered ⚠️).
- **S3 ⚠️ Arbitrary GCS read.** Draft routes read whatever `gs://bucket/object` is given, with the service account in `key.json`.
- **S4 OIC token compare.** `behavior_data` builds the expected header as `"Bearer " + OIC_TOKEN`; if `OIC_TOKEN` is unset, the header `Bearer ` (empty token) passes. Compare is not constant-time. It is also a mock that returns fixed test data on dev/uat.
- **S5** `LogToDBMiddleware` stores all request headers (incl. `Authorization`) and full request/response bodies (citizen IDs, driver licences) in `log_internal_interface`.
- **S6** `resend-iia` has no upper bound on `policy_nos` and each item regenerates `IIA_Lot_No` (consumes lot numbers) even when the send fails (intended per code comment).
- **S7** CORS `*`; limiter is per-pod, in-memory, keyed by `c.IP()` (behind a proxy this may be the proxy IP ⚠️ — `ProxyHeader` not configured).
- **N1** Batch GET endpoints change state (GET with side effects) and always return 200, even when the lock was not acquired or the job fails; status is only in logs / `tqm_request_status`.
- **N2** `UploadPolicySFTP` uses `required:"true"` tags, which go-playground ignores — fields are effectively optional.
- **N3** `UploadFileEndorsement` computes a default date for folder naming but passes the raw (possibly empty) `date` to the repository query.
- **N4** `GenerateCMIPolicyDocument` (`{Backend_Doc}act/{no}`) exists but no caller was found — ⚠️ unverified.
- **N5** `RATE_LIMIT_CONN` / `RATE_LIMIT_WINDOW` are read but the limiter is hard-coded to 100 / 1 min.
- **N6** Helm files contain 0 `secretKeyRef` entries — secrets appear to be set as plain `value:` (values not inspected / not copied).
- **N7** DB function signatures and column types were taken from SQL text in Go only; **not** verified against the live schema (`pg_proc` / `information_schema`) — ⚠️ unverified.
