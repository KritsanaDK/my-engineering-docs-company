# node-oic — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/node-oic` (package name `pre-cal`). Read-only analysis, 2026-09-23.

## Overview

| Item | Value |
|---|---|
| Type | **No HTTP API.** A one-shot, multi-process **batch job** (Node.js CLI) that bulk-calculates motor premiums against the OIC (คปภ.) tariff and reports which rate rows can be sold ("ลง OIC") vs rejected. |
| Language / runtime | Node.js 18 (`Dockerfile`: `node:18`), deps: `pg`, `axios`, `xlsx`, `dayjs`, `moment`, `@google-cloud/storage`, `google-auth-library` |
| Entry points | Docker: `node --max-old-space-size=30720 main2.js` (forks `cal2.js`). `npm start`: `node ... main` → `main.js` (forks `cal.js`). |
| Parallelism | Master splits rows into `os.cpus().length` chunks and `child_process.fork()`s one worker per CPU; workers report counts back via IPC (`process.send`). |
| Port | None |
| Config / env NAMES | `config.json` → `DB.{host,port,user,password,database,ssl.rejectUnauthorized}` (pg Pool). `credentials/config.json` → `activeProfile`, `profiles.<name>.{projectId,keyFilename,bucketName}` (GCS). Env: `INSURVERSE_GCS_PROFILE` (selects GCS profile: develop / uat / prod). |
| External calls | Google Cloud Storage (download input xlsx, upload reject CSV reports); HTTP POST (form-urlencoded `message=`) to an **n8n webhook** on host `n8n.achtix.com` (named `postApiLine` — LINE/email notification relay). |
| Background jobs | The process itself is the job; there is no internal cron. A job-lock row in `calculate_premium_job` prevents concurrent runs. Scheduling is external (⚠️ unverified — no CronJob/helm found in folder). |

## Auth & Middleware
Not applicable (no server). Access control relies on DB credentials in `config.json` and the GCS service-account key selected via `INSURVERSE_GCS_PROFILE`.

## Endpoint Summary

No HTTP API. Entry points:

| Kind | Name | File:line | Description |
|---|---|---|---|
| CLI (Docker default) | `node main2.js` | `main2.js` | Master: reads `run/runfile-new.xlsx` from GCS, forks `cal2.js` workers |
| CLI (`npm start`) | `node main.js` | `main.js:86` | Master: reads `run/runfile.xlsx` from GCS, forks `cal.js` workers |
| IPC worker | `cal.js` / `cal2.js` | `cal.js:2394` (`process.on("message")`) | Calculates premium for its chunk, writes logs/reports |
| Legacy script | `server_หน้า.js` | `server_หน้า.js:14` | Old standalone script reading table `prem` on a separate `test` DB (⚠️ unverified if still used) |
| Backup | `main2-backup.js` | — | Copy of master script, not referenced |

## Processing Flow (main.js / main2.js → cal.js / cal2.js)

