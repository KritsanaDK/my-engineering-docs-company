-- =============================================================================
-- Function: insurverse.fn_policy_comp_to_usage
-- OID: 18593
-- Identity Arguments: (in_car_act_no text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_comp_to_usage(in_car_act_no text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    sys_usage text;
    sys_car_comp_code text;
BEGIN
    /*
    SELECT "ipp"."Usage", "policy"."Car_Comp_Code"
    FROM insurverse."Policy_Car_Act_Discount_Premium" AS "policy"
    INNER JOIN insurverse."Imp_Price_Premium" AS "ipp"
        ON "policy"."Brand" = "ipp"."Brand"
        AND "policy"."Model" = "ipp"."Model"
        AND "policy"."Group" = "ipp"."Group"
    WHERE "policy"."Car_Act_No" = in_car_act_no
    LIMIT 1
    INTO sys_usage, sys_car_comp_code;
    */

    SELECT "policy"."Car_Comp_Code"
    INTO sys_car_comp_code
    FROM insurverse."Policy_Car_Act_Discount_Premium" AS "policy"
    WHERE "policy"."Car_Act_No" = in_car_act_no
    LIMIT 1;

    IF sys_car_comp_code = '1.10' THEN
        sys_usage := '110';
    ELSIF sys_car_comp_code = '1.20A' THEN
        sys_usage := '210';
    ELSIF sys_car_comp_code = '1.40A' THEN
        sys_usage := '320';
    ELSIF sys_car_comp_code = 'E11PA' THEN
        sys_usage := 'E11';
    ELSE
        sys_usage := NULL;
    END IF;

    RETURN sys_usage;
END;
$function$
