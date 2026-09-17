-- =============================================================================
-- Function: insurverse.fn_update_point_cancel
-- OID: 18920
-- Identity Arguments: (in_policy_type text, in_policy_no text)
-- Returns: TABLE(rtn_success boolean, rtn_msg text, rtn_point numeric, rtn_have_referal_code boolean, rtn_app_noti_id integer, rtn_ref_app_noti_id integer)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_point_cancel(in_policy_type text, in_policy_no text)
 RETURNS TABLE(rtn_success boolean, rtn_msg text, rtn_point numeric, rtn_have_referal_code boolean, rtn_app_noti_id integer, rtn_ref_app_noti_id integer)
 LANGUAGE plpgsql
AS $function$
	DECLARE
RTN_SUCCESS BOOL; RTN_MSG TEXT; RTN_POINT NUMERIC DEFAULT 0;
RTN_HAVE_CODE BOOL; RTN_APP_NOTI_ID INT; RTN_REF_APP_NOTI_ID INT;
USER_POINT NUMERIC; REF_USER_POINT NUMERIC; NEW_USER_POINT NUMERIC; NEW_REF_USER_POINT NUMERIC;
Q_POINT_TRANS_ID_CANCEL INT; Q_REF_POINT_TRANS_ID_CANCEL INT;
Q_POINT_TRANS_ID INT; Q_POINT NUMERIC; Q_USER_ID TEXT;
Q_REF_POINT_TRANS_ID INT; Q_REF_POINT NUMERIC; Q_REF_USER_ID TEXT;
Q_POLICY_CANCEL_NO TEXT; Q_POLICY_TYPE TEXT;
SYS_POINT_UPDATE NUMERIC; SYS_REF_POINT_UPDATE NUMERIC;
SYS_INSERT_POINT_TRANS_ID INT; SYS_REF_INSERT_POINT_TRANS_ID INT;
TXT_NOTI_SUBJECT TEXT; TXT_NOTI_BODY TEXT;
SYS_POLICY_TYPE TEXT;
	BEGIN
  RTN_SUCCESS = true;
	RTN_HAVE_CODE = false;
	SELECT "p_trans"."point_trans_id"
	FROM insurverse."loyalty_point_trans" as "p_trans"
	WHERE "p_trans"."point_status"='ACT'
	AND "p_trans"."policy_group"='motor'
	AND "p_trans"."policy_no"="in_policy_no"
	AND "p_trans"."remark"='cancel'
	AND ("referral_code" IS NULL OR "referral_code"='')
	INTO Q_POINT_TRANS_ID_CANCEL;
	
	SELECT "p_trans"."point_trans_id"
	FROM insurverse."loyalty_point_trans" as "p_trans"
	WHERE "p_trans"."point_status"='ACT'
	AND "p_trans"."policy_group"='motor'
	AND "p_trans"."policy_no"="in_policy_no"
	AND "p_trans"."remark"='cancel'
	AND "referral_code" IS NOT NULL AND "referral_code" !=''
	INTO Q_REF_POINT_TRANS_ID_CANCEL;
	
	SELECT "p_trans"."point_trans_id","p_trans"."point","p_trans"."user_id"
	FROM insurverse."loyalty_point_trans" as "p_trans"
	WHERE "p_trans"."point_status"='ACT'
	AND "p_trans"."policy_group"='motor'
	AND "p_trans"."policy_no"="in_policy_no"
	AND ("p_trans"."remark" IS NULL OR "p_trans"."remark"!='cancel')
	AND ("referral_code" IS NULL OR "referral_code"='')
	INTO Q_POINT_TRANS_ID,Q_POINT,Q_USER_ID;
	
	SELECT "p_trans"."point_trans_id","p_trans"."point","p_trans"."user_id"
	FROM insurverse."loyalty_point_trans" as "p_trans"
	WHERE "p_trans"."point_status"='ACT'
	AND "p_trans"."policy_group"='motor'
	AND "p_trans"."policy_no"="in_policy_no"
	AND ("p_trans"."remark" IS NULL OR "p_trans"."remark"!='cancel')
	AND "referral_code" IS NOT NULL AND "referral_code" !=''
	INTO Q_REF_POINT_TRANS_ID,Q_REF_POINT,Q_REF_USER_ID;
	
	SELECT SUM("point") FROM insurverse.loyalty_point_trans
	WHERE "point_status"='ACT' AND user_id=Q_USER_ID
	INTO USER_POINT;
	
	SELECT SUM("point") FROM insurverse.loyalty_point_trans
	WHERE "point_status"='ACT' AND user_id=Q_REF_USER_ID
	INTO REF_USER_POINT;
	
	IF "in_policy_type" = 'mv' THEN
		SELECT "Policy_No","Type"
		FROM insurverse."Policy_Header"
		WHERE "Policy_No"="in_policy_no"
		AND "Policy_Status"='INC'
		INTO Q_POLICY_CANCEL_NO,Q_POLICY_TYPE;
		SYS_POLICY_TYPE='ประกันชั้น ' || Q_POLICY_TYPE;
	END IF;

	IF "in_policy_type" = 'mc' THEN
		SELECT "Car_Act_No"
		FROM insurverse."Policy_Car_Act_Discount_Premium"
		WHERE "Car_Act_No"="in_policy_no"
		AND "Policy_Status"='INC'
		INTO Q_POLICY_CANCEL_NO;
		SYS_POLICY_TYPE='ประกัน พ.ร.บ.';
	END IF;
	
	IF "in_policy_type" = 'ta' THEN
		SELECT "policy_ta_no"
		FROM insurverse."policy_ta_premium"
		WHERE "policy_ta_no"="in_policy_no"
		AND "policy_status"='INC'
		INTO Q_POLICY_CANCEL_NO;
		SYS_POLICY_TYPE='ประกันเดินทาง';
	END IF;
	
	IF "in_policy_type" = 'pa' THEN
		SELECT "policy_pa_no"
		FROM insurverse."policy_pa_premium"
		WHERE "policy_pa_no"="in_policy_no"
		AND "policy_status"='INC'
		INTO Q_POLICY_CANCEL_NO;
		SYS_POLICY_TYPE='ประกันอุบัติเหตุ';
	END IF;
	
	IF "in_policy_type" = 'home' THEN
		SELECT "policy_home_no"
		FROM insurverse."policy_home_premium"
		WHERE "policy_home_no"="in_policy_no"
		AND "policy_status"='INC'
		INTO Q_POLICY_CANCEL_NO;
		SYS_POLICY_TYPE='ประกันบ้านและคอนโด';
	END IF;
	
	IF Q_POINT_TRANS_ID IS NULL AND Q_REF_POINT_TRANS_ID IS NULL THEN
			RTN_SUCCESS = false;
			RTN_MSG = 'Point transaction not found.';
	END IF;
	
	IF Q_POLICY_CANCEL_NO IS NULL THEN 
			RTN_SUCCESS = false;
			RTN_MSG = 'Policy cancel status not found.';
	END IF;
	
	IF RTN_SUCCESS = true THEN
		IF Q_POINT_TRANS_ID IS NOT NULL AND Q_POINT_TRANS_ID_CANCEL IS NULL THEN
			IF USER_POINT < Q_POINT THEN
				SYS_POINT_UPDATE = USER_POINT * -1;
			ELSE 
				SYS_POINT_UPDATE = Q_POINT * -1;
			END IF;
			
			INSERT INTO insurverse."loyalty_point_trans"
			("user_id","point",
			"remark","loyalty_con_id","point_status",
			"promo_trans_id","policy_no","lead_no",
			"referral_code","policy_type","policy_group",
			"lead_type")
			SELECT Q_USER_ID,SYS_POINT_UPDATE,
			'cancel',"loyalty_con_id","point_status",
			"promo_trans_id","policy_no","lead_no",
			"referral_code","policy_type","policy_group",
			"lead_type"
			FROM insurverse."loyalty_point_trans"
			WHERE "point_trans_id"=Q_POINT_TRANS_ID
			RETURNING point_trans_id
			INTO SYS_INSERT_POINT_TRANS_ID;
			
			IF SYS_INSERT_POINT_TRANS_ID IS NOT NULL THEN
				RTN_POINT = SYS_POINT_UPDATE;
				
				SELECT SUM("point") FROM insurverse.loyalty_point_trans
				WHERE "point_status"='ACT' AND user_id=Q_USER_ID
				INTO NEW_USER_POINT;
				
				if SYS_POINT_UPDATE < 0 THEN
					SYS_POINT_UPDATE = (SYS_POINT_UPDATE*-1);
				end if;
			
				TXT_NOTI_SUBJECT = 'แจ้งเตือนเมื่อมีการยกเลิกกรมธรรม์';
				TXT_NOTI_BODY = 'คะแนนถูกหักออกเนื่องจากยกเลิกกรมธรรม์ จำนวน ' || REPLACE(to_char(SYS_POINT_UPDATE,'999,999,990'),' ','') || ' คะแนน คะแนนทั้งหมดของคุณ คือ ' || REPLACE(to_char(NEW_USER_POINT,'999,999,990'),' ','') || ' คะแนน';
				
				INSERT INTO "insurverse"."app_notification" 
				("source", "noti_type", "subject", "message", "icon_type", "user_id","is_active") 
				VALUES ('fn_point_cancel', 'p_cancel', TXT_NOTI_SUBJECT, TXT_NOTI_BODY, NULL, Q_USER_ID, TRUE)
				RETURNING app_noti_id
				INTO RTN_APP_NOTI_ID;
			ELSE
				RTN_SUCCESS = false;
				RTN_MSG = 'Point transaction cancel status is fail.';
			END IF;
		END IF;
		IF Q_REF_POINT_TRANS_ID IS NOT NULL AND Q_REF_POINT_TRANS_ID_CANCEL IS NULL THEN
			RTN_HAVE_CODE = TRUE;
			IF REF_USER_POINT < Q_REF_POINT THEN
				SYS_REF_POINT_UPDATE = REF_USER_POINT * -1;
			ELSE 
				SYS_REF_POINT_UPDATE = Q_REF_POINT * -1;
			END IF;
			
			INSERT INTO insurverse."loyalty_point_trans"
			("user_id","point",
			"remark","loyalty_con_id","point_status",
			"promo_trans_id","policy_no","lead_no",
			"referral_code","policy_type","policy_group",
			"lead_type")
			SELECT Q_REF_USER_ID,SYS_REF_POINT_UPDATE,
			'cancel',"loyalty_con_id","point_status",
			"promo_trans_id","policy_no","lead_no",
			"referral_code","policy_type","policy_group",
			"lead_type"
			FROM insurverse."loyalty_point_trans"
			WHERE "point_trans_id"=Q_REF_POINT_TRANS_ID
			RETURNING point_trans_id
			INTO SYS_REF_INSERT_POINT_TRANS_ID;
			
			IF SYS_REF_INSERT_POINT_TRANS_ID IS NOT NULL THEN
				RTN_POINT = RTN_POINT + SYS_REF_POINT_UPDATE;
				
				SELECT SUM("point") FROM insurverse.loyalty_point_trans
				WHERE "point_status"='ACT' AND user_id=Q_REF_USER_ID
				INTO NEW_REF_USER_POINT;
				
				if SYS_REF_POINT_UPDATE < 0 THEN
					SYS_REF_POINT_UPDATE = (SYS_REF_POINT_UPDATE*-1);
				end if;
			
				TXT_NOTI_SUBJECT = 'แจ้งเตือนเมื่อมีการยกเลิกกรมธรรม์';
				TXT_NOTI_BODY = 'หัก ' || REPLACE(to_char(SYS_REF_POINT_UPDATE,'999,999,990'),' ','') || ' Point เนื่องจากการยกเลิกกรมธรรม์' || SYS_POLICY_TYPE || ' ในวันที่ ' || insurverse.fn_to_thai_date_d(CAST(now() + interval '7hour' as DATE));
				
				INSERT INTO "insurverse"."app_notification" 
				("source", "noti_type", "subject", "message", "icon_type", "user_id","is_active") 
				VALUES ('fn_point_cancel', 'p_cancel', TXT_NOTI_SUBJECT, TXT_NOTI_BODY, NULL, Q_REF_USER_ID, TRUE)
				RETURNING app_noti_id
				INTO RTN_REF_APP_NOTI_ID;
			ELSE
				RTN_SUCCESS = false;
				RTN_MSG = 'Point transaction cancel status is fail.';
			END IF;
		END IF;
	END IF;
	
	RETURN QUERY SELECT RTN_SUCCESS,RTN_MSG,RTN_POINT,RTN_HAVE_CODE,RTN_APP_NOTI_ID,RTN_REF_APP_NOTI_ID;
	
END
$function$
