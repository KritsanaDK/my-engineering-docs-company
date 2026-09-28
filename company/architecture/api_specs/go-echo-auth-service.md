# go-echo-auth-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-auth-service` (Go module `auth_microservice`). Generated from source reading on 2026-09-23. Secrets are never reproduced here, only variable names.

## Overview

| Item | Value |
|---|---|
| Purpose | Customer login for Insurverse: validates email + password against `insurverse.sec_user`, issues HS256 JWTs, issues/redeems short-lived "auto-login" tokens (AES-encrypted), and issues SSO tokens for internal backends. |
| Framework | **Go `net/http` standard library** (`http.HandleFunc` / `http.Handle`). Despite the folder name, Echo is **not** used. |
| Port | `HTTP_PORT` env, default `8888` (`main.go:80-84`). Helm (`helm/helm-uat-isv.yaml`) sets `8080`; in-cluster service name `backend-auth-service:8080`. |
| Base path | `/api/v1/auth/` (+ `/healthcheck`) |
| DB | PostgreSQL via `lib/pq` (`dbConnect.go`), schema `insurverse`. MySQL driver imported but unused. |
| External calls | None. No outbound HTTP calls. |

### Environment variable names

| Variable | Used in | Notes |
|---|---|---|
| `HTTP_PORT` | `main.go:80`, `config/config.go:11` | Listen port (default `8888`). |
| `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME` | `dbConnect.go:35-55` | Each falls back to a **hardcoded constant** in `dbConnect.go` if empty (a dev DB host/user/password are committed in source). |
| `Backend_Auth` | `config/config.go:16` | Read but effectively never applied (the `if Backend_Auth == ""` guard is always false). Unused. |

Helm files also inject many shared `Backend_*`, `Base_Url`, `ENV` variables; this service does not read them.

## Auth & Middleware

| Middleware | File:line | Behaviour |
|---|---|---|
| `addCorsHeaders` | `main.go:32` | `Access-Control-Allow-Origin: *`, methods `GET, POST, PUT, DELETE, OPTIONS`, headers `Content-Type, X-CSRF-Token, Authorization`. `OPTIONS` -> `204`. Applied to all routes except `/healthcheck` and `/refresh_token`. |
| `ValidateToken` | `validate.go:48` | Reads `Authorization: Bearer <jwt>` (or `bearer`), parses with HMAC key (hardcoded in source, same literal as the signing key), then `mapstructure`-decodes claims into the **package-global** `ALT_Temp`. On parse failure writes `{"error":"Invalid token not found"}` with **HTTP 200** and stops. A missing `Bearer` prefix writes the error JSON but does **not** return (falls through to parse). The `JWT_Temp.ExpiredAt` check is dead code (`JWT_Temp` never populated); expiry is enforced only by `jwt.Parse` on `exp`. |
| `backendMiddleware` | `main.go:48` | Allows the request only if `r.Host` contains `backend-auth-service:8080` (i.e. in-cluster calls). Otherwise `401` with `{"status":401,"result":{"host":"<host>"}}`. |

Every handler enforces `POST` itself (`405 "Invalid request method."` otherwise), except `/healthcheck`.

### Token formats

**1. Access JWT (login / refresh / auto-login-check / SSO)**
- Algorithm: `HS256`, key: hardcoded byte literal in `main.go:24` (not env-configurable). ⚠️ security: shared static secret in source.
- Claims (`models.go:89` `Claims`):

| Claim | Type | Source |
|---|---|---|
| `prefix_name` | string/null | `sec_user.prefix_name` |
| `first_name` | string | `sec_user.name` |
| `last_name` | string | `sec_user.last_name` |
| `email` | string | request email (login/SSO) or `sec_user.email` |
| `mobile` | string | request `mobile` (login/SSO); empty otherwise |
| `email_verified` | bool | `sec_user.email_verified` |
| `mobile_verified` | bool | `sec_user.mobile_verified` |
| `is_register` | bool | always `false` |
| `id` | string | `sec_user.user_id` |
| `token` | string | empty inside the JWT; populated only in the response body |
| `exp`, `iat` | NumericDate | registered claims |

- Expiry:

| Endpoint | `exp` |
|---|---|
| `/login` | now + **2 years** (24*365*2 h) |
| `/refresh_token` | now + **2 years** |
| `/auto_login_token_check` | now + **24 h** (cookie expiry = auto-login token expiry, see below) |
| `/login_sso` | now + **24 h** |

- Also set as cookie `token` (no `HttpOnly`/`Secure`/`Path` flags) and persisted to `sec_user.token`.

