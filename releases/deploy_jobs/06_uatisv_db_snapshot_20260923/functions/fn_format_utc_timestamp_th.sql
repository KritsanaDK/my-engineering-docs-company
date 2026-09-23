-- Source: UAT-ISV insurverse, exported 2026-09-23 (pg_get_functiondef)
-- Signature: fn_format_utc_timestamp_th(p_timestamp timestamp without time zone)
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

;
