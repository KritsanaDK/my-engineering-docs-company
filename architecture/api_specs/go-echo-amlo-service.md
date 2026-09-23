# go-echo-amlo-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-amlo-service` (Go module `amlo`, vendored deps). Generated from source reading on 2026-09-23. Secrets are never reproduced here, only variable names.

## Overview

| Item | Value |
|---|---|
| Purpose | AMLO (Thai Anti-Money Laundering Office) watch-list compliance batch. Downloads sanction/freeze lists from the AMLO gateway over mTLS, PGP-decrypts + unzips them, reloads them into `insurverse.amlo_*` tables, uploads raw files to GCS, and produces a daily compliance report (policies/claims whose citizen ID matches a watch-list ID) that is e-mailed to Compliance as XLSX. |
| Framework | **Echo v4** (`routes/routes.go`), `sqlx` + `lib/pq`, `gopenpgp/v2`, `cloud.google.com/go/storage`. |
| Port | **Hardcoded `:8080`** (`main.go:35`). `HTTP_PORT` is set in Helm but not read. |
| Base path | `/` (no prefix). |
| Trigger model | HTTP only — the in-process scheduler in `main.go` is commented out; ⚠️ unverified which external scheduler (k8s CronJob / Cloud Scheduler) calls `/download_blacklist` and `/amlo_cronjob` (not in this repo's Helm). |
| DB | PostgreSQL, schema `insurverse`. |

### External / third-party calls

| Target | How | Used by |
|---|---|---|
| AMLO gateway `Base_Url` (default `https://gateway.amlo.go.th/v1/`) + `freeze-05`, `al-qaida`, `taliban`, `iran`, `dprk`, `hr-02`, `hr-08` | `POST`, empty body, mTLS client cert from `./certs/amlo_ca_aps_2028.pfx` (PKCS#12), headers `X-API-Key`, `Authorization`, `Cookie`, `Content-Type: application/json` (`utils/httpClient.go:17,74`). Response `models.AmloResult` (`ReturnStatus`, `ReturnMessage`, `KeyID`, `FileName`, `mimeType`, `TotalRecord`, `Result` = base64 PGP message). | `/download_blacklist` |
| Google Cloud Storage bucket `GCS_BUCKET`, objects `amlo/<file>` | service-account file `key.json` (Helm mounts secret `service-account-credentials` at `/app/key.json`) | `/download_blacklist` |
| Notification service `Backend_Notification` + `email` (default hardcoded UAT URL) | `POST` JSON `{sender, subject, content, email[], attach[{filename, filebase64}]}` (`helper/httpClient.go:14`) | `/amlo_cronjob` |

### Environment variable names

| Variable | Read in | Notes |
|---|---|---|
| `ENV` | `constants/constants.go:41` | `dev`/`uat`/`prod`; selects `ComplianceEmailList` recipients and report subject |
| `Base_Url` | `constants.go:58` | AMLO gateway base URL |
| `Backend_Notification` | `constants.go:63` | notification service base; `email` appended |
| `GCS_BUCKET` | `constants.go:67`, `webserver/gcpConnect.go:28` | bucket for raw files |
| `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME` | `webserver/dbConnect.go:34-50` | fall back to hardcoded constants if empty |
| (Helm-only, **not read by code**) `Amlo_X_API_KEY`, `Amlo_Authorization`, `HTTP_PORT`, `Amlo_1` … `Amlo_14` | – | AMLO API key/authorization, username/password and PGP passphrase are **hardcoded in `constants/constants.go`** instead |

Files required at runtime: `./certs/amlo_ca_aps_2028.pfx`, `temp/insurverse(64DCD1B0).key`, `temp/insurverse_2025.key` (loaded in `controllers/amloController.go:41` `init()`; process exits if missing), `templates/compliant.html`, `key.json`.

## Auth & Middleware

- **None.** No Echo middleware (`e.Use` never called), no authentication, no CORS, no request logger/recover. ⚠️ Anyone who can reach the service can trigger a full truncate-and-reload of the AMLO tables and a compliance e-mail.
- Responses use `models.JsonReturn` `{title, status, description, result}`.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | none | `healthcheck` (`routes/routes.go:34`) | Returns text `OK` |
| POST | `/download_blacklist` | none | `DownloadBlacklist` (`controllers/amloController.go:190`) | Fetch 7 AMLO lists, decrypt, upload to GCS, truncate & reload `amlo_*` tables |
| POST | `/amlo_cronjob` | none | `AmloCronjob` (`controllers/amloController.go:231`) | Build compliance match report, e-mail XLSX to Compliance |
| POST | `/hello` | none | `HomeHandler` (`controllers/amloController.go:60`) | Placeholder |
| POST | `/freeze-05` | none | `HomeHandler` (`:60`) | Placeholder (no AMLO call) |
| POST | `/version_check_freeze-05` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/al-qaida` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/version_check_al-qaida` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/taliban` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/version_check_taliban` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/dprk` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/version_check_dprk` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/iran` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/version_check_iran` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/hr-02` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/version_check_hr-02` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/hr-08` | none | `HomeHandler` (`:60`) | Placeholder |
| POST | `/version_check_hr-08` | none | `HomeHandler` (`:60`) | Placeholder |

Routes registered in `routes/routes.go:11-31`. Total: **18** (2 functional + healthcheck + 15 placeholders).

## Endpoints

### POST `/download_blacklist`
- Purpose: refresh the local copy of AMLO watch-lists.
- Params / body: none.
- Flow (`amloController.go:190`):
  1. Sequentially call `Freeze_05`, `AL_qaida`, `Taliban`, `Iran`, `Dprk`, `Hr_02`, `Hr_08` (`:1155-1240`): `POST {Base_Url}<list>` via mTLS. Each result -> `ProcessReturnAmlo` (`:1241`): base64-decode `Result`, save `.pgp` copy, PGP-decrypt (private key `temp/insurverse_2025.key` + passphrase constant), write `./temp_zip/<name>.zip`, unzip to `./temp_files/`. **Errors from each list are ignored.**
  2. In parallel:
     - `UploadFileToGCP` (`:1324`): **sets bucket default object ACL to `allUsers: READER`**, then uploads every file in `./temp_files/` to `gs://$GCS_BUCKET/amlo/<file>`.
     - `ReadAndInsert` (`:978`): opens a transaction (`sql_trans`, package global), `TRUNCATE` `amlo_idnumber`, `amlo_master`, `amlo_name`; for each CSV in `./temp_files/` matching name filters, bulk-insert (`Insert_Idnumber_Bulk` `:587`, `Insert_Master_Bulk` `:655`, `Insert_Name_Bulk` `:735`, via `Exec_temp` `:852` prepared multi-row INSERTs); `COMMIT` (commits even if some file inserts failed — only the last `err` is checked).
  3. `cleanTemp` clears `./temp_zip/` and `./temp_files/`.
- Success `200`:
```json
{ "title": "", "status": 200, "description": "Success", "result": "" }
```
- Errors: none surfaced — always `200` once finished (failures only logged). Long-running synchronous request.
- DB: `insurverse.amlo_idnumber`, `insurverse.amlo_master`, `insurverse.amlo_name` — TRUNCATE + INSERT (column names quoted upper-case, e.g. `"ENTITY_ID"`, `"INFO_SOURCE"`, `"ENTITY_TYPE"`, `"BRIEF_NAME"`, `"ID_VALUE"`, `"NAME_TYPE"`, `"FIRST_NAME"`, `"SURNAME"` …).
- Outbound: AMLO gateway (7 calls), GCS.

---

### POST `/amlo_cronjob`
- Purpose: produce and e-mail the daily AMLO compliance match report.
- Params / body: none.
- Flow (`amloController.go:231`):
  1. `CreateAmloBatch` (`:94`): runs `query_batch_amlo` (`:1362`, ~540 lines, 15 `SELECT`s joined by `UNION`), matching `amlo_idnumber."ID_VALUE"` (non-empty) against citizen IDs of policy holders / participants / claim parties; writes `./amlo_compliant.csv` with 27 Thai/English columns (run date, issue/effective/expiry date, premium, class/subclass, customer group, policy/endorse/claim/settlement/recovery no., SI, premium, insured name + citizen ID, BrCode, EntityID, payee TH/EN names + citizen ID, watch-list code, IIA mapping).
  2. Reads `templates/compliant.html`, renders with `{DateNow_TH (dd/mm/yyyy Asia/Bangkok), Env}`.
  3. Converts CSV -> XLSX (`utils.GenerateXlsxWithHeaderMap`), base64 data-URI.
  4. `helper.EmailService` -> `POST {Backend_Notification}email` with subject `[Insurverse] <ENV> AMLO Batch report <dd/mm/yyyy>`, recipients `constants.ComplianceEmailList` (per `ENV`), attachment `<dd-mm-yyyy>-amlocompliant.xlsx`.
- Success `200`:
```json
{ "title": "Success", "status": 200, "description": "Service : uat", "result": null }
```
- Errors (`500`, `JsonReturn`), `description` one of: `CreateAmloBatch failed`, `ImportHTMLFile failed`, `read csv failed`, `GenerateXlsx failed`, `buf failed`, `Apply template email failed`, `Send email failed`.
- DB (read only): `insurverse.amlo_idnumber` joined with `"Policy_Header"`, `"Policy_Header_Trans"`, `"Policy_coverage_premium"`, `"Policy_coverage_premium_Trans"`, `"Policy_Car_Act_Discount_Premium"`, `"Policy_Car_Act_Discount_Premium_Trans"`, `policy_ta_premium`, `policy_pa_premium`, `policy_home_premium`, `lead_ta_participant`, `lead_pa_participant`, `lead_home_participant`, `mas_home_building_type`, `sf_claim`, `sf_claim_asset`, `sf_claim_car_detail`, `sf_claim_coverage`, `sf_claim_coverage_item`, `sf_claim_injured` (all schema `insurverse`). ⚠️ Per-block join keys other than `Policy_Header."Owner_citizen_id"` not individually verified.
- Outbound: notification service (e-mail).

---

### POST `/hello`, `/freeze-05`, `/al-qaida`, `/taliban`, `/dprk`, `/iran`, `/hr-02`, `/hr-08` and the seven `/version_check_*` routes
- All bound to `HomeHandler` (`amloController.go:60`): return `200` text `Welcome to my app!`. No body, no DB, no outbound call. They look like mock stand-ins mirroring the AMLO gateway paths (⚠️ unverified intent — possibly used as a local mock when `Base_Url` points at this service).

### GET `/healthcheck`
- `200` text `OK`.

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| `insurverse.amlo_idnumber` | W (TRUNCATE, INSERT); R | `/download_blacklist`; `/amlo_cronjob` |
| `insurverse.amlo_master` | W (TRUNCATE, INSERT) | `/download_blacklist` |
| `insurverse.amlo_name` | W (TRUNCATE, INSERT) | `/download_blacklist` |
| `insurverse."Policy_Header"`, `"Policy_Header_Trans"`, `"Policy_coverage_premium"`, `"Policy_coverage_premium_Trans"` | R | `/amlo_cronjob` |
| `insurverse."Policy_Car_Act_Discount_Premium"`, `"Policy_Car_Act_Discount_Premium_Trans"` | R | `/amlo_cronjob` |
| `insurverse.policy_ta_premium`, `policy_pa_premium`, `policy_home_premium`, `mas_home_building_type` | R | `/amlo_cronjob` |
| `insurverse.lead_ta_participant`, `lead_pa_participant`, `lead_home_participant` | R | `/amlo_cronjob` |
| `insurverse.sf_claim`, `sf_claim_asset`, `sf_claim_car_detail`, `sf_claim_coverage`, `sf_claim_coverage_item`, `sf_claim_injured` | R | `/amlo_cronjob` |

No stored functions/procedures are called.

## Notes / ⚠️ unverified items

1. ⚠️ **Secrets in source**: AMLO API key, Authorization, username/password, PGP passphrase (`constants/constants.go`), PKCS#12 password (`utils/httpClient.go`), DB fallback credentials (`webserver/dbConnect.go`), and **full PGP private key blocks embedded in `main.go` (`saaa`) and `controllers/amloController.go:1920` (`sc_key`)**; plus key files under `temp/`, `certs/`, `client.key`, `key.json` in the repo tree. Values intentionally not reproduced. Rotate and move to Secret Manager.
2. ⚠️ **Public bucket ACL**: `UploadFileToGCP` sets `DefaultObjectACL` of `GCS_BUCKET` to `allUsers` READER, making uploaded AMLO list files (and any future objects) publicly readable.
3. ⚠️ **No auth** on state-changing endpoints.
4. `/download_blacklist` always returns 200; per-list download/decrypt errors, truncate errors and insert errors are swallowed; the transaction commits after partial failure (tables may end up empty/partial).
5. Uses package-global transaction `sql_trans` and fixed temp dirs — concurrent calls would corrupt each other.
6. `Insert_Name` (non-bulk, unused) targets `insurverse.insurverse.amlo_name` (double schema) — dead code, would fail.
7. Env vars `Amlo_X_API_KEY`, `Amlo_Authorization`, `HTTP_PORT`, `Amlo_1..14` are provided by Helm but ignored by code.
8. ⚠️ unverified: scheduler that calls these endpoints; live DB column names/types (derived from SQL strings only).
9. Watch-list files contain personal data; `ComplianceEmailList` includes external/test mailboxes for `dev`/`uat` and the default (no `ENV`) list.
