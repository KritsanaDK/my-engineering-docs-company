# คู่มือขั้นตอนการจัดการฐานข้อมูล Workstream 6 ถึง 9 (WS6 - WS9)
# Database Deployment & Execution Guide for WS6 - WS9

> **เอกสารนี้สรุปขั้นตอนทั้งหมดที่ต้องปฏิบัติบนฐานข้อมูล (PostgreSQL & Google BigQuery) สำหรับการขึ้นระบบ Production หรือ UAT ครอบคลุม WS6, WS7, WS8 และ WS9**
> *(This document outlines all database procedures for PostgreSQL and Google Cloud BigQuery across WS6 to WS9).*

---

## 🚀 1. ตาราง Microservices ที่ต้อง Merge และ Deploy (Services to Merge & Deploy)

สำหรับการนำโค้ดขึ้น Production หรือ Release Pack ครอบคลุม **WS6 ถึง WS9** มี **3 Microservices** ที่มีโค้ด logic ใหม่และต้องทำการ Merge เข้าสู่สาขา `main` เพื่อ Deploy:

| ลำดับ | Microservice | Scope / Workstreams | Source Branch | Target Branch | 🔗 GitLab Merge Request Link | รายละเอียดโค้ดที่เปลี่ยนแปลง |
| :---: | :--- | :---: | :---: | :---: | :--- | :--- |
| **1** | **`go-echo-uam-service`** *(Core Backbone)* | **WS6, WS7, WS8, WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) | • **WS6**: รองรับสลักหลังยกเลิก (`no_cancel_flag = 'Y'`), แก้ไข phone mapping<br>• **WS7**: ล็อกอาชีพตามกรมธรรม์เดิมตอนต่ออายุ (`Occupation` locking)<br>• **WS8**: เพิ่ม Policy Expiry Check สำหรับ Active Policies<br>• **WS9**: REST API `GET /api/v1/uam/report/reconcile` และ Configurable DB Connection Pooling (`DB_MAX_OPEN_CONNS`, `DB_MAX_IDLE_CONNS`) |
| **2** | **`go-echo-backoffice-service`** | **WS8** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-backoffice-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) | • **WS8**: ปรับระบบโปรโมชันให้เชื่อมตรงกับ `insurverse.promo_code`<br>• เพิ่มฟังก์ชัน Export รายงาน Promo Code เป็น Excel/CSV พร้อม `COALESCE(create_by, '')` |
| **3** | **`go-echo-notification-service`** | **WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-notification-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) | • **WS9**: เพิ่ม Dynamic SMTP Configuration และ Required Headers (`Reply-To`, `Message-ID`, `X-Priority`) เพื่อแก้อีเมลตกหล่นใน Hotmail/Outlook/Live |

> ℹ️ **สถานะของ Services อื่นๆ (ไม่ต้อง Merge โค้ด Go เพิ่มเติม):**
> - **`go-echo-purchase-service`**: โค้ด Go ได้ถูก Merge เข้าสู่สาขา `main` เรียบร้อยแล้วก่อนหน้านี้ (ไม่มี Go diff ค้าง)
> - **`go-echo-saleforce-service`**: โค้ด Go บน `uat-isv` เหมือนกับ `main` 100% (Logic สลักหลังของ WS6 อยู่ใน `go-echo-uam-service`)
> - **`go-echo-analytics-service`**: มีเพียงไฟล์สคริปต์ BigQuery View Migration (`ws9_bigquery_column_migration.sql`) ซึ่งรันบน BigQuery โดยตรง ไม่มีการแก้ Go binary

---

## 📌 2. สรุปภาพรวมสิ่งต้องทำบน Database (Database Execution Summary)

