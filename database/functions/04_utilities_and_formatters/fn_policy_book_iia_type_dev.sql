-- =============================================================================
-- Function: insurverse.fn_policy_book_iia_type_dev
-- OID: 18587
-- Identity Arguments: (group_type text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_book_iia_type_dev(group_type text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	SYS_POLICY_BOOK TEXT;
BEGIN
  IF LOWER(group_type) = 'ta' THEN
		SYS_POLICY_BOOK = '12-4-90';
	ELSIF LOWER(group_type) = 'pa' THEN
		SYS_POLICY_BOOK = '12-4-90';
	ELSIF LOWER(group_type) = 'home' THEN
		SYS_POLICY_BOOK = '12-4-90';
	ELSIF LOWER(group_type) = 'motor' THEN
		SYS_POLICY_BOOK = '12-1-90';
	END IF;
	RETURN SYS_POLICY_BOOK;
END
$function$
