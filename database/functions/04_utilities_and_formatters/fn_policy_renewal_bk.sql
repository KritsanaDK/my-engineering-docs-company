-- =============================================================================
-- Function: insurverse.fn_policy_renewal_bk
-- OID: 18720
-- Identity Arguments: (in_policy_no text, in_flag_noti boolean, in_flag_lead boolean)
-- Returns: TABLE(rtn_success boolean, rtn_ncb_tier integer, rtn_error_code text, rtn_msg text, rtn_policy_no text, rtn_prem_amt numeric, rtn_duty_amt numeric, rtn_vat_amt numeric, rtn_total_amt numeric, rtn_is_compulsory boolean, rtn_together_policy text, rtn_lead_no integer, rtn_log_noti_id integer, rtn_json_body text, rtn_prem_act numeric)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_bk(in_policy_no text, in_flag_noti boolean, in_flag_lead boolean)
 RETURNS TABLE(rtn_success boolean, rtn_ncb_tier integer, rtn_error_code text, rtn_msg text, rtn_policy_no text, rtn_prem_amt numeric, rtn_duty_amt numeric, rtn_vat_amt numeric, rtn_total_amt numeric, rtn_is_compulsory boolean, rtn_together_policy text, rtn_lead_no integer, rtn_log_noti_id integer, rtn_json_body text, rtn_prem_act numeric)
 LANGUAGE plpgsql
AS $function$
declare
-- return result
RTN_SUCCESS BOOL;
RTN_MSG TEXT;
RTN_ERROR_CODE TEXT;
RTN_NCB_TIER INTEGER;
RTN_POLICY_NO TEXT;
RTN_PREM_AMT numeric;
RTN_DUTY_AMT numeric;
RTN_VAT_AMT numeric;
RTN_TOTAL_AMT numeric;
RTN_JSON_BODY TEXT;
RTN_PREM_ACT numeric;
RTN_LEAD_NO INTEGER;
RTN_LOG_NOTI_ID INTEGER;
RTN_IS_COMPULSORY BOOL;
RTN_TOGETHER_POLICY TEXT;
-- log
LOG_TARIFF TEXT;
-- center parameter
SYS_TEST_RUN BOOLEAN;
SYS_LAST_LOG_NOTI_ID INTEGER;
SYS_CUR_DATE TIMESTAMP;
SYS_PRODUCT TEXT;
SYS_POLICY_NO TEXT;
SYS_SUB_PRODUCT TEXT;
SYS_EMAIL TEXT;
SYS_MOBILE TEXT;
SYS_MC_MV_NO TEXT;
SYS_MC_NO TEXT;
SYS_POLICY_OLD_ENDDATE TIMESTAMP;
SYS_NCB_TIER INTEGER;
SYS_PROMO_TRANS_ID INTEGER;
SYS_PROMO_DISC_PERC numeric;
SYS_GARAGETYPE TEXT;
SYS_REF_POLICY_NO TEXT;
SYS_REF_POLICY_NO_PURE TEXT;
SYS_PREMIUM_AMT numeric;
SYS_CLAIM_AMT numeric;
SYS_CLAIM_RATE numeric;
SYS_MV_STARTDATE TIMESTAMP;
SYS_MV_ENDDATE TIMESTAMP;
SYS_MC_STARTDATE TIMESTAMP;
SYS_MC_ENDDATE TIMESTAMP;
SYS_REMARK TEXT;
-- mc premium
IC_PREMIUM DECIMAL(18, 2);
IC_DISCOUNT DECIMAL(18, 2);
IC_NET_PREMIUM DECIMAL(18, 2);
IC_STAMP DECIMAL(18, 2);
IC_VAT DECIMAL(18, 2);
IC_TOTAL DECIMAL(18, 2);
-- mas_renewal_config
CON_NOTI_1 numeric;
CON_NOTI_2 numeric;
CON_NOTI_3 numeric;
CON_SI_REDUCE_PERC numeric;
CON_BASE_ADD_AMT numeric;
CON_AGE_MAX numeric;
CON_CLAIM_RESERVE numeric;
CON_PREMIUM_MIN numeric;
-- tariff si and discount parameter
TR_NCB_TIER numeric;
TR_CAR_BRAND TEXT;
TR_CAR_MODEL TEXT;
TR_CAR_YEAR TEXT;
TR_GARAGETYPE TEXT;
TR_NAMEDAGE TEXT;
TR_PAR1_YEAR INTEGER;
TR_PAR2_YEAR INTEGER;
TR_USAGE INTEGER;
TR_CC TEXT;
TR_GROUP TEXT;
TR_COMP_CODE TEXT;
TR_BASE_PREMIUM numeric;
TR_BASE_PREMIUM_V5 numeric;
TR_SI_LIMIT numeric;
TR_ACCESS_LIMIT numeric;
TR_TPBI_LIMIT numeric;
TR_TPPD_LIMIT numeric;
TR_MV01_LIMIT numeric;
TR_MV02_LIMIT numeric;
TR_MV03_LIMIT numeric;
TR_MV01_AMT numeric;
TR_MV02_AMT numeric;
TR_MV03_AMT numeric;
TR_FLEET_PERC numeric;
TR_NCB_PERC numeric;
TR_OTHER_PERC numeric;
TR_DUTY_PERC numeric;
TR_VAT_PERC numeric;
TR_BODYTYPE TEXT;
TR_DOOR INTEGER;
TR_FLAG_ACT TEXT;
TR_PREM_ACT numeric;
TR_MV_ENDDATE TIMESTAMP;
TR_MC_ENDDATE TIMESTAMP;
-- tariff factor
TRF_USAGE numeric;
TRF_CC numeric;
TRF_DRIVER numeric;
TRF_CAR_YEAR numeric;
TRF_SI numeric;
TRF_CAR_GROUP numeric;
TRF_TPBI numeric;
TRF_TPPD numeric;
TRF_SI_V5 numeric;
-- new amount PARAMETER
NEW_CAR_AGE INTEGER;
NEW_CAR_CC TEXT;
NEW_YEAR_DRIVER numeric;
NEW_AGE_DRIVER INTEGER;
NEW_NAMEDAGE TEXT;
NEW_FLEET_AMT numeric;
NEW_NCB_AMT numeric;
NEW_OTHER_AMT numeric;
NEW_TOTAL_AMT_EX_MV numeric;
NEW_TOTAL_AMT_MV numeric;
NEW_PREMIUM_V5_OD numeric;
NEW_TOTAL_AMT_EX_MV_NO_DRIVER numeric;
NEW_DRIVER_DISCOUNT numeric;
-- CR21
PREM_VERSION_VARIABLE numeric;
OIC_VERSION_VARIABLE TEXT;
IS_NEW_OIC BOOLEAN;
TRF_DRIVER_BEHAVIOR numeric;
NEW_DRIVER_BEHAVIOR_DISCOUNT numeric;
NCB_DISCOUNT_DIFF numeric;
DRIVER_DISCOUNT numeric;
DRIVER_DISCOUNT_DIFF numeric;
TR_BASE_LOSS_MAX numeric;
TR_BASE_LOSS_MIN numeric;
TR_MV31_AMT numeric;
BASE_TRF_DRIVER_BEHAVIOR numeric;

TR_FIRST_NAME_1 TEXT;
TR_FIRST_NAME_2 TEXT;
TR_FIRST_NAME_3 TEXT;
TR_FIRST_NAME_4 TEXT;
TR_FIRST_NAME_5 TEXT;
TR_LAST_NAME_1 TEXT;
TR_LAST_NAME_2 TEXT;
TR_LAST_NAME_3 TEXT;
TR_LAST_NAME_4 TEXT;
TR_LAST_NAME_5 TEXT;
TR_PREFIX_NAME_1 TEXT;
TR_PREFIX_NAME_2 TEXT;
TR_PREFIX_NAME_3 TEXT;
TR_PREFIX_NAME_4 TEXT;
TR_PREFIX_NAME_5 TEXT;
TR_OCCUPATION_1 TEXT;
TR_OCCUPATION_2 TEXT;
TR_OCCUPATION_3 TEXT;
TR_OCCUPATION_4 TEXT;
TR_OCCUPATION_5 TEXT;
TR_OCCUPATION_CODE_1 TEXT;
TR_OCCUPATION_CODE_2 TEXT;
TR_OCCUPATION_CODE_3 TEXT;
TR_OCCUPATION_CODE_4 TEXT;
TR_OCCUPATION_CODE_5 TEXT;
TR_DRIVER_CITIZEN_1 TEXT;
TR_DRIVER_CITIZEN_2 TEXT;
TR_DRIVER_CITIZEN_3 TEXT;
TR_DRIVER_CITIZEN_4 TEXT;
TR_DRIVER_CITIZEN_5 TEXT;
TR_DRIVER_LICENSE_1 TEXT;
TR_DRIVER_LICENSE_2 TEXT;
TR_DRIVER_LICENSE_3 TEXT;
TR_DRIVER_LICENSE_4 TEXT;
TR_DRIVER_LICENSE_5 TEXT;
TR_DRIVER_CONSENT_1 boolean;
TR_DRIVER_CONSENT_2 boolean;
TR_DRIVER_CONSENT_3 boolean;
TR_DRIVER_CONSENT_4 boolean;
TR_DRIVER_CONSENT_5 boolean;
TR_DRIVER_BEHAVIOR_1 int;
TR_DRIVER_BEHAVIOR_2 int;
TR_DRIVER_BEHAVIOR_3 int;
TR_DRIVER_BEHAVIOR_4 int;
TR_DRIVER_BEHAVIOR_5 int;
TR_DRIVER_BEHAVIOR_CAL integer;
CURRENT_OIC_VERSION TEXT;
CURRENT_PREM_VERSION numeric;

V_CAR_PRICE numeric;
V_TMP_PRICE numeric;

begin
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

-- CR21
IS_NEW_OIC = false;
NCB_DISCOUNT_DIFF = 0;
TR_BASE_LOSS_MAX = 12000;
TR_BASE_LOSS_MIN = 7600;
BASE_TRF_DRIVER_BEHAVIOR = 105;

V_CAR_PRICE = 0;
V_TMP_PRICE = 0;

-- check last log_noti_renewal
select
	"id",
	"create_at"
from
	insurverse."log_noti_renewal"
where
	"policy_no" = "in_policy_no"
order by
	"id" desc
limit 1
into
	SYS_LAST_LOG_NOTI_ID,
	SYS_CUR_DATE;

-- set SYS_CUR_DATE is null = now()
if SYS_CUR_DATE is null then SYS_CUR_DATE = now();
end if;

-- check product
SYS_PRODUCT = lower(substr("in_policy_no", 1, 2));

