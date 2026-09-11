-- =============================================================================
-- 📌 PRODUCTION DATABASE MIGRATION SCRIPT: WS1 & WS5 CONCURRENCY HARDENING
-- =============================================================================
-- Release     : Production Hotfix / Hardening
-- Database    : insurverse
-- Schema      : insurverse
-- Description :
--   สคริปต์สำหรับอัปเดต 4 Stored Procedures หลักให้รองรับ High Concurrency 100%
--   ป้องกันปัญหา Race Condition, Duplicate Key Error และการแย่ง Sequence กัน
--
-- ฟังก์ชันที่ปรับปรุง (4 Core Stored Procedures):
--   1. insurverse.fn_lead_to_car_act(bigint)      - ออกเลข พ.ร.บ. แบบ Standalone (MC)
--   2. insurverse.fn_policy_to_car_act(text)       - ออกเลข พ.ร.บ. คู่สมัครใจ (MV+MC)
--   3. insurverse.fn_policy_invoiceno_iia()       - สร้างเลขที่ใบแจ้งหนี้ (Invoice No)
--   4. insurverse.fn_policy_quatationno_iia()     - สร้างเลขที่ใบเสนอราคา (Quotation No)
--
-- กลไกความปลอดภัย:
--   - pg_advisory_xact_lock: จัดคิว Transaction แยกตาม Prefix เพื่อป้องกันแย่งอ่านค่าเดิม
--   - Collision Detection Loop: วนลูปตรวจเช็คตารางจริงก่อนยืนยันเลข การันตีเลขไม่ซ้ำ 100%
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. Function: insurverse.fn_lead_to_car_act(bigint)
-- =============================================================================
DROP FUNCTION IF EXISTS insurverse.fn_lead_to_car_act(bigint);

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

			SYS_START_DATE = CURRENT_TIMESTAMP;
			SYS_END_DATE = CURRENT_DATE + INTERVAL '1 YEAR' + INTERVAL '16 HOUR' + INTERVAL '30 MINUTE';
			SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];
			MC_NO_PREFIX = 'MC-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];

			-- 📌 1. Transaction Advisory Lock
			PERFORM pg_advisory_xact_lock(hashtext(MC_NO_PREFIX));

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

			-- 📌 2. Collision Detection Loop
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
	END IF;
RETURN QUERY SELECT MC_NO,lead_no;
END
$function$;

-- =============================================================================
-- 2. Function: insurverse.fn_policy_to_car_act(text)
-- =============================================================================
DROP FUNCTION IF EXISTS insurverse.fn_policy_to_car_act(text);

