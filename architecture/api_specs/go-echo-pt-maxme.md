# go-echo-pt-maxme — API Spec

## Overview

| Item | Value |
|---|---|
| Purpose | Integration API for the ISV partner "PT Maxme". It lists **paid compulsory-act (CMI / พ.ร.บ.) discount leads** from `insurverse."Lead_Car_Act_Discount_Premium"`, and has its own JWT auth plus RBAC user management (`users` table). |
| Framework | Go + Echo v4, pgx v5 (`pgxpool`), zap logger, `go-playground/validator/v10`, `golang-jwt/jwt/v5`, bcrypt |
| Entry point | `cmd/server/main.go` (graceful shutdown on SIGINT/SIGTERM, 10s timeout) |
| Port | env `PORT`, default `8080` |
| Base path | `/api/v1` (health routes are at the root) |
| Env var NAMES | App: `APP_NAME`, `SERVICE_NAME`, `PORT`, `APP_ENV`, `APP_VERSION`, `GIT_COMMIT`, `BUILD_TIME`, `APP_READ_TIMEOUT`, `APP_WRITE_TIMEOUT` · JWT: `JWT_SECRET`, `JWT_EXPIRY` (default 24h) · Primary DB: `DATABASE_URL` (takes precedence if set), `DB_PRIMARY_HOST`, `DB_PRIMARY_PORT`, `DB_PRIMARY_USER`, `DB_PRIMARY_PASSWORD`, `DB_PRIMARY_NAME`, `DB_PRIMARY_SSLMODE`, `DB_PRIMARY_MAX_CONNS`, `DB_PRIMARY_MIN_CONNS`, `DB_PRIMARY_MAX_CONN_LIFETIME`, `DB_PRIMARY_MAX_CONN_IDLE_TIME` · Secondary DB (loaded but **not used**): `DATABASE_SECONDARY_URL`, `DB_SECONDARY_*` · Pagination: `PAGINATION_DEFAULT_LIMIT` (default 10), `PAGINATION_MAX_LIMIT` (default 100), `PAGINATION_DEFAULT_OFFSET` (default 0) |
| External / third-party calls | None. There are no outbound HTTP clients. The only dependency is PostgreSQL (primary pool). |
| Build info | `Version`, `GitCommit`, `BuildTime` are injected via `-ldflags`. Env vars override them (`config.ApplyBuildInfo`). |

## Auth & Middleware

Global middleware, in order (`internal/router/router.go:51-86`):
1. `TraceMiddleware`: reads `X-Trace-ID` or `X-Request-ID` (otherwise generates one) and echoes it back in the `X-Trace-ID` response header.
2. `BodyLimit("10M")`
3. `RequestLoggerWithConfig`: zap log with track_id, method, uri, status, latency.
4. `Recover()`
5. `CORS()` (Echo default: all origins).

Custom `HTTPErrorHandler` (`router.go:88-123`): turns every `echo.HTTPError` (from middleware, 404 route-not-found, and so on) into `{"code": "...", "message": "..."}`. It maps 400→`4000`, 401→`4001`, 403→`4003`, 404→`4004`, anything else→`5000`.

Auth (`internal/middleware/auth_middleware.go`):
- `JWTAuthMiddleware(JWT_SECRET)`: requires the `Authorization: Bearer <token>` header. The token must be HS256-signed. Claims: `user_id`, `email`, `role`, `partner_id` (optional), plus `exp` and `iat`. Tokens are issued by `/auth/register` and `/auth/login`.
  - 401 messages: `missing authorization header`, `invalid authorization format, expected 'Bearer <token>'`, `invalid or expired token`, `invalid token claims`.
- `RequireRole(roles...)`: the user's role must be in the list. Otherwise 403 `access denied: insufficient permissions` (or `access denied: missing role`).
- `RequireMinRole(role)`: hierarchical check. Levels: super_admin 50, admin 40, manager 30, auditor 25, partner/vendor/service_account 20, user 10. Otherwise 403 `access denied: insufficient role level`.
- `RequireThirdPartyPartner()` is defined but **not attached to any route**.

