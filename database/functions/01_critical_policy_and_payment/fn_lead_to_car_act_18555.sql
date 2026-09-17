-- =============================================================================
-- Function: insurverse.fn_lead_to_car_act
-- OID: 18555
-- Identity Arguments: (lead_no integer)
-- Returns: TABLE(car_act_no text, rtn_lead_no integer)
-- Language: plpgsql
-- Categorization: 01_critical_policy_and_payment
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

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
