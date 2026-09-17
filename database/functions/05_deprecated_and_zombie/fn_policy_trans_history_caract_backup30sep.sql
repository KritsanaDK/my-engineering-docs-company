-- =============================================================================
-- Function: insurverse.fn_policy_trans_history_caract_backup30sep
-- OID: 28470
-- Identity Arguments: (car_act_no text)
-- Returns: TABLE(rtn_car_act_no text, trans_id text)
-- Language: plpgsql
-- Categorization: 05_deprecated_and_zombie
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_trans_history_caract_backup30sep(car_act_no text)
 RETURNS TABLE(rtn_car_act_no text, trans_id text)
 LANGUAGE plpgsql
AS $function$
begin
    -- missing source code
end;
$function$
