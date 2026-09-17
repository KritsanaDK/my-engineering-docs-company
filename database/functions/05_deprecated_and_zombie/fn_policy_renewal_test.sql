-- =============================================================================
-- Function: insurverse.fn_policy_renewal_test
-- OID: 18782
-- Identity Arguments: (in_policy_no text, in_flag_noti boolean, in_flag_lead boolean)
-- Returns: TABLE(rtn_success boolean, rtn_ncb_tier integer, rtn_error_code text, rtn_msg text, rtn_policy_no text, rtn_prem_amt numeric, rtn_duty_amt numeric, rtn_vat_amt numeric, rtn_total_amt numeric, rtn_is_compulsory boolean, rtn_together_policy text, rtn_lead_no integer, rtn_log_noti_id integer, rtn_json_body text, rtn_prem_act numeric)
-- Language: plpgsql
-- Categorization: 05_deprecated_and_zombie
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_test(in_policy_no text, in_flag_noti boolean, in_flag_lead boolean)
 RETURNS TABLE(rtn_success boolean, rtn_ncb_tier integer, rtn_error_code text, rtn_msg text, rtn_policy_no text, rtn_prem_amt numeric, rtn_duty_amt numeric, rtn_vat_amt numeric, rtn_total_amt numeric, rtn_is_compulsory boolean, rtn_together_policy text, rtn_lead_no integer, rtn_log_noti_id integer, rtn_json_body text, rtn_prem_act numeric)
 LANGUAGE plpgsql
AS $function$
DECLARE
    -- return result
    RTN_SUCCESS BOOL; RTN_MSG TEXT; RTN_ERROR_CODE TEXT;
    RTN_NCB_TIER INTEGER; RTN_POLICY_NO TEXT;
    RTN_PREM_AMT NUMERIC; RTN_DUTY_AMT NUMERIC;
    RTN_VAT_AMT NUMERIC; RTN_TOTAL_AMT NUMERIC;
    RTN_JSON_BODY TEXT; RTN_PREM_ACT NUMERIC;
    RTN_LEAD_NO INTEGER; RTN_LOG_NOTI_ID INTEGER;
    RTN_IS_COMPULSORY BOOL; RTN_TOGETHER_POLICY TEXT;
    -- log
    LOG_TARIFF TEXT;
    -- center parameter
    SYS_TEST_RUN BOOLEAN;
    SYS_LAST_LOG_NOTI_ID INTEGER; SYS_CUR_DATE TIMESTAMP;
    SYS_PRODUCT TEXT; SYS_POLICY_NO TEXT; SYS_SUB_PRODUCT TEXT;
    SYS_EMAIL TEXT; SYS_MOBILE TEXT;
    SYS_MC_MV_NO TEXT; SYS_MC_NO TEXT;
    SYS_POLICY_OLD_ENDDATE TIMESTAMP;
    SYS_NCB_TIER INTEGER;
    SYS_PROMO_TRANS_ID INTEGER; SYS_PROMO_DISC_PERC NUMERIC;
    SYS_GARAGETYPE TEXT;
    SYS_REF_POLICY_NO TEXT; SYS_REF_POLICY_NO_PURE TEXT;
    SYS_PREMIUM_AMT NUMERIC; SYS_CLAIM_AMT NUMERIC; SYS_CLAIM_RATE NUMERIC;
    SYS_MV_STARTDATE TIMESTAMP; SYS_MV_ENDDATE TIMESTAMP;
    SYS_MC_STARTDATE TIMESTAMP; SYS_MC_ENDDATE TIMESTAMP;
    SYS_REMARK TEXT;
    -- mc premium
    IC_PREMIUM DECIMAL(18,2); IC_DISCOUNT DECIMAL(18,2); IC_NET_PREMIUM DECIMAL(18,2);
    IC_STAMP DECIMAL(18,2); IC_VAT DECIMAL(18,2); IC_TOTAL DECIMAL(18,2);
    -- mas_renewal_config
    CON_NOTI_1 NUMERIC; CON_NOTI_2 NUMERIC; CON_NOTI_3 NUMERIC;
    CON_SI_REDUCE_PERC NUMERIC; CON_BASE_ADD_AMT NUMERIC;
    CON_AGE_MAX NUMERIC; CON_CLAIM_RESERVE NUMERIC;
    CON_PREMIUM_MIN NUMERIC;
    -- tariff si and discount parameter
    TR_NCB_TIER NUMERIC;
    TR_CAR_BRAND TEXT; TR_CAR_MODEL TEXT; TR_CAR_YEAR TEXT; TR_GARAGETYPE TEXT;
    TR_NAMEDAGE TEXT; TR_PAR1_YEAR INTEGER; TR_PAR2_YEAR INTEGER;
    TR_USAGE INTEGER; TR_CC TEXT; TR_GROUP TEXT; TR_COMP_CODE TEXT;
    TR_BASE_PREMIUM NUMERIC; TR_BASE_PREMIUM_V5 NUMERIC;
    TR_SI_LIMIT NUMERIC; TR_ACCESS_LIMIT NUMERIC; TR_TPBI_LIMIT NUMERIC; TR_TPPD_LIMIT NUMERIC;
    TR_MV01_LIMIT NUMERIC; TR_MV02_LIMIT NUMERIC; TR_MV03_LIMIT NUMERIC;
    TR_MV01_AMT NUMERIC; TR_MV02_AMT NUMERIC; TR_MV03_AMT NUMERIC;
    TR_FLEET_PERC NUMERIC; TR_NCB_PERC NUMERIC; TR_OTHER_PERC NUMERIC;
    TR_DUTY_PERC NUMERIC; TR_VAT_PERC NUMERIC;
    TR_BODYTYPE TEXT; TR_DOOR INTEGER;
    TR_FLAG_ACT TEXT; TR_PREM_ACT NUMERIC;
    TR_MV_ENDDATE TIMESTAMP; TR_MC_ENDDATE TIMESTAMP;
    -- tariff factor
    TRF_USAGE NUMERIC; TRF_CC NUMERIC; TRF_DRIVER NUMERIC;
    TRF_CAR_YEAR NUMERIC; TRF_SI NUMERIC; TRF_CAR_GROUP NUMERIC;
    TRF_TPBI NUMERIC; TRF_TPPD NUMERIC; TRF_SI_V5 NUMERIC;
    -- new amount PARAMETER
    NEW_CAR_AGE INTEGER; NEW_CAR_CC TEXT;
    NEW_YEAR_DRIVER NUMERIC; NEW_AGE_DRIVER INTEGER; NEW_NAMEDAGE TEXT;
    NEW_FLEET_AMT NUMERIC; NEW_NCB_AMT NUMERIC; NEW_OTHER_AMT NUMERIC;
    NEW_TOTAL_AMT_EX_MV NUMERIC; NEW_TOTAL_AMT_MV NUMERIC; NEW_PREMIUM_V5_OD NUMERIC;
    NEW_TOTAL_AMT_EX_MV_NO_DRIVER NUMERIC; NEW_DRIVER_DISCOUNT NUMERIC;
BEGIN
    /*
    example::
    SELECT "rtn_success", "rtn_ncb_tier", "rtn_error_code", "rtn_msg", "rtn_policy_no", "rtn_prem_amt", "rtn_duty_amt", "rtn_vat_amt", "rtn_total_amt","rtn_is_compulsory","rtn_together_policy", "rtn_lead_no", "rtn_log_noti_id", "rtn_json_body"
    FROM insurverse."fn_policy_renewal"('MV-0024-A-000011',false,false)
    */

