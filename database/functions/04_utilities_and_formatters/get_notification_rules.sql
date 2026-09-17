-- =============================================================================
-- Function: insurverse.get_notification_rules
-- OID: 18980
-- Identity Arguments: (p_notification_type character varying, p_days_before integer)
-- Returns: TABLE(rule_code character varying, rule_name character varying, enable_email boolean, enable_sms boolean, enable_push boolean, enable_line boolean, email_template_code character varying, sms_template_code character varying, push_template_code character varying, line_template_code character varying)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.get_notification_rules(p_notification_type character varying, p_days_before integer)
 RETURNS TABLE(rule_code character varying, rule_name character varying, enable_email boolean, enable_sms boolean, enable_push boolean, enable_line boolean, email_template_code character varying, sms_template_code character varying, push_template_code character varying, line_template_code character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        nbr.rule_code,
        nbr.rule_name,
        nbr.enable_email,
        nbr.enable_sms,
        nbr.enable_push,
        nbr.enable_line,
        nbr.email_template_code,
        nbr.sms_template_code,
        nbr.push_template_code,
        nbr.line_template_code
    FROM insurverse.notification_business_rules nbr
    WHERE nbr.notification_type = p_notification_type 
    AND nbr.days_before = p_days_before
    AND nbr.is_active = true
    ORDER BY nbr.created_at;
END;
$function$
