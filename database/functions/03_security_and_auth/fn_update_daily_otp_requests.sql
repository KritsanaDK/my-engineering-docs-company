-- =============================================================================
-- Function: insurverse.fn_update_daily_otp_requests
-- OID: 18911
-- Identity Arguments: (p_email character varying)
-- Returns: void
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_daily_otp_requests(p_email character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO insurverse.otp_daily_requests (email, request_date, request_count)
    VALUES (p_email, CURRENT_DATE, 1)
    ON CONFLICT (email, request_date) 
    DO UPDATE SET request_count = insurverse.otp_daily_requests.request_count + 1;
END;
$function$