-- ERROR_CODE
-- ### Function Error
-- ER001 = Policy Number is not found.
-- ER002 = Premium Amount is equal 0.
-- ER003 = Config Data is not found.
-- ER005 = The policy number has already been renewed.
-- ER006 = The policy number has expired.
-- ER009 = Compulsory Master Data is not found.
-- ### Sub Function Error
-- ER100 = Function is not success.
-- ER101 = Pure loss NCB master data is not found.
-- ER102 = Cosmetic and other NCB master data is not found.
-- ### Can renewal but new purchase
-- PE001 = The age of the car cannot choose the same type of garage for insurance renewal.
-- PE002 = The age of the car prevents the insurance policy from being renewed in the same coverage class.
-- PE003 = The insurance premium must be lower than the minimum insurance premium.

    -- set DEFAULT
    SYS_TEST_RUN = false;
    RTN_SUCCESS = true;
    RTN_IS_COMPULSORY = false;
    RTN_PREM_AMT = 0;
    RTN_DUTY_AMT = 0;
    RTN_VAT_AMT = 0;
    RTN_TOTAL_AMT = 0;

    -- check last log_noti_renewal
    select "id","create_at"
    from insurverse."log_noti_renewal"
    where "policy_no"="in_policy_no"
    order by "id" desc
    limit 1
    into SYS_LAST_LOG_NOTI_ID,SYS_CUR_DATE;

    -- set SYS_CUR_DATE is null = now()
    IF SYS_CUR_DATE IS NULL THEN SYS_CUR_DATE = now(); END IF;

    -- check product
    SYS_PRODUCT = lower(substr("in_policy_no",1,2));
    -- check policy no
    IF SYS_PRODUCT = 'mc' THEN
        SELECT "policy"."Car_Act_No",'0',
               "policy"."Brand","policy"."Model","policy"."Year",
               "policy"."End_date",
               "policy_mv"."Policy_No","policy"."Car_Comp_Code",
               "policy"."BodyType","policy"."Doors",
               "policy"."End_date","policy"."email"
        FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                 LEFT JOIN insurverse."Policy_Header" as "policy_mv"
                           ON "policy"."Policy_No"="policy_mv"."Policy_No"
                               AND CAST("policy"."End_date"+INTERVAL'7HOUR' as DATE)=CAST("policy_mv"."Policy_Enddate"+INTERVAL'7HOUR' as DATE)
        WHERE "policy"."Car_Act_No"="in_policy_no"
        INTO SYS_POLICY_NO,SYS_SUB_PRODUCT,
            TR_CAR_BRAND,TR_CAR_MODEL,TR_CAR_YEAR,
            SYS_POLICY_OLD_ENDDATE,
            SYS_MC_MV_NO,TR_COMP_CODE,
            TR_BODYTYPE,TR_DOOR,
            TR_MC_ENDDATE,SYS_EMAIL;

        RTN_TOGETHER_POLICY = SYS_MC_MV_NO;
        SYS_MC_STARTDATE = TR_MC_ENDDATE;
        SYS_MC_ENDDATE = TR_MC_ENDDATE + INTERVAL '1YEAR';

        select "ref_policy_no"
        from insurverse."Policy_Car_Act_Discount_Premium"
        where "ref_policy_no"="in_policy_no"
        INTO SYS_REF_POLICY_NO;

        IF SYS_REF_POLICY_NO IS NULL THEN
            select "ref_policy_no"
            from insurverse."Lead_Car_Act_Discount_Premium"
            where "ref_policy_no"="in_policy_no"
              and UPPER("Payment_status")='SUCCESS'
            INTO SYS_REF_POLICY_NO;
        END IF;

        select "ref_policy_no"
        from insurverse."Policy_Header"
        where "ref_policy_no"=SYS_MC_MV_NO
        INTO SYS_REF_POLICY_NO_PURE;

        IF SYS_REF_POLICY_NO_PURE IS NOT NULL THEN
            SYS_REF_POLICY_NO_PURE = null;
            SYS_MC_MV_NO = null;
            RTN_TOGETHER_POLICY = null;
        END IF;
    end if;

    IF SYS_MC_MV_NO IS NOT NULL THEN
        SYS_PRODUCT = 'mv';
        SYS_MC_NO = SYS_POLICY_NO;
        SYS_POLICY_NO = null;
        "in_policy_no" = SYS_MC_MV_NO;
    END IF;

    IF SYS_PRODUCT = 'mv' THEN
        SELECT "policy"."Policy_No",
               CASE WHEN "policy"."Car_Act_No" IS NOT NULL AND CAST("policy"."Policy_Enddate"+INTERVAL'7HOUR' AS DATE) = (SELECT CAST("End_date"+INTERVAL'7HOUR' AS DATE) FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy_mc" WHERE "policy"."Car_Act_No"="policy_mc"."Car_Act_No")
                        THEN "policy"."Car_Act_No" ELSE NULL END as "Car_Act_No",
               "policy"."Type",
               "policy"."Brand","policy"."Model","policy"."Year","policy"."GarageType",
               "prem"."BodyType","prem"."Doors",
               "policy"."Policy_Enddate",
               "prem"."Basic_Premium","prem"."basic_premium_v5",
               "prem"."SI_Limit","prem"."SI_Access_Limit","prem"."SI_TPBI_Limit","prem"."SI_TPPD_Limit",
               "prem"."SI_MV01_Limit","prem"."SI_MV02_Limit","prem"."SI_MV03_Limit",
               "prem"."SI_MV01_Amt","prem"."SI_MV02_Amt","prem"."SI_MV03_Amt",
               "prem"."Fleet_Disc_perc","prem"."NCB_Disc_perc","prem"."Other_Disc_perc",
               "prem"."NamedAge","prem"."YOB_Driver_1","prem"."YOB_Driver_2",
               "prem"."Usage","policy"."CC","policy"."Group",
               "prem"."promo_trans_id","prem"."promo_discount_per",
               "prem"."Flag_Car_Act","policy"."Policy_Enddate",
               "policy"."email"
        FROM insurverse."Policy_Header" as "policy"
                 INNER JOIN insurverse."Policy_coverage_premium" as "prem"
                            ON "policy"."Policy_No"="prem"."Policy_No"
                                AND "policy"."Policy_No"="in_policy_no"
        INTO SYS_POLICY_NO,SYS_MC_NO,SYS_SUB_PRODUCT,
            TR_CAR_BRAND,TR_CAR_MODEL,TR_CAR_YEAR,TR_GARAGETYPE,
            TR_BODYTYPE,TR_DOOR,
            SYS_POLICY_OLD_ENDDATE,
            TR_BASE_PREMIUM,TR_BASE_PREMIUM_V5,
            TR_SI_LIMIT,TR_ACCESS_LIMIT,TR_TPBI_LIMIT,TR_TPPD_LIMIT,
            TR_MV01_LIMIT,TR_MV02_LIMIT,TR_MV03_LIMIT,
            TR_MV01_AMT,TR_MV02_AMT,TR_MV03_AMT,
            TR_FLEET_PERC,TR_NCB_PERC,TR_OTHER_PERC,
            TR_NAMEDAGE,TR_PAR1_YEAR,TR_PAR2_YEAR,
            TR_USAGE,TR_CC,TR_GROUP,
            SYS_PROMO_TRANS_ID,SYS_PROMO_DISC_PERC,
            TR_FLAG_ACT,TR_MV_ENDDATE,
            SYS_EMAIL;

        RTN_TOGETHER_POLICY = SYS_MC_NO;
        IF TR_MV_ENDDATE IS NOT NULL THEN
            SYS_MV_STARTDATE = TR_MV_ENDDATE;
            SYS_MV_ENDDATE = TR_MV_ENDDATE + INTERVAL '1YEAR';
        END IF;

        SELECT "Total"
        FROM insurverse."Imp_Discount_Premium"
        WHERE "Brand"=TR_CAR_BRAND AND "Model"=TR_CAR_MODEL AND "Year"=TR_CAR_YEAR
          AND "BodyType"=TR_BODYTYPE AND "Doors"=TR_DOOR
        LIMIT 1
        INTO TR_PREM_ACT;

        IF TR_PREM_ACT IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER009';
            RTN_MSG = 'Compulsory Master Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        select "ref_policy_no"
        from insurverse."Policy_Header"
        where "ref_policy_no"="in_policy_no"
        INTO SYS_REF_POLICY_NO;

        IF SYS_REF_POLICY_NO IS NULL THEN
            select "ref_policy_no"
            from insurverse."Lead_coverage_premium"
            where "ref_policy_no"="in_policy_no"
              and UPPER("Payment_status")='SUCCESS'
            INTO SYS_REF_POLICY_NO;
        END IF;

        -- Total MV + MC
        IF TR_FLAG_ACT IS NOT NULL AND UPPER(TR_FLAG_ACT) = 'Y' AND SYS_MC_NO IS NOT NULL THEN
            RTN_PREM_ACT = TR_PREM_ACT;
            SYS_MC_STARTDATE = SYS_MV_STARTDATE;
            SYS_MC_ENDDATE = SYS_MV_ENDDATE;
        ELSE
            SYS_MC_STARTDATE = NULL;
            SYS_MC_ENDDATE = NULL;
            TR_FLAG_ACT = 'N';
            RTN_PREM_ACT = 0;
        END IF;
    END IF;

    IF SYS_POLICY_NO IS NULL THEN
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER001';
        RTN_MSG = 'Policy Number is not found.';
        RTN_PREM_ACT = 0;
        SYS_POLICY_NO="in_policy_no";
        IF in_flag_noti = true THEN
--             INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--             VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--             RETURNING "id" INTO RTN_LOG_NOTI_ID;
        END IF;
        RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
        return;
    END IF;

    IF SYS_EMAIL IS NOT NULL THEN
        SELECT "mobile"
        FROM insurverse."sec_user"
        WHERE "email"=SYS_EMAIL
        INTO SYS_MOBILE;
    END IF ;

    RTN_POLICY_NO = SYS_POLICY_NO;

    IF SYS_TEST_RUN != true THEN
        IF SYS_REF_POLICY_NO IS NOT NULL OR SYS_REF_POLICY_NO_PURE IS NOT NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER005';
            RTN_MSG = 'The policy number has already been renewed.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;
    END IF;

    IF CAST(now() as TIMESTAMP) > CAST(SYS_POLICY_OLD_ENDDATE as TIMESTAMP) THEN
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER006';
        RTN_MSG = 'The policy number has expired.';
        RTN_PREM_ACT = 0;
        IF in_flag_noti = true THEN
--             INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--             VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--             RETURNING "id" INTO RTN_LOG_NOTI_ID;
        END IF;
        RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
        return;
    END IF;

    -- ==== mc renewal
    IF SYS_PRODUCT = 'mc' THEN
        RTN_IS_COMPULSORY = true;
        RTN_PREM_ACT = 0;
        SELECT "Premium","Discount","Net_Premium","Stamp","Vat","Total"
        FROM insurverse."Imp_Discount_Premium"
        WHERE "Brand"=TR_CAR_BRAND AND "Model"=TR_CAR_MODEL AND "Year"=TR_CAR_YEAR
          AND "BodyType"=TR_BODYTYPE AND "Doors"=TR_DOOR
        INTO IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,
            IC_STAMP,IC_VAT,IC_TOTAL;

        RTN_PREM_AMT = IC_NET_PREMIUM;
        RTN_DUTY_AMT = IC_STAMP;
        RTN_VAT_AMT = IC_VAT;
        RTN_TOTAL_AMT = IC_TOTAL;

        IF IC_TOTAL IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER009';
            RTN_MSG = 'Compulsory Master Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        IF in_flag_lead = true THEN
            select "Car_Act_Lead_No" from insurverse."Lead_Car_Act_Discount_Premium" order by "Car_Act_Lead_No" desc limit 1
            INTO RTN_LEAD_NO;
            IF RTN_LEAD_NO IS NULL THEN RTN_LEAD_NO = 1; ELSE RTN_LEAD_NO = RTN_LEAD_NO + 1; END IF;

            INSERT INTO insurverse."Lead_Car_Act_Discount_Premium"
            (
                "Car_Act_Lead_No","Brand","Model","Year",
                "Doors","Seat","Wg","Group","Type",
                "Sedan","BodyType","Start_date","End_date",
                "prefix_name","first_name","last_name",
                "birth_date","citizen_id",
                "province_id","subdistrict_id","district_id",
                "zipcode","countryid","phone",
                "Occupation","Remark","Car_Comp_Code",
                "Premium","Discount","Net_Premium","Stamp","Vat","Total",
                "CC",
                "Car_license_no","Car_license_provice","Car_serial_no",
                "Effective_Startdate","Effective_Enddate",
                "Comp_Code",
                "Deli_Addr_line1","Deli_Addr_line2","Deli_Addr_line3",
                "Deli_province_id","Deli_subdistrict_id","Deli_district_id",
                "Deli_zipcode","Deli_countryid",
                "Car_license_type","Car_color",
                "address","email",
                "Bene_Type","Bene_Title","Bene_Firstname","Bene_Midname",
                "Bene_Lastname","Bene_ID_card",
                "Flag_Deli","ref_policy_no"
            )
            SELECT RTN_LEAD_NO,"policy"."Brand","policy"."Model","policy"."Year",
                   "policy"."Doors","policy"."Seat","policy"."Wg","policy"."Group","policy"."Type",
                   "policy"."Sedan","policy"."BodyType",CAST(SYS_MC_STARTDATE as DATE),CAST(SYS_MC_ENDDATE as DATE),
                   "policy"."prefix_name","policy"."first_name","policy"."last_name",
                   "policy"."birth_date","policy"."citizen_id",
                   "policy"."province_id","policy"."subdistrict_id","policy"."district_id",
                   "policy"."zipcode","policy"."countryid",SYS_MOBILE,
                   "policy"."Occupation","policy"."Remark","policy"."Car_Comp_Code",
                   IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,IC_STAMP,IC_VAT,IC_TOTAL,
                   "policy"."CC",
                   "policy"."Car_license_no","policy"."Car_license_provice","policy"."Car_serial_no",
                   now(),SYS_MC_ENDDATE,
                   "policy"."Comp_Code",
                   "policy"."Deli_Addr_line1","policy"."Deli_Addr_line2","policy"."Deli_Addr_line3",
                   "policy"."Deli_province_id","policy"."Deli_subdistrict_id","policy"."Deli_district_id",
                   "policy"."Deli_zipcode","policy"."Deli_countryid",
                   "policy"."Car_license_type","policy"."Car_color",
                   "policy"."address","policy"."email",
                   "policy"."Bene_Type","policy"."Bene_Title","policy"."Bene_Firstname","policy"."Bene_Midname",
                   "policy"."Bene_Lastname","policy"."Bene_ID_card",
                   "policy"."Flag_Deli",SYS_POLICY_NO
            FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
            WHERE "policy"."Car_Act_No" = "in_policy_no";

            --RTN_MSG = 'RTN_LEAD_NO:' || RTN_LEAD_NO || ' ,SYS_MC_STARTDATE:' || SYS_MC_STARTDATE || ' ,SYS_MC_ENDDATE:' || SYS_MC_ENDDATE;
            --RTN_MSG = 'IC_PREMIUM:' || IC_PREMIUM || ' ,IC_DISCOUNT:' || IC_DISCOUNT || ' ,IC_NET_PREMIUM:' || IC_NET_PREMIUM || ' ,IC_STAMP:' || IC_STAMP || ' ,IC_VAT:' || IC_VAT || ' ,IC_TOTAL:' || IC_TOTAL;
        END IF;

        -- insert noti renewal mc
        IF in_flag_noti = true THEN
--             INSERT INTO insurverse.log_noti_renewal
--             (
--                 policy_no,premium_amt,duty_amt,vat_amt,total_amt,
--                 msg_html_body,msg_sms_body,msg_html_title,
--                 msg_push_body,is_active,
--                 is_renewal,error_code,return_message
--             )
--             VALUES (
--                        SYS_POLICY_NO,IC_NET_PREMIUM,IC_STAMP,IC_VAT,IC_TOTAL,
--                        NULL,NULL,NULL,
--                        NULL,true,
--                        true,NULL,NULL
--                    )
--             RETURNING "id" INTO RTN_LOG_NOTI_ID;
        END IF;

        RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
        return;
    END IF;

    -- ==== set config data

    -- check ncb tier FUNCTION
    SELECT "rn_ncb"."rtn_ncb_tier","rn_ncb"."rtn_success","rn_ncb"."rtn_error_code","rn_ncb"."rtn_msg"
    FROM insurverse."fn_policy_renewal_ncb"("in_policy_no") as "rn_ncb"
    INTO TR_NCB_TIER,RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG;

    IF RTN_SUCCESS = false THEN
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER100';
        RTN_MSG = 'Function is not success.';
        RTN_PREM_ACT = 0;
        RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
        return;
    END IF;

    IF SYS_PRODUCT = 'mv' THEN
        -- check config data mv
        -- CON_SI_REDUCE_PERC
        select "renewal_num"
        from insurverse."mas_renewal_config" as "rn_config"
        where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
          and "rn_config"."renewal_type"='tariff' and "rn_config"."renewal_code"='reduce_si'
        into CON_SI_REDUCE_PERC;

        IF CON_SI_REDUCE_PERC IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[CON_SI_REDUCE_PERC] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- CON_BASE_ADD_AMT
        select "renewal_num"
        from insurverse."mas_renewal_config" as "rn_config"
        where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
          and "rn_config"."renewal_type"='tariff' and "rn_config"."renewal_code"='add_base'
        into CON_BASE_ADD_AMT;

        IF CON_BASE_ADD_AMT IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[CON_BASE_ADD_AMT] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- ==== set tariff config

        -- set duty percent
        SELECT "para_value" FROM insurverse.sys_param WHERE dom_code='purchase' and sub_dom_code='duty' and para_code='duty_per'
        INTO TR_DUTY_PERC;

        IF TR_DUTY_PERC IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TR_DUTY_PERC] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- set vat percent
        SELECT "para_value" FROM insurverse.sys_param WHERE dom_code='purchase' and sub_dom_code='vat' and para_code='vat_per'
        INTO TR_VAT_PERC;

        IF TR_VAT_PERC IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TR_VAT_PERC] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- set tariff usage
        SELECT COALESCE("tariff_factor",0)
        FROM insurverse."mas_tariff"
        WHERE REPLACE(SYS_SUB_PRODUCT,'+','')="mas_tariff"."policy_type"
          AND "mas_tariff"."tariff_group"='motor' AND "mas_tariff"."tariff_code"='usage'
          AND LOWER("tariff_mapping") = CAST(TR_USAGE as TEXT)
        INTO TRF_USAGE;

        IF TRF_USAGE IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_USAGE] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- set tariff group
        SELECT COALESCE("tariff_factor",0)
        FROM insurverse."mas_tariff"
        WHERE REPLACE(SYS_SUB_PRODUCT,'+','')="mas_tariff"."policy_type"
          AND "mas_tariff"."tariff_group"='motor' AND "mas_tariff"."tariff_code"='vehicle_group'
          AND LOWER("tariff_mapping") = CAST(TR_GROUP as TEXT)
        INTO TRF_CAR_GROUP;

        IF TRF_CAR_GROUP IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_CAR_GROUP] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        IF TR_CC IS NOT NULL THEN
            TR_CC = REGEXP_REPLACE(TR_CC, '[^0-9]', '', 'g');
            IF TR_CC = '' THEN
                TR_CC = '0';
            END IF;
        END IF;
        -- set tariff cc
        SELECT COALESCE("tariff_factor",0),"tariff_mapping"
        FROM insurverse."mas_tariff"
        WHERE REPLACE(SYS_SUB_PRODUCT,'+','')="mas_tariff"."policy_type"
          AND "mas_tariff"."tariff_group"='motor' AND "mas_tariff"."tariff_code"='size'
          AND CAST(TR_CC as INTEGER) between tariff_num_min and tariff_num_max
        INTO TRF_CC,NEW_CAR_CC;

        IF TRF_CC IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_CC] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- set tariff car year
        NEW_CAR_AGE = CAST(TO_CHAR(SYS_POLICY_OLD_ENDDATE,'yyyy') as INTEGER) - CAST(TR_CAR_YEAR as INTEGER) + 1;
        --RTN_MSG = COALESCE(RTN_MSG,'') || ' - POLICY_ENDYEAR : ' || CAST(TO_CHAR(SYS_POLICY_OLD_ENDDATE,'yyyy') as INTEGER) || ' - CAR_YEAR : ' || CAST(TR_CAR_YEAR as INTEGER);
        SELECT COALESCE("tariff_factor",0)
        FROM insurverse."mas_tariff"
        WHERE REPLACE(SYS_SUB_PRODUCT,'+','')="mas_tariff"."policy_type"
          AND "mas_tariff"."tariff_group"='motor' AND "mas_tariff"."tariff_code"='vehicle_age'
          AND NEW_CAR_AGE between "tariff_num_min" and "tariff_num_max"
        LIMIT 1
        INTO TRF_CAR_YEAR;

        IF TRF_CAR_YEAR IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_CAR_YEAR] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- set tariff nameaged - YOB Driver
        IF (TR_PAR1_YEAR IS NOT NULL AND TR_PAR1_YEAR != 0)
            AND (TR_PAR2_YEAR IS NOT NULL AND TR_PAR2_YEAR != 0) THEN
            IF TR_PAR1_YEAR >= TR_PAR2_YEAR THEN
                NEW_YEAR_DRIVER = TR_PAR1_YEAR;
            ELSE
                NEW_YEAR_DRIVER = TR_PAR2_YEAR;
            END IF;
        ELSIF (TR_PAR1_YEAR IS NOT NULL AND TR_PAR1_YEAR != 0)
            AND (TR_PAR2_YEAR IS NULL OR TR_PAR2_YEAR = 0) THEN
            NEW_YEAR_DRIVER = TR_PAR1_YEAR;
        ELSIF (TR_PAR1_YEAR IS NULL OR TR_PAR1_YEAR = 0)
            AND (TR_PAR2_YEAR IS NOT NULL AND TR_PAR2_YEAR != 0) THEN
            NEW_YEAR_DRIVER = TR_PAR2_YEAR;
        ELSIF (TR_PAR1_YEAR IS NULL OR TR_PAR1_YEAR = 0)
            AND (TR_PAR2_YEAR IS NULL OR TR_PAR2_YEAR = 0) THEN
            NEW_YEAR_DRIVER = null;
        END IF;

        -- set tariff nameaged
        IF NEW_YEAR_DRIVER IS NOT NULL AND TR_NAMEDAGE != 'Unnamed' THEN
            -- set age new renewal startdate
            NEW_AGE_DRIVER = CAST(TO_CHAR(SYS_POLICY_OLD_ENDDATE,'yyyy') as INTEGER) - NEW_YEAR_DRIVER;

            select COALESCE("tariff_factor",0),"tariff_mapping"
            from insurverse.mas_tariff
            WHERE tariff_group='motor' AND "tariff_code"='driver_name'
              AND "policy_type"=REPLACE(SYS_SUB_PRODUCT,'+','')
              AND NEW_AGE_DRIVER between tariff_num_min and tariff_num_max
              AND tariff_mapping != 'Unnamed'
            INTO TRF_DRIVER,NEW_NAMEDAGE;
        ELSE
            select COALESCE("tariff_factor",0),"tariff_mapping"
            from insurverse.mas_tariff
            WHERE tariff_group='motor' AND "tariff_code"='driver_name'
              AND "policy_type"=REPLACE(SYS_SUB_PRODUCT,'+','')
              AND tariff_mapping=TR_NAMEDAGE
            INTO TRF_DRIVER,NEW_NAMEDAGE;
        END IF;

        IF TRF_DRIVER IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_DRIVER] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- set tariff si tpbi
        select COALESCE("tariff_factor",0)
        from insurverse.mas_tariff
        WHERE tariff_group='motor' AND "tariff_code"='vehicle_tpbi'
          AND "policy_type"=REPLACE(SYS_SUB_PRODUCT,'+','')
          AND TR_TPBI_LIMIT between tariff_num_min and tariff_num_max
        INTO TRF_TPBI;

        IF TRF_TPBI IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_TPBI] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- set tariff si tppd
        select COALESCE("tariff_factor",0)
        from insurverse.mas_tariff
        WHERE tariff_group='motor' AND "tariff_code"='vehicle_tppd'
          AND "policy_type"=REPLACE(SYS_SUB_PRODUCT,'+','')
          AND TR_TPPD_LIMIT between tariff_num_min and tariff_num_max
        INTO TRF_TPPD;

        IF TRF_TPPD IS NULL THEN
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_TPPD] Config Data is not found.';
            RTN_PREM_ACT = 0;
            IF in_flag_noti = true THEN
