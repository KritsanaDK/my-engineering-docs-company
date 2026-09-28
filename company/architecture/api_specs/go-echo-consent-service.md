# go-echo-consent-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-consent-service` (Go module `consent-service`). Generated from source reading on 2026-09-23. Secrets are never reproduced here, only variable names.

## Overview

| Item | Value |
|---|---|
| Purpose | PDPA consent handling. (a) Proxy to the external **e-consent / "IIA" API** (`ISV_API_URL`, JWT issuer "Dhipaya Centralize Purpose") for collection-point access tokens, purposes and consent receipts; (b) local consent storage for **payment-page consents** (`insurverse.consent_*` tables incl. record-of-processing `consent_rop`); (c) on marketing consent for motor leads, upsert a **Salesforce** lead. |
| Framework | **Echo v4**, `go-playground/validator`, `pgx/v5` pool, sqlc-generated queries (`database/sqlc`). Swagger via `swaggo/echo-swagger`. |
| Port | `HTTP_PORT`, default `4000` (`main.go`). In-cluster: `backend-consent-service:4000`. |
| Base path | `/api/v1/consent` (`router/router.go:13`); plus `/healthcheck`. |
| DB | PostgreSQL, schema `insurverse`. |
| External calls | e-consent API (`ISV_API_URL` + `/Authentication`, `/Purposes`, `/ConsentReceipt`); Salesforce (`SF_ENDPOINT/services/oauth2/token`, `<instance_url>/services/apexrest/upsertlead`). |

### Environment variable names
All are **mandatory** (process panics if missing/empty, `config/config.go:10-35`). When `ENV` is `LOCAL` or empty, `.env` is loaded via godotenv.

| Variable | Purpose |
|---|---|
| `ENV` | environment name |
| `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME` | Postgres (sslmode=disable) |
| `ISV_API_URL` | e-consent API base URL |
| `COLLECTION_CLIENTID_AUTHENTICATION`, `COLLECTION_CLIENTSECRET_AUTHENTICATION` | e-consent client for flow `website-authentication` |
| `COLLECTION_CLIENTID_PURCHASE`, `COLLECTION_CLIENTSECRET_PURCHASE` | flow `website-purchase` |
| `COLLECTION_CLIENTID_SHOPPING`, `COLLECTION_CLIENTSECRET_SHOPPING` | flow `website-shopping` |
| `SF_ENDPOINT`, `SF_AUTH_USERNAME`, `SF_AUTH_PASSWORD`, `SF_AUTH_CLIENT_ID`, `SF_AUTH_CLIENT_SECRET`, `SF_AUTH_GRANT_TYPE` | Salesforce OAuth (password grant) |
| `Base_Url` | required by config check; not used by handlers |
| `ID_CONSENT_SALES_PROMOTION` | purpose id that, when `CONFIRMED`, triggers Salesforce lead upsert |
| `ENC_KEY`, `IV` | AES-CBC key/IV to decrypt the hex-encoded `leadNo` |
| `HTTP_PORT` | optional, default `4000` |
| `TZ` | set in Helm (container timezone) |

## Auth & Middleware

- **No authentication** on any route. The service relies on network placement (called from front-end/BFF). ⚠️ All endpoints, including ones that write consent records, are anonymous.
- `middleware.CORS()` default (all origins).
- `RequestLoggerWithConfig` JSON (slog) access log; skips `/healthcheck` and `/api/v1/consent/docs*`.
- Validation: custom `CustomValidator` (go-playground) -> `400 {"message":"<validator error>"}`.
- Errors via `echo.NewHTTPError(code, msg)` render as `{"message":"…"}`; explicit error bodies use `util.ErrorResponse` `{"message":"…"}`.
- `leadNo` in request bodies is an **encrypted** token: AES-CBC (`ENC_KEY`, `IV`), hex-encoded, PKCS5 padded, decrypting to the integer lead number (`util/util.go:131`).
- Salesforce token cached in package globals `SF_URL`/`SF_TOKEN`; re-authenticated on 401 (`util/saleforce.go:101,137`).

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | none | inline (`main.go`) | Returns text `is already` |
| GET | `/api/v1/consent/docs/*` | none | `echoSwagger.WrapHandler` (`router/router.go:14`) | Swagger UI |
| POST | `/api/v1/consent/access/:flow` | none | `GetAccessToken` (`controllers/consent_service.go:39`) | Get e-consent collection-point JWT for a flow |
| GET | `/api/v1/consent/purpose` | Authorization passthrough | `GetCollectionPoint` (`controllers/consent_service.go:118`) | Get purposes of a collection point from e-consent |
| POST | `/api/v1/consent/consent-receipt` | none | `ConsentReceipt` (`controllers/consent_service.go:188`) | Submit consent receipt to e-consent (+SF lead) |
| POST | `/api/v1/consent/consent-receipt-group` | none | `ConsentReceiptGroup` (`controllers/consent_service.go:292`) | Submit consent receipt for every owner of a lead |
| GET | `/api/v1/consent/purpose/payment` | none | `GetCollectionPointPayment` (`controllers/consent_service.go:498`) | Get local payment-consent purpose by tag + language |
| POST | `/api/v1/consent/consent-receipt/payment` | none | `ConsentReceiptPayment` (`controllers/consent_service.go:559`) | Save local accept/reject + ROP |
| POST | `/api/v1/consent/consent-receipt/payment-group` | none | `ConsentReceiptPaymentGroup` (`controllers/consent_service.go:659`) | Save local accept/reject + ROP for every lead owner |

