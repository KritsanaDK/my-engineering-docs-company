-- =============================================================================
-- 📌 JOB 04 — STEP 4: POST-DEPLOY RESYNC + VERIFY — Issue #13
-- =============================================================================
-- รันหลัง Rolling Deploy ของ nodejs-express-premium-service เสร็จครบทุก Pod
-- Run after the premium-service rolling deploy has fully completed.
--
-- ส่วนที่ 1 (เขียน): เลื่อน sequence ข้ามเลขที่ Pod โค้ดเก่าอาจออกด้วย MAX+1 ระหว่าง Rolling Deploy
-- Part 1 (write): move the sequence past any MAX+1 values old pods issued during the rollout.
-- ส่วนที่ 2 (อ่านอย่างเดียว): ตรวจผล / Part 2 (read-only): verification.
-- =============================================================================

-- ---------- Part 1: resync (idempotent, same logic as step 2) ----------
BEGIN;
SELECT pg_advisory_xact_lock(hashtext('job04_init_seq_lead_no'));
LOCK TABLE insurverse."Lead_coverage_premium" IN SHARE ROW EXCLUSIVE MODE;
SELECT setval(
    'insurverse.seq_lead_no',
    GREATEST(
        COALESCE((SELECT MAX("Lead_No") FROM insurverse."Lead_coverage_premium"), 0) + 1,
        (SELECT CASE WHEN is_called THEN last_value + 1 ELSE last_value END
           FROM insurverse.seq_lead_no)
    ),
    false
) AS next_lead_no;
COMMIT;

-- ---------- Part 2: verify (read-only) ----------
-- ต้องได้ ok = true / expect ok = true
SELECT (SELECT CASE WHEN is_called THEN last_value + 1 ELSE last_value END FROM insurverse.seq_lead_no)
         > (SELECT COALESCE(MAX("Lead_No"), 0) FROM insurverse."Lead_coverage_premium") AS ok,
       (SELECT last_value FROM insurverse.seq_lead_no)                              AS seq_last_value,
       (SELECT MAX("Lead_No") FROM insurverse."Lead_coverage_premium")             AS max_lead_no;

-- Lead ที่สร้างหลัง Deploy ต้องเรียงต่อเนื่องจาก sequence (ช่องว่างเล็กน้อยเป็นเรื่องปกติของ sequence)
-- Leads created after the deploy (small gaps are normal for sequences).
SELECT "Lead_No"
  FROM insurverse."Lead_coverage_premium"
 ORDER BY "Lead_No" DESC
 LIMIT 10;
