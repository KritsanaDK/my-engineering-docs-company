# go-echo-core-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-core-service` (Go module `insurverse_core`).
> Derived from the route registration in `router/router.go` plus the handler code. `docs/docs.go` (Swagger) was used only as a hint. It is stale: it lists `/api/v1/core/all`, but the route is actually `/api/v1/core/get-all`, and it documents only 13 of the 32 routes.
> Generated 2026-09-23. Read-only analysis: no code was run.

---

## Overview (ภาพรวม)

| Item | Value |
|---|---|
| Purpose | Core/master-data service for Insurverse: car brand/model/year master data, address JSON, car-color and occupation lists, the WordPress menu, car-inspection photo submission, email confirmation of policies (MV/CMI/TA/PA/Home), "my policy" lookup and the daily reconcile report email. |
| Framework | Echo v4 (`github.com/labstack/echo/v4`), sqlx + lib/pq (Postgres), database/sql + go-sql-driver/mysql (MySQL), `cloud.google.com/go/storage` (GCS), `go-playground/validator` (v9 import path `github.com/go-playground/validator`) |
| Port | `HTTP_PORT` env (default `9100` in code). In Helm and the Dockerfile the container port is `8080`. |
| Public base path | `/api/v1/core/` (from `constants`: `API="api/"`, `Version="v1/"`, `Service="core/"`) |
| Internal base path | `/internal/core/` |
| Health | `GET /healthcheck` → `200 text/plain "OK"` (used by Helm liveness/readiness probes) |
| Swagger UI | `GET /api/v1/core/swagger/*` |
| Global middleware | `middleware.CORS()` (default config: all origins). There is **no** Recover or Logger middleware. |
| Validator | `CustomValidator`. On failure it returns HTTP 400 with body `{"result":false,"code":400,"message":"required: <StructField>[ , ...]"}` |

### Environment variables (names only)

| Name | Used in | Required by `CheckEnvReady` |
|---|---|---|
| `ENV` | env check; `LOCAL` or empty loads `local.env`; report file names and recipient selection (`DEV`/`UAT`/`PROD`) | yes |
| `HTTP_PORT` | listen port | yes |
| `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME` | Postgres connection (`config/db.go`) | yes |
| `DB_HOST_MYSQL`, `DB_PORT_MYSQL`, `DB_USER_MYSQL`, `DB_PASS_MYSQL`, `DB_NAME_MYSQL` | MySQL (WordPress) connection | no (but startup panics if MySQL ping fails) |
| `GCS_BUCKET` | GCS bucket name (`config/filemanagment.go`) | yes |
| `ENC_KEY`, `IV` | AES-CBC encryption of `Lead_No` in get-policy responses (`utils.LeadNoEncrypt`) | no |
| `Backend_Notification` | base URL of the notification service (`<Backend_Notification>email`) | no |
| `Backend_Uam` | base URL of the UAM/Salesforce bridge (`<Backend_Uam>policy_attachment_more`, `<Backend_Uam>create_policy_pure`) | no (⚠️ missing from `local.env`) |

GCS credentials come from the file `key.json` in the working directory (`option.WithCredentialsFile("key.json")`). The Helm charts also inject other `Backend_*`, `Base_Url` and `Url_Fontend` vars, but this service's code does not read them.

### External and third-party calls

| Call | Method / URL | Triggered by | Sync? |
|---|---|---|---|
| Notification service (email) | `POST {Backend_Notification}email` | `GET /report-email` | sync; success only if response `title == "Success"` |
| UAM → Salesforce attachment | `POST {Backend_Uam}policy_attachment_more` body `{"id":"<policyNo>"}` | `POST /submit-car-inspection` | async goroutine, fire-and-forget |
| UAM → Salesforce policy pure | `POST {Backend_Uam}create_policy_pure` body `{"id":"<policyNo>"}` | `POST /submit-car-inspection` | async goroutine, fire-and-forget |
| Google Cloud Storage | bucket `GCS_BUCKET`, objects `carmodel/carmodel.json`, `address/province.json` | `/get-all`, `/get-address-all`, `/update-carmodel-file` | sync |
| MySQL (WordPress DB) | tables `wp_posts`, `wp_postmeta`, `wp_users` | `/get-menu` | sync |

### Standard response envelope (`utils.Response`)

```json
{ "result": true, "code": 200, "message": "Success", "data": {} }
```
`data` is omitted when empty. Paginated endpoints put `utils.PaginationData` in `data`:
```json
{ "currentPage": 1, "limit": 10, "totalPage": 3, "totalData": 25, "dataCount": 10, "data": [] }
```
Note: the HTTP status and the body `code` do not always match. Each endpoint below lists the mismatches.

---

## Auth & Middleware (การยืนยันตัวตน)

| Scope | Middleware |
|---|---|
| All routes | `middleware.CORS()` (default, `*` origins) |
| `GET /api/v1/core/get-policy` only | `middlewares.ValidateToken` (route-level) |
| All other routes (including `/internal/core/get-policy`) | **none (public)** |

`ValidateToken` (`middlewares/auth.go`):
- It needs the header `Authorization: Bearer <JWT>` (`bearer` is also accepted). If the header is missing or malformed: `401 {"error":"Invalid token not found"}`.
- It verifies the token with HMAC (any HS* algorithm) using a **hard-coded shared secret in source**. The value is not reproduced here. On parse failure: `401 {"error":"Invalid token"}`.
- It checks `exp` manually. An expired token gets `401 {"error":"Token has expired"}`. A token with no `exp` claim causes a panic (`claims["exp"].(float64)`).
- It stores the claims in the **package-level global** `middlewares.JWTClaims`. The handler reads `JWTClaims["email"]`. See the notes on the race condition.

Internal route `/internal/core/get-policy` has no auth. It is assumed to be protected only by network or ingress rules (⚠️ unverified: no ingress rule for `/internal` was found in `helm/`).

