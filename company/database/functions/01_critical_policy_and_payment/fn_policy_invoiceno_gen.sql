-- =============================================================================
-- Function: insurverse.fn_policy_invoiceno_gen
-- OID: 18622
-- Identity Arguments: (in_is_test boolean, in_ref_key character varying, in_book_no character varying)
-- Returns: text
-- Language: plpgsql
-- Categorization: 01_critical_policy_and_payment
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_invoiceno_gen(in_is_test boolean, in_ref_key character varying, in_book_no character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	PRE_INVOICE_NO TEXT;
	SYS_INVOICE_NO TEXT;
  PH_INVOICE_LAST INT;
	CA_INVOICE_LAST INT;
	SYS_INVOICE_LAST INT;
	SYS_BOOK_NO TEXT;
BEGIN
	-- #1 PA KEY "PA-LEAD-" + LEAD_NO
	-- #2 HOME KEY "HOME-LEAD-" + LEAD_NO
	-- #3 TA KEY "TA-LEAD-" + LEAD_NO + "-" + OWNER_INDEX
	-- #4 MV KEY "MV-LEAD-" + LEAD_NO
	-- #5 MC KEY "MC-LEAD-" + LEAD_NO
	-- #6 MV+MC KEY "MVC-LEAD-" + LEAD_NO
	PRE_INVOICE_NO = TO_CHAR(now()+ INTERVAL '7 HOUR', 'yymm/');
	
	IF in_ref_key is not null and in_ref_key != '' THEN
		-- Check duplicate no. return old no.
		SELECT invoice_no
		FROM insurverse.running_book_invoice
		WHERE ref_key = in_ref_key
		INTO SYS_INVOICE_NO;
	END IF;
	IF SYS_INVOICE_NO is null OR SYS_INVOICE_NO = '' THEN
		IF in_is_test is not null and in_is_test = false THEN
			-- Actual no.
			-- If last no is not test data substring last 7 digi
				INSERT INTO insurverse.running_book_invoice (invoice_no,ref_key, book)
				VALUES (
					PRE_INVOICE_NO || 
					regexp_replace(TO_CHAR(COALESCE(CAST(SUBSTR((SELECT MAX(invoice_no) FROM insurverse.running_book_invoice WHERE book=in_book_no),6,5) AS INT),0)+1,'00000'), '[^\w]+','')
					,in_ref_key
					,in_book_no
				)
				RETURNING invoice_no
				INTO SYS_INVOICE_NO;
		ELSE
			-- Test no. substring last 6 digi
			INSERT INTO insurverse.running_book_invoice (invoice_no,ref_key, book)
			VALUES (
				PRE_INVOICE_NO || '9' || 
				regexp_replace(TO_CHAR(COALESCE(CAST(SUBSTR((SELECT MAX(invoice_no) FROM insurverse.running_book_invoice WHERE book=in_book_no),7,4) AS INT),0)+1,'0000'), '[^\w]+','')
				,in_ref_key
				,in_book_no
			)
			RETURNING invoice_no
			INTO SYS_INVOICE_NO;
		END IF;
	END IF;
	
	RETURN SYS_INVOICE_NO;
END
$function$
