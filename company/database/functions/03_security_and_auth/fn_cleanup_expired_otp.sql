-- =============================================================================
-- Function: insurverse.fn_cleanup_expired_otp
-- OID: 18468
-- Identity Arguments: ()
-- Returns: void
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_cleanup_expired_otp()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM insurverse.otp_verification
    WHERE expires_at < NOW() AND is_verified = FALSE;
END;
$function$
