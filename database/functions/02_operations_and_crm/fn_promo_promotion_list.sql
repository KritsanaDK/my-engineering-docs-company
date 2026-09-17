-- =============================================================================
-- Function: insurverse.fn_promo_promotion_list
-- OID: 18862
-- Identity Arguments: (in_group_type text, in_sub_group_type text, in_promocode text, in_email text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_promo_promotion_list(in_group_type text, in_sub_group_type text, in_promocode text, in_email text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
  RTN_JSON TEXT;
	BEGIN
    WITH set_para as (SELECT 
    "in_group_type" as "group_type",
    "in_sub_group_type" as "sub_group_type",
    "in_promocode" as "promocode",
    "in_email" as "email"
    ),
    promo_counts AS (
        SELECT
            promo_code_id,
            COUNT(*) FILTER (WHERE promo_active_by IS NOT NULL AND promo_active_by != '') AS promo_used_count,
            COUNT(*) FILTER (WHERE promo_active_by = (SELECT email FROM set_para)) AS email_used_count,
            COUNT(*) FILTER (WHERE promo_book_by IS NOT NULL AND promo_book_by != '') AS promo_booked_count,
            COUNT(*) FILTER (WHERE promo_book_by = (SELECT email FROM set_para)) AS email_booked_count_user
        FROM
            insurverse.promo_code_trans
        WHERE
            promo_trans_status = 'ACT'
        GROUP BY
            promo_code_id
    ),
    all_promotions_base AS (
        SELECT
            pc.promo_code_id,
            pc.promo_code_url AS thumbnail,
            pc.promo_banner_url,
            pc.promo_code_prefix,
            pc.promo_code_name,
            pc.promo_code_desc,
            pc.product_group_type,
            pc.product_sub_type,
            pc.promo_start_date + INTERVAL '7 HOUR' as "promo_start_date",
            pc.promo_end_date + INTERVAL '7 HOUR' as "promo_end_date",
            pc.active_start_date + INTERVAL '7 HOUR' as "active_start_date",
            pc.active_end_date + INTERVAL '7 HOUR' as "active_end_date",
            pc.prem_type,
            pc.prem_value,
            pc.priority,
            pc.term_condition_desc,
            pc.redeem_point,
            pc.number_quota_user,
            pc.number_quota,
            COALESCE(counts.promo_used_count, 0) AS promo_used_count,
            COALESCE(counts.email_used_count, 0) AS email_used_count,
            COALESCE(counts.promo_booked_count, 0) AS promo_booked_count,
            COALESCE(counts.email_booked_count_user, 0) AS email_booked_count_user,
            pc.suggest_status,
            pc.promo_code_type,
            pc.promo_screen_status,
            pc.redeem_status,
            pc.cta_label_button,
            pc.cta_url,
            pc.min_amt,
            -- Calculate promo card status in one central place
            CASE 
                WHEN pc.number_quota > 0 AND COALESCE(counts.promo_used_count, 0) >= pc.number_quota THEN 'promo_limit'
                WHEN pc.number_quota_user != 0 AND COALESCE(counts.email_used_count, 0) >= pc.number_quota_user THEN 'user_limit'
                WHEN now() + INTERVAL '7 HOUR' < (pc.active_start_date + INTERVAL '7 HOUR') THEN 'wait'
                ELSE 'active' 
            END as "promo_card_status"
        FROM
            insurverse.promo_code pc
        LEFT JOIN
            promo_counts counts ON pc.promo_code_id = counts.promo_code_id
        WHERE
            pc.promo_code_status = 'ACT'
            AND now() <= pc.active_end_date
        ORDER by
        	pc.promo_code_id
    ),
    unique_promotions_data AS (
        SELECT 
            p.promo_code_id,
            p.thumbnail,
            p.promo_banner_url,
            p.promo_code_prefix,
            p.promo_code_name,
            p.promo_code_desc,
            p.product_group_type,
            p.product_sub_type,
            p.promo_start_date,
            p.promo_end_date,
            p.active_start_date,
            p.active_end_date,
            p.prem_type,
            p.prem_value,
            p.priority,
            p.term_condition_desc,
            p.redeem_point,
            p.number_quota_user,
            p.number_quota,
            p.email_used_count,
            p.promo_used_count,
            p.suggest_status,
            p.promo_code_type,
            p.promo_screen_status,
            FALSE as "is_promo_mapping", -- As per original logic for this section
            p.redeem_status,
            p.cta_label_button,
            p.cta_url,
            p.min_amt,
            p.promo_card_status
        FROM all_promotions_base p
        CROSS JOIN set_para
        WHERE p.promo_code_type = 'unique'
          AND (p.redeem_status IS NULL OR p.redeem_status != 'ACT')
          AND p.product_group_type = set_para.group_type
          AND (p.product_sub_type = set_para.sub_group_type OR p.product_sub_type = '' OR p.product_sub_type IS NULL OR set_para.sub_group_type = 'all')
    ),
    promotions_data AS (
        -- Mass Promotions
        SELECT 
            p.promo_code_id, p.thumbnail, p.promo_banner_url, p.promo_code_prefix, p.promo_code_name, p.promo_code_desc,
            p.product_group_type, p.product_sub_type, p.promo_start_date, p.promo_end_date, p.active_start_date, p.active_end_date,
            p.prem_type, p.prem_value, p.priority, p.term_condition_desc, p.redeem_point, p.number_quota_user, p.number_quota,
            p.email_used_count, p.promo_used_count, p.suggest_status, p.promo_code_type, p.promo_screen_status,
            CASE WHEN LOWER(p.promo_code_prefix) = LOWER(set_para.promocode) THEN TRUE ELSE FALSE END as "is_promo_mapping",
            p.redeem_status, p.cta_label_button, p.cta_url, p.min_amt, p.promo_card_status
        FROM all_promotions_base p
        CROSS JOIN set_para
        WHERE p.promo_code_type = 'mass'
            AND (p.redeem_status IS NULL OR p.redeem_status != 'ACT')
            AND p.product_group_type = set_para.group_type
            AND (p.product_sub_type = set_para.sub_group_type OR p.product_sub_type = '' OR p.product_sub_type IS NULL OR (set_para.sub_group_type = 'all' AND p.product_sub_type != ''))
        
        UNION ALL

        -- Unique promotions that match a user-entered promo code
        SELECT 
            p.promo_code_id, p.thumbnail, p.promo_banner_url, pct.promo_code AS "promo_code_prefix", p.promo_code_name, p.promo_code_desc,
            p.product_group_type, p.product_sub_type, p.promo_start_date, p.promo_end_date, p.active_start_date, p.active_end_date,
            p.prem_type, p.prem_value, p.priority, p.term_condition_desc, p.redeem_point, p.number_quota_user, p.number_quota,
            p.email_used_count, p.promo_used_count, p.suggest_status, p.promo_code_type, p.promo_screen_status,
            CASE WHEN LOWER(pct.promo_code) = LOWER(set_para.promocode) THEN TRUE ELSE FALSE END as "is_promo_mapping",
            p.redeem_status, p.cta_label_button, p.cta_url, p.min_amt, p.promo_card_status
        FROM all_promotions_base p
        INNER JOIN insurverse.promo_code_trans pct ON p.promo_code_id = pct.promo_code_id
        CROSS JOIN set_para
        WHERE p.promo_code_type = 'unique'
            AND pct.promo_trans_status = 'ACT'
            AND (pct.promo_active_by IS NULL OR pct.promo_active_by = '')
            AND pct.promo_code = set_para.promocode
            AND p.product_group_type = set_para.group_type
            AND (p.product_sub_type = set_para.sub_group_type OR p.product_sub_type = '' OR p.product_sub_type IS NULL OR set_para.sub_group_type = 'all')
            AND ((p.redeem_status IS NULL OR p.redeem_status != 'ACT') OR (p.redeem_status = 'ACT' AND pct.promo_book_by != set_para.email))
    ),

    loyalty_data AS (
        SELECT 
            p.promo_code_id, p.thumbnail, p.promo_banner_url, pct.promo_code AS "promo_code_prefix", p.promo_code_name, p.promo_code_desc,
            p.product_group_type, p.product_sub_type, p.promo_start_date, p.promo_end_date, p.active_start_date, p.active_end_date,
            p.prem_type, p.prem_value, p.priority, p.term_condition_desc, p.redeem_point, p.number_quota_user, p.number_quota,
            p.email_used_count, p.promo_used_count, p.suggest_status, p.promo_code_type, p.promo_screen_status,
            CASE WHEN LOWER(pct.promo_code) = LOWER(set_para.promocode) THEN TRUE ELSE FALSE END as "is_promo_mapping",
            p.redeem_status, p.cta_label_button, p.cta_url, p.min_amt, p.promo_card_status
        FROM all_promotions_base p
        INNER JOIN insurverse.promo_code_trans pct ON p.promo_code_id = pct.promo_code_id
        CROSS JOIN set_para
        WHERE p.promo_code_type = 'unique'
        AND p.redeem_status = 'ACT'
        AND pct.promo_trans_status = 'ACT'
        AND (pct.promo_active_by IS NULL OR pct.promo_active_by = '')
        AND LOWER(pct.promo_book_by) = LOWER(set_para.email)
        AND p.product_group_type = set_para.group_type
        AND (p.product_sub_type = set_para.sub_group_type OR p.product_sub_type = '' OR p.product_sub_type IS NULL OR set_para.sub_group_type = 'all')
    ),

    redeem_exchange_data AS (
        SELECT 
            p.promo_code_id, p.thumbnail, p.promo_banner_url, p.promo_code_prefix, p.promo_code_name, p.promo_code_desc,
            p.product_group_type, p.product_sub_type, p.promo_start_date, p.promo_end_date, p.active_start_date, p.active_end_date,
            p.prem_type, p.prem_value, p.priority, p.term_condition_desc, p.redeem_point, p.number_quota_user, p.number_quota,
            p.email_booked_count_user AS "email_used_count",
            p.promo_booked_count AS "promo_used_count",     
            p.suggest_status, p.promo_code_type, p.promo_screen_status,
            FALSE as "is_promo_mapping",
            p.redeem_status, p.cta_label_button, p.cta_url, p.min_amt,
            CASE 
                WHEN p.number_quota > 0 AND p.promo_booked_count >= p.number_quota THEN 'promo_limit'
                WHEN p.number_quota_user != 0 AND p.email_booked_count_user >= p.number_quota_user THEN 'user_limit'
                WHEN now() + INTERVAL '7 HOUR' < p.active_start_date THEN 'wait'
                ELSE 'active' 
            END as "promo_card_status"
        FROM all_promotions_base p
        WHERE p.promo_code_type = 'unique'
        AND p.redeem_status = 'ACT'
    )

SELECT json_build_object(
    'unique_promotions', (SELECT json_agg(up) FROM unique_promotions_data up),
    'promotions',        (SELECT json_agg(p) FROM promotions_data p),
    'loyalty',           (SELECT json_agg(l) FROM loyalty_data l),
    'redeem_exchange',   (SELECT json_agg(re) FROM redeem_exchange_data re)
)
INTO RTN_JSON;
RETURN RTN_JSON;
END
$function$