Standard response envelope — `dto.TemplateResponse`:

```json
{ "code": "0000", "message": "SUCCESS", "data": { } }
```

Codes: `0000` success, `4000` invalid param, `4001` unauthorized, `4003` forbidden, `4004` not found, `4009` conflict, `5000` internal. `data` is left out on errors.

Validation error message format (`BaseHandler.ValidatorParam`): `field 'Email' failed on 'email' rule; field 'Password' failed on 'min' rule; ` (uses the Go struct field names).

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/` | None | `internal/handler/base_handler.go:156` (`HealthCheck`) | Full health status (DB ping) |
| GET | `/health` | None | `internal/handler/base_handler.go:156` (`HealthCheck`) | Same as `/` |
| GET | `/health/live` | None | `internal/handler/base_handler.go:128` (`LivenessCheck`) | K8s liveness probe |
| GET | `/health/ready` | None | `internal/handler/base_handler.go:136` (`ReadinessCheck`) | K8s readiness probe (DB ping) |
| GET | `/api/v1/isv/ptmaxme/leads` | **None** ⚠️ | `internal/handler/isv_handler.go:27` (`GetPtMaxmePaidLeads`) | Paginated paid CMI discount leads, filterable by payment date |
| POST | `/api/v1/auth/register` | None | `internal/handler/auth_handler.go:26` (`Register`) | Self-registration (role is always `user`), returns a JWT |
| POST | `/api/v1/auth/login` | None | `internal/handler/auth_handler.go:44` (`Login`) | Email/password login, returns a JWT |
| GET | `/api/v1/auth/me` | JWT | `internal/handler/auth_handler.go:62` (`GetMe`) | Current user's profile |
| GET | `/api/v1/users/:id` | JWT (any role) | `internal/handler/user_handler.go:44` (`GetByID`) | Get a user by ID |
| GET | `/api/v1/users` | JWT + min role `manager` | `internal/handler/user_handler.go:55` (`List`) | Paginated user list |
| POST | `/api/v1/users` | JWT + role `admin` or `super_admin` | `internal/handler/user_handler.go:26` (`Create`) | Create a user with any role |
| PUT | `/api/v1/users/:id` | JWT + role `admin` or `super_admin` | `internal/handler/user_handler.go:74` (`Update`) | Partial update of a user |
| DELETE | `/api/v1/users/:id` | JWT + role `super_admin` | `internal/handler/user_handler.go:90` (`Delete`) | Hard-delete a user |

Total: **13 routes** (4 health, 9 API).

## Endpoints

### GET `/` and GET `/health` — HealthCheck

- Purpose: overall health, including a DB ping with a 2s timeout.
- Success `200`:

```json
{ "status": "ok", "service": "go-echo-pt-maxme", "env": "development", "uptime": "1h2m3s", "database": "healthy", "timestamp": "2026-09-23T03:00:00Z" }
```

- `503` when the ping fails: `"status": "degraded"`, `"database": "unreachable: <err>"`. If the pool is nil, the endpoint returns 200 with `"database": "not configured"`.
- The response is not wrapped in the envelope. DB: `pool.Ping` only.

### GET `/health/live`

- Success `200`: `{ "status": "alive", "uptime": "1h2m3s" }`. No DB access.

### GET `/health/ready`

- Success `200`: `{ "status": "ready", "database": "connected" }`
- `503`: `{ "status": "unready", "reason": "database ping failed: <err>" }`
- If the pool is nil, it returns 200 ready. ⚠️

---

### GET `/api/v1/isv/ptmaxme/leads`

- Purpose: return the paid compulsory-act discount leads that PT Maxme reconciles against. The query only includes rows where `"Payment_date" IS NOT NULL AND customer_id IS NOT NULL`.
- Auth: **none** (the route is registered without `JWTAuthMiddleware`, `router.go:143-144`). ⚠️
- Query params (`dto.CarActPaidLeadQuery`, parsed by hand in the handler):

| Name | Type | Required | Validation (as enforced) |
|---|---|---|---|
| `start_date` | string `YYYY-MM-DD` | no | `util.ValidateDateFormat` → 400 if not `2006-01-02`. Filter: `"Payment_date" >= start_date`. |
| `end_date` | string `YYYY-MM-DD` | no | Same format check. Extended to `end_date 23:59:59`. Filter: `"Payment_date" <= ...`. |
| (both) | | | 400 `start_date must not be after end_date` if start > end (string compare) |
| `limit` | int | no | Non-numeric values are silently ignored. If ≤0, uses `PAGINATION_DEFAULT_LIMIT` (default 10). Capped at `PAGINATION_MAX_LIMIT` (default 100). The DTO tag `max=1000` is **not enforced**. |
| `offset` | int | no | Non-numeric values are ignored. A negative value becomes `PAGINATION_DEFAULT_OFFSET`. |

- Example: `GET /api/v1/isv/ptmaxme/leads?start_date=2026-09-01&end_date=2026-09-23&limit=20&offset=0`
- Success `200`:

```json
{
  "code": "0000",
  "message": "SUCCESS",
  "data": {
    "total": 125,
    "items": [
      {
        "car_comp_code": "1.10",
        "net_premium": 600.0,
        "customer_id": "1111111111119",
        "payment_date": "2026-09-20T10:15:00Z"
      }
    ]
  }
}
```

| Response field | Type | Source column |
|---|---|---|
| `total` | int64 | `COUNT(*)` with the same WHERE clause |
| `items[].car_comp_code` | string | `COALESCE(lcadp."Car_Comp_Code", '')` |
| `items[].net_premium` | float64 | `COALESCE(lcadp."Net_Premium", 0)` |
| `items[].customer_id` | string | `COALESCE(lcadp.customer_id, '')` (the example uses the standard test ID; ⚠️ whether this column holds a citizen ID or an internal ID is unverified) |
| `items[].payment_date` | timestamp, omitempty | `lcadp."Payment_date"` |

- Ordering: `ORDER BY lcadp."Car_Act_Lead_No" DESC`, `LIMIT/OFFSET`.
- Errors:

| Status | code | message |
|---|---|---|
| 400 | `4000` | `field 'start_date' must be in 2006-01-02 format (e.g. 2026-08-26)` (same for `end_date`) |
| 400 | `4000` | `start_date must not be after end_date` |
| 500 | `5000` | raw DB error text |

- DB: `insurverse."Lead_Car_Act_Discount_Premium"` (read-only, raw SQL via pgx, `internal/repository/isv_repo.go:30-113`). No stored functions.
- Outbound: none.

---

### POST `/api/v1/auth/register`

- Purpose: public self-registration. Role is always `user`. ID = `"usr-" + first 8 chars of a UUID`. Password is hashed with bcrypt (DefaultCost).
- Request (`dto.RegisterRequest`):

```json
{ "email": "kritsana.w.os@horixon-t8.com", "password": "secret123", "name": "กฤษณะ วัฒนายนนต์", "partner_id": "ptmaxme" }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | string | yes | `required,email` |
| `password` | string | yes | `required,min=6` |
| `name` | string | yes | `required` |
| `partner_id` | string, nullable | no | none (free text) ⚠️ |