**2. Auto-login token** (`/auto_login_token`)
- Plaintext `"<user_id>###<unix_exp>"` where exp = now + **30 s**.
- Encrypted with AES (16-byte key hardcoded in `main.go:26`) in **CFB** mode, random 16-byte IV prefixed, then standard Base64. No MAC/integrity check.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| ANY | `/healthcheck` | none | `healthcheck` (`main.go:28`) | Liveness, returns 200 empty body. |
| POST | `/api/v1/auth/login` | none (CORS) | `Login` (`main.go:199`) | Email + password login, issues 2-year JWT. |
| POST | `/api/v1/auth/auto_login_token` | Bearer JWT (`ValidateToken`) | `AutoLoginToken` (`main.go:351`) | Issue 30-second encrypted auto-login token for the caller. |
| POST | `/api/v1/auth/auto_login_token_check` | none (token in body) | `AutoLoginTokenCheck` (`main.go:377`) | Redeem auto-login token for a 24h JWT. |
| POST | `/api/v1/auth/refresh_token` | ⚠️ none (no middleware) | `RefreshToken` (`main.go:127`) | Re-issue 2-year JWT for user in global `ALT_Temp`. |
| POST | `/api/v1/auth/login_sso` | Host must be `backend-auth-service:8080` | `LoginSSO` (`main.go:278`) | Backend-only passwordless login by email, 24h JWT. |

Routes registered in `main.go:69-75`. Total: **6** (5 API + healthcheck).

## Endpoints

### Common response envelope (`JsonReturn`, `models.go:8`)
```json
{ "title": "string", "status": 200, "description": "", "result": {} }
```

---

### GET/ANY `/healthcheck`
- Purpose: k8s liveness/readiness. Any method. Returns `200`, empty body.
- DB: none.

---

