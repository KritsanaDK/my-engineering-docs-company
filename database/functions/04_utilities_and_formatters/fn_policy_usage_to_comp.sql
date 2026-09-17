-- =============================================================================
-- Function: insurverse.fn_policy_usage_to_comp
-- OID: 18848
-- Identity Arguments: (in_policy_no text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_usage_to_comp(in_policy_no text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    sys_comp_code text;
    sys_usage text;
BEGIN
    /*
    SELECT "idp"."Comp_Code"
    FROM insurverse."Policy_Header" AS "policy"
    INNER JOIN insurverse."Imp_Discount_Premium" AS "idp"
        ON "policy"."Brand" = "idp"."Brand"
        AND "policy"."Model" = "idp"."Model"
        AND "policy"."Seat" = "idp"."Seat"
        AND "policy"."Group" = "idp"."Group"
    WHERE "policy"."Policy_No" = in_policy_no
    LIMIT 1
    INTO sys_comp_code;
    */

    SELECT "policy"."Usage"
    INTO sys_usage
    FROM insurverse."Policy_Header" AS "policy"
    WHERE "policy"."Policy_No" = in_policy_no
    LIMIT 1;

    IF sys_usage = '110' THEN
        sys_comp_code := '1.10';
    ELSIF sys_usage = '210' THEN
        sys_comp_code := '1.20A';
    ELSIF sys_usage = '320' THEN
        sys_comp_code := '1.40A';
    ELSIF sys_usage = 'E11PA' THEN
        sys_comp_code := 'E11PA';
    END IF;

    RETURN sys_comp_code;
END;
$function$
