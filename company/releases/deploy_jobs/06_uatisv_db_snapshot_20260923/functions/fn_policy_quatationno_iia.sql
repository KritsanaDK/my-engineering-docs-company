-- Source: UAT-ISV insurverse, exported 2026-09-23 (pg_get_functiondef)
-- Signature: fn_policy_quatationno_iia()
CREATE OR REPLACE FUNCTION insurverse.fn_policy_quatationno_iia()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	SYS_QUATATION_NO TEXT;
  PH_QUATATION_LAST INT;
	CA_QUATATION_LAST INT;
	SYS_QUATATION_LAST INT;
	SYS_QUATATION_MOD INT;
BEGIN
	-- same pattern as fn_policy_invoiceno_iia, which already serialises this way
	PERFORM pg_advisory_xact_lock(hashtext('fn_policy_quatationno_iia'));

  SYS_QUATATION_NO = '001-00-' || TO_CHAR(now()+ INTERVAL '7 HOUR', 'yy') || '-';
	EXECUTE
	'SELECT "qua_no"
FROM (
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Policy_Header"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_NO || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Policy_Car_Act_Discount_Premium"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_NO || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Lead_coverage_premium"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_NO || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No_act",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Lead_coverage_premium"
	WHERE "Policy_Quatation_No_act" LIKE ''' || SYS_QUATATION_NO || '%''' ||
	'	ORDER BY "Policy_Quatation_No_act" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Policy_endorse_detail"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_NO || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_quotation_no",11,7) AS INT),0) as "qua_no"
			FROM insurverse."policy_ta_premium"
			WHERE "policy_quotation_no" LIKE ''' || SYS_QUATATION_NO || '%''' ||
			' ORDER BY "policy_quotation_no" DESC
			LIMIT 1) as "qua"
UNION
SELECT "qua_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_quotation_no",11,7) AS INT),0) as "qua_no"
			FROM insurverse."policy_pa_premium"
			WHERE "policy_quotation_no" LIKE ''' || SYS_QUATATION_NO || '%''' ||
			' ORDER BY "policy_quotation_no" DESC
			LIMIT 1) as "qua"
UNION
SELECT "qua_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_quotation_no",11,7) AS INT),0) as "qua_no"
			FROM insurverse."policy_home_premium"
			WHERE "policy_quotation_no" LIKE ''' || SYS_QUATATION_NO || '%''' ||
			' ORDER BY "policy_quotation_no" DESC
			LIMIT 1) as "qua"
) as "h_qua"
ORDER BY "qua_no" DESC
LIMIT 1
'
	INTO SYS_QUATATION_LAST;
	
	IF SYS_QUATATION_LAST IS NULL THEN
	 SYS_QUATATION_LAST = 0;
	END IF;
	
	SYS_QUATATION_MOD = MOD(SYS_QUATATION_LAST+1,8);
	SYS_QUATATION_NO = SYS_QUATATION_NO || regexp_replace(TO_CHAR(SYS_QUATATION_LAST+1,'0000000'), '[^\w]+','') || SYS_QUATATION_MOD;
	
	RETURN SYS_QUATATION_NO;
END
$function$

;
