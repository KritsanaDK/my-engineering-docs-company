-- =============================================================================
-- Function: insurverse.fn_policy_my_policy_prod
-- OID: 18646
-- Identity Arguments: (in_email text)
-- Returns: TABLE("Brand" character varying, "Model" character varying, "Year" character varying, "Car_license_no" text, "Type" character varying, "SI" integer, "Owner_first_name" text, "Owner_first_name_en" text, "Owner_last_name" text, "Owner_last_name_en" text, "Policy_No" text, "Policy_Ta_No" text, "Car_Act_No" text, "Policy_Startdate" text, "Policy_Startdate_en" text, "Policy_Enddate" text, "Policy_Enddate_en" text, policy_startdate_sort timestamp without time zone, "Car_license_provice" text, "Policy_url_copy_ref" text, "Receipt_url_copy_ref" text, policy_date text, policy_date_en text, "Car_Inspect_Status" text, "Lead_No" integer, "Car_Act_Lead_No" integer, priority integer, policy_status text, payment_date text, car_serial_no text, car_license_type text, car_color text, car_cc text, car_seat integer, car_weight integer, owner_citizen_id text, "Owner_birth_date" text, "Owner_birth_date_en" text, owner_prefix_name text, owner_prefix_name_en text, owner_address text, owner_address_en text, owner_subdistrict text, owner_subdistrict_en text, owner_district text, owner_district_en text, owner_province text, owner_province_en text, owner_zipcode text, user_email text, user_mobile text, par_1_prefix_name text, par_1_first_name text, par_1_last_name text, par_1_birth_date text, par_1_driver_license text, par_1_citizen text, par_2_prefix_name text, par_2_first_name text, par_2_last_name text, par_2_birth_date text, par_2_driver_license text, par_2_citizen text, bene_type text, bene_first_name text, bene_last_name text, bene_ta_detail text, deli_addr_1 text, deli_subdistrict text, deli_district text, deli_province text, deli_zipcode text, garage_type character varying, si_limit numeric, si_access_limit numeric, si_tppd_limit numeric, si_tpbi_limit numeric, si_mv01_limit numeric, si_mv02_limit numeric, si_mv03_limit numeric, car_comp_code character varying, coverinjury integer, coverdeath integer, coveracc integer, "Access_para_code" character varying, endorsement_list text, package_name text, ta_coverage_list text, ta_country_name_th text, ta_country_name_en text, owner_card_type text, owner_email text, owner_mobile text, deli_flag text, "Policy_Pa_No" text, bene_pa_detail text, bene_title text, pa_coverage_list text, policy_directory text, tax_deductions_url_ref text, endorse_last_status text, tax_deductions boolean, owner_subdistrict_id integer, owner_district_id integer, owner_province_id integer, deli_subdistrict_id integer, deli_district_id integer, deli_province_id integer, tax_deductions_date_th text, tax_deductions_date_en text, "Policy_Home_No" text, home_coverage text, bene_home_detail text, "Policy_url_ref" text, "Receipt_url_ref" text, tax_deductions_url_copy_ref text, claim_status_flag boolean, motor_detail text, renewal_detail text, ta_package_list text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_my_policy_prod(in_email text)
 RETURNS TABLE("Brand" character varying, "Model" character varying, "Year" character varying, "Car_license_no" text, "Type" character varying, "SI" integer, "Owner_first_name" text, "Owner_first_name_en" text, "Owner_last_name" text, "Owner_last_name_en" text, "Policy_No" text, "Policy_Ta_No" text, "Car_Act_No" text, "Policy_Startdate" text, "Policy_Startdate_en" text, "Policy_Enddate" text, "Policy_Enddate_en" text, policy_startdate_sort timestamp without time zone, "Car_license_provice" text, "Policy_url_copy_ref" text, "Receipt_url_copy_ref" text, policy_date text, policy_date_en text, "Car_Inspect_Status" text, "Lead_No" integer, "Car_Act_Lead_No" integer, priority integer, policy_status text, payment_date text, car_serial_no text, car_license_type text, car_color text, car_cc text, car_seat integer, car_weight integer, owner_citizen_id text, "Owner_birth_date" text, "Owner_birth_date_en" text, owner_prefix_name text, owner_prefix_name_en text, owner_address text, owner_address_en text, owner_subdistrict text, owner_subdistrict_en text, owner_district text, owner_district_en text, owner_province text, owner_province_en text, owner_zipcode text, user_email text, user_mobile text, par_1_prefix_name text, par_1_first_name text, par_1_last_name text, par_1_birth_date text, par_1_driver_license text, par_1_citizen text, par_2_prefix_name text, par_2_first_name text, par_2_last_name text, par_2_birth_date text, par_2_driver_license text, par_2_citizen text, bene_type text, bene_first_name text, bene_last_name text, bene_ta_detail text, deli_addr_1 text, deli_subdistrict text, deli_district text, deli_province text, deli_zipcode text, garage_type character varying, si_limit numeric, si_access_limit numeric, si_tppd_limit numeric, si_tpbi_limit numeric, si_mv01_limit numeric, si_mv02_limit numeric, si_mv03_limit numeric, car_comp_code character varying, coverinjury integer, coverdeath integer, coveracc integer, "Access_para_code" character varying, endorsement_list text, package_name text, ta_coverage_list text, ta_country_name_th text, ta_country_name_en text, owner_card_type text, owner_email text, owner_mobile text, deli_flag text, "Policy_Pa_No" text, bene_pa_detail text, bene_title text, pa_coverage_list text, policy_directory text, tax_deductions_url_ref text, endorse_last_status text, tax_deductions boolean, owner_subdistrict_id integer, owner_district_id integer, owner_province_id integer, deli_subdistrict_id integer, deli_district_id integer, deli_province_id integer, tax_deductions_date_th text, tax_deductions_date_en text, "Policy_Home_No" text, home_coverage text, bene_home_detail text, "Policy_url_ref" text, "Receipt_url_ref" text, tax_deductions_url_copy_ref text, claim_status_flag boolean, motor_detail text, renewal_detail text, ta_package_list text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    return Query
        WITH set_para as (SELECT "in_email" as "email")
        SELECT "my_policy"."Brand" varchar,
               "my_policy"."Model" varchar,
               "my_policy"."Year" varchar,
               "my_policy"."Car_license_no" text,
               "my_policy"."Type" varchar,
               "my_policy"."SI" integer,
               "my_policy"."Owner_first_name" text,
               "my_policy"."Owner_first_name_en" text,
               "my_policy"."Owner_last_name" text,
               "my_policy"."Owner_last_name_en" text,
               "my_policy"."Policy_No" text,
               "my_policy"."Policy_Ta_No" text,
               "my_policy"."Car_Act_No" text,
               "my_policy"."Policy_Startdate" text,
               "my_policy"."Policy_Startdate_en" text,
               "my_policy"."Policy_Enddate" text,
               "my_policy"."Policy_Enddate_en" text,
               "my_policy"."policy_startdate_sort" timestamp,
               "my_policy"."Car_license_provice" text,
               "my_policy"."Policy_url_copy_ref" text,
               "my_policy"."Receipt_url_copy_ref" text,
               "my_policy"."policy_date" text,
               "my_policy"."policy_date_en" text,
               "my_policy"."Car_Inspect_Status" text,
               "my_policy"."Lead_No" integer,
               "my_policy"."Car_Act_Lead_No" integer,
               "my_policy"."priority" integer,
               "my_policy"."policy_status" text,
               "my_policy"."payment_date" text,
               "my_policy"."car_serial_no" text,
               "my_policy"."car_license_type" text,
               "my_policy"."car_color" text,
               "my_policy"."car_cc" text,
               "my_policy"."car_seat" integer,
               "my_policy"."car_weight" integer,
               "my_policy"."owner_citizen_id" text,
               "my_policy"."Owner_birth_date" text,
               "my_policy"."Owner_birth_date_en" text,
               "my_policy"."owner_prefix_name" text,
               "my_policy"."owner_prefix_name_en" text,
               "my_policy"."owner_address" text,
               "my_policy"."owner_address_en" text,
               "my_policy"."owner_subdistrict" text,
               "my_policy"."owner_subdistrict_en" text,
               "my_policy"."owner_district" text,
               "my_policy"."owner_district_en" text,
               "my_policy"."owner_province" text,
               "my_policy"."owner_province_en" text,
               "my_policy"."owner_zipcode" text,
               "my_policy"."user_email" text,
               "my_policy"."user_mobile" text,
               "my_policy"."par_1_prefix_name" text,
               "my_policy"."par_1_first_name" text,
               "my_policy"."par_1_last_name" text,
               "my_policy"."par_1_birth_date" text,
               "my_policy"."par_1_driver_license" text,
               "my_policy"."par_1_citizen" text,
               "my_policy"."par_2_prefix_name" text,
               "my_policy"."par_2_first_name" text,
               "my_policy"."par_2_last_name" text,
               "my_policy"."par_2_birth_date" text,
               "my_policy"."par_2_driver_license" text,
               "my_policy"."par_2_citizen" text,
               "my_policy"."bene_type" text,
               "my_policy"."bene_first_name" text,
               "my_policy"."bene_last_name" text,
               "my_policy"."bene_ta_detail" text,
               "my_policy"."deli_addr_1" text,
               "my_policy"."deli_subdistrict" text,
               "my_policy"."deli_district" text,
               "my_policy"."deli_province" text,
               "my_policy"."deli_zipcode" text,
               "my_policy"."garage_type" varchar,
               "my_policy"."si_limit" numeric,
               "my_policy"."si_access_limit" numeric,
               "my_policy"."si_tppd_limit" numeric,
               "my_policy"."si_tpbi_limit" numeric,
               "my_policy"."si_mv01_limit" numeric,
               "my_policy"."si_mv02_limit" numeric,
               "my_policy"."si_mv03_limit" numeric,
               "my_policy"."car_comp_code" varchar,
               "my_policy"."coverinjury" integer,
               "my_policy"."coverdeath" integer,
               "my_policy"."coveracc" integer,
               "my_policy"."Access_para_code" varchar,
               "my_policy"."endorsement_list" text,
               "my_policy"."package_name" text,
               "my_policy"."ta_coverage_list" text,
               "my_policy"."ta_country_name_th" text,
               "my_policy"."ta_country_name_en" text,
               "my_policy"."owner_card_type" text,
               "my_policy"."owner_email" text,
               "my_policy"."owner_mobile" text,
               "my_policy"."deli_flag" text,
               "my_policy"."Policy_Pa_No" text,
               "my_policy"."bene_pa_detail" text,
               "my_policy"."bene_title" text,
               "my_policy"."pa_coverage_list" text,
               "my_policy"."policy_directory" text,
               "my_policy"."tax_deductions_url_ref" text,
               "my_policy"."endorse_last_status" text,
               "my_policy"."tax_deductions" boolean,
               "my_policy"."owner_subdistrict_id" integer,
               "my_policy"."owner_district_id" integer,
               "my_policy"."owner_province_id" integer,
               "my_policy"."deli_subdistrict_id" integer,
               "my_policy"."deli_district_id" integer,
               "my_policy"."deli_province_id" integer,
               "my_policy"."tax_deductions_date_th" text,
               "my_policy"."tax_deductions_date_en" text,
               "my_policy"."Policy_Home_No" text,
               "my_policy"."home_coverage" text,
               "my_policy"."bene_home_detail" text,
               "my_policy"."Policy_url_ref" text,
               "my_policy"."Receipt_url_ref" text,
               "my_policy"."tax_deductions_url_copy_ref" text,
               "my_policy"."claim_status_flag" bool,
               "my_policy"."motor_detail" text,
               "my_policy"."renewal_detail" text,
               "my_policy"."ta_package_list" text
        FROM (
-- Lead_coverage_premium
                 SELECT "lead"."Brand","lead"."Model", "lead"."Year", CAST("policy"."Car_license_no" as TEXT) as "Car_license_no",
                        "lead"."Type",CAST(COALESCE("lead"."SI_Limit", 0 ) + COALESCE("lead"."SI_Access_Limit", 0 ) as INT) as "SI",
                        CAST("policy"."Owner_first_name" as TEXT) as "Owner_first_name", CAST("policy"."Owner_last_name" as TEXT) as "Owner_last_name",
                        null as "Policy_No",
                        null as "Car_Act_No",
                        null as "Policy_Startdate",
                        null as "Policy_Enddate",
                        CAST((select "prname" from insurverse."province" where "provinceid"="policy"."Car_license_provice") as TEXT) as "Car_license_provice",
                        null as "Policy_url_copy_ref",
                        null as "Receipt_url_copy_ref",
                        null as "policy_date",
                        cast("lead"."Lead_No" as integer),
                        null as "Car_Act_Lead_No",
                        null as "Car_Inspect_Status",
                        1 as "priority",
                        'ACT' as "policy_status",
                        insurverse.fn_display_buddha_date("Payment_Date") as "payment_date",
                        NULL as "car_serial_no",
                        CAST("policy"."Car_license_type" as TEXT) as "car_license_type",
                        NULL as "car_color",
                        CAST(NULL as INT) as "car_seat",
                        CAST(NULL as INT) as "car_weight",
                        NULL as "car_cc",
                        null as "owner_citizen_id",
                        null as "Owner_birth_date",
                        null as "owner_prefix_name",
                        null as "owner_address",
                        null as "owner_subdistrict",
                        null as "owner_district",
                        null as "owner_province",
                        0 as "owner_subdistrict_id",
                        0 as "owner_district_id",
                        0 as "owner_province_id",
                        null as "owner_zipcode",
                        null as "user_email",
                        null as "user_mobile",
                        null as "par_1_prefix_name",
                        null as "par_1_first_name",
                        null as "par_1_last_name",
                        null as "par_1_birth_date",
                        null as "par_1_driver_license",
                        null as "par_1_citizen",
                        null as "par_2_prefix_name",
                        null as "par_2_first_name",
                        null as "par_2_last_name",
                        null as "par_2_birth_date",
                        null as "par_2_driver_license",
                        null as "par_2_citizen",
                        null as "bene_type",
                        null as "bene_title",
                        null as "bene_first_name",
                        null as "bene_last_name",
                        'N' as "deli_flag",
                        null as "deli_addr_1",
                        null as "deli_subdistrict",
                        null as "deli_district",
                        null as "deli_province",
                        0 as "deli_subdistrict_id",
                        0 as "deli_district_id",
                        0 as "deli_province_id",
                        null as "deli_zipcode",
                        "lead"."GarageType" as "garage_type",
                        COALESCE("lead"."SI_Limit", 0 ) as "si_limit",
                        COALESCE("lead"."SI_Access_Limit", 0 ) as "si_access_limit",
                        COALESCE("lead"."SI_TPPD_Limit", 0 ) as "si_tppd_limit",
                        COALESCE("lead"."SI_TPBI_Limit", 0 ) as "si_tpbi_limit",
                        COALESCE("lead"."SI_MV01_Limit", 0 ) as "si_mv01_limit",
                        COALESCE("lead"."SI_MV02_Limit", 0 ) as "si_mv02_limit",
                        COALESCE("lead"."SI_MV03_Limit", 0 ) as "si_mv03_limit",
                        null as "car_comp_code",
                        CAST(null as integer) as "coverinjury",
                        CAST(null as integer) as "coverdeath",
                        CAST(null as integer) as "coveracc",
                        "lead"."Access_para_code" as "Access_para_code",
                        null as "endorsement_list",
                        null as "policy_date_en",
                        null as "package_name",
                        null as "owner_prefix_name_en",
                        null as "Owner_first_name_en",
                        null as "Owner_last_name_en",
                        null as "Policy_Ta_No",
                        null as "Policy_Startdate_en",
                        null as "Policy_Enddate_en",
                        null as "ta_coverage_list",
                        null as "ta_country_name_th",
                        null as "ta_country_name_en",
                        null as "Owner_birth_date_en",
                        null as "owner_card_type",
                        null as "owner_address_en",
                        null as "owner_subdistrict_en",
                        null as "owner_district_en",
                        null as "owner_province_en",
                        null as "bene_ta_detail",
                        CAST(null as TIMESTAMP) as "policy_startdate_sort",
                        null as "owner_email",
                        null as "owner_mobile",
                        null as "endorse_last_status",
                        null as "Policy_Pa_No",
                        null as "pa_coverage_list",
                        null as "bene_pa_detail",
                        false as "tax_deductions",
                        null as "tax_deductions_url_ref",
                        null as "tax_deductions_date_th",
                        null as "tax_deductions_date_en",
                        'wait_fullfill' as "policy_directory",
                        null as "Policy_Home_No",
                        null as "home_coverage",
                        null as "bene_home_detail",
                        null as "Policy_url_ref",
                        null as "Receipt_url_ref",
                        null as "tax_deductions_url_copy_ref",
                        false as "claim_status_flag",
                        CAST((SELECT json_build_object(
                                             'cctv_flag',"lead"."Flag_CCTV",
                                             'cctv_disc_per',"lead"."CCTV",
                                             'access_flag', case when "lead"."Flag_Access" is not null then "lead"."Flag_Access" else 'N' end,
                                             'extend_startdate_th', null,
                                             'extend_startdate_en', null,
                                             'extend_enddate_th', null,
                                             'extend_enddate_en', null,
                                             'extend_amt', 0
                                     )) as TEXT) as "motor_detail",
                        CAST((SELECT json_build_object(
                                             'noti_renewal_flag',false,
                                             'expire_day_count',null,
                                             'last_noti_date_en',null,
                                             'last_noti_date_th',null,
                                             'total_amt',0,
                                             'is_renewed_flag',false,
                                             'renewed_policy_no',null,
                                             'can_renewal_flag',false,
                                             'ref_policy_no',"lead"."ref_policy_no"
                                     )) as TEXT) as "renewal_detail",
                        null as "ta_package_list"
                 FROM insurverse."Lead_coverage_premium" as "lead"
                          LEFT JOIN insurverse."Policy_Header" as "policy"
                                    ON "lead"."ref_policy_no"="policy"."Policy_No"
                 WHERE "lead"."Email" = (SELECT email FROM set_para)
                   AND "lead"."Payment_status"='SUCCESS'
                   AND "lead"."Lead_No" NOT IN (SELECT "prem"."Lead_No"
                                                FROM insurverse."Policy_coverage_premium" as "prem"
                                                         INNER JOIN insurverse."Policy_Header" as "policy" ON
                                                    "prem"."Policy_No" = "policy"."Policy_No" AND "policy"."email" = (SELECT email FROM set_para))
                 UNION
-- Lead_Car_Act_Discount_Premium
                 SELECT "lead"."Brand","lead"."Model", "lead"."Year", null as "Car_license_no",
                        '0' as "Type",0 as "SI",
                        null as "Owner_first_name", null as "Owner_last_name",
                        null as "Policy_No",
                        null as "Car_Act_No",
                        null as "Policy_Startdate",
                        null as "Policy_Enddate",
                        null as "Car_license_provice",
                        null as "Policy_url_copy_ref",
                        null as "Receipt_url_copy_ref",
                        null as "policy_date",
                        null as "Lead_No",
                        cast("lead"."Car_Act_Lead_No" as integer),
                        null as "Car_Inspect_Status",
                        1 as "priority",
                        'ACT' as "policy_status",
                        insurverse.fn_display_buddha_date("Payment_date") as "payment_date",
                        null as "car_serial_no",
                        null as "car_license_type",
                        null as "car_color",
                        CAST(NULL as INT) as "car_seat",
                        CAST(NULL as INT) as "car_weight",
                        null as "car_cc",
                        null as "owner_citizen_id",
                        null as "Owner_birth_date",
                        null as "owner_prefix_name",
                        null as "owner_address",
                        null as "owner_subdistrict",
                        null as "owner_district",
                        null as "owner_province",
                        0 as "owner_subdistrict_id",
                        0 as "owner_district_id",
                        0 as "owner_province_id",
                        null as "owner_zipcode",
                        null as "user_email",
                        null as "user_mobile",
                        null as "par_1_prefix_name",
                        null as "par_1_first_name",
                        null as "par_1_last_name",
                        null as "par_1_birth_date",
                        null as "par_1_driver_license",
                        null as "par_1_citizen",
                        null as "par_2_prefix_name",
                        null as "par_2_first_name",
                        null as "par_2_last_name",
                        null as "par_2_birth_date",
                        null as "par_2_driver_license",
                        null as "par_2_citizen",
                        null as "bene_type",
                        null as "bene_title",
                        null as "bene_first_name",
                        null as "bene_last_name",
                        'N' as "deli_flag",
                        null as "deli_addr_1",
                        null as "deli_subdistrict",
                        null as "deli_district",
                        null as "deli_province",
                        0 as "deli_subdistrict_id",
                        0 as "deli_district_id",
                        0 as "deli_province_id",
                        null as "deli_zipcode",
                        null as "garage_type",
                        null as "si_limit",
                        null as "si_access_limit",
                        null as "si_tppd_limit",
                        null as "si_tpbi_limit",
                        null as "si_mv01_limit",
                        null as "si_mv02_limit",
                        null as "si_mv03_limit",
                        "lead"."Car_Comp_Code" as "car_comp_code",
                        CASE WHEN "lead"."Car_Comp_Code" = '1.20A' THEN CAST("spar"."coverinjury_van" as INT) ELSE CAST("spar"."coverinjury" as INT) END as "coverinjury",
                        CASE WHEN "lead"."Car_Comp_Code" = '1.20A' THEN CAST("spar"."coverdeath_van" as INT) ELSE CAST("spar"."coverdeath" as INT) END as "coverdeath",
                        CASE WHEN "lead"."Car_Comp_Code" = '1.20A' THEN CAST("spar"."coveracc_van" as INT) ELSE CAST("spar"."coveracc" as INT) END as "coveracc",
                        null as "Access_para_code",
                        null as "endorsement_list",
                        null as "policy_date_en",
                        null as "package_name",
                        null as "owner_prefix_name_en",
                        null as "Owner_first_name_en",
                        null as "Owner_last_name_en",
                        null as "Policy_Ta_No",
                        null as "Policy_Startdate_en",
                        null as "Policy_Enddate_en",
                        null as "ta_coverage_list",
                        null as "ta_country_name_th",
                        null as "ta_country_name_en",
                        null as "Owner_birth_date_en",
                        null as "owner_card_type",
                        null as "owner_address_en",
                        null as "owner_subdistrict_en",
                        null as "owner_district_en",
                        null as "owner_province_en",
                        null as "bene_ta_detail",
                        CAST(null as TIMESTAMP) as "policy_startdate_sort",
                        null as "owner_email",
                        null as "owner_mobile",
                        null as "endorse_last_status",
                        null as "Policy_Pa_No",
                        null as "pa_coverage_list",
                        null as "bene_pa_detail",
                        false as "tax_deductions",
                        null as "tax_deductions_url_ref",
                        null as "tax_deductions_date_th",
                        null as "tax_deductions_date_en",
                        'wait_fullfill' as "policy_directory",
                        null as "Policy_Home_No",
                        null as "home_coverage",
                        null as "bene_home_detail",
                        null as "Policy_url_ref",
                        null as "Receipt_url_ref",
                        null as "tax_deductions_url_copy_ref",
                        false as "claim_status_flag",
                        CAST((SELECT json_build_object(
                                             'cctv_flag','N',
                                             'cctv_disc_per',0,
                                             'access_flag', 'N',
                                             'extend_startdate_th', null,
                                             'extend_startdate_en', null,
                                             'extend_enddate_th', null,
                                             'extend_enddate_en', null,
                                             'extend_amt', 0
                                     )) as TEXT) as "motor_detail",
                        null as "renewal_detail",
                        null as "ta_package_list"
                 FROM insurverse."Lead_Car_Act_Discount_Premium" as "lead"
                          INNER JOIN (SELECT DISTINCT "dom_code",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage' AND "para_code" = 'coverinjury' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverinjury",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage' AND "para_code" = 'coverdeath' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverdeath",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage' AND "para_code" = 'coveracc' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coveracc",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage_van' AND "para_code" = 'coverinjury' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverinjury_van",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage_van' AND "para_code" = 'coverdeath' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverdeath_van",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage_van' AND "para_code" = 'coveracc' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coveracc_van"
                                      FROM insurverse."sys_param"
                                      WHERE "dom_code"='Policy' AND ("sub_dom_code"='Car_act_coverage' OR "sub_dom_code"='Car_act_coverage_van')
                                      GROUP BY "dom_code")
                     as "spar" ON "spar"."dom_code" = 'Policy'
                 WHERE "lead"."email" = (SELECT email FROM set_para)
                   AND "lead"."Payment_status"='SUCCESS'
                   AND "lead"."Car_Act_Lead_No" NOT IN (SELECT "policy"."Car_Act_Lead_No"
                                                        FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                                                        WHERE "policy"."Car_Act_Lead_No" IS NOT NULL AND "policy"."email" = (SELECT email FROM set_para))
                 UNION
-- Policy_coverage_premium
                 SELECT "prem"."Brand", "prem"."Model", "prem"."Year", "policy"."Car_license_no",
                        "prem"."Type",CAST(COALESCE("prem"."SI_Limit", 0 ) + COALESCE("prem"."SI_Access_Limit", 0 ) as INT) as "SI",
                        "policy"."Owner_first_name", "policy"."Owner_last_name",
                        "policy"."Policy_No",
                        "policy"."Car_Act_No",
                        insurverse.fn_display_buddha_date("policy"."Policy_Startdate"+ INTERVAL '7 HOUR') as "Policy_Startdate",
                        insurverse.fn_display_buddha_date("policy"."Policy_Enddate"+ INTERVAL '7 HOUR') as "Policy_Enddate",
                        "province"."prname" as "Car_license_provice",
                        "policy"."Policy_url_copy_ref" as "Policy_url_copy_ref",
                        "policy"."Receipt_url_copy_ref" as "Receipt_url_copy_ref",
                        insurverse.fn_display_buddha_date("policy"."Create_date"+ INTERVAL '7 HOUR') as "policy_date",
                        "prem"."Lead_No",
                        null as "Car_Act_Lead_No",
                        CASE WHEN "policy"."Car_Inspect_Status"='' THEN null ELSE "policy"."Car_Inspect_Status" END as "Car_Inspect_Status",
                        3 as "priority",
                        COALESCE("policy"."Policy_Status",'ACT') as "policy_status",
                        insurverse.fn_display_buddha_date("prem"."Payment_Date") as "payment_date",
                        "policy"."Car_serial_no" as "car_serial_no",
                        "policy"."Car_license_type" as "car_license_type",
                        "color"."color_name_th" as "car_color",
                        COALESCE("policy"."Seat",0) as "car_seat",
                        COALESCE("policy"."Wg",0) as "car_weight",
                        "policy"."CC" as "car_cc",
                        "policy"."Owner_citizen_id" as "owner_citizen_id",
                        insurverse.fn_display_buddha_date("policy"."Owner_birth_date" + INTERVAL '7 HOUR') as "Owner_birth_date",
                        "policy"."Owner_prefix_name" as "owner_prefix_name",
                        "policy"."Owner_address" as "owner_address",
                        "owner_subd"."sdname" as "owner_subdistrict",
                        "owner_dis"."diname" as "owner_district",
                        "owner_prov"."prname" as "owner_province",
                        "policy"."Owner_subdistrict_id" as "owner_subdistrict_id",
                        "policy"."Owner_district_id"  as "owner_district_id",
                        "policy"."Owner_province_id"  as "owner_province_id",
                        "policy"."Owner_zipcode" as "owner_zipcode",
                        "policy"."email" as "user_email",
                        "user"."mobile" as "user_mobile",
                        "policy"."Par_prefix_name_1" as "par_1_prefix_name",
                        "policy"."Par_first_name_1" as "par_1_first_name",
                        "policy"."Par_last_name_1" as "par_1_last_name",
                        insurverse.fn_display_buddha_date("policy"."Par_birth_date_1" + INTERVAL '7 HOUR') as "par_1_birth_date",
                        "policy"."Par_Driver_license_no_1" as "par_1_driver_license",
                        "policy"."Par_citizen_id_1" as "par_1_citizen",
                        "policy"."Par_prefix_name_2" as "par_2_prefix_name",
                        "policy"."Par_first_name_2" as "par_2_first_name",
                        "policy"."Par_last_name_2" as "par_2_last_name",
                        insurverse.fn_display_buddha_date("policy"."Par_birth_date_2" + INTERVAL '7 HOUR') as "par_2_birth_date",
                        "policy"."Par_Driver_license_no_2" as "par_2_driver_license",
                        "policy"."Par_citizen_id_2" as "par_2_citizen",
                        case when "policy"."Bene_Type" is null then 'person' else "policy"."Bene_Type" end as "bene_type",
                        "policy"."Bene_Title" as "bene_title",
                        "policy"."Bene_Firstname" as "bene_first_name",
                        "policy"."Bene_Lastname" as "bene_last_name",
                        "policy"."Flag_Deli" as "deli_flag",
                        "policy"."Deli_Addr_line1" as "deli_addr_1",
                        "deli_subd"."sdname" as "deli_subdistrict",
                        "deli_dis"."diname" as "deli_district",
                        "deli_prov"."prname" as "deli_province",
                        "policy"."Deli_subdistrict_id" as "deli_subdistrict_id",
                        "policy"."Deli_district_id" as "deli_district_id",
                        "policy"."Deli_province_id" as "deli_province_id",
                        "policy"."Deli_zipcode" as "deli_zipcode",
                        "policy"."GarageType" as "garage_type",
                        COALESCE("prem"."SI_Limit", 0 ) as "si_limit",
                        COALESCE("prem"."SI_Access_Limit", 0 ) as "si_access_limit",
                        COALESCE("prem"."SI_TPPD_Limit", 0 ) as "si_tppd_limit",
                        COALESCE("prem"."SI_TPBI_Limit", 0 ) as "si_tpbi_limit",
                        COALESCE("prem"."SI_MV01_Limit", 0 ) as "si_mv01_limit",
                        COALESCE("prem"."SI_MV02_Limit", 0 ) as "si_mv02_limit",
                        COALESCE("prem"."SI_MV03_Limit", 0 ) as "si_mv03_limit",
                        null as "car_comp_code",
                        CAST(null as integer) as "coverinjury",
                        CAST(null as integer) as "coverdeath",
                        CAST(null as integer) as "coveracc",
                        "prem"."Access_para_code" as "Access_para_code",
                        CAST((SELECT json_agg(item)
                              FROM (SELECT * FROM (
                                                      SELECT "endorse"."SF_Policy_id" as "endorse_no",
                                                             1 as "priority",
                                                             insurverse.fn_display_buddha_date("endorse"."create_at" + INTERVAL '7 HOUR') as "endorse_date_th",
                                                             TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR','dd/mm/yyyy') as "endorse_date_en",
                                                             'endorse' as "endorse_doc_type",
                                                             "endorse"."doc_type" as "endorse_policy_type",
                                                             "endorse_name"."para_name" as "endorse_policy_name",
                                                             "endorse_name"."para_desc" as "endorse_policy_name_full",
                                                             "endorse"."Policy_url_ref" as "endorse_doc_url",
                                                             "endorse"."Policy_url_copy_ref" as "endorse_doc_url_copy"
                                                      FROM insurverse."Policy_endorse_detail" as "endorse"
                                                               INNER JOIN insurverse."sys_param" as "endorse_name"
                                                                          ON "endorse_name"."dom_code"='Policy'
                                                                              AND "endorse_name"."sub_dom_code"='doc_type'
                                                                              AND "endorse"."doc_type"="endorse_name"."para_code"
                                                      WHERE "endorse"."Policy_No"="policy"."Policy_No"
                                                      UNION
                                                      SELECT "endorse"."SF_Policy_id" as "endorse_no",
                                                             2 as "priority",
                                                             insurverse.fn_display_buddha_date("endorse"."create_at" + INTERVAL '7 HOUR') as "endorse_date_th",
                                                             TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR','dd/mm/yyyy') as "endorse_date_en",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != '' THEN 're_receipt'
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != '' THEN 'debitnote'
                                                                  WHEN "endorse"."debt_decrease_url_copy_ref" IS NOT NULL AND "endorse"."debt_decrease_url_copy_ref" != '' THEN 'createnote'
                                                                  ELSE 'no_document' END as "endorse_doc_type",
                                                             "endorse"."doc_type" as "endorse_policy_type",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != '' THEN 'ใบเสร็จ (ฉบับแก้ไข)'
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != '' THEN 'ใบเพิ่มหนี้'
                                                                  WHEN "endorse"."debt_decrease_url_copy_ref" IS NOT NULL AND "endorse"."debt_decrease_url_copy_ref" != '' THEN 'ใบลดหนี้'
                                                                  ELSE 'ไม่พบเอกสาร' END as "endorse_policy_name",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != '' THEN 'ใบเสร็จ (ฉบับแก้ไข)'
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != '' THEN 'ใบเพิ่มหนี้ (Debit note)'
                                                                  WHEN "endorse"."debt_decrease_url_copy_ref" IS NOT NULL AND "endorse"."debt_decrease_url_copy_ref" != '' THEN 'ใบลดหนี้ (Credit note)'
                                                                  ELSE 'ไม่พบเอกสาร' END as "endorse_policy_name_full",
                                                             CASE WHEN "endorse"."Receipt_url_ref" IS NOT NULL AND "endorse"."Receipt_url_ref" != '' THEN "endorse"."Receipt_url_ref"
                                                                  WHEN "endorse"."debt_increase_url_ref" IS NOT NULL AND "endorse"."debt_increase_url_ref" != '' THEN "endorse"."debt_increase_url_ref"
                                                                  ELSE "endorse"."debt_decrease_url_ref" END as "endorse_doc_url",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != ''  THEN "endorse"."Receipt_url_copy_ref"
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != ''  THEN "endorse"."debt_increase_url_copy_ref"
                                                                  ELSE "endorse"."debt_decrease_url_copy_ref" END as "endorse_doc_url_copy"
                                                      FROM insurverse."Policy_endorse_detail" as "endorse"
                                                               INNER JOIN insurverse."sys_param" as "endorse_name"
                                                                          ON "endorse_name"."dom_code"='Policy'
                                                                              AND "endorse_name"."sub_dom_code"='doc_type'
                                                                              AND "endorse"."doc_type"="endorse_name"."para_code"
                                                      WHERE "endorse"."Policy_No"="policy"."Policy_No"
                                                  ) as "endorse_list" WHERE "endorse_list"."endorse_doc_url" IS NOT NULL
                                    ORDER BY endorse_no DESC,priority ASC
                                   ) item
                        ) as TEXT) as "endorsement_list",
                        TO_CHAR("policy"."Create_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "policy_date_en",
                        null as "package_name",
                        null as "owner_prefix_name_en",
                        null as "Owner_first_name_en",
                        null as "Owner_last_name_en",
                        null as "Policy_Ta_No",
                        TO_CHAR("policy"."Policy_Startdate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Startdate_en",
                        TO_CHAR("policy"."Policy_Enddate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Enddate_en",
                        null as "ta_coverage_list",
                        null as "ta_country_name_th",
                        null as "ta_country_name_en",
                        TO_CHAR("policy"."Owner_birth_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Owner_birth_date_en",
                        null as "owner_card_type",
                        null as "owner_address_en",
                        null as "owner_subdistrict_en",
                        null as "owner_district_en",
                        null as "owner_province_en",
                        null as "bene_ta_detail",
                        "policy"."Policy_Startdate" as "policy_startdate_sort",
                        "policy"."email" as "owner_email",
                        null as "owner_mobile",
                        CAST ((
                            SELECT json_agg(json_req) FROM (
                                                               SELECT "log_req".create_at,CAST("log_req"."type" as JSON) as "type",
                                                                      "log_req"."policy_type","log_req"."policy_no","log_req"."car_act_no",
                                                                      "log_req"."owner_prefix_name" as "ownerPrefixName",
                                                                      "log_req"."owner_first_name" as "ownerFirstName",
                                                                      "log_req"."owner_last_name" as "ownerLastName",
                                                                      "log_req"."owner_address" as "ownerAddress",
                                                                      "log_req"."owner_province_id" as "ownerProvinceId",
                                                                      "log_req"."owner_province_name" as "ownerProvince",
                                                                      "log_req"."owner_district_id" as "ownerDistrictId",
                                                                      "log_req"."owner_district_name" as "ownerDistrict",
                                                                      "log_req"."owner_subdistrict_id" as "ownerSubdistrictId",
                                                                      "log_req"."owner_subdistrict_name" as "ownerSubdistrict",
                                                                      "log_req"."owner_zipcode" as "ownerZipcode",
                                                                      "log_req"."car_color" as "carColor",
                                                                      "log_req"."car_color_id" as "carColorID",
                                                                      "log_req"."car_license_no" as "carLicenseNo",
                                                                      "log_req"."car_license_province" as "carLicenseProvice",
                                                                      "log_req"."start_date" as "startDate",
                                                                      "log_req"."end_date" as "endDate",
                                                                      "log_req"."car_serial_no" as "carSerialNo",
                                                                      "log_req"."effective_date" as "effectiveDate",
                                                                      "log_req"."owner_birthdate" as "ownerBirthdate",
                                                                      "log_req"."owner_card_id" as "ownerCardId",
                                                                      "log_req"."salesforce_id" as "salesforceID",
                                                                      "log_req"."salesforce_id_at",
                                                                      "log_req"."request_body",
                                                                      "log_trans"."appr_status","log_trans"."appr_comment","log_trans"."create_at" as "callback_at"
                                                               FROM insurverse.log_sf_policy_trans_request as "log_req"
                                                                        LEFT JOIN insurverse.log_sf_policy_trans as "log_trans"
                                                                                  ON "log_req"."salesforce_id"="log_trans"."salesforce_id"
                                                                                      AND "log_req"."policy_no"="log_trans"."policy_no"
                                                               WHERE "log_trans"."salesforce_id" IS NULL AND "log_req"."policy_no"="policy"."Policy_No" AND "policy"."Type"!='0'
                                                               LIMIT 1
                                                           ) as "json_req") as TEXT) as "endorse_last_status",
                        null as "Policy_Pa_No",
                        null as "pa_coverage_list",
                        null as "bene_pa_detail",
                        false as "tax_deductions",
                        null as "tax_deductions_url_ref",
                        null as "tax_deductions_date_th",
                        null as "tax_deductions_date_en",
                        CASE WHEN ("policy"."Policy_Status"!='ACT') THEN 'cancel'
                             WHEN ("policy"."Type"='1' AND ("policy"."Car_Inspect_Status" IS NULL OR LOWER("policy"."Car_Inspect_Status")!='success')) THEN 'wait_inspect'
/*
WHEN ((SELECT COUNT(*) FROM insurverse.log_sf_policy_trans_request as "log_req"
LEFT JOIN insurverse.log_sf_policy_trans as "log_trans" 
ON "log_req"."salesforce_id"="log_trans"."salesforce_id"
AND "log_req"."policy_no"="log_trans"."policy_no"
WHERE "log_trans"."salesforce_id" IS NULL AND "log_req"."policy_no"="policy"."Policy_No" AND "policy"."Type"!='0'
AND ("log_req"."car_serial_no" IS NOT NULL AND "log_req"."car_serial_no" != '')
LIMIT 1) > 0) THEN 'request' 
*/
                             WHEN (CAST(now()+INTERVAL'7HOUR' as TIMESTAMP) BETWEEN CAST("policy"."Policy_Startdate"+INTERVAL'7HOUR' as TIMESTAMP) AND CAST("policy"."Policy_Enddate"+INTERVAL'7HOUR' as TIMESTAMP)) THEN 'insured_active'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as TIMESTAMP) < CAST("policy"."Policy_Startdate"+INTERVAL'7HOUR' as TIMESTAMP)) THEN 'insured_wait'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as TIMESTAMP) > CAST("policy"."Policy_Enddate"+INTERVAL'7HOUR' as TIMESTAMP)) THEN 'expired'
                             ELSE 'other' END as "policy_directory",
                        null as "Policy_Home_No",
                        null as "home_coverage",
                        null as "bene_home_detail",
                        "policy"."Policy_url_ref" as "Policy_url_ref",
                        "policy"."Receipt_url_ref" as "Receipt_url_ref",
                        null as "tax_deductions_url_copy_ref",
                        case when (select count("claim_id") from insurverse."sf_claim_coverage" as "cover" where policy_number="policy"."Policy_No" and UPPER("cover"."status") in ('CL','CC')) > 0 then true
                             else false end as "claim_status_flag",
                        CAST((SELECT json_build_object(
                                             'cctv_flag',"prem"."Flag_CCTV",
                                             'cctv_disc_per',"prem"."CCTV",
                                             'access_flag', case when "prem"."Flag_Access" is not null then "prem"."Flag_Access" else 'N' end,
                                             'extend_startdate_th', insurverse.fn_display_buddha_date("policy"."Extend_Start" + INTERVAL '7 HOUR'),
                                             'extend_startdate_en', TO_CHAR("policy"."Extend_Start" + INTERVAL '7 HOUR','dd/mm/yyyy'),
                                             'extend_enddate_th', insurverse.fn_display_buddha_date("policy"."Extend_End" + INTERVAL '7 HOUR'),
                                             'extend_enddate_en', TO_CHAR("policy"."Extend_End" + INTERVAL '7 HOUR','dd/mm/yyyy'),
                                             'extend_amt', "prem"."extend_amt"
                                     )) as TEXT) as "motor_detail",
                        CAST((SELECT json_build_object(
                                             'noti_renewal_flag',CASE WHEN COALESCE((select count("noti"."policy_no") from insurverse."log_noti_renewal" as "noti"
                                                                                                                               LEFT JOIN insurverse."Policy_Header" as "ref_policy" ON "noti"."policy_no"="ref_policy"."ref_policy_no"
                                                                                                                               LEFT JOIN insurverse."Lead_coverage_premium" as "ref_lead" ON "noti"."policy_no"="ref_lead"."ref_policy_no" AND UPPER("ref_lead"."Payment_status")='SUCCESS'
                                                                                     where "noti"."policy_no"="policy"."Policy_No" and "noti"."is_renewal"=true AND "ref_policy"."ref_policy_no" IS NULL
                                                                                       AND "ref_lead"."ref_policy_no" IS NULL limit 1),0) > 0 then true else false end,
                                             'expire_day_count',CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1,
                                             'last_noti_date_en', (select "create_at" + INTERVAL '7 HOUR' from insurverse."log_noti_renewal" where "policy_no"="policy"."Policy_No" order by "id" desc limit 1),
                                             'last_noti_date_th', (select insurverse.fn_display_buddha_date("create_at" + INTERVAL '7 HOUR') from insurverse."log_noti_renewal" where "policy_no"="policy"."Policy_No" order by "id" desc limit 1),
                                             'total_amt', (select "total_amt" from insurverse."log_noti_renewal" where "policy_no"="policy"."Policy_No" order by "id" desc limit 1),
                                             'is_renewed_flag',CASE WHEN (SELECT "rf_policy"."Policy_No" from insurverse."Policy_Header" as "rf_policy" where "rf_policy"."ref_policy_no"="policy"."Policy_No" limit 1) IS NOT NULL THEN true ELSE false END,
                                             'renewed_policy_no',(SELECT "rf_policy"."Policy_No" from insurverse."Policy_Header" as "rf_policy" where "rf_policy"."ref_policy_no"="policy"."Policy_No" limit 1),
                                             'can_renewal_flag',(select "is_renewal" from insurverse."log_noti_renewal" where "policy_no"="policy"."Policy_No" order by "id" desc limit 1),
                                             'ref_policy_no',"policy"."ref_policy_no",
                                             'Brand',"prem"."Brand",
                                             'Model',"prem"."Model",
                                             'Year',"prem"."Year",
                                             'Doors',"prem"."Doors"
                                     )) as TEXT) as "renewal_detail",
                        null as "ta_package_list"
                 FROM insurverse."Policy_coverage_premium" as "prem"
                          INNER JOIN insurverse."Policy_Header" as "policy" ON
                     "prem"."Policy_No" = "policy"."Policy_No"
                         AND "policy"."email" = (SELECT email FROM set_para)
                          INNER JOIN insurverse."province" ON
                     CAST("policy"."Car_license_provice" as INT)=CAST("province".provinceid as INT)
                          INNER JOIN insurverse."mas_cmi_color" as "color" ON "policy"."Car_color"="color"."color_id"
                          INNER JOIN insurverse.sec_user as "user" ON "policy"."email" = "user"."email"
                          INNER JOIN insurverse.subdistrict as "owner_subd" ON "policy"."Owner_subdistrict_id" = "owner_subd"."subdistrictid"
                          INNER JOIN insurverse.district as "owner_dis" ON "policy"."Owner_district_id" = "owner_dis"."districtid"
                          INNER JOIN insurverse.province as "owner_prov" ON "policy"."Owner_province_id" = "owner_prov"."provinceid"
                          LEFT JOIN insurverse.subdistrict as "deli_subd" ON "policy"."Deli_subdistrict_id" = "deli_subd"."subdistrictid"
                          LEFT JOIN insurverse.district as "deli_dis" ON "policy"."Deli_district_id" = "deli_dis"."districtid"
                          LEFT JOIN insurverse.province as "deli_prov" ON "policy"."Deli_province_id" = "deli_prov"."provinceid"
                 UNION
-- Policy_Car_Act_Discount_Premium
                 SELECT "policy"."Brand", "policy"."Model", "policy"."Year", "policy"."Car_license_no",
                        '0' as "Type",0 as "SI",
                        "policy"."first_name" as "Owner_first_name", "policy"."last_name" as "Owner_last_name",
                        CASE WHEN "policy"."Policy_No" IS NOT NULL AND CAST("policy"."Start_date" as DATE) = (SELECT CAST("head"."Policy_Startdate" as DATE) FROM insurverse."Policy_Header" as "head" WHERE "head"."Policy_No"="policy"."Policy_No") THEN
                                 "policy"."Policy_No" ELSE NULL END as "Policy_No",
--"policy"."Policy_No",
                        "policy"."Car_Act_No",
                        insurverse.fn_display_buddha_date("policy"."Start_date" + INTERVAL '7 HOUR') as "Policy_Startdate",
                        insurverse.fn_display_buddha_date("policy"."End_date" + INTERVAL '7 HOUR') as "Policy_Enddate",
                        "province"."prname" as "Car_license_provice",
                        "policy"."Policy_url_copy_ref" as "Policy_url_copy_ref",
                        "policy"."Receipt_url_copy_ref" as "Receipt_url_copy_ref",
                        insurverse.fn_display_buddha_date("policy"."Create_date" + INTERVAL '7 HOUR') as "policy_date",
                        cast("policy"."Lead_No" as integer) as "Lead_No",
                        cast("policy"."Car_Act_Lead_No" as integer),
                        'success' as "Car_Inspect_Status",
                        3 as "priority",
                        COALESCE("policy"."Policy_Status",'ACT') as "policy_status",
                        insurverse.fn_display_buddha_date("policy"."Payment_date" + INTERVAL '7 HOUR') as "payment_date",
                        "policy"."Car_serial_no" as "car_serial_no",
                        "policy"."Car_license_type" as "car_license_type",
                        "color"."color_name_th" as "car_color",
                        COALESCE("policy"."Seat",0) as "car_seat",
                        COALESCE("policy"."Wg",0) as "car_weight",
                        "policy"."CC" as "car_cc",
                        "policy"."citizen_id" as "owner_citizen_id",
                        insurverse.fn_display_buddha_date("policy"."birth_date" + INTERVAL '7 HOUR') as "Owner_birth_date",
                        "policy"."prefix_name" as "owner_prefix_name",
                        "policy"."address" as "owner_address",
                        "owner_subd"."sdname" as "owner_subdistrict",
                        "owner_dis"."diname" as "owner_district",
                        "owner_prov"."prname" as "owner_province",
                        "policy"."subdistrict_id" as "owner_subdistrict_id",
                        "policy"."district_id"  as "owner_district_id",
                        "policy"."province_id"  as "owner_province_id",
                        "policy"."zipcode" as "owner_zipcode",
                        "policy"."email" as "user_email",
                        "user"."mobile" as "user_mobile",
                        null as "par_1_prefix_name",
                        null as "par_1_first_name",
                        null as "par_1_last_name",
                        null as "par_1_birth_date",
                        null as "par_1_driver_license",
                        null as "par_1_citizen",
                        null as "par_2_prefix_name",
                        null as "par_2_first_name",
                        null as "par_2_last_name",
                        null as "par_2_birth_date",
                        null as "par_2_driver_license",
                        null as "par_2_citizen",
                        case when "policy"."Bene_Type" is null then 'person' else "policy"."Bene_Type" end as "bene_type",
                        "policy"."Bene_Title" as "bene_title",
                        "policy"."Bene_Firstname" as "bene_first_name",
                        "policy"."Bene_Lastname" as "bene_last_name",
                        "policy"."Flag_Deli" as "deli_flag",
                        "policy"."Deli_Addr_line1" as "deli_addr_1",
                        "deli_subd"."sdname" as "deli_subdistrict",
                        "deli_dis"."diname" as "deli_district",
                        "deli_prov"."prname" as "deli_province",
                        "policy"."Deli_subdistrict_id" as "deli_subdistrict_id",
                        "policy"."Deli_district_id" as "deli_district_id",
                        "policy"."Deli_province_id" as "deli_province_id",
                        "policy"."Deli_zipcode" as "deli_zipcode",
                        null as "garage_type",
                        null as "si_limit",
                        null as "si_access_limit",
                        null as "si_tppd_limit",
                        null as "si_tpbi_limit",
                        null as "si_mv01_limit",
                        null as "si_mv02_limit",
                        null as "si_mv03_limit",
                        "policy"."Car_Comp_Code" as "car_comp_code",
                        CASE WHEN "policy"."Car_Comp_Code" = '1.20A' THEN CAST("spar"."coverinjury_van" as INT) ELSE CAST("spar"."coverinjury" as INT) END as "coverinjury",
                        CASE WHEN "policy"."Car_Comp_Code" = '1.20A' THEN CAST("spar"."coverdeath_van" as INT) ELSE CAST("spar"."coverdeath" as INT) END as "coverdeath",
                        CASE WHEN "policy"."Car_Comp_Code" = '1.20A' THEN CAST("spar"."coveracc_van" as INT) ELSE CAST("spar"."coveracc" as INT) END as "coveracc",
                        null as "Access_para_code",
                        CAST((SELECT json_agg(item)
                              FROM (SELECT * FROM (
                                                      SELECT "endorse"."SF_Policy_id" as "endorse_no",
                                                             1 as "priority",
                                                             insurverse.fn_display_buddha_date("endorse"."create_at" + INTERVAL '7 HOUR') as "endorse_date_th",
                                                             TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR','dd/mm/yyyy') as "endorse_date_en",
                                                             'endorse' as "endorse_doc_type",
                                                             "endorse"."doc_type" as "endorse_policy_type",
                                                             "endorse_name"."para_name" as "endorse_policy_name",
                                                             "endorse_name"."para_desc" as "endorse_policy_name_full",
                                                             "endorse"."Policy_url_ref" as "endorse_doc_url",
                                                             "endorse"."Policy_url_copy_ref" as "endorse_doc_url_copy"
                                                      FROM insurverse."Policy_endorse_detail" as "endorse"
                                                               INNER JOIN insurverse."sys_param" as "endorse_name"
                                                                          ON "endorse_name"."dom_code"='Policy'
                                                                              AND "endorse_name"."sub_dom_code"='doc_type'
                                                                              AND "endorse"."doc_type"="endorse_name"."para_code"
                                                      WHERE "endorse"."Car_Act_No"="policy"."Car_Act_No"
                                                      UNION
                                                      SELECT "endorse"."SF_Policy_id" as "endorse_no",
                                                             2 as "priority",
                                                             insurverse.fn_display_buddha_date("endorse"."create_at" + INTERVAL '7 HOUR') as "endorse_date_th",
                                                             TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR','dd/mm/yyyy') as "endorse_date_en",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != '' THEN 're_receipt'
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != '' THEN 'debitnote'
                                                                  WHEN "endorse"."debt_decrease_url_copy_ref" IS NOT NULL AND "endorse"."debt_decrease_url_copy_ref" != '' THEN 'createnote'
                                                                  ELSE 'no_document' END as "endorse_doc_type",
                                                             "endorse"."doc_type" as "endorse_policy_type",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != '' THEN 'ใบเสร็จ (ฉบับแก้ไข)'
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != '' THEN 'ใบเพิ่มหนี้'
                                                                  WHEN "endorse"."debt_decrease_url_copy_ref" IS NOT NULL AND "endorse"."debt_decrease_url_copy_ref" != '' THEN 'ใบลดหนี้'
                                                                  ELSE 'ไม่พบเอกสาร' END as "endorse_policy_name",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != '' THEN 'ใบเสร็จ (ฉบับแก้ไข)'
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != '' THEN 'ใบเพิ่มหนี้ (Debit note)'
                                                                  WHEN "endorse"."debt_decrease_url_copy_ref" IS NOT NULL AND "endorse"."debt_decrease_url_copy_ref" != '' THEN 'ใบลดหนี้ (Credit note)'
                                                                  ELSE 'ไม่พบเอกสาร' END as "endorse_policy_name_full",
                                                             CASE WHEN "endorse"."Receipt_url_ref" IS NOT NULL AND "endorse"."Receipt_url_ref" != '' THEN "endorse"."Receipt_url_ref"
                                                                  WHEN "endorse"."debt_increase_url_ref" IS NOT NULL AND "endorse"."debt_increase_url_ref" != '' THEN "endorse"."debt_increase_url_ref"
                                                                  ELSE "endorse"."debt_decrease_url_ref" END as "endorse_doc_url",
                                                             CASE WHEN "endorse"."Receipt_url_copy_ref" IS NOT NULL AND "endorse"."Receipt_url_copy_ref" != ''  THEN "endorse"."Receipt_url_copy_ref"
                                                                  WHEN "endorse"."debt_increase_url_copy_ref" IS NOT NULL AND "endorse"."debt_increase_url_copy_ref" != ''  THEN "endorse"."debt_increase_url_copy_ref"
                                                                  ELSE "endorse"."debt_decrease_url_copy_ref" END as "endorse_doc_url_copy"
                                                      FROM insurverse."Policy_endorse_detail" as "endorse"
                                                               INNER JOIN insurverse."sys_param" as "endorse_name"
                                                                          ON "endorse_name"."dom_code"='Policy'
                                                                              AND "endorse_name"."sub_dom_code"='doc_type'
                                                                              AND "endorse"."doc_type"="endorse_name"."para_code"
                                                      WHERE "endorse"."Car_Act_No"="policy"."Car_Act_No"
                                                  ) as "endorse_list" WHERE "endorse_list"."endorse_doc_url" IS NOT NULL
                                    ORDER BY endorse_no DESC,priority ASC
                                   ) item
                        ) as TEXT) as "endorsement_list",
                        TO_CHAR("policy"."Create_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "policy_date_en",
                        null as "package_name",
                        null as "owner_prefix_name_en",
                        null as "Owner_first_name_en",
                        null as "Owner_last_name_en",
                        null as "Policy_Ta_No",
                        TO_CHAR("policy"."Start_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Startdate_en",
                        TO_CHAR("policy"."End_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Enddate_en",
                        null as "ta_coverage_list",
                        null as "ta_country_name_th",
                        null as "ta_country_name_en",
                        TO_CHAR("policy"."birth_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Owner_birth_date_en",
                        null as "owner_card_type",
                        null as "owner_address_en",
                        null as "owner_subdistrict_en",
                        null as "owner_district_en",
                        null as "owner_province_en",
                        null as "bene_ta_detail",
                        "policy"."Start_date" as "policy_startdate_sort",
                        "policy"."email" as "owner_email",
                        null as "owner_mobile",
                        CAST ((
                            SELECT json_agg(json_req) FROM (
                                                               SELECT "log_req".create_at,CAST("log_req"."type" as JSON) as "type",
                                                                      "log_req"."policy_type","log_req"."policy_no","log_req"."car_act_no",
                                                                      "log_req"."owner_prefix_name" as "ownerPrefixName",
                                                                      "log_req"."owner_first_name" as "ownerFirstName",
                                                                      "log_req"."owner_last_name" as "ownerLastName",
                                                                      "log_req"."owner_address" as "ownerAddress",
                                                                      "log_req"."owner_province_id" as "ownerProvinceId",
                                                                      "log_req"."owner_province_name" as "ownerProvince",
                                                                      "log_req"."owner_district_id" as "ownerDistrictId",
                                                                      "log_req"."owner_district_name" as "ownerDistrict",
                                                                      "log_req"."owner_subdistrict_id" as "ownerSubdistrictId",
                                                                      "log_req"."owner_subdistrict_name" as "ownerSubdistrict",
                                                                      "log_req"."owner_zipcode" as "ownerZipcode",
                                                                      "log_req"."car_color" as "carColor",
                                                                      "log_req"."car_color_id" as "carColorID",
                                                                      "log_req"."car_license_no" as "carLicenseNo",
                                                                      "log_req"."car_license_province" as "carLicenseProvice",
                                                                      "log_req"."start_date" as "startDate",
                                                                      "log_req"."end_date" as "endDate",
                                                                      "log_req"."car_serial_no" as "carSerialNo",
                                                                      "log_req"."effective_date" as "effectiveDate",
                                                                      "log_req"."owner_birthdate" as "ownerBirthdate",
                                                                      "log_req"."owner_card_id" as "ownerCardId",
                                                                      "log_req"."salesforce_id" as "salesforceID",
                                                                      "log_req"."salesforce_id_at",
                                                                      "log_req"."request_body",
                                                                      "log_trans"."appr_status","log_trans"."appr_comment","log_trans"."create_at" as "callback_at"
                                                               FROM insurverse.log_sf_policy_trans_request as "log_req"
                                                                        LEFT JOIN insurverse.log_sf_policy_trans as "log_trans"
                                                                                  ON "log_req"."salesforce_id"="log_trans"."salesforce_id"
                                                                                      AND "log_req"."car_act_no"="log_trans"."car_act_no"
                                                               WHERE "log_trans"."salesforce_id" IS NULL AND "log_req"."car_act_no"="policy"."Car_Act_No"
                                                               LIMIT 1
                                                           ) as "json_req") as TEXT) as "endorse_last_status",
                        null as "Policy_Pa_No",
                        null as "pa_coverage_list",
                        null as "bene_pa_detail",
                        false as "tax_deductions",
                        null as "tax_deductions_url_ref",
                        null as "tax_deductions_date_th",
                        null as "tax_deductions_date_en",
                        CASE WHEN ("policy"."Policy_Status"!='ACT') THEN 'cancel'
/*
WHEN ((SELECT COUNT(*) FROM insurverse.log_sf_policy_trans_request as "log_req"
LEFT JOIN insurverse.log_sf_policy_trans as "log_trans" 
ON "log_req"."salesforce_id"="log_trans"."salesforce_id"
AND "log_req"."car_act_no"="log_trans"."car_act_no"
WHERE "log_trans"."salesforce_id" IS NULL AND "log_req"."car_act_no"="policy"."Car_Act_No" AND "policy"."Type"='0'
AND ("log_req"."car_serial_no" IS NOT NULL AND "log_req"."car_serial_no" != '')
LIMIT 1) > 0) THEN 'request' 
*/
                             WHEN (CAST(now()+INTERVAL'7HOUR' as TIMESTAMP) BETWEEN CAST("policy"."Start_date"+INTERVAL'7HOUR' as TIMESTAMP) AND CAST("policy"."End_date"+INTERVAL'7HOUR' as TIMESTAMP)) THEN 'insured_active'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as TIMESTAMP) < CAST("policy"."Start_date"+INTERVAL'7HOUR' as TIMESTAMP)) THEN 'insured_wait'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as TIMESTAMP) > CAST("policy"."End_date"+INTERVAL'7HOUR' as TIMESTAMP)) THEN 'expired'
                             ELSE 'other' END as "policy_directory",
                        null as "Policy_Home_No",
                        null as "home_coverage",
                        null as "bene_home_detail",
                        "policy"."Policy_url_ref" as "Policy_url_ref",
                        "policy"."Receipt_url_ref" as "Receipt_url_ref",
                        null as "tax_deductions_url_copy_ref",
                        case when (select count("ref_notify_no") from insurverse.claim_request where acc_policy_no="policy"."Car_Act_No") > 0 then true
                             when (select count("ref_notify_no") from insurverse.sf_claim where acc_policy_no="policy"."Car_Act_No") > 0 then true
                             else false end as "claim_status_flag",
                        CAST((SELECT json_build_object(
                                             'cctv_flag','N',
                                             'cctv_disc_per',0,
                                             'access_flag', 'N',
                                             'extend_startdate_th', insurverse.fn_display_buddha_date("policy"."Extend_Start" + INTERVAL '7 HOUR'),
                                             'extend_startdate_en', TO_CHAR("policy"."Extend_Start" + INTERVAL '7 HOUR','dd/mm/yyyy'),
                                             'extend_enddate_th', insurverse.fn_display_buddha_date("policy"."Extend_End" + INTERVAL '7 HOUR'),
                                             'extend_enddate_en', TO_CHAR("policy"."Extend_End" + INTERVAL '7 HOUR','dd/mm/yyyy'),
                                             'extend_amt', "policy"."extend_amt"
                                     )) as TEXT) as "motor_detail",
                        CAST((SELECT json_build_object(
                                             'noti_renewal_flag',CASE WHEN COALESCE((select COUNT("noti"."policy_no")
                                                                                     from insurverse."log_noti_renewal" as "noti"
                                                                                              LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                                                                                        ON ("noti"."policy_no"="ref_policy"."ref_policy_no" or "noti"."remark"="ref_policy"."ref_policy_no")
                                                                                              LEFT JOIN (SELECT COUNT(*) as "lead_count" FROM insurverse."Lead_coverage_premium"
                                                                                                         WHERE "ref_policy_no"="policy"."Policy_No" AND UPPER("Flag_Car_Act")='Y' AND UPPER("Payment_status")='SUCCESS'
                                                                                     ) as "new_lead"
                                                                                                        ON lead_count is not null
                                                                                     where ("noti"."policy_no"="policy"."Car_Act_No" or "noti"."remark"="policy"."Car_Act_No")
                                                                                       and "noti"."is_renewal"=true
                                                                                       AND "ref_policy"."ref_policy_no" IS NULL
                                                                                       AND "new_lead"."lead_count" = 0
                                                                                     limit 1),0) > 0 then true else false end,
                                             'expire_day_count',CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1,
                                             'last_noti_date_en', (select "create_at" + INTERVAL '7 HOUR' from insurverse."log_noti_renewal" where "policy_no"="policy"."Car_Act_No" or "remark"="policy"."Car_Act_No" order by "id" desc limit 1),
                                             'last_noti_date_th', (select insurverse.fn_display_buddha_date("create_at" + INTERVAL '7 HOUR') from insurverse."log_noti_renewal" where "policy_no"="policy"."Car_Act_No" or "remark"="policy"."Car_Act_No" order by "id" desc limit 1),
                                             'total_amt', (select "total_amt" from insurverse."log_noti_renewal" where "policy_no"="policy"."Car_Act_No" or "remark"="policy"."Car_Act_No" order by "id" desc limit 1),
                                             'is_renewed_flag',CASE WHEN (SELECT "rf_policy"."Car_Act_No" from insurverse."Policy_Car_Act_Discount_Premium" as "rf_policy" where "rf_policy"."ref_policy_no"="policy"."Car_Act_No" limit 1) IS NOT NULL THEN true ELSE false END,
                                             'renewed_policy_no',(SELECT "rf_policy"."Car_Act_No" from insurverse."Policy_Car_Act_Discount_Premium" as "rf_policy" where "rf_policy"."ref_policy_no"="policy"."Car_Act_No" limit 1),
                                             'can_renewal_flag',(select "is_renewal" from insurverse."log_noti_renewal" where "policy_no"="policy"."Car_Act_No" or "remark"="policy"."Car_Act_No" order by "id" desc limit 1),
                                             'ref_policy_no',"policy"."ref_policy_no",
                                             'Brand',(SELECT "mv"."Brand" FROM insurverse."Policy_coverage_premium" as "mv" WHERE "policy"."Policy_No" IS NOT NULL AND "policy"."Policy_No"="mv"."Policy_No"),
                                             'Model',(SELECT "mv"."Model" FROM insurverse."Policy_coverage_premium" as "mv" WHERE "policy"."Policy_No" IS NOT NULL AND "policy"."Policy_No"="mv"."Policy_No"),
                                             'Year',(SELECT "mv"."Year" FROM insurverse."Policy_coverage_premium" as "mv" WHERE "policy"."Policy_No" IS NOT NULL AND "policy"."Policy_No"="mv"."Policy_No"),
                                             'Doors',(SELECT "mv"."Doors" FROM insurverse."Policy_coverage_premium" as "mv" WHERE "policy"."Policy_No" IS NOT NULL AND "policy"."Policy_No"="mv"."Policy_No")
                                     )) as TEXT) as "renewal_detail",
                        null as "ta_package_list"
                 FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                          INNER JOIN insurverse."province" ON
                     CAST("policy"."Car_license_provice" as INT)=CAST("province".provinceid as INT)
                          INNER JOIN insurverse."mas_cmi_color" as "color" ON "policy"."Car_color"="color"."color_id"
                          INNER JOIN insurverse.sec_user as "user" ON "policy"."email" = "user"."email"
                          INNER JOIN insurverse.subdistrict as "owner_subd" ON "policy"."subdistrict_id" = "owner_subd"."subdistrictid"
                          INNER JOIN insurverse.district as "owner_dis" ON "policy"."district_id" = "owner_dis"."districtid"
                          INNER JOIN insurverse.province as "owner_prov" ON "policy"."province_id" = "owner_prov"."provinceid"
                          INNER JOIN (SELECT DISTINCT "dom_code",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage' AND "para_code" = 'coverinjury' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverinjury",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage' AND "para_code" = 'coverdeath' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverdeath",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage' AND "para_code" = 'coveracc' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coveracc",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage_van' AND "para_code" = 'coverinjury' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverinjury_van",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage_van' AND "para_code" = 'coverdeath' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coverdeath_van",
                                                      MAX(CASE WHEN "sub_dom_code" = 'Car_act_coverage_van' AND "para_code" = 'coveracc' THEN CAST("para_value" as DECIMAL(16,2)) ELSE null END) as "coveracc_van"
                                      FROM insurverse."sys_param"
                                      WHERE "dom_code"='Policy' AND ("sub_dom_code"='Car_act_coverage' OR "sub_dom_code"='Car_act_coverage_van')
                                      GROUP BY "dom_code")
                     as "spar" ON "spar"."dom_code" = 'Policy'
                          LEFT JOIN insurverse.subdistrict as "deli_subd" ON "policy"."Deli_subdistrict_id" = "deli_subd"."subdistrictid"
                          LEFT JOIN insurverse.district as "deli_dis" ON "policy"."Deli_district_id" = "deli_dis"."districtid"
                          LEFT JOIN insurverse.province as "deli_prov" ON "policy"."Deli_province_id" = "deli_prov"."provinceid"
                 WHERE  "policy"."email" = (SELECT email FROM set_para)
                 UNION
-- policy_ta_premium
                 SELECT null as "Brand",null as "Model",null as "Year",null as "Car_license_no",
                        'ta' as "Type",0 as "SI",
                        "par"."owner_firstname_th" as "Owner_first_name", "par"."owner_lastname_th" as "Owner_last_name",
                        null as "Policy_No",
                        null as "Car_Act_No",
                        insurverse.fn_display_buddha_date("policy"."policy_startdate" + INTERVAL '7 HOUR') as "Policy_Startdate",
                        insurverse.fn_display_buddha_date("policy"."policy_enddate" + INTERVAL '7 HOUR') as "Policy_Enddate",
                        null as "Car_license_provice",
                        "policy"."policy_url_copy_ref" as "Policy_url_copy_ref",
                        "policy"."receipt_url_ref" as "Receipt_url_copy_ref",
                        insurverse.fn_display_buddha_date("policy"."create_date" + INTERVAL '7 HOUR') as "policy_date",
                        null as "Lead_No",
                        null as "Car_Act_Lead_No",
                        null as "Car_Inspect_Status",
                        3 as "priority",
                        COALESCE("policy"."policy_status",'ACT') as "policy_status",
                        insurverse.fn_display_buddha_date("policy"."payment_date" + INTERVAL '7 HOUR') as "payment_date",
                        null as "car_serial_no",
                        null as "car_license_type",
                        null as "car_color",
                        CAST(NULL as INT) as "car_seat",
                        CAST(NULL as INT) as "car_weight",
                        null as "car_cc",
                        "par"."owner_card_id" as "owner_citizen_id",
                        insurverse.fn_display_buddha_date("par"."owner_birthdate" + INTERVAL '7 HOUR') as "Owner_birth_date",
                        "par"."owner_title_th" as "owner_prefix_name",
                        "par"."owner_address_th" as "owner_address",
                        "owner_subd"."sdname" as "owner_subdistrict",
                        "owner_dis"."diname" as "owner_district",
                        "owner_prov"."prname" as "owner_province",
                        "par"."owner_subdistrict_id" as "owner_subdistrict_id",
                        "par"."owner_district_id"  as "owner_district_id",
                        "par"."owner_province_id"  as "owner_province_id",
                        "par"."owner_zipcode" as "owner_zipcode",
                        "policy"."email" as "user_email",
                        "user"."mobile" as "user_mobile",
                        null as "par_1_prefix_name",
                        null as "par_1_first_name",
                        null as "par_1_last_name",
                        null as "par_1_birth_date",
                        null as "par_1_driver_license",
                        null as "par_1_citizen",
                        null as "par_2_prefix_name",
                        null as "par_2_first_name",
                        null as "par_2_last_name",
                        null as "par_2_birth_date",
                        null as "par_2_driver_license",
                        null as "par_2_citizen",
                        null as "bene_type",
                        null as "bene_title",
                        null as "bene_first_name",
                        null as "bene_last_name",
                        'N'  as "deli_flag",
                        null as "deli_addr_1",
                        null as "deli_subdistrict",
                        null as "deli_district",
                        null as "deli_province",
                        0 as "deli_subdistrict_id",
                        0 as "deli_district_id",
                        0 as "deli_province_id",
                        null as "deli_zipcode",
                        null as "garage_type",
                        null as "si_limit",
                        null as "si_access_limit",
                        null as "si_tppd_limit",
                        null as "si_tpbi_limit",
                        null as "si_mv01_limit",
                        null as "si_mv02_limit",
                        null as "si_mv03_limit",
                        null as "car_comp_code",
                        CAST(null as integer) as "coverinjury",
                        CAST(null as integer) as "coverdeath",
                        CAST(null as integer) as "coveracc",
                        null as "Access_para_code",
                        null as "endorsement_list",
                        TO_CHAR("policy"."create_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "policy_date_en",
                        "pack"."package_name_en" as "package_name",
                        "par"."owner_title_en" as "owner_prefix_name_en",
                        "par"."owner_firstname_en" as "Owner_first_name_en",
                        "par"."owner_lastname_en" as "Owner_last_name_en",
                        "policy"."policy_ta_no" as "Policy_Ta_No",
                        TO_CHAR("policy"."policy_startdate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Startdate_en",
                        TO_CHAR("policy"."policy_enddate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Enddate_en",
                        CAST((SELECT json_agg(item)
                              FROM (SELECT "cover"."coverage_name_th" as "coverage_name_th",
                                           "cover"."coverage_name_en" as "coverage_name_en",
                                           "p_cover"."coverage_si_amt" as "coverage_si"
                                    FROM insurverse."mas_ta_package_coverage" as "p_cover"
                                             INNER JOIN insurverse."mas_ta_coverage" as "cover"
                                                        ON "p_cover"."ta_coverage_id"="cover"."ta_coverage_id"
                                                            AND "p_cover"."ta_package_id"="pack"."ta_package_id") item
                        ) as TEXT) as "ta_coverage_list",
                        insurverse.fn_display_country_th("policy"."country_id_array") as "ta_country_name_th",
                        insurverse.fn_display_country("policy"."country_id_array") as "ta_country_name_en",
                        TO_CHAR("par"."owner_birthdate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Owner_birth_date_en",
                        "par"."owner_card_type" as "owner_card_type",
                        "par"."owner_address_en" as "owner_address_en",
                        "owner_subd"."sdnameen" as "owner_subdistrict_en",
                        "owner_dis"."dinameen" as "owner_district_en",
                        "owner_prov"."prnameen" as "owner_province_en",
                        CAST((SELECT json_build_object(
                                             'bene_ta_type_th',"bene_type"."mas_name_th",
                                             'bene_ta_type_en',"bene_type"."mas_name_en",
                                             'bene_ta_title_name_th',"par"."bene_title_th",
                                             'bene_ta_first_name_th',"par"."bene_firstname_th",
                                             'bene_ta_last_name_th',"par"."bene_lastname_th",
                                             'bene_ta_title_name_en',"par"."bene_title_en",
                                             'bene_ta_first_name_en',"par"."bene_firstname_en",
                                             'bene_ta_last_name_en',"par"."bene_lastname_en",
                                             'bene_ta_relation_th',"bene_relation"."mas_name_th",
                                             'bene_ta_relation_en',"bene_relation"."mas_name_en"
                                     )) as TEXT) as "bene_ta_detail",
                        "policy"."policy_startdate" as "policy_startdate_sort",
                        "par"."owner_email" as "owner_email",
                        "par"."owner_phone" as "owner_mobile",
                        CAST((SELECT json_build_object(
                                             'id', "id",'create_at', "create_at",'request_type', "request_type",'subject', "subject",'body', "body",
                                             'request_status', "request_status",'remark', "remark",'update_at', "update_at",'iia_response_at', "iia_response_at"
                                     )
                              FROM insurverse."log_request_ta" as "req_ta"
                              WHERE "policy"."policy_ta_no"="req_ta"."policy_ta_no"
                              ORDER BY create_at DESC
                              LIMIT 1
                        ) as TEXT) as "endorse_last_status",
                        null as "Policy_Pa_No",
                        null as "pa_coverage_list",
                        null as "bene_pa_detail",
                        false as "tax_deductions",
                        null as "tax_deductions_url_ref",
                        null as "tax_deductions_date_th",
                        null as "tax_deductions_date_en",
                        CASE WHEN ("policy"."policy_status"!='ACT') THEN 'cancel'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) BETWEEN CAST("policy"."policy_startdate"+INTERVAL'7HOUR' as DATE) AND CAST("policy"."policy_enddate"+INTERVAL'7HOUR' as DATE)) THEN 'insured_active'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) < CAST("policy"."policy_startdate"+INTERVAL'7HOUR' as DATE)) THEN 'insured_wait'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) > CAST("policy"."policy_enddate"+INTERVAL'7HOUR' as DATE)) THEN 'expired'
                             ELSE 'other' END as "policy_directory",
                        null as "Policy_Home_No",
                        null as "home_coverage",
                        null as "bene_home_detail",
                        "policy"."policy_url_ref" as "Policy_url_ref",
                        "policy"."receipt_url_ref" as "Receipt_url_ref",
                        null as "tax_deductions_url_copy_ref",
                        false as "claim_status_flag",
                        null as "motor_detail",
                        null as "renewal_detail",
                        CAST((
                            SELECT json_agg("ta_pack")
                            FROM (
                                     SELECT "pack"."ta_package_id" as "ta_package_id",
                                            "pack"."package_name_th" as "package_name_th",
                                            "pack"."package_name_en" as "package_name_en",
                                            "pack"."package_desc_th" as "package_desc_th",
                                            "pack"."package_desc_en" as "package_desc_en",
                                            "pack"."is_addon" as "is_addon",
                                            (
                                                SELECT json_agg("2_coverage")
                                                FROM (
                                                         SELECT
                                                             "2_cover"."ta_coverage_id" as "ta_coverage_id",
                                                             "2_cover"."coverage_name_th" as "coverage_name_th",
                                                             "2_cover"."coverage_name_en" as "coverage_name_en",
                                                             "2_cover"."coverage_desc_th" as "coverage_desc_th",
                                                             "2_cover"."coverage_desc_en" as "coverage_desc_en",
                                                             COALESCE("2_policy_c"."coverage_si_amt",0) as "coverage_si_amt",
                                                             "2_cover"."coverage_desc_th_1" as "coverage_desc_1_th",
                                                             "2_cover"."coverage_desc_en_1" as "coverage_desc_1_en",
                                                             "2_cover"."coverage_desc_th_2" as "coverage_desc_2_th",
                                                             "2_cover"."coverage_desc_en_2" as "coverage_desc_2_en",
                                                             "2_cover"."coverage_desc_th_3" as "coverage_desc_3_th",
                                                             "2_cover"."coverage_desc_en_3" as "coverage_desc_3_en",
                                                             COALESCE("2_policy_c"."other_amt_min",0) as "other_amt_min",
                                                             COALESCE("2_policy_c"."other_amt_max",0) as "other_amt_max",
                                                             "2_cover"."coverage_type_icon" as "coverage_type_icon"
                                                         from insurverse."policy_ta_coverage" as "2_policy_c"
                                                                  inner join insurverse."mas_ta_coverage" as "2_cover"
                                                                             on "policy_c"."policy_ta_no"="2_policy_c"."policy_ta_no"
                                                                                 and "policy_c"."ta_package_id"="2_policy_c"."ta_package_id"
                                                                                 and "2_policy_c"."ta_coverage_id"="2_cover"."ta_coverage_id"
                                                                  inner join insurverse."mas_ta_package_coverage" as "2_pack_c"
                                                                             on "policy_c"."ta_package_id"="2_pack_c"."ta_package_id"
                                                                                 and "2_policy_c"."ta_coverage_id"="2_pack_c"."ta_coverage_id"
                                                         order by "2_pack_c"."priority" asc
                                                     ) as "2_coverage") as "ta_coverage_list"
                                     from (select DISTINCT "policy_ta_no","ta_package_id" from insurverse."policy_ta_coverage"
                                           where "policy_ta_no"="policy"."policy_ta_no") as "policy_c"
                                              inner join insurverse."mas_ta_package" as "pack"
                                                         on "policy_c"."policy_ta_no"="policy"."policy_ta_no"
                                                             and "policy_c"."ta_package_id"="pack"."ta_package_id"
                                 ) as "ta_pack"
                        ) as TEXT) as "ta_package_list"
                 FROM insurverse."policy_ta_premium" as "policy"
                          INNER JOIN insurverse."lead_ta_participant" as "par"
                                     ON "policy"."policy_ta_no"="par"."policy_ta_no"
                          INNER JOIN insurverse."mas_ta_package" as "pack"
                                     ON "policy"."ta_package_id"="pack"."ta_package_id"
                          INNER JOIN insurverse."mas_ta_description" as "bene_type"
                                     ON "par"."bene_type"=CAST("bene_type"."mas_ta_code" as INT2)
                                         AND "bene_type"."mas_ta_type"='bene_type'
                          LEFT JOIN insurverse."mas_ta_description" as "bene_relation"
                                    ON "par"."bene_relation"=CAST("bene_relation"."mas_ta_code" as INT2)
                                        AND "bene_relation"."mas_ta_type"='bene_relation'
                          INNER JOIN insurverse.sec_user as "user" ON "policy"."email" = "user"."email"
                          INNER JOIN insurverse.subdistrict as "owner_subd" ON "par"."owner_subdistrict_id" = "owner_subd"."subdistrictid"
                          INNER JOIN insurverse.district as "owner_dis" ON "par"."owner_district_id" = "owner_dis"."districtid"
                          INNER JOIN insurverse.province as "owner_prov" ON "par"."owner_province_id" = "owner_prov"."provinceid"
                 WHERE  "policy"."email" = (SELECT email FROM set_para)
                 UNION
-- policy_pa_premium
                 SELECT null as "Brand",null as "Model",null as "Year",null as "Car_license_no",
                        'pa' as "Type",0 as "SI",
                        "par"."owner_firstname_th" as "Owner_first_name", "par"."owner_lastname_th" as "Owner_last_name",
                        null as "Policy_No",
                        null as "Car_Act_No",
                        insurverse.fn_display_buddha_date("policy"."policy_startdate" + INTERVAL '7 HOUR') as "Policy_Startdate",
                        insurverse.fn_display_buddha_date("policy"."policy_enddate" + INTERVAL '7 HOUR') as "Policy_Enddate",
                        null as "Car_license_provice",
                        "policy"."policy_url_copy_ref" as "Policy_url_copy_ref",
                        "policy"."receipt_url_ref" as "Receipt_url_copy_ref",
                        insurverse.fn_display_buddha_date("policy"."create_date" + INTERVAL '7 HOUR') as "policy_date",
                        null as "Lead_No",
                        null as "Car_Act_Lead_No",
                        null as "Car_Inspect_Status",
                        3 as "priority",
                        COALESCE("policy"."policy_status",'ACT') as "policy_status",
                        insurverse.fn_display_buddha_date("policy"."payment_date" + INTERVAL '7 HOUR') as "payment_date",
                        null as "car_serial_no",
                        null as "car_license_type",
                        null as "car_color",
                        CAST(NULL as INT) as "car_seat",
                        CAST(NULL as INT) as "car_weight",
                        null as "car_cc",
                        "par"."owner_card_id" as "owner_citizen_id",
                        insurverse.fn_display_buddha_date("par"."owner_birthdate" + INTERVAL '7 HOUR') as "Owner_birth_date",
                        "par"."owner_title_th" as "owner_prefix_name",
                        "par"."owner_address_th" as "owner_address",
                        (SELECT "owner_subd"."sdname" FROM insurverse."subdistrict" AS "owner_subd"
                         WHERE "par"."owner_subdistrict_id"="owner_subd"."subdistrictid") as "owner_subdistrict",
                        (SELECT "owner_dis"."diname" FROM insurverse."district" AS "owner_dis"
                         WHERE "par"."owner_district_id"="owner_dis"."districtid") as "owner_district",
                        (SELECT "owner_prov"."prname" FROM insurverse."province" AS "owner_prov"
                         WHERE "par"."owner_province_id"="owner_prov"."provinceid") as "owner_province",
                        "par"."owner_subdistrict_id" as "owner_subdistrict_id",
                        "par"."owner_district_id"  as "owner_district_id",
                        "par"."owner_province_id"  as "owner_province_id",
                        "par"."owner_zipcode" as "owner_zipcode",
                        "policy"."email" as "user_email",
                        "user"."mobile" as "user_mobile",
                        null as "par_1_prefix_name",
                        null as "par_1_first_name",
                        null as "par_1_last_name",
                        null as "par_1_birth_date",
                        null as "par_1_driver_license",
                        null as "par_1_citizen",
                        null as "par_2_prefix_name",
                        null as "par_2_first_name",
                        null as "par_2_last_name",
                        null as "par_2_birth_date",
                        null as "par_2_driver_license",
                        null as "par_2_citizen",
                        null as "bene_type",
                        null as "bene_title",
                        null as "bene_first_name",
                        null as "bene_last_name",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN 'Y' ELSE 'N' END as "deli_flag",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_address_th" ELSE null END as "deli_addr_1",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN (SELECT "deli_subd"."sdname" FROM insurverse."subdistrict" AS "deli_subd"
                                                                  WHERE "policy"."deli_subdistrict_id"="deli_subd"."subdistrictid") ELSE null END as "deli_subdistrict",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN (SELECT "deli_dis"."diname" FROM insurverse."district" AS "deli_dis"
                                                                  WHERE "policy"."deli_district_id"="deli_dis"."districtid") ELSE null END as "deli_district",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN (SELECT "deli_prov"."prname" FROM insurverse."province" AS "deli_prov"
                                                                  WHERE "policy"."deli_province_id"="deli_prov"."provinceid") ELSE null END as "deli_province",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_subdistrict_id" ELSE 0 END as "deli_subdistrict_id",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_district_id" ELSE 0 END as "deli_district_id",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_province_id" ELSE 0 END as "deli_province_id",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_zipcode" ELSE null END as "deli_zipcode",
                        null as "garage_type",
                        null as "si_limit",
                        null as "si_access_limit",
                        null as "si_tppd_limit",
                        null as "si_tpbi_limit",
                        null as "si_mv01_limit",
                        null as "si_mv02_limit",
                        null as "si_mv03_limit",
                        null as "car_comp_code",
                        CAST(null as integer) as "coverinjury",
                        CAST(null as integer) as "coverdeath",
                        CAST(null as integer) as "coveracc",
                        null as "Access_para_code",
                        null as "endorsement_list",
                        TO_CHAR("policy"."create_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "policy_date_en",
                        "pack"."package_name_th" as "package_name",
                        "par"."owner_title_en" as "owner_prefix_name_en",
                        "par"."owner_firstname_en" as "Owner_first_name_en",
                        "par"."owner_lastname_en" as "Owner_last_name_en",
                        null as "Policy_Ta_No",
                        TO_CHAR("policy"."policy_startdate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Startdate_en",
                        TO_CHAR("policy"."policy_enddate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Enddate_en",
                        null as "ta_coverage_list",
                        null as "ta_country_name_th",
                        null as "ta_country_name_en",
                        TO_CHAR("par"."owner_birthdate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Owner_birth_date_en",
                        "par"."owner_card_type" as "owner_card_type",
                        "par"."owner_address_en" as "owner_address_en",
                        (SELECT "owner_subd"."sdnameen" FROM insurverse."subdistrict" AS "owner_subd"
                         WHERE "par"."owner_subdistrict_id"="owner_subd"."subdistrictid") as "owner_subdistrict_en",
                        (SELECT "owner_dis"."dinameen" FROM insurverse."district" AS "owner_dis"
                         WHERE "par"."owner_district_id"="owner_dis"."districtid") as "owner_district_en",
                        (SELECT "owner_prov"."prnameen" FROM insurverse."province" AS "owner_prov"
                         WHERE "par"."owner_province_id"="owner_prov"."provinceid") as "owner_province_en",
                        null as "bene_ta_detail",
                        "policy"."policy_startdate" as "policy_startdate_sort",
                        "par"."owner_email" as "owner_email",
                        "par"."owner_phone" as "owner_mobile",
                        CAST((SELECT json_build_object(
                                             'id', "id",'create_at', "create_at",'request_type', "request_type",'subject', "subject",'body', "body",
                                             'request_status', "request_status",'remark', "remark",'update_at', "update_at",'iia_response_at', "iia_response_at"
                                     )
                              FROM insurverse."log_request_pa" as "req_pa"
                              WHERE "policy"."policy_pa_no"="req_pa"."policy_pa_no"
                              ORDER BY create_at DESC
                              LIMIT 1
                        ) as TEXT) as "endorse_last_status",
                        "policy"."policy_pa_no" as "Policy_Pa_No",
                        CAST((SELECT json_agg(item)
                              FROM (SELECT
                                        "p_cover"."pa_coverage_id" as "pa_coverage_id",
                                        "cover"."coverage_name_th" as "coverage_name_th",
                                        "cover"."coverage_name_en" as "coverage_name_en",
                                        "p_cover"."si_cover_amt" as "coverage_si",
                                        "cover"."coverage_desc1_th" as "coverage_desc1_th",
                                        "cover"."coverage_desc1_en" as "coverage_desc1_en",
                                        "cover"."coverage_desc2_th" as "coverage_desc2_th",
                                        "cover"."coverage_desc2_en" as "coverage_desc3_en",
                                        "cover"."coverage_desc3_th" as "coverage_desc3_th",
                                        "cover"."coverage_desc3_en" as "coverage_desc3_en"
                                    FROM insurverse."lead_pa_coverage" as "p_cover"
                                             INNER JOIN insurverse."mas_pa_coverage" as "cover"
                                                        ON "p_cover"."policy_pa_no"="policy"."policy_pa_no"
                                                            AND "p_cover"."pa_coverage_id"="cover"."pa_coverage_id") item
                        ) as TEXT) as "pa_coverage_list",
                        CAST((SELECT json_build_object(
                                             'suminsure_rate',"bene"."suminsure_rate",
                                             'bene_pa_type_th',"bene_type"."mas_name_th",
                                             'bene_pa_type_en',"bene_type"."mas_name_en",
                                             'bene_pa_title_name_th',"bene"."bene_title_th",
                                             'bene_pa_first_name_th',"bene"."bene_firstname_th",
                                             'bene_pa_last_name_th',"bene"."bene_lastname_th",
                                             'bene_pa_title_name_en',"bene"."bene_title_en",
                                             'bene_pa_first_name_en',"bene"."bene_firstname_en",
                                             'bene_pa_last_name_en',"bene"."bene_lastname_en",
                                             'bene_pa_relation_th',"bene_relation"."mas_name_th",
                                             'bene_pa_relation_en',"bene_relation"."mas_name_en")
                              FROM insurverse."lead_pa_beneficiary" as "bene"
                                       INNER JOIN insurverse."mas_ta_description" as "bene_type"
                                                  ON "bene"."policy_pa_no"="policy"."policy_pa_no"
                                                      AND "bene"."bene_type"=CAST("bene_type"."mas_ta_code" as INT2)
                                                      AND "bene_type"."mas_ta_type"='bene_type'
                                       LEFT JOIN insurverse."mas_ta_description" as "bene_relation"
                                                 ON "bene"."bene_relation"=CAST("bene_relation"."mas_ta_code" as INT2)
                                                     AND "bene_relation"."mas_ta_type"='bene_relation'
                        )as TEXT) as "bene_pa_detail",
                        "policy"."tax_deductions" as "tax_deductions",
                        "policy"."tax_deductions_url_ref" as "tax_deductions_url_ref", -- (2023-12-04)
                        insurverse.fn_display_buddha_date("policy"."tax_deductions_date" + INTERVAL '7 HOUR') as "tax_deductions_date_th",
                        TO_CHAR("policy"."tax_deductions_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "tax_deductions_date_en",
                        CASE WHEN ("policy"."policy_status"!='ACT') THEN 'cancel'
/*
WHEN ((SELECT request_status
FROM insurverse."log_request_pa" as "req_pa"
WHERE "policy"."policy_pa_no"="req_pa"."policy_pa_no"
ORDER BY create_at DESC
LIMIT 1) NOT IN ('approve','cancel')) THEN 'request'
*/
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) BETWEEN CAST("policy"."policy_startdate"+INTERVAL'7HOUR' as DATE) AND CAST("policy"."policy_enddate"+INTERVAL'7HOUR' as DATE)) THEN 'insured_active'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) < CAST("policy"."policy_startdate"+INTERVAL'7HOUR' as DATE)) THEN 'insured_wait'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) > CAST("policy"."policy_enddate"+INTERVAL'7HOUR' as DATE)) THEN 'expired'
                             ELSE 'other' END as "policy_directory",
                        null as "Policy_Home_No",
                        null as "home_coverage",
                        null as "bene_home_detail",
                        "policy"."policy_url_ref" as "Policy_url_ref",
                        "policy"."receipt_url_ref" as "Receipt_url_ref",
                        "policy"."tax_deductions_url_ref_copy" as "tax_deductions_url_copy_ref",
                        false as "claim_status_flag",
                        null as "motor_detail",
                        null as "renewal_detail",
                        null as "ta_package_list"
                 FROM insurverse."policy_pa_premium" as "policy"
                          INNER JOIN insurverse."lead_pa_participant" as "par"
                                     ON "policy"."policy_pa_no"="par"."policy_pa_no"
                          INNER JOIN insurverse."mas_pa_package" as "pack"
                                     ON "policy"."pa_package_id"="pack"."pa_package_id"
                          INNER JOIN insurverse.sec_user as "user" ON "policy"."user_id" = "user"."user_id"
                 WHERE  "policy"."email" = (SELECT email FROM set_para)
                 union
