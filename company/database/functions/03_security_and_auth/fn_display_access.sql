-- =============================================================================
-- Function: insurverse.fn_display_access
-- OID: 18487
-- Identity Arguments: (access_para_code text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 03_security_and_auth
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_display_access(access_para_code text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    rtn_access_text TEXT DEFAULT '';
BEGIN
    IF access_para_code IS NOT NULL
       AND access_para_code <> ''
       AND access_para_code <> '[]'
    THEN
        SELECT COALESCE(
            string_agg(sp.para_name::TEXT, ',' ORDER BY ja.seq),
            ''
        )
        INTO rtn_access_text
        FROM json_array_elements_text(access_para_code::JSON)
             WITH ORDINALITY AS ja(para_code, seq)
        INNER JOIN insurverse.sys_param sp
            ON sp.para_code = ja.para_code;
    END IF;

    RETURN rtn_access_text;
END;
$function$
