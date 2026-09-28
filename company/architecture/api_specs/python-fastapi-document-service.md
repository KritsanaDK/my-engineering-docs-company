# python-fastapi-document-service — API Spec

> Generated from source on 2026-09-23 (read-only review). File:line refs are relative to `python-fastapi-document-service/`.
>
> **Important:** despite the folder name, the running service is **Go (Fiber v2)** — module `go-isv`, entry `cmd/server`, built by the `golang:1.24.2` Dockerfile. The `controllers/*.py` files (FastAPI imports) are **legacy/dead code**: there is no FastAPI app entrypoint, no `requirements.txt`, and the imported modules (`db.connect`, `pinpoins.*`, `querys.*`, `utils.util`) do not exist in the repo. No FastAPI route is live; the Python files are not documented as endpoints.

## Overview

| Item | Value |
|---|---|
| Purpose | Generates customer documents (policy schedules, receipts / e-Tax invoices, claim documents, endorsements, PA tax-deduction certificates) for MV (voluntary motor), MC (compulsory motor / พ.ร.บ.), TA (travel), PA (personal accident), Home and TQM partner policies. PDFs are rendered by the Jasper report service, digitally signed, uploaded to the file service, their URLs written back to policy tables, then e-Tax is issued, e-mail/SMS sent and Salesforce attachment sync triggered. |
| Language / framework | Go 1.24, Fiber v2, GORM (Postgres), go-playground/validator |
| Port | `APP_PORT` (default `8080`; helm uat-isv `port: 8080`), host `APP_HOST` |
| Base path | `/api/v1/doc` (`internal/documents/server.go:91`) |
| Swagger | `GET /api/v1/doc/swagger/*` (`internal/infrastructure/server/server.go:145`) |
| Response style | "Legacy" envelope `{status, error_code, msg, result}`. **All generation endpoints are synchronous side-effect calls; the success body is a fixed mock** (`result.file_url[0].url = "mockup"`, `internal/documents/model/response/*.go MockupLegacyResponse`) — real URLs are only persisted in DB. |
| Startup checks | `cer.pem` / `cer.key` must exist at project root; `TEMPLATES_STATIC_DIR` must resolve (`internal/documents/server.go:41-56`) |

### Environment variables (names only; parsed by `caarlos0/env` in `pkg/config/model.go`, `.env` loaded via godotenv)

| Group | Names |
|---|---|
| App | `APP_NAME`, `APP_ENV`, `APP_HOST`, `APP_PORT`, `APP_DEBUG`, `APP_ROOT_PATH`, `APP_CLIENT_TIMEOUT`, `APP_RATE_LIMIT_CONN`, `APP_RATE_LIMIT_WINDOW` |
| Database | `DATABASE_DRIVER`, `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`, `DATABASE_SEARCH_PATH`, `DATABASE_TZ`, `DATABASE_SSL_MODE`, `DATABASE_MAX_OPEN`, `DATABASE_MAX_IDLE`, `DATABASE_MAX_LIFE` |
| JWT (required at boot, not used by any route) | `JWT_SECRET`, `JWT_EXPIRE`, `JWT_ISSUER`, `JWT_AUDIENCE` |
| ISV internal services | `ISV_HOST`, `ISV_HOST_UAM_INTERNAL`, `ISV_HOST_JASPER_INTERNAL`, `ISV_HOST_FILE_INTERNAL`, `ISV_HOST_PURCHASE_INTERNAL`, `ISV_COOKIE_TOKEN`, `ISV_ENDPOINT_JASPER_REPORT`, `ISV_ENDPOINT_UAM`, `ISV_ENDPOINT_UPLOAD_FILE`, `ISV_ENDPOINT_PURCHASE`, `ISV_ENDPOINT_NOTIFICATION_SMS`, `ISV_ENDPOINT_NOTIFICATION_EMAIL` |
| e-Tax (INET) | `ETAX_PREFIX`, `ETAX_URL`, `ETAX_STATUS_URL`, `ETAX_AUTHORIZATION`, `ETAX_SELLERTAXID`, `ETAX_SELLERBRANCHID`, `ETAX_APIKEY`, `ETAX_USERCODE`, `ETAX_ACCESSKEY`, `ETAX_SERVICECODE`, `ETAX_API_VERSION` (`R2` = new contract) |
| Digital signature | `CERTIFICATE_URL`, `CERTIFICATE_CADDATA` |
| Other | `FRONTEND_URL`, `TEMPLATES_STATIC_DIR` (default `/templates_static`), `GCS_CREDENTIAL_PATH`, `GCS_CONDITION_LEVEL_3_BUCKET`, `GCS_CONDITION_LEVEL_3_OBJECT` |

