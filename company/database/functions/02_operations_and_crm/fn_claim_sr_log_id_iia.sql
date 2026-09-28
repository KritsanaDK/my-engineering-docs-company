-- =============================================================================
-- Function: insurverse.fn_claim_sr_log_id_iia
-- OID: 18457
-- Identity Arguments: ()
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_claim_sr_log_id_iia()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_ID_NO TEXT; SYS_ID_LAST INT;
BEGIN
  -- Routine body goes here...
	SYS_ID_NO = TO_CHAR(now()+ INTERVAL '7 HOUR','yymm');
	/*
	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR(CAST("sr_log_id" as TEXT),5,4) AS INT),0)
	FROM insurverse."sf_claim"
	ORDER BY "sr_log_id" DESC
	LIMIT 1'
	INTO SYS_ID_LAST;
	*/
	
	EXECUTE
	'SELECT COALESCE("sr_log_id",0)
	FROM insurverse."sf_claim"
	ORDER BY "sr_log_id" DESC
	LIMIT 1'
	INTO SYS_ID_LAST;
	
	IF SYS_ID_LAST IS NULL THEN
	 SYS_ID_LAST = 0;
	END IF;
	
	--SYS_ID_NO = SYS_ID_NO || regexp_replace(TO_CHAR(SYS_ID_LAST+1,'0000'), '[^\w]+','');
	SYS_ID_NO = SYS_ID_LAST+1;
	
	RETURN SYS_ID_NO;
END
$function$
