-- =============================================================================
-- Function: insurverse.fn_update_promo_active
-- OID: 18950
-- Identity Arguments: (in_policy_type text, in_lead_no text)
-- Returns: TABLE(rtn_success boolean, rtn_msg text)
-- Language: plpgsql
-- Categorization: 01_critical_policy_and_payment
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_update_promo_active(in_policy_type text, in_lead_no text)
 RETURNS TABLE(rtn_success boolean, rtn_msg text)
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_SUCCESS BOOL; RTN_MSG TEXT;
SYS_LEAD_NO INT; Q_PROMO_TRANS_ID INT; Q_EMAIL TEXT;
P_PROMO_TRANS_ID INT;
BEGIN
	RTN_SUCCESS = true;
	IF in_lead_no IS null OR in_lead_no = '' THEN
		in_lead_no = '0';
	END IF;
  IF LOWER(in_policy_type) = 'mv' THEN
		SELECT "lead"."Lead_No","lead"."promo_trans_id","lead"."Email"
		FROM insurverse."Lead_coverage_premium" as "lead"
		WHERE "lead"."Lead_No"=CAST(in_lead_no as INT) 
		AND "lead"."promo_trans_id" IS NOT NULL AND "lead"."promo_trans_id" != 0
		AND LOWER("lead"."Payment_status")='success'
		INTO SYS_LEAD_NO,Q_PROMO_TRANS_ID,Q_EMAIL;
	ELSIF LOWER(in_policy_type) = 'mc' THEN
		SELECT "lead"."Car_Act_Lead_No","lead"."promo_trans_id","lead"."email"
		FROM insurverse."Lead_Car_Act_Discount_Premium" as "lead"
		WHERE "lead"."Car_Act_Lead_No"=CAST(in_lead_no as INT)
		AND "lead"."promo_trans_id" IS NOT NULL AND "lead"."promo_trans_id" != 0
		AND LOWER("lead"."Payment_status")='success'
		INTO SYS_LEAD_NO,Q_PROMO_TRANS_ID,Q_EMAIL;
	ELSIF LOWER(in_policy_type) = 'ta' THEN
		SELECT "lead"."lead_ta_no","lead"."promo_trans_id","lead"."email"
		FROM insurverse."lead_ta_premium" as "lead"
		WHERE "lead"."lead_ta_no"=CAST(in_lead_no as INT)
		AND "lead"."promo_trans_id" IS NOT NULL AND "lead"."promo_trans_id" != 0
		AND LOWER("lead"."payment_status")='success'
		INTO SYS_LEAD_NO,Q_PROMO_TRANS_ID,Q_EMAIL;
	ELSIF LOWER(in_policy_type) = 'pa' THEN
		SELECT "lead"."lead_pa_no","lead"."promo_trans_id","lead"."email"
		FROM insurverse."lead_pa_premium" as "lead"
		WHERE "lead"."lead_pa_no"=CAST(in_lead_no as INT)
		AND "lead"."promo_trans_id" IS NOT NULL AND "lead"."promo_trans_id" != 0
		AND LOWER("lead"."payment_status")='success'
		INTO SYS_LEAD_NO,Q_PROMO_TRANS_ID,Q_EMAIL;
	ELSIF LOWER(in_policy_type) = 'home' or LOWER(in_policy_type) = 'fr' THEN
		SELECT "lead"."lead_home_no","lead"."promo_trans_id","lead"."email"
		FROM insurverse."lead_home_premium" as "lead"
		WHERE "lead"."lead_home_no"=CAST(in_lead_no as INT)
		AND "lead"."promo_trans_id" IS NOT NULL AND "lead"."promo_trans_id" != 0
		AND LOWER("lead"."payment_status")='success'
		INTO SYS_LEAD_NO,Q_PROMO_TRANS_ID,Q_EMAIL;
	ELSE
		RTN_SUCCESS = false;
		RTN_MSG = 'Policy type not found.';
	END IF;
	
	IF RTN_SUCCESS = true AND SYS_LEAD_NO IS NULL THEN
		RTN_SUCCESS = false;
		RTN_MSG = 'Lead number or Promotion Code not found or Payment incomplete.';
	END IF;
	
	IF RTN_SUCCESS = true THEN
		SELECT "p_trans"."promo_trans_id"
		FROM insurverse."promo_code_trans" as "p_trans"
		WHERE "p_trans"."promo_trans_id"=Q_PROMO_TRANS_ID
		AND ("p_trans"."promo_active_by" IS NULL OR "p_trans"."promo_active_by"='')
		AND "p_trans"."promo_trans_status"='ACT'
		INTO P_PROMO_TRANS_ID;
		
		IF P_PROMO_TRANS_ID IS NOT NULL AND P_PROMO_TRANS_ID != 0 THEN
			UPDATE insurverse."promo_code_trans"
			SET "promo_active_by"=Q_EMAIL,"promo_active_at"=now()
			WHERE "promo_trans_id"=P_PROMO_TRANS_ID;
		ELSE 
			RTN_SUCCESS = false;
			RTN_MSG = 'Promotion Code not found or Promotion Code not reserved or Promotion Code already used.';
		END IF;
	END IF;
	
	IF RTN_SUCCESS = true THEN
		RTN_MSG = '' || SYS_LEAD_NO;
	END IF;

	RETURN QUERY SELECT RTN_SUCCESS,RTN_MSG;
END
$function$
