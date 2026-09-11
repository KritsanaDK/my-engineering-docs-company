CREATE OR REPLACE FUNCTION insurverse.fn_move_driver_fields(from_idx integer, to_idx integer, policy_no text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    col_map jsonb := '{
        "Par_first_name": {
            "1": "Par_first_name_1", "2": "Par_first_name_2", 
            "3": "par_first_name_3", "4": "par_first_name_4", "5": "par_first_name_5"
        },
        "Par_last_name": {
            "1": "Par_last_name_1", "2": "Par_last_name_2", 
            "3": "par_last_name_3", "4": "par_last_name_4", "5": "par_last_name_5"
        },
        "Par_birth_date": {
            "1": "Par_birth_date_1", "2": "Par_birth_date_2", 
            "3": "par_birth_date_3", "4": "par_birth_date_4", "5": "par_birth_date_5"
        },
        "Par_occupation": {
            "1": "Par_occupation_1", "2": "Par_occupation_2", 
            "3": "par_occupation_3", "4": "par_occupation_4", "5": "par_occupation_5"
        },
        "Par_prefix_name": {
            "1": "Par_prefix_name_1", "2": "Par_prefix_name_2", 
            "3": "par_prefix_name_3", "4": "par_prefix_name_4", "5": "par_prefix_name_5"
        },
        "Par_Driver_license_no": {
            "1": "Par_Driver_license_no_1", "2": "Par_Driver_license_no_2", 
            "3": "par_driver_license_no_3", "4": "par_driver_license_no_4", "5": "par_driver_license_no_5"
        },
        "Par_Driver_license_category": {
            "1": "par_driver_license_category_1", "2": "par_driver_license_category_2",
            "3": "par_driver_license_category_3", "4": "par_driver_license_category_4", "5": "par_driver_license_category_5"
        },
        "Par_citizen_id": {
            "1": "Par_citizen_id_1", "2": "Par_citizen_id_2", 
            "3": "par_citizen_id_3", "4": "par_citizen_id_4", "5": "par_citizen_id_5"
        },
        "driver_behavior": {
            "1": "driver_behavior_1", "2": "driver_behavior_2", 
            "3": "driver_behavior_3", "4": "driver_behavior_4", "5": "driver_behavior_5"
        },
        "driver_behavior_consent": {
            "1": "driver_behavior_consent_1", "2": "driver_behavior_consent_2", 
            "3": "driver_behavior_consent_3", "4": "driver_behavior_consent_4", "5": "driver_behavior_consent_5"
        },
        "YOB_Driver": {
            "1": "YOB_Driver_1", "2": "YOB_Driver_2"
        },
        "par_birth_date": {
            "1": "par_birth_date_1", "2": "par_birth_date_2", 
            "3": "par_birth_date_3", "4": "par_birth_date_4", "5": "par_birth_date_5"
        }
    }'::jsonb;

    field text;
    col_from text;
    col_to text;
BEGIN
    ------------------------------------------
    -- MOVE (Policy_Header)
    ------------------------------------------
    FOR field IN
        SELECT key
        FROM jsonb_object_keys(col_map) AS t(key)
        WHERE key NOT IN ('YOB_Driver', 'par_birth_date', 'driver_behavior', 'driver_behavior_consent')
    LOOP
        col_from := col_map -> field ->> from_idx::text;
        col_to   := col_map -> field ->> to_idx::text;

        IF col_from IS NOT NULL AND col_to IS NOT NULL THEN
            EXECUTE format(
                'UPDATE insurverse."Policy_Header" SET %I = %I WHERE "Policy_No" = $1',
                col_to, col_from
            ) USING policy_no;
        END IF;
    END LOOP;

    ------------------------------------------
    -- CLEAR OLD (Policy_Header)
    ------------------------------------------
    FOR field IN
        SELECT key
        FROM jsonb_object_keys(col_map) AS t(key)
        WHERE key NOT IN ('YOB_Driver','par_birth_date','driver_behavior','driver_behavior_consent')
    LOOP
        col_from := col_map -> field ->> from_idx::text;

        IF col_from IS NOT NULL THEN
            EXECUTE format(
                'UPDATE insurverse."Policy_Header" SET %I = NULL WHERE "Policy_No" = $1',
                col_from
            ) USING policy_no;
        END IF;
    END LOOP;


    ------------------------------------------
    -- MOVE (Policy_coverage_premium)
    ------------------------------------------
    FOR field IN
        SELECT key
        FROM jsonb_object_keys(col_map) AS t(key)
        WHERE key IN ('YOB_Driver','par_birth_date','driver_behavior','driver_behavior_consent')
    LOOP
        col_from := col_map -> field ->> from_idx::text;
        col_to   := col_map -> field ->> to_idx::text;

        IF col_from IS NOT NULL AND col_to IS NOT NULL THEN
            EXECUTE format(
                'UPDATE insurverse."Policy_coverage_premium" SET %I = %I WHERE "Policy_No" = $1',
                col_to, col_from
            ) USING policy_no;
        END IF;
    END LOOP;

    ------------------------------------------
    -- CLEAR OLD (Policy_coverage_premium)
    ------------------------------------------
    FOR field IN
        SELECT key
        FROM jsonb_object_keys(col_map) AS t(key)
        WHERE key IN ('YOB_Driver','par_birth_date','driver_behavior','driver_behavior_consent')
    LOOP
        col_from := col_map -> field ->> from_idx::text;

        IF col_from IS NOT NULL THEN
            EXECUTE format(
                'UPDATE insurverse."Policy_coverage_premium" SET %I = NULL WHERE "Policy_No" = $1',
                col_from
            ) USING policy_no;
        END IF;
    END LOOP;
END;
$function$
;
