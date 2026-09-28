-- =============================================================================
-- Function: insurverse.fn_promo_promotion_list_backup_25_sep
-- OID: 18868
-- Identity Arguments: (in_group_type text, in_sub_group_type text, in_promocode text, in_email text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 05_deprecated_and_zombie
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_promo_promotion_list_backup_25_sep(in_group_type text, in_sub_group_type text, in_promocode text, in_email text)
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
)
SELECT json_build_object(
'unique_promotions',(SELECT json_agg("unquie_promotions")
FROM (
SELECT *,
CASE WHEN number_quota > 0 AND promo_used_count >= number_quota THEN 'promo_limit' -- (active)
WHEN number_quota_user != 0 AND email_used_count >= number_quota_user  THEN 'user_limit' -- (active)
WHEN now() + INTERVAL '7HOUR' < active_start_date  THEN 'wait'
ELSE 'active' END as "promo_card_status"
FROM (
SELECT
"promo_code"."promo_code_id",
promo_code_url AS thumbnail,
promo_banner_url,
"promo_code"."promo_code_prefix" as "promo_code_prefix",
promo_code_name,
promo_code_desc,
product_group_type,
product_sub_type,
promo_start_date + INTERVAL '7HOUR' as "promo_start_date",
promo_end_date + INTERVAL '7HOUR' as "promo_end_date",
active_start_date + INTERVAL '7HOUR' as "active_start_date",
active_end_date + INTERVAL '7HOUR' as "active_end_date",
prem_type,
prem_value,
priority,
term_condition_desc,
redeem_point,
number_quota_user,
number_quota,
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2"
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by"="set_para"."email") as "email_used_count",
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by" IS NOT NULL AND "trans_2"."promo_active_by" != '') as "promo_used_count",
"promo_code"."suggest_status",
"promo_code"."promo_code_type",
"promo_code".promo_screen_status,
FALSE as "is_promo_mapping",
"promo_code"."redeem_status",
"promo_code"."cta_label_button",
"promo_code"."cta_url",
"promo_code"."min_amt"
FROM insurverse.promo_code
INNER JOIN "set_para"
ON "promo_code"."product_group_type" = "set_para"."group_type"
AND (("promo_code"."product_sub_type" = "set_para"."sub_group_type"
OR "promo_code"."product_sub_type"='' OR "promo_code"."product_sub_type"=null)
OR ("set_para"."sub_group_type"='all'))
AND "promo_code"."promo_code_status"='ACT'
AND "promo_code".promo_code_type = 'unique'
AND ("promo_code".redeem_status IS NULL OR "promo_code".redeem_status !='ACT')
AND now() <= "promo_code".active_end_date
) as "sub_promotions"
) as "unquie_promotions"),
'promotions',
(SELECT json_agg("promotions")
FROM (
SELECT *,
CASE WHEN number_quota > 0 AND promo_used_count >= number_quota THEN 'promo_limit' -- (active)
WHEN number_quota_user != 0 AND email_used_count >= number_quota_user  THEN 'user_limit' -- (active)
WHEN now() + INTERVAL '7HOUR' < active_start_date  THEN 'wait'
ELSE 'active' END as "promo_card_status"
FROM (
SELECT
"promo_code"."promo_code_id",
promo_code_url AS thumbnail,
promo_banner_url,
promo_code_prefix,
promo_code_name,
promo_code_desc,
product_group_type,
product_sub_type,
promo_start_date + INTERVAL '7HOUR' as "promo_start_date",
promo_end_date + INTERVAL '7HOUR' as "promo_end_date",
active_start_date + INTERVAL '7HOUR' as "active_start_date",
active_end_date + INTERVAL '7HOUR' as "active_end_date",
prem_type,
prem_value,
priority,
term_condition_desc,
redeem_point,
number_quota_user,
number_quota,
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by"="set_para"."email") as "email_used_count",
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by" IS NOT NULL AND "trans_2"."promo_active_by" != '') as "promo_used_count",
"promo_code"."suggest_status",
"promo_code"."promo_code_type",
"promo_code".promo_screen_status,
CASE WHEN LOWER("promo_code"."promo_code_prefix")=LOWER("set_para"."promocode") THEN TRUE ELSE FALSE END as "is_promo_mapping",
"promo_code"."redeem_status",
"promo_code"."cta_label_button",
"promo_code"."cta_url",
"promo_code"."min_amt"
FROM insurverse."promo_code"
INNER JOIN "set_para"
ON "promo_code"."product_group_type" = "set_para"."group_type"
AND ("promo_code"."product_sub_type" = "set_para"."sub_group_type"
OR "promo_code"."product_sub_type"='' OR "promo_code"."product_sub_type"=null
OR ("set_para"."sub_group_type"='all' AND "promo_code"."product_sub_type"!=''))
AND "promo_code"."promo_code_status" = 'ACT'
AND NOW() <= "active_end_date"
AND LOWER("promo_code"."promo_code_type")='mass'
AND ("promo_code".redeem_status IS NULL OR "promo_code".redeem_status !='ACT')
UNION
SELECT
"promo_code"."promo_code_id",
promo_code_url AS thumbnail,
promo_banner_url,
"promo_code_trans"."promo_code" as "promo_code_prefix",
promo_code_name,
promo_code_desc,
product_group_type,
product_sub_type,
promo_start_date + INTERVAL '7HOUR' as "promo_start_date",
promo_end_date + INTERVAL '7HOUR' as "promo_end_date",
active_start_date + INTERVAL '7HOUR' as "active_start_date",
active_end_date + INTERVAL '7HOUR' as "active_end_date",
prem_type,
prem_value,
priority,
term_condition_desc,
redeem_point,
number_quota_user,
number_quota,
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2"
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by"="set_para"."email") as "email_used_count",
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by" IS NOT NULL AND "trans_2"."promo_active_by" != '') as "promo_used_count",
"promo_code"."suggest_status",
"promo_code"."promo_code_type",
"promo_code".promo_screen_status,
CASE WHEN LOWER("promo_code_trans"."promo_code")=LOWER("set_para"."promocode") THEN TRUE ELSE FALSE END as "is_promo_mapping",
"promo_code"."redeem_status",
"promo_code"."cta_label_button",
"promo_code"."cta_url",
"promo_code"."min_amt"
FROM insurverse.promo_code
INNER JOIN insurverse."promo_code_trans"
ON "promo_code"."promo_code_id"="promo_code_trans"."promo_code_id"
AND "promo_code"."promo_code_status"='ACT'
AND "promo_code_trans"."promo_trans_status"='ACT'
AND ("promo_code_trans"."promo_active_by" IS NULL OR "promo_code_trans"."promo_active_by"='')
AND "promo_code".promo_code_type = 'unique'
AND now() <= "promo_code".active_end_date
INNER JOIN "set_para"
ON "promo_code"."product_group_type" = "set_para"."group_type"
AND (("promo_code"."product_sub_type" = "set_para"."sub_group_type"
OR "promo_code"."product_sub_type"='' OR "promo_code"."product_sub_type"=null)
OR ("set_para"."sub_group_type"='all'))
AND "promo_code_trans"."promo_code"="set_para"."promocode"-- (2023-11-21)
AND (("promo_code".redeem_status IS NULL OR "promo_code".redeem_status !='ACT')
or ("promo_code".redeem_status='ACT' and "promo_code_trans"."promo_book_by" != "set_para"."email")
)
) as "sub_promotions"
) as "promotions"),
'loyalty',
(SELECT json_agg("loyalty")
FROM ( SELECT *,
CASE WHEN number_quota > 0 AND promo_used_count >= number_quota THEN 'promo_limit' -- (active)
WHEN number_quota_user != 0 AND email_used_count >= number_quota_user  THEN 'user_limit' -- (active)
WHEN now() + INTERVAL '7HOUR' < active_start_date  THEN 'wait'
ELSE 'active' END as "promo_card_status"
FROM (
SELECT
"promo_code"."promo_code_id",
promo_code_url AS thumbnail,
promo_banner_url,
"promo_code_trans"."promo_code" as "promo_code_prefix",
promo_code_name,
promo_code_desc,
product_group_type,
product_sub_type,
promo_start_date + INTERVAL '7HOUR' as "promo_start_date",
promo_end_date + INTERVAL '7HOUR' as "promo_end_date",
active_start_date + INTERVAL '7HOUR' as "active_start_date",
active_end_date + INTERVAL '7HOUR' as "active_end_date",
prem_type,
prem_value,
priority,
term_condition_desc,
redeem_point,
number_quota_user,
number_quota,
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2"
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by"="set_para"."email") as "email_used_count",
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_active_by" IS NOT NULL AND "trans_2"."promo_active_by" != '') as "promo_used_count",
"promo_code"."suggest_status",
"promo_code"."promo_code_type",
"promo_code".promo_screen_status,
CASE WHEN LOWER("promo_code_trans"."promo_code")=LOWER("set_para"."promocode") THEN TRUE ELSE FALSE END as "is_promo_mapping",
"promo_code"."redeem_status",
"promo_code"."cta_label_button",
"promo_code"."cta_url",
"promo_code"."min_amt"
FROM insurverse.promo_code
INNER JOIN insurverse."promo_code_trans"
ON "promo_code"."promo_code_id"="promo_code_trans"."promo_code_id"
AND "promo_code"."promo_code_status"='ACT'
AND "promo_code_trans"."promo_trans_status"='ACT'
AND ("promo_code_trans"."promo_active_by" IS NULL OR "promo_code_trans"."promo_active_by"='')
AND "promo_code".promo_code_type = 'unique'
AND now() <= "promo_code".active_end_date
INNER JOIN "set_para"
ON "promo_code"."product_group_type" = "set_para"."group_type"
AND (("promo_code"."product_sub_type" = "set_para"."sub_group_type"
OR "promo_code"."product_sub_type"='' OR "promo_code"."product_sub_type"=null)
OR ("set_para"."sub_group_type"='all'))
AND (LOWER("promo_code_trans"."promo_book_by") = LOWER("set_para"."email") AND "promo_code"."redeem_status"='ACT')
) as "sub_loyalty"
) as "loyalty"),
'redeem_exchange',
(SELECT json_agg("redeem_exchange")
FROM ( SELECT *,
CASE WHEN number_quota > 0 AND promo_used_count >= number_quota THEN 'promo_limit' -- (book)
WHEN number_quota_user != 0 AND email_used_count >= number_quota_user  THEN 'user_limit' -- (book)
WHEN now() + INTERVAL '7HOUR' < active_start_date  THEN 'wait'
ELSE 'active' END as "promo_card_status"
FROM (
SELECT
"promo_code"."promo_code_id",
promo_code_url AS thumbnail,
promo_banner_url,
"promo_code_prefix",
promo_code_name,
promo_code_desc,
product_group_type,
product_sub_type,
promo_start_date + INTERVAL '7HOUR' as "promo_start_date",
promo_end_date + INTERVAL '7HOUR' as "promo_end_date",
active_start_date + INTERVAL '7HOUR' as "active_start_date",
active_end_date + INTERVAL '7HOUR' as "active_end_date",
prem_type,
prem_value,
priority,
term_condition_desc,
redeem_point,
number_quota_user,
number_quota,
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2"
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_book_by"=(SELECT "email" FROM "set_para")) as "email_used_count",
(SELECT COUNT(*) FROM insurverse."promo_code_trans" as "trans_2" 
WHERE "promo_code"."promo_code_id"="trans_2"."promo_code_id"
AND "trans_2"."promo_trans_status"='ACT' 
AND "trans_2"."promo_book_by" IS NOT NULL AND "trans_2"."promo_book_by" != '') as "promo_used_count",
"promo_code"."suggest_status",
"promo_code"."promo_code_type",
"promo_code".promo_screen_status,
FALSE as "is_promo_mapping",
"promo_code"."redeem_status",
"promo_code"."cta_label_button",
"promo_code"."cta_url",
"promo_code"."min_amt"
FROM insurverse.promo_code
WHERE "promo_code"."promo_code_status"='ACT'
AND "promo_code".promo_code_type = 'unique'
AND "promo_code".redeem_status ='ACT'
AND now() <= "promo_code".active_end_date
) as "sub_redeem_exchange"
) as "redeem_exchange")
)
INTO RTN_JSON;
RETURN RTN_JSON;
END
$function$
