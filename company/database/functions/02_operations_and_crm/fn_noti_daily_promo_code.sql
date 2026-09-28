-- =============================================================================
-- Function: insurverse.fn_noti_daily_promo_code
-- OID: 18569
-- Identity Arguments: ()
-- Returns: TABLE(rtn_success boolean, rtn_msg text, rtn_json_promo json)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_noti_daily_promo_code()
 RETURNS TABLE(rtn_success boolean, rtn_msg text, rtn_json_promo json)
 LANGUAGE plpgsql
AS $function$
	DECLARE
	RTN_SUCCESS BOOL; RTN_MSG TEXT; RTN_JSON_PROMO JSON;
	LOOP_COVER RECORD;
BEGIN
	RTN_SUCCESS = TRUE;
	FOR LOOP_COVER in
		SELECT
		"promo_code_name" as "subject",
		"promo_code_desc" as "message",
		"user_id"
		FROM insurverse."promo_code"
		INNER JOIN insurverse."sec_user"
		ON "promo_code_status"='ACT' 
		AND "promo_screen_status"='ACT'
		AND (CAST(NOW() + interval '7hour' as DATE) = CAST("active_start_date" - INTERVAL '1DAY' + interval '7hour' as DATE)
		)
	LOOP
		INSERT INTO "insurverse"."app_notification" 
		("source", "noti_type","subject", "message", "icon_type", "user_id","is_active") 
		VALUES ('fn_noti_promo_code', 'promo', LOOP_COVER."subject",
		LOOP_COVER."message", NULL, LOOP_COVER."user_id", TRUE);
	END LOOP;
	
	RETURN QUERY SELECT RTN_SUCCESS,RTN_MSG,RTN_JSON_PROMO;
END
$function$