-- check policy no
if SYS_PRODUCT = 'mc' then
    select
        "policy"."Car_Act_No",
        '0',
        "policy"."Brand",
        "policy"."Model",
        "policy"."Year",
        "policy"."End_date",
        "policy_mv"."Policy_No",
        "policy"."Car_Comp_Code",
        "policy"."BodyType",
        "policy"."Doors",
        "policy"."End_date",
        "policy"."email",
        coalesce("policy"."oic_version", "policy_mv"."oic_version") as oic_version
    from
        insurverse."Policy_Car_Act_Discount_Premium" as "policy"
    left join insurverse."Policy_Header" as "policy_mv"
    on
        "policy"."Policy_No" = "policy_mv"."Policy_No"
        and cast("policy"."End_date" + interval '7HOUR' as DATE)= cast("policy_mv"."Policy_Enddate" + interval '7HOUR' as DATE)
    where
        "policy"."Car_Act_No" = "in_policy_no"
    into
        SYS_POLICY_NO,
        SYS_SUB_PRODUCT,
        TR_CAR_BRAND,
        TR_CAR_MODEL,
        TR_CAR_YEAR,
        SYS_POLICY_OLD_ENDDATE,
        SYS_MC_MV_NO,
        TR_COMP_CODE,
        TR_BODYTYPE,
        TR_DOOR,
        TR_MC_ENDDATE,
        SYS_EMAIL,
        OIC_VERSION_VARIABLE;

    RTN_TOGETHER_POLICY = SYS_MC_MV_NO;
    SYS_MC_STARTDATE = TR_MC_ENDDATE;
    SYS_MC_ENDDATE = TR_MC_ENDDATE + interval '1YEAR';

    select
        "ref_policy_no"
    from
        insurverse."Policy_Car_Act_Discount_Premium"
    where
        "ref_policy_no" = "in_policy_no"
    into
        SYS_REF_POLICY_NO;

    if SYS_REF_POLICY_NO is null then
        select
            "ref_policy_no"
        from
            insurverse."Lead_Car_Act_Discount_Premium"
        where
            "ref_policy_no" = "in_policy_no"
            and UPPER("Payment_status")= 'SUCCESS'
        into
            SYS_REF_POLICY_NO;
    end if;

    select
        "ref_policy_no"
    from
        insurverse."Policy_Header"
    where
        "ref_policy_no" = SYS_MC_MV_NO
    into
        SYS_REF_POLICY_NO_PURE;

    if SYS_REF_POLICY_NO_PURE is not null then
        SYS_REF_POLICY_NO_PURE = null;
        SYS_MC_MV_NO = null;
        RTN_TOGETHER_POLICY = null;
    end if;
end if;

-- set in_policy_no to mv policy no
if SYS_MC_MV_NO is not null then
    SYS_PRODUCT = 'mv';
    SYS_MC_NO = SYS_POLICY_NO;
    SYS_POLICY_NO = null;
    "in_policy_no" = SYS_MC_MV_NO;
end if;

if SYS_PRODUCT = 'mv' then
    select
        "policy"."Policy_No",
        case
            when "policy"."Car_Act_No" is not null
            and cast("policy"."Policy_Enddate" + interval '7HOUR' as DATE) = (
            select
                cast("End_date" + interval '7HOUR' as DATE)
            from
                insurverse."Policy_Car_Act_Discount_Premium" as "policy_mc"
            where
                "policy"."Car_Act_No" = "policy_mc"."Car_Act_No")
    then "policy"."Car_Act_No"
            else null
        end as "Car_Act_No",
        "policy"."Type",
        "policy"."Brand",
        "policy"."Model",
        "policy"."Year",
        "policy"."GarageType",
        "prem"."BodyType",
        "prem"."Doors",
        "policy"."Policy_Enddate",
        "prem"."Basic_Premium",
        "prem"."basic_premium_v5",
        "prem"."SI_Limit",
        "prem"."SI_Access_Limit",
        "prem"."SI_TPBI_Limit",
        "prem"."SI_TPPD_Limit",
        "prem"."SI_MV01_Limit",
        "prem"."SI_MV02_Limit",
        "prem"."SI_MV03_Limit",
        "prem"."SI_MV01_Amt",
        "prem"."SI_MV02_Amt",
        "prem"."SI_MV03_Amt",
        "prem"."Fleet_Disc_perc",
        "prem"."NCB_Disc_perc",
        "prem"."Other_Disc_perc",
        "prem"."NamedAge",
        "prem"."YOB_Driver_1",
        "prem"."YOB_Driver_2",
        "prem"."Usage",
        "policy"."CC",
        "policy"."Group",
        "prem"."promo_trans_id",
        "prem"."promo_discount_per",
        "prem"."Flag_Car_Act",
        "policy"."Policy_Enddate",
        "policy"."email",
		coalesce("policy"."oic_version", "prem"."oic_version") as oic_version,
		"policy"."prem_version",

		"policy"."Par_first_name_1",
		"policy"."Par_first_name_2",
		"policy"."par_first_name_3",
		"policy"."par_first_name_4",
		"policy"."par_first_name_5",
		"policy"."Par_last_name_1",
		"policy"."Par_last_name_2",
		"policy"."par_last_name_3",
		"policy"."par_last_name_4",
		"policy"."par_last_name_5",
		"policy"."Par_prefix_name_1",
		"policy"."Par_prefix_name_2",
		"policy"."par_prefix_name_3",
		"policy"."par_prefix_name_4",
		"policy"."par_prefix_name_5",
		"policy"."Par_occupation_1",
		"policy"."Par_occupation_2",
		"policy"."par_occupation_3",
		"policy"."par_occupation_4",
		"policy"."par_occupation_5",
		"policy"."par_occupation_code_1",
		"policy"."par_occupation_code_2",
		"policy"."par_occupation_code_3",
		"policy"."par_occupation_code_4",
		"policy"."par_occupation_code_5",

        "policy"."Par_citizen_id_1",
        "policy"."Par_citizen_id_2",
        "policy"."par_citizen_id_3",
        "policy"."par_citizen_id_4",
        "policy"."par_citizen_id_5",
        "policy"."Par_Driver_license_no_1",
        "policy"."Par_Driver_license_no_2",
        "policy"."par_driver_license_no_3",
        "policy"."par_driver_license_no_4",
        "policy"."par_driver_license_no_5",
        "policy"."driver_behavior_consent_1",
        "policy"."driver_behavior_consent_2",
        "policy"."driver_behavior_consent_3",
        "policy"."driver_behavior_consent_4",
        "policy"."driver_behavior_consent_5",
        "policy"."driver_behavior_1",
        "policy"."driver_behavior_2",
        "policy"."driver_behavior_3",
        "policy"."driver_behavior_4",
        "policy"."driver_behavior_5"
    from
        insurverse."Policy_Header" as "policy"
    inner join insurverse."Policy_coverage_premium" as "prem"
    on
        "policy"."Policy_No" = "prem"."Policy_No"
        and "policy"."Policy_No" = "in_policy_no"
    into
        SYS_POLICY_NO,
        SYS_MC_NO,
        SYS_SUB_PRODUCT,
        TR_CAR_BRAND,
        TR_CAR_MODEL,
        TR_CAR_YEAR,
        TR_GARAGETYPE,
        TR_BODYTYPE,
        TR_DOOR,
        SYS_POLICY_OLD_ENDDATE,
        TR_BASE_PREMIUM,
        TR_BASE_PREMIUM_V5,
        TR_SI_LIMIT,
        TR_ACCESS_LIMIT,
        TR_TPBI_LIMIT,
        TR_TPPD_LIMIT,
        TR_MV01_LIMIT,
        TR_MV02_LIMIT,
        TR_MV03_LIMIT,
        TR_MV01_AMT,
        TR_MV02_AMT,
        TR_MV03_AMT,
        TR_FLEET_PERC,
        TR_NCB_PERC,
        TR_OTHER_PERC,
        TR_NAMEDAGE,
        TR_PAR1_YEAR,
        TR_PAR2_YEAR,
        TR_USAGE,
        TR_CC,
        TR_GROUP,
        SYS_PROMO_TRANS_ID,
        SYS_PROMO_DISC_PERC,
        TR_FLAG_ACT,
        TR_MV_ENDDATE,
        SYS_EMAIL,
        OIC_VERSION_VARIABLE,
		PREM_VERSION_VARIABLE,
		TR_FIRST_NAME_1,
		TR_FIRST_NAME_2,
		TR_FIRST_NAME_3,
		TR_FIRST_NAME_4,
		TR_FIRST_NAME_5,
		TR_LAST_NAME_1,
		TR_LAST_NAME_2,
		TR_LAST_NAME_3,
		TR_LAST_NAME_4,
		TR_LAST_NAME_5,
		TR_PREFIX_NAME_1, 
		TR_PREFIX_NAME_2,
		TR_PREFIX_NAME_3,
		TR_PREFIX_NAME_4, 
		TR_PREFIX_NAME_5, 
		TR_OCCUPATION_1, 
		TR_OCCUPATION_2, 
		TR_OCCUPATION_3, 
		TR_OCCUPATION_4, 
		TR_OCCUPATION_5, 
		TR_OCCUPATION_CODE_1, 
		TR_OCCUPATION_CODE_2, 
		TR_OCCUPATION_CODE_3, 
		TR_OCCUPATION_CODE_4, 
		TR_OCCUPATION_CODE_5, 
        TR_DRIVER_CITIZEN_1,
        TR_DRIVER_CITIZEN_2,
        TR_DRIVER_CITIZEN_3,
        TR_DRIVER_CITIZEN_4,
        TR_DRIVER_CITIZEN_5,
        TR_DRIVER_LICENSE_1,
        TR_DRIVER_LICENSE_2,
        TR_DRIVER_LICENSE_3,
        TR_DRIVER_LICENSE_4,
        TR_DRIVER_LICENSE_5,
        TR_DRIVER_CONSENT_1,
        TR_DRIVER_CONSENT_2,
        TR_DRIVER_CONSENT_3,
        TR_DRIVER_CONSENT_4,
        TR_DRIVER_CONSENT_5,
        TR_DRIVER_BEHAVIOR_1,
        TR_DRIVER_BEHAVIOR_2,
        TR_DRIVER_BEHAVIOR_3,
        TR_DRIVER_BEHAVIOR_4,
        TR_DRIVER_BEHAVIOR_5;

    RTN_TOGETHER_POLICY = SYS_MC_NO;

	--  set driver behavior 1 when citizen is not null and behavior is null
    TR_DRIVER_BEHAVIOR_1 = NULLIF(CASE WHEN TR_DRIVER_CITIZEN_1 IS NOT NULL AND TR_DRIVER_BEHAVIOR_1 IS NULL THEN 1 ELSE TR_DRIVER_BEHAVIOR_1 END, 0);
    TR_DRIVER_BEHAVIOR_2 = NULLIF(CASE WHEN TR_DRIVER_CITIZEN_2 IS NOT NULL AND TR_DRIVER_BEHAVIOR_2 IS NULL THEN 1 ELSE TR_DRIVER_BEHAVIOR_2 END, 0);
    TR_DRIVER_BEHAVIOR_3 = NULLIF(CASE WHEN TR_DRIVER_CITIZEN_3 IS NOT NULL AND TR_DRIVER_BEHAVIOR_3 IS NULL THEN 1 ELSE TR_DRIVER_BEHAVIOR_3 END, 0);
    TR_DRIVER_BEHAVIOR_4 = NULLIF(CASE WHEN TR_DRIVER_CITIZEN_4 IS NOT NULL AND TR_DRIVER_BEHAVIOR_4 IS NULL THEN 1 ELSE TR_DRIVER_BEHAVIOR_4 END, 0);
    TR_DRIVER_BEHAVIOR_5 = NULLIF(CASE WHEN TR_DRIVER_CITIZEN_5 IS NOT NULL AND TR_DRIVER_BEHAVIOR_5 IS NULL THEN 1 ELSE TR_DRIVER_BEHAVIOR_5 END, 0);
    
	-- set driver consent false when citizen is not null and consent is null
    TR_DRIVER_CONSENT_1 = 
    CASE 
        WHEN TR_DRIVER_CITIZEN_1 IS NOT NULL AND TR_DRIVER_CONSENT_1 IS NULL THEN false 
        ELSE TR_DRIVER_CONSENT_1 
    END;
    TR_DRIVER_CONSENT_2 =
    CASE 
        WHEN TR_DRIVER_CITIZEN_2 IS NOT NULL AND TR_DRIVER_CONSENT_2 IS NULL THEN false 
        ELSE TR_DRIVER_CONSENT_2 
    END;
    TR_DRIVER_CONSENT_3 = 
    CASE 
        WHEN TR_DRIVER_CITIZEN_3 IS NOT NULL AND TR_DRIVER_CONSENT_3 IS NULL THEN false 
        ELSE TR_DRIVER_CONSENT_3 
    END;
    TR_DRIVER_CONSENT_4 =
    CASE 
        WHEN TR_DRIVER_CITIZEN_4 IS NOT NULL AND TR_DRIVER_CONSENT_4 IS NULL THEN false 
        ELSE TR_DRIVER_CONSENT_4 
    END;
    TR_DRIVER_CONSENT_5 =
    CASE 
        WHEN TR_DRIVER_CITIZEN_5 IS NOT NULL AND TR_DRIVER_CONSENT_5 IS NULL THEN false 
        ELSE TR_DRIVER_CONSENT_5 
    END;

    SELECT coalesce(LEAST(TR_DRIVER_BEHAVIOR_1, TR_DRIVER_BEHAVIOR_2, TR_DRIVER_BEHAVIOR_3, TR_DRIVER_BEHAVIOR_4, TR_DRIVER_BEHAVIOR_5), 0)
    INTO TR_DRIVER_BEHAVIOR_CAL;

    if TR_MV_ENDDATE is not null then
        SYS_MV_STARTDATE = TR_MV_ENDDATE;
        SYS_MV_ENDDATE = TR_MV_ENDDATE + interval '1YEAR';
    end if;

    select
        "Total"
    from
        insurverse."Imp_Discount_Premium"
    where
        "Brand" = TR_CAR_BRAND
        and "Model" = TR_CAR_MODEL
        and "Year" = TR_CAR_YEAR
        and "BodyType" = TR_BODYTYPE
        and "Doors" = TR_DOOR
    limit 1
    into
        TR_PREM_ACT;

    if TR_PREM_ACT is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER009';
        RTN_MSG = 'Compulsory Master Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

    return QUERY
    select
        RTN_SUCCESS,
        RTN_NCB_TIER,
        RTN_ERROR_CODE,
        RTN_MSG,
        RTN_POLICY_NO,
        RTN_PREM_AMT,
        RTN_DUTY_AMT,
        RTN_VAT_AMT,
        RTN_TOTAL_AMT,
        RTN_IS_COMPULSORY,
        RTN_TOGETHER_POLICY,
        RTN_LEAD_NO,
        RTN_LOG_NOTI_ID,
        RTN_JSON_BODY,
        RTN_PREM_ACT;

    return;
    end if;

    select
        "ref_policy_no"
    from
        insurverse."Policy_Header"
    where
        "ref_policy_no" = "in_policy_no"
    into
        SYS_REF_POLICY_NO;

    -- check in lead table
    if SYS_REF_POLICY_NO is null then
        select
            "ref_policy_no"
        from
            insurverse."Lead_coverage_premium"
        where
            "ref_policy_no" = "in_policy_no"
            and UPPER("Payment_status")= 'SUCCESS'
        into
            SYS_REF_POLICY_NO;
    end if;
        
    -- Total MV + MC
    if TR_FLAG_ACT is not null and UPPER(TR_FLAG_ACT) = 'Y' and SYS_MC_NO is not null then
        RTN_PREM_ACT = TR_PREM_ACT;
        SYS_MC_STARTDATE = SYS_MV_STARTDATE;
        SYS_MC_ENDDATE = SYS_MV_ENDDATE;
    else
        SYS_MC_STARTDATE = null;
        SYS_MC_ENDDATE = null;
        TR_FLAG_ACT = 'N';
        RTN_PREM_ACT = 0;
    end if;
