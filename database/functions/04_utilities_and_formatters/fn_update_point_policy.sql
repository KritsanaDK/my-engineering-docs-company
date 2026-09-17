-- =============================================================================
-- Function: insurverse.fn_update_point_policy
-- OID: 18940
-- Identity Arguments: (in_policy_type text, in_policy_no text)
-- Returns: TABLE(rtn_success boolean, rtn_msg text, rtn_point numeric, rtn_have_referal_code boolean, rtn_app_noti_id integer, rtn_ref_app_noti_id integer)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_point_policy(in_policy_type text, in_policy_no text)
 RETURNS TABLE(rtn_success boolean, rtn_msg text, rtn_point numeric, rtn_have_referal_code boolean, rtn_app_noti_id integer, rtn_ref_app_noti_id integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_SUCCESS BOOL; RTN_MSG TEXT; RTN_POINT NUMERIC DEFAULT 0;
RTN_HAVE_CODE BOOL; RTN_APP_NOTI_ID INT; RTN_REF_APP_NOTI_ID INT;
SYS_POLICY_GROUP TEXT; SYS_POINT_MULTI INT;
SYS_REMARK TEXT; 
SYS_PURCHASE_POINT NUMERIC DEFAULT 0;
SYS_REFERAL_POINT NUMERIC DEFAULT 0;
SYS_LEAD_TYPE TEXT;
Q_POLICY_NO TEXT; Q_POLICY_TYPE TEXT; 
Q_LEAD_NO INT;
Q_EMAIL TEXT; Q_USER_ID TEXT;
Q_LOYALTY_CON_ID INT;
Q_POLICY_TOTAL_AMT NUMERIC(16,4);
Q_AMT_PER_POINT NUMERIC(16,4);
Q_POINT_EARN NUMERIC(16,4);
Q_POINT_EARN_MIN NUMERIC(16,4);
Q_POINT_EARN_MAX NUMERIC(16,4);
Q_POINT_TRANS_ID INT;
Q_REFERAL_SOURCE TEXT; Q_REFERAL_CODE TEXT; Q_REFERAL_USER_ID TEXT;
TXT_NOTI_SUBJECT TEXT; TXT_NOTI_BODY TEXT; USER_POINT NUMERIC;
TXT_NOTO_POLICY_TYPE TEXT;
BEGIN
  RTN_SUCCESS = true;
	RTN_HAVE_CODE = false;
	IF "in_policy_type"='mv' THEN
		SYS_POLICY_GROUP = 'motor';
		SELECT "prem"."Policy_No","prem"."Type","prem"."Total_Amt",
		"policy"."email","sec_user"."user_id",
		"lead"."Lead_No","lead"."referal_source","lead"."referal_code",
		CASE WHEN "policy"."Car_Act_No" IS NULL THEN 'mv' ELSE 'mv+mc' END
		FROM insurverse."Policy_coverage_premium" as "prem"
		INNER JOIN insurverse."Policy_Header" as "policy"
		ON "prem"."Policy_No"="policy"."Policy_No"
		INNER JOIN insurverse."sec_user"
		ON "policy"."email"="sec_user"."email"
		INNER JOIN insurverse."Lead_coverage_premium" AS "lead"
		ON "prem"."Lead_No"="lead"."Lead_No"
		WHERE "prem"."Policy_No"="in_policy_no"
		INTO Q_POLICY_NO,Q_POLICY_TYPE,Q_POLICY_TOTAL_AMT,Q_EMAIL,Q_USER_ID,
		Q_LEAD_NO,Q_REFERAL_SOURCE,Q_REFERAL_CODE,SYS_LEAD_TYPE;
		TXT_NOTO_POLICY_TYPE = 'ประกันชั้น ' || Q_POLICY_TYPE;
	ELSIF "in_policy_type"='mc' THEN
		SYS_POLICY_GROUP = 'motor';
		TXT_NOTO_POLICY_TYPE = 'ประกัน พ.ร.บ.';
		SELECT "act"."Car_Act_No",'0',"act"."Total",
		"act"."email","sec_user"."user_id",
		CASE WHEN "lead_act"."Car_Act_Lead_No" IS NOT NULL THEN "lead_act"."Car_Act_Lead_No" ELSE "lead"."Lead_No" END,
		CASE WHEN "lead_act"."Car_Act_Lead_No" IS NOT NULL THEN "lead_act"."referal_source" ELSE "lead"."referal_source" END,
		CASE WHEN "lead_act"."Car_Act_Lead_No" IS NOT NULL THEN "lead_act"."referal_code" ELSE "lead"."referal_code" END,
		CASE WHEN "lead_act"."Car_Act_Lead_No" IS NOT NULL THEN 'mc' ELSE 'mv+mc' END
		FROM insurverse."Policy_Car_Act_Discount_Premium" as "act"
		INNER JOIN insurverse."sec_user"
		ON "act"."email"="sec_user"."email"
		LEFT JOIN insurverse."Lead_Car_Act_Discount_Premium" AS "lead_act"
		ON ("act"."Policy_No" IS NULL OR "act"."Policy_No" = '')
		AND "act"."Car_Act_Lead_No" IS NOT NULL
		AND "act"."Car_Act_Lead_No"="lead_act"."Car_Act_Lead_No"
		LEFT JOIN insurverse."Lead_coverage_premium" AS "lead"
		ON "act"."Policy_No" IS NOT NULL AND "act"."Policy_No" != ''
		AND "act"."Lead_No" IS NOT NULL
		AND "act"."Lead_No"="lead"."Lead_No"
		WHERE "Car_Act_No"="in_policy_no"
		INTO Q_POLICY_NO,Q_POLICY_TYPE,Q_POLICY_TOTAL_AMT,Q_EMAIL,Q_USER_ID,
		Q_LEAD_NO,Q_REFERAL_SOURCE,Q_REFERAL_CODE,SYS_LEAD_TYPE;
	ELSIF "in_policy_type"='pa' THEN
		SYS_POLICY_GROUP = 'pa';
		TXT_NOTO_POLICY_TYPE = 'ประกันอุบัติเหตุ';
		SELECT "policy_pa"."policy_pa_no",'pa',"policy_pa"."total_amt",
		"policy_pa"."email","sec_user"."user_id",
		"policy_pa"."lead_pa_no",
		"policy_pa"."referal_source",
		"policy_pa"."referal_code",
		'pa'
		FROM insurverse."policy_pa_premium" as "policy_pa"
		INNER JOIN insurverse."sec_user"
		ON "policy_pa"."email"="sec_user"."email"
		WHERE "policy_pa_no"="in_policy_no"
		INTO Q_POLICY_NO,Q_POLICY_TYPE,Q_POLICY_TOTAL_AMT,Q_EMAIL,Q_USER_ID,
		Q_LEAD_NO,Q_REFERAL_SOURCE,Q_REFERAL_CODE,SYS_LEAD_TYPE;
	ELSIF "in_policy_type"='home' THEN
		SYS_POLICY_GROUP = 'home';
		TXT_NOTO_POLICY_TYPE = 'ประกันบ้านและคอนโด';
		SELECT "policy_home"."policy_home_no","policy_home"."home_building_type_id","policy_home"."total_amt",
		"policy_home"."email","sec_user"."user_id",
		"policy_home"."lead_home_no",
		"policy_home"."referal_source",
		"policy_home"."referal_code",
		'home'
		FROM insurverse."policy_home_premium" as "policy_home"
		INNER JOIN insurverse."sec_user"
		ON "policy_home"."email"="sec_user"."email"
		WHERE "policy_home_no"="in_policy_no"
		INTO Q_POLICY_NO,Q_POLICY_TYPE,Q_POLICY_TOTAL_AMT,Q_EMAIL,Q_USER_ID,
		Q_LEAD_NO,Q_REFERAL_SOURCE,Q_REFERAL_CODE,SYS_LEAD_TYPE;
	ELSIF "in_policy_type"='ta' THEN
		SYS_POLICY_GROUP = 'ta';
		TXT_NOTO_POLICY_TYPE = 'ประกันเดินทาง';
		SELECT "policy_ta"."policy_ta_no",'ta',"policy_ta"."total_amt",
		"policy_ta"."email","sec_user"."user_id",
		"policy_ta"."lead_ta_no",
		"policy_ta"."referal_source",
		"policy_ta"."referal_code",
		'ta'
		FROM insurverse."policy_ta_premium" as "policy_ta"
		INNER JOIN insurverse."sec_user"
		ON "policy_ta"."email"="sec_user"."email"
		WHERE "policy_ta_no"="in_policy_no"
		INTO Q_POLICY_NO,Q_POLICY_TYPE,Q_POLICY_TOTAL_AMT,Q_EMAIL,Q_USER_ID,
		Q_LEAD_NO,Q_REFERAL_SOURCE,Q_REFERAL_CODE,SYS_LEAD_TYPE;
	ELSE
		RTN_SUCCESS = false;
		RTN_MSG = 'Policy type not found.';
	END IF; 
	
	IF RTN_SUCCESS = true AND (Q_POLICY_NO IS NULL OR Q_POLICY_NO = '') THEN
		RTN_SUCCESS = false;
		RTN_MSG = 'Policy number not found.';
	END IF;
	
	-- CHECK REFERAL CODE
	IF RTN_SUCCESS = true AND Q_REFERAL_CODE IS NOT NULL AND Q_REFERAL_CODE != '' THEN
		SELECT "user_id"
		FROM insurverse."sec_user"
		WHERE UPPER(insurverse.crc32("user_id"))=Q_REFERAL_CODE 
		and "user_id"!=Q_USER_ID
		LIMIT 1
		INTO Q_REFERAL_USER_ID;
		/*
		IF Q_REFERAL_USER_ID IS NULL THEN
			RTN_SUCCESS = false;
			RTN_MSG = 'Referal code not found.';
		END IF; 
		*/
	END IF;
	
	-- PURCHASE POINT
	IF RTN_SUCCESS = true THEN
		SELECT "loyalty_con_id","amt_per_point","point_earn","point_earn_min","point_earn_max"
		FROM insurverse."loyalty_condition"
		WHERE "loyalty_con_status"='ACT'
		AND "group_type"=SYS_POLICY_GROUP 
		AND ("sub_group_type"=Q_POLICY_TYPE OR "sub_group_type" IS NULL OR "sub_group_type"='')
		AND "loyalty_point_type"='purchase'
		AND now() BETWEEN "effective_startdate" AND "effective_enddate"
		AND ((amt_min != 0 AND Q_POLICY_TOTAL_AMT >= amt_min) OR amt_min = 0)
		AND ((amt_max != 0 AND Q_POLICY_TOTAL_AMT <= amt_max) OR amt_max = 0)
		ORDER BY loyalty_con_id DESC
		LIMIT 1
		INTO Q_LOYALTY_CON_ID,Q_AMT_PER_POINT,Q_POINT_EARN,Q_POINT_EARN_MIN,Q_POINT_EARN_MAX;
		
		--RTN_MSG = 'Amount per Point : ' || Q_AMT_PER_POINT || ' / Point Earn : ' || Q_POINT_EARN;
		--RTN_MSG = RTN_MSG ||  ' / Point Earn Min : ' || Q_POINT_EARN_MIN || ' / Point Earn Max : ' || Q_POINT_EARN_MAX;
		
		IF Q_LOYALTY_CON_ID IS NOT NULL THEN
			IF Q_AMT_PER_POINT != 0 THEN
				SYS_POINT_MULTI = TRUNC(Q_POLICY_TOTAL_AMT / Q_AMT_PER_POINT,0);
				SYS_PURCHASE_POINT = TRUNC(Q_POINT_EARN * SYS_POINT_MULTI,0);
			ELSE
				SYS_PURCHASE_POINT = Q_POINT_EARN;
			END IF;
		ELSE 
			RTN_SUCCESS = false;
			RTN_MSG = 'Loyalty purchase condition not found.';
		END IF;
		
		IF RTN_SUCCESS = true AND Q_POINT_EARN_MIN IS NOT NULL AND Q_POINT_EARN_MIN != 0 AND SYS_PURCHASE_POINT < Q_POINT_EARN_MIN THEN
		SYS_PURCHASE_POINT = Q_POINT_EARN_MIN;
		END IF;
		IF RTN_SUCCESS = true AND Q_POINT_EARN_MIN IS NOT NULL AND Q_POINT_EARN_MIN != 0 AND SYS_PURCHASE_POINT > Q_POINT_EARN_MAX THEN
			SYS_PURCHASE_POINT = Q_POINT_EARN_MAX;
		END IF;
		IF RTN_SUCCESS = true AND SYS_PURCHASE_POINT != 0 THEN
			SELECT "point_trans_id"
			FROM insurverse."loyalty_point_trans"
			WHERE "user_id"=Q_USER_ID
			AND "policy_no"=Q_POLICY_NO
			AND "loyalty_con_id"=Q_LOYALTY_CON_ID
			LIMIT 1
			INTO Q_POINT_TRANS_ID;
			
			IF Q_POINT_TRANS_ID IS NULL THEN
				INSERT INTO insurverse."loyalty_point_trans"
				("user_id","point","expire_date","remark","loyalty_con_id","point_status",
				"lead_no","policy_no","policy_type","policy_group","lead_type")
				VALUES (Q_USER_ID,SYS_PURCHASE_POINT,(DATE_TRUNC('month', NOW() + INTERVAL'2 YEAR') + INTERVAL '24 days' - INTERVAL '7 HOUR'),SYS_REMARK,Q_LOYALTY_CON_ID,'ACT',
				Q_LEAD_NO,Q_POLICY_NO,Q_POLICY_TYPE,SYS_POLICY_GROUP,SYS_LEAD_TYPE);
				
				SELECT SUM("point") FROM insurverse.loyalty_point_trans
				WHERE "point_status"='ACT' AND user_id=Q_USER_ID
				INTO USER_POINT;
				
				IF SYS_PURCHASE_POINT IS NULL THEN
					SYS_PURCHASE_POINT = 0;
				END IF;
				IF TXT_NOTO_POLICY_TYPE IS NULL THEN
					TXT_NOTO_POLICY_TYPE = '-';
				END IF;
				IF USER_POINT IS NULL THEN
					USER_POINT = 0;
				END IF;
				
				TXT_NOTI_SUBJECT = 'แจ้งเตือนเมื่อได้รับ Point';
				TXT_NOTI_BODY = 'คุณได้รับ ' || REPLACE(to_char(SYS_PURCHASE_POINT,'999,999,990'),' ','') || ' คะแนน จากการ ซื้อ' || TXT_NOTO_POLICY_TYPE || ' ที่ insurverse คะแนนทั้งหมดของคุณ คือ ' ||  REPLACE(to_char(USER_POINT,'999,999,990'),' ','') || ' คะแนน';
				
				INSERT INTO "insurverse"."app_notification" 
				("source", "noti_type", "subject", "message", "icon_type", "user_id","is_active") 
				VALUES ('fn_point_purchase', 'p_get', TXT_NOTI_SUBJECT, TXT_NOTI_BODY, NULL, Q_USER_ID, TRUE)
				RETURNING app_noti_id
				INTO RTN_APP_NOTI_ID;
				
				RTN_POINT = RTN_POINT + SYS_PURCHASE_POINT;
			END IF;
		END IF;
	END IF;
	
	
	-- REFERAL CODE
	IF RTN_SUCCESS = true AND Q_REFERAL_USER_ID IS NOT NULL AND Q_REFERAL_USER_ID != '' THEN
		SELECT "loyalty_con_id","amt_per_point","point_earn","point_earn_min","point_earn_max"
		FROM insurverse."loyalty_condition"
		WHERE "loyalty_con_status"='ACT'
		AND "group_type"=SYS_POLICY_GROUP
		AND ("sub_group_type"=Q_POLICY_TYPE OR "sub_group_type" IS NULL OR "sub_group_type"='')
		AND "loyalty_point_type"='referal'
		AND now() BETWEEN "effective_startdate" AND "effective_enddate"
		AND ((amt_min != 0 AND Q_POLICY_TOTAL_AMT >= amt_min) OR amt_min = 0)
		AND ((amt_max != 0 AND Q_POLICY_TOTAL_AMT <= amt_max) OR amt_max = 0)
		ORDER BY loyalty_con_id DESC
		LIMIT 1
		INTO Q_LOYALTY_CON_ID,Q_AMT_PER_POINT,Q_POINT_EARN,Q_POINT_EARN_MIN,Q_POINT_EARN_MAX;
		
		IF Q_LOYALTY_CON_ID IS NOT NULL THEN
			IF Q_AMT_PER_POINT != 0 THEN
				SYS_POINT_MULTI = TRUNC(Q_POLICY_TOTAL_AMT / Q_AMT_PER_POINT,0);
				SYS_REFERAL_POINT = TRUNC(Q_POINT_EARN * SYS_POINT_MULTI,0);
			ELSE
				SYS_REFERAL_POINT = Q_POINT_EARN;
			END IF;
		ELSE 
			RTN_SUCCESS = false;
			RTN_MSG = 'Loyalty referal condition not found.';
		END IF;
		
		IF RTN_SUCCESS = true AND Q_POINT_EARN_MIN IS NOT NULL AND Q_POINT_EARN_MIN != 0 AND SYS_REFERAL_POINT < Q_POINT_EARN_MIN THEN
			SYS_REFERAL_POINT = Q_POINT_EARN_MIN;
		END IF;
		IF RTN_SUCCESS = true AND Q_POINT_EARN_MIN IS NOT NULL AND Q_POINT_EARN_MIN != 0 AND SYS_REFERAL_POINT > Q_POINT_EARN_MAX THEN
			SYS_REFERAL_POINT = Q_POINT_EARN_MAX;
		END IF;
		IF RTN_SUCCESS = true AND SYS_REFERAL_POINT != 0 THEN
			SELECT "point_trans_id"
			FROM insurverse."loyalty_point_trans"
			WHERE "user_id"=Q_USER_ID
			AND "policy_no"=Q_POLICY_NO
			AND "loyalty_con_id"=Q_LOYALTY_CON_ID
			LIMIT 1
			INTO Q_POINT_TRANS_ID;
			
			IF Q_POINT_TRANS_ID IS NULL THEN
				INSERT INTO insurverse."loyalty_point_trans"
				("user_id","point","expire_date","remark","loyalty_con_id","point_status",
				"lead_no","policy_no","policy_type","policy_group","lead_type","referral_code")
				VALUES (Q_REFERAL_USER_ID,SYS_REFERAL_POINT,(DATE_TRUNC('month', NOW() + INTERVAL'2 YEAR') + INTERVAL '24 days' - INTERVAL '7 HOUR'),SYS_REMARK,Q_LOYALTY_CON_ID,'ACT',
				Q_LEAD_NO,Q_POLICY_NO,Q_POLICY_TYPE,SYS_POLICY_GROUP,SYS_LEAD_TYPE,Q_REFERAL_USER_ID);
				
				SELECT SUM("point") FROM insurverse.loyalty_point_trans
				WHERE "point_status"='ACT' AND user_id=Q_REFERAL_USER_ID
				INTO USER_POINT;
				
				IF SYS_REFERAL_POINT IS NULL THEN
					SYS_REFERAL_POINT = 0;
				END IF;
				IF TXT_NOTO_POLICY_TYPE IS NULL THEN
					TXT_NOTO_POLICY_TYPE = '-';
				END IF;
				IF USER_POINT IS NULL THEN
					USER_POINT = 0;
				END IF;
				
				TXT_NOTI_SUBJECT = 'แจ้งเตือนเมื่อได้รับ Point';
				TXT_NOTI_BODY = 'คุณได้รับ ' || REPLACE(to_char(SYS_REFERAL_POINT,'999,999,990'),' ','') || ' คะแนน จากการ แนะนำซื้อ' || TXT_NOTO_POLICY_TYPE || ' ที่ insurverse คะแนนทั้งหมดของคุณ คือ ' || REPLACE(to_char(USER_POINT,'999,999,990'),' ','') || ' คะแนน';
				
				INSERT INTO "insurverse"."app_notification" 
				("source", "noti_type", "subject", "message", "icon_type", "user_id","is_active") 
				VALUES ('fn_point_referal', 'p_get', TXT_NOTI_SUBJECT, TXT_NOTI_BODY, NULL, Q_REFERAL_USER_ID, TRUE)
				RETURNING app_noti_id
				INTO RTN_REF_APP_NOTI_ID;
								
				RTN_HAVE_CODE = true;
				RTN_POINT = RTN_POINT + SYS_REFERAL_POINT;
			END IF;
		END IF;
	END IF;
	
	
	RETURN QUERY SELECT RTN_SUCCESS,RTN_MSG,RTN_POINT,RTN_HAVE_CODE,RTN_APP_NOTI_ID,RTN_REF_APP_NOTI_ID;
END
$function$