### External / third-party calls (`internal/infrastructure/external/`)

| Target | Base | Paths / purpose |
|---|---|---|
| Jasper report service (internal) | `ISV_HOST_JASPER_INTERNAL` + `ISV_ENDPOINT_JASPER_REPORT` | `/mv/policy/`, `/mc/policy/`, `/receipt/mv`, `/receipt/mc`, `/mv/claim/third-party`, `/mv/claim/insurance`, `/endorse/ry/`, `/endorse/ryp/`, `/endorse/pr/`, `/receipt/endorse/mv`, `/receipt/endorse/mc`, `/receipt/endorse/motor-debt/`, `/ta/policy/`, `/pa/policy/`, `/receipt/no-vat`, `/tax/deduction`, `/home/policy/`, `/tqm/`, `/receipt/tax-invoice` (`jasper_impl.go`) → returns PDF bytes |
| File service (internal) | `ISV_HOST_FILE_INTERNAL` + `ISV_ENDPOINT_UPLOAD_FILE` | `/uploadbase64` → returns public file URL |
| UAM service (Salesforce bridge) | `ISV_HOST_UAM_INTERNAL` + `ISV_ENDPOINT_UAM` | `/sfattachment_policy_act`, `/sfattachment_policy`, `/sfattachment_receipt_act`, `/sfattachment_receipt`, `/sfattachmenturl_policy_endorse_dedebt`, `/sfattachmenturl_policy_endorse_indebt`, `/sfattachment_policy_endorse`, `/sfattachmenturl_policy_endorse_tax`, `/create_policy_pure`, `/create_policy_act`, `/policy_attachment_more` (`uam_impl.go`, fire-and-forget POST) |
| Purchase service (internal) | `ISV_HOST_PURCHASE_INTERNAL` + `ISV_ENDPOINT_PURCHASE` | `/update-sf-payment`, `/update-sf-payment-act` |
| Notification | `ISV_HOST` + `ISV_ENDPOINT_NOTIFICATION_EMAIL` / `_SMS` | send e-mail (with PDF attachments) / SMS (⚠️ exact host composition not traced line-by-line) |
| Digital-signature service | `CERTIFICATE_URL` | POST PDF → signed PDF base64 (`util_impl.go:297`) |
| INET e-Tax | `ETAX_URL`, `ETAX_STATUS_URL` | create e-Tax document from CSV rows + PDF; status retry; then GET the returned PDF URL (`util_impl.go:353`, `:588`) |
| Google Cloud Storage | `GCS_*` | download "condition level 3" PDF for MV e-mail attachment (`internal/documents/usecase/mv/interface.go:51-61`, `policy.go:511`) |

## Auth & Middleware

Global (`internal/infrastructure/server/server.go:110-143`), in order:

1. `cors.New()` — default (all origins).
2. `helmet.New()` — security headers.
3. `healthcheck` — `GET /healthcheck` (liveness, always true) and `GET /readyz` (readiness; ⚠️ the DB ping branch only runs when `DBConn == nil`, so readiness effectively always returns ready).
4. `logger.New` (skips health and swagger paths).
5. `recover.New()`.
6. `requestid.New` — UUID stored in `c.Locals("requestID")`, passed to use cases / Jasper payloads.
7. `limiter` sliding-window: `APP_RATE_LIMIT_CONN` requests per `APP_RATE_LIMIT_WINDOW` (default 1000 / 10s).

Per-route: `loggerMiddleware.LoggerToDB("<ApiName>")` (`internal/logger/middleware/`) on all routes **except** `/fix/*`. It captures request/response headers & bodies and inserts asynchronously into `insurverse.log_internal_interface`.

**Authentication: none.** No JWT/API-key check on any route (JWT config is loaded but unused). The service is intended for internal cluster calls only.

Error handler (`server.go:70`): unhandled errors → `{ "status": { "code", "header", "description" } }` with fiber status code or 500.

## Endpoint Summary

