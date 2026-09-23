# go-echo-internal-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-internal-service` (local working tree, read-only inspection, 2026-09-23).
> Everything below comes from the route registration code and the code it calls. Items that could not be confirmed are marked "⚠️ unverified".

## Overview

| Item | Value |
|---|---|
| Purpose | An internal back-office endpoint that manually marks a PENDING payment (policy `P...` or act `A...`) as successful. It builds a 2C2P-style success payload, signs it as an HS256 JWT and forwards it to the ISV purchase callback on go-e-api. |
| Framework | Go, Echo v4 (`github.com/labstack/echo/v4`), `sqlx` + `lib/pq`, `go-playground/validator` |
| Port | `HTTP_PORT` (default `8080`). Dockerfile `EXPOSE 8080`. Helm Service type NodePort, port 8080. |
| Base path | `/api/v1/internal` (`router/router.go:17`) |
| Health | `GET /healthcheck` (liveness/readiness probe path in helm) |
| Database | PostgreSQL, schema `insurverse` (via `DATABASE_SEARCH_PATH`). The connection is skipped when `ENV == "LOCAL"` (`main.go:57`). |
| Background jobs | None. No cron, queue consumer or scheduler is started. |

### Environment variables (names only)

Read in `configs/config.go`:

| Group | Variables |
|---|---|
| Runtime | `ENV`, `TZ`, `HTTP_PORT` |
| DB | `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME`, `DATABASE_SEARCH_PATH` |
| ISV callback | `ISV_HOST`, `ISV_ENDPOINT_CALLBACK` (default `/api/v1/purchase/callback`), `ISV_COOKIE_TOKEN` (read but not used by any route), `PAYMENT_SECRET_KEY` (HS256 signing key) |
| HTTP client | `APP_CLIENT_TIMEOUT` (default `90s`) |
| Basic auth | `BASIC_AUTH_USERNAME`, `BASIC_AUTH_PASSWORD`, `BASIC_AUTH_PARTNER_CODE` |
| Read but unused by routes | `JWT_SECRET_KEY`, `JWT_EXPIRATION_HOURS`, `Base_Url`, `Backend_Doc`, `Backend_Auth`, `Backend_Core`, `Backend_File`, `Backend_Notification`, `Backend_Purchase`, `Backend_Consent`, `Backend_Premium`, `Backend_Saleforce`, `Backend_Uam`, `Backend_Analytics`, `Url_Fontend`, `GCS_BUCKET`, `KEY_AES256`, `IV_AES256` |

### External and outbound calls

| Target | Method / URL | Used by |
|---|---|---|
| go-e-api (ISV purchase callback) | `POST {ISV_HOST}{ISV_ENDPOINT_CALLBACK}` with body `{"payload":"<JWT>"}` | `POST /api/v1/internal/payment/success` |

The HTTP client (`utils/http_client.go:19`) uses `InsecureSkipVerify: true`, which turns off TLS certificate checks.

## Auth & Middleware

Global middleware (`main.go:50-53`), in order:
1. `middleware.Recover()`
2. `middleware.CORS()` with the default config, which allows all origins
3. `middleware.Logger()`
4. `middlewares.LoggingMiddleware` (structured request logging, `middlewares/logging_middleware.go:13`)

Route middleware:
- `middlewares.AuthMiddleware` (`middlewares/auth_middleware.go:12`) checks HTTP Basic Auth.
  - A missing `Authorization` header returns `401 "Missing Authorization header"`.
  - A header without the `Basic ` prefix returns `401 "Invalid Authorization header format. Expected Basic Auth"`.
  - Bad base64 or no `:` returns `401 "Invalid Basic Auth format"`.
  - A username or password that does not match `BASIC_AUTH_USERNAME` / `BASIC_AUTH_PASSWORD` returns `401 "Invalid credentials"`.
  - On success it sets `c.Set("partnerCode", BASIC_AUTH_PARTNER_CODE or username)`. The handler does not read this value.
- `RequireAuth` and `ValidatePartnerCode` are defined but not registered on any route.

