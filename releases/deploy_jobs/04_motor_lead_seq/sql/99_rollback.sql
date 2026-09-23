-- =============================================================================
-- 📌 JOB 04 — ROLLBACK (DB) — Issue #13
-- =============================================================================
-- ปกติ "ไม่ต้อง" Rollback DB:
--   ถ้าต้องถอยโค้ดกลับไปเวอร์ชันเดิม (MAX+1) ให้ถอยแค่ Image ก็พอ เพราะโค้ดเดิมใส่ "Lead_No" เอง
--   และไม่สนใจ DEFAULT ของคอลัมน์ การคง DEFAULT ไว้ไม่มีผลเสีย
-- Normally NO DB rollback is needed: the previous code always supplies "Lead_No"
-- itself and ignores the column DEFAULT, so leaving the DEFAULT in place is harmless.
--
-- ใช้ไฟล์นี้เฉพาะเมื่อต้องคืนสภาพคอลัมน์ให้ตรงกับไฟล์ backup จาก 01_backup_state.sql เท่านั้น
-- และต้องถอยโค้ดกลับเป็นเวอร์ชันเดิมให้ครบทุก Pod "ก่อน" รันไฟล์นี้
-- Use only to restore the column to the state recorded by 01_backup_state.sql,
-- and only AFTER every pod is back on the previous code version.
--
-- ⚠️ ห้ามรันขณะที่โค้ด 7e03e85 ยังทำงานอยู่ — จะทำให้ Insert Motor Lead พังทันที
-- ⚠️ Never run while 7e03e85 is serving traffic — motor lead inserts would fail at once.
-- =============================================================================

BEGIN;
SELECT pg_advisory_xact_lock(hashtext('job04_init_seq_lead_no'));

-- กรณี A: backup บอกว่าเดิม column_default เป็น NULL
-- Case A: the backup shows column_default was NULL
ALTER TABLE insurverse."Lead_coverage_premium" ALTER COLUMN "Lead_No" DROP DEFAULT;

-- กรณี B: backup บอกว่าเดิมมี DEFAULT อื่น — ลบกรณี A ข้างบน แล้วใส่ค่าเดิมจากไฟล์ backup แทน
-- Case B: the backup shows a different default — remove Case A and restore it verbatim:
-- ALTER TABLE insurverse."Lead_coverage_premium" ALTER COLUMN "Lead_No" SET DEFAULT <value from backup>;

-- ไม่ DROP SEQUENCE: เก็บไว้เพื่อไม่ให้เลขที่แจกไปแล้วถูกนำกลับมาใช้ซ้ำหากเดินหน้าอีกครั้ง
-- The sequence is kept on purpose so a later roll-forward never reissues numbers.
COMMIT;
