# คู่มือและสคริปต์การขึ้นระบบ Production (Production Deployment Pack - WS6)

**Workstream:** WS6 - ข้อมูล Salesforce ไม่ครบ / ทำสลักหลังไม่ได้ (Salesforce Data & Endorsement Issues)  
**บริการที่เกี่ยวข้อง (Target Services):** `go-echo-uam-service`, `go-echo-saleforce-service`, `PostgreSQL Database`  
**สถานะการตรวจสอบ (Schema Verified):** ✅ ผ่านการตรวจสอบชนิดข้อมูลและทดสอบคำสั่งจริงบน PostgreSQL เรียบร้อยแล้ว (Rule 6)

---

## 📌 1. ข้อมูล Git และ Merge Request (Git Readiness)

- **Target Branch:** `main` (Production)
- **Source Branch:** `hotfix/ws6-saleforce-endoesement`
- **🔗 GitLab Merge Request Link:**
  - 👉 [`go-echo-uam-service` MR to main](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws6-saleforce-endoesement&merge_request%5Btarget_branch%5D=main)
- **รายการ Commit สำคัญใน WS6:**
  - `c6218d8`: `fix(ws6): use 'Y' instead of boolean true for no_cancel_flag in endorsement cancellation`
  - `d46c8c8`: `feat: add database schema patches for ws6 upgrade`
  - `b660737`: `fix: update mobile phone mapping, add .env to ignore, and set policy status to cancelled upon successful endorsement`

---

## 🗄️ 2. ขั้นตอนการรัน SQL บนระบบ Production (Step-by-Step SQL Guide)

### 🔹 STEP 0: สำรองข้อมูลก่อนรัน (Pre-Deployment Backup - Rule 3)
*รันคำสั่งนี้ก่อนเพื่อสร้างตารางสำรองข้อมูลแถวที่จะถูก Update ป้องกันข้อผิดพลาด:*
```sql
CREATE TABLE IF NOT EXISTS insurverse.backup_ws6_policy_header_pre_deploy AS
SELECT "Policy_No", "Policy_Status", "no_cancel_flag", "prem_version", "Update_date", "Update_by"
FROM insurverse."Policy_Header"
WHERE (prem_version IS NULL)
   OR (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled');
```

---

### 🔹 STEP 1: รันสคริปต์หลักสำหรับ WS6 (Production SQL Patch)
*คำสั่งทั้งหมดอยู่ภายใต้ Transaction (`BEGIN ... COMMIT`) สามารถรันพร้อมกันได้ทันที:*

```sql
BEGIN;

-- -----------------------------------------------------------------------------
-- 1. Helper Function: แปลงเวลาสลักหลัง UTC เป็นเวลาประเทศไทย (+7 Hours)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insurverse.fn_format_utc_timestamp_th(p_timestamp timestamp without time zone)
RETURNS character varying
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_timestamp IS NULL THEN
        RETURN '';
    END IF;
    -- บวกเวลา 7 ชั่วโมงเข้ากับ UTC Time เพื่อให้ตรงกับเวลาประเทศไทย
    RETURN to_char(p_timestamp + INTERVAL '7 HOUR', 'YYYY-MM-DD"T"HH24:MI:SS.MS');
END;
$$;

COMMENT ON FUNCTION insurverse.fn_format_utc_timestamp_th(timestamp without time zone) 
IS 'WS6: Format UTC timestamp to Thailand time (+7h) ISO string';


-- -----------------------------------------------------------------------------
-- 2. DML Patch: ซ่อมข้อมูล prem_version ใน Policy_Header ที่เป็น NULL
-- เพื่อให้ระบบระบุชุดเบี้ยและเปิดหน้าจอ Edit เพื่อทำสลักหลังได้ถูกต้อง
-- -----------------------------------------------------------------------------
UPDATE insurverse."Policy_Header" ph
SET prem_version = pcp.prem_version,
    "Update_date" = NOW(),
    "Update_by" = 'SYSTEM_WS6_PROD'
FROM insurverse."Policy_coverage_premium" pcp
WHERE ph."Policy_No" = pcp."Policy_No"
  AND ph.prem_version IS NULL
  AND pcp.prem_version IS NOT NULL;


-- -----------------------------------------------------------------------------
-- 3. DML Patch: อัปเดตสถานะ Policy_Status ของกรมธรรม์ที่ยกเลิกแล้วให้เป็น 'C'
-- ใช้ชนิดข้อมูล varchar(1) 'Y' ถูกต้องตาม Schema
-- -----------------------------------------------------------------------------
UPDATE insurverse."Policy_Header"
SET "Policy_Status" = 'C',
    "Update_date" = NOW(),
    "Update_by" = 'SYSTEM_WS6_PROD'
WHERE (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled')
  AND "Policy_Status" != 'C';

COMMIT;
```

