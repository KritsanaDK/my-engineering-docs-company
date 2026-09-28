-- =============================================================================
-- Function: insurverse.fn_policy_renewal_ref
-- OID: 18772
-- Identity Arguments: (in_lead_no integer)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_ref(in_lead_no integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_JSON TEXT;
BEGIN
    WITH set_para AS (
        SELECT in_lead_no AS lead_no
    ),
    driver_info AS (
        SELECT
            "driver"."Policy_No",
            (d).*
        FROM insurverse."Policy_Header" AS "driver"
        INNER JOIN insurverse."Lead_coverage_premium" AS "lead"
            ON "lead"."ref_policy_no" = "driver"."Policy_No"
        CROSS JOIN LATERAL (
            VALUES
                (1, "driver"."Par_citizen_id_1", "driver"."Par_first_name_1", "driver"."Par_last_name_1", "driver"."Par_birth_date_1", "driver"."Par_prefix_name_1", "driver"."Par_occupation_1", "driver"."par_occupation_code_1", "driver"."Par_Driver_license_no_1", "driver"."par_driver_license_category_1"),
                (2, "driver"."Par_citizen_id_2", "driver"."Par_first_name_2", "driver"."Par_last_name_2", "driver"."Par_birth_date_2", "driver"."Par_prefix_name_2", "driver"."Par_occupation_2", "driver"."par_occupation_code_2", "driver"."Par_Driver_license_no_2", "driver"."par_driver_license_category_2"),
                (3, "driver"."par_citizen_id_3", "driver"."par_first_name_3", "driver"."par_last_name_3", "driver"."par_birth_date_3", "driver"."par_prefix_name_3", "driver"."par_occupation_3", "driver"."par_occupation_code_3", "driver"."par_driver_license_no_3", "driver"."par_driver_license_category_3"),
                (4, "driver"."par_citizen_id_4", "driver"."par_first_name_4", "driver"."par_last_name_4", "driver"."par_birth_date_4", "driver"."par_prefix_name_4", "driver"."par_occupation_4", "driver"."par_occupation_code_4", "driver"."par_driver_license_no_4", "driver"."par_driver_license_category_4"),
                (5, "driver"."par_citizen_id_5", "driver"."par_first_name_5", "driver"."par_last_name_5", "driver"."par_birth_date_5", "driver"."par_prefix_name_5", "driver"."par_occupation_5", "driver"."par_occupation_code_5", "driver"."par_driver_license_no_5", "driver"."par_driver_license_category_5")
        ) AS d("order_idx", "citizen_id", "first_name", "last_name", "birth_date", "prefix_label", "occupation", "occupation_code", "license_number", "license_category")
        WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para)
    ),
    unpivoted_lead_drivers AS (
        SELECT
            "lead"."Lead_No",
            "lead"."ref_policy_no",
            "lead"."cal_basic_renewal",
            ld.*
        FROM insurverse."Lead_coverage_premium" AS "lead"
        CROSS JOIN LATERAL (
            VALUES
                (1, "lead"."par_citizen_id_1", "lead"."par_first_name_1", "lead"."par_driver_license_no_1", "lead"."par_driver_license_category_1", "lead"."driver_behavior_1", "lead"."driver_behavior_consent_1", "lead"."YOB_Driver_1"),
                (2, "lead"."par_citizen_id_2", "lead"."par_first_name_2", "lead"."par_driver_license_no_2", "lead"."par_driver_license_category_2", "lead"."driver_behavior_2", "lead"."driver_behavior_consent_2", "lead"."YOB_Driver_2"),
                (3, "lead"."par_citizen_id_3", "lead"."par_first_name_3", "lead"."par_driver_license_no_3", "lead"."par_driver_license_category_3", "lead"."driver_behavior_3", "lead"."driver_behavior_consent_3", NULL::TEXT),
                (4, "lead"."par_citizen_id_4", "lead"."par_first_name_4", "lead"."par_driver_license_no_4", "lead"."par_driver_license_category_4", "lead"."driver_behavior_4", "lead"."driver_behavior_consent_4", NULL::TEXT),
                (5, "lead"."par_citizen_id_5", "lead"."par_first_name_5", "lead"."par_driver_license_no_5", "lead"."par_driver_license_category_5", "lead"."driver_behavior_5", "lead"."driver_behavior_consent_5", NULL::TEXT)
        ) AS ld("order_idx", "citizen_id", "first_name", "license_number", "license_category", "driver_behavior", "driver_behavior_consent", "yob_fallback")
        WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para)
          AND ld.citizen_id IS NOT NULL
          AND ld.citizen_id != ''
    ),
    aggregated_drivers AS (
        SELECT
            ul."Lead_No",
            COALESCE(json_agg(
                json_build_object(
                    'birth_date', CASE WHEN ul.cal_basic_renewal THEN od.birth_date ELSE NULL END,
                    'citizen_id', ul.citizen_id,
                    'first_name', CASE WHEN ul.cal_basic_renewal THEN od.first_name ELSE NULL END,
                    'last_name', CASE WHEN ul.cal_basic_renewal THEN od.last_name ELSE NULL END,
                    'license_number', COALESCE(NULLIF(ul.license_number, ''), NULLIF(od.license_number, '')),
                    'license_category', COALESCE(
                        NULLIF(ul.license_category, ''),
                        NULLIF(od.license_category, ''),
                        CASE
                            WHEN COALESCE(NULLIF(ul.license_number, ''), NULLIF(od.license_number, '')) IS NOT NULL THEN 'ใบขับขี่ส่วนบุคคล'
                        END
                    ),
                    'order', ul.order_idx,
                    'prefix_id', '',
                    'prefix_label', CASE WHEN ul.cal_basic_renewal THEN od.prefix_label ELSE NULL END,
                    'yob_driver', CASE WHEN ul.cal_basic_renewal THEN EXTRACT(YEAR FROM od.birth_date) ELSE NULL END,
                    'occupation', CASE WHEN ul.cal_basic_renewal THEN od.occupation ELSE NULL END,
                    'occupation_code', CASE WHEN ul.cal_basic_renewal THEN od.occupation_code ELSE NULL END,
                    'driver_behavior', ul.driver_behavior,
                    'driver_behavior_consent', ul.driver_behavior_consent
                ) ORDER BY ul.order_idx
            ), '[]'::json) AS drivers_json,
            COUNT(1) AS driver_count,
            COALESCE(BOOL_OR(ul.first_name IS NULL OR ul.first_name = ''), false) AS is_driver_edited
        FROM unpivoted_lead_drivers ul
        LEFT JOIN driver_info od
            ON ul.ref_policy_no = od."Policy_No"
           AND ul.citizen_id = od.citizen_id
        GROUP BY ul."Lead_No"
    )
    SELECT json_build_object(
        'car', json_build_object(
            'ref_policy_no', "policy"."Policy_No",
            'policy_no', "new_policy"."Policy_No",
            'car_brand', "lead"."Brand",
            'car_model', "lead"."Model",
            'car_year', "lead"."Year",
            'act', (UPPER("lead"."Flag_Car_Act") = 'Y'),
            'address_no', "policy"."Deli_Addr_line1",
            'address_same_card_id', false,
            'cc', "policy"."CC",
            'color', "policy"."Car_color",
            'district_id', "policy"."Deli_district_id",
            'district_label', (SELECT d.diname FROM insurverse."district" d WHERE d."districtid" = "policy"."Deli_district_id"),
            'effective_date_coverage_end', TO_CHAR(COALESCE("lead"."renewal_mv_enddate", "policy"."Policy_Enddate" + INTERVAL '1 YEAR') + INTERVAL '7 HOUR', 'yyyy-mm-dd'),
            'effective_date_coverage_start', TO_CHAR(COALESCE("lead"."renewal_mv_startdate", "policy"."Policy_Enddate") + INTERVAL '7 HOUR', 'yyyy-mm-dd'),
            'effective_date_rd_end', CASE WHEN "lead"."renewal_mc_enddate" IS NOT NULL THEN TO_CHAR("lead"."renewal_mc_enddate" + INTERVAL '7 HOUR', 'yyyy-mm-dd') ELSE '' END,
            'effective_date_rd_start', CASE WHEN "lead"."renewal_mc_startdate" IS NOT NULL THEN TO_CHAR("lead"."renewal_mc_startdate" + INTERVAL '7 HOUR', 'yyyy-mm-dd') ELSE '' END,
            'lead_no', "lead"."Lead_No"::TEXT,
            'province_id', "policy"."Deli_province_id",
            'province_label', (SELECT p.prname FROM insurverse."province" p WHERE p."provinceid" = "policy"."Deli_province_id"),
            'receive_document', CASE WHEN "lead"."Flex_field1" IN ('post', 'email') THEN "lead"."Flex_field1" WHEN UPPER("policy"."Flag_Deli") = 'Y' THEN 'post' ELSE 'email' END,
            'size', "policy"."CC",
            'subdistrict_id', "policy"."Deli_subdistrict_id",
            'subdistrict_label', (SELECT sd.sdname FROM insurverse."subdistrict" sd WHERE sd."subdistrictid" = "policy"."Deli_subdistrict_id"),
            'vehicle_registration_number', "policy"."Car_license_no",
            'vehicle_registration_plate_color', "policy"."Car_license_type",
            'vehicle_registration_province_id', "policy"."Car_license_provice"::TEXT,
            'vehicle_registration_province_label', (SELECT p.prname FROM insurverse."province" p WHERE p."provinceid" = "policy"."Car_license_provice"),
            'vin', "policy"."Car_serial_no",
            'zipcode', "policy"."Deli_zipcode",
            'is_new_car_inspect', CASE WHEN "lead"."Type" = '1' AND "policy"."Type" != '1' THEN true ELSE false END,
            'is_access_inspect', CASE WHEN COALESCE("lead"."Flag_CCTV",'N') = 'Y' AND COALESCE("prem"."Flag_CCTV",'N') != 'Y' THEN true WHEN COALESCE("lead"."Flag_Access",'N') = 'Y' AND COALESCE("prem"."Flag_Access",'N') != 'Y' THEN true WHEN COALESCE("lead"."Flag_Access",'N') = 'Y' AND COALESCE("prem"."Flag_Access",'N') = 'Y' AND (SELECT ARRAY_AGG(x ORDER BY x) FROM jsonb_array_elements_text(COALESCE(NULLIF("lead"."Access_para_code", '')::jsonb, '[]'::jsonb)) x) != (SELECT ARRAY_AGG(y ORDER BY y) FROM jsonb_array_elements_text(COALESCE(NULLIF("prem"."Access_para_code", '')::jsonb, '[]'::jsonb)) y) THEN true ELSE false END
        ),
        'person', json_build_object(
            'lead_no', "lead"."Lead_No"::TEXT,
            'address_no', "policy"."Owner_address",
            'birth_date', "policy"."Owner_birth_date",
            'citizen_id', "policy"."Owner_citizen_id",
            'district_id', "policy"."Owner_district_id",
            'district_label', (SELECT d.diname FROM insurverse."district" d WHERE d."districtid" = "policy"."Owner_district_id"),
            'driver_count', COALESCE("ad"."driver_count", 0),
            'driver_yob_1', "lead"."YOB_Driver_1",
            'driver_yob_2', "lead"."YOB_Driver_2",
            'is_driver_edited', COALESCE("ad"."is_driver_edited", false),
            'drivers', COALESCE("ad"."drivers_json", '[]'::json),
            'financial_name', CASE WHEN "policy"."Bene_Firstname" IS NOT NULL AND "policy"."Bene_Firstname" <> '' AND "policy"."Bene_Type" <> 'person' THEN "policy"."Bene_Firstname" ELSE '' END,
            'first_name', "policy"."Owner_first_name",
            'last_name', "policy"."Owner_last_name",
            'prefix_id', '',
            'prefix_label', "policy"."Owner_prefix_name",
            'province_id', "policy"."Owner_province_id",
            'province_label', (SELECT p.prname FROM insurverse."province" p WHERE p."provinceid" = "policy"."Owner_province_id"),
            'subdistrict_id', "policy"."Owner_subdistrict_id",
            'subdistrict_label', (SELECT sd.sdname FROM insurverse."subdistrict" sd WHERE sd."subdistrictid" = "policy"."Owner_subdistrict_id"),
            'zipcode', "policy"."Owner_zipcode",
            'old_policy_type', "policy"."Type",
            'lead_policy_type', "lead"."Type",
            'occupation', "policy"."Owner_occupation"
        )
    )
    FROM set_para
    INNER JOIN insurverse."Lead_coverage_premium" AS "lead"
        ON set_para."lead_no" = "lead"."Lead_No"
        -- AND UPPER("lead"."Payment_status") = 'SUCCESS'
    INNER JOIN insurverse."Policy_Header" AS "policy"
        ON "lead"."ref_policy_no" = "policy"."Policy_No"
    INNER JOIN insurverse."Policy_coverage_premium" AS "prem"
        ON "policy"."Policy_No" = "prem"."Policy_No"
    LEFT JOIN aggregated_drivers AS "ad"
        ON "lead"."Lead_No" = "ad"."Lead_No"
    LEFT JOIN insurverse."Policy_Header" AS "new_policy"
        ON "lead"."ref_policy_no" = "new_policy"."ref_policy_no"
    WHERE "new_policy"."Car_Inspect_Status" IS NULL
       OR "new_policy"."Car_Inspect_Status" = 'access_modify'
    INTO RTN_JSON;

    RETURN RTN_JSON;
END
$function$
