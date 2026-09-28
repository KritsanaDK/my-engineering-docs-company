-- =============================================================================
-- Function: insurverse.fn_verify_otp
-- OID: 18970
-- Identity Arguments: (p_email character varying, p_otp character varying)
-- Returns: TABLE(rtn_success boolean, rtn_msg text, rtn_attempts_left integer)
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_verify_otp(p_email character varying, p_otp character varying)
 RETURNS TABLE(rtn_success boolean, rtn_msg text, rtn_attempts_left integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_record RECORD;
    v_max_attempts INT;
    v_attempts_left INT;
    v_should_notify BOOLEAN := FALSE;
    v_notification_threshold INT := 2; -- แจ้งเตือนหลังจากผิด 2 ครั้ง
BEGIN
    -- ดึงค่าจำนวนครั้งสูงสุดที่อนุญาตให้ยืนยัน OTP ผิดพลาด
    SELECT COALESCE(NULLIF(insurverse.fn_get_otp_setting('otp_max_attempts', '3'), ''), '3')::INT 
    INTO v_max_attempts;
    
    -- ค้นหา OTP ล่าสุดที่ยังไม่หมดอายุและไม่ได้ยืนยัน
    SELECT * INTO v_record
    FROM insurverse.otp_verification
    WHERE email = p_email
      AND expires_at > NOW()
      AND is_verified = FALSE
    ORDER BY created_at DESC
    LIMIT 1;
    
    -- กรณีไม่พบ OTP ที่ยังไม่หมดอายุ
    IF v_record IS NULL THEN
        RETURN QUERY SELECT 
            FALSE AS rtn_success,
            'No active OTP found or OTP expired' AS rtn_msg,
            0 AS rtn_attempts_left;
        RETURN;
    END IF;
    
    -- เพิ่มจำนวนครั้งที่พยายามยืนยัน
    UPDATE insurverse.otp_verification
    SET attempt_count = attempt_count + 1
    WHERE id = v_record.id
    RETURNING attempt_count INTO v_record.attempt_count;
    
    -- คำนวณจำนวนครั้งที่เหลือ
    v_attempts_left := GREATEST(v_max_attempts - v_record.attempt_count, 0);
    
    -- ตรวจสอบว่าต้องส่งการแจ้งเตือนหรือไม่
    IF v_record.attempt_count >= v_notification_threshold AND NOT v_record.notification_sent THEN
        v_should_notify := TRUE;
        
        -- อัพเดทสถานะการส่งการแจ้งเตือน
        UPDATE insurverse.otp_verification
        SET notification_sent = TRUE
        WHERE id = v_record.id;
    END IF;
    
    -- ตรวจสอบว่าเกินจำนวนครั้งที่กำหนดหรือไม่
    IF v_record.attempt_count > v_max_attempts THEN
        -- แบล็คลิสต์อีเมลชั่วคราว
        PERFORM insurverse.fn_blacklist_email(
            p_email, 
            'Too many failed OTP verification attempts'
        );
        
        RETURN QUERY SELECT 
            FALSE AS rtn_success,
            'Maximum attempt limit exceeded. Your account has been temporarily locked. Please try again later.' AS rtn_msg,
            0 AS rtn_attempts_left;
        RETURN;
    END IF;
    
    -- ตรวจสอบ OTP
    IF v_record.otp = p_otp THEN
        -- OTP ถูกต้อง ทำการอัพเดตสถานะการยืนยัน
        UPDATE insurverse.otp_verification
        SET is_verified = TRUE,
            verified_at = NOW()
        WHERE id = v_record.id;
        
        RETURN QUERY SELECT 
            TRUE AS rtn_success,
            'OTP verified successfully' AS rtn_msg,
            v_attempts_left AS rtn_attempts_left;
    ELSE
        -- OTP ไม่ถูกต้อง
        RETURN QUERY SELECT 
            FALSE AS rtn_success,
            'Invalid OTP. You have ' || v_attempts_left || ' attempts left.' || 
            CASE WHEN v_should_notify THEN ' A notification has been sent to your email about this activity.' ELSE '' END AS rtn_msg,
            v_attempts_left AS rtn_attempts_left;
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT 
        FALSE AS rtn_success,
        'Error: ' || SQLERRM AS rtn_msg,
        0 AS rtn_attempts_left;
END;
$function$
