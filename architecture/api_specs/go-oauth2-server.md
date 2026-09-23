# go-oauth2-server — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-oauth2-server` (Go module `go-oauth2-server`). Generated from source reading on 2026-09-23. Secrets are never reproduced here, only variable names.

## Overview

| Item | Value |
|---|---|
| Purpose | OAuth2-style token server for **Open API partners** (machine-to-machine). Only the `client_credentials` grant is implemented; partners are rows in `mas_partner` (`partner_code` = `client_id`). Other OAuth/OIDC endpoints are stubbed (`501 Not Implemented`). |
| Framework | **Fiber v2** (`gofiber/fiber/v2`), GORM + Postgres driver, `go-jose/v4` for JWT. Not Echo. |
| Entry | `cmd/server/main.go` -> `internal/infrastructure/server/fiber.go` |
| Host/Port | `APP_HOST` (default `localhost`) : `APP_PORT` (default `3000`). k8s: container `3000`, Service `openapi-oauth-service:8080 -> 3000`. |
| Base path | `/services/oauth/v2` (`fiber.go:132`). Also `/livez`, `/readyz`, `/swagger/*`. |
| DB | PostgreSQL via GORM; `search_path` from `DATABASE_SEARCH_PATH` (default `public`). Redis client code exists but is commented out (not used). |
| External calls | None. |

### Environment variable names (`pkg/config/model.go`, parsed by `caarlos0/env`)

| Variable | Default | Required | Purpose |
|---|---|---|---|
| `APP_NAME` | – | no | Fiber app name |
| `APP_ENV` | `local` | no | log only |
| `APP_HOST` | `localhost` | no | bind host (must be `0.0.0.0` in k8s ⚠️ unverified how it is set) |
| `APP_PORT` | `3000` | no | bind port |
| `APP_DEBUG` | `true` | no | GORM debug + **logs full config incl. secrets** (`main.go:35`, `fiber.go:84`) |
| `APP_RATE_LIMIT_CONN` | `100` | no | limiter max requests |
| `APP_RATE_LIMIT_WINDOW` | `10s` | no | limiter sliding window |
| `DATABASE_DRIVER` | – | no | unused |
| `DATABASE_HOST` / `DATABASE_PORT` | `localhost` / `5432` | no | |
| `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_NAME` | – | **yes** (`notEmpty`) | |
| `DATABASE_SEARCH_PATH` | `public` | yes | |
| `DATABASE_TZ` | `UTC` | no | |
| `DATABASE_SSL_MODE` | `disable` | no | |
| `DATABASE_MAX_OPEN` / `DATABASE_MAX_IDLE` / `DATABASE_MAX_LIFE` | `10` / `2` / `1h` | no | pool (`database/pool.go`) |
| `JWT_SECRET` | – | **yes** | HS256 signing key |
| `JWT_EXPIRE` | `1h` | no | access-token lifetime |
| `JWT_ISSUER` | – | **yes** | `iss` claim |
| `JWT_AUDIENCE` | – | **yes** | `aud` claim (comma-separated list) |

`RedisConfig` (`REDIS_*`) is defined but not wired into `Cfg`. ⚠️ unverified: where these env vars are set in k8s — `kustomize/base/deployment.yaml` has no `env`/`envFrom`.

## Auth & Middleware

Global (in order, `fiber.go:102-117`): `cors.New()` (default: all origins), `helmet.New()` (security headers), `healthcheck` (`/livez`, `/readyz`), `logger`, `recover`, `requestid` (`X-Request-ID`), `limiter` (sliding window, keyed by client IP, `APP_RATE_LIMIT_CONN` per `APP_RATE_LIMIT_WINDOW`; exceeding -> `429`).

Route middleware `JWTAuth()` (`internal/middleware/jwt.go:15`): requires `Authorization: Bearer <token>` (exactly two space-separated parts, scheme case-sensitive `Bearer`), verifies via `usecase.VerifyAccessToken`; stores `jwt.Claims` in `c.Locals("claim")`. Failure -> `401` with OAuth error body.

### Client authentication at `/token`
- `client_id` / `client_secret` from the body, **or** `Authorization: Basic base64(client_id:client_secret)` (header overrides body, `pkg/utils/basic_auth.go`).
- Secret compared in **plaintext** with `mas_partner.client_secret` (`strings.Compare`, not constant-time) where `partner_code = client_id AND is_active = true`.