1. **Download input** — `bucket.file("run/runfile.xlsx")` (`main2.js`: `run/runfile-new.xlsx`) → `file_temp/file.xlsx` (`main.js:87-91`).
2. **Parse Excel** first sheet with a fixed header map (`main.js:98-~200`), columns include: `Brand, Model, Year, Doors, Seat, Sedan, Group, Usage, CC, BodyType, Type, GarageType, NamedAge, MinSI, MaxSI, Split, SI_1..SI_5, Prem_OD_1..5, Prem_FT_1..5, SI_TPBI_1..`, … Rows without `Brand` are skipped; `Year` forced to string.
3. **Read flags** from `sys_param` (`main.js:222-235`): `dom_code='purchase'`, `sub_dom_code='premium'`, `para_code IN ('flag_acc_2plus','flag_acc_3plus')`, `para_status='ATV'` → `para_bool`.
4. **Acquire job lock** `startProcress()` (`main.js:61`): if any row in `calculate_premium_job` has `job_status=0` → exit (already running). Otherwise `INSERT (job_id = ISO timestamp, job_status = 0)` and notify n8n "OIC Calculation JOB_ID:… Started".
5. **Fork workers**, send `{ job_Id, core, dataRun, flagAcc }` via IPC.
6. **Worker** (`cal.js`): computes tariff factors (`tariffCalType1/2/3/5`: carSize, carUse, carAge, carGroup, NamedAge, sumAssured, TPBI_P, TPPD, attachmentPremium, cctvPercen), basic premium, fleet/NCB/other discount, duty, VAT; decides OIC-compliant or reject. Reject rows are accumulated into CSV and uploaded to GCS `log/old/<job_id>/Reject_Report<job_id>_core<n>_<k>.csv`; a pointer row `INSERT INTO log_calculate_premium (job_id, json)` is written (`cal.js:2197`, `2333`), and an n8n message with the file URL is sent. Worker returns `{allCase, okOIC, noOIC, OIC_loop, core}`.
7. **Finish** — when all workers report, master posts summary (เคส DIY ทั้งหมด / ขายได้ / ไม่ลง OIC / เคสโปรแกรมวิ่งหาการลง คปภ.) to n8n and `endProcress()` sets `calculate_premium_job.job_status = 1` (`main.js:50-58`).

### Outputs
| Output | Location |
|---|---|
| Reject CSV reports | GCS `<bucket>/log/old/<job_id>/Reject_Report<job_id>_core<n>_<k>.csv` |
| Job log rows | `insurverse.log_calculate_premium(job_id, json)` — json = `{allCase, file}` |
| Job status | `insurverse.calculate_premium_job(job_id, job_status)` |
| Notifications | n8n webhook (form field `message`) |
| Local files | `file_temp/file.xlsx` (downloaded input); legacy `OIC_Report.txt`, `Rject_Report.csv` in repo root |

## DB Usage (PostgreSQL, schema `insurverse`)

| Table / function | Read/Write | Used by |
|---|---|---|
| `insurverse.sys_param` | R | main.js / main2.js (flag_acc_2plus, flag_acc_3plus) |
| `insurverse.calculate_premium_job` | R/W (INSERT, UPDATE `job_status`) | main.js / main2.js job lock |
| `insurverse.log_calculate_premium` | W (INSERT) | cal.js / cal2.js |
| `insurverse."<tableName>"` (dynamic) | R (`count(1)`) | `countData()` in main.js — defined but not called in main flow |
| `insurverse."Imp_Price_Premium_pat"` / `Imp_Price_Premium_29jun` | — | Only in commented-out code (`cal.js:54`, `1858`) |
| `prem` (DB `test`) | R | `server_หน้า.js` (legacy) |
| Stored functions | — | None |

## Notes / ⚠️ unverified items
- **Security:** `server_หน้า.js` has a hard-coded Postgres host/user/password in source, and `credentials/` contains committed GCS service-account key files for develop/uat/prod. Values intentionally not reproduced here — recommend rotating and moving to secrets.
- **SQL injection risk:** all queries use string interpolation (`'${job_Id}'`, `"${tableName}"`, JSON in `log_calculate_premium`), no parameter binding.
- Stale-lock risk: if a run crashes before `endProcress()`, the `job_status=0` row blocks all future runs until manually updated.
- `endProcress()` updates `WHERE id = rows[0]?.id` of *any* pending job, not specifically the current `job_id`.
- `main.js` vs `main2.js`: differ in input file (`runfile.xlsx` vs `runfile-new.xlsx`), worker script (`cal.js` vs `cal2.js`) and error handling in `postApiLine` (main2 swallows errors). Docker runs `main2.js`.
- The n8n webhook path is hard-coded; ⚠️ unverified which channel (LINE / email) it forwards to.
- Scheduling/trigger of the job (k8s Job, manual run) ⚠️ unverified — no helm/cron manifest in the folder.
