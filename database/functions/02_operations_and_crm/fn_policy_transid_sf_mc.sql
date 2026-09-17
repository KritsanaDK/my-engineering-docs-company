-- =============================================================================
-- Function: insurverse.fn_policy_transid_sf_mc
-- OID: 18833
-- Identity Arguments: (car_act_no text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_transid_sf_mc(car_act_no text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_TRANSID_LAST INT; SYS_TRANSID_MOD INT; SYS_TRANSID TEXT;
SYS_POLICY_RUNNO INT; SYS_MARGE_RUNNO INT;
BEGIN
  SYS_TRANSID = car_act_no || '-';
	
	SYS_POLICY_RUNNO = COALESCE(CAST(SUBSTR("car_act_no",11,6) AS INT),0);
	
	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("SF_Policy_id",18,2) AS INT),0)
	FROM insurverse."Policy_Car_Act_Discount_Premium"
	WHERE "SF_Policy_id" LIKE ''' || SYS_TRANSID || '%''' ||
	'ORDER BY "SF_Policy_id" DESC
	LIMIT 1'
	INTO SYS_TRANSID_LAST;
	
	IF SYS_TRANSID_LAST IS NULL THEN
		SYS_TRANSID_LAST = 0;
	END IF;
	
	SYS_TRANSID_LAST = SYS_TRANSID_LAST + 1;
	SYS_MARGE_RUNNO = CAST(regexp_replace(TO_CHAR(SYS_POLICY_RUNNO,'000000'), '[^\w]+','') || regexp_replace(TO_CHAR(SYS_TRANSID_LAST,'00'), '[^\w]+','')  AS INT);
	SYS_TRANSID_MOD = MOD(SYS_MARGE_RUNNO,8);
	SYS_TRANSID = SYS_TRANSID || regexp_replace(TO_CHAR(SYS_TRANSID_LAST,'00'), '[^\w]+','') || SYS_TRANSID_MOD;
  
  RETURN SYS_TRANSID;
END
$function$