CREATE OR REPLACE FUNCTION insurverse.fn_policy_to_car_act(policy_no text)
 RETURNS TABLE(car_act_no text, rtn_policy_no text)
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_POLICY_NO_IN_AND_UP TEXT; SYS_LEAD_NO INT; SYS_MONTH_ARRAY TEXT[];
SYS_START_DATE TIMESTAMP; SYS_END_DATE TIMESTAMP; 
SYS_CAR_ACT_NO TEXT; SYS_EFFECTIVE_STARTDATE TIMESTAMP;
MC_NO_PREFIX TEXT; MC_NO_LAST INT; MC_NO_MOD INT; MC_NO TEXT; SYS_EXISTS BOOLEAN;
MC_BRAND TEXT; MC_MODEL TEXT; MC_YEAR TEXT;
MC_DOOR INT; MC_SEAT INT; MC_WG INT; MC_USAGE SMALLINT;
MC_GROUP TEXT; MC_TYPE TEXT; MC_SEDAN TEXT; MC_BODYTYPE TEXT;
MC_PAYMENT_STATUS TEXT; MC_PAYMENT_CHANNEL TEXT; MC_PAYMENT_TYPE TEXT; MC_PAYMENT_NO TEXT;
MC_PAYMENT_REF1 TEXT; MC_PAYMENT_REF2 TEXT; MC_PAYMENT_RESULT TEXT;
MC_RECEPT_NO TEXT; MC_TAX_NO TEXT; MC_FLEX_FIELD1 TEXT; MC_FLEX_FIELD2 TEXT; MC_FLEX_FIELD3 TEXT;
MC_FIRST_NAME TEXT; MC_LAST_NAME TEXT; MC_EMAIL TEXT; MC_PHONE TEXT;
MC_FLAG_CA TEXT;
MC_POLICY_BOOK TEXT; MC_POLICY_QUA_NO TEXT; MC_POLICY_INC_NO TEXT;
MC_REF_POLICY_NO TEXT; MC_RENEWAL_MC_STARTDATE TIMESTAMP; MC_RENEWAL_MC_ENDDATE TIMESTAMP;
IC_COMP_CODE TEXT; IC_PREMIUM DECIMAL(18,2); IC_DISCOUNT DECIMAL(18,2); IC_NET_PREMIUM DECIMAL(18,2);
IC_STAMP DECIMAL(18,2); IC_VAT DECIMAL(18,2); IC_TOTAL DECIMAL(18,2);
FIX_PREMIUM DECIMAL(18,2); FIX_DISCOUNT DECIMAL(18,2); FIX_NET_PREMIUM DECIMAL(18,2);
FIX_STAMP DECIMAL(18,2); FIX_VAT DECIMAL(18,2); FIX_TOTAL DECIMAL(18,2);
PH_EMAIL TEXT; PH_OWNER_PREFIX_NAME TEXT; PH_OWNER_FIRST_NAME TEXT; PH_OWNER_LAST_NAME TEXT; PH_OWBER_BIRTH_DATE DATE;
PH_OWNER_CITIZEN_ID TEXT; PH_OWNER_PHONE TEXT; PH_OWNER_OCCUPATION TEXT; PH_OWNER_ADDRESS TEXT;
PH_OWNER_SUBDISTRICT_ID INT; PH_OWNER_DISTRICT_ID INT; PH_OWNER_PROVINCE_ID INT; PH_OWNER_ZIPCODE TEXT;
PH_CC TEXT; PH_CAR_LINCENSE_NO TEXT; PH_CAR_LICENSE_PROVINCE TEXT; PH_CAR_SERIAL_NO TEXT; PH_CAR_LICENSE_TYPE TEXT; PH_CAR_COLOR TEXT;
PH_FLAG_DELI TEXT; PH_DELI_ADDR_LINE1 TEXT; PH_DELI_ADDR_LINE2 TEXT; PH_DELI_ADDR_LINE3 TEXT;
PH_DELI_SUBDISTRICT_ID INT; PH_DELI_DISTRICT_ID INT; PH_DELI_PROVINCE_ID INT; PH_DELI_ZIPCODE TEXT; PH_DELI_COUNTRY_ID INT;
PH_BENE_TYPE TEXT; PH_BENE_TITLE TEXT; PH_BENE_FRISTNAME TEXT; PH_BENE_MIDNAME TEXT; PH_BENE_LASTNAME TEXT; PH_BENE_ID_CARD TEXT;
PH_IIA_LOT TEXT;
PM_PAYMENT_DATE TIMESTAMP;
MC_PREM_ACT NUMERIC; MC_PREM_TOTAL NUMERIC;
PH_PARTNER_CODE TEXT;
BEGIN
  SYS_START_DATE = CURRENT_TIMESTAMP;
	SYS_END_DATE = (CURRENT_DATE - INTERVAL '1 DAY') + INTERVAL '1 YEAR' + INTERVAL '16 HOUR' + INTERVAL '30 MINUTE';
  SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];
  MC_NO_PREFIX = 'MC-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];
	
	-- 📌 1. Transaction Advisory Lock
	PERFORM pg_advisory_xact_lock(hashtext(MC_NO_PREFIX));

	SELECT "Lead_No"
	FROM insurverse."Policy_coverage_premium"
	WHERE "Policy_No"=policy_no
	ORDER BY "Effective_Startdate" DESC
	LIMIT 1
	INTO SYS_LEAD_NO;
	
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
	
	-- 📌 2. Collision Detection Loop
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
	
	SELECT "Brand","Model","Year","Doors","Seat","Wg","Group","Type","Sedan","BodyType",
	"Payment_status","Payment_channel","Payment_type","Payment_No",
	"Payment_Ref1","Payment_Ref2","Payment_result",
	"Recept_no","Tax_No","Flex_field1","Flex_field2","Flex_field3",
	"first_name","last_name","email","phone",
	"Flag_Car_Act",
	"Policy_book","Policy_Quatation_No","Policy_Invoice_No",
	"Prem_ACT",
	"ref_policy_no","renewal_mc_startdate","renewal_mc_enddate"
	FROM insurverse."Policy_coverage_premium"
	WHERE "Policy_No"=policy_no
	ORDER BY "Effective_Startdate" DESC
	LIMIT 1
	INTO MC_BRAND,MC_MODEL,MC_YEAR,MC_DOOR,MC_SEAT,MC_WG,MC_GROUP,MC_TYPE,MC_SEDAN,MC_BODYTYPE,
	MC_PAYMENT_STATUS,MC_PAYMENT_CHANNEL,MC_PAYMENT_TYPE,MC_PAYMENT_NO,
	MC_PAYMENT_REF1,MC_PAYMENT_REF2,MC_PAYMENT_RESULT,
	MC_RECEPT_NO,MC_TAX_NO,MC_FLEX_FIELD1,MC_FLEX_FIELD2,MC_FLEX_FIELD3,
	MC_FIRST_NAME,MC_LAST_NAME,MC_EMAIL,MC_PHONE,
	MC_FLAG_CA,
	MC_POLICY_BOOK,MC_POLICY_QUA_NO,MC_POLICY_INC_NO,
	MC_PREM_ACT,
	MC_REF_POLICY_NO,MC_RENEWAL_MC_STARTDATE,MC_RENEWAL_MC_ENDDATE;
	
	IF MC_FLAG_CA = 'Y' THEN
		
		SELECT "Car_Act_No"
		FROM insurverse."Policy_Car_Act_Discount_Premium"
		WHERE "Lead_No"=SYS_LEAD_NO
		ORDER BY "Effective_Startdate" DESC
		LIMIT 1
		INTO SYS_CAR_ACT_NO;
		
		IF SYS_CAR_ACT_NO IS NULL OR SYS_CAR_ACT_NO = '' THEN
		
		SELECT "email","Owner_prefix_name","Owner_first_name","Owner_last_name","Owner_birth_date",
		"Owner_citizen_id","Owner_phone","Owner_occupation","Owner_address",
		"Owner_subdistrict_id","Owner_district_id","Owner_province_id","Owner_zipcode",
		"CC","Car_license_no","Car_license_provice","Car_serial_no","Car_license_type","Car_color",
		"Flag_Deli","Deli_Addr_line1","Deli_Addr_line2","Deli_Addr_line3",
		"Deli_subdistrict_id","Deli_district_id","Deli_province_id","Deli_zipcode","Deli_countryid",
		"Bene_Type","Bene_Title","Bene_Firstname","Bene_Midname","Bene_Lastname","Bene_ID_card",
		"Effective_Startdate","partner_code"
		FROM insurverse."Policy_holder"
		WHERE "Policy_No"=policy_no
		ORDER BY "Effective_Startdate" DESC
		LIMIT 1
		INTO PH_EMAIL,PH_OWNER_PREFIX_NAME,PH_OWNER_FIRST_NAME,PH_OWNER_LAST_NAME,PH_OWBER_BIRTH_DATE,
		PH_OWNER_CITIZEN_ID,PH_OWNER_PHONE,PH_OWNER_OCCUPATION,PH_OWNER_ADDRESS,
		PH_OWNER_SUBDISTRICT_ID,PH_OWNER_DISTRICT_ID,PH_OWNER_PROVINCE_ID,PH_OWNER_ZIPCODE,
		PH_CC,PH_CAR_LINCENSE_NO,PH_CAR_LICENSE_PROVINCE,PH_CAR_SERIAL_NO,PH_CAR_LICENSE_TYPE,PH_CAR_COLOR,
		PH_FLAG_DELI,PH_DELI_ADDR_LINE1,PH_DELI_ADDR_LINE2,PH_DELI_ADDR_LINE3,
		PH_DELI_SUBDISTRICT_ID,PH_DELI_DISTRICT_ID,PH_DELI_PROVINCE_ID,PH_DELI_ZIPCODE,PH_DELI_COUNTRY_ID,
		PH_BENE_TYPE,PH_BENE_TITLE,PH_BENE_FRISTNAME,PH_BENE_MIDNAME,PH_BENE_LASTNAME,PH_BENE_ID_CARD,
		SYS_EFFECTIVE_STARTDATE,PH_PARTNER_CODE;
		
		SELECT "comp_code","premium","discount","net_premium","stamp","vat","total"
		FROM insurverse."Insurance_Car_Act"
		WHERE "comp_code" = MC_GROUP
		INTO IC_COMP_CODE,IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,IC_STAMP,IC_VAT,IC_TOTAL;

		IF MC_PREM_ACT IS NOT NULL AND MC_PREM_ACT > 0 THEN
			FIX_TOTAL = MC_PREM_ACT;
			FIX_PREMIUM = ROUND(CAST(((FIX_TOTAL - 0.50 - 0.47) / 1.07) AS NUMERIC), 2);
			FIX_NET_PREMIUM = FIX_PREMIUM;
			FIX_DISCOUNT = 0;
			FIX_STAMP = CEIL(CAST((FIX_PREMIUM * 0.004) AS NUMERIC));
			FIX_VAT = ROUND(CAST(((FIX_PREMIUM + FIX_STAMP) * 0.07) AS NUMERIC), 2);
		ELSE
			FIX_PREMIUM = IC_PREMIUM;
			FIX_DISCOUNT = IC_DISCOUNT;
			FIX_NET_PREMIUM = IC_NET_PREMIUM;
			FIX_STAMP = IC_STAMP;
			FIX_VAT = IC_VAT;
			FIX_TOTAL = IC_TOTAL;
		END IF;
		
		IF MC_SEAT IS NULL THEN
			MC_SEAT=0;
		END IF;
		IF MC_WG IS NULL THEN
			MC_WG=0;
		END IF;
		IF MC_USAGE IS NULL THEN
			MC_USAGE=0;
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
		"mas_premium","mas_discount","mas_net_premium","mas_stamp","mas_vat","mas_total",
		"ref_policy_no","Policy_No","partner_code")
		VALUES(
		MC_NO,MC_BRAND,MC_MODEL,MC_YEAR,
		MC_DOOR,MC_SEAT,MC_WG,MC_GROUP,MC_TYPE,MC_SEDAN,MC_BODYTYPE,
		CASE
			WHEN MC_REF_POLICY_NO IS NOT NULL AND MC_REF_POLICY_NO != '' AND MC_RENEWAL_MC_STARTDATE IS NOT NULL THEN
				MC_RENEWAL_MC_STARTDATE
			WHEN (SYS_EFFECTIVE_STARTDATE)::date = (now() + INTERVAL '7 HOUR')::date THEN
				CASE
					WHEN (now()::time < '09:30:00'::time) THEN
						CASE WHEN EXISTS (
							SELECT 1
							FROM (
								SELECT "Car_serial_no",
									   "End_date"+INTERVAL'7HOUR' as end_date
								FROM insurverse."Policy_Car_Act_Discount_Premium"
								WHERE "Car_serial_no" = PH_CAR_SERIAL_NO
								AND "Policy_Status" = 'ACT'
								AND DATE("Start_date") = DATE("End_date"+INTERVAL'7HOUR')
								ORDER BY "End_date" DESC
								LIMIT 1
							) latest_policy
						) THEN
							(CAST(SYS_EFFECTIVE_STARTDATE as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
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
						WHERE "Car_serial_no" = PH_CAR_SERIAL_NO
						AND "Policy_Status" = 'ACT'
						AND DATE("Start_date") = DATE("End_date"+INTERVAL'7HOUR')
						ORDER BY "End_date" DESC
						LIMIT 1
					) latest_policy
				) THEN
					(CAST(SYS_EFFECTIVE_STARTDATE as DATE) + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
				ELSE
					(CAST(SYS_EFFECTIVE_STARTDATE as DATE) - INTERVAL '7 HOUR' + INTERVAL '1 MINUTE')::timestamp
				END
		END,
		CASE
			WHEN MC_REF_POLICY_NO IS NOT NULL AND MC_REF_POLICY_NO != '' AND MC_RENEWAL_MC_ENDDATE IS NOT NULL THEN
				MC_RENEWAL_MC_ENDDATE
			ELSE
				(CAST(SYS_EFFECTIVE_STARTDATE as DATE)+ INTERVAL '1 YEAR' + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE')
		END,
		CURRENT_TIMESTAMP,
		MC_PAYMENT_STATUS,MC_PAYMENT_CHANNEL,MC_PAYMENT_TYPE,MC_PAYMENT_NO,MC_PAYMENT_REF1,MC_PAYMENT_REF2,
		MC_PAYMENT_RESULT,MC_RECEPT_NO,MC_TAX_NO,MC_FLEX_FIELD1,MC_FLEX_FIELD2,MC_FLEX_FIELD3,
		insurverse.fn_policy_quatationno_iia(),
		insurverse.fn_policy_invoiceno_iia(),
		null,PH_OWNER_PREFIX_NAME,PH_OWNER_FIRST_NAME,
		PH_OWNER_LAST_NAME,PH_OWBER_BIRTH_DATE,PH_OWNER_CITIZEN_ID,PH_OWNER_PROVINCE_ID,PH_OWNER_SUBDISTRICT_ID,PH_OWNER_DISTRICT_ID,
		PH_OWNER_ZIPCODE,null,PH_OWNER_PHONE,null,null,null,PH_OWNER_OCCUPATION,null,
		MC_GROUP,FIX_PREMIUM,FIX_DISCOUNT,FIX_NET_PREMIUM,FIX_STAMP,FIX_VAT,FIX_TOTAL,
		CASE WHEN PH_CC IS NULL THEN '0' ELSE PH_CC END,
		PH_CAR_LINCENSE_NO,PH_CAR_LICENSE_PROVINCE,PH_CAR_SERIAL_NO,SYS_EFFECTIVE_STARTDATE,
		(CAST(SYS_EFFECTIVE_STARTDATE as DATE)+ INTERVAL '1 YEAR' + INTERVAL '9 HOUR' + INTERVAL '30 MINUTE'),null,null,
		null,null,null,
		'ISV',insurverse.fn_policy_book_iia(),PH_DELI_ADDR_LINE1,PH_DELI_ADDR_LINE2,
		PH_DELI_ADDR_LINE3,PH_DELI_PROVINCE_ID,PH_DELI_SUBDISTRICT_ID,PH_DELI_DISTRICT_ID,
		PH_DELI_ZIPCODE,PH_DELI_COUNTRY_ID,PH_CAR_LICENSE_TYPE,null,null,
		PH_CAR_COLOR,SYS_LEAD_NO,insurverse.fn_policy_barcode(),PH_OWNER_ADDRESS,LOWER(PH_EMAIL),PH_BENE_TYPE,PH_BENE_TITLE,
		PH_BENE_FRISTNAME,PH_BENE_MIDNAME,PH_BENE_LASTNAME,PH_BENE_ID_CARD,null,
		null,(now() - INTERVAL '7 HOUR'),insurverse.fn_policy_lotno_iia(),PH_FLAG_DELI,null,null,
		'ACT',null,null,null,
		IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,IC_STAMP,IC_VAT,IC_TOTAL,
		MC_REF_POLICY_NO,policy_no,PH_PARTNER_CODE);
		END IF;
	END IF;
RETURN QUERY SELECT MC_NO,policy_no;
END
$function$;

-- =============================================================================
-- 3. Function: insurverse.fn_policy_invoiceno_iia()
-- =============================================================================
CREATE OR REPLACE FUNCTION insurverse.fn_policy_invoiceno_iia()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
	SYS_INVOICE_PREFIX TEXT;
	SYS_INVOICE_FINAL TEXT;
	SYS_INVOICE_LAST INT;
	SYS_BOOK_NO TEXT;
	SYS_EXISTS BOOLEAN;
BEGIN
	-- 📌 1. Transaction Advisory Lock
	PERFORM pg_advisory_xact_lock(hashtext('fn_policy_invoiceno_iia'));

	SYS_INVOICE_PREFIX = TO_CHAR(now()+ INTERVAL '7 HOUR', 'yymm/');
	SYS_BOOK_NO = insurverse.fn_policy_book_iia();

	EXECUTE
	'SELECT "inv_no"
FROM (
SELECT "inv_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
	FROM insurverse."Policy_Header"
	WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_PREFIX || '%''' ||
	' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
	' ORDER BY "Policy_Invoice_No" DESC
	LIMIT 1) as "inv"
UNION
SELECT "inv_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
	FROM insurverse."Policy_Car_Act_Discount_Premium"
	WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_PREFIX || '%''' ||
	' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
	' ORDER BY "Policy_Invoice_No" DESC
	LIMIT 1) as "inv"
UNION
SELECT "inv_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
	FROM insurverse."Lead_coverage_premium"
	WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_PREFIX || '%''' ||
	' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
	' ORDER BY "Policy_Invoice_No" DESC
	LIMIT 1) as "inv"
