-- =============================================================================
-- Function: insurverse.fn_update_promo_book
-- OID: 18960
-- Identity Arguments: (in_user_id text, in_promo_code_id integer)
-- Returns: TABLE(rtn_success boolean, rtn_msg text, rtn_app_noti_id integer, rtn_promo_code text)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_promo_book(in_user_id text, in_promo_code_id integer)
 RETURNS TABLE(rtn_success boolean, rtn_msg text, rtn_app_noti_id integer, rtn_promo_code text)
 LANGUAGE plpgsql
AS $function$
	DECLARE
	RTN_SUCCESS BOOL; RTN_MSG TEXT; RTN_PROMO_CODE TEXT;
	RTN_APP_NOTI_ID INT;
	SYS_REMARK TEXT; SYS_NOTI_DATE DATE;
	Q_USER_ID TEXT; Q_PROMO_CODE_ID INT; Q_EMAIL TEXT;
	Q_PROMO_USED_COUNT INT; Q_PROMO_QUOTA INT;
	Q_EMAIL_USED_COUNT INT; Q_PROMO_QUOTA_USER INT;
	Q_REDEEM_POINT NUMERIC; Q_PROMO_BOOK_COUNT INT;
	Q_PROMO_TRANS_ID INT;
	Q_PRODUCT_GROUP_TYPE TEXT; Q_PRODUCT_SUB_TYPE TEXT;
	Q_SUM_POINT TEXT; Q_PREM_TYPE TEXT;
	TXT_NOTI_SUBJECT TEXT; TXT_NOTI_BODY TEXT; USER_POINT NUMERIC;
	BEGIN
  	RTN_SUCCESS = true;
	SYS_NOTI_DATE = CAST(now()+interval'7hour' as DATE);
	
	SELECT "user_id","email",
	(SELECT SUM("point") FROM insurverse.loyalty_point_trans as "point" WHERE "point"."point_status"='ACT' AND "point".user_id="sec_user".user_id) as "loyalty_point"
	FROM insurverse."sec_user"
	WHERE "sec_user"."user_id" = in_user_id
	INTO Q_USER_ID,Q_EMAIL,Q_SUM_POINT;
	
	IF Q_USER_ID IS NULL THEN
		RTN_SUCCESS = false;
		RTN_MSG = 'P301'; -- User ID not found.
	ELSE
		SELECT "promo_code"."promo_code_id",
		(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
		WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
		AND "trans_2"."promo_trans_status"='ACT' 
		AND "trans_2"."promo_active_by" IS NOT NULL AND "trans_2"."promo_active_by" != ''
		) as "promo_used_count",
		"promo_code"."number_quota",
		(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
		WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
		AND "trans_2"."promo_trans_status"='ACT' 
		AND ("trans_2"."promo_book_by"=Q_EMAIL
		OR "trans_2"."promo_active_by"=Q_EMAIL)) as "email_used_count",
		"promo_code"."number_quota_user",
		"promo_code"."redeem_point",
		(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
		WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
		AND "trans_2"."promo_trans_status"='ACT' 
		AND ("trans_2"."promo_book_by" IS NULL OR "trans_2"."promo_book_by" = '')
		) as "promo_book_count",
		"promo_code"."product_group_type","promo_code"."product_sub_type",
		"prem_type"
		FROM insurverse."promo_code"
		WHERE "promo_code"."promo_code_id"="in_promo_code_id"
		AND "promo_code"."promo_code_status"='ACT'
		AND LOWER("promo_code".promo_code_type) = 'unique'
		AND "promo_code"."redeem_status"='ACT'
		AND now() BETWEEN "promo_code"."active_start_date" AND "promo_code"."active_end_date"
		AND "promo_code"."redeem_point" >= 0
		LIMIT 1
		INTO Q_PROMO_CODE_ID,Q_PROMO_USED_COUNT,Q_PROMO_QUOTA,
		Q_EMAIL_USED_COUNT,Q_PROMO_QUOTA_USER,Q_REDEEM_POINT,Q_PROMO_BOOK_COUNT,
		Q_PRODUCT_GROUP_TYPE,Q_PRODUCT_SUB_TYPE,Q_PREM_TYPE;
		
		IF Q_PROMO_CODE_ID IS NULL THEN
			RTN_SUCCESS = false;
			RTN_MSG = 'P302'; -- Promotion Code not found or Conditions not met.
		END IF;
		
		IF CAST(Q_SUM_POINT as NUMERIC) < Q_REDEEM_POINT THEN
			RTN_SUCCESS = false;
			RTN_MSG = 'P303'; -- User not enough points.
		END IF;
		
		IF Q_PROMO_QUOTA > 0 AND (Q_PROMO_USED_COUNT >= Q_PROMO_QUOTA OR Q_PROMO_BOOK_COUNT < 1) THEN
			RTN_SUCCESS = false;
			RTN_MSG = 'P304'; -- Promotion Code quota full.
		END IF;
		
		IF Q_PROMO_QUOTA_USER > 0 AND Q_EMAIL_USED_COUNT >= Q_PROMO_QUOTA_USER THEN
			RTN_SUCCESS = false;
			RTN_MSG = 'P305'; -- Promotion Code user quota full.
		END IF;
		
		
		IF RTN_SUCCESS = true THEN
			SELECT "p_trans"."promo_trans_id","p_trans"."promo_code"
			FROM insurverse."promo_code_trans" as "p_trans"
			WHERE "p_trans"."promo_code_id"=Q_PROMO_CODE_ID
			AND "p_trans"."promo_trans_status"='ACT'
			AND ("p_trans"."promo_book_by" IS NULL OR "p_trans"."promo_book_by" ='')
			ORDER BY "p_trans"."seq_id" ASC
			LIMIT 1
			INTO Q_PROMO_TRANS_ID,RTN_PROMO_CODE;
			
			IF Q_PROMO_TRANS_ID IS NULL THEN
				RTN_SUCCESS = false;
				RTN_MSG = 'P306'; -- Promotion Code transaction not found.
			else
				if Q_PREM_TYPE != 'premium' THEN
					UPDATE insurverse."promo_code_trans"
					SET "promo_book_by"=Q_EMAIL,"promo_book_at"=now()
					WHERE "promo_code_trans"."promo_trans_id"=Q_PROMO_TRANS_ID;
				else
					UPDATE insurverse."promo_code_trans"
					SET "promo_book_by"=Q_EMAIL,"promo_book_at"=now(),
					"promo_active_by"=Q_EMAIL,"promo_active_at"=now()
					WHERE "promo_code_trans"."promo_trans_id"=Q_PROMO_TRANS_ID;
				end if;
				
				INSERT INTO insurverse."loyalty_point_trans"
				("user_id","point","remark","point_status",
				"policy_type","policy_group","promo_trans_id")
				VALUES (Q_USER_ID,(Q_REDEEM_POINT*-1),SYS_REMARK,'ACT',
				Q_PRODUCT_SUB_TYPE,Q_PRODUCT_GROUP_TYPE,Q_PROMO_TRANS_ID);
				
				SELECT SUM("point") FROM insurverse.loyalty_point_trans
				WHERE "point_status"='ACT' AND user_id=Q_USER_ID
				INTO USER_POINT;
				
				TXT_NOTI_SUBJECT = 'แจ้งเตือนเมื่อมีการใช้ Point';
				TXT_NOTI_BODY = 'คุณใช้ ' || REPLACE(to_char(Q_REDEEM_POINT,'999,999,990'),' ','') || ' คะแนน ที่ Insurverse คะแนนคงเหลือ ณ  วันที่ ' || insurverse.fn_to_thai_date_d(SYS_NOTI_DATE) || ' คือ ' || REPLACE(to_char(USER_POINT,'999,999,990'),' ','') || ' คะแนน';
				
				INSERT INTO "insurverse"."app_notification" 
				("source", "noti_type", "subject", "message", "icon_type", "user_id","is_active") 
				VALUES ('fn_point_redeem', 'p_used', TXT_NOTI_SUBJECT, TXT_NOTI_BODY, NULL, Q_USER_ID, TRUE)
				RETURNING app_noti_id
				INTO RTN_APP_NOTI_ID;
			END IF;
		END IF;
	END IF;
	
	
	
	RETURN QUERY SELECT RTN_SUCCESS,RTN_MSG,RTN_APP_NOTI_ID,RTN_PROMO_CODE;
END
$function$
