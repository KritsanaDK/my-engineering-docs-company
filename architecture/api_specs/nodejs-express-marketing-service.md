# nodejs-express-marketing-service — API Spec

> Generated from source on 2026-09-23 (read-only review). File:line refs are relative to `nodejs-express-marketing-service/`.

## Overview

| Item | Value |
|---|---|
| Purpose | ETL client that pulls IIA policy/claim data from the IIA back-end (`/API_IIA_Bigquery/*`) page by page and UPSERTs it into Postgres `insurverse.iia_data_sr_*` tables. BigQuery is fed downstream by Datastream (the service never writes to BigQuery directly — see `docs/bigquery-sync-api.md`). Despite the name, no "marketing" endpoints exist in the current code. |
| Language / framework | Node.js, Express 4 (`services/express.service.js`), Sequelize (postgres dialect, raw SQL), axios |
| Port | `3001` hard-coded in `services/config.service.js:6` (Dockerfile `EXPOSE 3001`, helm `port: 3001`) |
| Base path | `/api/v1/marketing` (`configService.referencesPath`, `services/config.service.js:7`) |
| Entry | `server.js` → `services/express.service.js:20 expressInit()` → `services/routing.service.js:6 routingConfig()` |
| DB | Postgres, schema/searchPath `insurverse` (`services/sequelize/index.js`), pool max 10 / min 3 |
| Invocation pattern | Single RPC-style route; operation chosen by `body.fn` (dispatched via `utility.service.js:37 callFunc`). Triggered by Cloud Scheduler (per `docs/bigquery-sync-api.md`). |

### Environment variables (names only)

| Name | Used in | Purpose |
|---|---|---|
| `DATABASE_HOST`, `DATABASE_NAME`, `DATABASE_USER`, `DATABASE_PASSWORD` | `services/sequelize/index.js:9-13` | Postgres connection |
| `IIA_ENDPOINT` | `services/iia.service.js` (all sync functions) | Base URL of the IIA back-end |
| `IIA_ALLOCATE_EXPENSE_AUTH` | `services/iia.service.js:179` | `Authorization` header for `claims-m-movement-allocate-expense` (a hard-coded Basic fallback exists in code — ⚠️ should be removed; value intentionally not reproduced) |
| `IIA_ALLOCATE_EXPENSE_TIMEOUT_MS` | `services/iia.service.js:170` | Request timeout for allocate-expense (default 120000) |
| helm-only (not read by current code): `ENV`, `SF_ENDPOINT`, `SF_Client_ID`, `SF_Client_Secret`, `SF_UserName`, `SF_Password`, `Base_Url`, `Backend_Doc`, `Backend_Auth`, `Backend_Core`, `Backend_File`, `Backend_Notification`, `Backend_Purchase`, `Backend_Consent`, `Backend_Premium`, `Backend_Saleforce`, `Backend_Uam`, `Backend_Analytics`, `Url_Fontend`, `ENC_KEY`, `IV` | `helm/helm-uat-isv.yaml` | Leftovers from shared template |

### External / third-party calls

All `POST` via axios to `${IIA_ENDPOINT}/API_IIA_Bigquery/...`, body `{ ReportDate|LoadDate|IsClose, Page, PageSize: 1000 }`, response expected as `{ data: [ ...rows ] }`. Recursion continues page+1 until `data.length === 0`.

| IIA path | Called by (service fn, file:line) |
|---|---|
| `/API_IIA_Bigquery/policies` | `policiesInsert` `services/iia.service.js:53` |
| `/API_IIA_Bigquery/lastversion-policies` | `policiesLastversionInsert` `:74` |
| `/API_IIA_Bigquery/claims-m-lastversion` | `motorClaimLastversionInsert` `:95`, `motorClaimLastversionInsertInitial` `:115` |
| `/API_IIA_Bigquery/claims-m-movement` | `motorClaimMovementInsert` `:135` |
| `/API_IIA_Bigquery/claims-m-movement-allocate-expense` (requires `Authorization`) | `motorClaimMovementAllocateExpenseInsert` `:165` (timeout + 3 attempts, 5s×attempt backoff) |
| `/API_IIA_Bigquery/claims-nm-movement` | `nonMotorClaimMovementInsert` `:222` |
| `/API_IIA_Bigquery/claims-nm-lastversion` | `nonMotorClaimLastVersionInsert` `:246` |

## Auth & Middleware

Order in `services/express.service.js:20-40` then `services/routing.service.js`:

