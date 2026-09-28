-- =============================================================================
-- Function: insurverse.fn_policy_package_iia
-- OID: 18674
-- Identity Arguments: (in_usage text, in_type text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_package_iia(in_usage text, in_type text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE RTN_PACKAGE_ID INT;
BEGIN
  IF in_usage='110' AND in_type='1' THEN RTN_PACKAGE_ID='1';
	ELSIF in_usage='110' AND in_type='3' THEN RTN_PACKAGE_ID='2';
	ELSIF in_usage='110' AND (in_type='2+' OR in_type='3+') THEN RTN_PACKAGE_ID='3';
	ELSIF in_usage='210' AND in_type='1' THEN RTN_PACKAGE_ID='4';
	ELSIF in_usage='210' AND in_type='3' THEN RTN_PACKAGE_ID='5';
	ELSIF in_usage='210' AND (in_type='2+' OR in_type='3+') THEN RTN_PACKAGE_ID='6';
	ELSIF in_usage='320' AND in_type='1' THEN RTN_PACKAGE_ID='7';
	ELSIF in_usage='320' AND in_type='3' THEN RTN_PACKAGE_ID='8';
	ELSIF in_usage='320' AND (in_type='2+' OR in_type='3+') THEN RTN_PACKAGE_ID='9';
	ELSIF in_usage='1.10' THEN RTN_PACKAGE_ID='2';
	ELSIF in_usage='1.40A' THEN RTN_PACKAGE_ID='13';
	ELSIF in_usage='1.20A' THEN RTN_PACKAGE_ID='9';
	ELSIF in_usage='E11PA'  THEN RTN_PACKAGE_ID='71';
	END IF;
	RETURN RTN_PACKAGE_ID;
END
$function$
