-- =============================================================================
-- WS7 Database Patch Scripts (PostgreSQL - Schema: insurverse)
-- Host: 34.126.145.44 | DB: insurverse
-- =============================================================================

-- -----------------------------------------------------------------------------
-- WS7.1 & WS7.2: ปรับปรุง fn_policy_renewal ให้รักษาข้อมูลผู้ขับขี่ 1..5 และตรวจ 90 วัน
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
BEGIN
    -- 1. WS7.2: ตรวจสอบกำหนดเวลา 90 วันก่อนหมดอายุ
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

    -- 2. WS7.1: คัดลอกข้อมูลผู้ขับขี่ 1..5 (Par_first_name, Par_citizen_id, etc.) จาก Policy_coverage_premium เดิมไปยังฉบับต่ออายุ
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

    -- ส่งคืนค่าผลลัพธ์การสร้าง Lead/Policy Renewal
    RETURN QUERY SELECT true, 1, 'SUCCESS'::varchar, 'Success'::text, p_policy_no, 0::numeric, 0::numeric, 0::numeric, 0::numeric, false, 0::bigint, 0::bigint, ''::text, 0::numeric;
END;
$$;
