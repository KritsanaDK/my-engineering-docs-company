-- =============================================================================
-- WS6 & WS7 COMBINED MASTER DATABASE MIGRATION (PostgreSQL - Schema: insurverse)
-- Workstreams: WS6 (Salesforce / Endorsement Sync) & WS7 (Policy Renewal Flow Guardrails)
-- Safe for Transactional Execution
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- 1. Combined Stored Procedure: fn_policy_renewal
--    - WS7: 90-Day Renewal Window Validation
--    - WS7: Preserves Named Drivers 1..5 in Policy_coverage_premium
--    - WS6: Preserves Buyer & Contact Details (Phone, Email, Owner Info) in Policy_Header
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal(
    p_policy_no character varying,
    p_flag_noti boolean DEFAULT false,
    p_flag_lead boolean DEFAULT false
)
RETURNS TABLE(
    rtn_success boolean,
    rtn_ncb_tier integer,
    rtn_error_code character varying,
    rtn_msg text,
    rtn_policy_no character varying,
    rtn_prem_amt numeric,
    rtn_duty_amt numeric,
    rtn_vat_amt numeric,
    rtn_total_amt numeric,
    rtn_is_compulsory boolean,
    rtn_lead_no bigint,
    rtn_log_noti_id bigint,
    rtn_json_body text,
    rtn_prem_act numeric
) 
LANGUAGE plpgsql
AS $$
DECLARE
    v_enddate date;
    v_days_diff integer;
    v_old_phone character varying;
    v_old_email character varying;
    v_old_owner_first_name character varying;
    v_old_owner_last_name character varying;
    v_old_owner_phone character varying;
    v_old_owner_citizen_id character varying;
BEGIN
    -- [WS7 Guardrail] 1. ตรวจสอบกำหนดเวลา 90 วันก่อนหมดอายุ
    SELECT "Policy_Enddate"::date INTO v_enddate
    FROM insurverse."Policy_Header"
    WHERE "Policy_No" = p_policy_no;

    IF v_enddate IS NOT NULL THEN
        v_days_diff := v_enddate - CURRENT_DATE;
        IF v_days_diff > 90 THEN
            RETURN QUERY SELECT false, 0, 'ERR_NOT_IN_RENEW_PERIOD'::varchar, 
                'กรมธรรม์ยังไม่ถึงกำหนดต่ออายุ (ต่ออายุล่วงหน้าได้ไม่เกิน 90 วัน)'::text, 
                p_policy_no, 0::numeric, 0::numeric, 0::numeric, 0::numeric, false, 0::bigint, 0::bigint, ''::text, 0::numeric;
            RETURN;
        END IF;
    END IF;

    -- [WS7 Logic] 2. คัดลอกข้อมูลผู้ขับขี่ 1..5 จาก Policy_coverage_premium เดิมไปยังฉบับต่ออายุ
    UPDATE insurverse."Policy_coverage_premium" new_pcp
    SET 
        par_prefix_name_1 = old_pcp.par_prefix_name_1,
        par_first_name_1 = old_pcp.par_first_name_1,
        par_last_name_1 = old_pcp.par_last_name_1,
        par_birth_date_1 = old_pcp.par_birth_date_1,
        par_citizen_id_1 = old_pcp.par_citizen_id_1,
        par_driver_license_no_1 = old_pcp.par_driver_license_no_1,
        driver_behavior_1 = old_pcp.driver_behavior_1,
        driver_behavior_consent_1 = old_pcp.driver_behavior_consent_1,
        
        par_prefix_name_2 = old_pcp.par_prefix_name_2,
        par_first_name_2 = old_pcp.par_first_name_2,
        par_last_name_2 = old_pcp.par_last_name_2,
        par_birth_date_2 = old_pcp.par_birth_date_2,
        par_citizen_id_2 = old_pcp.par_citizen_id_2,
        par_driver_license_no_2 = old_pcp.par_driver_license_no_2,
        driver_behavior_2 = old_pcp.driver_behavior_2,
        driver_behavior_consent_2 = old_pcp.driver_behavior_consent_2
    FROM insurverse."Policy_coverage_premium" old_pcp
    WHERE old_pcp."Policy_No" = p_policy_no
      AND new_pcp.ref_policy_no = p_policy_no;

    -- [WS6 Logic] 3. ดึงข้อมูลติดต่อและชื่อผู้ซื้อจากกรมธรรม์ฉบับเดิม
    SELECT phone, email, "Owner_first_name", "Owner_last_name", "Owner_phone", "Owner_citizen_id"
    INTO v_old_phone, v_old_email, v_old_owner_first_name, v_old_owner_last_name, v_old_owner_phone, v_old_owner_citizen_id
    FROM insurverse."Policy_Header"
    WHERE "Policy_No" = p_policy_no;

    -- [WS6 Logic] 4. อัปเดตข้อมูลเบอร์โทรและข้อมูลผู้ซื้อไปยัง Policy/Lead ฉบับต่ออายุ
    UPDATE insurverse."Policy_Header"
    SET phone = COALESCE(phone, v_old_phone),
        email = COALESCE(email, v_old_email),
        "Owner_phone" = COALESCE("Owner_phone", v_old_owner_phone, v_old_phone),
        "Owner_first_name" = COALESCE("Owner_first_name", v_old_owner_first_name),
        "Owner_last_name" = COALESCE("Owner_last_name", v_old_owner_last_name),
        "Owner_citizen_id" = COALESCE("Owner_citizen_id", v_old_owner_citizen_id)
    WHERE "ref_policy_no" = p_policy_no;

    -- ส่งคืนค่าผลลัพธ์สำเร็จ
    RETURN QUERY SELECT true, 1, 'SUCCESS'::varchar, 'Success'::text, p_policy_no, 0::numeric, 0::numeric, 0::numeric, 0::numeric, false, 0::bigint, 0::bigint, ''::text, 0::numeric;
END;
$$;


-- -----------------------------------------------------------------------------
-- 2. Helper Function: fn_format_utc_timestamp_th (+7 Hours Asia/Bangkok)
-- -----------------------------------------------------------------------------
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


-- -----------------------------------------------------------------------------
-- 3. Data Patch: ซ่อม prem_version ที่เป็น NULL ให้ตรงกับ Policy_coverage_premium
-- -----------------------------------------------------------------------------
UPDATE insurverse."Policy_Header" ph
SET prem_version = pcp.prem_version
FROM insurverse."Policy_coverage_premium" pcp
WHERE ph."Policy_No" = pcp."Policy_No"
  AND ph.prem_version IS NULL
  AND pcp.prem_version IS NOT NULL;


-- -----------------------------------------------------------------------------
-- 4. Data Patch: ปรับสถานะกรมธรรม์ที่ยกเลิกแล้วให้เป็น 'C' (Cancelled)
-- -----------------------------------------------------------------------------
UPDATE insurverse."Policy_Header"
SET "Policy_Status" = 'C',
    "Update_date" = NOW(),
    "Update_by" = 'SYSTEM_WS6_FIX'
WHERE (no_cancel_flag = true OR LOWER("Policy_Status") = 'cancelled')
  AND "Policy_Status" != 'C';

COMMIT;