- Success `201`:

```json
{
  "code": "0000",
  "message": "SUCCESS",
  "data": {
    "token": "<jwt>",
    "user": { "id": "usr-1a2b3c4d", "email": "kritsana.w.os@horixon-t8.com", "name": "กฤษณะ วัฒนายนนต์", "role": "user", "partner_id": "ptmaxme", "created_at": "2026-09-23T03:00:00Z", "updated_at": "2026-09-23T03:00:00Z" }
  }
}
```

- Errors: 400 `4000` `invalid request payload` (bind) or a validation message; 400 `4009` `email is already registered`; 400 `4009` `failed to create user: <db err>` / `failed to generate token: ...` (all service errors map to 400/4009).
- DB: `users` SELECT by email, then INSERT.

### POST `/api/v1/auth/login`

- Request (`dto.LoginRequest`): `{ "email": "kritsana.w.os@horixon-t8.com", "password": "secret123" }`

| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | string | yes | `required,email` |
| `password` | string | yes | `required` |

- Success `200`: same `data` shape as register (`token`, `user`).
- Errors: 400 `4000` (bind or validation); 401 `4001` `invalid email or password`.
- DB: `users` SELECT by email.

### GET `/api/v1/auth/me`

- Auth: JWT.
- Success `200`: `data` = UserResponse (`id`, `email`, `name`, `role`, `partner_id?`, `created_at`, `updated_at`).
- Errors: 401 from the middleware (see above); 401 `4001` `unauthorized` (no user_id in the context); 404 `4004` `user not found`.
- DB: `users` SELECT by id.