---

## Endpoint Summary

Base `P` = `/api/v1/core`, `I` = `/internal/core`. File paths are relative to the repo root.

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | `router/router.go:73` `healthcheck` | Liveness: plain `OK` |
| 2 | GET | `P/swagger/*` | none | echo-swagger `WrapHandler` | Swagger UI (stale spec) |
| 3 | GET | `P/get-all` | none | `controllers/dataController.go:227` `GetCarAll` | Return cached car master JSON from GCS |
| 4 | GET | `P/get-address-all` | none | `controllers/dataController.go:279` `GetAddressAll` | Return province/address JSON from GCS (10-min memory cache) |
| 5 | GET | `P/update-carmodel-file` | none | `controllers/dataController.go:59` `UpdateFileModel` | Rebuild car master JSON from DB and upload it to GCS (**write**) |
| 6 | GET | `P/get-brand-top` | none | `controllers/dataController.go:314` `GetCarBrandsTop` | Static top-6 brands |
| 7 | GET | `P/get-brand` | none | `controllers/dataController.go:333` `GetCarBrands` | Paginated brand search |
| 8 | GET | `P/get-model-top` | none | `controllers/dataController.go:423` `GetCarModelsTop` | Up to 6 models for a brand |
| 9 | GET | `P/get-model` | none | `controllers/dataController.go:479` `GetCarModels` | Paginated model search for a brand |
| 10 | GET | `P/get-years` | none | `controllers/dataController.go:566` `GetYearAndDetail` | Years for brand+model |
| 11 | GET | `P/get-car-color` | none | `controllers/dataController.go:621` `GetCarColor` | Car color master |
| 12 | GET | `P/get-menu` | none | `controllers/dataController.go:2553` `GetMenu` | WordPress nav menu (MySQL) |
| 13 | GET | `P/check-car-inspection` | none | `controllers/carInspectionController.go:62` `CheckCarInspection` | Which inspection photos are required for a policy |
| 14 | POST | `P/submit-car-inspection` | none | `controllers/carInspectionController.go:188` `SubmitCarInspection` | Save inspection photo URLs, update the inspect status, notify UAM (**write**) |
| 15 | GET | `P/auto-complete-car-inspection` | none | `controllers/carInspectionController.go:561` `AutoCompleteCarInspection` | Mark inspection success for non-type-1 policies (**write**) |
| 16 | GET | `P/get-policy` | JWT | `controllers/policyController.go:25` `GetPolicyByLead` | My policies for the JWT email (`fn_policy_my_policy`) |
| 17 | GET | `I/get-policy` | none (internal) | `controllers/policyController.go:160` `GetPolicyByLeadInternal` | My policies by `email` query |
| 18 | GET | `P/load-policy-info` | none | `controllers/dataController.go:646` `LoadPolicyConfirmEmail` | Load MV policy info for the email-confirm page |
| 19 | GET | `P/load-caract-info` | none | `controllers/dataController.go:769` `LoadCarActConfirmEmail` | Load CMI (พ.ร.บ.) info for the email-confirm page |
| 20 | GET | `P/confirm-policy` | none | `controllers/dataController.go:858` `ConfirmPolicy` | Confirm the MV policy (and its CMI) by email (**write**) |
| 21 | GET | `P/confirm-caract` | none | `controllers/dataController.go:950` `ConfirmCarAct` | Confirm the CMI by email (**write**) |
| 22 | GET | `P/load-ta-info` | none | `controllers/dataController.go:1025` `LoadTAConfirmEmail` | Load TA policy info for confirmation |
| 23 | GET | `P/confirm-ta` | none | `controllers/dataController.go:1111` `ConfirmTA` | Confirm the TA policy (**write**) |
| 24 | GET | `P/load-pa-info` | none | `controllers/dataController.go:1192` `LoadPAConfirmEmail` | Load PA policy info for confirmation |
| 25 | GET | `P/confirm-pa` | none | `controllers/dataController.go:1285` `ConfirmPA` | Confirm the PA policy (**write**) |
| 26 | GET | `P/load-home-info` | none | `controllers/dataController.go:1370` `LoadHomeConfirmEmail` | Load Home policy info for confirmation |
| 27 | GET | `P/confirm-home` | none | `controllers/dataController.go:1463` `ConfirmHome` | Confirm the Home policy (**write**) |
| 28 | GET | `P/check-encrypt` | none | `controllers/dataController.go:1548` `EncryptAES` | AES-ECB encrypt a 16-char text (debug utility) |
| 29 | GET | `P/check-decrypt` | none | `controllers/dataController.go:1579` `DecryptAES` | AES-ECB decrypt hex text (debug utility) |
| 30 | GET | `P/report-email` | none | `controllers/dataController.go:1613` `SendReport` | Build yesterday's reconcile XLSX files and email them via the notification service |
| 31 | GET | `P/get-pwa-occupation` | none | `controllers/dataController.go:2686` `GetOccupation` | Occupation list for WPA (`sys_param`) |

**Total: 31 routes**, all registered in `router/router.go` lines 20–69: 29 business endpoints plus healthcheck and swagger.

---

## Endpoints

Common error behaviour for handlers that use `c.Bind` + `c.Validate`:
- Bind error: Echo default `400 {"message":"..."}`.
- Validation error: `400 {"result":false,"code":400,"message":"required: <Field>"}`.

### 1. GET `/healthcheck`
- Response `200 text/plain`: `OK`. No DB access.

### 2. GET `/api/v1/core/swagger/*`
- Serves Swagger UI from the generated `docs/docs.go`. ⚠️ The spec is stale and incomplete (see the Notes section).

