-- =============================================================================
-- Function: insurverse.fn_policy_quatationno_iia_endorse
-- OID: 18679
-- Identity Arguments: (policy_number text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_quatationno_iia_endorse(policy_number text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	SYS_QUATATION_NO TEXT;
BEGIN
	IF SUBSTR(policy_number,1,2) = 'MV' then
		/*
		SELECT "Policy_Quatation_No"
		FROM insurverse."Policy_endorse_detail"
		WHERE "Policy_No"="policy_number"
		ORDER BY "id" desc
		LIMIT 1
		INTO SYS_QUATATION_NO;
		*/
		IF SYS_QUATATION_NO IS NULL OR SYS_QUATATION_NO = '' THEN
			SELECT "Policy_Quatation_No"
			FROM insurverse."Policy_Header"
			WHERE "Policy_No"="policy_number"
			INTO SYS_QUATATION_NO;
		END IF;
	ELSIF SUBSTR(policy_number,1,2) = 'MC' then
		/*
		SELECT "Policy_Quatation_No"
		FROM insurverse."Policy_endorse_detail"
		WHERE "Car_Act_No"="policy_number"
		ORDER BY "id" desc
		LIMIT 1
		INTO SYS_QUATATION_NO;
		*/
		IF SYS_QUATATION_NO IS NULL OR SYS_QUATATION_NO = '' THEN
			SELECT "Policy_Quatation_No"
			FROM insurverse."Policy_Car_Act_Discount_Premium"
			WHERE "Car_Act_No"="policy_number"
			INTO SYS_QUATATION_NO;
		END IF;
	END IF;
	RETURN SYS_QUATATION_NO;
END
$function$