---

### GET `/api/v1/users/:id`

- Auth: JWT. **Any role** can read any user by ID (no ownership check). ⚠️
- Path param: `id` (string, for example `usr-1a2b3c4d`).
- Success `200`: `data` = UserResponse.
- Errors: 401/403 from middleware; 404 `4004` `user not found` (DB errors also return 404).
- DB: `users` SELECT by id.

### GET `/api/v1/users`

- Auth: JWT + `RequireMinRole(manager)`, so allowed roles are manager, admin and super_admin. Auditor (25) is refused.
- Query: `limit` (int, default 10 if ≤0 or invalid; **no maximum**) ⚠️, `offset` (int, default 0).
- Success `200`:

```json
{ "code": "0000", "message": "SUCCESS", "data": { "users": [ { "id": "usr-1a2b3c4d", "email": "kritsana.w.os@horixon-t8.com", "name": "กฤษณะ วัฒนายนนต์", "role": "user", "created_at": "2026-09-23T03:00:00Z", "updated_at": "2026-09-23T03:00:00Z" } ], "total": 1, "limit": 10, "offset": 0 } }
```

- Errors: 401/403; 500 `5000` DB error.
- DB: `users` COUNT + SELECT `ORDER BY created_at DESC LIMIT/OFFSET`.

### POST `/api/v1/users`

- Auth: JWT + role `admin` or `super_admin`.
- Request (`dto.CreateUserRequest`):

```json
{ "email": "kritsana.w.os@horixon-t8.com", "password": "secret123", "name": "กฤษณะ วัฒนายนนต์", "role": "partner", "partner_id": "ptmaxme" }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | string | yes | `required,email` |
| `password` | string | yes | `required,min=6` |
| `name` | string | yes | `required` |
| `role` | string enum | no | Defaults to `user`. Must be one of `super_admin, admin, manager, user, partner, vendor, service_account, auditor` (service check). |
| `partner_id` | string, nullable | no | none |

- Success `201`: `data` = UserResponse.
- Errors: 400 `4000` (bind or validation); 400 `4009` `email is already registered`, `invalid role '<x>'`, or a raw DB error.
- An admin can create a `super_admin` account, which is a privilege-escalation risk. ⚠️
- DB: `users` SELECT by email, then INSERT.

### PUT `/api/v1/users/:id`

- Auth: JWT + role `admin` or `super_admin`.
- Path param: `id`.
- Request (`dto.UpdateUserRequest`, every field optional; empty strings are ignored):

```json
{ "email": "kritsana.w.os@horixon-t8.com", "password": "newsecret1", "name": "กฤษณะ วัฒนายนนต์", "role": "manager", "partner_id": "ptmaxme" }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | string | no | Tag `omitempty,email`, **not enforced** (the handler does not call `ValidatorParam`) ⚠️. The service checks uniqueness. |
| `password` | string | no | Tag `omitempty,min=6`, **not enforced** ⚠️. Rehashed with bcrypt. |
| `name` | string | no | none |
| `role` | string enum | no | Must be a valid role (service check) |
| `partner_id` | string | no | Set whenever present, including `""` |