### 3. GET `/api/v1/core/get-all` — Car master bundle (ข้อมูลรถทั้งหมด)
- **Purpose:** streams the GCS object `carmodel/carmodel.json` exactly as stored. `/update-carmodel-file` produces this object.
- **Params:** none.
- **Success 200** (`application/json`, the stored file content):
```json
{
  "result": true, "code": 200, "message": "Load car data success",
  "data": {
    "brandTop": ["Toyota","Honda","Mazda","Nissan","Isuzu","Mitsubishi"],
    "brandAll": ["Honda","Toyota"],
    "modelAll": {
      "Toyota": [ { "model": "YARIS", "doors": 4, "sedan": "SEDAN",
                    "years": [ { "year": "2024", "cc": ["1200"] } ] } ]
    }
  }
}
```
- **Errors** (HTTP **200** with `code: 400` in the body): `"Cannot load Carmodel"` (object read error), `"Data Invalid"` (read failure).
- **DB:** none. **Storage:** GCS read `carmodel/carmodel.json`.

### 4. GET `/api/v1/core/get-address-all` — Address master (ข้อมูลที่อยู่)
- **Purpose:** returns GCS `address/province.json` exactly as stored. The result is cached in process memory for 10 minutes.
- **Params:** none.
- **Success 200:** raw JSON from the file. ⚠️ Its schema is not defined in code. A local `province.json` exists in the repo root, but it is unverified whether it matches the GCS file.
- **Errors** (HTTP **200**, `code: 400`): `"Cannot load province data"`, `"Data Invalid"`.
- **DB:** none. **Storage:** GCS read `address/province.json`.

### 5. GET `/api/v1/core/update-carmodel-file` — Rebuild car master file (**mutating GET**)
- **Purpose:** queries every active brand/model/year/CC from the DB, builds the payload shown for `/get-all`, and uploads it to GCS `carmodel/carmodel.json` (`Content-Type: application/json`, `Cache-Control: no-cache, no-store, max-age=0`). It also sets the **bucket default object ACL to `allUsers: READER`**.
- **Params:** none. **Auth:** none.
- **Success 200:** the same body as `/get-all` (`message: "Load car data success"`).
- **Errors:** `500 {"result":false,"code":500,"message":"Get brand error"}` or `"Get model error"`. On a GCS write or close failure the handler returns a Go error, which Echo turns into `500 {"message":"Internal Server Error"}`.
- **DB tables (read):** `insurverse."Imp_Price_Premium"` (`Brand`, `Model`, `Doors`, `Sedan`, `Year`, `CC`, `is_active`), `insurverse."mas_cmi_brand_model"` (`brand_name`).
- **Storage:** GCS write `carmodel/carmodel.json`, plus the bucket ACL change.

### 6. GET `/api/v1/core/get-brand-top`
- **Purpose:** returns a hard-coded list of 6 brands.
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "Load car brand top6 success",
  "data": ["Toyota","Honda","Mazda","Nissan","Isuzu","Mitsubishi"] }
```
- **DB:** none.

### 7. GET `/api/v1/core/get-brand` — Brand search (paginated)
- **Query** (`dto.GetCarBrandDTO`):

| Name | Type | Required | Validation / notes |
|---|---|---|---|
| `page` | int | yes | `required` (0 fails validation) |
| `limit` | int | yes | `required`. Used as a divisor, so 0 fails validation. |
| `search` | string | no | prefix match, case-insensitive (`LIKE search%`) |

- **Example:** `GET /api/v1/core/get-brand?page=1&limit=10&search=to`
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "Load car brand success",
  "data": { "currentPage": 1, "limit": 10, "totalPage": 1, "totalData": 1, "dataCount": 1, "data": ["Toyota"] } }
```
- **Errors:** `400 {"result":false,"code":400,"message":"Get car brand fail"}`, plus validation 400.
- **DB (read):** `insurverse."Imp_Price_Premium"`, `insurverse."mas_cmi_brand_model"` (`brand_name`, `model_name`).

### 8. GET `/api/v1/core/get-model-top`
- **Query** (`dto.GetCarModelTopDTO`): `brand` string, **required**.
- **Success 200:** `data` is an array of `{ "model": "YARIS", "doors": 4, "sedan": "SEDAN" }` with at most 6 items (`message: "Load car model success"`).
- **Errors:** `400 "Get car model fail"`, plus validation 400.
- **DB (read):** `Imp_Price_Premium`, `mas_cmi_brand_model`.

### 9. GET `/api/v1/core/get-model` — Model search (paginated)
- **Query** (`dto.GetCarModelDTO`):

| Name | Type | Required | Notes |
|---|---|---|---|
| `brand` | string | yes | exact match, case-insensitive |
| `page` | int | yes | `required` |
| `limit` | int | yes | `required` |
| `search` | string | no | substring match (`LIKE %search%`) on the model |

- **Success 200:** a `PaginationData` whose `data` is `[{ "model": "...", "doors": 4, "sedan": "..." }]` (`message: "load car model success"`).
- **Errors:** `400 "Get car model fail"`, plus validation 400.
- **DB (read):** `Imp_Price_Premium`, `mas_cmi_brand_model`.

### 10. GET `/api/v1/core/get-years`
- **Query** (`dto.GetYearListAndDetail`): `brand` string **required**, `model` string **required**. Both are matched exactly, case-insensitive.
- **Success 200:** `data` is an array of `models.CarPremiumEntity`. Only `brand`, `model` and `Year` are filled by the query. Every other field of the entity (for example `doors`, `si_1`, `prem_od_1`) is still serialized, as a zero value or null.
```json
{ "result": true, "code": 200, "message": "Load years and detail success",
  "data": [ { "brand": "Toyota", "model": "YARIS", "Year": "2024", "doors": 0, "seat": 0, "wg": null } ] }
```
- **Errors:** `400 "Get car year fail"`, `400 "Not found List"` (no rows), plus validation 400.
- **DB (read):** `Imp_Price_Premium`.