1. `express-session` (secret hard-coded in code — ⚠️ not reproduced; should move to env).
2. `cors()` — all origins.
3. `bodyParser.json` / `urlencoded` (limit 50mb).
4. `GET /healthcheck` — registered **before** the middleware, so it is unauthenticated.
5. Global middleware `services/middleware.service.js:24`:
   - **Injection filter**: lower-cased `JSON.stringify(req.body)` rejected if it contains `;`, `--` or `'` → HTTP **200** `{ "status": false, "msg": "API Reject Request (Injection Detection)" }`.
   - **fn allow-list** (`skipAuth`, `:9-19`): request passes only if `body.fn` is one of the 9 sync functions. Otherwise HTTP **200** `{ "status": false, "msg": "API Reject Request (Authentication Failed)" }`.
   - **No token / JWT verification is performed.** `auth.service.js` (JWT sign/verify with keys in `config.service.js`) is imported but never called on any route. Effectively the API is **unauthenticated**; protection relies on network (ingress/Cloud Scheduler).
   - Attaches helpers `res.responseSuccess(data)` → **201** `{status:true,data}`; `res.responseFailure(msg)` → **400** `{status:false,msg}`.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | inline `services/routing.service.js:10` | Liveness, returns `{}` |
| GET, POST | `/api/v1/marketing/iiaAPI` | fn allow-list only (no token) | `controllers/iia.controller.js:22 index()` → `utility.service.js:37 callFunc` | RPC dispatcher on `body.fn` |

Operations reachable through `/api/v1/marketing/iiaAPI` (`body.fn`):

| fn | Handler (file:line) | Target table | Start-date source |
|---|---|---|---|
| `syncPolicies` | `controllers/iia.controller.js:72` | `iia_data_sr_policy_daily` | override or `max(reportdate)` − 1 month |
| `syncPoliciesLastversion` | `:83` | `iia_data_sr_policy_daily_lastversion` | override or `max(reportdate_issued)` − 1 month |
| `syncMotorClaimLastversion` | `:96` | `iia_data_sr_motor_claim_lastversion` | none (`IsClose:false`) |
| `syncMotorClaimLastversionInitial` | `:101` | `iia_data_sr_motor_claim_lastversion` | none (no IsClose filter; full pull) |
| `syncMotorClaimMovement` | `:108` | `iia_data_sr_claim_motor_movement` | override or `max(loaddate)` − 1 month |
| `syncMotorClaimMovementAllocateExpense` | `:125` | `iia_data_sr_claim_motor_movement_allocate_expense` | override or `max(loaddate)` − 1 month; empty table → `2000-01-01` |
| `syncMotorClaimMovementAllocateExpenseInitial` | `:138` | same as above | override or `2000-01-01` |
| `syncNonMotorClaimMovement` | `:149` | `iia_data_sr_claim_nonmotor_movement` | override or `max(loaddate)` − 1 month |
| `syncNonMotorClaimLastversion` | `:160` | `iia_data_sr_nonmotor_claim_lastversion` | override or `max(loaddate)` − 1 month |

## Endpoints

### GET /healthcheck
- Purpose: k8s liveness/readiness.
- Params/body: none.
- Response `200`: `{}`
- DB / outbound: none.

### GET | POST /api/v1/marketing/iiaAPI

Common contract for all `fn` operations.

**Request body**

```json
{
  "fn": "syncPolicies",
  "reportdate": "2026-08-01"
}
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `fn` | string | Yes | Must be one of the 9 allow-listed names (middleware) and a method on the controller |
| `reportdate` | string | No | `YYYY-MM-DD` or `YYYY-MM` (strict moment parse, `iia.controller.js:34`); `YYYY-MM` → 1st of month. Ignored by `syncMotorClaimLastversion*` |
| `loaddate` | string | No | Alias of `reportdate` (used only if `reportdate` absent) |

Whole body must not contain `;`, `--` or `'`.

**Behaviour**: the controller resolves the start date (`resolveStartDate`, `iia.controller.js:61`: `SELECT to_char(max(<col>),'YYYY-MM-DD') FROM <table>`), fires the service sync **without awaiting it** (fire-and-forget), and responds immediately. The sync pages through IIA (1000 rows/page) and for each page runs one multi-row `INSERT ... ON CONFLICT (<key>) DO UPDATE SET col = EXCLUDED.col` (`utility.service.js:198 queryBuilderUpsertClaim`, via `iia.service.js:34 buildPageUpsert`, which pads missing keys with NULL and de-duplicates the conflict key within a page). Columns are taken from IIA JSON keys, so target table columns must match IIA field names.

**Success response** — HTTP `201`

```json
{ "status": true, "data": { "reportdate": "2026-07-01" } }
```
(`syncMotorClaimLastversion` / `...Initial` return `"data": {}`.) A 201 means *started*, not *completed*; sync errors are only logged (`console.error`) and never returned.

**Error responses**

| HTTP | Body | Cause |
|---|---|---|
| 400 | `{ "status": false, "msg": "Invalid reportdate \"x\" - expected YYYY-MM-DD or YYYY-MM" }` | bad `reportdate`/`loaddate` |
| 200 | `{ "status": false, "msg": "API Reject Request (Authentication Failed)" }` | `fn` missing / not allow-listed |
| 200 | `{ "status": false, "msg": "API Reject Request (Injection Detection)" }` | body contains `;`, `--`, `'` |
| 200 | `{ "status": true, "msg": { "info": "Function \"x' was not found", ... }, "data": {} }` | fn allow-listed but not implemented (currently unreachable) |
| 500 | Express default | DB error while reading `max()` (unhandled promise, ⚠️ may hang instead) |

