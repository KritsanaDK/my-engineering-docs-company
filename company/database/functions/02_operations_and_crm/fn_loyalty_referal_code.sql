-- =============================================================================
-- Function: insurverse.fn_loyalty_referal_code
-- OID: 18565
-- Identity Arguments: (in_user_id text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_loyalty_referal_code(in_user_id text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$BEGIN
  
	RETURN UPPER(insurverse.crc32("in_user_id"));
END
$function$
