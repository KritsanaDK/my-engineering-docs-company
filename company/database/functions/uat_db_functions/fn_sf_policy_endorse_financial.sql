CREATE OR REPLACE FUNCTION insurverse.fn_sf_policy_endorse_financial(policy_no text, type text, owner_prefix_name text, owner_first_name text, owner_last_name text, owner_address text, owner_province_id text, owner_province_name text, owner_district_id text, owner_district_name text, owner_subdistrict_id text, owner_subdistrict_name text, owner_zipcode text, car_license_no text, car_license_provice text, car_brand text, car_model text, car_cc text, start_date text, end_date text, appr_prefix_name text, appr_first_name text, appr_last_name text, car_serial_no text, effective_date text, owner_birthdate text, owner_card_id text, deli_address text, deli_province_id text, deli_subdistrict_id text, deli_district_id text, deli_zipcode text, bene_type text, bene_firstname text, bene_lastname text, par1_prefix text, par1_firstname text, par1_lastname text, par1_driver_no text, par1_driver_license_category text, par2_prefix text, par2_firstname text, par2_lastname text, par2_driver_no text, par2_driver_license_category text, salesforce_id text, car_color text, car_license_type text, appr_status text, appr_comment text, drive_action text, coverage_detail text, deli_flag text, bene_title text, par1_citizen_id text, par2_citizen_id text, par3_prefix text, par4_prefix text, par3_firstname text, par3_lastname text, par3_driver_no text, par3_driver_license_category text, par3_citizen_id text, par4_firstname text, par4_lastname text, par4_driver_no text, par4_driver_license_category text, par4_citizen_id text, par5_prefix text, par5_firstname text, par5_lastname text, par5_driver_no text, par5_driver_license_category text, par5_citizen_id text, sc_premium_amt text, garage_type text, package_id text, par1_occupation text, par2_occupation text, par3_occupation text, par4_occupation text, par5_occupation text, driver_brithdate1 text, driver_brithdate2 text, driver_birthdate3 text, driver_birthdate4 text, driver_birthdate5 text, driver_behavior1 text, driver_behavior2 text, driver_behavior3 text, driver_behavior4 text, driver_behavior5 text, driver_consent1 text, driver_consent2 text, driver_consent3 text, driver_consent4 text, driver_consent5 text, owner_occupation text, hp integer DEFAULT NULL::integer, refund_type text DEFAULT NULL::text)
 RETURNS TABLE(log_running_no integer, msg text, sf_trans_id text, endorse_doc_type text, out_policy_type text, out_policy_no text, out_car_act_no text, endorse_doc_type_name text, endorse_doc_type_short text, endorse_salesforce_id text, doc_group_type text)
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
    SF_ID TEXT; SF_APPR_STATUS TEXT; SF_APPR_COMMENT TEXT;
    MP_PAR_ID INT;
    POLICY_TYPE TEXT;
    PH_POLICY_NO TEXT; CA_CAR_ACT_NO TEXT;
    OLD_PERM_AMT NUMERIC(18,2); OLD_DUTY_AMT NUMERIC(18,2); OLD_VAT_AMT NUMERIC(18,2); OLD_TOTAL_AMT NUMERIC(18,2);
    UP_POLICY_NO TEXT; UP_TRANS_ID TEXT;
    NEW_PERM_AMT NUMERIC(18,2); NEW_DUTY_AMT NUMERIC(18,2); NEW_VAT_AMT NUMERIC(18,2); NEW_TOTAL_AMT NUMERIC(18,2);
    DETAIL_RESULT TEXT;
    
    -- R2.5 PARAM
    CV_PRV_CC TEXT; OLD_DRIVER_1_FIRSTNAME TEXT; OLD_DRIVER_2_FIRSTNAME TEXT;
    CAR_LIC_NAME TEXT; P_USAGE TEXT;
    
    array_doc_type TEXT;
    DOC_TYPE_NAME TEXT; RTN_DOC_TYPE TEXT DEFAULT '';
    RTN_DOC_TYPE_SHORT TEXT DEFAULT ''; RTN_DOC_TYPE_NAME TEXT DEFAULT '';
    REC_FA RECORD; DOC_TYPE TEXT; FLAG_CANCEL BOOL DEFAULT FALSE;
    LOOP_COVER RECORD;
    FLAG_CHANGE_OWNER TEXT DEFAULT 'n';
    FLAG_ENDORSE_EFF_DATE TEXT DEFAULT 'n';
    FLAG_ENDORSE_17 TEXT DEFAULT 'n';
    FLAG_ENDORSE_19 TEXT DEFAULT 'n';
    FLAG_ENDORSE_23 TEXT DEFAULT 'n';
    -- R2.5
    FLAG_ENDORSE_00_T TEXT DEFAULT 'n';
  FLAG_ENDORSE_00_NT TEXT DEFAULT 'n';
    FLAG_ENDORSE_17_NT TEXT DEFAULT 'n';
    FLAG_ENDORSE_23_T TEXT DEFAULT 'n';
    FLAG_ENDORSE_23_NT TEXT DEFAULT 'n';
    FLAG_ENDORSE_05 TEXT DEFAULT 'n';
    FLAG_ENDORSE_18 TEXT DEFAULT 'n';
    FLAG_ENDORSE_20 TEXT DEFAULT 'n';
    FLAG_ENDORSE_24 TEXT DEFAULT 'n';
    FLAG_ENDORSE_26 TEXT DEFAULT 'n';
    FLAG_ENDORSE_27 TEXT DEFAULT 'n';
    FLAG_ENDORSE_28 TEXT DEFAULT 'n';
    FLAG_ENDORSE_COVER TEXT DEFAULT 'n';
    FLAG_ENDORSE_COVER_FIELD TEXT DEFAULT 'n';
    ONCE_ENDORSE_TXT TEXT DEFAULT '';
    FLAG_TOTAL_AMT_ERR TEXT DEFAULT 'n';
    -- R2.5 CR
    FLAG_ENDORSE_18_C TEXT DEFAULT 'n';
    FLAG_ENDORSE_18_P TEXT DEFAULT 'n';
    FLAG_ENDORSE_20_A TEXT DEFAULT 'n';
    OLD_FLAG_CCTV text; OLD_FLAG_ACCESS text; OLD_ACCESS_PARA_CODE text;
    
    UPDATE_QUERY_MV TEXT DEFAULT ''; UPDATE_QUERY_MVC TEXT DEFAULT ''; 
    UPDATE_QUERY_MVC_1 TEXT DEFAULT ''; UPDATE_QUERY_MVC_2 TEXT DEFAULT ''; 
    UPDATE_QUERY_MVC_3 TEXT DEFAULT ''; UPDATE_QUERY_MC TEXT DEFAULT '';
    UPDATE_QUERY_MP TEXT DEFAULT '';
    
    COVER_DAY INT DEFAULT 0; COVER_MONTH INT DEFAULT 0;
    PREV_POLICY_STARTDATE TIMESTAMP; PREV_POLICY_ENDDATE TIMESTAMP;
    CANCEL_DATE TIMESTAMP;
    EXTEND_STARTDATE TIMESTAMP; EXTEND_ENDDATE TIMESTAMP;
    RETURN_PER NUMERIC;
    CHANGE_PERM_AMT NUMERIC(18,2); CHANGE_DUTY_AMT NUMERIC(18,2);
    CHANGE_VAT_AMT NUMERIC(18,2); CHANGE_TOTAL_AMT NUMERIC(18,2);
    SYS_EFF_DATE TIMESTAMP;
    
    C_FIELD_NAME TEXT;
    C_POLICY_TYPE TEXT;
    C_COVERAGE_DAY_COUNT INT;
    C_CAR_BRAND TEXT;
    C_CAR_MODEL TEXT;
    C_GARAGE_TYPE TEXT;
    C_BASIC_PREM_AMT NUMERIC;
    C_BASIC_PREM_V5_AMT NUMERIC;
    C_PREMIUM_V5_OD NUMERIC;
    C_USAGE TEXT;
    C_USAGE_TARIFF NUMERIC;
    C_CAR_CC TEXT;
    C_CAR_CC_CONDITION TEXT;
    C_CAR_CC_TARIFF NUMERIC;
    C_DRIVER_BRITHDATE1 DATE;
    C_DRIVER_BRITHDATE2 DATE;
    C_DRIVER_CITIZEN1 TEXT;
    C_DRIVER_CITIZEN2 TEXT;
    C_DRIVER_CITIZEN3 TEXT;
    C_DRIVER_CITIZEN4 TEXT;
    C_DRIVER_CITIZEN5 TEXT;
    C_DRIVER_AGE TEXT;
    C_DRIVER_AGE_DISC NUMERIC;
    C_DRIVER_AGE_TARIFF NUMERIC;
    C_CAR_YEAR TEXT;
    C_CAR_YEAR_TARIFF NUMERIC;
    C_SI_AMT NUMERIC;
    C_OD_AMT NUMERIC;
    C_FT_AMT NUMERIC;
    C_ACCESS_HAVE BOOL;
    C_ACCESS_SI_AMT NUMERIC;
    C_ACCESS_PREM_AMT NUMERIC;
    C_ACCESS_NAME JSON;
    C_SI_TARIFF NUMERIC;
    C_SI_V5_TARIFF NUMERIC;
    C_CAR_GROUP TEXT;
    C_CAR_GROUP_TARIFF NUMERIC;
    C_TPBI_PASS_SI_AMT NUMERIC;
    C_TPBI_PASS_PREM_AMT NUMERIC;
    C_TPBI_PASS_TARIFF NUMERIC;
    C_TPBI_EVENT_SI_AMT NUMERIC;
    C_TPBI_EVENT_PREM_AMT NUMERIC;
    C_TPBI_EVENT_TARIFF NUMERIC;
    C_TPPD_SI_AMT NUMERIC;
    C_TPPD_PREM_AMT NUMERIC;
    C_TPPD_TARIFF NUMERIC;
    C_TOTAL_EX_MV_AMT NUMERIC;
    C_MV01_SI_AMT NUMERIC;
    C_MV01_PREM_AMT NUMERIC;
    C_MV02_SI_AMT NUMERIC;
    C_MV02_PREM_AMT NUMERIC;
    C_MV03_SI_AMT NUMERIC;
    C_MV03_PREM_AMT NUMERIC;
    C_CCTV_HAVE BOOL;
    C_CCTV_PERCENT NUMERIC;
    C_TOTAL_MV_AMT NUMERIC;
    C_FLEET_DISC_PER NUMERIC;
    C_FLEET_DISC_AMT NUMERIC;
    C_NCB_DISC_PER NUMERIC;
    C_NCB_DISC_AMT NUMERIC;
    C_OTHER_DISC_PER NUMERIC;
    C_OTHER_DISC_AMT NUMERIC;
    C_TOTAL_DISC_AMT NUMERIC;
    C_EXTEND_ENDDATE TIMESTAMP;
    C_EXTEND_DAY_COUNT INT;
    C_EXTEND_PREM_AMT NUMERIC;
    C_PREM_AMT NUMERIC;
    C_DUTY_AMT NUMERIC;
    C_VAT_PER NUMERIC;
    C_VAT_AMT NUMERIC;
    C_TOTAL_AMT NUMERIC;
    C_DRIVER_BEHAVIOR_SUMMARY INTEGER;
    C_DRIVER_BEHAVIOR_TARIFF NUMERIC;
    C_DRIVER_BEHAVIOR_DISC NUMERIC;

    -- cr21
    OIC_VERSION TEXT;
    IS_NEW_OIC BOOL = false;
	
	RTN_CCTV_ACTION TEXT DEFAULT '';
	RTN_ACCESSORY_ACTION TEXT DEFAULT '';
    
    BEGIN
    SF_ID="salesforce_id";
    SF_APPR_STATUS="appr_status";
    SF_APPR_COMMENT="appr_comment";
    IF "policy_no" IS NOT NULL AND SUBSTR("policy_no",1,2) = 'MV' THEN
        IN_POLICY_NO = "policy_no";
        
        -- Check Policy_No
        SELECT "policy"."Policy_No","policy"."Type","policy"."Policy_Startdate","policy"."Policy_Enddate",
        "prem"."Perm_Amt","prem"."Duty_Amt","prem"."Vat_Amt","prem"."Total_Amt","Extend_Start","Extend_End",
        "policy"."par_id","prem"."Usage", "policy"."oic_version"
        FROM insurverse."Policy_Header" as "policy"
        INNER JOIN insurverse."Policy_coverage_premium" as "prem"
        ON "policy"."Policy_No"="prem"."Policy_No"
        WHERE "policy"."Policy_No"=IN_POLICY_NO
        INTO PH_POLICY_NO,POLICY_TYPE,PREV_POLICY_STARTDATE,PREV_POLICY_ENDDATE,
        OLD_PERM_AMT,OLD_DUTY_AMT,OLD_VAT_AMT,OLD_TOTAL_AMT,EXTEND_STARTDATE,EXTEND_ENDDATE,
        MP_PAR_ID,P_USAGE,OIC_VERSION;
        
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
        "Net_Premium","Stamp","Vat","Total","Extend_Start","Extend_End",
        "par_id",insurverse.fn_comp_to_usage("Car_Comp_Code")
        FROM insurverse."Policy_Car_Act_Discount_Premium"
        WHERE "Car_Act_No"=IN_CAR_ACT_NO
        INTO CA_CAR_ACT_NO,PREV_POLICY_STARTDATE,PREV_POLICY_ENDDATE,
        OLD_PERM_AMT,OLD_DUTY_AMT,OLD_VAT_AMT,OLD_TOTAL_AMT,EXTEND_STARTDATE,EXTEND_ENDDATE,
        MP_PAR_ID,P_USAGE;
        
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

    -- is new oic
    IF OIC_VERSION IS NOT NULL THEN
        IS_NEW_OIC = true;
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
    "appr_first_name" , "appr_last_name","car_serial_no","effective_date",
    -- R2.5
    "owner_birthdate","owner_card_id","deli_address","deli_province_id","deli_subdistrict_id","deli_district_id","deli_zipcode",
    "bene_type","bene_firstname","bene_lastname","par1_prefix","par1_firstname","par1_lastname","par1_driver_no","par1_driver_license_category",
    "par2_prefix","par2_firstname","par2_lastname","par2_driver_no","par2_driver_license_category","salesforce_id",
    "car_color","car_license_type","appr_status","appr_comment","drive_action",
    "coverage_detail",
    deli_flag,
    -- CR21
    "bene_title","par1_citizen_id","par2_citizen_id","par3_prefix","par4_prefix","par3_firstname","par3_lastname","par3_driver_no","par3_driver_license_category","par3_citizen_id",
    "par4_firstname","par4_lastname","par4_driver_no","par4_driver_license_category","par4_citizen_id","par5_prefix","par5_firstname","par5_lastname","par5_driver_no","par5_driver_license_category","par5_citizen_id",
    "sc_premium_amt","garage_type","package_id","par1_occupation","par2_occupation","par3_occupation","par4_occupation","par5_occupation",
    "driver_behavior1","driver_behavior2","driver_behavior3","driver_behavior4","driver_behavior5",
    "driver_birthdate1","driver_birthdate2","driver_birthdate3","driver_birthdate4","driver_birthdate5",
    "driver_consent1","driver_consent2","driver_consent3","driver_consent4","driver_consent5",
    "owner_occupation","refund_type")
    VALUES (IN_POLICY_NO , IN_CAR_ACT_NO , IN_POLICY_TYPE,"type" , "owner_prefix_name" ,
    "owner_first_name" , "owner_last_name" , "owner_address" , "owner_province_id" ,
    "owner_province_name" , "owner_district_id" , "owner_district_name" , "owner_subdistrict_id" ,
    "owner_subdistrict_name" , "owner_zipcode" , "car_license_no" , "car_license_provice" ,
    "car_brand" , "car_model" , "car_cc" , "start_date" , "end_date" , "appr_prefix_name" ,
    "appr_first_name" , "appr_last_name","car_serial_no","effective_date",
    -- R2.5
    "owner_birthdate","owner_card_id","deli_address","deli_province_id","deli_subdistrict_id","deli_district_id","deli_zipcode",
    "bene_type","bene_firstname","bene_lastname","par1_prefix","par1_firstname","par1_lastname","par1_driver_no","par1_driver_license_category",
    "par2_prefix","par2_firstname","par2_lastname","par2_driver_no","par2_driver_license_category","salesforce_id",
    "car_color","car_license_type","appr_status","appr_comment","drive_action",
    CAST((CASE WHEN "coverage_detail"='' THEN NULL ELSE "coverage_detail" END) AS JSON),
    deli_flag,
    -- CR21
    "bene_title","par1_citizen_id","par2_citizen_id","par3_prefix","par4_prefix","par3_firstname","par3_lastname","par3_driver_no","par3_driver_license_category","par3_citizen_id",
    "par4_firstname","par4_lastname","par4_driver_no","par4_driver_license_category","par4_citizen_id","par5_prefix","par5_firstname","par5_lastname","par5_driver_no","par5_driver_license_category","par5_citizen_id",
    "sc_premium_amt","garage_type","package_id","par1_occupation","par2_occupation","par3_occupation","par4_occupation","par5_occupation",
    "driver_behavior1","driver_behavior2","driver_behavior3","driver_behavior4","driver_behavior5",
    "driver_brithdate1","driver_brithdate2","driver_birthdate3","driver_birthdate4","driver_birthdate5",
    "driver_consent1","driver_consent2","driver_consent3","driver_consent4","driver_consent5",
    "owner_occupation","refund_type")
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
        
        /*
        IF PREV_POLICY_STARTDATE > SYS_EFF_DATE AND PREV_POLICY_STARTDATE > now() AND (start_date is null or start_date = '') THEN
            SYS_EFF_DATE = PREV_POLICY_STARTDATE;
        ELSIF PREV_POLICY_STARTDATE > SYS_EFF_DATE AND PREV_POLICY_STARTDATE <= now() AND (start_date is null or start_date = '') THEN
            SYS_EFF_DATE = now();
        ELSIF start_date is not null and CAST(start_date AS TIMESTAMP) > SYS_EFF_DATE AND CAST(start_date AS TIMESTAMP) > now() THEN
            SYS_EFF_DATE = CAST(start_date AS TIMESTAMP);
        ELSIF start_date is not null and CAST(start_date AS TIMESTAMP) > SYS_EFF_DATE AND CAST(start_date AS TIMESTAMP) <= now() THEN
            SYS_EFF_DATE = now();
        END IF;
        */
        --MSG = 'Effective : ' || TO_CHAR(SYS_EFF_DATE,'dd/mm/yyyy hh24:mi:ss') || ' - Start Date : ' || TO_CHAR(PREV_POLICY_STARTDATE,'dd/mm/yyyy hh24:mi:ss');
    
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
                /*
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
                */
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
                    UPDATE_QUERY_MP = UPDATE_QUERY_MP || ',"owner_prefix_name"=''' || "owner_prefix_name" || '''';
                END IF;
                IF REC_FA.field_name = 'ownerfirstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23 = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_first_name"=''' || "owner_first_name" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"first_name"=''' || "owner_first_name" || '''';
                    UPDATE_QUERY_MP = UPDATE_QUERY_MP || ',"owner_first_name"=''' || "owner_first_name" || '''';
                END IF;
                IF REC_FA.field_name = 'ownerlastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23 = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_last_name"=''' || "owner_last_name" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"last_name"=''' || "owner_last_name" || '''';
                    UPDATE_QUERY_MP = UPDATE_QUERY_MP || ',"owner_last_name"=''' || "owner_last_name" || '''';
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
                
                -- R2.5
                IF REC_FA.field_name = 'ownerbirthdate' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_NT = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_birth_date"=''' || "owner_birthdate" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"birth_date"=''' || "owner_birthdate" || '''';
                    UPDATE_QUERY_MP = UPDATE_QUERY_MP || ',"owner_birth_date"=''' || "owner_birthdate" || '''';
                END IF;
                IF REC_FA.field_name = 'ownercardid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_T = 'y';
                    ONCE_ENDORSE_TXT='23';
                    FLAG_CHANGE_OWNER='y';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_citizen_id"=''' || "owner_card_id" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"citizen_id"=''' || "owner_card_id" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"par_id"=null';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_id"=null';
                END IF;
                IF REC_FA.field_name = 'carcolor' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                    FLAG_ENDORSE_17_NT = 'y';
                    ONCE_ENDORSE_TXT='17';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Car_color"=''' || "car_color" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Car_color"=''' || "car_color" || '''';
                END IF;
                IF REC_FA.field_name = 'carlicensetype' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                    SELECT "para_name" FROM insurverse.sys_param 
                    WHERE "dom_code"='Policy' AND "sub_dom_code"='Car_license_type'
                        AND ("para_code"="car_license_type" OR "para_name"="car_license_type")
                    INTO CAR_LIC_NAME;
                    IF CAR_LIC_NAME IS NOT NULL THEN
                        FLAG_ENDORSE_17_NT = 'y';
                        ONCE_ENDORSE_TXT='17';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Car_license_type"=''' || CAR_LIC_NAME || '''';
                        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Car_license_type"=''' || CAR_LIC_NAME || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'deliflag' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_NT = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Flag_Deli"=''' || UPPER("deli_flag") || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Flag_Deli"=''' || UPPER("deli_flag") || '''';
                END IF;
                IF REC_FA.field_name = 'deliaddress' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_NT = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Deli_Addr_line1"=''' || "deli_address" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Deli_Addr_line1"=''' || "deli_address" || '''';
                END IF;
                IF REC_FA.field_name = 'deliprovinceid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_NT = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Deli_province_id"=''' || "deli_province_id" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Deli_province_id"=''' || "deli_province_id" || '''';
                END IF;
                IF REC_FA.field_name = 'delisubdistrictid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_NT = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Deli_subdistrict_id"=''' || "deli_subdistrict_id" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Deli_subdistrict_id"=''' || "deli_subdistrict_id" || '''';
                END IF;
                IF REC_FA.field_name = 'delidistrictid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_NT = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Deli_district_id"=''' || "deli_district_id" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Deli_district_id"=''' || "deli_district_id" || '''';
                END IF;
                IF REC_FA.field_name = 'delizipcode' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    FLAG_ENDORSE_23_NT = 'y';
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Deli_zipcode"=''' || "deli_zipcode" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Deli_zipcode"=''' || "deli_zipcode" || '''';
                END IF;
                --CR21              
                IF REC_FA.field_name = 'owneroccupation' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='23') THEN
                    IF POLICY_TYPE = '0' THEN
	                    FLAG_ENDORSE_23_T = 'y'; -- mc เฉพาะใบกำกับ
					ELSE
	                    FLAG_ENDORSE_23 = 'y'; -- อื่น ๆ ออกเอกสารสสลักหลัง
					END IF;
                    ONCE_ENDORSE_TXT='23';
                    UPDATE_QUERY_MV = COALESCE(UPDATE_QUERY_MV,'') || ',"Owner_occupation"=''' || COALESCE("owner_occupation",'') || '''';
					UPDATE_QUERY_MV :=
					    COALESCE(UPDATE_QUERY_MV, '')
						    || ',"bene_occupation" = CASE '
						    || 'WHEN "Bene_Type" = ''financial'' THEN NULL '
						    || 'ELSE ''' || COALESCE("owner_occupation",'') || ''''
						    || 'END';
                    UPDATE_QUERY_MC = COALESCE(UPDATE_QUERY_MC,'') || ',"Occupation"=''' || COALESCE("owner_occupation",'') || '''';
                END IF;
                --
                IF REC_FA.field_name = 'benetype' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='24') THEN
                    FLAG_ENDORSE_24 = 'y';
                    ONCE_ENDORSE_TXT='24';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Type"=''' || "bene_type" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Type"=''' || "bene_type" || '''';
                    IF "bene_type"='financial' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Title"=null';
                        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Title"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Lastname"=null';
                        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Lastname"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"bene_occupation"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"bene_occupation_code"=null';
                    ELSE
                        -- CR21 (02-12-2025)
                        -- เมื่อเปลี่ยนจาก financial เป็นบุคคล ให้อัปเดต Occupation ของผู้รับผลประโยชน์ให้เท่ากับ Owner_occupation
                        IF "owner_occupation" IS NOT NULL AND COALESCE("owner_occupation",'') != '' THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"bene_occupation"=''' || COALESCE("owner_occupation",'') || '''';
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Owner_occupation"=''' || COALESCE("owner_occupation",'') || '''';
                        END IF;
                        -- อัปเดต Title (Prefix Name)
                        IF "owner_prefix_name" IS NOT NULL AND COALESCE("owner_prefix_name",'') != '' THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Title"=''' || COALESCE("owner_prefix_name",'') || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Title"=''' || COALESCE("owner_prefix_name",'') || '''';
                        END IF;
                        -- อัปเดต First Name
                        IF "owner_first_name" IS NOT NULL AND COALESCE("owner_first_name",'') != '' THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Firstname"=''' || COALESCE("owner_first_name",'') || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Firstname"=''' || COALESCE("owner_first_name",'') || '''';
                        END IF;
                        -- อัปเดต Last Name
                        IF "owner_last_name" IS NOT NULL AND COALESCE("owner_last_name",'') != '' THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Lastname"=''' || COALESCE("owner_last_name",'') || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Lastname"=''' || COALESCE("owner_last_name",'') || '''';
                        END IF;
                        --
                    END IF;
                END IF;
                IF REC_FA.field_name = 'benetitle' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='24') THEN
                    FLAG_ENDORSE_24 = 'y';
                    ONCE_ENDORSE_TXT='24';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Title"=''' || "bene_title" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Title"=''' || "bene_title" || '''';
                END IF;
                IF REC_FA.field_name = 'benefirstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='24') THEN
                    FLAG_ENDORSE_24 = 'y';
                    ONCE_ENDORSE_TXT='24';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Firstname"=''' || "bene_firstname" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Firstname"=''' || "bene_firstname" || '''';
                END IF;
                IF REC_FA.field_name = 'benelastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='24') AND "bene_type"!='financial' THEN
                    FLAG_ENDORSE_24 = 'y';
                    ONCE_ENDORSE_TXT='24';
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Bene_Lastname"=''' || "bene_lastname" || '''';
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Bene_Lastname"=''' || "bene_lastname" || '''';
                END IF;

                IF REC_FA.field_name = 'driveaction' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='27' OR ONCE_ENDORSE_TXT='28') THEN
                    
                    IF LOWER("drive_action") = 'add' THEN
                        FLAG_ENDORSE_26 = 'y';
                        ONCE_ENDORSE_TXT='26';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Flag_Driver"=''Y''';

                    END IF;
                    IF LOWER("drive_action") = 'delete' THEN
                        FLAG_ENDORSE_27 = 'y';
                        ONCE_ENDORSE_TXT='27';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Flag_Driver"=''N''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"YOB_Driver_1"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"YOB_Driver_2"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_1"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_2"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_3"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_4"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_prefix_name_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_prefix_name_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_first_name_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_first_name_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_last_name_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_last_name_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_Driver_license_no_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_Driver_license_no_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_occupation_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_occupation_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_5"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_1"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_2"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_3"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_4"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_5"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_1"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_2"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_3"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_4"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_5"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Driver_Discount"=0';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"NamedAge"=''Unnamed''';
                    END IF;
                    IF LOWER("drive_action") = 'edit' THEN
                        FLAG_ENDORSE_28 = 'y';
                        ONCE_ENDORSE_TXT='28';
                    END IF;
                    
                END IF;
                
                IF REC_FA.field_name = 'par1prefix' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par1_prefix = null OR COALESCE("par1_prefix",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_prefix_name_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_prefix_name_1"=''' || COALESCE("par1_prefix",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par2prefix' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par2_prefix is null OR COALESCE("par2_prefix",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_prefix_name_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_prefix_name_2"=''' || COALESCE("par2_prefix",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par1firstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par1_firstname is null OR COALESCE("par1_firstname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_first_name_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_first_name_1"=''' || COALESCE("par1_firstname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par2firstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par2_firstname is null OR COALESCE("par2_firstname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_first_name_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_first_name_2"=''' || COALESCE("par2_firstname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par1lastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par1_lastname is null OR COALESCE("par1_lastname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_last_name_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_last_name_1"=''' || COALESCE("par1_lastname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par2lastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par2_lastname is null OR COALESCE("par2_lastname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_last_name_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_last_name_2"=''' || COALESCE("par2_lastname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par1driverno' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par1_driver_no is null OR COALESCE("par1_driver_no",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_Driver_license_no_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_Driver_license_no_1"=''' || COALESCE("par1_driver_no",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par2driverno' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par2_driver_no is null OR COALESCE("par2_driver_no",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_Driver_license_no_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_Driver_license_no_2"=''' || COALESCE("par2_driver_no",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par1driverlicensecategory' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF ONCE_ENDORSE_TXT='' AND COALESCE(LOWER("drive_action"), '') NOT IN ('add', 'delete') THEN
                        FLAG_ENDORSE_28 = 'y';
                        ONCE_ENDORSE_TXT='28';
                    END IF;
                    IF par1_driver_license_category is null OR COALESCE("par1_driver_license_category",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_1"=''' || COALESCE("par1_driver_license_category",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par2driverlicensecategory' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF ONCE_ENDORSE_TXT='' AND COALESCE(LOWER("drive_action"), '') NOT IN ('add', 'delete') THEN
                        FLAG_ENDORSE_28 = 'y';
                        ONCE_ENDORSE_TXT='28';
                    END IF;
                    IF par2_driver_license_category is null OR COALESCE("par2_driver_license_category",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_2"=''' || COALESCE("par2_driver_license_category",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par1citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND NOT IS_NEW_OIC THEN
                    IF par1_citizen_id is null OR COALESCE("par1_citizen_id",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_1"=''' || COALESCE("par1_citizen_id",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par2citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND NOT IS_NEW_OIC THEN
                    IF par2_citizen_id is null OR COALESCE("par2_citizen_id",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_2"=''' || COALESCE("par2_citizen_id",'') || '''';
                    END IF;
                END IF;
                
                -- CR21: Par3-5 fields
                IF REC_FA.field_name = 'par3prefix' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par3_prefix is null OR COALESCE("par3_prefix",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_3"=''' || COALESCE("par3_prefix",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par4prefix' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par4_prefix is null OR COALESCE("par4_prefix",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_4"=''' || COALESCE("par4_prefix",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par5prefix' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par5_prefix is null OR COALESCE("par5_prefix",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_prefix_name_5"=''' || COALESCE("par5_prefix",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par3firstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par3_firstname is null OR COALESCE("par3_firstname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_3"=''' || COALESCE("par3_firstname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par4firstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par4_firstname is null OR COALESCE("par4_firstname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_4"=''' || COALESCE("par4_firstname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par5firstname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par5_firstname is null OR COALESCE("par5_firstname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_first_name_5"=''' || COALESCE("par5_firstname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par3lastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par3_lastname is null OR COALESCE("par3_lastname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_3"=''' || COALESCE("par3_lastname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par4lastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par4_lastname is null OR COALESCE("par4_lastname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_4"=''' || COALESCE("par4_lastname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par5lastname' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par5_lastname is null OR COALESCE("par5_lastname",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_last_name_5"=''' || COALESCE("par5_lastname",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par3driverno' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par3_driver_no is null OR COALESCE("par3_driver_no",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_3"=''' || COALESCE("par3_driver_no",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par4driverno' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par4_driver_no is null OR COALESCE("par4_driver_no",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_4"=''' || COALESCE("par4_driver_no",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par5driverno' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par5_driver_no is null OR COALESCE("par5_driver_no",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_no_5"=''' || COALESCE("par5_driver_no",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par3driverlicensecategory' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF ONCE_ENDORSE_TXT='' AND COALESCE(LOWER("drive_action"), '') NOT IN ('add', 'delete') THEN
                        FLAG_ENDORSE_28 = 'y';
                        ONCE_ENDORSE_TXT='28';
                    END IF;
                    IF par3_driver_license_category is null OR COALESCE("par3_driver_license_category",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_3"=''' || COALESCE("par3_driver_license_category",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par4driverlicensecategory' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF ONCE_ENDORSE_TXT='' AND COALESCE(LOWER("drive_action"), '') NOT IN ('add', 'delete') THEN
                        FLAG_ENDORSE_28 = 'y';
                        ONCE_ENDORSE_TXT='28';
                    END IF;
                    IF par4_driver_license_category is null OR COALESCE("par4_driver_license_category",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_4"=''' || COALESCE("par4_driver_license_category",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par5driverlicensecategory' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF ONCE_ENDORSE_TXT='' AND COALESCE(LOWER("drive_action"), '') NOT IN ('add', 'delete') THEN
                        FLAG_ENDORSE_28 = 'y';
                        ONCE_ENDORSE_TXT='28';
                    END IF;
                    IF par5_driver_license_category is null OR COALESCE("par5_driver_license_category",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_driver_license_category_5"=''' || COALESCE("par5_driver_license_category",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par3citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND NOT IS_NEW_OIC THEN
                    IF par3_citizen_id is null OR COALESCE("par3_citizen_id",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_3"=''' || COALESCE("par3_citizen_id",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par4citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND NOT IS_NEW_OIC THEN
                    IF par4_citizen_id is null OR COALESCE("par4_citizen_id",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_4"=''' || COALESCE("par4_citizen_id",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'par5citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND NOT IS_NEW_OIC THEN
                    IF par5_citizen_id is null OR COALESCE("par5_citizen_id",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_5"=''' || COALESCE("par5_citizen_id",'') || '''';
                    END IF;
                END IF;
                -- Note: schema driverbirthdate1-2 ภาษาสะกดไม่ถูกต้อง , 3-5 สะกดถูก
                IF REC_FA.field_name = 'driverbrithdate1' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                    IF driver_brithdate1 IS NULL OR COALESCE("driver_brithdate1",'') = '' THEN
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_1"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_1"=null';
                    ELSE
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_1"=''' || "driver_brithdate1" || '''';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_1"=''' || COALESCE("driver_brithdate1") || '''';
                    END IF;
                    
                END IF;
                -- Note: schema driverbirthdate1-2 ภาษาสะกดไม่ถูกต้อง , 3-5 สะกดถูก
                IF REC_FA.field_name = 'driverbrithdate2' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                    IF driver_brithdate2 IS NULL OR COALESCE("driver_brithdate2",'') = '' THEN
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_2"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_2"=null';
                    ELSE
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_2"=''' || COALESCE("driver_brithdate2") || '''';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_2"=''' || COALESCE("driver_brithdate2") || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverbirthdate3' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN

                    IF driver_birthdate3 IS NULL OR COALESCE("driver_birthdate3",'') = '' THEN
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_3"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_3"=null';
                    ELSE
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_3"=''' || COALESCE("driver_birthdate3") || '''';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_3"=''' || COALESCE("driver_birthdate3") || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverbirthdate4' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                    IF driver_birthdate4 IS NULL OR COALESCE("driver_birthdate4",'') = '' THEN
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_4"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_4"=null';
                    ELSE
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_4"=''' || COALESCE("driver_birthdate4") || '''';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_4"=''' || COALESCE("driver_birthdate4") || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverbirthdate5' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                    IF driver_birthdate5 IS NULL OR COALESCE("driver_birthdate5",'') = '' THEN
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_5"=null';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_5"=null';
                    ELSE
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_birth_date_5"=''' || COALESCE("driver_birthdate5") || '''';
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_birth_date_5"=''' || COALESCE("driver_birthdate5") || '''';
                    END IF;
                END IF;
                
                -- CR21: Occupation fields (1-5)
                IF REC_FA.field_name = 'par1occupation' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par1_occupation is null OR COALESCE("par1_occupation",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_occupation_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_occupation_1"=''' || COALESCE("par1_occupation",'') || '''';
                    END IF;
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_1"=null'; -- sf ยังไม่ได้ control code ให้ถือ name เป็นหลักไปก่อน
                END IF;
                IF REC_FA.field_name = 'par2occupation' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par2_occupation is null OR COALESCE("par2_occupation",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_occupation_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_occupation_2"=''' || COALESCE("par2_occupation",'') || '''';
                    END IF;
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_2"=null'; -- sf ยังไม่ได้ control code ให้ถือ name เป็นหลักไปก่อน
                END IF;
                IF REC_FA.field_name = 'par3occupation' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par3_occupation is null OR COALESCE("par3_occupation",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_3"=''' || COALESCE("par3_occupation",'') || '''';
                    END IF;
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_3"=null'; -- sf ยังไม่ได้ control code ให้ถือ name เป็นหลักไปก่อน
                END IF;
                IF REC_FA.field_name = 'par4occupation' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par4_occupation is null OR COALESCE("par4_occupation",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_4"=''' || COALESCE("par4_occupation",'') || '''';
                    END IF;
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_4"=null'; -- sf ยังไม่ได้ control code ให้ถือ name เป็นหลักไปก่อน
                END IF;
                IF REC_FA.field_name = 'par5occupation' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF par5_occupation is null OR COALESCE("par5_occupation",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_5"=''' || COALESCE("par5_occupation",'') || '''';
                    END IF;
                    UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_occupation_code_5"=null'; -- sf ยังไม่ได้ control code ให้ถือ name เป็นหลักไปก่อน
                END IF;
                
                -- CR21: Driver Behavior fields (1-5) - snake_case
                IF REC_FA.field_name = 'driverbehavior1' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_behavior1 is null OR COALESCE("driver_behavior1",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_1"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_1"=''' || COALESCE("driver_behavior1",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_1"=''' || COALESCE("driver_behavior1",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverbehavior2' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_behavior2 is null OR COALESCE("driver_behavior2",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_2"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_2"=''' || COALESCE("driver_behavior2",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_2"=''' || COALESCE("driver_behavior2",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverbehavior3' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_behavior3 is null OR COALESCE("driver_behavior3",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_3"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_3"=''' || COALESCE("driver_behavior3",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_3"=''' || COALESCE("driver_behavior3",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverbehavior4' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_behavior4 is null OR COALESCE("driver_behavior4",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_4"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_4"=''' || COALESCE("driver_behavior4",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_4"=''' || COALESCE("driver_behavior4",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverbehavior5' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_behavior5 is null OR COALESCE("driver_behavior5",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_5"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_5"=''' || COALESCE("driver_behavior5",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_5"=''' || COALESCE("driver_behavior5",'') || '''';
                    END IF;
                END IF;
                
                -- CR21: Driver Consent fields (1-5) - snake_case
                IF REC_FA.field_name = 'driverconsent1' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_consent1 is null OR COALESCE("driver_consent1",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_1"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_1"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_1"=''' || COALESCE("driver_consent1",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_1"=''' || COALESCE("driver_consent1",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverconsent2' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_consent2 is null OR COALESCE("driver_consent2",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_2"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_2"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_2"=''' || COALESCE("driver_consent2",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_2"=''' || COALESCE("driver_consent2",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverconsent3' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_consent3 is null OR COALESCE("driver_consent3",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_3"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_3"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_3"=''' || COALESCE("driver_consent3",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_3"=''' || COALESCE("driver_consent3",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverconsent4' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_consent4 is null OR COALESCE("driver_consent4",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_4"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_4"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_4"=''' || COALESCE("driver_consent4",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_4"=''' || COALESCE("driver_consent4",'') || '''';
                    END IF;
                END IF;
                IF REC_FA.field_name = 'driverconsent5' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                    IF driver_consent5 is null OR COALESCE("driver_consent5",'') = '' THEN
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_5"=null';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_5"=null';
                    ELSE
                        UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_consent_5"=''' || COALESCE("driver_consent5",'') || '''';
                        UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_consent_5"=''' || COALESCE("driver_consent5",'') || '''';
                    END IF;
                END IF;
                
                IF REC_FA.field_name = 'coveragedetail' THEN
                    FLAG_ENDORSE_COVER = 'y';
                    
                    SELECT 
                    COALESCE(json_cover->>'fieldName', '') as "fieldName",
                    COALESCE(json_cover->>'policyType', '') as "policyType",
                    CAST(COALESCE(json_cover->>'coverageDayCount', '0') as INT) as "coverageDayCount",
                    COALESCE(json_cover->>'carBrand', '') as "carBrand",
                    COALESCE(json_cover->>'carModel', '') as "carModel",
                    COALESCE(json_cover->>'garageType', '') as "garageType",
                    CAST(COALESCE(json_cover->>'basicPremAmt', '0') as NUMERIC) as "basicPremAmt",
                    CAST(COALESCE(json_cover->>'basicPremV5Amt', '0') as NUMERIC) as "basicPremV5Amt",
                    COALESCE(json_cover->>'usage', '') as "usage",
                    CAST(COALESCE(json_cover->>'usageTariff', '0') as NUMERIC) as "usageTariff",
                    COALESCE(json_cover->>'carCc', '') as "carCc",
                    COALESCE(json_cover->>'carCcCondition', '') as "carCcCondition",
                    CAST(COALESCE(json_cover->>'carCcTariff', '0') as NUMERIC) as "carCcTariff",
                    COALESCE(json_cover->>'driverBrithdate1', NULL) as "driverBrithdate1",
                    COALESCE(json_cover->>'driverBrithdate2', NULL) as "driverBrithdate2",
                    COALESCE(json_cover->>'par1CitizenId', NULL) as "par1CitizenId",
                    COALESCE(json_cover->>'par2CitizenId', NULL) as "par2CitizenId",
                    COALESCE(json_cover->>'par3CitizenId', NULL) as "par3CitizenId",
                    COALESCE(json_cover->>'par4CitizenId', NULL) as "par4CitizenId",
                    COALESCE(json_cover->>'par5CitizenId', NULL) as "par5CitizenId",
                    COALESCE(json_cover->>'driverAge', '') as "driverAge",
                    CAST(COALESCE(json_cover->>'driverAgeDisc', '0') as NUMERIC) as "driverAgeDisc",
                    CAST(COALESCE(json_cover->>'driverAgeTariff', '0') as NUMERIC) as "driverAgeTariff",
                    COALESCE(json_cover->>'carYear', '') as "carYear",
                    CAST(COALESCE(json_cover->>'carYearTariff', '0') as NUMERIC) as "carYearTariff",
                    CAST(COALESCE(json_cover->>'siAmt', '0') as NUMERIC) as "siAmt",
                    CAST(COALESCE(json_cover->>'odAmt', '0') as NUMERIC) as "odAmt",
                    CAST(COALESCE(json_cover->>'ftAmt', '0') as NUMERIC) as "ftAmt",
                    CAST(COALESCE(json_cover->>'accessHave', 'FALSE') as BOOL) as "accessHave",
                    CAST(COALESCE(json_cover->>'accessSiAmt', '0') as NUMERIC) as "accessSiAmt",
                    CAST(COALESCE(json_cover->>'accessPremAmt', '0') as NUMERIC) as "accessPremAmt",
                    COALESCE(json_cover->>'accessName', NULL) as "accessName",
                    CAST(COALESCE(json_cover->>'siTariff', '0') as NUMERIC) as "siTariff",
                    CAST(COALESCE(json_cover->>'siV5Tariff', '0') as NUMERIC) as "siV5Tariff",
                    COALESCE(json_cover->>'carGroup', '') as "carGroup",
                    CAST(COALESCE(json_cover->>'carGroupTariff', '0') as NUMERIC) as "carGroupTariff",
                    CAST(COALESCE(json_cover->>'tpbiPassSiAmt', '0') as NUMERIC) as "tpbiPassSiAmt",
                    CAST(COALESCE(json_cover->>'tpbiPassPremAmt', '0') as NUMERIC) as "tpbiPassPremAmt",
                    CAST(COALESCE(json_cover->>'tpbiPassTariff', '0') as NUMERIC) as "tpbiPassTariff",
                    CAST(COALESCE(json_cover->>'tpbiEventSiAmt', '0') as NUMERIC) as "tpbiEventSiAmt",
                    CAST(COALESCE(json_cover->>'tpbiEventPremAmt', '0') as NUMERIC) as "tpbiEventPremAmt",
                    CAST(COALESCE(json_cover->>'tpbiEventTariff', '0') as NUMERIC) as "tpbiEventTariff",
                    CAST(COALESCE(json_cover->>'tppdSiAmt', '0') as NUMERIC) as "tppdSiAmt",
                    CAST(COALESCE(json_cover->>'tppdPremAmt', '0') as NUMERIC) as "tppdPremAmt",
                    CAST(COALESCE(json_cover->>'tppdTariff', '0') as NUMERIC) as "tppdTariff",
                    CAST(COALESCE(json_cover->>'totalExMvAmt', '0') as NUMERIC) as "totalExMvAmt",
                    CAST(COALESCE(json_cover->>'mv01SiAmt', '0') as NUMERIC) as "mv01SiAmt",
                    CAST(COALESCE(json_cover->>'mv01PremAmt', '0') as NUMERIC) as "mv01PremAmt",
                    CAST(COALESCE(json_cover->>'mv02SiAmt', '0') as NUMERIC) as "mv02SiAmt",
                    CAST(COALESCE(json_cover->>'mv02PremAmt', '0') as NUMERIC) as "mv02PremAmt",
                    CAST(COALESCE(json_cover->>'mv03SiAmt', '0') as NUMERIC) as "mv03SiAmt",
                    CAST(COALESCE(json_cover->>'mv03PremAmt', '0') as NUMERIC) as "mv03PremAmt",
                    CAST(COALESCE(json_cover->>'cctvHave', 'FALSE') as BOOL) as "cctvHave",
                    CAST(COALESCE(json_cover->>'cctvPercent', '0') as NUMERIC) as "cctvPercent",
                    CAST(COALESCE(json_cover->>'totalMvAmt', '0') as NUMERIC) as "totalMvAmt",
                    CAST(COALESCE(json_cover->>'fleetDiscPer', '0') as NUMERIC) as "fleetDiscPer",
                    CAST(COALESCE(json_cover->>'fleetDiscAmt', '0') as NUMERIC) as "fleetDiscAmt",
                    CAST(COALESCE(json_cover->>'ncbDiscPer', '0') as NUMERIC) as "ncbDiscPer",
                    CAST(COALESCE(json_cover->>'ncbDiscAmt', '0') as NUMERIC) as "ncbDiscAmt",
                    CAST(COALESCE(json_cover->>'otherDiscPer', '0') as NUMERIC) as "otherDiscPer",
                    CAST(COALESCE(json_cover->>'otherDiscAmt', '0') as NUMERIC) as "otherDiscAmt",
                    CAST(COALESCE(json_cover->>'totalDiscAmt', '0') as NUMERIC) as "totalDiscAmt",
                    COALESCE(json_cover->>'extendEnddate', NULL) as "extendEnddate",
                    CAST(COALESCE(json_cover->>'extendDayCount', '0') as INT) as "extendDayCount",
                    CAST(COALESCE(json_cover->>'extendPremAmt', '0') as NUMERIC) as "extendPremAmt",
                    CAST(COALESCE(json_cover->>'premAmt', '0') as NUMERIC) as "premAmt",
                    CAST(COALESCE(json_cover->>'dutyAmt', '0') as NUMERIC) as "dutyAmt",
                    CAST(COALESCE(json_cover->>'vatPer', '0') as NUMERIC) as "vatPer",
                    CAST(COALESCE(json_cover->>'vatAmt', '0') as NUMERIC) as "vatAmt",
                    CAST(COALESCE(json_cover->>'totalAmt', '0') as NUMERIC) as "totalAmt",
                    CAST(COALESCE(json_cover->>'premiumV5Od', '0') as NUMERIC) as "premiumV5Od",
                    CAST((CASE WHEN json_cover->>'driverBehaviorSummary' IS NULL OR json_cover->>'driverBehaviorSummary' = '' THEN NULL ELSE json_cover->>'driverBehaviorSummary' END) AS INTEGER) as "driverBehaviorSummary",
                    CAST((CASE WHEN json_cover->>'driverBehaviorTariff' IS NULL OR json_cover->>'driverBehaviorTariff' = '' THEN NULL ELSE json_cover->>'driverBehaviorTariff' END) AS NUMERIC) as "driverBehaviorTariff",
                    CAST((CASE WHEN json_cover->>'driverBehaviorDisc' IS NULL OR json_cover->>'driverBehaviorDisc' = '' THEN NULL ELSE json_cover->>'driverBehaviorDisc' END) AS NUMERIC) as "driverBehaviorDisc"
                    FROM CAST((CASE WHEN "coverage_detail"='' THEN NULL ELSE "coverage_detail" END) AS JSON) as json_cover
                    INTO 
                    C_FIELD_NAME,
                    C_POLICY_TYPE,
                    C_COVERAGE_DAY_COUNT,
                    C_CAR_BRAND,
                    C_CAR_MODEL,
                    C_GARAGE_TYPE,
                    C_BASIC_PREM_AMT,
                    C_BASIC_PREM_V5_AMT,
                    C_USAGE,
                    C_USAGE_TARIFF,
                    C_CAR_CC,
                    C_CAR_CC_CONDITION,
                    C_CAR_CC_TARIFF,
                    C_DRIVER_BRITHDATE1,
                    C_DRIVER_BRITHDATE2,
                    C_DRIVER_CITIZEN1,
                    C_DRIVER_CITIZEN2,
                    C_DRIVER_CITIZEN3,
                    C_DRIVER_CITIZEN4,
                    C_DRIVER_CITIZEN5,
                    C_DRIVER_AGE,
                    C_DRIVER_AGE_DISC,
                    C_DRIVER_AGE_TARIFF,
                    C_CAR_YEAR,
                    C_CAR_YEAR_TARIFF,
                    C_SI_AMT,
                    C_OD_AMT,
                    C_FT_AMT,
                    C_ACCESS_HAVE,
                    C_ACCESS_SI_AMT,
                    C_ACCESS_PREM_AMT,
                    C_ACCESS_NAME,
                    C_SI_TARIFF,
                    C_SI_V5_TARIFF,
                    C_CAR_GROUP,
                    C_CAR_GROUP_TARIFF,
                    C_TPBI_PASS_SI_AMT,
                    C_TPBI_PASS_PREM_AMT,
                    C_TPBI_PASS_TARIFF,
                    C_TPBI_EVENT_SI_AMT,
                    C_TPBI_EVENT_PREM_AMT,
                    C_TPBI_EVENT_TARIFF,
                    C_TPPD_SI_AMT,
                    C_TPPD_PREM_AMT,
                    C_TPPD_TARIFF,
                    C_TOTAL_EX_MV_AMT,
                    C_MV01_SI_AMT,
                    C_MV01_PREM_AMT,
                    C_MV02_SI_AMT,
                    C_MV02_PREM_AMT,
                    C_MV03_SI_AMT,
                    C_MV03_PREM_AMT,
                    C_CCTV_HAVE,
                    C_CCTV_PERCENT,
                    C_TOTAL_MV_AMT,
                    C_FLEET_DISC_PER,
                    C_FLEET_DISC_AMT,
                    C_NCB_DISC_PER,
                    C_NCB_DISC_AMT,
                    C_OTHER_DISC_PER,
                    C_OTHER_DISC_AMT,
                    C_TOTAL_DISC_AMT,
                    C_EXTEND_ENDDATE,
                    C_EXTEND_DAY_COUNT,
                    C_EXTEND_PREM_AMT,
                    C_PREM_AMT,
                    C_DUTY_AMT,
                    C_VAT_PER,
                    C_VAT_AMT,
                    C_TOTAL_AMT,
                    C_PREMIUM_V5_OD,
                    C_DRIVER_BEHAVIOR_SUMMARY,
                    C_DRIVER_BEHAVIOR_TARIFF,
                    C_DRIVER_BEHAVIOR_DISC;
                    
                    FOR LOOP_COVER in SELECT regexp_replace(LOWER(CAST("json_b".value as TEXT)), '"','', 'g') as "cover_name"
                    FROM json_array_elements(C_FIELD_NAME::json) as "json_b"
                    LOOP
                        FLAG_ENDORSE_COVER_FIELD = 'y';
                    
                        -- R2.5 CR
                        IF IN_POLICY_TYPE = 'V' THEN 
                            select coalesce(UPPER("Flag_CCTV"),'N'),coalesce(UPPER("Flag_Access"),'N'),"Access_para_code"
                            from insurverse."Policy_coverage_premium"
                            where "Policy_No"=PH_POLICY_NO
                            into OLD_FLAG_CCTV,OLD_FLAG_ACCESS,OLD_ACCESS_PARA_CODE;
                        end if;
                        
                        IF LOOP_COVER.cover_name = 'carbrand' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Brand"=''' || C_CAR_BRAND || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Brand"=''' || C_CAR_BRAND || '''';
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Brand"=''' || C_CAR_BRAND || '''';
                        END IF;
                        IF LOOP_COVER.cover_name = 'carmodel' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Model"=''' || C_CAR_MODEL || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Model"=''' || C_CAR_MODEL || '''';
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Model"=''' || C_CAR_MODEL || '''';
                        END IF;
                        IF LOOP_COVER.cover_name = 'usage' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Usage"=''' || C_USAGE || '''';
                            --UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Usage"=''' || C_USAGE || '''';
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Usage"=''' || C_USAGE || '''';
                        END IF;
                        IF LOOP_COVER.cover_name = 'caryear' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Year"=''' || C_CAR_YEAR || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Year"=''' || C_CAR_YEAR || '''';
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Year"=''' || C_CAR_YEAR || '''';
                        END IF;
                        IF LOOP_COVER.cover_name = 'cargroup' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Group"=''' || C_CAR_GROUP || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Group"=''' || C_CAR_GROUP || '''';
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Group"=''' || C_CAR_GROUP || '''';
                        END IF;
                        IF LOOP_COVER.cover_name = 'carcc' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18') THEN
                            
                            SELECT "CC" FROM insurverse."Policy_coverage_premium" WHERE "Policy_No"=IN_POLICY_NO
                            INTO CV_PRV_CC;
                            IF CV_PRV_CC=C_CAR_CC_CONDITION THEN
                                FLAG_ENDORSE_17 = 'y';
                                ONCE_ENDORSE_TXT='17';
                            ELSE
                                IF IN_POLICY_TYPE = 'C' THEN 
                                    FLAG_ENDORSE_17 = 'y';
                                    ONCE_ENDORSE_TXT='17';
                                ELSE 
                                    FLAG_ENDORSE_17 = 'n';
                                    FLAG_ENDORSE_18 = 'y';
                                    ONCE_ENDORSE_TXT='18';
                                END IF;
                            END IF;
                            
                            IF (C_USAGE IS NOT NULL AND C_USAGE='210') OR (C_USAGE IS NULL AND P_USAGE IS NOT NULL AND P_USAGE='210') THEN
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Seat"=''' || C_CAR_CC || '''';
                                UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Seat"=''' || C_CAR_CC || '''';
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Seat"=''' || C_CAR_CC || '''';
                            ELSIF (C_USAGE IS NOT NULL AND C_USAGE='320') OR (C_USAGE IS NULL AND P_USAGE IS NOT NULL AND P_USAGE='320') THEN
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Wg"=''' || C_CAR_CC || '''';
                                UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Wg"=''' || C_CAR_CC || '''';
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Wg"=''' || C_CAR_CC || '''';
                            ELSE -- C_USAGE = 110
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"CC"=''' || C_CAR_CC || '''';
                                UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"CC"=''' || C_CAR_CC || '''';
                                IF C_CAR_CC_CONDITION IS NOT NULL AND C_CAR_CC_CONDITION != '' THEN
                                    UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"CC"=''' || C_CAR_CC_CONDITION || '''';
                                END IF;
                            END IF;

                        END IF;

                        IF LOOP_COVER.cover_name = 'hp'
                        AND IN_POLICY_TYPE = 'C' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17') THEN
                            FLAG_ENDORSE_17 = 'y';
                            ONCE_ENDORSE_TXT='17';
                        END IF;

                        IF LOOP_COVER.cover_name = 'caryear'
                        AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='17' OR ONCE_ENDORSE_TXT='18')
                        THEN
                            IF IN_POLICY_TYPE = 'C' THEN 
                                IF LOOP_COVER.cover_name = 'caryear' AND FLAG_ENDORSE_17 != 'y' THEN
                                    FLAG_ENDORSE_17_NT = 'y';
                                    ONCE_ENDORSE_TXT='17';
                                ELSE
                                    FLAG_ENDORSE_17 = 'y';
                                    ONCE_ENDORSE_TXT='17';
                                END IF;
                            ELSE 
                                FLAG_ENDORSE_17 = 'n';
                                FLAG_ENDORSE_18 = 'y';
                                ONCE_ENDORSE_TXT='18';
                            END IF;
                        END IF;
                        
                        IF LOOP_COVER.cover_name = 'driverbrithdate1' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND NOT IS_NEW_OIC THEN
                            IF C_DRIVER_BRITHDATE1 IS NULL THEN
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"YOB_Driver_1"=null';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_1"=null';
                            ELSE
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"YOB_Driver_1"=''' || EXTRACT(YEAR FROM CAST(C_DRIVER_BRITHDATE1 as DATE)) || '''';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_1"=''' || C_DRIVER_BRITHDATE1 || '''';
                            END IF;
                        END IF;
                        IF LOOP_COVER.cover_name = 'driverbrithdate2' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND NOT IS_NEW_OIC THEN
                            IF C_DRIVER_BRITHDATE2 IS NULL THEN
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"YOB_Driver_2"=null';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_2"=null';
                            ELSE
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"YOB_Driver_2"=''' || EXTRACT(YEAR FROM CAST(C_DRIVER_BRITHDATE2 as DATE)) || '''';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_birth_date_2"=''' || C_DRIVER_BRITHDATE2 || '''';
                            END IF;
                        END IF;

                        -- cr21
                        IF LOOP_COVER.cover_name = 'par1citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                            IF C_DRIVER_CITIZEN1 IS NULL THEN
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_1"=null';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_1"=null';
                            ELSE
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_1"=''' || C_DRIVER_CITIZEN1 || '''';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_1"=''' || C_DRIVER_CITIZEN1 || '''';
                            END IF;
                        END IF;

                        IF LOOP_COVER.cover_name = 'par2citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                            IF C_DRIVER_CITIZEN2 IS NULL THEN
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_2"=null';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_2"=null';
                            ELSE
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_2"=''' || C_DRIVER_CITIZEN2 || '''';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Par_citizen_id_2"=''' || C_DRIVER_CITIZEN2 || '''';
                            END IF;
                        END IF;

                        IF LOOP_COVER.cover_name = 'par3citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                            IF C_DRIVER_CITIZEN3 IS NULL THEN
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_3"=null';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_3"=null';
                            ELSE
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_3"=''' || C_DRIVER_CITIZEN3 || '''';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_3"=''' || C_DRIVER_CITIZEN3 || '''';
                            END IF;
                        END IF;

                        IF LOOP_COVER.cover_name = 'par4citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                            IF C_DRIVER_CITIZEN4 IS NULL THEN
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_4"=null';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_4"=null';
                            ELSE
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_4"=''' || C_DRIVER_CITIZEN4 || '''';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_4"=''' || C_DRIVER_CITIZEN4 || '''';
                            END IF;
                        END IF;

                        IF LOOP_COVER.cover_name = 'par5citizenid' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') AND IS_NEW_OIC THEN
                            IF C_DRIVER_CITIZEN5 IS NULL THEN
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_5"=null';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_5"=null';
                            ELSE
                                UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"par_citizen_id_5"=''' || C_DRIVER_CITIZEN5 || '''';
                                UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"par_citizen_id_5"=''' || C_DRIVER_CITIZEN5 || '''';
                            END IF;
                        END IF;

                        IF LOOP_COVER.cover_name = 'driverage' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"NamedAge"=''' || C_DRIVER_AGE || '''';
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"NamedAge"=''' || C_DRIVER_AGE || '''';
                        END IF;
                        /*
                        IF LOOP_COVER.cover_name = 'driveragedisc' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='28') THEN
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Driver_Discount"=' || C_DRIVER_AGE_DISC;
                        END IF;
                        */
                        -- R2.5 CR
                        if (LOOP_COVER.cover_name = 'cctvhave') and OLD_FLAG_CCTV is not null then
                            ONCE_ENDORSE_TXT='18';
                            FLAG_ENDORSE_18_P = 'y';
                          	if OLD_FLAG_CCTV = 'N' and CAST(C_CCTV_HAVE AS BOOL) = true then 
							    RTN_CCTV_ACTION = 'ADD';
							elsif OLD_FLAG_CCTV = 'Y' and CAST(C_CCTV_HAVE AS BOOL) = false then
							    RTN_CCTV_ACTION = 'REMOVE';
							end if;
                            IF CAST(C_CCTV_HAVE AS BOOL) = TRUE THEN
                                UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Flag_CCTV"=''Y''';
                            ELSE
                                UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Flag_CCTV"=''N''';
                            END IF;
                            UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"CCTV"=' || C_CCTV_PERCENT;
                        end if;
                        -- R2.5 CR
                        if (LOOP_COVER.cover_name = 'accesshave') and OLD_FLAG_ACCESS is not null then
                            if OLD_FLAG_ACCESS = 'N' and CAST(C_ACCESS_HAVE AS BOOL) = true 
                                or json_array_length(cast(OLD_ACCESS_PARA_CODE as JSON)) != json_array_length(cast(C_ACCESS_NAME as JSON))
                            then 
                                FLAG_ENDORSE_20_A = 'y';
								RTN_ACCESSORY_ACTION = 'ADD';
                            end if;
                        end if;
                        
                        IF (LOOP_COVER.cover_name = 'siamt' OR LOOP_COVER.cover_name = 'odamt' OR LOOP_COVER.cover_name = 'ftamt' OR 
                        LOOP_COVER.cover_name = 'accesshave' OR LOOP_COVER.cover_name = 'accesssiamt' OR
                        LOOP_COVER.cover_name = 'accesspremamt' OR LOOP_COVER.cover_name = 'accessname' OR
                        LOOP_COVER.cover_name = 'tpbipasssiamt' OR LOOP_COVER.cover_name = 'tpbipasspremamt' OR  
                        LOOP_COVER.cover_name = 'tpbieventsiamt' OR LOOP_COVER.cover_name = 'tpbieventpremamt' OR
                        LOOP_COVER.cover_name = 'tppdsiamt' OR LOOP_COVER.cover_name = 'tppdpremamt' OR
                        LOOP_COVER.cover_name = 'driveragedisc' OR
                        LOOP_COVER.cover_name = 'mv01siamt' OR LOOP_COVER.cover_name = 'mv01premamt' OR
                        LOOP_COVER.cover_name = 'mv02siamt' OR LOOP_COVER.cover_name = 'mv02premamt' OR
                        LOOP_COVER.cover_name = 'mv03siamt' OR LOOP_COVER.cover_name = 'mv03premamt')
                        AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='20')
                        THEN
                            FLAG_ENDORSE_20 = 'y';
                        END IF;
                        
                        IF (LOOP_COVER.cover_name = 'extendenddate')
                        AND (ONCE_ENDORSE_TXT='')
                        THEN
                            FLAG_ENDORSE_05 = 'y';
                            ONCE_ENDORSE_TXT='05';
                            IF EXTEND_STARTDATE IS NULL THEN
                                EXTEND_STARTDATE = PREV_POLICY_ENDDATE;
                            END IF;
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Policy_Enddate"=''' || C_EXTEND_ENDDATE || '''';
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Extend_Start"=''' || EXTEND_STARTDATE || '''';
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Extend_End"=''' || C_EXTEND_ENDDATE || '''';
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"extend_amt"=' || C_EXTEND_PREM_AMT;
                            
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"End_date"=''' || C_EXTEND_ENDDATE || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Extend_Start"=''' || EXTEND_STARTDATE || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Extend_End"=''' || C_EXTEND_ENDDATE || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"extend_amt"=' || C_EXTEND_PREM_AMT;
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Net_Premium"=' || C_PREM_AMT;
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Stamp"=' || C_DUTY_AMT;
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Vat"=' || C_VAT_AMT;
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Total"=' || C_TOTAL_AMT;
                            
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"Effective_Enddate"=''' || C_EXTEND_ENDDATE || '''';
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Effective_Enddate"=''' || C_EXTEND_ENDDATE || '''';
                            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Effective_Enddate"=''' || C_EXTEND_ENDDATE || '''';
                            
                        END IF;

                        -- CR21
                        IF LOOP_COVER.cover_name = 'driverbehaviorsummary' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='27' OR ONCE_ENDORSE_TXT='28') AND C_DRIVER_BEHAVIOR_SUMMARY IS NOT NULL THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_cal"=' || C_DRIVER_BEHAVIOR_SUMMARY;
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_cal"=' || C_DRIVER_BEHAVIOR_SUMMARY;
                        END IF;
                        IF LOOP_COVER.cover_name = 'driverbehaviortariff' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='27' OR ONCE_ENDORSE_TXT='28') AND C_DRIVER_BEHAVIOR_TARIFF IS NOT NULL THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_disc_perc"=' || C_DRIVER_BEHAVIOR_TARIFF;
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_disc_perc"=' || C_DRIVER_BEHAVIOR_TARIFF;
                        END IF;
                        IF LOOP_COVER.cover_name = 'driverbehaviordisc' AND (ONCE_ENDORSE_TXT='' OR ONCE_ENDORSE_TXT='26' OR ONCE_ENDORSE_TXT='27' OR ONCE_ENDORSE_TXT='28') AND C_DRIVER_BEHAVIOR_DISC IS NOT NULL THEN
                            UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"driver_behavior_disc_amt"=' || C_DRIVER_BEHAVIOR_DISC;
                            UPDATE_QUERY_MVC = UPDATE_QUERY_MVC || ',"driver_behavior_disc_amt"=' || C_DRIVER_BEHAVIOR_DISC;
                        END IF;

                    END LOOP;
                    
                    IF FLAG_ENDORSE_COVER_FIELD = 'y' AND IN_POLICY_TYPE = 'V' AND FLAG_ENDORSE_17 = 'n' AND C_TOTAL_AMT IS NOT NULL AND C_TOTAL_AMT > 0 AND C_PREM_AMT IS NOT NULL AND C_PREM_AMT > 0 THEN
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"Basic_Premium"=' || C_BASIC_PREM_AMT;
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"basic_premium_v5"=' || C_BASIC_PREM_V5_AMT;
                        
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_Limit"=' || C_SI_AMT;
                        --UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"OD_Amt"=' || C_OD_AMT;
                        --UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"FT_Amt"=' || C_FT_AMT;
                        
                        IF CAST(C_ACCESS_HAVE AS BOOL) = TRUE THEN
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"Flag_Access"=''Y''';
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_Access_Limit"=' || C_ACCESS_SI_AMT;
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_Access_Amt"=1';
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"Access_para_code"=''' || C_ACCESS_NAME || '''';
                        ELSE
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"Flag_Access"=''N''';
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_Access_Limit"=null';
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_Access_Amt"=null';
                            UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"Access_para_code"=null';
                        END IF;
                        
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_TPBI_Limit"=' || C_TPBI_PASS_SI_AMT;
                        --UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_TPBI_Amt"=' || C_TPBI_PASS_PREM_AMT;
                        
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_TPPD_Limit"=' || C_TPPD_SI_AMT;
                        --UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"SI_TPPD_Amt"=' || C_TPPD_PREM_AMT;
                        
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"Total_Amt_exclude_mv"=' || C_TOTAL_EX_MV_AMT;
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"Driver_Discount"=' || C_DRIVER_AGE_DISC;
                        UPDATE_QUERY_MVC_1 = UPDATE_QUERY_MVC_1 || ',"premium_v5_od"=' || C_PREMIUM_V5_OD;
                        
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"SI_MV01_Limit"=' || C_MV01_SI_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"SI_MV01_Amt"=' || C_MV01_PREM_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"SI_MV02_Limit"=' || C_MV02_SI_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"SI_MV02_Amt"=' || C_MV02_PREM_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"SI_MV03_Limit"=' || C_MV03_SI_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"SI_MV03_Amt"=' || C_MV03_PREM_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Total_Amt_mv"=' || C_TOTAL_MV_AMT;
                        
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Fleet_Disc_perc"=' || C_FLEET_DISC_PER;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"NCB_Disc_perc"=' || C_NCB_DISC_PER;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Other_Disc_perc"=' || C_OTHER_DISC_PER;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Fleet_Disc_Amt"=' || C_FLEET_DISC_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"NCB_Disc_Amt"=' || C_NCB_DISC_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Other_Disc_Amt"=' || C_OTHER_DISC_AMT;
                        UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Total_Disc_Amt"=' || C_TOTAL_DISC_AMT;

                    END IF;
                END IF;
            END IF;
        end LOOP;
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
        
        IF CAST(CAST(PREV_POLICY_STARTDATE as TIMESTAMP) + INTERVAL '7 HOUR' as TIMESTAMP)::date >= CAST(CAST(CANCEL_DATE as TIMESTAMP) + INTERVAL '7 HOUR' as TIMESTAMP)::date THEN
            -- Change Amt ใบลดหนี้ กรณีคืนเต็ม
            CHANGE_PERM_AMT = OLD_PERM_AMT;
            CHANGE_DUTY_AMT = OLD_DUTY_AMT;
            CHANGE_VAT_AMT = OLD_VAT_AMT;
            CHANGE_TOTAL_AMT = OLD_TOTAL_AMT;
        ELSE
            IF IN_POLICY_TYPE = 'V' THEN
                COVER_DAY = EXTRACT(DAY FROM date_trunc('day',CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)) + '00:00:00' - date_trunc('day',CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' AS TIMESTAMP)) + '00:00:00');

                -- CR21 Prorate: short-rate (OIC penalty table) vs pro-rate (linear unearned premium)
                IF COALESCE(refund_type, 'short') = 'pro' THEN
                    RETURN_PER = 100.0 * EXTRACT(DAY FROM date_trunc('day', CAST(PREV_POLICY_ENDDATE + INTERVAL '7 HOUR' AS TIMESTAMP)) - date_trunc('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' AS TIMESTAMP))) / NULLIF(EXTRACT(DAY FROM date_trunc('day', CAST(PREV_POLICY_ENDDATE + INTERVAL '7 HOUR' AS TIMESTAMP)) - date_trunc('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' AS TIMESTAMP))), 0);    
                ELSE
                    SELECT "oic_return"."Perc_return"
                    FROM insurverse."OIC_Perc_Return_by_Day" as "oic_return"
                    WHERE "oic_return"."Range_start"<=COVER_DAY AND "oic_return"."Range_end">=COVER_DAY
                    INTO RETURN_PER;
                END IF;
                
                -- Change Amt ใบลดหนี้ กรณีคืนไม่เต็มจำนวน
                CHANGE_PERM_AMT = FLOOR(OLD_PERM_AMT * (RETURN_PER/100));
                CHANGE_DUTY_AMT = 0.00;
                CHANGE_VAT_AMT = CHANGE_PERM_AMT * 0.07;
                CHANGE_TOTAL_AMT = CHANGE_PERM_AMT + CHANGE_VAT_AMT;
            END IF;
            IF IN_POLICY_TYPE = 'C' THEN
                IF (EXTRACT(MONTH FROM DATE_TRUNC('month', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP))) != EXTRACT(MONTH FROM DATE_TRUNC('month', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))
                        AND EXTRACT(DAY FROM DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP))) < EXTRACT(DAY FROM DATE_TRUNC('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP))))
                        OR EXTRACT(DAY FROM DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP))) > EXTRACT(DAY FROM DATE_TRUNC('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))
                    THEN COVER_MONTH = (EXTRACT(YEAR FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))) * 12) + EXTRACT(MONTH FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))) + 1;
                    ELSE COVER_MONTH = (EXTRACT(YEAR FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP)))) * 12) + EXTRACT(MONTH FROM AGE(DATE_TRUNC('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' as TIMESTAMP)), DATE_TRUNC('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' as TIMESTAMP))));
                END IF;

                -- CR21 Prorate: short-rate (OIC penalty table) vs pro-rate (linear unearned premium)
                IF COALESCE(refund_type, 'short') = 'pro' THEN
                    RETURN_PER = 100.0 * EXTRACT(DAY FROM date_trunc('day', CAST(PREV_POLICY_ENDDATE + INTERVAL '7 HOUR' AS TIMESTAMP)) - date_trunc('day', CAST(CANCEL_DATE + INTERVAL '7 HOUR' AS TIMESTAMP))) / NULLIF(EXTRACT(DAY FROM date_trunc('day', CAST(PREV_POLICY_ENDDATE + INTERVAL '7 HOUR' AS TIMESTAMP)) - date_trunc('day', CAST(PREV_POLICY_STARTDATE + INTERVAL '7 HOUR' AS TIMESTAMP))), 0);
                ELSE
                    SELECT "oic_return"."Perc_return"
                    FROM insurverse."OIC_Perc_Return_Act_by_Day" as "oic_return"
                    WHERE "oic_return"."Range_start"<=COVER_MONTH AND "oic_return"."Range_end">=COVER_MONTH
                    INTO RETURN_PER;
                END IF;
                
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
        
        --IF CANCEL_DATE < PREV_POLICY_STARTDATE THEN
        --  CANCEL_DATE = PREV_POLICY_STARTDATE;
        --END IF;
        
        --UPDATE_QUERY_MV = UPDATE_QUERY_MV || ',"Policy_Startdate"=''' || CANCEL_DATE || '''';
        --UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Start_date"=''' || CANCEL_DATE || '''';
                
        NEW_PERM_AMT = OLD_PERM_AMT + CHANGE_PERM_AMT;
        NEW_DUTY_AMT = OLD_DUTY_AMT + CHANGE_DUTY_AMT;
        NEW_VAT_AMT = OLD_VAT_AMT + CHANGE_VAT_AMT;
        NEW_TOTAL_AMT = NEW_PERM_AMT + NEW_DUTY_AMT + NEW_VAT_AMT;
        
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Net_Premium"=' || NEW_PERM_AMT;
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Stamp"=' || NEW_DUTY_AMT;
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Vat"=' || NEW_VAT_AMT;
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Total"=' || NEW_TOTAL_AMT;
        
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Perm_Amt"=' || NEW_PERM_AMT;
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Duty_Amt"=' || NEW_DUTY_AMT;
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Vat_Amt"=' || NEW_VAT_AMT;
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Total_Amt"=' || NEW_TOTAL_AMT;
        IF NEW_TOTAL_AMT < 0 THEN
            FLAG_TOTAL_AMT_ERR = 'y';
        END IF;
        
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Perm_Amt"=' || CHANGE_PERM_AMT;
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Duty_Amt"=' || CHANGE_DUTY_AMT;
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Vat_Amt"=' || CHANGE_VAT_AMT;
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Total_Amt"=' || CHANGE_TOTAL_AMT;
        
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Perm_Amt"=' || CHANGE_PERM_AMT;
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Duty_Amt"=' || CHANGE_DUTY_AMT;
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Vat_Amt"=' || CHANGE_VAT_AMT;
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Total_Amt"=' || CHANGE_TOTAL_AMT;
        
    ELSIF (FLAG_ENDORSE_05 = 'y' OR FLAG_ENDORSE_18 = 'y' OR
    FLAG_ENDORSE_20 = 'y' OR FLAG_ENDORSE_26 = 'y' OR
    FLAG_ENDORSE_27 = 'y' OR FLAG_ENDORSE_28 = 'y')
    THEN
        IF FLAG_ENDORSE_COVER_FIELD = 'y' AND C_TOTAL_AMT IS NOT NULL AND C_TOTAL_AMT > 0 AND C_PREM_AMT IS NOT NULL AND C_PREM_AMT > 0 THEN
            
            CHANGE_PERM_AMT = C_PREM_AMT - OLD_PERM_AMT;
            IF CHANGE_PERM_AMT < 0 THEN
                CHANGE_DUTY_AMT = 0;
            ELSE
                CHANGE_DUTY_AMT = CEIL(CHANGE_PERM_AMT * 0.004);
                if CHANGE_DUTY_AMT < 1 then
                    CHANGE_DUTY_AMT = 0;
                end if;
            END IF;
            CHANGE_VAT_AMT = (CHANGE_PERM_AMT + CHANGE_DUTY_AMT) * 0.07;
            CHANGE_TOTAL_AMT = CHANGE_PERM_AMT + CHANGE_DUTY_AMT + CHANGE_VAT_AMT;
            C_DUTY_AMT = OLD_DUTY_AMT + CHANGE_DUTY_AMT;
            C_VAT_AMT = OLD_VAT_AMT + CHANGE_VAT_AMT;
            C_TOTAL_AMT = C_PREM_AMT + C_DUTY_AMT + C_VAT_AMT;
            UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Perm_Amt"=' || C_PREM_AMT;
            UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Duty_Amt"=' || C_DUTY_AMT;
            UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Vat_Amt"=' || C_VAT_AMT;
            UPDATE_QUERY_MVC_2 = UPDATE_QUERY_MVC_2 || ',"Total_Amt"=' || C_TOTAL_AMT;
            
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Perm_Amt"=' || CHANGE_PERM_AMT;
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Duty_Amt"=' || CHANGE_DUTY_AMT;
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Vat_Amt"=' || CHANGE_VAT_AMT;
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Total_Amt"=' || CHANGE_TOTAL_AMT;
            
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Perm_Amt"=' || CHANGE_PERM_AMT;
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Duty_Amt"=' || CHANGE_DUTY_AMT;
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Vat_Amt"=' || CHANGE_VAT_AMT;
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Total_Amt"=' || CHANGE_TOTAL_AMT;
        ELSE
            CHANGE_PERM_AMT = 0;
            CHANGE_DUTY_AMT = 0;
            CHANGE_VAT_AMT = 0;
            CHANGE_TOTAL_AMT = 0;
        
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Perm_Amt"=0';
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Duty_Amt"=0';
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Vat_Amt"=0';
            UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Total_Amt"=0';
            
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Perm_Amt"=0';
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Duty_Amt"=0';
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Vat_Amt"=0';
            UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Total_Amt"=0';
        END IF;
        
        IF FLAG_ENDORSE_05 = 'y' THEN
            IF POLICY_TYPE = '0' THEN
                    RTN_DOC_TYPE = 'v0_05'; -- ปร1 รย05
            ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_05'; -- รยภ01 รย05
            ELSE
                RTN_DOC_TYPE = 'v1_05'; -- รย05
            END IF;
        END IF;
        -- R2.5 CR
        IF FLAG_ENDORSE_18 = 'y' AND CHANGE_PERM_AMT != 0 AND FLAG_ENDORSE_18_C != 'y' THEN
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_18'; -- รยภ01 รย17/รย18
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_18'; -- รย17/รย18
            END IF;
        END IF;
        IF FLAG_ENDORSE_18 = 'y' AND CHANGE_PERM_AMT != 0 AND FLAG_ENDORSE_18_C = 'y' THEN
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_18'; -- รยภ01 รย17/รย18+CCTV v5_18_c
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_18'; -- รย17/รย18+CCTV v1_18_c
            END IF;
        END IF;
        IF FLAG_ENDORSE_18 != 'y' AND FLAG_ENDORSE_18_P = 'y' AND CHANGE_PERM_AMT != 0 AND FLAG_ENDORSE_18_C != 'y' THEN
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_18_p'; -- รยภ01 รย18
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_18_p'; -- รย18
            END IF;
        END IF;
        IF FLAG_ENDORSE_18 != 'y' AND FLAG_ENDORSE_18_P = 'y' AND CHANGE_PERM_AMT != 0 AND FLAG_ENDORSE_18_C = 'y' THEN
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_18_p'; -- รยภ01 รย18+CCTV v5_18_pc
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_18_p'; -- รย18+CCTV v1_18_pc
            END IF;
        END IF;
        --MSG = '18=' || FLAG_ENDORSE_18 || ' - 18_P=' || FLAG_ENDORSE_18_P || ' - 18_C=' || FLAG_ENDORSE_18_C || ' - RTN=' || RTN_DOC_TYPE || ' - CHANGE_PERM_AMT=' || CHANGE_PERM_AMT;
        IF (FLAG_ENDORSE_18 = 'y' or FLAG_ENDORSE_18_P = 'y') AND CHANGE_PERM_AMT = 0 then
            ONCE_ENDORSE_TXT = '17';
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_17'; -- รยภ01 รย17
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_17'; -- รย17
            END IF;
        END IF;
        IF FLAG_ENDORSE_26 = 'y' THEN
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_26'; -- รยภ01 รย26
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_26'; -- รย26
            END IF;
        END IF;
        IF FLAG_ENDORSE_27 = 'y' THEN
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_27'; -- รยภ01 รย27
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_27'; -- รย27
            END IF;
        END IF;
        IF FLAG_ENDORSE_28 = 'y' THEN
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_28'; -- รยภ01 รย28
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_28'; -- รย28
            END IF;
        END IF;
        -- R2.5 CR
        IF FLAG_ENDORSE_20 = 'y' AND (RTN_DOC_TYPE IS NULL OR RTN_DOC_TYPE='') and FLAG_ENDORSE_20_A != 'y' THEN
            ONCE_ENDORSE_TXT='20';
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_20'; -- รยภ01 รย20
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_20'; -- รย20
            END IF;
        END IF;
        IF FLAG_ENDORSE_20 = 'y' AND (RTN_DOC_TYPE IS NULL OR RTN_DOC_TYPE='') and FLAG_ENDORSE_20_A = 'y' THEN
            ONCE_ENDORSE_TXT='20';
            IF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_20'; -- รยภ01 รย20+ACCESSERY v5_20_a
            ELSIF POLICY_TYPE = '1' OR POLICY_TYPE = '3' THEN
                RTN_DOC_TYPE = 'v1_20'; -- รย20+ACCESSERY v1_20_a
            END IF;
        END IF;
    ELSE
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Perm_Amt"=0';
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Duty_Amt"=0';
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Vat_Amt"=0';
        UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"Change_Total_Amt"=0';
        
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Perm_Amt"=0';
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Duty_Amt"=0';
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Vat_Amt"=0';
        UPDATE_QUERY_MVC_3 = UPDATE_QUERY_MVC_3 || ',"Change_Total_Amt"=0';
        IF FLAG_ENDORSE_17 = 'y' THEN
            IF POLICY_TYPE = '0' THEN
                RTN_DOC_TYPE = 'v0_17'; -- ปร1 รย17
            ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_17'; -- รยภ01 รย17
            ELSE
                RTN_DOC_TYPE = 'v1_17'; -- รย17
            END IF;
        ELSIF FLAG_ENDORSE_17_NT = 'y' THEN
            IF POLICY_TYPE = '0' THEN
                RTN_DOC_TYPE = 'v0_17_nt'; -- ปร1 รย17 ไม่ออกเอกสาร
            ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_17_nt'; -- รยภ01 รย17 ไม่ออกเอกสาร
            ELSE
                RTN_DOC_TYPE = 'v1_17_nt'; -- ร.ย.17 ไม่ออกเอกสาร
            END IF;
        ELSIF FLAG_ENDORSE_19 = 'y' THEN
            IF POLICY_TYPE = '0' THEN
                RTN_DOC_TYPE = 'v0_19'; -- ปร1 รย19
            ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_19'; -- รยภ01 รย19
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
        ELSIF FLAG_ENDORSE_23_T = 'y' THEN
            IF POLICY_TYPE = '0' THEN
                RTN_DOC_TYPE = 'v0_23_t'; -- ปร.1 (23) เฉพาะใบกำกับภาษี
            ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_23_t'; -- ร.ย.ภ.00 (23) เฉพาะใบกำกับภาษี
            ELSE
                RTN_DOC_TYPE = 'v1_23_t'; -- ร.ย.23 เฉพาะใบกำกับภาษี
            END IF;
        ELSIF FLAG_ENDORSE_23_NT = 'y' THEN
            IF POLICY_TYPE = '0' THEN
                RTN_DOC_TYPE = 'v0_23_nt'; -- ปร1 รย23 ไม่ออกเอกสาร
            ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_23_nt'; -- รยภ01 รย23 ไม่ออกเอกสาร
            ELSE
                RTN_DOC_TYPE = 'v1_23_nt'; -- ร.ย.23 ไม่ออกเอกสาร
            END IF;
        ELSIF FLAG_ENDORSE_24 = 'y' THEN
            IF POLICY_TYPE = '0' THEN
                RTN_DOC_TYPE = 'v0_24'; -- ปร1 รย24
            ELSIF POLICY_TYPE = '2+' OR POLICY_TYPE = '3+' THEN
                RTN_DOC_TYPE = 'v5_24'; -- รยภ01 รย24
            ELSE
                RTN_DOC_TYPE = 'v1_24'; -- รย24
            END IF;
        END IF;
    END IF;
    IF RTN_DOC_TYPE IS NULL OR RTN_DOC_TYPE = '' THEN
                RTN_DOC_TYPE = 'not_found';
                MSG = 'Document Type Mapping Issue.';
    END IF;
    
    IF (C_PREM_AMT is not null and C_PREM_AMT < 0) or (C_TOTAL_AMT is not null and C_TOTAL_AMT < 0) then
        FLAG_TOTAL_AMT_ERR = 'y';
        MSG = 'Total Amount < 0';
    END IF;
    
    --RUNNING_NO = 1;
    IF LOWER(SF_APPR_STATUS) = 'rejected' OR LOWER(SF_APPR_STATUS) = 'reject'
    OR LOWER(SF_APPR_STATUS) = 'cancel' OR LOWER(SF_APPR_STATUS) = 'canceled' OR LOWER(SF_APPR_STATUS) = 'cancellation'
  THEN
        MSG = SF_APPR_STATUS || ' : ' || COALESCE(SF_APPR_COMMENT,'ไม่ระบุสาเหตุ');
        IN_POLICY_TYPE = 'R';
    END IF;
    
    --MSG = COALESCE(MSG,'') || ' ,IN_POLICY_TYPE:' || COALESCE(IN_POLICY_TYPE,'NULL') || ' ,RTN_DOC_TYPE:' || COALESCE(RTN_DOC_TYPE,'NULL'); 
    --MSG = COALESCE(MSG,'') || ' ,SF_APPR_STATUS:' || COALESCE(SF_APPR_STATUS,'NULL'); 
    IF IN_POLICY_TYPE != 'F' AND IN_POLICY_TYPE != 'R' AND RTN_DOC_TYPE IS NOT NULL AND RTN_DOC_TYPE != '' 
    AND RTN_DOC_TYPE != 'not_found'
    AND FLAG_TOTAL_AMT_ERR != 'y'
    THEN
        ENDORSE_DOC_TYPE = RTN_DOC_TYPE;
        IF IN_POLICY_TYPE = 'V' THEN
            IF UPDATE_QUERY_MV IS NOT NULL OR UPDATE_QUERY_MVC != '' 
            OR UPDATE_QUERY_MVC_1 != '' OR UPDATE_QUERY_MVC_2 != '' OR UPDATE_QUERY_MVC_3 != '' THEN
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
                
                IF (UPDATE_QUERY_MVC IS NOT NULL AND UPDATE_QUERY_MVC != '')
                THEN
                    EXECUTE
                    'UPDATE insurverse."Policy_coverage_premium"
                    SET  "Update_date"=now()' 
                    || UPDATE_QUERY_MVC ||
                    ' WHERE "Policy_No"=''' || IN_POLICY_NO || '''';
                END IF;
                IF (UPDATE_QUERY_MVC_1 IS NOT NULL AND UPDATE_QUERY_MVC_1 != '')
                THEN
                    EXECUTE
                    'UPDATE insurverse."Policy_coverage_premium"
                    SET  "Update_date"=now()' 
                    || UPDATE_QUERY_MVC_1 ||
                    ' WHERE "Policy_No"=''' || IN_POLICY_NO || '''';
                END IF;
                IF (UPDATE_QUERY_MVC_2 IS NOT NULL AND UPDATE_QUERY_MVC_2 != '')
                THEN
                    EXECUTE
                    'UPDATE insurverse."Policy_coverage_premium"
                    SET  "Update_date"=now()' 
                    || UPDATE_QUERY_MVC_2 ||
                    ' WHERE "Policy_No"=''' || IN_POLICY_NO || '''';
                END IF;
                IF (UPDATE_QUERY_MVC_3 IS NOT NULL AND UPDATE_QUERY_MVC_3 != '')
                THEN
                    EXECUTE
                    'UPDATE insurverse."Policy_coverage_premium"
                    SET  "Update_date"=now()' 
                    || UPDATE_QUERY_MVC_3 ||
                    ' WHERE "Policy_No"=''' || IN_POLICY_NO || '''';
                END IF;
                
                SELECT insurverse.fn_sf_policy_endorse_detail(UP_POLICY_NO, IN_POLICY_TYPE,RTN_DOC_TYPE,UP_TRANS_ID,CHANGE_TOTAL_AMT,SYS_EFF_DATE,RTN_CCTV_ACTION,RTN_ACCESSORY_ACTION)
                INTO DETAIL_RESULT;
                ----------------------------------------------------------------
                -- Manage Driver 1-5 เช็คว่ามีผู้ขับขี่ใดที่ 1-5 ถูกลบออกหรือไม่
                ----------------------------------------------------------------
                IF FLAG_ENDORSE_26 = 'y' OR FLAG_ENDORSE_27 = 'y' OR FLAG_ENDORSE_28 = 'y' THEN
                    -- Dynamic driver compacting using helper function
                    DECLARE
                        i INT;
                        j INT;
                        driver_first_name TEXT;
                        first_name_slot TEXT;

                     -- mapping case-sensitive column names
                        col_map jsonb := '{
                            "1": "Par_first_name_1",
                            "2": "Par_first_name_2",
                            "3": "par_first_name_3",
                            "4": "par_first_name_4",
                            "5": "par_first_name_5"
                        }'::jsonb;
                    
                        col_i TEXT;
                        col_j TEXT;

                    BEGIN
                        -- Compact drivers by moving non-empty drivers to front positions
                        FOR i IN 2..5 LOOP

                        col_i := col_map ->> i::text;
                
                        EXECUTE format('SELECT %I FROM insurverse."Policy_Header" WHERE "Policy_No"=$1',
                                        col_i)
                        INTO driver_first_name USING IN_POLICY_NO;

                            IF driver_first_name IS NOT NULL AND driver_first_name != '' THEN
                                FOR j IN 1..(i-1) LOOP
                                    col_j := col_map ->> j::text;
                                    EXECUTE format('SELECT %I FROM insurverse."Policy_Header" WHERE "Policy_No"=$1',col_j)
                                    INTO first_name_slot USING IN_POLICY_NO;
                                    
                                    IF first_name_slot IS NULL OR first_name_slot = '' THEN
                                        PERFORM insurverse."fn_move_driver_fields"(i, j, IN_POLICY_NO);
                                        EXIT;
                                    END IF;
                                END LOOP;
                            END IF;
                        END LOOP;
                    END;
                END IF;
            END IF;
        ELSIF IN_POLICY_TYPE = 'C' THEN
            IF UPDATE_QUERY_MC IS NOT NULL AND UPDATE_QUERY_MC != '' THEN
                SELECT "rtn_car_act_no","trans_id"
                FROM insurverse."fn_policy_trans_history_caract"(IN_CAR_ACT_NO)
                INTO UP_POLICY_NO,UP_TRANS_ID;
            
                IF hp IS NOT NULL THEN
                    UPDATE_QUERY_MC = UPDATE_QUERY_MC || ',"hp"=' || hp::text;
                END IF;
                
                EXECUTE
                'UPDATE insurverse."Policy_Car_Act_Discount_Premium"
                SET "Update_date"=now(),
                "Appr_prefix_name"=''' || "appr_prefix_name" || ''','
                '"Appr_first_name"=''' || "appr_first_name" || ''','
                '"Appr_last_name"=''' || "appr_last_name" || '''' 
                || UPDATE_QUERY_MC || '
                WHERE "Car_Act_No"=''' || IN_CAR_ACT_NO || '''';
                
                SELECT insurverse.fn_sf_policy_endorse_detail(IN_CAR_ACT_NO, IN_POLICY_TYPE,RTN_DOC_TYPE,UP_TRANS_ID,CHANGE_TOTAL_AMT,SYS_EFF_DATE,RTN_CCTV_ACTION,RTN_ACCESSORY_ACTION)
                INTO DETAIL_RESULT;
            END IF;
        END IF;
        
        IF FLAG_ENDORSE_23 = 'y' AND FLAG_CHANGE_OWNER='n' AND UPDATE_QUERY_MP IS NOT NULL AND MP_PAR_ID IS NOT NULL THEN
            EXECUTE
            'UPDATE insurverse."policy_participant"
            SET  "update_date"=now()' 
            || UPDATE_QUERY_MP ||
            ' WHERE "par_id"=''' || MP_PAR_ID || '''';
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
    
    UPDATE insurverse."log_sf_policy_trans_request"
    SET "appr_status"=SF_APPR_STATUS,"appr_comment"=SF_APPR_COMMENT,"salesforce_callback_at"=now()
    WHERE "log_sf_policy_trans_request"."salesforce_id"=SF_ID;

    --MSG=UPDATE_QUERY_MVC || UPDATE_QUERY_MVC_1 || UPDATE_QUERY_MVC_2 || UPDATE_QUERY_MVC_3;
    RETURN QUERY SELECT RUNNING_NO,MSG,UP_TRANS_ID,ENDORSE_DOC_TYPE,IN_POLICY_TYPE,IN_POLICY_NO,IN_CAR_ACT_NO,RTN_DOC_TYPE_NAME,RTN_DOC_TYPE_SHORT,SF_ID,ONCE_ENDORSE_TXT;
END
$function$
;
