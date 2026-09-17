-- =============================================================================
-- Function: insurverse.fn_generate_random_otp
-- OID: 18525
-- Identity Arguments: (p_length integer, p_character_set character varying)
-- Returns: character varying
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_generate_random_otp(p_length integer DEFAULT 6, p_character_set character varying DEFAULT 'numeric'::character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_otp VARCHAR(10) := '';
    v_chars VARCHAR(100);
    v_i INT;
    v_idx INT;
BEGIN
    IF p_character_set = 'numeric' THEN
        v_chars := '0123456789';
    ELSIF p_character_set = 'alphanumeric' THEN
        v_chars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    ELSIF p_character_set = 'alphanumeric_lower' THEN
        v_chars := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    ELSE -- ใช้ค่าเริ่มต้นเป็นตัวเลข
        v_chars := '0123456789';
    END IF;
    
    FOR v_i IN 1..p_length LOOP
        v_idx := 1 + floor(random() * length(v_chars));
        v_otp := v_otp || substring(v_chars, v_idx, 1);
    END LOOP;
    
    RETURN v_otp;
END;
$function$