| Workstream | ชนิด Database | สิ่งที่ต้องทำบนฐานข้อมูล | ระดับความสำคัญ / ความเสี่ยง | ไฟล์อ้างอิง |
| :--- | :---: | :--- | :---: | :--- |
| **WS6** (Salesforce & Endorsement) | **PostgreSQL** | 1. เพิ่มคอลัมน์ `no_cancel_flag`<br>2. สร้าง Helper Function `fn_format_utc_timestamp_th`<br>3. ซ่อมแซมข้อมูลย้อนหลัง `prem_version` และสถานะยกเลิก `'C'` | 🟡 ปานกลาง (มี Data Update) | [`ws6_production_deployment.sql`](file:///Users/kritsanawathaniyanon/Code/Go/ws6_production_deployment.sql) |
| **WS7** (Renewals) | **PostgreSQL** | 1. ตรวจสอบเงื่อนไข 90 วันใน `fn_policy_renewal`<br>2. อัปเดตฟังก์ชันฉบับเต็ม **(เฉพาะกรณีที่ยังไม่มี `ER007`)** | 🔴 สูง (กระทบระบบคำนวณเบี้ย) | [`docs/uat_db_functions/fn_policy_renewal.sql`](file:///Users/kritsanawathaniyanon/Code/Go/docs/uat_db_functions/fn_policy_renewal.sql) |
| **WS8** (Backoffice Promo) | **PostgreSQL** | **ไม่ต้องทำอะไรเลย (No Action Required)**<br>*(ระบบใช้งานตาราง `insurverse.promo_code` ที่มีอยู่แล้วใน DB)* | 🟢 ปลอดภัย (ไม่มีการแก้ไข DB) | - |
| **WS9** (Ops / Analytics) | **BigQuery** | สร้าง Compatibility View แปลงชื่อคอลัมน์ภาษาไทยเป็นภาษาอังกฤษ | 🟢 ปลอดภัย (View Definition) | [`go-echo-analytics-service/ws9_bigquery_column_migration.sql`](file:///Users/kritsanawathaniyanon/Code/Go/go-echo-analytics-service/ws9_bigquery_column_migration.sql) |

---

## 🛡️ กฎเหล็กความปลอดภัยก่อนลงมือ (Mandatory Safety Rules)

1. **Rule 3: ต้อง Backup ข้อมูลและ Stored Function ก่อนแก้ไขเสมอ**
   - รันคำสั่ง Backup ตารางแถวที่จะโดน Update
   - สกัดนิยามฟังก์ชันเดิมในฐานข้อมูลเก็บเป็นไฟล์ `.sql` ก่อนรัน `CREATE OR REPLACE`
2. **Rule 6: ต้องตรวจสอบ Schema จริงก่อนรัน**
   - ห้ามเดาชื่อฟิลด์หรือรัน Patch ย่อที่ตัดทอน Logic เดิมของระบบ

---

## 📋 ขั้นตอนการปฏิบัติการอย่างละเอียด (Step-by-Step Execution)

### 🔹 STEP 1: จัดการฐานข้อมูล WS6 (PostgreSQL Schema: `insurverse`)

#### 1.1 สำรองข้อมูลก่อน Update (Pre-backup):
```sql
-- สำรองข้อมูลแถวที่จะได้รับผลกระทบใน Policy_Header
CREATE TABLE IF NOT EXISTS insurverse.backup_ws6_policy_header_pre_deploy AS
SELECT "Policy_No", "Policy_Status", "no_cancel_flag", "prem_version", "Update_date", "Update_by"
FROM insurverse."Policy_Header"
WHERE (prem_version IS NULL)
   OR (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled');
```

#### 1.2 รันสคริปต์ DDL & Helper Function:
```sql
BEGIN;

-- 1. เพิ่มคอลัมน์ no_cancel_flag สำหรับระบบสลักหลัง
ALTER TABLE insurverse."Policy_Header" 
ADD COLUMN IF NOT EXISTS no_cancel_flag VARCHAR(1) DEFAULT NULL;

-- 2. สร้าง Helper Function แปลงเวลาเป็น UTC+7 (เวลาประเทศไทย)
CREATE OR REPLACE FUNCTION insurverse.fn_format_utc_timestamp_th(p_timestamp timestamp without time zone)
RETURNS character varying
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_timestamp IS NULL THEN
        RETURN '';
    END IF;
    RETURN to_char(p_timestamp + INTERVAL '7 HOUR', 'YYYY-MM-DD"T"HH24:MI:SS.MS');
END;
$$;

-- 3. ซ่อมแซม prem_version ที่เป็น NULL ให้สืบทอดจาก Policy_coverage_premium
UPDATE insurverse."Policy_Header" ph
SET prem_version = pcp.prem_version,
    "Update_date" = NOW(),
    "Update_by" = 'SYSTEM_WS6_PROD'
FROM insurverse."Policy_coverage_premium" pcp
WHERE ph."Policy_No" = pcp."Policy_No"
  AND ph.prem_version IS NULL
  AND pcp.prem_version IS NOT NULL;

-- 4. ซิงค์สถานะกรมธรรม์ที่ยกเลิกแล้วให้เป็น 'C'
UPDATE insurverse."Policy_Header"
SET "Policy_Status" = 'C',
    "Update_date" = NOW(),
    "Update_by" = 'SYSTEM_WS6_PROD'
WHERE (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled')
  AND "Policy_Status" != 'C';

COMMIT;
```

---

### 🔹 STEP 2: ตรวจสอบและจัดการฟังก์ชันต่ออายุ WS7 (PostgreSQL: `fn_policy_renewal`)

#### 2.1 ตรวจสอบสถานะฟังก์ชันบน Production ก่อนทำอะไร (Inspection Query):
รันคำสั่งด้านล่างนี้บนฐานข้อมูล:
```sql
SELECT 
    prosrc LIKE '%ER007%' AS has_90day_check,
    pg_get_function_identity_arguments(oid) AS args
FROM pg_proc 
JOIN pg_namespace n ON pg_proc.pronamespace = n.oid
WHERE n.nspname = 'insurverse' AND proname = 'fn_policy_renewal';
```

#### 2.2 การตัดสินใจ:
- **ผลลัพธ์เป็น `has_90day_check = true` และ `args` มี 4 ตัว:**  
  👉 **ข้ามขั้นตอนนี้ได้เลย ไม่ต้องแก้ไขอะไรบนฐานข้อมูลทั้งสิ้น!**
- **ผลลัพธ์เป็น `has_90day_check = false`:**  
  👉 **ต้องทำ 2 ขั้นตอนด้านล่าง:**
  1. สำรองฟังก์ชันเดิม:
     ```bash
     pg_dump -h <DB_HOST> -U pgpool -d insurverse -t 'insurverse.fn_policy_renewal*' --schema-only > backup_fn_policy_renewal_$(date +%Y%m%d_%H%M%S).sql
     ```
  2. รันสคริปต์ฉบับเต็ม (3,554 บรรทัด) จากไฟล์:  
     [`docs/uat_db_functions/fn_policy_renewal.sql`](file:///Users/kritsanawathaniyanon/Code/Go/docs/uat_db_functions/fn_policy_renewal.sql)  
     *(⚠️ **คำเตือนเด็ดขาด:** ห้ามใช้ไฟล์ Mock patch ย่อ `ws7_database_patches.sql` เด็ดขาด)*

---

### 🔹 STEP 3: ตรวจสอบ WS8 (PostgreSQL: Backoffice Promotion)

- ✅ **ไม่ต้องรัน SQL ใดๆ (Zero Migration)**
- **เหตุผล:** ระบบใช้งานตารางจริงคือ `insurverse.promo_code` ซึ่งมีโครงสร้างและข้อมูล 10,400+ แถวอยู่แล้ว โค้ดใน Service ถูกปรับให้ชี้ตรงตารางนี้แล้ว จึงไม่ต้องแก้ไขฐานข้อมูล

---

### 🔹 STEP 4: จัดการ BigQuery WS9 (Google BigQuery Dataset: `insurverse_analytics`)

#### 4.1 รันสร้าง Compatibility View บน BigQuery Console:
```sql
-- สร้าง View แปลงชื่อคอลัมน์ภาษาไทยเดิมให้เป็นชื่อภาษาอังกฤษมาตรฐาน
CREATE OR REPLACE VIEW `insurverse_analytics.v_policy_daily_english` AS
SELECT
  `ชื่อ` AS first_name,
  `นามสกุล` AS last_name,
  `เบอร์โทรศัพท์` AS mobile_phone,
  `เลขตัวถัง` AS car_serial_no,
  `ทะเบียนรถ` AS car_license_no,
  `วันหมดอายุ` AS expiration_date,
  `เลขที่กรมธรรม์` AS policy_no,
  `เลขที่ใบเสร็จ` AS receipt_no,
  `เบี้ยประกันรวม` AS total_premium,
  `สถานะกรมธรรม์` AS policy_status,
  `วันที่สร้าง` AS created_at
FROM `insurverse_analytics.policy_daily_lastversion`;
```

---

## 🔍 คำสั่งตรวจสอบผลลัพธ์หลัง Deploy (Post-Deployment Verification)

รันคำสั่งเหล่านี้เพื่อตรวจสอบความสมบูรณ์ 100%:

```sql
-- 1. เช็คว่าคอลัมน์ no_cancel_flag ถูกสร้างแล้ว
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'insurverse' 
  AND table_name = 'Policy_Header' 
  AND column_name = 'no_cancel_flag';

-- 2. เช็คว่า Helper Function ใช้งานได้ถูกต้อง (+7 ชั่วโมง)
SELECT insurverse.fn_format_utc_timestamp_th(NOW() AT TIME ZONE 'UTC');

-- 3. เช็คว่าไม่มี prem_version ตกหล่นเป็น NULL
SELECT COUNT(*) AS missing_prem_version_count
FROM insurverse."Policy_Header" ph
JOIN insurverse."Policy_coverage_premium" pcp ON ph."Policy_No" = pcp."Policy_No"
WHERE ph.prem_version IS NULL AND pcp.prem_version IS NOT NULL;
-- (ผลลัพธ์ที่ถูกต้องต้องได้ 0)

-- 4. เช็คสถานะฟังก์ชัน fn_policy_renewal (ต้องมี ER007 และ 4 parameters)
SELECT prosrc LIKE '%ER007%' AS has_90day_check,
       pg_get_function_identity_arguments(oid) AS args
FROM pg_proc 
JOIN pg_namespace n ON pg_proc.pronamespace = n.oid
WHERE n.nspname = 'insurverse' AND proname = 'fn_policy_renewal';
```

---

## 🔄 แผนการย้อนกลับกรณีฉุกเฉิน (Rollback Plan)

หากพบปัญหาจากการรัน SQL สามารถย้อนกลับได้ดังนี้:

1. **ย้อนกลับข้อมูล Policy_Header (WS6):**
   ```sql
   UPDATE insurverse."Policy_Header" ph
   SET "Policy_Status" = b."Policy_Status",
       "no_cancel_flag" = b."no_cancel_flag",
       "prem_version" = b."prem_version"
   FROM insurverse.backup_ws6_policy_header_pre_deploy b
   WHERE ph."Policy_No" = b."Policy_No";
   ```
2. **ย้อนกลับ Function `fn_policy_renewal` (WS7):**
   - รันไฟล์ SQL Backup ที่สำรองไว้ก่อนเริ่มรัน (`backup_fn_policy_renewal_*.sql`) หรือกู้คืนจาก [`docs/uat_db_functions/backup_fn_policy_renewal_uat_isv_20260907_112900.sql`](file:///Users/kritsanawathaniyanon/Code/Go/docs/uat_db_functions/backup_fn_policy_renewal_uat_isv_20260907_112900.sql)
