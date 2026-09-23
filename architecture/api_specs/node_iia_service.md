# node_iia_service — API Spec

> Generated from source on 2026-09-23 (read-only review). File:line refs are relative to `node_iia_service/`.
>
> **Note:** despite the folder name, this is a **Go (Fiber v2)** service — module `iia-api`, entry `cmd/api/main.go`, DB access via **sqlc + pgx/v5**. There is no Node.js code.

## Overview

| Item | Value |
|---|---|
| Purpose | Integration gateway between Insurverse and **IIA** (Thai insurance industry association) / **EMCS** (e-claim/e-survey system) and **Salesforce**: (1) SOAP endpoint IIA calls to pull e-survey claim data and send cross-check results; (2) inbound endorsement feeds (TA/PA/Home) that update policy data; (3) endorsement request/cancel for TA/PA/Home; (4) claim-coverage push from Salesforce/IIA side, with image retrieval from EMCS, upload to file service and attachment push to Salesforce. |
| Language / framework | Go 1.24, Fiber v2, pgxpool, sqlc (`sqlc.yaml`), viper config |
| Port | `HTTP_PORT` (`cmd/api/main.go:54`; helm uat-isv `3000`) |
| Base path | `/api/v1/iia` (`pkg/common` `BasePath`) |
| Health | `GET /healthcheck` (liveness), `GET /ready` (readiness = DB ping) |
| Swagger | `GET /api/v1/iia/swagger/*` — disabled when `ENV=PROD` (`internal/server/server.go:98`) |
| DB | Postgres; schema from `DATABASE_SCHEMA` (search_path), TZ Asia/Bangkok (`server.go:161`) |

### Environment variables (names only; `internal/server/config/config.go`)

`ENV`, `HTTP_PORT`, `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`, `DATABASE_SCHEMA`, `GOOGLE_STORAGE`, `GOOGLE_STORAGE_BUCKET_NAME`, `JWT_SECRET_KEY`, `EMCS_ENDPOINT`, `EMCS_AUTH_USERNAME`, `EMCS_AUTH_PASSWORD`, `SF_ENDPOINT`, `SF_AUTH_USERNAME`, `SF_AUTH_PASSWORD`, `SF_AUTH_CLIENT_ID`, `SF_AUTH_CLIENT_SECRET`, `SF_AUTH_GRANT_TYPE`, `Base_Url`, `Backend_Doc`, `Backend_Auth`, `Backend_Core`, `Backend_File`, `Backend_Notification`, `Backend_Purchase`, `Backend_Consent`, `Backend_Premium`, `Backend_Saleforce`, `Backend_Uam`, `Backend_Analytics`, `Url_Fontend`, `EMAIL_SUPPORT`.
(Actually used by code: DB vars, `JWT_SECRET_KEY`, `EMCS_*`, `SF_*`, `Base_Url`, `Backend_Auth`, `Backend_Notification`, `Backend_File`, `EMAIL_SUPPORT`, `ENV`, `HTTP_PORT`.)

### External / third-party calls (`internal/external/implement.go`)

| Call | Target | Used by |
|---|---|---|
| `AuthLogin` (`:22`) | POST `Backend_Auth` + `login` (validates IIA SOAP username/password) | SOAP `getEsurvey_Detail_EH`, `Esurvey_Detail_CrossChecked_EH` |
| `SendEmail` (`:75`) | POST `Backend_Notification` + `email` | `/ta/request_endorse` |
| `EMCSGetClaimDetail` (`:112`), `EMCSGetClaimDetailCrossCheck` (`:181`) | SOAP `EMCS_ENDPOINT/EMCS_ENHANCE_WS/getclaimdetail.asmx` (EMCS creds) | `/claim/getimage_detail` |
| `EMCSWSExportToString` (`:257`) | SOAP `EMCS_ENDPOINT/ws_exporttostring/WSExportToString.asmx` | `/claim/claim_coverage` |
| `EMCSGetImageToString` (`:326`) | SOAP `EMCS_ENDPOINT/EMCS_ENHANCE_WS/getclaimdetail.asmx` | `/claim/claim_coverage` (+ unused batch job) |
| `SFAuth` (`:503`) | POST `SF_ENDPOINT/services/oauth2/token` (password grant, creds in query string ⚠️) | SF calls below |
| `SFClaimCoverage` (`:397`) | POST `<instance_url>/services/apexrest/upsertclaimcoverage` | `/claim/claim_coverage` |
| `SFClaimAttachment` (`:450`) | POST `<instance_url>/services/apexrest/upsertclaimattachmenturl` | `/claim/claim_coverage` |
| `UploadFile` (`:549`) | POST `Backend_File` + `uploadbase64` | `/claim/claim_coverage` |
| `CreateThumbnailImage` (`:618`) | ⚠️ unverified target (image thumbnail generation) | `/claim/claim_coverage` |

