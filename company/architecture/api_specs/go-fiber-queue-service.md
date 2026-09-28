# go-fiber-queue-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-fiber-queue-service` (module `queue-service`). Read-only analysis, 2026-09-23.

## Overview

| Item | Value |
|---|---|
| Purpose | Thin **producer** for Google Cloud Tasks. Other services POST a target URL + payload; this service enqueues an HTTP task on a single, configured Cloud Tasks queue, scheduled **10 s later**. Cloud Tasks then calls the target URL (retries handled by the queue). It does not consume/process tasks itself. |
| Language / framework | Go, Fiber v2, GORM (postgres driver), `cloud.google.com/go/cloudtasks/apiv2`, go-playground/validator v10, viper |
| Entry point | `cmd/main.go` |
| Port | `config.containerPort` → env `HTTP_PORT` (helm value `8080`; local default `8080`) |
| Base path | `/api/v1/queue` (+ `/`, `/healthcheck`, `/readyz`) |
| Config source | `./configs/helm/helm-<env>.yaml` chosen by `ENV` (`local`/empty → `helm-local`, `dev`, `uat`, `prod`), then env overrides (`configs/config.go:143-160`) |
| Env var NAMES | `ENV`, `HTTP_PORT`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME`, `CLOUD_TASK_QUEUE_PROJECT_ID`, `CLOUD_TASK_QUEUE_QUEUE_ID`, `CLOUD_TASK_QUEUE_LOCATION_ID` |
| Credentials | GCP service-account file at **`/key.json`** (hard-coded, `infrastructure/gcp/gcpCon.go:22`); mounted from a k8s secret via helm `volumes`/`volumeMounts`. A `key.json` also exists in the repo root. |
| External calls | Google Cloud Tasks API `CreateTask` on `projects/{CLOUD_TASK_QUEUE_PROJECT_ID}/locations/{CLOUD_TASK_QUEUE_LOCATION_ID}/queues/{CLOUD_TASK_QUEUE_QUEUE_ID}`; indirectly, Cloud Tasks later calls the caller-supplied `url`. |
| Queues | Output: one Cloud Tasks queue (id from env). No consumer, no cron. |
| Deploy | `Dockerfile`, `.gitlab-ci.yml`, helm values `configs/helm/helm-{local,dev,dev2,uat,uat2,uat-isv,prod}.yaml`, `helm/helm-uat-isv.yaml` (image `.../insurverse-uat/insurverse/backend-queue-service`) |

## Auth & Middleware

Global (`cmd/main.go:29-33`): `cors.New()` (allow all origins), `helmet.New()`, `logger.New()`, `recover.New()`, `requestid.New()`; `healthcheck.New` (`main.go:43-50`).

**Auth: none.** Any caller that can reach the service can enqueue an HTTP task to an arbitrary URL with arbitrary headers (network-level protection assumed — ⚠️ unverified ingress exposure).

Response envelope (`pkg/presentaion.go`):
```json
{ "status": { "code": 1000, "header": "Success", "description": "Success" }, "data": null }
```
Status codes: `1000` success, `1001` success-with-condition, `2000` not found, `3000` request validation error, `8000` business-error-with-condition, `8888` technical error, `9000` file error, `9100` API error, `9200` DB error, `9999` business error.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/` | None | `testRoutes` closure — `cmd/main.go:114` | Echo/debug: returns caller IPs, method, path, query, UA |
| GET | `/healthcheck` | None | Fiber `healthcheck` → `Liveness` — `cmd/main.go:99` | Liveness (always true) |
| GET | `/readyz` | None | Fiber `healthcheck` → `Readiness` — `cmd/main.go:106` | Readiness: pings PostgreSQL |
| POST | `/api/v1/queue/create_task_queue` | None | `taskHandler.CreateTaskQueueHandler` — `internal/handler/task.go:40` (registered `:34`) | Enqueue an HTTP task on Cloud Tasks |

Total: **4 endpoints** (1 business + 3 infra/debug).

## Endpoints