### POST `/api/v1/auth/login`
- Purpose: authenticate a customer by email + password.
- Headers: `Content-Type: application/json`.
- Request body (`Credentials`, `models.go:82`):
```json
{ "email": "user@example.com", "hashpassword": "<plain password>", "mobile": "0800000000", "username": "" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | string | yes (functionally) | none (no validate tags); used as lookup key |
| `hashpassword` | string | yes (functionally) | none. Despite the name it is the **plaintext** password; compared with `bcrypt.CompareHashAndPassword(stored, password + salt)` where salt is a hardcoded literal |
| `mobile` | string | no | copied into JWT `mobile` claim unverified |
| `username` | string | no | unused |

- Success `200`:
```json
{
  "title": "Authen Service", "status": 200, "description": "",
  "result": {
    "prefix_name": "นาย", "first_name": "…", "last_name": "…",
    "email": "user@example.com", "mobile": "0800000000",
    "email_verified": true, "mobile_verified": false, "is_register": false,
    "id": "<user_id>", "token": "<JWT>", "exp": 1790000000, "iat": 1727000000
  }
}
```
Plus `Set-Cookie: token=<JWT>`.
- Errors:
  - `405` text `Invalid request method.` (non-POST)
  - `400` empty body (JSON decode failure)
  - `401` `{"title":"อีเมลหรือรหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง","status":401,"result":{}}` (user not found or password mismatch)
  - `500` empty (signing failure)
- DB:
  - `SELECT email, hashpassword, user_id, email_verified, mobile_verified, name, last_name, COALESCE(prefix_name,'') FROM insurverse.sec_user WHERE email = $1` (`main.go:92`)
  - async `UPDATE insurverse.sec_user SET token=$1, last_login=$2 WHERE email=$3` (`main.go:483`, goroutine, errors ignored)
- Outbound: none.

---

### POST `/api/v1/auth/auto_login_token`
- Purpose: produce a one-shot encrypted token (30 s TTL) so an already-logged-in user can be logged in on another front-end (hand-off link).
- Headers: `Authorization: Bearer <access JWT>` (required).
- Request body: none read.
- Success `200`:
```json
{ "title": "", "status": 200, "description": "", "result": { "token": "<base64 AES-CFB ciphertext>" } }
```
- Errors: `405`; `500` text `Something wrong!` (encrypt failure); invalid JWT -> **HTTP 200** `{"error":"Invalid token not found"}`.
- DB: none. User id comes from the JWT `id` claim (via global `ALT_Temp`).
- Outbound: none.

---

### POST `/api/v1/auth/auto_login_token_check`
- Purpose: redeem the auto-login token and receive a fresh 24 h JWT.
- Request body (`AutoLoginTokenCheckModel`, `models.go:115`):
```json
{ "token": "<value from /auto_login_token>" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `token` | string | yes | must Base64-decode and AES-decrypt; must contain `###` |

- Success `200`: same envelope/claims as `/login` (`title: "Authen Service"`), `exp` = now+24h; cookie `token` set with expiry = the (already near) auto-login expiry.
- Errors:
  - `405`; `400` empty (bad JSON)
  - `500` text `Something wrong!` (decrypt failure)
  - `401` `{"status":401,"result":"The token has expired."}`
  - `400` `{"status":400,"result":"Data not found!"}` (user_id not in `sec_user`)
  - ⚠️ A decryptable string without `###` would panic (`sr[1]` index out of range); net/http recovers per-request -> connection dropped.
- DB: `SELECT … FROM insurverse.sec_user WHERE user_id = $1` (`main.go:105`); async `UPDATE insurverse.sec_user SET token, last_login WHERE email`.
- Note: token is not single-use (replayable within 30 s).

---

### POST `/api/v1/auth/refresh_token`
- Purpose: re-issue a 2-year JWT.
- Headers: none enforced. ⚠️ Route is registered **without** `ValidateToken` and without CORS (`main.go:73`).
- Request body: none read.
- Behaviour: looks up user by `ALT_Temp.Id` — a **package-global** last populated by whichever request most recently passed `ValidateToken` (i.e. `/auto_login_token`). If never populated since process start -> 401. ⚠️ Race / cross-user token issuance risk: a caller may receive a JWT for another user.
- Success `200`: same as `/login` (email claim from `ALT_Temp.Email`).
- Errors: `405`; `401` `{"title":"","status":401,"result":{}}`; `500`.
- DB: `SELECT … FROM insurverse.sec_user WHERE user_id = $1`; async `UPDATE insurverse.sec_user SET token, last_login WHERE email`.

---

### POST `/api/v1/auth/login_sso`
- Purpose: backend-only passwordless login by email (other microservices call it in-cluster after their own SSO/OTP check).
- Access: `Host` header must contain `backend-auth-service:8080`, else `401 {"status":401,"result":{"host":"…"}}`. ⚠️ Host header is client-controlled; this is not a strong control if the service is reachable externally with a forged Host.
- Request body (`Credentials`):
```json
{ "email": "user@example.com", "mobile": "0800000000" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `email` | string | yes | must exist in `sec_user` |
| `mobile` | string | no | copied to claim |

- Success `200` — **no envelope**, raw claims object:
```json
{
  "prefix_name": "", "first_name": "…", "last_name": "…", "email": "user@example.com",
  "mobile": "", "email_verified": true, "mobile_verified": false, "is_register": false,
  "id": "<user_id>", "token": "<JWT>", "exp": 1727086400, "iat": 1727000000
}
```
- Errors: `405`; `400` (bad JSON); `401` `{"title":"Data not found","status":401,"result":{}}`; `500`.
- DB: `SELECT email, user_id, email_verified, mobile_verified, name, last_name, COALESCE(prefix_name,'') FROM insurverse.sec_user WHERE email = $1` (`main.go:294`); async `UPDATE insurverse.sec_user SET token, last_login`.

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| `insurverse.sec_user` (cols: `email`, `hashpassword`, `user_id`, `email_verified`, `mobile_verified`, `name`, `last_name`, `prefix_name`) | Read | `/login`, `/auto_login_token_check`, `/refresh_token`, `/login_sso` |
| `insurverse.sec_user` (cols: `token`, `last_login`) | Write (UPDATE, async) | `/login`, `/auto_login_token_check`, `/refresh_token`, `/login_sso` |

No stored functions, procedures or triggers are called.

## Notes / ⚠️ unverified items

1. ⚠️ **Hardcoded secrets in source**: JWT HMAC key, bcrypt salt suffix and AES auto-login key are literals in `main.go:24-26`; DB fallback credentials are constants in `dbConnect.go`. Values intentionally not copied here. Recommend moving to env/secret.
2. ⚠️ **Global mutable state**: `u` (`main.go:23`), `ALT_Temp`, `Token` (`validate.go`) are shared across concurrent requests -> data races; `/refresh_token` can mint a token for another user.
3. `ValidateToken` returns HTTP **200** with an `error` JSON on invalid tokens; clients must inspect the body.
4. The `mobile` JWT claim at `/login` and `/login_sso` is taken from the request body without verification.
5. Unused code: `main2`, `CheckExpire`, `ExtractClaims`, `HashPassword`, models `JWT`, `CustomClaims`, `TokenTemp`.
6. ⚠️ unverified: actual schema/column types of `insurverse.sec_user` were not checked against a live DB (doc derived from SQL in code only).
7. Other services that call this one (e.g. via `Backend_Auth` = `http://backend-auth-service:8080/api/v1/auth/`) were not traced.
