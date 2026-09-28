-- =============================================================================
-- Function: insurverse.fn_update_promo_batch
-- OID: 18959
-- Identity Arguments: ()
-- Returns: TABLE(rtn_success boolean, rtn_error_code text, rtn_msg text, rtn_json_body text)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_promo_batch()
 RETURNS TABLE(rtn_success boolean, rtn_error_code text, rtn_msg text, rtn_json_body text)
 LANGUAGE plpgsql
AS $function$
	DECLARE
	-- return result
	RTN_SUCCESS BOOL; RTN_ERROR_CODE TEXT;
	RTN_MSG TEXT; RTN_JSON_BODY TEXT;
	BEGIN
	RTN_SUCCESS = true;
	-- BATCH Update promo_code_status
	update insurverse."promo_code"
	set "promo_code_status" = 'INT'
	where "promo_code_status" = 'ACT' and "active_end_date" < now();
	
	RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_JSON_BODY;
END
$function$
