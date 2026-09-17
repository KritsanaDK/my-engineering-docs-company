-- =============================================================================
-- Function: insurverse.uuid_generate_v4
-- OID: 25645
-- Identity Arguments: ()
-- Returns: uuid
-- Language: sql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.uuid_generate_v4()
 RETURNS uuid
 LANGUAGE sql
AS $function$ SELECT public.uuid_generate_v4(); $function$
