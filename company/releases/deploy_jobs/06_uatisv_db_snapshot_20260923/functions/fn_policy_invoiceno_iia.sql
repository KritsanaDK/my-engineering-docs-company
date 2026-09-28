-- Source: UAT-ISV insurverse, exported 2026-09-23 (pg_get_functiondef)
-- Signature: fn_policy_invoiceno_iia()
CREATE OR REPLACE FUNCTION insurverse.fn_policy_invoiceno_iia()
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
	PERFORM pg_advisory_xact_lock(hashtext('fn_policy_invoiceno_iia'));

	SYS_INVOICE_NO = TO_CHAR(now()+ INTERVAL '7 HOUR', 'yymm/');
	SYS_BOOK_NO = insurverse.fn_policy_book_iia();

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

	IF SYS_INVOICE_LAST IS NULL THEN
	 SYS_INVOICE_LAST = 0;
	END IF;

	SYS_INVOICE_NO = SYS_INVOICE_NO || regexp_replace(TO_CHAR(SYS_INVOICE_LAST+1,'00000'), '[^\w]+','');

	RETURN SYS_INVOICE_NO;
END
$function$

;