### 11. GET `/api/v1/core/get-car-color`
- **Success 200:** `data` is `[{ "color_id": "01", "color_name_th": "ขาว", "color_name_en": "White" }]` (`message: "Load car color success"`).
- **Errors:** `400 "Get car color fail"`.
- **DB (read):** `insurverse."mas_cmi_color"` (`SELECT *`, mapped to `color_id`, `color_name_th` and `color_name_en`).

### 12. GET `/api/v1/core/get-menu` — WordPress menu (MySQL)
- **Purpose:** reads the parent nav-menu items from WordPress, then runs a sub-query for the children of each parent.
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "",
  "data": [ { "menu_order": "1", "post_title": "Car Insurance",
              "sub_menu": [ { "post_title": "Class 1", "guid": "https://example.com/?p=1" } ] } ] }
```
- **Errors:** `500 {"code":500,"message":"Something wrong about query..."}` or `"Something wrong about append data..."`.
- **DB:** MySQL `wp_posts`, `wp_postmeta`, `wp_users` (read). No Postgres access.

### 13. GET `/api/v1/core/check-car-inspection` — Required inspection photos (ตรวจสภาพรถ)
- **Query** (`dto.GetPolicyNoDTO`): `policyNo` string **required**.
- **Logic:**
  - Policies with `Car_Inspect_Status = "success"` are rejected.
  - A policy with `Type != "1"` gets `"no need to inspect"`, unless its status is `access_modify`.
  - `Type = "1"` requires the body photos `IMG_CAR_FRONT/BACK/LEFT/RIGHT`. They are not required when the status is `access_modify`.
  - `Flag_CCTV = 'Y'` adds `IMG_CAR_CAMERA`.
  - `Flag_Access = 'Y'` maps the codes in the JSON array `Access_para_code` (skirt, pipe, wheel, carry_boy, gas) to `IMG_ACCESS_SKIRT/PIPE/WHEEL/CARRYBOY/GAS`. When the status is `access_modify`, it asks only for accessories that have no photos yet under `ref_policy_no` in `Policy_Regis_Evident`.
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "OK",
  "data": { "policyNo": "TEST-POLICY-0001",
            "carDetail": { "brand": "Toyota", "model": "YARIS", "year": "2024", "carLicenseNo": "1กข1234" },
            "inspectionCarBodyRequire": true,
            "inspectionCarBodyKey": ["IMG_CAR_FRONT","IMG_CAR_BACK","IMG_CAR_LEFT","IMG_CAR_RIGHT"],
            "inspectionCarCCTVRequire": false, "inspectionCarCCTVKey": [],
            "inspectionCarAccessRequire": true, "inspectionCarAccessKey": ["IMG_ACCESS_WHEEL"] } }
```
- **Errors:** `400 "not found policy_no"`, `400 "This policy has been inspected"`, `400 "This policy no need to inspect"`. On a bind error, `400` with the Echo error message.
- **DB (read):** `insurverse."Policy_coverage_premium"` (`Policy_No`, `Type`, `Flag_CCTV`, `Flag_Access`, `Access_para_code`, `Brand`, `Model`, `Year`, `Effective_Startdate`), `insurverse."Policy_Header"` (`Car_license_no`, `Car_Inspect_Status`, `ref_policy_no`), `insurverse."Policy_Regis_Evident"` (`Evi_Sector_ID`).

