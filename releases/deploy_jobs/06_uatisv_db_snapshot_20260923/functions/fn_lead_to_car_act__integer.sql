-- Source: UAT-ISV insurverse, exported 2026-09-23 (pg_get_functiondef)
-- Signature: fn_lead_to_car_act(lead_no integer)
CREATE OR REPLACE FUNCTION insurverse.fn_lead_to_car_act(lead_no integer)
 RETURNS TABLE(car_act_no text, rtn_lead_no integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY
	SELECT f.car_act_no, f.rtn_lead_no::integer
	FROM   insurverse.fn_lead_to_car_act(lead_no::bigint) f;
END;
$function$

;
