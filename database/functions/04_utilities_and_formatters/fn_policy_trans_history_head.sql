-- =============================================================================
-- Function: insurverse.fn_policy_trans_history_head
-- OID: 18807
-- Identity Arguments: (policy_no text)
-- Returns: TABLE(rtn_policy_no text, trans_id text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_trans_history_head(policy_no text)
 RETURNS TABLE(rtn_policy_no text, trans_id text)
 LANGUAGE plpgsql
AS $function$
DECLARE SYS_TRANSID TEXT;
BEGIN
  SYS_TRANSID = insurverse.fn_policy_transid_sf_mv("policy_no");
	
	UPDATE insurverse."Policy_Header"
	SET "Create_date"="Effective_Startdate"
	WHERE "Policy_No"=policy_no and "Create_date" IS NULL;
	
	-- UPDATE EFFECTIVE_DATE coverage = header
	UPDATE insurverse."Policy_coverage_premium"
	SET "Effective_Startdate"="Policy_Header"."Effective_Startdate",
	"Create_date"="Policy_Header"."Create_date"
	FROM insurverse."Policy_Header"
	WHERE "Policy_coverage_premium"."Policy_No"=policy_no  
	AND "Policy_coverage_premium"."Policy_No"="Policy_Header"."Policy_No";

  	INSERT INTO insurverse."Policy_Header_Trans" (
		"Policy_No", "Policy_Startdate", "Policy_Enddate", "Policy_Status",
		"Policy_Quatation_No", "Policy_Invoice_No", "Car_Act_No", "IIA_Ref_no",
		"Policy_ETax_No", "Par_code", "Payment_Status",
		"Create_date", "Create_by", 
		"Update_date", "Update_by",
		"Car_Inspect_code", "Car_Inspect_Status", "Car_Inspect_Result", "Car_inspect_date",
		"SF_Policy_id", "Deli_Addr_line1", "Deli_Addr_line2", "Deli_Addr_line3",
		"Deli_province_id", "Deli_subdistrict_id", "Deli_district_id", "Deli_zipcode", "Deli_countryid",
		phone, email, "Brand", "Model", "Year", "Doors", "Seat", "Wg", "Group", "Usage",
		"Type", "BodyType", "GarageType", "NamedAge", "CC",
		"Car_license_no", "Car_license_provice", "Car_serial_no",
		"Bene_Type", "Bene_Title", "Bene_Firstname", "Bene_Midname", "Bene_Lastname", "Bene_ID_card",
		"Extend_Start", "Extend_End", "Car_license_type", "Policy_Ref_no", "Policy_QR_code",
		"Car_color", "Lead_No", "Effective_Startdate", "Effective_Enddate",
		"Flag_Deli", "Comp_Code", "Policy_url_ref", id, "Policy_Barcode", "Policy_url_copy_ref",
		"Par_first_name_1", "Par_last_name_1", "Par_birth_date_1", "Par_occupation_1",
		"Par_first_name_2", "Par_last_name_2", "Par_birth_date_2", "Par_occupation_2",
		"Owner_first_name", "Owner_last_name", "Owner_birth_date",
		"Par_prefix_name_1", "Par_prefix_name_2", "Owner_prefix_name",
		"Owner_address", "Owner_province_id", "Owner_subdistrict_id", "Owner_district_id",
		"Owner_zipcode", "Owner_countryid", "Owner_phone", "Owner_occupation", "Owner_citizen_id",
		"Policy_book", "Par_Driver_license_no_1", "Par_Driver_license_no_2",
		"Receipt_url_ref", "Receipt_url_copy_ref",
		"SF_Epolicy_file_id", "SF_Etax_file_id", "SF_Endorse_type",
		"Par_citizen_id_1", "Par_citizen_id_2", "IIA_Lot_No",
		"Appr_prefix_name", "Appr_first_name", "Appr_last_name",
		par_id, no_cancel_flag, no_cancel_reason, no_cancel_at,
		ref_policy_no, partner_code, cc_ans,
		par_prefix_name_3, par_first_name_3, par_last_name_3, par_birth_date_3, par_citizen_id_3, par_driver_license_no_3, par_occupation_3,
		par_prefix_name_4, par_first_name_4, par_last_name_4, par_birth_date_4, par_citizen_id_4, par_driver_license_no_4, par_occupation_4,
		par_prefix_name_5, par_first_name_5, par_last_name_5, par_birth_date_5, par_citizen_id_5, par_driver_license_no_5, par_occupation_5,
		driver_behavior_1, driver_behavior_2, driver_behavior_3, driver_behavior_4, driver_behavior_5,
		driver_behavior_cal, driver_behavior_disc_perc, driver_behavior_disc_amt,
		car_price, car_price_date, sc_premium_amt, prem_version, oic_version,
		driver_behavior_consent_1, driver_behavior_consent_2, driver_behavior_consent_3, driver_behavior_consent_4, driver_behavior_consent_5,
		bene_occupation,
		par_occupation_code_1, par_occupation_code_2, par_occupation_code_3, par_occupation_code_4, par_occupation_code_5,
		bene_occupation_code,
        par_driver_license_category_1, par_driver_license_category_2, par_driver_license_category_3, par_driver_license_category_4, par_driver_license_category_5
	)
	SELECT
		"Policy_No", "Policy_Startdate", "Policy_Enddate", "Policy_Status",
		"Policy_Quatation_No", "Policy_Invoice_No", "Car_Act_No", "IIA_Ref_no",
		"Policy_ETax_No", "Par_code", "Payment_Status",
		now(), "Create_by", 
		now(), "Update_by",
		"Car_Inspect_code", "Car_Inspect_Status", "Car_Inspect_Result", "Car_inspect_date",
		"SF_Policy_id", "Deli_Addr_line1", "Deli_Addr_line2", "Deli_Addr_line3",
		"Deli_province_id", "Deli_subdistrict_id", "Deli_district_id", "Deli_zipcode", "Deli_countryid",
		phone, email, "Brand", "Model", "Year", "Doors", "Seat", "Wg", "Group", "Usage",
		"Type", "BodyType", "GarageType", "NamedAge", "CC",
		"Car_license_no", "Car_license_provice", "Car_serial_no",
		"Bene_Type", "Bene_Title", "Bene_Firstname", "Bene_Midname", "Bene_Lastname", "Bene_ID_card",
		"Extend_Start", "Extend_End", "Car_license_type", "Policy_Ref_no", "Policy_QR_code",
		"Car_color", "Lead_No", "Effective_Startdate", "Effective_Enddate",
		"Flag_Deli", "Comp_Code", "Policy_url_ref", id, "Policy_Barcode", "Policy_url_copy_ref",
		"Par_first_name_1", "Par_last_name_1", "Par_birth_date_1", "Par_occupation_1",
		"Par_first_name_2", "Par_last_name_2", "Par_birth_date_2", "Par_occupation_2",
		"Owner_first_name", "Owner_last_name", "Owner_birth_date",
		"Par_prefix_name_1", "Par_prefix_name_2", "Owner_prefix_name",
		"Owner_address", "Owner_province_id", "Owner_subdistrict_id", "Owner_district_id",
		"Owner_zipcode", "Owner_countryid", "Owner_phone", "Owner_occupation", "Owner_citizen_id",
		"Policy_book", "Par_Driver_license_no_1", "Par_Driver_license_no_2",
		"Receipt_url_ref", "Receipt_url_copy_ref",
		"SF_Epolicy_file_id", "SF_Etax_file_id", "SF_Endorse_type",
		"Par_citizen_id_1", "Par_citizen_id_2", "IIA_Lot_No",
		"Appr_prefix_name", "Appr_first_name", "Appr_last_name",
		par_id, no_cancel_flag, no_cancel_reason, no_cancel_at,
		ref_policy_no, partner_code, cc_ans,
		par_prefix_name_3, par_first_name_3, par_last_name_3, par_birth_date_3, par_citizen_id_3, par_driver_license_no_3, par_occupation_3,
		par_prefix_name_4, par_first_name_4, par_last_name_4, par_birth_date_4, par_citizen_id_4, par_driver_license_no_4, par_occupation_4,
		par_prefix_name_5, par_first_name_5, par_last_name_5, par_birth_date_5, par_citizen_id_5, par_driver_license_no_5, par_occupation_5,
		driver_behavior_1, driver_behavior_2, driver_behavior_3, driver_behavior_4, driver_behavior_5,
		driver_behavior_cal, driver_behavior_disc_perc, driver_behavior_disc_amt,
		car_price, car_price_date, sc_premium_amt, prem_version, oic_version,
		driver_behavior_consent_1, driver_behavior_consent_2, driver_behavior_consent_3, driver_behavior_consent_4, driver_behavior_consent_5,
		bene_occupation,
		par_occupation_code_1, par_occupation_code_2, par_occupation_code_3, par_occupation_code_4, par_occupation_code_5,
		bene_occupation_code,
        par_driver_license_category_1, par_driver_license_category_2, par_driver_license_category_3, par_driver_license_category_4, par_driver_license_category_5
	FROM insurverse."Policy_Header"
	WHERE "Policy_No" = policy_no
	ORDER BY "Effective_Startdate" DESC
	LIMIT 1;
	
	UPDATE insurverse."Policy_Header"
	SET "SF_Policy_id" = SYS_TRANSID,"Effective_Startdate"=now(),"Create_date" = COALESCE("Create_date", now())
	WHERE "Policy_No"=policy_no;
	
	-- 2023-06-14
	UPDATE insurverse."Policy_Header_Trans"
	SET "SF_Policy_id" = policy_no || '-000'
	WHERE "Policy_No"=policy_no AND "SF_Policy_id" IS NULL;
	
	UPDATE insurverse."Policy_coverage_premium"
	SET "Create_date"="Effective_Startdate"
	WHERE "Policy_No"=policy_no and "Create_date" IS NULL;
	
	INSERT INTO insurverse."Policy_coverage_premium_Trans" (
		"Policy_No", "Effective_Startdate", "Effective_Enddate",
		"Brand", "Model", "Year", "Doors", "Seat", "Wg", "Group", "Usage",
		"Type", "BodyType", "GarageType", "NamedAge",
		"MinSI", "MaxSI", "Split",
		"SI_1", "SI_2", "SI_3", "SI_4", "SI_5", "SI_Ans", "SI_Start", "SI_End", "SI_OIC_disct_perc",
		"Prem_OD_1", "Prem_OD_2", "Prem_OD_3", "Prem_OD_4", "Prem_OD_5",
		"OD_Ans", "OD_Start", "OD_End", "OD_OIC_disct_perc", "OD_Amt",
		"Prem_FT_1", "Prem_FT_2", "Prem_FT_3", "Prem_FT_4", "Prem_FT_5",
		"FT_Ans", "FT_Start", "FT_End", "FT_OIC_disct_perc", "FT_Amt",
		"SI_TPBI_1", "SI_TPBI_2", "SI_TPBI_3",
		"Prem_TPBI_1", "Prem_TPBI_2", "Prem_TPBI_3",
		"SI_TPBI_Ans", "SI_TPBI_Start", "SI_TPBI_End", "SI_TPBI_OIC_disct_perc", "SI_TPBI_Amt",
		"SI_TPPD_1", "SI_TPPD_2", "SI_TPPD_3",
		"Prem_TPPD_1", "Prem_TPPD_2", "Prem_TPPD_3",
		"SI_TPPD_Ans", "SI_TPPD_Start", "SI_TPPD_End", "SI_TPPD_OIC_disct_perc", "SI_TPPD_Amt",
		"SI_MV01_1", "SI_MV01_2", "SI_MV01_3",
		"Prem_MV01_1", "Prem_MV01_2", "Prem_MV01_3",
		"SI_MV01_Ans", "SI_MV01_Start", "SI_MV01_End", "SI_MV01_OIC_disct_perc", "SI_MV01_Amt",
		"SI_MV02_1", "SI_MV02_2", "SI_MV02_3",
		"Prem_MV02_1", "Prem_MV02_2", "Prem_MV02_3",
		"SI_MV02_Ans", "SI_MV02_Start", "SI_MV02_End", "SI_MV02_OIC_disct_perc", "SI_MV02_Amt",
		"SI_MV03_1", "SI_MV03_2", "SI_MV03_3",
		"Prem_MV03_1", "Prem_MV03_2", "Prem_MV03_3",
		"SI_MV03_Ans", "SI_MV03_Start", "SI_MV03_End", "SI_MV03_OIC_disct_perc", "SI_MV03_Amt",
		"Sedan", "CC",
		"SI_Access_1", "SI_Access_2", "SI_Access_3",
		"Prem_Access_1", "Prem_Access_2", "Prem_Access_3",
		"SI_Access_Ans", "SI_Access_Start", "SI_Access_End", "SI_Access_OIC_disct_perc", "SI_Access_Amt",
		"Perm_BEF_Discount", "Duty_BEF_Discout", "Vat_BEF_Discout", "Total_BEF_Discout",
		"Discount", "Perm_Amt", "Duty_Amt", "Vat_Amt", "Total_Amt",
		"Payment_status", "Payment_channel", "Payment_type", "Payment_No",
		"Payment_Ref1", "Payment_Ref2", "Payment_result", "Recept_no", "Tax_No",
		"Flex_field1", "Flex_field2", "Flex_field3",
		"Create_date", "Create_by", 
		"Update_date", "Update_by",
		"Fleet_Disc_perc", "NCB_Disc_perc", "Other_Disc_perc", "Surcharge_Amt",
		"Total_Amt_exclude_mv", "Total_Amt_mv",
		"Flag_Car_Act", "Flag_CCTV", "Flag_Driver",
		"Fleet_Disc_Amt", "NCB_Disc_Amt", "Other_Disc_Amt", "Total_Disc_Amt",
		"Lead_No", "NamedAge_Amt",
		"SI_DD_1", "SI_DD_2", "SI_DD_3",
		"Prem_DD_1", "Prem_DD_2", "Prem_DD_3",
		"SI_DD_Ans", "SI_DD_Start", "SI_DD_End", "SI_DD_OIC_disct_perc", "SI_DD_Amt",
		"Flag_Access", "Access_para_code",
		"YOB_Driver_1", "YOB_Driver_2", "Payment_Date",
		"Basic_Premium", "Change_Perm_Amt", "Change_Duty_Amt", "Change_Vat_Amt", "Change_Total_Amt",
		"SI_Limit", "SI_TPBI_Limit", "SI_TPPD_Limit",
		"SI_MV01_Limit", "SI_MV02_Limit", "SI_MV03_Limit", "SI_Access_Limit",
		sf_payment_prem, "Prem_ACT", "SF_Lead", "SI_DD_Limit",
		"CCTV", "Driver_Discount", premium_v5_od, "SF_Policy_id",
		promo_trans_id, promo_discount_per, promo_discount_amt,
		cover_day_count, driver_age, extend_amt,
		"SI_TPBI_E_Limit", "SI_TPBI_E_Amt", basic_premium_v5, cc_ans,
		par_prefix_name_1, par_first_name_1, par_last_name_1, par_birth_date_1, par_citizen_id_1, par_driver_license_no_1, par_occupation_1,
		par_prefix_name_2, par_first_name_2, par_last_name_2, par_birth_date_2, par_citizen_id_2, par_driver_license_no_2, par_occupation_2,
		par_prefix_name_3, par_first_name_3, par_last_name_3, par_birth_date_3, par_citizen_id_3, par_driver_license_no_3, par_occupation_3,
		par_prefix_name_4, par_first_name_4, par_last_name_4, par_birth_date_4, par_citizen_id_4, par_driver_license_no_4, par_occupation_4,
		par_prefix_name_5, par_first_name_5, par_last_name_5, par_birth_date_5, par_citizen_id_5, par_driver_license_no_5, par_occupation_5,
		driver_behavior_1, driver_behavior_2, driver_behavior_3, driver_behavior_4, driver_behavior_5,
		driver_behavior_cal, driver_behavior_disc_perc, driver_behavior_disc_amt,
		car_price, car_price_date,
		sc_premium_amt_1, sc_premium_amt_2, sc_premium_amt_3, sc_premium_amt_4, sc_premium_amt_5, sc_premium_amt_ans,
		prem_version, oic_version,
		driver_behavior_consent_1, driver_behavior_consent_2, driver_behavior_consent_3, driver_behavior_consent_4, driver_behavior_consent_5,
		par_occupation_code_1, par_occupation_code_2, par_occupation_code_3, par_occupation_code_4, par_occupation_code_5,
		sc_premium_amt,
        par_driver_license_category_1, par_driver_license_category_2, par_driver_license_category_3, par_driver_license_category_4, par_driver_license_category_5
	)
	SELECT
		"Policy_No", "Effective_Startdate", "Effective_Enddate",
		"Brand", "Model", "Year", "Doors", "Seat", "Wg", "Group", "Usage",
		"Type", "BodyType", "GarageType", "NamedAge",
		"MinSI", "MaxSI", "Split",
		"SI_1", "SI_2", "SI_3", "SI_4", "SI_5", "SI_Ans", "SI_Start", "SI_End", "SI_OIC_disct_perc",
		"Prem_OD_1", "Prem_OD_2", "Prem_OD_3", "Prem_OD_4", "Prem_OD_5",
		"OD_Ans", "OD_Start", "OD_End", "OD_OIC_disct_perc", "OD_Amt",
		"Prem_FT_1", "Prem_FT_2", "Prem_FT_3", "Prem_FT_4", "Prem_FT_5",
		"FT_Ans", "FT_Start", "FT_End", "FT_OIC_disct_perc", "FT_Amt",
		"SI_TPBI_1", "SI_TPBI_2", "SI_TPBI_3",
		"Prem_TPBI_1", "Prem_TPBI_2", "Prem_TPBI_3",
		"SI_TPBI_Ans", "SI_TPBI_Start", "SI_TPBI_End", "SI_TPBI_OIC_disct_perc", "SI_TPBI_Amt",
		"SI_TPPD_1", "SI_TPPD_2", "SI_TPPD_3",
		"Prem_TPPD_1", "Prem_TPPD_2", "Prem_TPPD_3",
		"SI_TPPD_Ans", "SI_TPPD_Start", "SI_TPPD_End", "SI_TPPD_OIC_disct_perc", "SI_TPPD_Amt",
		"SI_MV01_1", "SI_MV01_2", "SI_MV01_3",
		"Prem_MV01_1", "Prem_MV01_2", "Prem_MV01_3",
		"SI_MV01_Ans", "SI_MV01_Start", "SI_MV01_End", "SI_MV01_OIC_disct_perc", "SI_MV01_Amt",
		"SI_MV02_1", "SI_MV02_2", "SI_MV02_3",
		"Prem_MV02_1", "Prem_MV02_2", "Prem_MV02_3",
		"SI_MV02_Ans", "SI_MV02_Start", "SI_MV02_End", "SI_MV02_OIC_disct_perc", "SI_MV02_Amt",
		"SI_MV03_1", "SI_MV03_2", "SI_MV03_3",
		"Prem_MV03_1", "Prem_MV03_2", "Prem_MV03_3",
		"SI_MV03_Ans", "SI_MV03_Start", "SI_MV03_End", "SI_MV03_OIC_disct_perc", "SI_MV03_Amt",
		"Sedan", "CC",
		"SI_Access_1", "SI_Access_2", "SI_Access_3",
		"Prem_Access_1", "Prem_Access_2", "Prem_Access_3",
		"SI_Access_Ans", "SI_Access_Start", "SI_Access_End", "SI_Access_OIC_disct_perc", "SI_Access_Amt",
		"Perm_BEF_Discount", "Duty_BEF_Discout", "Vat_BEF_Discout", "Total_BEF_Discout",
		"Discount", "Perm_Amt", "Duty_Amt", "Vat_Amt", "Total_Amt",
		"Payment_status", "Payment_channel", "Payment_type", "Payment_No",
		"Payment_Ref1", "Payment_Ref2", "Payment_result", "Recept_no", "Tax_No",
		"Flex_field1", "Flex_field2", "Flex_field3",
		now(), "Create_by", 
		now(), "Update_by",
		"Fleet_Disc_perc", "NCB_Disc_perc", "Other_Disc_perc", "Surcharge_Amt",
		"Total_Amt_exclude_mv", "Total_Amt_mv",
		"Flag_Car_Act", "Flag_CCTV", "Flag_Driver",
		"Fleet_Disc_Amt", "NCB_Disc_Amt", "Other_Disc_Amt", "Total_Disc_Amt",
		"Lead_No", "NamedAge_Amt",
		"SI_DD_1", "SI_DD_2", "SI_DD_3",
		"Prem_DD_1", "Prem_DD_2", "Prem_DD_3",
		"SI_DD_Ans", "SI_DD_Start", "SI_DD_End", "SI_DD_OIC_disct_perc", "SI_DD_Amt",
		"Flag_Access", "Access_para_code",
		"YOB_Driver_1", "YOB_Driver_2", "Payment_Date",
		"Basic_Premium", "Change_Perm_Amt", "Change_Duty_Amt", "Change_Vat_Amt", "Change_Total_Amt",
		"SI_Limit", "SI_TPBI_Limit", "SI_TPPD_Limit",
		"SI_MV01_Limit", "SI_MV02_Limit", "SI_MV03_Limit", "SI_Access_Limit",
		sf_payment_prem, "Prem_ACT", "SF_Lead", "SI_DD_Limit",
		"CCTV", "Driver_Discount", premium_v5_od, "SF_Policy_id",
		promo_trans_id, promo_discount_per, promo_discount_amt,
		cover_day_count, driver_age, extend_amt,
		"SI_TPBI_E_Limit", "SI_TPBI_E_Amt", basic_premium_v5, cc_ans,
		par_prefix_name_1, par_first_name_1, par_last_name_1, par_birth_date_1, par_citizen_id_1, par_driver_license_no_1, par_occupation_1,
		par_prefix_name_2, par_first_name_2, par_last_name_2, par_birth_date_2, par_citizen_id_2, par_driver_license_no_2, par_occupation_2,
		par_prefix_name_3, par_first_name_3, par_last_name_3, par_birth_date_3, par_citizen_id_3, par_driver_license_no_3, par_occupation_3,
		par_prefix_name_4, par_first_name_4, par_last_name_4, par_birth_date_4, par_citizen_id_4, par_driver_license_no_4, par_occupation_4,
		par_prefix_name_5, par_first_name_5, par_last_name_5, par_birth_date_5, par_citizen_id_5, par_driver_license_no_5, par_occupation_5,
		driver_behavior_1, driver_behavior_2, driver_behavior_3, driver_behavior_4, driver_behavior_5,
		driver_behavior_cal, driver_behavior_disc_perc, driver_behavior_disc_amt,
		car_price, car_price_date,
		sc_premium_amt_1, sc_premium_amt_2, sc_premium_amt_3, sc_premium_amt_4, sc_premium_amt_5, sc_premium_amt_ans,
		prem_version, oic_version,
		driver_behavior_consent_1, driver_behavior_consent_2, driver_behavior_consent_3, driver_behavior_consent_4, driver_behavior_consent_5,
		par_occupation_code_1, par_occupation_code_2, par_occupation_code_3, par_occupation_code_4, par_occupation_code_5,
		sc_premium_amt,
        par_driver_license_category_1, par_driver_license_category_2, par_driver_license_category_3, par_driver_license_category_4, par_driver_license_category_5
	FROM insurverse."Policy_coverage_premium"
	WHERE "Policy_No" = policy_no
	ORDER BY "Effective_Startdate" DESC
	LIMIT 1;
	
	-- 2023-07-19
	UPDATE insurverse."Policy_coverage_premium"
	SET "SF_Policy_id" = SYS_TRANSID,"Effective_Startdate"=now(),"Create_date" = COALESCE("Create_date", now())
	WHERE "Policy_No"=policy_no;
	
	-- 2023-07-19
	UPDATE insurverse."Policy_coverage_premium_Trans"
	SET "SF_Policy_id" = policy_no || '-000'
	WHERE "Policy_No"=policy_no AND "SF_Policy_id" IS NULL;
	
	RETURN QUERY SELECT policy_no,SYS_TRANSID;
END
$function$
