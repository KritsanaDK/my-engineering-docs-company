-- =============================================================================
-- Function: insurverse.fn_sf_policy_endorse
-- OID: 18875
-- Identity Arguments: (policy_no text, type text, owner_prefix_name text, owner_first_name text, owner_last_name text, owner_address text, owner_province_id text, owner_province_name text, owner_district_id text, owner_district_name text, owner_subdistrict_id text, owner_subdistrict_name text, owner_zipcode text, car_license_no text, car_license_provice text, car_brand text, car_model text, car_cc text, start_date text, end_date text, appr_prefix_name text, appr_first_name text, appr_last_name text, car_serial_no text, effective_date text)
-- Returns: TABLE(log_running_no integer, msg text, sf_trans_id text, endorse_doc_type text, out_policy_type text, out_policy_no text, out_car_act_no text, endorse_doc_type_name text, endorse_doc_type_short text)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_sf_policy_endorse(policy_no text, type text, owner_prefix_name text, owner_first_name text, owner_last_name text, owner_address text, owner_province_id text, owner_province_name text, owner_district_id text, owner_district_name text, owner_subdistrict_id text, owner_subdistrict_name text, owner_zipcode text, car_license_no text, car_license_provice text, car_brand text, car_model text, car_cc text, start_date text, end_date text, appr_prefix_name text, appr_first_name text, appr_last_name text, car_serial_no text, effective_date text)
 RETURNS TABLE(log_running_no integer, msg text, sf_trans_id text, endorse_doc_type text, out_policy_type text, out_policy_no text, out_car_act_no text, endorse_doc_type_name text, endorse_doc_type_short text)
 LANGUAGE plpgsql
