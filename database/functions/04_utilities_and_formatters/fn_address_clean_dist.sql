-- =============================================================================
-- Function: insurverse.fn_address_clean_dist
-- OID: 18443
-- Identity Arguments: (district_id integer, province_id integer)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_address_clean_dist(district_id integer, province_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$

DECLARE

RTN_ADDR_TEXT TEXT;

BEGIN
 
	IF province_id = 1 THEN

		SELECT "replace"(diname, 'เขต','') as "diname"

		FROM insurverse.district

		WHERE districtid=district_id and diprovince=1

		INTO RTN_ADDR_TEXT;

	ELSE

	  SELECT diname

		FROM insurverse.district

		WHERE districtid=district_id and diprovince=province_id

		INTO RTN_ADDR_TEXT;

	END IF;

	RETURN RTN_ADDR_TEXT;

END

$function$
