# 🚀 Merge Request (MR) Template - WS9 (Target: main)

**Source Branch:** `hotfix/ws9-ops`  
**Target Branch:** `main`  
**Assignee:** `T8-Kritsana-Wathaniyanon`  
**Reviewer:** `voranunb`  
**Repositories:** `go-echo-uam-service` / `go-echo-notification-service` / `go-echo-analytics-service`

---

## MR Title:
`hotfix(ws9): UAM connection pool tuning, Hotmail email headers & reconciliation report API`

---

## MR Description:

```markdown
## 📝 Summary of Changes (WS9)

- **UAM Connection Pool Tuning (WS9.1):** Configured production DB connection pool in `go-echo-uam-service/webserver/dbConnect.go` (`MaxOpenConns: 50`, `MaxIdleConns: 25`, `ConnMaxLifetime: 15m`, `ConnMaxIdleTime: 5m`, with `DB_MAX_OPEN_CONNS` env override).
- **Hotmail/Outlook Email Headers (WS9.3):** Updated `SendEmailSMTP` in `go-echo-notification-service/controllers/notificationController.go` to include required SMTP headers (`Reply-To`, `Message-ID`, `MIME-Version: 1.0`, `X-Priority: 3`) and TLS dialer settings.
- **Reconciliation Report API (WS9.4):** Created REST API `GET /api/v1/uam/report/reconcile` in `go-echo-uam-service` (`controllers/reportController.go` & `router/router.go`).
- **BigQuery Column Migration (WS9.5):** Added Thai to English view migration script `ws9_bigquery_column_migration.sql` in `go-echo-analytics-service`.

## 📁 Modified Files
- `go-echo-uam-service/webserver/dbConnect.go`
- `go-echo-uam-service/controllers/reportController.go`
- `go-echo-uam-service/router/router.go`
- `go-echo-notification-service/controllers/notificationController.go`
- `go-echo-analytics-service/ws9_bigquery_column_migration.sql`

## 🧪 Verification
- Verified 100% clean compilation (`go build ./...`) across all 3 microservices.

**Assignee:** T8-Kritsana-Wathaniyanon  
**Reviewer:** voranunb
```
