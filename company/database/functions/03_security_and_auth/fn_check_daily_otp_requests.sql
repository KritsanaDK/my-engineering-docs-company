-- =============================================================================
-- Function: insurverse.fn_check_daily_otp_requests
-- OID: 18445
-- Identity Arguments: (p_email character varying)
-- Returns: TABLE(can_request boolean, daily_limit integer, requests_made integer, remaining_requests integer)
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_check_daily_otp_requests(p_email character varying)
 RETURNS TABLE(can_request boolean, daily_limit integer, requests_made integer, remaining_requests integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_max_requests INT;
    v_current_count INT := 0;
    v_limit INT;
    v_remaining INT;
BEGIN
    -- ดึงจำนวนครั้งสูงสุดที่อนุญาตต่อวัน
    SELECT COALESCE(NULLIF(insurverse.fn_get_otp_setting('otp_max_daily_requests', '5'), ''), '5')::INT 
    INTO v_max_requests;
    
    -- ตรวจสอบว่ามีการขอ OTP ไปกี่ครั้งแล้วในวันนี้
    SELECT COALESCE(request_count, 0) INTO v_current_count
    FROM insurverse.otp_daily_requests
    WHERE email = p_email AND request_date = CURRENT_DATE;
    
    -- คำนวณค่าที่เหลือ
    v_remaining := GREATEST(0, v_max_requests - v_current_count);
    
    IF v_current_count >= v_max_requests THEN
        RETURN QUERY SELECT 
            FALSE AS can_request,
            v_max_requests AS daily_limit,
            v_current_count AS requests_made,
            v_remaining AS remaining_requests;
    ELSE
        RETURN QUERY SELECT 
            TRUE AS can_request,
            v_max_requests AS daily_limit,
            v_current_count AS requests_made,
            v_remaining AS remaining_requests;
    END IF;
END;
$function$