--                 INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                 VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                 RETURNING "id" INTO RTN_LOG_NOTI_ID;
            END IF;
            RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
            return;
        END IF;

        -- remove promo code discount percent
        IF SYS_PROMO_DISC_PERC IS NULL THEN SYS_PROMO_DISC_PERC = 0; END IF;
        TR_OTHER_PERC = TR_OTHER_PERC - SYS_PROMO_DISC_PERC;

        -- tariff calculator
        -- class 1 calculator
        IF SYS_SUB_PRODUCT = '1' THEN

            -- CON_AGE_MAX
            select "renewal_num"
            from insurverse."mas_renewal_config" as "rn_config"
            where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
              and "rn_config"."renewal_type"='car_age'
              and "rn_config"."renewal_mapping"=CAST(TR_USAGE as TEXT)
              and ("rn_config"."renewal_code"='year_sc' and TR_GARAGETYPE = 'SC'
                or "rn_config"."renewal_code"='year_g' and TR_GARAGETYPE = 'G')
            into CON_AGE_MAX;
            --RTN_MSG = 'CON_AGE_MAX: ' || CON_AGE_MAX;
            IF CON_AGE_MAX IS NULL THEN
                RTN_SUCCESS = false;
                RTN_ERROR_CODE = 'ER003';
                RTN_MSG = '[CON_AGE_MAX_'|| SYS_SUB_PRODUCT ||'] Config Data is not found.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            --CON_CLAIM_RESERVE
            select "renewal_num"
            from insurverse."mas_renewal_config" as "rn_config"
            where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
              and "rn_config"."renewal_type"='claim'
              and "rn_config"."renewal_code"='loss_reserve'
            into CON_CLAIM_RESERVE;

            IF CON_CLAIM_RESERVE IS NULL THEN
                RTN_SUCCESS = false;
                RTN_ERROR_CODE = 'ER003';
                RTN_MSG = '[CON_CLAIM_RESERVE] Config Data is not found.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            -- query permium_amt (exclude duty & vat)
            select "Perm_Amt"
            from insurverse."Policy_coverage_premium"
            where "Policy_No"="in_policy_no"
            into SYS_PREMIUM_AMT;

            -- query claim_amt (wrong side)
            SELECT sum("total_loss_reserve")
            from insurverse."sf_claim_coverage"
            where "policy_number"="in_policy_no" and "responsibility" != 'ฝ่ายถูก'
            into SYS_CLAIM_AMT;

            -- set SYS_PREMIUM_AMT is null = 0
            IF SYS_PREMIUM_AMT IS NULL THEN SYS_PREMIUM_AMT = 0; END IF;

            -- set SYS_CLAIM_AMT is null = SYS_CLAIM_RATE = 0
            IF SYS_CLAIM_AMT IS NULL THEN SYS_CLAIM_RATE = 0; END IF;

            -- cal SYS_CLAIM_RATE
            IF SYS_PREMIUM_AMT != 0 THEN
                SYS_CLAIM_RATE =  (SYS_CLAIM_AMT * 100) / SYS_PREMIUM_AMT;
            ELSE
                RTN_SUCCESS = false;
                RTN_ERROR_CODE = 'ER002';
                RTN_MSG = 'Premium Amount is equal 0.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            -- check car age , garage , loss reserve
            IF (CON_AGE_MAX IS NOT NULL AND NEW_CAR_AGE > CON_AGE_MAX)
                OR (TR_GARAGETYPE = 'SC' AND SYS_CLAIM_RATE > CON_CLAIM_RESERVE)
            THEN
                RTN_SUCCESS = true;
                RTN_ERROR_CODE = 'PE001';
                RTN_MSG = 'The age of the car cannot choose the same type of garage for insurance renewal.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,true,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            TR_SI_LIMIT = TR_SI_LIMIT - (TR_SI_LIMIT * (CON_SI_REDUCE_PERC / 100));
            -- FIX MA (2025-01-13)
            IF TR_SI_LIMIT < 1000000 THEN
                TR_SI_LIMIT = CEIL(TR_SI_LIMIT/10000)*10000;
            ELSE
                TR_SI_LIMIT = CEIL((CEIL(TR_SI_LIMIT/10000)*10000)/100000)*100000;
            END IF;
            -- set tariff si
            select COALESCE("tariff_factor",0)
            from insurverse.mas_tariff
            WHERE tariff_group='motor' AND "tariff_code"='vehicle_si'
              AND "policy_type"=REPLACE(SYS_SUB_PRODUCT,'+','')
              AND (TR_SI_LIMIT+COALESCE(TR_ACCESS_LIMIT,0)) between tariff_num_min and tariff_num_max
            INTO TRF_SI;

            IF TRF_SI IS NULL THEN
                RTN_SUCCESS = false;
                RTN_ERROR_CODE = 'ER003';
                RTN_MSG = '[TRF_SI] Config Data is not found.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            -- set old ncb tier
            IF TR_NCB_PERC <= 0 THEN
                SYS_NCB_TIER = 0;
            ELSIF TR_NCB_PERC between 1 and 20 THEN
                SYS_NCB_TIER = 1;
            ELSIF TR_NCB_PERC between 21 and 30 THEN
                SYS_NCB_TIER = 2;
            ELSIF TR_NCB_PERC between 31 and 40 THEN
                SYS_NCB_TIER = 3;
            ELSIF TR_NCB_PERC between 41 and 50 THEN
                SYS_NCB_TIER = 4;
            ELSE
                SYS_NCB_TIER = 5;
            END IF;

            -- set new ncb tier
            SYS_NCB_TIER = SYS_NCB_TIER + TR_NCB_TIER;

            -- set ncb percent
            IF SYS_NCB_TIER < 0 THEN
                TR_BASE_PREMIUM = TR_BASE_PREMIUM + CON_BASE_ADD_AMT;
                TR_NCB_PERC = 0;
            ELSIF SYS_NCB_TIER = 0 THEN
                TR_NCB_PERC = 0;
            ELSIF SYS_NCB_TIER = 1 THEN
                TR_NCB_PERC = 20;
            ELSIF SYS_NCB_TIER = 2 THEN
                TR_NCB_PERC = 30;
            ELSIF SYS_NCB_TIER = 3 THEN
                TR_NCB_PERC = 40;
            ELSIF SYS_NCB_TIER = 4 THEN
                TR_NCB_PERC = 50;
            ELSE
                TR_NCB_PERC = 50;
            END IF;

            NEW_TOTAL_AMT_EX_MV = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (TRF_DRIVER / 100) * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
            NEW_TOTAL_AMT_EX_MV_NO_DRIVER = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
            NEW_DRIVER_DISCOUNT = NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV;

            NEW_TOTAL_AMT_MV = CAST(TR_MV01_AMT AS NUMERIC) + CAST(TR_MV02_AMT AS NUMERIC) + CAST(TR_MV03_AMT AS NUMERIC);

            RTN_PREM_AMT = CAST(NEW_TOTAL_AMT_EX_MV AS NUMERIC) + CAST(NEW_TOTAL_AMT_MV AS NUMERIC);

            NEW_FLEET_AMT = FLOOR(RTN_PREM_AMT * (TR_FLEET_PERC/100));
            NEW_NCB_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT) * (TR_NCB_PERC/100));
            NEW_OTHER_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT - NEW_NCB_AMT) * (TR_OTHER_PERC/100));

            RTN_PREM_AMT = RTN_PREM_AMT - NEW_FLEET_AMT;
            RTN_PREM_AMT = RTN_PREM_AMT - NEW_NCB_AMT;
            RTN_PREM_AMT = RTN_PREM_AMT - NEW_OTHER_AMT;

            -- CON_PREMIUM_MIN
            /*
            select "premium_amt_min"
            from insurverse."mas_renewal_premium" as "rn_prem"
            where SYS_CUR_DATE between "rn_prem"."trans_startdate" and "rn_prem"."trans_enddate"
            and "rn_prem"."is_active"=true
            and "rn_prem"."car_group"=TR_GROUP
            and "rn_prem"."garage_type"=TR_GARAGETYPE
            into CON_PREMIUM_MIN;

            IF RTN_PREM_AMT < CON_PREMIUM_MIN THEN
                RTN_SUCCESS = true;
                RTN_ERROR_CODE = 'PE003';
                RTN_MSG = 'The insurance premium must be lower than the minimum insurance premium.';
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;
            */

            -- class 2+ 3+ calculator
        ELSIF SYS_SUB_PRODUCT = '2+' OR SYS_SUB_PRODUCT = '3+' THEN
            -- CON_AGE_MAX
            select "renewal_num"
            from insurverse."mas_renewal_config" as "rn_config"
            where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
              and "rn_config"."renewal_type"='car_age'
              and ("rn_config"."renewal_code"='age_2plus' and SYS_SUB_PRODUCT = '2+'
                or "rn_config"."renewal_code"='age_3plus' and SYS_SUB_PRODUCT = '3+')
            into CON_AGE_MAX;

            -- CON_AGE_MAX
            select "renewal_num"
            from insurverse."mas_renewal_config" as "rn_config"
            where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
              and "rn_config"."renewal_type"='car_age'
              and ("rn_config"."renewal_code"='age_2plus' and SYS_SUB_PRODUCT = '2+'
                or "rn_config"."renewal_code"='age_3plus' and SYS_SUB_PRODUCT = '3+')
            into CON_AGE_MAX;

            IF CON_AGE_MAX IS NULL THEN
                RTN_SUCCESS = false;
                RTN_ERROR_CODE = 'ER003';
                RTN_MSG = '[CON_AGE_MAX_'|| SYS_SUB_PRODUCT ||'] Config Data is not found.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            -- check car age , garage
            IF CON_AGE_MAX IS NOT NULL AND NEW_CAR_AGE > CON_AGE_MAX
            THEN
                RTN_SUCCESS = true;
                RTN_ERROR_CODE = 'PE002';
                RTN_MSG = 'The age of the car prevents the insurance policy from being renewed in the same coverage class.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,true,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            -- default base premium v5 if NULL
            IF TR_BASE_PREMIUM_V5 IS NULL THEN
                IF TR_ACCESS_LIMIT IS NULL OR TR_ACCESS_LIMIT = 0 THEN
                    TR_BASE_PREMIUM_V5 = 3500;
                ELSE
                    TR_BASE_PREMIUM_V5 = 4500;
                END IF;
            END IF;

            -- set tariff si
            select COALESCE("tariff_factor",0)
            from insurverse.mas_tariff
            WHERE tariff_group='motor' AND "tariff_code"='vehicle_si'
              AND "policy_type"=REPLACE(SYS_SUB_PRODUCT,'+','')
              AND (TR_SI_LIMIT+COALESCE(TR_ACCESS_LIMIT,0)) between tariff_num_min and tariff_num_max
            INTO TRF_SI;

            IF TRF_SI IS NULL THEN
                RTN_SUCCESS = false;
                RTN_ERROR_CODE = 'ER003';
                RTN_MSG = '[TRF_SI] Config Data is not found.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            -- set tariff si v5
            select COALESCE("tariff_factor",0)
            from insurverse.mas_tariff
            WHERE tariff_group='motor' AND "tariff_code"='vehicle_base_v5'
              AND "policy_type"=SYS_SUB_PRODUCT
              AND (TR_SI_LIMIT+COALESCE(TR_ACCESS_LIMIT,0)) between tariff_num_min and tariff_num_max
            INTO TRF_SI_V5;

            IF TRF_SI_V5 IS NULL THEN
                RTN_SUCCESS = false;
                RTN_ERROR_CODE = 'ER003';
                RTN_MSG = '[TRF_SI_V5] Config Data is not found.';
                RTN_PREM_ACT = 0;
                IF in_flag_noti = true THEN
