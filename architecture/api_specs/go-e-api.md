# go-e-api — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-e-api` (module `go-eapi`). Every route below comes from route-registration code (`internal/*/server.go` + `RegisterRoutes`). Written from a read-only review on 2026-09-23.

## Overview

| Item | Value |
|---|---|
| Purpose | **External partner Open API gateway** ("EXMS" APIs) for Insurverse motor insurance. Partners use it to get quotes (voluntary motor + compulsory/พ.ร.บ.), create/update leads, create payments, issue voluntary policies, list their policies, manage consent, and run driver-behavior checks. Almost all business logic runs in the downstream **ISV** services. This service validates input, checks the partner, and reshapes requests and responses. |
| Language / framework | Go 1.24, **Fiber v2** (`github.com/gofiber/fiber/v2`), GORM + pgx (PostgreSQL), go-playground/validator, go-jose (JWT) |
| Entry point | `cmd/server/main.go` → `internal/infrastructure/server/server.go` |
| Module selection | Go build tags. `all` is the default (Dockerfile `BUILD_TAGS=all`). Tags `user`, `lead`, `motor`, `policy`, `payment`, `consent` and `core` build a single-module binary (`internal/infrastructure/server/*.go`). |
| Base path | Each module mounts its own group under `/api/v1/<module>` (`motor`, `lead`, `payment`, `openpolicy`, `user`, `agreement`, `core`) |
| Port | `APP_HOST:APP_PORT` (code default `localhost:3000`, Dockerfile `EXPOSE 3000`, helm containerPort `8080`) |
| Swagger UI | `GET /swagger/*` (swag annotations; BasePath `/api/v1`. ⚠️ several paths are stale, see Notes) |
| Health | `GET /livez` (always true), `GET /readyz` (see Notes: the DB check is effectively a no-op) |
| Response envelope | `{"status":{"code":<int>,"header":"...","description":"..."},"data":<any, omitempty>}` (`pkg/model/presentaion.go`) |

### Environment variables (names only)
Loaded from `.env` (godotenv) and parsed with `caarlos0/env` (`pkg/config/model.go`):

- **App**: `APP_NAME`, `APP_ENV`, `APP_HOST`, `APP_PORT`, `APP_DEBUG` (default **true**), `APP_CLIENT_TIMEOUT`, `APP_RATE_LIMIT_CONN`, `APP_RATE_LIMIT_WINDOW`
- **Database**: `DATABASE_DRIVER`, `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME`, `DATABASE_SEARCH_PATH`, `DATABASE_TZ`, `DATABASE_SSL_MODE`, `DATABASE_MAX_OPEN`, `DATABASE_MAX_IDLE`, `DATABASE_MAX_LIFE`
- **JWT**: `JWT_SECRET`, `JWT_EXPIRE`, `JWT_ISSUER`, `JWT_AUDIENCE`
- **ISV**: `ISV_HOST`, `ISV_HOST_UAM_INTERNAL`, `ISV_COOKIE_TOKEN`, and the endpoint paths `ISV_ENDPOINT_MOTOR_MODEL`, `ISV_ENDPOINT_UAM_REGISTER_ACCOUNT`, `ISV_ENDPOINT_CREATE_POLICY`, `ISV_ENDPOINT_GET_POLICY`, `ISV_ENDPOINT_DECRYPT_LEADNO`, `ISV_ENDPOINT_CORE_CAR_COLOR`, `ISV_ENDPOINT_PREMIUM`, `ISV_ENDPOINT_PREMIUM_ACTAPI`, `ISV_ENDPOINT_PREMIUM_UTILITYAPI`, `ISV_ENDPOINT_PURCHASE_CREATE`, `ISV_ENDPOINT_PURCHASE_CREATE_ACT`, `ISV_ENDPOINT_PURCHASE_CHECK`, `ISV_ENDPOINT_PURCHASE_CHECK_ACT`, `ISV_ENDPOINT_PURCHASE_CALLBACK`, `ISV_ENDPOINT_CONSENT`, `ISV_ENDPOINT_COMP_PREMIUM`, `ISV_ENDPOINT_GET_OCCUPATION`, `ISV_ENDPOINT_DRIVER_BEHAVIOR`
- **Payment**: `PAYMENT_SECRET_KEY` (HMAC key used to sign the 2C2P-format success payload)
- Redis config struct exists, but Redis is **not initialised** (the code is commented out).

### External / third-party calls
All calls go to **ISV** (Insurverse internal services) over HTTP. The shared client (`internal/infrastructure/client/http_client.go`) attaches cookie `token=<ISV_COOKIE_TOKEN>`. Motor/lead `fetchGet`/`fetchPost` and the consent repository use their own `http.Client` (30s timeout) **without** that cookie.