### 14. POST `/api/v1/core/submit-car-inspection` — Submit inspection photos (**write**)
- **Body** (`dto.SubmitCarInspectionDTO`, `application/json`):
```json
{ "policyNo": "TEST-POLICY-0001",
  "imgData": [
    { "key": "IMG_CAR_FRONT", "imgUrl": ["https://storage.example.com/insp/front1.jpg"] },
    { "key": "IMG_CAR_BACK",  "imgUrl": ["https://storage.example.com/insp/back1.jpg"] },
    { "key": "IMG_CAR_LEFT",  "imgUrl": ["https://storage.example.com/insp/left1.jpg"] },
    { "key": "IMG_CAR_RIGHT", "imgUrl": ["https://storage.example.com/insp/right1.jpg"] } ] }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `policyNo` | string | yes | `required` |
| `imgData` | array | yes | `required`. Nested items are **not** validated because there is no `dive` tag. |
| `imgData[].key` | string | (yes) | Must be one of the keys allowed for this policy (same rules as #13): `IMG_CAR_FRONT`, `IMG_CAR_BACK`, `IMG_CAR_LEFT`, `IMG_CAR_RIGHT`, `IMG_CAR_CAMERA`, `IMG_ACCESS_SKIRT`, `IMG_ACCESS_PIPE`, `IMG_ACCESS_WHEEL`, `IMG_ACCESS_CARRYBOY`, `IMG_ACCESS_GAS` |
| `imgData[].imgUrl` | string[] | (yes) | URLs of files that are already uploaded. This service does not upload files. |

- **Logic:**
  1. Run the same eligibility checks as #13.
  2. Reject unknown keys and any missing required key.
  3. Compute `Evi_ID` as `MAX("Evi_ID")+1` per policy.
  4. Bulk-insert one `Policy_Regis_Evident` row per URL. `Evi_Sector_ID` is one of `car_front`, `car_back`, `car_left`, `car_right`, `cctv`, `skirt`, `pipe`, `wheel`, `carry_boy`, `gas`. `Evi_type` is `image/jpg`.
  5. Update `Policy_Header` for the latest `Effective_Startdate` row: `Car_Inspect_Status='success'` and `Car_inspect_date=now`. When the status is `access_modify` and no body inspection exists yet, the handler writes an empty status and a NULL date instead.
  6. Start two async UAM calls.
- **Success 200:** `{"result":true,"code":200,"message":"Car Inspection Success!"}`
- **Errors:**
  - `400 "Not found policyNo"`, `400 "This policy has been inspected"`, `400 "This policy no need to inspect"`
  - `400 "Unknown key"` with `data: ["BAD_KEY"]`
  - `400 "Key missing "` with `data: ["IMG_CAR_LEFT"]`
  - `500 "Error while insert Policy_Regis_Evident"`
- **DB:**
  - Read: `Policy_coverage_premium`, `Policy_Header`, `Policy_Regis_Evident`.
  - **Write:** INSERT `Policy_Regis_Evident` (`Policy_No`, `Evi_ID`, `Evi_path`, `Create_date`, `Update_date`, `Evi_type`, `Evi_Sector_ID`, `Evi_isdel`); UPDATE `Policy_Header` (`Car_Inspect_Status`, `Car_inspect_date`).
- **Outbound:** `POST {Backend_Uam}policy_attachment_more` and `POST {Backend_Uam}create_policy_pure`, both with body `{"id":"<policyNo>"}`. They run as goroutines and their results are only logged.

### 15. GET `/api/v1/core/auto-complete-car-inspection` (**mutating GET**)
- **Query** (`dto.AutoCompleteInspectionDTO`): `policyNo` string **required**. It is also bindable from a JSON body.
- **Logic:** if `Policy_coverage_premium.Type != "1"`, set `Car_Inspect_Status='success'` and `Car_inspect_date=now` on the latest `Policy_Header` row.
- **Success 200:** `{"result":true,"code":200,"message":"[<policyNo>] Car Inspection SUCCESS"}`
- **Type 1:** HTTP **200** with `{"result":false,"code":400,"message":"[<policyNo>] This policy can't auto complete car inspection."}`
- **Not found:** HTTP **500** with `{"result":false,"code":400,"message":"Not found policyNo"}`. This includes the case where more than one row exists, because the handler uses `Get` on `SELECT *`.
- **DB:** read `Policy_coverage_premium` (`SELECT *`), **write** UPDATE `Policy_Header`.

### 16. GET `/api/v1/core/get-policy` — My policies (JWT) (กรมธรรม์ของฉัน)
- **Headers:** `Authorization: Bearer <JWT>`. The token must carry the claims `email` and `exp`.
- **Query:** `email` (declared in `dto.GetPolicyByEmailDTO`, but **ignored**: the email always comes from the JWT).
- **Logic:** runs `SELECT * FROM insurverse.fn_policy_my_policy($email)`. Columns are returned dynamically:
  - `[]byte` values are converted to float if numeric, otherwise to string.
  - Values in columns named `Lead_No` or `Car_Act_Lead_No` (case-insensitive) are replaced with AES-256-CBC hex ciphertext (`ENC_KEY`/`IV`).
- **Success 200** (the columns depend on the function. ⚠️ The column list could not be verified from code):
```json
{ "result": true, "code": 200, "message": "Get policy success",
  "data": [ { "Lead_No": "9f2c…(hex)", "Policy_No": "TEST-POLICY-0001", "Car_Act_Lead_No": null } ] }
```
- **Errors:**
  - Middleware 401s (see Auth).
  - `401 {"code":400,"message":"Unauthorized"}` when the claims are nil or `email` is missing.
  - `401 {"code":400,"message":"Bad Request"}` when the function call fails.
  - `400 "Not found policy"` when there are no rows.
  - `400 "Get car brand fail"` on a row iteration error (wrong message copied from another handler).
  - `500 "LeadNoEncrypt fail"`.
- **DB:** stored function `insurverse.fn_policy_my_policy(text)` (read). ⚠️ The tables it reads are internal to the function and were not inspected, because DB access is out of scope for this read-only task.

### 17. GET `/internal/core/get-policy` — My policies (internal, no auth)
- **Query** (`dto.GetPolicyByEmailInternalDTO`): `email` string **required**, e.g. `?email=test.user@example.com`.
- **Logic, response and DB:** the same as #16, except the email comes from the query string.
- **Errors:** validation 400, `400 "Not found policy"`, `400 "Get car brand fail"`. ⚠️ If the function call fails, `rows` is nil and the handler panics with a nil deref. `handlerReturn(...)` results are not returned, so execution continues after an error. There is no Recover middleware, so the connection drops.

### 18. GET `/api/v1/core/load-policy-info` — Load MV policy for email confirm (โหลดข้อมูลยืนยันกรมธรรม์)
- **Query** (`dto.ConfirmNoDTO`): `confirmNo` string. It has no `validate` tag, so the code does not enforce it. The value is the hex AES-128-ECB ciphertext of a 16-char `Policy_No` (see #28).
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "Load policy info success",
  "data": { "carDetail": { "carLicenseNo": "1กข1234", "carLicenseProvice": "กรุงเทพมหานคร", "redPlate": false },
            "policyInfo": { "policyNo": "TEST-POLICY-0001", "type": "1", "siAmount": 500000, "garageType": "G",
                            "ownerName": "กฤษณะ  วัฒนายนนต์", "policyStartdate": "2026-01-01T00:00:00Z", "policyEnddate": "2027-01-01T00:00:00Z" },
            "withCarAct": true,
            "carActInfo": { "carActNo": "TEST-ACT-0001", "ownerName": "กฤษณะ  วัฒนายนนต์",
                            "carActStartDate": "2026-01-01T00:00:00Z", "carActEndDate": "2027-01-01T00:00:00Z" } } }
```
- **Errors:** `400 "Not found data"` (decrypt error), `400 "Not found Policy"`, `400 "This policy has been confirmed"`.
- **DB (read):**
  - `insurverse."Policy_Header"`, `insurverse."province"`, `insurverse."Policy_coverage_premium"` (`Flag_Car_Act`, `GarageType`), `insurverse."Lead_coverage_premium"` (`SI_Limit`, `SI_Access_Limit`)
  - `insurverse."Policy_email_confirm"` (`Policy_No`, `flag_confirm`)
  - `insurverse."Policy_Car_Act_Discount_Premium"`, read when `Flag_Car_Act='Y'`

