-- =============================================================================
-- 📌 JOB 04 — STEP 2: PRODUCTION DB MIGRATION — Issue #13 Motor Lead MAX()+1 Race
-- =============================================================================
-- Database    : insurverse
-- Schema      : insurverse
-- Target code : nodejs-express-premium-service  7e03e85 (fix/fx-01-premium)
--
-- ⚠️ ต้องรันไฟล์นี้ "ก่อน" Deploy โค้ด 7e03e85
--    7e03e85 ไม่ใส่ค่า "Lead_No" ใน INSERT แล้ว ถ้าคอลัมน์ไม่มี DEFAULT จะ Insert พังทุกครั้ง
-- ⚠️ Run BEFORE deploying 7e03e85: it omits "Lead_No" from the INSERT, so the
--    column must already have a DEFAULT or every motor lead insert fails.
--
-- ปลอดภัยต่อโค้ดเดิมบน main: โค้ดเดิมใส่ "Lead_No" = MAX+1 เองทุกครั้ง จึงไม่ใช้ DEFAULT
-- Safe for the currently deployed code: it always supplies "Lead_No" itself.
--
-- รันซ้ำได้ (Idempotent): CREATE IF NOT EXISTS + setval ด้วย GREATEST ไม่ถอยเลขลง
-- Re-runnable: CREATE IF NOT EXISTS, and setval via GREATEST never moves the sequence back.
--
-- สอดคล้องกับ UAT-ISV (ตรวจ 2026-09-23): Lead_No DEFAULT nextval('insurverse.seq_lead_no'),
-- seq_lead_no เป็น bigint, increment 1, cache 1
-- =============================================================================

BEGIN;

-- จัดคิวกันรันสคริปต์นี้ซ้อนกัน / serialize concurrent runs of this script
SELECT pg_advisory_xact_lock(hashtext('job04_init_seq_lead_no'));

-- กันโค้ดเดิม (MAX+1) Insert แทรกระหว่างคำนวณ setval; อ่านได้ปกติ
-- Block concurrent MAX+1 inserts while the sequence is positioned; reads are not blocked.
LOCK TABLE insurverse."Lead_coverage_premium" IN SHARE ROW EXCLUSIVE MODE;

CREATE SEQUENCE IF NOT EXISTS insurverse.seq_lead_no AS bigint;

-- ตั้งค่าแบบ Dynamic จาก MAX(id) + 1 (Rule 5) และไม่ถอยต่ำกว่าเลขที่ sequence แจกไปแล้ว
-- Dynamic from MAX(id) + 1 (Rule 5), never below what the sequence already handed out.
SELECT setval(
    'insurverse.seq_lead_no',
    GREATEST(
        COALESCE((SELECT MAX("Lead_No") FROM insurverse."Lead_coverage_premium"), 0) + 1,
        (SELECT CASE WHEN is_called THEN last_value + 1 ELSE last_value END
           FROM insurverse.seq_lead_no)
    ),
    false
) AS next_lead_no;

ALTER TABLE insurverse."Lead_coverage_premium"
    ALTER COLUMN "Lead_No" SET DEFAULT nextval('insurverse.seq_lead_no');

COMMIT;

-- ตรวจผลทันที / immediate check
SELECT column_default FROM information_schema.columns
 WHERE table_schema = 'insurverse' AND table_name = 'Lead_coverage_premium' AND column_name = 'Lead_No';
