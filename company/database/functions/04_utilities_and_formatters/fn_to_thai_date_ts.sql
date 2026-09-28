-- =============================================================================
-- Function: insurverse.fn_to_thai_date_ts
-- OID: 18910
-- Identity Arguments: (ts timestamp without time zone)
-- Returns: character varying
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_to_thai_date_ts(ts timestamp without time zone)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    --thai_months VARCHAR[] := ARRAY['', 'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน', 'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'];
		thai_months VARCHAR[] := ARRAY['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ย.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
BEGIN
		ts = ts + interval '543year';
    RETURN cast(TO_CHAR(ts, 'DD') as int) || ' ' || thai_months[EXTRACT(MONTH FROM ts)] || ' ' || TO_CHAR(ts, 'YYYY');
END;
$function$
