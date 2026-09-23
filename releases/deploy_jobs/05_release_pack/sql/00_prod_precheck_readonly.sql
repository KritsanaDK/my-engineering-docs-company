-- =============================================================================
-- 📌 RELEASE PACK 05 — PROD PRE-CHECK (READ-ONLY) — OIC / WS6-9 / FX-01
-- =============================================================================
-- รันบน Production ก่อนตัดสินใจรัน SQL ใดๆ ไม่มีการเขียนข้อมูล (SELECT ล้วน)
-- Run on Production before deciding which SQL to apply. SELECT-only, no writes.
--
-- ส่งผลลัพธ์ทั้งหมดกลับมาให้เทียบกับค่าอ้างอิงของ UAT-ISV ใน deployment_plan_05_release.md §3
-- Send the full output back so it can be compared with the UAT-ISV reference in §3.
-- =============================================================================

-- [1] Stored functions ที่ Release นี้เกี่ยวข้อง: signature + md5 ของ body
--     Functions touched by this release: signature and body md5
SELECT p.proname                                   AS function_name,
       pg_get_function_identity_arguments(p.oid)   AS identity_args,
       md5(p.prosrc)                               AS src_md5,
       length(p.prosrc)                            AS src_len,
       p.prosrc ILIKE '%pg_advisory_xact_lock%'    AS has_advisory_lock
  FROM pg_proc p
  JOIN pg_namespace n ON n.oid = p.pronamespace
 WHERE n.nspname = 'insurverse'
   AND p.proname IN ('fn_lead_to_car_act', 'fn_policy_to_car_act',
                     'fn_policy_invoiceno_iia', 'fn_policy_quatationno_iia',
                     'fn_policy_renewal', 'fn_format_utc_timestamp_th')
 ORDER BY 1, 2;

-- [2] Job 04 (#13): สถานะ Lead_No DEFAULT / sequence
--     Job 04 (#13): Lead_No default and sequence state
SELECT 'lead_no_default' AS check_name, column_default AS value
  FROM information_schema.columns
 WHERE table_schema = 'insurverse' AND table_name = 'Lead_coverage_premium' AND column_name = 'Lead_No'
UNION ALL
SELECT 'seq_lead_no', COALESCE(to_regclass('insurverse.seq_lead_no')::text, 'NOT FOUND')
UNION ALL
SELECT 'max_lead_no', MAX("Lead_No")::text FROM insurverse."Lead_coverage_premium";

-- [3] WS6 data patch: ชนิดคอลัมน์ที่สคริปต์เดิมอ้างถึง (no_cancel_flag บน UAT-ISV เป็น varchar)
--     WS6 data patch: types of the columns the original script relies on
SELECT column_name, data_type
  FROM information_schema.columns
 WHERE table_schema = 'insurverse' AND table_name = 'Policy_Header'
   AND column_name IN ('prem_version', 'Policy_Status', 'no_cancel_flag', 'Update_date', 'Update_by')
 ORDER BY 1;

-- [4] WS6 data patch: จำนวนแถวที่จะโดนแก้ (dry-run) และค่าที่มีจริง
--     WS6 data patch: rows each UPDATE would touch (dry run) and the values present
SELECT 'upd3_prem_version_rows' AS check_name, COUNT(*)::text AS value
  FROM insurverse."Policy_Header" ph
  JOIN insurverse."Policy_coverage_premium" pcp ON ph."Policy_No" = pcp."Policy_No"
 WHERE ph.prem_version IS NULL AND pcp.prem_version IS NOT NULL
UNION ALL
SELECT 'upd3_policies_with_conflicting_versions', COUNT(*)::text
  FROM (SELECT pcp."Policy_No"
          FROM insurverse."Policy_coverage_premium" pcp
          JOIN insurverse."Policy_Header" ph ON ph."Policy_No" = pcp."Policy_No"
         WHERE ph.prem_version IS NULL AND pcp.prem_version IS NOT NULL
         GROUP BY pcp."Policy_No"
        HAVING COUNT(DISTINCT pcp.prem_version) > 1) x;

SELECT "Policy_Status", no_cancel_flag, COUNT(*) AS policies
  FROM insurverse."Policy_Header"
 GROUP BY 1, 2
 ORDER BY 3 DESC
 LIMIT 30;