AS $function$
	/*
	2023-04-14 23:28 
	Add Return Table
	Add Param car_serial_no
	
	Example ::
	SELECT "log_running_no","msg","sf_trans_id","endorse_doc_type"
	FROM insurverse.fn_sf_policy_endorse(param...)
	--RETURN TABLE (RUNNING_NO, MSG, SF_TRANS_ID, ENDORSE_DOC_TYPE)
	--RUNNING_NO if RUNNING_NO=0 Policy_No or Car_Act_No not found
	*/
	DECLARE 
	RUNNING_NO INT; MSG TEXT; SF_TRANS_ID TEXT; ENDORSE_DOC_TYPE TEXT;
	IN_POLICY_NO TEXT DEFAULT ''; IN_CAR_ACT_NO TEXT DEFAULT ''; IN_POLICY_TYPE TEXT;
	POLICY_TYPE TEXT;
	PH_POLICY_NO TEXT; CA_CAR_ACT_NO TEXT;
	OLD_PERM_AMT NUMERIC(18,2); OLD_DUTY_AMT NUMERIC(18,2); OLD_VAT_AMT NUMERIC(18,2); OLD_TOTAL_AMT NUMERIC(18,2);
	UP_POLICY_NO TEXT; UP_TRANS_ID TEXT;
	NEW_PERM_AMT NUMERIC(18,2); NEW_DUTY_AMT NUMERIC(18,2); NEW_VAT_AMT NUMERIC(18,2); NEW_TOTAL_AMT NUMERIC(18,2);
	DETAIL_RESULT TEXT;
	
	array_doc_type TEXT;
	DOC_TYPE_NAME TEXT; RTN_DOC_TYPE TEXT DEFAULT '';
	RTN_DOC_TYPE_SHORT TEXT DEFAULT ''; RTN_DOC_TYPE_NAME TEXT DEFAULT '';
	REC_FA RECORD; DOC_TYPE TEXT; FLAG_CANCEL BOOL DEFAULT FALSE;
	FLAG_ENDORSE_EFF_DATE TEXT DEFAULT 'n';
	FLAG_ENDORSE_17 TEXT DEFAULT 'n';
	FLAG_ENDORSE_19 TEXT DEFAULT 'n';
	FLAG_ENDORSE_23 TEXT DEFAULT 'n';
	ONCE_ENDORSE_TXT TEXT DEFAULT '';
	
	UPDATE_QUERY_MV TEXT DEFAULT ''; UPDATE_QUERY_MVC TEXT DEFAULT ''; UPDATE_QUERY_MC TEXT DEFAULT '';
	
	COVER_DAY INT DEFAULT 0; COVER_MONTH INT DEFAULT 0;
	CANCEL_STARTDATE TIMESTAMP; CANCEL_ENDDATE TIMESTAMP;
	CANCEL_DATE TIMESTAMP;
	RETURN_PER NUMERIC;
	CHANGE_PERM_AMT NUMERIC(18,2); CHANGE_DUTY_AMT NUMERIC(18,2);
	CHANGE_VAT_AMT NUMERIC(18,2); CHANGE_TOTAL_AMT NUMERIC(18,2);
	SYS_EFF_DATE TIMESTAMP;
	BEGIN
	
	IF "policy_no" IS NOT NULL AND SUBSTR("policy_no",1,2) = 'MV' THEN
		IN_POLICY_NO = "policy_no";
		
		-- Check Policy_No
		SELECT "policy"."Policy_No","policy"."Type","policy"."Policy_Startdate","policy"."Policy_Enddate",
		"prem"."Perm_Amt","prem"."Duty_Amt","prem"."Vat_Amt","prem"."Total_Amt"
		FROM insurverse."Policy_Header" as "policy"
		INNER JOIN insurverse."Policy_coverage_premium" as "prem"
		ON "policy"."Policy_No"="prem"."Policy_No"
		WHERE "policy"."Policy_No"=IN_POLICY_NO
		INTO PH_POLICY_NO,POLICY_TYPE,CANCEL_STARTDATE,CANCEL_ENDDATE,
		OLD_PERM_AMT,OLD_DUTY_AMT,OLD_VAT_AMT,OLD_TOTAL_AMT;
		
		IF PH_POLICY_NO IS NULL OR PH_POLICY_NO = '' THEN
			MSG = 'Policy_No not found.';
			IN_POLICY_TYPE = 'F';
		ELSE
			IN_POLICY_TYPE = 'V';
		END IF;
		
	ELSIF "policy_no" IS NOT NULL AND SUBSTR("policy_no",1,2) = 'MC' THEN
		IN_CAR_ACT_NO = "policy_no";
		
		-- Check Car_Act_No
		SELECT "Car_Act_No","Start_date","End_date",
		"Net_Premium","Stamp","Vat","Total"
		FROM insurverse."Policy_Car_Act_Discount_Premium"
		WHERE "Car_Act_No"=IN_CAR_ACT_NO
		INTO CA_CAR_ACT_NO,CANCEL_STARTDATE,CANCEL_ENDDATE,
		OLD_PERM_AMT,OLD_DUTY_AMT,OLD_VAT_AMT,OLD_TOTAL_AMT;
		
		IF CA_CAR_ACT_NO IS NULL OR CA_CAR_ACT_NO = '' THEN
			MSG = 'Policy_No not found.';
			IN_POLICY_TYPE = 'F';
		ELSE
			POLICY_TYPE = '0';
			IN_POLICY_TYPE = 'C';
		END IF;
	ELSE 
		IN_POLICY_NO = "policy_no";
		MSG = 'Policy_No not found.';
		IN_POLICY_TYPE = 'F';
	END IF;
	
	IF "type" IS NULL OR "type" = '' THEN
		MSG = 'type is empty.';
		IN_POLICY_TYPE = 'F';
	END IF;
	
	IF "start_date" = '' THEN
		start_date = null;
	END IF;
	
	IF "end_date" = '' THEN
		end_date = null;
	END IF;
	
	IF "effective_date" = '' THEN
		effective_date = null;
	END IF;
	
	
	INSERT INTO insurverse."log_sf_policy_trans"
	("policy_no" , "car_act_no", "policy_type" , "type" , "owner_prefix_name" ,
	"owner_first_name" , "owner_last_name" , "owner_address" , "owner_province_id" ,
	"owner_province_name" , "owner_district_id" , "owner_district_name" , "owner_subdistrict_id" ,
	"owner_subdistrict_name" , "owner_zipcode" , "car_license_no" , "car_license_provice" ,
	"car_brand" , "car_model" , "car_cc" , "start_date" , "end_date" , "appr_prefix_name" ,
	"appr_first_name" , "appr_last_name","car_serial_no","effective_date")
	VALUES (IN_POLICY_NO , IN_CAR_ACT_NO , IN_POLICY_TYPE,"type" , "owner_prefix_name" ,
	"owner_first_name" , "owner_last_name" , "owner_address" , "owner_province_id" ,
	"owner_province_name" , "owner_district_id" , "owner_district_name" , "owner_subdistrict_id" ,
	"owner_subdistrict_name" , "owner_zipcode" , "car_license_no" , "car_license_provice" ,
	"car_brand" , "car_model" , "car_cc" , "start_date" , "end_date" , "appr_prefix_name" ,
	"appr_first_name" , "appr_last_name","car_serial_no","effective_date")
  RETURNING id
	INTO RUNNING_NO;
	
	
	array_doc_type = CAST("type" as TEXT);
	
	IF array_doc_type IS NOT NULL AND array_doc_type != '' THEN
	
			IF "effective_date" is null OR "effective_date" = '' THEN
				SYS_EFF_DATE=now();
			ELSE
				--SYS_EFF_DATE=CAST("effective_date" AS TIMESTAMP) - INTERVAL '7 HOUR';
				SYS_EFF_DATE=CAST("effective_date" AS TIMESTAMP);
			END IF;
	
		for REC_FA in SELECT regexp_replace(LOWER(CAST("json_a".value as TEXT)), '"','', 'g') as "field_name"
		FROM json_array_elements(array_doc_type::json) as "json_a"
		LOOP 
			IF REC_FA.field_name IS NOT NULL AND REC_FA.field_name != '' THEN
				
				-- Effective Date
				IF REC_FA.field_name = 'effectivedate' THEN
					FLAG_ENDORSE_EFF_DATE = 'y';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Effective_Startdate"=''' || SYS_EFF_DATE || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Effective_Startdate"=''' || SYS_EFF_DATE || '''';
					UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Effective_Startdate"=''' || SYS_EFF_DATE || '''';
				END IF;
				
				-- 11
				IF REC_FA.field_name = 'cancellation' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='11') THEN
					FLAG_CANCEL = 'y';
					ONCE_ENDORSE_TXT='11';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Policy_Status"=''INC''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Policy_Status"=''INC''';
				END IF;
				
				-- 17
				IF REC_FA.field_name = 'carlicenseno' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17') THEN
					FLAG_ENDORSE_17 = 'y';
					ONCE_ENDORSE_TXT='17';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Car_license_no"=''' || "car_license_no" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Car_license_no"=''' || "car_license_no" || '''';
				END IF;
				IF REC_FA.field_name = 'carlicenseprovice' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17') THEN
					FLAG_ENDORSE_17 = 'y';
					ONCE_ENDORSE_TXT='17';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Car_license_provice"=''' || "car_license_provice" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Car_license_provice"=''' || "car_license_provice" || '''';
				END IF;
				IF REC_FA.field_name = 'carserialno' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17') THEN
					FLAG_ENDORSE_17 = 'y';
					ONCE_ENDORSE_TXT='17';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Car_serial_no"=''' || "car_serial_no" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Car_serial_no"=''' || "car_serial_no" || '''';
				END IF;
				IF REC_FA.field_name = 'carbrand' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17') THEN
					FLAG_ENDORSE_17 = 'y';
					ONCE_ENDORSE_TXT='17';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Brand"=''' || "car_brand" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Brand"=''' || "car_brand" || '''';
					UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Brand"=''' || "car_brand" || '''';
				END IF;
				IF REC_FA.field_name = 'carmodel' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17') THEN
					FLAG_ENDORSE_17 = 'y';
					ONCE_ENDORSE_TXT='17';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Model"=''' || "car_model" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Model"=''' || "car_model" || '''';
					UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Model"=''' || "car_model" || '''';
				END IF;
				IF REC_FA.field_name = 'carcc' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17') THEN
					FLAG_ENDORSE_17 = 'y';
					ONCE_ENDORSE_TXT='17';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"CC"=''' || "car_cc" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"CC"=''' || "car_cc" || '''';
				END IF;
				
				-- 19
				IF REC_FA.field_name = 'startdate' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='19') THEN
					FLAG_ENDORSE_19 = 'y';
					ONCE_ENDORSE_TXT='19';
					--"start_date" = CAST("start_date" AS TIMESTAMP) - INTERVAL '7 HOUR';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Policy_Startdate"=''' || "start_date" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Start_date"=''' || "start_date" || '''';
				END IF;
				IF REC_FA.field_name = 'enddate' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='19') THEN
					FLAG_ENDORSE_19 = 'y';
					ONCE_ENDORSE_TXT='19';
					--"end_date" = CAST("end_date" AS TIMESTAMP) - INTERVAL '7 HOUR';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Policy_Enddate"=''' || "end_date" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"End_date"=''' || "end_date" || '''';
					UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Effective_Enddate"=''' || "end_date" || '''';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Effective_Enddate"=''' || "end_date" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Effective_Enddate"=''' || "end_date" || '''';
				END IF;
				
				-- 23
				IF REC_FA.field_name = 'ownerprefixname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_prefix_name"=''' || "owner_prefix_name" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"prefix_name"=''' || "owner_prefix_name" || '''';
				END IF;
				IF REC_FA.field_name = 'ownerfirstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_first_name"=''' || "owner_first_name" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"first_name"=''' || "owner_first_name" || '''';
				END IF;
				IF REC_FA.field_name = 'ownerlastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_last_name"=''' || "owner_last_name" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"last_name"=''' || "owner_last_name" || '''';
				END IF;
				IF REC_FA.field_name = 'owneraddress' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_address"=''' || "owner_address" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"address"=''' || "owner_address" || '''';
				END IF;
				IF REC_FA.field_name = 'ownerprovinceid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_province_id"=''' || "owner_province_id" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"province_id"=''' || "owner_province_id" || '''';
				END IF;
				IF REC_FA.field_name = 'ownerdistrictid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_district_id"=''' || "owner_district_id" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"district_id"=''' || "owner_district_id" || '''';
				END IF;
				IF REC_FA.field_name = 'ownersubdistrictid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_subdistrict_id"=''' || "owner_subdistrict_id" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"subdistrict_id"=''' || "owner_subdistrict_id" || '''';
				END IF;
				IF REC_FA.field_name = 'ownerzipcode' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
					FLAG_ENDORSE_23 = 'y';
					ONCE_ENDORSE_TXT='23';
					UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_zipcode"=''' || "owner_zipcode" || '''';
					UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"zipcode"=''' || "owner_zipcode" || '''';
				END IF;
				
			END IF;
		end loop;
  END IF;
	
	IF FLAG_ENDORSE_EFF_DATE = 'n' THEN
		SYS_EFF_DATE=now();
	END IF;
	
	IF FLAG_CANCEL = 'y' THEN
		IF POLICY_TYPE = '0' THEN
		  RTN_DOC_TYPE = 'v0_11'; -- ปร1ยกเลิก 
		ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
			RTN_DOC_TYPE = 'v5_11'; -- รยภ01ยกเลิก
		ELSE
			RTN_DOC_TYPE = 'v1_11'; -- รย11ยกเลิก
		END IF;
		
		IF FLAG_ENDORSE_EFF_DATE = 'y' THEN
			CANCEL_DATE = SYS_EFF_DATE;
		ELSE
			CANCEL_DATE = now();
		END IF;
		
		IF CAST(CAST(CANCEL_STARTDATE as TIMESTAMP) + INTERVAL '7 HOUR' as TIMESTAMP)::date >= CAST(CAST(CANCEL_DATE as TIMESTAMP) + INTERVAL '7 HOUR' as TIMESTAMP)::date THEN
			-- Change Amt ใบลดหนี้ กรณีคืนเต็ม
			CHANGE_PERM_AMT = OLD_PERM_AMT;
			CHANGE_DUTY_AMT = OLD_DUTY_AMT;
			CHANGE_VAT_AMT = OLD_VAT_AMT;
			CHANGE_TOTAL_AMT = OLD_TOTAL_AMT;
		ELSE
			IF IN_POLICY_TYPE = 'V' THEN
				COVER_DAY = EXTRACT(DAY FROM date_trunc('day',CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)) + '00:00:00' - date_trunc('day',CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' AS TIMESTAMP)) + '00:00:00');
				
				SELECT "oic_return"."Perc_return"
				FROM insurverse."OIC_Perc_Return_by_Day" as "oic_return"
				WHERE "oic_return"."Range_start"<=COVER_DAY AND "oic_return"."Range_end">=COVER_DAY
				INTO RETURN_PER;
				
				-- Change Amt ใบลดหนี้ กรณีคืนไม่เต็มจำนวน
				CHANGE_PERM_AMT = FLOOR(OLD_PERM_AMT * (RETURN_PER/100));
				CHANGE_DUTY_AMT = 0.00;
				CHANGE_VAT_AMT = CHANGE_PERM_AMT * 0.07;
				CHANGE_TOTAL_AMT = CHANGE_PERM_AMT + CHANGE_VAT_AMT;
			END IF;
			IF IN_POLICY_TYPE = 'C' THEN
				IF (EXTRACT(MONTH FROM DATE_TRUNC('month', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP))) != EXTRACT(MONTH FROM DATE_TRUNC('month', CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))
						AND EXTRACT(DAY FROM DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP))) < EXTRACT(DAY FROM DATE_TRUNC('day', CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP))))
						OR EXTRACT(DAY FROM DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP))) > EXTRACT(DAY FROM DATE_TRUNC('day', CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))
					THEN COVER_MONTH = (EXTRACT(YEAR FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))) * 12) + EXTRACT(MONTH FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))) + 1;
					ELSE COVER_MONTH = (EXTRACT(YEAR FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))) * 12) + EXTRACT(MONTH FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(CANCEL_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP))));
				END IF;
				
				SELECT "oic_return"."Perc_return"
				FROM insurverse."OIC_Perc_Return_Act_by_Day" as "oic_return"
				WHERE "oic_return"."Range_start"<=COVER_MONTH AND "oic_return"."Range_end">=COVER_MONTH
				INTO RETURN_PER;
				
				-- Change Amt ใบลดหนี้ กรณีคืนไม่เต็มจำนวน
				CHANGE_PERM_AMT = FLOOR(OLD_PERM_AMT * (RETURN_PER/100));
				CHANGE_DUTY_AMT = 0.00;
				CHANGE_VAT_AMT = CHANGE_PERM_AMT * 0.07;
				CHANGE_TOTAL_AMT = CHANGE_PERM_AMT + CHANGE_VAT_AMT;
			END IF;
		END IF;
		
		CHANGE_PERM_AMT = CHANGE_PERM_AMT * -1;
		CHANGE_DUTY_AMT = CHANGE_DUTY_AMT * -1;
		CHANGE_VAT_AMT = CHANGE_VAT_AMT * -1;
		CHANGE_TOTAL_AMT = CHANGE_TOTAL_AMT * -1;
		
		IF CANCEL_DATE < CANCEL_STARTDATE THEN
			CANCEL_DATE = CANCEL_STARTDATE;
		END IF;
		
		UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Policy_Startdate"=''' || CANCEL_DATE || '''';
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Start_date"=''' || CANCEL_DATE || '''';
				
		NEW_PERM_AMT = OLD_PERM_AMT + CHANGE_PERM_AMT;
		NEW_DUTY_AMT = OLD_DUTY_AMT + CHANGE_DUTY_AMT;
		NEW_VAT_AMT = OLD_VAT_AMT + CHANGE_VAT_AMT;
		NEW_TOTAL_AMT = NEW_PERM_AMT + NEW_DUTY_AMT + NEW_VAT_AMT;
		
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Net_Premium"=' || NEW_PERM_AMT;
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Stamp"=' || NEW_DUTY_AMT;
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Vat"=' || NEW_VAT_AMT;
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Total"=' || NEW_TOTAL_AMT;
		
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Perm_Amt"=' || NEW_PERM_AMT;
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Duty_Amt"=' || NEW_DUTY_AMT;
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Vat_Amt"=' || NEW_VAT_AMT;
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Total_Amt"=' || NEW_TOTAL_AMT;
		
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Perm_Amt"=' || CHANGE_PERM_AMT;
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Duty_Amt"=' || CHANGE_DUTY_AMT;
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Vat_Amt"=' || CHANGE_VAT_AMT;
		UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Total_Amt"=' || CHANGE_TOTAL_AMT;
		
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Change_Perm_Amt"=' || CHANGE_PERM_AMT;
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Change_Duty_Amt"=' || CHANGE_DUTY_AMT;
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Change_Vat_Amt"=' || CHANGE_VAT_AMT;
		UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Change_Total_Amt"=' || CHANGE_TOTAL_AMT;

	ELSE
		IF FLAG_ENDORSE_17 = 'y' THEN
			IF POLICY_TYPE = '0' THEN
				RTN_DOC_TYPE = 'v0_17'; -- ปร1 รย17
			ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
				RTN_DOC_TYPE = 'v5_17'; -- รยภ01 รย17
			ELSE
				RTN_DOC_TYPE = 'v1_17'; -- รย17
			END IF;
		ELSIF FLAG_ENDORSE_19 = 'y' THEN
			IF POLICY_TYPE = '0' THEN
				RTN_DOC_TYPE = 'v0_19'; -- ปร1 รย19
			ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
				RTN_DOC_TYPE = RTN_DOC_TYPE || 'v5_19'; -- รยภ01 รย19
			ELSE
				RTN_DOC_TYPE = 'v1_19'; -- รย19
			END IF;
		ELSIF FLAG_ENDORSE_23 = 'y' THEN
			IF POLICY_TYPE = '0' THEN
				RTN_DOC_TYPE = 'v0_23'; -- ปร1 รย23
			ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
				RTN_DOC_TYPE = 'v5_23'; -- รยภ01 รย23
			ELSE
				RTN_DOC_TYPE = 'v1_23'; -- รย23
			END IF;
		END IF;
	END IF;
	
	IF RTN_DOC_TYPE IS NULL OR RTN_DOC_TYPE = '' THEN
				RTN_DOC_TYPE = 'not_found';
	END IF;
	
	--RUNNING_NO = 1;
	
	IF IN_POLICY_TYPE != 'F' AND RTN_DOC_TYPE IS NOT NULL AND RTN_DOC_TYPE != '' AND RTN_DOC_TYPE != 'not_found' THEN
		ENDORSE_DOC_TYPE = RTN_DOC_TYPE;
		IF IN_POLICY_TYPE = 'V' THEN
			IF UPDATE_QUERY_MV IS NOT NULL AND UPDATE_QUERY_MV != '' THEN
				SELECT "rtn_policy_no","trans_id"
				FROM insurverse."fn_policy_trans_history_head"(IN_POLICY_NO)
				INTO UP_POLICY_NO,UP_TRANS_ID;
				
				EXECUTE
				'UPDATE insurverse."Policy_Header"
				SET "Update_date"=now(),
				"Appr_prefix_name"=''' || "appr_prefix_name" || ''','
				'"Appr_first_name"=''' || "appr_first_name" || ''','
				'"Appr_last_name"=''' || "appr_last_name" || ''''
				|| UPDATE_QUERY_MV || '
				WHERE "Policy_No"=''' || IN_POLICY_NO || '''';
				
				IF UPDATE_QUERY_MVC IS NOT NULL AND UPDATE_QUERY_MVC != '' THEN
					EXECUTE
					'UPDATE insurverse."Policy_coverage_premium"
					SET  "Update_date"=now()' 
					|| UPDATE_QUERY_MVC || '
					WHERE "Policy_No"=''' || IN_POLICY_NO || '''';
				END IF;
				
				SELECT insurverse.fn_sf_policy_endorse_detail(UP_POLICY_NO, IN_POLICY_TYPE,RTN_DOC_TYPE,UP_TRANS_ID,CHANGE_TOTAL_AMT,SYS_EFF_DATE)
				INTO DETAIL_RESULT;
			END IF;
		ELSIF IN_POLICY_TYPE = 'C' THEN
			IF UPDATE_QUERY_MC IS NOT NULL AND UPDATE_QUERY_MC != '' THEN
				SELECT "rtn_car_act_no","trans_id"
				FROM insurverse."fn_policy_trans_history_caract"(IN_CAR_ACT_NO)
				INTO UP_POLICY_NO,UP_TRANS_ID;
			
				EXECUTE
				'UPDATE insurverse."Policy_Car_Act_Discount_Premium"
				SET "Update_date"=now(),
				"Appr_prefix_name"=''' || "appr_prefix_name" || ''','
				'"Appr_first_name"=''' || "appr_first_name" || ''','
				'"Appr_last_name"=''' || "appr_last_name" || '''' 
				|| UPDATE_QUERY_MC || '
				WHERE "Car_Act_No"=''' || IN_CAR_ACT_NO || '''';
				
				SELECT insurverse.fn_sf_policy_endorse_detail(IN_CAR_ACT_NO, IN_POLICY_TYPE,RTN_DOC_TYPE,UP_TRANS_ID,CHANGE_TOTAL_AMT,SYS_EFF_DATE)
				INTO DETAIL_RESULT;
			END IF;

		END IF;
		
		UPDATE insurverse."log_sf_policy_trans"
		SET sf_trans_id=UP_TRANS_ID,"doc_type"=RTN_DOC_TYPE
		WHERE "id"=RUNNING_NO;
	
	ELSE
		RUNNING_NO = 0;
	END IF;
	
	SELECT "para_name","para_desc"
	FROM insurverse.sys_param
	WHERE "para_code"=ENDORSE_DOC_TYPE
	INTO RTN_DOC_TYPE_SHORT,RTN_DOC_TYPE_NAME;

	RETURN QUERY SELECT RUNNING_NO,MSG,UP_TRANS_ID,ENDORSE_DOC_TYPE,IN_POLICY_TYPE,IN_POLICY_NO,IN_CAR_ACT_NO,RTN_DOC_TYPE_NAME,RTN_DOC_TYPE_SHORT;
END
$function$
