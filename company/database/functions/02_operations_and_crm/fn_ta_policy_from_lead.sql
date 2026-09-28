-- =============================================================================
-- Function: insurverse.fn_ta_policy_from_lead
-- OID: 18906
-- Identity Arguments: (env_name text, im_lead_ta_no integer)
-- Returns: TABLE(rtn_policy_ta_no text, rtn_lead_ta_no integer, rtn_msg text)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_ta_policy_from_lead(env_name text, im_lead_ta_no integer)
 RETURNS TABLE(rtn_policy_ta_no text, rtn_lead_ta_no integer, rtn_msg text)
 LANGUAGE plpgsql
AS $function$
DECLARE
    SYS_POLICY_TA_NO TEXT; SYS_LEAD_NO INT;
    SYS_PACKAGE_ID INT;
    SYS_QUO_NO TEXT; SYS_BOOK TEXT; SYS_INVOICE_NO TEXT;
    TA_NO_ENV TEXT;
    TA_NO_LAST INT; TA_NO_MOD INT; TA_NO TEXT DEFAULT null;
    SYS_MONTH_ARRAY TEXT[];
    SYS_START_DATE TIMESTAMP;
    SYS_END_DATE TIMESTAMP;
    LEAD_START_DATE TIMESTAMP; LEAD_END_DATE TIMESTAMP; LEAD_EMAIL TEXT;
    PAR_POLICY_NO TEXT;
    TA_TRAVEL_TYPE INT;
    LOOP_COVER RECORD;