#### Per-operation details

| fn | IIA call body | Upsert conflict key | DB read (start date) | DB write |
|---|---|---|---|---|
| `syncPolicies` | `{ReportDate, Page, PageSize}` → `/policies` | `reportdate,dfpolicyno,endorseseries` | `iia_data_sr_policy_daily.reportdate` | `iia_data_sr_policy_daily` |
| `syncPoliciesLastversion` | `{ReportDate,...}` → `/lastversion-policies` | `dfpolicyno` | `iia_data_sr_policy_daily_lastversion.reportdate_issued` | `iia_data_sr_policy_daily_lastversion` |
| `syncMotorClaimLastversion` | `{IsClose:false,...}` → `/claims-m-lastversion` | `claimno` | — | `iia_data_sr_motor_claim_lastversion` |
| `syncMotorClaimLastversionInitial` | `{Page, PageSize}` → `/claims-m-lastversion` | `claimno` | — | `iia_data_sr_motor_claim_lastversion` |
| `syncMotorClaimMovement` | `{ReportDate,...}` → `/claims-m-movement` | `approvedate,claimno,estimateno,rectype` | `iia_data_sr_claim_motor_movement.loaddate` | `iia_data_sr_claim_motor_movement` |
| `syncMotorClaimMovementAllocateExpense` | `{LoadDate,...}` + `Authorization` → `/claims-m-movement-allocate-expense`; renames column `estimated_od_รย` → `estimated_od_ry` | `approvedate,claimno,estimateno,rectype` | `iia_data_sr_claim_motor_movement_allocate_expense.loaddate` | same table |
| `syncMotorClaimMovementAllocateExpenseInitial` | same as above, LoadDate default `2000-01-01` | same | — | same table |
| `syncNonMotorClaimMovement` | `{ReportDate,...}` → `/claims-nm-movement` | `approvedate,dfclaimno,estimateno` | `iia_data_sr_claim_nonmotor_movement.loaddate` | `iia_data_sr_claim_nonmotor_movement` |
| `syncNonMotorClaimLastversion` | `{ReportDate,...}` → `/claims-nm-lastversion` | `dfclaimno` | `iia_data_sr_nonmotor_claim_lastversion.loaddate` | `iia_data_sr_nonmotor_claim_lastversion` |

No stored functions/procedures are called.

## DB Usage

All tables in schema `insurverse`.

| Table / function | Read / Write | Endpoints (fn) |
|---|---|---|
| `iia_data_sr_policy_daily` | R (max reportdate) / W (upsert) | `syncPolicies` |
| `iia_data_sr_policy_daily_lastversion` | R (max reportdate_issued) / W | `syncPoliciesLastversion` |
| `iia_data_sr_motor_claim_lastversion` | W | `syncMotorClaimLastversion`, `syncMotorClaimLastversionInitial` |
| `iia_data_sr_claim_motor_movement` | R (max loaddate) / W | `syncMotorClaimMovement` |
| `iia_data_sr_claim_motor_movement_allocate_expense` | R (max loaddate) / W | `syncMotorClaimMovementAllocateExpense`, `syncMotorClaimMovementAllocateExpenseInitial` |
| `iia_data_sr_claim_nonmotor_movement` | R (max loaddate) / W | `syncNonMotorClaimMovement` |
| `iia_data_sr_nonmotor_claim_lastversion` | R (max loaddate) / W | `syncNonMotorClaimLastversion` |
| Stored functions | — | none |

## Notes / ⚠️ unverified items

- ⚠️ **No real authentication** — only an fn allow-list; JWT helpers unused. Hard-coded secrets exist in `services/config.service.js`, `services/express.service.js:22` (session secret) and `services/iia.service.js:179` (Basic-auth fallback). Values deliberately not copied here; recommend moving to env/secret manager.
- ⚠️ Fire-and-forget: HTTP 201 is returned before the sync finishes; failures only appear in logs. Non-allocate syncs stop at the first failed page with no retry.
- ⚠️ SQL is built by string concatenation (quotes escaped for strings only); table/column names come from IIA JSON keys.
- ⚠️ Rejections return HTTP 200 with `status:false` rather than 4xx.
- ⚠️ `GET` on `/iiaAPI` only works if a JSON body is sent (fn required).
- The formidable/multipart branch in `utility.service.js:62+` (no `fn`) is unreachable because the middleware rejects requests without an allow-listed `fn`.
- Target table column definitions were not verified against a live DB; see `migration/*.sql` for the original DDL.
- `docs/iia-bigquery-policies.openapi.yaml` and `docs/bigquery-sync-api.md` are existing supplementary docs in the repo.