--                     INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message,remark)
--                     VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG,SYS_MC_NO)
--                     RETURNING "id" INTO RTN_LOG_NOTI_ID;
                END IF;
                RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
                return;
            END IF;

            -- Premium v5 OD
            NEW_PREMIUM_V5_OD = FLOOR(TR_BASE_PREMIUM_V5 * (TRF_SI_V5/100));

            NEW_TOTAL_AMT_EX_MV = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (TRF_DRIVER / 100)  * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100)) + NEW_PREMIUM_V5_OD;
            NEW_TOTAL_AMT_EX_MV_NO_DRIVER = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100)  * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100)) + NEW_PREMIUM_V5_OD;
            NEW_DRIVER_DISCOUNT = NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV;


            NEW_TOTAL_AMT_MV = CAST(TR_MV01_AMT AS NUMERIC) + CAST(TR_MV02_AMT AS NUMERIC) + CAST(TR_MV03_AMT AS NUMERIC);

            RTN_PREM_AMT = CAST(NEW_TOTAL_AMT_EX_MV AS NUMERIC) + CAST(NEW_TOTAL_AMT_MV AS NUMERIC);

            NEW_FLEET_AMT = FLOOR((RTN_PREM_AMT - NEW_PREMIUM_V5_OD) * (TR_FLEET_PERC/100));
            NEW_NCB_AMT = FLOOR(((RTN_PREM_AMT - NEW_PREMIUM_V5_OD) - NEW_FLEET_AMT) * (TR_NCB_PERC/100));
            NEW_OTHER_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT - NEW_NCB_AMT) * (TR_OTHER_PERC/100));

            RTN_PREM_AMT = RTN_PREM_AMT - NEW_FLEET_AMT;
            RTN_PREM_AMT = RTN_PREM_AMT - NEW_NCB_AMT;
            RTN_PREM_AMT = RTN_PREM_AMT - NEW_OTHER_AMT;
            -- class 3 calculator
        ELSIF SYS_SUB_PRODUCT = '3' THEN
            NEW_TOTAL_AMT_EX_MV = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (TRF_DRIVER / 100)  * (TRF_CAR_YEAR / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
            NEW_TOTAL_AMT_EX_MV_NO_DRIVER = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100)  * (TRF_CAR_YEAR / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
            NEW_DRIVER_DISCOUNT = NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV;

            NEW_TOTAL_AMT_MV = CAST(TR_MV01_AMT AS NUMERIC) + CAST(TR_MV02_AMT AS NUMERIC) + CAST(TR_MV03_AMT AS NUMERIC);

            RTN_PREM_AMT = CAST(NEW_TOTAL_AMT_EX_MV AS NUMERIC) + CAST(NEW_TOTAL_AMT_MV AS NUMERIC);

            NEW_FLEET_AMT = FLOOR(RTN_PREM_AMT * (TR_FLEET_PERC/100));
            NEW_NCB_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT) * (TR_NCB_PERC/100));
            NEW_OTHER_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT - NEW_NCB_AMT) * (TR_OTHER_PERC/100));

            RTN_PREM_AMT = RTN_PREM_AMT - NEW_FLEET_AMT;
            RTN_PREM_AMT = RTN_PREM_AMT - NEW_NCB_AMT;
            RTN_PREM_AMT = RTN_PREM_AMT - NEW_OTHER_AMT;
        END IF;

        LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - SYS_NCB_TIER : ' || SYS_NCB_TIER || ' - NEW_CAR_AGE : ' || COALESCE(NEW_CAR_AGE,0);
        LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - NEW_NAMEDAGE : ' || NEW_NAMEDAGE || ' - NEW_YEAR_DRIVER : ' || COALESCE(NEW_YEAR_DRIVER,0) || ' - TR_PAR1_YEAR : ' || COALESCE(TR_PAR1_YEAR,0) || ' - TR_PAR2_YEAR : ' || COALESCE(TR_PAR2_YEAR,0);
        LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - TRF_USAGE : ' || TRF_USAGE || ' - TRF_CC : ' || TRF_CC || ' - TRF_DRIVER : ' || TRF_DRIVER || ' - TRF_CAR_YEAR : ' || TRF_CAR_YEAR || ' - TRF_SI : ' || TRF_SI || ' - TRF_CAR_GROUP : ' || TRF_CAR_GROUP || ' - TRF_TPBI : ' || TRF_TPBI || ' - TRF_TPPD : ' || TRF_TPPD;
        LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - SI_TPPD_Limit : ' || TR_TPPD_LIMIT || ' - SI_TPBI_Limit : ' || TR_TPBI_LIMIT;
        LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - TR_FLEET_PERC : ' || TR_FLEET_PERC || ' - TR_NCB_PERC : ' || TR_NCB_PERC || ' - TR_OTHER_PERC : ' || TR_OTHER_PERC;
        LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - TR_BASE_PREMIUM : ' || COALESCE(TR_BASE_PREMIUM,0) || ' - TR_BASE_PREMIUM_V5 : ' || COALESCE(TR_BASE_PREMIUM_V5,0) || ' - (TR_SI_LIMIT+COALESCE(TR_ACCESS_LIMIT,0)) : ' || (COALESCE(TR_SI_LIMIT,0)+COALESCE(TR_ACCESS_LIMIT,0)) || ' - TRF_SI_V5 : ' || COALESCE(TRF_SI_V5,0);
        LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - NEW_PREMIUM : ' || (COALESCE(NEW_TOTAL_AMT_EX_MV,0) - COALESCE(NEW_PREMIUM_V5_OD,0)) || ' - NEW_PREMIUM_V5_OD : ' || COALESCE(NEW_PREMIUM_V5_OD,0) || ' - NEW_TOTAL_AMT_EX_MV : ' || COALESCE(NEW_TOTAL_AMT_EX_MV,0) || ' - NEW_TOTAL_AMT_MV : ' || COALESCE(NEW_TOTAL_AMT_MV,0);

    END IF;

    RTN_DUTY_AMT = CEIL(RTN_PREM_AMT * (TR_DUTY_PERC/100));
    RTN_VAT_AMT = ROUND((RTN_PREM_AMT + RTN_DUTY_AMT) * (TR_VAT_PERC/100),2);
    RTN_TOTAL_AMT = RTN_PREM_AMT + RTN_DUTY_AMT + RTN_VAT_AMT;

    LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - RTN_PREM_AMT : ' || COALESCE(RTN_PREM_AMT,0) || ' - RTN_DUTY_AMT : ' || COALESCE(RTN_DUTY_AMT,0);
    LOG_TARIFF = COALESCE(LOG_TARIFF,'') || ' - RTN_VAT_AMT : ' || COALESCE(RTN_VAT_AMT,0) || ' - RTN_TOTAL_AMT : ' || COALESCE(RTN_TOTAL_AMT,0);

