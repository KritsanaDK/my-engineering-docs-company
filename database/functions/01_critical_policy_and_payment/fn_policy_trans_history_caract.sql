-- =============================================================================
-- Function: insurverse.fn_policy_trans_history_caract
-- OID: 18804
-- Identity Arguments: (car_act_no text)
-- Returns: TABLE(rtn_car_act_no text, trans_id text)
-- Language: plpgsql
-- Categorization: 01_critical_policy_and_payment
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_trans_history_caract(car_act_no text)
 RETURNS TABLE(rtn_car_act_no text, trans_id text)
 LANGUAGE plpgsql
AS $function$
DECLARE SYS_TRANSID TEXT;
BEGIN
	SYS_TRANSID = insurverse.fn_policy_transid_sf_mc("car_act_no");

	UPDATE insurverse."Policy_Car_Act_Discount_Premium_Trans"
	SET "Create_date"="Effective_Startdate"
	WHERE "Car_Act_No"=car_act_no and "Create_date" IS NULL;

    INSERT INTO insurverse."Policy_Car_Act_Discount_Premium_Trans" (
        "Car_Act_No", "Policy_No", "Brand", "Model", "Year", "Doors", "Seat", "Wg", "Group", "Type",
        "Sedan", "BodyType", "Start_date", "End_date",
        "Create_date",
        "Create_by", "Update_date", "Update_by", "Payment_status", "Payment_channel", "Payment_type",
        "Payment_No", "Payment_Ref1", "Payment_Ref2", "Payment_result", "Recept_no", "Tax_No",
        "Flex_field1", "Flex_field2", "Flex_field3", "Policy_Quatation_No", "Policy_Invoice_No",
        "IIA_Ref_no", "prefix_name", "first_name", "last_name", "birth_date", "citizen_id",
        "province_id", "subdistrict_id", "district_id", "zipcode", "countryid", "phone", "IsKYC",
        "KYC_id", "KYC_date", "Occupation", "Remark", "Car_Comp_Code", "Premium", "Discount",
        "Net_Premium", "Stamp", "Vat", "Total", "CC", "Car_license_no", "Car_license_provice",
        "Car_serial_no", "Effective_Startdate", "Effective_Enddate", "cmi_reference_number",
        "cmi_receive_number", "cmi_endorse_ref_number", "cmi_endorse_receive_number",
        "cmi_update_date", "Comp_Code", "Policy_book", "Deli_Addr_line1", "Deli_Addr_line2",
        "Deli_Addr_line3", "Deli_province_id", "Deli_subdistrict_id", "Deli_district_id",
        "Deli_zipcode", "Deli_countryid", "Car_license_type", "Policy_Ref_no", "Policy_QR_code",
        "Car_color", "Lead_No", "Policy_url_ref", "Policy_Barcode", "Policy_url_copy_ref",
        "address", "email", "Bene_Type", "Bene_Title", "Bene_Firstname", "Bene_Midname",
        "Bene_Lastname", "Bene_ID_card", "Receipt_url_ref", "Receipt_url_copy_ref",
        "SF_Epolicy_file_id", "SF_Etax_file_id", "Payment_date", "IIA_Lot_No", "Flag_Deli",
        "SF_Policy_id", "Car_Act_Lead_No", "Policy_Status", "Appr_prefix_name", "Appr_first_name",
        "Appr_last_name", "cmi_status", "Change_Perm_Amt", "Change_Duty_Amt", "Change_Vat_Amt",
        "Change_Total_Amt", "par_id", "promo_trans_id", "promo_discount_per", "promo_discount_amt",
        "no_cancel_flag", "no_cancel_reason", "no_cancel_at", "Extend_Start", "Extend_End",
        "extend_amt", "mas_premium", "mas_discount", "mas_net_premium", "mas_stamp", "mas_vat",
        "mas_total", "ref_policy_no", "partner_code",
        "engineType", "hp", "customer_id"
    )
    SELECT
        "Car_Act_No", "Policy_No", "Brand", "Model", "Year", "Doors", "Seat", "Wg", "Group", "Type",
        "Sedan", "BodyType", "Start_date", "End_date",
        NOW() AS "Create_date",  -- Create date in Main table don't change
        "Create_by", "Update_date", "Update_by", "Payment_status", "Payment_channel", "Payment_type",
        "Payment_No", "Payment_Ref1", "Payment_Ref2", "Payment_result", "Recept_no", "Tax_No",
        "Flex_field1", "Flex_field2", "Flex_field3", "Policy_Quatation_No", "Policy_Invoice_No",
        "IIA_Ref_no", "prefix_name", "first_name", "last_name", "birth_date", "citizen_id",
        "province_id", "subdistrict_id", "district_id", "zipcode", "countryid", "phone", "IsKYC",
        "KYC_id", "KYC_date", "Occupation", "Remark", "Car_Comp_Code", "Premium", "Discount",
        "Net_Premium", "Stamp", "Vat", "Total", "CC", "Car_license_no", "Car_license_provice",
        "Car_serial_no", "Effective_Startdate", "Effective_Enddate", "cmi_reference_number",
        "cmi_receive_number", "cmi_endorse_ref_number", "cmi_endorse_receive_number",
        "cmi_update_date", "Comp_Code", "Policy_book", "Deli_Addr_line1", "Deli_Addr_line2",
        "Deli_Addr_line3", "Deli_province_id", "Deli_subdistrict_id", "Deli_district_id",
        "Deli_zipcode", "Deli_countryid", "Car_license_type", "Policy_Ref_no", "Policy_QR_code",
        "Car_color", "Lead_No", "Policy_url_ref", "Policy_Barcode", "Policy_url_copy_ref",
        "address", "email", "Bene_Type", "Bene_Title", "Bene_Firstname", "Bene_Midname",
        "Bene_Lastname", "Bene_ID_card", "Receipt_url_ref", "Receipt_url_copy_ref",
        "SF_Epolicy_file_id", "SF_Etax_file_id", "Payment_date", "IIA_Lot_No", "Flag_Deli",
        "SF_Policy_id", "Car_Act_Lead_No", "Policy_Status", "Appr_prefix_name", "Appr_first_name",
        "Appr_last_name", "cmi_status", "Change_Perm_Amt", "Change_Duty_Amt", "Change_Vat_Amt",
        "Change_Total_Amt", "par_id", "promo_trans_id", "promo_discount_per", "promo_discount_amt",
        "no_cancel_flag", "no_cancel_reason", "no_cancel_at", "Extend_Start", "Extend_End",
        "extend_amt", "mas_premium", "mas_discount", "mas_net_premium", "mas_stamp", "mas_vat",
        "mas_total", "ref_policy_no", "partner_code",
        "engineType", "hp", "customer_id"
    FROM insurverse."Policy_Car_Act_Discount_Premium"
    WHERE "Car_Act_No"=car_act_no
    ORDER BY "Effective_Startdate" DESC
    LIMIT 1;

	UPDATE insurverse."Policy_Car_Act_Discount_Premium"
	SET "SF_Policy_id" = SYS_TRANSID,"Effective_Startdate"=now()
	WHERE "Car_Act_No"=car_act_no;

	-- 2023-06-14
	UPDATE insurverse."Policy_Car_Act_Discount_Premium_Trans"
	SET "SF_Policy_id" = car_act_no || '-000'
	WHERE "Car_Act_No"=car_act_no AND "SF_Policy_id" IS NULL;

	RETURN QUERY SELECT car_act_no,SYS_TRANSID;
END
$function$
