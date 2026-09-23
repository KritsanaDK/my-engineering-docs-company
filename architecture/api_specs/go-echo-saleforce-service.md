# go-echo-saleforce-service — API Spec

> Written from the source code at `/Users/kritsanawathaniyanon/Code/Go/go-echo-saleforce-service` (Go module `saleforce-service`).
> Business-level interface sheets (Integration Spec V4.0) live in [`../salesforce_api_specs/`](../salesforce_api_specs/README.md). This document describes what the **code** actually does; any differences from those sheets are listed under Notes.

## Overview

| Item | Value |
|---|---|
| Purpose | Integration hub between **Salesforce (SFDC)** and InsurVerse. Salesforce calls this service to post endorsements (policy transactions), attachments, claims, iBilling, customer detail changes, live-chat business hours, and motor master/coverage lookups. The service also calls the Salesforce APEX REST APIs (upsert policy transaction, attachment URLs, account). It also accepts TQM partner callbacks (car inspection results, TQM data-file notifications). |
| Framework | Go + Echo v4 (`github.com/labstack/echo/v4`), `echo-jwt/v4`, `go-playground/validator/v10`, pgx v5 pool + **sqlc** (`database/sqlc`), swaggo (`echo-swagger`) |
| Swagger title | "Microservice Salesforce X10" v1.0.1 (`main.go`) |
| Base path | `/api/v1/sf` (`router/router.go:12`), plus the root-level `/healthcheck` |
| Port | `:${HTTP_PORT}` (`main.go`, `app.Start(":" + httpPort)`) |
| DB | PostgreSQL, schema `insurverse` (all sqlc queries use `insurverse.` explicitly) |
| Startup | `config.InitENV()` loads `.env` when `ENV` is `LOCAL` or empty, and **panics if any key in the required list is missing or empty**. Then it connects the pgx pool and calls `api.SalesforceConn()` to get the Salesforce OAuth token (3 tries, 5 s apart; refreshes every 20 min; after a total failure it retries every 5 min). |

### Environment variables (names only)