### POST `/api/v1/queue/create_task_queue`
- **Purpose:** buffer an outbound HTTP call via Cloud Tasks (delayed 10 s, retried by queue policy).
- **Flow:** `CreateTaskQueueHandler` → validate → `loggingRepo.WriteLog` (slog only) → `taskUseCase.CreateTaskQueue` (`internal/usecase/task.go:42`) builds `CreateTaskRequest` → `taskRepo.CreateTask` (`internal/repository/task.go:30`) → Cloud Tasks.
- **Request body** (`internal/model/task.go`):
```json
{
  "title": "issue-policy-callback",
  "project_id": "ignored",
  "location_id": "ignored",
  "queue_id": "ignored",
  "message": "optional note",
  "payload": "{\"leadId\":123}",
  "url": "https://target-service.internal/api/v1/callback",
  "method": "POST",
  "headers": { "Content-Type": "application/json" }
}
```
| Field | Type | Required | Validation / notes |
|---|---|---|---|
| `url` | string | **yes** | `validate:"required"`; target URL Cloud Tasks will call |
| `method` | string | **yes** | `validate:"required"`; `POST`→HttpMethod 1, `GET`→2, anything else → 0 (`HTTP_METHOD_UNSPECIFIED`, Cloud Tasks defaults to POST) |
| `payload` | string | no | Sent as raw request body bytes (must be pre-serialized JSON string) |
| `headers` | map<string,string> | no | Copied to task HTTP headers |
| `title` | string | no | Only logged |
| `message` | string | no | Only logged |
| `project_id`, `location_id`, `queue_id` | string | no | **Ignored** — queue path always comes from config |

- **Success 200:**
```json
{ "status": { "code": 1000, "header": "Success", "description": "Success" } }
```
(Created task name is not returned.)
- **Errors:**
  - 400 `{"error":"Invalid input"}` — body parse failure
  - 400 `{"status":{"code":3000,"header":"Bad Request","description":"Key: 'TaskRequest.Url' Error:Field validation for 'Url' failed on the 'required' tag"}}`
  - 500 `{"status":{"code":8888,"header":"","description":"cloudtasks.CreateTask: <grpc error>"}}`
- **DB:** none (the DB connection is injected but unused by this flow).
- **Outbound:** Cloud Tasks `CreateTask`; task `ScheduleTime = now + 10s`.

### GET `/`
Returns `{"status":"success","data":{"host":[...],"method":"GET","path":"/","query":{},"ua":"..."}}`. Debug only.

### GET `/healthcheck` · GET `/readyz`
Fiber healthcheck middleware: 200 `OK` when probe true, 503 otherwise. `/readyz` does `sqlDB.PingContext`.

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| PostgreSQL connection (no tables) | ping only | `/readyz` |
| Stored functions | — | None |

`loggingRepo.WriteLog` (`internal/repository/logger.go:24`) writes only to stdout via `slog` — no DB table despite holding a `*gorm.DB`.

## Notes / ⚠️ unverified items
- **No authentication** and open CORS on an endpoint that makes Cloud Tasks call arbitrary URLs with arbitrary headers → SSRF-style risk if exposed beyond the cluster. ⚠️ unverified ingress config.
- `configs/config.go:setDefaults` (local profile only) contains hard-coded DB host/user/password — not reproduced here; recommend removal. `key.json` (GCP SA key) is present in repo root.
- DB is required at startup (`log.Fatal` if connection fails) although no business logic uses it.
- DSN uses `TimeZone=Asia/Shanghai` and `sslmode=disable` (`infrastructure/database/dbGorm.go:20`).
- `Configuration.PostgresConfig` has yaml tag `volumes` (copy-paste); viper decodes by mapstructure field name, so env bindings still work — ⚠️ unverified for yaml file values.
- Startup logs the full config struct (`main.go:39`), including DB password, to stdout.
- `pkg/cloud_tasks.go` is an empty placeholder; `internal/handler/task.go:81-103` is commented-out legacy code.
- Consumers (target URLs) are defined by callers; ⚠️ unverified which services call this queue service.