- Success `200`: `data` = UserResponse.
- Errors: 400 `4000` for `invalid request payload`, `user not found`, `email is already in use by another user`, `invalid role '<x>'`, or a DB error (all service errors map to 400/4000).
- DB: `users` SELECT by id (plus SELECT by email when the email changes), then UPDATE.

### DELETE `/api/v1/users/:id`

- Auth: JWT + role `super_admin`.
- Success `200`: `{ "code": "0000", "message": "SUCCESS", "data": { "message": "user deleted successfully" } }`
- Errors: 401/403; **500** `5000` `user not found` (a not-found result maps to 500) ⚠️, or a DB error.
- DB: `users` DELETE (hard delete).

## DB Usage

All queries are raw SQL through the pgx primary pool (`GetRunner`, which can join a tx held in the ctx; no route opens a transaction). No stored functions, procedures or triggers are called.

| Table / function | Read / write | Endpoints |
|---|---|---|
| `insurverse."Lead_Car_Act_Discount_Premium"` (cols: `"Car_Comp_Code"`, `"Net_Premium"`, `customer_id`, `"Payment_date"`, `"Car_Act_Lead_No"`) | read | GET `/api/v1/isv/ptmaxme/leads` |
| `users` (unqualified, resolved via `search_path`; cols `id, email, password_hash, name, role, partner_id, created_at, updated_at`; DDL in `migrations/000001_create_users_table.up.sql` and `schema.sql`) | read | `/auth/register`, `/auth/login`, `/auth/me`, GET `/users`, GET `/users/:id`, POST `/users`, PUT `/users/:id` |
| `users` | write (INSERT) | `/auth/register`, POST `/users` |
| `users` | write (UPDATE) | PUT `/users/:id` |
| `users` | write (DELETE) | DELETE `/users/:id` |
| (connection) `pool.Ping` | check only | `/`, `/health`, `/health/ready` |

## Notes / ⚠️ unverified items

1. ⚠️ **`GET /api/v1/isv/ptmaxme/leads` has no authentication.** It exposes `customer_id`, premiums and payment dates to anyone who can reach it. `RequireThirdPartyPartner` exists but is not wired in. Confirm whether an ingress or API gateway protects it.
2. ⚠️ `/auth/register` is public, and any registrant immediately gets a valid JWT. Combined with item 1, this means JWT is not a real barrier for partner data.
3. ⚠️ Both tables use the same primary pool. `users` is unqualified while the lead table is schema-qualified (`insurverse`), so the `users` table's actual schema depends on the DB user's `search_path`. Not verified against the live DB (no DB access was allowed).
4. ⚠️ The columns of `insurverse."Lead_Car_Act_Discount_Premium"` were taken from the Go SQL only. Per Rule 6 they need checking against `information_schema.columns` before any change.
5. ⚠️ The `JWT_SECRET` default in `internal/config/config.go` is a placeholder string (value not copied here). The service will run with it if the env var is missing.
6. ⚠️ `DB_SECONDARY_*` / `DATABASE_SECONDARY_URL` are loaded but never used. `UserService.ListUsersByPartner` / `userRepo.ListByPartner` have no route.
7. ⚠️ If the DB is unreachable after 5 retries, `InitPGXPoolWithRetry` returns nil and the server still starts. Repository calls on a nil pool will panic (caught by `Recover` → 500), and `/health/ready` reports ready.
8. ⚠️ Inconsistent error mapping: all register/create errors return 400/`4009` (including DB errors), update errors return 400/`4000`, and delete not-found returns 500.
9. ⚠️ Date filters are passed as text parameters and compared with `"Payment_date"`. The timezone of that column (timestamp vs timestamptz) was not verified.
10. The Postman collection (`postman_collection.json`) and `scripts/fetch_paid_leads*.sh` / `scripts/get_token.sh` exist as client helpers. They were not reviewed in detail and add no routes.