## Auth & Middleware

Global (`internal/server/server.go:63-89`):
1. CORS — `AllowOrigins: *`, methods GET/PUT/POST/PATCH/DELETE/OPTIONS.
2. `middleware.LogHandler()` — access log (skips health, swagger, `/claim/getimage_detail`).
3. Fiber healthcheck (`/healthcheck`, `/ready`).
4. Error handler `pkg/middleware/error.go` → `{ "status": <code>, "message": <msg> }` (500 → generic "something went wrong please try again").

Per-route:
- **JWT** `middleware.Protected(JWT_SECRET_KEY)` (`pkg/middleware/jwt.go`, gofiber/contrib/jwt, HS key, claims `id`, `email`): applied to the whole `/ta`, `/pa`, `/home` groups and to `POST /claim/claim_coverage`. Header `Authorization: Bearer <token>`. Errors: 400 `{statuscode:"1001", message:"Missing or malformed JWT"}`; 401 `{statuscode:"1001", message:"Invalid or expired JWT"}`.
- **SOAP credential auth**: `/getesurvey_detail` has no JWT; the SOAP body `username`/`password` are validated against the Auth service (`usecase/iia/implement.go:124 validateAuth`).
- **No auth**: `GET /getesurvey_detail` (WSDL), `GET|POST /claim/getimage_detail`.
- Validation: go-playground validator with custom tags `no_special_char`, `no_special_char_slash` (`pkg/middleware/validator.go`).
- Audit logs: TA/PA/Home handlers write `log_iia_policy_trans`; SOAP handler writes `log_iia_claim`.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | fiber healthcheck `internal/server/server.go:80` | Liveness |
| GET | `/ready` | None | `server.go:85` | Readiness (DB ping) |
| GET | `/api/v1/iia/swagger/*` | None (non-PROD only) | `server.go:99` | Swagger UI |
| GET | `/api/v1/iia/getesurvey_detail` | None | `internal/server/handlers/iia/implement.go:42 GetWSDL` | Returns WSDL for IIA SOAP service |
| POST | `/api/v1/iia/getesurvey_detail` | SOAP username/password | `handlers/iia/implement.go:52 HandleSOAPRequest` | SOAP: `getEsurvey_Detail_EH` / `Esurvey_Detail_CrossChecked_EH` |
| POST | `/api/v1/iia/ta/endorse_detail` | JWT | `handlers/ta/implement.go:68 HandleEndorseDetail` | Apply TA endorsement |
| POST | `/api/v1/iia/ta/request_endorse` | JWT | `handlers/ta/implement.go:28 HandleEndorseRequest` | Log a TA endorsement request + notify support by e-mail |
| POST | `/api/v1/iia/ta/endorse_cancel` | JWT | `handlers/ta/implement.go:116 HandleEndorseCancel` | Endorsement cancel for TA / PA / Home (by policy prefix) |
| POST | `/api/v1/iia/pa/endorse_detail` | JWT | `handlers/pa/implement.go:28 HandleEndorseDetail` | Apply PA endorsement |
| POST | `/api/v1/iia/home/endorse_detail` | JWT | `handlers/home/implement.go:28 HandleEndorseDetail` | Apply Home endorsement |
| POST | `/api/v1/iia/claim/claim_coverage` | JWT | `handlers/claim/implement.go:25 ClaimCoverage` | Upsert claim coverage (+ EMCS images → file service → Salesforce) |
| POST | `/api/v1/iia/claim/getimage_detail` | None | `handlers/claim/implement.go:105 GetImageDetail` | Pull next EMCS image batch + cross-check |
| GET | `/api/v1/iia/claim/getimage_detail` | None | `handlers/claim/implement.go:105 GetImageDetail` | Same as POST |

