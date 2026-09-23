# 🚀 Release Pack 05 — FX-01 / OIC / WS6–9 (+ ส่วนที่เหลือของ WS1–5) (Production Deployment Pack)

> **จัดทำ:** 2026-09-23 · **สถานะ:** 🟡 DRAFT — ยังไม่พร้อม Deploy ทั้งชุด (มี Blocker ใน §2)
> **ขอบเขต:** 4 สายงานแยกกัน — **WS1–5** (ขึ้น Prod แล้ว), **OIC** (พ.ร.บ. คปภ. / CMI Realtime), **WS6–9**, **FX-01** — ตาม Golden Rule 5
> ⚠️ **CI Deploy Prod อัตโนมัติจาก `main` เท่านั้น** (`configuration/cicd/k8s-deploy-gcp.yml`: build/deploy prod `only: main`) → **กด Merge MR = ขึ้น Prod ทันที** ดังนั้น DB ที่โค้ดต้องใช้ต้องรันเสร็จ "ก่อน" กด Merge และ Prod = โค้ดใน `main` เสมอ (อะไรไม่อยู่ใน main = ไม่อยู่บน Prod)
> **ข้อห้าม:** ห้าม merge `uat-isv` → `main` ทั้ง branch — ขึ้น Prod ผ่าน **MR จาก branch งานแต่ละตัว → `main`** และคนเป็นผู้ Review/Merge เท่านั้น (Rule 10)

---

## 0. สรุปสำหรับผู้ตัดสินใจ (Executive Summary)