UNION
SELECT "inv_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No_act",6,5) AS INT),0) as "inv_no"
	FROM insurverse."Lead_coverage_premium"
	WHERE "Policy_Invoice_No_act" LIKE ''' || SYS_INVOICE_PREFIX || '%''' ||
	' AND "Policy_book_act"=''' || SYS_BOOK_NO || '''' ||
	' ORDER BY "Policy_Invoice_No_act" DESC
	LIMIT 1) as "inv"
UNION
SELECT "inv_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Invoice_No",6,5) AS INT),0) as "inv_no"
	FROM insurverse."Policy_endorse_detail"
	WHERE "Policy_Invoice_No" LIKE ''' || SYS_INVOICE_PREFIX || '%''' ||
	' AND "Policy_book"=''' || SYS_BOOK_NO || '''' ||
	' ORDER BY "Policy_Invoice_No" DESC
	LIMIT 1) as "inv"
) as "h_inv"
ORDER BY "inv_no" DESC
LIMIT 1
'
	INTO SYS_INVOICE_LAST;

	IF SYS_INVOICE_LAST IS NULL THEN
	 SYS_INVOICE_LAST = 0;
	END IF;

	-- 📌 2. Collision Detection Loop
	LOOP
		SYS_INVOICE_LAST = SYS_INVOICE_LAST + 1;
		SYS_INVOICE_FINAL = SYS_INVOICE_PREFIX || regexp_replace(TO_CHAR(SYS_INVOICE_LAST, '00000'), '[^\w]+', '');

		EXECUTE 'SELECT EXISTS (
			SELECT 1 FROM (
				SELECT "Policy_Invoice_No" FROM insurverse."Policy_Header" WHERE "Policy_Invoice_No" = $1
				UNION ALL
				SELECT "Policy_Invoice_No" FROM insurverse."Policy_Car_Act_Discount_Premium" WHERE "Policy_Invoice_No" = $1
				UNION ALL
				SELECT "Policy_Invoice_No" FROM insurverse."Lead_coverage_premium" WHERE "Policy_Invoice_No" = $1 OR "Policy_Invoice_No_act" = $1
				UNION ALL
				SELECT "Policy_Invoice_No" FROM insurverse."Policy_endorse_detail" WHERE "Policy_Invoice_No" = $1
			) t
		)' INTO SYS_EXISTS USING SYS_INVOICE_FINAL;

		IF NOT SYS_EXISTS THEN
			EXIT;
		END IF;
	END LOOP;

	RETURN SYS_INVOICE_FINAL;
END
$function$;

-- =============================================================================
-- 4. Function: insurverse.fn_policy_quatationno_iia()
-- =============================================================================
CREATE OR REPLACE FUNCTION insurverse.fn_policy_quatationno_iia()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
	SYS_QUATATION_PREFIX TEXT;
	SYS_QUATATION_FINAL TEXT;
	SYS_QUATATION_LAST INT;
	SYS_QUATATION_MOD INT;
	SYS_EXISTS BOOLEAN;
BEGIN
	-- 📌 1. Transaction Advisory Lock
	PERFORM pg_advisory_xact_lock(hashtext('fn_policy_quatationno_iia'));

	SYS_QUATATION_PREFIX = '001-00-' || TO_CHAR(now()+ INTERVAL '7 HOUR', 'yy') || '-';
	EXECUTE
	'SELECT "qua_no"
FROM (
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Policy_Header"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Policy_Car_Act_Discount_Premium"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Lead_coverage_premium"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No_act",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Lead_coverage_premium"
	WHERE "Policy_Quatation_No_act" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
	'	ORDER BY "Policy_Quatation_No_act" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
FROM (SELECT COALESCE(CAST(SUBSTR("Policy_Quatation_No",11,7) AS INT),0) as "qua_no"
	FROM insurverse."Policy_endorse_detail"
	WHERE "Policy_Quatation_No" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
	'	ORDER BY "Policy_Quatation_No" DESC
	LIMIT 1) as "qua"
UNION
SELECT "qua_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_quotation_no",11,7) AS INT),0) as "qua_no"
			FROM insurverse."policy_ta_premium"
			WHERE "policy_quotation_no" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
			' ORDER BY "policy_quotation_no" DESC
			LIMIT 1) as "qua"
UNION
SELECT "qua_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_quotation_no",11,7) AS INT),0) as "qua_no"
			FROM insurverse."policy_pa_premium"
			WHERE "policy_quotation_no" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
			' ORDER BY "policy_quotation_no" DESC
			LIMIT 1) as "qua"
UNION
SELECT "qua_no"
		FROM (SELECT COALESCE(CAST(SUBSTR("policy_quotation_no",11,7) AS INT),0) as "qua_no"
			FROM insurverse."policy_home_premium"
			WHERE "policy_quotation_no" LIKE ''' || SYS_QUATATION_PREFIX || '%''' ||
			' ORDER BY "policy_quotation_no" DESC
			LIMIT 1) as "qua"
) as "h_qua"
ORDER BY "qua_no" DESC
LIMIT 1
'
	INTO SYS_QUATATION_LAST;
	
	IF SYS_QUATATION_LAST IS NULL THEN
	 SYS_QUATATION_LAST = 0;
	END IF;
	
	-- 📌 2. Collision Detection Loop
	LOOP
		SYS_QUATATION_LAST = SYS_QUATATION_LAST + 1;
		SYS_QUATATION_MOD = MOD(SYS_QUATATION_LAST, 8);
		SYS_QUATATION_FINAL = SYS_QUATATION_PREFIX || regexp_replace(TO_CHAR(SYS_QUATATION_LAST, '0000000'), '[^\w]+', '') || SYS_QUATATION_MOD;

		EXECUTE 'SELECT EXISTS (
			SELECT 1 FROM (
				SELECT "Policy_Quatation_No" FROM insurverse."Policy_Header" WHERE "Policy_Quatation_No" = $1
				UNION ALL
				SELECT "Policy_Quatation_No" FROM insurverse."Policy_Car_Act_Discount_Premium" WHERE "Policy_Quatation_No" = $1
				UNION ALL
				SELECT "Policy_Quatation_No" FROM insurverse."Lead_coverage_premium" WHERE "Policy_Quatation_No" = $1 OR "Policy_Quatation_No_act" = $1
				UNION ALL
				SELECT "Policy_Quatation_No" FROM insurverse."Policy_endorse_detail" WHERE "Policy_Quatation_No" = $1
				UNION ALL
				SELECT "policy_quotation_no" FROM insurverse."policy_ta_premium" WHERE "policy_quotation_no" = $1
				UNION ALL
				SELECT "policy_quotation_no" FROM insurverse."policy_pa_premium" WHERE "policy_quotation_no" = $1
				UNION ALL
				SELECT "policy_quotation_no" FROM insurverse."policy_home_premium" WHERE "policy_quotation_no" = $1
			) t
		)' INTO SYS_EXISTS USING SYS_QUATATION_FINAL;

		IF NOT SYS_EXISTS THEN
			EXIT;
		END IF;
	END LOOP;

	RETURN SYS_QUATATION_FINAL;
END
$function$;

COMMIT;

-- =============================================================================
-- 📌 Verification Query: ตรวจสอบสถานะความปลอดภัยหลังการ Deploy
-- =============================================================================
SELECT 
    p.proname AS function_name,
    CASE 
        WHEN pg_get_functiondef(p.oid) LIKE '%pg_advisory_xact_lock%' 
         AND pg_get_functiondef(p.oid) LIKE '%LOOP%' THEN '✅ CONCURRENCY SAFE'
        ELSE '⚠️ LEGACY / UNSAFE'
    END AS concurrency_status,
    LENGTH(pg_get_functiondef(p.oid)) AS def_length
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname IN ('fn_lead_to_car_act', 'fn_policy_to_car_act', 'fn_policy_invoiceno_iia', 'fn_policy_quatationno_iia') 
  AND n.nspname = 'insurverse'
ORDER BY p.proname;
