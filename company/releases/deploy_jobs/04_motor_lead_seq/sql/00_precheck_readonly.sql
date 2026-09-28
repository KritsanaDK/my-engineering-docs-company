-- =============================================================================
-- 📌 JOB 04 — STEP 0: PRE-CHECK (READ-ONLY) — Issue #13 Motor Lead MAX()+1
-- =============================================================================
-- รันบน Production ก่อนทุกอย่าง ไม่มีการเขียนข้อมูล
-- Run on Production before anything else. Read-only.
--
-- ผลที่คาดหวัง (Expected on a DB that is READY for 7e03e85):
--   lead_no_default  = nextval('insurverse.seq_lead_no'::regclass)
--   seq_exists       = insurverse.seq_lead_no
--   seq_next         >= max_lead_no + 1
-- ถ้า lead_no_default เป็น NULL → ต้องรัน 02_migration_seq_lead_no.sql ก่อน Deploy โค้ด
-- =============================================================================

SELECT 'lead_no_default' AS check_name, column_default AS value
  FROM information_schema.columns
 WHERE table_schema = 'insurverse'
   AND table_name   = 'Lead_coverage_premium'
   AND column_name  = 'Lead_No'
UNION ALL
SELECT 'lead_no_type', data_type
  FROM information_schema.columns
 WHERE table_schema = 'insurverse'
   AND table_name   = 'Lead_coverage_premium'
   AND column_name  = 'Lead_No'
UNION ALL
SELECT 'seq_exists', COALESCE(to_regclass('insurverse.seq_lead_no')::text, 'NOT FOUND')
UNION ALL
SELECT 'serial_seq_owned_by', COALESCE(pg_get_serial_sequence('insurverse."Lead_coverage_premium"', 'Lead_No'), 'NULL (not OWNED BY)')
UNION ALL
SELECT 'max_lead_no', MAX("Lead_No")::text
  FROM insurverse."Lead_coverage_premium"
UNION ALL
SELECT 'non_internal_triggers', COUNT(*)::text
  FROM pg_trigger t
  JOIN pg_class c ON c.oid = t.tgrelid
 WHERE c.relname = 'Lead_coverage_premium'
   AND NOT t.tgisinternal;

-- สถานะ sequence (รันเฉพาะเมื่อ seq_exists ไม่ใช่ NOT FOUND)
-- Sequence state (only if seq_exists is not NOT FOUND)
-- SELECT last_value, is_called FROM insurverse.seq_lead_no;