Route registrations: `handlers/iia/router.go:39-40`, `handlers/ta/router.go:38-41`, `handlers/pa/rounter.go:38-39`, `handlers/home/rounter.go:38-39`, `handlers/claim/router.go:38-41`.

Total: **10 business routes** + 3 infra routes.

## Endpoints

Common JSON envelope for TA/PA/Home/claim (`internal/server/response/common.go`):
```json
{ "statuscode": "0000", "message": "Success", "timestamp": "2026-09-23T10:00:00", "result": [ ... ] }
```
Errors use the same envelope with `statuscode: "1001"` and `message: <error>`. HTTP status from `exceptions.MapToHTTPStatusCode`: DOMAIN/BUSINESS → 400, NOTFOUND → 404, DATACONFLICT → 409, AUTHORIZED → 401, FORBIDDEN → 403, SYSTEM/REPOSITORY/UNKNOWN → 500.

### GET /api/v1/iia/getesurvey_detail
- Returns WSDL XML (`Content-Type: application/xml`) built from `Base_Url` (`implement.go:408 wsdl()`).
- No DB / outbound.

### POST /api/v1/iia/getesurvey_detail (SOAP)
- `Content-Type: text/xml`. Operation detected from the SOAP Body element (`identifySOAPAction`, `implement.go:373`).

**Operation `getEsurvey_Detail_EH`** (request `request.SOAPEnvelopeGetEsurveyDetail`)
```xml
<soapenv:Envelope><soapenv:Body>
  <getEsurvey_Detail_EH><username>…</username><password>…</password><seq_id>44</seq_id></getEsurvey_Detail_EH>
</soapenv:Body></soapenv:Envelope>
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `username` | string | Yes | non-empty; verified via Auth service login |
| `password` | string | Yes | non-empty |
| `seq_id` | int64 | Yes | sequence batch id |

- Success `200`: SOAP envelope `ns1:getEsurvey_Detail_EHResponse` containing `SYS_ERROR_DESCRIPTION` and arrays `TXN_SUMMARY`, `TXN_SURV_REPORT`, `TXN_SURV_CAR` (incl. assets), `TXN_SURV_INJ`, `TXN_SURV_BILL`, `TXN_SURV_PAY` (`usecase/iia/implement.go:143-497`).
- Errors: `400` SOAP fault-style envelope (error no 1 = missing credentials); auth failure / no data / DB errors → mapped status with SOAP error envelope (`handleError`, `:205`).
- DB read: `TXN_SURV_REPORT` (`sf_claim` ⋈ `company_detail`), `TXN_SURV_INJ` (`sf_claim_injured`), `TXN_SURV_CAR` (`sf_claim_car_detail`), `TXN_SURV_CAR_ASSET` (`sf_claim_asset`), `TXN_SURV_BILL` (`sf_claim_ibilling`), `TXN_SURV_PAY` (`sf_claim_pay`) — all joined to `sf_claim` by seq id.
- DB write: `UpdateSFClaimSeqID` (UPDATE `sf_claim`), `CreateLogIIAClaim` (INSERT `log_iia_claim`).
- Outbound: Auth `login`.

**Operation `Esurvey_Detail_CrossChecked_EH`** (request `request.SOAPEnvelopeCrossCheck`)
| Field | Type | Required | Validation |
|---|---|---|---|
| `result` | int | Yes | must be present (0/1 cross-check result) |
| `username`, `password` | string | Yes | non-empty; Auth login |
| `seq_id` | int64 | Yes | — |

- Success `200`: SOAP envelope with error no 0 / "OK".
- DB write: `UpdateSFClaimCrossCheck` (UPDATE `sf_claim`), INSERT `log_iia_claim`.

### POST /api/v1/iia/ta/endorse_detail
Request (`request.TaEndorseDetail`, `internal/server/request/ta.go`):
```json
{
  "policyNo": "TA-0024-B-900640",
  "endorseNo": "TA-0024-B-900640-0001",
  "endorseDate": "2024-02-08T10:31:10",
  "effectiveDate": "2024-02-08T10:31:10",
  "ownerDetails": { "ownerTitleEn": "Mr.", "ownerFirstnameEn": "…", "ownerLastnameEn": "…", "ownerBirthDate": "1980-01-01", "ownerCardType": "I", "ownerCardId": "…", "ownerAddressEn": "…", "ownerDistrictName": "…", "ownerSubdistrictName": "…", "ownerProvinceName": "…", "ownerZipcode": "10120", "ownerPhone": "…" },
  "deliDetail": { "deliAddressEn": "…", "deliDistrictName": "…", "deliSubdistrictName": "…", "deliProvinceName": "…", "deliZipcode": "10120", "deliFlag": true },
  "beneDetail": { "beneType": "Legal heirs", "beneRelation": "Son", "beneTitleEn": "Mr.", "beneFirstnameEn": "…", "beneLastnameEn": "…" },
  "policyDateDatail": { "policyStartDate": "2024-02-08T10:31:10", "policyEndDate": "2024-02-15T10:31:10" },
  "requestEndorseNo": "A8CE8644",
  "approveStatus": "approve", "approveTitle": "", "approveFirstname": "admin", "approveLastname": "admin",
  "flagEndorseOwner": true, "flagEndorseDeli": true, "flagEndorsePolicyDate": true, "flagEndorseBene": true
}
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `policyNo`, `endorseNo` | string | Yes | `validate:"required"` |
| `endorseDate`, `effectiveDate` | string (ISO `YYYY-MM-DDTHH:mm:ss`) | Yes | required; parsed, else 400 `invalid endorseDate` |
| `ownerDetails.*`, `deliDetail.*`, `beneDetail.*` | text (nullable) | Applied only when matching `flagEndorse*` true | address names resolved to IDs (`GetProvinceIDByName` etc.); bene type/relation must exist in `mas_ta_description` (404 `beneType not found` / `beneRelation not found`) |
| `policyDateDatail` (sic) | object | Required when `flagEndorsePolicyDate` | 400 `policyDate required`, `invalid policyStartDate/EndDate` |
| `requestEndorseNo` | text | No | if sent, must exist in `log_request_ta` via CRC32 (404 `requestEndorseNo not found`) |
| `approve*` | text | No | — |
| `flagEndorse*` | bool | No | select which sections to apply |

