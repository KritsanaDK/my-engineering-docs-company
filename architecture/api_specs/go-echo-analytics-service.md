# go-echo-analytics-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-analytics-service` (local working tree, read-only inspection, 2026-09-23).
> Everything below comes from the route registration code and the code it calls. Items that could not be confirmed are marked "⚠️ unverified".

## Overview

| Item | Value |
|---|---|
| Purpose | Collects front-end and app tracking events (page views, clicks, device info) and inserts each one as a row into a Google BigQuery table. |
| Framework | Go, Echo v4, `cloud.google.com/go/bigquery`, swaggo `echo-swagger` |
| Port | `HTTP_PORT` (default `8080`) |
| Base path | `/api/v1/analytics` (`router.GenApiVersion`, `router/router.go:32`; `ApiVersion = "v1"`) |
| Data store | Google BigQuery only. There is no PostgreSQL connection. The client is created in `webserver/bigqueryConnect.go:20` with the credentials file `key.json` in the working directory. |
| Graceful shutdown | On SIGTERM: wait 10s, then `e.Shutdown` with a 15s timeout (`main.go:44-52`), so the pod can leave the load balancer's network endpoint group (NEG) before exiting. |
| Background jobs | None |

### Environment variables (names only)

| Variable | Use | Fallback |
|---|---|---|
| `HTTP_PORT` | Listen port | `8080` |
| `ANALYTIC_TABLE` | Fully qualified BigQuery table (`project.dataset.table`) for the INSERT | `constants.AnalyticTable` (a develop test table) |
| `ANALYTIC_PROJECT_ID` | GCP project for the BigQuery client | `constants.AnalyticProjectID` |

Helm files also set `ENV`, `DB_HOST/DB_PORT/DB_USER/DB_PASS/DB_NAME` and `Base_Url`/`Backend_*`, but the code never reads them.

### External and outbound calls

| Target | Call | Used by |
|---|---|---|
| Google BigQuery | `Client.Query("INSERT INTO `<ANALYTIC_TABLE>` ...").Run(ctx)` | `POST /api/v1/analytics/analytics` |

## Auth & Middleware

- Global: `middleware.CORS()` with the default config, which allows all origins (`main.go:26`). **`middleware.Recover()` is not registered.**
- `e.Validator` is set to go-playground/validator (`router/router.go:49`). The DTO has no `validate` tags, so validation never rejects anything.
- Route middleware `middlewares.ValidateToken` (`middlewares/Validate.go:12`):
  - Reads `Authorization`, strips `Bearer `, and compares the result with the **static constant** `constant.AuthToken` (`constants/constant.go:5`, hardcoded in source; value not reproduced here).
  - A missing or wrong token returns `401 {"title":"Unsuccess","status":401,"description":"Unauthorized","result":""}`.
  - It is not a JWT or Keycloak check. Every client shares the same token.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | `main.go:55` (`healthcheck`) | Returns plain text `OK` |
| GET | `/swagger/*` | None | `router/router.go:48` (`echoSwagger.WrapHandler`) | Swagger UI and spec from the `docs` package |
| POST | `/api/v1/analytics/analytics` | Static Bearer token | `controllers/analytics.go:23` (`PostDataAnalytics`), registered at `router/router.go:52` | Inserts one analytics event into BigQuery |

Total: 3 routes (1 business endpoint, 1 health check, 1 Swagger UI).

## Endpoints

### GET /healthcheck
- **Response 200:** `text/plain` body `OK`.
- **DB / outbound calls:** none.

### GET /swagger/*
- Serves Swagger UI. The generated `docs/docs.go` still has template metadata (host `petstore.swagger.io`, BasePath `/v2`), so "Try it out" will point at the wrong host.

### POST /api/v1/analytics/analytics

- **Purpose:** record one tracking event.
- **Headers:** `Authorization: Bearer <static token>`, `Content-Type: application/json`.
- **Path/query params:** none.

**Request body** (`models.DataAnalytics`, `models/dataAnalyticsModel.go`; the JSON keys are PascalCase)
```json
{
  "EventId": "7f1c...", "SessionId": "s-123", "EventName": "click_buy", "EventValue": "plan_A",
  "CurrentPage": "/car/quote", "Device": "mobile", "Browser": "Chrome", "BrowserVersion": "128",
  "OS": "Android", "DeviceWidth": 390, "DeviceHeight": 844, "IPAddress": "1.2.3.4",
  "EventTimeStamp": "ignored", "UserId": "u-1", "LoginProvider": "google", "AppVersion": "1.0.0",
  "IMMEIId": "", "MACId": "", "CountryCode": "TH", "Latitude": 13.75, "Longitude": 100.5,
  "Language": "th", "CookieId": "c-1", "ExperimentId": "exp-1"
}
```