end if;

-- check is new oic
if OIC_VERSION_VARIABLE is not null and OIC_VERSION_VARIABLE <> '' then
    IS_NEW_OIC := true;
else
    IS_NEW_OIC := false;
end if;

-- set CURRENT_OIC_VERSION
select sp.para_str
from insurverse.sys_param sp 
where
	sp.dom_code = 'Policy'
	and sp.sub_dom_code = 'oic_version'
	and sp.para_code = 'current_version'
into
    CURRENT_OIC_VERSION;

-- set CURRENT_PREM_VERSION
select ipp."version" 
from insurverse."Imp_Price_Premium" ipp 
where
	ipp."Brand" = TR_CAR_BRAND
	and ipp."Model" = TR_CAR_MODEL
	-- and ipp."Year" = TR_CAR_YEAR
	-- and ipp."GarageType" = TR_GARAGE_TYPE
	and ipp.is_active = true
	and ipp."version" is not null
limit 1
into 
    CURRENT_PREM_VERSION;

-- check policy no found
if SYS_POLICY_NO is null then
    RTN_SUCCESS = false;
    RTN_ERROR_CODE = 'ER001';
    RTN_MSG = 'Policy Number is not found.';
    RTN_PREM_ACT = 0;
    SYS_POLICY_NO = "in_policy_no";
    if in_flag_noti = true then
        insert
            into
            insurverse.log_noti_renewal(policy_no,
            is_active,
            is_renewal,
            error_code,
            return_message,
            remark)
        values ("in_policy_no",
        true,
        false,
        RTN_ERROR_CODE,
        RTN_MSG,
        SYS_MC_NO)
        returning "id"
        into
            RTN_LOG_NOTI_ID;
    end if;

    return QUERY
    select
        RTN_SUCCESS,
        RTN_NCB_TIER,
        RTN_ERROR_CODE,
        RTN_MSG,
        RTN_POLICY_NO,
        RTN_PREM_AMT,
        RTN_DUTY_AMT,
        RTN_VAT_AMT,
        RTN_TOTAL_AMT,
        RTN_IS_COMPULSORY,
        RTN_TOGETHER_POLICY,
        RTN_LEAD_NO,
        RTN_LOG_NOTI_ID,
        RTN_JSON_BODY,
        RTN_PREM_ACT;
    return;
end if;

-- get mobile from email
if SYS_EMAIL is not null then
    select
        "mobile"
    from
        insurverse."sec_user"
    where
        "email" = SYS_EMAIL
    into
        SYS_MOBILE;
end if ;

RTN_POLICY_NO = SYS_POLICY_NO;

-- check already renewal
if SYS_TEST_RUN is not true then
    if SYS_REF_POLICY_NO is not null or SYS_REF_POLICY_NO_PURE is not null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER005';
        RTN_MSG = 'The policy number has already been renewed.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;
end if;

-- check policy expired
if cast(now() as TIMESTAMP) > cast(SYS_POLICY_OLD_ENDDATE as TIMESTAMP) then
    RTN_SUCCESS = false;
    RTN_ERROR_CODE = 'ER006';
    RTN_MSG = 'The policy number has expired.';
    RTN_PREM_ACT = 0;

    if in_flag_noti = true then
        insert
            into
            insurverse.log_noti_renewal(policy_no,
            is_active,
            is_renewal,
            error_code,
            return_message,
            remark)
        values ("in_policy_no",
        true,
        false,
        RTN_ERROR_CODE,
        RTN_MSG,
        SYS_MC_NO)
        returning "id"
        into
            RTN_LOG_NOTI_ID;
    end if;

    return QUERY
    select
        RTN_SUCCESS,
        RTN_NCB_TIER,
        RTN_ERROR_CODE,
        RTN_MSG,
        RTN_POLICY_NO,
        RTN_PREM_AMT,
        RTN_DUTY_AMT,
        RTN_VAT_AMT,
        RTN_TOTAL_AMT,
        RTN_IS_COMPULSORY,
        RTN_TOGETHER_POLICY,
        RTN_LEAD_NO,
        RTN_LOG_NOTI_ID,
        RTN_JSON_BODY,
        RTN_PREM_ACT;

    return;
end if;

