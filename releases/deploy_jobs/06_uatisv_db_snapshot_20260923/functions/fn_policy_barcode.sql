-- Source: UAT-ISV insurverse, exported 2026-09-23 (pg_get_functiondef)
-- Signature: fn_policy_barcode()
CREATE OR REPLACE FUNCTION insurverse.fn_policy_barcode()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_BARCODE_LAST INT; SYS_BARCODE_MOD INT; SYS_BARCODE TEXT;
PH_BARCODE_LAST INT; CA_BARCODE_LAST INT;
SYS_ENCODE_EAN TEXT;
BEGIN
  SYS_BARCODE = '46100' || TO_CHAR(now()+ INTERVAL '7 HOUR','y');
	
	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("Policy_Barcode",7,6) AS INT),0)
	FROM insurverse."Policy_Header"
	WHERE "Policy_Barcode" LIKE ''' || SYS_BARCODE || '%''' ||
	'ORDER BY "Policy_Barcode" DESC
	LIMIT 1'
	INTO PH_BARCODE_LAST;
	
	IF PH_BARCODE_LAST IS NULL THEN
	 PH_BARCODE_LAST = 0;
	END IF;
	
	EXECUTE
	'SELECT COALESCE(CAST(SUBSTR("Policy_Barcode",7,6) AS INT),0)
	FROM insurverse."Policy_Car_Act_Discount_Premium"
	WHERE "Policy_Barcode" LIKE ''' || SYS_BARCODE || '%''' ||
	'ORDER BY "Policy_Barcode" DESC
	LIMIT 1'
	INTO CA_BARCODE_LAST;
	
	IF CA_BARCODE_LAST IS NULL THEN
	 CA_BARCODE_LAST = 0;
	END IF;
	
	IF PH_BARCODE_LAST >= CA_BARCODE_LAST THEN
		SYS_BARCODE_LAST = PH_BARCODE_LAST;
	ELSE
		SYS_BARCODE_LAST = CA_BARCODE_LAST;
	END IF;
	
	SYS_BARCODE_MOD = MOD(SYS_BARCODE_LAST+1,8);
	SYS_BARCODE = CAST(SYS_BARCODE || regexp_replace(TO_CHAR(SYS_BARCODE_LAST+1,'000000'), '[^\w]+','') as BIGINT);
	
	with recursive source as (
    select CAST(SYS_BARCODE as bigint) as code
),
checksum_calc as (
    select code, 3 as cs_mult, 0::bigint as checksum, code as interm_code from source
    union
    select
        code,
        (case when cs_mult = 3 then 1 else 3 end) as cs_mult,
        interm_code % 10 * cs_mult as checksum,
        interm_code / 10 as interm_code
    from checksum_calc
    where interm_code > 0
)

select (code::text || ((10 - sum(checksum) % 10) % 10)::text)::bigint as code
from checksum_calc group by code
INTO SYS_ENCODE_EAN;
  
  RETURN SYS_ENCODE_EAN;
END
$function$

;
