-- =============================================================================
-- Function: insurverse.test_jane
-- OID: 19017
-- Identity Arguments: ()
-- Returns: text
-- Language: sql
-- Categorization: 05_deprecated_and_zombie
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.test_jane()
 RETURNS text
 LANGUAGE sql
AS $function$
    SELECT 'Hello from test_jane!'::text;
$function$
