-- =============================================================================
-- Function: insurverse.fn_blacklist_email
-- OID: 18444
-- Identity Arguments: (p_email character varying, p_reason character varying)
-- Returns: void
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_blacklist_email(p_email character varying, p_reason character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_lockout_minutes INT;
BEGIN
    -- ดึงค่าจำนวนนาทีที่จะล็อกบัญชี
    SELECT COALESCE(NULLIF(insurverse.fn_get_otp_setting('otp_lockout_minutes', '10'), ''), '10')::INT 
    INTO v_lockout_minutes;
    
    -- ล็อกบัญชี
    INSERT INTO insurverse.otp_request_blacklist (
        email, locked_until, reason
    ) VALUES (
        p_email, 
        NOW() + (v_lockout_minutes || ' minutes')::INTERVAL, 
        p_reason
    );
END;
$function$
