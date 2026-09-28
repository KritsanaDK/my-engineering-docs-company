-- =============================================================================
-- 📌 DEPLOY FUNCTIONS FINGERPRINT (READ-ONLY) — 11 functions ของรอบ Deploy นี้
-- =============================================================================
-- รันได้ทั้ง UAT-ISV และ Production — SELECT ล้วน ไม่มีการเขียนข้อมูล
-- Runs identically on UAT-ISV and Production. SELECT-only.
--
-- วิธีรัน / How to run:
--   psql -h <HOST> -U <USER> -d insurverse -X -q -A -t -F '|' \
--        -c 'SET default_transaction_read_only = on' \
--        -f 00_fingerprint_readonly.sql > fingerprint_prod.txt
--
-- ผลลัพธ์: หนึ่งบรรทัดต่อ function → name(args)|returns|md5(body)|length
-- ถ้า function ไม่มีบน DB นั้น จะขึ้น MISSING
-- =============================================================================

WITH wanted(proname) AS (
    VALUES ('fn_format_utc_timestamp_th'), ('fn_lead_to_car_act'), ('fn_policy_barcode'),
           ('fn_policy_book_iia'), ('fn_policy_invoiceno_iia'), ('fn_policy_lotno_iia'),
           ('fn_policy_quatationno_iia'), ('fn_policy_renewal'), ('fn_policy_renewal_noti'),
           ('fn_policy_renewal_noti_log'), ('fn_policy_to_car_act')
)
SELECT COALESCE(p.proname || '(' || pg_get_function_identity_arguments(p.oid) || ')', w.proname || '(?)') AS function_name,
       COALESCE(pg_get_function_result(p.oid), '')                                    AS returns,
       COALESCE(md5(p.prosrc), 'MISSING')                                             AS body_md5,
       COALESCE(length(p.prosrc)::text, '0')                                          AS body_len
  FROM wanted w
  LEFT JOIN pg_proc p
         ON p.proname = w.proname
        AND p.pronamespace = 'insurverse'::regnamespace
 ORDER BY 1;
