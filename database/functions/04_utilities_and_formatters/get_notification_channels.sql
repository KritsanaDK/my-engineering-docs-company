-- =============================================================================
-- Function: insurverse.get_notification_channels
-- OID: 18976
-- Identity Arguments: (p_notification_type character varying, p_days_before integer)
-- Returns: TABLE(enable_email boolean, enable_sms boolean, email_template_code character varying, sms_template_code character varying)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.get_notification_channels(p_notification_type character varying, p_days_before integer)
 RETURNS TABLE(enable_email boolean, enable_sms boolean, email_template_code character varying, sms_template_code character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        nbr.enable_email,
        nbr.enable_sms,
        nbr.email_template_code,
        nbr.sms_template_code
    FROM insurverse.notification_business_rules nbr
    WHERE nbr.notification_type = p_notification_type 
    AND nbr.days_before = p_days_before
    AND nbr.is_active = true
    LIMIT 1;
END;
$function$