The service requires all of these (`config/config.go`):
`ENV`, `DATABASE_HOST`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`, `DATABASE_PORT`, `TZ`, `HTTP_PORT`, `GOOGLE_STORAGE`, `GOOGLE_STORAGE_BUCKET_NAME`, `JWT_SECRET_KEY`, `SF_ENDPOINT`, `SF_AUTH_USERNAME`, `SF_AUTH_PASSWORD`, `SF_AUTH_CLIENT_ID`, `SF_AUTH_CLIENT_SECRET`, `SF_AUTH_GRANT_TYPE`, `Base_Url`, `Backend_Notification`, `Backend_Uam`, `Backend_Doc`, `Backend_Policy`.

It also reads the GCS service-account file `/app/key.json` (a mounted file, not an env var).

### Outbound / third-party calls

URL rule for internal services: if `Backend_X` is set, the URL is `${Backend_X}<suffix>`. Otherwise it is `${Base_Url}api/v1/<svc>/<suffix>`. No `Authorization` header is sent to internal services.

| Client fn (`util/api/*.go`) | Target | Method + path | Used by |
|---|---|---|---|
| `fetchSalesforceToken` (`saleforce.go:90`) | Salesforce OAuth | `POST ${SF_ENDPOINT}/services/oauth2/token?grant_type=…&client_id=…&client_secret=…&username=…&password=…` (password grant, credentials in the query string) | startup / timer |
| `SaleForcePolicyTransaction` (`saleforce.go:711`) | Salesforce APEX | `POST {instance_url}/services/apexrest/upsertpolicytransaction` — spec [15_sf-policytransaction](../salesforce_api_specs/01_sfdc_inbound/15_sf-policytransaction.md) | PolicyTransacti (TQM path) |
| `SaleForcePolicyAttachment` (`saleforce.go:473`) | Salesforce APEX | `POST …/services/apexrest/upsertpolicyattachmenturl` — [18](../salesforce_api_specs/01_sfdc_inbound/18_sf-policyattachment_(url).md) | PolicyAttachment |
| `SaleForceClaimAttachment` (`saleforce.go:513`) | Salesforce APEX | `POST …/services/apexrest/upsertclaimattachmenturl` — [21](../salesforce_api_specs/01_sfdc_inbound/21_sf-claimattachmenturl.md) | ClaimAttachment, Claim |
| `SaleForceFileAttachment` (`saleforce.go:552`) | Salesforce APEX | `POST …/services/apexrest/upsertfileattachmenturl` — [26](../salesforce_api_specs/01_sfdc_inbound/26_sf-fileattachmenturl.md) | FileAttachment |
| `SaleForceEndorsementsAttachment` (`saleforce.go:591`) | Salesforce APEX | `POST …/services/apexrest/upsertpolicyattachment` — [17](../salesforce_api_specs/01_sfdc_inbound/17_sf-policyattachment.md) | UploadEndorseAttachment |
| `SaleForceUpsertAccount` (`saleforce.go:632`) | Salesforce APEX | `POST …/services/apexrest/upsertaccount` — [06](../salesforce_api_specs/01_sfdc_inbound/06_sf-account.md) | customerDetail |
| `CreateThumbnailImage` (`saleforce.go:671`) | the file URL itself (GCS) | `GET <file url>` (for image content types only) to build a base64 thumbnail | attachment flows |
| `UploadFileToGCS` / `DownloadFileFromGCS` (`google.go`) | Google Cloud Storage | bucket `${GOOGLE_STORAGE_BUCKET_NAME}`; public URL = `${GOOGLE_STORAGE}` + bucket + `/` + file | attachments |
| `UamCreatePolicyPure` | UAM service | `POST …create_policy_pure` | PolicyTransacti (type V) |
| `UamCreatePolicyAct` | UAM service | `POST …create_policy_act` | PolicyTransacti (type C) |
| `UamCmiRealtimeEndorse` | UAM service | `POST …cmi_realtime_endorse_service` | PolicyTransacti (type C) |
| `UamSendIIARy` | UAM service | `POST …ry<docGroupType>` (26/27/28 are all sent to `ry28`) | PolicyTransacti |
| `DocEndorseSfTransId` | Doc service | `GET …endorse/{sf_trans_id}` | PolicyTransacti |
| `DocClaim` | Doc service | `POST …claim` | Claim |
| `PushNotification` | Notification service | `POST …push_notification_id` | PolicyTransacti (point cancel) |
| `SMSNotification` / `EmailNotification` / `EmailNotificationEndorse` | Notification service | `POST …sms` / `…email` / `…tqm/emailendorse` | notification endpoints |
| `GetDriverBehaviorOIC` | Policy service | `POST …oic/driver_behavior` | getMotorCoverage |
| `NotifyToPolicyTQMVMI` / `NotifyToPolicyTQMCMI` | Policy service | `POST …tqm/vmi` / `…tqm/cmi` (async goroutine) | notifyTQMRequest |
| `ValidateToPolicyTQMVMI/CMI` | Policy service | `POST …tqm/{vmi,cmi}/validate` | **not called** (commented out) |

## Auth & Middleware

Registered in `main.go` (Echo applies `app.Use` middleware to every route):

1. `middleware.CORS()`: default config, which allows all origins.
2. **JWT** `echojwt.WithConfig`: HS256 by default, signing key `JWT_SECRET_KEY`, claims `jwtCustomClaims{email, RegisteredClaims}`. The token comes from `Authorization: Bearer <token>`. The code does not check any role or claim beyond the signature and expiry.
   - **Skipped for:** `/healthcheck`, `GET /api/v1/sf/businesshr`, and any path containing `/api/v1/sf/docs`.
3. `RequestLoggerWithConfig`: JSON slog. It extracts `InsurancePolicyID` from the body to log `policy_id`. Skipped for healthcheck and docs.
4. Custom validator: tags `checkTimeFormat` (`15:04`), `birthdate` (`2006-01-02`, not in the future; empty is allowed), `datetime` (RFC3339 or `2006-01-02 15:04:05`; empty is allowed). pgtype values are unwrapped for validation.
5. `customHTTPErrorHandler`: every `echo.HTTPError` is returned as
   ```json
   { "title": "Unsuccess", "status": 400, "description": "<message>", "result": null }
   ```
   Any other error type becomes `500 "Internal Server Error"`.

Common success envelope (`structs.ResponseStructs` + `Result`): `{ "title": "Success", "status": 200, "description": "", "result": … }`.

## Endpoint Summary

The two dispatcher routes pick a sub-function by the body field `fn`, compared case-insensitively. Each `fn` is listed as its own logical endpoint.

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | none | `main.go:164` | Liveness; returns plain text `is already` |
| GET | `/api/v1/sf/docs/*` | none | `router/router.go:13` (echoSwagger) | Swagger UI |
| POST | `/api/v1/sf/saleforceControllerAPI` | JWT | `controllers/sf_service.go:19` | Dispatcher on `fn` (the 12 functions below) |
| ↳ | fn=`PolicyTransacti` | JWT | `controllers/policy_transacti_service.go:41` | Endorsement (financial/non-financial) from SF → `fn_sf_policy_endorse_financial` |
| ↳ | fn=`PolicyAttachment` | JWT | `controllers/policyAttachment_service.go:30` | Upload policy document → GCS + `Policy_Regis_Evident` → SF |
| ↳ | fn=`iBilling` | JWT | `controllers/iBilling_service.go:16` | Upsert surveyor billing and pay records for a claim |
| ↳ | fn=`Claim` | JWT | `controllers/claim_service.go:22` | Upsert claim, car detail, injured and asset records; generate claim doc; push to SF |
| ↳ | fn=`ClaimAttachment` | JWT | `controllers/claimAttachment_service.go:17` | Upload claim file → GCS + `sf_claim_attech` → SF |
| ↳ | fn=`getMotorMaster` | JWT | `controllers/motorMaster_service.go:17` | Motor master data for an endorsement (`fn_policy_endorse_master`) |
| ↳ | fn=`getMotorCoverage` | JWT | `controllers/motorCoverage_service.go:24` | Recalculate coverage/premium (`fn_policy_endorse_coverage`) plus OIC driver behaviour |
| ↳ | fn=`FileAttachment` | JWT | `controllers/fileAttachment_service.go:23` | Upload case/chat file → GCS + `sf_file_attach` → SF |
| ↳ | fn=`livechatHour` | JWT | `controllers/businesshr_service.go:17` | Upsert live-chat business hours |
| ↳ | fn=`carInspectResult` | JWT | `controllers/tqm_car_inspect.go:21` | TQM car inspection result (also reachable via the `/tqm/` route) |
| ↳ | fn=`notifyTQMRequest` | JWT | `controllers/tqm_notify_service.go:15` | TQM data-file notification (also reachable via the `/tqm/` route) |
| ↳ | fn=`uploadEndorseAttachment` | JWT | `controllers/fileAttachment_service.go:143` | Push one GCS endorsement file to SF for many TQM policies |
| POST | `/api/v1/sf/customerDetail` | JWT | `controllers/customerDetail_service.go:32` | SF changes customer profile/email → `sec_user` → SF upsertaccount |
| POST | `/api/v1/sf/notification/sms` | JWT | `controllers/notification_service.go:26` | Relay SMS to the notification service |
| POST | `/api/v1/sf/notification/email` | JWT | `controllers/notification_service.go:93` | Relay email to the notification service |
| POST | `/api/v1/sf/notification/tqm/emailendorse` | JWT | `controllers/tqm_notify_service.go:139` | Relay TQM endorsement email |
| GET | `/api/v1/sf/businesshr` | **none** (skipped) | `controllers/businesshr_service.go:84` | Current live-chat business-hour message/status for the frontend |
| POST | `/api/v1/sf/tqm/saleforceControllerAPI` | JWT | `controllers/tqm_sf_service.go:19` | TQM dispatcher: only `carInspectResult` and `notifyTQMRequest` |

That is 9 registered routes, plus 12 `fn` sub-functions on the SF dispatcher (2 of them also on the TQM dispatcher).

## Endpoints

### Dispatcher behaviour (both `saleforceControllerAPI` routes)

- The handler reads the raw body and unmarshals `{ "fn": string }`. An empty `fn` returns **400** `fn required`, and an unknown one returns **400** `fn is invalid`. Invalid JSON returns 400.
- It sets the response header `X-Request-Id` to the lowercased `fn`.
- It prints a minified copy of the body to stdout. For the attachment functions, the `body` (base64) field is left out.
- It unmarshals into the function's DTO, runs `c.Validate`, and returns **400** with the validator message if validation fails.

---

### GET `/healthcheck`
Returns `200 text/plain` `is already`. No auth, no DB access.

### GET `/api/v1/sf/docs/*`
Swagger UI generated by swaggo (`docs/docs.go`). No auth.

---

### fn = `PolicyTransacti`
Spec sheets: [32_r1_microservice-policytransacti](../salesforce_api_specs/02_microservice_inbound/32_r1_microservice-policytransacti.md), [35_r2_5_microservice-policytransac](../salesforce_api_specs/02_microservice_inbound/35_r2_5_microservice-policytransac.md)

**Purpose:** Salesforce sends an approved endorsement for a voluntary (V) or compulsory/CMI (C) policy. The stored function applies it and returns the transaction number, then the service triggers the downstream re-issue, IIA and document steps.

**Request body** (`dto.PolicyTransactiDto`, `controllers/dto/policyTransacti.go`):
```json
{
  "fn": "PolicyTransacti",
  "insurancePolicyId": "MV-0023-K-000011",
  "salesforceID": "a0X000000000001",
  "type": ["carColor", "effectiveDate", "coverageDetail"],
  "carColor": "CL001",
  "ownerPrefixName": "นาย", "ownerFirstName": "กฤษณะ", "ownerLastName": "วัฒนายนนต์",
  "ownerHouseNo": "1", "ownerMoo": "1", "ownerProvinceId": "10", "ownerDistrictId": "124",
  "ownerSubdistrictId": "979", "ownerZipcode": "18110", "ownerCardId": "1111111111119",
  "ownerBirthdate": "1990-01-01",
  "effectiveDate": "2024-01-03T17:01:00.000Z",
  "apprStatus": "Approved", "apprFirstName": "Approver", "apprLastName": "SF",
  "refundType": "pro",
  "coverageDetail": {
    "fieldName": ["policyType", "garageType"],
    "policyType": "1", "garageType": "G", "premAmt": 1000.00, "dutyAmt": 4, "vatPer": 7, "vatAmt": 70.28, "totalAmt": 1074.28
  }
}
```

| Field | Type | Required | Validation / notes |
|---|---|---|---|
| fn | string | ✔ | `required` |
| insurancePolicyId | string | ✔ | `required`. The prefix `MV`/`MC` is used for TQM detection |
| salesforceID | string | – | If present, it is checked for duplicates in `log_sf_policy_trans` (duplicate → 400). If empty, the TQM path runs (see flow) |
| type | string[] | ✔ | `required,gt=0,dive,required,min=1`. The list of changed field groups |
| apprFirstName | string | ✔ | `required` |
| ownerBirthdate | text | – | `omitempty,birthdate` (`YYYY-MM-DD`, not in the future) |
| startDate / endDate / effectiveDate | text | – | `omitempty,datetime` (RFC3339 or `YYYY-MM-DD HH:mm:ss`) |
| refundType | string | – | `omitempty,oneof=full short pro` |
| owner* (PrefixName, FirstName, LastName, Address, HouseNo, Moo, Building, Soi, Road, ProvinceId, DistrictId, SubdistrictId, Zipcode, CardId, Occupation) | text | – | Split address parts are resolved into `ownerAddress` (`policy_address.go`). Province, district and subdistrict names are looked up from the IDs |
| car* (Color, LicenseType, LicenseNo, LicenseProvice, SerialNo, Brand, Model, Cc) | text | – | `carColor` may be a name; it is resolved through `mas_cmi_color` |
| appr* (Status, PrefixName, LastName, Comment) | text | – | – |
| deli* (Flag, Address, HouseNo, Moo, Building, Soi, Road, ProvinceId, SubdistrictId, DistrictId, Zipcode) | text | – | Delivery address |
| bene* (Type, Title, Firstname, Lastname) | text | – | Beneficiary |
| driveAction | text | – | – |
| par1..par5 (Prefix, Firstname, Lastname, DriverNo, DriverLicenseCategory, CitizenId, Occupation) | text / *string | – | Named drivers. Par1/2 are pgtype.Text, par3–5 are *string |
| driverBehavior1..5 | *int | – | – |
| driverConsent1..5 | *bool | – | – |
| driverBrithdate1, driverBrithdate2, driverBirthdate3..5 | text | – | Note that 1–2 keep the misspelling "Brith" from the SF schema |
| scPremiumAmt | *float64 | – | – |
| garageType, packageId | *string | – | – |
| coverageDetail | object | – | `CoverageDetail`: `fieldName[]` (`omitempty,gt=0,dive,required,min=1`); `policyType`, `coverageDayCount`, `hp`, `carBrand`, `carModel`, `garageType`, premium components (`basicPremAmt`, `basicPremV5Amt`, `premiumV5Od`, `usage`, `usageTariff`, `carCc*`, `driverAge*`, `carYear*`, `siAmt`, `odAmt`, `ftAmt`, `access*`, `carGroup*`, `tpbi*`, `tppd*`, `mv01..03*`, `cctv*`, `totalMvAmt`, `fleetDisc*`, `ncbDisc*`, `otherDisc*`, `totalDiscAmt`, `extendEnddate` (`omitempty,datetime`), `extendDayCount`, `extendPremAmt`, `premAmt`, `dutyAmt`, `vatPer`, `vatAmt`, `totalAmt`, `driverBehaviorSummary/Tariff/Disc`, `par1..5CitizenId`), plus `driverBrithdate1/2` (`omitempty,birthdate`). It is serialized to JSON and passed to the function as one text argument |

**Flow** (`PolicyTransactiService`):
1. **TQM shortcut:** if `salesforceID` is empty, `processEndorseJobNoti` runs. For an `MV…` policy it calls `CheckTQMPolicyNoExists` (`Policy_Header` ⋈ `tqm_lead_vmi`); for `MC…` it calls `CheckTQMCarActNoExists` (`Policy_Car_Act_Discount_Premium` ⋈ `tqm_lead_cmi`). If the policy is a TQM policy, the payload is mapped and sent to SF `upsertpolicytransaction`, `log_sf_policy` is written, and the service returns **200** without calling the DB function. If the policy is not TQM (the check returns false), it also returns 200 and nothing is processed (⚠️ see Notes).
2. If `salesforceID` is set and already in `log_sf_policy_trans`, the response is **400** `salesforceID duplicated`.
3. It builds the parameters (`GetProvince`/`GetDistrict`/`GetSubdistrict`/`GetOwnerInfoByPolicyNo`/`GetColorIdByColorName`) and calls **`insurverse.fn_sf_policy_endorse_financial(...)`**.
4. Result handling by `out_policy_type`:
   - msg `Document Type Mapping Issue.` → **500**.
   - No `sf_trans_id` and type `R` (rejected) → **200** Success, with `msg` in the description. Any other type without `sf_trans_id` → **400** with msg.
   - `V` → UAM `create_policy_pure(policy_no)`. `C` → UAM `create_policy_act(car_act_no)` and `cmi_realtime_endorse_service(sf_trans_id)`. `F` or unknown → **404**. `R` → 200.
5. It sends to IIA through UAM `ry{docGroupType}` (26/27/28 are all sent as `ry28`).
6. If `endorse_doc_type` is `v0_11`, `v1_11` or `v5_11`, it calls **`insurverse.fn_update_point_cancel('m'+type, policy_no)`** and pushes app notifications for the returned `app_noti_id` / `ref_app_noti_id`.
7. It calls Doc `GET endorse/{sf_trans_id}` to create the endorsement document.
8. It writes `log_sf_policy` (request header and body, response) on every terminal branch.

**Success 200** (`structs.PolicyTransactiStructs`):
```json
{
  "title": "Success", "status": 200, "description": "success",
  "Result": null,
  "result": {
    "insurancePolicyId": "MV-0023-K-000011",
    "transactionNumber": "SFT-000123",
    "requestId": 456,
    "msg": "…",
    "endorseDocType": "v0_11",
    "endorseDocName": "…",
    "salesforceID": "a0X000000000001"
  }
}
```
(`Result: null` comes from the untagged embedded `ResponseStructs.Result` field. ⚠️ Whether it serializes alongside `result` depends on Go's field-shadowing rules; the outer `result` field wins. Unverified at runtime.)

**Errors:** 400 (validation, `salesforceID duplicated`, function msg), 404 (policy type F or unknown), 500 (DB error, `Document Type Mapping Issue.`, error from the SF API on the TQM path).

**DB:** `fn_sf_policy_endorse_financial` (read/write), `fn_update_point_cancel`, `log_sf_policy_trans` (R), `log_sf_policy` (W), `province`, `district`, `subdistrict`, `Policy_Header`, `mas_cmi_color`, `tqm_lead_vmi`, `tqm_lead_cmi`, `Policy_Car_Act_Discount_Premium` (R).
**Outbound:** SF `upsertpolicytransaction` (TQM path only); UAM `create_policy_pure` / `create_policy_act` / `cmi_realtime_endorse_service` / `ry28` and similar; Notification `push_notification_id`; Doc `endorse/{id}`. The results of the UAM, Doc and Push calls are **ignored**.

---

### fn = `PolicyAttachment`
Spec: [41_microservice-policyattachment](../salesforce_api_specs/02_microservice_inbound/41_microservice-policyattachment.md) · Outbound: [18](../salesforce_api_specs/01_sfdc_inbound/18_sf-policyattachment_(url).md)

**Request** (`dto.PolicyAttachmentDto`; this DTO has **no validate tags**):
```json
{ "fn": "PolicyAttachment", "fileID": "", "name": "idcard.jpg", "contentType": "image/jpeg",
  "description": "บัตรประชาชน", "body": "<base64>", "insurancePolicyId": "MV-0023-K-000011",
  "transactionNumber": "SFT-000123", "isDeleted": false, "code": "01" }
```
| Field | Type | Required | Notes |
|---|---|---|---|
| fn | string | ✔ (dispatcher) | – |
| fileID | text | – | If empty, a new ID is generated by `fn_policy_fileid_sf()` |
| name, contentType, body | string | (not enforced) | `body` = base64 file content |
| description | text | – | – |
| insurancePolicyId | string | (not enforced) | – |
| transactionNumber | text | – | – |
| isDeleted | bool | – | – |
| code | string | – | Stored as `evi_sector_id` |

**Flow:** get the file ID → upload to GCS → look up `Policy_Regis_Evident` by (policy, code). If no row exists, insert one with the next `evi_id` (`GetLastEviIdByPolicyNo`); otherwise update. Then list the rows for the fileID, build thumbnails and send them to SF `upsertpolicyattachmenturl`.
**200:** `{ "title":"Success","status":200,"description":"","result":{"fileID":"…","fileURL":"https://…"} }`
**Errors:** 404 `fileID not found.`, 400 (thumbnail error, SF error `error from [/services/apexrest/upsertpolicyattachmenturl], statusCode=…, message=…`), 500 (DB/GCS).
**DB:** `fn_policy_fileid_sf`, `Policy_Regis_Evident` (R/W).

---

### fn = `iBilling`
Spec: [53_microservice-ibilling](../salesforce_api_specs/02_microservice_inbound/53_microservice-ibilling.md)

**Request** (`dto.IBillingDto`):
```json
{
  "fn": "iBilling",
  "billing": { "surveyReportID": 123, "refNotifyNo": "N001", "refClaimNo": "C001",
    "surveyFee": 500, "insuranceFee": 500, "surveyTransportation": 0, "insuranceTransportation": 0,
    "surveyOther": 0, "insuranceOther": 0, "otherDescription": "", "billingNo": "B001",
    "billingDate": "2024-01-31", "surveyClaim": 0, "insuranceClaim": 0, "surveyDaily": 0, "insuranceDaily": 0,
    "sendDate": "2024-01-31", "sendBy": "user", "approveDate": "2024-02-01", "approveBy": "approver" },
  "pay": { "refClaimNo": "C001", "payID": "P1", "srID": "S1", "srrefID": "R1", "addNo": 1, "surveyID": "SV1",
    "surveyorName": "…", "accClaimRefNo": "…", "accPolicyNo": "…", "carRegNo": "…", "unitPrice": 500, "incVat": 535,
    "sendDate": "…", "checkDate": "…", "checkrID": "…", "approveID": "…", "accDate": "…", "accCallDate": "…",
    "posStatus": 1, "vendor": "…" }
}
```
| Field | Type | Required | Validation |
|---|---|---|---|
| billing.surveyReportID | int64 | ✔ | `required` |
| billing.refNotifyNo | string | ✔ | `required` |
| billing.refClaimNo | string | ✔ | `required` |
| billing.billingDate / sendDate / approveDate | *string | – | Parsed as `YYYY-MM-DD`. A parse failure returns **500** |
| billing.* fees | numeric | – | – |
| pay.refClaimNo | string | ✔ | `required` |
| pay.* others | text / numeric | – | – |

**Flow:** upsert `sf_claim_ibilling` by (surveyReportID, refNotifyNo, refClaimNo). Upsert `sf_claim_pay` by (surveyReportID, refNotifyNo, pay.refClaimNo). If `approveDate` or `approveBy` is present, `UpdateClearIIASeqSFClaim` sets `sf_claim.claim_url_ref`, `claim_url_ref_tp`, `seq_id`, `cross_result` (and similar) to NULL so the claim document is regenerated and resent to IIA.
**200:** `{ "title":"Success","status":200,"description":"","result":null }`. **Errors:** 400 validation, 500 DB or date parse.
**DB:** `sf_claim_ibilling` (R/W), `sf_claim_pay` (R/W), `sf_claim` (W).

---

### fn = `Claim`
Spec: [43_microservice-claim](../salesforce_api_specs/02_microservice_inbound/43_microservice-claim.md)

**Request** (`dto.ClaimDto`; **no validate tags**, so nothing is enforced beyond `fn`):
```json
{
  "fn": "Claim", "surveyReportID": 123, "sendSMS": true, "refNotifyNo": "N001", "refClaimNo": "C001",
  "addOn": 0, "surveyID": 1, "surveyBrID": 1, "posStatus": 1, "prbNumber": "", "accPolicyNo": "MV-0023-K-000011",
  "assuredName": "กฤษณะ วัฒนายนนต์", "policyType": "1", "policyStart": "2024-01-01T00:00:00", "policyEnd": "2025-01-01T00:00:00",
  "opoPay": 0, "accidentDate": "2024-06-01T10:00:00", "accidentPlace": "…", "accidentDistrict": "…", "accidentProvince": "…",
  "accident_district_id": 124, "accident_province_id": 10, "accidentType": "…", "accidentDetail": "…", "accidentCause": 1,
  "policeName": "…", "surveyorName": "…", "surveyDate": "2024-06-01T12:00:00", "remark": "",
  "carDetail": [{ "recordID": "CD1", "index": 1, "carRegisterNo": "กข1234", "carProvinceId": 10, "carBrand": "TOYOTA",
     "driverName": "…", "driverBirthday": "1990-01-01", "driverIDCard": "1111111111119", "totalDamageCost": 10000,
     "damageList": [{ "part": "bumper", "damageLevel": "M", "damageType": "scratch", "damageCost": 5000, "memo": "" }] }],
  "injured": [{ "recordID": "IJ1", "index": 1, "name": "…", "idCard": "1111111111119", "birthday": "1990-01-01", "cost": 0 }],
  "asset": [{ "recordID": "AS1", "index": 1, "assetName": "…", "ownerName": "…", "cost": 0 }]
}
```
Field groups: the header fields map to `sf_claim`. `carDetail[]` (recordID, index, car*, driver*, haveInsurance, policyNo, claimNo, policyType, opoRecovery, totalDamageCost, damageList[] stored as JSON text) maps to `sf_claim_car_detail`. `injured[]` maps to `sf_claim_injured`, and `asset[]` maps to `sf_claim_asset`. Timestamp fields are `pgtype.Timestamp`, and date fields (`driverBirthday`, `driverLicenseStart/Expired`, `birthday`) are `pgtype.Date` (⚠️ the JSON formats pgx accepts were not verified).

**Flow:**
1. Compute the next `sc_id` as MAX over `sf_claim_car_detail` and `sf_claim_asset`, plus one.
2. Upsert `sf_claim` by (surveyReportID, refNotifyNo, refClaimNo). For a new claim, `fn_claim_sr_log_id_iia()` supplies the sr_log id.
3. Upsert child rows by recordID. New rows are inserted in bulk with **COPY FROM** (`CreateSfClaimCarDetail/Injured/Asset`); existing rows are updated.
4. Call Doc `POST claim` with the survey, notify and claim references (result ignored).
5. For the claim's insured and third-party documents (`ListClaimInsured`/`ListClaimTP`) that have a URL, send them to SF `upsertclaimattachmenturl`. On status `0000`, update `sf_claim` with the file id (`UpdateSfEclaimFileId`/`…Tp`). SF errors do **not** fail the request; they are returned in `description` as a warning.

**200:** `{ "title":"Success","status":200,"description":"<warning or empty>","result":null }`. **Errors:** 500 DB.
**DB:** `sf_claim` (R/W), `sf_claim_car_detail`, `sf_claim_injured`, `sf_claim_asset` (R/W, COPY), `fn_claim_sr_log_id_iia`.

---

### fn = `ClaimAttachment`
Spec: [51_microservice-claimattachment](../salesforce_api_specs/02_microservice_inbound/51_microservice-claimattachment.md), [52](../salesforce_api_specs/02_microservice_inbound/52_microservice-claimattachment_(e.md) · Outbound [21](../salesforce_api_specs/01_sfdc_inbound/21_sf-claimattachmenturl.md)

**Request** (`dto.ClaimAttachmentDto`):
```json
{ "fn": "ClaimAttachment", "fileID": "", "name": "damage.jpg", "contentType": "image/jpeg", "description": "รูปความเสียหาย",
  "body": "<base64>", "caseID": "500xx", "fileType": "photo", "claimNumber": "C001", "eClaimID": "E001",
  "surveyorReportID": "123", "itemID": "", "noteID": "" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| name | string | ✔ | `required` |
| contentType | string | ✔ | `required` |
| body | string (base64) | ✔ | `required` |
| fileID | text | – | Generated by `fn_claim_fileid_sf()` if empty |
| description, caseID, fileType, claimNumber, eClaimID, surveyorReportID, itemID, noteID | text | – | – |

**Flow:** upload to GCS → upsert `sf_claim_attech` → list by fileID → thumbnail → SF `upsertclaimattachmenturl`.
**200:** `result: { "fileID": "…", "fileURL": "…", "description": "<description + ' ' + fileType>" }`. **Errors:** 400 (validation, SF error), 404 `fileID not found.`, 500.
**DB:** `fn_claim_fileid_sf`, `sf_claim_attech` (R/W).

---

### fn = `getMotorMaster`
Spec: [33_microservice-get_motor_master](../salesforce_api_specs/02_microservice_inbound/33_microservice-get_motor_master.md)

**Request:** `{ "fn": "getMotorMaster", "insurancePolicyId": "MV-0023-K-000011" }` (both `required`).
**Flow:** `insurverse.fn_policy_endorse_master(insurancePolicyId)` returns a JSON text. If `success == false`, the response is **400** with the function's `message`. If the policy's `partner_code` is `TQM` (`GetPartnerCodeByInsurancePolicyID`), the `occupation` key is set to null.
**200:** `{ "title":"Success","status":200,"description":"","result": { …JSON returned by fn_policy_endorse_master… } }`. The shape is defined by the DB function (⚠️ not in code).
**Errors:** 404 `insurancePolicyId not found`, 400 function message, 500.
**DB:** `fn_policy_endorse_master`, `Policy_Header` (R).

---

### fn = `getMotorCoverage`
Spec: [34_microservice-get_motor_coverage](../salesforce_api_specs/02_microservice_inbound/34_microservice-get_motor_coverage.md)

**Request** (`dto.MotorCoverageDto`):
```json
{ "fn": "getMotorCoverage", "insurancePolicyId": "MV-0023-K-000011", "carBrand": "TOYOTA", "carModel": "YARIS",
  "carYear": 2022, "carGroup": "4", "carCcCondition": "<=2000", "namedAge": "",
  "par1CitizenId": "1111111111119", "par1Consent": true, "par2CitizenId": "", "par2Consent": false,
  "premiumVersion": 2 }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| fn, insurancePolicyId, carBrand, carModel | string | ✔ | `required` |
| carYear | int | ✔ | `required` |
| carGroup, carCcCondition | text | – | – |
| namedAge | string | cond. | Required when `premiumVersion` is null and the policy is not TQM (`namedAge is required for old OIC (premiumVersion is null)`) |
| par1..5CitizenId | string | – | Must be exactly 13 characters; duplicates are rejected |
| par1..5Consent | bool | – | Without consent, the behaviour value is set to 1 |
| premiumVersion | *int64 | – | null means the old OIC tariff |

**Flow:** check whether the policy is TQM (`GetDataByPolicyNo` partner_code). If it is TQM or `premiumVersion` is set, merge the drivers with `Policy_Header.par_citizen_id*`/`par_behavior*` and call Policy `oic/driver_behavior` for drivers with no known behaviour. For TQM policies, return a fixed skeleton straight away (`success`, `message`, `coverageList:null`, `si_detail:null`, `si_base_v5_detail:null`, `driverBehavior1..5`, `driverBehaviorSummary`). Otherwise call `insurverse.fn_policy_endorse_coverage(insurancePolicyId, carBrand, carModel, carYear, carGroup, carCcCondition, namedAge, driverBehavior(lowest), premVersion)` and merge the `driverBehavior1..5` and `driverBehaviorSummary` keys into its JSON.
**200:** `result` = the function's JSON plus the driverBehavior keys. **Errors:** 400 (validation, OIC error, function `success=false`), 404 `insurancePolicyId not found`, 500.
**DB:** `fn_policy_endorse_coverage`, `Policy_Header` (R). **Outbound:** Policy `oic/driver_behavior`.

---

### fn = `FileAttachment`
Spec: [64_microservice-fileattachment](../salesforce_api_specs/02_microservice_inbound/64_microservice-fileattachment.md) · Outbound [26](../salesforce_api_specs/01_sfdc_inbound/26_sf-fileattachmenturl.md)

**Request:** `{ "fn":"FileAttachment", "fileID":"", "name":"chat.png", "contentType":"image/png", "description":"", "body":"<base64>", "caseID":"500xx", "chatID":"570xx" }`
Required: `fn`, `name`, `contentType`, `body`. `fileID` is generated by `fn_file_fileid_sf()` if empty.
**Flow:** GCS upload → upsert `sf_file_attach` → list → thumbnail → SF `upsertfileattachmenturl`.
**200:** `result: {"fileID":"…","fileURL":"…"}`. **Errors:** 400, 404 `fileID not found.`, 500.
**DB:** `fn_file_fileid_sf`, `sf_file_attach` (R/W).

---

### fn = `livechatHour`
Spec: [65_microservice-businesshour](../salesforce_api_specs/02_microservice_inbound/65_microservice-businesshour.md)

**Request:** `{ "fn":"livechatHour", "startTime":"08:30", "endTime":"21:00", "displayMessageTH":"…", "displayMessageEN":"…" }`
| Field | Type | Required | Validation |
|---|---|---|---|
| startTime, endTime | string | ✔ | `required,checkTimeFormat` (`HH:mm`) |
| displayMessageTH, displayMessageEN | string | ✔ | `required,max=2000` |

**Flow:** if `sf_business_hour` has no row (`GetSFBusinessHourMaxId`), insert one; otherwise update the row with the max id. This is a single-row configuration.
**200:** `{ "title":"Success","status":200,"description":"" }`. **Errors:** 400, 500.
**DB:** `sf_business_hour` (R/W).

---

### fn = `carInspectResult` (also on `POST /api/v1/sf/tqm/saleforceControllerAPI`)

**Request** (`dto.CarInspectionTQMRequestDTO`):
```json
{ "fn": "carInspectResult",
  "requests": [{ "requestId": "SBC-0001", "status": "success", "inspectDetail": "…", "inspectDate": "2024-06-01",
    "carDetail": { "carColor": "ขาว", "carLicense": "กข1234", "carProvince": "สระบุรี", "carBand": "TOYOTA", "carModel": "YARIS", "carYear": "2022", "haveAccessory": false },
    "imageDetail": [{ "imageName": "front", "imageType": "jpg", "imageStatus": "pass", "imageResaon": "", "imagePartDetail": "", "imagePath": "gs://…" }] }] }
```
Validation (per item, in code rather than tags): `requestId` required; `inspectDate` is `YYYY-MM-DD`; `requestId` must exist in `tqm_request_status` and in `tqm_lead_vmi` (sale_book_code); `status` must be `success` or `fail`; `inspectDate` must not be more than 365 days before the policy start date.
**Flow:** if any item fails validation, the whole request returns **400** `{title:"Insert Policy Transaction Response", status:400, description:"Invalid Request", result:[{requestId,status:"Fail",errMsg}]}`. Otherwise, for each item: `CreateTQMCarInspectResult` → `tqm_car_inspect_result` (guarded by `tqm_request_status`) → `UpdateTQMRequestStatus(status=INSPECTED, type=VMI)` → `UpdateCarInspectStatusBySaleBookCode` (`Policy_Header`).
**200:** `{ "title":"Insert Policy Transaction Response","status":200,"description":"","result":[{"requestId":"SBC-0001","status":"Success","errMsg":""}] }`. Failures on individual items come back inside a 200 with `status:"Fail"`.
**Errors:** 400. If the insert returns no rows, the handler returns a plain error, which the error handler turns into **500** `Internal Server Error`.
**DB:** `tqm_request_status` (R/W), `tqm_lead_vmi` (R), `tqm_car_inspect_result` (W), `Policy_Header` (W).

---

### fn = `notifyTQMRequest` (also on `POST /api/v1/sf/tqm/saleforceControllerAPI`)

**Request:** `{ "fn":"notifyTQMRequest", "requestDataUrl":"gs://bucket/path/file.txt", "policyType":"VMI", "requestType":"request" }`
| Field | Type | Required | Validation |
|---|---|---|---|
| requestDataUrl | string | ✔ | `required`; must start with `gs://` and end in `.txt` |
| policyType | string | ✔ | `VMI` or `CMI` (case-insensitive) |
| requestType | string | ✔ | `request` \| `edit` \| `endorsement` |

**Flow:** validate, then start an async goroutine that calls Policy `tqm/vmi` or `tqm/cmi`. The result is only logged.
**200:** `{ "title":"Success","status":200,"description":"","Result":null }`. **400** bodies use `title` as the message (for example `invalid GCS URI: missing gs:// prefix`, `policyType invalid`, `requestType invalid` in description).
**DB:** none. **Outbound:** Policy service TQM.

---

### fn = `uploadEndorseAttachment`

**Request:** `{ "fn":"uploadEndorseAttachment", "requestIds":["SBC-0001","SBC-0002"], "fileUrl":"gs://bucket/endorse/file.pdf" }`. Both `requestIds` and `fileUrl` are `required`; an empty list or URL returns 400.
**Flow:** download the file from GCS (from a `gs://` or https URL). For each requestId (the TQM `sale_book_code`), look up `Policy_Header ⋈ tqm_lead_vmi` (`GetTQMPolicyWithPolicyNo`); IDs that are not found are skipped. Send the file to SF `upsertpolicyattachment` and write `log_sf_policy` asynchronously.
**200:** `{ "title":"Endorsement Attachment Response","status":200,"description":"Successfully processed N endorsement attachment(s)","Result":null }`.
**Errors:** 400 (download failure, empty file, SF non-`0000` messages joined with `; `), 500 (DB error, SF transport error).
**DB:** `Policy_Header`, `tqm_lead_vmi` (R), `log_sf_policy` (W).

---

### POST `/api/v1/sf/customerDetail`
Spec: [60_microservice-customer_detail](../salesforce_api_specs/02_microservice_inbound/60_microservice-customer_detail.md) · Outbound [06_sf-account](../salesforce_api_specs/01_sfdc_inbound/06_sf-account.md)

**Request** (`dto.CustomerDetailDto`):
```json
{ "accountID": "001xx000003DGb2AAG", "email": "kritsana.w.os@horixon-t8.com", "phone": "0628696603",
  "firstname": "กฤษณะ", "lastname": "วัฒนายนนต์", "prefix": "นาย", "birthdate": "1990-01-01" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| accountID | string | ✔ | `required`; the SF account id in `sec_user` |
| email | text | – | Lower-cased. If it differs from the current email, the email-change flow runs |
| phone, firstname, lastname, prefix | text | – | – |
| birthdate | *string | – | `YYYY-MM-DD`. A parse error returns **500** |

**Flow:** `GetUserBySfAccountId` (404 if not found). If the email changed: insert `log_email_change` → `CheckIsDuplicateEmail` (400 `อีเมลถูกใช้งานแล้ว โปรดใช้อีเมลอื่น`) → insert `temp_otp` → update `log_email_change` → **`fn_profile_email_change(ref_id)`**, which must return `success` or the response is 500 `can not update email.`. Then `UpdateUser` (`sec_user`), re-read the user with `GetUserBySfUserId`, and call SF `upsertaccount` with CustomerType `Person`, AccountType `Owner`, PaymentStatus `ปกติ`. A non-`0000` status returns **400**.
**200:** `{ "title":"Success","status":200,"description":"","result":null }`.
**DB:** `sec_user` (R/W), `log_email_change` (W), `temp_otp` (W), `fn_profile_email_change`.

---

### POST `/api/v1/sf/notification/sms`
Spec: [57_microservice-noti_(sms)](../salesforce_api_specs/02_microservice_inbound/57_microservice-noti_(sms).md)

**Request:** `{ "phone": "0628696603", "content": "ข้อความ" }`. `phone` may be a string **or** an array of strings. `content` is `required`. Any other type for `phone` returns 400 `body request`.
**Flow:** one notification-service `sms` call per number. Downstream errors are **only logged**, and the endpoint always returns 200.
**200:** `{ "title":"Success","status":200,"description":"","result":"" }`.

### POST `/api/v1/sf/notification/email`
Spec: [56_microservice-noti_(email)](../salesforce_api_specs/02_microservice_inbound/56_microservice-noti_(email).md)

**Request:** `{ "subject":"…", "content":"<html>…", "email":["kritsana.w.os@horixon-t8.com"], "attach":[{"filebase64":"…","filename":"a.pdf"}] }`. `subject`, `content` and `email` are `required`.
**Flow:** relays to the notification service `email`. Errors are only logged, and the endpoint always returns 200 with the same envelope as sms.

### POST `/api/v1/sf/notification/tqm/emailendorse`
**Request** (`dto.EndorseEmailRequest`, no validate tags): `{ "notiType":"…", "mailSubject":"…", "content":"…", "attach":[{"filename":"…","filebase64":"…"}] }`
**Flow:** relays to the notification service `tqm/emailendorse`. A transport error returns **400** `{title:"error",status:400}`. Otherwise it returns 200 with `title` equal to the downstream title.
No SF spec sheet matches this endpoint (⚠️ see Notes).

### GET `/api/v1/sf/businesshr`  (no JWT)
Spec: [66_frontend-businesshour](../salesforce_api_specs/03_aws_and_frontend/66_frontend-businesshour.md)

**200:**
```json
{ "title":"Success","status":200,"description":"",
  "result": { "displayMessageTH":"ขณะนี้เป็นเวลานอกทำการ…", "displayMessageEN":"…", "isActive": true } }
```
`isActive = !flag_out_business_time`, computed by the SQL `GetSFBusinessHour`. If there is no row, `isActive=false` and the messages are null. **Errors:** 500.
**DB:** `sf_business_hour` (R).

## DB Usage

All objects are in schema `insurverse`.

| Table / function | R/W | Endpoints (fn) |
|---|---|---|
| `fn_sf_policy_endorse_financial(...)` | call (W) | PolicyTransacti |
| `fn_update_point_cancel(text,text)` | call (W) | PolicyTransacti |
| `fn_policy_endorse_master(text)` | call (R) | getMotorMaster |
| `fn_policy_endorse_coverage(...)` | call (R) | getMotorCoverage |
| `fn_policy_fileid_sf()` / `fn_claim_fileid_sf()` / `fn_file_fileid_sf()` | call (ID seq) | PolicyAttachment / ClaimAttachment / FileAttachment |
| `fn_claim_sr_log_id_iia()` | call | Claim |
| `fn_profile_email_change(text)` | call (W) | customerDetail |
| `log_sf_policy` | W | PolicyTransacti, uploadEndorseAttachment |
| `log_sf_policy_trans` | R | PolicyTransacti (salesforceID duplicate check) |
| `"Policy_Header"` | R/W | PolicyTransacti, getMotorMaster, getMotorCoverage, uploadEndorseAttachment (R); carInspectResult (W) |
| `"Policy_Car_Act_Discount_Premium"`, `tqm_lead_cmi` | R | PolicyTransacti (TQM check) |
| `tqm_lead_vmi` | R | PolicyTransacti, carInspectResult, uploadEndorseAttachment |
| `province`, `district`, `subdistrict` | R | PolicyTransacti |
| `mas_cmi_color` | R | PolicyTransacti |
| `"Policy_Regis_Evident"` | R/W | PolicyAttachment |
| `sf_claim` | R/W | Claim, iBilling (clear IIA seq) |
| `sf_claim_car_detail`, `sf_claim_injured`, `sf_claim_asset` | R/W (COPY FROM insert) | Claim |
| `sf_claim_ibilling`, `sf_claim_pay` | R/W | iBilling |
| `sf_claim_attech` | R/W | ClaimAttachment |
| `sf_file_attach` | R/W | FileAttachment |
| `sf_business_hour` | R/W | livechatHour (W), GET businesshr (R) |
| `sec_user` | R/W | customerDetail |
| `log_email_change` | W | customerDetail |
| `temp_otp` | W | customerDetail |
| `tqm_request_status` | R/W | carInspectResult |
| `tqm_car_inspect_result` | W | carInspectResult |
| `tqm_notification_job` | W (sqlc query `TQMCreateNotificationJob`) | ⚠️ no route calls it |

## Notes / ⚠️ unverified items

1. **Mapping to the spec sheets:** Salesforce-inbound sheets 32/33/34/35/41/43/51/53/64/65 all point to `/api/v1/sf/saleforceControllerAPI` with different `fn` values, which matches the code. Sheet [63 resend endorse email](../salesforce_api_specs/02_microservice_inbound/63_microservice-resend_endorse_ema.md) and [72 resend compulsory](../salesforce_api_specs/02_microservice_inbound/72_microservice-resend_compulsory.md) point to the **doc** service (`/api/v1/doc/...`), not this service. The code has endpoints with **no sheet**: `notification/tqm/emailendorse`, the `tqm/saleforceControllerAPI` route, and the `carInspectResult`, `notifyTQMRequest` and `uploadEndorseAttachment` functions. The sheets for claimcoverage, claimpayment, recovery, reserveadjust, VRA, account, policy and similar (36–50, 54) have **no matching `fn`** in this service's code. ⚠️ They may belong to another service or may not be implemented. Field-level conflicts are covered in [`../salesforce_integration_spec_v4_conflicts.md`](../salesforce_integration_spec_v4_conflicts.md).
2. **Security:**
   - The Salesforce OAuth password grant sends the client secret and password **in the URL query string**, where proxies or logs can capture them.
   - JWT is the only guard. There are no role or claim checks and no request signature from SF.
   - CORS allows every origin.
3. **PolicyTransacti with an empty `salesforceID`:** when the policy is not a TQM policy (`CheckTQM*Exists` returns false), `processEndorseJobNoti` returns `true` and the API answers 200 without calling `fn_sf_policy_endorse_financial`. ⚠️ Check whether this is intended. Only TQM policies without a salesforceID reach the SF push; everything else is silently accepted.
4. **Fire-and-forget:** UAM, Doc, Push, the notify SMS/email calls and the TQM notify goroutine all ignore downstream failures, so a 200 does not guarantee the downstream work happened. In `uploadEndorseAttachment`, `insertLog` runs in a goroutine with the request context, which may already be cancelled when it runs.
5. **Claim `sc_id`:** calculated as MAX+1 across two tables with no lock or transaction, so concurrent Claim calls can collide. There is also no transaction around the header and child upserts.
6. **Validation gaps:** `PolicyAttachmentDto`, `ClaimDto` and `EndorseEmailRequest` have no `validate` tags. In iBilling and customerDetail, a date parse error returns 500 where 400 would be expected.
7. **`FnProfileEmailChange` error** is not checked (`customerDetail_service.go` ~l.115); only the returned string is compared.
8. **Envelope quirk:** `structs.ResponseStructs` has an untagged `Result interface{}` field. Responses built directly from it (TQM notify, uploadEndorseAttachment) serialize it as `"Result": null`, with a capital R.
9. Formats for `pgtype.Timestamp`, `pgtype.Date` and `pgtype.Numeric` JSON input follow pgx v5 JSON unmarshalling. ⚠️ Not verified against live traffic.
10. The column lists for the stored functions and sqlc tables were not checked against a live DB (no DB access in this task). The generated sqlc models in `database/sqlc/models.go` are the in-repo schema reference.