Total: **9** routes (7 business + swagger + healthcheck).

## Endpoints

### POST `/api/v1/consent/access/:flow`
- Purpose: obtain a collection-point access token from the e-consent system for the given website flow.
- Path params:

| Param | Type | Required | Values |
|---|---|---|---|
| `flow` | string | yes | `website-authentication`, `website-purchase`, `website-shopping` |

- Request body: none.
- Outbound: `POST {ISV_API_URL}/Authentication`, `multipart/form-data` fields `ClientId`, `ClientSecret` (from the flow's `COLLECTION_*` env vars).
- Success `200` (`structs.AccessToken`) — upstream JSON re-serialized:
```json
{ "token": "<e-consent JWT>", "collectionPointId": "a85f3f2e-ba51-4aa5-a171-0c0046d59f13" }
```
- Errors: `400 {"message":"Flow not found"}`; `400 {"message":"<transport/read error>"}`. ⚠️ Upstream non-200 is not checked — body is unmarshalled as-is (may return empty fields with 200). ⚠️ On JSON unmarshal failure the code calls `errs.Error()` on a nil error (`:100`) -> panic -> Echo 500.
- DB: none.

---

### GET `/api/v1/consent/purpose`
- Purpose: fetch purposes/texts of a collection point for rendering the consent UI.
- Headers: `Authorization` — forwarded verbatim to e-consent (use the `token` from `/access/:flow`, e.g. `Bearer <token>` ⚠️ unverified exact scheme expected upstream).
- Query:

| Param | Type | Required | Validation |
|---|---|---|---|
| `collectionpointId` | string | yes | `required` |

- Outbound: `GET {ISV_API_URL}/Purposes?collectionpointId=<id>`.
- Success `200` (`structs.CollectionPoint`):
```json
{
  "identifier": "National ID/Passport", "defaultLanguage": "th-th", "languages": ["th-th"],
  "purposes": [ { "id": "2953753a-…", "name": "C1-การดำเนินกิจกรรมส่งเสริมการขาย", "version": 23,
                  "giveConsent": "REQUIRED", "isDefault": false,
                  "languages": [ { "default": true, "description": "…", "language": "th-th", "name": "…" } ] } ],
  "dataElements": ["NationalID","MobilePhone","Name","LastName","Email"], "constDataElements": {},
  "id": "a85f3f2e-…", "name": "Purchase", "description": "Purchase",
  "header": [ { "title": "…", "language": "th-th", "description": "<html>" } ],
  "jwtToken": "<requestInformation JWT>", "isShowReveal": false
}
```
- Errors: `400` (validation / transport); upstream non-200 -> same status with `{"message":"Error"}`.
- DB: none.

---

### POST `/api/v1/consent/consent-receipt`
- Purpose: submit a data subject's consent choices to e-consent; if the sales-promotion purpose is `CONFIRMED` and a valid `leadNo` is supplied, upsert a Salesforce lead for that motor lead.
- Request body (`dto.ConsentReceiptDTO`) — forwarded to e-consent as JSON (including `leadNo`):
```json
{
  "leadNo": "<hex AES-CBC encrypted lead no> | null",
  "identifier": "0812345678|ทดสอบ|เว็บไซต์รีจิสเตอร์",
  "requestInformation": "<jwtToken from /purpose>",
  "purposes": [ { "Id": "2953753a-6f14-4e52-974c-f147c96adc61", "TransactionType": "CONFIRMED" } ],
  "dsDataElements": { "MobilePhone": "0812345678", "Name": "…", "LastName": "…", "Email": "a@b.com" }
}
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `leadNo` | string/null | no | decrypt failure -> treated as 0 (no SF call) |
| `identifier` | string | functionally yes | none (no validate tags) |
| `requestInformation` | string (JWT) | functionally yes | none |
| `purposes[].Id` | string (UUID) | – | none |
| `purposes[].TransactionType` | string | – | `CONFIRMED` (case-insensitive) triggers SF check |
| `dsDataElements.*` | string | – | none |

- Outbound: `POST {ISV_API_URL}/ConsentReceipt` (JSON). Then, conditionally, Salesforce `POST {instance_url}/services/apexrest/upsertlead` with `{salutation:"", firstname, lastname, interestProduct:"ประกันภัยรถยนต์ประเภท <Type>", leadSource:"PWA", mobilePhone, email, carBrand, carModel, carYear}`.
- Success `200`: `{ "receipt": "<e-consent receipt JWT>" }`
- Errors: `400`/`500 {"message":"…"}`; upstream non-200 -> same status `{"message":"Error"}` (upstream body logged).
- DB (only when SF triggered): `SELECT "Lead_No","FirstName","LastName","Type","Mobile","Email","Brand","Model","Year" FROM insurverse."Lead_coverage_premium" WHERE "Lead_No"=$1`; on SF `statuscode == "0000"`: `UPDATE insurverse."Lead_coverage_premium" SET "SF_Lead"=$1 WHERE "Lead_No"=$2`. SF errors are only logged.

---

### POST `/api/v1/consent/consent-receipt-group`
- Purpose: same as above, but the service looks up every owner/participant of a lead and submits one e-consent receipt per owner.
- Request body (`dto.ConsentReceiptGroupDTO`):
```json
{
  "leadType": "ta",
  "leadNo": "<hex AES-CBC encrypted lead no>",
  "requestInformation": "<jwtToken>",
  "purposes": [ { "Id": "2953753a-…", "TransactionType": "CONFIRMED" } ]
}
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `leadType` | string | yes | `required,oneof=ta pa home mv mc ta-inbound` |
| `leadNo` | string | yes | must decrypt, else `400 "invalid lead no"` |
| `requestInformation` | string | – | none |
| `purposes[]` | array | – | none |

- Owner lookup by `leadType`:

| leadType | Query | Table |
|---|---|---|
| `ta`, `ta-inbound` | `ListOwnerTA` (`ORDER BY owner_index`); `ta-inbound` prefixes mobile with `+<owner_country_code>` | `insurverse.lead_ta_participant` |
| `pa` | `ListOwnerPA` | `insurverse.lead_pa_participant` |
| `home` | `ListOwnerHome` | `insurverse.lead_home_participant` |
| `mv` | `ListOwnerMV` | `insurverse."Lead_coverage_premium"` |
| `mc` | `ListOwnerMC` | `insurverse."Lead_Car_Act_Discount_Premium"` |

- Per owner: builds `identifier = "<mobile>|<name>|<lastName>"` and `dsDataElements` from DB, `POST {ISV_API_URL}/ConsentReceipt`. For `mv` + sales-promotion `CONFIRMED`: Salesforce upsert (as above) once per owner.
- Success `200`:
```json
{ "response": "success", "status": 200, "message": "success", "name": "save accept" }
```
- Errors: `400 {"message":"leadType not found"|"invalid lead no"|"owner not found"|<validator>}`; `500` DB error. ⚠️ Non-200 responses from e-consent are **silently ignored** (still returns success).
- DB: tables in the lookup table above (read); `Lead_coverage_premium` read/`SF_Lead` write for `mv`.

---

### GET `/api/v1/consent/purpose/payment`
- Purpose: get the locally-stored consent text shown on the payment page (by product tag).
- Query:

| Param | Type | Required | Validation |
|---|---|---|---|
| `type` | string | yes | `required`; matched against `consent_purpose.tags` |
| `lang` | string | no | `en-us` -> English, anything else -> `th-th` |

- Success `200`:
```json
{
  "id": "ff1b183c-a1c5-4a1a-9adf-7ef88cb1f36a", "name": "ประกันรถยนต์ชั้น 1", "version": 3,
  "activeStartDate": "2023-04-09T04:35:32.746886Z",
  "content": [ { "id": "8c20b373-…", "name": "ประกันรถยนต์ชั้น 1", "description": "<html terms>", "language": "th-th" } ]
}
```
- Errors: `400` validation; `404 {"message":"no rows in result set"}`; `500`.
- DB: `GetConsentByTags` — `insurverse.consent_purpose cp LEFT JOIN insurverse.consent_content cc ON cp.id = cc."purposeId" WHERE cp.tags=$1 AND cp.active AND cc.active AND cc.language=$2 LIMIT 1`.

---

### POST `/api/v1/consent/consent-receipt/payment`
- Purpose: record accept/reject of payment-page purposes for one identifier, and write an audit row to `consent_rop`.
- Request body (`dto.ConsentReceiptPaymentDTO`):
```json
{
  "identifier": "authen@gmail.com",
  "customer_id": "",
  "purposes": [ { "id": "ff1b183c-a1c5-4a1a-9adf-7ef88cb1f36a", "status": "ACCEPTED" } ]
}
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `identifier` | string | yes | `required` |
| `customer_id` | string/null | no | – |
| `purposes` | array | yes | `required,dive` |
| `purposes[].id` | UUID | yes | `required`; must exist in `consent_purpose` else 404 |
| `purposes[].status` | string | yes | `oneof=ACCEPTED REJECTED` |

- Logic per purpose: `GetPurpose` -> `GetAcceptByIdentifier(identifier, purposeId)`; insert (`CreateAccept`, sets `accepted_date` or `rejected_date`) if none, else `UpdateAccept` (sets status, date by CASE, `updated_at=now()`, `customer_id`); then `insertROP` (reads accept + active `consent_content` descriptions joined by `<---|--->`, inserts `consent_rop`; failures only logged).
- Success **`201`** body `{"response":"success","status":200,"message":"success","name":"save accept"}`.
- Errors: `400` validation/`"Status purpose do not match."`; `404` purpose not found; `500` DB. No transaction — partial writes possible if a later purpose fails.
- DB: `consent_purpose` (R), `consent_accept` (R/W), `consent_content` (R), `consent_rop` (W).

---

### POST `/api/v1/consent/consent-receipt/payment-group`
- Purpose: same as `/consent-receipt/payment`, for every owner of a lead (identifier = `"<mobile>|<name>|<lastName>"`, no `customer_id`).
- Request body (`dto.ConsentReceiptPaymentGroupDTO`):
```json
{ "leadType": "pa", "leadNo": "<hex AES-CBC encrypted lead no>",
  "purposes": [ { "id": "ff1b183c-…", "status": "REJECTED" } ] }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `leadType` | string | yes | `oneof=ta pa home mv mc ta-inbound` |
| `leadNo` | string | yes | must decrypt, else 400 `invalid lead no` |
| `purposes[].id` | UUID | yes | `required` |
| `purposes[].status` | string | yes | `oneof=ACCEPTED REJECTED` |

- Success `201` `{"response":"success","status":200,"message":"success","name":"save accept"}`. Returns success even if the lead has zero owners.
- Errors: `400`, `404`, `500` as above.
- DB: owner tables (see group endpoint) + `consent_purpose`, `consent_accept`, `consent_content`, `consent_rop`.

---

### GET `/healthcheck` — `200` text `is already`.
### GET `/api/v1/consent/docs/*` — Swagger UI (generated `docs/docs.go`).

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| `insurverse.consent_purpose` | R | `/purpose/payment`, `/consent-receipt/payment`, `/consent-receipt/payment-group` |
| `insurverse.consent_content` | R | `/purpose/payment`, payment + payment-group (ROP description) |
| `insurverse.consent_accept` | R/W (INSERT/UPDATE) | `/consent-receipt/payment`, `/consent-receipt/payment-group` |
| `insurverse.consent_rop` | W (INSERT) | `/consent-receipt/payment`, `/consent-receipt/payment-group` |
| `insurverse."Lead_coverage_premium"` | R; W (`"SF_Lead"`) | `/consent-receipt` (SF), `/consent-receipt-group` (`mv`), `/consent-receipt/payment-group` (`mv`) |
| `insurverse.lead_ta_participant` | R | group endpoints (`ta`, `ta-inbound`) |
| `insurverse.lead_pa_participant` | R | group endpoints (`pa`) |
| `insurverse.lead_home_participant` | R | group endpoints (`home`) |
| `insurverse."Lead_Car_Act_Discount_Premium"` | R | group endpoints (`mc`) |
| enum `insurverse.consent_accept_status_enum` (`ACCEPTED`/`REJECTED`) | used in UPDATE cast | payment endpoints |

No stored functions/procedures are called. Unused generated queries: `CreatePurpose`, `CreateContent`, `GetContent`.

## Notes / ⚠️ unverified items

1. ⚠️ **No authentication** on any endpoint (including DB-writing payment consent endpoints).
2. ⚠️ **Bug — `ListOwnerMC` swaps columns**: `email AS "MobilePhone", phone AS "Email"` (`database/sqlc/lead_car_act_discount_premium.sql.go`), so `mc` owners get identifier/dsDataElements with email and phone swapped.
3. ⚠️ `GetAccessToken` / `GetCollectionPoint` / `ConsentReceipt`: on JSON unmarshal error they call `errs.Error()` where `errs` is nil -> panic (Echo returns 500).
4. `ConsentReceiptGroup` ignores e-consent non-200 responses and still returns success; `defer res.Body.Close()` inside a loop.
5. Payment endpoints are not transactional; `insertROP` failures are logged only.
6. Salesforce token is cached in globals without locking (possible data race under concurrency).
7. ⚠️ unverified: live schema/column types of the tables above (derived from sqlc SQL and `database/schema.sql`, not checked against DB).
8. ⚠️ unverified: exact contract of the external e-consent API beyond the fields mapped in `controllers/structs`.
