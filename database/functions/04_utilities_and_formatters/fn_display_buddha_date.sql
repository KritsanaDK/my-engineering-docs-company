-- =============================================================================
-- Function: insurverse.fn_display_buddha_date
-- OID: 18496
-- Identity Arguments: (in_date_ac timestamp without time zone)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_display_buddha_date(in_date_ac timestamp without time zone)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
SYS_YEAR_AC int; SYS_MONTH_AC text; SYS_DAY_AC text;
SYS_YEAR_BC text;
RTN_DATE_BC text;
	begin
		SYS_DAY_AC = replace(TO_CHAR(EXTRACT(day FROM in_date_ac),'00'),' ','');
		SYS_MONTH_AC = replace(TO_CHAR(EXTRACT(month FROM in_date_ac),'00'),' ','');
		SYS_YEAR_AC = EXTRACT(year FROM in_date_ac);
		SYS_YEAR_BC = SYS_YEAR_AC + 543;
		RTN_DATE_BC = SYS_DAY_AC || '/' || SYS_MONTH_AC || '/' || SYS_YEAR_BC;
		return RTN_DATE_BC;
	END;
$function$
