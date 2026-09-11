-- ============================================================================
-- STEP 4: EMERGENCY ROLLBACK SCRIPT (WS6 - WS9)
-- Target Environment: PRODUCTION (PostgreSQL)
-- Database: insurverse
-- Run only in case of emergency rollback
-- ============================================================================

\set ON_ERROR_STOP on
SET search_path TO insurverse, public;

BEGIN;

-- 1. Drop Added Indexes
DROP INDEX IF EXISTS insurverse.idx_policy_header_enddate;
DROP INDEX IF EXISTS insurverse.idx_sf_claim_ref_notify_no;

-- 2. Drop or Revert Functions (if restoring from backup)
-- To restore original definitions, run:
-- \i backups/backup_prod_functions_<TIMESTAMP>.sql

-- 3. Columns (Safe rollback: column remains harmless, but can drop default)
ALTER TABLE insurverse."Policy_Header" ALTER COLUMN no_cancel_flag DROP DEFAULT;

COMMIT;

SELECT 'Rollback completed. Please verify service health.' AS status;
