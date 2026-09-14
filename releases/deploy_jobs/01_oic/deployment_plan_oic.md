# 🚀 แผนการขึ้นระบบ Production: ระบบ พ.ร.บ. คปภ. (Production Deployment Plan - OIC System)

> **สรุปภาพรวม (Deployment Overview)**
> * **ระบบที่ Deploy:** ระบบ พ.ร.บ. คปภ. (OIC Compulsory Act Policy & Concurrency System)
> * **วันที่/เวลาดำเนินการ:** ตามกำหนดการปล่อยระบบ (Release Schedule)
> * **ระดับความเสี่ยง (Risk Level):** ปานกลาง (มีส่วนฐานข้อมูล Stored Procedure แต่มี Transaction Advisory Locks และสคริปต์ Rollback รองรับ 100%)
> * **ระยะเวลา Downtime:** **Zero Downtime** (ไม่มีการหยุดให้บริการระบบ)
> 
> 📚 **เอกสารในชุดส่งมอบ (Production Documentation Pack):**
> * 📋 **แผนแม่บทการทดสอบ:** [`oic_master_test_plan.md`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_jobs/01_oic/oic_master_test_plan.md)
> * ✅ **รายงานผลการทดสอบ (100% PASS):** [`test_cases_oic.md`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_jobs/01_oic/test_cases_oic.md)

---

## 📌 สรุปขั้นตอนการ Deploy (Deployment Sequence)

```text
[ขั้นตอนที่ 1: เตรียมการ & Backup] ──► [ขั้นตอนที่ 2: Deploy DB Stored Procedures]
                                                        │
[ขั้นตอนที่ 4: Post-Deploy Verification] ◄── [ขั้นตอนที่ 3: Deploy Application Services]
```

1. **Step 1: Backup Database Function** (ดึง Backup ฟังก์ชันเดิมเก็บไว้ก่อนเสมอ ตาม Golden Rule 3)
2. **Step 2: Database Migration** (อัปเดต Stored Procedures 4 ตัวใน Transaction เดียว)
3. **Step 3: Application Deployment** (Merge & Deploy Frontend `nextjs-webapp` และ Backend API)
4. **Step 4: Verification & Health Check** (รัน Query ตรวจสอบความปลอดภัย และทดสอบยิง API)

---

## 🗄️ ขั้นตอนที่ 1: เตรียมการและ Backup Database (Pre-Deployment Backup)

ก่อนแก้ไข Database Production ต้อง Backup Definition เดิมของทั้ง 4 ฟังก์ชันออกมาเป็นไฟล์ SQL Timestamp ก่อนเสมอ:

```sql
-- คำสั่งดึง Backup Definition ออกมาเก็บไว้ (รันบน psql หรือ Cloud SQL Studio)
SELECT proname, pg_get_functiondef(oid) 
FROM pg_proc 
WHERE proname IN ('fn_lead_to_car_act', 'fn_policy_to_car_act', 'fn_policy_invoiceno_iia', 'fn_policy_quatationno_iia')
  AND pronamespace = 'insurverse'::regnamespace;
```
*ไฟล์ Backup ที่เตรียมไว้:* `backup_oic_functions_YYYYMMDD_HHMMSS.sql`

---

## 🗄️ ขั้นตอนที่ 2: Deploy Database Migration (Production DB)

ดำเนินการ Execute สคริปต์ Migration ที่เตรียมไว้อย่างปลอดภัย (รองรับ Transaction Rollback ทันทีหากเกิดข้อผิดพลาด):

### ตัวเลือกที่ 2.1: รันผ่าน Go Script อัตโนมัติ (แนะนำ สะดวก มีสรุปผลทันที)
```bash
cd /Users/kritsanawathaniyanon/Code/Go/deploy_jobs/01_oic/scripts

go run deploy_prod_db.go \
  -host <PROD_DB_HOST> \
  -port 5432 \
  -user pgpool \
  -password "<PROD_DB_PASSWORD>" \
  -dbname insurverse
```