- Success `200`: `{ "statuscode":"0000","message":"Success","timestamp":"…","result":[{"policyNo":"…","endorseNo":"…"}] }`
- Errors: 400 body/validation/business; 401/400 JWT; 404 not found; 409 duplicate (⚠️ via `IsPolicyTAEndorseDetailTAExists`, exact status unverified); 500 DB.
- DB: read `policy_ta_premium`, `lead_ta_participant`, `mas_ta_description`, `province`, `district`, `subdistrict`, `policy_ta_endorse_detail`, `log_request_ta`; transaction `TAEndorseDetail` (`internal/database/sqlc/tx_ta_endorse_detail.go`) → INSERT `policy_ta_endorse_detail`, UPDATE `policy_ta_premium` (deli address, policy date, endorse no), UPDATE `lead_ta_participant` (owner, bene), UPDATE `log_request_ta`, SELECT `insurverse.fn_policy_trans_history_ta(policyNo, endorseNo)`; INSERT `log_iia_policy_trans`.
- Outbound: none.

### POST /api/v1/iia/pa/endorse_detail
Request (`request.PaEndorseDetail`): same shape as TA but Thai-language fields (`ownerTitleTh`, `ownerFirstnameTh`, `ownerAddressTh`, `deliAddressTh`, `beneFirstnameTh`, …) plus
```json
"coverageDetail": { "suminsure": "1000000.00", "suminsurePremium": "2292.00", "suminsureMed": "124.00", "suminsureMedPremium": "124.00", "discountAmt": "0.00", "premAmt": "2295.00", "dutyAmt": "10.00", "totalAmt": "2302.00", "suminsureDeathReason": "มรดก" },
"flagEndorseCover": true
```
Required: `policyNo`, `endorseNo`, `endorseDate`, `effectiveDate`.
- Success/errors: as TA.
- DB: read `policy_pa_premium`, `lead_pa_participant`, `lead_pa_coverage`, `mas_ta_description`, address tables, `policy_pa_endorse_detail`, `log_request_pa`; tx `PAEndorseDetail` → INSERT `policy_pa_endorse_detail`, UPDATE `policy_pa_premium` (deli, dates, endorse no, coverage), `lead_pa_participant`, `lead_pa_beneficiary`, `lead_pa_coverage`, `log_request_pa`; `fn_policy_trans_history_pa()`; INSERT `log_iia_policy_trans`.