-- mc renewal
if SYS_PRODUCT = 'mc' then
    RTN_IS_COMPULSORY = true;
    RTN_PREM_ACT = 0;

    select
        "Premium",
        "Discount",
        "Net_Premium",
        "Stamp",
        "Vat",
        "Total"
    from
        insurverse."Imp_Discount_Premium"
    where
        "Brand" = TR_CAR_BRAND
        and "Model" = TR_CAR_MODEL
        and "Year" = TR_CAR_YEAR
        and "BodyType" = TR_BODYTYPE
        and "Doors" = TR_DOOR
    into
        IC_PREMIUM,
        IC_DISCOUNT,
        IC_NET_PREMIUM,
        IC_STAMP,
        IC_VAT,
        IC_TOTAL;

    RTN_PREM_AMT = IC_NET_PREMIUM;
    RTN_DUTY_AMT = IC_STAMP;
    RTN_VAT_AMT = IC_VAT;
    RTN_TOTAL_AMT = IC_TOTAL;

    if IC_TOTAL is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER009';
        RTN_MSG = 'Compulsory Master Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;

    if in_flag_lead = true then
        select
            "Car_Act_Lead_No"
        from
            insurverse."Lead_Car_Act_Discount_Premium"
        order by
            "Car_Act_Lead_No" desc
        limit 1
        into
            RTN_LEAD_NO;

        if RTN_LEAD_NO is null then 
            RTN_LEAD_NO = 1;
        else 
            RTN_LEAD_NO = RTN_LEAD_NO + 1;
        end if;

        insert into insurverse."Lead_Car_Act_Discount_Premium"
        (
            "Car_Act_Lead_No",
            "Brand",
            "Model",
            "Year",
            "Doors",
            "Seat",
            "Wg",
            "Group",
            "Type",
            "Sedan",
            "BodyType",
            "Start_date",
            "End_date",
            "prefix_name",
            "first_name",
            "last_name",
            "birth_date",
            "citizen_id",
            "province_id",
            "subdistrict_id",
            "district_id",
            "zipcode",
            "countryid",
            "phone",
            "Occupation",
            "Remark",
            "Car_Comp_Code",
            "Premium",
            "Discount",
            "Net_Premium",
            "Stamp",
            "Vat",
            "Total",
            "CC",
            "Car_license_no",
            "Car_license_provice",
            "Car_serial_no",
            "Effective_Startdate",
            "Effective_Enddate",
            "Comp_Code",
            "Deli_Addr_line1",
            "Deli_Addr_line2",
            "Deli_Addr_line3",
            "Deli_province_id",
            "Deli_subdistrict_id",
            "Deli_district_id",
            "Deli_zipcode",
            "Deli_countryid",
            "Car_license_type",
            "Car_color",
            "address",
            "email",
            "Bene_Type",
            "Bene_Title",
            "Bene_Firstname",
            "Bene_Midname",
            "Bene_Lastname",
            "Bene_ID_card",
            "Flag_Deli",
            "ref_policy_no",
            "oic_version"
        )
        select
            RTN_LEAD_NO,
            "policy"."Brand",
            "policy"."Model",
            "policy"."Year",
            "policy"."Doors",
            "policy"."Seat",
            "policy"."Wg",
            "policy"."Group",
            "policy"."Type",
            "policy"."Sedan",
            "policy"."BodyType",
            cast(SYS_MC_STARTDATE as DATE),
            cast(SYS_MC_ENDDATE as DATE),
            "policy"."prefix_name",
            "policy"."first_name",
            "policy"."last_name",
            "policy"."birth_date",
            "policy"."citizen_id",
            "policy"."province_id",
            "policy"."subdistrict_id",
            "policy"."district_id",
            "policy"."zipcode",
            "policy"."countryid",
            SYS_MOBILE,
            "policy"."Occupation",
            "policy"."Remark",
            "policy"."Car_Comp_Code",
            IC_PREMIUM,
            IC_DISCOUNT,
            IC_NET_PREMIUM,
            IC_STAMP,
            IC_VAT,
            IC_TOTAL,
            "policy"."CC",
            "policy"."Car_license_no",
            "policy"."Car_license_provice",
            "policy"."Car_serial_no",
            now(),
            SYS_MC_ENDDATE,
            "policy"."Comp_Code",
            "policy"."Deli_Addr_line1",
            "policy"."Deli_Addr_line2",
            "policy"."Deli_Addr_line3",
            "policy"."Deli_province_id",
            "policy"."Deli_subdistrict_id",
            "policy"."Deli_district_id",
            "policy"."Deli_zipcode",
            "policy"."Deli_countryid",
            "policy"."Car_license_type",
            "policy"."Car_color",
            "policy"."address",
            "policy"."email",
            "policy"."Bene_Type",
            "policy"."Bene_Title",
            "policy"."Bene_Firstname",
            "policy"."Bene_Midname",
            "policy"."Bene_Lastname",
            "policy"."Bene_ID_card",
            "policy"."Flag_Deli",
            SYS_POLICY_NO,
            CURRENT_OIC_VERSION
        from
            insurverse."Policy_Car_Act_Discount_Premium" as "policy"
        where
            "policy"."Car_Act_No" = "in_policy_no";
        --RTN_MSG = 'RTN_LEAD_NO:' || RTN_LEAD_NO || ' ,SYS_MC_STARTDATE:' || SYS_MC_STARTDATE || ' ,SYS_MC_ENDDATE:' || SYS_MC_ENDDATE;
        --RTN_MSG = 'IC_PREMIUM:' || IC_PREMIUM || ' ,IC_DISCOUNT:' || IC_DISCOUNT || ' ,IC_NET_PREMIUM:' || IC_NET_PREMIUM || ' ,IC_STAMP:' || IC_STAMP || ' ,IC_VAT:' || IC_VAT || ' ,IC_TOTAL:' || IC_TOTAL;
    end if;

    -- insert noti renewal mc
    if in_flag_noti = true then
        insert into insurverse.log_noti_renewal
        (
            policy_no,
            premium_amt,
            duty_amt,
            vat_amt,
            total_amt,
            msg_html_body,
            msg_sms_body,
            msg_html_title,
            msg_push_body,
            is_active,
            is_renewal,
            error_code,
            return_message
        )
        values (
            SYS_POLICY_NO,
            IC_NET_PREMIUM,
            IC_STAMP,
            IC_VAT,
            IC_TOTAL,
            null,
            null,
            null,
            null,
            true,
            true,
            null,
            null
        )
        returning "id"
        into
            RTN_LOG_NOTI_ID;
    end if;

    return QUERY
    select
        RTN_SUCCESS,
        RTN_NCB_TIER,
        RTN_ERROR_CODE,
        RTN_MSG,
        RTN_POLICY_NO,
        RTN_PREM_AMT,
        RTN_DUTY_AMT,
        RTN_VAT_AMT,
        RTN_TOTAL_AMT,
        RTN_IS_COMPULSORY,
        RTN_TOGETHER_POLICY,
        RTN_LEAD_NO,
        RTN_LOG_NOTI_ID,
        RTN_JSON_BODY,
        RTN_PREM_ACT;

    return;
end if;

-- ==== set config data
-- check ncb tier FUNCTION
select
	"rn_ncb"."rtn_ncb_tier",
	"rn_ncb"."rtn_success",
	"rn_ncb"."rtn_error_code",
	"rn_ncb"."rtn_msg"
from
	insurverse."fn_policy_renewal_ncb"("in_policy_no") as "rn_ncb"
into
	TR_NCB_TIER,
	RTN_SUCCESS,
	RTN_ERROR_CODE,
	RTN_MSG;

if RTN_SUCCESS = false then
    RTN_ERROR_CODE = 'ER100';
    RTN_MSG = 'Function is not success.';
    RTN_PREM_ACT = 0;

    return QUERY
    select
        RTN_SUCCESS,
        RTN_NCB_TIER,
        RTN_ERROR_CODE,
        RTN_MSG,
        RTN_POLICY_NO,
        RTN_PREM_AMT,
        RTN_DUTY_AMT,
        RTN_VAT_AMT,
        RTN_TOTAL_AMT,
        RTN_IS_COMPULSORY,
        RTN_TOGETHER_POLICY,
        RTN_LEAD_NO,
        RTN_LOG_NOTI_ID,
        RTN_JSON_BODY,
        RTN_PREM_ACT;

    return;
end if;

