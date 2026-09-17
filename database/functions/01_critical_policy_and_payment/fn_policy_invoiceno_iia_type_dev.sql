-- =============================================================================
-- Function: insurverse.fn_policy_invoiceno_iia_type_dev
-- OID: 18625
-- Identity Arguments: (group_type text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 01_critical_policy_and_payment
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_invoiceno_iia_type_dev(group_type text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	SYS_INVOICE_NO TEXT;
  PH_INVOICE_LAST INT;
	CA_INVOICE_LAST INT;
	SYS_INVOICE_LAST INT;
	SYS_BOOK_NO TEXT;
BEGIN
	SYS_INVOICE_NO = TO_CHAR(now()+ INTERVAL '7 HOUR', 'yymm/');
	
  IF LOWER(group_type) = 'ta' OR LOWER(group_type) = 'pa' or LOWER(group_type) = 'home' THEN
		SYS_BOOK_NO = insurverse.fn_policy_book_iia_type_dev(group_type);
		EXECUTE
	'SELECT "inv_no"
		FROM (
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_invoice_no",6,5) AS INT),0) as "inv_no"
			FROM insurverse."policy_ta_premium"
			WHERE "policy_invoice_no" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "policy_book"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "policy_invoice_no" DESC
			LIMIT 1) as "inv"
		UNION
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_invoice_no",6,5) AS INT),0) as "inv_no"
			FROM insurverse."policy_pa_premium"
			WHERE "policy_invoice_no" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "policy_book"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "policy_invoice_no" DESC
			LIMIT 1) as "inv"
		UNION
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_invoice_no",6,5) AS INT),0) as "inv_no"
			FROM insurverse."policy_home_premium"
			WHERE "policy_invoice_no" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "policy_book"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "policy_invoice_no" DESC
			LIMIT 1) as "inv"
		) as "h_inv"
		ORDER BY "inv_no" DESC
		LIMIT 1
		'
	INTO SYS_INVOICE_LAST;
	ELSIF LOWER(group_type) = 'motor' THEN
		SYS_BOOK_NO = insurverse.fn_policy_book_iia_type_dev(group_type);
		
		EXECUTE
	'SELECT "inv_no"
		FROM (
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
			FROM insurverse."Policy_Header"
			WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "Policy_Invoice_No" DESC
			LIMIT 1) as "inv"
		UNION
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
			FROM insurverse."Policy_Car_Act_Discount_Premium"
			WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "Policy_Invoice_No" DESC
			LIMIT 1) as "inv"
		UNION
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
			FROM insurverse."Lead_coverage_premium"
			WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "Policy_Invoice_No" DESC
			LIMIT 1) as "inv"
		UNION
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No_act",6,5) AS INT),0) as "inv_no"
			FROM insurverse."Lead_coverage_premium"
			WHERE "Policy_Invoice_No_act" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "Policy_book_act"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "Policy_Invoice_No_act" DESC
			LIMIT 1) as "inv"
		UNION
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
			FROM insurverse."Policy_endorse_detail"
			WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
			' ORDER BY "Policy_Invoice_No" DESC
			LIMIT 1) as "inv"
		) as "h_inv"
		ORDER BY "inv_no" DESC
		LIMIT 1
		'
	INTO SYS_INVOICE_LAST;
	END IF;
	
	IF SYS_INVOICE_LAST IS NULL THEN
	 SYS_INVOICE_LAST = 90000;
	END IF;
	
	SYS_INVOICE_NO = SYS_INVOICE_NO || regexp_replace(TO_CHAR(SYS_INVOICE_LAST+1,'00000'), '[^\w]+','');
	
	RETURN SYS_INVOICE_NO;
END
$function$
