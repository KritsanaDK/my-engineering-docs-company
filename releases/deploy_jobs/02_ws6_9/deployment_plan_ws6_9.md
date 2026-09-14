# 🚀 แผนการขึ้นระบบ Production: งานระบบหลังบ้าน WS6 - WS9 (Backoffice, Salesforce, Renewal & Operations)

> **สรุปภาพรวม (Deployment Overview)**
> * **ระบบที่ Deploy:** Workstreams WS6 – WS9
>   - **WS6:** Salesforce Endorsement & Renewal Contact Sync (แก้ปัญหาเบอร์โทรผู้ซื้อไม่ขึ้น SF และ Timezone สลักหลัง)
>   - **WS7:** Policy Renewal Flow Guardrails (จำกัดต่ออายุล่วงหน้าไม่เกิน 90 วัน และคัดลอกข้อมูลผู้ขับขี่ 1–5)
>   - **WS8:** Backoffice Promotion Export & Active Policy Expiration Filter
>   - **WS9:** Database Connection Pooling, SMTP Deliverability Headers, Reconcile API & BigQuery Compatibility View
> * **ระดับความเสี่ยง (Risk Level):** ต่ำถึงปานกลาง (Low to Moderate - เป็นงานระบบหลังบ้าน ไม่กระทบ Flow ซื้อ พ.ร.บ. หน้าบ้าน)
> * **ระยะเวลา Downtime:** **Zero Downtime** (ไม่มีการหยุดให้บริการระบบ)

---

## 📌 สรุปขั้นตอนการ Deploy (Deployment Sequence)

```text
[ขั้นตอนที่ 1: Backup DB Function] ──► [ขั้นตอนที่ 2: Deploy Master SQL (WS6+7)]
                                                    │
[ขั้นตอนที่ 4: Post-Deploy Verification] ◄── [ขั้นตอนที่ 3: Deploy Microservices WS6-9]
```

---

## 🗄️ ขั้นตอนที่ 1: สำรองข้อมูล Stored Procedure เดิม (Pre-Deployment DB Backup)

> [!IMPORTANT]
> **ปฏิบัติตาม AGENTS.md Rule 3:** ต้องสำรอง Stored Procedure เดิมก่อนทำการแทนที่ (`CREATE OR REPLACE`) ทุกครั้ง

รันคำสั่ง SQL ต่อไปนี้บน Production Database (`34.126.145.44` / Cloud SQL Studio / DBeaver) เพื่อดึงนิยามฟังก์ชันเดิมเก็บไว้:

```sql
-- บันทึกผลลัพธ์เป็นไฟล์: backup_ws6_ws7_functions_YYYYMMDD_HHMMSS.sql
SELECT proname, pg_get_functiondef(oid) 
FROM pg_proc 
WHERE proname IN ('fn_policy_renewal', 'fn_format_utc_timestamp_th')
  AND pronamespace = 'insurverse'::regnamespace;
```

---

## 🗄️ ขั้นตอนที่ 2: ดำเนินการ Database Migration (Production DB)

### 2.1 รัน PostgreSQL Master Migration (แนะนำให้รันไฟล์รวม Master)
สคริปต์นี้ผสาน Logic ทั้งหมดของ **WS6 และ WS7** เข้าด้วยกันอย่างสมบูรณ์ ป้องกันการรันทับกัน:
👉 **[`sql/ws6_ws7_combined_renewal_master.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_jobs/02_ws6_9/sql/ws6_ws7_combined_renewal_master.sql)**

**สิ่งที่สคริปต์ดำเนินการ (ภายใน Transaction เดียวกัน):**
1. `insurverse.fn_policy_renewal`:
   - [WS7] บล็อกการต่ออายุหากเกิน 90 วันก่อนหมดอายุ (`Policy_Enddate - CURRENT_DATE > 90` คืน `ERR_NOT_IN_RENEW_PERIOD`)
   - [WS7] คัดลอกข้อมูลผู้ขับขี่ 1..5 (`par_first_name_1..5`, `par_citizen_id_1..5` ฯลฯ) เข้า `Policy_coverage_premium`
   - [WS6] คัดลอกเบอร์โทรและข้อมูลผู้ซื้อ (`phone`, `email`, `Owner_phone`, `Owner_citizen_id`) เข้า `Policy_Header`
2. `insurverse.fn_format_utc_timestamp_th`:
   - [WS6] ปรับ Timezone สลักหลังบวก 7 ชั่วโมง (`INTERVAL '7 HOUR'`) ให้ตรงกับเวลาไทย
3. DML Data Fixes:
   - [WS6] ซ่อมแซม `prem_version` ที่เป็น NULL ให้ตรงกับ `Policy_coverage_premium`
   - [WS6] ปรับสถานะกรมธรรม์ที่ยกเลิกให้เป็น `'C'` (Cancelled)

### 2.2 BigQuery Compatibility View (สำหรับทีม Analytics - ถ้าต้องการใช้งาน)
👉 **[`sql/ws9_bigquery_english_view.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_jobs/02_ws6_9/sql/ws9_bigquery_english_view.sql)**
* รันบน **Google BigQuery Console** (Dataset: `insurverse_analytics`) เพื่อสร้าง View `v_policy_daily_english`