-- ==== mv renewal
if SYS_PRODUCT = 'mv' then
    -- check config data mv
    -- CON_SI_REDUCE_PERC
    select
        "renewal_num"
    from
        insurverse."mas_renewal_config" as "rn_config"
    where
        SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
        and "rn_config"."renewal_type" = 'tariff'
        and "rn_config"."renewal_code" = 'reduce_si'
    into
        CON_SI_REDUCE_PERC;

    if CON_SI_REDUCE_PERC is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[CON_SI_REDUCE_PERC] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;

    -- CON_BASE_ADD_AMT
    select
        "renewal_num"
    from
        insurverse."mas_renewal_config" as "rn_config"
    where
        SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
        and "rn_config"."renewal_type" = 'tariff'
        and "rn_config"."renewal_code" = 'add_base'
    into
        CON_BASE_ADD_AMT; -- เพิ่ม tier ขับดี

    if CON_BASE_ADD_AMT is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[CON_BASE_ADD_AMT] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;

    -- ==== set tariff config
    -- set duty percent
    select
        "para_value"
    from
        insurverse.sys_param
    where
        dom_code = 'purchase'
        and sub_dom_code = 'duty'
        and para_code = 'duty_per'
    into
        TR_DUTY_PERC;

    if TR_DUTY_PERC is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TR_DUTY_PERC] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;

    -- set vat percent
    select
        "para_value"
    from
        insurverse.sys_param
    where
        dom_code = 'purchase'
        and sub_dom_code = 'vat'
        and para_code = 'vat_per'
    into
        TR_VAT_PERC;

    if TR_VAT_PERC is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TR_VAT_PERC] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;

    -- set tariff usage
    select
        coalesce("tariff_factor", 0)
    from
        insurverse."mas_tariff"
    where
        replace(SYS_SUB_PRODUCT, '+', '')= "mas_tariff"."policy_type"
        and "mas_tariff"."tariff_group" = 'motor'
        and "mas_tariff"."tariff_code" = 'usage'
        and LOWER("tariff_mapping") = cast(TR_USAGE as TEXT)
    into
        TRF_USAGE;

    if TRF_USAGE is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_USAGE] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;
        
    -- set tariff group
    select
        coalesce("tariff_factor", 0)
    from
        insurverse."mas_tariff"
    where
        replace(SYS_SUB_PRODUCT, '+', '')= "mas_tariff"."policy_type"
        and "mas_tariff"."tariff_group" = 'motor'
        and "mas_tariff"."tariff_code" = 'vehicle_group'
        and LOWER("tariff_mapping") = cast(TR_GROUP as TEXT)
    into
        TRF_CAR_GROUP;

    if TRF_CAR_GROUP is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_CAR_GROUP] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;

    if TR_CC is not null then
        TR_CC = REGEXP_REPLACE(TR_CC, '[^0-9]', '', 'g');

        if TR_CC = '' then
            TR_CC = '0';
        end if;
    end if;
        
    -- set tariff cc
    select
        coalesce("tariff_factor", 0),
        "tariff_mapping"
    from
        insurverse."mas_tariff"
    where
        replace(SYS_SUB_PRODUCT, '+', '')= "mas_tariff"."policy_type"
        and "mas_tariff"."tariff_group" = 'motor'
        and "mas_tariff"."tariff_code" = 'size'
        and cast(TR_CC as INTEGER) between tariff_num_min and tariff_num_max
    into
        TRF_CC,
        NEW_CAR_CC;

    if TRF_CC is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_CC] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;
    
    -- set tariff car year
    NEW_CAR_AGE = cast(TO_CHAR(SYS_POLICY_OLD_ENDDATE, 'yyyy') as INTEGER) - cast(TR_CAR_YEAR as INTEGER) + 1;

    --RTN_MSG = COALESCE(RTN_MSG,'') || ' - POLICY_ENDYEAR : ' || CAST(TO_CHAR(SYS_POLICY_OLD_ENDDATE,'yyyy') as INTEGER) || ' - CAR_YEAR : ' || CAST(TR_CAR_YEAR as INTEGER);
    select
        coalesce("tariff_factor", 0)
    from
        insurverse."mas_tariff"
    where
        replace(SYS_SUB_PRODUCT, '+', '')= "mas_tariff"."policy_type"
        and "mas_tariff"."tariff_group" = 'motor'
        and "mas_tariff"."tariff_code" = 'vehicle_age'
        and NEW_CAR_AGE between "tariff_num_min" and "tariff_num_max"
    limit 1
    into
        TRF_CAR_YEAR;

    if TRF_CAR_YEAR is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_CAR_YEAR] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;
        
    -- set tariff nameaged - YOB Driver
    if (TR_PAR1_YEAR is not null and TR_PAR1_YEAR != 0) and (TR_PAR2_YEAR is not null and TR_PAR2_YEAR != 0) then

        if TR_PAR1_YEAR >= TR_PAR2_YEAR then
            NEW_YEAR_DRIVER = TR_PAR1_YEAR;
        else
            NEW_YEAR_DRIVER = TR_PAR2_YEAR;
        end if;

    elsif (TR_PAR1_YEAR is not null and TR_PAR1_YEAR != 0) and (TR_PAR2_YEAR is null or TR_PAR2_YEAR = 0) then
        NEW_YEAR_DRIVER = TR_PAR1_YEAR;

    elsif (TR_PAR1_YEAR is null or TR_PAR1_YEAR = 0) and (TR_PAR2_YEAR is not null and TR_PAR2_YEAR != 0) then
        NEW_YEAR_DRIVER = TR_PAR2_YEAR;

    elsif (TR_PAR1_YEAR is null or TR_PAR1_YEAR = 0) and (TR_PAR2_YEAR is null or TR_PAR2_YEAR = 0) then
        NEW_YEAR_DRIVER = null;

    end if;
        
    -- set tariff nameaged
    -- CR21 add condition NOT IS_NEW_OIC
    if NEW_YEAR_DRIVER is not null and TR_NAMEDAGE != 'Unnamed' and not IS_NEW_OIC then
        -- set age new renewal startdate
        NEW_AGE_DRIVER = cast(TO_CHAR(SYS_POLICY_OLD_ENDDATE, 'yyyy') as INTEGER) - NEW_YEAR_DRIVER;

        select
            coalesce("tariff_factor", 0),
            "tariff_mapping"
        from
            insurverse.mas_tariff
        where
            tariff_group = 'motor'
            and "tariff_code" = 'driver_name'
            and "policy_type" = replace(SYS_SUB_PRODUCT, '+', '')
            and NEW_AGE_DRIVER between tariff_num_min and tariff_num_max
            and tariff_mapping != 'Unnamed'
        into
            TRF_DRIVER,
            NEW_NAMEDAGE;
    else
        select
            coalesce("tariff_factor", 0),
            "tariff_mapping"
        from
            insurverse.mas_tariff
        where
            tariff_group = 'motor'
            and "tariff_code" = 'driver_name'
            and "policy_type" = replace(SYS_SUB_PRODUCT, '+', '')
            and tariff_mapping = TR_NAMEDAGE
        into
            TRF_DRIVER,
            NEW_NAMEDAGE;
    end if;

    if TRF_DRIVER is null and not IS_NEW_OIC then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_DRIVER] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;
        
    -- set tariff driver behavior
    select
        coalesce("tariff_factor", 0)
    from
        insurverse."mas_tariff"
    where
        replace(SYS_SUB_PRODUCT, '+', '')= "mas_tariff"."policy_type"
        and "mas_tariff"."tariff_group" = 'motor'
        and "mas_tariff"."tariff_code" = 'driver_behaviour'
        and LOWER("tariff_mapping") = cast(TR_DRIVER_BEHAVIOR_CAL as TEXT)
    into
        TRF_DRIVER_BEHAVIOR;

    if TRF_DRIVER_BEHAVIOR is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_DRIVER_BEHAVIOR] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;

    -- set tariff si tpbi
    select
        coalesce("tariff_factor", 0)
    from
        insurverse.mas_tariff
    where
        tariff_group = 'motor'
        and "tariff_code" = 'vehicle_tpbi'
        and "policy_type" = replace(SYS_SUB_PRODUCT, '+', '')
        and TR_TPBI_LIMIT between tariff_num_min and tariff_num_max
    into
        TRF_TPBI;

    if TRF_TPBI is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_TPBI] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;
        
    -- set tariff si tppd
    select
        coalesce("tariff_factor", 0)
    from
        insurverse.mas_tariff
    where
        tariff_group = 'motor'
        and "tariff_code" = 'vehicle_tppd'
        and "policy_type" = replace(SYS_SUB_PRODUCT, '+', '')
        and TR_TPPD_LIMIT between tariff_num_min and tariff_num_max
    into
        TRF_TPPD;

    if TRF_TPPD is null then
        RTN_SUCCESS = false;
        RTN_ERROR_CODE = 'ER003';
        RTN_MSG = '[TRF_TPPD] Config Data is not found.';
        RTN_PREM_ACT = 0;

        if in_flag_noti = true then
            insert
                into
                insurverse.log_noti_renewal(policy_no,
                is_active,
                is_renewal,
                error_code,
                return_message,
                remark)
            values ("in_policy_no",
            true,
            false,
            RTN_ERROR_CODE,
            RTN_MSG,
            SYS_MC_NO)
            returning "id"
            into
                RTN_LOG_NOTI_ID;
        end if;

        return QUERY
        select
            RTN_SUCCESS,
            RTN_NCB_TIER,
            RTN_ERROR_CODE,
            RTN_MSG,
            RTN_POLICY_NO,
            RTN_PREM_AMT,
            RTN_DUTY_AMT,
            RTN_VAT_AMT,
            RTN_TOTAL_AMT,
            RTN_IS_COMPULSORY,
            RTN_TOGETHER_POLICY,
            RTN_LEAD_NO,
            RTN_LOG_NOTI_ID,
            RTN_JSON_BODY,
            RTN_PREM_ACT;

        return;
    end if;
        
    -- remove promo code discount percent
    if SYS_PROMO_DISC_PERC is null then 
        SYS_PROMO_DISC_PERC = 0;
    end if;

    TR_OTHER_PERC = TR_OTHER_PERC - SYS_PROMO_DISC_PERC;

    -- motor vehicle 31
    if TR_GARAGETYPE = 'SC' then
        TR_MV31_AMT = 1;
    else
        TR_MV31_AMT = 0;
    end if;

    -- tariff calculator
    -- class 1 calculator
    if SYS_SUB_PRODUCT = '1' then
        -- CON_AGE_MAX
        select
            "renewal_num"
        from
            insurverse."mas_renewal_config" as "rn_config"
        where
            SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
            and "rn_config"."renewal_type" = 'car_age'
            and "rn_config"."renewal_mapping" = cast(TR_USAGE as TEXT)
            and ("rn_config"."renewal_code" = 'year_sc'
                and TR_GARAGETYPE = 'SC'
                or "rn_config"."renewal_code" = 'year_g'
                and TR_GARAGETYPE = 'G')
        into
            CON_AGE_MAX;
                
            --RTN_MSG = 'CON_AGE_MAX: ' || CON_AGE_MAX;
        if CON_AGE_MAX is null then
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[CON_AGE_MAX_' || SYS_SUB_PRODUCT || '] Config Data is not found.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                false,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        --CON_CLAIM_RESERVE
        select
            "renewal_num"
        from
            insurverse."mas_renewal_config" as "rn_config"
        where
            SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
            and "rn_config"."renewal_type" = 'claim'
            and "rn_config"."renewal_code" = 'loss_reserve'
        into
            CON_CLAIM_RESERVE;

        if CON_CLAIM_RESERVE is null then
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[CON_CLAIM_RESERVE] Config Data is not found.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                false,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        -- query permium_amt (exclude duty & vat)
        select
            "Perm_Amt"
        from
            insurverse."Policy_coverage_premium"
        where
            "Policy_No" = "in_policy_no"
        into
            SYS_PREMIUM_AMT;

        -- query claim_amt (wrong side)
        select
            sum("total_loss_reserve")
        from
            insurverse."sf_claim_coverage"
        where
            "policy_number" = "in_policy_no"
            and "responsibility" != 'ฝ่ายถูก'
        into
            SYS_CLAIM_AMT;
                    
        -- set SYS_PREMIUM_AMT is null = 0
        if SYS_PREMIUM_AMT is null then 
            SYS_PREMIUM_AMT = 0;
        end if;
                
        -- set SYS_CLAIM_AMT is null = SYS_CLAIM_RATE = 0
        if SYS_CLAIM_AMT is null then 
            SYS_CLAIM_RATE = 0;
            SYS_CLAIM_AMT = 0;
        end if;

        -- cal SYS_CLAIM_RATE
        if SYS_PREMIUM_AMT != 0 then
            SYS_CLAIM_RATE = (SYS_CLAIM_AMT * 100) / SYS_PREMIUM_AMT;
        else
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER002';
            RTN_MSG = 'Premium Amount is equal 0.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                false,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        -- check car age , garage , loss reserve
        if (CON_AGE_MAX is not null and NEW_CAR_AGE > CON_AGE_MAX) or (TR_GARAGETYPE = 'SC' and SYS_CLAIM_RATE > CON_CLAIM_RESERVE) then
            RTN_SUCCESS = true;
            RTN_ERROR_CODE = 'PE001';
            RTN_MSG = 'The age of the car cannot choose the same type of garage for insurance renewal.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                true,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;

        TR_SI_LIMIT = TR_SI_LIMIT - (TR_SI_LIMIT * (CON_SI_REDUCE_PERC / 100));

        -- FIX MA (2025-01-13)
        if TR_SI_LIMIT < 1000000 then
            TR_SI_LIMIT = CEIL(TR_SI_LIMIT / 10000)* 10000;
        else
            TR_SI_LIMIT = CEIL((CEIL(TR_SI_LIMIT / 10000)* 10000)/ 100000)* 100000;
        end if;

        -- set tariff si
        select
            coalesce("tariff_factor", 0)
        from
            insurverse.mas_tariff
        where
            tariff_group = 'motor'
            and "tariff_code" = 'vehicle_si'
            and "policy_type" = replace(SYS_SUB_PRODUCT, '+', '')
            and (TR_SI_LIMIT + coalesce(TR_ACCESS_LIMIT, 0)) between tariff_num_min and tariff_num_max
        into
            TRF_SI;

        if TRF_SI is null then
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_SI] Config Data is not found.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                false,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        -- set old ncb tier
        if TR_NCB_PERC <= 0 then
            SYS_NCB_TIER = 0;
        elsif TR_NCB_PERC between 1 and 20 then
            SYS_NCB_TIER = 1;
        elsif TR_NCB_PERC between 21 and 30 then
            SYS_NCB_TIER = 2;
        elsif TR_NCB_PERC between 31 and 40 then
            SYS_NCB_TIER = 3;
        elsif TR_NCB_PERC between 41 and 50 then
            SYS_NCB_TIER = 4;
        else
            SYS_NCB_TIER = 5;
        end if;
                
        -- set new ncb tier
        SYS_NCB_TIER = SYS_NCB_TIER + TR_NCB_TIER;

        -- set ncb percent
        if SYS_NCB_TIER < 0 then
            TR_BASE_PREMIUM = TR_BASE_PREMIUM + CON_BASE_ADD_AMT;
            TR_NCB_PERC = 0;
        elsif SYS_NCB_TIER = 0 then
            TR_NCB_PERC = 0;
        elsif SYS_NCB_TIER = 1 then
            TR_NCB_PERC = 20;
        elsif SYS_NCB_TIER = 2 then
            TR_NCB_PERC = 30;
        elsif SYS_NCB_TIER = 3 then
            TR_NCB_PERC = 40;
        elsif SYS_NCB_TIER = 4 then
            TR_NCB_PERC = 50;
        else
            TR_NCB_PERC = 50;
        end if;

        -- new calculation CR21
		TR_BASE_PREMIUM = TR_BASE_PREMIUM - 50;
        if (TR_BASE_PREMIUM) < TR_BASE_LOSS_MIN then
            TR_BASE_PREMIUM = TR_BASE_LOSS_MIN;
        end if;

        -- NCB discount
        if TR_NCB_PERC >= 50 then
            NCB_DISCOUNT_DIFF = TR_NCB_PERC - 40;
            TR_NCB_PERC = 40;
        end if;

        -- driver discount CR21
        DRIVER_DISCOUNT_DIFF = 
			CASE 
				WHEN NOT IS_NEW_OIC THEN TRF_DRIVER_BEHAVIOR - TRF_DRIVER
				ELSE 0 
			END;

        -- other discount add NCB discount and driver discount
        TR_OTHER_PERC = TR_OTHER_PERC + NCB_DISCOUNT_DIFF + DRIVER_DISCOUNT_DIFF;

        if TR_OTHER_PERC > 60 then
            TR_OTHER_PERC = 60;
        end if;
                
        -- CR21
        NEW_TOTAL_AMT_EX_MV = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (TRF_DRIVER_BEHAVIOR / 100) * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
        NEW_TOTAL_AMT_EX_MV_NO_DRIVER = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (BASE_TRF_DRIVER_BEHAVIOR / 100) * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
        NEW_DRIVER_DISCOUNT = 0;
        NEW_DRIVER_BEHAVIOR_DISCOUNT = 
            case when NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV < 0 then 
                0
            else 
                NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV
            end;
        NEW_TOTAL_AMT_MV = cast(TR_MV01_AMT as numeric) + cast(TR_MV02_AMT as numeric) + cast(TR_MV03_AMT as numeric) + TR_MV31_AMT;
        RTN_PREM_AMT = cast(NEW_TOTAL_AMT_EX_MV as numeric) + cast(NEW_TOTAL_AMT_MV as numeric);
        NEW_FLEET_AMT = FLOOR(RTN_PREM_AMT * (TR_FLEET_PERC / 100));
        NEW_NCB_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT) * (TR_NCB_PERC / 100));
        NEW_OTHER_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT - NEW_NCB_AMT) * (TR_OTHER_PERC / 100));
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_FLEET_AMT;
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_NCB_AMT;
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_OTHER_AMT;

    -- class 2+ 3+ calculator
    elsif SYS_SUB_PRODUCT = '2+' or SYS_SUB_PRODUCT = '3+' then
        -- CON_AGE_MAX
        select
            "renewal_num"
        from
            insurverse."mas_renewal_config" as "rn_config"
        where
            SYS_CUR_DATE between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
            and "rn_config"."renewal_type" = 'car_age'
            and ("rn_config"."renewal_code" = 'age_2plus'
                and SYS_SUB_PRODUCT = '2+'
                or "rn_config"."renewal_code" = 'age_3plus'
                and SYS_SUB_PRODUCT = '3+')
        into
            CON_AGE_MAX;

        if CON_AGE_MAX is null then
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[CON_AGE_MAX_' || SYS_SUB_PRODUCT || '] Config Data is not found.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                false,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        -- check car age , garage
        if CON_AGE_MAX is not null and NEW_CAR_AGE > CON_AGE_MAX then
            RTN_SUCCESS = true;
            RTN_ERROR_CODE = 'PE002';
            RTN_MSG = 'The age of the car prevents the insurance policy from being renewed in the same coverage class.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                true,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        -- default base premium v5 if NULL
        if TR_BASE_PREMIUM_V5 is null then
            if TR_ACCESS_LIMIT is null or TR_ACCESS_LIMIT = 0 then
                TR_BASE_PREMIUM_V5 = 3500;
            else
                TR_BASE_PREMIUM_V5 = 4500;
            end if;
        end if;

        -- set tariff si
        select
            coalesce("tariff_factor", 0)
        from
            insurverse.mas_tariff
        where
            tariff_group = 'motor'
            and "tariff_code" = 'vehicle_si'
            and "policy_type" = replace(SYS_SUB_PRODUCT, '+', '')
            and (TR_SI_LIMIT + coalesce(TR_ACCESS_LIMIT, 0)) between tariff_num_min and tariff_num_max
        into
            TRF_SI;

        if TRF_SI is null then
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_SI] Config Data is not found.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                false,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        -- set tariff si v5
        select
            coalesce("tariff_factor", 0)
        from
            insurverse.mas_tariff
        where
            tariff_group = 'motor'
            and "tariff_code" = 'vehicle_base_v5'
            and "policy_type" = SYS_SUB_PRODUCT
            and (TR_SI_LIMIT + coalesce(TR_ACCESS_LIMIT, 0)) between tariff_num_min and tariff_num_max
        into
            TRF_SI_V5;

        if TRF_SI_V5 is null then
            RTN_SUCCESS = false;
            RTN_ERROR_CODE = 'ER003';
            RTN_MSG = '[TRF_SI_V5] Config Data is not found.';
            RTN_PREM_ACT = 0;

            if in_flag_noti = true then
                insert
                    into
                    insurverse.log_noti_renewal(policy_no,
                    is_active,
                    is_renewal,
                    error_code,
                    return_message,
                    remark)
                values ("in_policy_no",
                true,
                false,
                RTN_ERROR_CODE,
                RTN_MSG,
                SYS_MC_NO)
                returning "id"
                into
                    RTN_LOG_NOTI_ID;
            end if;

            return QUERY
            select
                RTN_SUCCESS,
                RTN_NCB_TIER,
                RTN_ERROR_CODE,
                RTN_MSG,
                RTN_POLICY_NO,
                RTN_PREM_AMT,
                RTN_DUTY_AMT,
                RTN_VAT_AMT,
                RTN_TOTAL_AMT,
                RTN_IS_COMPULSORY,
                RTN_TOGETHER_POLICY,
                RTN_LEAD_NO,
                RTN_LOG_NOTI_ID,
                RTN_JSON_BODY,
                RTN_PREM_ACT;

            return;
        end if;
                
        -- Premium v5 OD
        NEW_PREMIUM_V5_OD = FLOOR(TR_BASE_PREMIUM_V5 * (TRF_SI_V5 / 100));

        -- new oic class 2+ 3+ calculation CR21
        -- NCB discount
        if TR_NCB_PERC >= 50 then
            NCB_DISCOUNT_DIFF = TR_NCB_PERC - 40;
            TR_NCB_PERC = 40;
        end if;

     	-- driver discount CR21
        DRIVER_DISCOUNT_DIFF = 
			CASE 
				WHEN NOT IS_NEW_OIC THEN TRF_DRIVER_BEHAVIOR - TRF_DRIVER
				ELSE 0 
			END;

        -- other discount add NCB discount and driver discount
        TR_OTHER_PERC = TR_OTHER_PERC + NCB_DISCOUNT_DIFF + DRIVER_DISCOUNT_DIFF;

        if TR_OTHER_PERC > 60 then
            TR_OTHER_PERC = 60;
        end if;

        -- CR21
        NEW_TOTAL_AMT_EX_MV = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (TRF_DRIVER_BEHAVIOR / 100) * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100)) + NEW_PREMIUM_V5_OD;
        NEW_TOTAL_AMT_EX_MV_NO_DRIVER = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (BASE_TRF_DRIVER_BEHAVIOR / 100) * (TRF_CAR_YEAR / 100) * (TRF_SI / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100)) + NEW_PREMIUM_V5_OD;
        NEW_DRIVER_DISCOUNT = 0;
        NEW_DRIVER_BEHAVIOR_DISCOUNT = 
            case
                when NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV < 0
            then 0
                else NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV
            end;
        NEW_TOTAL_AMT_MV = cast(TR_MV01_AMT as numeric) + cast(TR_MV02_AMT as numeric) + cast(TR_MV03_AMT as numeric);
        RTN_PREM_AMT = cast(NEW_TOTAL_AMT_EX_MV as numeric) + cast(NEW_TOTAL_AMT_MV as numeric);
        NEW_FLEET_AMT = FLOOR((RTN_PREM_AMT - NEW_PREMIUM_V5_OD) * (TR_FLEET_PERC / 100));
        NEW_NCB_AMT = FLOOR(((RTN_PREM_AMT - NEW_PREMIUM_V5_OD) - NEW_FLEET_AMT) * (TR_NCB_PERC / 100));
        NEW_OTHER_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT - NEW_NCB_AMT) * (TR_OTHER_PERC / 100));
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_FLEET_AMT;
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_NCB_AMT;
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_OTHER_AMT;

        -- class 3 calculator
        elsif SYS_SUB_PRODUCT = '3' then

        -- new oic class 3 calculation CR21
        -- NCB discount
        if TR_NCB_PERC >= 50 then
            NCB_DISCOUNT_DIFF = TR_NCB_PERC - 40;
            TR_NCB_PERC = 40;
        end if;
    
        -- driver discount calculation CR21
        DRIVER_DISCOUNT_DIFF = 
			CASE 
				WHEN NOT IS_NEW_OIC THEN TRF_DRIVER_BEHAVIOR - TRF_DRIVER
				ELSE 0 
			END;

        -- other discount add NCB discount and driver discount
        TR_OTHER_PERC = TR_OTHER_PERC + NCB_DISCOUNT_DIFF + DRIVER_DISCOUNT_DIFF;

        if TR_OTHER_PERC > 60 then
            TR_OTHER_PERC = 60;
        end if;
            
        -- CR21
        NEW_TOTAL_AMT_EX_MV = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (TRF_DRIVER_BEHAVIOR / 100) * (TRF_CAR_YEAR / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
        NEW_TOTAL_AMT_EX_MV_NO_DRIVER = FLOOR(TR_BASE_PREMIUM * (TRF_USAGE / 100) * (TRF_CC / 100) * (BASE_TRF_DRIVER_BEHAVIOR / 100) * (TRF_CAR_YEAR / 100) * (TRF_CAR_GROUP / 100) * (TRF_TPBI / 100) * (TRF_TPPD / 100));
        NEW_DRIVER_DISCOUNT = 0;
        NEW_DRIVER_BEHAVIOR_DISCOUNT = 
            case
                when NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV < 0
            then 0
                else NEW_TOTAL_AMT_EX_MV_NO_DRIVER - NEW_TOTAL_AMT_EX_MV
            end;
        NEW_TOTAL_AMT_MV = cast(TR_MV01_AMT as numeric) + cast(TR_MV02_AMT as numeric) + cast(TR_MV03_AMT as numeric);
        RTN_PREM_AMT = cast(NEW_TOTAL_AMT_EX_MV as numeric) + cast(NEW_TOTAL_AMT_MV as numeric);
        NEW_FLEET_AMT = FLOOR(RTN_PREM_AMT * (TR_FLEET_PERC / 100));
        NEW_NCB_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT) * (TR_NCB_PERC / 100));
        NEW_OTHER_AMT = FLOOR((RTN_PREM_AMT - NEW_FLEET_AMT - NEW_NCB_AMT) * (TR_OTHER_PERC / 100));
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_FLEET_AMT;
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_NCB_AMT;
        RTN_PREM_AMT = RTN_PREM_AMT - NEW_OTHER_AMT;
    end if;

    LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - SYS_NCB_TIER : ' || SYS_NCB_TIER || ' - NEW_CAR_AGE : ' || coalesce(NEW_CAR_AGE, 0);
    LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - NEW_NAMEDAGE : ' || NEW_NAMEDAGE || ' - NEW_YEAR_DRIVER : ' || coalesce(NEW_YEAR_DRIVER, 0) || ' - TR_PAR1_YEAR : ' || coalesce(TR_PAR1_YEAR, 0) || ' - TR_PAR2_YEAR : ' || coalesce(TR_PAR2_YEAR, 0);
    LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - TRF_USAGE : ' || TRF_USAGE || ' - TRF_CC : ' || TRF_CC || ' - TRF_DRIVER : ' || TRF_DRIVER || ' - TRF_CAR_YEAR : ' || TRF_CAR_YEAR || ' - TRF_SI : ' || TRF_SI || ' - TRF_CAR_GROUP : ' || TRF_CAR_GROUP || ' - TRF_TPBI : ' || TRF_TPBI || ' - TRF_TPPD : ' || TRF_TPPD || ' - TRF_DRIVER_BEHAVIOR : ' || TRF_DRIVER_BEHAVIOR;
    LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - SI_TPPD_Limit : ' || TR_TPPD_LIMIT || ' - SI_TPBI_Limit : ' || TR_TPBI_LIMIT;
    LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - TR_FLEET_PERC : ' || TR_FLEET_PERC || ' - TR_NCB_PERC : ' || TR_NCB_PERC || ' - TR_OTHER_PERC : ' || TR_OTHER_PERC;
    LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - TR_BASE_PREMIUM : ' || coalesce(TR_BASE_PREMIUM, 0) || ' - TR_BASE_PREMIUM_V5 : ' || coalesce(TR_BASE_PREMIUM_V5, 0) || ' - (TR_SI_LIMIT+COALESCE(TR_ACCESS_LIMIT,0)) : ' || (coalesce(TR_SI_LIMIT, 0)+ coalesce(TR_ACCESS_LIMIT, 0)) || ' - TRF_SI_V5 : ' || coalesce(TRF_SI_V5, 0);
    LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - NEW_PREMIUM : ' || (coalesce(NEW_TOTAL_AMT_EX_MV, 0) - coalesce(NEW_PREMIUM_V5_OD, 0)) || ' - NEW_PREMIUM_V5_OD : ' || coalesce(NEW_PREMIUM_V5_OD, 0) || ' - NEW_TOTAL_AMT_EX_MV : ' || coalesce(NEW_TOTAL_AMT_EX_MV, 0) || ' - NEW_TOTAL_AMT_MV : ' || coalesce(NEW_TOTAL_AMT_MV, 0);