| สาย | DB | โค้ด | พร้อม? |
| :--- | :--- | :--- | :---: |
| **FX-01** (#6, #13, #15, #17, #23, #24, #25, #27) | Job 04 (#13) เท่านั้น | 8 branch `fix/fx-01-*` แตกจาก `main`, merge ได้ไม่ชน | ✅ Wave 1 |
| **WS1–5** | ✅ **ขึ้น Prod แล้ว** (ยืนยันโดยเจ้าของงาน 2026-09-23) รวม SQL A — ไม่รันซ้ำ, Step 0 ใช้ยืนยันเท่านั้น | ของที่เหลือใน `hotfix/ws1–5*` = โค้ดที่ **ยังไม่อยู่บน Prod** (§4.2) | 🟡 รอตัดสินใจว่าต้องขึ้นไหม |
| **OIC** (พ.ร.บ. คปภ. / CMI Realtime) | ✅ **ไม่มี DB ใหม่** — ตาราง/คอลัมน์ที่ใช้ (`mas_cmi_brand_model`, `mas_cmi_province`, `cmi_*` 5 คอลัมน์ใน `Policy_Car_Act_Discount_Premium`) มีใช้อยู่แล้วในโค้ด `main` = มีบน Prod แล้ว | `hotfix/oic` ใน uam / fiber-policy / premium / nextjs — ยังไม่อยู่ใน `main`; uam + fiber-policy มีงานคนอื่นปน, uam ชน `main` (§4.3) | ⛔ ต้องทำ branch สะอาดก่อน |
| **WS6–9** | `ws6_ws7_combined_renewal_master.sql` **พังบน Prod แน่นอน** (2 Defect) | branch ส่วนใหญ่เก่า (behind 50–120) และชน `main` 7 ตัว | ⛔ ต้องแก้ก่อน |

---

## 1. ลำดับการ Deploy (Deployment Sequence)

```
Step 0  รัน sql/00_prod_precheck_readonly.sql บน Prod → ส่งผลกลับมาเทียบ §3
Step 1  Wave 1 — FX-01
          1a DB: Job 04 (00 → 01 → 02 → 03)   ← ต้องเสร็จก่อน premium 7e03e85
          1b MR 8 ตัว (§4.1) → main → CI deploy
          1c Verify (§6)
Step 2  Wave 2 — WS ที่ merge ได้สะอาด (§4.2) หลังเจ้าของยืนยัน scope + ผลเทสต์
Step 3  OIC (§4.3) — โค้ดอย่างเดียว ไม่มี DB; หลังทำ branch สะอาดจาก main + E2E บน uat-isv
Step 4  Wave 3 — WS ที่ชน main (§4.4) + WS6/7 SQL ฉบับแก้ (§2)
```

---

## 2. Database

| ID | ไฟล์ | Object ที่เปลี่ยน | สถานะ | เหตุผล |
| :-: | :--- | :--- | :---: | :--- |
| **D** | `04_motor_lead_seq/sql/00→03` | `seq_lead_no`, `Lead_No DEFAULT` | ✅ **READY** | ทดสอบบน UAT-ISV แล้ว (50 concurrent, ไม่ซ้ำ), idempotent, มี rollback |
| **A** (WS1–5) | `01_oic/sql/ws1_ws5_concurrency_safe_master.sql` (อยู่ในโฟลเดอร์ OIC แต่เป็นของ **WS1–5**) | `fn_lead_to_car_act`, `fn_policy_to_car_act`, `fn_policy_invoiceno_iia`, `fn_policy_quatationno_iia` | ✅ **ขึ้น Prod แล้ว — ไม่รันซ้ำ** (เดิม: HOLD) | เจ้าของงานยืนยัน WS1–5 ขึ้น Prod แล้ว → Step 0 ใช้แค่ยืนยัน (มี advisory lock ครบ 4 ตัว) — ⚠️ ห้ามใช้ไฟล์นี้เป็น Rollback/Redeploy: body **ไม่ตรงกับ UAT-ISV ทั้ง 4 ตัว** (md5 §3) และใช้ `DROP FUNCTION` ก่อน `CREATE` (GRANT/dependency หาย) |
| **B** | `02_ws6_9/sql/ws6_ws7_combined_renewal_master.sql` | `fn_policy_renewal`, `fn_format_utc_timestamp_th`, `UPDATE "Policy_Header"` ×2 | ⛔ **BLOCKED** | ดู Defect B1–B3 ด้านล่าง |
| **C** | `02_ws6_9/sql/ws9_bigquery_english_view.sql` | BigQuery view `insurverse_analytics.v_policy_daily_english` | 🟡 แยกรัน | ไม่ใช่ Postgres — รันใน BigQuery Console, ไม่ขึ้นกับลำดับ |

### Defect ของไฟล์ B (ตรวจบน UAT-ISV 2026-09-23, Rule 6)

- **B1 — Signature ไม่ตรง → สร้าง Overload แทนการแทนที่:** ไฟล์ประกาศ `fn_policy_renewal(p_policy_no varchar, p_flag_noti bool DEFAULT false, p_flag_lead bool DEFAULT false)` แต่ของจริงคือ `fn_policy_renewal(in_policy_no text, in_flag_noti bool, in_flag_lead bool, in_bad_behavior bool DEFAULT false)` (107 KB) — `CREATE OR REPLACE` จะ **เพิ่มฟังก์ชันตัวที่สอง (3.3 KB)** แทนการแทนที่; premium เรียกด้วย literal 3 ตัว → PostgreSQL เลือกตัว `text` เดิม → **ตัวใหม่ไม่ถูกเรียก = logic WS6/WS7 ในไฟล์ไม่มีผล** และทิ้ง overload ค้าง (แก้ไข 2026-09-23: เดิมเขียนว่า Renewal จะพัง — ตรวจกฎ overload resolution แล้วไม่ใช่) — รายละเอียด `sql_readiness_review_20260923.md`
- **B2 — Type error ยกเลิกทั้ง Transaction:** `WHERE (no_cancel_flag = true …)` แต่ `no_cancel_flag` เป็น `varchar` → `ERROR: operator does not exist: character varying = boolean` → ทั้งไฟล์ (BEGIN…COMMIT) Rollback
- **B3 — ความหมายข้อมูล:** ตั้ง `"Policy_Status" = 'C'` แต่ comment ของคอลัมน์ระบุค่าเป็น `ACT, INC, 11, 00` — ไม่มี `'C'`; และ `no_cancel_flag` ชื่อสื่อว่า "ห้ามยกเลิก" แต่สคริปต์ใช้เป็นเงื่อนไข "ยกเลิกแล้ว" → **ต้องให้เจ้าของ Business ยืนยันก่อน**
- **B4 — ไม่มี Backup แถวข้อมูล:** UPDATE แก้ข้อมูลจริง ต้อง Backup แถวที่ตรงเงื่อนไขก่อน (ตอนนี้มีแค่ Backup function `backups/backup_ws6_ws7_functions_20260921_100251.sql`)

➡️ **ข้อเสนอ:** เขียนไฟล์ B ใหม่จาก definition ที่ทดสอบแล้วบน UAT-ISV (`pg_get_functiondef`) + แยก Data Patch เป็นไฟล์ของตัวเองที่มี Backup แถว/Dry-run/Rollback — รออนุมัติ

---

## 3. ค่าอ้างอิงจาก UAT-ISV (สำหรับเทียบผล Step 0)

| function | identity args | md5 (UAT-ISV) | ขนาด | lock | md5 ในไฟล์ Pack |
| :--- | :--- | :--- | ---: | :-: | :--- |
| `fn_lead_to_car_act` | `lead_no bigint` | `40184b44dbf420159f38f1798eaa7830` | 9010 | ✅ | `5ff5bd5f…` ❌ ไม่ตรง |
| `fn_lead_to_car_act` | `lead_no integer` | `609f4d6334eb4e948824ffdc6d682935` | 135 | – | (ไม่มีในไฟล์) |
| `fn_policy_to_car_act` | `policy_no text` | `657dc56f11ffd2056bb21a07797cd139` | 15154 | ✅ | `7fceaf39…` ❌ |
| `fn_policy_invoiceno_iia` | – | `55132eabe26a6d5332da194f5eaa25c9` | 2281 | ✅ | `e15aa738…` ❌ |
| `fn_policy_quatationno_iia` | – | `e329a89dce1002914a1464c275fdd70a` | 3086 | ✅ | `90be0ec2…` ❌ |
| `fn_policy_renewal` | `in_policy_no text, in_flag_noti boolean, in_flag_lead boolean, in_bad_behavior boolean` | `1a87c166fe05bc49892cb57d8fdc8a87` | 107107 | – | `8d021015…` ❌ (signature ต่าง) |
| `fn_format_utc_timestamp_th` | `p_timestamp timestamp without time zone` | `e994e9b5e5f29d9f5a27d89d19f0b7b7` | 227 | – | `268b2ffc…` ❌ |

**อ่านผล Step 0:** ถ้า md5 บน Prod = UAT-ISV → ไม่ต้องรัน; ถ้าต่าง → ต้องได้ definition ที่ผ่านการทดสอบมาเป็นไฟล์ Deploy ก่อน (ไม่ใช้ไฟล์ Pack เดิม)

---

## 4. Git Readiness — MR เข้า `main` (คนเป็นผู้ Merge)

ตรวจ 2026-09-23 ด้วย `git merge-tree` (merge จำลอง) เทียบ `origin/main`

### 4.1 Wave 1 — FX-01 ✅ พร้อมเปิด MR (แตกจาก `main`, behind 0, ไม่ชน, ผ่าน E2E บน UAT-ISV)

| Repo | Branch | Commit | Issue | E2E |
| :--- | :--- | :--- | :-: | :-: |
| `nodejs-express-premium-service` | `fix/fx-01-premium` | `7e03e85` Lead_No จาก sequence | #13 | ✅ (ต้องรัน DB D ก่อน) |
| `isv-test` | `fix/fx-01-isv-test` | `92688d2` Short link UA + endpoint | #15 | ✅ |
| `go-echo-analytics-service` | `fix/fx-01-analytics` | `d28bb6c` graceful drain | #25 | ✅ 0×503 |
| `go-oauth2-server` | `fix/fx-01-oauth2` | `bc47a8e` graceful drain | #24 | ✅ 0×503 |
| `go-e-api` | `fix/fx-01-e-api` | `374cbca` non-JSON guard | #27 | ✅ |
| `go-echo-lead-policy-service` | `fix/fx-01-lead-policy` | `e7a7fbf` non-JSON guard | #17 | 🟡 unit test (รอ Backoffice) |
| `python-fastapi-document-service` | `fix/fx-01-document` | `35c58b7` retry replica lag | #6 | 🟡 ตรวจโค้ด |
| `go-echo-uam-service` | `fix/fx-01-uam` | 5 commits (`3c0d2ed` OCR fallback #23 + `11b6b38`, `70516c7`, `9e0f5c3`, `65fdb48`) | #16/#23 | ⚠️ ต้อง Review scope — 3 commit ขอบเขตกว้างกว่า FX-01 |

ลิงก์เปิด MR: `https://isv-gl-s.insurverse.co.th/insurverse/<group>/<repo>/-/merge_requests/new?merge_request[source_branch]=<branch>&merge_request[target_branch]=main`
(group: `open-api` สำหรับ `go-e-api`, `go-oauth2-server` · `backend` สำหรับตัวอื่น)
**ห้ามติ๊ก "Merge when pipeline succeeds"**

### 4.2 Wave 2 — WS merge ได้ไม่ชน 🟡 (ต้องให้เจ้าของยืนยันว่ายังต้องการและผ่านเทสต์)

> WS1–5 ขึ้น Prod แล้ว แต่ branch `hotfix/ws1–5*` ยังมีโค้ดที่ **ไม่อยู่ใน `main` = ไม่อยู่บน Prod** (เพิ่มหลังรอบ Deploy หรือไม่ได้รวมใน squash):
>
> | Branch | สิ่งที่ยังไม่อยู่บน Prod | หมายเหตุ |
> | :--- | :--- | :--- |
> | `go-echo-purchase-service` `hotfix/ws1-policy-issue` | `paymentController.go` +41 (commit ล่าสุด 2026-09-22) | ⚠️ มี `helm-uat-isv.yaml`, `helm-uat.yaml`, `.gitlab-ci.yml` ปน → ห้าม MR ตรง ต้อง cherry-pick เฉพาะ controller |
> | `go-echo-lead-policy-service` `hotfix/ws1-policy-issue` / `ws3-cmi` | CMI service/repository, `scripts/resubmit_batch.go`, `utils/keycloak.go` | scripts ไม่ควรขึ้น image Prod — Review |
> | `node_iia_service` `hotfix/ws4-caim` | `iia/implement.go` +68, `utils/helper.go` +62 (+ tests) | Review |
> | `go-echo-purchase-service` `hotfix/ws5-invoice` | `coreController.go` +8, `ws5_database_patches.sql` | ไฟล์ SQL ไม่ควรอยู่ใน repo service |
> | `go-e-api` `hotfix/ws1-policy-issue` | 1 บรรทัดใน `payment/repository.go` | เล็ก |
> | `go-echo-uam-service` `hotfix/ws5-invoice`, `python-fastapi-document-service` `hotfix/ws1-policy-issue` | conflict (`.gitignore` / `etax.go`) | ย้ายไป Wave 3 |

| Repo | Branch | net files | behind main |
| :--- | :--- | ---: | ---: |
| `go-e-api` | `hotfix/ws1-policy-issue` | 1 | 15 |
| `go-echo-lead-policy-service` | `hotfix/ws1-policy-issue` / `hotfix/ws3-cmi` | 10 / 5 | 13 |
| `go-echo-purchase-service` | `hotfix/ws1-policy-issue` / `ws5-invoice` / `ws7-renew` | 5 / 3 / 4 | 21 / 51 / 51 |
| `go-echo-uam-service` | `hotfix/ws7-renew` / `hotfix/ws8-backoffice` | 4 / 1 | 0 / 65 |
| `go-echo-backoffice-service` | `hotfix/ws8-backoffice` (มี commit ของ voranun 1 ตัว) | 7 | 2 |
| `go-echo-analytics-service` | `hotfix/ws9-ops` | 1 | 2 |
| `node_iia_service` | `hotfix/ws4-caim` | 13 | 0 |

> Playbook ระบุว่า WS1–5 ขึ้น Prod แล้ว (release 21 ก.ย. แบบ squash) แต่ merge จำลองยังเพิ่มไฟล์ใหม่ → ต้องเทียบทีละ branch ว่ายังขาดอะไรจริง ก่อนเปิด MR

### 4.3 OIC (พ.ร.บ. คปภ. / CMI Realtime) — สายงานแยก, โค้ดอย่างเดียว

| Repo | Branch | ไฟล์หลักที่เราแก้ | ปัญหา |
| :--- | :--- | :--- | :--- |
| `go-echo-uam-service` | `hotfix/oic` | `controllers/cmiRealtimeController.go` (+test), `models/cmiRealTimeModel.go`, `userController.go` | ⛔ conflict 2 ไฟล์ + งานคนอื่นปน 7 คน (37 จาก 71 commit ไม่ใช่ของเรา) |
| `go-fiber-policy-service` | `hotfix/oic` | `internal/{repository,service}/cmi_realtime.go` (+test), `issue.go`, `handler/router.go` | ⛔ งานคนอื่นปน 50 จาก 74 commit + `helm-uat-isv.yaml` |
| `nodejs-express-premium-service` | `hotfix/oic` | `controllers/act.controller.js`, `validation/act_validation.js` | 🟡 merge ได้ไม่ชน แต่มี `helm-uat-isv.yaml` + `scripts/load_test_*.js` ปน |
| `nextjs-webapp` | `hotfix/oic` | `src/services/act-service/*` (21 ไฟล์) | 🟡 merge ได้ไม่ชน, behind 22 |

➡️ ทำ `fix/oic-<service>` ใหม่จาก `origin/main --no-track` แล้ว cherry-pick เฉพาะ commit OIC ของเรา (ตัด helm-uat-isv / scripts) → ทดสอบบน uat-isv → MR
➡️ `01_oic/deployment_plan_oic.md` ขั้นที่ 1–2 อ้าง SQL ของ WS1–5 เป็น DB ของ OIC — ต้องแก้เอกสาร

### 4.4 Wave 3 — ⛔ WS ที่ชน `main` หรือมีงานคนอื่นปน (ต้องทำ branch ใหม่จาก `origin/main` + cherry-pick เฉพาะของเรา)

| Repo | Branch | ปัญหา |
| :--- | :--- | :--- |
| `go-fiber-policy-service` | `hotfix/ws3-cmi-oic` | conflict 9 ไฟล์ + แตะ `helm-prod.yaml` |
| `go-echo-uam-service` | `hotfix/ws5-invoice`, `ws6-saleforce-endoesement`, `ws9-ops` | conflict 1 ไฟล์ต่อ branch |
| `go-echo-notification-service` | `hotfix/ws9-ops` (behind 120), `fix/fx-01-notification` | conflict `notificationController.go`; `fix/fx-01-notification` **แตกจาก uat-isv** (มี `helm-uat-isv.yaml` + merge uat-isv) ผิดกฎ — ต้องทำใหม่จาก main แล้ว cherry-pick `ae17af1` (#4) |
| `nodejs-express-premium-service` | `hotfix/ws6-saleforce-endoesement`, `hotfix/oic-uat` | conflict 1 / งานคนอื่นปน |
| `python-fastapi-document-service` | `hotfix/ws1-policy-issue` | conflict 1 |

> `hotfix/oic-uat` ทุก repo เป็น branch สำหรับ UAT — **ไม่ใช้เปิด MR เข้า main**

---

## 5. Config / Helm (Prod)

CI (`configuration/cicd/k8s-deploy-gcp.yml`) รัน `helm upgrade -i -f $CHART_PATH … --force` **ไม่มี `--reuse-values`** → ค่าที่ Patch มือด้วย `03_fixes/helm_patches` จะ **หายตอน Deploy ครั้งถัดไป**

| Service | Issue | ค่าที่ต้องการบน Prod | สถานะ |
| :--- | :-: | :--- | :--- |
| uam | #16 | `Backend_Notification` → `http://backend-notification-service:8080/...` | ⏳ รอตัดสินใจนโยบาย `helm-prod.yaml` |
| lead-policy | #17 | `EMAIL_URL` → `http://backend-notification-service:8080/api/v1/notification/email` | ⏳ เหมือนกัน |
| oauth2 | #24 | mem 128Mi/256Mi, cpu 200m, probe 15s/threshold 5 | ⏳ (ผ่านบน uat-isv `c2e4985`) |
| analytics | #25 | probe 15s/threshold 5 | ⏳ (ผ่านบน uat-isv `9d5fd8c`) |
| go-e-api | #27 | ~~`ISV_HOST` → core~~ | ⛔ **ห้ามใช้ `patch_go_e_api_prod.yaml`** (ทำ premium/purchase/uam 404) |

➡️ ข้อเสนอ: แก้ `helm-prod.yaml` ใน `fix/fx-01-*` แล้วไปกับ MR เดียวกัน (ค่าคงอยู่ถาวร, Review ได้)

---

## 6. Post-Deploy Verification

| Wave | ตรวจ | ผ่านเมื่อ |
| :--- | :--- | :--- |
| 1a | `04_motor_lead_seq/sql/03_post_deploy_verify.sql` | DEFAULT = `nextval('insurverse.seq_lead_no')`, seq ≥ MAX+1 |
| 1b | สร้าง Motor Lead 1 รายการ | ได้ `Lead_No` = ค่า sequence, ไม่มี error |
| 1b | `OPTIONS /api/v1/analytics/analytics`, `POST /services/oauth/v2/token` ระหว่าง rollout | ไม่มี 503 |
| 1b | OpenAPI `GET /api/v1/motor/premium` (partner จริง) | 200 / error เป็น JSON |
| 1b | Log `backend-lead-policy-service` | ไม่มี `invalid character '<'` (ถ้า error จะเห็น `HTTP <code> non-JSON response`) |
| ทุก Wave | `kubectl rollout status deployment/<svc>` | successfully rolled out |

## 7. Rollback

| สิ่งที่ถอย | วิธี |
| :--- | :--- |
| โค้ด | Revert MR บน GitLab (สร้าง MR revert → main) หรือ `helm rollback <release> <rev>` |
| DB D (#13) | ปกติไม่ต้อง; ถ้าจำเป็น `04_motor_lead_seq/sql/99_rollback.sql` **หลัง** ถอยโค้ด premium ครบทุก Pod |
| DB A/B | ใช้ไฟล์ Backup ที่ดึงจาก **Prod** ใน Step 0 (`pg_get_functiondef`) — ห้ามใช้ Backup จาก UAT-ISV |

## 8. สิ่งที่ต้องตัดสินใจ (Decisions Needed)

0. WS1–5 ส่วนที่เหลือ (§4.2): ยังต้องการขึ้น Prod ไหม หรือทิ้งได้ (เพราะ Prod ทำงานได้แล้ว)
1. อนุมัติ Wave 1 (FX-01 8 MR + DB D) ให้ขึ้นก่อนแยกจากชุดอื่น?
2. ไฟล์ B: เขียนใหม่ตาม §2 ข้อเสนอ? และใครยืนยันความหมายของ `no_cancel_flag` / `'C'`?
3. รัน Step 0 บน Prod (อ่านอย่างเดียว) เพื่อยืนยัน function WS1–5 และสถานะ Job 04
4. นโยบาย `helm-prod.yaml` (§5)
5. `fix/fx-01-uam`: เอา 3 commit ขอบเขตกว้างออก หรือ Review ทั้งหมด?
6. OIC: อนุมัติให้ทำ `fix/oic-<service>` จาก main + cherry-pick เฉพาะ commit OIC ของเรา (uam, fiber-policy, premium, nextjs)
7. WS Wave 3: ทำ branch ใหม่จาก main + cherry-pick ของเรา