---

### 🔹 STEP 2: ตรวจสอบความถูกต้องหลังการรัน (Post-Deploy Verification)
*รันคำสั่งเหล่านี้เพื่อยืนยันว่าไม่มีข้อมูลตกค้าง:*

```sql
-- 1. ตรวจสอบว่าไม่มี prem_version ที่ค้างเป็น NULL:
SELECT COUNT(*) as remaining_null_prem_version 
FROM insurverse."Policy_Header" ph 
JOIN insurverse."Policy_coverage_premium" pcp ON ph."Policy_No" = pcp."Policy_No"
WHERE ph.prem_version IS NULL AND pcp.prem_version IS NOT NULL;
-- ✅ ผลลัพธ์ที่ถูกต้อง: 0

-- 2. ตรวจสอบว่าไม่มีกรมธรรม์ยกเลิกที่ค้างสถานะอื่น:
SELECT COUNT(*) as remaining_uncancelled 
FROM insurverse."Policy_Header"
WHERE (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled')
  AND "Policy_Status" != 'C';
-- ✅ ผลลัพธ์ที่ถูกต้อง: 0
```

---

### 🔹 STEP 3 (ตรวจเช็คเพิ่มเติม): Stored Procedure `fn_policy_renewal` บน Production
ตรวจสอบ Arguments ของฟังก์ชัน `fn_policy_renewal` บน Production:
```sql
SELECT pg_get_function_identity_arguments(oid) 
FROM pg_proc 
WHERE proname = 'fn_policy_renewal';
```
- **กรณีพบ 4 พารามิเตอร์** (`in_policy_no text, in_flag_noti boolean, in_flag_lead boolean, in_bad_behavior boolean`):
  👉 **ไม่ต้องดำเนินการใดๆ เพิ่มเติม** (เป็นเวอร์ชันล่าสุดเรียบร้อยแล้ว)
- **กรณีพบ 3 พารามิเตอร์** (ยังเป็นเวอร์ชันเก่า):
  👉 ให้ Deploy ไฟล์ฟังก์ชันฉบับเต็มจาก `docs/uat_db_functions/fn_policy_renewal.sql`

---

## ⏪ 3. แผนการย้อนคืนข้อมูลกรณีฉุกเฉิน (Emergency Rollback Plan)

หากพบความผิดปกติหลังการรัน SQL สามารถ Restore ข้อมูลเดิมกลับมาจากตาราง Backup ได้ทันที:

```sql
BEGIN;

UPDATE insurverse."Policy_Header" ph
SET "Policy_Status" = b."Policy_Status",
    "no_cancel_flag" = b."no_cancel_flag",
    "prem_version" = b."prem_version",
    "Update_date" = b."Update_date",
    "Update_by" = b."Update_by"
FROM insurverse.backup_ws6_policy_header_pre_deploy b
WHERE ph."Policy_No" = b."Policy_No";

COMMIT;
```

---

## 📄 4. อ้างอิงไฟล์ในระบบ (File References)

- **สคริปต์ SQL พร้อมรัน:** [`ws6_production_deployment.sql`](file:///Users/kritsanawathaniyanon/Code/Go/ws6_production_deployment.sql)
- **สรุปภาพรวม WS1 - WS9:** [`workstreams_summary_ws1_ws9.md`](file:///Users/kritsanawathaniyanon/Code/Go/workstreams_summary_ws1_ws9.md)
- **ไฟล์สำรอง Function DB UAT-ISV:** [`docs/uat_db_functions/backup_fn_policy_renewal_uat_isv_20260907_112900.sql`](file:///Users/kritsanawathaniyanon/Code/Go/docs/uat_db_functions/backup_fn_policy_renewal_uat_isv_20260907_112900.sql)