### POST /api/v1/iia/home/endorse_detail
Request (`request.HomeEndorseDetail`): TA-like with Thai fields plus
```json
"buildingDetail": { "isOwner": "Y", "buildingAddressTh": "…", "buildingDistrictName": "…", "buildingSubdistrictName": "…", "buildingProvinceName": "…", "buildingZipcode": "20150" },
"flagEndorseBuilding": true
```
Required: `policyNo` (e.g. `FR-…`/`HI-…`), `endorseNo`, `endorseDate`, `effectiveDate`.
- DB: read `policy_home_premium`, `lead_home_participant`, `mas_ta_description`, address tables, `policy_home_endorse_detail`, `log_request_home`; tx `HomeEndorseDetail` → INSERT `policy_home_endorse_detail`, UPDATE `policy_home_premium` (deli, dates, endorse no, building), `lead_home_participant` (owner, bene), `log_request_home`; `fn_policy_trans_history_home()`; INSERT `log_iia_policy_trans`.

### POST /api/v1/iia/ta/request_endorse
Request (`request.TARequestEndorse`):
```json
{ "policyTaNo": "TA-0024-B-900273", "requestType": "endorse", "subject": "ขอแก้ไข", "body": "แก้ไขชื่อผู้เอาประกัน…" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `policyTaNo` | string | Yes | required; must exist (404 `policyTaNo not found`) |
| `requestType` | string | Yes | required |
| `subject`, `body` | string | Yes | required |

- Behaviour (`usecase/ta/request_endorse.go`): requires `EMAIL_SUPPORT` configured (400 `EmailSupport not found`); reads participant e-mail; INSERT `log_request_ta`; computes `insurverse.crc32(<log id>)` as reference; sends e-mail to support.
- Success `200`: `{ "statuscode":"0000","message":"Success","timestamp":"…","result":[{"id":"<CRC32 hash ref>"}] }`
- Errors: 400/404/500 (not logged to `log_iia_policy_trans`).
- DB: `GetEmailParticipantTA` (`policy_ta_premium`, `lead_ta_participant`, `mas_ta_package`, address tables, `set_para`), INSERT `log_request_ta`, `HashRef` → `insurverse.crc32()`.
- Outbound: Notification `email`.

### POST /api/v1/iia/ta/endorse_cancel
Request (`request.EndorseCancel`):
```json
{ "policyNo": "TA-0024-B-900273", "endorseNo": "TA-0024-B-900273-0001", "endorseDate": "2024-02-27T07:32:32", "effectiveDate": "2024-02-28T07:32:32",
  "requestEndorseNo": "A8CE8644", "approveStatus": "approve", "approveTitle": "", "approveFirstname": "admin", "approveLastname": "admin", "isCancel": true }
