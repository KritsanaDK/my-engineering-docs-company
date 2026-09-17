-- =============================================================================
-- Function: insurverse.fn_update_point_expire
-- OID: 18927
-- Identity Arguments: ()
-- Returns: TABLE(rtn_success boolean, rtn_msg text, rtn_json_point json)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_point_expire()
 RETURNS TABLE(rtn_success boolean, rtn_msg text, rtn_json_point json)
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
	RTN_SUCCESS = true;
	SYS_REMARK = 'point expire date';
	
	-- noti point expire
	SELECT json_build_object(
	'fn_active_date',now(),
	'expire_year',EXTRACT(YEAR FROM now()),
	'expire_month',EXTRACT(MONTH FROM now()),
	'point_summary',(
	SELECT json_agg(point_list)
	FROM (
		select *
		from (
		SELECT "user_id","point_earn","point_used","email","name","last_name","point_total","expire_date",
		to_char("expire_date"+ interval '543year'+ interval '7hour','dd/mm/yyyy') as "expire_date_th",
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
	) as "point_list"))
	INTO RTN_JSON_POINT;
	
	FOR LOOP_COVER in
		select *
		from (
		SELECT "user_id","point_earn","point_used","email","name","last_name","point_total","expire_date",
		to_char("expire_date"+ interval '543year'+ interval '7hour','dd/mm/yyyy') as "expire_date_th",
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
		IF LOOP_COVER."point_dd" > 0 THEN
		INSERT INTO insurverse."loyalty_point_trans"
				("user_id","point","remark","point_status")
				VALUES (LOOP_COVER."user_id",(LOOP_COVER."point_dd"*-1),SYS_REMARK,'ACT');
		END IF;
		
		SELECT SUM("point") FROM insurverse.loyalty_point_trans
		WHERE "point_status"='ACT' AND user_id=LOOP_COVER."user_id"
		INTO USER_POINT;
		
		IF USER_POINT IS NULL THEN
			USER_POINT = 0;
		END IF;
		
		if LOOP_COVER."point_dd" < 0 then
			Q_POINT_DD = (LOOP_COVER."point_dd"*-1);
		else
			Q_POINT_DD = LOOP_COVER."point_dd";
		end if;
		
		TXT_NOTI_SUBJECT = 'แจ้งเตือนเมื่อ Point หมดอายุ';
		TXT_NOTI_BODY = 'คะแนนหมดอายุ จำนวน ' || REPLACE(to_char(Q_POINT_DD,'999,999,990'),' ','') || ' คะแนน คะแนนทั้งหมดของคุณ คือ ' || REPLACE(to_char(USER_POINT,'999,999,990'),' ','') || ' คะแนน';
		
		INSERT INTO "insurverse"."app_notification" 
		("source", "noti_type", "subject", "message", "icon_type", "user_id","is_active") 
		VALUES ('fn_point_expired', 'p_expired', TXT_NOTI_SUBJECT, TXT_NOTI_BODY, NULL, LOOP_COVER."user_id", TRUE);
	END LOOP;
		
	INSERT INTO insurverse.log_point_expire
		("result","msg","body","remark","fn_name")
	VALUES (RTN_SUCCESS,RTN_MSG,RTN_JSON_POINT,SYS_REMARK,'fn_update_point_expire');
	
	RETURN QUERY SELECT RTN_SUCCESS,RTN_MSG,RTN_JSON_POINT;
END
$function$
