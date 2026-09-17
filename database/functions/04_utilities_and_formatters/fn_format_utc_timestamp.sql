-- =============================================================================
-- Function: insurverse.fn_format_utc_timestamp
-- OID: 18524
-- Identity Arguments: (in_times timestamp without time zone)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_format_utc_timestamp(in_times timestamp without time zone)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE 
TXT_UTC TEXT;
BEGIN
	TXT_UTC = to_char(in_times::date, 'yyyy-mm-dd') || 'T' || to_char(in_times::time, 'HH24:MI:SS') || '+07:00';
	
	IF TXT_UTC IS NULL THEN
		TXT_UTC = null;
	END IF;
	RETURN TXT_UTC;
END
$function$