Base `/api/v1/doc` unless noted. "Log" = LoggerToDB API name.

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | fiber healthcheck `internal/infrastructure/server/server.go:112` | Liveness |
| GET | `/readyz` | None | `server.go:194 Readiness` | Readiness |
| GET | `/api/v1/doc/swagger/*` | None | `server.go:145` | Swagger UI |
| GET | `/policy/:policyNo` | None (Log `Document:MV`) | `internal/documents/handler/mv/impl.go:24 MVHandlerPolicyAndReceipt` | MV policy + receipt (parallel) |
| GET | `/policy/:policyNo/policy` | None | `handler/mv/impl.go:66 MVHandlerPolicy` | MV policy only |
| GET | `/policy/:policyNo/receipt` | None | `handler/mv/impl.go:108 MVHandlerReceipt` | MV receipt + e-Tax |
| POST | `/claim` | None (Log `Document:Claim`) | `handler/mv/impl.go:150 ClaimHandler` | MV claim docs (third-party + insured) |
| GET | `/act/:policyNo` | None (Log `Document:MC`) | `handler/mc/impl.go:23 MCHandlerPolicyAndReceipt` | MC (พ.ร.บ.) policy + receipt |
| GET | `/act/:policyNo/policy` | None | `handler/mc/impl.go:66 MCHandlerPolicy` | MC policy |
| GET | `/act/:policyNo/receipt` | None | `handler/mc/impl.go:109 MCHandlerReceipt` | MC receipt + e-Tax |
| GET | `/ta_policy_document/:policyNo` | None (Log `Document:TA`) | `handler/ta/impl.go:65 TAHandlerPolicyAndReceipt` | TA policy + receipt |
| GET | `/ta_policy_document/:policyNo/policy` | None | `handler/ta/impl.go:107 TAHandlerPolicy` | TA policy |
| GET | `/ta_policy_document/:policyNo/receipt` | None | `handler/ta/impl.go:149 TAHandlerReceipt` | TA tax invoice + e-Tax |
| GET | `/ta_policy_document/:policyNo/condition` | None | `handler/ta/impl.go:23 TAHandlerCondition` | Returns TA coverage-condition PDF (binary) |
| GET | `/pa_policy_all_document/:policyNo` | None (Log `Document:PA`) | `handler/pa/impl.go:23 PAHandlerPolicyAndReceipt` | PA policy + receipt (+ tax deduction) |
| GET | `/pa_policy_all_document/:policyNo/policy` | None | `handler/pa/impl.go:65 PAHandlerPolicy` | PA policy |
| GET | `/pa_policy_all_document/:policyNo/receipt` | None | `handler/pa/impl.go:107 PAHandlerReceipt` | PA receipt (no-VAT) + e-Tax |
| GET | `/home_policy_all_document/:policyNo` | None (Log `Document:Home`) | `handler/home/impl.go:23 HomeHandlerPolicyAndReceipt` | Home policy + receipt |
| GET | `/home_policy_all_document/:policyNo/policy` | None | `handler/home/impl.go:65 HomeHandlerPolicy` | Home policy |
| GET | `/home_policy_all_document/:policyNo/receipt` | None | `handler/home/impl.go:107 HomeHandlerReceipt` | Home tax invoice + e-Tax |
| GET | `/policy/tqm/:policyNo` | None (Log `Document:TQM`) | `handler/tqm/impl.go:23 TQMHandler` | TQM combined policy/receipt |
| GET | `/endorse/:sfPolicyID` | None (Log `Document:Endorse`) | `handler/endorse/impl.go:22 EndorseHandler` | All endorsement docs for a Salesforce policy |
| GET | `/fix/doc/policy` | None, no log | `handler/fix/impl.go:16 FixDocHandler` | Batch re-generate missing docs |
| GET | `/fix/saleforce/policy` | None, no log | `handler/fix/impl.go:29 FixSFPolicyHandler` | Batch re-push policies/attachments to Salesforce |
| GET | `/fix/salesforce_payment` | None, no log | `handler/fix/impl.go:42 FixSFPaymentHandler` | Batch re-push payments to Salesforce |

Route registration lines: `internal/documents/handler/<module>/interface.go:30-36`.

Total: **22 business routes** + 3 infra routes (25 total; corrected from an earlier count of 24).

## Endpoints

### Common contract for document-generation GET routes

