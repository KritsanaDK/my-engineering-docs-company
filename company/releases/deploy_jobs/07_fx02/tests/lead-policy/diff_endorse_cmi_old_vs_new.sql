with o as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		TO_CHAR("endorse"."create_at" + interval '7 HOUR',
		'yyyymmdd') as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and "endorse"."Car_Act_No" = "car_act"."Car_Act_No"
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

), n as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		case
			when "endorse"."create_at" > "endorse"."effective_date"
			then TO_CHAR("endorse"."effective_date" + interval '7 HOUR', 'yyyymmdd')
			else TO_CHAR("endorse"."create_at" + interval '7 HOUR', 'yyyymmdd')
		end as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and (
			"endorse"."Car_Act_No" = "car_act"."Car_Act_No"
			or (coalesce("endorse"."Car_Act_No", '') = '' and "endorse"."Policy_No" = "car_act"."Policy_No")
		)
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

) select 'old rows' k, count(*) a, count(distinct endorse_ref_no) b from o union all select 'new rows', count(*), count(distinct endorse_ref_no) from n union all select 'identical rows', count(*), count(distinct endorse_ref_no) from (select * from o intersect all select * from n) x union all select 'only in old', count(*), count(distinct endorse_ref_no) from (select * from o except all select * from n) x union all select 'only in new', count(*), count(distinct endorse_ref_no) from (select * from n except all select * from o) x;
with o as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		TO_CHAR("endorse"."create_at" + interval '7 HOUR',
		'yyyymmdd') as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and "endorse"."Car_Act_No" = "car_act"."Car_Act_No"
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

), n as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		case
			when "endorse"."create_at" > "endorse"."effective_date"
			then TO_CHAR("endorse"."effective_date" + interval '7 HOUR', 'yyyymmdd')
			else TO_CHAR("endorse"."create_at" + interval '7 HOUR', 'yyyymmdd')
		end as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and (
			"endorse"."Car_Act_No" = "car_act"."Car_Act_No"
			or (coalesce("endorse"."Car_Act_No", '') = '' and "endorse"."Policy_No" = "car_act"."Policy_No")
		)
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

) select case when nn.endorse_ref_no in (select endorse_ref_no from o) then 'only-in-new: endorse existed before (changed row)' else 'only-in-new: endorse was missing before (policy-only)' end, count(*), count(distinct endorse_ref_no) from (select * from n except all select * from o) nn group by 1;
with o as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		TO_CHAR("endorse"."create_at" + interval '7 HOUR',
		'yyyymmdd') as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and "endorse"."Car_Act_No" = "car_act"."Car_Act_No"
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

), n as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		case
			when "endorse"."create_at" > "endorse"."effective_date"
			then TO_CHAR("endorse"."effective_date" + interval '7 HOUR', 'yyyymmdd')
			else TO_CHAR("endorse"."create_at" + interval '7 HOUR', 'yyyymmdd')
		end as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and (
			"endorse"."Car_Act_No" = "car_act"."Car_Act_No"
			or (coalesce("endorse"."Car_Act_No", '') = '' and "endorse"."Policy_No" = "car_act"."Policy_No")
		)
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

) select 'changed rows differing ONLY in contract_dt', count(*), count(*) filter (where n.contract_dt < o.contract_dt) from n join o using (endorse_ref_no, policy_no) where (to_jsonb(n.*) - 'contract_dt') = (to_jsonb(o.*) - 'contract_dt') and n.contract_dt is distinct from o.contract_dt;
with o as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		TO_CHAR("endorse"."create_at" + interval '7 HOUR',
		'yyyymmdd') as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and "endorse"."Car_Act_No" = "car_act"."Car_Act_No"
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

), n as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		case
			when "endorse"."create_at" > "endorse"."effective_date"
			then TO_CHAR("endorse"."effective_date" + interval '7 HOUR', 'yyyymmdd')
			else TO_CHAR("endorse"."create_at" + interval '7 HOUR', 'yyyymmdd')
		end as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and (
			"endorse"."Car_Act_No" = "car_act"."Car_Act_No"
			or (coalesce("endorse"."Car_Act_No", '') = '' and "endorse"."Policy_No" = "car_act"."Policy_No")
		)
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

) select 'new: contract_dt > endorse_effective_dt', count(*), null from n where contract_dt > endorse_effective_dt union all select 'old: contract_dt > endorse_effective_dt (2BUS0004)', count(*), null from o where contract_dt > endorse_effective_dt;
with o as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		TO_CHAR("endorse"."create_at" + interval '7 HOUR',
		'yyyymmdd') as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and "endorse"."Car_Act_No" = "car_act"."Car_Act_No"
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

), n as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		case
			when "endorse"."create_at" > "endorse"."effective_date"
			then TO_CHAR("endorse"."effective_date" + interval '7 HOUR', 'yyyymmdd')
			else TO_CHAR("endorse"."create_at" + interval '7 HOUR', 'yyyymmdd')
		end as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and (
			"endorse"."Car_Act_No" = "car_act"."Car_Act_No"
			or (coalesce("endorse"."Car_Act_No", '') = '' and "endorse"."Policy_No" = "car_act"."Policy_No")
		)
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

) select 'new: endorses with >1 row (limit 1 picks arbitrary)', count(*), null from (select endorse_ref_no from n group by 1 having count(*)>1) x union all select 'old: endorses with >1 row', count(*), null from (select endorse_ref_no from o group by 1 having count(*)>1) x;
with o as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		TO_CHAR("endorse"."create_at" + interval '7 HOUR',
		'yyyymmdd') as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and "endorse"."Car_Act_No" = "car_act"."Car_Act_No"
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

), n as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		case
			when "endorse"."create_at" > "endorse"."effective_date"
			then TO_CHAR("endorse"."effective_date" + interval '7 HOUR', 'yyyymmdd')
			else TO_CHAR("endorse"."create_at" + interval '7 HOUR', 'yyyymmdd')
		end as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and (
			"endorse"."Car_Act_No" = "car_act"."Car_Act_No"
			or (coalesce("endorse"."Car_Act_No", '') = '' and "endorse"."Policy_No" = "car_act"."Policy_No")
		)
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

) select 'new endorses with empty reference/receive (-> 400)', count(*), count(distinct endorse_ref_no) from n where coalesce(reference_no,'')='' or coalesce(receive_no,'')='';
with o as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		TO_CHAR("endorse"."create_at" + interval '7 HOUR',
		'yyyymmdd') as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and "endorse"."Car_Act_No" = "car_act"."Car_Act_No"
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

), n as materialized (select
		"comp"."regist_id" as company_code,
		"car_act"."Car_Act_No" as policy_no,
		case
			when "endorse"."create_at" > "endorse"."effective_date"
			then TO_CHAR("endorse"."effective_date" + interval '7 HOUR', 'yyyymmdd')
			else TO_CHAR("endorse"."create_at" + interval '7 HOUR', 'yyyymmdd')
		end as contract_dt,
		case when "car_act"."Start_date" >= "endorse"."effective_date" and "car_act"."Start_date" >= "endorse"."create_at"
			then TO_CHAR("car_act"."Start_date" + interval '7 HOUR',
			'yyyymmdd')
			else case
				when "endorse"."create_at" >= "endorse"."effective_date" and "endorse"."create_at" >= "car_act"."Start_date"
				then TO_CHAR("endorse"."create_at" + interval '7 HOUR',
				'yyyymmdd')
				else TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
				'yyyymmdd')
			end
		end as effective_dt,
		TO_CHAR("car_act"."End_date" + interval '7 HOUR',
		'yyyymmdd') as end_dt,
		"car_act"."Car_Comp_Code" as vehicle_type_code,
		"province"."cmi_prov_id" as registered_province_code,
		"car_act"."Car_license_no" as plate_no,
		"car_act"."Car_serial_no" as chassis_vin_no,
		"car_act"."citizen_id" as insured_unique_id,
		"car_act"."first_name" as insured_name,
		"car_act"."last_name" as insured_surname,
		'THA' as country,
		"comp"."regist_id" as agent_broker_license_no,
		case
			when "brand"."brand_id" is null then '99999'
			else "brand"."brand_id"
		end as vehicle_brand,
		case
			when "brand"."brand_id" is null and "model"."model_id" is null then '99999'
			when "brand"."brand_id" is not null and "model"."model_id" is null then "brand"."brand_id" || '0000'
			else "model"."model_id"
		end as vehicle_model,
		"color"."color_id" as vehicle_color,
		"car_act"."cmi_reference_number" as reference_no,
		"car_act"."cmi_receive_number" as receive_no,
		TO_CHAR("endorse"."effective_date" + interval '7 HOUR',
		'yyyymmdd') as endorse_effective_dt,
		"endorse"."SF_Policy_id" as endorse_ref_no,
		case
			when "endorse"."doc_type" = 'v0_11' then 'X'
			else 'U'
		end as endorse_flag
	from
		insurverse."Policy_endorse_detail" as "endorse"
	inner join insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
								on
		"endorse"."SF_Policy_id" is not null
		and (
			"endorse"."Car_Act_No" = "car_act"."Car_Act_No"
			or (coalesce("endorse"."Car_Act_No", '') = '' and "endorse"."Policy_No" = "car_act"."Policy_No")
		)
	inner join insurverse."company_detail" as "comp"
								on
		"car_act"."Comp_Code" = "comp"."comp_code"
	left join insurverse."mas_cmi_province" as "province" on
		cast("car_act"."Car_license_provice" as INT)= "province"."provinceid"
	left join (
		select
			distinct brand_id,
			brand_name
		from
			insurverse."mas_cmi_brand_model") as "brand"
								on
		UPPER("car_act"."Brand")= UPPER("brand"."brand_name")
	left join (
		select
			distinct brand_name,
			model_id,
			model_name
		from
			insurverse."mas_cmi_brand_model") as "model"
								on
		UPPER("car_act"."Brand")= UPPER("model"."brand_name")
		and UPPER("car_act"."Model")= UPPER("model"."model_name")
	left join insurverse."mas_cmi_color" as "color" on
		"car_act"."Car_color" = "color"."color_name_th"
		or "car_act"."Car_color" = "color"."color_id"

) select 'of those, endorses old query also returned', count(distinct endorse_ref_no), null from n where (coalesce(reference_no,'')='' or coalesce(receive_no,'')='') and endorse_ref_no in (select endorse_ref_no from o);