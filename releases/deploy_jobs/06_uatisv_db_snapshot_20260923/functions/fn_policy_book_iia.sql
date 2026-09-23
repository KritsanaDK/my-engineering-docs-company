-- Source: UAT-ISV insurverse, exported 2026-09-23 (pg_get_functiondef)
-- Signature: fn_policy_book_iia()
CREATE OR REPLACE FUNCTION insurverse.fn_policy_book_iia()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	SYS_POLICY_BOOK TEXT;
BEGIN
  SYS_POLICY_BOOK = '12-1-00';
	RETURN SYS_POLICY_BOOK;
END
$function$

;