| Config key | Path value in uat-isv helm | Used by |
|---|---|---|
| `ISV_ENDPOINT_MOTOR_MODEL` (GET) | `/api/v1/core/get-all` | motor car-and-model |
| `ISV_ENDPOINT_PREMIUM` (POST, `fn` dispatch) | `/api/v1/premium/premiumAPI` | motor premium; lead upsert/inquiry (`loadPremium`, `saveLeadCoveragePremium`, `updateLeadCoveragePremium`, `getLeadCoveragePremium`) |
| `ISV_ENDPOINT_PREMIUM_ACTAPI` (POST, `fn` dispatch) | `/api/v1/premium/actAPI` | compulsory brand/model/year/premium (`loadBrand`, `loadModel`, `loadModelYear`, `loadActPremium`); lead comp (`getLeadActPremium`, `saveLeadActPremium`) |
| `ISV_ENDPOINT_PREMIUM_UTILITYAPI` (POST) | `/api/v1/premium/utilityAPI` | `fn=decode` for the lead number (lead comp inquiry) |
| `ISV_ENDPOINT_CORE_CAR_COLOR` (GET) | `/api/v1/core/get-car-color` | comp-color |
| `ISV_ENDPOINT_GET_OCCUPATION` (GET) | `/api/v1/core/get-pwa-occupation` | user occupation |
| `ISV_ENDPOINT_UAM_REGISTER_ACCOUNT` (POST) | `/api/v1/uam/registeraccount_email_auto` | user isvregisterauto |
| `ISV_HOST_UAM_INTERNAL` + `ISV_ENDPOINT_DECRYPT_LEADNO` (POST) | `/v1/uam/decrypt_lead_no` | payment request (lead validation) |
| `ISV_ENDPOINT_PURCHASE_CREATE` / `_CREATE_ACT` (POST) | `/api/v1/purchase/create-payment(-act)` | payment request (creates a 2C2P payment via ISV purchase) |
| `ISV_ENDPOINT_PURCHASE_CHECK` / `_CHECK_ACT` (POST) | `/api/v1/purchase/check-payment(-act)` | payment inquiry |
| `ISV_ENDPOINT_PURCHASE_CALLBACK` (POST) | `/api/v1/purchase/callback` | payment success (manual success callback, signed with `PAYMENT_SECRET_KEY`) |
| `ISV_ENDPOINT_CREATE_POLICY` (POST) | `/api/v1/uam/create_policy_form` | openpolicy voluntary (policy issuance) |
| `ISV_ENDPOINT_DRIVER_BEHAVIOR` (POST) | `/api/v1/policy/oic/driver_behavior` | openpolicy driver-behavior (**OIC / คปภ.** driver-risk lookup via ISV) |
| `ISV_ENDPOINT_CONSENT` (+ suffixes) | `/api/v1/consent` | agreement/* (`/access/website-purchase`, `/purpose`, `/purpose/payment`, `/consent-receipt-group`, `/consent-receipt/payment-group`) |
| `ISV_ENDPOINT_COMP_PREMIUM` (GET) | `/api/v1/motor/comp-premium` | **Self-call** from lead comp-motor save back to this service's own `/api/v1/motor/comp-premium` (through `ISV_HOST`), forwarding the partner's `Authorization` header |
| `ISV_ENDPOINT_GET_POLICY` | `/api/v1/core/get-policy` | Declared but **not used** (my-policy reads the DB directly) |

### Background jobs / queues
- There are no cron jobs, queues or consumers.
- The only background work is `LoggerToDB`: each route gets a goroutine and an unbuffered channel that insert request/response logs into `log_openapi_interface`.

## Auth & Middleware

Global middleware, in order (`server.go` `Run()`): `cors.New()` (allows all origins) → `helmet` → `healthcheck` (`/livez`, `/readyz`) → `logger` (stdout) → `recover` → `requestid` (stored in `Locals("requestID")`) → `limiter` (sliding window, `APP_RATE_LIMIT_CONN` requests per `APP_RATE_LIMIT_WINDOW`, keyed by client IP by default).

**JWT auth** (`internal/auth/middleware/jwt.go`, `internal/auth/usecase/jwt.go`):
- The request needs the header `Authorization: Bearer <token>`. Token signature: HS256 with `JWT_SECRET`. Validated claims: `iss == JWT_ISSUER`, `aud` must contain one of `JWT_AUDIENCE`, plus standard exp/nbf.
- The `sub` claim is stored as `Locals("partnerCode")`. Handlers use it for partner ownership checks.
- On failure it returns HTTP **401** with `status.code=8888` and header "Malformed Request", "Invalid Authorization Type" or "Invalid Authorization Token".
- This service **does not issue tokens**. They are minted elsewhere ⚠️ unverified which service.

**LoggerToDB(apiName)** (`internal/logger/middleware/insert.go`): after the handler returns without error, it asynchronously inserts one row into `log_openapi_interface` with id (uuid v7), request_id, api_name, api_url, api_method, request_header (**all headers, including the Bearer token**), request_body, response_status, response_body, partner_code, and remark (`processTime`).

**Custom validators** (`internal/infrastructure/validate/validate.go`):

| Tag | Rule |
|---|---|
| `digit` / `digit=N` | Digits only, exactly N digits if N is given |
| `nonumeric` | No numeric characters |
| `validspecificcharacter` | `^[0-9a-zA-Zก-๙/-]*$` |
| `validthaicharacter` | Thai characters only |
| `validthaicharacterwithspace` | Thai characters and spaces |
| `prefixnamelabel` | One of `นาย`, `นาง`, `นางสาว` |
| `thaiCitizenID` | 13 digits plus mod-11 checksum |
| `email` | Overridden with `net/mail` parsing |

**Status codes** (`status.code` → default HTTP): 1000→200, 1001→202, 2000→204, 3000→400, 8000→400, 8888→503, 9999→400, 9000/9100/9200→503. Many handlers set the HTTP status explicitly instead, so the per-endpoint notes below list the actual HTTP status.

## Endpoint Summary

All business routes need a JWT. "JWT+P" means the handler also requires a non-empty `partnerCode` (JWT `sub`) and returns 403 without one.

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/livez` | none | `internal/infrastructure/server/server.go` (`Liveness`) | Liveness probe |
| 2 | GET | `/readyz` | none | `internal/infrastructure/server/server.go` (`Readiness`) | Readiness probe |
| 3 | GET | `/swagger/*` | none | `internal/infrastructure/server/server.go` | Swagger UI |
| 4 | GET | `/api/v1/motor/car-and-model` | JWT | `internal/motor/handler/handler.go:26` | Brand, model and year master (voluntary) |
| 5 | GET | `/api/v1/motor/premium` | JWT | `internal/motor/handler/handler.go:66` | Voluntary motor premium matrix |
| 6 | GET | `/api/v1/motor/comp-brand` | JWT | `internal/motor/handler/handler.go:121` | Compulsory (พ.ร.บ.) brands for a compCode |
| 7 | GET | `/api/v1/motor/comp-year` | JWT | `internal/motor/handler/handler.go:169` | Compulsory years and vehicle details |
| 8 | GET | `/api/v1/motor/comp-model` | JWT | `internal/motor/handler/handler.go:216` | Compulsory models for a brand |
| 9 | GET | `/api/v1/motor/comp-color` | JWT | `internal/motor/handler/handler.go:261` | Car color master |
| 10 | GET | `/api/v1/motor/comp-premium` | JWT | `internal/motor/handler/handler.go:297` | Compulsory premium for a compCode |
| 11 | PUT | `/api/v1/lead/motor` | JWT+P | `internal/lead/handler/handler.go:31` | Create or update a voluntary motor lead (premium lock) |
| 12 | GET | `/api/v1/lead/motor` | JWT+P | `internal/lead/handler/handler.go:116` | Get a voluntary lead and its premium |
| 13 | GET | `/api/v1/lead/comp-motor` | JWT+P | `internal/lead/handler/handler.go:216` | Get a compulsory (act) lead |
| 14 | PUT | `/api/v1/lead/comp-motor` | JWT+P | `internal/lead/handler/handler.go:277` | Create a compulsory (act) lead |
| 15 | POST | `/api/v1/payment/request` | JWT+P | `internal/payment/handler/payment.go:27` | Create a payment (2C2P via ISV purchase) |
| 16 | GET | `/api/v1/payment/inquiry` | JWT | `internal/payment/handler/payment.go:87` | Payment status by invoiceNo |
| 17 | POST | `/api/v1/payment/success` | JWT+P | `internal/payment/handler/payment.go:131` | Mark a PENDING payment as successful (manual callback) |
| 18 | POST | `/api/v1/openpolicy/voluntary` | JWT | `internal/policy/handler/policy.go:103` | Issue a voluntary motor policy |
| 19 | GET | `/api/v1/openpolicy/my-policy` | JWT+P | `internal/policy/handler/policy.go:31` | List policies by email for the partner |
| 20 | POST | `/api/v1/openpolicy/driver-behavior` | JWT | `internal/policy/handler/policy.go:432` | Driver risk level and discount (OIC) |
| 21 | POST | `/api/v1/user/isvregisterauto` | JWT | `internal/user/handler/register.go:25` | Auto-register a customer account in ISV UAM |
| 22 | GET | `/api/v1/user/occupation` | JWT | `internal/user/handler/occupation.go:20` | Occupation master |
| 23 | GET | `/api/v1/agreement/marketing` | JWT | `internal/consent/handler/interface.go:9` | Marketing consent purposes |
| 24 | POST | `/api/v1/agreement/marketing` | JWT+P | `internal/consent/handler/interface.go:36` | Save marketing consent |
| 25 | GET | `/api/v1/agreement/payment` | JWT | `internal/consent/handler/interface.go:94` | Payment consent text by policy type |
| 26 | POST | `/api/v1/agreement/payment` | JWT+P | `internal/consent/handler/interface.go:142` | Save payment consent |

Totals: **23 business endpoints** plus 3 infrastructure endpoints. The `core` module is mounted at `/api/v1/core` but registers **no routes** (`internal/core/handler/interface.go:29`).

Routes are registered in: motor `internal/motor/handler/interface.go:37-46`, lead `internal/lead/handler/interface.go:37-42`, payment `internal/payment/handler/interface.go:35-39`, policy `internal/policy/handler/interface.go:34-37`, user `internal/user/handler/interface.go:36-38`, consent `internal/consent/handler/handler.go:36-41`.

## Endpoints

Common error responses for every JWT route: **401** for a bad or missing token (see Auth), **429** from the rate limiter, and **500** for an unhandled error (global `ErrorHandler`, code 8888, or 9100 for a Fiber error).

---

### Motor (quote / master data) — `/api/v1/motor`
None of the motor endpoints use the DB directly (except the request log).

#### 4. GET `/api/v1/motor/car-and-model`
- **Purpose**: returns the brand → model → year/CC tree. Top brands (from ISV `BrandTop`) come first, ordered by `topNo`; the rest follow alphabetically.
- **Params**: none.
- **Success 200**:
```json
{"status":{"code":1000,"header":"Success","description":"Success without condition"},
 "data":{"brandLists":[{"carName":"TOYOTA","topNo":1,"modelLists":[{"modelName":"YARIS","topNo":0,"door":4,"sedanType":"S","years":[{"year":"2023","cc":["1200"]}]}]}]}}
```
- **Errors**: 503 with code 9100 "API Error" (ISV error or HTTP ≥400); 503 with code 8888 otherwise.
- **Outbound**: GET `ISV_HOST + ISV_ENDPOINT_MOTOR_MODEL`.

#### 5. GET `/api/v1/motor/premium`
- **Purpose**: voluntary premium matrix for a vehicle.
- **Query**:

| Name | Type | Required | Validation |
|---|---|---|---|
| brand | string | yes (not enforced) | none |
| model | string | yes (not enforced) | none |
| year | int | yes | > 0 |
| doors | int | yes | > 0 |
| cc | string | no | none |

- **Success 200**:
```json
{"status":{"code":1000,"header":"Success","description":"Success without condition"},
 "data":{"brand":"TOYOTA","model":"YARIS","year":2023,"doors":4,"seat":5,
  "premiumGroup":[{"key":"1_G_0","policyType":"1","garageType":"G","driverBehavior":0,
   "scPremiumAmt1":null,"scPremiumAmt2":null,"scPremiumAmt3":null,"scPremiumAmt4":null,"scPremiumAmt5":null,
   "premiumdetail":{"wg":null,"group":"3","usage":110,"sedan":"S","cc":"1200","bodyType":"...","cctv":0,"premAct":645.21,"isShowAccess":false,
    "coverageLists":[{"minSi":300000,"maxSi":400000,"split":0,"siCode":"od","options":[{"seq":1,"siAmt":300000,"premiumAmt":15000.0}]}]}}]}}
```
  `siCode` is one of `od`, `ft`, `tpbi_p`, `tppd`, `mv01`, `mv02`, `mv03`, `access`. `od` and `ft` have 5 options; the others have 3.
- **Errors**: 400 with code 3000 when year or doors ≤ 0; **400** with code 8000 "Data not found" when ISV returns no rows; 503 with code 9100 or 8888.
- **Outbound**: POST `ISV_ENDPOINT_PREMIUM` with `{"fn":"loadPremium","data":{brand,model,year,doors,cc}}`.

#### 6. GET `/api/v1/motor/comp-brand`
- **Query**: `compCode` (string, required).
- **Success 200**: `data: [{"brand":"TOYOTA"}]`
- **Errors**: 400 with code 3000 when compCode is missing; **400** with code 2000 when ISV returns no records or a status ≠ 201 (description = error text).
- **Outbound**: POST `ISV_ENDPOINT_PREMIUM_ACTAPI` with `{"fn":"loadBrand","data":{"compCode":...}}`. ISV must answer **201**.

#### 7. GET `/api/v1/motor/comp-year`
- **Query**: `compCode`, `brand`, `model` (all required).
- **Success 200**: `data: [{"brand","model","year","doors","seat","wg","group","type","sedan","bodyType","startDate","compCode","premium","discount","netPremium","stamp","vat","total"}]`. The money fields are **strings**.
- **Errors / outbound**: same as comp-brand, with `fn=loadModelYear`.

#### 8. GET `/api/v1/motor/comp-model`
- **Query**: `compCode`, `brand` (required).
- **Success 200**: `data: [{"model":"YARIS"}]`
- **Errors / outbound**: same as comp-brand, with `fn=loadModel`.

#### 9. GET `/api/v1/motor/comp-color`
- **Params**: none.
- **Success 200**: `data: [{"colorId":"01","colorNameTh":"ขาว","colorNameEn":"White"}]`
- **Errors**: **500** with code 9100 when ISV fails or returns a status ≠ 200.
- **Outbound**: GET `ISV_ENDPOINT_CORE_CAR_COLOR`.

#### 10. GET `/api/v1/motor/comp-premium`
- **Query**: `compCode` (required).
- **Success 200**: `data: {"premium":600.0,"discount":0,"netPremium":600.0,"stamp":3.0,"vat":42.21,"total":645.21}`. ISV returns strings; this service parses them to floats and uses 0 when parsing fails.
- **Errors**: 400 with code 3000 when compCode is missing; 400 with code 2000 when ISV returns a status ≠ 201 or all fields are empty.
- **Outbound**: POST `ISV_ENDPOINT_PREMIUM_ACTAPI` with `fn=loadActPremium`.
- Also called internally by endpoint 14 (self-call).

---

### Lead — `/api/v1/lead`

#### 11. PUT `/api/v1/lead/motor` (upsert voluntary lead)
- **Purpose**:
  - Empty `leadNo`: creates the lead. Calls ISV `loadPremium` and requires the key `<policyType>_<garageType>_<driverBehaviorCal>` to exist, then calls `saveLeadCoveragePremium` with the ISV `checkSum`. If any promo, affiliate or referral field is set, it immediately runs an update as well.
  - Non-empty `leadNo`: calls `updateLeadCoveragePremium`.
  - `partnerCode` is always overwritten with the JWT `sub`.
- **Request body** (`internal/lead/model/lead_ext.go` `LeadMotorUpsertRequest`):
```json
{
  "leadNo": "",
  "email": "kritsana.w.os@horixon-t8.com",
  "firstName": "กฤษณะ", "lastName": "วัฒนายนนต์", "mobile": "0628696603",
  "brand": "TOYOTA", "model": "YARIS", "year": "2023", "doors": 4,
  "policyType": "1", "garageType": "G",
  "cc": "1200", "siAns": 300000, "siTpbiPAns": 1000000, "siTppdAns": 1000000,
  "siMv01Ans": 100000, "siMv02Ans": 100000, "siMv03Ans": 200000, "siAccessAns": null,
  "flagCctv": "N", "flagCarAct": "Y", "flagAccess": "N",
  "parCitizenId1": "1111111111119", "parDriverLicenseNo1": "12345678", "driverBehaviorConsent1": true,
  "driverBehavior1": 1, "driverBehaviorCal": 0,
  "accessParaCode": [], "promoCode": null,
  "affiliateSource": null, "affiliateCode": null, "referalSource": null, "referalCode": null
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| leadNo | string | no | Empty → create, otherwise update |
| email | string | yes | `email` plus the handler regex `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$` |
| firstName, lastName, mobile | string | yes | none |
| brand, model, year | string | yes | `year` must parse as an int |
| doors | int | yes | gt=0 |
| policyType | string | yes | oneof `1`, `2+`, `3+`, `3` |
| garageType | string | yes | oneof `G`, `SC` |
| wg, usage, siAns, siTpbiPAns, siTppdAns, siMv01Ans, siMv02Ans, siMv03Ans, siAccessAns, scPremiumAmtAns, driverBehavior1..5, driverBehaviorCal | int or null | no | none |
| group, cc, promoCode, affiliateSource, affiliateCode, referalSource, referalCode | string or null | no | none |
| flagCctv, flagCarAct, flagAccess | string | no | Normalised by `checkFlag` |
| parCitizenId1..5, parDriverLicenseNo1..5 | string or null | no | none |
| driverBehaviorConsent1..5 | bool or null | no | none |
| scPremiumAmt1..5, driverBehaviorDiscPerc, driverBehaviorDiscAmt | float or null | no | none |
| accessParaCode | []string | no | Normalised (`utils.NormalizeSlice`) |

- **Success 200**: `{"status":{"code":1000,...},"data":{"leadNo":"<encrypted lead no>"}}`
- **Errors**:
  - 400 with code 3000 for a body parse error, validation failure or bad email.
  - 403 with code 8000 when partnerCode is missing.
  - 400 with code 8000 "Data not found" when the premium key is missing.
  - 400 with code 8000 "invalid checkSum" when ISV returns "checksum fail".
  - 503 with code 9100 for an ISV error, or 8888 for anything else (for example a non-numeric `year`).
- **DB**: none directly. Lead rows are written by ISV premiumAPI ⚠️ unverified which tables or functions.
- **Outbound**: POST `ISV_ENDPOINT_PREMIUM` (fn `loadPremium`, `saveLeadCoveragePremium`, `updateLeadCoveragePremium`).

#### 12. GET `/api/v1/lead/motor`
- **Query**: `leadNo` (required).
- **Purpose**: fetches the lead from ISV `getLeadCoveragePremium` and rebuilds the coverage and premium detail.
- **Success 200**: `data` = `GetLeadPremiumExt`. Main fields: leadNo, email, firstName, lastName, mobile, brand, model, year, doors, seat, premiumGroupKey, policyType, garageType, premiumDetail{wg, group, usage, sedan, cc, bodyType, cctv, premAct, coverageLists[]}, flags, si*Ans, driverDiscount, accessParaCode, premium, statusPromoCode, promoCode, premiumBeforeDiscount, promoDiscountPer, promoDiscountAmt, dutyAmt, vatAmt, totalAmt, paymentStatus, affiliate and referral fields, renewal dates, refPolicyNo, parCitizenId1..5, parDriverLicenseNo1..5, driverBehavior*, driverBehaviorConsent*, scPremiumAmtAns.
- **Errors**: 400 with code 3000 when leadNo is missing; 403 when partnerCode is missing; 503 with code 9100 or 8888.
- ⚠️ **Security gap**: the partner is not checked against the lead. `GetLeadPremium(leadNo)` ignores partnerCode (`internal/lead/usecase/usecase.go:40`), so any authenticated partner can read any lead's PII if it knows the encrypted leadNo.
- **Outbound**: POST `ISV_ENDPOINT_PREMIUM` (fn `getLeadCoveragePremium`).

#### 13. GET `/api/v1/lead/comp-motor`
- **Query**: `leadNo` (required, encrypted).
- **Flow**:
  1. ISV utilityAPI `fn=decode` turns the encrypted lead number into a numeric id.
  2. DB `insurverse."Lead_Car_Act_Discount_Premium"` is read `WHERE "Car_Act_Lead_No" = id`.
  3. The row's `partner_code` must equal the JWT partner.
  4. ISV actAPI `fn=getLeadActPremium` (must return 201 and `status=true`).
- **Success 200**: `data` = `LeadInquiryExternalResponse`. Fields: leadNo, startDate, endDate, effectiveStartdate, effectiveEnddate, brand, model, year, doors, seat, group, type, sedan, bodyType, compCode, premium, discount, netPremium, stamp, vat, total, prefixName, firstName, lastName, phone, email, paymentStatus, birthDate, citizenId, carLicenseNo, colorNameTh, carLicenseProvice, carLicenseProviceName, carLicenseType, carSerialNo, cc, address, provinceId, prname, districtId, diname, subdistrictId, sdname, zipcode, the deli* address fields (note the JSON key typo `delSsubdistrictId`), affiliate and referral fields, carColor, wg, occupation, occupationCode.
- **Errors**: 400 with code 3000 when leadNo is missing; 403 when partnerCode is missing; **400** with code 8000 and description "LeadNo not valid", "data not found", "partnerCode not valid", "internal_error", "something went wrong" or "error: …".
- **DB**: `insurverse."Lead_Car_Act_Discount_Premium"` (read).
- **Outbound**: `ISV_ENDPOINT_PREMIUM_UTILITYAPI`, `ISV_ENDPOINT_PREMIUM_ACTAPI`.

#### 14. PUT `/api/v1/lead/comp-motor` (create compulsory/act lead)
- **Request body** (`LeadMotorCompulsorySaveExternalRequest`):
```json
{
  "compCode": "110", "brand": "TOYOTA", "model": "YARIS", "year": "2023",
  "startDate": "2026-10-01", "carSerialNo": "MR0XXXXXXXXXXXXXX", "carColor": "01",
  "carLicenseType": "1", "carLicenseNo": "1กข1234", "carLicenseProvince": "10",
  "flagDeli": false,
  "prefixName": "นาย", "firstName": "กฤษณะ", "lastName": "วัฒนายนนต์",
  "birthDate": "1990-01-01", "citizenId": "1111111111119",
  "address": "1 หมู่ 1", "provinceId": 10, "districtId": 124, "subdistrictId": 979, "zipcode": "18110",
  "deliAddressNo": "", "deliProvinceId": 0, "deliDistrictId": 0, "deliSubdistrictId": 0, "deliZipcode": "",
  "doors": 4, "seat": 5, "cc": 1200, "wg": 0,
  "email": "kritsana.w.os@horixon-t8.com", "phone": "0628696603",
  "bodyType": "เก๋ง", "group": "3", "sedan": "S",
  "occupation": "พนักงานบริษัท", "occupationCode": "01"
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| compCode, brand, model, year | string | yes | (brand, model, compCode, year) must exist in `"Imp_Discount_Premium"` |
| startDate | string | yes | `yyyy-mm-dd`, `dd/mm/BBBB` (Buddhist year), `mm/dd/yyyy`, `dd-mm-yyyy` or RFC3339; not before today (UTC); within ±100 years |
| carSerialNo, carLicenseType, carLicenseNo | string | yes | none |
| carColor | string | yes | Must be a `color_id` in `insurverse.mas_cmi_color` |
| carLicenseProvince | string | yes | Must be a `provinceid` in `insurverse.province` |
| flagDeli | bool | **yes (must be present)** | Mapped to Y/N |
| prefixName, firstName | string | yes | `validthaicharacter` |
| lastName | string | yes | `validthaicharacterwithspace` |
| birthDate | string | yes | Date formats as startDate; within ±100 years |
| citizenId | string | no (tag) | `thaiCitizenID` (13 digits plus checksum) |
| address, zipcode | string | yes | none |
| provinceId, districtId, subdistrictId | int | yes | The combination with zipcode must exist (province/district/subdistrict/zipcode join) |
| deliAddressNo, deliZipcode, deliProvinceId, deliDistrictId, deliSubdistrictId | mixed | no | If any is set, the full combination must resolve |
| doors, seat, cc, wg | int | **yes (must be present)** | none |
| email | string | yes | `email` plus the handler regex |
| phone | string | no | `digit` (digits only) |
| bodyType, group, sedan, occupation, occupationCode | string | yes | none |

- **Flow**:
  1. Validate the request (see table).
  2. Self-call GET `ISV_HOST + ISV_ENDPOINT_COMP_PREMIUM?compCode=` (this service's `/api/v1/motor/comp-premium`) with the caller's `Authorization` header.
  3. ISV actAPI `fn=saveLeadActPremium` (must return **201**). `type` is fixed to 0 and `partnerCode` comes from the JWT.
- **Success 200**: `{"status":{"code":1000,"header":"Success",...},"data":{"leadNo":"<carActLeadNo>"}}`
- **Errors**: 400 with code 3000 for parse, validation or email errors; 403 when partnerCode or Authorization is missing; **400** with code 8000 and the business message (for example "doors not valid", "StartDate not valid", "invalid data: carLicenseProvince not found", "carColor not found", "Something went wrong, Can't prepare data", "Something went wrong, Can't save data").
- **DB (read)**: `insurverse.province`, `insurverse.district`, `insurverse.subdistrict`, `insurverse.zipcode`, `"Imp_Discount_Premium"` (unqualified, resolved via search_path), `insurverse.mas_cmi_color`.
- **Outbound**: this service (comp-premium), `ISV_ENDPOINT_PREMIUM_ACTAPI`.

---

### Payment — `/api/v1/payment`

#### 15. POST `/api/v1/payment/request`
- **Purpose**: create a payment for a voluntary lead (`leadType=mv`) or a compulsory lead (`mc`).
- **Request body** (`RequestDataExternal`):
```json
{"leadNo":"<encrypted leadNo>","leadType":"mv","productDesc":"ประกันรถยนต์ชั้น 1","policyType":"1",
 "amount":15000.00,"isIPP":false,"paymentMethod":"CC","installmentPeriod":0,
 "email":"kritsana.w.os@horixon-t8.com","remark":"","redirectUrl":"https://partner.example/return",
 "paymentChannel":"2C2P","SalesChannel":1}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| leadNo | string | yes | Decrypted via UAM `decrypt_lead_no`; must resolve |
| leadType | string | yes | `mv` or `mc` (case-insensitive); anything else is unsupported |
| productDesc | string | yes | none |
| policyType | string | no | Must equal the DB `Type`; for `mc` it must be `"0"` |
| amount | float | yes | Non-zero. ⚠️ **not compared with the DB premium** in this service |
| isIPP | bool | no | none |
| paymentMethod | string | yes | `CC`, `PPQR` or `TRUEMONEY` |
| installmentPeriod | int | no | Forwarded for `mv` only |
| email | string | yes | email |
| remark | string | no | none |
| redirectUrl | string | yes | none |
| paymentChannel | string | yes | Default "2C2P" |
| SalesChannel | int | no | JSON key has a capital `S`. If set, it must match `para_code` in `insurverse.sys_param` (dom_code `openapi`, sub_dom_code `sales_channcel`); 0 becomes 1 |

- **Validation flow**:
  1. Decrypt leadNo.
  2. `mv`: read `insurverse."Lead_coverage_premium"` `WHERE "Lead_No"=?`. `mc`: read `insurverse."Lead_Car_Act_Discount_Premium"` `WHERE "Car_Act_Lead_No"=?`.
  3. `partner_code` must equal the JWT partner.
  4. `Type` must equal `policyType`.
  5. Check the payment method, the email and the sales channel.
- **Success 200**: `{"status":{"code":1000,"header":"OK","description":"Payment Request is successfully created"},"data":{"invoiceNo":"P...","webPaymentUrl":"https://...2c2p...","token":"...","amount":15000,"description":"...","method":"CC","installment":false,"remark":"","redirectUrl":""}}`. `redirectUrl` is not populated.
- **Errors**: 400 with code 3000 for parse or validation errors; 403 when partnerCode is missing; **400** with code 9100 and description e.g. "LeadNo not valid", "partnerCode not valid", "PolicyType not valid", "method not valid", "sales channel N is not valid", or the ISV message.
- **DB (read)**: `insurverse."Lead_coverage_premium"`, `insurverse."Lead_Car_Act_Discount_Premium"`, `insurverse.sys_param`.
- **Outbound**: `ISV_HOST_UAM_INTERNAL + ISV_ENDPOINT_DECRYPT_LEADNO`, then `ISV_ENDPOINT_PURCHASE_CREATE` (mv, request forwarded as-is) or `ISV_ENDPOINT_PURCHASE_CREATE_ACT` (mc, `actNo`=leadNo). ISV must return HTTP 200. The payment rows (`insurverse.payment` / `payment_act`) are written by ISV purchase, and invoice numbering is done in the DB/ISV ⚠️ unverified (e.g. `fn_policy_invoiceno_*`).

#### 16. GET `/api/v1/payment/inquiry`
- **Query**: `invoiceNo` (required). The prefix `P` means a voluntary payment and `A` means an act payment; any other prefix returns "InvoiceNo not valid".
- **Success 200**: `data: {"paymentId","invoiceNo","leadNo","urlPay","token","amount","description","method","isInstallment","paymentStatus","customerEmail","salesChannel","remark"}`
- **Errors**: 400 with code 3000; **400** with code 2000 (description = error).
- ⚠️ No partner ownership check: any authenticated partner can query any invoice.
- **Outbound**: `ISV_ENDPOINT_PURCHASE_CHECK` (P) or `ISV_ENDPOINT_PURCHASE_CHECK_ACT` (A).

#### 17. POST `/api/v1/payment/success`
- **Purpose**: lets a partner mark its **PENDING** invoice as paid. This service builds a **2C2P-format payment-result payload** with these values:
  - RespCode `0000`
  - PaymentChannel `["CC"]`
  - a hard-coded MerchantID
  - userDefined1 = leadNo, userDefined2 = `POLICY` or `ACT`, userDefined3 = email
  - `isManualUpdate=true`

  It signs the payload as an HS256 JWT with `PAYMENT_SECRET_KEY` and POSTs `{"payload":"<jwt>"}` to the ISV purchase callback.
- **Request body**:
```json
{"invoiceNo":"P2026000001","ref1":"","ref2":"","ref3":""}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| invoiceNo | string | yes | Prefix `P` or `A` |
| ref1, ref2, ref3 | string | no | Forwarded as reference1..3 |

- **Validation**: DB join. `P`: `"Lead_coverage_premium" lcp JOIN payment p ON p.lead_no = lcp."Lead_No" WHERE p.invoice_no=?`. `A`: `"Lead_Car_Act_Discount_Premium" lca JOIN payment_act pa ON pa.act_no = lca."Car_Act_Lead_No"`. The row must exist, `payment_status` must be `PENDING`, and `partner_code` must equal the JWT partner.
- **Success 200**: `{"status":{"code":1000,"header":"OK","description":"Success without condition"}}` (no data).
- **Errors**: 400 with code 3000; 403 when partnerCode is missing; 400 with code 2000 only for "InvoiceNo not valid"; **500** with code 9100 for everything else. The usecase returns lowercase "data not found", which does not match the handler's "Data not found" check, so not-found cases also return 500.
- **DB (read)**: `payment`, `payment_act`, `"Lead_coverage_premium"`, `"Lead_Car_Act_Discount_Premium"` (the raw SQL uses unqualified names, resolved via search_path).
- **Outbound**: `ISV_ENDPOINT_PURCHASE_CALLBACK`.
- ⚠️ This is a partner-trusted "mark paid" mechanism: no real 2C2P settlement is verified here. `UpdatedManualBy` is taken from `data.PartnerCode`, which comes from the DB row.

---

### Open Policy — `/api/v1/openpolicy`

#### 18. POST `/api/v1/openpolicy/voluntary` (issue voluntary motor policy)
- **Request body** (`ExtPolicyMVCreateRequest`):
```json
{
  "leadNo": "<encrypted leadNo>",
  "person": {
    "prefixId": "1", "prefixLabel": "นาย", "firstName": "กฤษณะ", "lastName": "วัฒนายนนต์",
    "birthDate": "1990-01-01", "citizenId": "1111111111119",
    "addressNo": "1 หมู่ 1", "provinceId": 10, "provinceLabel": "สระบุรี",
    "districtId": 124, "districtLabel": "เมืองสระบุรี", "subdistrictId": 979, "subdistrictLabel": "ปากเพรียว",
    "zipcode": "18110", "financialName": "", "occupation": "พนักงานบริษัท", "occupationCode": "01",
    "drivers": []
  },
  "car": {
    "carBrand": "TOYOTA", "carModel": "YARIS", "carYear": "2023", "act": true,
    "vin": "MR0XXXXXXXXXXXXXX", "color": "01", "size": "1200",
    "vehicleRegistrationNumber": "1กข1234", "vehicleRegistrationPlateColor": "ป้ายขาว",
    "vehicleRegistrationProvinceId": 10, "vehicleRegistrationProvinceLabel": "สระบุรี",
    "effectiveDateCoverageStart": "2026-10-01", "effectiveDateCoverageEnd": "2027-10-01",
    "effectiveDateRdStart": "2026-10-01", "effectiveDateRdEnd": "2027-10-01",
    "receiveDocument": "email", "addressSameCardId": true,
    "addressNo": "1 หมู่ 1", "provinceId": 10, "provinceLabel": "สระบุรี",
    "districtId": 124, "districtLabel": "เมืองสระบุรี", "subdistrictId": 979, "subdistrictLabel": "ปากเพรียว",
    "zipcode": "18110"
  }
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| leadNo | string | yes | none |
| person.addressNo, districtLabel, provinceLabel, subdistrictLabel, occupation, occupationCode | string | yes | none |
| person.birthDate | string | yes | `yyyy-mm-dd`; year must be < the current year and ≥ current year − 100 (Christian era) |
| person.citizenId | string | yes | `number`, `digit=13` (**no checksum**) |
| person.districtId | int | yes | Location combination (province/district/subdistrict/zipcode) must exist, or all four must be empty |
| person.firstName, lastName | string | no | `validthaicharacter`, `nonumeric` |
| person.prefixLabel | string | yes | `นาย`, `นาง` or `นางสาว` |
| person.financialName | string | no | `validspecificcharacter` |
| person.drivers[] | array | no | order, prefixId, prefixLabel(`prefixnamelabel`), firstName/lastName (Thai), birthDate, licenseNumber(`number`), occupation, occupationCode, citizenId(`number,digit=13`) |
| car.carBrand, carModel, carYear | string | yes | Must exist in `insurverse."Imp_Price_Premium"` (case-insensitive) |
| car.color | string | yes | Must exist in `insurverse.mas_cmi_color` |
| car.size | string | yes | `number` |
| car.vin | string | yes | `validspecificcharacter` |
| car.effectiveDateCoverageStart/End, effectiveDateRdStart/End | string | yes | `yyyy-mm-dd`, ≥ today |
| car.vehicleRegistrationPlateColor | string | yes | `ป้ายแดง` or `ป้ายขาว` |
| car.vehicleRegistrationProvinceId | int | yes | Must exist in `insurverse.province` |
| car.receiveDocument | string | yes | `email` or `post` |
| car.addressSameCardId | bool | yes (must be present) | none |
| car.addressNo, the *Label fields, vehicleRegistrationNumber, vehicleRegistrationProvinceLabel | string | yes | none |
| car.provinceId, districtId, subdistrictId, zipcode | mixed | no | All set and valid, or all empty |
| car.act | bool | no | none |

- **Success 200**: `{"status":{"code":1000,"header":"OK","description":""},"data":{"policyNo":"<policy no>"}}`
- **Errors**: 400 with code 3000 for parse, validation or business-validation failures (description, e.g. "Color not valid", "Car detail not valid", "Get location detail (Person data) not valid"); **400** with code **1001** (sic) when ISV fails or no policyNo comes back (description = ISV description).
- ⚠️ **No partnerCode check** in this handler. partnerCode is not forwarded, and lead ownership is not verified here; it presumably happens in ISV `create_policy_form` ⚠️ unverified.
- **DB (read)**: `insurverse.mas_cmi_color`, `insurverse.province`, `insurverse."Imp_Price_Premium"`, and the province/district/subdistrict/zipcode join.
- **Outbound**: POST `ISV_ENDPOINT_CREATE_POLICY` (UAM `create_policy_form`) with `IntPolicyForm{person, car}`. Policy issuance, invoice/policy numbering and the OIC submission happen downstream ⚠️ unverified (e.g. `fn_lead_to_car_act` or others are not referenced in this repo).

#### 19. GET `/api/v1/openpolicy/my-policy`
- **Query** (Fiber `QueryParser` with no `query` tags, so parameter names match struct fields case-insensitively): `email` (required), `policyNo` (optional). A `partnerCode` query value is ignored because the JWT `sub` overrides it.
- **Success 200**: `data: [MyPolicyResponse]`. Motor, TA, PA and Home policy fields: brand, model, year, carLicenseNo, type, si, owner* (TH/EN), policyNo, policyTaNo, carActNo, dates, policyStatus, paymentDate, car details, ownerCitizenId, address, drivers par1..5*, bene*, deli*, garageType, si*Limit, plus parsed JSON sub-objects (endorsements, coverages, motorDetail, beneTA/PA detail, renewalDetail, homeCoverage, partner_detail).
- **Not found**: **HTTP 200** with code 2000 "No records found".
- **Errors**: 400 with code 3000; 403 when partnerCode is missing; **500** with code 9200 for a DB or build error.
- **DB**: stored function **`insurverse.fn_policy_my_policy_search_optimized($email, NULLIF($partnerCode,''), NULLIF($policyNo,''))`** (read; `internal/policy/repository/interface.go:178-343`). ⚠️ The function definition was not inspected in the DB.

#### 20. POST `/api/v1/openpolicy/driver-behavior`
- **Request body**:
```json
{"carType":"110","effectiveDate":"2026-10-01",
 "driverLists":[{"driverNo":1,"idCard":"1111111111119","driverLicense":"12345678","driverBehaviorConsent":true}]}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| carType | string | no | none |
| effectiveDate | string | no | none |
| driverLists[].driverNo | int | yes | none |
| driverLists[].idCard | string | yes | numeric, len=13 |
| driverLists[].driverLicense | string | no | none |
| driverLists[].driverBehaviorConsent | bool | yes (must be present) | none |

- **Success 200** (note: `status.code` is a **string** here): `{"status":{"code":"1000","header":"Success","description":"Success without condition"},"data":{"driverRiskLevelLists":[{"driverNo":1,"riskLevel":2,"discountPct":5}]}}`
- **Errors**: 400 with code 3000; **500** with code 9200 when ISV fails.
- **Outbound**: POST `ISV_ENDPOINT_DRIVER_BEHAVIOR` (ISV → OIC/คปภ. driver-behavior). No partnerCode check.

---

### User — `/api/v1/user`

#### 21. POST `/api/v1/user/isvregisterauto`
- **Request body**:
```json
{"email":"kritsana.w.os@horixon-t8.com","firstName":"กฤษณะ","lastName":"วัฒนายนนต์","mobile":"0628696603","occupation":"พนักงานบริษัท","occupationCode":"01"}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| email | string | yes | email |
| firstName, lastName, mobile, occupation, occupationCode | string | yes | none |

- **Success 200**: `{"status":{"code":1000,"header":"Success","description":"Success"}}`
- **Errors**: 422 with code 3000 for a parse error; 400 with code 3000 for a validation error; **500** with code 8888 (header = the HTTP status text of the ISV error, description = the ISV `title`).
- ⚠️ If ISV returns HTTP < 400 but a body `status` ≥ 400, then `err` is nil and `err.Error()` panics. The recover middleware turns this into a 500.
- **Outbound**: POST `ISV_ENDPOINT_UAM_REGISTER_ACCOUNT` (with the cookie token). Sent as `{email, first_name, last_name, mobile, occupation, occupationCode}`.

#### 22. GET `/api/v1/user/occupation`
- **Success 200**: `data: [{"occupationCode":"01","occupation":"พนักงานบริษัท"}]`
- **Errors**: **500** with code 9100 when ISV fails or returns `result=false`.
- **Outbound**: GET `ISV_ENDPOINT_GET_OCCUPATION`.

---

### Agreement / Consent — `/api/v1/agreement`
None of the consent endpoints use the DB. Upstream calls use their own client with no cookie. On an error the handler returns **503** with code 8888 "something went wrong".

#### 23. GET `/api/v1/agreement/marketing`
- **Flow**: POST `CONSENT/access/website-purchase` returns `{token, collectionPointId}`. Then GET `CONSENT/purpose?collectionpointId=` with `Bearer <token>`.
- **Success 200**: `data: {"identifier","defaultLanguage","languages":[],"purposes":[{"id","name","version","giveConsent","languages":[{"default","description","language","name"}],"isDefault"}],"dataElements":[],"constDataElements":{},"id","name","description","header":[{"title","language","description"}],"jwtToken","isShowReveal"}`. Note that the upstream `jwtToken` is passed through to the partner.

#### 24. POST `/api/v1/agreement/marketing`
- **Body**:
```json
{"leadType":"mv","leadNo":"<leadNo>","requestInformation":"...","purposes":[{"Id":"<purposeId>","TransactionType":"CONFIRMED"}]}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| leadType | string | yes | oneof `pa`, `ta`, `home`, `mv`, `mc` |
| leadNo | string | yes | none |
| requestInformation | string | yes | none |
| purposes[] | array | yes | min=1; `Id` and `TransactionType` required (capitalised JSON keys) |

- **Success 200**: status only. Upstream must return `message=="success"`.
- 403 when partnerCode is missing. ⚠️ Lead ownership is not checked.
- **Outbound**: POST `CONSENT/consent-receipt-group`.

#### 25. GET `/api/v1/agreement/payment`
- **Query**: `type` (required) = `1`, `2+`, `3+`, `3` or `act`. The `+` is URL-encoded upstream.
- **Success 200**: `data: {"id","name","version","activeStartDate","content":[{"id","name","description","language"}]}`
- **Errors**: 400 with code 3000 when type is missing or invalid.
- **Outbound**: GET `CONSENT/purpose/payment?type=`.

#### 26. POST `/api/v1/agreement/payment`
- **Body**: `{"leadType":"mc","leadNo":"<leadNo>","purposes":[{"id":"<purposeId>","status":"CONFIRMED"}]}`. leadType uses the same oneof as endpoint 24; purposes needs min=1 with `id` and `status` required.
- **Success 200**: status only. 403 when partnerCode is missing. ⚠️ Lead ownership is not checked.
- **Outbound**: POST `CONSENT/consent-receipt/payment-group`.

---

### Infrastructure
- **`/livez`**: always ready.
- **`/readyz`**: Redis is nil, so it counts as ready. The DB branch runs only `if r.DBConn == nil` (inverted condition), so with a live DB it always reports ready without pinging, and with a nil DB it would panic.
- **`/swagger/*`**: `gofiber/swagger` default handler.

## DB Usage

PostgreSQL via GORM. Connection: `DATABASE_*`, search_path `DATABASE_SEARCH_PATH`. Schema `insurverse` unless noted.

| Table / function | R/W | Endpoints |
|---|---|---|
| `log_openapi_interface` (unqualified) | **W** (insert) | All 23 business endpoints (LoggerToDB) |
| `insurverse."Lead_coverage_premium"` | R | 15 payment/request (mv), 17 payment/success (P) |
| `insurverse."Lead_Car_Act_Discount_Premium"` | R | 13 lead/comp-motor GET, 15 payment/request (mc), 17 payment/success (A) |
| `payment` (unqualified; GORM model `insurverse.payment`) | R | 17 payment/success |
| `payment_act` (unqualified) | R | 17 payment/success |
| `insurverse.sys_param` (dom_code `openapi`, sub_dom_code `sales_channcel`) | R | 15 payment/request |
| `insurverse.province` | R | 14 lead/comp-motor PUT, 18 openpolicy/voluntary |
| `insurverse.district`, `insurverse.subdistrict`, `insurverse.zipcode` | R | 14, 18 (location validation join) |
| `insurverse.mas_cmi_color` | R | 14, 18 |
| `"Imp_Discount_Premium"` (unqualified) | R | 14 lead/comp-motor PUT |
| `insurverse."Imp_Price_Premium"` | R | 18 openpolicy/voluntary |
| **`insurverse.fn_policy_my_policy_search_optimized(email, partner_code, policy_no)`** | R (function) | 19 openpolicy/my-policy |

Unused in active routes: `pkg/entity/mas_partner.gen.go` (`mas_partner` entity) and `paymentRepository.GetPayment`. This service writes no business rows directly. Leads, payments and policies are written by downstream ISV services.

## Notes / ⚠️ unverified items

**Swagger drift**
1. `docs/swagger.*` annotations are **stale**:
   - policy is documented as `/policy/*`, but the real prefix is `/api/v1/openpolicy/*`;
   - payment create is documented as `/payment/voluntary`, but the real route is `/api/v1/payment/request`;
   - the `/agreement/*` routes are missing;
   - comp-brand documents an unused `model` param;
   - my-policy is documented with a body, but it actually reads query params.
2. Tests in `test/policy` mount `/api/v1/policy`, which does not match production.

**Security and authorization gaps**
3. No partner ownership check on:
   - GET `/lead/motor` (12)
   - GET `/payment/inquiry` (16)
   - POST `/openpolicy/voluntary` (18)
   - POST `/openpolicy/driver-behavior` (20)
   - POST `/agreement/*` (24, 26)

   ⚠️ Whether ISV enforces ownership downstream is unverified.
4. `LoggerToDB` stores **all request headers, including the Bearer JWT**, and full request and response bodies (citizen IDs, addresses) in `log_openapi_interface`.
5. `APP_DEBUG` defaults to **true** and is **not set** in `helm-prod.yaml`, `helm-uat.yaml`, `helm-uat2.yaml` or `helm-uat-isv.yaml`. In debug mode `main.go` logs the full config struct (including `JWT_SECRET`, `DATABASE_PASSWORD` and `PAYMENT_SECRET_KEY`), and GORM runs in Debug mode (SQL logging).
6. Helm env-name mismatches with the code: helm sets `DATABASE_SSLMODE` and `ENV`, but the code reads `DATABASE_SSL_MODE` and `APP_ENV`, so the defaults (`disable`, `local`) apply.
7. `/payment/success` lets a partner self-mark a PENDING invoice as paid by synthesising a signed 2C2P-style callback (hard-coded MerchantID, RespCode `0000`). This is intended as a manual-update path (`IsManualUpdate=true`), but it is a high-trust operation.

**Bugs and response inconsistencies**
8. `/payment/success`: lowercase "data not found" does not match the handler's "Data not found" check, so not-found cases return 500 instead of 400.
9. `/user/isvregisterauto`: possible nil-error panic (see endpoint 21).
10. `/readyz`: inverted DB check (see Infrastructure).
11. Motor premium bug: the `access` option seq 3 uses `PremAccess2` as its premium (`internal/motor/usecase/usecase.go`, access case).
12. Lead comp save: a bad `birthDate` format returns "StartDate not valid".
13. Response code inconsistencies: `/openpolicy/voluntary` returns code 1001 with HTTP 400 on ISV failure; `/openpolicy/driver-behavior` returns `status.code` as a string.

**Not verified**
14. ⚠️ The DB definition of `insurverse.fn_policy_my_policy_search_optimized` was not inspected (source code is read-only; no DB access was used).
15. ⚠️ Downstream behaviour of the ISV endpoints (premiumAPI, actAPI, purchase, UAM `create_policy_form`, consent, OIC driver_behavior) is outside this repo, including:
    - which tables and stored functions they touch (e.g. invoice-number or lead-to-act functions);
    - whether they enforce partner ownership;
    - whether they submit to OIC/คปภ.
16. ⚠️ The JWT issuer (the service that mints partner tokens) is not in this repo.

**Other**
17. `core` module: the repository and usecase exist, but no routes are registered.
18. Redis is configured but disabled.
19. `ISV_ENDPOINT_GET_POLICY` and `leadRepository.DecryptLeadNo` are unused.
