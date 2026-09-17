-- =============================================================================
-- Function: insurverse.fn_policy_renewal_inspect_email
-- OID: 18730
-- Identity Arguments: (in_policy_no text)
-- Returns: TABLE(rtn_policy_no text, rtn_is_send_email boolean, rtn_car_license_no text, rtn_car_license_province text, rtn_owner_first_name text, rtn_owner_last_name text, rtn_update_inspect boolean)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_inspect_email(in_policy_no text)
 RETURNS TABLE(rtn_policy_no text, rtn_is_send_email boolean, rtn_car_license_no text, rtn_car_license_province text, rtn_owner_first_name text, rtn_owner_last_name text, rtn_update_inspect boolean)
 LANGUAGE plpgsql
AS $function$
	DECLARE
	RTN_POLICY_NO TEXT; RTN_IS_SEND_EMAIL BOOLEAN;
	RTN_CAR_LICENSE_NO TEXT; RTN_CAR_LICENSE_PROVINCE TEXT;
	RTN_OWNER_FIRST_NAME TEXT; RTN_OWNER_LAST_NAME TEXT;
	RTN_UPDATE_INSPECT BOOLEAN;
	-- QUERY
	Q_NEW_POLICY_NO TEXT; Q_REF_POLICY_NO TEXT; Q_IS_SEND_EMAIL BOOLEAN; Q_REMARK TEXT;
	Q_NEW_TYPE TEXT; Q_REF_TYPE TEXT; Q_NEW_CCTV TEXT; Q_REF_CCTV TEXT;
	Q_NEW_ACCESS TEXT; Q_REF_ACCESS TEXT; Q_NEW_ACCESS_CODE TEXT; Q_REF_ACCESS_CODE TEXT;
	Q_CAR_LICENSE_NO TEXT; Q_CAR_LICENSE_PROVINCE TEXT;
	Q_OWNER_PREFIX_NAME TEXT; Q_OWNER_FIRST_NAME TEXT; Q_OWNER_LAST_NAME TEXT;
	-- LOG
	L_ID INTEGER; L_POLICY_NO TEXT;
	BEGIN
	/*
	select rtn_policy_no,rtn_is_send_email,rtn_car_license_no,rtn_car_license_province,rtn_owner_first_name,rtn_owner_last_name
	from insurverse.fn_policy_renewal_inspect_email('MV-0024-B-002091') -- กรมธรรม์ใหม่
	*/
	RTN_UPDATE_INSPECT = true;
	
	with set_para as (select
	"in_policy_no" as "new_policy_no"
	)
	select "policy"."Policy_No" as "policy_no","policy"."ref_policy_no" as "ref_policy_no",
	CASE WHEN ("policy"."Type"='1' AND "ref_policy"."Type"!='1') OR 
	("policy"."Type"='1' AND 
	(("prem"."Flag_CCTV"='Y' AND "prem"."Flag_CCTV" != "ref_prem"."Flag_CCTV") 
	OR ("prem"."Flag_Access"='Y' AND "prem"."Flag_Access" != "ref_prem"."Flag_Access")
	OR ("prem"."Flag_Access"='Y' AND "prem"."Access_para_code" != "ref_prem"."Access_para_code"))) 
	THEN true else false end as "is_send_email",
	CASE WHEN "policy"."Type"='1' AND "ref_policy"."Type"!='1' THEN ' เดิมประกันชั้น ' || "ref_policy"."Type" || ' ต่ออายุเป็นประกันชั้น ' || "policy"."Type" else '' end 
	|| CASE WHEN "policy"."Type"='1' AND "prem"."Flag_CCTV"='Y' AND "prem"."Flag_CCTV" != "ref_prem"."Flag_CCTV" THEN ' เพิ่มส่วนลดกล้อง' else '' end 
	|| CASE WHEN "policy"."Type"='1' AND "prem"."Flag_Access"='Y' AND "prem"."Flag_Access" != "ref_prem"."Flag_Access" THEN ' เพิ่มความคุ้มครองอุปกรณ์ตกแต่ง' else '' end 
	|| CASE WHEN "policy"."Type"='1' AND "prem"."Flag_Access"='Y' AND "prem"."Access_para_code" != "ref_prem"."Access_para_code" THEN ' เดิมอุปกรณ์ตกแต่ง ' || insurverse.fn_display_access("ref_prem"."Access_para_code") || ' ปรับเป็น ' || insurverse.fn_display_access("prem"."Access_para_code") else '' end 
	as "remark",
	"policy"."Type" as "new_type",
	"ref_policy"."Type" as "ref_type",
	COALESCE("prem"."Flag_CCTV",'N') as "new_cctv",
	COALESCE("ref_prem"."Flag_CCTV",'N') as "ref_cctv",
	COALESCE("prem"."Flag_Access",'N') as "new_access",
	COALESCE("ref_prem"."Flag_Access",'N') as "ref_access",
	COALESCE("prem"."Access_para_code",'') as "new_access_code",
	COALESCE("ref_prem"."Access_para_code",'') as "ref_access_code",
	"policy"."Car_license_no" as "email_car_license_no",
	(select "prname" from insurverse."province" where "provinceid" = "policy"."Car_license_provice") as "email_car_license_province",
	"policy"."Owner_prefix_name" as "email_owner_prefix_name",
	"policy"."Owner_first_name" as "email_owner_first_name",
	"policy"."Owner_last_name" as "email_owner_last_name"
	from set_para
	inner join insurverse."Policy_Header" as "policy"
	on "new_policy_no"="policy"."Policy_No"
	--on "policy"."ref_policy_no" is not null and "policy"."ref_policy_no" != ''
	inner join insurverse."Policy_coverage_premium" as "prem"
	on "policy"."Policy_No"="prem"."Policy_No"
	inner join insurverse."Policy_Header" as "ref_policy"
	on "policy"."ref_policy_no"="ref_policy"."Policy_No"
	inner join insurverse."Policy_coverage_premium" as "ref_prem"
	on "ref_policy"."Policy_No"="ref_prem"."Policy_No"
	INTO Q_NEW_POLICY_NO,Q_REF_POLICY_NO,Q_IS_SEND_EMAIL,Q_REMARK,
	Q_NEW_TYPE,Q_REF_TYPE,Q_NEW_CCTV,Q_REF_CCTV,
	Q_NEW_ACCESS,Q_REF_ACCESS,Q_NEW_ACCESS_CODE,Q_REF_ACCESS_CODE,
	Q_CAR_LICENSE_NO,Q_CAR_LICENSE_PROVINCE,
	Q_OWNER_PREFIX_NAME,Q_OWNER_FIRST_NAME,Q_OWNER_LAST_NAME;
	
	IF Q_NEW_POLICY_NO IS NULL OR (Q_REF_TYPE!='1' AND Q_NEW_TYPE='1') THEN
		RTN_UPDATE_INSPECT = false;
	END IF;
	
	RTN_POLICY_NO = Q_NEW_POLICY_NO;
	RTN_IS_SEND_EMAIL = Q_IS_SEND_EMAIL;
	RTN_CAR_LICENSE_NO = Q_CAR_LICENSE_NO;
	RTN_CAR_LICENSE_PROVINCE = Q_CAR_LICENSE_PROVINCE;
	RTN_OWNER_FIRST_NAME = Q_OWNER_FIRST_NAME;
	RTN_OWNER_LAST_NAME = Q_OWNER_LAST_NAME;
	
	SELECT "id"
	FROM insurverse.log_email_renewal
	where "policy_no"=Q_NEW_POLICY_NO
	INTO L_ID;
	
	IF L_ID IS NOT NULL THEN
		UPDATE "insurverse"."log_email_renewal" 
		SET "is_send_email" = Q_IS_SEND_EMAIL, "remark" = Q_REMARK, "update_at"=now()
		WHERE "id" = L_ID;
	ELSE 
		INSERT INTO "insurverse"."log_email_renewal" 
		("create_at", "policy_no", "is_send_email", "remark") 
		VALUES (now(), Q_NEW_POLICY_NO, Q_IS_SEND_EMAIL, Q_REMARK);
	END IF;
  
	RETURN QUERY SELECT RTN_POLICY_NO,RTN_IS_SEND_EMAIL,RTN_CAR_LICENSE_NO,RTN_CAR_LICENSE_PROVINCE,RTN_OWNER_FIRST_NAME,RTN_OWNER_LAST_NAME,RTN_UPDATE_INSPECT;
END
$function$
