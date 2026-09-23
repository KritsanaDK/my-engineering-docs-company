-- =============================================================================
-- 📌 JOB 04 — STEP 1: BACKUP CURRENT STATE (READ-ONLY, Rule 3)
-- =============================================================================
-- บันทึกสถานะเดิมของคอลัมน์ Lead_No และ sequence ลงไฟล์ก่อนแก้ไข
-- Captures the current Lead_No default and sequence state to a timestamped file.
--
-- วิธีรัน / How to run:
--   psql "$PROD_DSN" -v ON_ERROR_STOP=1 -f 01_backup_state.sql \
--        -o backups/backup_lead_no_state_$(date +%Y%m%d_%H%M%S).txt
--
-- ไฟล์ผลลัพธ์คือข้อมูลที่ใช้ใน 99_rollback.sql
-- The output file is the input for 99_rollback.sql.
-- =============================================================================

\echo '== backup taken at'
SELECT now();

\echo '== Lead_No column definition'
SELECT column_name, data_type, is_nullable, column_default
  FROM information_schema.columns
 WHERE table_schema = 'insurverse'
   AND table_name   = 'Lead_coverage_premium'
   AND column_name  = 'Lead_No';

\echo '== seq_lead_no definition (empty if it does not exist)'
SELECT c.relname, s.seqtypid::regtype AS data_type, s.seqstart, s.seqincrement,
       s.seqmin, s.seqmax, s.seqcache, s.seqcycle
  FROM pg_sequence s
  JOIN pg_class c     ON c.oid = s.seqrelid
  JOIN pg_namespace n ON n.oid = c.relnamespace
 WHERE n.nspname = 'insurverse'
   AND c.relname = 'seq_lead_no';

\echo '== seq_lead_no position (empty if it does not exist)'
SELECT sequencename, last_value
  FROM pg_sequences
 WHERE schemaname   = 'insurverse'
   AND sequencename = 'seq_lead_no';

\echo '== MAX(Lead_No)'
SELECT MAX("Lead_No") AS max_lead_no FROM insurverse."Lead_coverage_premium";
