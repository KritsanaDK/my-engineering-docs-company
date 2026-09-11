CREATE OR REPLACE FUNCTION insurverse.fn_lead_to_car_act(lead_no bigint)
 RETURNS TABLE(car_act_no text, rtn_lead_no bigint)
 LANGUAGE plpgsql
AS $function$
DECLARE 
SYS_LEAD_NO BIGINT;
SYS_CAR_ACT_LEAD_NO BIGINT;
SYS_START_DATE TIMESTAMP;
SYS_END_DATE TIMESTAMP;
SYS_MONTH_ARRAY TEXT[];
MC_NO_PREFIX TEXT;
MC_NO TEXT;
MC_NO_LAST INT;
MC_NO_MOD INT;
SYS_EXISTS BOOLEAN;

MC_BRAND TEXT; MC_MODEL TEXT; MC_YEAR TEXT;
MC_FIRST_NAME TEXT; MC_LAST_NAME TEXT; MC_EMAIL TEXT; MC_PHONE TEXT;
IC_COMP_CODE TEXT; IC_PREMIUM DECIMAL(18,2); IC_DISCOUNT DECIMAL(18,2); IC_NET_PREMIUM DECIMAL(18,2);
IC_STAMP DECIMAL(18,2); IC_VAT DECIMAL(18,2); IC_TOTAL DECIMAL(18,2);
IC_SEAT INT DEFAULT 0; IC_WG INT DEFAULT 0;
PM_PAYMENT_DATE TIMESTAMP;
 BEGIN
	-- =========================================================================
	-- 📌 ล็อกแบบ Advisory Lock ตั้งแต่จังหวะแรกสุด (Top-Level Concurrency Control)
	-- เหตุผลที่แก้ไข (WS1 Hotfix - Top-Level Lock):
	-- 1. [Early Lock]: คำนวณ Prefix และล็อก pg_advisory_xact_lock ตั้งแต่บรรทัดแรกหลัง BEGIN
	--    ป้องกันกรณีมีการยิง Lead เดียวกันเบิ้ลเข้ามาพร้อมกัน (Concurrent Duplicate Leads)
	--    ไม่ให้หลุดเข้าไปสร้างเลขและ Insert ซ้ำซ้อน
	-- 2. [Idempotency Check]: เมื่อได้ Lock แล้ว ค่อยตรวจสอบว่ามี Car_Act_No สำหรับ Lead นี้อยู่แล้วหรือไม่
	--    หากมีอยู่แล้ว จะข้ามขั้นตอนการ Insert และ Return เลขเดิมทันที
	-- =========================================================================
	SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];
	MC_NO_PREFIX = 'MC-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];

	PERFORM pg_advisory_xact_lock(hashtext(MC_NO_PREFIX));

	SELECT "Car_Act_Lead_No"
	FROM insurverse."Lead_Car_Act_Discount_Premium"
	WHERE "Car_Act_Lead_No"=lead_no and UPPER("Payment_status")='SUCCESS'
	INTO SYS_LEAD_NO;

	IF SYS_LEAD_NO IS NOT NULL AND SYS_LEAD_NO!=0 THEN

		SELECT "Car_Act_No"
		FROM insurverse."Policy_Car_Act_Discount_Premium"
		WHERE "Car_Act_Lead_No"=lead_no
		INTO MC_NO;

		IF MC_NO IS NULL OR MC_NO = '' THEN

			SYS_START_DATE = CURRENT_TIMESTAMP; -- UPDATE FROM Personal Form
			SYS_END_DATE = CURRENT_DATE + INTERVAL '1 YEAR' + INTERVAL '16 HOUR' + INTERVAL '30 MINUTE'; -- UPDATE FROM Personal Form

			EXECUTE
			'SELECT COALESCE(CAST(SUBSTR("Car_Act_No",11,5) AS INT),0)
			FROM insurverse."Policy_Car_Act_Discount_Premium"
			WHERE "Car_Act_No" LIKE ''' || MC_NO_PREFIX || '%''' ||
			'ORDER BY "Car_Act_No" DESC
			LIMIT 1'
			INTO MC_NO_LAST;

			IF MC_NO_LAST IS NULL THEN
			 MC_NO_LAST = 0;
			END IF;

			LOOP
				MC_NO_LAST = MC_NO_LAST + 1;
				MC_NO_MOD = MOD(MC_NO_LAST, 8);
				MC_NO = MC_NO_PREFIX || '-' || regexp_replace(TO_CHAR(MC_NO_LAST, '00000'), '[^\w]+', '') || MC_NO_MOD;

				EXECUTE 'SELECT EXISTS (SELECT 1 FROM insurverse."Policy_Car_Act_Discount_Premium" WHERE "Car_Act_No" = $1)'
				INTO SYS_EXISTS
				USING MC_NO;

				IF NOT SYS_EXISTS THEN
					EXIT;
				END IF;
			END LOOP;

			IF IC_SEAT IS NULL THEN
				IC_SEAT=0;
			END IF;
			IF IC_WG IS NULL THEN
				IC_WG=0;
			END IF;

			INSERT INTO insurverse."Policy_Car_Act_Discount_Premium" ("Car_Act_No","Brand","Model","Year",
		 "Doors","Seat","Wg","Group","Type","Sedan","BodyType","Start_date","End_date","Create_date",
		 "Payment_status","Payment_channel","Payment_type","Payment_No","Payment_Ref1","Payment_Ref2",
		 "Payment_result","Recept_no","Tax_No","Flex_field1","Flex_field2","Flex_field3",
		 "Policy_Quatation_No","Policy_Invoice_No","IIA_Ref_no","prefix_name","first_name",
		 "last_name","birth_date","citizen_id","province_id","subdistrict_id","district_id",
		 "zipcode","countryid","phone","IsKYC","KYC_id","KYC_date","Occupation","Remark",
		 "Car_Comp_Code","Premium","Discount","Net_Premium","Stamp","Vat","Total",
		 "CC","Car_license_no","Car_license_provice","Car_serial_no","Effective_Startdate",
		 "Effective_Enddate","cmi_reference_number","cmi_receive_number",
		 "cmi_endorse_ref_number","cmi_endorse_receive_number","cmi_update_date",
		 "Comp_Code","Policy_book","Deli_Addr_line1","Deli_Addr_line2",
		 "Deli_Addr_line3","Deli_province_id","Deli_subdistrict_id","Deli_district_id",
		 "Deli_zipcode","Deli_countryid","Car_license_type","Policy_Ref_no","Policy_QR_code",
		 "Car_color","Lead_No","Policy_Barcode","address","email","Bene_Type","Bene_Title",
		 "Bene_Firstname","Bene_Midname","Bene_Lastname","Bene_ID_card","SF_Epolicy_file_id",
		 "SF_Etax_file_id","Payment_date","IIA_Lot_No","Flag_Deli","SF_Policy_id","Car_Act_Lead_No",
		 "Policy_Status","promo_trans_id","promo_discount_per","promo_discount_amt",
		 "mas_premium","mas_discount","mas_net_premium","mas_stamp","mas_vat","mas_total","ref_policy_no","oic_version","hp","engineType")
			SELECT MC_NO,"Brand","Model","Year",
		 "Doors",
		 CASE WHEN "Seat" IS NULL THEN CAST(IC_SEAT as INT2) ELSE "Seat" END,
		 CASE WHEN "Wg" IS NULL THEN CAST(IC_WG as INT4) ELSE "Wg" END,
		 "Group","Type","Sedan","BodyType",
		 CASE
			    WHEN "ref_policy_no" IS NOT NULL AND "ref_policy_no" != '' THEN
			        (CAST("Start_date" as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
			    WHEN ("Start_date")::date = (now() + INTERVAL '7 HOUR')::date THEN
			        CASE
			            WHEN (now()::time < '09:30:00'::time) THEN
			                CASE WHEN EXISTS (
			                    SELECT 1
			                    FROM (
			                        SELECT "Car_serial_no",
			                               "End_date"+INTERVAL'7HOUR' as end_date
			                        FROM insurverse."Policy_Car_Act_Discount_Premium"
			                        WHERE "Car_serial_no" = "Car_serial_no"
			                        AND "Policy_Status" = 'ACT'
			                        AND DATE("Start_date") = DATE("End_date"+INTERVAL'7HOUR')
			                        ORDER BY "End_date" DESC
			                        LIMIT 1
			                    ) latest_policy
			                ) THEN
			                    (CAST("Start_date" as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
			                ELSE
			                    now()::timestamp
			                END
			            ELSE
			                now()::timestamp
			        END
			    ELSE
			        CASE WHEN EXISTS (
			            SELECT 1
			            FROM (
			                SELECT "Car_serial_no",
			                       "End_date"+INTERVAL'7HOUR' as end_date
			                FROM insurverse."Policy_Car_Act_Discount_Premium"
			                WHERE "Car_serial_no" = "Car_serial_no"
			                AND "Policy_Status" = 'ACT'
			                AND DATE("Start_date") = DATE("End_date"+INTERVAL'7HOUR')
			                ORDER BY "End_date" DESC
			                LIMIT 1
			            ) latest_policy
			        ) THEN
			            (CAST("Start_date" as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
			        ELSE
			            (CAST("Start_date" as DATE) - INTERVAL '7 HOUR' + INTERVAL '1 MINUTE')::timestamp
			        END
		END,
		 (CAST("Start_date" as DATE)+ INTERVAL '1 YEAR' + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE'),CURRENT_TIMESTAMP,
		 "Payment_status","Payment_channel","Payment_type","Payment_No","Payment_Ref1","Payment_Ref2",
		 "Payment_result","Recept_no","Tax_No","Flex_field1","Flex_field2","Flex_field3",
		 insurverse.fn_policy_quatationno_iia(),
		 insurverse.fn_policy_invoiceno_iia(),
		 "IIA_Ref_no","prefix_name","first_name",
		 "last_name","birth_date","citizen_id","province_id","subdistrict_id","district_id",
		 "zipcode","countryid","phone","IsKYC","KYC_id","KYC_date","Occupation","Remark",
		 "Car_Comp_Code","Premium","Discount","Net_Premium","Stamp","Vat","Total",
		 CASE WHEN "CC" IS NULL THEN '0' ELSE "CC" END,
		 "Car_license_no","Car_license_provice","Car_serial_no",CURRENT_TIMESTAMP,
		 (CAST("Start_date" as DATE)+ INTERVAL '1 YEAR' + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE'),"cmi_reference_number","cmi_receive_number",
		 "cmi_endorse_ref_number","cmi_endorse_receive_number","cmi_update_date",
		 'ISV',insurverse.fn_policy_book_iia(),
		 "Deli_Addr_line1","Deli_Addr_line2",
		 "Deli_Addr_line3","Deli_province_id","Deli_subdistrict_id","Deli_district_id",
		 "Deli_zipcode","Deli_countryid","Car_license_type","Policy_Ref_no","Policy_QR_code",
		 "Car_color","Lead_No",insurverse.fn_policy_barcode(),"address",LOWER("email"),"Bene_Type","Bene_Title",
		 "Bene_Firstname","Bene_Midname","Bene_Lastname","Bene_ID_card","SF_Epolicy_file_id",
		 "SF_Etax_file_id",("Payment_date" - INTERVAL '7 HOUR'),insurverse.fn_policy_lotno_iia(),"Flag_Deli","SF_Policy_id","Car_Act_Lead_No",
		 'ACT',"promo_trans_id","promo_discount_per","promo_discount_amt",
		 "Premium","Discount","Net_Premium","Stamp","Vat","Total","ref_policy_no","oic_version",
		 COALESCE("hp"),
		 COALESCE("engineType", 'ICE')
			FROM insurverse."Lead_Car_Act_Discount_Premium"
			WHERE "Car_Act_Lead_No"=lead_no and "Payment_status"='SUCCESS';
		END IF;

		RETURN QUERY SELECT MC_NO, lead_no;
	END IF;
END;
$function$
;
CREATE OR REPLACE FUNCTION insurverse.fn_lead_to_car_act(lead_no integer)
 RETURNS TABLE(car_act_no text, rtn_lead_no integer)
 LANGUAGE plpgsql
AS $function$
/*
	  EXAMPLE :
		SELECT "car_act_no","rtn_lead_no"
    FROM insurverse.fn_lead_to_car_act(663)
*/
DECLARE
SYS_MONTH_ARRAY TEXT[];
SYS_START_DATE TIMESTAMP;
SYS_END_DATE TIMESTAMP;
SYS_LEAD_NO INT; SYS_CAR_ACT_LEAD_NO INT DEFAULT null;
MC_NO_LAST INT; MC_NO_MOD INT; MC_NO TEXT DEFAULT null;
MC_BRAND TEXT; MC_MODEL TEXT; MC_YEAR TEXT;
MC_DOOR INT; MC_SEAT INT; MC_WG INT;
MC_GROUP TEXT; MC_TYPE TEXT; MC_SEDAN TEXT; MC_BODYTYPE TEXT;
MC_PAYMENT_STATUS TEXT; MC_PAYMENT_CHANNEL TEXT; MC_PAYMENT_TYPE TEXT; MC_PAYMENT_NO TEXT;
MC_PAYMENT_REF1 TEXT; MC_PAYMENT_REF2 TEXT; MC_PAYMENT_RESULT TEXT;
MC_RECEPT_NO TEXT; MC_TAX_NO TEXT; MC_FLEX_FIELD1 TEXT; MC_FLEX_FIELD2 TEXT; MC_FLEX_FIELD3 TEXT;
MC_FIRST_NAME TEXT; MC_LAST_NAME TEXT; MC_EMAIL TEXT; MC_PHONE TEXT;
IC_COMP_CODE TEXT; IC_PREMIUM DECIMAL(18,2); IC_DISCOUNT DECIMAL(18,2); IC_NET_PREMIUM DECIMAL(18,2);
IC_STAMP DECIMAL(18,2); IC_VAT DECIMAL(18,2); IC_TOTAL DECIMAL(18,2);
IC_SEAT INT DEFAULT 0; IC_WG INT DEFAULT 0;
PM_PAYMENT_DATE TIMESTAMP;
 BEGIN
	SELECT "Car_Act_Lead_No"
	FROM insurverse."Lead_Car_Act_Discount_Premium"
	WHERE "Car_Act_Lead_No"=lead_no and UPPER("Payment_status")='SUCCESS'
	INTO SYS_LEAD_NO;

	IF SYS_LEAD_NO IS NOT NULL AND SYS_LEAD_NO!=0 THEN

			SELECT "Car_Act_Lead_No"
			FROM insurverse."Policy_Car_Act_Discount_Premium"
			WHERE "Car_Act_Lead_No"=lead_no
			INTO SYS_CAR_ACT_LEAD_NO;

			IF SYS_CAR_ACT_LEAD_NO IS NULL OR SYS_CAR_ACT_LEAD_NO=0 THEN

			SYS_START_DATE = CURRENT_TIMESTAMP; -- UPDATE FROM Personal Form
			SYS_END_DATE = CURRENT_DATE + INTERVAL '1 YEAR' + INTERVAL '16 HOUR' + INTERVAL '30 MINUTE'; -- UPDATE FROM Personal Form
			SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];
			MC_NO = 'MC-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];

			EXECUTE
			'SELECT COALESCE(CAST(SUBSTR("Car_Act_No",11,5) AS INT),0)
			FROM insurverse."Policy_Car_Act_Discount_Premium"
			WHERE "Car_Act_No" LIKE ''' || MC_NO || '%''' ||
			'ORDER BY "Car_Act_No" DESC
			LIMIT 1'
			INTO MC_NO_LAST;

			IF MC_NO_LAST IS NULL THEN
			 MC_NO_LAST = 0;
			END IF;

			MC_NO_MOD = MOD(MC_NO_LAST+1,8);
			MC_NO = MC_NO || '-' || regexp_replace(TO_CHAR(MC_NO_LAST+1,'00000'), '[^\w]+','') || MC_NO_MOD;

			/*
			SELECT "Comp_Code","Premium","Discount","Net_Premium","Stamp","Vat","Total",
			"Seat","Wg"
			FROM insurverse."Imp_Discount_Premium"
			WHERE "Brand"=MC_BRAND AND "Model"=MC_MODEL AND "Year"=MC_YEAR
			INTO IC_COMP_CODE,IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,
			IC_STAMP,IC_VAT,IC_TOTAL,IC_SEAT,IC_WG;
			*/

			IF IC_SEAT IS NULL THEN
				IC_SEAT=0;
			END IF;
			IF IC_WG IS NULL THEN
				IC_WG=0;
			END IF;

			INSERT INTO insurverse."Policy_Car_Act_Discount_Premium" ("Car_Act_No","Brand","Model","Year",
		 "Doors","Seat","Wg","Group","Type","Sedan","BodyType","Start_date","End_date","Create_date",
		 "Payment_status","Payment_channel","Payment_type","Payment_No","Payment_Ref1","Payment_Ref2",
		 "Payment_result","Recept_no","Tax_No","Flex_field1","Flex_field2","Flex_field3",
		 "Policy_Quatation_No","Policy_Invoice_No","IIA_Ref_no","prefix_name","first_name",
		 "last_name","birth_date","citizen_id","province_id","subdistrict_id","district_id",
		 "zipcode","countryid","phone","IsKYC","KYC_id","KYC_date","Occupation","Remark",
		 "Car_Comp_Code","Premium","Discount","Net_Premium","Stamp","Vat","Total",
		 "CC","Car_license_no","Car_license_provice","Car_serial_no","Effective_Startdate",
		 "Effective_Enddate","cmi_reference_number","cmi_receive_number",
		 "cmi_endorse_ref_number","cmi_endorse_receive_number","cmi_update_date",
		 "Comp_Code","Policy_book","Deli_Addr_line1","Deli_Addr_line2",
		 "Deli_Addr_line3","Deli_province_id","Deli_subdistrict_id","Deli_district_id",
		 "Deli_zipcode","Deli_countryid","Car_license_type","Policy_Ref_no","Policy_QR_code",
		 "Car_color","Lead_No","Policy_Barcode","address","email","Bene_Type","Bene_Title",
		 "Bene_Firstname","Bene_Midname","Bene_Lastname","Bene_ID_card","SF_Epolicy_file_id",
		 "SF_Etax_file_id","Payment_date","IIA_Lot_No","Flag_Deli","SF_Policy_id","Car_Act_Lead_No",
		 "Policy_Status","promo_trans_id","promo_discount_per","promo_discount_amt",
		 "mas_premium","mas_discount","mas_net_premium","mas_stamp","mas_vat","mas_total","ref_policy_no","oic_version","hp","engineType")
			SELECT MC_NO,"Brand","Model","Year",
		 "Doors",
		 CASE WHEN "Seat" IS NULL THEN CAST(IC_SEAT as INT2) ELSE "Seat" END,
		 CASE WHEN "Wg" IS NULL THEN CAST(IC_WG as INT4) ELSE "Wg" END,
		 "Group","Type","Sedan","BodyType",
		 CASE
			    WHEN "ref_policy_no" IS NOT NULL AND "ref_policy_no" != '' THEN
			        (CAST("Start_date" as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
			    WHEN ("Start_date")::date = (now() + INTERVAL '7 HOUR')::date THEN
			        CASE
			            WHEN (now()::time < '09:30:00'::time) THEN
			                CASE WHEN EXISTS (
			                    SELECT 1
			                    FROM (
			                        SELECT "Car_serial_no",
			                               "End_date"+INTERVAL'7HOUR' as end_date
			                        FROM insurverse."Policy_Car_Act_Discount_Premium"
			                        WHERE "Car_serial_no" = "Car_serial_no"
			                        AND "Policy_Status" = 'ACT'
			                        AND DATE("Start_date") = DATE("End_date"+INTERVAL'7HOUR')
			                        ORDER BY "End_date" DESC
			                        LIMIT 1
			                    ) latest_policy
			                ) THEN
			                    (CAST("Start_date" as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
			                ELSE
			                    now()::timestamp
			                END
			            ELSE
			                now()::timestamp
			        END
			    ELSE
			        CASE WHEN EXISTS (
			            SELECT 1
			            FROM (
			                SELECT "Car_serial_no",
			                       "End_date"+INTERVAL'7HOUR' as end_date
			                FROM insurverse."Policy_Car_Act_Discount_Premium"
			                WHERE "Car_serial_no" = "Car_serial_no"
			                AND "Policy_Status" = 'ACT'
			                AND DATE("Start_date") = DATE("End_date"+INTERVAL'7HOUR')
			                ORDER BY "End_date" DESC
			                LIMIT 1
			            ) latest_policy
			        ) THEN
			            (CAST("Start_date" as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
			        ELSE
			            (CAST("Start_date" as DATE) - INTERVAL '7 HOUR' + INTERVAL '1 MINUTE')::timestamp
			        END
		END,
		 (CAST("Start_date" as DATE)+ INTERVAL '1 YEAR' + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE'),CURRENT_TIMESTAMP,
		 "Payment_status","Payment_channel","Payment_type","Payment_No","Payment_Ref1","Payment_Ref2",
		 "Payment_result","Recept_no","Tax_No","Flex_field1","Flex_field2","Flex_field3",
		 --insurverse.fn_policy_quotationno_gen(false,'MC-LEAD-' || "Car_Act_Lead_No"),
		 --insurverse.fn_policy_invoiceno_gen(false,'MC-LEAD-' || "Car_Act_Lead_No",insurverse.fn_policy_book_iia()),
		 insurverse.fn_policy_quatationno_iia(), -- Backup Before new gen QUO
		 insurverse.fn_policy_invoiceno_iia(), -- Backup Before new gen INV
		 "IIA_Ref_no","prefix_name","first_name",
		 "last_name","birth_date","citizen_id","province_id","subdistrict_id","district_id",
		 "zipcode","countryid","phone","IsKYC","KYC_id","KYC_date","Occupation","Remark",
		 "Car_Comp_Code","Premium","Discount","Net_Premium","Stamp","Vat","Total",
		 CASE WHEN "CC" IS NULL THEN '0' ELSE "CC" END,
		 "Car_license_no","Car_license_provice","Car_serial_no",CURRENT_TIMESTAMP,
		 (CAST("Start_date" as DATE)+ INTERVAL '1 YEAR' + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE'),"cmi_reference_number","cmi_receive_number",
		 "cmi_endorse_ref_number","cmi_endorse_receive_number","cmi_update_date",
		 'ISV',insurverse.fn_policy_book_iia(),
		 "Deli_Addr_line1","Deli_Addr_line2",
		 "Deli_Addr_line3","Deli_province_id","Deli_subdistrict_id","Deli_district_id",
		 "Deli_zipcode","Deli_countryid","Car_license_type","Policy_Ref_no","Policy_QR_code",
		 "Car_color","Lead_No",insurverse.fn_policy_barcode(),"address",LOWER("email"),"Bene_Type","Bene_Title",
		 "Bene_Firstname","Bene_Midname","Bene_Lastname","Bene_ID_card","SF_Epolicy_file_id",
		 "SF_Etax_file_id",("Payment_date" - INTERVAL '7 HOUR'),insurverse.fn_policy_lotno_iia(),"Flag_Deli","SF_Policy_id","Car_Act_Lead_No",
		 'ACT',"promo_trans_id","promo_discount_per","promo_discount_amt",
		 "Premium","Discount","Net_Premium","Stamp","Vat","Total","ref_policy_no","oic_version",
		 COALESCE("hp"),
         COALESCE("engineType", 'ICE')
			FROM insurverse."Lead_Car_Act_Discount_Premium"
			WHERE "Car_Act_Lead_No"=lead_no and "Payment_status"='SUCCESS';
		END IF;
	END IF;
RETURN QUERY SELECT MC_NO,lead_no;
END
$function$
;
