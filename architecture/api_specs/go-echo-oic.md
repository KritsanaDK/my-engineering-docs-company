# go-echo-oic — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-oic` (module `gitlab.devlab.dev/xsifi/insurverse/backend/go-echo-oic`). Read-only analysis, 2026-09-23.

## Overview

| Item | Value |
|---|---|
| Purpose | Skeleton/boilerplate Echo service meant for OIC (คปภ.) motor-premium calculation. The only HTTP route today is a health/ping `GET /`. The premium tariff calculation logic lives in `pkg/cal` as a library but is **not wired to any route**. |
| Language / framework | Go, Echo v4.11.4 (`github.com/labstack/echo/v4`), go-playground/validator v10, viper (config) |
| Entry point | `cmd/app/main.go` |
| Listen address | Hard-coded `:8080` (`cmd/app/main.go:46`). Config struct has `app.port.http` etc. but it is not read by `main.go`. |
| Base path | `/` (no prefix) |
| Graceful shutdown | SIGINT/SIGTERM, 10s timeout |
| Env var / config NAMES | Loader `infrastructures/config/config.go` (**not called from main**). Reads `configs/common.toml` + `configs/<name>.toml` (default `dev`), overridable by env via viper `AutomaticEnv` with `.`→`_`: `APP_ENV`, `APP_LISTEN`, `APP_DEBUG`, `APP_PORT_HTTP`, `APP_PORT_HTTPS`, `APP_PORT_GRPC`, `JWT_PRIVATE`, `JWT_PUBLIC`, `DB_MARIADB_{DRIVER,HOST,PORT,USERNAME,PASSWORD,DBNAME,SSLMODE,TIMEZONE}`, `DB_POSTGRES_{DRIVER,HOST,PORT,USERNAME,PASSWORD,DBNAME,SSLMODE,TIMEZONE}`, `DB_REDIS_{DRIVER,HOST,PORT,USERNAME,PASSWORD,DBNAME}` |
| External / third-party calls | None |
| Background jobs / queues | None |
| Build | `build/dockerfile` (golang:bookworm, `TZ=Asia/Bangkok`), `.air.toml` for live reload |

## Auth & Middleware

Registered in `cmd/app/main.go:20-35`:

| Middleware | Effect |
|---|---|
| `middleware.Logger()` | Access log |
| `middleware.Recover()` | Panic recovery |
| `middleware.Secure()` | Security headers (XSS, nosniff, X-Frame-Options) |
| `RequestIDWithConfig` | UUIDv4 request id (`presentations/middlewares/requestid.go`), stored in context key `request_id`, returned in `X-Request-Id` |
| `CustomJSONSerializer` | `presentations/middlewares/json.go` |
| `CustomHTTPErrorHandler` | `presentations/middlewares/http_error_handler.go` — JSend-style envelope |
| `CustomValidator` | `presentations/middlewares/validator.go` |

**Auth:** none. JWT key paths exist in config (`jwt.private` / `jwt.public`) but no JWT middleware is registered.

Standard error envelope (`presentations/common/response.go`):
```json
{ "code": 404, "status": "fail", "message": "code=404, message=Not Found" }
```
`status` = `success` | `fail` (4xx) | `error` (5xx/other).

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/` | None | inline closure, `cmd/app/main.go:37` | Ping; sleeps 5 s then returns `"OK"` |

Total: **1 endpoint**.

## Endpoints

### GET `/`
- **Purpose:** liveness/ping. Note: handler does `time.Sleep(5 * time.Second)` before replying — a probe with a timeout under 5 s will fail.
- **Params:** none. **Body:** none.
- **Success 200:**
```json
"OK"
```
- **Errors:** only generic (500 via Recover + custom handler).
- **DB:** none. **Outbound:** none.

## Library (not exposed): `pkg/cal` — premium calculation

Functions available for a future endpoint (all pure functions, no I/O):

| Function | File | Purpose |
|---|---|---|
| `CalBasic(data map[string]any) CalResult` | `pkg/cal/cal_basic.go:23` | Motor premium (basic) incl. fleet/NCB/other discount, CCTV discount, driver discount, duty, VAT |
| `CalPlus(data map[string]any) CalResult` | `pkg/cal/cal_plus.go:10` | "Plus" (type 2+/3+) premium using `sumAssured5` |
| `BasicBTFPremium`, `BasicBTFPremiumPlus` | `pkg/cal/cal_btf.go` | Back-to-front premium |
| `BasicFTBPremium`, `BasicFTBPremiumPlus` | `pkg/cal/cal_ftb.go` | Front-to-back premium |
| `TariffCalType1/2/3/5(data map[string]string)` | `pkg/cal/cal_type*.go` | OIC tariff tables per coverage type (constants in `const_type*.go`) |

Input keys used (all strings): `carUse`, `carSize`, `carAge`, `carGroup`, `NamedAge`, `sumAssured`, `sumAssured5`, `TPBI_P`, `TPPD`, `attachmentPremium`, `cctvPercen`, `isvCla`, `Type`.
Output `CalResult`: `Tariff`, `SumPremium`, `Fleet`, `NCB`, `Other`, `BasicPremium`, `CCTVDiscount`, `Duty`, `VAT`, `DriverDiscount`.

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| — | — | None. `infrastructures/gorm.go` is empty; `infrastructures/redis.go` only has a package line. DB configs (MariaDB, Postgres, Redis) are declared but never connected. |

## Notes / ⚠️ unverified items
- Service is a scaffold: config loader, DB configs, JWT config and `pkg/cal` are unused by `main.go`.
- `GET /` intentionally(?) sleeps 5 s — ⚠️ unverified whether this is deliberate (looks like a test leftover); risky as a k8s probe.
- `CustomValidator.Validate` always returns a non-nil `*echo.HTTPError` (400) even when validation passes (`validator.go:23`) — any future handler using `c.Validate()` would always fail. Bug to fix before adding endpoints.
- `docs/docs.go` is a 1-line placeholder (no Swagger spec generated).
- Port is hard-coded `:8080`; `APP_PORT_HTTP` has no effect.
