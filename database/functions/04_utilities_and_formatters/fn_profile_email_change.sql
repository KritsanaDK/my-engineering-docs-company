-- =============================================================================
-- Function: insurverse.fn_profile_email_change
-- OID: 18852
-- Identity Arguments: (email_change_ref_id text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_profile_email_change(email_change_ref_id text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_PREV_EMAIL TEXT; SYS_NEW_EMAIL TEXT;
CHK_EMAIL TEXT;
	BEGIN

		SELECT prev_email,new_email
		FROM insurverse.log_email_change
		WHERE CAST(ref_id AS TEXT) = email_change_ref_id
		AND UPPER(flag_password_conf) = 'Y'
		AND UPPER(flag_otp_conf) = 'Y'
		INTO SYS_PREV_EMAIL,SYS_NEW_EMAIL;
		
		SELECT email
		FROM insurverse.sec_user
		WHERE email = SYS_NEW_EMAIL
		INTO CHK_EMAIL;
		IF SYS_PREV_EMAIL IS NOT NULL AND SYS_PREV_EMAIL != ''
		AND SYS_NEW_EMAIL IS NOT NULL AND SYS_NEW_EMAIL != '' THEN
			IF CHK_EMAIL IS NULL THEN
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
			
				update insurverse."payment_transaction"
				set "customer_email"=SYS_NEW_EMAIL
				where "customer_email"=SYS_PREV_EMAIL;
				
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
				
				RETURN 'success';
			ELSE
				RETURN 'error: cannot change email because new email is duplicate.';
			END IF;
		ELSE
			RETURN 'error: cannot change email because previous email or new email is empty.';
		END IF;
END;
$function$