### 19. GET `/api/v1/core/load-caract-info` — Load CMI (พ.ร.บ.) for email confirm
- **Query:** `confirmNo` (encrypted `Car_Act_No`).
- **Success 200:** `data` has the form `{ "carDetail": {carLicenseNo, carLicenseProvice, redPlate}, "carActInfo": {carActNo, ownerName, carActStartDate, carActEndDate} }` (`message: "Load car act info success"`).
- **Errors:** `400 "Not found data"`, `400 "Not found Car Act"`, `400 "This car act has been confirmed"`.
- **DB (read):** `Policy_Car_Act_Discount_Premium`, `province`, `Policy_email_confirm` (`Car_Act_No`).

### 20. GET `/api/v1/core/confirm-policy` — Confirm MV policy (**mutating GET**)
- **Query:** `confirmNo` (encrypted `Policy_No`).
- **Logic:** runs the same lookup and "already confirmed" check as #18, then INSERTs a `Policy_email_confirm` row (`Policy_No`, `flag_confirm=true`, `confirm_at=now`). If `Flag_Car_Act='Y'`, it also INSERTs a row for `Car_Act_No`.
- **Success 200:** `{"result":true,"code":200,"message":"Confirm success"}`
- **Errors:** `400 "Not found data"`, `400 "Not found Policy"`, `400 "This policy has been confirmed"`. `MustExec` panics on a DB error.
- **DB:** read `Policy_Header`, `province`, `Policy_coverage_premium`, `Lead_coverage_premium`, `Policy_email_confirm`. **Write:** INSERT `Policy_email_confirm`.

### 21. GET `/api/v1/core/confirm-caract` — Confirm CMI (**mutating GET**)
- **Query:** `confirmNo` (encrypted `Car_Act_No`).
- **Success 200:** `"Confirm success"`.
- **Errors:** `400 "Not found data"`, `400 "Not found Car Act"`, `400 "This car act has been confirmed"`.
- **DB:** read `Policy_Car_Act_Discount_Premium`, `province`, `Policy_email_confirm`. **Write:** INSERT `Policy_email_confirm` (`Car_Act_No`, `flag_confirm`, `confirm_at`).

### 22. GET `/api/v1/core/load-ta-info` — Load TA (travel) for confirm
- **Query:** `confirmNo` (encrypted `policy_ta_no`).
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "Load policy info success",
  "data": { "policyInfo": { "policy_no": "TEST-TA-0001", "owner_title": "MR.", "owner_firstname": "KRITSANA",
                            "owner_lastname": "WATTHANIYANON", "policy_startdate": "2026-01-01T00:00:00Z",
                            "policy_enddate": "2026-01-10T00:00:00Z" } } }
```
- **Errors:** `400 "Not found data"`, `400 "Not found TA"`, `400 "This policy has been confirmed"`.
- **DB (read):** `insurverse.policy_ta_premium`, `insurverse."lead_ta_participant"` (English owner name columns), `Policy_email_confirm` (`policy_ta_no`). ⚠️ The query uses `Get` on a join with participants. A TA policy with more than one participant returns only the first row, and sqlx `Get` does not error on multiple rows.

### 23. GET `/api/v1/core/confirm-ta` (**mutating GET**)
- **Query:** `confirmNo`. **Success 200:** `"Confirm success"`.
- **Errors:** `400 "Not found data"`, which is used both for a decrypt error and for a not-found record, and `400 "This policy has been confirmed"`.
- **DB:** read `policy_ta_premium`, `lead_ta_participant`, `Policy_email_confirm`. **Write:** INSERT `Policy_email_confirm` (`policy_ta_no`, `flag_confirm`, `confirm_at`).

### 24. GET `/api/v1/core/load-pa-info` — Load PA for confirm
- **Query:** `confirmNo` (encrypted `policy_pa_no`).
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "Load policy info success",
  "data": { "policyInfo": { "policyNo": "TEST-PA-0001", "ownerTitle": "นาย", "ownerFirstname": "กฤษณะ", "ownerLastname": "วัฒนายนนต์",
                            "policyStartdateTh": "1 มกราคม 2569", "policyEnddateTh": "1 มกราคม 2570",
                            "policyStarttime": "00:00", "policyEndtime": "00:00",
                            "policyStartdateEn": "01/01/2026", "policyEnddateEn": "01/01/2027" } } }
```
The Thai date format shown comes from `fn_display_buddha_date` and is ⚠️ unverified.
- **Errors:** `400 "Not found data"`, `400 "Not found PA"`, `400 "This policy has been confirmed"`.
- **DB (read):** `insurverse."policy_pa_premium"`, `insurverse."lead_pa_participant"`, `Policy_email_confirm` (`policy_pa_no`). **Function:** `insurverse.fn_display_buddha_date(timestamp)`.

### 25. GET `/api/v1/core/confirm-pa` (**mutating GET**)
- **Query:** `confirmNo`. **Success 200:** `"Confirm success"`.
- **Errors:** `400 "Not found data"`, `400 "This policy has been confirmed"`.
- **DB:** read `policy_pa_premium`, `lead_pa_participant`, `Policy_email_confirm`, plus `fn_display_buddha_date`. **Write:** INSERT `Policy_email_confirm` (`policy_pa_no`, …).

### 26. GET `/api/v1/core/load-home-info` — Load Home for confirm
- **Query:** `confirmNo` (encrypted `policy_home_no`).
- **Success 200:** same shape as #24 (`dto.HomeInfo`).
- **Errors:** `400 "Not found data"`, `400 "Not found HOME"`, `400 "This policy has been confirmed"`.
- **DB (read):** `insurverse."policy_home_premium"`, `insurverse."lead_home_participant"`, `Policy_email_confirm` (`policy_home_no`), plus `fn_display_buddha_date`.

