-- =============================================================================
-- Function: insurverse.fn_pa_policy_from_lead
-- OID: 18572
-- Identity Arguments: (env_name text, im_lead_no integer)
-- Returns: TABLE(rtn_policy_pa_no text, rtn_lead_pa_no integer, rtn_msg text)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_pa_policy_from_lead(env_name text, im_lead_no integer)
 RETURNS TABLE(rtn_policy_pa_no text, rtn_lead_pa_no integer, rtn_msg text)
 LANGUAGE plpgsql
AS $function$
DECLARE
    SYS_POLICY_NO TEXT; SYS_LEAD_NO INT;
    SYS_PACKAGE_ID INT;
    SYS_QUO_NO TEXT; SYS_BOOK TEXT; SYS_INVOICE_NO TEXT;
    SYS_RECEIPT_NO TEXT; SYS_EMAIL text; SYS_USER_ID text;
    PRE_NO_ENV TEXT;
    PRE_NO_LAST INT; PRE_NO_MOD INT; PRE_NO TEXT DEFAULT null;
    SYS_MONTH_ARRAY TEXT[];
    SYS_START_DATE TIMESTAMP;
    SYS_END_DATE TIMESTAMP;
    LEAD_START_DATE TIMESTAMP; LEAD_END_DATE TIMESTAMP;
    PAR_POLICY_NO TEXT; COV_POLICY_NO TEXT; BENE_POLICY_NO TEXT;
    TAX_DD_FLAG BOOL DEFAULT FALSE;
    TAX_DD_DEATH_COVER_AMT NUMERIC; TAX_DD_MEDICAL_PREM_AMT NUMERIC;
    TAX_DD_DEATH_1 NUMERIC; TAX_DD_DEATH_2 NUMERIC; TAX_DD_MEDICAL_1 NUMERIC;
    TAX_DD_DEATH_AMT NUMERIC DEFAULT 0; TAX_DD_MEDICAL_AMT NUMERIC DEFAULT 0;
