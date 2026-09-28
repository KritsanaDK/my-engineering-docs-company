-- =============================================================================
-- Function: insurverse.fn_create_otp
-- OID: 18478
-- Identity Arguments: (p_email character varying, p_otp_length integer)
-- Returns: TABLE(rtn_success boolean, rtn_otp character varying, rtn_ref_code character varying, rtn_msg text, rtn_expiry_minutes integer)
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_create_otp(p_email character varying, p_otp_length integer DEFAULT NULL::integer)
 RETURNS TABLE(rtn_success boolean, rtn_otp character varying, rtn_ref_code character varying, rtn_msg text, rtn_expiry_minutes integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_otp VARCHAR(10);
    v_ref_code VARCHAR(50);
    v_expires_at TIMESTAMP;
    v_expiry_minutes INT;
    v_otp_length INT;
    v_character_set VARCHAR(50);
    v_blacklist_check RECORD;
    v_daily_check RECORD;
BEGIN
    
    -- ตรวจสอบจำนวนการขอ OTP รายวัน
    SELECT * INTO v_daily_check 
    FROM insurverse.fn_check_daily_otp_requests(p_email);
    
    IF NOT v_daily_check.can_request THEN
        RETURN QUERY SELECT 
            FALSE AS rtn_success,
            '' AS rtn_otp,
            '' AS rtn_ref_code,
            'Maximum daily OTP requests exceeded. Try again tomorrow.' AS rtn_msg,
            0 AS rtn_expiry_minutes;
        RETURN;
    END IF;
    
    -- ดึงการตั้งค่าระยะเวลาหมดอายุของ OTP
    SELECT COALESCE(NULLIF(insurverse.fn_get_otp_setting('otp_expiry_minutes', '5'), ''), '5')::INT 
    INTO v_expiry_minutes;
    
    -- ดึงการตั้งค่าความยาวของ OTP
    SELECT COALESCE(NULLIF(insurverse.fn_get_otp_setting('otp_length', '6'), ''), '6')::INT 
    INTO v_otp_length;
    
    -- ปรับแต่งความยาว OTP ถ้ามีการระบุในพารามิเตอร์
    IF p_otp_length IS NOT NULL AND p_otp_length > 0 THEN
        v_otp_length := p_otp_length;
    END IF;
    
    -- ดึงการตั้งค่ารูปแบบตัวอักษรของ OTP
    SELECT COALESCE(insurverse.fn_get_otp_setting('otp_character_set', 'numeric'), 'numeric') 
    INTO v_character_set;
    
    -- สร้าง OTP และ reference code
    v_otp := insurverse.fn_generate_random_otp(v_otp_length, v_character_set);
    v_ref_code := 'REF-' || to_char(NOW(), 'YYYYMMDD-HH24MISS-') || floor(random() * 1000)::TEXT;
    v_expires_at := NOW() + (v_expiry_minutes || ' minutes')::INTERVAL;
    
    -- บันทึกข้อมูล OTP
    INSERT INTO insurverse.otp_verification (
        email, otp, ref_code, expires_at, attempt_count, notification_sent
    ) VALUES (
        p_email, v_otp, v_ref_code, v_expires_at, 0, FALSE
    );
    
    -- อัพเดทจำนวนการขอ OTP รายวัน
    PERFORM insurverse.fn_update_daily_otp_requests(p_email);
    
    RETURN QUERY SELECT 
        TRUE AS rtn_success,
        v_otp AS rtn_otp,
        v_ref_code AS rtn_ref_code,
        'OTP created successfully' AS rtn_msg,
        v_expiry_minutes AS rtn_expiry_minutes;
    
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT 
        FALSE AS rtn_success,
        '' AS rtn_otp,
        '' AS rtn_ref_code,
        'Error: ' || SQLERRM AS rtn_msg,
        0 AS rtn_expiry_minutes;
END;
$function$
