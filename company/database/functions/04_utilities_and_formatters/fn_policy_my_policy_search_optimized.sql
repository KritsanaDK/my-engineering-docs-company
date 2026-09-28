-- =============================================================================
-- Function: insurverse.fn_policy_my_policy_search_optimized
-- OID: 18658
-- Identity Arguments: (in_email text, in_partner_code text, in_policy_no text)
-- Returns: TABLE("Brand" character varying, "Model" character varying, "Year" character varying, "Car_license_no" text, "Type" character varying, "SI" integer, "Owner_first_name" text, "Owner_first_name_en" text, "Owner_last_name" text, "Owner_last_name_en" text, "Policy_No" text, "Policy_Ta_No" text, "Car_Act_No" text, "Policy_Startdate" text, "Policy_Startdate_en" text, "Policy_Enddate" text, "Policy_Enddate_en" text, policy_startdate_sort timestamp without time zone, "Car_license_provice" text, "Policy_url_copy_ref" text, "Receipt_url_copy_ref" text, policy_date text, policy_date_en text, "Car_Inspect_Status" text, "Lead_No" integer, "Car_Act_Lead_No" integer, priority integer, policy_status text, payment_date text, car_serial_no text, car_license_type text, car_color text, car_cc text, car_seat integer, car_weight integer, owner_citizen_id text, "Owner_birth_date" text, "Owner_birth_date_en" text, owner_prefix_name text, owner_prefix_name_en text, owner_address text, owner_address_en text, owner_subdistrict text, owner_subdistrict_en text, owner_district text, owner_district_en text, owner_province text, owner_province_en text, owner_zipcode text, user_email text, user_mobile text, par_1_prefix_name text, par_1_first_name text, par_1_last_name text, par_1_birth_date text, par_1_driver_license text, par_1_citizen text, par_2_prefix_name text, par_2_first_name text, par_2_last_name text, par_2_birth_date text, par_2_driver_license text, par_2_citizen text, bene_type text, bene_first_name text, bene_last_name text, bene_ta_detail text, deli_addr_1 text, deli_subdistrict text, deli_district text, deli_province text, deli_zipcode text, garage_type character varying, si_limit numeric, si_access_limit numeric, si_tppd_limit numeric, si_tpbi_limit numeric, si_mv01_limit numeric, si_mv02_limit numeric, si_mv03_limit numeric, car_comp_code character varying, coverinjury integer, coverdeath integer, coveracc integer, "Access_para_code" character varying, endorsement_list text, package_name text, ta_coverage_list text, ta_country_name_th text, ta_country_name_en text, owner_card_type text, owner_email text, owner_mobile text, deli_flag text, "Policy_Pa_No" text, bene_pa_detail text, bene_title text, pa_coverage_list text, policy_directory text, tax_deductions_url_ref text, endorse_last_status text, tax_deductions boolean, owner_subdistrict_id integer, owner_district_id integer, owner_province_id integer, deli_subdistrict_id integer, deli_district_id integer, deli_province_id integer, tax_deductions_date_th text, tax_deductions_date_en text, "Policy_Home_No" text, home_coverage text, bene_home_detail text, "Policy_url_ref" text, "Receipt_url_ref" text, tax_deductions_url_copy_ref text, claim_status_flag boolean, motor_detail text, renewal_detail text, ta_package_list text, ta_policy_detail text, partner_code text, partner_detail text, par_3_prefix_name text, par_3_first_name text, par_3_last_name text, par_3_birth_date text, par_3_driver_license text, par_3_citizen text, par_4_prefix_name text, par_4_first_name text, par_4_last_name text, par_4_birth_date text, par_4_driver_license text, par_4_citizen text, par_5_prefix_name text, par_5_first_name text, par_5_last_name text, par_5_birth_date text, par_5_driver_license text, par_5_citizen text, owner_occupation character varying, owner_occupation_code text, prem_version integer, oic_version text, bene_occupation text, bene_occupation_code text, par_1_occupation character varying, par_1_driver_behavior integer, par_2_occupation character varying, par_2_driver_behavior integer, par_3_occupation character varying, par_3_driver_behavior integer, par_4_occupation character varying, par_4_driver_behavior integer, par_5_occupation character varying, par_1_occupation_code character varying, par_2_occupation_code character varying, par_3_occupation_code character varying, par_4_occupation_code character varying, par_5_occupation_code character varying, par_5_driver_behavior integer, driver_behavior_consent_1 boolean, driver_behavior_consent_2 boolean, driver_behavior_consent_3 boolean, driver_behavior_consent_4 boolean, driver_behavior_consent_5 boolean, customer_id text, hp integer, "engineType" text, par_1_driver_license_category text, par_2_driver_license_category text, par_3_driver_license_category text, par_4_driver_license_category text, par_5_driver_license_category text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_my_policy_search_optimized(in_email text, in_partner_code text, in_policy_no text)
 RETURNS TABLE("Brand" character varying, "Model" character varying, "Year" character varying, "Car_license_no" text, "Type" character varying, "SI" integer, "Owner_first_name" text, "Owner_first_name_en" text, "Owner_last_name" text, "Owner_last_name_en" text, "Policy_No" text, "Policy_Ta_No" text, "Car_Act_No" text, "Policy_Startdate" text, "Policy_Startdate_en" text, "Policy_Enddate" text, "Policy_Enddate_en" text, policy_startdate_sort timestamp without time zone, "Car_license_provice" text, "Policy_url_copy_ref" text, "Receipt_url_copy_ref" text, policy_date text, policy_date_en text, "Car_Inspect_Status" text, "Lead_No" integer, "Car_Act_Lead_No" integer, priority integer, policy_status text, payment_date text, car_serial_no text, car_license_type text, car_color text, car_cc text, car_seat integer, car_weight integer, owner_citizen_id text, "Owner_birth_date" text, "Owner_birth_date_en" text, owner_prefix_name text, owner_prefix_name_en text, owner_address text, owner_address_en text, owner_subdistrict text, owner_subdistrict_en text, owner_district text, owner_district_en text, owner_province text, owner_province_en text, owner_zipcode text, user_email text, user_mobile text, par_1_prefix_name text, par_1_first_name text, par_1_last_name text, par_1_birth_date text, par_1_driver_license text, par_1_citizen text, par_2_prefix_name text, par_2_first_name text, par_2_last_name text, par_2_birth_date text, par_2_driver_license text, par_2_citizen text, bene_type text, bene_first_name text, bene_last_name text, bene_ta_detail text, deli_addr_1 text, deli_subdistrict text, deli_district text, deli_province text, deli_zipcode text, garage_type character varying, si_limit numeric, si_access_limit numeric, si_tppd_limit numeric, si_tpbi_limit numeric, si_mv01_limit numeric, si_mv02_limit numeric, si_mv03_limit numeric, car_comp_code character varying, coverinjury integer, coverdeath integer, coveracc integer, "Access_para_code" character varying, endorsement_list text, package_name text, ta_coverage_list text, ta_country_name_th text, ta_country_name_en text, owner_card_type text, owner_email text, owner_mobile text, deli_flag text, "Policy_Pa_No" text, bene_pa_detail text, bene_title text, pa_coverage_list text, policy_directory text, tax_deductions_url_ref text, endorse_last_status text, tax_deductions boolean, owner_subdistrict_id integer, owner_district_id integer, owner_province_id integer, deli_subdistrict_id integer, deli_district_id integer, deli_province_id integer, tax_deductions_date_th text, tax_deductions_date_en text, "Policy_Home_No" text, home_coverage text, bene_home_detail text, "Policy_url_ref" text, "Receipt_url_ref" text, tax_deductions_url_copy_ref text, claim_status_flag boolean, motor_detail text, renewal_detail text, ta_package_list text, ta_policy_detail text, partner_code text, partner_detail text, par_3_prefix_name text, par_3_first_name text, par_3_last_name text, par_3_birth_date text, par_3_driver_license text, par_3_citizen text, par_4_prefix_name text, par_4_first_name text, par_4_last_name text, par_4_birth_date text, par_4_driver_license text, par_4_citizen text, par_5_prefix_name text, par_5_first_name text, par_5_last_name text, par_5_birth_date text, par_5_driver_license text, par_5_citizen text, owner_occupation character varying, owner_occupation_code text, prem_version integer, oic_version text, bene_occupation text, bene_occupation_code text, par_1_occupation character varying, par_1_driver_behavior integer, par_2_occupation character varying, par_2_driver_behavior integer, par_3_occupation character varying, par_3_driver_behavior integer, par_4_occupation character varying, par_4_driver_behavior integer, par_5_occupation character varying, par_1_occupation_code character varying, par_2_occupation_code character varying, par_3_occupation_code character varying, par_4_occupation_code character varying, par_5_occupation_code character varying, par_5_driver_behavior integer, driver_behavior_consent_1 boolean, driver_behavior_consent_2 boolean, driver_behavior_consent_3 boolean, driver_behavior_consent_4 boolean, driver_behavior_consent_5 boolean, customer_id text, hp integer, "engineType" text, par_1_driver_license_category text, par_2_driver_license_category text, par_3_driver_license_category text, par_4_driver_license_category text, par_5_driver_license_category text)
 LANGUAGE plpgsql
AS $function$
begin
    return QUERY
    with set_para as (
select
    in_email as "email",
    in_policy_no as "in_policy_no",
    in_partner_code as "in_partner_code" 
    ),
    
    user_motor_policies as (
select
    *
from
    insurverse."Policy_Header"
where
    email = (
    select
        email
    from
        set_para)
    ),
    user_act_policies as (
select
    *
from
    insurverse."Policy_Car_Act_Discount_Premium"
where
    email = (
    select
        email
    from
        set_para)
    ),
    user_ta_policies as (
select
    *
from
    insurverse.policy_ta_premium
where
    email = (
    select
        email
    from
        set_para)
    ),
    user_pa_policies as (
select
    *
from
    insurverse.policy_pa_premium
where
    email = (
    select
        email
    from
        set_para)
    ),
    user_home_policies as (
select
    *
from
    insurverse.policy_home_premium
where
    email = (
    select
        email
    from
        set_para)
    ),
    
    converted_leads as (
select
    "prem"."Lead_No"::text
from
    insurverse."Policy_coverage_premium" as "prem"
inner join insurverse."Policy_Header" as "policy" 
            on
    "prem"."Policy_No" = "policy"."Policy_No"
where
    "policy"."email" = (
    select
        email
    from
        set_para)
    and "prem"."Lead_No" is not null
union
-- Use UNION to combine and de-duplicate
select
    "policy"."Car_Act_Lead_No"::text
from
    insurverse."Policy_Car_Act_Discount_Premium" as "policy"
where
    "policy"."Car_Act_Lead_No" is not null
    and "policy"."email" = (
    select
        email
    from
        set_para)
    ),
        
    act_renewal_with_mv as (
-- This will return Policy No
select
    distinct lcp.ref_policy_no
from
    insurverse."Lead_coverage_premium" lcp
where
    UPPER(lcp."Flag_Car_Act") = 'Y'
        and UPPER(lcp."Payment_status") = 'SUCCESS'
            and lcp.ref_policy_no in (
            select
                uap."Policy_No"
            from
                user_act_policies as uap
            where
                uap."Policy_No" is not null)
    ),

    motor_renewal_with_mv as (
select
    distinct lcp.ref_policy_no
from
    insurverse."Lead_coverage_premium" lcp
where
    UPPER(lcp."Payment_status") = 'SUCCESS'
        and lcp.ref_policy_no in (
        select
            ump."Policy_No"
        from
            user_motor_policies as ump)
    ),
    
    latest_act_notifications as (
select
    policy_key,
    id,
    create_at,
    total_amt,
    is_renewal
from
    (
    select
        uap."Car_Act_No" as policy_key,
        noti.id,
        noti.create_at,
        noti.total_amt,
        noti.is_renewal,
        row_number() over (
                    partition by uap."Car_Act_No"
    order by
        noti.id desc
                ) as rn
    from
        insurverse.log_noti_renewal as noti
    join user_act_policies as uap 
            on
        (noti.policy_no = uap."Car_Act_No"
            or noti.remark = uap."Car_Act_No")
        ) ranked
where
    rn = 1
    ),
    
    latest_mv_notifications as (
select
    policy_no as policy_key,
    id,
    create_at,
    total_amt,
    is_renewal
from
    (
    select
        policy_no,
        id,
        create_at,
        total_amt,
        is_renewal,
        row_number() over (partition by policy_no
    order by
        id desc) as rn
    from
        insurverse.log_noti_renewal
    where
        policy_no in (
        select
            ump."Policy_No"
        from
            user_motor_policies as ump)
        ) ranked
where
    rn = 1
    ),
    
    car_act_params as (
select
    MAX(case when "sub_dom_code" = 'Car_act_coverage' and "para_code" = 'coverinjury' then cast("para_value" as DECIMAL(16, 2)) end) as "coverinjury",
    MAX(case when "sub_dom_code" = 'Car_act_coverage' and "para_code" = 'coverdeath' then cast("para_value" as DECIMAL(16, 2)) end) as "coverdeath",
    MAX(case when "sub_dom_code" = 'Car_act_coverage' and "para_code" = 'coveracc' then cast("para_value" as DECIMAL(16, 2)) end) as "coveracc",
    MAX(case when "sub_dom_code" = 'Car_act_coverage_van' and "para_code" = 'coverinjury' then cast("para_value" as DECIMAL(16, 2)) end) as "coverinjury_van",
    MAX(case when "sub_dom_code" = 'Car_act_coverage_van' and "para_code" = 'coverdeath' then cast("para_value" as DECIMAL(16, 2)) end) as "coverdeath_van",
    MAX(case when "sub_dom_code" = 'Car_act_coverage_van' and "para_code" = 'coveracc' then cast("para_value" as DECIMAL(16, 2)) end) as "coveracc_van"
from
    insurverse."sys_param"
where
    "dom_code" = 'Policy'
    and "sub_dom_code" in ('Car_act_coverage', 'Car_act_coverage_van')
    ),
    
    mv_renewal_details_json as (
select
    p_main."Policy_No",
    case
        when noti.is_renewal = true
            and renewed_policy."Policy_No" is null
            and new_lead.ref_policy_no is null
		then true
            else false
        end as noti_renewal_flag,
        json_build_object(
                'noti_renewal_flag',
                case
                    when noti.is_renewal = true
                         and renewed_policy."Policy_No" is null
                         and new_lead.ref_policy_no is null
                    then true else false
                end,
                'expire_day_count', cast(p_main."Policy_Enddate" as DATE) - cast(now() at TIME zone 'Asia/Bangkok' as DATE) + 1,
                'last_noti_date_en', noti.create_at + interval '7 HOUR',
                'last_noti_date_th', insurverse.fn_display_buddha_date(noti.create_at + interval '7 HOUR'),
                'total_amt', noti.total_amt,
                'is_renewed_flag', (renewed_policy."Policy_No" is not null),
                'renewed_policy_no', renewed_policy."Policy_No",
                'can_renewal_flag', noti.is_renewal,
                'ref_policy_no', p_main.ref_policy_no,
                'Brand', mv."Brand",
                'Model', mv."Model",
                'Year', mv."Year",  
                'Doors', mv."Doors",
				'CC',
			        case 
			            when cast(nullif(regexp_replace(mv."CC", '\D', '', 'g'), '') as int) <= 2000 
			            then '<=2000'
			            else '>2000'
			        end
            )::text as renewal_detail
    from
        user_motor_policies p_main
    left join insurverse."Policy_coverage_premium" mv on
        p_main."Policy_No" = mv."Policy_No"
    left join motor_renewal_with_mv new_lead on
        p_main."Policy_No" = new_lead.ref_policy_no
    left join latest_mv_notifications noti on
        p_main."Policy_No" = noti.policy_key
    left join user_motor_policies renewed_policy on
        renewed_policy.ref_policy_no = p_main."Policy_No"
    ),
    
    mc_renewal_details_json as (
select
    pa."Car_Act_No" as "car_act_no",
    json_build_object(
                'noti_renewal_flag',
                case
                    when noti.is_renewal = true -- A renewal notification was sent
                         and renewed_pa."Car_Act_No" is null -- AND it was NOT renewed via another ACT policy
                         and new_lead."ref_policy_no" is null -- AND it was NOT renewed via a new Lead
                    then true else false
                end,
                'expire_day_count', (pa."End_date" + interval '7 HOUR')::DATE - (now() + interval '7 HOUR')::DATE + 1,

                -- Override Value when policy was canceled
                'last_noti_date_en', noti.create_at + interval '7 HOUR',
                'last_noti_date_th', insurverse.fn_display_buddha_date(noti.create_at + interval '7 HOUR'),
                'total_amt', noti.total_amt,

                'is_renewed_flag', (renewed_pa."Car_Act_No" is not null),
                'renewed_policy_no', renewed_pa."Car_Act_No",
                'can_renewal_flag', noti.is_renewal,
                'ref_policy_no', pa."ref_policy_no",
                'Brand', mv."Brand", 
				'Model', mv."Model", 
				'Year', mv."Year", 
				'Doors', mv."Doors",
				'CC',
			        case 
			            when cast(nullif(regexp_replace(mv."CC", '\D', '', 'g'), '') as int) <= 2000 
			            then '<=2000'
			            else '>2000'
			        end
            )::text as renewal_detail
from
    user_act_policies pa
left join insurverse."Policy_coverage_premium" mv on
    pa."Policy_No" = mv."Policy_No"
left join act_renewal_with_mv new_lead on
    pa."Policy_No" = new_lead."ref_policy_no"
left join latest_act_notifications noti on
    pa."Car_Act_No" = noti.policy_key
left join user_act_policies as renewed_pa on
    renewed_pa."ref_policy_no" = pa."Car_Act_No"
    ),
    
    endorsement_details_json as (
        with endorsement_rows as (
select
    coalesce(e."Policy_No", e."Car_Act_No") as policy_key,
    e."SF_Policy_id" as endorse_no,
    docs.priority,
    insurverse.fn_display_buddha_date(e."create_at" + interval '7 HOUR') as endorse_date_th,
    TO_CHAR(e."create_at" + interval '7 HOUR', 'dd/mm/yyyy') as endorse_date_en,
    docs.endorse_doc_type,
    e."doc_type" as endorse_policy_type,
    docs.endorse_policy_name,
    docs.endorse_policy_name_full,
    docs.endorse_doc_url,
    docs.endorse_doc_url_copy
from
    insurverse."Policy_endorse_detail" as e
join lateral (
    select
        1 as priority,
        'endorse' as endorse_doc_type,
        name.para_name,
        name.para_desc,
        e."Policy_url_ref",
        e."Policy_url_copy_ref"
    from
        insurverse.sys_param as name
    where
        name.dom_code = 'Policy'
        and name.sub_dom_code = 'doc_type'
        and e.doc_type = name.para_code
        and e."Policy_url_ref" is not null
union all
    select
        2,
        -- This is the ORIGINAL logic
                        case
            when e."Receipt_url_copy_ref" is not null
            and e."Receipt_url_copy_ref" != '' then 're_receipt'
            when e."debt_increase_url_copy_ref" is not null
            and e."debt_increase_url_copy_ref" != '' then 'debitnote'
            when e."debt_decrease_url_copy_ref" is not null
            and e."debt_decrease_url_copy_ref" != '' then 'createnote'
            else 'no_document'
        end,
        case
            when e."Receipt_url_copy_ref" is not null
            and e."Receipt_url_copy_ref" != '' then 'ใบเสร็จ (ฉบับแก้ไข)'
            when e."debt_increase_url_copy_ref" is not null
            and e."debt_increase_url_copy_ref" != '' then 'ใบเพิ่มหนี้'
            when e."debt_decrease_url_copy_ref" is not null
            and e."debt_decrease_url_copy_ref" != '' then 'ใบลดหนี้'
            else 'ไม่พบเอกสาร'
        end,
        case
            when e."Receipt_url_copy_ref" is not null
            and e."Receipt_url_copy_ref" != '' then 'ใบเสร็จ (ฉบับแก้ไข)'
            when e."debt_increase_url_copy_ref" is not null
            and e."debt_increase_url_copy_ref" != '' then 'ใบเพิ่มหนี้ (Debit note)'
            when e."debt_decrease_url_copy_ref" is not null
            and e."debt_decrease_url_copy_ref" != '' then 'ใบลดหนี้ (Credit note)'
            else 'ไม่พบเอกสาร'
        end,
        case
            when e."Receipt_url_ref" is not null
            and e."Receipt_url_ref" != '' then e."Receipt_url_ref"
            when e."debt_increase_url_ref" is not null
            and e."debt_increase_url_ref" != '' then e."debt_increase_url_ref"
            else e."debt_decrease_url_ref"
        end,
        case
            when e."Receipt_url_copy_ref" is not null
            and e."Receipt_url_copy_ref" != '' then e."Receipt_url_copy_ref"
            when e."debt_increase_url_copy_ref" is not null
            and e."debt_increase_url_copy_ref" != '' then e."debt_increase_url_copy_ref"
            else e."debt_decrease_url_copy_ref"
        end
        -- This is my previous fix (filtering on _ref columns to match original)
    where
        coalesce(e."Receipt_url_ref", e."debt_increase_url_ref", e."debt_decrease_url_ref") is not null
            and coalesce(e."Receipt_url_ref", e."debt_increase_url_ref", e."debt_decrease_url_ref") <> ''
                    ) as docs (priority,
    endorse_doc_type,
    endorse_policy_name,
    endorse_policy_name_full,
    endorse_doc_url,
    endorse_doc_url_copy) on
    true
where
    coalesce(e."Policy_No", e."Car_Act_No") in (
    select
        ump."Policy_No"
    from
        user_motor_policies as ump
union
    select
        uap."Car_Act_No"
    from
        user_act_policies as uap
            )
        )
select
    sub.policy_key,
    -- This order by endorse from latest first
    json_agg(sub.item order by sub.endorse_no desc, sub.priority asc)::text as endorsement_list
from
    (
    -- To Produce the same result with the \n between endorsement we have to impliment this way.
    select
        (
        select
            r
        from
            (
            select
                er.endorse_no,
                er.priority,
                er.endorse_date_th,
                er.endorse_date_en,
                er.endorse_doc_type,
                er.endorse_policy_type,
                er.endorse_policy_name,
                er.endorse_policy_name_full,
                er.endorse_doc_url,
                er.endorse_doc_url_copy) r) as item,
        er.policy_key,
        er.endorse_no,
        er.priority
    from
        endorsement_rows as er
        ) sub
group by
    policy_key
    ),

    endorse_last_status_mv_json as (
select
    json_req_cleaned.policy_no as policy_key,
    cast(json_agg(to_json(json_req_cleaned)) as TEXT) as endorse_last_status
from
    (
    -- hides the 'rn' columns from to_json().
    select
        j.create_at,
        j."type",
        j.policy_type,
        j.policy_no,
        j.car_act_no,
        j."ownerPrefixName",
        j."ownerFirstName",
        j."ownerLastName",
        j."ownerAddress",
        j."ownerProvinceId",
        j."ownerProvince",
        j."ownerDistrictId",
        j."ownerDistrict",
        j."ownerSubdistrictId",
        j."ownerSubdistrict",
        j."ownerZipcode",
        j."carColor",
        j."carColorID",
        j."carLicenseNo",
        j."carLicenseProvice",
        j."startDate",
        j."endDate",
        j."carSerialNo",
        j."effectiveDate",
        j."ownerBirthdate",
        j."ownerCardId",
        j."salesforceID",
        j.salesforce_id_at,
        j.request_body,
        j.appr_status,
        j.appr_comment,
        j.callback_at
    from
        (
        select
            "log_req".create_at,
            "log_req"."type"::json as "type",
            "log_req"."policy_type",
            "log_req".policy_no,
            "log_req"."car_act_no",
            "log_req"."owner_prefix_name" as "ownerPrefixName",
            "log_req"."owner_first_name" as "ownerFirstName",
            "log_req"."owner_last_name" as "ownerLastName",
            "log_req"."owner_address" as "ownerAddress",
            "log_req"."owner_province_id" as "ownerProvinceId",
            "log_req"."owner_province_name" as "ownerProvince",
            "log_req"."owner_district_id" as "ownerDistrictId",
            "log_req"."owner_district_name" as "ownerDistrict",
            "log_req"."owner_subdistrict_id" as "ownerSubdistrictId",
            "log_req"."owner_subdistrict_name" as "ownerSubdistrict",
            "log_req"."owner_zipcode" as "ownerZipcode",
            "log_req"."car_color" as "carColor",
            "log_req"."car_color_id" as "carColorID",
            "log_req"."car_license_no" as "carLicenseNo",
            "log_req"."car_license_province" as "carLicenseProvice",
            "log_req"."start_date" as "startDate",
            "log_req"."end_date" as "endDate",
            "log_req"."car_serial_no" as "carSerialNo",
            "log_req"."effective_date" as "effectiveDate",
            "log_req"."owner_birthdate" as "ownerBirthdate",
            "log_req"."owner_card_id" as "ownerCardId",
            "log_req"."salesforce_id" as "salesforceID",
            "log_req"."salesforce_id_at",
            "log_req"."request_body",
            "log_trans"."appr_status",
            "log_trans"."appr_comment",
            "log_trans"."create_at" as "callback_at",
            row_number() over(partition by "log_req"."policy_no" order by "log_req".id desc) as rn
        from
            insurverse.log_sf_policy_trans_request as "log_req"
        join user_motor_policies ump on
            "log_req"."policy_no" = ump."Policy_No"
            and ump."Type" <> '0'
        left join insurverse.log_sf_policy_trans as "log_trans"
                    on
            "log_req"."salesforce_id" = "log_trans"."salesforce_id"
            and "log_req"."policy_no" = "log_trans"."policy_no"
        where
            "log_trans"."salesforce_id" is null
            ) as j
    where
        j.rn = 1 
        ) as json_req_cleaned
group by
    json_req_cleaned.policy_no
    ),

    endorse_last_status_mc_json as (
select
    json_req_cleaned.car_act_no as policy_key,
    cast(json_agg(to_json(json_req_cleaned)) as TEXT) as endorse_last_status
from
    (
    -- hides the 'rn' columns from to_json().
    select
        j.create_at,
        j."type",
        j.policy_type,
        j.policy_no,
        j.car_act_no,
        j."ownerPrefixName",
        j."ownerFirstName",
        j."ownerLastName",
        j."ownerAddress",
        j."ownerProvinceId",
        j."ownerProvince",
        j."ownerDistrictId",
        j."ownerDistrict",
        j."ownerSubdistrictId",
        j."ownerSubdistrict",
        j."ownerZipcode",
        j."carColor",
        j."carColorID",
        j."carLicenseNo",
        j."carLicenseProvice",
        j."startDate",
        j."endDate",
        j."carSerialNo",
        j."effectiveDate",
        j."ownerBirthdate",
        j."ownerCardId",
        j."salesforceID",
        j.salesforce_id_at,
        j.request_body,
        j.appr_status,
        j.appr_comment,
        j.callback_at
    from
        (
        select
            "log_req".create_at,
            cast("log_req"."type" as JSON) as "type",
            "log_req"."policy_type",
            "log_req"."policy_no",
            "log_req".car_act_no,
            "log_req"."owner_prefix_name" as "ownerPrefixName",
            "log_req"."owner_first_name" as "ownerFirstName",
            "log_req"."owner_last_name" as "ownerLastName",
            "log_req"."owner_address" as "ownerAddress",
            "log_req"."owner_province_id" as "ownerProvinceId",
            "log_req"."owner_province_name" as "ownerProvince",
            "log_req"."owner_district_id" as "ownerDistrictId",
            "log_req"."owner_district_name" as "ownerDistrict",
            "log_req"."owner_subdistrict_id" as "ownerSubdistrictId",
            "log_req"."owner_subdistrict_name" as "ownerSubdistrict",
            "log_req"."owner_zipcode" as "ownerZipcode",
            "log_req"."car_color" as "carColor",
            "log_req"."car_color_id" as "carColorID",
            "log_req"."car_license_no" as "carLicenseNo",
            "log_req"."car_license_province" as "carLicenseProvice",
            "log_req"."start_date" as "startDate",
            "log_req"."end_date" as "endDate",
            "log_req"."car_serial_no" as "carSerialNo",
            "log_req"."effective_date" as "effectiveDate",
            "log_req"."owner_birthdate" as "ownerBirthdate",
            "log_req"."owner_card_id" as "ownerCardId",
            "log_req"."salesforce_id" as "salesforceID",
            "log_req"."salesforce_id_at",
            "log_req"."request_body",
            "log_trans"."appr_status",
            "log_trans"."appr_comment",
            "log_trans"."create_at" as "callback_at",
            row_number() over(partition by "log_req"."car_act_no" order by "log_req".id desc) as rn
        from
            insurverse.log_sf_policy_trans_request as "log_req"
        join user_act_policies uap on
            "log_req"."car_act_no" = uap."Car_Act_No"
        left join insurverse.log_sf_policy_trans as "log_trans"
                    on
            "log_req"."salesforce_id" = "log_trans"."salesforce_id"
            and "log_req"."car_act_no" = "log_trans"."car_act_no"
        where
            "log_trans"."salesforce_id" is null
            ) as j
    where
        j.rn = 1 
        ) as json_req_cleaned
group by
    json_req_cleaned.car_act_no
    ),
    
    motor_claims as (
select
    distinct sfc.policy_number
from
    insurverse.sf_claim_coverage sfc
join user_motor_policies ump on
    sfc.policy_number = ump."Policy_No"
where
    UPPER(sfc.status) in ('CL', 'CC')
    ),
    
    act_claims as (
select
    acc_policy_no as car_act_no
from
    insurverse.claim_request
union
select
    acc_policy_no as car_act_no
from
    insurverse.sf_claim
    ),
    
    ta_coverage_json as (
        with coverage_rows as (
select
    p_cover.ta_package_id,
    p_cover.ta_coverage_id,
    -- For sorting
    p_cover.priority,
    cover.coverage_name_th,
    cover.coverage_name_en,
    p_cover.coverage_si_amt
from
    insurverse.mas_ta_package_coverage as p_cover
join insurverse.mas_ta_coverage as cover on
    p_cover.ta_coverage_id = cover.ta_coverage_id
        )
select
    ta_package_id,
    json_agg(item 
                -- Force the original sort order [Medical, Evac, Accident...]
                order by
                    case ta_coverage_id 
                        when 2 then 1
                        when 3 then 2
                        when 1 then 3
                        when 4 then 4
                        when 5 then 5
                        else 99
                    end asc
            )::text as ta_coverage_list
from
    (
    select
        (
        select
            r
        from
            (
            select
                cr.coverage_name_th,
                cr.coverage_name_en,
                cr.coverage_si_amt as "coverage_si"
                ) r) as item,
        cr.ta_package_id,
        cr.ta_coverage_id,
        cr.priority
    from
        coverage_rows as cr 
        ) sub
group by
    ta_package_id
    ),

    ta_package_list_json as (
-- First, we build the detailed coverage list *with* \n formatting
        with package_coverage_details as (
select
    sub.policy_ta_no,
    sub.ta_package_id,
    json_agg(sub.item order by sub."priority" asc)::text as ta_coverage_list_detail
from
    (
    select
        policy_c.policy_ta_no,
        policy_c.ta_package_id,
        pack_c.priority,
        -- This is the "magic" \n newline trick for the nested list
                    (
        select
            r
        from
            (
            select
                cover.ta_coverage_id,
                cover.coverage_name_th,
                cover.coverage_name_en,
                cover.coverage_desc_th,
                cover.coverage_desc_en,
                coalesce(policy_c.coverage_si_amt, 0) as coverage_si_amt,
                cover.coverage_desc_th_1 as coverage_desc_1_th,
                cover.coverage_desc_en_1 as coverage_desc_1_en,
                cover.coverage_desc_th_2 as coverage_desc_2_th,
                cover.coverage_desc_en_2 as coverage_desc_2_en,
                cover.coverage_desc_th_3 as coverage_desc_3_th,
                cover.coverage_desc_en_3 as coverage_desc_3_en,
                coalesce(policy_c.other_amt_min, 0) as other_amt_min,
                coalesce(policy_c.other_amt_max, 0) as other_amt_max,
                cover.coverage_type_icon
                    ) r) as item
    from
        insurverse.policy_ta_coverage as policy_c
    join user_ta_policies utp on
        policy_c.policy_ta_no = utp.policy_ta_no
    join insurverse.mas_ta_coverage as cover on
        policy_c.ta_coverage_id = cover.ta_coverage_id
    join insurverse.mas_ta_package_coverage as pack_c on
        policy_c.ta_package_id = pack_c.ta_package_id
        and policy_c.ta_coverage_id = pack_c.ta_coverage_id
            ) sub
group by
    sub.policy_ta_no,
    sub.ta_package_id
        ),
-- Now we build the package list, just like the original query
package_details as (
select
    policy_c.policy_ta_no,
    pack.ta_package_id,
    pack.package_name_th,
    pack.package_name_en,
    pack.package_desc_th,
    pack.package_desc_en,
    pack.is_addon,
    pcd.ta_coverage_list_detail::json as ta_coverage_list,
    pack.priority_addon
from
    (
    select
        distinct ptc.policy_ta_no,
        ptc.ta_package_id
    from
        insurverse.policy_ta_coverage ptc
    join user_ta_policies utp on
        ptc.policy_ta_no = utp.policy_ta_no) as policy_c
join insurverse.mas_ta_package as pack on
    policy_c.ta_package_id = pack.ta_package_id
left join package_coverage_details as pcd on
    policy_c.policy_ta_no = pcd.policy_ta_no
    and policy_c.ta_package_id = pcd.ta_package_id
        )
-- Finally, apply the \n trick to the outer list of packages
select
    sub.policy_ta_no,
    json_agg(sub.item order by sub.priority_addon asc)::text as ta_package_list
from
    (
    select
        (
        select
            r
        from
            (
            select
                pd.ta_package_id,
                pd.package_name_th,
                pd.package_name_en,
                pd.package_desc_th,
                pd.package_desc_en,
                pd.is_addon,
                pd.ta_coverage_list
                ) r) as item,
        pd.policy_ta_no,
        pd.priority_addon
    from
        package_details as pd 
        ) sub
group by
    sub.policy_ta_no
    ),

    
    ta_bene_detail_json as (
select
    par.policy_ta_no,
    json_build_object(
                'bene_ta_type_th', bene_type.mas_name_th, 'bene_ta_type_en', bene_type.mas_name_en,
                'bene_ta_title_name_th', par.bene_title_th, 'bene_ta_first_name_th', par.bene_firstname_th,
                'bene_ta_last_name_th', par.bene_lastname_th, 'bene_ta_title_name_en', par.bene_title_en,
                'bene_ta_first_name_en', par.bene_firstname_en, 'bene_ta_last_name_en', par.bene_lastname_en,
                'bene_ta_relation_th', bene_relation.mas_name_th, 'bene_ta_relation_en', bene_relation.mas_name_en
            )::text as bene_ta_detail
from
    insurverse.lead_ta_participant as par
join user_ta_policies utp on
    par.policy_ta_no = utp.policy_ta_no
    -- Join to reduce Overhead
join insurverse.mas_ta_description as bene_type on
    par.bene_type = cast(bene_type.mas_ta_code as INT2)
        and bene_type.mas_ta_type = 'bene_type'
    left join insurverse.mas_ta_description as bene_relation on
        par.bene_relation = cast(bene_relation.mas_ta_code as INT2)
            and bene_relation.mas_ta_type = 'bene_relation'
    ),
    
    ta_endorse_last_status_json as (
select
    policy_ta_no as policy_key,
    json_build_object(
            'id', id, 'create_at', create_at, 'request_type', request_type, 'subject', subject, 'body', body,
            'request_status', request_status, 'remark', remark, 'update_at', update_at, 'iia_response_at', iia_response_at
        )::text as endorse_last_status
from
    (
    select
        log_req.*,
        row_number() over(partition by log_req.policy_ta_no order by log_req.create_at desc) as rn
    from
        insurverse.log_request_ta as log_req
    join user_ta_policies as utp on
        log_req.policy_ta_no = utp.policy_ta_no
        ) as ranked_logs
where
    rn = 1
    ),
    
    pa_coverage_json as (
        with coverage_rows as (
select
    p_cover.policy_pa_no,
    p_cover.pa_coverage_id,
    cover.coverage_name_th,
    cover.coverage_name_en,
    p_cover.si_cover_amt,
    cover.coverage_desc1_th,
    cover.coverage_desc1_en,
    cover.coverage_desc2_th,
    cover.coverage_desc2_en,
    cover.coverage_desc3_th,
    cover.coverage_desc3_en
from
    insurverse.lead_pa_coverage as p_cover
join user_pa_policies upp on
    p_cover.policy_pa_no = upp.policy_pa_no
    -- Join to reduce overhead
join insurverse.mas_pa_coverage as cover on
    p_cover.pa_coverage_id = cover.pa_coverage_id
        )
select
    -- 1. (si_cover_amt = 0) is TRUE for all 0-value SIs.
    -- 2. Sorting by this DESC puts all TRUEs (the 0-value SIs) first.
    -- 3. The second sort key (pa_coverage_id ASC) sorts within those groups.
    policy_pa_no,
    json_agg(item order by (si_cover_amt = 0) desc, si_cover_amt desc, pa_coverage_id asc)::text as pa_coverage_list
from
    (
    select
        (
        select
            r
        from
            (
            select
                pa_coverage_id,
                coverage_name_th,
                coverage_name_en,
                si_cover_amt as "coverage_si",
                coverage_desc1_th,
                coverage_desc1_en,
                coverage_desc2_th,
                coverage_desc2_en as "coverage_desc3_en",
                -- TODO: Force Duplicate key to remain production previous my_policy output   
                coverage_desc3_th,
                coverage_desc3_en
                ) r
            ) as item,
        policy_pa_no,
        pa_coverage_id,
        si_cover_amt
    from
        coverage_rows
        ) sub
group by
    policy_pa_no
    ),

    pa_bene_detail_json as (
        with ranked_beneficiaries as (
select
    bene.policy_pa_no,
    json_build_object(
                    'suminsure_rate', bene.suminsure_rate,
                    'bene_pa_type_th', bene_type.mas_name_th,
                    'bene_pa_type_en', bene_type.mas_name_en,
                    'bene_pa_title_name_th', bene.bene_title_th,
                    'bene_pa_first_name_th', bene.bene_firstname_th,
                    'bene_pa_last_name_th', bene.bene_lastname_th,
                    'bene_pa_title_name_en', bene.bene_title_en,
                    'bene_pa_first_name_en', bene.bene_firstname_en,
                    'bene_pa_last_name_en', bene.bene_lastname_en,
                    'bene_pa_relation_th', bene_relation.mas_name_th,
                    'bene_pa_relation_en', bene_relation.mas_name_en
                )::text as bene_pa_detail,
    row_number() over(partition by bene.policy_pa_no order by (select null)) as rn
from
    insurverse.lead_pa_beneficiary as bene
join user_pa_policies as upp on
    bene.policy_pa_no = upp.policy_pa_no
join insurverse.mas_ta_description as bene_type on
    bene.bene_type = cast(bene_type.mas_ta_code as INT2)
        and bene_type.mas_ta_type = 'bene_type'
    left join insurverse.mas_ta_description as bene_relation on
        bene.bene_relation = cast(bene_relation.mas_ta_code as INT2)
            and bene_relation.mas_ta_type = 'bene_relation'
        )
select
    rb.policy_pa_no,
    rb.bene_pa_detail
from
    ranked_beneficiaries as rb
where
    rb.rn = 1 
    ),

    pa_endorse_last_status_json as (
select
    policy_pa_no as policy_key,
    json_build_object(
            'id', id, 'create_at', create_at, 'request_type', request_type, 'subject', subject, 'body', body,
            'request_status', request_status, 'remark', remark, 'update_at', update_at, 'iia_response_at', iia_response_at
        )::text as endorse_last_status
from
    (
    select
        log_req.*,
        row_number() over(partition by log_req.policy_pa_no order by log_req.create_at desc) as rn
    from
        insurverse.log_request_pa as log_req
    join user_pa_policies as upp on
        log_req.policy_pa_no = upp.policy_pa_no
        ) as ranked_logs
where
    rn = 1
    ),
    
    home_coverage_json as (
select
    p.policy_home_no,
    json_build_object(
                 'building_type_id', p.home_building_type_id,
                 'building_type_name_th', build.building_name_th,
                 'building_province_id', p.home_building_province_id,
                 'building_province_name_th', prov.prname,
                 'building_material_type_id', p.home_material_type_id,
                 'building_material_type_name_th', mat.material_name_th,
                 'resident_type_id', p.home_resident_type_id,
                 'resident_type_name_th', resident.resident_name_th,
                 'building_address_detail', json_build_object(
                    'building_address_th', p.building_address_th,
                    'building_subdistrict', coalesce(build_subd.sdname, ''),
                    'building_district', coalesce(build_dis.diname, ''),
                    'building_province', coalesce(build_prov.prname, ''),
                    'building_zipcode', coalesce(p.building_zipcode, '')
                 ),
                 'coverage_detail', json_build_object(
                    'cover_main_si', coalesce(cover.cover_main_si, 0), 'flag_furniture', coalesce(cover.flag_furniture, false), 'cover_furniture_si', coalesce(cover.cover_furniture_si, 0),
                    'cover_main_furniture_si', coalesce(cover.cover_main_furniture_si, 0), 'cover_main_furniture_prem', coalesce(cover.cover_main_furniture_prem, 0),
                    'cover_loss_and_damage_si', coalesce(cover.cover_loss_and_damage_si, 0), 'cover_loss_and_damage_prem', coalesce(cover.cover_loss_and_damage_prem, 0),
                    'flag_cover_rental_cost', coalesce(cover.flag_cover_rental_cost, false), 'cover_glass_si', coalesce(cover.cover_glass_si, 0), 'cover_glass_prem', coalesce(cover.cover_glass_prem, 0),
                    'cover_main_total_amt', coalesce(cover.cover_main_total_amt, 0), 'flag_cover_natural_dis_ex_flood', coalesce(cover.flag_cover_natural_dis_ex_flood, false),
                    'cover_natural_dis_ex_flood_si', coalesce(cover.cover_natural_dis_ex_flood_si, 0), 'cover_natural_dis_ex_flood_prem', coalesce(cover.cover_natural_dis_ex_flood_prem, 0),
                    'flag_cover_flood_dis', coalesce(cover.flag_cover_flood_dis, false), 'cover_flood_dis_si', coalesce(cover.cover_flood_dis_si, 0), 'cover_flood_dis_prem', coalesce(cover.cover_flood_dis_prem, 0),
                    'flag_cover_theft', coalesce(cover.flag_cover_theft, false), 'cover_theft_si', coalesce(cover.cover_theft_si, 0), 'cover_theft_prem', coalesce(cover.cover_theft_prem, 0),
                    'flag_cover_third_parties', coalesce(cover.flag_cover_third_parties, false), 'cover_third_parties_si', coalesce(cover.cover_third_parties_si, 0),
                    'cover_third_parties_prem', coalesce(cover.cover_third_parties_prem, 0), 'cover_addon_total_amt', coalesce(cover.cover_addon_total_amt, 0)
                 )
            )::text as home_coverage
from
    user_home_policies as p
    -- Reduce Overhead from Main CTE 
left join insurverse.lead_home_coverage cover on
    p.policy_home_no = cover.policy_home_no
left join insurverse.mas_home_building_type build on
    p.home_building_type_id = build.home_building_type_id
left join insurverse.province prov on
    p.home_building_province_id = prov.provinceid
left join insurverse.mas_home_material_type mat on
    p.home_material_type_id = mat.home_material_type_id
left join insurverse.mas_home_resident_type resident on
    p.home_resident_type_id = resident.home_resident_type_id
left join insurverse.subdistrict build_subd on
    p.building_subdistrict_id = build_subd.subdistrictid
left join insurverse.district build_dis on
    p.building_district_id = build_dis.districtid
left join insurverse.province build_prov on
    p.building_province_id = build_prov.provinceid
    ),
    home_bene_detail_json as (
select
    par.policy_home_no,
    json_build_object(
                'suminsure_rate', par.suminsure_rate, 'bene_home_type_th', bene_type.mas_name_th, 'bene_home_type_en', bene_type.mas_name_en,
                'bene_home_title_name_th', par.bene_title_th, 'bene_home_first_name_th', par.bene_firstname_th, 'bene_home_last_name_th', par.bene_lastname_th,
                'bene_home_title_name_en', par.bene_title_en, 'bene_home_first_name_en', par.bene_firstname_en, 'bene_home_last_name_en', par.bene_lastname_en,
                'bene_home_relation_th', bene_relation.mas_name_th, 'bene_home_relation_en', bene_relation.mas_name_en
            )::text as bene_home_detail
from
    insurverse.lead_home_participant as par
join user_home_policies as uhp on
    par.policy_home_no = uhp.policy_home_no
join insurverse.mas_ta_description as bene_type on
    par.bene_type = cast(bene_type.mas_ta_code as INT2)
        and bene_type.mas_ta_type = 'bene_type'
    left join insurverse.mas_ta_description as bene_relation on
        par.bene_relation = cast(bene_relation.mas_ta_code as INT2)
            and bene_relation.mas_ta_type = 'bene_relation'
    ),
    home_endorse_last_status_json as (
select
    policy_home_no as policy_key,
    json_build_object(
            'id', id, 'create_at', create_at, 'request_type', request_type, 'subject', subject, 'body', body,
            'request_status', request_status, 'remark', remark, 'update_at', update_at, 'iia_response_at', iia_response_at
        )::text as endorse_last_status
from
    (
    select
        log_req.*,
        row_number() over(partition by log_req.policy_home_no order by log_req.create_at desc) as rn
    from
        insurverse.log_request_home as log_req
    join user_home_policies as uhp on
        log_req.policy_home_no = uhp.policy_home_no
    ) as ranked_logs
where
    rn = 1
    ),
-- Main CTEs mimicking the UNION structure
motor_leads as (
select
    1 as "priority",
    "lead"."Brand"::varchar,
    "lead"."Model"::varchar,
    "lead"."Year"::varchar,
    cast("policy"."Car_license_no" as TEXT) as "Car_license_no",
    "lead"."Type"::varchar,
    cast(coalesce("lead"."SI_Limit", 0) + coalesce("lead"."SI_Access_Limit", 0) as INT) as "SI",
    cast("policy"."Owner_first_name" as TEXT) as "Owner_first_name",
    cast(null as text) as "Owner_first_name_en",
    cast("policy"."Owner_last_name" as TEXT) as "Owner_last_name",
    cast(null as text) as "Owner_last_name_en",
    cast(null as text) as "Policy_No",
    cast(null as text) as "Policy_Ta_No",
    cast(null as text) as "Car_Act_No",
    cast(null as text) as "Policy_Startdate",
    cast(null as text) as "Policy_Startdate_en",
    cast(null as text) as "Policy_Enddate",
    cast(null as text) as "Policy_Enddate_en",
    cast(null as TIMESTAMP) as "policy_startdate_sort",
    prov."prname"::text as "Car_license_provice",
    cast(null as text) as "Policy_url_copy_ref",
    cast(null as text) as "Receipt_url_copy_ref",
    cast(null as text) as "policy_date",
    cast(null as text) as "policy_date_en",
    cast(null as text) as "Car_Inspect_Status",
    cast("lead"."Lead_No" as INTEGER) as "Lead_No",
    cast(null as integer) as "Car_Act_Lead_No",
    'ACT'::text as "policy_status",
    insurverse.fn_display_buddha_date ("lead"."Payment_Date") as "payment_date",
    cast(null as text) as "car_serial_no",
    cast("policy"."Car_license_type" as TEXT) as "car_license_type",
    cast(null as text) as "car_color",
    cast(null as text) as "car_cc",
    cast(null as INT) as "car_seat",
    cast(null as INT) as "car_weight",
    cast(null as text) as "owner_citizen_id",
    cast(null as text) as "Owner_birth_date",
    cast(null as text) as "Owner_birth_date_en",
    cast(null as text) as "owner_prefix_name",
    cast(null as text) as "owner_prefix_name_en",
    cast(null as text) as "owner_address",
    cast(null as text) as "owner_address_en",
    cast(null as text) as "owner_subdistrict",
    cast(null as text) as "owner_subdistrict_en",
    cast(null as text) as "owner_district",
    cast(null as text) as "owner_district_en",
    cast(null as text) as "owner_province",
    cast(null as text) as "owner_province_en",
    cast(null as text) as "owner_zipcode",
    cast(null as text) as "user_email",
    cast(null as text) as "user_mobile",
    cast(null as text) as "par_1_prefix_name",
    cast(null as text) as "par_1_first_name",
    cast(null as text) as "par_1_last_name",
    cast(null as text) as "par_1_birth_date",
    cast(null as text) as "par_1_driver_license",
    cast(null as text) as "par_1_citizen",
    cast(null as text) as "par_2_prefix_name",
    cast(null as text) as "par_2_first_name",
    cast(null as text) as "par_2_last_name",
    cast(null as text) as "par_2_birth_date",
    cast(null as text) as "par_2_driver_license",
    cast(null as text) as "par_2_citizen",
    cast(null as text) as "bene_type",
    cast(null as text) as "bene_first_name",
    cast(null as text) as "bene_last_name",
    cast(null as text) as "bene_ta_detail",
    'N'::text as "deli_flag",
    cast(null as text) as "deli_addr_1",
    cast(null as text) as "deli_subdistrict",
    cast(null as text) as "deli_district",
    cast(null as text) as "deli_province",
    cast(null as text) as "deli_zipcode",
    "lead"."GarageType"::varchar,
    coalesce("lead"."SI_Limit", 0)::numeric as "si_limit",
    coalesce("lead"."SI_Access_Limit", 0)::numeric as "si_access_limit",
    coalesce("lead"."SI_TPPD_Limit", 0)::numeric as "si_tppd_limit",
    coalesce("lead"."SI_TPBI_Limit", 0)::numeric as "si_tpbi_limit",
    coalesce("lead"."SI_MV01_Limit", 0)::numeric as "si_mv01_limit",
    coalesce("lead"."SI_MV02_Limit", 0)::numeric as "si_mv02_limit",
    coalesce("lead"."SI_MV03_Limit", 0)::numeric as "si_mv03_limit",
    cast(null as varchar) as "car_comp_code",
    cast(null as integer) as "coverinjury",
    cast(null as integer) as "coverdeath",
    cast(null as integer) as "coveracc",
    "lead"."Access_para_code"::varchar,
    cast(null as text) as "endorsement_list",
    cast(null as text) as "package_name",
    cast(null as text) as "ta_coverage_list",
    cast(null as text) as "ta_country_name_th",
    cast(null as text) as "ta_country_name_en",
    cast(null as text) as "owner_card_type",
    cast(null as text) as "owner_email",
    cast(null as text) as "owner_mobile",
    cast(null as text) as "Policy_Pa_No",
    cast(null as text) as "bene_pa_detail",
    cast(null as text) as "bene_title",
    cast(null as text) as "pa_coverage_list",
    'wait_fullfill'::text as "policy_directory",
    cast(null as text) as "tax_deductions_url_ref",
    cast(null as text) as "endorse_last_status",
    false as "tax_deductions",
    cast(0 as integer) as "owner_subdistrict_id",
    cast(0 as integer) as "owner_district_id",
    cast(0 as integer) as "owner_province_id",
    cast(0 as integer) as "deli_subdistrict_id",
    cast(0 as integer) as "deli_district_id",
    cast(0 as integer) as "deli_province_id",
    cast(null as text) as "tax_deductions_date_th",
    cast(null as text) as "tax_deductions_date_en",
    cast(null as text) as "Policy_Home_No",
    cast(null as text) as "home_coverage",
    cast(null as text) as "bene_home_detail",
    cast(null as text) as "Policy_url_ref",
    cast(null as text) as "Receipt_url_ref",
    cast(null as text) as "tax_deductions_url_copy_ref",
    false as "claim_status_flag",
    cast((select json_build_object(
                                        'cctv_flag', "lead"."Flag_CCTV",
                                        'cctv_disc_per', "lead"."CCTV",
                                        'access_flag', case when "lead"."Flag_Access" is not null then "lead"."Flag_Access" else 'N' end,
                                        'extend_startdate_th', null,
                                        'extend_startdate_en', null,
                                        'extend_enddate_th', null,
                                        'extend_enddate_en', null,
                                        'extend_amt', 0
                                )) as TEXT) as "motor_detail",
    cast((select json_build_object(
                                        'noti_renewal_flag', false,
                                        'expire_day_count', null,
                                        'last_noti_date_en', null,
                                        'last_noti_date_th', null,
                                        'total_amt', 0,
                                        'is_renewed_flag', false,
                                        'renewed_policy_no', null,
                                        'can_renewal_flag', false,
                                        'ref_policy_no', "lead"."ref_policy_no"
                                )) as TEXT) as "renewal_detail",
    cast(null as text) as "ta_package_list",
    cast(null as text) as "ta_policy_detail",
    cast("lead"."partner_code" as TEXT) as "partner_code",
    cast(json_build_object('partner_code', "lead"."partner_code", 'partner_name_th', partner.partner_name_th, 'partner_name_en', partner.partner_name_en) as TEXT) as "partner_detail",
    --CR21
    --ผู้ขับขี่ 3-5
	"lead"."par_prefix_name_3"::text as "par_3_prefix_name",
    "lead"."par_first_name_3"::text as "par_3_first_name",
    "lead"."par_last_name_3"::text as "par_3_last_name",
    "lead"."par_birth_date_3"::text as "par_3_birth_date",
    "lead"."par_driver_license_no_3"::text as "par_3_driver_license",
    "lead"."par_citizen_id_3"::text as "par_3_citizen",
    "lead"."par_prefix_name_4"::text as "par_4_prefix_name",
    "lead"."par_first_name_4"::text as "par_4_first_name",
    "lead"."par_last_name_4"::text as "par_4_last_name",
    "lead"."par_birth_date_4"::text as "par_4_birth_date",
    "lead"."par_driver_license_no_4"::text as "par_4_driver_license",
    "lead"."par_citizen_id_4"::text as "par_4_citizen",
    "lead"."par_prefix_name_5"::text as "par_5_prefix_name",
    "lead"."par_first_name_5"::text as "par_5_first_name",
    "lead"."par_last_name_5"::text as "par_5_last_name",
    "lead"."par_birth_date_5"::text as "par_5_birth_date",
    "lead"."par_driver_license_no_5"::text as "par_5_driver_license",
    "lead"."par_citizen_id_5"::text as "par_5_citizen",
    "policy"."Owner_occupation" as owner_occupation,
    cast(null as text) as owner_occupation_code,
    "lead".prem_version::integer,
    "lead".oic_version::text,
    "policy".bene_occupation::text,
    "policy".bene_occupation_code:: text,
    "lead".par_occupation_1 as "par_1_occupation",
    "lead".driver_behavior_1::integer as "par_1_driver_behavior" ,
    "lead".par_occupation_2 as "par_2_occupation",
    "lead".driver_behavior_2::integer as "par_2_driver_behavior" ,
    "lead".par_occupation_3 as "par_3_occupation",
    "lead".driver_behavior_3::integer as "par_3_driver_behavior" ,
    "lead".par_occupation_4 as "par_4_occupation",
    "lead".driver_behavior_4::integer as "par_4_driver_behavior" ,
    "lead".par_occupation_5 as "par_5_occupation",
    "lead".par_occupation_code_1 as "par_1_occupation_code",
    "lead".par_occupation_code_2 as "par_2_occupation_code",
    "lead".par_occupation_code_3 as "par_3_occupation_code",
    "lead".par_occupation_code_4 as "par_4_occupation_code",
    "lead".par_occupation_code_5 as "par_5_occupation_code",
    "lead".driver_behavior_5::integer as "par_5_driver_behavior" ,
    "lead".driver_behavior_consent_1::boolean,
    "lead".driver_behavior_consent_2::boolean,
    "lead".driver_behavior_consent_3::boolean,
    "lead".driver_behavior_consent_4::boolean,
    "lead".driver_behavior_consent_5::boolean,
    -- [PLACEHOLDERS FOR NEW FIELDS]
    null::text as customer_id,
    null::integer as hp,
    null::text as "engineType",
    "lead"."par_driver_license_category_1"::text as par_1_driver_license_category,
    "lead"."par_driver_license_category_2"::text as par_2_driver_license_category,
    "lead"."par_driver_license_category_3"::text as par_3_driver_license_category,
    "lead"."par_driver_license_category_4"::text as par_4_driver_license_category,
    "lead"."par_driver_license_category_5"::text as par_5_driver_license_category
from
    insurverse."Lead_coverage_premium" as "lead"
left join converted_leads cl on
    "lead"."Lead_No"::text = cl."Lead_No"
left join insurverse."Policy_Header" as "policy" on
    "lead"."ref_policy_no" = "policy"."Policy_No"
left join insurverse."province" as prov on
    "policy"."Car_license_provice" = prov.provinceid
left join insurverse.mas_partner as partner on
    "lead".partner_code = partner.partner_code
where
    "lead"."Email" = (
    select
        email
    from
        set_para
		)
    and "lead"."Payment_status" = 'SUCCESS'
    and cl."Lead_No" is null
),
    
    act_leads as (
select
    2 as "priority",
    -- Changed from 1 to 2 just like original implementation logic if needed, but matches union order
		"lead"."Brand"::varchar,
    "lead"."Model"::varchar,
    "lead"."Year"::varchar,
    cast(null as text) as "Car_license_no",
    '0'::varchar as "Type",
    0 as "SI",
    cast(null as text) as "Owner_first_name",
    cast(null as text) as "Owner_first_name_en",
    cast(null as text) as "Owner_last_name",
    cast(null as text) as "Owner_last_name_en",
    cast(null as text) as "Policy_No",
    cast(null as text) as "Policy_Ta_No",
    cast(null as text) as "Car_Act_No",
    cast(null as text) as "Policy_Startdate",
    cast(null as text) as "Policy_Startdate_en",
    cast(null as text) as "Policy_Enddate",
    cast(null as text) as "Policy_Enddate_en",
    cast(null as TIMESTAMP) as "policy_startdate_sort",
    cast(null as text) as "Car_license_provice",
    cast(null as text) as "Policy_url_copy_ref",
    cast(null as text) as "Receipt_url_copy_ref",
    cast(null as text) as "policy_date",
    cast(null as text) as "policy_date_en",
    cast(null as text) as "Car_Inspect_Status",
    cast(null as INTEGER) as "Lead_No",
    cast("lead"."Car_Act_Lead_No" as INTEGER) as "Car_Act_Lead_No",
    'ACT'::text as "policy_status",
    insurverse.fn_display_buddha_date ("lead"."Payment_date") as "payment_date",
    cast(null as text) as "car_serial_no",
    cast(null as text) as "car_license_type",
    cast(null as text) as "car_color",
    cast(null as text) as "car_cc",
    cast(null as INT) as "car_seat",
    cast(null as INT) as "car_weight",
    cast(null as text) as "owner_citizen_id",
    cast(null as text) as "Owner_birth_date",
    cast(null as text) as "Owner_birth_date_en",
    cast(null as text) as "owner_prefix_name",
    cast(null as text) as "owner_prefix_name_en",
    cast(null as text) as "owner_address",
    cast(null as text) as "owner_address_en",
    cast(null as text) as "owner_subdistrict",
    cast(null as text) as "owner_subdistrict_en",
    cast(null as text) as "owner_district",
    cast(null as text) as "owner_district_en",
    cast(null as text) as "owner_province",
    cast(null as text) as "owner_province_en",
    cast(null as text) as "owner_zipcode",
    cast(null as text) as "user_email",
    cast(null as text) as "user_mobile",
    cast(null as text) as "par_1_prefix_name",
    cast(null as text) as "par_1_first_name",
    cast(null as text) as "par_1_last_name",
    cast(null as text) as "par_1_birth_date",
    cast(null as text) as "par_1_driver_license",
    cast(null as text) as "par_1_citizen",
    cast(null as text) as "par_2_prefix_name",
    cast(null as text) as "par_2_first_name",
    cast(null as text) as "par_2_last_name",
    cast(null as text) as "par_2_birth_date",
    cast(null as text) as "par_2_driver_license",
    cast(null as text) as "par_2_citizen",
    cast(null as text) as "bene_type",
    cast(null as text) as "bene_first_name",
    cast(null as text) as "bene_last_name",
    cast(null as text) as "bene_ta_detail",
    'N'::text as "deli_flag",
    cast(null as text) as "deli_addr_1",
    cast(null as text) as "deli_subdistrict",
    cast(null as text) as "deli_district",
    cast(null as text) as "deli_province",
    cast(null as text) as "deli_zipcode",
    cast(null as varchar) as "garage_type",
    cast(null as numeric) as "si_limit",
    cast(null as numeric) as "si_access_limit",
    cast(null as numeric) as "si_tppd_limit",
    cast(null as numeric) as "si_tpbi_limit",
    cast(null as numeric) as "si_mv01_limit",
    cast(null as numeric) as "si_mv02_limit",
    cast(null as numeric) as "si_mv03_limit",
    "lead"."Car_Comp_Code"::varchar as "car_comp_code",
    case
        when "lead"."Car_Comp_Code" = '1.20A' then cast(spar.coverinjury_van as INT)
        else cast(spar.coverinjury as INT)
    end as "coverinjury",
    case
        when "lead"."Car_Comp_Code" = '1.20A' then cast(spar.coverdeath_van as INT)
        else cast(spar.coverdeath as INT)
    end as "coverdeath",
    case
        when "lead"."Car_Comp_Code" = '1.20A' then cast(spar.coveracc_van as INT)
        else cast(spar.coveracc as INT)
    end as "coveracc",
    cast(null as varchar) as "Access_para_code",
    cast(null as text) as "endorsement_list",
    cast(null as text) as "package_name",
    cast(null as text) as "ta_coverage_list",
    cast(null as text) as "ta_country_name_th",
    cast(null as text) as "ta_country_name_en",
    cast(null as text) as "owner_card_type",
    cast(null as text) as "owner_email",
    cast(null as text) as "owner_mobile",
    cast(null as text) as "Policy_Pa_No",
    cast(null as text) as "bene_pa_detail",
    cast(null as text) as "bene_title",
    cast(null as text) as "pa_coverage_list",
    'wait_fullfill'::text as "policy_directory",
    cast(null as text) as "tax_deductions_url_ref",
    cast(null as text) as "endorse_last_status",
    false as "tax_deductions",
    0 as "owner_subdistrict_id",
    0 as "owner_district_id",
    0 as "owner_province_id",
    0 as "deli_subdistrict_id",
    0 as "deli_district_id",
    0 as "deli_province_id",
    cast(null as text) as "tax_deductions_date_th",
    cast(null as text) as "tax_deductions_date_en",
    cast(null as text) as "Policy_Home_No",
    cast(null as text) as "home_coverage",
    cast(null as text) as "bene_home_detail",
    cast(null as text) as "Policy_url_ref",
    cast(null as text) as "Receipt_url_ref",
    cast(null as text) as "tax_deductions_url_copy_ref",
    false as "claim_status_flag",
    cast((select json_build_object(
                                'cctv_flag', 'N',
                                'cctv_disc_per', 0,
                                'access_flag', 'N',
                                'extend_startdate_th', null,
                                'extend_startdate_en', null,
                                'extend_enddate_th', null,
                                'extend_enddate_en', null,
                                'extend_amt', 0
                        )) as TEXT) as "motor_detail",
    null as "renewal_detail",
    cast(null as text) as "ta_package_list",
    cast(null as text) as "ta_policy_detail",
    cast(null as TEXT) as "partner_code",
    cast(null as TEXT) as "partner_detail",
    --CR21
    --ผู้ขับขี่ 3-5
		cast(null as text) as "par_3_prefix_name",
    cast(null as text) as "par_3_first_name",
    cast(null as text) as "par_3_last_name",
    cast(null as text) as "par_3_birth_date",
    cast(null as text) as "par_3_driver_license",
    cast(null as text) as "par_3_citizen",
    cast(null as text) as "par_4_prefix_name",
    cast(null as text) as "par_4_first_name",
    cast(null as text) as "par_4_last_name",
    cast(null as text) as "par_4_birth_date",
    cast(null as text) as "par_4_driver_license",
    cast(null as text) as "par_4_citizen",
    cast(null as text) as "par_5_prefix_name",
    cast(null as text) as "par_5_first_name",
    cast(null as text) as "par_5_last_name",
    cast(null as text) as "par_5_birth_date",
    cast(null as text) as "par_5_driver_license",
    cast(null as text) as "par_5_citizen",
    "lead"."Occupation" as "owner_occupation",
    "lead"."occupation_code" as "owner_occupation_code",
    cast(null as integer) as "prem_version",
    "lead"."oic_version" as "oic_version",
    cast(null as text) as "bene_occupation",
    cast(null as text) as "bene_occupation_code",
    cast(null as text) as "par_1_occupation",
    cast(null as integer) as "par_1_driver_behavior",
    cast(null as text) as "par_2_occupation",
    cast(null as integer) as "par_2_driver_behavior",
    cast(null as text) as "par_3_occupation",
    cast(null as integer) as "par_3_driver_behavior",
    cast(null as text) as "par_4_occupation",
    cast(null as integer) as "par_4_driver_behavior",
    cast(null as text) as "par_5_occupation",
    cast(null as text) as "par_1_occupation_code",
    cast(null as text) as "par_2_occupation_code",
    cast(null as text) as "par_3_occupation_code",
    cast(null as text) as "par_4_occupation_code",
    cast(null as text) as "par_5_occupation_code",
    cast(null as integer) as "par_5_driver_behavior",
    cast(null as boolean) as "driver_behavior_consent_1",
    cast(null as boolean) as "driver_behavior_consent_2",
    cast(null as boolean) as "driver_behavior_consent_3",
    cast(null as boolean) as "driver_behavior_consent_4",
    cast(null as boolean) as "driver_behavior_consent_5",
    -- [MAPPED NEW FIELDS FROM Lead_Car_Act_Discount_Premium] -- address/tax fields not yet in UAT schema, only hp/engineType are live
        "lead"."customer_id"::text as customer_id,
        "lead"."hp"::integer as hp,
        "lead"."engineType"::text as "engineType",
        null::text as par_1_driver_license_category,
        null::text as par_2_driver_license_category,
        null::text as par_3_driver_license_category,
        null::text as par_4_driver_license_category,
        null::text as par_5_driver_license_category
from
    insurverse."Lead_Car_Act_Discount_Premium" as "lead"
left join converted_leads cl on
    "lead"."Car_Act_Lead_No"::text = cl."Lead_No"
cross join car_act_params as spar
left join insurverse.mas_partner as partner on
    "lead".partner_code = partner.partner_code
where
    "lead"."email" = (
    select
        email
    from
        set_para
		)
    and "lead"."Payment_status" = 'SUCCESS'
    and cl."Lead_No" is null
        ),
    
    motor_policies as (
select
    3 as "priority",
    prem."Brand"::varchar,
    prem."Model"::varchar,
    prem."Year"::varchar,
    policy."Car_license_no"::text,
    prem."Type"::varchar,
    cast(coalesce(prem."SI_Limit", 0) + coalesce(prem."SI_Access_Limit", 0) as INT) as "SI",
    policy."Owner_first_name"::text,
    null::text,
    policy."Owner_last_name"::text,
    null::text,
    policy."Policy_No"::text,
    null::text,
    policy."Car_Act_No"::text,
    insurverse.fn_display_buddha_date (policy."Policy_Startdate" + interval '7 HOUR')::text as "Policy_Startdate",
    TO_CHAR(policy."Policy_Startdate" + interval '7 HOUR', 'dd/mm/yyyy')::text as "Policy_Startdate_en",
    insurverse.fn_display_buddha_date (policy."Policy_Enddate" + interval '7 HOUR')::text as "Policy_Enddate",
    TO_CHAR(policy."Policy_Enddate" + interval '7 HOUR', 'dd/mm/yyyy')::text as "Policy_Enddate_en",
    policy."Policy_Startdate" as "policy_startdate_sort",
    car_prov."prname"::text as "Car_license_provice",
    policy."Policy_url_copy_ref"::text,
    policy."Receipt_url_copy_ref"::text,
    insurverse.fn_display_buddha_date (policy."Create_date" + interval '7 HOUR')::text as "policy_date",
    TO_CHAR(policy."Create_date" + interval '7 HOUR', 'dd/mm/yyyy')::text as "policy_date_en",
    case
        when policy."Car_Inspect_Status" = '' then null
        else policy."Car_Inspect_Status"
    end::text as "Car_Inspect_Status",
    prem."Lead_No",
    cast(null as integer) as "Car_Act_Lead_No",
    coalesce(policy."Policy_Status", 'ACT')::text as "policy_status",
    insurverse.fn_display_buddha_date (prem."Payment_Date")::text as "payment_date",
    policy."Car_serial_no"::text,
    policy."Car_license_type"::text,
    color."color_name_th"::text as "car_color",
    policy."CC"::text as "car_cc",
    coalesce(policy."Seat", 0) as "car_seat",
    coalesce(policy."Wg", 0) as "car_weight",
    policy."Owner_citizen_id"::text,
    insurverse.fn_display_buddha_date (policy."Owner_birth_date" + interval '7 HOUR')::text as "Owner_birth_date",
    TO_CHAR(policy."Owner_birth_date" + interval '7 HOUR', 'dd/mm/yyyy')::text as "Owner_birth_date_en",
    policy."Owner_prefix_name"::text,
    null::text as "owner_prefix_name_en",
    policy."Owner_address"::text,
    null::text as "owner_address_en",
    owner_subd."sdname"::text as "owner_subdistrict",
    null::text as "owner_subdistrict_en",
    owner_dis."diname"::text as "owner_district",
    null::text as "owner_district_en",
    owner_prov."prname"::text as "owner_province",
    null::text as "owner_province_en",
    policy."Owner_zipcode"::text,
    policy."email"::text as "user_email",
    "user"."mobile"::text as "user_mobile",
    policy."Par_prefix_name_1"::text as "par_1_prefix_name",
    policy."Par_first_name_1"::text as "par_1_first_name",
    policy."Par_last_name_1"::text as "par_1_last_name",
    insurverse.fn_display_buddha_date (policy."Par_birth_date_1" + interval '7 HOUR')::text as "par_1_birth_date",
    policy."Par_Driver_license_no_1"::text as "par_1_driver_license",
    policy."Par_citizen_id_1"::text as "par_1_citizen",
    policy."Par_prefix_name_2"::text as "par_2_prefix_name",
    policy."Par_first_name_2"::text as "par_2_first_name",
    policy."Par_last_name_2"::text as "par_2_last_name",
    insurverse.fn_display_buddha_date (policy."Par_birth_date_2" + interval '7 HOUR')::text as "par_2_birth_date",
    policy."Par_Driver_license_no_2"::text as "par_2_driver_license",
    policy."Par_citizen_id_2"::text as "par_2_citizen",
    coalesce(policy."Bene_Type", 'person')::text as "bene_type",
    policy."Bene_Firstname"::text as "bene_first_name",
    policy."Bene_Lastname"::text as "bene_last_name",
    null::text as "bene_ta_detail",
    policy."Flag_Deli"::text as "deli_flag",
    policy."Deli_Addr_line1"::text as "deli_addr_1",
    deli_subd."sdname"::text as "deli_subdistrict",
    deli_dis."diname"::text as "deli_district",
    deli_prov."prname"::text as "deli_province",
    policy."Deli_zipcode"::text as "deli_zipcode",
    policy."GarageType"::varchar as "garage_type",
    coalesce(prem."SI_Limit", 0)::numeric as "si_limit",
    coalesce(prem."SI_Access_Limit", 0)::numeric as "si_access_limit",
    coalesce(prem."SI_TPPD_Limit", 0)::numeric as "si_tppd_limit",
    coalesce(prem."SI_TPBI_Limit", 0)::numeric as "si_tpbi_limit",
    coalesce(prem."SI_MV01_Limit", 0)::numeric as "si_mv01_limit",
    coalesce(prem."SI_MV02_Limit", 0)::numeric as "si_mv02_limit",
    coalesce(prem."SI_MV03_Limit", 0)::numeric as "si_mv03_limit",
    null::varchar as "car_comp_code",
    null::integer as "coverinjury",
    null::integer as "coverdeath",
    null::integer as "coveracc",
    prem."Access_para_code"::varchar as "Access_para_code",
    edj.endorsement_list,
    null::text as "package_name",
    null::text as "ta_coverage_list",
    null::text as "ta_country_name_th",
    null::text as "ta_country_name_en",
    null::text as "owner_card_type",
    policy."email"::text as "owner_email",
    null::text as "owner_mobile",
    null::text as "Policy_Pa_No",
    null::text as "bene_pa_detail",
    policy."Bene_Title"::text as "bene_title",
    null::text as "pa_coverage_list",
    case
        when ("policy"."Policy_Status" != 'ACT') then 'cancel'
        when (LOWER("policy"."Car_Inspect_Status") = 'access_modify') then 'wait_add_access'
        when ("policy"."Type" = '1'
            and coalesce(rdj.noti_renewal_flag, false) = false
                and ("policy"."Car_Inspect_Status" is null
                    or LOWER("policy"."Car_Inspect_Status")!= 'success')) then 'wait_inspect'
        -- [CR21 P2-3] Sprint Cut-off date: Allow renewal policy with in  23:59:59 GMT + 7.00 
        -- Normally Endate 09:30 UTC --> Strip time --> + 1 days - 7 Hrs --> 17.00 UTC
        when (cast(now()+ interval '7HOUR' as TIMESTAMP) between cast("policy"."Policy_Startdate" + interval '7HOUR' as TIMESTAMP) and (cast(date_trunc('day', "policy"."Policy_Enddate" + interval '7HOUR') as TIMESTAMP) + interval '24 hours')) then 'insured_active'
        when (cast(now()+ interval '7HOUR' as TIMESTAMP) < cast("policy"."Policy_Startdate" + interval '7HOUR' as TIMESTAMP)) then 'insured_wait'
        when (cast(now()+ interval '7HOUR' as TIMESTAMP) > (cast(date_trunc('day', "policy"."Policy_Enddate" + interval '7HOUR') as TIMESTAMP) + interval '24 hours')) then 'expired'
        else 'other'
    end as "policy_directory",
    null::text as "tax_deductions_url_ref",
    elsj.endorse_last_status,
    false as "tax_deductions",
    policy."Owner_subdistrict_id" as "owner_subdistrict_id",
    policy."Owner_district_id" as "owner_district_id",
    policy."Owner_province_id" as "owner_province_id",
    policy."Deli_subdistrict_id" as "deli_subdistrict_id",
    policy."Deli_district_id" as "deli_district_id",
    policy."Deli_province_id" as "deli_province_id",
    null::text as "tax_deductions_date_th",
    null::text as "tax_deductions_date_en",
    null::text as "Policy_Home_No",
    null::text as "home_coverage",
    null::text as "bene_home_detail",
    policy."Policy_url_ref"::text,
    policy."Receipt_url_ref"::text,
    null::text as "tax_deductions_url_copy_ref",
    (mclaims.policy_number is not null) as "claim_status_flag",
    cast(
			json_build_object(
				'cctv_flag',
				prem."Flag_CCTV",
				'cctv_disc_per',
				prem."CCTV",
				'access_flag',
				coalesce(prem."Flag_Access", 'N'),
				'extend_startdate_th',
				insurverse.fn_display_buddha_date (policy."Extend_Start" + interval '7 HOUR'),
				'extend_startdate_en',
				TO_CHAR(policy."Extend_Start" + interval '7 HOUR', 'dd/mm/yyyy'),
				'extend_enddate_th',
				insurverse.fn_display_buddha_date (policy."Extend_End" + interval '7 HOUR'),
				'extend_enddate_en',
				TO_CHAR(policy."Extend_End" + interval '7 HOUR', 'dd/mm/yyyy'),
				'extend_amt',
				prem."extend_amt"
			) as TEXT
		) as "motor_detail",
    rdj.renewal_detail,
    null::text as "ta_package_list",
    null::text as "ta_policy_detail",
    cast(policy."partner_code" as TEXT) as "partner_code",
    cast((select json_build_object(
						'partner_code', "policy"."partner_code",
						'partner_name_th', case when "policy"."partner_code" is not null then (select partner_name_th from insurverse.mas_partner where mas_partner.partner_code = "policy"."partner_code") else null end,
						'partner_name_en', case when "policy"."partner_code" is not null then (select partner_name_en from insurverse.mas_partner where mas_partner.partner_code = "policy"."partner_code") else null end
				)) as TEXT) as "partner_detail",
    --CR21
    --ผู้ขับขี่ 3-5
	"policy"."par_prefix_name_3"::text as "par_3_prefix_name",
    "policy"."par_first_name_3"::text as "par_3_first_name",
    "policy"."par_last_name_3"::text as "par_3_last_name",
    insurverse.fn_display_buddha_date (policy."par_birth_date_3" + interval '7 HOUR')::text as "par_3_birth_date",
    "policy"."par_driver_license_no_3"::text as "par_3_driver_license",
    "policy"."par_citizen_id_3"::text as "par_3_citizen",
    "policy"."par_prefix_name_4"::text as "par_4_prefix_name",
    "policy"."par_first_name_4"::text as "par_4_first_name",
    "policy"."par_last_name_4"::text as "par_4_last_name",
    insurverse.fn_display_buddha_date (policy."par_birth_date_4" + interval '7 HOUR')::text as "par_4_birth_date",
    "policy"."par_driver_license_no_4"::text as "par_4_driver_license",
    "policy"."par_citizen_id_4"::text as "par_4_citizen",
    "policy"."par_prefix_name_5"::text as "par_5_prefix_name",
    "policy"."par_first_name_5"::text as "par_5_first_name",
    "policy"."par_last_name_5"::text as "par_5_last_name",
    insurverse.fn_display_buddha_date (policy."par_birth_date_5" + interval '7 HOUR')::text as "par_5_birth_date",
    "policy"."par_driver_license_no_5"::text as "par_5_driver_license",
    "policy"."par_citizen_id_5"::text as "par_5_citizen",
    "policy"."Owner_occupation" as owner_occupation,
    cast(null as text) as "owner_occupation_code",
    "policy".prem_version::integer,
    "policy".oic_version::text,
    "policy".bene_occupation::text,
    "policy".bene_occupation_code:: text,
    "policy"."Par_occupation_1" as "par_1_occupation",
    "policy".driver_behavior_1::integer as "par_1_driver_behavior" ,
    "policy"."Par_occupation_2" as "par_2_occupation",
    "policy".driver_behavior_2::integer as "par_2_driver_behavior" ,
    "policy".par_occupation_3 as "par_3_occupation",
    "policy".driver_behavior_3::integer as "par_3_driver_behavior" ,
    "policy".par_occupation_4 as "par_4_occupation",
    "policy".driver_behavior_4::integer as "par_4_driver_behavior" ,
    "policy".par_occupation_5 as "par_5_occupation",
    "policy".par_occupation_code_1 as "par_1_occupation_code",
    "policy".par_occupation_code_2 as "par_2_occupation_code",
    "policy".par_occupation_code_3 as "par_3_occupation_code",
    "policy".par_occupation_code_4 as "par_4_occupation_code",
    "policy".par_occupation_code_5 as "par_5_occupation_code",
    "policy".driver_behavior_5::integer as "par_5_driver_behavior" ,
    "policy".driver_behavior_consent_1::boolean,
    "policy".driver_behavior_consent_2::boolean,
    "policy".driver_behavior_consent_3::boolean,
    "policy".driver_behavior_consent_4::boolean,
    "policy".driver_behavior_consent_5::boolean,
    -- [PLACEHOLDERS FOR NEW FIELDS]
    null::text as customer_id,
    null::integer as hp,
    null::text as "engineType",
    policy."par_driver_license_category_1"::text as par_1_driver_license_category,
    policy."par_driver_license_category_2"::text as par_2_driver_license_category,
    policy."par_driver_license_category_3"::text as par_3_driver_license_category,
    policy."par_driver_license_category_4"::text as par_4_driver_license_category,
    policy."par_driver_license_category_5"::text as par_5_driver_license_category
from
    user_motor_policies as "policy"
inner join insurverse."Policy_coverage_premium" as prem on
    "policy"."Policy_No" = prem."Policy_No"
inner join insurverse."province" as car_prov on
    cast("policy"."Car_license_provice" as INT) = car_prov.provinceid
inner join insurverse."mas_cmi_color" as "color" on
    "policy"."Car_color" = "color"."color_id"
inner join insurverse.sec_user as "user" on
    "policy"."email" = "user"."email"
inner join insurverse.subdistrict as "owner_subd" on
    "policy"."Owner_subdistrict_id" = "owner_subd"."subdistrictid"
inner join insurverse.district as "owner_dis" on
    "policy"."Owner_district_id" = "owner_dis"."districtid"
inner join insurverse.province as "owner_prov" on
    "policy"."Owner_province_id" = "owner_prov"."provinceid"
left join insurverse.subdistrict as "deli_subd" on
    "policy"."Deli_subdistrict_id" = "deli_subd"."subdistrictid"
left join insurverse.district as "deli_dis" on
    "policy"."Deli_district_id" = "deli_dis"."districtid"
left join insurverse.province as "deli_prov" on
    "policy"."Deli_province_id" = "deli_prov"."provinceid"
left join insurverse.mas_partner as partner on
    "policy".partner_code = partner.partner_code
left join mv_renewal_details_json rdj on
    policy."Policy_No" = rdj."Policy_No"
left join endorsement_details_json edj on
    policy."Policy_No" = edj.policy_key
left join endorse_last_status_mv_json elsj on
    policy."Policy_No" = elsj.policy_key
left join motor_claims mclaims on
    policy."Policy_No" = mclaims.policy_number
    ),
    
    
    act_policies as (
select
    3 as "priority",
    "policy"."Brand"::varchar,
    "policy"."Model"::varchar,
    "policy"."Year"::varchar,
    "policy"."Car_license_no"::text,
    '0'::varchar,
    0 as "SI",
    "policy"."first_name"::text,
    null::text,
    "policy"."last_name"::text,
    null::text,
    case
        when "policy"."Policy_No" is not null
            and cast("policy"."Start_date" as DATE) = (
            select
                cast(ph."Policy_Startdate" as DATE)
            from
                insurverse."Policy_Header" ph
            where
                ph."Policy_No" = "policy"."Policy_No"
			) then "policy"."Policy_No"
            else null
        end::text as "Policy_No",
        null::text as "Policy_Ta_No",
        "policy"."Car_Act_No"::text,
        insurverse.fn_display_buddha_date ("policy"."Start_date" + interval '7 HOUR')::text as "Policy_Startdate",
        TO_CHAR("policy"."Start_date" + interval '7 HOUR', 'dd/mm/yyyy')::text as "Policy_Startdate_en",
        insurverse.fn_display_buddha_date ("policy"."End_date" + interval '7 HOUR')::text as "Policy_Enddate",
        TO_CHAR("policy"."End_date" + interval '7 HOUR', 'dd/mm/yyyy')::text as "Policy_Enddate_en",
        "policy"."Start_date" as "policy_startdate_sort",
        car_prov.prname::text as "Car_license_provice",
        "policy"."Policy_url_copy_ref"::text,
        "policy"."Receipt_url_copy_ref"::text,
        insurverse.fn_display_buddha_date ("policy"."Create_date" + interval '7 HOUR')::text as "policy_date",
        TO_CHAR("policy"."Create_date" + interval '7 HOUR', 'dd/mm/yyyy')::text as "policy_date_en",
        'success'::text as "Car_Inspect_Status",
        cast("policy"."Lead_No" as integer) as "Lead_No",
        cast("policy"."Car_Act_Lead_No" as integer) as "Car_Act_Lead_No",
        coalesce("policy"."Policy_Status", 'ACT')::text as "policy_status",
        insurverse.fn_display_buddha_date ("policy"."Payment_date" + interval '7 HOUR')::text as "payment_date",
        "policy"."Car_serial_no"::text,
        "policy"."Car_license_type"::text,
        color.color_name_th::text as "car_color",
        "policy"."CC"::text as "car_cc",
        coalesce("policy"."Seat", 0) as "car_seat",
        coalesce("policy"."Wg", 0) as "car_weight",
        "policy"."citizen_id"::text as "owner_citizen_id",
        insurverse.fn_display_buddha_date ("policy"."birth_date" + interval '7 HOUR')::text as "Owner_birth_date",
        TO_CHAR("policy"."birth_date" + interval '7 HOUR', 'dd/mm/yyyy')::text as "Owner_birth_date_en",
        "policy"."prefix_name"::text as "owner_prefix_name",
        null::text as "owner_prefix_name_en",
        "policy"."address"::text as "owner_address",
        null::text as "owner_address_en",
        owner_subd.sdname::text as "owner_subdistrict",
        null::text as "owner_subdistrict_en",
        owner_dis.diname::text as "owner_district",
        null::text as "owner_district_en",
        owner_prov.prname::text as "owner_province",
        null::text as "owner_province_en",
        "policy"."zipcode"::text as "owner_zipcode",
        "policy"."email"::text as user_email,
        "user"."mobile"::text as "user_mobile",
        null::text as "par_1_prefix_name",
        null::text as "par_1_first_name",
        null::text as "par_1_last_name",
        null::text as "par_1_birth_date",
        null::text as "par_1_driver_license",
        null::text as "par_1_citizen",
        null::text as "par_2_prefix_name",
        null::text as "par_2_first_name",
        null::text as "par_2_last_name",
        null::text as "par_2_birth_date",
        null::text as "par_2_driver_license",
        null::text as "par_2_citizen",
        coalesce("policy"."Bene_Type", 'person')::text as "bene_type",
        "policy"."Bene_Firstname"::text as "bene_first_name",
        "policy"."Bene_Lastname"::text as "bene_last_name",
        null::text as "bene_ta_detail",
        "policy"."Flag_Deli"::text as "deli_flag",
        "policy"."Deli_Addr_line1"::text as "deli_addr_1",
        deli_subd.sdname::text as "deli_subdistrict",
        deli_dis.diname::text as "deli_district",
        deli_prov.prname::text as "deli_province",
        "policy"."Deli_zipcode"::text as "deli_zipcode",
        null::varchar as "garage_type",
        null::numeric as "si_limit",
        null::numeric as "si_access_limit",
        null::numeric as "si_tppd_limit",
        null::numeric as "si_tpbi_limit",
        null::numeric as "si_mv01_limit",
        null::numeric as "si_mv02_limit",
        null::numeric as "si_mv03_limit",
        "policy"."Car_Comp_Code"::varchar as "car_comp_code",
        case
            when "policy"."Car_Comp_Code" = '1.20A' then cast(spar.coverinjury_van as INT)
            else cast(spar.coverinjury as INT)
        end as "coverinjury",
        case
            when "policy"."Car_Comp_Code" = '1.20A' then cast(spar.coverdeath_van as INT)
            else cast(spar.coverdeath as INT)
        end as "coverdeath",
        case
            when "policy"."Car_Comp_Code" = '1.20A' then cast(spar.coveracc_van as INT)
            else cast(spar.coveracc as INT)
        end as "coveracc",
        null::varchar as "Access_para_code",
        edj.endorsement_list,
        null::text as "package_name",
        null::text as "ta_coverage_list",
        null::text as "ta_country_name_th",
        null::text as "ta_country_name_en",
        null::text as "owner_card_type",
        "policy"."email"::text as "owner_email",
        null::text as "owner_mobile",
        null::text as "Policy_Pa_No",
        null::text as "bene_pa_detail",
        "policy"."Bene_Title"::text as "bene_title",
        null::text as "pa_coverage_list",
        case
            when ("policy"."Policy_Status" != 'ACT') then 'cancel'
            -- [CR21 P2-3] Sprint Cut-off date: Allow renewal policy with in  23:59:59 GMT + 7.00 
            -- Normally Endate 09:30 UTC --> Strip time --> + 1 days - 7 Hrs --> 17.00 UTC
            when (cast(now()+ interval '7HOUR' as TIMESTAMP) between cast("policy"."Start_date" + interval '7HOUR' as TIMESTAMP) and (cast(date_trunc('day', "policy"."End_date" + interval '7HOUR') as TIMESTAMP) + interval '24 hours')) then 'insured_active'
            when (cast(now()+ interval '7HOUR' as TIMESTAMP) < cast("policy"."Start_date" + interval '7HOUR' as TIMESTAMP)) then 'insured_wait'
            when (cast(now()+ interval '7HOUR' as TIMESTAMP) > (cast(date_trunc('day', "policy"."End_date" + interval '7HOUR') as TIMESTAMP) + interval '24 hours')) then 'expired'
            else 'other'
        end as "policy_directory",
        null::text as "tax_deductions_url_ref",
        elsj.endorse_last_status,
        false as "tax_deductions",
        "policy"."subdistrict_id" as "owner_subdistrict_id",
        "policy"."district_id" as "owner_district_id",
        "policy"."province_id" as "owner_province_id",
        "policy"."Deli_subdistrict_id" as "deli_subdistrict_id",
        "policy"."Deli_district_id" as "deli_district_id",
        "policy"."Deli_province_id" as "deli_province_id",
        null::text as "tax_deductions_date_th",
        null::text as "tax_deductions_date_en",
        null::text as "Policy_Home_No",
        null::text as "home_coverage",
        null::text as "bene_home_detail",
        "policy"."Policy_url_ref"::text,
        "policy"."Receipt_url_ref"::text,
        null::text as "tax_deductions_url_copy_ref",
        (aclaims.car_act_no is not null) as "claim_status_flag",
        cast((select json_build_object(
            'cctv_flag', 'N',
            'cctv_disc_per', 0,
            'access_flag', 'N',
            'extend_startdate_th', insurverse.fn_display_buddha_date("policy"."Extend_Start" + interval '7 HOUR'),
            'extend_startdate_en', TO_CHAR("policy"."Extend_Start" + interval '7 HOUR', 'dd/mm/yyyy'),
            'extend_enddate_th', insurverse.fn_display_buddha_date("policy"."Extend_End" + interval '7 HOUR'),
            'extend_enddate_en', TO_CHAR("policy"."Extend_End" + interval '7 HOUR', 'dd/mm/yyyy'),
            'extend_amt', "policy"."extend_amt"
        )) as TEXT) as "motor_detail",
        rvj.renewal_detail as "renewal_detail",
        null::text as "ta_package_list",
        null::text as "ta_policy_detail",
        cast("policy"."partner_code" as TEXT) as "partner_code",
        cast((select json_build_object(
						'partner_code', "policy"."partner_code",
						'partner_name_th', case when "policy"."partner_code" is not null then (select partner_name_th from insurverse.mas_partner where mas_partner.partner_code = "policy"."partner_code") else null end,
						'partner_name_en', case when "policy"."partner_code" is not null then (select partner_name_en from insurverse.mas_partner where mas_partner.partner_code = "policy"."partner_code") else null end
				)) as TEXT) as "partner_detail",
        --CR21
        --ผู้ขับขี่ 3-5
		cast(null as text) as "par_3_prefix_name",
        cast(null as text) as "par_3_first_name",
        cast(null as text) as "par_3_last_name",
        cast(null as text) as "par_3_birth_date",
        cast(null as text) as "par_3_driver_license",
        cast(null as text) as "par_3_citizen",
        cast(null as text) as "par_4_prefix_name",
        cast(null as text) as "par_4_first_name",
        cast(null as text) as "par_4_last_name",
        cast(null as text) as "par_4_birth_date",
        cast(null as text) as "par_4_driver_license",
        cast(null as text) as "par_4_citizen",
        cast(null as text) as "par_5_prefix_name",
        cast(null as text) as "par_5_first_name",
        cast(null as text) as "par_5_last_name",
        cast(null as text) as "par_5_birth_date",
        cast(null as text) as "par_5_driver_license",
        cast(null as text) as "par_5_citizen",
        "policy"."Occupation" as "owner_occupation",
        "policy"."occupation_code" as "owner_occupation_code",
        cast(null as integer) as "prem_version",
        coalesce("policy"."oic_version", ph."oic_version") as "oic_version",
        cast(null as text) as "bene_occupation",
        cast(null as text) as "bene_occupation_code",
        cast(null as text) as "par_1_occupation",
        cast(null as integer) as "par_1_driver_behavior",
        cast(null as text) as "par_2_occupation",
        cast(null as integer) as "par_2_driver_behavior",
        cast(null as text) as "par_3_occupation",
        cast(null as integer) as "par_3_driver_behavior",
        cast(null as text) as "par_4_occupation",
        cast(null as integer) as "par_4_driver_behavior",
        cast(null as text) as "par_5_occupation",
        cast(null as text) as "par_1_occupation_code",
        cast(null as text) as "par_2_occupation_code",
        cast(null as text) as "par_3_occupation_code",
        cast(null as text) as "par_4_occupation_code",
        cast(null as text) as "par_5_occupation_code",
        cast(null as integer) as "par_5_driver_behavior",
        cast(null as boolean) as "driver_behavior_consent_1",
        cast(null as boolean) as "driver_behavior_consent_2",
        cast(null as boolean) as "driver_behavior_consent_3",
        cast(null as boolean) as "driver_behavior_consent_4",
        cast(null as boolean) as "driver_behavior_consent_5",
        "policy"."customer_id"::text as customer_id,
        "policy"."hp"::integer as hp,
        "policy"."engineType"::text as "engineType",
        null::text as par_1_driver_license_category,
        null::text as par_2_driver_license_category,
        null::text as par_3_driver_license_category,
        null::text as par_4_driver_license_category,
        null::text as par_5_driver_license_category
    from
        user_act_policies as "policy"
    join car_act_params as spar on
        1 = 1
    inner join insurverse."province" as car_prov on
        cast("policy"."Car_license_provice" as INT) = car_prov.provinceid
    inner join insurverse."mas_cmi_color" as color on
        "policy"."Car_color" = color."color_id"
    inner join insurverse.sec_user as "user" on
        "policy"."email" = "user"."email"
    inner join insurverse.subdistrict as owner_subd on
        "policy"."subdistrict_id" = owner_subd.subdistrictid
    inner join insurverse.district as owner_dis on
        "policy"."district_id" = owner_dis.districtid
    inner join insurverse.province as owner_prov on
        "policy"."province_id" = owner_prov.provinceid
    left join insurverse.subdistrict as deli_subd on
        "policy"."Deli_subdistrict_id" = deli_subd.subdistrictid
    left join insurverse.district as deli_dis on
        "policy"."Deli_district_id" = deli_dis.districtid
    left join insurverse.province as deli_prov on
        "policy"."Deli_province_id" = deli_prov.provinceid
    left join insurverse.mas_partner as partner on
        "policy".partner_code = partner.partner_code
    left join mc_renewal_details_json as rvj on
        "policy"."Car_Act_No" = rvj.car_act_no
    left join endorsement_details_json edj on
        policy."Car_Act_No" = edj.policy_key
    left join endorse_last_status_mc_json elsj on
        policy."Car_Act_No" = elsj.policy_key
    left join act_claims aclaims on
        policy."Car_Act_No" = aclaims.car_act_no
    left join insurverse."Policy_Header" ph on
        "policy"."Policy_No" = ph."Policy_No"
    ),
    
    ta_policies as (
select
    3 as "priority",
    null::varchar,
    null::varchar,
    null::varchar,
    null::text,
    'ta'::varchar,
    0,
    par.owner_firstname_th::text,
    par.owner_firstname_en::text,
    par.owner_lastname_th::text,
    par.owner_lastname_en::text,
    null::text as "Policy_No",
    policy.policy_ta_no::text as "Policy_Ta_No",
    null::text as "Car_Act_No",
    insurverse.fn_display_buddha_date(policy.policy_startdate + interval '7 HOUR')::text,
    TO_CHAR(policy.policy_startdate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    insurverse.fn_display_buddha_date(policy.policy_enddate + interval '7 HOUR')::text,
    TO_CHAR(policy.policy_enddate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    policy.policy_startdate,
    null::text,
    policy.policy_url_copy_ref::text,
    policy.receipt_url_ref::text,
    insurverse.fn_display_buddha_date(policy.create_date + interval '7 HOUR')::text,
    TO_CHAR(policy.create_date + interval '7 HOUR', 'dd/mm/yyyy')::text,
    null::text,
    null::integer,
    null::integer,
    coalesce(policy.policy_status, 'ACT')::text,
    insurverse.fn_display_buddha_date(policy.payment_date + interval '7 HOUR')::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::integer,
    null::integer,
    par.owner_card_id::text,
    insurverse.fn_display_buddha_date(par.owner_birthdate + interval '7 HOUR')::text,
    TO_CHAR(par.owner_birthdate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    par.owner_title_th::text,
    par.owner_title_en::text,
    par.owner_address_th::text,
    par.owner_address_en::text,
    owner_subd.sdname::text,
    owner_subd.sdnameen::text,
    owner_dis.diname::text,
    owner_dis.dinameen::text,
    owner_prov.prname::text,
    owner_prov.prnameen::text,
    par.owner_zipcode::text,
    policy.email::text,
    "user".mobile::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    tbdj.bene_ta_detail,
    'N'::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::varchar,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::varchar,
    null::integer,
    null::integer,
    null::integer,
    null::varchar,
    null::text,
    pack.package_name_en::text,
    tcj.ta_coverage_list,
    insurverse.fn_display_country_th(policy.country_id_array)::text,
    insurverse.fn_display_country(policy.country_id_array)::text,
    par.owner_card_type::text,
    par.owner_email::text,
    par.owner_phone::text,
    null::text,
    null::text,
    null::text,
    null::text,
    case
        when ("policy"."policy_status" != 'ACT') then 'cancel'
        when (cast(now()+ interval '7HOUR' as DATE) between cast("policy"."policy_startdate" + interval '7HOUR' as DATE) and cast("policy"."policy_enddate" + interval '7HOUR' as DATE)) then 'insured_active'
        when (cast(now()+ interval '7HOUR' as DATE) < cast("policy"."policy_startdate" + interval '7HOUR' as DATE)) then 'insured_wait'
        when (cast(now()+ interval '7HOUR' as DATE) > cast("policy"."policy_enddate" + interval '7HOUR' as DATE)) then 'expired'
        else 'other'
    end as "policy_directory",
    null::text,
    telsj.endorse_last_status,
    false,
    par.owner_subdistrict_id,
    par.owner_district_id,
    par.owner_province_id,
    0,
    0,
    0,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    policy.policy_url_ref::text,
    policy.receipt_url_ref::text,
    null::text,
    false,
    null::text,
    null::text,
    tplj.ta_package_list,
    cast(json_build_object(
                'ta_travel_type_id', policy.ta_travel_type_id,
                'ta_travel_type_name', travel_type.mas_name_th,
                'flag_ref_info_buyer', par.flag_ref_info_buyer,
                'flag_ref_email_buyer', par.flag_ref_email_buyer
            ) as TEXT),
    policy.partner_code::text,
    cast(json_build_object('partner_code', policy.partner_code, 'partner_name_th', partner.partner_name_th, 'partner_name_en', partner.partner_name_en) as TEXT),
    --CR21
    --ผู้ขับขี่ 3-5
		cast(null as text) as "par_3_prefix_name",
    cast(null as text) as "par_3_first_name",
    cast(null as text) as "par_3_last_name",
    cast(null as text) as "par_3_birth_date",
    cast(null as text) as "par_3_driver_license",
    cast(null as text) as "par_3_citizen",
    cast(null as text) as "par_4_prefix_name",
    cast(null as text) as "par_4_first_name",
    cast(null as text) as "par_4_last_name",
    cast(null as text) as "par_4_birth_date",
    cast(null as text) as "par_4_driver_license",
    cast(null as text) as "par_4_citizen",
    cast(null as text) as "par_5_prefix_name",
    cast(null as text) as "par_5_first_name",
    cast(null as text) as "par_5_last_name",
    cast(null as text) as "par_5_birth_date",
    cast(null as text) as "par_5_driver_license",
    cast(null as text) as "par_5_citizen",
    cast(null as text) as "owner_occupation",
    cast(null as text) as "owner_occupation_code",
    cast(null as integer) as "prem_version",
    cast(null as text) as "oic_version",
    cast(null as text) as "bene_occupation",
    cast(null as text) as "bene_occupation_code",
    cast(null as text) as "par_1_occupation",
    cast(null as integer) as "par_1_driver_behavior",
    cast(null as text) as "par_2_occupation",
    cast(null as integer) as "par_2_driver_behavior",
    cast(null as text) as "par_3_occupation",
    cast(null as integer) as "par_3_driver_behavior",
    cast(null as text) as "par_4_occupation",
    cast(null as integer) as "par_4_driver_behavior",
    cast(null as text) as "par_5_occupation",
    cast(null as text) as "par_1_occupation_code",
    cast(null as text) as "par_2_occupation_code",
    cast(null as text) as "par_3_occupation_code",
    cast(null as text) as "par_4_occupation_code",
    cast(null as text) as "par_5_occupation_code",
    cast(null as integer) as "par_5_driver_behavior",
    cast(null as boolean) as "driver_behavior_consent_1",
    cast(null as boolean) as "driver_behavior_consent_2",
    cast(null as boolean) as "driver_behavior_consent_3",
    cast(null as boolean) as "driver_behavior_consent_4",
    cast(null as boolean) as "driver_behavior_consent_5",
    -- [PLACEHOLDERS FOR NEW FIELDS]
        null::text as customer_id,
        null::integer as hp,
        null::text as "engineType",
        null::text as par_1_driver_license_category,
        null::text as par_2_driver_license_category,
        null::text as par_3_driver_license_category,
        null::text as par_4_driver_license_category,
        null::text as par_5_driver_license_category
from
    user_ta_policies as policy
join insurverse.lead_ta_participant as par on
    policy.policy_ta_no = par.policy_ta_no
join insurverse.sec_user as "user" on
    policy.email = "user".email
inner join insurverse.mas_ta_package as pack on
    policy.ta_package_id = pack.ta_package_id
inner join insurverse.subdistrict as owner_subd on
    par.owner_subdistrict_id = owner_subd.subdistrictid
inner join insurverse.district as owner_dis on
    par.owner_district_id = owner_dis.districtid
inner join insurverse.province as owner_prov on
    par.owner_province_id = owner_prov.provinceid
left join insurverse.mas_partner as partner on
    policy.partner_code = partner.partner_code
left join insurverse.mas_ta_travel_type as travel_type on
    policy.ta_travel_type_id = travel_type.ta_travel_type_id
left join ta_coverage_json as tcj on
    pack.ta_package_id = tcj.ta_package_id
left join ta_package_list_json as tplj on
    policy.policy_ta_no = tplj.policy_ta_no
left join ta_bene_detail_json as tbdj on
    policy.policy_ta_no = tbdj.policy_ta_no
left join ta_endorse_last_status_json as telsj on
    policy.policy_ta_no = telsj.policy_key
    ),
    
    pa_policies as (
select
    3 as "priority",
    null::varchar,
    null::varchar,
    null::varchar,
    null::text,
    'pa'::varchar,
    0,
    par.owner_firstname_th::text,
    par.owner_firstname_en::text,
    par.owner_lastname_th::text,
    par.owner_lastname_en::text,
    null::text as "Policy_No",
    null::text,
    null::text as "Car_Act_No",
    insurverse.fn_display_buddha_date(policy.policy_startdate + interval '7 HOUR')::text,
    TO_CHAR(policy.policy_startdate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    insurverse.fn_display_buddha_date(policy.policy_enddate + interval '7 HOUR')::text,
    TO_CHAR(policy.policy_enddate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    policy.policy_startdate,
    null::text,
    policy.policy_url_copy_ref::text,
    policy.receipt_url_ref::text,
    insurverse.fn_display_buddha_date(policy.create_date + interval '7 HOUR')::text,
    TO_CHAR(policy.create_date + interval '7 HOUR', 'dd/mm/yyyy')::text,
    null::text,
    null::integer,
    null::integer,
    coalesce(policy.policy_status, 'ACT')::text,
    insurverse.fn_display_buddha_date(policy.payment_date + interval '7 HOUR')::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::integer,
    null::integer,
    par.owner_card_id::text,
    insurverse.fn_display_buddha_date(par.owner_birthdate + interval '7 HOUR')::text,
    TO_CHAR(par.owner_birthdate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    par.owner_title_th::text,
    par.owner_title_en::text,
    par.owner_address_th::text,
    par.owner_address_en::text,
    owner_subd.sdname::text,
    owner_subd.sdnameen::text,
    owner_dis.diname::text,
    owner_dis.dinameen::text,
    owner_prov.prname::text,
    owner_prov.prnameen::text,
    par.owner_zipcode::text,
    policy.email::text,
    "user".mobile::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text as "bene_ta_detail",
    case
        when policy.deli_flag = true then 'Y'
        else 'N'
    end::text,
    case
        when policy.deli_flag = true then policy.deli_address_th
        else null
    end::text,
    case
        when policy.deli_flag = true then deli_subd.sdname
        else null
    end::text ,
    case
        when policy.deli_flag = true then deli_dis.diname
        else null
    end::text ,
    case
        when policy.deli_flag = true then deli_prov.prname
        else null
    end::text ,
    case
        when policy.deli_flag = true then policy.deli_zipcode
        else null
    end::text,
    null::varchar,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::varchar,
    null::integer,
    null::integer,
    null::integer,
    null::varchar,
    null::text,
    -- endorsement_list placeholder
    pack.package_name_th::text,
    null::text,
    null::text,
    null::text,
    -- ta coverage placeholders
    par.owner_card_type::text,
    par.owner_email::text,
    par.owner_phone::text,
    policy.policy_pa_no::text,
    pbdj.bene_pa_detail,
    -- bene_pa_detail
            null::text as "bene_title",
    pcj.pa_coverage_list,
    case
        when ("policy"."policy_status" != 'ACT') then 'cancel'
        when (cast(now()+ interval '7HOUR' as DATE) between cast("policy"."policy_startdate" + interval '7HOUR' as DATE) and cast("policy"."policy_enddate" + interval '7HOUR' as DATE)) then 'insured_active'
        when (cast(now()+ interval '7HOUR' as DATE) < cast("policy"."policy_startdate" + interval '7HOUR' as DATE)) then 'insured_wait'
        when (cast(now()+ interval '7HOUR' as DATE) > cast("policy"."policy_enddate" + interval '7HOUR' as DATE)) then 'expired'
        else 'other'
    end as "policy_directory",
    policy.tax_deductions_url_ref::text,
    pesj.endorse_last_status,
    policy.tax_deductions,
    par.owner_subdistrict_id,
    par.owner_district_id,
    par.owner_province_id,
    case
        when policy.deli_flag = true then policy.deli_subdistrict_id
        else 0
    end,
    case
        when policy.deli_flag = true then policy.deli_district_id
        else 0
    end,
    case
        when policy.deli_flag = true then policy.deli_province_id
        else 0
    end,
    insurverse.fn_display_buddha_date (policy.tax_deductions_date + interval '7 HOUR')::text,
    TO_CHAR(policy.tax_deductions_date + interval '7 HOUR', 'dd/mm/yyyy')::text,
    null::text,
    null::text,
    null::text,
    policy.policy_url_ref::text,
    policy.receipt_url_ref::text,
    policy.tax_deductions_url_ref_copy::text,
    false,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    -- partner_code, partner_detail
    --CR21
    --ผู้ขับขี่ 3-5
		cast(null as text) as "par_3_prefix_name",
    cast(null as text) as "par_3_first_name",
    cast(null as text) as "par_3_last_name",
    cast(null as text) as "par_3_birth_date",
    cast(null as text) as "par_3_driver_license",
    cast(null as text) as "par_3_citizen",
    cast(null as text) as "par_4_prefix_name",
    cast(null as text) as "par_4_first_name",
    cast(null as text) as "par_4_last_name",
    cast(null as text) as "par_4_birth_date",
    cast(null as text) as "par_4_driver_license",
    cast(null as text) as "par_4_citizen",
    cast(null as text) as "par_5_prefix_name",
    cast(null as text) as "par_5_first_name",
    cast(null as text) as "par_5_last_name",
    cast(null as text) as "par_5_birth_date",
    cast(null as text) as "par_5_driver_license",
    cast(null as text) as "par_5_citizen",
    cast(null as text) as "owner_occupation",
    cast(null as text) as "owner_occupation_code",
    cast(null as integer) as "prem_version",
    cast(null as text) as "oic_version",
    cast(null as text) as "bene_occupation",
    cast(null as text) as "bene_occupation_code",
    cast(null as text) as "par_1_occupation",
    cast(null as integer) as "par_1_driver_behavior",
    cast(null as text) as "par_2_occupation",
    cast(null as integer) as "par_2_driver_behavior",
    cast(null as text) as "par_3_occupation",
    cast(null as integer) as "par_3_driver_behavior",
    cast(null as text) as "par_4_occupation",
    cast(null as integer) as "par_4_driver_behavior",
    cast(null as text) as "par_5_occupation",
        cast(null as text) as "par_1_occupation_code",
    cast(null as text) as "par_2_occupation_code",
    cast(null as text) as "par_3_occupation_code",
    cast(null as text) as "par_4_occupation_code",
    cast(null as text) as "par_5_occupation_code",
    cast(null as integer) as "par_5_driver_behavior",
    cast(null as boolean) as "driver_behavior_consent_1",
    cast(null as boolean) as "driver_behavior_consent_2",
    cast(null as boolean) as "driver_behavior_consent_3",
    cast(null as boolean) as "driver_behavior_consent_4",
    cast(null as boolean) as "driver_behavior_consent_5",
    -- [PLACEHOLDERS FOR NEW FIELDS]
        null::text as customer_id,
        null::integer as hp,
        null::text as "engineType",
        null::text as par_1_driver_license_category,
        null::text as par_2_driver_license_category,
        null::text as par_3_driver_license_category,
        null::text as par_4_driver_license_category,
        null::text as par_5_driver_license_category
from
    user_pa_policies as policy
join insurverse.lead_pa_participant as par on
    policy.policy_pa_no = par.policy_pa_no
join insurverse.sec_user as "user" on
    policy.user_id = "user".user_id
join insurverse.mas_pa_package as pack on
    policy.pa_package_id = pack.pa_package_id
left join insurverse.subdistrict as owner_subd on
    par.owner_subdistrict_id = owner_subd.subdistrictid
left join insurverse.district as owner_dis on
    par.owner_district_id = owner_dis.districtid
left join insurverse.province as owner_prov on
    par.owner_province_id = owner_prov.provinceid
left join insurverse.subdistrict as deli_subd on
    policy.deli_subdistrict_id = deli_subd.subdistrictid
left join insurverse.district as deli_dis on
    policy.deli_district_id = deli_dis.districtid
left join insurverse.province as deli_prov on
    policy.deli_province_id = deli_prov.provinceid
left join pa_coverage_json pcj on
    policy.policy_pa_no = pcj.policy_pa_no
left join pa_bene_detail_json pbdj on
    policy.policy_pa_no = pbdj.policy_pa_no
left join pa_endorse_last_status_json pesj on
    policy.policy_pa_no = pesj.policy_key
    ),
    
    home_policies as (
select
    3 as "priority",
    null::varchar,
    null::varchar,
    null::varchar,
    null::text,
    'home'::varchar,
    0,
    par.owner_firstname_th::text,
    par.owner_firstname_en::text,
    par.owner_lastname_th::text,
    par.owner_lastname_en::text,
    null::text,
    null::text,
    null::text,
    insurverse.fn_display_buddha_date(policy.policy_startdate + interval '7 HOUR')::text,
    TO_CHAR(policy.policy_startdate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    insurverse.fn_display_buddha_date(policy.policy_enddate + interval '7 HOUR')::text,
    TO_CHAR(policy.policy_enddate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    policy.policy_startdate,
    null::text,
    policy.policy_url_copy_ref::text,
    policy.receipt_url_ref::text,
    insurverse.fn_display_buddha_date(policy.create_date + interval '7 HOUR')::text,
    TO_CHAR(policy.create_date + interval '7 HOUR', 'dd/mm/yyyy')::text,
    null::text,
    null::integer,
    null::integer,
    coalesce(policy.policy_status, 'ACT')::text,
    insurverse.fn_display_buddha_date(policy.payment_date + interval '7 HOUR')::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::integer,
    null::integer,
    par.owner_card_id::text,
    insurverse.fn_display_buddha_date(par.owner_birthdate + interval '7 HOUR')::text,
    TO_CHAR(par.owner_birthdate + interval '7 HOUR', 'dd/mm/yyyy')::text,
    par.owner_title_th::text,
    par.owner_title_en::text,
    par.owner_address_th::text,
    par.owner_address_en::text,
    owner_subd.sdname::text,
    owner_subd.sdnameen::text,
    owner_dis.diname::text,
    owner_dis.dinameen::text,
    owner_prov.prname::text,
    owner_prov.prnameen::text,
    par.owner_zipcode::text,
    policy.email::text,
    "user".mobile::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text as "bene_ta_detail",
    case
        when policy.deli_flag = true then 'Y'
        else 'N'
    end::text,
    case
        when policy.deli_flag = true then policy.deli_address_th
        else null
    end::text,
    case
        when policy.deli_flag = true then deli_subd.sdname
        else null
    end::text,
    case
        when policy.deli_flag = true then deli_dis.diname
        else null
    end::text,
    case
        when policy.deli_flag = true then deli_prov.prname
        else null
    end::text,
    case
        when policy.deli_flag = true then policy.deli_zipcode
        else null
    end::text,
    null::varchar,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::numeric,
    null::varchar,
    null::integer,
    null::integer,
    null::integer,
    null::varchar,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    par.owner_card_type::text,
    par.owner_email::text,
    par.owner_phone::text,
    null::text,
    null::text,
    null::text,
    null::text,
    case
        when ("policy"."policy_status" != 'ACT') then 'cancel'
        when (cast(now()+ interval '7HOUR' as DATE) between cast("policy"."policy_startdate" + interval '7HOUR' as DATE) and cast("policy"."policy_enddate" + interval '7HOUR' as DATE)) then 'insured_active'
        when (cast(now()+ interval '7HOUR' as DATE) < cast("policy"."policy_startdate" + interval '7HOUR' as DATE)) then 'insured_wait'
        when (cast(now()+ interval '7HOUR' as DATE) > cast("policy"."policy_enddate" + interval '7HOUR' as DATE)) then 'expired'
        else 'other'
    end as "policy_directory",
    null::text,
    hesj.endorse_last_status,
    false,
    par.owner_subdistrict_id,
    par.owner_district_id,
    par.owner_province_id,
    case
        when policy.deli_flag = true then policy.deli_subdistrict_id
        else 0
    end,
    case
        when policy.deli_flag = true then policy.deli_district_id
        else 0
    end,
    case
        when policy.deli_flag = true then policy.deli_province_id
        else 0
    end,
    null::text,
    null::text,
    policy.policy_home_no::text,
    hcj.home_coverage,
    hbdj.bene_home_detail,
    policy.policy_url_ref::text,
    policy.receipt_url_ref::text,
    null::text,
    false,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    null::text,
    --CR21
    --ผู้ขับขี่ 3-5
		cast(null as text) as "par_3_prefix_name",
    cast(null as text) as "par_3_first_name",
    cast(null as text) as "par_3_last_name",
    cast(null as text) as "par_3_birth_date",
    cast(null as text) as "par_3_driver_license",
    cast(null as text) as "par_3_citizen",
    cast(null as text) as "par_4_prefix_name",
    cast(null as text) as "par_4_first_name",
    cast(null as text) as "par_4_last_name",
    cast(null as text) as "par_4_birth_date",
    cast(null as text) as "par_4_driver_license",
    cast(null as text) as "par_4_citizen",
    cast(null as text) as "par_5_prefix_name",
    cast(null as text) as "par_5_first_name",
    cast(null as text) as "par_5_last_name",
    cast(null as text) as "par_5_birth_date",
    cast(null as text) as "par_5_driver_license",
    cast(null as text) as "par_5_citizen",
    cast(null as text) as "owner_occupation",
    cast(null as text) as "owner_occupation_code",
    cast(null as integer) as "prem_version",
    cast(null as text) as "oic_version",
    cast(null as text) as "bene_occupation",
    cast(null as text) as "bene_occupation_code",
    cast(null as text) as "par_1_occupation",
    cast(null as integer) as "par_1_driver_behavior",
    cast(null as text) as "par_2_occupation",
    cast(null as integer) as "par_2_driver_behavior",
    cast(null as text) as "par_3_occupation",
    cast(null as integer) as "par_3_driver_behavior",
    cast(null as text) as "par_4_occupation",
    cast(null as integer) as "par_4_driver_behavior",
    cast(null as text) as "par_5_occupation",
        cast(null as text) as "par_1_occupation_code",
    cast(null as text) as "par_2_occupation_code",
    cast(null as text) as "par_3_occupation_code",
    cast(null as text) as "par_4_occupation_code",
    cast(null as text) as "par_5_occupation_code",
    cast(null as integer) as "par_5_driver_behavior",
    cast(null as boolean) as "driver_behavior_consent_1",
    cast(null as boolean) as "driver_behavior_consent_2",
    cast(null as boolean) as "driver_behavior_consent_3",
    cast(null as boolean) as "driver_behavior_consent_4",
    cast(null as boolean) as "driver_behavior_consent_5",
    -- [PLACEHOLDERS FOR NEW FIELDS]
        null::text as customer_id,
        null::integer as hp,
        null::text as "engineType",
        null::text as par_1_driver_license_category,
        null::text as par_2_driver_license_category,
        null::text as par_3_driver_license_category,
        null::text as par_4_driver_license_category,
        null::text as par_5_driver_license_category
from
    user_home_policies as policy
join insurverse.lead_home_participant as par on
    policy.policy_home_no = par.policy_home_no
join insurverse.sec_user as "user" on
    policy.user_id = "user".user_id
left join insurverse.subdistrict as owner_subd on
    par.owner_subdistrict_id = owner_subd.subdistrictid
left join insurverse.district as owner_dis on
    par.owner_district_id = owner_dis.districtid
left join insurverse.province as owner_prov on
    par.owner_province_id = owner_prov.provinceid
left join insurverse.subdistrict as deli_subd on
    policy.deli_subdistrict_id = deli_subd.subdistrictid
left join insurverse.district as deli_dis on
    policy.deli_district_id = deli_dis.districtid
left join insurverse.province as deli_prov on
    policy.deli_province_id = deli_prov.provinceid
left join home_coverage_json hcj on
    policy.policy_home_no = hcj.policy_home_no
left join home_bene_detail_json hbdj on
    policy.policy_home_no = hbdj.policy_home_no
left join home_endorse_last_status_json hesj on
    policy.policy_home_no = hesj.policy_key
    ),
    
    
    all_policies as (
select
    *
from
    motor_leads
union all
select
    *
from
    act_leads
union all
select
    *
from
    motor_policies
union all
select
    *
from
    act_policies
union all
select
    *
from
    ta_policies
union all
select
    *
from
    pa_policies
union all
select
    *
from
    home_policies
    )  
    
    
    select
    "my_policy"."Brand" as "Brand",
    "my_policy"."Model" as "Model",
    "my_policy"."Year" as "Year",
    "my_policy"."Car_license_no" as "Car_license_no",
    "my_policy"."Type" as "Type",
    "my_policy"."SI" as "SI",
    "my_policy"."Owner_first_name" as "Owner_first_name",
    "my_policy"."Owner_first_name_en" as "Owner_first_name_en",
    "my_policy"."Owner_last_name" as "Owner_last_name",
    "my_policy"."Owner_last_name_en" as "Owner_last_name_en",
    "my_policy"."Policy_No" as "Policy_No",
    "my_policy"."Policy_Ta_No" as "Policy_Ta_No",
    "my_policy"."Car_Act_No" as "Car_Act_No",
    "my_policy"."Policy_Startdate" as "Policy_Startdate",
    "my_policy"."Policy_Startdate_en" as "Policy_Startdate_en",
    "my_policy"."Policy_Enddate" as "Policy_Enddate",
    "my_policy"."Policy_Enddate_en" as "Policy_Enddate_en",
    "my_policy"."policy_startdate_sort" as "policy_startdate_sort",
    "my_policy"."Car_license_provice" as "Car_license_provice",
    "my_policy"."Policy_url_copy_ref" as "Policy_url_copy_ref",
    "my_policy"."Receipt_url_copy_ref" as "Receipt_url_copy_ref",
    "my_policy"."policy_date" as "policy_date",
    "my_policy"."policy_date_en" as "policy_date_en",
    "my_policy"."Car_Inspect_Status" as "Car_Inspect_Status",
    "my_policy"."Lead_No" as "Lead_No",
    "my_policy"."Car_Act_Lead_No" as "Car_Act_Lead_No",
    "my_policy"."priority" as "priority",
    "my_policy"."policy_status" as "policy_status",
    "my_policy"."payment_date" as "payment_date",
    "my_policy"."car_serial_no" as "car_serial_no",
    "my_policy"."car_license_type" as "car_license_type",
    "my_policy"."car_color" as "car_color",
    "my_policy"."car_cc" as "car_cc",
    "my_policy"."car_seat" as "car_seat",
    "my_policy"."car_weight" as "car_weight",
    "my_policy"."owner_citizen_id" as "owner_citizen_id",
    "my_policy"."Owner_birth_date" as "Owner_birth_date",
    "my_policy"."Owner_birth_date_en" as "Owner_birth_date_en",
    "my_policy"."owner_prefix_name" as "owner_prefix_name",
    "my_policy"."owner_prefix_name_en" as "owner_prefix_name_en",
    "my_policy"."owner_address" as "owner_address",
    "my_policy"."owner_address_en" as "owner_address_en",
    "my_policy"."owner_subdistrict" as "owner_subdistrict",
    "my_policy"."owner_subdistrict_en" as "owner_subdistrict_en",
    "my_policy"."owner_district" as "owner_district",
    "my_policy"."owner_district_en" as "owner_district_en",
    "my_policy"."owner_province" as "owner_province",
    "my_policy"."owner_province_en" as "owner_province_en",
    "my_policy"."owner_zipcode" as "owner_zipcode",
    "my_policy"."user_email" as "user_email",
    "my_policy"."user_mobile" as "user_mobile",
    "my_policy"."par_1_prefix_name" as "par_1_prefix_name",
    "my_policy"."par_1_first_name" as "par_1_first_name",
    "my_policy"."par_1_last_name" as "par_1_last_name",
    "my_policy"."par_1_birth_date" as "par_1_birth_date",
    "my_policy"."par_1_driver_license" as "par_1_driver_license",
    "my_policy"."par_1_citizen" as "par_1_citizen",
    "my_policy"."par_2_prefix_name" as "par_2_prefix_name",
    "my_policy"."par_2_first_name" as "par_2_first_name",
    "my_policy"."par_2_last_name" as "par_2_last_name",
    "my_policy"."par_2_birth_date" as "par_2_birth_date",
    "my_policy"."par_2_driver_license" as "par_2_driver_license",
    "my_policy"."par_2_citizen" as "par_2_citizen",
    "my_policy"."bene_type" as "bene_type",
    "my_policy"."bene_first_name" as "bene_first_name",
    "my_policy"."bene_last_name" as "bene_last_name",
    "my_policy"."bene_ta_detail" as "bene_ta_detail",
    "my_policy"."deli_addr_1" as "deli_addr_1",
    "my_policy"."deli_subdistrict" as "deli_subdistrict",
    "my_policy"."deli_district" as "deli_district",
    "my_policy"."deli_province" as "deli_province",
    "my_policy"."deli_zipcode" as "deli_zipcode",
    "my_policy"."GarageType" as "garage_type",
    "my_policy"."si_limit" as "si_limit",
    "my_policy"."si_access_limit" as "si_access_limit",
    "my_policy"."si_tppd_limit" as "si_tppd_limit",
    "my_policy"."si_tpbi_limit" as "si_tpbi_limit",
    "my_policy"."si_mv01_limit" as "si_mv01_limit",
    "my_policy"."si_mv02_limit" as "si_mv02_limit",
    "my_policy"."si_mv03_limit" as "si_mv03_limit",
    "my_policy"."car_comp_code" as "car_comp_code",
    "my_policy"."coverinjury" as "coverinjury",
    "my_policy"."coverdeath" as "coverdeath",
    "my_policy"."coveracc" as "coveracc",
    "my_policy"."Access_para_code" as "Access_para_code",
    "my_policy"."endorsement_list" as "endorsement_list",
    "my_policy"."package_name" as "package_name",
    "my_policy"."ta_coverage_list" as "ta_coverage_list",
    "my_policy"."ta_country_name_th" as "ta_country_name_th",
    "my_policy"."ta_country_name_en" as "ta_country_name_en",
    "my_policy"."owner_card_type" as "owner_card_type",
    "my_policy"."owner_email" as "owner_email",
    "my_policy"."owner_mobile" as "owner_mobile",
    "my_policy"."deli_flag" as "deli_flag",
    "my_policy"."Policy_Pa_No" as "Policy_Pa_No",
    "my_policy"."bene_pa_detail" as "bene_pa_detail",
    "my_policy"."bene_title" as "bene_title",
    "my_policy"."pa_coverage_list" as "pa_coverage_list",
    "my_policy"."policy_directory" as "policy_directory",
    "my_policy"."tax_deductions_url_ref" as "tax_deductions_url_ref",
    "my_policy"."endorse_last_status" as "endorse_last_status",
    "my_policy"."tax_deductions" as "tax_deductions",
    "my_policy"."owner_subdistrict_id" as "owner_subdistrict_id",
    "my_policy"."owner_district_id" as "owner_district_id",
    "my_policy"."owner_province_id" as "owner_province_id",
    "my_policy"."deli_subdistrict_id" as "deli_subdistrict_id",
    "my_policy"."deli_district_id" as "deli_district_id",
    "my_policy"."deli_province_id" as "deli_province_id",
    "my_policy"."tax_deductions_date_th" as "tax_deductions_date_th",
    "my_policy"."tax_deductions_date_en" as "tax_deductions_date_en",
    "my_policy"."Policy_Home_No" as "Policy_Home_No",
    "my_policy"."home_coverage" as "home_coverage",
    "my_policy"."bene_home_detail" as "bene_home_detail",
    "my_policy"."Policy_url_ref" as "Policy_url_ref",
    "my_policy"."Receipt_url_ref" as "Receipt_url_ref",
    "my_policy"."tax_deductions_url_copy_ref" as "tax_deductions_url_copy_ref",
    "my_policy"."claim_status_flag" as "claim_status_flag",
    "my_policy"."motor_detail" as "motor_detail",
    "my_policy"."renewal_detail" as "renewal_detail",
    "my_policy"."ta_package_list" as "ta_package_list",
    "my_policy"."ta_policy_detail" as "ta_policy_detail",
    "my_policy"."partner_code" as "partner_code",
    "my_policy"."partner_detail" as "partner_detail",
    --CR21
    --ผู้ขับขี่ 3-5
	"my_policy"."par_3_prefix_name" as "par_3_prefix_name",
    "my_policy"."par_3_first_name" as "par_3_first_name",
    "my_policy"."par_3_last_name" as "par_3_last_name",
    "my_policy"."par_3_birth_date" as "par_3_birth_date",
    "my_policy"."par_3_driver_license" as "par_3_driver_license",
    "my_policy"."par_3_citizen" as "par_3_citizen",
    "my_policy"."par_4_prefix_name" as "par_4_prefix_name",
    "my_policy"."par_4_first_name" as "par_4_first_name",
    "my_policy"."par_4_last_name" as "par_4_last_name",
    "my_policy"."par_4_birth_date" as "par_4_birth_date",
    "my_policy"."par_4_driver_license" as "par_4_driver_license",
    "my_policy"."par_4_citizen" as "par_4_citizen",
    "my_policy"."par_5_prefix_name" as "par_5_prefix_name",
    "my_policy"."par_5_first_name" as "par_5_first_name",
    "my_policy"."par_5_last_name" as "par_5_last_name",
    "my_policy"."par_5_birth_date" as "par_5_birth_date",
    "my_policy"."par_5_driver_license" as "par_5_driver_license",
    "my_policy"."par_5_citizen" as "par_5_citizen",
    "my_policy"."owner_occupation" as "owner_occupation",
    "my_policy"."owner_occupation_code" as "owner_occupation_code",
    "my_policy"."prem_version" as "prem_version",
    "my_policy"."oic_version" as "oic_version",
    "my_policy"."bene_occupation" as "bene_occupation",
    "my_policy"."bene_occupation_code" as "bene_occupation_code",
    "my_policy"."par_1_occupation" as "par_1_occupation",
    "my_policy"."par_1_driver_behavior" as "par_1_driver_behavior",
    "my_policy"."par_2_occupation" as "par_2_occupation",
    "my_policy"."par_2_driver_behavior" as "par_2_driver_behavior",
    "my_policy"."par_3_occupation" as "par_3_occupation",
    "my_policy"."par_3_driver_behavior" as "par_3_driver_behavior",
    "my_policy"."par_4_occupation" as "par_4_occupation",
    "my_policy"."par_4_driver_behavior" as "par_4_driver_behavior",
    "my_policy"."par_5_occupation" as "par_5_occupation",
    "my_policy"."par_1_occupation_code" as "par_1_occupation_code",
    "my_policy"."par_2_occupation_code" as "par_2_occupation_code",
    "my_policy"."par_3_occupation_code" as "par_3_occupation_code",
    "my_policy"."par_4_occupation_code" as "par_4_occupation_code",
    "my_policy"."par_5_occupation_code" as "par_5_occupation_code",
    "my_policy"."par_5_driver_behavior" as "par_5_driver_behavior",
    "my_policy"."driver_behavior_consent_1" as "driver_behavior_consent_1",
    "my_policy"."driver_behavior_consent_2" as "driver_behavior_consent_2",
    "my_policy"."driver_behavior_consent_3" as "driver_behavior_consent_3",
    "my_policy"."driver_behavior_consent_4" as "driver_behavior_consent_4",
    "my_policy"."driver_behavior_consent_5" as "driver_behavior_consent_5",
    -- [SELECT OUTPUT FOR NEW FIELDS]
    "my_policy"."customer_id" as customer_id,
    "my_policy"."hp" as hp,
    "my_policy"."engineType" as "engineType",
    "my_policy"."par_1_driver_license_category" as par_1_driver_license_category,
    "my_policy"."par_2_driver_license_category" as par_2_driver_license_category,
    "my_policy"."par_3_driver_license_category" as par_3_driver_license_category,
    "my_policy"."par_4_driver_license_category" as par_4_driver_license_category,
    "my_policy"."par_5_driver_license_category" as par_5_driver_license_category
from
    all_policies as my_policy
where
    ((
    select
        sp.in_policy_no
    from
        set_para sp) is null
    or (
            my_policy."Policy_No" like '%' || (
    select
        sp.in_policy_no
    from
        set_para sp) || '%'
    or
            my_policy."Car_Act_No" like '%' || (
    select
        sp.in_policy_no
    from
        set_para sp) || '%'
    or
            my_policy."Policy_Ta_No" like '%' || (
    select
        sp.in_policy_no
    from
        set_para sp) || '%'
    or
            my_policy."Policy_Pa_No" like '%' || (
    select
        sp.in_policy_no
    from
        set_para sp) || '%'
    or
            my_policy."Policy_Home_No" like '%' || (
    select
        sp.in_policy_no
    from
        set_para sp) || '%'
        ))
    and
        ((
    select
        sp.in_partner_code
    from
        set_para sp) is null
    or
        my_policy."partner_code" = (
    select
        sp.in_partner_code
    from
        set_para sp))
order by
    my_policy."priority",
    my_policy."Car_Inspect_Status" desc,
    my_policy."policy_startdate_sort" asc,
    my_policy."Policy_No" desc,
    my_policy."Car_Act_No" desc,
    case
        when my_policy."policy_directory" = 'insured_active' then my_policy."Type"
    end asc,
    case
        when my_policy."policy_directory" = 'expired' then my_policy."Type"
    end desc,
    my_policy."Policy_Ta_No" desc,
    my_policy."Policy_Pa_No" desc,
    my_policy."Policy_Home_No" desc;
end;

$function$