- Path param: `policyNo` (string, required; empty → 400). No query params, no body.
- Success `200`:
```json
{ "status": 200, "error_code": 0, "msg": "success", "result": { "file_url": [ { "url": "mockup" } ] } }
```
- Errors:

| HTTP | Body | Cause |
|---|---|---|
| 400 | `{ "status": 400, "error_code": 1, "msg": "Policy number is required", "result": {} }` | empty `policyNo` |
| 404 | `{ "status": 404, "error_code": 1, "msg": "Policy not found", "result": {} }` | `gorm.ErrRecordNotFound` |
| 500 | `{ "status": 500, "error_code": 1, "msg": "<error text>", "result": {} }` | Jasper/upload/e-Tax/DB errors, timeout (`context deadline exceeded` after 1 min in PolicyAndReceipt) |

- Common pipeline (policy): read data → build Jasper payload → Jasper render → e-signature (`CERTIFICATE_URL`; skipped for some partner codes via `IsIgnorePartner`) → `/uploadbase64` → UPDATE original URL; a second "copy" (สำเนา) render → upload → UPDATE copy URL → e-mail to customer with attachments (async) → Salesforce attachment sync (async).
- Common pipeline (receipt): read data → Jasper receipt → upload copy → `HandleEtaxAndUpdate` (`usecase/shared/impl.go:43`): read e-Tax rows → INET e-Tax (retry on non-ok) → download e-Tax PDF → upload → UPDATE original receipt URL → Salesforce receipt attachment.
- `…/:policyNo` (no suffix) runs policy and receipt concurrently (errgroup) with a 1-minute timeout (e.g. `usecase/mv/impl.go:13`).
- Idempotency: MV and MC (and TA) check the existing URL column first and skip if already generated (`CheckPolicyVMIUrlRef`, `CheckReceiptVMIUrlRef`, `CheckPolicyUrlRef`, `CheckReceiptUrlRef`). ⚠️ PA / Home / TQM re-generate on every call (no check found).

### GET /policy/:policyNo, /policy/:policyNo/policy, /policy/:policyNo/receipt (MV — voluntary motor)
- Use case: `internal/documents/usecase/mv/{impl.go,policy.go:37,receipt.go:15}`.
- DB read: `GetPolicyMV` (`Policy_Header`, `payment`, `Policy_coverage_premium`, `Policy_endorse_detail`, `province`, `district`, `subdistrict`), `GetPolicyReceiptMVDocument` (`Policy_Header`, `Policy_coverage_premium`, `payment`, address tables, `fn_display_access()`), `GetPartnerCodeMVPolicy`, e-Tax `GetMVReceiptEtax` (`Policy_Header`, `Policy_coverage_premium`).
- DB write: `UPDATE insurverse."Policy_Header"` (policy original/copy URL, receipt original/copy URL) — `query/mv_query.go:342-360`.
- Outbound: Jasper `/mv/policy/`, `/receipt/mv`; e-signature; upload; e-Tax; e-mail (attachments incl. static condition PDFs from `templates_static/` and GCS condition-level-3 file); UAM `/sfattachment_policy`, `/sfattachment_receipt`.

### POST /claim (MV claim)