-- policy_home_premium
                 SELECT null as "Brand",null as "Model",null as "Year",null as "Car_license_no",
                        'home' as "Type",0 as "SI",
                        "par"."owner_firstname_th" as "Owner_first_name", "par"."owner_lastname_th" as "Owner_last_name",
                        null as "Policy_No",
                        null as "Car_Act_No",
                        insurverse.fn_display_buddha_date("policy"."policy_startdate" + INTERVAL '7 HOUR') as "Policy_Startdate",
                        insurverse.fn_display_buddha_date("policy"."policy_enddate" + INTERVAL '7 HOUR') as "Policy_Enddate",
                        null as "Car_license_provice",
                        "policy"."policy_url_copy_ref" as "Policy_url_copy_ref",
                        "policy"."receipt_url_ref" as "Receipt_url_copy_ref",
                        insurverse.fn_display_buddha_date("policy"."create_date" + INTERVAL '7 HOUR') as "policy_date",
                        null as "Lead_No",
                        null as "Car_Act_Lead_No",
                        null as "Car_Inspect_Status",
                        3 as "priority",
                        COALESCE("policy"."policy_status",'ACT') as "policy_status",
                        insurverse.fn_display_buddha_date("policy"."payment_date" + INTERVAL '7 HOUR') as "payment_date",
                        null as "car_serial_no",
                        null as "car_license_type",
                        null as "car_color",
                        CAST(NULL as INT) as "car_seat",
                        CAST(NULL as INT) as "car_weight",
                        null as "car_cc",
                        "par"."owner_card_id" as "owner_citizen_id",
                        insurverse.fn_display_buddha_date("par"."owner_birthdate" + INTERVAL '7 HOUR') as "Owner_birth_date",
                        "par"."owner_title_th" as "owner_prefix_name",
                        "par"."owner_address_th" as "owner_address",
                        (SELECT "owner_subd"."sdname" FROM insurverse."subdistrict" AS "owner_subd"
                         WHERE "par"."owner_subdistrict_id"="owner_subd"."subdistrictid") as "owner_subdistrict",
                        (SELECT "owner_dis"."diname" FROM insurverse."district" AS "owner_dis"
                         WHERE "par"."owner_district_id"="owner_dis"."districtid") as "owner_district",
                        (SELECT "owner_prov"."prname" FROM insurverse."province" AS "owner_prov"
                         WHERE "par"."owner_province_id"="owner_prov"."provinceid") as "owner_province",
                        "par"."owner_subdistrict_id" as "owner_subdistrict_id",
                        "par"."owner_district_id"  as "owner_district_id",
                        "par"."owner_province_id"  as "owner_province_id",
                        "par"."owner_zipcode" as "owner_zipcode",
                        "policy"."email" as "user_email",
                        "user"."mobile" as "user_mobile",
                        null as "par_1_prefix_name",
                        null as "par_1_first_name",
                        null as "par_1_last_name",
                        null as "par_1_birth_date",
                        null as "par_1_driver_license",
                        null as "par_1_citizen",
                        null as "par_2_prefix_name",
                        null as "par_2_first_name",
                        null as "par_2_last_name",
                        null as "par_2_birth_date",
                        null as "par_2_driver_license",
                        null as "par_2_citizen",
                        null as "bene_type",
                        null as "bene_title",
                        null as "bene_first_name",
                        null as "bene_last_name",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN 'Y' ELSE 'N' END as "deli_flag",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_address_th" ELSE null END as "deli_addr_1",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN (SELECT "deli_subd"."sdname" FROM insurverse."subdistrict" AS "deli_subd"
                                                                  WHERE "policy"."deli_subdistrict_id"="deli_subd"."subdistrictid") ELSE null END as "deli_subdistrict",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN (SELECT "deli_dis"."diname" FROM insurverse."district" AS "deli_dis"
                                                                  WHERE "policy"."deli_district_id"="deli_dis"."districtid") ELSE null END as "deli_district",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN (SELECT "deli_prov"."prname" FROM insurverse."province" AS "deli_prov"
                                                                  WHERE "policy"."deli_province_id"="deli_prov"."provinceid") ELSE null END as "deli_province",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_subdistrict_id" ELSE 0 END as "deli_subdistrict_id",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_district_id" ELSE 0 END as "deli_district_id",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_province_id" ELSE 0 END as "deli_province_id",
                        CASE WHEN "policy"."deli_flag"=TRUE THEN "policy"."deli_zipcode" ELSE null END as "deli_zipcode",
                        null as "garage_type",
                        null as "si_limit",
                        null as "si_access_limit",
                        null as "si_tppd_limit",
                        null as "si_tpbi_limit",
                        null as "si_mv01_limit",
                        null as "si_mv02_limit",
                        null as "si_mv03_limit",
                        null as "car_comp_code",
                        CAST(null as integer) as "coverinjury",
                        CAST(null as integer) as "coverdeath",
                        CAST(null as integer) as "coveracc",
                        null as "Access_para_code",
                        null as "endorsement_list",
                        TO_CHAR("policy"."create_date" + INTERVAL '7 HOUR','dd/mm/yyyy') as "policy_date_en",
                        null as "package_name",
                        "par"."owner_title_en" as "owner_prefix_name_en",
                        "par"."owner_firstname_en" as "Owner_first_name_en",
                        "par"."owner_lastname_en" as "Owner_last_name_en",
                        null as "Policy_Ta_No",
                        TO_CHAR("policy"."policy_startdate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Startdate_en",
                        TO_CHAR("policy"."policy_enddate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Policy_Enddate_en",
                        null as "ta_coverage_list",
                        null as "ta_country_name_th",
                        null as "ta_country_name_en",
                        TO_CHAR("par"."owner_birthdate" + INTERVAL '7 HOUR','dd/mm/yyyy') as "Owner_birth_date_en",
                        "par"."owner_card_type" as "owner_card_type",
                        "par"."owner_address_en" as "owner_address_en",
                        (SELECT "owner_subd"."sdnameen" FROM insurverse."subdistrict" AS "owner_subd"
                         WHERE "par"."owner_subdistrict_id"="owner_subd"."subdistrictid") as "owner_subdistrict_en",
                        (SELECT "owner_dis"."dinameen" FROM insurverse."district" AS "owner_dis"
                         WHERE "par"."owner_district_id"="owner_dis"."districtid") as "owner_district_en",
                        (SELECT "owner_prov"."prnameen" FROM insurverse."province" AS "owner_prov"
                         WHERE "par"."owner_province_id"="owner_prov"."provinceid") as "owner_province_en",
                        null as "bene_ta_detail",
                        "policy"."policy_startdate" as "policy_startdate_sort",
                        "par"."owner_email" as "owner_email",
                        "par"."owner_phone" as "owner_mobile",
                        CAST((SELECT json_build_object(
                                             'id', "id",'create_at', "create_at",'request_type', "request_type",'subject', "subject",'body', "body",
                                             'request_status', "request_status",'remark', "remark",'update_at', "update_at",'iia_response_at', "iia_response_at"
                                     )
                              FROM insurverse."log_request_home" as "req_home"
                              WHERE "policy"."policy_home_no"="req_home"."policy_home_no"
                              ORDER BY create_at DESC
                              LIMIT 1
                        ) as TEXT) as "endorse_last_status",
                        null as "Policy_Pa_No",
                        null as "pa_coverage_list",
                        null as "bene_pa_detail",
                        false as "tax_deductions",
                        null as "tax_deductions_url_ref",
                        null as "tax_deductions_date_th",
                        null as "tax_deductions_date_en",
                        CASE WHEN ("policy"."policy_status"!='ACT') THEN 'cancel'
/*
WHEN ((SELECT request_status
FROM insurverse."log_request_home" as "req_home"
WHERE "policy"."policy_home_no"="req_home"."policy_home_no"
ORDER BY create_at DESC
LIMIT 1) NOT IN ('approve','cancel')) THEN 'request'
*/
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) BETWEEN CAST("policy"."policy_startdate"+INTERVAL'7HOUR' as DATE) AND CAST("policy"."policy_enddate"+INTERVAL'7HOUR' as DATE)) THEN 'insured_active'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) < CAST("policy"."policy_startdate"+INTERVAL'7HOUR' as DATE)) THEN 'insured_wait'
                             WHEN (CAST(now()+INTERVAL'7HOUR' as DATE) > CAST("policy"."policy_enddate"+INTERVAL'7HOUR' as DATE)) THEN 'expired'
                             ELSE 'other' END as "policy_directory",
                        "policy"."policy_home_no" as "Policy_Home_No",
                        CAST((SELECT json_build_object(
                                             'building_type_id',"policy"."home_building_type_id",
                                             'building_type_name_th',(select "building_name_th" from insurverse."mas_home_building_type" as "build" where "build"."home_building_type_id"="policy"."home_building_type_id"),
                                             'building_province_id',"policy"."home_building_province_id",
                                             'building_province_name_th',(select "prname" from insurverse."province" where "province"."provinceid"="policy"."home_building_province_id"),
                                             'building_material_type_id',"policy"."home_material_type_id",
                                             'building_material_type_name_th',(select "material_name_th" from insurverse."mas_home_material_type" as "mat" where "mat"."home_material_type_id"="policy"."home_material_type_id"),
                                             'resident_type_id',"policy"."home_resident_type_id",
                                             'resident_type_name_th',(select "resident_name_th" from insurverse."mas_home_resident_type" as "resident" where "resident"."home_resident_type_id"="policy"."home_resident_type_id"),
                                             'building_address_detail',(SELECT json_build_object(
                                                                                       'building_address_th',"building_address_th",
                                                                                       'building_subdistrict',COALESCE((SELECT "build_subd"."sdname" FROM insurverse."subdistrict" AS "build_subd"
                                                                                                                        WHERE "policy"."building_subdistrict_id"="build_subd"."subdistrictid"),''),
                                                                                       'building_district',COALESCE((SELECT "build_dis"."diname" FROM insurverse."district" AS "build_dis"
                                                                                                                     WHERE "policy"."building_district_id"="build_dis"."districtid"),''),
                                                                                       'building_province',COALESCE((SELECT "build_prov"."prname" FROM insurverse."province" AS "build_prov"
                                                                                                                     WHERE "policy"."building_province_id"="build_prov"."provinceid"),''),
                                                                                       'building_zipcode',COALESCE("policy"."building_zipcode",'')
                                                                               )),
                                             'coverage_detail',(select json_build_object(
                                                                               'cover_main_si',coalesce("cover"."cover_main_si",0),
                                                                               'flag_furniture',coalesce("cover"."flag_furniture",false),
                                                                               'cover_furniture_si',coalesce("cover"."cover_furniture_si",0),
                                                                               'cover_main_furniture_si',coalesce("cover"."cover_main_furniture_si",0),
                                                                               'cover_main_furniture_prem',coalesce("cover"."cover_main_furniture_prem",0),
                                                                               'cover_loss_and_damage_si',coalesce("cover"."cover_loss_and_damage_si",0),
                                                                               'cover_loss_and_damage_prem',coalesce("cover"."cover_loss_and_damage_prem",0),
                                                                               'flag_cover_rental_cost',coalesce("cover"."flag_cover_rental_cost",false),
                                                                               'cover_glass_si',coalesce("cover"."cover_glass_si",0),
                                                                               'cover_glass_prem',coalesce("cover"."cover_glass_prem",0),
                                                                               'cover_main_total_amt',coalesce("cover"."cover_main_total_amt",0),
                                                                               'flag_cover_natural_dis_ex_flood',coalesce("cover"."flag_cover_natural_dis_ex_flood",false),
                                                                               'cover_natural_dis_ex_flood_si',coalesce("cover"."cover_natural_dis_ex_flood_si",0),
                                                                               'cover_natural_dis_ex_flood_prem',coalesce("cover"."cover_natural_dis_ex_flood_prem",0),
                                                                               'flag_cover_flood_dis',coalesce("cover"."flag_cover_flood_dis",false),
                                                                               'cover_flood_dis_si',coalesce("cover"."cover_flood_dis_si",0),
                                                                               'cover_flood_dis_prem',coalesce("cover"."cover_flood_dis_prem",0),
                                                                               'flag_cover_theft',coalesce("cover"."flag_cover_theft",false),
                                                                               'cover_theft_si',coalesce("cover"."cover_theft_si",0),
                                                                               'cover_theft_prem',coalesce("cover"."cover_theft_prem",0),
                                                                               'flag_cover_third_parties',coalesce("cover"."flag_cover_third_parties",false),
                                                                               'cover_third_parties_si',coalesce("cover"."cover_third_parties_si",0),
                                                                               'cover_third_parties_prem',coalesce("cover"."cover_third_parties_prem",0),
                                                                               'cover_addon_total_amt',coalesce("cover"."cover_addon_total_amt",0)
                                                                       ) from insurverse."lead_home_coverage" as "cover"
                                                                where "cover"."policy_home_no"="policy"."policy_home_no")
                                     )) as TEXT) as "home_coverage",
                        CAST((SELECT json_build_object(
                                             'suminsure_rate',"par"."suminsure_rate",
                                             'bene_home_type_th',"bene_type"."mas_name_th",
                                             'bene_home_type_en',"bene_type"."mas_name_en",
                                             'bene_home_title_name_th',"par"."bene_title_th",
                                             'bene_home_first_name_th',"par"."bene_firstname_th",
                                             'bene_home_last_name_th',"par"."bene_lastname_th",
                                             'bene_home_title_name_en',"par"."bene_title_en",
                                             'bene_home_first_name_en',"par"."bene_firstname_en",
                                             'bene_home_last_name_en',"par"."bene_lastname_en",
                                             'bene_home_relation_th',"bene_relation"."mas_name_th",
                                             'bene_home_relation_en',"bene_relation"."mas_name_en")
                              FROM insurverse."mas_ta_description" as "bene_type"
                                       LEFT JOIN insurverse."mas_ta_description" as "bene_relation"
                                                 ON "par"."bene_relation"=CAST("bene_relation"."mas_ta_code" as INT2)
                                                     AND "bene_relation"."mas_ta_type"='bene_relation'
                              where "par"."bene_type"=CAST("bene_type"."mas_ta_code" as INT2)
                                AND "bene_type"."mas_ta_type"='bene_type'
                        )as TEXT) as "bene_home_detail",
                        "policy"."policy_url_ref" as "Policy_url_ref",
                        "policy"."receipt_url_ref" as "Receipt_url_ref",
                        null as "tax_deductions_url_copy_ref",
                        false as "claim_status_flag",
                        null as "motor_detail",
                        null as "renewal_detail",
                        null as "ta_package_list"
                 FROM insurverse."policy_home_premium" as "policy"
                          INNER JOIN insurverse."lead_home_participant" as "par"
                                     ON "policy"."policy_home_no"="par"."policy_home_no"
                          INNER JOIN insurverse.sec_user as "user" ON "policy"."user_id" = "user"."user_id"
                 WHERE  "policy"."email" = (SELECT email FROM set_para)
             ) as "my_policy"
        ORDER BY "my_policy"."priority","my_policy"."Car_Inspect_Status" DESC,"my_policy"."policy_startdate_sort" desc,
                 "my_policy"."Policy_No" DESC,"my_policy"."Car_Act_No" desc,"my_policy"."Policy_Ta_No" desc,
                 "my_policy"."Policy_Pa_No" desc,"my_policy"."Policy_Home_No" desc;
END;
$function$