### 27. GET `/api/v1/core/confirm-home` (**mutating GET**)
- **Query:** `confirmNo`. **Success 200:** `"Confirm success"`.
- **Errors:** `400 "Not found data"`, `400 "This policy has been confirmed"`.
- **DB:** read `policy_home_premium`, `lead_home_participant`, `Policy_email_confirm`, plus `fn_display_buddha_date`. **Write:** INSERT `Policy_email_confirm` (`policy_home_no`, …).

### 28. GET `/api/v1/core/check-encrypt` — Debug encrypt (⚠️ public)
- **Query** (`dto.TextDTO`): `text` string, **required**, and **exactly 16 characters** (bytes).
- **Logic:** AES-128-ECB with PKCS7 padding and a **hard-coded key in source**. Output is hex. This produces the `confirmNo` used by #18–#27.
- **Success 200:** `{"result":true,"code":200,"message":"Encrypt success","data":"<hex>"}`
- **Errors:** `400 "Encrypt failed"` (length != 16), plus validation 400. **DB:** none.

### 29. GET `/api/v1/core/check-decrypt` — Debug decrypt (⚠️ public)
- **Query:** `text` string (hex), **required**.
- **Success 200:** `{"result":true,"code":200,"message":"Decrypt success","data":"<plaintext>"}`
- **Errors:** `400 "Decrypt failed"` (invalid hex). ⚠️ Ciphertext that is not a multiple of 16 bytes, or has invalid padding, can panic inside `CryptBlocks` or `unpadPlaintext`. **DB:** none.

### 30. GET `/api/v1/core/report-email` — Daily reconcile report email (**side-effecting GET**)
- **Purpose:** probably triggered by a cron or scheduler (⚠️ the trigger is not in this repo). It builds two XLSX files for **yesterday** (Bangkok time, `now()+7h-1day`):
  1. `<ENV>_Policy_reconcile_report_YYYYMMDD.xlsx`: a union of MV-only leads, MV+CMI and CMI-only leads with payment but no policy, MV/CMI policies, transaction (`_Trans`) tables, and TA/PA/Home policies.
  2. `<ENV>_Endorse_reconcile_report_YYYYMMDD.xlsx`: rows from `Policy_endorse_detail`.
  
  It then POSTs both files as base64 data-URIs to the notification service. Recipients are hard-coded per `ENV` (DEV/UAT/PROD) plus an "ALL" list. The addresses are in source code and are not reproduced here.
- **Params:** none.
- **Outbound request body** (to `{Backend_Notification}email`):
```json
{ "sender": "epolicy", "subject": "[Insurverse] UAT Reconcile report 22/09/2026",
  "content": "<html>…</html>", "email": ["recipient@example.com"],
  "attach": [ { "filename": "uat_Policy_reconcile_report_20260922.xlsx", "filebase64": "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,…" },
              { "filename": "uat_Endorse_reconcile_report_20260922.xlsx", "filebase64": "data:…" } ] }
```
- **Success 200:** `{"result":true,"code":200,"message":"Send Email Success"}`
- **Errors:**
  - `400 "[Err] Report Policy Reconcile"` or `400 "[Err] Report Endorse Reconcile"`
  - `500 "[Err] Create Data Sheet"` or `500 "[Err] Create Buffer"` (body `code:400`)
  - `400 "[Err] While connect Notification"`: transport error, or the response `title` is not `"Success"`
- **DB (read only):**
  - Lead and payment tables: `Lead_coverage_premium`, `payment`, `payment_act`, `payment_ta`, `payment_transaction`, `Imp_Discount_Premium`
  - MV/CMI policy tables: `Policy_Header`, `Policy_Header_Trans`, `Policy_coverage_premium`, `Policy_coverage_premium_Trans`, `Policy_Car_Act_Discount_Premium`, `Policy_Car_Act_Discount_Premium_Trans`
  - TA/PA/Home tables: `policy_ta_premium`, `policy_ta_premium_trans`, `lead_ta_participant`, `mas_ta_package`, `policy_pa_premium`, `policy_pa_premium_trans`, `lead_pa_participant`, `lead_pa_participant_trans`, `mas_pa_package`, `policy_home_premium`, `policy_home_premium_trans`, `lead_home_participant`, `lead_home_participant_trans`, `mas_home_building_type`
  - Endorsements and address masters: `Policy_endorse_detail`, `province`, `district`, `subdistrict`
  - All tables are in schema `insurverse`.
- **Outbound:** `POST {Backend_Notification}email`.

### 31. GET `/api/v1/core/get-pwa-occupation` — Occupation list (อาชีพ)
- **Success 200:**
```json
{ "result": true, "code": 200, "message": "Success",
  "data": [ { "occupation_code": "001", "occupation_name": "พนักงานบริษัท", "occupation_name_en": "Office worker" } ] }
```
- **Errors:** `400 "[Err] occupationList"`.
- **DB (read):** `insurverse."sys_param"` (`para_code`, `para_name`, `para_name_en`, `dom_code='occupation'`, `sub_dom_code='occupation_wpa'`, `para_status='ATV'`).

---

## DB Usage

Postgres schema: `insurverse`. MySQL: the WordPress DB named by `DB_NAME_MYSQL`. No GORM is used: every query is raw SQL through sqlx or database/sql, and no `TableName()` exists.