### Access token format
- JWS compact, **HS256**, key = `JWT_SECRET` (`internal/usecase/jwt.go:17`).
- Claims (standard only):

| Claim | Value |
|---|---|
| `iss` | `JWT_ISSUER` |
| `sub` | partner code (`mas_partner.partner_code`) |
| `aud` | `JWT_AUDIENCE` list |
| `iat` | now |
| `exp` | now + `JWT_EXPIRE` (default 1h) |
| `jti` | UUIDv7 |

- No `nbf`, no scope claim, no refresh token.
- Verification (`VerifyAccessToken`): HS256 only, checks signature, `iss`, any-of `aud`, and `exp`/`nbf`/`iat` via `jwt.Claims.Validate` (default 1-minute leeway). Tokens are **not** checked against `mas_partner.access_token`, so issuing a new token does not revoke older ones.

### Grant types
| grant_type | Status |
|---|---|
| `client_credentials` | Implemented |
| anything else (`authorization_code`, `refresh_token`, `password`, device, …) | `400 {"error":"unsupported_response_type"}` |

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/livez` | none | `Resource.Liveness` (`fiber.go:184`) | Liveness, always OK |
| GET | `/readyz` | none | `Resource.Readiness` (`fiber.go:191`) | Readiness |
| GET | `/swagger/*` | none | `swagger.HandlerDefault` (`fiber.go:119`) | Swagger UI (`docs/`) |
| GET | `/services/oauth/v2/` | none | inline (`internal/handler/interface.go:31`) | Echo request info (debug) |
| GET | `/services/oauth/v2/authorize` | none | `Authorize` (`internal/handler/authorize.go:9`) | **501** stub |
| POST | `/services/oauth/v2/token` | client credentials | `Token` (`internal/handler/token.go:26`) | Issue access token (client_credentials) |
| POST | `/services/oauth/v2/introspect` | none | `Introspect` (`internal/handler/introspect.go:9`) | **501** stub |
| GET | `/services/oauth/v2/userinfo` | Bearer JWT | `UserInfo` (`internal/handler/user_info.go:22`) | Return verified token claims |
| POST | `/services/oauth/v2/revoke` | none | `Revoke` (`internal/handler/revoke.go:9`) | **501** stub |
| POST | `/services/oauth/v2/end_session` | none | `EndSession` (`internal/handler/end_session.go:9`) | **501** stub |
| POST | `/services/oauth/v2/device_authorization` | none | `Device` (`internal/handler/device.go:9`) | **501** stub |
| GET | `/services/oauth/v2/keys` | none | `Keys` (`internal/handler/key.go:9`) | **501** stub (no JWKS; HS256 symmetric) |

Total: **12** routes (9 under `/services/oauth/v2`, of which 2 functional + 1 debug + 6 stubs; plus 3 infra).

## Endpoints

### Error body (all OAuth errors) — `model.TokenResponse` (`pkg/model/token_model.go:27`)
```json
{ "access_token": "", "expires_in": 0, "token_type": "", "error": "unauthorized_client", "error_description": "…" }
```
Error codes defined: `invalid_request`, `unauthorized_client`, `access_denied`, `unsupported_response_type`, `invalid_scope`, `server_error`, `temporarily_unavailable`, `invalid_client`, `expired_token` (only the first four + `temporarily_unavailable` are emitted).

---

### POST `/services/oauth/v2/token`
- Purpose: partner obtains a Bearer access token for the Insurverse Open API.
- Headers: `Content-Type: application/json` **or** `application/x-www-form-urlencoded` (Fiber `BodyParser`; ⚠️ form parsing needs `form` tags — struct only has `json` tags, so form fields may not bind; JSON is the verified path). Optional `Authorization: Basic …`.
- Request body (`model.TokenRequest`, `token_model.go:20`):
```json
{ "grant_type": "client_credentials", "client_id": "<partner_code>", "client_secret": "<secret>", "scope": "" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `grant_type` | string | yes | must equal `client_credentials` |
| `client_id` | string | yes (or via Basic) | non-empty; must match active `mas_partner.partner_code` (varchar(10)) |
| `client_secret` | string | yes (or via Basic) | non-empty; exact match with `mas_partner.client_secret` |
| `scope` | string | no | ignored |

- Success `200`:
```json
{ "access_token": "<JWS HS256>", "expires_in": 3600, "token_type": "Bearer" }
```
- Errors:

| HTTP | `error` | When |
|---|---|---|
| 422 | `invalid_request` | body cannot be parsed |
| 401 | `unauthorized_client` | missing client_id/secret, partner not found/inactive, secret mismatch |
| 400 | `unsupported_response_type` | grant_type ≠ `client_credentials` (note: RFC 6749 would use `unsupported_grant_type`) |
| 503 | `temporarily_unavailable` (+ `error_description`) | signing error or DB update of `mas_partner` failed |
| 429 | – | rate limiter |

- Edge case: an `Authorization` header with a non-Basic scheme (e.g. `Bearer x`) is parsed as `client_id = "x"`, `client_secret = ""` and overrides the body -> `401`.
- DB:
  - Read: `SELECT * FROM mas_partner WHERE partner_code = ? AND is_active = true LIMIT 1` (GORM `First`, `repository/partner.go:11`).
  - Write (transaction): `UPDATE mas_partner SET access_token = ?, access_token_last_at = ?, expires_in = ? WHERE partner_code = ?` (`repository/partner.go:31`). Note `expires_in` column stores the absolute expiry timestamp (UTC).
- Outbound: none.

---

### GET `/services/oauth/v2/userinfo`
- Purpose: return the verified claims of the caller's access token (useful for partners/gateways to check a token).
- Headers: `Authorization: Bearer <access_token>` (required).
- Success `200`:
```json
{ "iss": "<JWT_ISSUER>", "sub": "<partner_code>", "aud": ["<aud>"], "exp": 1727003600, "iat": 1727000000, "jti": "0192…" }
```
- Errors: `401 {"error":"unauthorized_client"}` (missing/malformed header); `401 {"error":"access_denied","error_description":"<jose error e.g. go-jose/go-jose/jwt: validation failed, token is expired (exp)>"}`.
- DB: none.

---

### GET `/services/oauth/v2/`
- Purpose: debug echo. No auth.
- Success `200`:
```json
{ "status": "success", "data": { "host": ["<X-Forwarded-For IPs>"], "method": "GET", "path": "/services/oauth/v2/", "query": {}, "ua": "curl/8.0" } }
```

---

### Stub endpoints (all return `501` text `Not Implemented`)
`GET /authorize`, `POST /introspect`, `POST /revoke`, `POST /end_session`, `POST /device_authorization`, `GET /keys` (all under `/services/oauth/v2`). No request parsing, no DB.

---

### GET `/livez`, GET `/readyz`
- Fiber healthcheck middleware: `200 OK` when probe returns true, else `503`.
- `/readyz`: ⚠️ bug — DB ping only runs when `r.DBConn == nil` (`fiber.go:208`, inverted condition), so with a live connection the DB is **never pinged** and readiness is always true; Redis is nil -> true.

### GET `/swagger/*`
- Swagger UI generated by swag (`docs/swagger.yaml`). ⚠️ unverified whether the generated doc matches current routes.

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| `mas_partner` (`partner_code` PK, `client_secret`, `is_active`) | Read | `POST /token` |
| `mas_partner` (`access_token`, `access_token_last_at`, `expires_in`) | Write (UPDATE in tx) | `POST /token` |
| `log_openapi_interface` | – (entity generated, **not used** by any code path) | none |

Schema resolved via `DATABASE_SEARCH_PATH` (default `public`). No stored functions, procedures or raw SQL.

## Notes / ⚠️ unverified items

1. ⚠️ **Ingress mismatch**: `kustomize/base/ingress.yaml` routes prefix `/api/oauth/v2` to service `oauth-service:8080`, but the app serves `/services/oauth/v2` and the Service is named `openapi-oauth-service`. Either an external gateway rewrites the path or the ingress is stale — unverified.
2. ⚠️ Env vars are not defined in the kustomize manifests; source of `JWT_*`/`DATABASE_*` in each environment unverified.
3. `APP_DEBUG` defaults to `true`, which logs the whole config (including `JWT_SECRET`/`DATABASE_PASSWORD`) at startup — ensure it is `false` outside local.
4. Partner `client_secret` is stored and compared in plaintext.
5. Issued tokens are stored in `mas_partner.access_token` but never used for validation/revocation (multiple valid tokens can coexist).
6. Downstream Open API services that validate these tokens (shared `JWT_SECRET`) were not traced.
7. `mock/` and `*_test.go` exist for partner repo/usecase and JWT usecase; not part of runtime.