---

## 📦 ขั้นตอนที่ 3: Deploy Microservices Application

ผสานโค้ดจาก Hotfix Branch ไปยัง `uat-isv` ──► `uat` ──► `main` ตามลำดับ:

### 3.1 กลุ่ม WS6: Salesforce & Endorsement Services
1. **`go-echo-saleforce-service`**:
   - **Branch:** `hotfix/ws6-saleforce-endoesement` ──► `main`
   - **สิ่งที่แก้ไข:** แมปเบอร์โทรศัพท์ผู้ซื้อสำรอง `COALESCE("Owner_phone", phone, '')` ส่งขึ้น Salesforce
2. **`nodejs-express-premium-service`**:
   - **Branch:** `hotfix/ws6-saleforce-endoesement` ──► `main`
   - **สิ่งที่แก้ไข:** กำหนด Default ค่า `prem_version` ให้ถูกต้อง

### 3.2 กลุ่ม WS7: Policy Renewal Services
1. **`go-echo-uam-service`**:
   - **Branch:** `hotfix/ws7-renew` ──► `main`
   - **สิ่งที่แก้ไข:** ล็อกอาชีพ (Occupation) ให้อ่านอย่างเดียวเมื่อเป็นงานต่ออายุ (`ref_policy_no != ''`)
2. **`go-echo-purchase-service`**:
   - **Branch:** `hotfix/ws7-renew` ──► `main`
   - **สิ่งที่แก้ไข:** เพิ่มเติมการคำนวณเบี้ย Renewal และรองรับข้อมูลผู้ขับขี่

### 3.3 กลุ่ม WS8: Backoffice Services
1. **`go-echo-backoffice-service`**:
   - **Branch:** `hotfix/ws8-backoffice` ──► `main`
   - **สิ่งที่แก้ไข:** แก้ไขการ Query ตาราง Promo จาก `mas_promo_code` เป็น `insurverse.promo_code` และฟิลเตอร์กรมธรรม์หมดอายุ

### 3.4 กลุ่ม WS9: Operations & Notifications
1. **`go-echo-notification-service`**:
   - **Branch:** `hotfix/ws9-ops` ──► `main`
   - **สิ่งที่แก้ไข:** เพิ่ม SMTP Headers (`Reply-To`, `Message-ID`, `X-Priority`) ป้องกันอีเมลตก Junk
2. **`go-echo-uam-service` (Config)**:
   - **สิ่งที่แก้ไข:** ปรับค่า Database Connection Pool ใน Helm Config / `.env` (`DB_MAX_OPEN_CONNS=50`, `DB_MAX_IDLE_CONNS=25`, `ConnMaxLifetime=15m`)

---

## 🔍 ขั้นตอนที่ 4: การตรวจสอบหลังขึ้นระบบ (Post-Deployment Verification)

### 4.1 ตรวจสอบ Stored Procedure ใน Database
```sql
SELECT proname, length(pg_get_functiondef(oid)) as def_len
FROM pg_proc 
WHERE proname IN ('fn_policy_renewal', 'fn_format_utc_timestamp_th')
  AND pronamespace = 'insurverse'::regnamespace;
```

### 4.2 ทดสอบการทำงาน Renewal Flow (ใช้ Test Citizen ID ตาม Rule 4)
* **Citizen ID ทดสอบ:** `1111111111119`
* **ชื่อ-นามสกุล:** `กฤษณะ วัฒนายนนต์`
* **การทดสอบ:**
  1. กรมธรรม์ที่เหลืออายุเกิน 90 วัน ต้องตอบกลับ Error `ERR_NOT_IN_RENEW_PERIOD`
  2. กรมธรรม์ที่ต่ออายุสำเร็จ ต้องมีเบอร์โทรผู้ซื้อและรายชื่อผู้ขับขี่ครบถ้วน

---

## 🔄 แผนการถอยระบบ (Rollback Plan)

### 1. Database Rollback
* Execute ไฟล์ Backup ที่สำรองไว้ในขั้นตอนที่ 1 (`backup_ws6_ws7_functions_YYYYMMDD_HHMMSS.sql`) เพื่อคืนค่า Stored Procedure เดิม

### 2. Microservices Rollback
* สั่ง Revert Merge Request บน GitLab ของแต่ละ Service หรือใช้คำสั่ง Helm Rollback:
  ```bash
  helm rollback <SERVICE_RELEASE_NAME> <PREVIOUS_REVISION> -n production
  ```
