with o as materialized (
	SELECT 
	"comp"."regist_id" as "companyCode",
	"car_act"."Car_Act_No" as "policyNumber",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR(TO_TIMESTAMP(cmi.contract_date, 'DD/MM/YYYY') + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE TO_CHAR("car_act"."Create_date" + INTERVAL '7 HOUR', 'yyyymmdd') 
	END AS "contractDt",
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "effectiveDt",
	TO_CHAR("car_act"."End_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "endDt",
	"car_act"."Car_Comp_Code" as "vehicleTypeCode",
	"province"."cmi_prov_id" as "registeredProvinceCode", 
	"car_act"."Car_license_no" as "plateNumber",
	"car_act"."Car_serial_no" as "chassisVINNumber",
	"car_act"."citizen_id" as "insuredUniqueID",
	"car_act"."first_name" as "insuredName",
	"car_act"."last_name" as "insuredSurname",
	'THA' as "country",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' THEN 'ว00019/2546' ELSE "comp"."regist_id" END AS "agentBrokerLicenseNumber",
	CASE WHEN "brand"."brand_id" IS NULL THEN '99999' ELSE "brand"."brand_id" END as "vehicleBrand", 
	CASE WHEN "brand"."brand_id" IS NULL AND "model"."model_id" IS NULL THEN '99999'
	WHEN "brand"."brand_id" IS NOT NULL AND "model"."model_id" IS NULL THEN "brand"."brand_id" || '0000' 
	ELSE "model"."model_id" END as "vehicleModel", 
	"color"."color_id" as "vehicleColor",
	
	"car_act"."cmi_reference_number" as "ReferenceNumber",
	"car_act"."cmi_receive_number" as "ReceiveNumber",
	CASE
	WHEN CURRENT_DATE < ("car_act"."Start_date" + INTERVAL '7 HOUR')::DATE THEN
	
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR("endorse"."effective_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	ELSE
	
	TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR', 'yyyymmdd')
	END as "EndorseEffectiveDt",
	"endorse"."SF_Policy_id" as "EndorseRefNumber",
	
	'N' as "EndorseFlag" 
	FROM insurverse."Policy_endorse_detail" as "endorse"
	INNER JOIN insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
	ON "endorse"."SF_Policy_id" is not null
	AND "endorse"."Car_Act_No"="car_act"."Car_Act_No"
	INNER JOIN insurverse."company_detail" as "comp" 
	ON "car_act"."Comp_Code"="comp"."comp_code"
	LEFT JOIN insurverse."mas_cmi_province" as "province" ON CAST(NULLIF("car_act"."Car_license_provice",'') as INT)="province"."provinceid" 
	LEFT JOIN (SELECT DISTINCT brand_id, brand_name FROM insurverse."mas_cmi_brand_model") as "brand"
	ON UPPER("car_act"."Brand")=UPPER("brand"."brand_name")
	LEFT JOIN (SELECT DISTINCT brand_name, model_id, model_name FROM insurverse."mas_cmi_brand_model") as "model" 
	ON UPPER("car_act"."Brand")=UPPER("model"."brand_name") AND UPPER("car_act"."Model")=UPPER("model"."model_name")
	LEFT JOIN insurverse."mas_cmi_color" as "color" ON "car_act"."Car_color"="color"."color_name_th" OR "car_act"."Car_color"="color"."color_id"
	LEFT JOIN insurverse."tqm_lead_cmi" AS "cmi" ON "cmi".policy_number = "endorse"."Car_Act_No"
	
	
), n as materialized (
	SELECT 
	"comp"."regist_id" as "companyCode",
	"car_act"."Car_Act_No" as "policyNumber",
	CASE WHEN c.contract_dt > TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
		THEN TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE c.contract_dt
	END AS "contractDt",
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "effectiveDt",
	TO_CHAR("car_act"."End_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "endDt",
	"car_act"."Car_Comp_Code" as "vehicleTypeCode",
	"province"."cmi_prov_id" as "registeredProvinceCode", 
	"car_act"."Car_license_no" as "plateNumber",
	"car_act"."Car_serial_no" as "chassisVINNumber",
	"car_act"."citizen_id" as "insuredUniqueID",
	"car_act"."first_name" as "insuredName",
	"car_act"."last_name" as "insuredSurname",
	'THA' as "country",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' THEN 'ว00019/2546' ELSE "comp"."regist_id" END AS "agentBrokerLicenseNumber",
	CASE WHEN "brand"."brand_id" IS NULL THEN '99999' ELSE "brand"."brand_id" END as "vehicleBrand", 
	CASE WHEN "brand"."brand_id" IS NULL AND "model"."model_id" IS NULL THEN '99999'
	WHEN "brand"."brand_id" IS NOT NULL AND "model"."model_id" IS NULL THEN "brand"."brand_id" || '0000' 
	ELSE "model"."model_id" END as "vehicleModel", 
	"color"."color_id" as "vehicleColor",
	
	"car_act"."cmi_reference_number" as "ReferenceNumber",
	"car_act"."cmi_receive_number" as "ReceiveNumber",
	CASE
	WHEN CURRENT_DATE < ("car_act"."Start_date" + INTERVAL '7 HOUR')::DATE THEN
	
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR("endorse"."effective_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	ELSE
	
	TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR', 'yyyymmdd')
	END as "EndorseEffectiveDt",
	"endorse"."SF_Policy_id" as "EndorseRefNumber",
	
	'N' as "EndorseFlag" 
	FROM insurverse."Policy_endorse_detail" as "endorse"
	INNER JOIN insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
	ON "endorse"."SF_Policy_id" is not null
	AND "endorse"."Car_Act_No"="car_act"."Car_Act_No"
	INNER JOIN insurverse."company_detail" as "comp" 
	ON "car_act"."Comp_Code"="comp"."comp_code"
	LEFT JOIN insurverse."mas_cmi_province" as "province" ON CAST(NULLIF("car_act"."Car_license_provice",'') as INT)="province"."provinceid" 
	LEFT JOIN (SELECT DISTINCT brand_id, brand_name FROM insurverse."mas_cmi_brand_model") as "brand"
	ON UPPER("car_act"."Brand")=UPPER("brand"."brand_name")
	LEFT JOIN (SELECT DISTINCT brand_name, model_id, model_name FROM insurverse."mas_cmi_brand_model") as "model" 
	ON UPPER("car_act"."Brand")=UPPER("model"."brand_name") AND UPPER("car_act"."Model")=UPPER("model"."model_name")
	LEFT JOIN insurverse."mas_cmi_color" as "color" ON "car_act"."Car_color"="color"."color_name_th" OR "car_act"."Car_color"="color"."color_id"
	LEFT JOIN insurverse."tqm_lead_cmi" AS "cmi" ON "cmi".policy_number = "endorse"."Car_Act_No"
	CROSS JOIN LATERAL (SELECT CASE WHEN UPPER("car_act".partner_code) = 'TQM'
		THEN TO_CHAR(TO_TIMESTAMP(cmi.contract_date, 'DD/MM/YYYY') + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE TO_CHAR("car_act"."Create_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	END AS contract_dt) AS c
	
	
) select 'old rows', count(*) from o union all select 'new rows', count(*) from n union all select 'identical', count(*) from (select * from o intersect all select * from n) x union all select 'only old', count(*) from (select * from o except all select * from n) x;
with o as materialized (
	SELECT 
	"comp"."regist_id" as "companyCode",
	"car_act"."Car_Act_No" as "policyNumber",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR(TO_TIMESTAMP(cmi.contract_date, 'DD/MM/YYYY') + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE TO_CHAR("car_act"."Create_date" + INTERVAL '7 HOUR', 'yyyymmdd') 
	END AS "contractDt",
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "effectiveDt",
	TO_CHAR("car_act"."End_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "endDt",
	"car_act"."Car_Comp_Code" as "vehicleTypeCode",
	"province"."cmi_prov_id" as "registeredProvinceCode", 
	"car_act"."Car_license_no" as "plateNumber",
	"car_act"."Car_serial_no" as "chassisVINNumber",
	"car_act"."citizen_id" as "insuredUniqueID",
	"car_act"."first_name" as "insuredName",
	"car_act"."last_name" as "insuredSurname",
	'THA' as "country",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' THEN 'ว00019/2546' ELSE "comp"."regist_id" END AS "agentBrokerLicenseNumber",
	CASE WHEN "brand"."brand_id" IS NULL THEN '99999' ELSE "brand"."brand_id" END as "vehicleBrand", 
	CASE WHEN "brand"."brand_id" IS NULL AND "model"."model_id" IS NULL THEN '99999'
	WHEN "brand"."brand_id" IS NOT NULL AND "model"."model_id" IS NULL THEN "brand"."brand_id" || '0000' 
	ELSE "model"."model_id" END as "vehicleModel", 
	"color"."color_id" as "vehicleColor",
	
	"car_act"."cmi_reference_number" as "ReferenceNumber",
	"car_act"."cmi_receive_number" as "ReceiveNumber",
	CASE
	WHEN CURRENT_DATE < ("car_act"."Start_date" + INTERVAL '7 HOUR')::DATE THEN
	
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR("endorse"."effective_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	ELSE
	
	TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR', 'yyyymmdd')
	END as "EndorseEffectiveDt",
	"endorse"."SF_Policy_id" as "EndorseRefNumber",
	
	'N' as "EndorseFlag" 
	FROM insurverse."Policy_endorse_detail" as "endorse"
	INNER JOIN insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
	ON "endorse"."SF_Policy_id" is not null
	AND "endorse"."Car_Act_No"="car_act"."Car_Act_No"
	INNER JOIN insurverse."company_detail" as "comp" 
	ON "car_act"."Comp_Code"="comp"."comp_code"
	LEFT JOIN insurverse."mas_cmi_province" as "province" ON CAST(NULLIF("car_act"."Car_license_provice",'') as INT)="province"."provinceid" 
	LEFT JOIN (SELECT DISTINCT brand_id, brand_name FROM insurverse."mas_cmi_brand_model") as "brand"
	ON UPPER("car_act"."Brand")=UPPER("brand"."brand_name")
	LEFT JOIN (SELECT DISTINCT brand_name, model_id, model_name FROM insurverse."mas_cmi_brand_model") as "model" 
	ON UPPER("car_act"."Brand")=UPPER("model"."brand_name") AND UPPER("car_act"."Model")=UPPER("model"."model_name")
	LEFT JOIN insurverse."mas_cmi_color" as "color" ON "car_act"."Car_color"="color"."color_name_th" OR "car_act"."Car_color"="color"."color_id"
	LEFT JOIN insurverse."tqm_lead_cmi" AS "cmi" ON "cmi".policy_number = "endorse"."Car_Act_No"
	
	
), n as materialized (
	SELECT 
	"comp"."regist_id" as "companyCode",
	"car_act"."Car_Act_No" as "policyNumber",
	CASE WHEN c.contract_dt > TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
		THEN TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE c.contract_dt
	END AS "contractDt",
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "effectiveDt",
	TO_CHAR("car_act"."End_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "endDt",
	"car_act"."Car_Comp_Code" as "vehicleTypeCode",
	"province"."cmi_prov_id" as "registeredProvinceCode", 
	"car_act"."Car_license_no" as "plateNumber",
	"car_act"."Car_serial_no" as "chassisVINNumber",
	"car_act"."citizen_id" as "insuredUniqueID",
	"car_act"."first_name" as "insuredName",
	"car_act"."last_name" as "insuredSurname",
	'THA' as "country",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' THEN 'ว00019/2546' ELSE "comp"."regist_id" END AS "agentBrokerLicenseNumber",
	CASE WHEN "brand"."brand_id" IS NULL THEN '99999' ELSE "brand"."brand_id" END as "vehicleBrand", 
	CASE WHEN "brand"."brand_id" IS NULL AND "model"."model_id" IS NULL THEN '99999'
	WHEN "brand"."brand_id" IS NOT NULL AND "model"."model_id" IS NULL THEN "brand"."brand_id" || '0000' 
	ELSE "model"."model_id" END as "vehicleModel", 
	"color"."color_id" as "vehicleColor",
	
	"car_act"."cmi_reference_number" as "ReferenceNumber",
	"car_act"."cmi_receive_number" as "ReceiveNumber",
	CASE
	WHEN CURRENT_DATE < ("car_act"."Start_date" + INTERVAL '7 HOUR')::DATE THEN
	
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR("endorse"."effective_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	ELSE
	
	TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR', 'yyyymmdd')
	END as "EndorseEffectiveDt",
	"endorse"."SF_Policy_id" as "EndorseRefNumber",
	
	'N' as "EndorseFlag" 
	FROM insurverse."Policy_endorse_detail" as "endorse"
	INNER JOIN insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
	ON "endorse"."SF_Policy_id" is not null
	AND "endorse"."Car_Act_No"="car_act"."Car_Act_No"
	INNER JOIN insurverse."company_detail" as "comp" 
	ON "car_act"."Comp_Code"="comp"."comp_code"
	LEFT JOIN insurverse."mas_cmi_province" as "province" ON CAST(NULLIF("car_act"."Car_license_provice",'') as INT)="province"."provinceid" 
	LEFT JOIN (SELECT DISTINCT brand_id, brand_name FROM insurverse."mas_cmi_brand_model") as "brand"
	ON UPPER("car_act"."Brand")=UPPER("brand"."brand_name")
	LEFT JOIN (SELECT DISTINCT brand_name, model_id, model_name FROM insurverse."mas_cmi_brand_model") as "model" 
	ON UPPER("car_act"."Brand")=UPPER("model"."brand_name") AND UPPER("car_act"."Model")=UPPER("model"."model_name")
	LEFT JOIN insurverse."mas_cmi_color" as "color" ON "car_act"."Car_color"="color"."color_name_th" OR "car_act"."Car_color"="color"."color_id"
	LEFT JOIN insurverse."tqm_lead_cmi" AS "cmi" ON "cmi".policy_number = "endorse"."Car_Act_No"
	CROSS JOIN LATERAL (SELECT CASE WHEN UPPER("car_act".partner_code) = 'TQM'
		THEN TO_CHAR(TO_TIMESTAMP(cmi.contract_date, 'DD/MM/YYYY') + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE TO_CHAR("car_act"."Create_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	END AS contract_dt) AS c
	
	
) select 'changed only contractDt', count(*) from n join o using ("EndorseRefNumber","policyNumber") where (to_jsonb(n.*)-'contractDt')=(to_jsonb(o.*)-'contractDt') and n."contractDt" is distinct from o."contractDt";
with o as materialized (
	SELECT 
	"comp"."regist_id" as "companyCode",
	"car_act"."Car_Act_No" as "policyNumber",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR(TO_TIMESTAMP(cmi.contract_date, 'DD/MM/YYYY') + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE TO_CHAR("car_act"."Create_date" + INTERVAL '7 HOUR', 'yyyymmdd') 
	END AS "contractDt",
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "effectiveDt",
	TO_CHAR("car_act"."End_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "endDt",
	"car_act"."Car_Comp_Code" as "vehicleTypeCode",
	"province"."cmi_prov_id" as "registeredProvinceCode", 
	"car_act"."Car_license_no" as "plateNumber",
	"car_act"."Car_serial_no" as "chassisVINNumber",
	"car_act"."citizen_id" as "insuredUniqueID",
	"car_act"."first_name" as "insuredName",
	"car_act"."last_name" as "insuredSurname",
	'THA' as "country",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' THEN 'ว00019/2546' ELSE "comp"."regist_id" END AS "agentBrokerLicenseNumber",
	CASE WHEN "brand"."brand_id" IS NULL THEN '99999' ELSE "brand"."brand_id" END as "vehicleBrand", 
	CASE WHEN "brand"."brand_id" IS NULL AND "model"."model_id" IS NULL THEN '99999'
	WHEN "brand"."brand_id" IS NOT NULL AND "model"."model_id" IS NULL THEN "brand"."brand_id" || '0000' 
	ELSE "model"."model_id" END as "vehicleModel", 
	"color"."color_id" as "vehicleColor",
	
	"car_act"."cmi_reference_number" as "ReferenceNumber",
	"car_act"."cmi_receive_number" as "ReceiveNumber",
	CASE
	WHEN CURRENT_DATE < ("car_act"."Start_date" + INTERVAL '7 HOUR')::DATE THEN
	
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR("endorse"."effective_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	ELSE
	
	TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR', 'yyyymmdd')
	END as "EndorseEffectiveDt",
	"endorse"."SF_Policy_id" as "EndorseRefNumber",
	
	'N' as "EndorseFlag" 
	FROM insurverse."Policy_endorse_detail" as "endorse"
	INNER JOIN insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
	ON "endorse"."SF_Policy_id" is not null
	AND "endorse"."Car_Act_No"="car_act"."Car_Act_No"
	INNER JOIN insurverse."company_detail" as "comp" 
	ON "car_act"."Comp_Code"="comp"."comp_code"
	LEFT JOIN insurverse."mas_cmi_province" as "province" ON CAST(NULLIF("car_act"."Car_license_provice",'') as INT)="province"."provinceid" 
	LEFT JOIN (SELECT DISTINCT brand_id, brand_name FROM insurverse."mas_cmi_brand_model") as "brand"
	ON UPPER("car_act"."Brand")=UPPER("brand"."brand_name")
	LEFT JOIN (SELECT DISTINCT brand_name, model_id, model_name FROM insurverse."mas_cmi_brand_model") as "model" 
	ON UPPER("car_act"."Brand")=UPPER("model"."brand_name") AND UPPER("car_act"."Model")=UPPER("model"."model_name")
	LEFT JOIN insurverse."mas_cmi_color" as "color" ON "car_act"."Car_color"="color"."color_name_th" OR "car_act"."Car_color"="color"."color_id"
	LEFT JOIN insurverse."tqm_lead_cmi" AS "cmi" ON "cmi".policy_number = "endorse"."Car_Act_No"
	
	
), n as materialized (
	SELECT 
	"comp"."regist_id" as "companyCode",
	"car_act"."Car_Act_No" as "policyNumber",
	CASE WHEN c.contract_dt > TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
		THEN TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE c.contract_dt
	END AS "contractDt",
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "effectiveDt",
	TO_CHAR("car_act"."End_date" + INTERVAL '7 HOUR', 'yyyymmdd') as "endDt",
	"car_act"."Car_Comp_Code" as "vehicleTypeCode",
	"province"."cmi_prov_id" as "registeredProvinceCode", 
	"car_act"."Car_license_no" as "plateNumber",
	"car_act"."Car_serial_no" as "chassisVINNumber",
	"car_act"."citizen_id" as "insuredUniqueID",
	"car_act"."first_name" as "insuredName",
	"car_act"."last_name" as "insuredSurname",
	'THA' as "country",
	CASE WHEN UPPER("car_act".partner_code) = 'TQM' THEN 'ว00019/2546' ELSE "comp"."regist_id" END AS "agentBrokerLicenseNumber",
	CASE WHEN "brand"."brand_id" IS NULL THEN '99999' ELSE "brand"."brand_id" END as "vehicleBrand", 
	CASE WHEN "brand"."brand_id" IS NULL AND "model"."model_id" IS NULL THEN '99999'
	WHEN "brand"."brand_id" IS NOT NULL AND "model"."model_id" IS NULL THEN "brand"."brand_id" || '0000' 
	ELSE "model"."model_id" END as "vehicleModel", 
	"color"."color_id" as "vehicleColor",
	
	"car_act"."cmi_reference_number" as "ReferenceNumber",
	"car_act"."cmi_receive_number" as "ReceiveNumber",
	CASE
	WHEN CURRENT_DATE < ("car_act"."Start_date" + INTERVAL '7 HOUR')::DATE THEN
	
	TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	WHEN UPPER("car_act".partner_code) = 'TQM' 
		THEN TO_CHAR("endorse"."effective_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	ELSE
	
	TO_CHAR("endorse"."create_at" + INTERVAL '7 HOUR', 'yyyymmdd')
	END as "EndorseEffectiveDt",
	"endorse"."SF_Policy_id" as "EndorseRefNumber",
	
	'N' as "EndorseFlag" 
	FROM insurverse."Policy_endorse_detail" as "endorse"
	INNER JOIN insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
	ON "endorse"."SF_Policy_id" is not null
	AND "endorse"."Car_Act_No"="car_act"."Car_Act_No"
	INNER JOIN insurverse."company_detail" as "comp" 
	ON "car_act"."Comp_Code"="comp"."comp_code"
	LEFT JOIN insurverse."mas_cmi_province" as "province" ON CAST(NULLIF("car_act"."Car_license_provice",'') as INT)="province"."provinceid" 
	LEFT JOIN (SELECT DISTINCT brand_id, brand_name FROM insurverse."mas_cmi_brand_model") as "brand"
	ON UPPER("car_act"."Brand")=UPPER("brand"."brand_name")
	LEFT JOIN (SELECT DISTINCT brand_name, model_id, model_name FROM insurverse."mas_cmi_brand_model") as "model" 
	ON UPPER("car_act"."Brand")=UPPER("model"."brand_name") AND UPPER("car_act"."Model")=UPPER("model"."model_name")
	LEFT JOIN insurverse."mas_cmi_color" as "color" ON "car_act"."Car_color"="color"."color_name_th" OR "car_act"."Car_color"="color"."color_id"
	LEFT JOIN insurverse."tqm_lead_cmi" AS "cmi" ON "cmi".policy_number = "endorse"."Car_Act_No"
	CROSS JOIN LATERAL (SELECT CASE WHEN UPPER("car_act".partner_code) = 'TQM'
		THEN TO_CHAR(TO_TIMESTAMP(cmi.contract_date, 'DD/MM/YYYY') + INTERVAL '7 HOUR', 'yyyymmdd')
		ELSE TO_CHAR("car_act"."Create_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	END AS contract_dt) AS c
	
	
) select 'old contractDt>effectiveDt', count(*) from o where "contractDt">"effectiveDt" union all select 'new contractDt>effectiveDt', count(*) from n where "contractDt">"effectiveDt" union all select 'new contractDt null', count(*) from n where "contractDt" is null union all select 'old contractDt null', count(*) from o where "contractDt" is null;