| Table / function | R/W | Endpoints (#) |
|---|---|---|
| `Imp_Price_Premium` | R | 5, 7, 8, 9, 10 |
| `mas_cmi_brand_model` | R | 5, 7, 8, 9 |
| `mas_cmi_color` | R | 11 |
| `sys_param` | R | 31 |
| `Policy_coverage_premium` | R | 13, 14, 15, 18, 20, 30 |
| `Policy_Header` | R / **W (UPDATE `Car_Inspect_Status`, `Car_inspect_date`)** | R: 13, 18, 20, 30. W: 14, 15 |
| `Policy_Regis_Evident` | R / **W (INSERT)** | R: 13, 14. W: 14 |
| `Policy_email_confirm` | R / **W (INSERT)** | R: 18–27. W: 20, 21, 23, 25, 27 |
| `Lead_coverage_premium` | R | 18, 20, 30 |
| `province` | R | 18–21, 30 |
| `district`, `subdistrict` | R | 30 |
| `Policy_Car_Act_Discount_Premium` | R | 18, 19, 21, 30 |
| `policy_ta_premium`, `lead_ta_participant` | R | 22, 23, 30 |
| `policy_pa_premium`, `lead_pa_participant` | R | 24, 25, 30 |
| `policy_home_premium`, `lead_home_participant` | R | 26, 27, 30 |
| `Policy_Header_Trans`, `Policy_coverage_premium_Trans`, `Policy_Car_Act_Discount_Premium_Trans` | R | 30 |
| `policy_ta_premium_trans`, `policy_pa_premium_trans`, `lead_pa_participant_trans`, `policy_home_premium_trans`, `lead_home_participant_trans` | R | 30 |
| `payment`, `payment_act`, `payment_ta`, `payment_transaction` | R | 30 |
| `Imp_Discount_Premium`, `mas_ta_package`, `mas_pa_package`, `mas_home_building_type` | R | 30 |
| `Policy_endorse_detail` | R | 30 |
| **fn** `insurverse.fn_policy_my_policy(email)` | R (set-returning) | 16, 17 |
| **fn** `insurverse.fn_display_buddha_date(timestamp)` | R (scalar) | 24–27 |
| MySQL `wp_posts`, `wp_postmeta`, `wp_users` | R | 12 |
| GCS `carmodel/carmodel.json` | R / **W** | R: 3. W: 5 |
| GCS `address/province.json` | R | 4 |

No `CALL` procedures, advisory locks or sequences are used by this service.

---

## Notes / ⚠️ unverified items

**Spec and docs drift**
- The Swagger file `docs/docs.go` is stale. It documents `/api/v1/core/all`, but the real route is `/get-all`. It also omits the confirm/load, encrypt/decrypt, menu, occupation, address and internal routes.
- Helm and the Dockerfile use port 8080, while the code default is 9100. `HTTP_PORT` must be set.
- `Backend_Uam` is read by code but is missing from `local.env`, so local runs send the UAM calls to a relative URL and fail.

**Security**
- Secrets are hard-coded in source: the JWT HMAC key (`middlewares/auth.go`), the AES-ECB key (`helper/utils.go`), and a MySQL DSN with credentials in a comment in `config/db.go`. A GCS service-account file `key.json` is committed in the repo root. None of these values are reproduced here, and all of them should be rotated and moved to secrets.
- Almost every route is unauthenticated, including the mutating GETs (#5, #14, #15, #20–#27, #30) and the internal get-policy route (#17), which returns policy data for any email.
- `/check-encrypt` and `/check-decrypt` are public. Anyone can mint a valid `confirmNo` for any 16-char policy number and confirm it. AES-ECB is also weak.
- `/update-carmodel-file` sets the bucket's **default object ACL to public-read** (`allUsers`).

**Concurrency**
- `middlewares.JWTClaims` and `token` are package globals. Under concurrent requests, one user's email claims can be read by another request's handler (**race and data-leak risk**). The claims should be stored with `c.Set`.

**Crash and panic risks** (there is no Recover middleware)
- An empty or invalid `confirmNo` reaches `helper.DecryptAES` and can panic with an index out of range in `unpadPlaintext`.
- `MustExec` panics on DB errors (#20–#27).
- `CheckCarInspection` dereferences nullable pointers (`Brand`, `Model`, `Year`, `Car_license_no`), which can be NULL because of the LEFT JOIN.
- `GetPolicyByLeadInternal` uses `rows` when it is nil after a query error.
- `ConnectPolicyAttachmentMore` and `ConnectPolicyPure` call `response.Body.Close()` on a nil response when the POST fails. This is a panic inside a goroutine, so it **terminates the process**.
- A JWT with no `exp` claim panics in the middleware.

**Data integrity**
- `Evi_ID = MAX+1` is computed without a lock or transaction, so concurrent submits for the same policy can collide.
- The evidence INSERT and the `Policy_Header` UPDATE are not in one transaction.
- The `tx.NamedExec` UPDATE error is ignored.
- `ConfirmPolicy` inserts `Car_Act_No` in a second, separate transaction, and `defer tx.Rollback()` refers to the wrong tx.
- The "already confirmed" check (a SELECT via `NamedExec` plus `RowsAffected`) and the INSERT are not atomic, so duplicate confirmations are possible under concurrency. ⚠️ Whether a unique constraint on `Policy_email_confirm` prevents this is unverified.
- The `ConfirmNoDTO.confirmNo` and `GetPolicyByEmailDTO.email` fields have no `validate` tags, so `c.Validate` always passes for them.

**Status codes and resource leaks**
- Several handlers return an HTTP status that does not match the body `code`: #3, #4, #15 (200 or 500 with `code:400`) and #16 (401 with `code:400`).
- `GetMenu` never closes `rows_title` or `rows_sub`, which leaks MySQL connections.

**Not verified**
- The output columns of `fn_policy_my_policy`, the tables it reads, and the format of `fn_display_buddha_date` were not verified against the live DB, because this was a code-only, read-only review. Column names in this document come from SQL text in the code, not from `information_schema`.
- It is unverified which caller or scheduler triggers `/report-email`, `/update-carmodel-file` and `/auto-complete-car-inspection`.
- `controllers/dataController_test.go` contains only `TestGetMenu`, which needs a live MySQL connection.
