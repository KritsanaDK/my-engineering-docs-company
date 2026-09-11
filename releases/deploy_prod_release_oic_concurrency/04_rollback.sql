-- ============================================================================
-- STEP 4: EMERGENCY ROLLBACK SCRIPT: OIC & CONCURRENCY
-- Target Environment: PRODUCTION (PostgreSQL)
-- Database: insurverse
-- Run only in case of emergency rollback
-- ============================================================================

\set ON_ERROR_STOP on
SET search_path TO insurverse, public;

-- NOTE:
-- All 4 functions were backed up prior to migration in Step 01.
-- To rollback to the exact previous definitions, execute the generated backup file:
--
-- Example:
--   psql -h <DB_HOST> -p <DB_PORT> -U <DB_USER> -d insurverse -f backups/backup_prod_oic_functions_<TIMESTAMP>.sql
--
-- Alternatively in interactive psql:
--   \i backups/backup_prod_oic_functions_<TIMESTAMP>.sql

BEGIN;

\echo '=================================================================='
\echo '⚠️ Reverting to previous function definitions...'
\echo '=================================================================='

-- If you have a specific timestamped backup, specify it below:
-- \i backups/backup_prod_oic_functions_latest.sql

COMMIT;

SELECT 'Rollback script template executed. Verify function definitions with 03_verify_post_deploy.sql' AS status;