BEGIN
    SELECT "lead_ta_no","ta_package_id","policy_startdate","policy_enddate","email","ta_travel_type_id"
    FROM insurverse."lead_ta_premium"
    WHERE "lead_ta_no"=im_lead_ta_no and UPPER("payment_status")='SUCCESS'
    INTO SYS_LEAD_NO,SYS_PACKAGE_ID,LEAD_START_DATE,LEAD_END_DATE,LEAD_EMAIL,TA_TRAVEL_TYPE;

    SELECT "policy_ta_no"
    FROM insurverse."policy_ta_premium"
    WHERE "lead_ta_no"=im_lead_ta_no and UPPER("payment_status")='SUCCESS'
    INTO SYS_POLICY_TA_NO;


    IF SYS_LEAD_NO IS NOT NULL AND SYS_LEAD_NO!=0 AND SYS_POLICY_TA_NO IS NULL THEN
        SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];

        LOOP_COVER = null;
        FOR LOOP_COVER in
            SELECT
                lead_ta_no,
                owner_index,
                flag_ref_email_buyer,
                owner_email
            FROM insurverse."lead_ta_participant"
            WHERE "lead_ta_no"=SYS_LEAD_NO
            LOOP

                TA_NO = 'TA-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];

                EXECUTE
                    'SELECT COALESCE(CAST(SUBSTR("policy_ta_no",11,5) AS INT),0)
                    FROM insurverse."policy_ta_premium"
                    WHERE "policy_ta_no" LIKE ''' || TA_NO || '%''' ||
                    'ORDER BY "policy_ta_no" DESC
                    LIMIT 1'
                    INTO TA_NO_LAST;

                IF TA_NO_LAST IS NULL THEN
                    IF LOWER(env_name) = 'dev' THEN
                        TA_NO_LAST = 90000;
                    ELSE
                        TA_NO_LAST = 0;
                    END IF;
                END IF;

                TA_NO_MOD = MOD(TA_NO_LAST+1,8);
                SYS_POLICY_TA_NO = TA_NO || '-' || regexp_replace(TO_CHAR(TA_NO_LAST+1,'00000'), '[^\w]+','') || TA_NO_MOD;

                SYS_START_DATE = CURRENT_TIMESTAMP + INTERVAL '7HOUR'; -- UPDATE FROM Personal Form
                --LEAD_START_DATE = LEAD_START_DATE + INTERVAL '7HOUR';
                -- SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_END_DATE as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
                -- Check TA/PA Logic for year that have 29 day on febuary
                IF TA_TRAVEL_TYPE = 2 THEN
                    IF EXTRACT(MONTH FROM LEAD_START_DATE) = 2 AND EXTRACT(DAY FROM LEAD_START_DATE) = 29 THEN
                        SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE + INTERVAL '1 YEAR' as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
                    ELSE
                        SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE + INTERVAL '1 YEAR' - INTERVAL '1 DAY' as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
                    END IF;
                ELSE
                    SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_END_DATE as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
                END IF;

                IF CAST(SYS_START_DATE as DATE) = CAST(LEAD_START_DATE as DATE) THEN
                    SYS_START_DATE = CAST(CURRENT_TIMESTAMP as Timestamp(0));
                ELSE
                    SYS_START_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE as TIMESTAMP)) + INTERVAL '00 HOUR 01 MINUTE' - INTERVAL '7 HOUR';
                END IF;

                IF LOWER(env_name) = 'dev' THEN
                    SYS_QUO_NO = insurverse.fn_policy_quatationno_iia_dev();
                    SYS_BOOK = insurverse.fn_policy_book_iia_type_dev('ta');
                    SYS_INVOICE_NO = insurverse.fn_policy_invoiceno_iia_type_dev('ta');
                ELSE
                    SYS_QUO_NO = insurverse.fn_policy_quatationno_iia();
                    SYS_BOOK = insurverse.fn_policy_book_iia_type('ta');
                    SYS_INVOICE_NO =insurverse.fn_policy_invoiceno_iia_type('ta');
                END IF;

                INSERT INTO insurverse."policy_ta_premium" (
                    policy_ta_no,policy_status,
                    lead_ta_no,ta_package_id,country_main_id,
                    country_id_array,policy_startdate,policy_enddate,
                    email,payment_status,payment_channel,
                    payment_type,payment_no,payment_ref1,
                    payment_ref2,payment_result,payment_date,
                    promo_trans_id,promo_discount_per,promo_discount_amt,
                    perm_amt,duty_amt,vat_amt,total_amt,
                    policy_quotation_no,policy_book,policy_invoice_no,
                    create_date,update_date,
                    effective_startdate,effective_enddate,
                    affiliate_source,affiliate_code,referal_source,referal_code,
                    discount_amt,user_id,deli_flag,
                    deli_address_th,deli_address_en,
                    deli_subdistrict_id,deli_district_id,deli_province_id,deli_zipcode,
                    promo_discount_sum,perm_amt_main,perm_amt_addon,
                    partner_code,ta_travel_type_id
                )
                SELECT SYS_POLICY_TA_NO,'ACT',
                       "lead"."lead_ta_no","lead"."ta_package_id","lead"."country_main_id",
                       "lead"."country_id_array",SYS_START_DATE,SYS_END_DATE,
                       "lead"."email","lead"."payment_status","lead"."payment_channel",
                       "lead"."payment_type","lead"."payment_no","lead"."payment_ref1",
                       "lead"."payment_ref2","lead"."payment_result","lead"."payment_date" - INTERVAL '7HOUR',
                       "lead"."promo_trans_id","lead"."promo_discount_per","par"."indiv_discount_amt",
                       "par"."indiv_perm_amt","par"."indiv_duty_amt","par"."indiv_vat_amt","par"."indiv_total_amt",
                       SYS_QUO_NO,SYS_BOOK,SYS_INVOICE_NO,
                       now(),now(),
                       now(),"lead"."policy_enddate",
                       "lead"."affiliate_source","lead"."affiliate_code","lead"."referal_source","lead"."referal_code",
                       "par"."indiv_discount_amt","lead"."user_id","lead"."deli_flag",
                       "par"."deli_address_th","par"."deli_address_en",
                       "par"."deli_subdistrict_id","par"."deli_district_id","par"."deli_province_id","par"."deli_zipcode",
                       "par"."indiv_promo_discount_sum","par"."indiv_perm_amt_main","par"."indiv_perm_amt_addon",
                       "lead"."partner_code","lead"."ta_travel_type_id"
                FROM insurverse."lead_ta_premium" as "lead"
                         INNER JOIN insurverse."lead_ta_participant" as "par"
                                    on "lead"."lead_ta_no" = "par"."lead_ta_no"
                                        and "par"."owner_index" = LOOP_COVER."owner_index"
                WHERE "lead"."lead_ta_no"=im_lead_ta_no and UPPER("lead"."payment_status")='SUCCESS';

                INSERT INTO insurverse."policy_ta_coverage"
                (policy_ta_no,ta_package_id,ta_coverage_id,
                 coverage_si_amt,is_active,create_date,
                 update_date,other_amt_min,other_amt_max)
                SELECT SYS_POLICY_TA_NO,ta_package_id,ta_coverage_id,
                       coverage_si_amt,is_active,now(),
                       now(),other_amt_min,other_amt_max
                FROM insurverse."mas_ta_package_coverage"
                WHERE "is_active" = true AND "ta_package_id"=SYS_PACKAGE_ID;

                INSERT INTO insurverse."policy_ta_coverage"
                (policy_ta_no,ta_package_id,ta_coverage_id,
                 coverage_si_amt,is_active,create_date,
                 update_date,other_amt_min,other_amt_max)
                SELECT SYS_POLICY_TA_NO,"pack"."ta_package_id","pack_c"."ta_coverage_id",
                       "pack_c"."coverage_si_amt",true,now(),
                       now(),"pack_c"."other_amt_min","pack_c"."other_amt_max"
                FROM insurverse."lead_ta_package" as "pack"
                         inner join insurverse."mas_ta_package_coverage" as "pack_c"
                                    on "pack"."lead_ta_no"=im_lead_ta_no
                                        and "pack"."ta_package_id"="pack_c"."ta_package_id"
                                        and "pack"."is_addon" = true
                         inner join insurverse."mas_ta_coverage" as "cover"
                                    on "pack_c"."ta_coverage_id"="cover"."ta_coverage_id";

                UPDATE insurverse."lead_ta_participant"
                SET "policy_ta_no"=SYS_POLICY_TA_NO
                WHERE "lead_ta_no"=im_lead_ta_no and "owner_index"=LOOP_COVER."owner_index";

                SELECT "policy_ta_no"
                FROM insurverse."lead_ta_participant"
                WHERE "lead_ta_no"=im_lead_ta_no and "owner_index"=LOOP_COVER."owner_index"
                INTO PAR_POLICY_NO;

                IF SYS_POLICY_TA_NO IS NOT NULL AND PAR_POLICY_NO IS NULL THEN
                    UPDATE insurverse."lead_ta_participant"
                    SET "policy_ta_no"=SYS_POLICY_TA_NO
                    WHERE "lead_ta_no"=SYS_LEAD_NO and "owner_index"=LOOP_COVER."owner_index";
                END IF;

                IF LOOP_COVER."owner_index" = 1 THEN
                    SELECT "policy_ta_no"
                    FROM insurverse."lead_ta_package"
                    WHERE "lead_ta_no"=im_lead_ta_no
                    INTO PAR_POLICY_NO;

                    IF SYS_POLICY_TA_NO IS NOT NULL AND PAR_POLICY_NO IS NULL THEN
                        UPDATE insurverse."lead_ta_package"
                        SET "policy_ta_no"=SYS_POLICY_TA_NO
                        WHERE "lead_ta_no"=SYS_LEAD_NO;
                    END IF;
                END IF;

                RETURN QUERY SELECT SYS_POLICY_TA_NO,im_lead_ta_no,rtn_msg;

            END LOOP;
    ELSE
        rtn_msg = 'Lead not found or Payment status is not success or Policy is duplicate.';
        RETURN QUERY SELECT SYS_POLICY_TA_NO,im_lead_ta_no,rtn_msg;
    END IF;
END
$function$
