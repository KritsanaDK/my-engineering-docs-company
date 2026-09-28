-- =============================================================================
-- Production Deployment Script: Workstream WS6 (Salesforce & Endorsement)
-- Target Environment: Production PostgreSQL Database
-- Schema: insurverse
-- Prepared per Rule 5 (Production Deployment Pack) & Rule 6 (Verified Schema)
-- =============================================================================

-- =============================================================================
-- STEP 0: PRE-DEPLOYMENT BACKUP & SAFETY CHECK (คำแนะนำการสำรองข้อมูลก่อนรัน)
-- =============================================================================
-- 1. ทำการ Backup ข้อมูลแถวที่จะถูก Update ใน Policy_Header:
-- CREATE TABLE IF NOT EXISTS insurverse.backup_ws6_policy_header_pre_deploy AS
-- SELECT "Policy_No", "Policy_Status", "no_cancel_flag", "prem_version", "Update_date", "Update_by"
-- FROM insurverse."Policy_Header"
-- WHERE (prem_version IS NULL)
--    OR (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled');

-- =============================================================================
-- TRANSACTION START
-- =============================================================================
BEGIN;

-- -----------------------------------------------------------------------------
-- STEP 1 (WS6.4): สร้างฟังก์ชันจัดรูปแบบเวลาสลักหลัง UTC เป็นเวลาไทย (+7 Hours)
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
-- STEP 2 (WS6.2): ซ่อมข้อมูล prem_version ใน Policy_Header ที่เป็น NULL
-- เพื่อให้ระบบสามารถระบุชุดเบี้ยและเปิดหน้าจอ Edit เพื่อทำสลักหลังได้ถูกต้อง
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
-- STEP 3 (WS6.5): อัปเดตสถานะ Policy_Status ของกรมธรรม์ที่ยกเลิกแล้วให้เป็น 'C'
-- แก้ไข type mismatch จาก boolean true เป็น varchar(1) 'Y' เรียบร้อยแล้ว
-- -----------------------------------------------------------------------------
UPDATE insurverse."Policy_Header"
SET "Policy_Status" = 'C',
    "Update_date" = NOW(),
    "Update_by" = 'SYSTEM_WS6_PROD'
WHERE (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled')
  AND "Policy_Status" != 'C';


-- =============================================================================
-- STEP 4: VERIFICATION QUERIES (ตรวจสอบผลการรันก่อน COMMIT)
-- =============================================================================
-- ตรวจสอบว่ายังมี prem_version เป็น NULL หรือไม่:
-- SELECT COUNT(*) as remaining_null_prem_version 
-- FROM insurverse."Policy_Header" ph 
-- JOIN insurverse."Policy_coverage_premium" pcp ON ph."Policy_No" = pcp."Policy_No"
-- WHERE ph.prem_version IS NULL AND pcp.prem_version IS NOT NULL;

-- ตรวจสอบว่ายังมีกรมธรรม์ยกเลิกที่ยังไม่เป็น 'C' หรือไม่:
-- SELECT COUNT(*) as remaining_uncancelled 
-- FROM insurverse."Policy_Header"
-- WHERE (no_cancel_flag = 'Y' OR LOWER("Policy_Status") = 'cancelled')
--   AND "Policy_Status" != 'C';

COMMIT;
-- =============================================================================
-- END OF SCRIPT
-- =============================================================================
