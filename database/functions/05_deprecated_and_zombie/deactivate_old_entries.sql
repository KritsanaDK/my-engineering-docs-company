-- =============================================================================
-- Function: insurverse.deactivate_old_entries
-- OID: 18442
-- Identity Arguments: ()
-- Returns: trigger
-- Language: plpgsql
-- Categorization: 05_deprecated_and_zombie
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.deactivate_old_entries()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE mas_limite_purchase 
    SET active = FALSE 
    WHERE period_name = NEW.period_name 
    AND id != NEW.id;
    
    RETURN NEW;
END;
$function$