| Field | Type | Required | Validation / notes |
|---|---|---|---|
| `EventId` | string | no | none |
| `SessionId` | string | no | none |
| `EventName` | string | no | none |
| `EventValue` | string | no | none |
| `CurrentPage` | string | no | none |
| `Device` | string | no | none |
| `Browser` | string | no | none |
| `BrowserVersion` | string | no | none |
| `OS` | string | no | none |
| `DeviceWidth` | int | no | none |
| `DeviceHeight` | int | no | none |
| `IPAddress` | string | no | Taken from the client. The server does not derive it from the request. |
| `EventTimeStamp` | string | no | **Ignored.** The server stores `UNIX_MICROS(CURRENT_TIMESTAMP())`. |
| `UserId` | string | no | none |
| `LoginProvider` | string | no | none |
| `AppVersion` | string | no | none |
| `IMMEIId` | string | no | none |
| `MACId` | string | no | none |
| `CountryCode` | string | no | none |
| `Latitude` | float32 | no | none |
| `Longitude` | float32 | no | none |
| `Language` | string | no | none |
| `CookieId` | string | no | none |
| `ExperimentId` | string | no | none |

**Success 200** (`result` is the BigQuery job ID):
```json
{ "title": "Success", "status": 200, "description": "", "result": "job_AbC123..." }
```

**Error responses**

| HTTP | When | Body |
|---|---|---|
| 401 | Token missing or wrong | `{"title":"Unsuccess","status":401,"description":"Unauthorized","result":""}` |
| 400 | JSON bind error | text/plain `Bad Request` |
| 400 | Validator error (cannot happen today because there are no tags) | text/plain error text |
| (connection dropped) | `q.Run` fails: the error is only printed, then `even.ID()` is called on a nil job and panics. With no Recover middleware, net/http aborts the connection. | none (see Notes) |

- **BigQuery table:** `<ANALYTIC_TABLE>`, INSERT (parameterised query, `controllers/analytics.go:33-37`). The columns written are `EventId, SessionId, EventName, EventTimeStamp, EventValue, CurrentPage, Device, Browser, BrowserVersion, OS, DeviceWidth, DeviceHeight, IPAddress, Language, UserId, LoginProvider, AppVersion, IMMEIId, MACId, CountryCode, Latitude, Longitude, ExperimentId, CookieId`.
- **Stored functions / PostgreSQL:** none.
- **Outbound calls:** BigQuery API.

## DB Usage

| Table / function | Read / write | Endpoints |
|---|---|---|
| BigQuery `<ANALYTIC_TABLE>`. Per-environment helm values point at `insurverse-{develop,uat,prod}` datasets; the prod value starts with `insurverse-prod.ANALYTIC...`. ⚠️ Full table names were not verified. | write (INSERT) | `POST /api/v1/analytics/analytics` |
| PostgreSQL tables / stored functions | none | — |

`ws9_bigquery_column_migration.sql` in the repo root defines BigQuery views over `insurverse_analytics.policy_daily_lastversion`. No route uses it; it is a standalone migration script.

## Notes / ⚠️ unverified items

1. **A nil-pointer panic can drop requests.** If the BigQuery insert fails, `even` is nil and `even.ID()` panics (`controllers/analytics.go:65-69`). There is no `middleware.Recover()`, so the client gets a dropped connection instead of a 5xx.
2. **The auth token is hardcoded** in `constants/constant.go` and shared by every client. It should move to an env or secret.
3. **A GCP service-account key is in the repo.** `key.json` sits in the repo working tree and is loaded by path. Check whether it is tracked in git (⚠️ unverified, since git commands were not allowed).
4. **Invalid payloads still get inserted.** There are no validation tags, so empty or partial events are inserted.
5. **Some constants are unused by routes.** `utils` has `HashPassword`/`GenOTP` helpers that no route uses. The `ENV`/`DB_*`/`Backend_*` values in the helm files are also unused.
6. `helper/error.go` and `helper/response.go` are not referenced by the route.
