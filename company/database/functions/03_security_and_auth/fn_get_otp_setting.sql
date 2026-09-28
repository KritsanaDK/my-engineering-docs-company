-- =============================================================================
-- Function: insurverse.fn_get_otp_setting
-- OID: 18534
-- Identity Arguments: (p_setting_key character varying, p_default_value character varying)
-- Returns: character varying
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_get_otp_setting(p_setting_key character varying, p_default_value character varying DEFAULT NULL::character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_value VARCHAR(255);
BEGIN
    SELECT setting_value INTO v_value
    FROM insurverse.otp_settings
    WHERE setting_key = p_setting_key;
    
    IF v_value IS NULL THEN
        RETURN p_default_value;
    ELSE
        RETURN v_value;
    END IF;
END;
$function$
