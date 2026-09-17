-- =============================================================================
-- Function: insurverse.fn_policy_renewal_noti
-- OID: 18750
-- Identity Arguments: ()
-- Returns: TABLE(rtn_success boolean, rtn_error_code text, rtn_msg text, rtn_log_noti_id integer, rtn_noti_code text, rtn_expire_count integer, rtn_mv_type text, rtn_mv_no text, rtn_mc_no text, rtn_owner_title text, rtn_owner_firstname text, rtn_owner_lastname text, rtn_mv_enddate timestamp without time zone, rtn_mc_enddate timestamp without time zone, rtn_car_license_no text, rtn_car_license_province text, rtn_email text, rtn_phone text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_noti()
 RETURNS TABLE(rtn_success boolean, rtn_error_code text, rtn_msg text, rtn_log_noti_id integer, rtn_noti_code text, rtn_expire_count integer, rtn_mv_type text, rtn_mv_no text, rtn_mc_no text, rtn_owner_title text, rtn_owner_firstname text, rtn_owner_lastname text, rtn_mv_enddate timestamp without time zone, rtn_mc_enddate timestamp without time zone, rtn_car_license_no text, rtn_car_license_province text, rtn_email text, rtn_phone text)
 LANGUAGE plpgsql
AS $function$
DECLARE
    -- parameter
    SYS_CUR_DATE TIMESTAMP; SYS_SAVE_NOTI BOOLEAN; SYS_SAVE_NOTI_DEFAULT BOOLEAN;
    SYS_LOG_NOTI_ID INTEGER; SYS_EMAIL_AT TIMESTAMP;
    -- return result
    RTN_SUCCESS BOOL; RTN_MSG TEXT; RTN_ERROR_CODE TEXT;
    RTN_NCB_TIER INTEGER; RTN_POLICY_NO TEXT;
    RTN_PREM_AMT NUMERIC; RTN_DUTY_AMT NUMERIC;
    RTN_VAT_AMT NUMERIC; RTN_TOTAL_AMT NUMERIC;
    RTN_JSON_BODY TEXT;
    RTN_LEAD_NO INTEGER; RTN_LOG_NOTI_ID INTEGER;
    RTN_IS_COMPULSORY BOOL; RTN_TOGETHER_POLICY TEXT;
    LOOP_COVER RECORD;
    -- retrun result for "Email"
    RTN_NOTI_CODE TEXT; RTN_EXPIRE_COUNT INTEGER;
    RTN_MV_TYPE TEXT; RTN_MV_NO TEXT; RTN_MC_NO TEXT;
    RTN_OWNER_TITLE TEXT; RTN_OWNER_FIRSTNAME TEXT; RTN_OWNER_LASTNAME TEXT;
    RTN_MV_ENDDATE TIMESTAMP; RTN_MC_ENDDATE TIMESTAMP;
    RTN_CAR_LICENSE_NO TEXT; RTN_CAR_LICENSE_PROVINCE TEXT;
    RTN_EMAIL TEXT; RTN_PHONE TEXT;
    -- mas_renewal_config
    CON_NOTI_TYPE TEXT;
    CON_NOTI_CODE_1 TEXT; CON_NOTI_CODE_2 TEXT; CON_NOTI_CODE_3 TEXT;
    CON_NOTI_1 NUMERIC; CON_NOTI_2 NUMERIC; CON_NOTI_3 NUMERIC;
BEGIN
    SYS_SAVE_NOTI_DEFAULT = true;
    RTN_SUCCESS = true;
    CON_NOTI_TYPE = 'noti';
    CON_NOTI_CODE_1 = 'noti_1';
    CON_NOTI_CODE_2 = 'noti_2';
    CON_NOTI_CODE_3 = 'noti_3';

    -- set SYS_CUR_DATE is null = now()
    IF SYS_CUR_DATE IS NULL THEN SYS_CUR_DATE = now(); END IF;

    -- CON_NOTI_1
    select "renewal_num"
    from insurverse."mas_renewal_config" as "rn_config"
    where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
      and "rn_config"."renewal_type"=CON_NOTI_TYPE and "rn_config"."renewal_code"=CON_NOTI_CODE_1
    into CON_NOTI_1;

    IF CON_NOTI_1 IS NULL THEN
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[CON_NOTI_1] Config Data is not found.';
        IF in_flag_noti = true THEN
            INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message)
            VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG)
            RETURNING RTN_LOG_NOTI_ID;
        END IF;
        RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                            RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                            RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
        return;
    END IF;

    -- CON_NOTI_2
    select "renewal_num"
    from insurverse."mas_renewal_config" as "rn_config"
    where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
      and "rn_config"."renewal_type"=CON_NOTI_TYPE and "rn_config"."renewal_code"=CON_NOTI_CODE_2
    into CON_NOTI_2;

    IF CON_NOTI_2 IS NULL THEN
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[CON_NOTI_2] Config Data is not found.';
        IF in_flag_noti = true THEN
            INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message)
            VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG)
            RETURNING RTN_LOG_NOTI_ID;
        END IF;
        RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                            RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                            RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
        return;
    END IF;

    -- CON_NOTI_3
    select "renewal_num"
    from insurverse."mas_renewal_config" as "rn_config"
    where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
      and "rn_config"."renewal_type"=CON_NOTI_TYPE and "rn_config"."renewal_code"=CON_NOTI_CODE_3
    into CON_NOTI_3;

    IF CON_NOTI_3 IS NULL THEN
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[CON_NOTI_3] Config Data is not found.';
        IF in_flag_noti = true THEN
            INSERT INTO insurverse.log_noti_renewal(policy_no,is_active,is_renewal,error_code,return_message)
            VALUES ("in_policy_no",true,false,RTN_ERROR_CODE,RTN_MSG)
            RETURNING RTN_LOG_NOTI_ID;
        END IF;
        RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                            RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                            RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
        return;
    END IF;

    -- noti renewal noti mv
    LOOP_COVER = null;
    FOR LOOP_COVER in
        SELECT DISTINCT *
        FROM (
                 SELECT "policy"."Policy_No" as "policy_no",CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_1 as "con_noti_code", CON_NOTI_1 as "con_noti_count"
                 FROM insurverse."Policy_Header" as "policy"
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON "policy"."Policy_No"="noti"."policy_no"
                                        AND "noti"."noti_code" = CON_NOTI_CODE_1
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Header" as "ref_policy"
                                    ON "policy"."Policy_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_1
                   AND CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
                 UNION
                 SELECT "policy"."Policy_No" as "policy_no",CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_2 as "con_noti_code", CON_NOTI_2 as "con_noti_count"
                 FROM insurverse."Policy_Header" as "policy"
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON "policy"."Policy_No"="noti"."policy_no"
                                        AND "noti"."noti_code" = CON_NOTI_CODE_2
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Header" as "ref_policy"
                                    ON "policy"."Policy_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_2
                   AND CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
                 UNION
                 SELECT "policy"."Policy_No" as "policy_no",CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_3 as "con_noti_code", CON_NOTI_3 as "con_noti_count"
                 FROM insurverse."Policy_Header" as "policy"
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON "policy"."Policy_No"="noti"."policy_no"
                                        AND "noti"."noti_code" = CON_NOTI_CODE_3
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Header" as "ref_policy"
                                    ON "policy"."Policy_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_3
                   AND CAST("policy"."Policy_Enddate" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
             ) as "noti_policy"
        LOOP
            -- CLEAR
            RTN_SUCCESS = true;
            RTN_MSG = NULL;
            RTN_ERROR_CODE = NULL;
            RTN_NCB_TIER = NULL;
            RTN_POLICY_NO = NULL;
            RTN_PREM_AMT = NULL;
            RTN_DUTY_AMT = NULL;
            RTN_VAT_AMT = NULL;
            RTN_TOTAL_AMT = NULL;
            RTN_JSON_BODY = NULL;
            RTN_LEAD_NO = NULL;
            RTN_LOG_NOTI_ID = NULL;
            RTN_IS_COMPULSORY = NULL;
            RTN_TOGETHER_POLICY = NULL;
            RTN_NOTI_CODE = NULL;
            RTN_EXPIRE_COUNT = NULL;
            RTN_MV_TYPE = NULL;
            RTN_MV_NO = NULL;
            RTN_MC_NO = NULL;
            RTN_OWNER_TITLE = NULL;
            RTN_OWNER_FIRSTNAME = NULL;
            RTN_OWNER_LASTNAME = NULL;
            RTN_MV_ENDDATE = NULL;
            RTN_MC_ENDDATE = NULL;
            RTN_CAR_LICENSE_NO = NULL;
            RTN_CAR_LICENSE_PROVINCE = NULL;

            RTN_NOTI_CODE = LOOP_COVER."con_noti_code";
            RTN_EXPIRE_COUNT = LOOP_COVER."con_noti_count";

            SYS_SAVE_NOTI = SYS_SAVE_NOTI_DEFAULT;

            SELECT "fn"."rtn_success", "fn"."rtn_ncb_tier", "fn"."rtn_error_code", "fn"."rtn_msg", "fn"."rtn_policy_no",
                   "fn"."rtn_prem_amt", "fn"."rtn_duty_amt", "fn"."rtn_vat_amt", "fn"."rtn_total_amt",
                   "fn"."rtn_is_compulsory","fn"."rtn_together_policy", "fn"."rtn_lead_no", "fn"."rtn_log_noti_id", "fn"."rtn_json_body"
            FROM insurverse."fn_policy_renewal"(LOOP_COVER."policy_no",SYS_SAVE_NOTI,false) as "fn"
            INTO RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO,
                RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY;

            UPDATE insurverse.log_noti_renewal
            SET noti_code=RTN_NOTI_CODE
            where "id"=RTN_LOG_NOTI_ID;


            IF RTN_SUCCESS = true AND RTN_POLICY_NO IS NOT NULL AND RTN_IS_COMPULSORY = false THEN
                SELECT "policy"."Type","policy"."Policy_No",
                       "policy"."Owner_prefix_name","policy"."Owner_first_name","policy"."Owner_last_name",
                       "policy"."Policy_Enddate","policy"."Car_license_no",
                       (select "prname" from insurverse."province" where "province"."provinceid"="policy"."Car_license_provice") as "Car_license_province",
                       "policy"."email",CASE WHEN "user"."mobile" IS NOT NULL THEN "user"."mobile" ELSE "lead"."Mobile" END as "phone"
                FROM insurverse."Policy_Header" as "policy"
                         INNER JOIN insurverse."Policy_coverage_premium" as "prem"
                                    ON "policy"."Policy_No"=RTN_POLICY_NO
                                        AND "policy"."Policy_No"="prem"."Policy_No"
                         INNER JOIN insurverse.sec_user as "user"
                                    ON "policy"."email"="user"."email"
                         INNER JOIN insurverse."Lead_coverage_premium" as "lead"
                                    ON "prem"."Lead_No"="lead"."Lead_No"
                INTO RTN_MV_TYPE,RTN_MV_NO,
                    RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                    RTN_MV_ENDDATE,RTN_CAR_LICENSE_NO,
                    RTN_CAR_LICENSE_PROVINCE,
                    RTN_EMAIL,RTN_PHONE;

                IF RTN_TOGETHER_POLICY IS NOT NULL THEN
                    SELECT "policy"."Car_Act_No","policy"."End_date"
                    FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                             LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                       ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                    WHERE "policy"."Policy_No"=RTN_POLICY_NO
                      and "ref_policy"."Car_Act_No" IS NULL
                    INTO RTN_MC_NO,RTN_MC_ENDDATE;
                END IF;

                --RTN_MSG = 'check mv:' || LOOP_COVER."policy_no";
                RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                                    RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                                    RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
            END IF;
        END LOOP;

    -- noti renewal noti mc
    LOOP_COVER = null;
    FOR LOOP_COVER in
        SELECT DISTINCT *
        FROM (
                 SELECT "policy"."Car_Act_No" as "policy_no",CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_1 as "con_noti_code", CON_NOTI_1 as "con_noti_count"
                 FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON ("policy"."Car_Act_No"="noti"."policy_no" OR "policy"."Car_Act_No"="noti"."remark")
                                        AND "noti"."noti_code" = CON_NOTI_CODE_1
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                    ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_1
                   AND CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_No" IS NULL
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
                 UNION
                 SELECT "policy"."Car_Act_No" as "policy_no",CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_2 as "con_noti_code", CON_NOTI_2 as "con_noti_count"
                 FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON ("policy"."Car_Act_No"="noti"."policy_no" OR "policy"."Car_Act_No"="noti"."remark")
                                        AND "noti"."noti_code" = CON_NOTI_CODE_2
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                    ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_2
                   AND CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_No" IS NULL
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
                 UNION
                 SELECT "policy"."Car_Act_No" as "policy_no",CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_3 as "con_noti_code", CON_NOTI_3 as "con_noti_count"
                 FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON ("policy"."Car_Act_No"="noti"."policy_no" OR "policy"."Car_Act_No"="noti"."remark")
                                        AND "noti"."noti_code" = CON_NOTI_CODE_3
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                    ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_3
                   AND CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_No" IS NULL
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
             ) as "noti_policy"
        LOOP
            -- CLEAR
            RTN_SUCCESS = true;
            RTN_MSG = NULL;
            RTN_ERROR_CODE = NULL;
            RTN_NCB_TIER = NULL;
            RTN_POLICY_NO = NULL;
            RTN_PREM_AMT = NULL;
            RTN_DUTY_AMT = NULL;
            RTN_VAT_AMT = NULL;
            RTN_TOTAL_AMT = NULL;
            RTN_JSON_BODY = NULL;
            RTN_LEAD_NO = NULL;
            RTN_LOG_NOTI_ID = NULL;
            RTN_IS_COMPULSORY = NULL;
            RTN_TOGETHER_POLICY = NULL;
            RTN_NOTI_CODE = NULL;
            RTN_EXPIRE_COUNT = NULL;
            RTN_MV_TYPE = 0;
            RTN_MV_NO = NULL;
            RTN_MC_NO = NULL;
            RTN_OWNER_TITLE = NULL;
            RTN_OWNER_FIRSTNAME = NULL;
            RTN_OWNER_LASTNAME = NULL;
            RTN_MV_ENDDATE = NULL;
            RTN_MC_ENDDATE = NULL;
            RTN_CAR_LICENSE_NO = NULL;
            RTN_CAR_LICENSE_PROVINCE = NULL;

            RTN_NOTI_CODE = LOOP_COVER."con_noti_code";
            RTN_EXPIRE_COUNT = LOOP_COVER."con_noti_count";
            RTN_MC_NO = LOOP_COVER."policy_no";

            SYS_SAVE_NOTI = SYS_SAVE_NOTI_DEFAULT;

            SELECT "fn"."rtn_success", "fn"."rtn_ncb_tier", "fn"."rtn_error_code", "fn"."rtn_msg", "fn"."rtn_policy_no",
                   "fn"."rtn_prem_amt", "fn"."rtn_duty_amt","fn"."rtn_vat_amt","fn"."rtn_total_amt",
                   "fn"."rtn_is_compulsory","fn"."rtn_together_policy","fn"."rtn_lead_no","fn"."rtn_log_noti_id","fn"."rtn_json_body"
            FROM insurverse."fn_policy_renewal"(LOOP_COVER."policy_no",SYS_SAVE_NOTI,false) as "fn"
            INTO RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,
                RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY;

            UPDATE insurverse.log_noti_renewal
            SET noti_code=RTN_NOTI_CODE
            where "id"=RTN_LOG_NOTI_ID;


            IF RTN_SUCCESS = true AND RTN_POLICY_NO IS NOT NULL AND RTN_IS_COMPULSORY = true THEN
                RTN_MV_TYPE = 0;
                SELECT "policy"."Car_Act_No","policy"."End_date",
                       "policy"."prefix_name","policy"."first_name","policy"."last_name",
                       "policy"."End_date","policy"."Car_license_no",
                       (select "prname" from insurverse."province" where "province"."provinceid"=CAST("policy"."Car_license_provice" as INT)) as "Car_license_province",
                       "policy"."email",CASE WHEN "user"."mobile" IS NOT NULL THEN "user"."mobile" ELSE "policy"."phone" END as "phone"
                FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                         INNER JOIN insurverse.sec_user as "user"
                                    ON "policy"."Car_Act_No"=RTN_POLICY_NO
                                        AND "policy"."email"="user"."email"
                INTO RTN_MC_NO,RTN_MC_ENDDATE,
                    RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                    RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,
                    RTN_CAR_LICENSE_PROVINCE,
                    RTN_EMAIL,RTN_PHONE;

                --RTN_MSG = 'check mc:' || LOOP_COVER."policy_no";
                RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                                    RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                                    RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
            END IF;

            IF RTN_SUCCESS = true AND RTN_POLICY_NO IS NOT NULL AND RTN_IS_COMPULSORY = false THEN
                SELECT "policy"."Type","policy"."Policy_No",
                       "policy"."Owner_prefix_name","policy"."Owner_first_name","policy"."Owner_last_name",
                       "policy"."Policy_Enddate","policy"."Car_license_no",
                       (select "prname" from insurverse."province" where "province"."provinceid"="policy"."Car_license_provice") as "Car_license_province",
                       "policy"."email",CASE WHEN "user"."mobile" IS NOT NULL THEN "user"."mobile" ELSE "lead"."Mobile" END as "phone"
                FROM insurverse."Policy_Header" as "policy"
                         INNER JOIN insurverse."Policy_coverage_premium" as "prem"
                                    ON "policy"."Policy_No"=RTN_POLICY_NO
                                        AND "policy"."Policy_No"="prem"."Policy_No"
                         INNER JOIN insurverse.sec_user as "user"
                                    ON "policy"."email"="user"."email"
                         INNER JOIN insurverse."Lead_coverage_premium" as "lead"
                                    ON "prem"."Lead_No"="lead"."Lead_No"
                INTO RTN_MV_TYPE,RTN_MV_NO,
                    RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                    RTN_MV_ENDDATE,RTN_CAR_LICENSE_NO,
                    RTN_CAR_LICENSE_PROVINCE,
                    RTN_EMAIL,RTN_PHONE;

                IF RTN_TOGETHER_POLICY IS NOT NULL THEN
                    SELECT "policy"."Car_Act_No","policy"."End_date"
                    FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                             LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                       ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                    WHERE "policy"."Policy_No"=RTN_POLICY_NO
                      and "ref_policy"."Car_Act_No" IS NULL
                    INTO RTN_MC_NO,RTN_MC_ENDDATE;
                END IF;

                --RTN_MSG = 'check mv mc:' || LOOP_COVER."policy_no";

                RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                                    RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                                    RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
            END IF;
        END LOOP;

    -- noti renewal noti mc + mv (policy startdate not match)
    LOOP_COVER = null;
    FOR LOOP_COVER in
        SELECT DISTINCT *
        FROM (
                 SELECT "policy"."Car_Act_No" as "policy_no",CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_1 as "con_noti_code", CON_NOTI_1 as "con_noti_count"
                 FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                          INNER JOIN insurverse."Policy_Header" as "policy_mv"
                                     ON "policy"."Policy_No"="policy_mv"."Policy_No"
                                         AND CAST("policy"."End_date" + INTERVAL '7HOUR' as DATE) != CAST("policy_mv"."Policy_Enddate" + INTERVAL '7HOUR' as DATE)
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON ("policy"."Car_Act_No"="noti"."policy_no" OR "policy"."Car_Act_No"="noti"."remark")
                                        AND "noti"."noti_code" = CON_NOTI_CODE_1
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                    ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_1
                   AND CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
                 UNION
                 SELECT "policy"."Car_Act_No" as "policy_no",CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_2 as "con_noti_code", CON_NOTI_2 as "con_noti_count"
                 FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                          INNER JOIN insurverse."Policy_Header" as "policy_mv"
                                     ON "policy"."Policy_No"="policy_mv"."Policy_No"
                                         AND CAST("policy"."End_date" + INTERVAL '7HOUR' as DATE) != CAST("policy_mv"."Policy_Enddate" + INTERVAL '7HOUR' as DATE)
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON ("policy"."Car_Act_No"="noti"."policy_no" OR "policy"."Car_Act_No"="noti"."remark")
                                        AND "noti"."noti_code" = CON_NOTI_CODE_2
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                    ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_2
                   AND CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
                 UNION
                 SELECT "policy"."Car_Act_No" as "policy_no",CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 as "expire_day_count",
                        CON_NOTI_CODE_3 as "con_noti_code", CON_NOTI_3 as "con_noti_count"
                 FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                          INNER JOIN insurverse."Policy_Header" as "policy_mv"
                                     ON "policy"."Policy_No"="policy_mv"."Policy_No"
                                         AND CAST("policy"."End_date" + INTERVAL '7HOUR' as DATE) != CAST("policy_mv"."Policy_Enddate" + INTERVAL '7HOUR' as DATE)
                          LEFT JOIN insurverse."log_noti_renewal" as "noti"
                                    ON ("policy"."Car_Act_No"="noti"."policy_no" OR "policy"."Car_Act_No"="noti"."remark")
                                        AND "noti"."noti_code" = CON_NOTI_CODE_3
                                        AND "noti"."is_renewal" = true
                          LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                    ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                 WHERE CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 <= CON_NOTI_3
                   AND CAST("policy"."End_date" + INTERVAL '7 HOUR' as DATE)-CAST(now() + INTERVAL '7 HOUR' as DATE) + 1 > 0
                   AND "policy"."Policy_Status" = 'ACT'
                   AND "noti"."policy_no" IS NULL AND "ref_policy"."ref_policy_no" IS NULL
             ) as "noti_policy"
        LOOP
            -- CLEAR
            RTN_SUCCESS = true;
            RTN_MSG = NULL;
            RTN_ERROR_CODE = NULL;
            RTN_NCB_TIER = NULL;
            RTN_POLICY_NO = NULL;
            RTN_PREM_AMT = NULL;
            RTN_DUTY_AMT = NULL;
            RTN_VAT_AMT = NULL;
            RTN_TOTAL_AMT = NULL;
            RTN_JSON_BODY = NULL;
            RTN_LEAD_NO = NULL;
            RTN_LOG_NOTI_ID = NULL;
            RTN_IS_COMPULSORY = NULL;
            RTN_TOGETHER_POLICY = NULL;
            RTN_NOTI_CODE = NULL;
            RTN_EXPIRE_COUNT = NULL;
            RTN_MV_TYPE = 0;
            RTN_MV_NO = NULL;
            RTN_MC_NO = NULL;
            RTN_OWNER_TITLE = NULL;
            RTN_OWNER_FIRSTNAME = NULL;
            RTN_OWNER_LASTNAME = NULL;
            RTN_MV_ENDDATE = NULL;
            RTN_MC_ENDDATE = NULL;
            RTN_CAR_LICENSE_NO = NULL;
            RTN_CAR_LICENSE_PROVINCE = NULL;

            RTN_NOTI_CODE = LOOP_COVER."con_noti_code";
            RTN_EXPIRE_COUNT = LOOP_COVER."con_noti_count";
            RTN_MC_NO = LOOP_COVER."policy_no";

            SYS_SAVE_NOTI = SYS_SAVE_NOTI_DEFAULT;

            SELECT "fn"."rtn_success", "fn"."rtn_ncb_tier", "fn"."rtn_error_code", "fn"."rtn_msg", "fn"."rtn_policy_no",
                   "fn"."rtn_prem_amt", "fn"."rtn_duty_amt","fn"."rtn_vat_amt","fn"."rtn_total_amt",
                   "fn"."rtn_is_compulsory","fn"."rtn_together_policy","fn"."rtn_lead_no","fn"."rtn_log_noti_id","fn"."rtn_json_body"
            FROM insurverse."fn_policy_renewal"(LOOP_COVER."policy_no",SYS_SAVE_NOTI,false) as "fn"
            INTO RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,
                RTN_POLICY_NO,RTN_PREM_AMT,RTN_DUTY_AMT,RTN_VAT_AMT,RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,RTN_TOGETHER_POLICY,RTN_LEAD_NO,RTN_LOG_NOTI_ID,RTN_JSON_BODY;

            UPDATE insurverse.log_noti_renewal
            SET noti_code=RTN_NOTI_CODE
            where "id"=RTN_LOG_NOTI_ID;


            IF RTN_SUCCESS = true AND RTN_POLICY_NO IS NOT NULL AND RTN_IS_COMPULSORY = true THEN
                RTN_MV_TYPE = 0;
                SELECT "policy"."Car_Act_No","policy"."End_date",
                       "policy"."prefix_name","policy"."first_name","policy"."last_name",
                       "policy"."End_date","policy"."Car_license_no",
                       (select "prname" from insurverse."province" where "province"."provinceid"=CAST("policy"."Car_license_provice" as INT)) as "Car_license_province",
                       "policy"."email",CASE WHEN "user"."mobile" IS NOT NULL THEN "user"."mobile" ELSE "policy"."phone" END as "phone"
                FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                         INNER JOIN insurverse.sec_user as "user"
                                    ON "policy"."Car_Act_No"=RTN_POLICY_NO
                                        AND "policy"."email"="user"."email"
                INTO RTN_MC_NO,RTN_MC_ENDDATE,
                    RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                    RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,
                    RTN_CAR_LICENSE_PROVINCE,
                    RTN_EMAIL,RTN_PHONE;

                --RTN_MSG = 'check mc:' || LOOP_COVER."policy_no";
                RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                                    RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                                    RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
            END IF;

            IF RTN_SUCCESS = true AND RTN_POLICY_NO IS NOT NULL AND RTN_IS_COMPULSORY = false THEN
                SELECT "policy"."Type","policy"."Policy_No",
                       "policy"."Owner_prefix_name","policy"."Owner_first_name","policy"."Owner_last_name",
                       "policy"."Policy_Enddate","policy"."Car_license_no",
                       (select "prname" from insurverse."province" where "province"."provinceid"="policy"."Car_license_provice") as "Car_license_province",
                       "policy"."email",CASE WHEN "user"."mobile" IS NOT NULL THEN "user"."mobile" ELSE "lead"."Mobile" END as "phone"
                FROM insurverse."Policy_Header" as "policy"
                         INNER JOIN insurverse."Policy_coverage_premium" as "prem"
                                    ON "policy"."Policy_No"=RTN_POLICY_NO
                                        AND "policy"."Policy_No"="prem"."Policy_No"
                         INNER JOIN insurverse.sec_user as "user"
                                    ON "policy"."email"="user"."email"
                         INNER JOIN insurverse."Lead_coverage_premium" as "lead"
                                    ON "prem"."Lead_No"="lead"."Lead_No"
                INTO RTN_MV_TYPE,RTN_MV_NO,
                    RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                    RTN_MV_ENDDATE,RTN_CAR_LICENSE_NO,
                    RTN_CAR_LICENSE_PROVINCE,
                    RTN_EMAIL,RTN_PHONE;

                IF RTN_TOGETHER_POLICY IS NOT NULL THEN
                    SELECT "policy"."Car_Act_No","policy"."End_date"
                    FROM insurverse."Policy_Car_Act_Discount_Premium" as "policy"
                             LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" as "ref_policy"
                                       ON "policy"."Car_Act_No"="ref_policy"."ref_policy_no"
                    WHERE "policy"."Policy_No"=RTN_POLICY_NO
                      and "ref_policy"."Car_Act_No" IS NULL
                    INTO RTN_MC_NO,RTN_MC_ENDDATE;
                END IF;

                --RTN_MSG = 'check mv mc:' || LOOP_COVER."policy_no";

                RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                                    RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                                    RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
            END IF;
        END LOOP;

END
$function$
