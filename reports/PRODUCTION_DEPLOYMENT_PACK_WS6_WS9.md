# แผนและแพ็กเกจเตรียมความพร้อมขึ้น Production (WS6 - WS9)
# Production Deployment Pack: Workstreams WS6 - WS9

> **เอกสารตามกฎข้อบังคับ Rule 5 (Mandatory Production Deployment Pack) และ Rule 3 (Mandatory DB Function Backup)**  
> สรุปความพร้อม Git, DDL/DML Database Script, Configurations, และแผน Rollback สำหรับขึ้นระบบจริง (Production Release)

---

## 📦 1. Git Readiness & Merge Requests (ความพร้อมด้าน Git)

| ลำดับ | Microservice | Scope งาน | Source Branch | Target Branch | 🔗 GitLab MR Link |
| :---: | :--- | :---: | :---: | :---: | :--- |
| **1** | **`go-echo-uam-service`** | **WS6, WS7, WS8, WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) |
| **2** | **`go-echo-backoffice-service`** | **WS8** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-backoffice-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) |
| **3** | **`go-echo-notification-service`** | **WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-notification-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) |

---

## 🗄️ 2. Production-Safe Database Script (ไฟล์ SQL สำหรับรันบน Prod)

ไฟล์ SQL ฉบับเต็มอยู่ที่: [`deploy_prod_ws6_ws9.sql`](file:///Users/kritsanawathaniyanon/Code/Go/deploy_prod_ws6_ws9.sql)

### ⚠️ ขั้นตอน Backup ก่อนรัน (Pre-Deployment Backup - Rule 3):
ก่อนรันสคริปต์บน Production ให้รันคำสั่ง Backup คำนิยามฟังก์ชันเดิมไว้ก่อนเสมอ:
```bash
# Backup functions on Production before applying
pg_dump -h <PROD_HOST> -p 5432 -U <PROD_USER> -d insurverse \
  -t 'insurverse.fn_format_utc_timestamp_th' \
  -t 'insurverse.fn_policy_renewal_ref' \
  -s > backup_functions_pre_prod_$(date +%Y%m%d_%H%M%S).sql
```

### 📜 เนื้อหาคำสั่ง SQL ที่ต้องเตรียมไปรัน (DDL / Stored Functions / Sequence Sync):

```sql
\set ON_ERROR_STOP on
SET search_path TO insurverse, public;

BEGIN;

-- 1. DDL: Columns & Performance Indexes
ALTER TABLE insurverse."Policy_Header" 
ADD COLUMN IF NOT EXISTS no_cancel_flag VARCHAR(1) DEFAULT 'N';

ALTER TABLE insurverse."Policy_Header" 
ADD COLUMN IF NOT EXISTS "Owner_occupation" VARCHAR(100) DEFAULT '';

CREATE INDEX IF NOT EXISTS idx_policy_header_enddate 
ON insurverse."Policy_Header"("Policy_Enddate");

CREATE INDEX IF NOT EXISTS idx_sf_claim_ref_notify_no 
ON insurverse.sf_claim(ref_notify_no);

-- 2. Stored Functions (WS6 & WS7)
CREATE OR REPLACE FUNCTION insurverse.fn_format_utc_timestamp_th(p_timestamp timestamp without time zone)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF p_timestamp IS NULL THEN
        RETURN '';
    END IF;
    RETURN to_char(p_timestamp + INTERVAL '7 HOUR', 'YYYY-MM-DD"T"HH24:MI:SS.MS');
END;
$function$;

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_ref(in_lead_no integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_JSON TEXT;
BEGIN
    -- Driver details and Owner_occupation inheritance
    WITH set_para AS (
        SELECT in_lead_no AS lead_no
    ),
    driver_info AS (
        SELECT
            "driver"."Policy_No",
            (d).*
        FROM insurverse."Policy_Header" AS "driver"
        INNER JOIN insurverse."Lead_coverage_premium" AS "lead"
            ON "lead"."ref_policy_no" = "driver"."Policy_No"
        CROSS JOIN LATERAL (
            VALUES
                (1, "driver"."Par_citizen_id_1", "driver"."Par_first_name_1", "driver"."Par_last_name_1", "driver"."Par_birth_date_1", "driver"."Par_prefix_name_1", "driver"."Par_occupation_1", "driver"."par_occupation_code_1", "driver"."Par_Driver_license_no_1", "driver"."par_driver_license_category_1"),
                (2, "driver"."Par_citizen_id_2", "driver"."Par_first_name_2", "driver"."Par_last_name_2", "driver"."Par_birth_date_2", "driver"."Par_prefix_name_2", "driver"."Par_occupation_2", "driver"."par_occupation_code_2", "driver"."Par_Driver_license_no_2", "driver"."par_driver_license_category_2"),
                (3, "driver"."par_citizen_id_3", "driver"."par_first_name_3", "driver"."par_last_name_3", "driver"."par_birth_date_3", "driver"."par_prefix_name_3", "driver"."par_occupation_3", "driver"."par_occupation_code_3", "driver"."par_driver_license_no_3", "driver"."par_driver_license_category_3"),
                (4, "driver"."par_citizen_id_4", "driver"."par_first_name_4", "driver"."par_last_name_4", "driver"."par_birth_date_4", "driver"."par_prefix_name_4", "driver"."par_occupation_4", "driver"."par_occupation_code_4", "driver"."par_driver_license_no_4", "driver"."par_driver_license_category_4"),
                (5, "driver"."par_citizen_id_5", "driver"."par_first_name_5", "driver"."par_last_name_5", "driver"."par_birth_date_5", "driver"."par_prefix_name_5", "driver"."par_occupation_5", "driver"."par_occupation_code_5", "driver"."par_driver_license_no_5", "driver"."par_driver_license_category_5")
        ) AS d("order_idx", "citizen_id", "first_name", "last_name", "birth_date", "prefix_label", "occupation", "occupation_code", "license_number", "license_category")
        WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para)
    ),
    unpivoted_lead_drivers AS (
        SELECT
            "lead"."Lead_No",
            "lead"."ref_policy_no",
            "lead"."cal_basic_renewal",
            ld.*
        FROM insurverse."Lead_coverage_premium" AS "lead"
        CROSS JOIN LATERAL (
            VALUES
                (1, "lead"."par_citizen_id_1", "lead"."par_first_name_1", "lead"."par_driver_license_no_1", "lead"."par_driver_license_category_1", "lead"."driver_behavior_1", "lead"."driver_behavior_consent_1", "lead"."YOB_Driver_1"),
                (2, "lead"."par_citizen_id_2", "lead"."par_first_name_2", "lead"."par_driver_license_no_2", "lead"."par_driver_license_category_2", "lead"."driver_behavior_2", "lead"."driver_behavior_consent_2", "lead"."YOB_Driver_2"),
                (3, "lead"."par_citizen_id_3", "lead"."par_first_name_3", "lead"."par_driver_license_no_3", "lead"."par_driver_license_category_3", "lead"."driver_behavior_3", "lead"."driver_behavior_consent_3", "lead"."YOB_Driver_3"),
                (4, "lead"."par_citizen_id_4", "lead"."par_first_name_4", "lead"."par_driver_license_no_4", "lead"."par_driver_license_category_4", "lead"."driver_behavior_4", "lead"."driver_behavior_consent_4", "lead"."YOB_Driver_4"),
                (5, "lead"."par_citizen_id_5", "lead"."par_first_name_5", "lead"."par_driver_license_no_5", "lead"."par_driver_license_category_5", "lead"."driver_behavior_5", "lead"."driver_behavior_consent_5", "lead"."YOB_Driver_5")
        ) AS ld("order_idx", "citizen_id", "first_name", "license_number", "license_category", "driver_behavior", "driver_behavior_consent", "yob")
        WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para)
    ),
    driver_list AS (
        SELECT
            jsonb_agg(
                jsonb_build_object(
                    'citizen_id', ld."citizen_id",
                    'first_name', ld."first_name",
                    'last_name', di."last_name",
                    'birth_date', di."birth_date",
                    'prefix_label', di."prefix_label",
                    'occupation', di."occupation",
                    'occupation_code', di."occupation_code",
                    'license_number', ld."license_number",
                    'license_category', ld."license_category",
                    'driver_behavior', ld."driver_behavior",
                    'driver_behavior_consent', ld."driver_behavior_consent",
                    'yob', ld."yob"
                ) ORDER BY ld."order_idx"
            ) AS drivers
        FROM unpivoted_lead_drivers ld
        LEFT JOIN driver_info di
            ON ld."order_idx" = di."order_idx"
        WHERE ld."citizen_id" IS NOT NULL
          AND ld."citizen_id" <> ''
    )
    SELECT
        jsonb_build_object(
            'lead_no', (SELECT lead_no FROM set_para),
            'ref_policy_no', "lead"."ref_policy_no",
            'cal_basic_renewal', "lead"."cal_basic_renewal",
            'owner_occupation', "policy"."Owner_occupation",
            'drivers', COALESCE((SELECT drivers FROM driver_list), '[]'::jsonb)
        )::text
    INTO RTN_JSON
    FROM insurverse."Lead_coverage_premium" AS "lead"
    LEFT JOIN insurverse."Policy_Header" AS "policy"
        ON "lead"."ref_policy_no" = "policy"."Policy_No"
    WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para);

    RETURN RTN_JSON;
END;
$function$;

-- 3. Dynamic Sequence Synchronization (MAX(id) + 1)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE n.nspname = 'insurverse' AND c.relkind = 'S' AND c.relname = 'seq_car_act_lead_no'
    ) THEN
        PERFORM setval('insurverse.seq_car_act_lead_no', COALESCE((SELECT MAX("Car_Act_Lead_No") FROM insurverse."Lead_Car_Act_Discount_Premium"), 90100) + 1, false);
    END IF;

    IF EXISTS (
        SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE n.nspname = 'insurverse' AND c.relkind = 'S' AND c.relname = 'seq_lead_no'
    ) THEN
        PERFORM setval('insurverse.seq_lead_no', COALESCE((SELECT MAX("Lead_No") FROM insurverse."Lead_coverage_premium"), 90100) + 1, false);
    END IF;
END $$;

COMMIT;
```

---

## ⚙️ 3. Environment Configurations (การตั้งค่า Configs)

### `go-echo-uam-service` Helm Values / Environment:
```yaml
env:
  - name: DB_MAX_OPEN_CONNS
    value: "50"
  - name: DB_MAX_IDLE_CONNS
    value: "25"
  - name: DB_CONN_MAX_LIFETIME
    value: "15m"
  - name: DB_CONN_MAX_IDLE_TIME
    value: "5m"
```

---

## 🔄 4. Post-Deployment Verification & Rollback Plan

### คำสั่งตรวจสอบหลังรันเสร็จ (Post-Deploy Health Verification):
```sql
-- ตรวจสอบคอลัมน์
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'insurverse' AND table_name = 'Policy_Header' AND column_name IN ('no_cancel_flag', 'Owner_occupation');

-- ทดสอบฟังก์ชัน Timezone (+7 ชม.)
SELECT insurverse.fn_format_utc_timestamp_th(NOW()::timestamp);

-- ตรวจสอบ Index
SELECT indexname FROM pg_indexes WHERE schemaname = 'insurverse' AND indexname IN ('idx_policy_header_enddate', 'idx_sf_claim_ref_notify_no');
```

### ขั้นตอน Rollback (กรณีฉุกเฉิน):
```sql
-- 1. Restore ฟังก์ชันเดิมจากไฟล์ Backup
\i backup_functions_pre_prod_<TIMESTAMP>.sql

-- 2. Drop Index (หากจำเป็น)
DROP INDEX IF EXISTS insurverse.idx_policy_header_enddate;
DROP INDEX IF EXISTS insurverse.idx_sf_claim_ref_notify_no;
```
