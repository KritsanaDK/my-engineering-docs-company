with d as (SELECT "car_act".partner_code as pc, "car_act".cmi_reference_number as ref, 
	"comp"."regist_id" as "companyCode",
	"car_act"."Car_Act_No" as "policyNumber",
	CASE WHEN CAST("car_act"."Effective_Startdate" + INTERVAL '7 HOUR' AS DATE) < CAST("car_act"."Start_date" + INTERVAL '7 HOUR' AS DATE)
	THEN TO_CHAR("car_act"."Effective_Startdate" + INTERVAL '7 HOUR', 'yyyymmdd')
	ELSE TO_CHAR("car_act"."Start_date" + INTERVAL '7 HOUR', 'yyyymmdd')
	END as "contractDt", 
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
	"color"."color_id" as "vehicleColor"
	FROM insurverse."Policy_Car_Act_Discount_Premium" as "car_act"
	INNER JOIN insurverse."company_detail" as "comp" 
	ON "car_act"."Comp_Code"="comp"."comp_code"
	LEFT JOIN insurverse."mas_cmi_province" as "province" ON CAST(NULLIF("car_act"."Car_license_provice",'') as INT)="province"."provinceid" 
	LEFT JOIN (SELECT DISTINCT brand_id, brand_name FROM insurverse."mas_cmi_brand_model") as "brand"
	ON UPPER("car_act"."Brand")=UPPER("brand"."brand_name")
	LEFT JOIN (SELECT DISTINCT brand_name, model_id, model_name FROM insurverse."mas_cmi_brand_model") as "model" 
	ON UPPER("car_act"."Brand")=UPPER("model"."brand_name") AND UPPER("car_act"."Model")=UPPER("model"."model_name")
	LEFT JOIN insurverse."mas_cmi_color" as "color" ON "car_act"."Car_color"="color"."color_name_th" OR "car_act"."Car_color"="color"."color_id"
	) select 'acts', count(*), 'blocks', count(*) filter (where coalesce("contractDt",'')='' or coalesce("effectiveDt",'')='' or coalesce("endDt",'')='' or coalesce(trim("vehicleTypeCode"),'')='' or char_length("vehicleTypeCode")>5 or coalesce(trim("registeredProvinceCode"),'')='' or char_length("registeredProvinceCode")>2 or coalesce(trim("plateNumber"),'')='' or char_length("plateNumber")>20 or coalesce(trim("chassisVINNumber"),'')='' or char_length("chassisVINNumber")>50), 'blocks but OIC accepted', count(*) filter (where (coalesce("contractDt",'')='' or coalesce("effectiveDt",'')='' or coalesce("endDt",'')='' or coalesce(trim("vehicleTypeCode"),'')='' or char_length("vehicleTypeCode")>5 or coalesce(trim("registeredProvinceCode"),'')='' or char_length("registeredProvinceCode")>2 or coalesce(trim("plateNumber"),'')='' or char_length("plateNumber")>20 or coalesce(trim("chassisVINNumber"),'')='' or char_length("chassisVINNumber")>50) and coalesce(ref,'')<>'') from d;
