-- =============================================================================
-- Function: insurverse.fn_profile_email_change_manual
-- OID: 18860
-- Identity Arguments: (email_old text, email_new text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_profile_email_change_manual(email_old text, email_new text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_PREV_EMAIL TEXT; SYS_NEW_EMAIL TEXT;
CHK_EMAIL TEXT;
	BEGIN
	SYS_PREV_EMAIL = email_old;
	SYS_NEW_EMAIL = email_new;
	
		update insurverse.sec_user
		set email=SYS_NEW_EMAIL
		where email=SYS_PREV_EMAIL;

		update insurverse."Lead_coverage_premium"
		set "Email"=SYS_NEW_EMAIL
		where "Email"=SYS_PREV_EMAIL;

		update insurverse."Lead_Car_Act_Discount_Premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;

		update insurverse."Policy_Header"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;

		update insurverse."Policy_Car_Act_Discount_Premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."payment"
		set "customer_email"=SYS_NEW_EMAIL
		where "customer_email"=SYS_PREV_EMAIL;

		update insurverse."payment_act"
		set "customer_email"=SYS_NEW_EMAIL
		where "customer_email"=SYS_PREV_EMAIL;
		
		update insurverse."promo_code_trans"
		set "promo_book_by"=SYS_NEW_EMAIL
		where "promo_book_by"=SYS_PREV_EMAIL;

		update insurverse."promo_code_trans"
		set "promo_active_by"=SYS_NEW_EMAIL
		where "promo_active_by"=SYS_PREV_EMAIL;

		update insurverse."consent_accept"
		set "identifier"=SYS_NEW_EMAIL
		where "identifier"=SYS_PREV_EMAIL;

		update insurverse."consent_rop"
		set "identifier"=SYS_NEW_EMAIL
		where "identifier"=SYS_PREV_EMAIL;
		
		update insurverse."payment_ta"
		set "customer_email"=SYS_NEW_EMAIL
		where "customer_email"=SYS_PREV_EMAIL;
		
		update insurverse."lead_ta_premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."policy_ta_premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."policy_ta_premium_trans"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."lead_pa_premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."policy_pa_premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."policy_pa_premium_trans"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."lead_home_premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."policy_home_premium"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."policy_home_premium_trans"
		set "email"=SYS_NEW_EMAIL
		where "email"=SYS_PREV_EMAIL;
		
		update insurverse."promo_code_trans"
		set "promo_book_by"=SYS_NEW_EMAIL
		where "promo_book_by"=SYS_PREV_EMAIL;
		
		update insurverse."promo_code_trans"
		set "promo_active_by"=SYS_NEW_EMAIL
		where "promo_active_by"=SYS_PREV_EMAIL;
			
		RETURN 'Success : Change Email : ' || SYS_PREV_EMAIL || ' to Email : ' || SYS_NEW_EMAIL;
END;
$function$