Echo's default HTTP error body is `{"message": ...}`. When the handler passes a `models.Response` into `echo.NewHTTPError`, that object is serialized as the `message` value (see error examples below).

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | `main.go:28` (`healthcheck`) | Liveness check that returns status, version and time |
| POST | `/api/v1/internal/payment/success` | Basic Auth | `controllers/payment_controller.go:42` (`PaymentController.Success`), registered at `router/router.go:21` | Manually marks a PENDING payment as successful and forwards a signed success callback to the ISV purchase callback |

Total: 2 routes (1 business endpoint and 1 health check).

## Endpoints

### GET /healthcheck

- **Purpose:** liveness and readiness probe.
- **Auth:** none.
- **Success 200:**
```json
{ "message": "Service is running", "status": "OK", "version": "1.0.0", "time": "2026-09-23T04:00:00Z" }
```
- **DB / outbound calls:** none. It does not ping the DB. `webserver.HealthCheckDB()` exists but is not wired to any route.

### POST /api/v1/internal/payment/success

- **Purpose:** force a payment into the success state without a real 2C2P callback, for manual or ops recovery. Flow (`controllers/payment_controller.go`):
  1. Bind and validate the body (`:46-65`).
  2. `validateSuccess` (`:126`) picks the lookup query from the first character of `invoiceNo`:
     - `P` means a policy: `webserver.GetValidatePaymentInvoice` (`webserver/dbConnect.go:62`).
     - `A` means an act (CMI): `webserver.GetValidatePaymentInvoiceAct` (`webserver/dbConnect.go:86`).
     - Any other prefix returns 400.
     - The row's `payment_status` must equal `PENDING`, otherwise 400.
  3. `prepareSuccessData` (`:159`) builds the 2C2P-like success payload:
     - Hardcoded values: `merchantID`, `currencyCode=THB`, `paymentChannel=["CC"]`, `respCode="0000"`, `respDesc="Success"`, `isManualUpdate=true`.
     - `transactionDateTime` is the current UTC time in `yyyyMMddHHmmss`.
     - `userDefined1` is the lead no, `userDefined2` is `POLICY` or `ACT`, `userDefined3` is the email.
     - `ref1..3` come from the payment row. `updatedManualBy` is the lead's `partner_code`.
  4. `encryptPaymentData` (`:204`) creates an HS256 JWT (`header.payload.signature`) signed with `PAYMENT_SECRET_KEY`.
  5. `PaymentRepository.SuccessPayment` (`:259`) sends `POST {ISV_HOST}{ISV_ENDPOINT_CALLBACK}`.
- **Headers:** `Authorization: Basic base64(username:password)`, `Content-Type: application/json`.
- **Path/query params:** none.

