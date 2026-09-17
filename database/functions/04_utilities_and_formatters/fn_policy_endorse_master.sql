-- =============================================================================
-- Function: insurverse.fn_policy_endorse_master
-- OID: 18616
-- Identity Arguments: (in_policy_no text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_endorse_master(in_policy_no text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
RTN_JSON TEXT;

SYS_POLICY_NO TEXT;

begin
select
	"policy"
from
	(
	select
		"Policy_No" as "policy"
	from
		insurverse."Policy_Header"
	where
		"Policy_No" = "in_policy_no"
union
	select
		"Car_Act_No" as "policy"
	from
		insurverse."Policy_Car_Act_Discount_Premium"
	where
		"Car_Act_No" = "in_policy_no"
) as "check_policy"
limit 1
into
	SYS_POLICY_NO;

if SYS_POLICY_NO is not null then
	with set_para as (
select
	$1 as "policy_no")
select
	json_build_object(
'success', true,
'message', '',
'brands', case when SUBSTR((select "policy_no" from set_para), 1, 2) = 'MV' then
(
  select json_agg(item)
  from (
   select "ipp"."Brand" as "brand",
   (
    select json_agg(models)
    from (
     select "ipp2"."Model" as "model",
     insurverse.fn_policy_usage_to_comp((select "policy_no" from set_para)) as "compCode",
     "ipp2"."Usage" as "usage",
     (select "tariff_factor" from insurverse.mas_tariff
     where "tariff_group" = 'motor' and "tariff_code" = 'usage'
     and "policy_type" = replace("ipp"."Type", '+', '') and "tariff_mapping" = cast("ipp2"."Usage" as TEXT))
     as "tariffUsage",
     "ipp2"."Group" as "carGroup",
     (select "tariff_factor" from insurverse.mas_tariff
     where "tariff_group" = 'motor' and "tariff_code" = 'vehicle_group'
     and "policy_type" = replace("ipp"."Type", '+', '') and "tariff_mapping" = "ipp2"."Group")
     as "tariffGroup",
     (
      select json_agg("year")
      from (
       select "Year" as "year"
       from (select distinct "Brand", "Model", "Usage", "Group", "Year", "Type", "GarageType"
       from insurverse."Imp_Price_Premium"
       ) as "ipp3"
       where "ipp3"."Brand" = "ipp2"."Brand"
       and "ipp3"."Model" = "ipp2"."Model"
       and "ipp3"."Group" = "ipp2"."Group"
       and "ipp3"."Type" = "ipp"."Type"
       and "ipp3"."GarageType" = "ipp"."GarageType"
       order by "ipp3"."Year" desc
      ) years
     ) as "year"
     from (select distinct "ipp"."Brand", "ipp"."Model", "ipp"."Usage", "ipp"."Group", "ipp"."Type"
     from insurverse."Imp_Price_Premium" as "ipp"
     inner join insurverse."Policy_Header" as "policy"
     on "ipp"."Type" = "policy"."Type"
     and "policy"."Policy_No" =(select "policy_no" from set_para)
     ) as "ipp2"
     where "ipp2"."Brand" = "ipp"."Brand"
     order by "ipp2"."Model"
    ) models
   ) as "models"
   from (select distinct "Brand", "GarageType", "Type" from insurverse."Imp_Price_Premium"
   ) as "ipp"
   inner join insurverse."Policy_Header" as "po_h"
   on "po_h"."Policy_No" in (select "policy_no" from set_para)
   and "ipp"."GarageType" = "po_h"."GarageType"
   and "ipp"."Type" = "po_h"."Type"
   order by "ipp"."Brand"
  ) item
) else (
  select json_agg(item)
  from (
   select "idp"."Brand" as "brand",
   (
    select json_agg(models)
    from (
     select "idp2"."Model" as "model",
     "idp2"."Comp_Code" as "compCode",
     (
      select case when "usage_val" ~ '^[0-9]+$'
        then to_jsonb(cast("usage_val" as INTEGER))
        else null
      end
      from (select insurverse.fn_policy_comp_to_usage((select "policy_no" from set_para)) as "usage_val") "u"
     ) as "usage",
     "idp2"."Group" as "carGroup",
     (
      select json_agg("year")
      from (
       select "Year" as "year"
       from (select distinct "Brand", "Model", "Comp_Code", "Group", "Year" from insurverse."Imp_Discount_Premium"
       ) as "idp3"
       where "idp3"."Brand" = "idp2"."Brand"
       and "idp3"."Model" = "idp2"."Model"
       and "idp3"."Group" = "idp2"."Group"
       and "idp3"."Comp_Code" = "idp2"."Comp_Code"
       order by "idp3"."Year" desc
      ) years
     ) as "year"
     from (select distinct "Brand", "Model", "Comp_Code", "Group" from insurverse."Imp_Discount_Premium"
     ) as "idp2"
     where "idp2"."Brand" = "idp"."Brand"
     and "idp2"."Comp_Code" = "idp"."Comp_Code"
     order by "idp2"."Model"
    ) models
   ) as "models"
   from (select distinct "idp"."Brand", "idp"."Comp_Code" from insurverse."Imp_Discount_Premium" as "idp"
   inner join insurverse."Policy_Car_Act_Discount_Premium" as "po_a"
   on "po_a"."Car_Act_No" in (select "policy_no" from set_para)
   and "po_a"."Car_Comp_Code" = "idp"."Comp_Code"
   ) as "idp"
   order by "idp"."Brand"
  ) item
) end, -- bands
'titles',
(
  select json_agg(item)
  from (
   select "para_code" as "titleCode", "para_name" as "titleNameTh", "para_str" as "titleNameEn"
   from insurverse."sys_param" as "title"
   where "title"."dom_code" = 'Title'
   order by "para_code"
  ) item
), -- titles
'colors',
(
  select json_agg(item)
  from (
   select "color_id" as "colorId", "color_name_th" as "colorNameTh", "color_name_en" as "colorNameEn"
   from insurverse."mas_cmi_color" as "color"
   order by "color_id"
  ) item
), -- colors
'ageRange',
(
  select 
	case 
	    when (
	      select oic_version
	      from insurverse."Policy_Header"
	      where "Policy_No" = (select "policy_no" from set_para)
	      limit 1
	    ) is not null 
	      then null 
	    else json_agg(item)
  	end as result
  from (
   select "ipp"."NamedAge" as "namedAge",
   case when SPLIT_PART("ipp"."NamedAge", '-', 1) = 'Unnamed' then 0
   else cast(replace(SPLIT_PART("ipp"."NamedAge", '-', 1), '>', '') as INTEGER) end as "min",
   case when SPLIT_PART("ipp"."NamedAge", '-', 2) = 'Unnamed' then 0
   when SPLIT_PART("ipp"."NamedAge", '-', 2) = '' then 999
   else cast(replace(SPLIT_PART("ipp"."NamedAge", '-', 2), '>', '') as INTEGER) end as "max",
   (select "tariff_factor"
    from insurverse."mas_tariff"
    inner join insurverse."Policy_Header" as "policy"
    on "mas_tariff"."policy_type" = replace("policy"."Type", '+', '')
    and "policy"."Policy_No" =(select "policy_no" from set_para)
    and "tariff_group" = 'motor' and "tariff_code" = 'driver_name'
    and "tariff_mapping" = "ipp"."NamedAge"
    limit 1) as "tariffNamedAge"
   from (
    select distinct "NamedAge" from insurverse."Imp_Price_Premium"
   ) as "ipp"
   order by "ipp"."NamedAge"
  ) item
), -- ageRange
'carCc',
(
  select json_agg("item")
  from (
   select "tariff_mapping" as "carCcCondition",
   "tariff_num_min" as "min",
   "tariff_num_max" as "max",
   "tariff_factor" as "tariffCarCc"
   from (select distinct "tariff_mapping", "tariff_num_min", "tariff_num_max",
   "tariff_factor" from insurverse.mas_tariff
   inner join insurverse."Policy_Header" as "policy"
    on "mas_tariff"."policy_type" = replace("policy"."Type", '+', '')
    and "policy"."Policy_No" =(select "policy_no" from set_para)
    and "tariff_group" = 'motor' and "tariff_code" = 'size'
   ) as "tariff"
   order by "tariff_num_min"
  ) item
), -- carCc
'accessorys',
(
  select json_agg(item)
  from (
   select "para_code" as "accessCode", "para_name" as "accessNameTh", "para_str" as "accessNameEn"
   from insurverse."sys_param" as "access"
   inner join "set_para"
   on "set_para"."policy_no" is not null
   inner join insurverse."Policy_Header" as "policy"
   on "set_para"."policy_no" = "policy"."Policy_No"
   and (("policy"."BodyType" like '%เก๋ง%' and "access"."para_code" != 'carry_boy')
   or ("policy"."BodyType" not like '%เก๋ง%'))
   where "access"."dom_code" = 'Premium' and "access"."sub_dom_code" = 'Car_Sector'
   and "access"."para_desc" = 'Access'
   order by "para_min"
  ) item
), -- accessorys
'beneTypes',
(
  select json_agg(item)
  from (
   select "para_code" as "beneCode", "para_name" as "beneNameTh", "para_str" as "beneNameEn"
   from insurverse."sys_param" as "beme"
   where "beme"."dom_code" = 'Policy' and "beme"."sub_dom_code" = 'Bene_type'
   order by "para_code"
  ) item
), -- beneTypes
'carLicenseTypes',
(
  select json_agg(item)
  from (
   select "para_code" as "carLicenseCode", "para_name" as "carLicenseNameTh", "para_str" as "carLicenseNameEn"
   from insurverse."sys_param" as "linc"
   where "linc"."dom_code" = 'Policy' and "linc"."sub_dom_code" = 'Car_license_type'
   order by "para_code"
  ) item
), -- carLicenseTypes
'carYears',
(
  select json_agg("item")
  from (select
   "tariff_num_min" as "min",
   "tariff_num_max" as "max",
   "tariff_factor" as "tariffCarYear"
   from (select distinct "tariff_mapping", "tariff_num_min", "tariff_num_max",
   "tariff_factor" from insurverse.mas_tariff
   inner join insurverse."Policy_Header" as "policy"
    on "mas_tariff"."policy_type" = replace("policy"."Type", '+', '')
    and "policy"."Policy_No" =(select "policy_no" from set_para)
    and "tariff_group" = 'motor' and "tariff_code" = 'vehicle_age'
   ) as "tariff"
   order by "tariff_num_min"
  ) item
), -- carYears
'driverBehaviors',
(
	select 
	  case 
	    when (
	      select oic_version
	      from insurverse."Policy_Header"
	      where "Policy_No" = (
             select
               "policy_no"
             from
               "set_para"
           )
	      limit 1
	    ) is null 
	      then null 
	    else json_agg(item)
	  end as result
	from (
	  select
	    ipp.driver_behavior::text as "driverBehavior",
	    (
	      select tariff_factor
	      from insurverse."mas_tariff"
	      inner join insurverse."Policy_Header" policy
	        on "mas_tariff"."policy_type" = replace(policy."Type", '+', '')
	       and policy."Policy_No" = (
             select
               "policy_no"
             from
               "set_para"
           )
	      where tariff_group = 'motor'
	        and tariff_code = 'driver_behaviour'
	        and tariff_mapping = ipp.driver_behavior::text
	      limit 1
	    ) as "tariffDriverBehavior"
	  from (
	    select distinct driver_behavior
	    from insurverse."Imp_Price_Premium"
	    where driver_behavior is not null
	  ) ipp
	  order by ipp.driver_behavior
	) item
), -- driverBehaviors
'occupation',
(
  select 
	case 
	    when (
			select oic_version
			from insurverse."Policy_Header"
			where "Policy_No" = (
				select
				"policy_no"
				from
				"set_para"
			)
			union
			select
				coalesce(policy."oic_version", ph."oic_version") as oic_version
			from
				insurverse."Policy_Car_Act_Discount_Premium" as policy
				left join insurverse."Policy_Header" as ph on policy."Policy_No" = ph."Policy_No"
			where
				policy."Car_Act_No" = (
				select
				"policy_no"
				from
				"set_para"
			)
	      limit 1
	    ) is null 
	      then null 
	    else json_agg(sp.para_name)
	  end as result
	from insurverse.sys_param sp 
	where sp.dom_code = 'occupation'
	  and sp.sub_dom_code = 'occupation_wpa'
	  and sp.para_status = 'ATV'
	)-- occupation
) as "json_body"
	-- 1
	into
	RTN_JSON;
else
	RTN_JSON = '{"success" : false,"message" : "Policy number is not found."}';
end if;

return RTN_JSON;
end
$function$
