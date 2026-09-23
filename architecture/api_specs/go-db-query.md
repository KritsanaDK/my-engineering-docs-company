# go-db-query — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-db-query` (module `go-db-query`). Read-only analysis, 2026-09-23.

## Overview

| Item | Value |
|---|---|
| Purpose | Generic "shared DB query" gateway: callers send an **AES-encrypted SQL string**, the service decrypts it and executes it as-is against PostgreSQL, returning rows as JSON. A helper endpoint encrypts plaintext SQL. |
| Language / framework | Go, Echo v4, pgx v4 (`pgxpool`), golang-jwt v5, godotenv |
| Entry point | `cmd/server/main.go` (a pre-built binary `server` is also committed in the folder) |
| Port | `PORT` env, default `8080` (`cmd/server/main.go:59-63`) |
| Base path | `/api/v1/share` |
| Env var NAMES | `PORT`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_SSLMODE` (`internal/db/db.go`), `JWT_SECRET` (`internal/middleware/jwt.go`), `KEY`, `IV` (AES-CBC key/IV, `internal/service/share_service.go`). Loaded from `.env` via godotenv if present. |
| External calls | None (only its PostgreSQL) |
| Background jobs / queues | None |

## Auth & Middleware

| Layer | Detail |
|---|---|
| Global | `middleware.Logger()`, `middleware.Recover()` (`main.go:28-29`) |
| Group `/api/v1/share` | `JWTMiddleware` (`internal/middleware/jwt.go:13`) |

`JWTMiddleware`:
- Requires header `Authorization: Bearer <token>`.
- Accepts any HMAC-signed JWT (HS256/384/512) verified with `JWT_SECRET`; **falls back to a hardcoded fallback literal in `internal/middleware/jwt.go:29` (value redacted) if `JWT_SECRET` is empty**.
- No claim checks (no issuer/audience/role); claims stored in context key `user_claims`, not used afterwards.
- Errors (401): `missing authorization header`, `invalid authorization header format`, `invalid or expired token`.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| POST | `/api/v1/share/encrypt` | JWT (HMAC) | `ShareHandler.Encrypt` — `internal/handler/share_handler.go:45` | AES-256/128-CBC encrypt a plaintext SQL string → hex |
| POST | `/api/v1/share/query` | JWT (HMAC) | `ShareHandler.Query` — `internal/handler/share_handler.go:27` | Decrypt hex SQL and execute it; return rows |

Total: **2 endpoints**.

## Endpoints

### POST `/api/v1/share/encrypt`
- **Purpose:** produce the encrypted payload that `/query` accepts.
- **Flow:** handler → `shareService.InternalEncrypt` (`share_service.go:48`) → reads `KEY`, `IV` from env (`env_repository.go:26`) → `util.EncryptAES` (AES-CBC, PKCS#5 padding, hex output; `internal/util/encrypt.go:11`).
- **Request body:**
```json
{ "query": "SELECT id, name FROM public.some_table LIMIT 10" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `query` | string | yes | non-empty (else 400 `query is required`) |

- **Success 200:**
```json
{ "encrypted_query": "9f1c...e04a" }
```
- **Errors:** 400 `{"error":"invalid request payload"}` / `{"error":"query is required"}`; 401 (JWT); 500 `{"error":"configuration key KEY not found in environment"}` or cipher errors (e.g. invalid key length).
- **DB:** none. **Outbound:** none.

### POST `/api/v1/share/query`
- **Purpose:** execute arbitrary SQL supplied (encrypted) by the caller.
- **Flow:** handler → `shareService.InternalDBQuery` (`share_service.go:27`) → `util.DecryptAES` (hex → AES-CBC decrypt → PKCS#5 unpad) → `shareRepository.Query` (`share_repository.go:54`) runs `pool.Query(ctx, sql)` with **no parameters, no allow-list, no read-only transaction**; each row → `map[column]value` (`[]byte` converted to string).
- **Request body:**
```json
{ "query": "9f1c...e04a" }
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `query` | string (hex AES-CBC ciphertext) | yes | non-empty; must be valid hex, length ≥ 16 bytes |

- **Success 200:**
```json
{ "data": [ { "id": 1, "name": "example" } ] }
```
(empty result → `{"data": []}`)
- **Errors:** 400 (bind / empty query); 401 (JWT); 500 `{"error":"r.client.Query|<pg error>"}`, `{"error":"cipherText too short (less than block size 16)"}`, hex decode errors, missing `KEY`/`IV`.
- **DB:** whatever tables the decrypted SQL references (any statement type the DB user is allowed — SELECT/INSERT/UPDATE/DELETE/DDL).
- **Outbound:** none.

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| *Any* (dynamic SQL from caller) | R/W (depends on DB user grants) | `POST /api/v1/share/query` |
| `public.api_key` (`key`, `system_name`, `is_active`) | R | **None** — `IsConfigExists` (`share_repository.go:28`) is defined but never called |
| Stored functions | — | None defined/called by the service |

## Notes / ⚠️ unverified items
- **Security (high):** the service is effectively remote SQL execution. Protection rests entirely on (1) JWT HMAC secret and (2) AES key/IV secrecy. Any JWT holder can also call `/encrypt` to obtain valid ciphertext for any SQL, so the encryption adds no authorization. Recommend: restrict DB user to read-only, wrap in `SET TRANSACTION READ ONLY`, add statement allow-listing or wire up `public.api_key` checks, remove the hardcoded `JWT_SECRET` fallback literal.
- Static IV (`IV` env) for AES-CBC — same plaintext → same ciphertext.
- `rows.Scan` error is ignored and `rows.Err()` not checked (`share_repository.go:74`) — partial results possible silently.
- `NewShareRepository` error in `main.go:42` is not checked.
- `internal/model/user.go` (User structs) is unused.
- Committed `.env` contains real values (not reproduced) and a compiled `server` binary is in the folder — ⚠️ verify they are git-ignored.
- ⚠️ unverified: which services call this gateway and which DB it points to per environment (no helm/Dockerfile in folder).
