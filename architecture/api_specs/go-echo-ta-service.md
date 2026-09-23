# go-echo-ta-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-ta-service` (Go module `ta-service`). Written from source code only; the service was not run and no database was queried.

## Overview

| Item | Value |
|---|---|
| Purpose | Travel Accident (TA) insurance microservice. It quotes TA package premiums, creates or updates a TA lead (`lead_ta_premium` with participants and packages), applies promo codes, checks referral codes, and checks each insured person against the AMLO blacklist. It also returns a stored lead by its encrypted lead number. |
| Framework | Echo v4 (`github.com/labstack/echo/v4`), sqlc-generated queries on pgx/v5 (`pgxpool`, MaxConns 10), go-playground/validator v10, swaggo (`echo-swagger`) |
| Base path | `/api/v1/ta` (`router/router.go:13`). `/healthcheck` sits at the root. |
| Port | `HTTP_PORT` env (default `3000`, `main.go`). Helm sets the container/service port to 8080. |
| DB | PostgreSQL, schema `insurverse`. DSN built from env with `port=5432` hard-coded in `main.go`. `DATABASE_PORT` is used only by `sqlc.yaml` and helm. |
| Swagger title | "Microservice Premium TA" v1.0.1 |

### Env var names
- **Required at startup** (`config/config.go` `envKeys`; startup panics if any is missing or empty): `ENV`, `DATABASE_HOST`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`, `Base_Url`, `Backend_Doc`, `Backend_Auth`, `Backend_Core`, `Backend_File`, `Backend_Notification`, `Backend_Purchase`, `Backend_Consent`, `Backend_Premium`, `Backend_Saleforce`, `Backend_Uam`, `Backend_Analytics`, `Url_Fontend`, `ENC_KEY`, `IV`
- **Optional / read elsewhere:** `HTTP_PORT`, `Url_IIA`, `IIA_Username`, `IIA_Password` (read only by the unused IIA client)
- If `ENV` is `LOCAL` or empty, the service loads `.env` and panics when the file is missing.
- Helm (`helm/helm-uat-isv.yaml`) also injects names this code never reads: `DATABASE_PORT`, `SF_*`, `YIP_EKCY`, `Token_EKYC_*`, `URL_YIP_*`, `URL_CMI_Realtime_Policy`, `EMAIL_SUPPORT`, and a `google-cloud-key` mount.

### External / third-party calls
| Call | URL built from | Used by |
|---|---|---|
| UAM AMLO blacklist check `POST` (`util/api/uam.go`) | `Backend_Uam` + `check_amlo_blacklist`, or, if `Backend_Uam` is empty, `Base_Url` + `api/v1/uam/check_amlo_blacklist` | `POST /upsertleadta` |
| Notification `SendEmail` (`util/api/notification.go`) | `Backend_Notification` / `Base_Url` | **Not called by any route** |
| Doc `DocTaxDeduction` (`util/api/doc.go`) | `Backend_Doc` / `Base_Url` | **Not called by any route** |
| IIA `IIATaxDeduction` (`util/api/third_party_iia.go`, Basic auth) | `Url_IIA` + `ServiceTaxDeduction/api/AddDeduction`, credentials `IIA_Username` / `IIA_Password` | **Not called by any route** |

AMLO request body: `{"lead_no","owner_citizen_id","owner_firstname","owner_lastname","check_type":"ta"}`. The HTTP client timeout is 2 minutes. The response field `result.watchlist_code` is checked for the substring `FREEZE`.

## Auth & Middleware

- **No authentication or authorization on any route.** No JWT, API key, or basic-auth middleware is registered, so every endpoint is public at the service level. Any auth must come from the gateway or ingress (⚠️ unverified, not in this repo).
- Middleware, in registration order (`main.go`):
  1. `ErrorHandler` (custom, `main.go:92`). Turns `*echo.HTTPError` into `{"status":false,"message":"<msg>"}` with the error's status code. Any other error becomes `500 {"status":false,"message":"Internal Server Error"}`. It asserts `e.Message.(string)`, so a non-string HTTPError message would panic.
  2. `middleware.CORS()` with default config (all origins allowed).
  3. `middleware.RequestLoggerWithConfig`: JSON slog logs to stdout. It skips `/healthcheck` and any path containing `/api/v1/pa/docs`. That is a leftover from the PA service, so `/api/v1/ta/docs` **is** logged.
- **No `Recover` middleware** is registered, even though a comment in `database/sqlc/exec_tx.go` mentions one.
- Custom validator: `validName` allows letters, `.`, `-`, `'`, and space. `date` must be `YYYY-MM-DD`. pgtype `Text/Numeric/Int4` values are unwrapped before validation.
- Handlers set the `X-Request-Id` response header to the **decrypted** numeric lead number, for logging.
- Lead numbers go over the wire AES-256 encrypted (`util.LeadNoEncrypt/Decrypt` with `ENC_KEY` / `IV`).

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | `main.go:141` (inline) | Liveness/readiness probe, returns plain text `is already` |
| GET | `/api/v1/ta/docs/*` | None | `router/router.go:14` (`echoSwagger.WrapHandler`) | Swagger UI and JSON |
| POST | `/api/v1/ta/premium` | None | `controllers/ta_service.go:39` (`GetPremiumTA`) | Quote premiums for all active packages of a travel type |
| POST | `/api/v1/ta/upsertleadta` | None | `controllers/ta_service.go:167` (`UpsertPremiumTA`) | Create or update a TA lead with participants, packages, and promo/referral, plus the AMLO check |
| GET | `/api/v1/ta/getleadta/:leadTaNo` | None | `controllers/ta_service.go:707` (`GetLeadTA`) | Get an unpaid TA lead by its encrypted lead number |

