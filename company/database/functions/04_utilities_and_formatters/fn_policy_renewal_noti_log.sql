-- =============================================================================
-- Function: insurverse.fn_policy_renewal_noti_log
-- OID: 18762
-- Identity Arguments: ()
-- Returns: TABLE(rtn_success boolean, rtn_error_code text, rtn_msg text, rtn_log_noti_id integer, rtn_noti_code text, rtn_expire_count integer, rtn_mv_type text, rtn_mv_no text, rtn_mc_no text, rtn_owner_title text, rtn_owner_firstname text, rtn_owner_lastname text, rtn_mv_enddate timestamp without time zone, rtn_mc_enddate timestamp without time zone, rtn_car_license_no text, rtn_car_license_province text, rtn_email text, rtn_phone text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_noti_log()
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

    -- CON_NOTI_2
    select "renewal_num"
    from insurverse."mas_renewal_config" as "rn_config"
    where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
      and "rn_config"."renewal_type"=CON_NOTI_TYPE and "rn_config"."renewal_code"=CON_NOTI_CODE_2
    into CON_NOTI_2;

    -- CON_NOTI_3
    select "renewal_num"
    from insurverse."mas_renewal_config" as "rn_config"
    where SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
      and "rn_config"."renewal_type"=CON_NOTI_TYPE and "rn_config"."renewal_code"=CON_NOTI_CODE_3
    into CON_NOTI_3;

    -- noti renewal noti
    LOOP_COVER = null;
    FOR LOOP_COVER in
        SELECT "log"."id","log"."policy_no","log"."noti_code","log"."is_renewal","log"."remark"
        FROM insurverse.log_noti_renewal as "log"
        WHERE ("log".noti_email_at is null or ("log".noti_sms_at is null and noti_code='noti_3')) and is_renewal = true and noti_code is not null
        LOOP
            -- CLEAR
            RTN_SUCCESS = LOOP_COVER."is_renewal";
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

            RTN_POLICY_NO = LOOP_COVER."policy_no";
            RTN_NOTI_CODE = LOOP_COVER."noti_code";
            RTN_LOG_NOTI_ID = LOOP_COVER."id";

            IF lower(substr(RTN_POLICY_NO,1,2)) = 'mv' THEN
                RTN_IS_COMPULSORY = false;
            ELSE
                RTN_IS_COMPULSORY = true;
            END IF;

            RTN_TOGETHER_POLICY = LOOP_COVER."remark";

            IF RTN_NOTI_CODE = CON_NOTI_CODE_1 THEN
                RTN_EXPIRE_COUNT = CON_NOTI_1;
            ELSIF RTN_NOTI_CODE = CON_NOTI_CODE_2 THEN
                RTN_EXPIRE_COUNT = CON_NOTI_2;
            ELSIF RTN_NOTI_CODE = CON_NOTI_CODE_3 THEN
                RTN_EXPIRE_COUNT = CON_NOTI_3;
            END IF;

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
                                        AND "policy"."End_date" >= SYS_CUR_DATE -- Block Policy have end effective date
                INTO RTN_MC_NO,RTN_MC_ENDDATE,
                    RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                    RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,
                    RTN_CAR_LICENSE_PROVINCE,
                    RTN_EMAIL,RTN_PHONE;

                --RTN_MSG = 'check mc:' || LOOP_COVER."policy_no";
                IF RTN_MC_NO IS NOT NULL THEN
                    RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                                        RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                                        RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
                END IF;
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
                                        AND "policy"."Policy_Enddate" >= SYS_CUR_DATE -- Block Policy have end effective date
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
                      AND "policy"."End_date" >= SYS_CUR_DATE -- Block Policy have end effective date
                    INTO RTN_MC_NO,RTN_MC_ENDDATE;
                END IF;

                --RTN_MSG = 'check mv:' || LOOP_COVER."policy_no";
                IF (RTN_MV_NO IS NULL AND RTN_MC_NO IS NOT NULL) OR (RTN_MV_NO IS NOT NULL AND RTN_MC_NO IS NULL) OR (RTN_MV_NO IS NOT NULL AND RTN_MC_NO IS NOT NULL) THEN
                    RETURN QUERY SELECT RTN_SUCCESS,RTN_ERROR_CODE,RTN_MSG,RTN_LOG_NOTI_ID,RTN_NOTI_CODE,RTN_EXPIRE_COUNT,
                                        RTN_MV_TYPE,RTN_MV_NO,RTN_MC_NO,RTN_OWNER_TITLE,RTN_OWNER_FIRSTNAME,RTN_OWNER_LASTNAME,
                                        RTN_MV_ENDDATE,RTN_MC_ENDDATE,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_EMAIL,RTN_PHONE;
                END IF;
            END IF;
        END LOOP;

END
$function$