**Request body**
```json
{ "invoiceNo": "P2026092300001" }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `invoiceNo` | string | yes | `validate:"required"`. It must start with `P` (policy) or `A` (act). The row must exist and have `payment_status = 'PENDING'`. |

**Payload sent to the ISV callback** (JWT claims, `models.SuccessPaymentprepareInternalRequest`):
```json
{
  "merchantID": "<hardcoded>", "invoiceNo": "P2026092300001", "description": "...", "amount": 7200.00,
  "currencyCode": "THB", "paymentChannel": ["CC"], "installmentPeriodFilter": [],
  "frontendReturnUrl": "", "backendReturnUrl": "",
  "userDefined1": "<Lead_No>", "userDefined2": "POLICY", "userDefined3": "<email>",
  "uiParams": { "userInfo": { "mobileNoPrefix": "66" } },
  "respCode": "0000", "respDesc": "Success", "transactionDateTime": "20260923040000",
  "ref1": "", "ref2": "", "ref3": "", "isManualUpdate": true, "updatedManualBy": "<partner_code>"
}
```
Wire body: `{"payload": "<base64url(header)>.<base64url(claims)>.<signature>"}`.

**Success 200** (ISV returned 200 with a body; `status.code` is taken from the ISV `code`):
```json
{
  "status": { "code": 200, "header": "Success", "description": "<isv message>" },
  "data": { "result": true, "code": 200, "message": "<isv message>" }
}
```
Variants that also return **HTTP 200**:
- ISV returned an empty body: `data.message = "Payment success callback processed"`.
- **The ISV call failed** (network error): `data.message = "Local server connection failed, but payment processed"`.
- **ISV returned a non-200 status**: `data.message = "Payment processed locally. External service failed with status=<n>"`, `data.warning = "External service unavailable"`.

**Error responses**

| HTTP | When | Body (Echo default) |
|---|---|---|
| 401 | Basic Auth missing or invalid | `{"message":"Missing Authorization header"}` (or another auth message) |
| 400 | The body cannot be bound | `{"message":{"status":{"code":400,"header":"Request Validation Error","description":"Invalid request body format"},"data":null}}` |
| 400 | `invoiceNo` is missing | Same shape, `description` = validator error text |
| 500 | Any use-case error, including bad prefix, not found or non-PENDING status (see note) | `{"message":{"status":{"code":500,"header":"Internal Server Error","description":"code=400, message=..."},"data":null}}` |
| 500 | The ISV 200 body is not valid JSON | Same wrapper, `description` "...Failed to parse response" |

- **DB tables (read only; the service itself writes nothing):**
  - Policy (`P`): `insurverse.payment` joined to `insurverse."Lead_coverage_premium"` on `payment.lead_no = "Lead_No"`. Columns read: `invoice_no, payment_status, description, amount, payment_channel, installment_period, url, ref1, ref2, ref3`, and `partner_code, "Lead_No", "Email"`.
  - Act (`A`): `insurverse.payment_act` joined to `insurverse."Lead_Car_Act_Discount_Premium"` on `payment_act.act_no = "Car_Act_Lead_No"`. The same payment columns are read, plus `partner_code, "Car_Act_Lead_No", email`.
- **Stored functions:** none are called directly. Any state change, such as issuing the policy or updating the payment, happens downstream in the go-e-api purchase callback. That part is out of scope here and ⚠️ unverified.
- **Outbound calls:** `POST {ISV_HOST}{ISV_ENDPOINT_CALLBACK}`.

## DB Usage

| Table / function | Read / write | Endpoints |
|---|---|---|
| `insurverse.payment` | read | `POST /api/v1/internal/payment/success` (invoice `P...`) |
| `insurverse."Lead_coverage_premium"` | read | `POST /api/v1/internal/payment/success` (invoice `P...`) |
| `insurverse.payment_act` | read | `POST /api/v1/internal/payment/success` (invoice `A...`) |
| `insurverse."Lead_Car_Act_Discount_Premium"` | read | `POST /api/v1/internal/payment/success` (invoice `A...`) |
| Stored functions | none | — |

`controllers/crud.go` has generic `Create`, `Read` and `Update` helpers using `NamedQuery`, but no route calls them.

## Notes / ⚠️ unverified items

1. **The env var names do not match helm.** The code reads `DB_HOST/DB_PORT/DB_USER/DB_PASS/DB_NAME`, but `helm/helm-uat-isv.yaml` sets `DATABASE_HOST/DATABASE_PORT/DATABASE_USER/DATABASE_PASSWORD/DATABASE_NAME`. The deployed pod would therefore fall back to the defaults hardcoded in `configs/config.go`. ⚠️ Confirm which DB the running pod actually uses.
2. **Hardcoded secret defaults** in `configs/config.go`: DB password, `PAYMENT_SECRET_KEY`, `ISV_COOKIE_TOKEN` and the Basic Auth credentials. `BASIC_AUTH_*` is not set in the uat-isv helm file, so the default credentials from the source apply. The values are deliberately left out of this doc. Rotate them and remove the defaults.
3. **Errors map to the wrong status.** Business-rule 400 errors (unknown prefix, not found, status not PENDING) are created with `echo.NewHTTPError(400, ...)` inside the use case, but the controller wraps them in a 500 (`payment_controller.go:72-79`). Clients see HTTP 500 with the 400 text inside `description`.
4. **Failures are reported as success.** A failed ISV callback (network error or non-200) is still returned as HTTP 200 "processed", even though this service writes nothing to the DB itself. The payment may still be PENDING.
5. The `merchantID` is hardcoded in `payment_controller.go:173`.
6. `InsecureSkipVerify: true` is set on the outbound HTTP client.
7. The `partnerCode` from the auth context is ignored. `updatedManualBy` uses the lead's `partner_code` from the DB instead.
8. Swagger annotations exist on the handler, but no swagger route is registered and there is no `docs/` package.