Total: **5 routes** (3 business routes, plus healthcheck and swagger).

## Endpoints

### GET /healthcheck
- Purpose: k8s liveness/readiness probe (helm `livenessProbe` / `readinessProbe` path `/healthcheck`).
- Response `200`, `text/plain`: `is already`
- DB / outbound: none.

### GET /api/v1/ta/docs/*
- Purpose: Swagger UI from `docs/docs.go` (swag generated; `Host` and `BasePath` are empty).
- Note: the swagger annotation on `GetLeadTA` declares `@Router /api/v1/pa/getleadta/{leadTaNo}`. That is **wrong**: the real route is `/api/v1/ta/getleadta/{leadTaNo}`.

### POST /api/v1/ta/premium
Purpose: for a travel type and a date range, return every active package of that type (main and add-on) with its premium, duty, VAT, and total for the computed day count. Each package also carries its coverage list, the requested countries, and the travel-type master record.

**Request body**
```json
{
  "data": {
    "countryID": [1, 5],
    "travelStartdate": "2026-10-01",
    "travelEnddate": "2026-10-07",
    "travelType": 1
  }
}
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `data` | object | yes | `required` |
| `data.countryID` | int16[] | yes | `required,min=1,dive,gt=0` |
| `data.travelStartdate` | string `YYYY-MM-DD` | yes | `required`; parsed in the handler |
| `data.travelEnddate` | string `YYYY-MM-DD` | yes | `required`; must not be before the start date |
| `data.travelType` | int16 | yes | `required,oneof=1 2 3` |

Logic:
- `countDay` is 0 if the travel type is "Per year" (`LOWER(mas_name_en)='per year'`). Otherwise it is `(end - start) days + 1`.
- For each package, the handler reads `mas_ta_premium` for `(package, countDay)` and lists coverages.
- A package appears in the result **only if** it has at least one coverage row for that `countDay`.

**Success 200**
```json
{
  "status": true,
  "data": [
    {
      "packageId": 1,
      "taTravelType": {
        "taTravelTypeId": 1,
        "taTravelTypeNameTh": "string",
        "taTravelTypeNameEn": "Per trip",
        "taTravelTypeDescTh": "string",
        "taTravelTypeDescEn": "string"
      },
      "isVisa": true,
      "packageName": "string",
      "packageDesc": "string",
      "countDay": 7,
      "premAmt": 300.0,
      "dutyAmt": 2.0,
      "vatAmt": 21.14,
      "totalAmt": 323.14,
      "countryItems": [ { "countryid": 1, "nameTh": "string", "nameEn": "string" } ],
      "coverageItems": [
        {
          "coverageId": 1, "nameTh": "string", "nameEn": "string",
          "coverageDescTh": "string", "coverageDescEn": "string", "siAmt": 1000000,
          "coverageDesc1Th": "string", "coverageDesc2Th": "string", "coverageDesc3Th": "string",
          "coverageDesc1En": "string", "coverageDesc2En": "string", "coverageDesc3En": "string",
          "otherAmtMin": 0, "otherAmtMax": 0, "coverageTypeIcon": "string"
        }
      ],
      "isAddon": false,
      "packageDesc1": "string",
      "packageDesc2": "string",
      "packageDesc3": "string",
      "isDefault": true
    }
  ]
}
```
Note: the country key is lowercase `countryid` because the sqlc column alias is unquoted.

**Errors**
| Status | Message |
|---|---|
| 400 | bind/validator error text; `startDate invalid format`; `endDate invalid format`; `endDate must be after startDate` |
| 404 | `travelType not found` |
| 500 | raw DB error text |

**DB:**
- `mas_ta_travel_type`: `IsMasTaTravelTypeYear`, `GetMasTaTravelTypeByID`
- `mas_ta_package`: `ListMasTaPackageByTravelType`, filtered by `is_active=true` and a non-null priority
- `mas_country`: `ListMasCountry`
- `mas_ta_premium`: `GetTotalAmtMasTaPackage`
- `mas_ta_package_coverage` JOIN `mas_ta_premium` JOIN `mas_ta_coverage`: `ListMasTaPackageCoverage`

Read only. **Outbound:** none.

### POST /api/v1/ta/upsertleadta
Purpose: create a new TA lead, or update an existing one when `leadTaNo` (encrypted) is sent. The endpoint:
- recomputes premiums server-side from master data (the client amount fields are ignored and overwritten);
- applies the promo code;
- rejects a self-referral;
- upserts participants and packages inside one DB transaction;
- runs an AMLO check for new participants;
- returns the stored lead in the same shape as `GET /getleadta`.

**Request body**
```json
{
  "data": {
    "leadTaNo": null,
    "taPackageId": 1,
    "taTravelTypeId": 1,
    "countryOriginId": null,
    "countryMainId": 5,
    "countryIdArray": "[5,7]",
    "policyStartdate": "2026-10-01",
    "policyEnddate": "2026-10-07",
    "email": "user@example.com",
    "totalInsuredPersons": 1,
    "addonPackageDetails": [ { "addonPackageId": 10, "addonPackageAmt": 0 } ],
    "promoCode": "PROMO2026",
    "productGroupType": "ta",
    "productSubType": "",
    "affiliateSource": null,
    "affiliateCode": null,
    "referalSource": null,
    "referalCode": null,
    "partner_code": null,
    "ownerDetails": [
      {
        "ownerIndex": 1,
        "ownerTitleEn": "Mr.",
        "ownerFirstnameEn": "John",
        "ownerLastnameEn": "Doe",
        "flagRefInfoBuyer": true,
        "flagRefEmailBuyer": true,
        "ownerCardType": "citizen",
        "ownerCardId": "1111111111119",
        "ownerAddressEn": "1 Moo 1",
        "ownerDistrictId": 124,
        "ownerSubdistrictId": 979,
        "ownerProvinceId": 10,
        "ownerCountryId": null,
        "ownerStateId": null,
        "ownerCity": null,
        "ownerZipcode": "18110",
        "ownerCountryCode": null,
        "ownerCountryCodeId": null,
        "ownerPhone": "0800000000",
        "ownerEmail": "user@example.com",
        "ownerOccupationCode": null,
        "ownerBirthdate": "1990-01-01",
        "travelReasonID": 1,
        "travelReasonEn": "Travel",
        "beneDetails": { "beneType": 1, "beneRelation": 1, "beneTitleEn": "Mrs.", "beneFirstnameEn": "Jane", "beneLastnameEn": "Doe" },
        "deliFlag": false,
        "deliDetail": { "deliAddressEn": null, "deliDistrictId": null, "deliSubdistrictId": null, "deliProvinceId": null, "deliZipcode": null }
      }
    ]
  }
}
```

Top-level `data` fields (`controllers/dto/upsertleadta.go`):
| Field | Type | Required | Validation / notes |
|---|---|---|---|
| `leadTaNo` | string (encrypted) \| null | no | If present, it is decrypted and must be > 0 and exist unpaid, else 400/404 |
| `taPackageId` | int16 | yes | `required,gt=0`; must have a premium row for `countDay`, else 404 |
| `taTravelTypeId` | int16 | yes | `required,gt=0`; must exist in `mas_ta_travel_type`, else 404 |
| `countryOriginId` | int16 \| null | conditional | `omitempty,gt=0`; **required when the travel type is Inbound** (checked in the transaction, 400) |
| `countryMainId` | int16 | yes | `required,gt=0` |
| `countryIdArray` | string, e.g. `"[5,7]"` | yes | `required`; must not be `"[]"`; each element must parse as an int |
| `policyStartdate` / `policyEnddate` | string | yes | `required,date` (`YYYY-MM-DD`); end must not be before start |
| `email` | string | yes | `required,email` |
| `totalInsuredPersons` | int16 | yes | `required,gt=0`; **overwritten** with `len(ownerDetails)` |
| `ownerDetails` | array | yes | `required,min=1,max=15,dive` |
| `addonPackageDetails[].addonPackageId` | int16 | no | Must be an active add-on package with premium for `countDay`, else 404 |
| `addonPackageDetails[].addonPackageAmt` | float | no | Ignored (the server recomputes it) |
| `promoCode` | string \| null | no | If set, `email` is required; the code is looked up for group `ta` |
| `productGroupType` | string \| null | no | When `promoCode` is set, it must be `ta` (case-insensitive), else 400 |
| `productSubType` | string \| null | no | Used as the promo sub-group filter |
| `affiliateSource`, `affiliateCode`, `referalSource` | string \| null | no | Stored as-is |
| `referalCode` | string \| null | no | Rejected (400) if it equals the user's own referral code (`fn_loyalty_referal_code`) |
| `partner_code` | string \| null | no | Note the **snake_case** json tag (the response uses `partnerCode`) |
| `totalAmt`, `premAmt`, `dutyAmt`, `vatPer`, `vatAmt`, `discountPer`, `discountAmt`, `addonPackageTotalAmt`, `taPackageTotalAmt` | numeric | no | Ignored or overwritten by the server calculation |

`ownerDetails[]` fields:
| Field | Type | Required | Validation / notes |
|---|---|---|---|
| `ownerIndex` | int16 | yes | `required,gt=0`; unique within the request |
| `ownerFirstnameEn` / `ownerLastnameEn` | string | yes | `required,validName` |
| `ownerTitleEn` | string \| null | no | |
| `ownerCardType` | string | yes | `required` |
| `ownerCardId` | string | yes | `required`; unique within the request |
| `ownerZipcode` | string | yes | `required,max=16` |
| `ownerPhone` | string | yes | `required` |
| `ownerEmail` | string | yes | `required,email` |
| `ownerBirthdate` | string | yes | `required,date` |
| `ownerDistrictId`, `ownerSubdistrictId`, `ownerProvinceId` | int32 \| null | conditional | `omitempty,gt=0`; **required when not Inbound** |
| `ownerCountryId`, `ownerCountryCode`, `ownerCountryCodeId` | int16 \| null | conditional | `omitempty,gt=0`; **required when Inbound** |
| `ownerCity`, `ownerOccupationCode` | string \| null | conditional | **Required and non-empty when Inbound** |
| `ownerStateId` | int16 \| null | no | `omitempty,gt=0` |
| `ownerAddressEn`, `travelReasonEn` | string \| null | no | |
| `travelReasonID` | int16 \| null | no | |
| `flagRefInfoBuyer`, `flagRefEmailBuyer` | bool \| null | no | |
| `beneDetails` | object | yes (`required`) | `beneTitleEn`, `beneFirstnameEn`, and `beneLastnameEn` use `omitempty,validName`; `beneType` and `beneRelation` are int16 |
| `deliFlag` | bool | no | If true, `deliDetail.deliDistrictId`, `deliSubdistrictId`, `deliProvinceId`, and `deliZipcode` are all required |
| `deliDetail` | object | yes (`required`) | `deliAddressEn`, `deliDistrictId`, `deliSubdistrictId`, `deliProvinceId`, `deliZipcode` |
| `indiv*` amounts | numeric | no | Overwritten by the server |

Calculation (`ta_service.go:282-598`):
- `premAmt` = main package premium from `mas_ta_premium` + the sum of add-on premiums, minus the promo discount. The discount is either `percent` or `amount` of `prem_value`.
- `dutyAmt` = `ceil(premAmt * duty_per / 100)`, where `duty_per` comes from `sys_param`.
- `vatAmt` = `(premAmt + duty) * vat_per / 100`, rounded to 2 decimals. `vat_per` comes from `sys_param`.
- Per-person amounts go on each participant. Lead totals are the per-person amounts × `totalInsuredPersons`.

**Success 200:** same body as `GET /api/v1/ta/getleadta/:leadTaNo`, shown below. It includes the new or updated encrypted `leadTaNo`.

**Errors**
| Status | Message |
|---|---|
| 400 | bind/validator error text; `countryIdArray required`; `array is empty` or an Atoi error (countryIdArray); `ownerCountryId is required`; `ownerCity is required`; `ownerOccupationCode is required`; `ownerCountryCode is required`; `ownerCountryCodeId is required`; `ownerDistrictId is required`; `ownerSubdistrictId is required`; `ownerProvinceId is required`; `deliDetail required`; `ownerCardId <ids> duplicate`; `ownerIndex <n> duplicate`; `startDate invalid format`; `endDate invalid format`; `endDate must be after startDate`; `leadTaNo is invalid`; `referalCode '<code>' is invalid.`; `if the promoCode is not empty, the email should not be empty either.`; `productGroupType is invalid`; `countryOriginId is required for inbound travel type` |
| 403 | `ownerCardId '<id>' is on the AMLO blacklist with watchlist code <code>`. The message always cites `ownerDetails[0].ownerCardId`, whichever owner matched. |
| 404 | `taTravelTypeId not found`; `taPackageID not found`; `addonPackageId '<id>' not found`; `leadTaNo not found`; `promocode '<CODE>' not found.`; `Premium Tariff not found.`; `leadTaNo not found.`; `PromoTransId not found.` |
| 500 | raw DB error; `this promocode '<code>' has already been used.` (a unique code already active for this email; returned as 500, not 4xx) |
| 503 | AMLO call failure (network error, or `fetch API '<url>' fail.`) |

**DB tables & functions**

Reads:
- `mas_ta_travel_type`: `IsMasTaTravelTypeInbound`, `IsMasTaTravelTypeAlreadyExists`, `IsMasTaTravelTypeYear`
- `mas_ta_package_coverage` JOIN `mas_ta_premium` JOIN `mas_ta_coverage`: `GetMasTaPackageCoverage`
- `mas_ta_package`: `IsMasTaPackageAddon`
- `lead_ta_premium`: `GetLeadTaPremium`, which filters `payment_status IS NULL OR != 'SUCCESS'`
- `lead_ta_participant`: `GetLeadTAOwnerByCardId`, `GetLeadTAOwner`, `ListLeadTAOwnerId`
- `sec_user`: `GetUserIdByEmail`
- stored function `insurverse.fn_loyalty_referal_code(user_id)`: `GetReferalCodeByUser`
- `promo_code` + `promo_code_trans`: `GetPromoCode` CTE query, `GetPromoActiveByPromoCodeId`, `GetPromoTransNoPromoActiveByPromoCodeId`, `GetSeqIdPromoCodeTransByPromoCodeId`
- `sys_param`: `GetDutyPercent` (`purchase/duty/duty_per`), `GetVatPercent` (`purchase/vat/vat_per`)
- `lead_ta_package`: `GetLeadTaPackageByLeadNo`, `ListLeadTaPackageByLeadNo`

Writes, in one transaction (`database/sqlc/tx_upsertleadta.go`, `execTx`; no advisory lock and no `FOR UPDATE`):
- `lead_ta_premium`: INSERT (identity `lead_ta_no`, `RETURNING lead_ta_no`), or UPDATE; then UPDATE `promo_trans_id`
- `promo_code_trans`: INSERT for a mass code with no trans (`seq_id` = max + 1, computed in app code); UPDATE `promo_book_by` / `promo_book_at`
- `lead_ta_participant`: `CopyFrom` bulk insert, UPDATE, and DELETE of indexes not in the request
- `lead_ta_package`: `CopyFrom` bulk insert, UPDATE, and DELETE of packages not in the request

After the commit, the handler reads the lead back the same way `GET /getleadta` does.

**Outbound:** UAM `check_amlo_blacklist` (see Overview). It is called once per owner whose `ownerCardId` is not yet on the lead:
- existing lead: before the transaction;
- new lead: **after** the transaction commits. A FREEZE hit then returns 403, but the lead rows are already saved.

### GET /api/v1/ta/getleadta/:leadTaNo
Purpose: return a TA lead that is **not yet paid** (`payment_status` is NULL or not `SUCCESS`), with participants, add-on packages, promo info, and the VAT percent.

| Param | In | Type | Required | Notes |
|---|---|---|---|---|
| `leadTaNo` | path | string | yes | AES-encrypted lead number (URL-encode it) |

**Success 200** (`controllers/structs/getLeadTa.go`)
```json
{
  "status": true,
  "data": {
    "leadTaNo": "<encrypted-lead-no>",
    "taPackageId": 1,
    "taTravelTypeId": 1,
    "countryOriginId": null,
    "countryMainId": 5,
    "countryIdArray": "[5,7]",
    "policyStartdate": "2026-10-01",
    "policyEnddate": "2026-10-07",
    "email": "user@example.com",
    "totalAmt": 323.14,
    "ownerDetails": [
      {
        "ownerIndex": 1, "ownerTitleEn": "Mr.", "ownerFirstnameEn": "John", "ownerLastnameEn": "Doe",
        "flagRefInfoBuyer": true, "flagRefEmailBuyer": true,
        "ownerCardType": "citizen", "ownerCardId": "1111111111119", "ownerAddressEn": "1 Moo 1",
        "ownerDistrictId": 124, "ownerSubdistrictId": 979, "ownerProvinceId": 10,
        "ownerCountryId": null, "ownerCountryName": null, "ownerStateId": null, "ownerStateName": null,
        "ownerCity": null, "ownerZipcode": "18110", "ownerPhone": "0800000000", "ownerEmail": "user@example.com",
        "ownerCountryCode": null, "ownerCountryCodeId": null, "ownerOccupationCode": null, "ownerOccupationName": null,
        "ownerBirthdate": "1990-01-01", "travelReasonID": 1, "travelReasonEn": "Travel",
        "beneDetails": { "beneType": 1, "beneRelation": 1, "beneTitleEn": "Mrs.", "beneFirstnameEn": "Jane", "beneLastnameEn": "Doe" },
        "deliFlag": false,
        "deliDetail": { "deliAddressEn": null, "deliDistrictId": null, "deliSubdistrictId": null, "deliProvinceId": null, "deliZipcode": null },
        "indivDiscountAmt": 0, "indivPermAmt": 300, "indivDutyAmt": 2, "indivVatAmt": 21.14,
        "indivTotalAmt": 323.14, "indivPromoDiscountSum": 0, "indivPermAmtMain": 250, "indivPermAmtAddon": 50
      }
    ],
    "addonPackageDetails": [ { "addonPackageId": 10, "addonPackageAmt": 50 } ],
    "addonPackageTotalAmt": 50,
    "taPackageTotalAmt": 250,
    "promoCode": null,
    "productGroupType": null,
    "productSubType": null,
    "discountPer": null,
    "discountAmt": 0,
    "affiliateSource": null,
    "affiliateCode": null,
    "referalSource": null,
    "referalCode": null,
    "premAmt": 300,
    "dutyAmt": 2,
    "vatPer": 7,
    "vatAmt": 21.14,
    "partnerCode": null,
    "totalInsuredPersons": 1,
    "discountAmtSum": 0
  }
}
```

**Errors**
| Status | Message |
|---|---|
| 400 | `leadTaNo required`; `leadTaNo is invalid` (decrypt failure) |
| 404 | `leadTaNo not found.` (also returned when the lead is already paid); `PromoTransId not found.` |
| 500 | raw DB error |

**DB (read only):**
- `lead_ta_premium`: `GetLeadTaPremium`
- `promo_code_trans` LEFT JOIN `promo_code`: `GetPromoCodeTransByPromoCodeTransId`
- `sys_param`: `GetVatPercent`
- `lead_ta_package`: `ListLeadTaPackageAddonByLeadNo`
- `lead_ta_participant` LEFT JOIN `mas_country`, `mas_state`, `sys_param` (`sub_dom_code='occupation_wpa'`): `ListLeadTAOwner`

**Outbound:** none.

## DB Usage

All objects are in schema `insurverse`.

| Table / function | Read / Write | Endpoints |
|---|---|---|
| `mas_ta_travel_type` | R | premium, upsertleadta |
| `mas_ta_package` | R | premium, upsertleadta |
| `mas_ta_premium` | R | premium, upsertleadta |
| `mas_ta_package_coverage` | R | premium, upsertleadta |
| `mas_ta_coverage` | R | premium, upsertleadta |
| `mas_country` | R | premium, upsertleadta (read-back), getleadta |
| `mas_state` | R | upsertleadta (read-back), getleadta |
| `sys_param` (duty %, VAT %, occupation names) | R | upsertleadta, getleadta |
| `sec_user` | R | upsertleadta |
| `fn_loyalty_referal_code(text)` (stored function) | R | upsertleadta (only when `referalCode` is sent and the email maps to a user) |
| `promo_code` | R | upsertleadta, getleadta |
| `promo_code_trans` | R/W (INSERT, UPDATE) | upsertleadta (W), getleadta (R) |
| `lead_ta_premium` | R/W (INSERT, UPDATE) | upsertleadta (R/W), getleadta (R) |
| `lead_ta_participant` | R/W (COPY insert, UPDATE, DELETE) | upsertleadta (R/W), getleadta (R) |
| `lead_ta_package` | R/W (COPY insert, UPDATE, DELETE) | upsertleadta (R/W), getleadta (R) |

No other stored functions or procedures are called. The only one is `fn_loyalty_referal_code`. `GetUserByReferalCode` also uses it but is never called. No raw `CALL` statements, advisory locks, or `SELECT ... FOR UPDATE`.

## Notes / ⚠️ unverified items

- ⚠️ **No auth** on any business endpoint (the upsert writes PII and promo usage). Auth at the gateway or ingress cannot be checked from this repo.
- ⚠️ **Swagger path mismatch:** the `GetLeadTA` annotation says `/api/v1/pa/getleadta/{leadTaNo}`; the real route is `/api/v1/ta/...`. The request-logger skipper checks `/api/v1/pa/docs` (copied from the PA service).
- ⚠️ **AMLO ordering on new leads:** for a new lead, the check runs after the transaction commits, so a blacklisted person's lead, participants, and promo trans rows stay in the DB even though the API returns 403.
- ⚠️ **AMLO message:** the 403 message always shows `ownerDetails[0].ownerCardId`, not the matched owner.
- ⚠️ **Status code for a used promo:** a unique promo code that was already used returns 500, not 4xx.
- ⚠️ **Promo race:** `promo_code_trans.seq_id` is computed as `MAX(seq_id)+1` in app code with no lock, so concurrent upserts can race. There is no advisory lock anywhere in the transaction.
- ⚠️ **Paid leads:** `GetLeadTaPremium` hides leads with `payment_status='SUCCESS'`, so both GET and upsert return 404 `leadTaNo not found` for paid leads.
- ⚠️ **`countDay` for Per-year types:** it is 0; the pricing relies on `mas_ta_premium` rows with `count_day = 0` (data not verified).
- ⚠️ **Travel type IDs:** `POST /premium` hard-limits `travelType` to `1`, `2`, or `3`. The type checks match names by string (`Per year`, `Per trip`, `Inbound Travel Insurance`), so renaming master data would change behavior.
- ⚠️ **Key naming:** the country item key is lowercase `countryid` (unquoted SQL alias). The request uses `partner_code` while the response uses `partnerCode`.
- ⚠️ **ErrorHandler panic risk:** it type-asserts `HTTPError.Message` to `string`, and there is no Recover middleware, so a non-string message would panic the request.
- ⚠️ **Unused clients:** `SendEmail`, `DocTaxDeduction`, and `IIATaxDeduction` in `util/api` are unused by any route. The IIA env vars (`Url_IIA`, `IIA_Username`, `IIA_Password`) are not in the startup `envKeys` check.
- ⚠️ **DB port:** it is hard-coded to 5432 in the runtime DSN; `DATABASE_PORT` is ignored at runtime.
- The code is from the local working copy (the branch was not checked, per the no-git rule), and DB column existence was not checked against a live schema. `database/schema.sql` is the sqlc schema snapshot.
