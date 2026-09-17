-- =============================================================================
-- Function: insurverse.fn_policy_receiptno_gen
-- OID: 18700
-- Identity Arguments: (in_is_test boolean, in_ref_key character varying)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_receiptno_gen(in_is_test boolean, in_ref_key character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	PRE_RECEIPT_NO TEXT;
	SYS_RECEIPT_NO TEXT;
BEGIN
	-- #1 PA KEY "PA-LEAD-" + LEAD_NO
	-- #2 HOME KEY "HOME-LEAD-" + LEAD_NO
	-- #3 TA KEY "TA-LEAD-" + LEAD_NO + "-" + OWNER_INDEX
	-- #4 MV KEY "MV-LEAD-" + LEAD_NO
	-- #5 MC KEY "MC-LEAD-" + LEAD_NO
	-- #6 MV+MC KEY "MVC-LEAD-" + LEAD_NO
	PRE_RECEIPT_NO = '3-4-00-' || TO_CHAR(now()+ INTERVAL '7 HOUR', 'yymm');
	IF in_ref_key is not null and in_ref_key != '' THEN
		-- Check duplicate no. return old no.
		SELECT receipt_no
		FROM insurverse.running_receipt
		WHERE ref_key = in_ref_key
		INTO SYS_RECEIPT_NO;
	END IF;
	IF SYS_RECEIPT_NO is null OR SYS_RECEIPT_NO = '' THEN
		IF in_is_test is not null and in_is_test = false THEN
			-- Actual no.
			-- If last no is not test data substring last 7 digi
				INSERT INTO insurverse.running_receipt (receipt_no,ref_key)
				VALUES (
					PRE_RECEIPT_NO || 
					regexp_replace(TO_CHAR(COALESCE(CAST(SUBSTR((SELECT MAX(receipt_no) FROM insurverse.running_receipt),12,5) AS INT),0)+1,'00000'), '[^\w]+','')
					,in_ref_key
				)
				RETURNING receipt_no
				INTO SYS_RECEIPT_NO;
		ELSE
			-- Test no. substring last 6 digi
			INSERT INTO insurverse.running_receipt (receipt_no,ref_key)
			VALUES (
				PRE_RECEIPT_NO || '9' || 
				regexp_replace(TO_CHAR(COALESCE(CAST(SUBSTR((SELECT MAX(receipt_no) FROM insurverse.running_receipt),13,4) AS INT),0)+1,'0000'), '[^\w]+','')
				,in_ref_key
			)
			RETURNING receipt_no
			INTO SYS_RECEIPT_NO;
		END IF;
	END IF;
	
	RETURN SYS_RECEIPT_NO;
END
$function$