Request body (`internal/documents/model/request/*.go GetClaimRequest`):
```json
{ "ref_notify_no": "CLM-2026-000123" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `ref_notify_no` | string | Yes | non-empty (manual check, `handler/mv/impl.go:162`) |

- Behaviour (`usecase/mv/claim.go:17`): runs in parallel `claimThirdParty` and `claimInsurance`; third-party "no data" is skipped. Each: read claim → Jasper → e-signature → upload → UPDATE `sf_claim` URL → SMS to claimant.
- Success: common mock body. Errors: 400 `'ref_notify_no' is required.` / body-parse error; 404 `RefNotifyNo not found`; 500 other.
- DB read: `GetClaimThirdParty` / `GetClaimInsurance` (`sf_claim`, `sf_claim_car_detail`, `sf_claim_asset`, `sf_claim_injured`, `Policy_coverage_premium`, `Policy_Header`, `fn_display_access()`), `GetImageClaim` (`sf_claim_attech`).
- DB write: `UPDATE insurverse."sf_claim"` (`UpdateClaimThirdPartyURLRef`, `UpdateClaimInsuranceURLRef`, `query/mv_query.go:261-267`).
- Outbound: Jasper `/mv/claim/third-party`, `/mv/claim/insurance`; e-signature; upload; SMS.

### GET /act/:policyNo, /act/:policyNo/policy, /act/:policyNo/receipt (MC — compulsory motor)
- Use case: `usecase/mc/{impl.go,policy.go,receipt.go}`.
- DB read: `GetPolicyMC` (`Policy_Car_Act_Discount_Premium`, `payment`, `company_detail`, `Policy_Header`, address tables), `GetPolicyReceiptMC`, `IsMVCarActNoExist` (`Policy_Header`), `GetPartnerCodeMCPolicy`, `CheckReceiptUrlRefMC`, e-Tax `GetMCReceiptEtax`.
- DB write: `UPDATE insurverse."Policy_Car_Act_Discount_Premium"` URL columns (`query/mc_query.go:133-151`).
- Outbound: Jasper `/mc/policy/`, `/receipt/mc`; e-signature; upload; e-Tax; e-mail; UAM `/sfattachment_policy_act`, `/sfattachment_receipt_act`.

### GET /ta_policy_document/:policyNo[/policy|/receipt] (TA — travel)
- Use case: `usecase/ta/{impl.go:7,policy.go,receipt.go}`.
- DB read: `GetPolicyTA` (`policy_ta_premium`, `mas_ta_package`, `payment_ta`, `mas_country`, `lead_ta_participant`, `mas_ta_description`, `mas_state`, `company_detail`, `mas_ta_coverage`, `policy_ta_coverage`, `mas_other_description`, `lead_ta_package`, address tables, `fn_display_country()`), `GetPolicyReceiptTA`, e-Tax `GetTAReceiptEtax`.
- DB write: `UPDATE insurverse."policy_ta_premium"` URL columns (`query/ta.go:250-262`).
- Outbound: Jasper `/ta/policy/`, `/receipt/tax-invoice`; e-signature; upload; e-Tax; e-mail (with condition PDF).

### GET /ta_policy_document/:policyNo/condition
- Use case: `usecase/ta/condition.go:22 ConditionFile` — reads policy (`GetPolicyTA`), chooses static template by `FlagAddOn` / `PolicyType==3` (inbound) and streams a file from `TEMPLATES_STATIC_DIR` (`condition_ta.pdf`, `condition_ta_inbound.pdf`, …).
- Success `200`: `Content-Type: application/pdf`, `Content-Disposition: attachment; filename="coverage-condition-ta-<key>.pdf"`, binary body.
- Errors: 400 / 404 / 500 legacy envelope. No LoggerToDB-visible difference (logged as `Document:TA`). No writes, no outbound calls.

### GET /pa_policy_all_document/:policyNo[/policy|/receipt] (PA)
- Use case: `usecase/pa/{impl.go,policy.go,receipt.go,tax.go}` — also generates the tax-deduction certificate (`TaxDeduction`).
- DB read: `GetPolicyPA` (`policy_pa_premium`, `lead_pa_participant`, `mas_pa_occupation`, `company_detail`, `lead_pa_beneficiary`, `lead_pa_coverage`, `mas_ta_description`, address tables), `GetPolicyReceiptPA`, `GetDataPA` (`mas_pa_package`), `PATaxDeduction`, e-Tax `GetPAReceiptEtax`.
- DB write: `UPDATE insurverse."policy_pa_premium"` (policy, copy, receipt, tax-deduction original/copy URLs; `query/pa.go:147-171`).
- Outbound: Jasper `/pa/policy/`, `/receipt/no-vat`, `/tax/deduction`; e-signature; upload; e-Tax; e-mail.

### GET /home_policy_all_document/:policyNo[/policy|/receipt] (Home / Condo)
- Use case: `usecase/home/{impl.go,policy.go,reciept.go}`.
- DB read: `GetPolicyHome` (`policy_home_premium`, `lead_home_participant`, `company_detail`, `lead_home_coverage`, address tables), `GetPolicyReceiptHome`, `GetDataHome` (`mas_other_description`, `mas_home_building_type`, `mas_home_resident_type`), e-Tax `GetHomeReceiptEtax`.
- DB write: `UPDATE insurverse.policy_home_premium` URL columns (`query/home.go:158-170`).
- Outbound: Jasper `/home/policy/`, `/receipt/tax-invoice`; e-signature; upload; e-Tax; e-mail.

### GET /policy/tqm/:policyNo (TQM partner motor)
- Use case: `usecase/tqm/impl.go:22` — builds a combined policy+receipt PDF.
- DB read: `GetTQMPolicy` (`Policy_Header`, `Policy_coverage_premium`, `Policy_endorse_detail`, `tqm_lead_vmi`, `tqm_premium`, address tables), `GetTQMReceipt` (+ `payment`, `fn_display_access()`), partner code.
- DB write: `UPDATE insurverse."Policy_Header"` (`Policy_url_ref`, `Policy_url_copy_ref`, `Receipt_url_ref`; `query/tqm_query.go:243-260`).
- Outbound: Jasper `/tqm/`; e-signature; upload; e-mail; UAM `/sfattachment_policy`.

### GET /endorse/:sfPolicyID (Endorsements)
- Param: `sfPolicyID` (Salesforce policy id, required; empty → 400 `SF Policy ID is required`; not found → 404 `SF Policy ID not found`).
- Use case: `usecase/endorse/impl.go:33 GenerateAllEndorse` — `ListEndorse` with up to 3 retries (4 attempts, waits 0.5s/1s/2s) when it returns an error **or no rows** (replica-lag guard; FX-02 (2026-09-24), branch `fix/fx-02-document` — before, one empty read answered 404 at once); after the last attempt the existing error / 404 applies; for each endorsement row, by MV (`PolicyNo`) or MC (`CarActNo`) and doc type: ร.ย. (`/endorse/ry/`), ร.ย.พ. (`/endorse/ryp/`), พ.ร. (`/endorse/pr/`), debt increase/decrease receipts (`/receipt/endorse/motor-debt/`), endorsement receipts (`/receipt/endorse/mv|mc`), plus e-Tax (receipt / instead / credit note / debit note).
- DB read: `ListEndorse`, `GetEndorseMV`, `GetEndorseMC`, `GetMVDebt`, `GetMCDebt`, `GetMV/MCReceiptEndorse`, `GetMV/MCReceiptEtax`, `…InsteadEtax`, `…CreditNoteEtax`, `…DebitNoteEtax` — tables `Policy_endorse_detail`, `Policy_Header`, `Policy_Header_Trans`, `Policy_coverage_premium(_Trans)`, `Policy_Car_Act_Discount_Premium(_Trans)`, `tqm_lead_vmi`, `tqm_lead_cmi`, `tqm_group_premium`, `tqm_premium`, `payment`, `company_detail`, `sys_param`, address tables, `fn_display_access()`.
- DB write: `UPDATE insurverse."Policy_endorse_detail"` URL columns (8 statements, `query/endorse.go:932-980`).
- Outbound: Jasper endorse/receipt paths; e-signature; upload; INET e-Tax (+ status retry, PDF download); e-mail; UAM `/sfattachment_policy_endorse`, `/sfattachmenturl_policy_endorse_dedebt|indebt|tax`.

### GET /fix/doc/policy
- Use case `usecase/fix/impl.go:10 RepairFullVersion`: `ListFixPolicy` (`Policy_Header`, `Policy_Car_Act_Discount_Premium`, `policy_ta_premium`, `policy_pa_premium`, `policy_home_premium`) then, **in a background goroutine**, calls the MV/MC/TA/PA/Home `PolicyAndReceipt` flow per row.
- Response: `200` empty body immediately. No error reporting.

### GET /fix/saleforce/policy
- `RepairSFPolicy` (`fix/impl.go:60`): `ListFixSFPolicy` (`log_sf_policy`, `Policy_Car_Act_Discount_Premium`, `Policy_Header`); background loop calls UAM `/create_policy_pure`, `/sfattachment_policy`, `/sfattachment_receipt`, `/policy_attachment_more` (MV) or `/create_policy_act`, `/sfattachment_policy_act`, `/sfattachment_receipt_act` (MC).
- Response: `200` empty body.

### GET /fix/salesforce_payment
- `RepairSFPayment` (`fix/impl.go:94`): `ListFixSFPayment` (`Policy_Header`, `Policy_Car_Act_Discount_Premium`); background loop calls Purchase `/update-sf-payment` (MV) or `/update-sf-payment-act` (MC).
- Response: `200` empty body.

### Infra routes
- `GET /healthcheck` → `200 OK`; `GET /readyz` → `200`/`503` (fiber healthcheck); `GET /api/v1/doc/swagger/*` → Swagger UI from `docs/`.

## DB Usage

Schema `insurverse` (Postgres via GORM raw SQL, `internal/infrastructure/database/query/*.go`).

| Table / function | Read / Write | Endpoints |
|---|---|---|
| `Policy_Header` | R/W (URL columns) | MV `/policy/*`, `/policy/tqm`, `/act/*` (existence check), `/endorse`, `/claim` (R), `/fix/*` (R) |
| `Policy_Header_Trans` | R | `/endorse` |
| `Policy_coverage_premium`, `Policy_coverage_premium_Trans` | R | MV, TQM, `/claim`, `/endorse` |
| `Policy_Car_Act_Discount_Premium` | R/W (URL columns) | `/act/*`, `/endorse` (R), `/fix/*` (R) |
| `Policy_Car_Act_Discount_Premium_Trans` | R | `/endorse` |
| `Policy_endorse_detail` | R/W (URL columns) | `/endorse` (W); MV, TQM (R) |
| `payment` | R | MV, MC, TQM, `/endorse` |
| `payment_ta` | R | TA |
| `policy_ta_premium` | R/W | TA; `/fix/doc/policy` (R) |
| `policy_ta_coverage`, `lead_ta_participant`, `lead_ta_package`, `mas_ta_package`, `mas_ta_coverage`, `mas_ta_description`, `mas_country`, `mas_state` | R | TA (`mas_ta_description` also PA) |
| `policy_pa_premium` | R/W | PA; `/fix/doc/policy` (R) |
| `lead_pa_participant`, `lead_pa_beneficiary`, `lead_pa_coverage`, `mas_pa_package`, `mas_pa_occupation` | R | PA |
| `policy_home_premium` | R/W | Home; `/fix/doc/policy` (R) |
| `lead_home_participant`, `lead_home_coverage`, `mas_home_building_type`, `mas_home_resident_type`, `mas_other_description` | R | Home (`mas_other_description` also TA) |
| `sf_claim` | R/W (URL ref) | `/claim` |
| `sf_claim_car_detail`, `sf_claim_asset`, `sf_claim_injured`, `sf_claim_attech` | R | `/claim` |
| `tqm_lead_vmi`, `tqm_premium` | R | TQM, `/endorse` |
| `tqm_lead_cmi`, `tqm_group_premium` | R | `/endorse` |
| `company_detail` | R | MC, TA, PA, Home, `/endorse` |
| `sys_param` | R | `/endorse` (e-Tax/debt) |
| `province`, `district`, `subdistrict` | R | all generation endpoints |
| `log_sf_policy` | R | `/fix/saleforce/policy` |
| `log_internal_interface` | W (insert) | every route with LoggerToDB (all except `/fix/*`) |
| `insurverse.fn_display_access()` (function) | R (called in SELECT) | MV receipt, `/claim`, TQM, `/endorse` |
| `insurverse.fn_display_country()` (function) | R | TA policy |

No stored procedures are executed; no INSERT into business tables (writes are UPDATEs of document URL columns only).

## Notes / ⚠️ unverified items

- ⚠️ Folder name says "python-fastapi" but the deployed service is Go Fiber. `controllers/*.py` are orphaned legacy FastAPI code (no app, missing modules) — recommend deleting or renaming the repo folder to avoid confusion.
- ⚠️ No authentication on any route, including the batch `/fix/*` routes that trigger mass regeneration and Salesforce pushes; rely on network isolation.
- ⚠️ Success response is a hard-coded mock (`url: "mockup"`); callers must read URLs from DB.
- ⚠️ `/readyz` DB check logic is inverted (`server.go:200`), so readiness is always true when a DB connection object exists.
- ⚠️ `/fix/*` are GET routes with side effects and fire-and-forget goroutines; errors only logged.
- ⚠️ Exact URL column names written per UPDATE (other than TQM: `Policy_url_ref`, `Policy_url_copy_ref`, `Receipt_url_ref`) were not enumerated individually; see `query/*.go` UPDATE constants.
- ⚠️ Notification (e-mail/SMS) host composition and e-Tax CSV field mapping (`query/etax.go`, 2.7k lines) were summarized, not traced field-by-field.
- Secrets: `cer.key` / `cer.pem` and `.env` exist in the repo folder; not reproduced here.
- Swagger annotations exist on handlers (`docs/swagger.yaml`) and match the routes above.