### ตัวเลือกที่ 2.2: รันผ่าน SQL Client (Cloud SQL Studio / DBeaver / psql)
นำสคริปต์ในไฟล์นี้ไป Execute:
👉 [`sql/ws1_ws5_concurrency_safe_master.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_jobs/01_oic/sql/ws1_ws5_concurrency_safe_master.sql)

**รายการ Stored Procedures ที่อัปเดต:**
1. `insurverse.fn_lead_to_car_act(bigint)` — ใส่ `pg_advisory_xact_lock` + Sequence Retry Loop
2. `insurverse.fn_policy_to_car_act(bigint)` — ใส่ `pg_advisory_xact_lock` + Sequence Retry Loop
3. `insurverse.fn_policy_invoiceno_iia(...)` — ป้องกันเลขที่ใบกำกับภาษีชนกัน
4. `insurverse.fn_policy_quatationno_iia(...)` — ป้องกันเลขที่ใบเสนอราคาชนกัน

### 2.3 ตารางตรวจสอบความจำเป็นในการ Deploy SQL แต่ละ Workstream (WS1 – WS9 SQL Deployment Matrix)
> **สำหรับใช้อ้างอิงทุกครั้งที่ขึ้นระบบ (Deployment Job Quick Reference):**

| Workstream | ต้อง Deploy SQL ไหม? | ประเภทงาน / ไฟล์ SQL ที่จัดเก็บไว้ |
| :--- | :---: | :--- |
| **WS1 (Policy Concurrency)** | **ต้องรัน (YES)** | [`deploy_scripts/ws1_ws5_concurrency_safe_master.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_scripts/ws1_ws5_concurrency_safe_master.sql) *(รวมในรอบนี้)* |
| **WS2 (Receipt / E-Tax)** | **ไม่ต้องรัน (NO ❌)** | ปรับโค้ดเรียก e-Tax API R2 และ fallback zipcode ใน Service |
| **WS3 (CMI / OIC Sync)** | **ไม่ต้องรัน (NO ❌)** | ปรับโค้ด Go ปรับ Effective Date และ Reconcile Worker |
| **WS4 (IIA Integration)** | **ไม่ต้องรัน (NO ❌)** | ปรับโค้ด XML Escaping และ Cron Worker ใน Node/Go |
| **WS5 (Invoice Concurrency)**| **ต้องรัน (YES)** | [`deploy_scripts/ws1_ws5_concurrency_safe_master.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_scripts/ws1_ws5_concurrency_safe_master.sql) *(รวมในรอบนี้)* |
| **WS6 (Salesforce & Endorse)**| **ต้องรัน (YES)** *(รอบ SF)* | [`deploy_scripts/ws6_salesforce_endorsement_patches.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_scripts/ws6_salesforce_endorsement_patches.sql) |
| **WS7 (Renewal Guardrails)** | **ต้องรัน (YES)** *(รอบ Renew)* | [`deploy_scripts/ws7_renewal_guardrails_patches.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_scripts/ws7_renewal_guardrails_patches.sql) |
| **WS6 + WS7 รวม Master** | **แนะนำรันตัวนี้ (Recommended)** | 👉 [`deploy_scripts/ws6_ws7_combined_renewal_master.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_scripts/ws6_ws7_combined_renewal_master.sql) *(รวมทั้งสอง Workstream ไม่ทับกัน)* |
| **WS8 (Backoffice Promo)** | **ไม่ต้องรัน (NO ❌)** | แก้โค้ด Go ชี้ตาราง `insurverse.promo_code` ที่มีอยู่แล้วใน DB |
| **WS9 (Ops, Pooling, SMTP)** | **ไม่ต้องรันใน Postgres (NO ❌)** | มีเฉพาะ BigQuery View: [`deploy_scripts/ws9_bigquery_english_view.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_scripts/ws9_bigquery_english_view.sql) |

---

## 📦 ขั้นตอนที่ 3: Deploy Application Repositories

### 1. Frontend Webapp (`nextjs-webapp`)
* **Repository:** [`/Users/kritsanawathaniyanon/Code/NextJs/nextjs-webapp`](file:///Users/kritsanawathaniyanon/Code/NextJs/nextjs-webapp)
* **Source Branch:** `hotfix/oic`
* **Target Branch:** `uat` ──► `main` (Production)
* **การทำงานของ CI/CD:** เมื่อ Merge เข้า `main` ระบบ GitLab CI จะทริกเกอร์ Job `build_react_prod` และ Deploy ขึ้น **Cloudflare Pages** อัตโนมัติ

**ขั้นตอน Git:**
```bash
cd /Users/kritsanawathaniyanon/Code/NextJs/nextjs-webapp

# ตรวจสอบความเรียบร้อยของ branch
git checkout hotfix/oic
git pull origin hotfix/oic

# สร้าง Merge Request ไปยัง uat -> main ผ่าน GitLab UI
```

### 2. Backend Premium Service (`nodejs-express-premium-service`)
* **Repository:** [`/Users/kritsanawathaniyanon/Code/Go/nodejs-express-premium-service`](file:///Users/kritsanawathaniyanon/Code/Go/nodejs-express-premium-service)
* **Source Branch:** `hotfix/oic`
* **Target Branch:** `uat` ──► `main` (Production)
* **การทำงานของ CI/CD:** GitLab CI ทำการ Build Docker Image และ Deploy ผ่าน Kubernetes Helm Chart อัตโนมัติ

**ขั้นตอน Git:**
```bash
cd /Users/kritsanawathaniyanon/Code/Go/nodejs-express-premium-service

# ตรวจสอบความเรียบร้อยของ branch
git checkout hotfix/oic
git pull origin hotfix/oic

# สร้าง Merge Request ไปยัง uat -> main ผ่าน GitLab UI
```

---

## 🔍 ขั้นตอนที่ 4: การตรวจสอบหลังขึ้นระบบ (Post-Deployment Verification)

### 4.1 ตรวจสอบสถานะ Stored Procedure บน Production DB
รัน Query เพื่อยืนยันว่าฟังก์ชันบน Production ปลอดภัยจากปัญหา Concurrency 100%:

```sql
SELECT 
    p.proname AS function_name,
    CASE 
        WHEN pg_get_functiondef(p.oid) LIKE '%pg_advisory_xact_lock%' 
         AND pg_get_functiondef(p.oid) LIKE '%LOOP%' THEN '✅ CONCURRENCY SAFE'
        ELSE '⚠️ LEGACY / UNSAFE'
    END AS concurrency_status,
    LENGTH(pg_get_functiondef(p.oid)) AS def_length
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname IN ('fn_lead_to_car_act', 'fn_policy_to_car_act', 'fn_policy_invoiceno_iia', 'fn_policy_quatationno_iia') 
  AND n.nspname = 'insurverse'
ORDER BY p.proname;
```
> **เกณฑ์ผ่าน:** ทุกฟังก์ชันต้องแสดงผลลัพธ์เป็น `✅ CONCURRENCY SAFE` ทั้งหมด

### 4.2 ตรวจสอบ Health Check ของ Microservices
* **Backend Premium Service:** `https://<PROD_API_DOMAIN>/api/v1/premium/healthcheck` (ต้องตอบ HTTP `200 OK`)
* **Frontend Webapp:** เข้าหน้าซื้อ พ.ร.บ. `/act` บน Production ตรวจสอบความสมบูรณ์ของฟอร์ม

---

## 🔄 แผนการถอยระบบ (Rollback Plan)

หากเกิดเหตุขัดข้องฉุกเฉิน ให้ดำเนินการตามขั้นตอนถอยระบบดังนี้:

### 1. การ Rollback Database
* Execute ไฟล์ Backup SQL ที่ได้ดึงไว้ในขั้นตอนที่ 1 (`backup_oic_functions_YYYYMMDD_HHMMSS.sql`) เพื่อคืนค่า Stored Procedure ตัวเดิม

### 2. การ Rollback Application
* **Frontend (`nextjs-webapp`):** สั่ง Rollback Deployment บน Cloudflare Pages ไปยัง Build เวอร์ชั่นก่อนหน้าได้ทันทีภายใน 1 นาที
* **Backend (`nodejs-express-premium-service`):** ทำการ Revert Merge Request บน GitLab หรือใช้ Helm Rollback:
  ```bash
  helm rollback backend-premium-service <PREVIOUS_REVISION> -n production
  ```
