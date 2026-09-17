-- =============================================================================
-- Function: insurverse.fn_policy_quotationno_gen
-- OID: 18699
-- Identity Arguments: (in_is_test boolean, in_ref_key character varying)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_quotationno_gen(in_is_test boolean, in_ref_key character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	PRE_QUATATION_NO TEXT;
	SYS_QUATATION_NO TEXT;
BEGIN
	-- #1 PA KEY "PA-LEAD-" + LEAD_NO
	-- #2 HOME KEY "HOME-LEAD-" + LEAD_NO
	-- #3 TA KEY "TA-LEAD-" + LEAD_NO + "-" + OWNER_INDEX
	-- #4 MV KEY "MV-LEAD-" + LEAD_NO
	-- #5 MC KEY "MC-LEAD-" + LEAD_NO
	-- #6 MV+MC KEY "MVC-LEAD-" + LEAD_NO
	PRE_QUATATION_NO = '001-00-' || TO_CHAR(now()+ INTERVAL '7 HOUR', 'yy') || '-';
	IF in_ref_key is not null and in_ref_key != '' THEN
		-- Check duplicate no. return old no.
		SELECT quotation_no
		FROM insurverse.running_quotation
		WHERE ref_key = in_ref_key
		INTO SYS_QUATATION_NO;
	END IF;
	IF SYS_QUATATION_NO is null OR SYS_QUATATION_NO = '' THEN
		IF in_is_test is not null and in_is_test = false THEN
			-- Actual no.
			-- If last no is not test data substring last 7 digi
				INSERT INTO insurverse.running_quotation (quotation_no,ref_key)
				VALUES (
					PRE_QUATATION_NO || 
					regexp_replace(TO_CHAR(COALESCE(CAST(SUBSTR((SELECT MAX(quotation_no) FROM insurverse.running_quotation WHERE quotation_no like PRE_QUATATION_NO||'%'),11,7) AS INT),0)+1,'0000000'), '[^\w]+','') ||
					MOD(COALESCE(CAST(SUBSTR((SELECT MAX(quotation_no) FROM insurverse.running_quotation WHERE quotation_no like PRE_QUATATION_NO||'%'),11,7) AS INT),0)+1,8)
					,in_ref_key
				)
				RETURNING quotation_no
				INTO SYS_QUATATION_NO;
		ELSE
			-- Test no. substring last 6 digi
			INSERT INTO insurverse.running_quotation (quotation_no,ref_key)
			VALUES (
				PRE_QUATATION_NO || '9' || 
				regexp_replace(TO_CHAR(COALESCE(CAST(SUBSTR((SELECT MAX(quotation_no) FROM insurverse.running_quotation WHERE quotation_no like PRE_QUATATION_NO||'%'),12,6) AS INT),0)+1,'000000'), '[^\w]+','') ||
				MOD(COALESCE(CAST(SUBSTR('9' || (SELECT MAX(quotation_no) FROM insurverse.running_quotation WHERE quotation_no like PRE_QUATATION_NO||'%'),12,6) AS INT),0)+1,8)
				,in_ref_key
			)
			RETURNING quotation_no
			INTO SYS_QUATATION_NO;
		END IF;
	END IF;
	
	RETURN SYS_QUATATION_NO;
END
$function$