```
Required: `policyNo`, `endorseNo`, `endorseDate`, `effectiveDate`. Policy prefix selects product: `TA` → TA, `PA` → PA, `HI`/`FR` → Home (`usecase/ta/endorse_cancle.go:47`); other → 400.
- Success `200`: `result: [{policyNo, endorseNo}]`.
- DB: `IsPolicy{TA|PA|Home}EndorseDetailEndorseNoExist`, `IsLogRequest{TA|PA|Home}Exists`; tx `EndorseCancel{TA|PA|Home}` (`tx_endorse_cancel.go`) → INSERT/UPDATE `policy_{ta|pa|home}_endorse_detail`, UPDATE `policy_{ta|pa|home}_premium` status, UPDATE `log_request_{ta|pa|home}`, `fn_policy_trans_history_{ta|pa|home}()`; INSERT `log_iia_policy_trans` (api name `<TYPE>-EndorseCancel`).

### POST /api/v1/iia/claim/claim_coverage
Request: **JSON array** of `request.ClaimCoverageURL`:
```json
[
  {
    "claimId": "CC-23-MV-00013", "policyNumber": "MV-0023-E-006535", "status": "OP", "claimType": "PURELOSS",
    "responsibility": "ฝ่ายถูก", "paymentType": "", "totalLossReserve": 30000, "totalLossSettlement": 25000, "totalRecovery": 25000,
    "claimItem": [
      { "coverageID": "IV_0", "eClaimId": "R03023081012", "coverageType": "IV", "emcsAdjustStatus": "", "itemNo": 1, "emcsStatus": 7,
        "carDetail": { "repairerCode": "24", "repBringDate": "2023-08-21T00:00:00", "getCarBackDate": "2023-08-21T11:10:35", "repairerName": "…", "originatorCode": "0", "originatorName": "", "carLicense": "…", "policyNumber": "…", "claimNumber": "…", "imagePart": "2308/ISV/…jpg", "invoicePath": "Billing\\…jpg", "repComment": "", "insComment": "" },
        "injuryDetail": { "firstname": "…", "lastname": "…", "citizenID": "…" },
        "propertyDetail": { "name": "…", "ownerFirstname": "…", "ownerLastname": "…", "ownerCitizenID": "…" } }
    ]
  }
]
```
| Field | Type | Required | Validation |
|---|---|---|---|
| (body) | array | Yes | non-empty (400 `Request body is empty`) |
| `claimId` | string | Yes | required |
| `claimItem[].coverageID` | string | Yes | required (⚠️ nested validation depends on validator `dive`; not declared) |
| other fields | text/numeric/int (nullable) | No | — |

- Behaviour (`usecase/claim/claimCoverage.go:22`): per claim — check existing coverage/items → tx `SFClaim` (INSERT/UPDATE `sf_claim_coverage`, `sf_claim_coverage_item`) → Salesforce `upsertclaimcoverage` → UPDATE `sf_claim_coverage` SF response → `handleClaimFile`: EMCS AR export + image/invoice fetch → upload file service → thumbnail → Salesforce `upsertclaimattachmenturl` → tx `SFClaimItem` (UPDATE image/invoice URLs & SF file ids on `sf_claim_coverage_item`, INSERT/UPDATE `emcs_getimage_ar`, UPDATE `emcs_getimage_detail`).
- Success `200`: `{ "statuscode":"0000","message":"Success","timestamp":"…","result": null }`; on any item failure the status is the last failing item's code and `result` lists `[{ "claimId", "isSuccess": false, "errorMessage" }]` with `statuscode "1001"`.
- DB tables: `sf_claim_coverage`, `sf_claim_coverage_item`, `emcs_getimage_ar`, `emcs_getimage_detail`.
- Outbound: Salesforce OAuth + 2 Apex REST endpoints; EMCS SOAP (export, image); file upload; thumbnail.

### GET | POST /api/v1/iia/claim/getimage_detail
- No auth; body ignored (the `username`/`password` fields in `request.ClaimGetImageDetail` are commented out in handler).
- Behaviour (`usecase/claim/getImageDetail.go:18`): loop — next seq = `max(seq)+1` from `emcs_getimage_detail` → EMCS `getclaimdetail` → if no data / not-in-time, send cross-check and stop → store images (COPY into / UPDATE `emcs_getimage_detail`) → EMCS cross-check → UPDATE cross-check columns.
- Success `200`:
```json
{ "status": 200, "message": "success",
  "data": { "sequenceid": 45, "crosscheck": { "SYS_ERROR_DESCRIPTION": { "ERROR_CODE": 0, "ERROR_DESCRIPTION": "" }, "TXN_IMAGE_CROSSCHECKED": { "STATUS": 1, "DESCRIPTION": "" } } } }
