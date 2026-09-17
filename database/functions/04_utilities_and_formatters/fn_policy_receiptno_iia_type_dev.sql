-- =============================================================================
-- Function: insurverse.fn_policy_receiptno_iia_type_dev
-- OID: 18707
-- Identity Arguments: (group_type text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_receiptno_iia_type_dev(group_type text)
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
	SYS_INVOICE_NO = '3-4-00-' || TO_CHAR(now()+ INTERVAL '7 HOUR', 'yymm');
	
  IF LOWER(group_type) = 'pa' THEN
		EXECUTE
		'SELECT "inv_no"
		FROM (
		SELECT "inv_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_receipt_no",12,5) AS INT),0) as "inv_no"
			FROM insurverse."policy_pa_premium"
			WHERE "policy_receipt_no" LIKE ''' || SYS_INVOICE_NO || '%''' ||
			' ORDER BY "policy_receipt_no" DESC
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
