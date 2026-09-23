# go-echo-pa-service — API Spec

## Overview

- **Purpose**: Personal Accident (PA) insurance microservice. It serves PA master data (age ranges, occupations, packages, coverages, premium tariffs, health questions, beneficiary types and relations, duty percent). It creates and updates PA leads, recalculates premium, duty, promo-code discount and total on the server, and runs an AMLO blacklist check. It also handles post-policy requests (cancel, endorse, tax deduction) by sending notification emails and calling IIA.
- **Go module**: `pa-service`. Swagger title: "Microservice Premium PA" v1.0.1.
- **Framework**: Echo v4 (`github.com/labstack/echo/v4`), pgx v5 pool (`pgxpool`), sqlc-generated queries (`database/sqlc`, schema `insurverse`), go-playground/validator v10, swaggo/echo-swagger.
- **Base path**: `/api/v1/pa`. `/healthcheck` is registered at the root.
- **Port**: `HTTP_PORT`, default `3000`.
- **DB connection**: PostgreSQL. The DSN is built from `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_HOST`, `DATABASE_NAME`, with the port hardcoded to 5432 in `main.go` (`DATABASE_PORT` is required by config but only used by `sqlc.yaml`). `sslmode=disable`.

### Environment variables (names only)

`config.InitENV()` panics at startup if any of these is missing or empty. When `ENV` is `LOCAL` or empty, it loads `.env`.