```
(⚠️ exact JSON key casing per `internal/server/response/claim.go`, not fully verified.)
- Errors: `{ "status": <code>, "message": <error> }` with mapped HTTP status.
- DB: `emcs_getimage_detail` (R/W). Outbound: EMCS `getclaimdetail.asmx` (detail + cross-check).

## DB Usage

Schema = `DATABASE_SCHEMA` (functions are referenced as `insurverse.*`).

| Table / function | Read / Write | Endpoints |
|---|---|---|
| `sf_claim` | R/W (seq id, cross-check) | SOAP `getesurvey_detail` |
| `sf_claim_injured`, `sf_claim_car_detail`, `sf_claim_asset`, `sf_claim_ibilling`, `sf_claim_pay`, `company_detail` | R | SOAP `getesurvey_detail` |
| `log_iia_claim` | W | SOAP `getesurvey_detail` |
| `policy_ta_premium` | R/W | `/ta/endorse_detail`, `/ta/endorse_cancel`, `/ta/request_endorse` (R) |
| `policy_ta_endorse_detail` | R/W | `/ta/endorse_detail`, `/ta/endorse_cancel` |
| `lead_ta_participant` | R/W | `/ta/endorse_detail`, `/ta/request_endorse` (R) |
| `log_request_ta` | R/W | `/ta/request_endorse` (W), `/ta/endorse_detail`, `/ta/endorse_cancel` |
| `policy_pa_premium`, `policy_pa_endorse_detail`, `lead_pa_participant`, `lead_pa_beneficiary`, `lead_pa_coverage`, `log_request_pa` | R/W | `/pa/endorse_detail`, `/ta/endorse_cancel` (PA) |
| `policy_home_premium`, `policy_home_endorse_detail`, `lead_home_participant`, `log_request_home` | R/W | `/home/endorse_detail`, `/ta/endorse_cancel` (HI/FR) |
| `mas_ta_description` | R | TA/PA/Home endorse_detail |
| `mas_ta_package`, `set_para` | R | `/ta/request_endorse` |
| `province`, `district`, `subdistrict` | R | endorse_detail (name→id), `/ta/request_endorse` |
| `log_iia_policy_trans` | W | TA/PA/Home endorse_detail, endorse_cancel |
| `sf_claim_coverage`, `sf_claim_coverage_item` | R/W | `/claim/claim_coverage` |
| `emcs_getimage_ar` | R/W | `/claim/claim_coverage` |
| `emcs_getimage_detail` | R/W | `/claim/getimage_detail`, `/claim/claim_coverage` |
| `insurverse.fn_policy_trans_history_ta(policyNo, endorseNo)` | function (R/W ⚠️ body not inspected) | `/ta/endorse_detail`, `/ta/endorse_cancel` |
| `insurverse.fn_policy_trans_history_pa(...)` | function | `/pa/endorse_detail`, `/ta/endorse_cancel` |
| `insurverse.fn_policy_trans_history_home(...)` | function | `/home/endorse_detail`, `/ta/endorse_cancel` |
| `insurverse.crc32(text)` | function | `/ta/request_endorse`, endorse_detail (`requestEndorseNo` lookup via `Get*CRC32`) |

## Notes / ⚠️ unverified items

- ⚠️ Folder is named `node_…` but the code is Go; `IIA-API.postman_collection.json` and `docs/swagger.yaml` exist as secondary references.
- ⚠️ `/claim/getimage_detail` is unauthenticated and triggers EMCS pulls + DB writes; both GET and POST do the same.
- ⚠️ `claim` group is registered as `Group("claim")` without leading slash; Fiber normalises this to `/api/v1/iia/claim` (behaviour of Fiber `getGroupPath`, not tested at runtime).
- ⚠️ Salesforce OAuth sends client secret/password as URL query parameters (`implement.go:504`).
- ⚠️ `BatchCronJobGetImageDetail` (`usecase/claim/batchCronJob.go`) is not wired to any route or scheduler.
- ⚠️ Bodies of `fn_policy_trans_history_*` and `crc32` were not inspected (DB-side); behaviour inferred from return columns `rtn_policy_no`, `rtn_trans_id`.
- Swagger annotation examples contain sample SOAP credentials; not copied here.
