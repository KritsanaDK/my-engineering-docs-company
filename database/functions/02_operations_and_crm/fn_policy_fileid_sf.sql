-- =============================================================================
-- Function: insurverse.fn_policy_fileid_sf
-- OID: 18620
-- Identity Arguments: ()
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_fileid_sf()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_FILEID_LAST INT; SYS_FILEID_MOD INT; SYS_FILEID TEXT;
BEGIN
  SYS_FILEID = TO_CHAR(now()+ INTERVAL '7 HOUR','yymmdd') || 'F';
	
	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("sf_file_id",8,6) AS INT),0)
	FROM insurverse."Policy_Regis_Evident"
	WHERE "sf_file_id" LIKE ''' || SYS_FILEID || '%''' ||
	'ORDER BY "sf_file_id" DESC
	LIMIT 1'
	INTO SYS_FILEID_LAST;
	
	IF SYS_FILEID_LAST IS NULL THEN
	 SYS_FILEID_LAST = 0;
	END IF;
	
	SYS_FILEID_MOD = MOD(SYS_FILEID_LAST+1,8);
	SYS_FILEID = SYS_FILEID || regexp_replace(TO_CHAR(SYS_FILEID_LAST+1,'000000'), '[^\w]+','') || SYS_FILEID_MOD;
  
  RETURN SYS_FILEID;
END
$function$