| Name | Used for |
|---|---|
| `ENV` | Environment switch (`LOCAL` or empty loads `.env`) |
| `DATABASE_HOST`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`, `DATABASE_PORT` | PostgreSQL connection |
| `HTTP_PORT` | Listen port |
| `Base_Url` | Fallback base URL for internal backends |
| `Backend_Uam` | UAM service base URL (AMLO check) |
| `Backend_Notification` | Notification service base URL (email) |
| `Backend_Doc` | Document service base URL (tax deduction document) |
| `Url_IIA` | IIA third-party base URL |
| `IIA_Username`, `IIA_Password` | Basic auth for IIA |
| `EMAIL_SUPPORT` | Comma-separated recipient list for cancel and endorse emails |
| `ENC_KEY`, `IV` | AES-256-CBC key and IV used to encrypt and decrypt `leadPaNo` |

### External / third-party calls (`util/api/*`)

| Call | Method + URL | Timeout | Used by |
|---|---|---|---|
| `CheckAmloBlacklist` (`util/api/uam.go`) | `POST {Backend_Uam}check_amlo_blacklist` (fallback `{Base_Url}api/v1/uam/check_amlo_blacklist`). Body `{lead_no, owner_citizen_id, owner_firstname, owner_lastname, check_type:"pa"}` | 2 min | `POST /upsertleadpa` |
| `SendEmail` (`util/api/notification.go`) | `POST {Backend_Notification}email` (fallback `{Base_Url}api/v1/notification/email`). Body `{content, email[], sender:"pa-service", subject, attach[]}` | 2 min | `POST /requestendorse` (cancel, endorse) |
| `DocTaxDeduction` (`util/api/doc.go`) | `GET {Backend_Doc}pa_document_Tax_Deduction/{policyPaNo}` (fallback `{Base_Url}api/v1/doc/pa_document_Tax_Deduction/{id}`) | 1 min | `POST /requestendorse` (tax_dd). A failure is only logged as a warning. |
| `IIATaxDeduction` (`util/api/third_party_iia.go`) | `POST {Url_IIA}ServiceTaxDeduction/api/AddDeduction`, Basic auth (`IIA_Username`:`IIA_Password`). Body `{request_by, policy_no, policy_status, reciept_no, payment_date, policy_start_date, payment_period, policy_period, insured_title, insured_fullname, insured_tax_id, requested_flag, tax_deduction_amount}` | 2 min | `POST /requestendorse` (tax_dd). A failure is only logged as a warning. |

## Auth & Middleware

- **No authentication or authorization middleware.** All endpoints are public at the service level. Any auth is presumably handled by the gateway or ingress (⚠️ unverified, not in this repo).
- `middleware.CORS()` uses the default config (all origins allowed).
- `middleware.RequestLoggerWithConfig` writes a slog JSON log per request. It skips `/healthcheck` and any path containing `/api/v1/pa/docs`.
- These middlewares are registered with `app.Use` after the routes. In Echo v4, `Use` middleware still applies to every route.
- **Validator**: a custom validator wraps `validator.New()`. Validation errors are returned as HTTP 400 with the validator message.
- **Errors**: handlers return `echo.NewHTTPError(status, msg)`. The default Echo error handler renders them as `{"message": "<msg>"}` (see `util.ErrorResponse`).
- **X-Request-ID**: handlers set the response header `X-Request-ID` to the decrypted lead number or the `policyPaNo`, for log correlation.
- **leadPaNo encryption**: externally, `leadPaNo` is an AES-256-CBC encrypted string (`util.LeadNoEncrypt` / `util.LeadNoDecrypt`, using `ENC_KEY` and `IV`). The DB holds the int32 value.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | `main.go:58` (inline) | Liveness check. Returns plain text `is already`. |
| GET | `/api/v1/pa/docs/*` | None | `router/router.go:14` (`echoSwagger.WrapHandler`) | Swagger UI and spec (`docs/docs.go`) |
| GET | `/api/v1/pa/premium` | None | `controllers/pa_service.go:39` (`GetPremiumPA`) | All PA master data plus duty percent |
| POST | `/api/v1/pa/upsertleadpa` | None | `controllers/pa_service.go:144` (`UpsertleadPA`) | Create or update a PA lead, recalculate premium and promo, run AMLO check |
| GET | `/api/v1/pa/getleadpa/:leadPaNo` | None | `controllers/pa_service.go:583` (`GetLeadPA`) | Get a PA lead by encrypted lead number |
| POST | `/api/v1/pa/requestendorse` | None | `controllers/pa_service.go:622` (`RequestEndorse`) | Log a cancel, endorse or tax-deduction request. Sends email or calls IIA. |

Routes are registered in `router/router.go:13-19` and `main.go:58`.

## Endpoints

### GET /healthcheck

- **Purpose**: liveness probe.
- **Response 200** (`text/plain`): `is already`
- No DB access and no outbound calls.

### GET /api/v1/pa/docs/*

- **Purpose**: Swagger UI served by swaggo (`echoSwagger.WrapHandler`), for example `/api/v1/pa/docs/index.html`.
- No DB access and no outbound calls.

### GET /api/v1/pa/premium

- **Purpose**: returns all master data needed to build a PA quotation.
- **Params**: none.
- **Success 200**:

```json
{
  "status": true,
  "msg": "success",
  "data": {
    "ageRangeDetails": [{ "paAgeRangeId": 1, "ageRangeNameTh": "...", "ageRangeNameEn": "...", "ageMin": 20, "ageMax": 60 }],
    "paOccupationDetails": [{ "paOccupationId": 1, "occupationNameTh": "...", "occupationNameEn": "...", "occupationDescTh": "...", "occupationDescEn": "...", "occupationFactor": 1, "flagCoverage": true }],
    "paPackageDetails": [{ "paPackageId": 4, "packageNameTh": "...", "packageDescTh": null, "packageNameEn": "...", "packageDescEn": "...", "coverageIdArray": [1, 2, 3], "flagDebt": false }],
    "coverageDetails": [{ "paCoverageId": 2, "coverageNameTh": "...", "coverageNameEn": "...", "coverageDesc1Th": "...", "coverageDesc1En": "...", "flagCoverMain": true, "coverLimitMin": 100000, "coverLimitMax": 2200000, "coverLimitSplit": 100000, "coverSiPercent": 100, "coverageDesc2Th": "...", "coverageDesc2En": "...", "coverageDesc3Th": "...", "coverageDesc3En": "..." }],
    "paPremiumTariffDetails": [{ "paPremiumTariffId": 1, "coverageId": 2, "ageRangeId": 1, "occupationId": 1, "siFirstLimit": 1000000, "siFirstFactor": 0.25, "siSecondFlag": true, "siSecondLimit": 0, "siSecondFactor": 0.2 }],
    "paHeathQuestionDetails": [{ "paQuestionId": 1, "questionNameTh": "...", "questionNameEn": "...", "questionDescTh": "...", "questionDescEn": "...", "priority": 1 }],
    "beneTypeDetails": [{ "beneTypeId": "2", "beneTypeNameTh": "...", "beneTypeNameEn": "..." }],
    "beneRelationDetails": [{ "beneRelationId": "1", "beneRelationNameTh": "...", "beneRelationNameEn": "..." }],
    "dutyPercent": 0.4
  }
}
```

`packageDescTh` is present in the struct but never populated by the handler, so it is always `null`. Value types in the example are illustrative. Column types come from sqlc models.

- **Errors**: `404 {"message":"dutyPercent is not found."}` when the `sys_param` row is missing. `500` on any DB error.
- **DB**: `mas_pa_age_range` (`ListAgeRage`), `mas_pa_occupation` (`ListOccupation`), `mas_pa_package` (`ListPackage`), `mas_pa_coverage` (`ListCoverage`), `mas_pa_premium_tariff` (`ListPremiumTariff`), `mas_pa_heath_question` (`ListHeathQuestion`), `mas_ta_description` (`ListTaDesciptionBeneType`, `ListTaDesciptionBeneRelation`), `sys_param` (`GetDutyPercent`: dom_code `purchase` / sub_dom_code `duty` / para_code `duty_per`). All reads.
- **Outbound**: none.

### POST /api/v1/pa/upsertleadpa

- **Purpose**: create a new PA lead (when there is no `leadPaNo`) or update an existing unpaid lead. The server validates master data, recalculates each coverage premium from the tariff and rejects mismatches, applies the promo code, computes duty and total, and upserts lead premium, participants, coverages, beneficiaries and promo transaction in one DB transaction (`UpsertleadpaTx`). It checks the AMLO blacklist and returns the stored lead.
- **Request body** (`dto.UpsertLeadpaDTO`):

```json
{
  "data": {
    "leadPaNo": "<encrypted-lead-no or omit for new>",
    "paAgeRangeId": 1,
    "paOccupationId": 1,
    "paPackageId": 4,
    "coverageDetails": [
      { "paCoverageId": 2, "coverageSi": 2200000.0000, "coveragePrem": 5042.4000 }
    ],
    "taxDeductions": false,
    "policyStartdate": "2026-10-01",
    "policyEnddate": "2027-09-30",
    "email": "user@example.com",
    "promoCode": "PROMO01",
    "productGroupType": "pa",
    "productSubType": "",
    "discountPer": 0,
    "discountAmt": 0,
    "affiliateSource": "",
    "affiliateCode": "",
    "referalSource": "",
    "referalCode": "",
    "premAmt": 5042.40,
    "dutyAmt": 21,
    "totalAmt": 5063.40,
    "ownerDetails": [{
      "ownerTitleTh": "นาย",
      "ownerFirstnameTh": "ทดสอบ",
      "ownerLastnameTh": "ระบบ",
      "ownerCardType": "I",
      "ownerCardId": "1111111111119",
      "ownerAddressTh": "1 หมู่ 1",
      "ownerDistrictId": 124,
      "ownerSubdistrictId": 979,
      "ownerProvinceId": 10,
      "ownerCountryId": 1,
      "ownerZipcode": "18110",
      "ownerPhone": "0800000000",
      "ownerEmail": "user@example.com",
      "ownerBirthdate": "1990-01-01"
    }],
    "beneDetails": [{
      "beneType": 2, "beneRelation": 1, "beneTitleTh": "นาย", "beneFirstnameTh": "ผู้รับ", "beneLastnameTh": "ประโยชน์"
    }],
    "deliFlag": true,
    "deliDetail": {
      "deliAddressTh": "1 หมู่ 1", "deliDistrictId": 124, "deliSubdistrictId": 979, "deliProvinceId": 10, "deliZipcode": "18110"
    }
  }
}
```

| Field | Type | Required | Validation / notes |
|---|---|---|---|
| `data.leadPaNo` | string (encrypted) | no | If present it must decrypt to an int > 0 (else 400 `leadPaNo is invalid`) and exist in `lead_pa_premium` with payment_status not SUCCESS (else 404) |
| `data.paAgeRangeId` | int16 | yes | `required,min=1`. Must be active in `mas_pa_age_range` (else 404) |
| `data.paOccupationId` | int16 / null | no | If present, must be active in `mas_pa_occupation` (else 404) |
| `data.paPackageId` | int16 | yes | `required,min=1`. Must be active in `mas_pa_package` (else 404) |
| `data.coverageDetails[]` | array | no (no tag) | Each `paCoverageId` must be active in `mas_pa_coverage`, and a tariff must exist for coverage + age range + occupation (else 404) |
| `...paCoverageId` | int16 | – | |
| `...coverageSi` | numeric | – | Sum insured, rounded to 2 dp |
| `...coveragePrem` | numeric | – | Must equal the server-calculated premium (2 dp), else 400 `coveragePrem = X and prem_atm_value = Y do not match` |
| `data.taxDeductions` | bool | yes (manual) | 400 `taxDeductions required` if null |
| `data.policyStartdate` / `policyEnddate` | string `YYYY-MM-DD` | yes | `required`. Parsed in the transaction. A bad format gives 500. |
| `data.email` | string | no | If non-empty it must be a valid email (400). Required when `promoCode` is set (400). |
| `data.promoCode` | string | no | Looked up as uppercase against group type `pa`. 404 `promocode 'X' not found.` |
| `data.productGroupType` | string | no | If a promo code is sent, it must be `pa` (case-insensitive), else 400 `productGroupType is invalid` |
| `data.productSubType` | string | no | Passed to promo lookup |
| `data.discountPer` | numeric | no | Ignored (recalculated) |
| `data.discountAmt` | numeric | yes (manual) | 400 `DiscountAmt is required` if null, 400 if < 0. Overwritten by the server value. |
| `data.affiliateSource`, `affiliateCode`, `referalSource` | string | no | Stored as-is |
| `data.referalCode` | string | no | If the email maps to a `sec_user` whose own referral code (`fn_loyalty_referal_code`) equals this code, 400 `referalCode 'X' is invalid.` |
| `data.premAmt`, `dutyAmt`, `totalAmt` | numeric | no | Ignored and overwritten by server calculation |
| `data.ownerDetails[]` | array | yes | `required`, and an empty array gives 400 `ownerDetails is required`. Each item needs `ownerFirstnameTh`, `ownerLastnameTh`, `ownerPhone`, `ownerEmail` (400 `<field> is required.`). `ownerEmail` must be a valid format. |
| `...ownerTitleTh`, `ownerCardType`, `ownerCardId`, `ownerAddressTh`, `ownerZipcode` | string | no | `ownerCardId` of owner[0] is sent to the AMLO check |
| `...ownerDistrictId`, `ownerSubdistrictId`, `ownerProvinceId`, `ownerCountryId` | int32 | no | |
| `...ownerBirthdate` | string `YYYY-MM-DD` | no | |
| `data.beneDetails[]` | array | yes | `required` (non-nil) |
| `...beneType`, `beneRelation` | int16 | no | |
| `...beneTitleTh`, `beneFirstnameTh`, `beneLastnameTh` | string | no | |
| `data.deliFlag` | bool | yes (manual) | 400 `deliFlag required` if null |
| `data.deliDetail.*` | object | no | `deliAddressTh`, `deliDistrictId`, `deliSubdistrictId`, `deliProvinceId`, `deliZipcode` |

**Calculation rules** (in `controllers/pa_service.go`):
- Per coverage (`calCoveragePrem`, line 977): if `si_second_flag` is false, the premium is `SI × siFirstFactor/100`. If it is true, SI up to `siFirstLimit` uses the first factor and the excess uses `siSecondFactor`. Results are rounded to 2 dp.
- Duty (`caldutyAmt`, line 1061): `ceil(premAmt × dutyPercent/100)`.
- Promo (`calPromoCode`, line 998): a `percent` type discounts `premAmt × value/100`. An `amount` type subtracts a fixed value. The total is `premAmt + duty`.

- **Success 200** (`structs.LeadPAResponse`):

```json
{
  "status": true,
  "message": "success",
  "data": {
    "leadPaNo": "<encrypted-lead-no>",
    "paAgeRangeId": 1,
    "paOccupationId": 1,
    "paPackageId": 4,
    "coverageDetails": [{ "paCoverageId": 2, "coverageSi": 2200000, "coveragePrem": 5042.4 }],
    "taxDeductions": false,
    "policyStartdate": "2026-10-01",
    "policyEnddate": "2027-09-30",
    "email": "user@example.com",
    "promoCode": "PROMO01",
    "productGroupType": "pa",
    "productSubType": "",
    "discountPer": 10,
    "discountAmt": 504.24,
    "affiliateSource": "",
    "affiliateCode": "",
    "referalSource": "",
    "referalCode": "",
    "premAmt": 4538.16,
    "dutyAmt": 19,
    "totalAmt": 4557.16,
    "ownerDetails": [{ "ownerTitleTh": "นาย", "ownerFirstnameTh": "ทดสอบ", "ownerLastnameTh": "ระบบ", "ownerCardType": "I", "ownerCardId": "1111111111119", "ownerAddressTh": "1 หมู่ 1", "ownerDistrictId": 124, "ownerSubdistrictId": 979, "ownerProvinceId": 10, "ownerCountryId": 1, "ownerZipcode": "18110", "ownerPhone": "0800000000", "ownerEmail": "user@example.com", "ownerBirthdate": "1990-01-01" }],
    "beneDetails": [{ "beneType": 2, "beneRelation": 1, "beneTitleTh": "นาย", "beneFirstnameTh": "ผู้รับ", "beneLastnameTh": "ประโยชน์" }],
    "deliFlag": true,
    "deliDetail": { "deliAddressTh": "1 หมู่ 1", "deliDistrictId": 124, "deliSubdistrictId": 979, "deliProvinceId": 10, "deliZipcode": "18110" },
    "discountAmt_sum": 506.24
  }
}
```

Note that this response uses the key `message`, while `/premium` and `/requestendorse` use `msg`.

- **Errors**:

| Status | Message |
|---|---|
| 400 | Bind or validator errors. `email '<x>' is invalid format`, `ownerDetails is required`, `ownerFirstnameTh is required.` (and the other owner fields), `ownerEmail '<x>' is invalid format`, `leadPaNo is invalid`, `DiscountAmt is required`, `discountAmt must greater than -1`, `taxDeductions required`, `deliFlag required`, `referalCode '<x>' is invalid.`, `coveragePrem = … do not match`, `if the promoCode is not empty, the email should not be empty either.`, `productGroupType is invalid` |
| 403 | `ownerCardId '<id>' is on the AMLO blacklist with watchlist code <code>` (watchlist code contains `FREEZE`) |
| 404 | `leadPaNo not found`, `paAgeRangeId N not found.`, `paOccupationId N not found.`, `paPackageId N not found.`, `paCoverageID N not found.`, `Premium Tariff not found.`, `promocode '<X>' not found.`, `PromoTransId not found.` |
| 500 | DB errors, `this promocode '<x>' has already been used.` (a unique code already activated), `Policy paid` (coverage change on a paid lead), and date parse errors |
| 503 | AMLO (UAM) call failed |

- **DB tables and functions**:
  - Reads: `lead_pa_premium` (`GetLeadPAPremium`), `lead_pa_participant` (`GetLeadPAOwner`, `ListLeadPAOwner`), `mas_pa_age_range`, `mas_pa_occupation`, `mas_pa_package`, `mas_pa_coverage`, `mas_pa_premium_tariff` (`GetPremiumTariffBycoverageDetails`), `mas_pa_heath_question` (`ListHeathQuestionId`, `json_agg` of active question ids, stored as `pa_question_id_array`), `sys_param` (duty %), `sec_user` (`GetUserIdByEmail`), `promo_code` and `promo_code_trans` (`GetPromoCode`, `GetPromoActiveByPromoCodeId`, `GetPromoTransNoPromoActiveByPromoCodeId`, `GetSeqIdPromoCodeTransByPromoCodeId`, `GetPromoCodeTransByPromoCodeTransId`), `payment_transaction` (`GetLeadPaymentPA`, `lead_type='pa'`), `lead_pa_coverage`, `lead_pa_beneficiary`.
  - Writes (in transaction `UpsertleadpaTx`, `database/sqlc/tx_upsertleadpa.go`): `lead_pa_premium` (`InsertLeadPAPremiumWithLeadPaNo`, `UpdateLeadPAPremium`, `UpdateLeadPAPremiumPromotransId`), `promo_code_trans` (`InsertPromoCodeTrans`, `UpdatePromoCodeTrans`), `lead_pa_participant` (`InsertLeadPAOwner` COPY FROM, `UpdateLeadPAOwner`), `lead_pa_coverage` (`InsertLeadPACoverage` COPY FROM, `UpdateLeadPACoverage`, `DeleteLeadPACoverageById` for coverages no longer sent), `lead_pa_beneficiary` (`InsertBeneficiary` COPY FROM, `UpdateBeneficiary`). Rows that already have a `policy_pa_no` are not updated.
  - Stored functions: `insurverse.fn_loyalty_referal_code(user_id)` (self-referral check via `GetReferalCodeByUser`).
- **Outbound**: `CheckAmloBlacklist` (UAM). For an existing lead it runs before the transaction, only when owner[0] is new or `ownerCardId` changed. For a new lead it runs after the transaction commits, so a new lead row can be saved and the request still returns 403 or 503.

### GET /api/v1/pa/getleadpa/:leadPaNo

- **Purpose**: fetch a PA lead (not yet paid) with coverages, owners, beneficiaries and promo info.
- **Path params**: `leadPaNo` (string, required). This is the AES-encrypted lead number. The Swagger annotation says `int`, but the code decrypts it as a string.
- **Query params**: none.
- **Success 200**: same shape as the `upsertleadpa` response (`structs.LeadPAResponse`).
- **Errors**: `400 leadPaNo required` / `400 leadPaNo is invalid` (decrypt failed). `404 leadPaNo not found.` (missing, or payment_status = SUCCESS). `404 PromoTransId not found.` `500` on DB or encrypt errors.
- **DB (read)**: `lead_pa_premium` (`GetLeadPAPremium`, filter `payment_status IS NULL OR UPPER(payment_status) != 'SUCCESS'`), `lead_pa_coverage` (`ListLeadPACoverage`), `promo_code_trans` left-joined to `promo_code` (`GetPromoCodeTransByPromoCodeTransId`), `lead_pa_participant` (`ListLeadPAOwner`), `lead_pa_beneficiary` (`ListBeneficiary`).
- **Outbound**: none.

### POST /api/v1/pa/requestendorse

- **Purpose**: record a post-issuance customer request for a PA policy in `log_request_pa` and act on it:
  - `cancel` / `endorse`: emails the support team (`EMAIL_SUPPORT`) through the notification service. The email includes a request reference (CRC32 hash of the log id).
  - `tax_dd`: allowed only once per policy. It sets `policy_pa_premium.tax_deductions = true`, triggers tax-document generation, sends the deduction to IIA, and sets the log `request_status` to `approve`.
- **Request body** (`dto.RequestEndorseDTO`):

```json
{
  "policyPaNo": "PA-0000-X-000000",
  "requestType": "endorse",
  "subject": "ขอแก้ไข",
  "body": "รายละเอียดคำขอ"
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `policyPaNo` | string | yes | `required`. Must exist (joined `policy_pa_premium` + `lead_pa_participant`), else 404 |
| `requestType` | string | yes | `required,oneof=cancel endorse tax_dd` |
| `subject` | string / null | no | Overrides the default Thai email subject |
| `body` | string | yes | `required`. Reason or details, included in the email |

- **Success 200**:

```json
{ "status": true, "msg": "success", "data": { "id": "00000000-0000-0000-0000-000000000000" } }
```

`id` is the UUID of the `log_request_pa` row. For `tax_dd`, the IIA result message is overwritten by `"success"` before the response is sent, so IIA failures are not visible to the caller.

- **Errors**: `400` for validation or `requestType is invalid`. `404 policyPaNo <no> not found.` `404 policyPaNo not found` (tax_dd IIA data lookup). `403 plicyPaNo '<no>' unable to request Tax deductions` (flag already true; the typo is in the source). `500` on DB errors. `503` if the SendEmail call fails.
- **DB tables and functions**:
  - `policy_pa_premium` + `lead_pa_participant` + `subdistrict` / `district` / `province` (`GetEmailParticipant`, read)
  - `log_request_pa` (`InsertLogRequestPa` write, `UpdateRequestStatusLogRequestPa` write for tax_dd)
  - `insurverse.crc32(text)` function (`GetRequestEndorseRequestRef`)
  - `policy_pa_premium.tax_deductions` (`GetFlagTaxDeductions` read, `UpdateFlagTaxDeductions` write)
  - `policy_pa_premium` + `lead_pa_participant` (`GetIIATaxDD` read)
- **Outbound**: `SendEmail` (cancel, endorse). `DocTaxDeduction` and `IIATaxDeduction` (tax_dd; errors are only logged).

## DB Usage

All objects are in schema `insurverse`.

| Table / function | Read / Write | Endpoints |
|---|---|---|
| `mas_pa_age_range` | R | premium, upsertleadpa |
| `mas_pa_occupation` | R | premium, upsertleadpa |
| `mas_pa_package` | R | premium, upsertleadpa |
| `mas_pa_coverage` | R | premium, upsertleadpa |
| `mas_pa_premium_tariff` | R | premium, upsertleadpa |
| `mas_pa_heath_question` | R | premium, upsertleadpa |
| `mas_ta_description` | R | premium |
| `sys_param` (duty_per) | R | premium, upsertleadpa |
| `lead_pa_premium` | R/W | upsertleadpa, getleadpa |
| `lead_pa_participant` | R/W | upsertleadpa, getleadpa, requestendorse (R) |
| `lead_pa_coverage` | R/W (incl. DELETE) | upsertleadpa, getleadpa |
| `lead_pa_beneficiary` | R/W | upsertleadpa, getleadpa |
| `promo_code` | R | upsertleadpa, getleadpa |
| `promo_code_trans` | R/W | upsertleadpa (R/W), getleadpa (R) |
| `payment_transaction` | R | upsertleadpa |
| `sec_user` | R | upsertleadpa |
| `policy_pa_premium` | R/W (`tax_deductions`) | requestendorse |
| `log_request_pa` | W | requestendorse |
| `subdistrict`, `district`, `province` | R | requestendorse |
| `fn_loyalty_referal_code(text)` | function (R) | upsertleadpa |
| `crc32(text)` | function (R) | requestendorse |

No `CALL` procedures and no triggers are referenced in code. Triggers on these tables, if any, are not visible from this repo (⚠️ unverified).

## Notes / ⚠️ unverified items

- ⚠️ There is no auth middleware in the service. Protection is presumably at the gateway or ingress (not verifiable from the repo).
- ⚠️ The sqlc queries `GetUserByReferalCode`, `GetNoPromoActiveByPromoCodeId`, `UpdatePromoCodeTransOnlyDate`, `GetTaDesciption`, `GetHeathQuestionById` and `GetPremiumTariffById` exist but are not called from the handler paths traced here.
- For a new lead, the AMLO check runs after the DB transaction commits. A blacklisted or failed AMLO check returns 403 or 503, but the lead rows are already persisted.
- `this promocode '<x>' has already been used.` and `Policy paid` surface as HTTP 500, not 4xx.
- For tax_dd, `response.Msg` is set from the IIA result and then overwritten with `"success"`. The tax flag is set to true before the IIA call, and IIA or document failures do not roll it back.
- The DB port is hardcoded to 5432 in `main.go`, while `DATABASE_PORT` is required but only used by the sqlc CLI.
- The `/getleadpa/{leadPaNo}` Swagger param type is `int`, but it is actually an encrypted string.
- The repo contains a nested `go-echo-policy-service` directory, which was not part of this spec.
