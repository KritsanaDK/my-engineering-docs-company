# go-echo-home-service — API Spec

## Overview

- **Purpose:** Home and condo insurance ("ประกันบ้านและคอนโด") backend. It serves the master data and premium tariffs, creates and updates home leads (premium calculation and server-side re-validation, promo code, referral code, AMLO blacklist check), reads a lead back, and handles cancel and endorse requests for issued home policies (it logs the request and emails support).
- **Module name:** `home-service` (go.mod)
- **Framework:** Echo v4 (`github.com/labstack/echo/v4`), `go-playground/validator/v10`, pgx v5 (`pgxpool`), sqlc-generated queries (`database/sqlc`), and swaggo (`echo-swagger`).
- **Base path:** `/api/v1/home` (plus the root route `/healthcheck`)
- **Port:** `HTTP_PORT` (defaults to `3000` in `main.go:119-122`). The helm charts expose containerPort `8080`.
- **DB schema:** `insurverse` (PostgreSQL)
- **Env vars that must exist** (`config/config.go` panics if one is missing): `ENV`, `DATABASE_HOST`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`, `DATABASE_PORT`, `Base_Url`, `HTTP_PORT`, `Backend_Uam`, `EMAIL_SUPPORT`, `ENC_KEY`, `IV`.
  - `Backend_Notification` is optional. It is read in `util/api/notification.go`.
  - When `ENV` is `LOCAL` or empty, the service loads a `.env` file.
  - `ENC_KEY` and `IV` are the AES-256 key and IV that encrypt and decrypt the external `leadHomeNo` token (`util/util.go:137-160`).
  - `EMAIL_SUPPORT` is a comma-separated list of support mailbox recipients.
  - The helm files also declare many env vars this code never reads, such as `Backend_Auth`, `Backend_Core`, `SF_*` and `YIP_EKCY`.
- **Outbound HTTP calls** (`util/api`, plain `net/http`, POST JSON, no auth header):

  | Call | URL construction | Used by |
  |---|---|---|
  | UAM `CheckAmloBlacklist` | `${Backend_Uam}check_amlo_blacklist`, or `${Base_Url}api/v1/uam/check_amlo_blacklist` when `Backend_Uam` is empty. The body is `{lead_no, owner_citizen_id, owner_firstname, owner_lastname, check_type:"home"}`. Timeout 2 min. | `POST /upsertleadhome` |
  | Notification `SendEmail` | `${Backend_Notification}email`, or `${Base_Url}api/v1/notification/email` when `Backend_Notification` is empty. The body is `{content, email[], sender, subject, attach[]}`. Timeout 2 min. | `POST /requestendorse` |

## Auth & Middleware

- **No authentication or authorization middleware.** The code never reads a JWT, API key or `Authorization` header, so every route is public at the service level. Any protection must come from the gateway or ingress (⚠️ unverified, not visible in this repo).
- `middleware.CORS()` uses the default settings, which allow all origins.
- `middleware.RequestLoggerWithConfig` writes JSON slog output to stdout. It skips `/healthcheck` and any path that contains `/api/v1/home/docs`.
- Custom `echo.Validator` (go-playground). A validation failure returns `400` with the validator error text.
- `X-Request-ID` response header:
  - `GET /getleadhome` and `POST /upsertleadhome` (when `leadHomeNo` is given) set it to the decrypted numeric lead number.
  - `POST /requestendorse` sets it to `policyHomeNo`.
- **Error format:** handlers return `echo.NewHTTPError(status, msg)`, which Echo renders as `{"message": "<msg>"}`. This matches `util.ErrorResponse`.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | `main.go:58` (inline) | Liveness check. Returns the plain text `is already`. |
| GET | `/api/v1/home/docs/*` | None | `router/router.go:14` (`echoSwagger.WrapHandler`) | Swagger UI and doc.json |
| GET | `/api/v1/home/premium` | None | `controllers/home_service.go:37` `GetPremiumHome` | All home master data, tariffs, and duty and VAT percentages |
| POST | `/api/v1/home/upsertleadhome` | None | `controllers/home_service.go:135` `UpsertleadHome` | Create or update a home lead after premium validation, promo and AMLO checks |
| GET | `/api/v1/home/getleadhome/:leadHomeNo` | None | `controllers/home_service.go:536` `GetLeadHome` | Get a lead by its encrypted lead number |
| POST | `/api/v1/home/requestendorse` | None | `controllers/home_service.go:575` `RequestEndorse` | Log a cancel or endorse request for a home policy and email support |

Routes are registered in `router/router.go:12-21`. `/healthcheck` is registered in `main.go:58`.

## Endpoints

### GET /healthcheck
- **Purpose:** liveness probe.
- **Response 200:** the plain text `is already`.
- **DB / outbound:** none.

### GET /api/v1/home/docs/*
- **Purpose:** serves the swaggo-generated Swagger UI from the `docs/` package (title "Microservice Premium Home", version 1.0.1).
- **DB / outbound:** none.

### GET /api/v1/home/premium
- **Purpose:** returns all master data that the home premium calculator frontend needs.
- **Params:** none.
- **Success 200** (`structs.GetPremiumHomeResponse`):
```json
{
  "status": true,
  "msg": "success",
  "data": {
    "homeBuildingTypeDetails": [{"homeBuildingTypeId": 1, "buildingNameTh": "บ้านเดี่ยว", "buildingNameEn": "Detached house", "buildingDescTh": "...", "buildingDescEn": "...", "flagOther": false}],
    "homeCoverageGroupDetails": [{"homeCoverageGroupId": 1, "coverageGroupNameTh": "...", "coverageGroupNameEn": "...", "coverageGroupDescTh": "...", "coverageGroupDescEn": "...", "flagAddon": false}],
    "homeCoverageDetails": [{"homeCoverageId": 1, "coverageNameTh": "...", "coverageNameEn": "...", "coverageDescTh": "...", "coverageDescEn": "...", "flagCoverMain": true, "homeCoverageGroupId": 1, "siMergeGroup": "..."}],
    "homeMaterialTypeDetails": [{"homeMaterialTypeId": 1, "materialNameTh": "...", "materialNameEn": "...", "materialDescTh": "...", "materialDescEn": "...", "flagOther": false, "flagDefault": true}],
    "homeResidentTypeDetails": [{"homeResidentTypeId": 1, "residentNameTh": "...", "residentNameEn": "...", "residentDescTh": "...", "residentDescEn": "...", "flagOther": false, "flagDefault": true}],
    "homePremiumTariffDetails": [{"homePremiumTariffId": 1, "homeBuildingTypeId": 1, "homeCoverageId": 1, "coverLimitMin": 0, "coverLimitMax": 0, "coverLimitSplit": 0, "flagCoverSiFactor": false, "coverSiFactor": 0, "coverSiLimitMin": 0, "coverSiLimitMax": 0, "siSecondFlag": false, "siFirstLimit": 0, "siFirstFactor": 0, "siSecondLimit": 0, "siSecondFactor": 0}],
    "beneTypeDetails": [{"beneTypeId": "1", "beneTypeNameTh": "...", "beneTypeNameEn": "..."}],
    "beneRelationDetails": [{"beneRelationId": "1", "beneRelationNameTh": "...", "beneRelationNameEn": "..."}],
    "provinceDetails": [{"provinceid": 10, "prname": "สระบุรี", "prnameen": "Saraburi", "flag_cover_flood": true}],
    "dutyPercent": 0.4,
    "vatPercent": 7
  }
}
```
- **Errors:** `500` with the DB error message if any query fails.
- **DB:**
  - Master tables: `mas_home_building_type` (is_active), `mas_home_coverage_group`, `mas_home_coverage`, `mas_home_material_type` (is_active), `mas_home_resident_type`, `mas_home_premium_tariff`, `mas_ta_description` (bene type and bene relation lists).
  - Provinces: `mas_home_province` LEFT JOIN `province`.
  - Rates: `sys_param` (`purchase/duty/duty_per` and `purchase/vat/vat_per`).
- **Outbound:** none.

### POST /api/v1/home/upsertleadhome
- **Purpose:** creates a new home lead, or updates an existing one when `data.leadHomeNo` is given. The frontend sends its own premium figures and the server recalculates each one from `mas_home_premium_tariff`. Every mismatch returns `400 "<field> X should be Y"`.
  1. Checks the referral code. A user cannot use their own referral code.
  2. Applies the promo code (the product group is always `home`).
  3. Recomputes duty, VAT and total, then writes everything in one DB transaction.
  4. Runs the AMLO blacklist check (UAM service). The check always runs for a new lead. For an existing lead it runs only when the stored participant is missing or `ownerCardId` changed.
- **Request body** (`dto.UpsertleadHomeDTO`):
```json
{
  "data": {
    "leadHomeNo": "<encrypted-lead-token or omit for new>",
    "homeBuildingTypeId": 1,
    "homeBuildingProvinceId": 10,
    "homeMaterialTypeId": 1,
    "coverageMainDetail": {
      "coverMainSi": 4000000.0, "flagFurniture": true, "coverFurnitureSi": 500000.0,
      "coverMainFurnitureSi": 4500000.0, "coverMainFurniturePrem": 2174.0,
      "coverLossAndDamageSi": 225000.0, "coverLossAndDamagePrem": 788.0,
      "flagCoverRentalCost": true, "coverGlassSi": 225000.0, "coverGlassPrem": 118.0,
      "coverMainTotalAmt": 3080.0
    },
    "coverageAddonDetail": {
      "flagCoverNaturalDisExFlood": true, "coverNaturalDisExFloodSi": 300000.0, "coverNaturalDisExFloodPrem": 829.0,
      "flagCoverFloodDis": true, "coverFloodDisSi": 300000.0, "coverFloodDisPrem": 427.0,
      "flagCoverTheft": true, "coverTheftSi": 450000.0, "coverTheftPrem": 1119.0,
      "flagCoverThirdParties": true, "coverThirdPartiesSi": 1000000.0, "coverThirdPartiesPrem": 361.0,
      "coverAddonTotalAmt": 2736.0
    },
    "promoCode": "PROMOCODE01",
    "productGroupType": "home",
    "productSubType": "",
    "discountPer": 0,
    "discountAmt": 0,
    "affiliateSource": "",
    "affiliateCode": "",
    "referalSource": "",
    "referalCode": "",
    "premAmt": 5816.0,
    "dutyAmt": 24,
    "vatPer": 7,
    "vatAmt": 408.8,
    "totalAmt": 6248.8,
    "buildingAddressDetail": {
      "buildingAddressTh": "1 หมู่ 1", "buildingDistrictId": 124, "buildingSubdistrictId": 979,
      "buildingProvinceId": 10, "buildingCountryId": 1, "buildingZipcode": "18110"
    },
    "homeResidentTypeId": 1,
    "policyStartdate": "2026-10-01",
    "policyEnddate": "2027-10-01",
    "ownerDetails": {
      "ownerTitleTh": "นาย", "ownerFirstnameTh": "กฤษณะ", "ownerLastnameTh": "วัฒนายนนต์",
      "ownerCardType": "I", "ownerCardId": "1111111111119",
      "ownerAddressTh": "1 หมู่ 1", "ownerDistrictId": 124, "ownerSubdistrictId": 979,
      "ownerProvinceId": 10, "ownerCountryId": 1, "ownerZipcode": "18110",
      "ownerPhone": "0628696603", "ownerEmail": "user@example.com", "ownerBirthdate": "1990-01-01"
    },
    "beneDetails": {"beneType": 1, "beneTitleTh": "", "beneFirstnameTh": "", "beneLastnameTh": ""},
    "deliFlag": false,
    "deliDetail": {
      "deliAddressTh": "1 หมู่ 1", "deliDistrictId": 124, "deliSubdistrictId": 979,
      "deliProvinceId": 10, "deliZipcode": "18110"
    }
  }
}
```

**Fields** (all under `data`. `pgtype.*` fields are nullable. Numeric fields are JSON numbers.)

| Field | Type | Required | Validation / notes |
|---|---|---|---|
| leadHomeNo | string (nullable) | No | AES-encrypted lead number. If present, it must decrypt to a value > 0 (else `400 leadHomeNo is invalid`), and the lead must exist and must not be paid (else `404 leadHomeNo not found`). |
| homeBuildingTypeId | int16 | Yes (effectively) | Must exist and be active in `mas_home_building_type` (else `404`). |
| homeBuildingProvinceId | int32 | Yes (effectively) | Must exist and be active in `mas_home_province` (else `404`). |
| homeMaterialTypeId | int (nullable) | Effectively | Must exist and be active in `mas_home_material_type` (else `404`). |
| coverageMainDetail.* | numeric / bool | Yes | Each SI and premium is recomputed from the tariff for coverage IDs 1 or 2 (depending on `flagFurniture`), 3 and 5. A mismatch returns `400`. |
| coverageAddonDetail.* | numeric / bool | Conditional | Recomputed per flag for coverage IDs 10 (natural disaster), 6, 7, 8 and 9. `coverAddonTotalAmt` must match the sum. |
| promoCode | string (nullable) | No | If set, `ownerEmail` is required and `productGroupType` must be `home` (else `400`). If the code is not found, the handler returns `404 promocode '<x>' not found.` |
| productGroupType / productSubType | string (nullable) | No | Used in the promo lookup. |
| discountPer | numeric | No | Overwritten by the server. |
| discountAmt | numeric | **Yes** | Must be present (`400 DiscountAmt is required`) and ≥ 0. The server overwrites it. |
| affiliateSource / affiliateCode / referalSource | string (nullable) | No | Stored as sent. |
| referalCode | string (nullable) | No | If `ownerEmail` belongs to an existing `sec_user`, the code must not be that user's own code from `fn_loyalty_referal_code` (else `400`). |
| premAmt / dutyAmt / vatAmt / totalAmt | numeric | No | The server recomputes and overwrites them. `totalAmt` is sent to the promo min-amount check. |
| vatPer | numeric | Yes (effectively) | Must equal `sys_param` `vat_per` to 2 decimal places (else `400 vatPer X should be Y`). |
| buildingAddressDetail.* | text / int (nullable) | No | Stored. |
| homeResidentTypeId | int16 (nullable) | No | Stored. It is not validated against the master table. |
| policyStartdate / policyEnddate | string `YYYY-MM-DD` | Yes (effectively) | Parsed inside the transaction. A parse failure returns `500`. |
| ownerDetails.ownerFirstnameTh | string | **Yes** | `validate:"required"` |
| ownerDetails.ownerLastnameTh | string | **Yes** | `validate:"required"` |
| ownerDetails.ownerPhone | string | **Yes** | `validate:"required"` |
| ownerDetails.ownerEmail | string (nullable) | No | If non-empty, it must match the email regex (`util.ValidateEmail`). |
| ownerDetails.ownerCardId | string (nullable) | No | Sent to the AMLO check. |
| ownerDetails.ownerBirthdate | string `YYYY-MM-DD` (nullable pointer) | No | Parsed only when non-empty. |
| ownerDetails (other fields) | text / int (nullable) | No | Stored. |
| beneDetails.* | int16 / text (nullable) | No | Stored. |
| deliFlag | bool (nullable) | **Yes** | `400 deliFlag required` if null or missing. |
| deliDetail.* | text / int (nullable) | No | Stored. |

- **Success 200** (`structs.GetLeadHomeResponse`, the same shape as `GET /getleadhome`):
```json
{
  "status": true,
  "msg": "success",
  "data": {
    "leadHomeNo": "<encrypted-lead-token>",
    "homeBuildingTypeId": 1, "homeBuildingProvinceId": 10, "homeMaterialTypeId": 1,
    "coverageMainDetail": { "coverMainSi": 4000000, "flagFurniture": true, "...": "..." },
    "coverageAddonDetail": { "flagCoverNaturalDisExFlood": true, "...": "..." },
    "promoCode": "PROMOCODE01", "productGroupType": "home", "productSubType": null,
    "discountPer": 0, "discountAmt": 0,
    "affiliateSource": null, "affiliateCode": null, "referalSource": null, "referalCode": null,
    "premAmt": 5816, "dutyAmt": 24, "vatPer": 7, "vatAmt": 408.8, "totalAmt": 6248.8,
    "buildingAddressDetail": { "buildingAddressTh": "1 หมู่ 1", "buildingDistrictId": 124, "buildingSubdistrictId": 979, "buildingProvinceId": 10, "buildingCountryId": 1, "buildingZipcode": "18110" },
    "homeResidentTypeId": 1,
    "policyStartdate": "2026-10-01", "policyEnddate": "2027-10-01",
    "ownerDetails": { "ownerTitleTh": "นาย", "ownerFirstnameTh": "กฤษณะ", "ownerLastnameTh": "วัฒนายนนต์", "ownerCardType": "I", "ownerCardId": "1111111111119", "ownerPhone": "0628696603", "ownerEmail": "user@example.com", "ownerBirthdate": "1990-01-01", "...": "..." },
    "beneDetails": { "beneType": 1, "beneTitleTh": null, "beneFirstnameTh": null, "beneLastnameTh": null },
    "deliFlag": false,
    "deliDetail": { "deliAddressTh": "1 หมู่ 1", "deliDistrictId": 124, "deliSubdistrictId": 979, "deliProvinceId": 10, "deliZipcode": "18110" },
    "discountAmt_sum": 0
  }
}
```
- **Errors:**

  | Status | Message (examples) |
  |---|---|
  | 400 | Bind or validator error text. `DiscountAmt is required`, `discountAmt must greater than -1`, `deliFlag required`, `ownerFirstnameTh is required.`, `ownerLastnameTh is required.`, `ownerPhone is required.`, `ownerEmail '<x>' is invalid format`, `leadHomeNo is invalid`, `referalCode '<x>' is invalid.`, `if the promoCode is not empty, the ownerEmail should not be empty either.`, `productGroupType is invalid`, `vatPer X should be Y`, `<coverField> X should be Y` (coverMainFurnitureSi/Prem, coverLossAndDamageSi/Prem, coverGlassSi/Prem, coverMainTotalAmt, coverNaturalDisExFloodSi/Prem, coverFloodDisSi/Prem, coverTheftSi/Prem, coverThirdPartiesSi/Prem, coverAddonTotalAmt) |
  | 403 | `ownerCardId '<id>' is on the AMLO blacklist with watchlist code <code>` (when the UAM `watchlist_code` contains `FREEZE`) |
  | 404 | `leadHomeNo not found`, `homeBuildingTypeId N not found.`, `homeMaterialTypeId N not found.`, `homeBuildingProvinceId N not found.`, `promocode '<x>' not found.`, `Premium Tariff not found.` |
  | 500 | DB errors, `this promocode '<x>' has already been used.`, `Policy paid`, date parse errors, and a lead missing on the read-back (see Notes) |
  | 503 | UAM AMLO call failure (network error or non-200 response without a `title`) |

- **DB:**
  - **Reads:**
    - Lead and payment: `lead_home_premium` (`GetLeadHomePremium`, which excludes rows with `payment_status = SUCCESS`), `lead_home_participant`, `payment_transaction` (`lead_type='home'`).
    - Master data: `mas_home_building_type`, `mas_home_material_type`, `mas_home_province`, `mas_home_premium_tariff` (by building type and coverage ID).
    - Users and rates: `sec_user` (by email), `sys_param` (duty, VAT).
    - Promo: `promo_code` + `promo_code_trans` (`GetPromoCode` with subqueries, `GetPromoActiveByPromoCodeId`, `GetPromoTransNoPromoActiveByPromoCodeId`, `GetSeqIdPromoCodeTransByPromoCodeId`).
  - **Writes** (in one transaction, `database/sqlc/tx_upsertleadhome.go` `UpsertleadHomeTx`):
    - `lead_home_premium`: INSERT, or UPDATE plus `promo_trans_id` update.
    - `promo_code_trans`: INSERT for a `mass` code (next `seq_id`), or UPDATE.
    - `lead_home_coverage` and `lead_home_participant`: INSERT, or UPDATE only while `policy_home_no` IS NULL.
    - `lead_home_premium_tariff`: UPDATE per tariff, or bulk insert with `COPY FROM`.
  - **Stored functions:** `insurverse.fn_loyalty_referal_code(user_id)` checks the referral code.
  - **Update guard:** updating a lead whose premium changed returns error `Policy paid` if a `payment_transaction` row exists.
- **Outbound:** UAM `check_amlo_blacklist` (0 or 1 call per request).

### GET /api/v1/home/getleadhome/:leadHomeNo
- **Purpose:** returns the full lead (premium, coverage, participant, promo and VAT) for an encrypted lead number.
- **Path params:**

  | Name | Type | Required | Notes |
  |---|---|---|---|
  | leadHomeNo | string | Yes | AES-256 encrypted lead number (URL-safe token). A decrypt failure returns `400 leadHomeNo is invalid`. |

- **Success 200:** the same `structs.GetLeadHomeResponse` as `POST /upsertleadhome` (see above).
  - `vatPer` comes from `sys_param`.
  - `promoCode`, `productGroupType` and `productSubType` are filled only when `lead_home_premium.promo_trans_id` is set.
- **Errors:**

  | Status | Message |
  |---|---|
  | 400 | `leadHomeNo is invalid` |
  | 404 | `PromoTransId not found.` |
  | 500 | The lead is missing or already paid (`leadHomeNo N not found.`, see Notes) and other DB errors |

- **DB (read):**
  - Lead data: `lead_home_premium` (excludes `payment_status = SUCCESS`), `lead_home_coverage`, `lead_home_participant`.
  - Promo: `promo_code_trans` LEFT JOIN `promo_code`.
  - Rates: `sys_param` (VAT).
- **Outbound:** none.

### POST /api/v1/home/requestendorse
- **Purpose:** a customer asks to cancel or endorse (edit) an issued home policy.
  1. The service looks up the policy owner and inserts a row into `log_request_home`.
  2. It builds a request reference, `UPPER(crc32(<log id>))`.
  3. It emails the `EMAIL_SUPPORT` recipients through the notification service, with a Thai subject and an HTML body.
- **Request body** (`dto.RequestEndorseDTO`):
```json
{
  "policyHomeNo": "HI-0000-L-000000",
  "requestType": "endorse",
  "subject": "ขอแก้ไข",
  "body": "รายละเอียดการแก้ไขข้อมูล"
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| policyHomeNo | string | Yes | `required`. Must exist in `policy_home_premium` (else `404`). |
| requestType | string | Yes | `required,oneof=cancel endorse` |
| subject | string (nullable) | No | Overrides the default email subject. |
| body | string | Yes | `required`. Becomes the cancel reason or the endorsement details in the email. |

- **Success 200** (`structs.RequestEndorseResponse`):
```json
{ "status": true, "msg": "success", "data": { "id": "00000000-0000-0000-0000-000000000000" } }
```
- **Errors:**

  | Status | Message |
  |---|---|
  | 400 | Bind or validator error. `requestType is invalid` |
  | 404 | `policyHomeNo <no> not found.` |
  | 500 | DB errors |
  | 503 | Notification email call failed |

  The log row has already been inserted when a 503 is returned.
- **DB:**
  - Read: `policy_home_premium` INNER JOIN `lead_home_participant`, plus the `subdistrict`, `district` and `province` lookups (`GetEmailParticipant`).
  - Write: INSERT `log_request_home (policy_home_no, request_type, subject, body) RETURNING id`.
  - Function: `insurverse.crc32(text)`.
- **Outbound:** Notification `email` (sender `home-service`).

## DB Usage

All objects are in the `insurverse` schema.

| Table / function | Read/Write | Endpoints |
|---|---|---|
| mas_home_building_type | R | premium, upsertleadhome |
| mas_home_coverage_group | R | premium |
| mas_home_coverage | R | premium |
| mas_home_material_type | R | premium, upsertleadhome |
| mas_home_resident_type | R | premium |
| mas_home_premium_tariff | R | premium, upsertleadhome |
| mas_ta_description | R | premium |
| mas_home_province (+ province) | R | premium, upsertleadhome |
| sys_param | R | premium, upsertleadhome, getleadhome |
| lead_home_premium | R/W | upsertleadhome (W), getleadhome (R) |
| lead_home_coverage | R/W | upsertleadhome (W), getleadhome (R) |
| lead_home_participant | R/W | upsertleadhome (W), getleadhome (R), requestendorse (R) |
| lead_home_premium_tariff | R/W (UPDATE and COPY FROM) | upsertleadhome |
| payment_transaction | R | upsertleadhome |
| promo_code | R | upsertleadhome, getleadhome |
| promo_code_trans | R/W | upsertleadhome (W), getleadhome (R) |
| sec_user | R | upsertleadhome |
| policy_home_premium | R | requestendorse |
| subdistrict, district, province | R | requestendorse |
| log_request_home | W (INSERT) | requestendorse |
| fn `insurverse.fn_loyalty_referal_code(text)` | R (function) | upsertleadhome |
| fn `insurverse.crc32(text)` | R (function) | requestendorse |

## Notes / ⚠️ unverified items

- **No auth on any route.** Any caller that can reach the service can create or modify leads and send support emails. Check the gateway-level protection (⚠️ unverified).
- **Error-mapping mismatches** (the code compares exact strings):
  - `getLeadHomeResponse` returns `leadHomeNo %d not found.` (with the number), but the handlers compare against `leadHomeNo not found.`. A missing or paid lead on `GET /getleadhome` therefore returns **500**, not 404.
  - A reused unique promo (`this promocode ... has already been used.`) returns **500**.
  - `Policy paid` returns **500**.
  - I did not find any code that produces `Premium Tariff not found.` (⚠️ likely dead mapping).
- **Lead reads filter paid leads.** `GetLeadHomePremium` excludes rows with `payment_status = 'SUCCESS'`, so paid leads are not readable through `GET /getleadhome`.
- **Empty coverage or participant rows are silent.** In `getLeadHomeResponse`, a missing coverage or participant row (`ErrNoRows`) returns early with `err = nil` and `status = false`. The client then gets a 200 with `status:false` and only part of the data.
- **Hard-coded values:**
  - Coverage ID 10 is the natural-disaster coverage, with a fixed SI of 20000 (`coverMainNaturalSi_FIX`). Its premium is added to `coverMainTotalAmt` (a "CR4" comment in the code).
  - The promo product group is forced to `home`.
- **Validator structs:** the `validate` tags on `structs.OwnerDetails` (response struct) are never run for requests. Request validation comes only from `dto.OwnerDetails`.
- **`homeResidentTypeId`** is not validated against `mas_home_resident_type`. `GetHomeResidentTypeById` exists but is unused.
- **AMLO check order:** for a new lead, the AMLO check runs after the DB transaction commits. If AMLO returns FREEZE (403) or is unavailable (503), the lead row has already been written.
- **Endorse logging:** `UpdateRequestStatusLogRequestHome` exists in sqlc but no endpoint calls it.
- **Untested in this repo:** exact numeric formats of the response JSON (how `pgtype.Numeric` renders) and the `mas_ta_description` filter values for the bene lists (⚠️ unverified).
