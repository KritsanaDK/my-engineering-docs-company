-- =============================================================================
-- Function: insurverse.fn_display_country
-- OID: 18505
-- Identity Arguments: (country_para_code text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_display_country(country_para_code text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_ACCESS_TEXT TEXT DEFAULT '';
BEGIN
	IF country_para_code IS NOT NULL AND country_para_code != '' THEN
		SELECT DISTINCT regexp_replace(regexp_replace(CAST(array_agg(country_name_en::TEXT) as TEXT), '{','', 'g'), '}','', 'g')
		FROM insurverse.mas_country 
		INNER JOIN json_array_elements(country_para_code::json) as "json_a" 
		ON mas_country.country_id=CAST(regexp_replace(CAST(json_a.value as TEXT), '"','', 'g') as INT2)
		INTO RTN_ACCESS_TEXT;
		
		RTN_ACCESS_TEXT = replace(RTN_ACCESS_TEXT,'"','');
		RTN_ACCESS_TEXT = replace(RTN_ACCESS_TEXT,',',', ');
  END IF;
	
	RETURN RTN_ACCESS_TEXT;
END
$function$
