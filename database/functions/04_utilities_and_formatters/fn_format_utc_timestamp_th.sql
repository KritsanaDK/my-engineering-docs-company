-- =============================================================================
-- Function: insurverse.fn_format_utc_timestamp_th
-- OID: 25457
-- Identity Arguments: (p_timestamp timestamp without time zone)
-- Returns: character varying
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_format_utc_timestamp_th(p_timestamp timestamp without time zone)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF p_timestamp IS NULL THEN
        RETURN '';
    END IF;
    -- บวกเวลา 7 ชั่วโมงเข้ากับ UTC Time เพื่อให้ตรงกับเวลาประเทศไทย
    RETURN to_char(p_timestamp + INTERVAL '7 HOUR', 'YYYY-MM-DD"T"HH24:MI:SS.MS');
END;
$function$
