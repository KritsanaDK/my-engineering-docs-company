-- =============================================================================
-- Function: insurverse.fn_policy_transid_sf
-- OID: 18828
-- Identity Arguments: ()
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_transid_sf()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_TRANSID_LAST INT; SYS_TRANSID_MOD INT; SYS_TRANSID TEXT;
PH_TRANSID_LAST INT; CA_TRANSID_LAST INT;
BEGIN
  SYS_TRANSID = TO_CHAR(now()+ INTERVAL '7 HOUR','yymmdd') || 'T';
	
	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("SF_Policy_id",8,6) AS INT),0)
	FROM insurverse."Policy_Header"
	WHERE "SF_Policy_id" LIKE ''' || SYS_TRANSID || '%''' ||
	'ORDER BY "SF_Policy_id" DESC
	LIMIT 1'
	INTO PH_TRANSID_LAST;
	
	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("SF_Policy_id",8,6) AS INT),0)
	FROM insurverse."Policy_Car_Act_Discount_Premium"
	WHERE "SF_Policy_id" LIKE ''' || SYS_TRANSID || '%''' ||
	'ORDER BY "SF_Policy_id" DESC
	LIMIT 1'
	INTO CA_TRANSID_LAST;
	
	IF PH_TRANSID_LAST IS NULL THEN
	 PH_TRANSID_LAST = 0;
	END IF;
	
	IF CA_TRANSID_LAST IS NULL THEN
	 CA_TRANSID_LAST = 0;
	END IF;
	
	IF PH_TRANSID_LAST >= CA_TRANSID_LAST THEN
		SYS_TRANSID_LAST = PH_TRANSID_LAST;
	ELSE
		SYS_TRANSID_LAST = CA_TRANSID_LAST;
	END IF;
	
	SYS_TRANSID_MOD = MOD(SYS_TRANSID_LAST+1,8);
	SYS_TRANSID = SYS_TRANSID || regexp_replace(TO_CHAR(SYS_TRANSID_LAST+1,'000000'), '[^\w]+','') || SYS_TRANSID_MOD;
  
  RETURN SYS_TRANSID;
END
$function$