--     INSERT INTO insurverse."log_tariff_renewal"("policy_no","message")
--     VALUES (RTN_POLICY_NO,LOG_TARIFF);

    -- new lead
    IF in_flag_lead = true THEN
        IF IC_TOTAL IS NULL THEN
            IC_TOTAL = 0;
        END IF;

        --RTN_MSG = COALESCE(RTN_MSG,'') || ' - TR_FLAG_ACT : ' || COALESCE(TR_FLAG_ACT,'NULL') || ' - IC_TOTAL : ' || COALESCE(IC_TOTAL,'NULL');

        select "Lead_No" from insurverse."Lead_coverage_premium" order by "Lead_No" desc limit 1
        INTO RTN_LEAD_NO;
        IF RTN_LEAD_NO IS NULL THEN RTN_LEAD_NO = 1; ELSE RTN_LEAD_NO = RTN_LEAD_NO + 1; END IF;
        insert into insurverse."Lead_coverage_premium"
        (
            "Lead_No",
            "Brand","Model","Year","Doors","Seat","Wg",
            "Group","Usage","Type","BodyType","GarageType","NamedAge",
            "Sedan","CC",
            "MinSI","MaxSI","Split",
            "SI_1","SI_2","SI_3","SI_4","SI_5","SI_Ans",
            "Prem_OD_1","Prem_OD_2","Prem_OD_3","Prem_OD_4","Prem_OD_5","OD_Ans","OD_Amt",
            "Prem_FT_1","Prem_FT_2","Prem_FT_3","Prem_FT_4","Prem_FT_5","FT_Ans","FT_Amt",
            "SI_TPBI_1","SI_TPBI_2","SI_TPBI_3",
            "Prem_TPBI_1","Prem_TPBI_2","Prem_TPBI_3","SI_TPBI_Ans","SI_TPBI_Amt",
            "SI_TPPD_1","SI_TPPD_2","SI_TPPD_3",
            "Prem_TPPD_1","Prem_TPPD_2","Prem_TPPD_3","SI_TPPD_Ans","SI_TPPD_Amt",
            "SI_MV01_1","SI_MV01_2","SI_MV01_3",
            "Prem_MV01_1","Prem_MV01_2","Prem_MV01_3","SI_MV01_Ans","SI_MV01_Amt",
            "SI_MV02_1","SI_MV02_2","SI_MV02_3",
            "Prem_MV02_1","Prem_MV02_2","Prem_MV02_3","SI_MV02_Ans","SI_MV02_Amt",
            "SI_MV03_1","SI_MV03_2","SI_MV03_3",
            "Prem_MV03_1","Prem_MV03_2","Prem_MV03_3","SI_MV03_Ans","SI_MV03_Amt",
            "SI_Access_1","SI_Access_2","SI_Access_3",
            "Prem_Access_1","Prem_Access_2","Prem_Access_3","SI_Access_Ans","SI_Access_Amt",
            "Perm_Amt","Duty_Amt","Vat_Amt","Total_Amt",
            "Fleet_Disc_perc","NCB_Disc_perc","Other_Disc_perc",
            "Total_Amt_exclude_mv","Total_Amt_mv",
            "Email","Mobile","Flag_CCTV","Flag_Driver",
            "Fleet_Disc_Amt","NCB_Disc_Amt","Other_Disc_Amt",
            "FirstName","LastName","Total_Disc_Amt",
            "Flag_Access","CCTV","Access_para_code",
            "YOB_Driver_1","YOB_Driver_2",
            "Basic_Premium","SI_Limit","SI_TPBI_Limit","SI_TPPD_Limit",
            "SI_MV01_Limit","SI_MV02_Limit","SI_MV03_Limit","SI_Access_Limit",
            "Driver_Discount","premium_v5_od",
            "basic_premium_v5","ref_policy_no",
            "Flag_Car_Act","Prem_ACT",
            "renewal_mv_startdate","renewal_mv_enddate",
            "renewal_mc_startdate","renewal_mc_enddate",
            "cal_basic_renewal"
        )
        select
            RTN_LEAD_NO,
            "pc"."Brand","pc"."Model","pc"."Year","pc"."Doors","pc"."Seat","pc"."Wg",
            "pc"."Group","pc"."Usage","pc"."Type","pc"."BodyType","pc"."GarageType",NEW_NAMEDAGE,
            "pc"."Sedan",NEW_CAR_CC,
            "pc"."MinSI","pc"."MaxSI","pc"."Split",
            "pc"."SI_1","pc"."SI_2","pc"."SI_3","pc"."SI_4","pc"."SI_5","pc"."SI_Ans",
            "pc"."Prem_OD_1","pc"."Prem_OD_2","pc"."Prem_OD_3","pc"."Prem_OD_4","pc"."Prem_OD_5","pc"."OD_Ans","pc"."OD_Amt",
            "pc"."Prem_FT_1","pc"."Prem_FT_2","pc"."Prem_FT_3","pc"."Prem_FT_4","pc"."Prem_FT_5","pc"."FT_Ans","pc"."FT_Amt",
            "pc"."SI_TPBI_1","pc"."SI_TPBI_2","pc"."SI_TPBI_3",
            "pc"."Prem_TPBI_1","pc"."Prem_TPBI_2","pc"."Prem_TPBI_3","pc"."SI_TPBI_Ans","pc"."SI_TPBI_Amt",
            "pc"."SI_TPPD_1","pc"."SI_TPPD_2","pc"."SI_TPPD_3",
            "pc"."Prem_TPPD_1","pc"."Prem_TPPD_2","pc"."Prem_TPPD_3","pc"."SI_TPPD_Ans","pc"."SI_TPPD_Amt",
            "pc"."SI_MV01_1","pc"."SI_MV01_2","pc"."SI_MV01_3",
            "pc"."Prem_MV01_1","pc"."Prem_MV01_2","pc"."Prem_MV01_3","pc"."SI_MV01_Ans","pc"."SI_MV01_Amt",
            "pc"."SI_MV02_1","pc"."SI_MV02_2","pc"."SI_MV02_3",
            "pc"."Prem_MV02_1","pc"."Prem_MV02_2","pc"."Prem_MV02_3","pc"."SI_MV02_Ans","pc"."SI_MV02_Amt",
            "pc"."SI_MV03_1","pc"."SI_MV03_2","pc"."SI_MV03_3",
            "pc"."Prem_MV03_1","pc"."Prem_MV03_2","pc"."Prem_MV03_3","pc"."SI_MV03_Ans","pc"."SI_MV03_Amt",
            "pc"."SI_Access_1","pc"."SI_Access_2","pc"."SI_Access_3",
            "pc"."Prem_Access_1","pc"."Prem_Access_2","pc"."Prem_Access_3","pc"."SI_Access_Ans","pc"."SI_Access_Amt",
            RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,
            TR_FLEET_PERC,TR_NCB_PERC,TR_OTHER_PERC,
            NEW_TOTAL_AMT_EX_MV,NEW_TOTAL_AMT_MV,
            "ph"."email","suser"."mobile","pc"."Flag_CCTV","pc"."Flag_Driver",
            NEW_FLEET_AMT,NEW_NCB_AMT,NEW_OTHER_AMT,
            "ph"."Owner_first_name","ph"."Owner_last_name",COALESCE(NEW_FLEET_AMT,0)+COALESCE(NEW_NCB_AMT,0)+COALESCE(NEW_OTHER_AMT,0),
            "pc"."Flag_Access","pc"."CCTV","pc"."Access_para_code",
            "pc"."YOB_Driver_1","pc"."YOB_Driver_2",
            TR_BASE_PREMIUM,TR_SI_LIMIT,"pc"."SI_TPBI_Limit","pc"."SI_TPPD_Limit",
            "pc"."SI_MV01_Limit","pc"."SI_MV02_Limit","pc"."SI_MV03_Limit","pc"."SI_Access_Limit",
            NEW_DRIVER_DISCOUNT,NEW_PREMIUM_V5_OD,
            TR_BASE_PREMIUM_V5,CONCAT('RN', SYS_POLICY_NO),
            TR_FLAG_ACT,TR_PREM_ACT,
            SYS_MV_STARTDATE,SYS_MV_ENDDATE,
            SYS_MC_STARTDATE,SYS_MC_ENDDATE,
            true
        from insurverse."Policy_Header" as "ph"
                 inner join insurverse."Policy_coverage_premium" as "pc"
                            on "ph"."Policy_No"="pc"."Policy_No"
                                and "ph"."Policy_No"="in_policy_no"
                 inner join insurverse."sec_user" as "suser"
                            on "ph"."email"="suser"."email"
                 left outer join insurverse."Policy_Header" as "new_ph"
                                 on "new_ph"."ref_policy_no"="ph"."Policy_No"
        where "new_ph"."Policy_No" is null;

    END IF;
    -- insert noti renewal mv
    IF in_flag_noti = true THEN
--         INSERT INTO insurverse.log_noti_renewal
--         (
--             policy_no,premium_amt,duty_amt,vat_amt,total_amt,is_active,is_renewal,remark
--         )
--         VALUES (
--                    SYS_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,true,true,SYS_MC_NO
--                )
--         RETURNING "id" INTO RTN_LOG_NOTI_ID;
    END IF;

    IF SYS_TEST_RUN = true THEN
        RTN_MSG = COALESCE(LOG_TARIFF,'');
    END IF;

    RETURN QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY,RTN_PREM_ACT;
END
$function$
