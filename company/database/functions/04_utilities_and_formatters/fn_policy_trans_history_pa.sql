-- =============================================================================
-- Function: insurverse.fn_policy_trans_history_pa
-- OID: 18810
-- Identity Arguments: (in_policy_pa_no text, in_trans_id text)
-- Returns: TABLE(rtn_policy_no text, rtn_trans_id text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_trans_history_pa(in_policy_pa_no text, in_trans_id text)
 RETURNS TABLE(rtn_policy_no text, rtn_trans_id text)
 LANGUAGE plpgsql
AS $function$
DECLARE 
SYS_TRANSID TEXT; SYS_POLICY_NO TEXT;
BEGIN

	SELECT "policy_pa_no"
	FROM insurverse."policy_pa_premium"
	WHERE "policy_pa_no"="in_policy_pa_no"
	INTO SYS_POLICY_NO;
	
	SELECT "sf_policy_id"
	FROM insurverse."policy_pa_premium"
	WHERE "sf_policy_id"="in_trans_id"
	INTO SYS_TRANSID;
	
	IF SYS_TRANSID IS NULL THEN
		SELECT "sf_policy_id"
		FROM insurverse."policy_pa_premium_trans"
		WHERE "sf_policy_id"="in_trans_id"
		INTO SYS_TRANSID;
	END IF;
	
	IF SYS_POLICY_NO IS NOT NULL AND SYS_TRANSID IS NULL THEN
		SYS_TRANSID = "in_trans_id";
		
		UPDATE insurverse."policy_pa_premium"
		SET "sf_policy_id" = "in_policy_pa_no" || '-000'
		WHERE "policy_pa_no"="in_policy_pa_no" AND "sf_policy_id" IS NULL;
	
		UPDATE insurverse."lead_pa_participant"
		SET "sf_policy_id" = "in_policy_pa_no" || '-000'
		WHERE "policy_pa_no"="in_policy_pa_no" AND "sf_policy_id" IS NULL;
	
		UPDATE insurverse."lead_pa_coverage"
		SET "sf_policy_id" = "in_policy_pa_no" || '-000'
		WHERE "policy_pa_no"="in_policy_pa_no" AND "sf_policy_id" IS NULL;
	
		UPDATE insurverse."lead_pa_beneficiary"
		SET "sf_policy_id" = "in_policy_pa_no" || '-000'
		WHERE "policy_pa_no"="in_policy_pa_no" AND "sf_policy_id" IS NULL;
		
		INSERT INTO insurverse."policy_pa_premium_trans"
		SELECT *
		FROM insurverse."policy_pa_premium"
		WHERE "policy_pa_no"="in_policy_pa_no"
		LIMIT 1;
	
		INSERT INTO insurverse."lead_pa_participant_trans"
		SELECT *
		FROM insurverse."lead_pa_participant"
		WHERE "policy_pa_no"="in_policy_pa_no";
	
		INSERT INTO insurverse."lead_pa_coverage_trans"
		SELECT *
		FROM insurverse."lead_pa_coverage"
		WHERE "policy_pa_no"="in_policy_pa_no";
	
		INSERT INTO insurverse."lead_pa_beneficiary_trans"
		SELECT *
		FROM insurverse."lead_pa_beneficiary"
		WHERE "policy_pa_no"="in_policy_pa_no";
		
		UPDATE insurverse."policy_pa_premium"
		SET "sf_policy_id" = "in_trans_id", "create_date"=now()
		WHERE "policy_pa_no"="in_policy_pa_no";
	
		UPDATE insurverse."lead_pa_participant"
		SET "sf_policy_id" = "in_trans_id", "create_date"=now()
		WHERE "policy_pa_no"="in_policy_pa_no";
	
		UPDATE insurverse."lead_pa_coverage"
		SET "sf_policy_id" = "in_trans_id", "create_date"=now()
		WHERE "policy_pa_no"="in_policy_pa_no";
	
		UPDATE insurverse."lead_pa_beneficiary"
		SET "sf_policy_id" = "in_trans_id", "create_date"=now()
		WHERE "policy_pa_no"="in_policy_pa_no";
		
	END IF;
	
	RETURN QUERY SELECT SYS_POLICY_NO,SYS_TRANSID;
END
$function$
