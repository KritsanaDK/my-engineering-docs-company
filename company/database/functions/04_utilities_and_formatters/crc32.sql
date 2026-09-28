-- =============================================================================
-- Function: insurverse.crc32
-- OID: 18441
-- Identity Arguments: (text_string text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.crc32(text_string text)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
DECLARE
    tmp bigint;
    i int;
    j int;
    byte_length int;
    binary_string bytea;
BEGIN
    IF text_string = '' THEN
        RETURN 0;
    END IF;

    i = 0;
    tmp = 4294967295;
    byte_length = bit_length(text_string) / 8;
    binary_string = decode(replace(text_string, E'\\\\', E'\\\\\\\\'), 'escape');
    LOOP
        tmp = (tmp # get_byte(binary_string, i))::bigint;
        i = i + 1;
        j = 0;
        LOOP
            tmp = ((tmp >> 1) # (3988292384 * (tmp & 1)))::bigint;
            j = j + 1;
            IF j >= 8 THEN
                EXIT;
            END IF;
        END LOOP;
        IF i >= byte_length THEN
            EXIT;
        END IF;
    END LOOP;
    RETURN TO_HEX(tmp # 4294967295);
END
$function$
