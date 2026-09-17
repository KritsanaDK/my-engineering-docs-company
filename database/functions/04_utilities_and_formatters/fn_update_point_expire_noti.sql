-- =============================================================================
-- Function: insurverse.fn_update_point_expire_noti
-- OID: 18936
-- Identity Arguments: ()
-- Returns: boolean
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_point_expire_noti()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_SUCCESS BOOL; RTN_MSG TEXT DEFAULT ''; RTN_JSON_POINT JSON;
SYS_REMARK TEXT;
LOOP_COVER RECORD; Q_USER_ID TEXT; 
Q_POINT_EARN NUMERIC; Q_POINT_USED NUMERIC; Q_POINT_DD NUMERIC;
TXT_NOTI_SUBJECT TEXT; TXT_NOTI_BODY TEXT;
USER_POINT NUMERIC;
	BEGIN
		-- noti before point expire
		FOR LOOP_COVER in
		select *
		from (
		SELECT "user_id","point_earn","point_used","email","name","last_name","point_total","expire_date",
		insurverse.fn_to_thai_date_d(CAST("expire_date" + interval '7hour' as DATE)) as "expire_date_th",
		CASE WHEN ("point_earn" + "point_used") < 0 THEN 0 ELSE ("point_earn" + "point_used") END as "point_dd" 
		FROM (
		SELECT "user"."user_id","user"."email","user"."name","user"."last_name",cast("p_trans"."expire_date"+ interval '7hour' as date) as "expire_date",
		COALESCE((SELECT SUM("p_trans_2"."point") FROM insurverse.loyalty_point_trans as "p_trans_2" 
		WHERE "p_trans_2"."user_id"="user"."user_id"
		AND "p_trans_2"."point" > 0
		and cast("p_trans_2"."expire_date" + interval '7hour' as date) <= cast(DATE_TRUNC('MONTH', now()) + INTERVAL '1 MONTH' - INTERVAL '1 day' as date)
		),0) as "point_earn",
		COALESCE((SELECT SUM("p_trans_2"."point") FROM insurverse.loyalty_point_trans as "p_trans_2" 
		WHERE "p_trans_2"."user_id"="user"."user_id"
		AND "p_trans_2"."point" < 0
		),0) as "point_used",
		COALESCE((SELECT SUM("p_trans_2"."point") FROM insurverse.loyalty_point_trans as "p_trans_2" 
		WHERE "p_trans_2"."user_id"="user"."user_id"
		),0) as "point_total"
		FROM insurverse.sec_user as "user"
		INNER JOIN insurverse.loyalty_point_trans as "p_trans"
		ON "user"."user_id"="p_trans"."user_id"
		where EXTRACT(MONTH FROM "p_trans"."expire_date" + interval'7HOUR') = EXTRACT(MONTH FROM NOW() + interval'7HOUR') 
		AND EXTRACT(YEAR FROM "p_trans"."expire_date" + interval'7HOUR') = EXTRACT(YEAR FROM NOW() + interval'7HOUR')
		GROUP BY "user"."user_id","user"."email","user"."name","user"."last_name","p_trans"."expire_date"
		) as "cal_dd_point"
		) as "point_expire"
		where point_dd > 0
		LOOP
			SELECT SUM("point") FROM insurverse.loyalty_point_trans
			WHERE "point_status"='ACT' AND user_id=LOOP_COVER."user_id"
			INTO USER_POINT;
			
			IF USER_POINT IS NULL THEN
				USER_POINT = 0;
			END IF;
			
			TXT_NOTI_SUBJECT = 'แจ้งเตือนเมื่อ Point จะหมดอายุ';
			TXT_NOTI_BODY = 'คะแนนของคุณกำลังจะหมดอายุ อย่าลืมเช็กคะแนนและแลกรับสิทธิพิเศษภายใน วันที่ ' || LOOP_COVER."expire_date_th";
			
			INSERT INTO "insurverse"."app_notification" 
			("source", "noti_type", "subject", "message", "icon_type", "user_id","is_active") 
			VALUES ('fn_point_expired', 'p_expired', TXT_NOTI_SUBJECT, TXT_NOTI_BODY, NULL, LOOP_COVER."user_id", TRUE);
		END LOOP;
		return true;
	END;
$function$
