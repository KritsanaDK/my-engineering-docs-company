-- =============================================================================
-- Function: insurverse.fn_policy_my_policy_search_optimisation
-- OID: 28464
-- Identity Arguments: (in_email text)
-- Returns: TABLE("Brand" character varying, "Model" character varying, "Year" character varying, "Car_license_no" text, "Type" character varying, "SI" integer, "Owner_first_name" text, "Owner_first_name_en" text, "Owner_last_name" text, "Owner_last_name_en" text, "Policy_No" text, "Policy_Ta_No" text, "Car_Act_No" text, "Policy_Startdate" text, "Policy_Startdate_en" text, "Policy_Enddate" text, "Policy_Enddate_en" text, policy_startdate_sort timestamp without time zone, "Car_license_provice" text, "Policy_url_copy_ref" text, "Receipt_url_copy_ref" text, policy_date text, policy_date_en text, "Car_Inspect_Status" text, "Lead_No" integer, "Car_Act_Lead_No" integer, priority integer, policy_status text, payment_date text, car_serial_no text, car_license_type text, car_color text, car_cc text, car_seat integer, car_weight integer, owner_citizen_id text, "Owner_birth_date" text, "Owner_birth_date_en" text, owner_prefix_name text, owner_prefix_name_en text, owner_address text, owner_address_en text, owner_subdistrict text, owner_subdistrict_en text, owner_district text, owner_district_en text, owner_province text, owner_province_en text, owner_zipcode text, user_email text, user_mobile text, par_1_prefix_name text, par_1_first_name text, par_1_last_name text, par_1_birth_date text, par_1_driver_license text, par_1_citizen text, par_2_prefix_name text, par_2_first_name text, par_2_last_name text, par_2_birth_date text, par_2_driver_license text, par_2_citizen text, bene_type text, bene_first_name text, bene_last_name text, bene_ta_detail text, deli_addr_1 text, deli_subdistrict text, deli_district text, deli_province text, deli_zipcode text, garage_type character varying, si_limit numeric, si_access_limit numeric, si_tppd_limit numeric, si_tpbi_limit numeric, si_mv01_limit numeric, si_mv02_limit numeric, si_mv03_limit numeric, car_comp_code character varying, coverinjury integer, coverdeath integer, coveracc integer, "Access_para_code" character varying, endorsement_list text, package_name text, ta_coverage_list text, ta_country_name_th text, ta_country_name_en text, owner_card_type text, owner_email text, owner_mobile text, deli_flag text, "Policy_Pa_No" text, bene_pa_detail text, bene_title text, pa_coverage_list text, policy_directory text, tax_deductions_url_ref text, endorse_last_status text, tax_deductions boolean, owner_subdistrict_id integer, owner_district_id integer, owner_province_id integer, deli_subdistrict_id integer, deli_district_id integer, deli_province_id integer, tax_deductions_date_th text, tax_deductions_date_en text, "Policy_Home_No" text, home_coverage text, bene_home_detail text, "Policy_url_ref" text, "Receipt_url_ref" text, tax_deductions_url_copy_ref text, claim_status_flag boolean, motor_detail text, renewal_detail text, ta_package_list text, ta_policy_detail text, partner_code text, partner_detail text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_my_policy_search_optimisation(in_email text)
 RETURNS TABLE("Brand" character varying, "Model" character varying, "Year" character varying, "Car_license_no" text, "Type" character varying, "SI" integer, "Owner_first_name" text, "Owner_first_name_en" text, "Owner_last_name" text, "Owner_last_name_en" text, "Policy_No" text, "Policy_Ta_No" text, "Car_Act_No" text, "Policy_Startdate" text, "Policy_Startdate_en" text, "Policy_Enddate" text, "Policy_Enddate_en" text, policy_startdate_sort timestamp without time zone, "Car_license_provice" text, "Policy_url_copy_ref" text, "Receipt_url_copy_ref" text, policy_date text, policy_date_en text, "Car_Inspect_Status" text, "Lead_No" integer, "Car_Act_Lead_No" integer, priority integer, policy_status text, payment_date text, car_serial_no text, car_license_type text, car_color text, car_cc text, car_seat integer, car_weight integer, owner_citizen_id text, "Owner_birth_date" text, "Owner_birth_date_en" text, owner_prefix_name text, owner_prefix_name_en text, owner_address text, owner_address_en text, owner_subdistrict text, owner_subdistrict_en text, owner_district text, owner_district_en text, owner_province text, owner_province_en text, owner_zipcode text, user_email text, user_mobile text, par_1_prefix_name text, par_1_first_name text, par_1_last_name text, par_1_birth_date text, par_1_driver_license text, par_1_citizen text, par_2_prefix_name text, par_2_first_name text, par_2_last_name text, par_2_birth_date text, par_2_driver_license text, par_2_citizen text, bene_type text, bene_first_name text, bene_last_name text, bene_ta_detail text, deli_addr_1 text, deli_subdistrict text, deli_district text, deli_province text, deli_zipcode text, garage_type character varying, si_limit numeric, si_access_limit numeric, si_tppd_limit numeric, si_tpbi_limit numeric, si_mv01_limit numeric, si_mv02_limit numeric, si_mv03_limit numeric, car_comp_code character varying, coverinjury integer, coverdeath integer, coveracc integer, "Access_para_code" character varying, endorsement_list text, package_name text, ta_coverage_list text, ta_country_name_th text, ta_country_name_en text, owner_card_type text, owner_email text, owner_mobile text, deli_flag text, "Policy_Pa_No" text, bene_pa_detail text, bene_title text, pa_coverage_list text, policy_directory text, tax_deductions_url_ref text, endorse_last_status text, tax_deductions boolean, owner_subdistrict_id integer, owner_district_id integer, owner_province_id integer, deli_subdistrict_id integer, deli_district_id integer, deli_province_id integer, tax_deductions_date_th text, tax_deductions_date_en text, "Policy_Home_No" text, home_coverage text, bene_home_detail text, "Policy_url_ref" text, "Receipt_url_ref" text, tax_deductions_url_copy_ref text, claim_status_flag boolean, motor_detail text, renewal_detail text, ta_package_list text, ta_policy_detail text, partner_code text, partner_detail text)
 LANGUAGE plpgsql
AS $function$
BEGIN

  IF EXISTS (
    SELECT 1
    FROM insurverse.policy_optimized_email_list
    WHERE email = in_email
  ) THEN
		RETURN QUERY
		SELECT
		    pct."Brand", pct."Model", pct."Year", pct."Car_license_no", pct."Type", pct."SI",
		    pct."Owner_first_name", pct."Owner_first_name_en", pct."Owner_last_name", pct."Owner_last_name_en",
		    pct."Policy_No", pct."Policy_Ta_No", pct."Car_Act_No",
		    pct."Policy_Startdate", pct."Policy_Startdate_en", pct."Policy_Enddate", pct."Policy_Enddate_en",
		    pct.policy_startdate_sort, pct."Car_license_provice",
		    pct."Policy_url_copy_ref", pct."Receipt_url_copy_ref",
		    pct.policy_date, pct.policy_date_en, pct."Car_Inspect_Status",
		    pct."Lead_No", pct."Car_Act_Lead_No", pct.priority, pct.policy_status,
		    pct.payment_date, pct.car_serial_no, pct.car_license_type, pct.car_color, pct.car_cc,
		    pct.car_seat, pct.car_weight, pct.owner_citizen_id,
		    pct."Owner_birth_date", pct."Owner_birth_date_en",
		    pct.owner_prefix_name, pct.owner_prefix_name_en, pct.owner_address, pct.owner_address_en,
		    pct.owner_subdistrict, pct.owner_subdistrict_en, pct.owner_district, pct.owner_district_en,
		    pct.owner_province, pct.owner_province_en, pct.owner_zipcode,
		    pct.user_email, pct.user_mobile,
		    pct.par_1_prefix_name, pct.par_1_first_name, pct.par_1_last_name,
		    pct.par_1_birth_date, pct.par_1_driver_license, pct.par_1_citizen,
		    pct.par_2_prefix_name, pct.par_2_first_name, pct.par_2_last_name,
		    pct.par_2_birth_date, pct.par_2_driver_license, pct.par_2_citizen,
		    pct.bene_type, pct.bene_first_name, pct.bene_last_name, pct.bene_ta_detail,
		    pct.deli_addr_1, pct.deli_subdistrict, pct.deli_district, pct.deli_province, pct.deli_zipcode,
		    pct.garage_type,
		    pct.si_limit, pct.si_access_limit, pct.si_tppd_limit, pct.si_tpbi_limit,
		    pct.si_mv01_limit, pct.si_mv02_limit, pct.si_mv03_limit,
		    pct.car_comp_code, pct.coverinjury, pct.coverdeath, pct.coveracc,
		    pct."Access_para_code", pct.endorsement_list, pct.package_name,
		    pct.ta_coverage_list, pct.ta_country_name_th, pct.ta_country_name_en,
		    pct.owner_card_type, pct.owner_email, pct.owner_mobile, pct.deli_flag,
		    pct."Policy_Pa_No", pct.bene_pa_detail, pct.bene_title, pct.pa_coverage_list,
		    pct.policy_directory, pct.tax_deductions_url_ref, pct.endorse_last_status, pct.tax_deductions,
		    pct.owner_subdistrict_id, pct.owner_district_id, pct.owner_province_id,
		    pct.deli_subdistrict_id, pct.deli_district_id, pct.deli_province_id,
		    pct.tax_deductions_date_th, pct.tax_deductions_date_en,
		    pct."Policy_Home_No", pct.home_coverage, pct.bene_home_detail,
		    pct."Policy_url_ref", pct."Receipt_url_ref", pct.tax_deductions_url_copy_ref,
		    pct.claim_status_flag, pct.motor_detail, pct.renewal_detail, pct.ta_package_list,
		    pct.ta_policy_detail, pct.partner_code, pct.partner_detail
		FROM insurverse.policy_cache AS pct -- Alias added
		WHERE pct.cache_email = in_email;

  ELSE

    RETURN QUERY
    SELECT * FROM insurverse.fn_policy_my_policy_search(in_email, null, null);
  END IF;
END;
$function$
