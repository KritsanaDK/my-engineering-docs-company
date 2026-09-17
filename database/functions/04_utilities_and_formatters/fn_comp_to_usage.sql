-- =============================================================================
-- Function: insurverse.fn_comp_to_usage
-- OID: 18474
-- Identity Arguments: (in_comp_code text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_comp_to_usage(in_comp_code text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    sys_usage text; 
BEGIN
    IF in_comp_code = '1.10' THEN
        sys_usage := '110';
    ELSIF in_comp_code = '1.20A' THEN
        sys_usage := '210';
    ELSIF in_comp_code = '1.40A' THEN
        sys_usage := '320';
   	ELSIF in_comp_code = 'E11PA' THEN
        sys_usage := 'E11';
    END IF;

    RETURN sys_usage;
END;
$function$