end if;

RTN_DUTY_AMT = CEIL(RTN_PREM_AMT * (TR_DUTY_PERC / 100));
RTN_VAT_AMT = ROUND((RTN_PREM_AMT + RTN_DUTY_AMT) * (TR_VAT_PERC / 100), 2);
RTN_TOTAL_AMT = RTN_PREM_AMT + RTN_DUTY_AMT + RTN_VAT_AMT;
LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - RTN_PREM_AMT : ' || coalesce(RTN_PREM_AMT, 0) || ' - RTN_DUTY_AMT : ' || coalesce(RTN_DUTY_AMT, 0);
LOG_TARIFF = coalesce(LOG_TARIFF, '') || ' - RTN_VAT_AMT : ' || coalesce(RTN_VAT_AMT, 0) || ' - RTN_TOTAL_AMT : ' || coalesce(RTN_TOTAL_AMT, 0);

insert
	into
	insurverse."log_tariff_renewal"("policy_no",
	"message")
values (RTN_POLICY_NO,
LOG_TARIFF);

-- new lead
if in_flag_lead = true then
    if IC_TOTAL is null then
        IC_TOTAL = 0;
    end if;

    -- get max lead no
    select
        "Lead_No"
    from
        insurverse."Lead_coverage_premium"
    order by
        "Lead_No" desc
    limit 1
    into
        RTN_LEAD_NO;

    if RTN_LEAD_NO is null then 
        RTN_LEAD_NO = 1;
    else 
        RTN_LEAD_NO = RTN_LEAD_NO + 1;
    end if;

	-- car price
	if SYS_SUB_PRODUCT = '1' then
		V_CAR_PRICE = TR_SI_LIMIT / 0.8;
	else 
        with param as (
            select 
                TR_CAR_BRAND::text as brand,
                TR_CAR_MODEL::text as model,
                TR_GROUP::text as car_group,
                NEW_CAR_CC::text as cc,
                (cast(TR_CAR_YEAR as INTEGER) + 1)::text as car_year,
                TR_SI_LIMIT::text as si
        )
        select 
            case
                when p.si::numeric / 0.8 > c.car_price then p.si::numeric / 0.8
                when 100000 > c.car_price then 100000
                else c.car_price
            end
        into V_TMP_PRICE
        from param p
        cross join lateral (
            select
                ipp."SI_1",
                (ipp."Year"::int - p.car_year::int) as year_diff,
                (ipp."SI_1" / 0.8) * POWER(0.9, (ipp."Year"::int - p.car_year::int)) as car_price
            from "Imp_Price_Premium" ipp
            where ipp.is_active = true
              and ipp."Type" = '1'
              and ipp."Brand" = p.brand
              and ipp."Model" = p.model
              and ipp."Group" = p.car_group
              and ipp."CC" = p.cc
            order by
                case when ipp."Year" = p.car_year then 0 else 1 end,
                ipp."Year"
            limit 1
        ) c;

        V_CAR_PRICE = coalesce(V_TMP_PRICE, 100000);
    end IF;

	V_CAR_PRICE = ceil(V_CAR_PRICE / 10000) * 10000;

    insert
        into
        insurverse."Lead_coverage_premium"
    (
        "Lead_No",
        "Brand",
        "Model",
        "Year",
        "Doors",
        "Seat",
        "Wg",
        "Group",
        "Usage",
        "Type",
        "BodyType",
        "GarageType",
        "NamedAge",
        "Sedan",
        "CC",
        "MinSI",
        "MaxSI",
        "Split",
        "SI_1",
        "SI_2",
        "SI_3",
        "SI_4",
        "SI_5",
        "SI_Ans",
        "Prem_OD_1",
        "Prem_OD_2",
        "Prem_OD_3",
        "Prem_OD_4",
        "Prem_OD_5",
        "OD_Ans",
        "OD_Amt",
        "Prem_FT_1",
        "Prem_FT_2",
        "Prem_FT_3",
        "Prem_FT_4",
        "Prem_FT_5",
        "FT_Ans",
        "FT_Amt",
        "SI_TPBI_1",
        "SI_TPBI_2",
        "SI_TPBI_3",
        "Prem_TPBI_1",
        "Prem_TPBI_2",
        "Prem_TPBI_3",
        "SI_TPBI_Ans",
        "SI_TPBI_Amt",
        "SI_TPPD_1",
        "SI_TPPD_2",
        "SI_TPPD_3",
        "Prem_TPPD_1",
        "Prem_TPPD_2",
        "Prem_TPPD_3",
        "SI_TPPD_Ans",
        "SI_TPPD_Amt",
        "SI_MV01_1",
        "SI_MV01_2",
        "SI_MV01_3",
        "Prem_MV01_1",
        "Prem_MV01_2",
        "Prem_MV01_3",
        "SI_MV01_Ans",
        "SI_MV01_Amt",
        "SI_MV02_1",
        "SI_MV02_2",
        "SI_MV02_3",
        "Prem_MV02_1",
        "Prem_MV02_2",
        "Prem_MV02_3",
        "SI_MV02_Ans",
        "SI_MV02_Amt",
        "SI_MV03_1",
        "SI_MV03_2",
        "SI_MV03_3",
        "Prem_MV03_1",
        "Prem_MV03_2",
        "Prem_MV03_3",
        "SI_MV03_Ans",
        "SI_MV03_Amt",
        "SI_Access_1",
        "SI_Access_2",
        "SI_Access_3",
        "Prem_Access_1",
        "Prem_Access_2",
        "Prem_Access_3",
        "SI_Access_Ans",
        "SI_Access_Amt",
        "Perm_Amt",
        "Duty_Amt",
        "Vat_Amt",
        "Total_Amt",
        "Fleet_Disc_perc",
        "NCB_Disc_perc",
        "Other_Disc_perc",
        "Total_Amt_exclude_mv",
        "Total_Amt_mv",
        "Email",
        "Mobile",
        "Flag_CCTV",
        "Flag_Driver",
        "Fleet_Disc_Amt",
        "NCB_Disc_Amt",
        "Other_Disc_Amt",
        "FirstName",
        "LastName",
        "Total_Disc_Amt",
        "Flag_Access",
        "CCTV",
        "Access_para_code",
        "YOB_Driver_1",
        "YOB_Driver_2",
        "Basic_Premium",
        "SI_Limit",
        "SI_TPBI_Limit",
        "SI_TPPD_Limit",
        "SI_MV01_Limit",
        "SI_MV02_Limit",
        "SI_MV03_Limit",
        "SI_Access_Limit",
        "Driver_Discount",
        "premium_v5_od",
        "basic_premium_v5",
        "ref_policy_no",
        "Flag_Car_Act",
        "Prem_ACT",
        "renewal_mv_startdate",
        "renewal_mv_enddate",
        "renewal_mc_startdate",
        "renewal_mc_enddate",
        "cal_basic_renewal",
		-- CR21
		"oic_version",
		"prem_version",
		"par_first_name_1",
		"par_first_name_2",
		"par_first_name_3",
		"par_first_name_4",
		"par_first_name_5",
		"par_last_name_1",
		"par_last_name_2",
		"par_last_name_3",
		"par_last_name_4",
		"par_last_name_5",
		"par_prefix_name_1",
		"par_prefix_name_2",
		"par_prefix_name_3",
		"par_prefix_name_4",
		"par_prefix_name_5",
		"par_occupation_1",
		"par_occupation_2",
		"par_occupation_3",
		"par_occupation_4",
		"par_occupation_5",
		"par_occupation_code_1",
		"par_occupation_code_2",
		"par_occupation_code_3",
		"par_occupation_code_4",
		"par_occupation_code_5",
        "par_citizen_id_1",
        "par_citizen_id_2",
        "par_citizen_id_3",
        "par_citizen_id_4",
        "par_citizen_id_5",
        "par_driver_license_no_1",
        "par_driver_license_no_2",
        "par_driver_license_no_3",
        "par_driver_license_no_4",
        "par_driver_license_no_5",
        "driver_behavior_consent_1",
        "driver_behavior_consent_2",
        "driver_behavior_consent_3",
        "driver_behavior_consent_4",
        "driver_behavior_consent_5",
        "driver_behavior_cal",
        "driver_behavior",
        "sc_premium_amt",
        "driver_behavior_1",
        "driver_behavior_2",
        "driver_behavior_3",
        "driver_behavior_4",
        "driver_behavior_5",
		"car_price",
		"car_price_date"
    )
    select
        RTN_LEAD_NO,
        "pc"."Brand",
        "pc"."Model",
        "pc"."Year",
        "pc"."Doors",
        "pc"."Seat",
        "pc"."Wg",
        "pc"."Group",
        "pc"."Usage",
        "pc"."Type",
        "pc"."BodyType",
        "pc"."GarageType",
        NEW_NAMEDAGE,
        "pc"."Sedan",
        NEW_CAR_CC,
        "pc"."MinSI",
        "pc"."MaxSI",
        "pc"."Split",
        "pc"."SI_1",
        "pc"."SI_2",
        "pc"."SI_3",
        "pc"."SI_4",
        "pc"."SI_5",
        "pc"."SI_Ans",
        "pc"."Prem_OD_1",
        "pc"."Prem_OD_2",
        "pc"."Prem_OD_3",
        "pc"."Prem_OD_4",
        "pc"."Prem_OD_5",
        "pc"."OD_Ans",
        "pc"."OD_Amt",
        "pc"."Prem_FT_1",
        "pc"."Prem_FT_2",
        "pc"."Prem_FT_3",
        "pc"."Prem_FT_4",
        "pc"."Prem_FT_5",
        "pc"."FT_Ans",
        "pc"."FT_Amt",
        "pc"."SI_TPBI_1",
        "pc"."SI_TPBI_2",
        "pc"."SI_TPBI_3",
        "pc"."Prem_TPBI_1",
        "pc"."Prem_TPBI_2",
        "pc"."Prem_TPBI_3",
        "pc"."SI_TPBI_Ans",
        "pc"."SI_TPBI_Amt",
        "pc"."SI_TPPD_1",
        "pc"."SI_TPPD_2",
        "pc"."SI_TPPD_3",
        "pc"."Prem_TPPD_1",
        "pc"."Prem_TPPD_2",
        "pc"."Prem_TPPD_3",
        "pc"."SI_TPPD_Ans",
        "pc"."SI_TPPD_Amt",
        "pc"."SI_MV01_1",
        "pc"."SI_MV01_2",
        "pc"."SI_MV01_3",
        "pc"."Prem_MV01_1",
        "pc"."Prem_MV01_2",
        "pc"."Prem_MV01_3",
        "pc"."SI_MV01_Ans",
        "pc"."SI_MV01_Amt",
        "pc"."SI_MV02_1",
        "pc"."SI_MV02_2",
        "pc"."SI_MV02_3",
        "pc"."Prem_MV02_1",
        "pc"."Prem_MV02_2",
        "pc"."Prem_MV02_3",
        "pc"."SI_MV02_Ans",
        "pc"."SI_MV02_Amt",
        "pc"."SI_MV03_1",
        "pc"."SI_MV03_2",
        "pc"."SI_MV03_3",
        "pc"."Prem_MV03_1",
        "pc"."Prem_MV03_2",
        "pc"."Prem_MV03_3",
        "pc"."SI_MV03_Ans",
        "pc"."SI_MV03_Amt",
        "pc"."SI_Access_1",
        "pc"."SI_Access_2",
        "pc"."SI_Access_3",
        "pc"."Prem_Access_1",
        "pc"."Prem_Access_2",
        "pc"."Prem_Access_3",
        "pc"."SI_Access_Ans",
        "pc"."SI_Access_Amt",
        RTN_PREM_AMT,
        RTN_DUTY_AMT,
        RTN_VAT_AMT,
        RTN_TOTAL_AMT,
        TR_FLEET_PERC,
        TR_NCB_PERC,
        TR_OTHER_PERC,
        NEW_TOTAL_AMT_EX_MV,
        NEW_TOTAL_AMT_MV,
        "ph"."email",
        "suser"."mobile",
        "pc"."Flag_CCTV",
        "pc"."Flag_Driver",
        NEW_FLEET_AMT,
        NEW_NCB_AMT,
        NEW_OTHER_AMT,
        "ph"."Owner_first_name",
        "ph"."Owner_last_name",
        coalesce(NEW_FLEET_AMT, 0)+ coalesce(NEW_NCB_AMT, 0)+ coalesce(NEW_OTHER_AMT, 0),
        "pc"."Flag_Access",
        "pc"."CCTV",
        "pc"."Access_para_code",
        "pc"."YOB_Driver_1",
        "pc"."YOB_Driver_2",
        TR_BASE_PREMIUM,
        TR_SI_LIMIT,
        "pc"."SI_TPBI_Limit",
        "pc"."SI_TPPD_Limit",
        "pc"."SI_MV01_Limit",
        "pc"."SI_MV02_Limit",
        "pc"."SI_MV03_Limit",
        "pc"."SI_Access_Limit",
        NEW_DRIVER_DISCOUNT,
        NEW_PREMIUM_V5_OD,
        TR_BASE_PREMIUM_V5,
        SYS_POLICY_NO,
        TR_FLAG_ACT,
        TR_PREM_ACT,
        SYS_MV_STARTDATE,
        SYS_MV_ENDDATE,
        SYS_MC_STARTDATE,
        SYS_MC_ENDDATE,
        true,
		-- CR21
		COALESCE(OIC_VERSION_VARIABLE, CURRENT_OIC_VERSION),
		COALESCE(PREM_VERSION_VARIABLE, CURRENT_PREM_VERSION),
		TR_FIRST_NAME_1,
		TR_FIRST_NAME_2,
		TR_FIRST_NAME_3,
		TR_FIRST_NAME_4,
		TR_FIRST_NAME_5,
		TR_LAST_NAME_1,
		TR_LAST_NAME_2,
		TR_LAST_NAME_3,
		TR_LAST_NAME_4,
		TR_LAST_NAME_5,
		TR_PREFIX_NAME_1, 
		TR_PREFIX_NAME_2,
		TR_PREFIX_NAME_3,
		TR_PREFIX_NAME_4, 
		TR_PREFIX_NAME_5, 
		TR_OCCUPATION_1, 
		TR_OCCUPATION_2, 
		TR_OCCUPATION_3, 
		TR_OCCUPATION_4, 
		TR_OCCUPATION_5, 
		TR_OCCUPATION_CODE_1, 
		TR_OCCUPATION_CODE_2, 
		TR_OCCUPATION_CODE_3, 
		TR_OCCUPATION_CODE_4, 
		TR_OCCUPATION_CODE_5, 
        TR_DRIVER_CITIZEN_1,
        TR_DRIVER_CITIZEN_2,
        TR_DRIVER_CITIZEN_3,
        TR_DRIVER_CITIZEN_4,
        TR_DRIVER_CITIZEN_5,
        TR_DRIVER_LICENSE_1,
        TR_DRIVER_LICENSE_2,
        TR_DRIVER_LICENSE_3,
        TR_DRIVER_LICENSE_4,
        TR_DRIVER_LICENSE_5,
        COALESCE(TR_DRIVER_CONSENT_1, CASE WHEN TR_DRIVER_CITIZEN_1 IS NOT NULL THEN false ELSE null END),
        COALESCE(TR_DRIVER_CONSENT_2, CASE WHEN TR_DRIVER_CITIZEN_2 IS NOT NULL THEN false ELSE null END),
        COALESCE(TR_DRIVER_CONSENT_3, CASE WHEN TR_DRIVER_CITIZEN_3 IS NOT NULL THEN false ELSE null END),
        COALESCE(TR_DRIVER_CONSENT_4, CASE WHEN TR_DRIVER_CITIZEN_4 IS NOT NULL THEN false ELSE null END),
        COALESCE(TR_DRIVER_CONSENT_5, CASE WHEN TR_DRIVER_CITIZEN_5 IS NOT NULL THEN false ELSE null END),
        TR_DRIVER_BEHAVIOR_CAL,
        TR_DRIVER_BEHAVIOR_CAL,
        TR_MV31_AMT,
        TR_DRIVER_BEHAVIOR_1,
        TR_DRIVER_BEHAVIOR_2,
        TR_DRIVER_BEHAVIOR_3,
        TR_DRIVER_BEHAVIOR_4,
        TR_DRIVER_BEHAVIOR_5,
		V_CAR_PRICE,
		now()
    from
        insurverse."Policy_Header" as "ph"
        inner join insurverse."Policy_coverage_premium" as "pc"
            on "ph"."Policy_No" = "pc"."Policy_No" and "ph"."Policy_No" = "in_policy_no"
        inner join insurverse."sec_user" as "suser"
            on "ph"."email" = "suser"."email"
        left outer join insurverse."Policy_Header" as "new_ph"
            on "new_ph"."ref_policy_no" = "ph"."Policy_No"
    where
        "new_ph"."Policy_No" is null;