begin

    SELECT "lead_pa_no","pa_package_id","policy_startdate","policy_enddate","email","user_id"
    FROM insurverse."lead_pa_premium"
    WHERE "lead_pa_no"=im_lead_no and UPPER("payment_status")='SUCCESS'
    INTO SYS_LEAD_NO,SYS_PACKAGE_ID,LEAD_START_DATE,LEAD_END_DATE,SYS_EMAIL,SYS_USER_ID;

    SELECT "policy_pa_no","tax_deductions"
    FROM insurverse."policy_pa_premium"
    WHERE "lead_pa_no"=im_lead_no and UPPER("payment_status")='SUCCESS'
    INTO SYS_POLICY_NO,TAX_DD_FLAG;

    IF SYS_LEAD_NO IS NOT NULL AND SYS_LEAD_NO!=0 AND SYS_POLICY_NO IS NULL then
        if SYS_USER_ID is null or SYS_USER_ID = '' THEN
            select "user_id"
            from insurverse.sec_user
            where email=LOWER(SYS_EMAIL)
            into SYS_USER_ID;
        end if;

        SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];

        IF LOWER(env_name) = 'dev' THEN
            SYS_QUO_NO = insurverse.fn_policy_quatationno_iia_dev();
            SYS_RECEIPT_NO = insurverse.fn_policy_receiptno_iia_type_dev('pa');
        ELSE
            SYS_QUO_NO = insurverse.fn_policy_quatationno_iia();
            SYS_RECEIPT_NO = insurverse.fn_policy_receiptno_iia_type('pa');
        END IF;

        PRE_NO = 'PA-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];

        EXECUTE
            'SELECT COALESCE(CAST(SUBSTR("policy_pa_no",11,5) AS INT),0)
            FROM insurverse."policy_pa_premium"
            WHERE "policy_pa_no" LIKE ''' || PRE_NO || '%''' ||
            'ORDER BY "policy_pa_no" DESC
            LIMIT 1'
            INTO PRE_NO_LAST;

        IF PRE_NO_LAST IS NULL THEN
            IF LOWER(env_name) = 'dev' THEN
                PRE_NO_LAST = 90000;
            ELSE
                PRE_NO_LAST = 0;
            END IF;
        END IF;

        PRE_NO_MOD = MOD(PRE_NO_LAST+1,8);
        SYS_POLICY_NO = PRE_NO || '-' || regexp_replace(TO_CHAR(PRE_NO_LAST+1,'00000'), '[^\w]+','') || PRE_NO_MOD;

        SYS_START_DATE = CURRENT_TIMESTAMP + INTERVAL '7HOUR'; -- UPDATE FROM Personal Form
        LEAD_START_DATE = LEAD_START_DATE + INTERVAL '7HOUR';
        /*
        if EXTRACT(month FROM LEAD_START_DATE) = 2 AND EXTRACT(day FROM LEAD_START_DATE) = 29 THEN
            SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE + INTERVAL '1 YEAR' as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
        else
            SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE + INTERVAL '1 YEAR' as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '1 DAY' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
        end if;
        */
        -- Check TA/PA Logic for year that have 29 day on febuary
        IF EXTRACT(MONTH FROM LEAD_START_DATE) = 2 AND EXTRACT(DAY FROM LEAD_START_DATE) = 29 THEN
            SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE + INTERVAL '1 YEAR' as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
        ELSE
            SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE + INTERVAL '1 YEAR' - INTERVAL '1 DAY' as TIMESTAMP)) + INTERVAL '23 HOUR 59 MINUTE 59 SECOND' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
        END IF;

        IF CAST(SYS_START_DATE as DATE) = CAST(LEAD_START_DATE as DATE) THEN
            SYS_START_DATE = CAST(CURRENT_TIMESTAMP as Timestamp(0));
        ELSE
            SYS_START_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE as TIMESTAMP)) + INTERVAL '00 HOUR 01 MINUTE' - INTERVAL '7 HOUR';
        END IF;

        -- TAX DD Cal.
        WITH set_para as (SELECT
                              im_lead_no as "in_lead_no"
        )
        SELECT
            (SELECT "cover"."si_cover_amt"
             FROM insurverse.lead_pa_coverage as "cover"
                      INNER JOIN set_para
                                 ON "cover"."lead_pa_no"="set_para"."in_lead_no"
             WHERE "cover".pa_coverage_id IN (1,2) LIMIT 1) as "tax_dd_death_si",
            (SELECT "cover"."si_prem_amt"
             FROM insurverse.lead_pa_coverage as "cover"
                      INNER JOIN set_para
                                 ON "cover"."lead_pa_no"="set_para"."in_lead_no"
             WHERE "cover".pa_coverage_id IN (3) LIMIT 1) as "tax_dd_medical_prem"
        INTO TAX_DD_DEATH_COVER_AMT,TAX_DD_MEDICAL_PREM_AMT;

        IF TAX_DD_DEATH_COVER_AMT IS NOT NULL THEN
            SELECT
                (SELECT mas_num
                 FROM insurverse."mas_other_description"
                 WHERE "mas_other_type"='tax_dd' AND "mas_other_code"='factor_death_1'
                   AND "mas_product_type"='pa' LIMIT 1) as "factor_death_1",
                (SELECT mas_num
                 FROM insurverse."mas_other_description"
                 WHERE "mas_other_type"='tax_dd' AND "mas_other_code"='factor_death_2'
                   AND "mas_product_type"='pa' LIMIT 1) as "factor_death_2",
                (SELECT mas_num
                 FROM insurverse."mas_other_description"
                 WHERE "mas_other_type"='tax_dd' AND "mas_other_code"='factor_medical_1'
                   AND "mas_product_type"='pa' LIMIT 1) as "factor_medical_1"
            INTO TAX_DD_DEATH_1, TAX_DD_DEATH_2, TAX_DD_MEDICAL_1;

            if TAX_DD_DEATH_1 is null then
                TAX_DD_DEATH_1 = 0;
            end if;
            if TAX_DD_DEATH_2 is null then
                TAX_DD_DEATH_2 = 0;
            end if;
            if TAX_DD_MEDICAL_1 is null then
                TAX_DD_MEDICAL_1 = 0;
            end if;

            if TAX_DD_MEDICAL_PREM_AMT is null then
                TAX_DD_MEDICAL_PREM_AMT = 0;
            end if;

            TAX_DD_DEATH_AMT = CEIL((TAX_DD_DEATH_COVER_AMT*((TAX_DD_DEATH_1/100)*(TAX_DD_DEATH_2/100)))*100)/100;
            TAX_DD_MEDICAL_AMT = CEIL((CEIL(TAX_DD_MEDICAL_PREM_AMT*(TAX_DD_MEDICAL_1/100))+TAX_DD_MEDICAL_PREM_AMT)*100)/100;
        END IF;

        INSERT INTO insurverse."policy_pa_premium" (
            policy_pa_no,policy_status,
            lead_pa_no,pa_package_id,
            policy_startdate,policy_enddate,
            email,payment_status,payment_channel,
            payment_type,payment_no,payment_ref1,
            payment_ref2,payment_result,payment_date,
            promo_trans_id,promo_discount_per,promo_discount_amt,
            perm_amt,duty_amt,vat_amt,total_amt,
            policy_quotation_no,policy_receipt_no,
            create_date,update_date,
            effective_startdate,effective_enddate,
            discount_amt,pa_age_range_id,pa_occupation_id,
            user_id,tax_deductions,
            affiliate_source,affiliate_code,
            referal_source,referal_code,
            deli_flag,deli_address_th,deli_address_en,
            deli_subdistrict_id,deli_district_id,deli_province_id,
            deli_zipcode,pa_question_id_array,
            tax_deductions_death_amt,tax_deductions_medical_amt,tax_deductions_total_amt
        )
        SELECT SYS_POLICY_NO,'ACT',
               lead_pa_no,pa_package_id,
               SYS_START_DATE,SYS_END_DATE,
               LOWER(email),payment_status,payment_channel,
               payment_type,payment_no,payment_ref1,
               payment_ref2,payment_result,payment_date - INTERVAL '7HOUR',
               promo_trans_id,promo_discount_per,promo_discount_amt,
               perm_amt,duty_amt,COALESCE(vat_amt,0),total_amt,
               SYS_QUO_NO,SYS_RECEIPT_NO,
               now(),now(),
               now(),policy_enddate,
               discount_amt,pa_age_range_id,pa_occupation_id,
               SYS_USER_ID,tax_deductions,
               affiliate_source,'', -- Close affiliate [CR]
               referal_source,referal_code,
               deli_flag,deli_address_th,deli_address_en,
               deli_subdistrict_id,deli_district_id,deli_province_id,
               deli_zipcode,pa_question_id_array,
               TAX_DD_DEATH_AMT,TAX_DD_MEDICAL_AMT,(TAX_DD_DEATH_AMT+TAX_DD_MEDICAL_AMT)
        FROM insurverse."lead_pa_premium"
        WHERE "lead_pa_no"=im_lead_no and UPPER("payment_status")='SUCCESS';

        UPDATE insurverse."lead_pa_participant"
        SET "policy_pa_no"=SYS_POLICY_NO
        WHERE "lead_pa_no"=im_lead_no;

        UPDATE insurverse."lead_pa_coverage"
        SET "policy_pa_no"=SYS_POLICY_NO
        WHERE "lead_pa_no"=im_lead_no;

        UPDATE insurverse."lead_pa_beneficiary"
        SET "policy_pa_no"=SYS_POLICY_NO
        WHERE "lead_pa_no"=im_lead_no;
    ELSIF SYS_POLICY_NO IS NOT NULL THEN
        WITH set_para as (SELECT
                              im_lead_no as "in_lead_no"
        )
        SELECT
            COALESCE((SELECT "cover"."si_cover_amt"
                      FROM insurverse.lead_pa_coverage as "cover"
                               INNER JOIN set_para
                                          ON "cover"."lead_pa_no"="set_para"."in_lead_no"
                      WHERE "cover".pa_coverage_id IN (1,2) LIMIT 1),0) as "tax_dd_death_si",
            COALESCE((SELECT "cover"."si_prem_amt"
                      FROM insurverse.lead_pa_coverage as "cover"
                               INNER JOIN set_para
                                          ON "cover"."lead_pa_no"="set_para"."in_lead_no"
                      WHERE "cover".pa_coverage_id IN (3) LIMIT 1),0) as "tax_dd_medical_prem"
        INTO TAX_DD_DEATH_COVER_AMT,TAX_DD_MEDICAL_PREM_AMT;

        select user_id,email
        from insurverse."policy_pa_premium"
        WHERE policy_pa_no=SYS_POLICY_NO
        into SYS_USER_ID,SYS_EMAIL;

        if SYS_USER_ID is null or SYS_USER_ID = '' THEN
            select "user_id"
            from insurverse.sec_user
            where email=LOWER(SYS_EMAIL)
            into SYS_USER_ID;

            UPDATE insurverse.policy_pa_premium
            SET user_id=SYS_USER_ID
            WHERE policy_pa_no=SYS_POLICY_NO;
        end if;

        IF TAX_DD_DEATH_COVER_AMT IS NOT NULL THEN
            SELECT
                (SELECT mas_num
                 FROM insurverse."mas_other_description"
                 WHERE "mas_other_type"='tax_dd' AND "mas_other_code"='factor_death_1'
                   AND "mas_product_type"='pa' LIMIT 1) as "factor_death_1",
                (SELECT mas_num
                 FROM insurverse."mas_other_description"
                 WHERE "mas_other_type"='tax_dd' AND "mas_other_code"='factor_death_2'
                   AND "mas_product_type"='pa' LIMIT 1) as "factor_death_2",
                (SELECT mas_num
                 FROM insurverse."mas_other_description"
                 WHERE "mas_other_type"='tax_dd' AND "mas_other_code"='factor_medical_1'
                   AND "mas_product_type"='pa' LIMIT 1) as "factor_medical_1"
            INTO TAX_DD_DEATH_1, TAX_DD_DEATH_2, TAX_DD_MEDICAL_1;

            if TAX_DD_MEDICAL_PREM_AMT is null then
                TAX_DD_MEDICAL_PREM_AMT = 0;
            end if;

            TAX_DD_DEATH_AMT = CEIL((TAX_DD_DEATH_COVER_AMT*((TAX_DD_DEATH_1/100)*(TAX_DD_DEATH_2/100)))*100)/100;
            TAX_DD_MEDICAL_AMT = CEIL((CEIL(TAX_DD_MEDICAL_PREM_AMT*(TAX_DD_MEDICAL_1/100))+TAX_DD_MEDICAL_PREM_AMT)*100)/100;
        END IF;

        UPDATE insurverse.policy_pa_premium
        SET tax_deductions_death_amt=TAX_DD_DEATH_AMT,tax_deductions_medical_amt=TAX_DD_MEDICAL_AMT,
            tax_deductions_total_amt=(TAX_DD_DEATH_AMT+TAX_DD_MEDICAL_AMT)
        WHERE policy_pa_no=SYS_POLICY_NO;

    ELSE
        rtn_msg = 'Lead not found or Payment status is not success or Policy is duplicate.';
    END IF;

    SELECT "policy_pa_no"
    FROM insurverse."lead_pa_participant"
    WHERE "lead_pa_no"=im_lead_no
    INTO PAR_POLICY_NO;

    IF SYS_POLICY_NO IS NOT NULL AND PAR_POLICY_NO IS NULL THEN
        UPDATE insurverse."lead_pa_participant"
        SET "policy_pa_no"=SYS_POLICY_NO
        WHERE "lead_pa_no"=SYS_LEAD_NO;
    END IF;

    SELECT "policy_pa_no"
    FROM insurverse."lead_pa_coverage"
    WHERE "lead_pa_no"=im_lead_no
    INTO COV_POLICY_NO;

    IF SYS_POLICY_NO IS NOT NULL AND COV_POLICY_NO IS NULL THEN
        UPDATE insurverse."lead_pa_coverage"
        SET "policy_pa_no"=SYS_POLICY_NO
        WHERE "lead_pa_no"=SYS_LEAD_NO;
    END IF;

    SELECT "policy_pa_no"
    FROM insurverse."lead_pa_beneficiary"
    WHERE "lead_pa_no"=im_lead_no
    INTO BENE_POLICY_NO;

    IF SYS_POLICY_NO IS NOT NULL AND BENE_POLICY_NO IS NULL THEN
        UPDATE insurverse."lead_pa_beneficiary"
        SET "policy_pa_no"=SYS_POLICY_NO
        WHERE "lead_pa_no"=SYS_LEAD_NO;
    END IF;

    RETURN QUERY SELECT SYS_POLICY_NO,im_lead_no,rtn_msg;
END
$function$
