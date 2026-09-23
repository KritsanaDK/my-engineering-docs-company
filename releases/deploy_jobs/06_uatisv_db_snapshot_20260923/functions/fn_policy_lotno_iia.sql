-- Source: UAT-ISV insurverse, exported 2026-09-23 (pg_get_functiondef)
-- Signature: fn_policy_lotno_iia()
CREATE OR REPLACE FUNCTION insurverse.fn_policy_lotno_iia()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_LOT_NO TEXT; SYS_LOT_LAST INT;
PH_LOT_NO TEXT; PH_LOT_LAST INT;
CA_LOT_LAST INT;
BEGIN
  PERFORM pg_advisory_xact_lock(hashtext('fn_policy_lotno_iia'));

	SYS_LOT_NO = TO_CHAR(now()+ INTERVAL '7 HOUR','ddmmyyyy');

	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("IIA_Lot_No",9,6) AS INT),0)
	FROM insurverse."Policy_Header"
	WHERE "IIA_Lot_No" LIKE ''' || SYS_LOT_NO || '%''' ||
	'ORDER BY "IIA_Lot_No" DESC
	LIMIT 1'
	INTO PH_LOT_LAST;

	IF PH_LOT_LAST IS NULL THEN
	 PH_LOT_LAST = 0;
	END IF;

	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("IIA_Lot_No",9,6) AS INT),0)
	FROM insurverse."Policy_Car_Act_Discount_Premium"
	WHERE "IIA_Lot_No" LIKE ''' || SYS_LOT_NO || '%''' ||
	'ORDER BY "IIA_Lot_No" DESC
	LIMIT 1'
	INTO CA_LOT_LAST;

	IF CA_LOT_LAST IS NULL THEN
	 CA_LOT_LAST = 0;
	END IF;

	IF PH_LOT_LAST >= CA_LOT_LAST THEN
		SYS_LOT_LAST = PH_LOT_LAST;
	ELSE
		SYS_LOT_LAST = CA_LOT_LAST;
	END IF;

	SYS_LOT_NO = SYS_LOT_NO || regexp_replace(TO_CHAR(SYS_LOT_LAST+1,'000000'), '[^\w]+','');

	RETURN SYS_LOT_NO;
END
$function$

;