end if;

-- insert noti renewal mv
if in_flag_noti = true then
    insert
        into
        insurverse.log_noti_renewal
    (
    policy_no,
        premium_amt,
        duty_amt,
        vat_amt,
        total_amt,
        is_active,
        is_renewal,
        remark
    )
    values (
    SYS_POLICY_NO,
    RTN_PREM_AMT,
    RTN_DUTY_AMT,
    RTN_VAT_AMT,
    RTN_TOTAL_AMT,
    true,
    true,
    SYS_MC_NO
    )
    returning "id"
    into
        RTN_LOG_NOTI_ID;
end if;

if SYS_TEST_RUN = true then
    RTN_MSG = coalesce(LOG_TARIFF, '');
end if;

return QUERY
select
	RTN_SUCCESS,
	RTN_NCB_TIER,
	RTN_ERROR_CODE,
	RTN_MSG,
	RTN_POLICY_NO,
	RTN_PREM_AMT,
	RTN_DUTY_AMT,
	RTN_VAT_AMT,
	RTN_TOTAL_AMT,
	RTN_IS_COMPULSORY,
	RTN_TOGETHER_POLICY,
	RTN_LEAD_NO,
	RTN_LOG_NOTI_ID,
	RTN_JSON_BODY,
	RTN_PREM_ACT;
end
$function$
