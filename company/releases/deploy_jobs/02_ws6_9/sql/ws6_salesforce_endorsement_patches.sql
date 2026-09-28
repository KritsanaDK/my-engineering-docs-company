-- =============================================================================
-- WS6 Database Patch Scripts (PostgreSQL - Schema: insurverse)
-- Host: 34.126.145.44 | DB: insurverse
-- =============================================================================

-- -----------------------------------------------------------------------------
-- WS6.1: แก้เคสเบอร์โทร/ข้อมูลผู้ซื้อไม่ขึ้น SF (ตอน renew MC ให้ส่งเบอร์และข้อมูลผู้ซื้อต่อ)
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
    v_old_phone character varying;
    v_old_email character varying;
    v_old_owner_first_name character varying;
    v_old_owner_last_name character varying;
    v_old_owner_phone character varying;
    v_old_owner_citizen_id character varying;
BEGIN
    -- 1. ดึงข้อมูลติดต่อและชื่อผู้ซื้อจากกรมธรรม์ฉบับเดิม
    SELECT phone, email, "Owner_first_name", "Owner_last_name", "Owner_phone", "Owner_citizen_id"
    INTO v_old_phone, v_old_email, v_old_owner_first_name, v_old_owner_last_name, v_old_owner_phone, v_old_owner_citizen_id
    FROM insurverse."Policy_Header"
    WHERE "Policy_No" = p_policy_no;

    -- 2. อัปเดตข้อมูลเบอร์โทรและข้อมูลผู้ซื้อไปยัง Policy/Lead ฉบับต่ออายุ
    UPDATE insurverse."Policy_Header"
    SET phone = COALESCE(phone, v_old_phone),
        email = COALESCE(email, v_old_email),
        "Owner_phone" = COALESCE("Owner_phone", v_old_owner_phone, v_old_phone),
        "Owner_first_name" = COALESCE("Owner_first_name", v_old_owner_first_name),
        "Owner_last_name" = COALESCE("Owner_last_name", v_old_owner_last_name),
        "Owner_citizen_id" = COALESCE("Owner_citizen_id", v_old_owner_citizen_id)
    WHERE "ref_policy_no" = p_policy_no;

END;
$$;


-- -----------------------------------------------------------------------------
-- WS6.2: ซ่อม prem_version ที่เป็น NULL / หยิบผิดชุด ให้ตรงกับ Policy_coverage_premium
-- -----------------------------------------------------------------------------
UPDATE insurverse."Policy_Header" ph
SET prem_version = pcp.prem_version
FROM insurverse."Policy_coverage_premium" pcp
WHERE ph."Policy_No" = pcp."Policy_No"
  AND ph.prem_version IS NULL
  AND pcp.prem_version IS NOT NULL;


-- -----------------------------------------------------------------------------
-- WS6.4: ปรับปรุงฟังก์ชันแปลงเวลาวันที่สลักหลังให้บวก offset 7 ชั่วโมง (Asia/Bangkok)
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


-- -----------------------------------------------------------------------------
-- WS6.5: ปรับสถานะกรมธรรม์ที่ยกเลิกแล้วให้เป็น 'C' (Cancelled)
-- -----------------------------------------------------------------------------
UPDATE insurverse."Policy_Header"
SET "Policy_Status" = 'C',
    "Update_date" = NOW(),
    "Update_by" = 'SYSTEM_WS6_FIX'
WHERE (no_cancel_flag = true OR LOWER("Policy_Status") = 'cancelled')
  AND "Policy_Status" != 'C';
