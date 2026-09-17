-- =============================================================================
-- Function: insurverse.fn_check_sf_account
-- OID: 18447
-- Identity Arguments: (policy_number text)
-- Returns: TABLE(sf_account text, par_id integer, salutation text, firstname text, lastname text, "idNumber" text, "idType" text, birthdate text, "customerType" text, "paymentStatus" text, "accountType" text)
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_check_sf_account(policy_number text)
 RETURNS TABLE(sf_account text, par_id integer, salutation text, firstname text, lastname text, "idNumber" text, "idType" text, birthdate text, "customerType" text, "paymentStatus" text, "accountType" text)
 LANGUAGE plpgsql
AS $function$
	DECLARE
	SF_ACCOUNT TEXT;
	SYS_POLICY_NO TEXT; SYS_CAR_ACT_NO TEXT; SYS_PAR_ID INT4; REF_CAR_ACT_NO TEXT;
	PREFIX_NAME TEXT; FIRST_NAME TEXT; LAST_NAME TEXT; CITIZEN_ID TEXT; BIRTH_DATE DATE;
	salutation TEXT; firstname TEXT; lastname TEXT; "idNumber" TEXT; 
	"idType" TEXT; birthdate TEXT; "customerType" TEXT; "paymentStatus" TEXT;
	accountType TEXT;
	P_PREFIX_NAME TEXT; P_FIRST_NAME TEXT; P_LAST_NAME TEXT; P_CITIZEN_ID TEXT; P_BIRTH_DATE DATE;
	BEGIN
	
	"idType" = '1';
	"customerType" = 'person';
	"paymentStatus" ='ปกติ';
	"accountType" = 'Owner';
	
	IF SF_ACCOUNT IS NULL THEN
		SELECT "par"."sf_account","par"."par_id",
		"par"."owner_prefix_name","par"."owner_first_name", "par"."owner_last_name",
		"par"."owner_citizen_id","par"."owner_birth_date",
		"head"."Car_Act_No",
		"head"."Owner_prefix_name","head"."Owner_first_name","head"."Owner_last_name",
		"head"."Owner_citizen_id","head"."Owner_birth_date"
		FROM insurverse."Policy_Header" as "head"
		INNER JOIN insurverse.policy_participant as "par"
		ON "head"."Owner_citizen_id" = "par"."owner_citizen_id"
		AND "head"."Policy_No"=policy_number
		INTO SF_ACCOUNT,SYS_PAR_ID,
		PREFIX_NAME,FIRST_NAME,LAST_NAME,
		CITIZEN_ID,BIRTH_DATE,
		REF_CAR_ACT_NO,
		P_PREFIX_NAME,P_FIRST_NAME,P_LAST_NAME,
		P_CITIZEN_ID,P_BIRTH_DATE;
	END IF;
	
	IF SF_ACCOUNT IS NULL THEN
		SELECT "par"."sf_account","par"."par_id",
		"par"."owner_prefix_name","par"."owner_first_name", "par"."owner_last_name",
		"par"."owner_citizen_id","par"."owner_birth_date",
		"act"."prefix_name","act"."first_name","act"."last_name",
		"act"."citizen_id","act"."birth_date"
		FROM insurverse."Policy_Car_Act_Discount_Premium" as "act"
		INNER JOIN insurverse.policy_participant as "par"
		ON "act"."citizen_id" = "par"."owner_citizen_id"
		AND "act"."Car_Act_No"=policy_number
		INTO SF_ACCOUNT,SYS_PAR_ID,
		PREFIX_NAME,FIRST_NAME,LAST_NAME,
		CITIZEN_ID,BIRTH_DATE,
		P_PREFIX_NAME,P_FIRST_NAME,P_LAST_NAME,
		P_CITIZEN_ID,P_BIRTH_DATE;
	END IF;
	
	IF SF_ACCOUNT IS NOT NULL THEN 
		salutation = P_PREFIX_NAME;
		firstname = P_FIRST_NAME;
		lastname = P_LAST_NAME;
		"idNumber" = P_CITIZEN_ID;
		"birthdate" = TO_CHAR(P_BIRTH_DATE, 'yyyy-mm-dd');
	END IF;
	
	IF SYS_PAR_ID IS NOT NULL THEN 
		UPDATE insurverse."policy_participant"
		SET "owner_prefix_name"=P_PREFIX_NAME,
		"owner_first_name"=P_FIRST_NAME, "owner_last_name"=P_LAST_NAME,
		"owner_citizen_id"=P_CITIZEN_ID,"owner_birth_date"=P_BIRTH_DATE
		WHERE "policy_participant"."par_id"=SYS_PAR_ID;
	END IF;
	
	IF SF_ACCOUNT IS NULL THEN
		SELECT "Policy_No","Owner_prefix_name","Owner_first_name","Owner_last_name","Owner_citizen_id","Owner_birth_date","Car_Act_No"
		FROM insurverse."Policy_Header"
		WHERE "Policy_No"=policy_number
		INTO SYS_POLICY_NO,PREFIX_NAME,FIRST_NAME,LAST_NAME,CITIZEN_ID,BIRTH_DATE,REF_CAR_ACT_NO;
	
		IF SYS_POLICY_NO IS NULL THEN
			SELECT "Car_Act_No","act"."prefix_name","act"."first_name","act"."last_name","act"."citizen_id","act"."birth_date"
			FROM insurverse."Policy_Car_Act_Discount_Premium" as "act"
			WHERE "Car_Act_No"=policy_number
			INTO SYS_CAR_ACT_NO,PREFIX_NAME,FIRST_NAME,LAST_NAME,CITIZEN_ID,BIRTH_DATE;
		END IF;
		
		salutation = PREFIX_NAME;
		firstname = FIRST_NAME;
		lastname = LAST_NAME;
		"idNumber" = CITIZEN_ID;
		"birthdate" = TO_CHAR(BIRTH_DATE, 'yyyy-mm-dd');
		
		IF SYS_PAR_ID IS NULL THEN
			SELECT "par".par_id
			FROM insurverse."policy_participant" as "par"
			WHERE "owner_citizen_id" = CITIZEN_ID
			INTO SYS_PAR_ID;
		END IF;
		
		IF SYS_PAR_ID IS NULL THEN
			INSERT INTO insurverse."policy_participant"
			("owner_prefix_name","owner_first_name", "owner_last_name","owner_citizen_id","owner_birth_date","create_date")
			VALUES (PREFIX_NAME,FIRST_NAME,LAST_NAME,CITIZEN_ID,BIRTH_DATE,now())
			RETURNING "policy_participant"."par_id" INTO SYS_PAR_ID;
		END IF;
	END IF;
	
	UPDATE insurverse."Policy_Header"
	SET "par_id"=SYS_PAR_ID
	WHERE "Policy_No"=policy_number;
	
	UPDATE insurverse."Policy_Car_Act_Discount_Premium"
	SET "par_id"=SYS_PAR_ID
	WHERE "Car_Act_No"=policy_number OR "Car_Act_No"=REF_CAR_ACT_NO;
	
	IF SF_ACCOUNT = '' OR SF_ACCOUNT = '""' THEN
		SF_ACCOUNT = null;
	END IF;
	
 RETURN QUERY SELECT SF_ACCOUNT,SYS_PAR_ID,salutation,firstname,lastname || ' (Owner)',"idNumber","idType","birthdate","customerType","paymentStatus","accountType";
END
$function$
