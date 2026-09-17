-- =============================================================================
-- Function: insurverse.fn_check_next_invoice_no
-- OID: 18446
-- Identity Arguments: (p_prefix text)
-- Returns: TABLE(prefix text, max_no integer, digit_len integer, next_invoice_no text)
-- Language: plpgsql
-- Categorization: 01_critical_policy_and_payment
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_check_next_invoice_no(p_prefix text)
 RETURNS TABLE(prefix text, max_no integer, digit_len integer, next_invoice_no text)
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    v_max_no    INT;
    v_digit_len INT;
BEGIN
    SELECT
        GREATEST(
            (SELECT MAX(CAST(SPLIT_PART("Policy_Invoice_No", '/', 2) AS INT))
             FROM insurverse."Policy_Header"
             WHERE "Policy_Invoice_No" LIKE p_prefix || '/%'),
            (SELECT MAX(CAST(SPLIT_PART("Policy_Invoice_No", '/', 2) AS INT))
             FROM insurverse."Policy_Car_Act_Discount_Premium"
             WHERE "Policy_Invoice_No" LIKE p_prefix || '/%'),
            (SELECT MAX(CAST(SPLIT_PART(policy_invoice_no, '/', 2) AS INT))
             FROM insurverse."policy_ta_premium"
             WHERE policy_invoice_no LIKE p_prefix || '/%'),
            (SELECT MAX(CAST(SPLIT_PART(policy_invoice_no, '/', 2) AS INT))
             FROM insurverse."policy_pa_premium"
             WHERE policy_invoice_no LIKE p_prefix || '/%'),
            (SELECT MAX(CAST(SPLIT_PART(policy_invoice_no, '/', 2) AS INT))
             FROM insurverse."policy_home_premium"
             WHERE policy_invoice_no LIKE p_prefix || '/%'),
            (SELECT MAX(CAST(SPLIT_PART("Policy_Invoice_No", '/', 2) AS INT))
             FROM insurverse."Policy_endorse_detail"
             WHERE "Policy_Invoice_No" LIKE p_prefix || '/%')
        )
    INTO v_max_no;

    IF v_max_no IS NULL THEN
        v_max_no    := 0;
        v_digit_len := 4;
    ELSE
        v_digit_len := GREATEST(LENGTH(v_max_no::TEXT), 4);
    END IF;

    RETURN QUERY
    SELECT
        p_prefix,
        v_max_no,
        v_digit_len,
        p_prefix || '/' || LPAD((v_max_no + 1)::TEXT, v_digit_len, '0');
END;
$function$
