-- =============================================================================
-- Function: insurverse.fn_home_policy_from_lead
-- OID: 18543
-- Identity Arguments: (env_name text, im_lead_no integer)
-- Returns: TABLE(rtn_policy_home_no text, rtn_lead_home_no integer, rtn_msg text)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_home_policy_from_lead(env_name text, im_lead_no integer)
 RETURNS TABLE(rtn_policy_home_no text, rtn_lead_home_no integer, rtn_msg text)
 LANGUAGE plpgsql
AS $function$
DECLARE
SYS_POLICY_NO TEXT; SYS_LEAD_NO INT;
SYS_QUO_NO TEXT; SYS_BOOK TEXT; SYS_INVOICE_NO TEXT;
SYS_EMAIL text; SYS_USER_ID text;
PRE_NO_ENV TEXT;
PRE_NO_LAST INT; PRE_NO_MOD INT; PRE_NO TEXT DEFAULT null;
SYS_MONTH_ARRAY TEXT[];
SYS_START_DATE TIMESTAMP;
SYS_END_DATE TIMESTAMP;
LEAD_START_DATE TIMESTAMP; LEAD_END_DATE TIMESTAMP; 
PAR_POLICY_NO TEXT; COV_POLICY_NO TEXT; TARIFF_POLICY_NO TEXT;
 BEGIN
	SELECT "lead_home_no","policy_startdate","policy_enddate","email","user_id"
	FROM insurverse."lead_home_premium"
	WHERE "lead_home_no"=im_lead_no and UPPER("payment_status")='SUCCESS'
	INTO SYS_LEAD_NO,LEAD_START_DATE,LEAD_END_DATE,SYS_EMAIL,SYS_USER_ID;
	
	IF SYS_LEAD_NO IS NOT NULL AND SYS_LEAD_NO!=0 AND SYS_POLICY_NO IS NULL then
			if SYS_USER_ID is null or SYS_USER_ID = '' THEN
			select "user_id"
			from insurverse.sec_user
			where email=LOWER(SYS_EMAIL)
			into SYS_USER_ID;
			end if;
			
			SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];
			
			IF LOWER(env_name) = 'dev' THEN
				SYS_QUO_NO = insurverse.fn_policy_quatationno_iia_dev();
				SYS_BOOK = insurverse.fn_policy_book_iia_type_dev('home');
				SYS_INVOICE_NO = insurverse.fn_policy_invoiceno_iia_type_dev('home');
			ELSE
				SYS_QUO_NO = insurverse.fn_policy_quatationno_iia();
				SYS_BOOK = insurverse.fn_policy_book_iia_type('home');
				SYS_INVOICE_NO =insurverse.fn_policy_invoiceno_iia_type('home');
			END IF;
			
			PRE_NO = 'HI-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];
			
			EXECUTE
			'SELECT COALESCE(CAST(SUBSTR("policy_home_no",11,5) AS INT),0)
			FROM insurverse."policy_home_premium"
			WHERE "policy_home_no" LIKE ''' || PRE_NO || '%''' ||
			'ORDER BY "policy_home_no" DESC
			LIMIT 1'
			INTO PRE_NO_LAST;

			IF PRE_NO_LAST IS NULL THEN
				IF LOWER(env_name) = 'dev' THEN
					PRE_NO_LAST = 90000;
				ELSE
					PRE_NO_LAST = 0;
				END IF;
			END IF;
			
			PRE_NO_MOD = MOD(PRE_NO_LAST+1,8);
			SYS_POLICY_NO = PRE_NO || '-' || regexp_replace(TO_CHAR(PRE_NO_LAST+1,'00000'), '[^\w]+','') || PRE_NO_MOD;
			
			SYS_START_DATE = CURRENT_TIMESTAMP + INTERVAL '7HOUR'; -- UPDATE FROM Personal Form
			LEAD_START_DATE = LEAD_START_DATE + INTERVAL '7HOUR';
			SYS_END_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE + INTERVAL '1 YEAR' as TIMESTAMP)) + INTERVAL '16 HOUR 30 MINUTE' - INTERVAL '7 HOUR'; -- UPDATE FROM Personal Form
			
			IF CAST(SYS_START_DATE as DATE) = CAST(LEAD_START_DATE as DATE) THEN
				SYS_START_DATE = DATE_TRUNC('day', CAST(SYS_START_DATE as TIMESTAMP)) + INTERVAL '16 HOUR 30 MINUTE' - INTERVAL '7 HOUR';
			ELSE
				SYS_START_DATE = DATE_TRUNC('day', CAST(LEAD_START_DATE as TIMESTAMP)) + INTERVAL '16 HOUR 30 MINUTE' - INTERVAL '7 HOUR';
			END IF;
		
			if EXTRACT(month FROM SYS_START_DATE) = 2 AND EXTRACT(day FROM SYS_START_DATE) = 29 THEN 
				SYS_END_DATE = SYS_END_DATE+interval'1day';
			end if;
			
			INSERT INTO insurverse."policy_home_premium" (
			policy_home_no,policy_status,
			lead_home_no,
			policy_startdate,policy_enddate,
			email,payment_status,payment_channel,
			payment_type,payment_no,payment_ref1,
			payment_ref2,payment_result,payment_date,
			promo_trans_id,promo_discount_per,promo_discount_amt,
			perm_amt,duty_amt,vat_amt,total_amt,
			policy_quotation_no,policy_book,policy_invoice_no,
			create_date,update_date,
			effective_startdate,effective_enddate,
			discount_amt,user_id,
			affiliate_source,affiliate_code,
			referal_source,referal_code,
			deli_flag,deli_address_th,deli_address_en,
			deli_subdistrict_id,deli_district_id,deli_province_id,
			deli_zipcode,
			home_building_type_id,home_building_province_id,home_material_type_id,
			home_resident_type_id,building_address_th,building_address_en,
			building_subdistrict_id,building_district_id,building_province_id,
			building_zipcode,building_country_id
			)
			SELECT SYS_POLICY_NO,'ACT',
			lead_home_no,
			SYS_START_DATE,SYS_END_DATE,
			LOWER(email),payment_status,payment_channel,
			payment_type,payment_no,payment_ref1,
			payment_ref2,payment_result,payment_date - INTERVAL '7HOUR',
			promo_trans_id,promo_discount_per,promo_discount_amt,
			perm_amt,duty_amt,vat_amt,total_amt,
			SYS_QUO_NO,SYS_BOOK,SYS_INVOICE_NO,
			now(),now(),
			now(),policy_enddate,
			discount_amt,SYS_USER_ID,
			affiliate_source,'', -- Close affiliate [CR]
			referal_source,referal_code,
			deli_flag,deli_address_th,deli_address_en,
			deli_subdistrict_id,deli_district_id,deli_province_id,
			deli_zipcode,
			home_building_type_id,home_building_province_id,home_material_type_id,
			home_resident_type_id,building_address_th,building_address_en,
			building_subdistrict_id,building_district_id,building_province_id,
			building_zipcode,building_country_id
			FROM insurverse."lead_home_premium"
			WHERE "lead_home_no"=im_lead_no and UPPER("payment_status")='SUCCESS';
			
			UPDATE insurverse."lead_home_participant"
			SET "policy_home_no"=SYS_POLICY_NO
			WHERE "lead_home_no"=im_lead_no;
			
			UPDATE insurverse."lead_home_coverage"
			SET "policy_home_no"=SYS_POLICY_NO
			WHERE "lead_home_no"=im_lead_no;
			
			UPDATE insurverse."lead_home_premium_tariff"
			SET "policy_home_no"=SYS_POLICY_NO
			WHERE "lead_home_no"=im_lead_no;
	ELSE
		rtn_msg = 'Lead not found or Payment status is not success or Policy is duplicate.';
	END IF;
	
	SELECT "policy_home_no"
	FROM insurverse."lead_home_participant"
	WHERE "lead_home_no"=im_lead_no
	INTO PAR_POLICY_NO;
	
	IF SYS_POLICY_NO IS NOT NULL AND PAR_POLICY_NO IS NULL THEN
		UPDATE insurverse."lead_home_participant"
		SET "policy_home_no"=SYS_POLICY_NO
		WHERE "lead_home_no"=SYS_LEAD_NO;
	END IF;
	
	SELECT "policy_home_no"
	FROM insurverse."lead_home_coverage"
	WHERE "lead_home_no"=im_lead_no
	INTO COV_POLICY_NO;
	
	IF SYS_POLICY_NO IS NOT NULL AND COV_POLICY_NO IS NULL THEN
		UPDATE insurverse."lead_home_coverage"
		SET "policy_home_no"=SYS_POLICY_NO
		WHERE "lead_home_no"=SYS_LEAD_NO;
	END IF;
	
	SELECT "policy_home_no"
	FROM insurverse."lead_home_premium_tariff"
	WHERE "lead_home_no"=im_lead_no
	INTO TARIFF_POLICY_NO;
	
	IF SYS_POLICY_NO IS NOT NULL AND TARIFF_POLICY_NO IS NULL THEN
		UPDATE insurverse."lead_home_premium_tariff"
		SET "policy_home_no"=SYS_POLICY_NO
		WHERE "lead_home_no"=SYS_LEAD_NO;
	END IF;
	
  RETURN QUERY SELECT SYS_POLICY_NO,im_lead_no,rtn_msg;
END
$function$
