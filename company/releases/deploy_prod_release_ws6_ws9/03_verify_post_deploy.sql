-- ============================================================================
-- STEP 3: POST-DEPLOYMENT VERIFICATION SCRIPT (READ-ONLY)
-- Target Environment: PRODUCTION (PostgreSQL)
-- Database: insurverse
-- ============================================================================

\set ON_ERROR_STOP on
SET search_path TO insurverse, public;

SELECT '=== 1. Checking Columns ===' AS checkpoint;
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_schema = 'insurverse' 
  AND table_name = 'Policy_Header' 
  AND column_name IN ('no_cancel_flag', 'Owner_occupation');

SELECT '=== 2. Checking Functions ===' AS checkpoint;
SELECT p.proname, pg_get_function_identity_arguments(p.oid) AS arguments
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'insurverse' 
  AND p.proname IN ('fn_format_utc_timestamp_th', 'fn_policy_renewal_ref');

SELECT '=== 3. Testing Timezone Function ===' AS checkpoint;
SELECT insurverse.fn_format_utc_timestamp_th(NOW()::timestamp) AS current_ict_time;

SELECT '=== 4. Checking Indexes ===' AS checkpoint;
SELECT indexname, tablename 
FROM pg_indexes 
WHERE schemaname = 'insurverse' 
  AND indexname IN ('idx_policy_header_enddate', 'idx_sf_claim_ref_notify_no');

SELECT '=== 5. Checking Sequences ===' AS checkpoint;
SELECT c.relname AS sequence_name, last_value, is_called 
FROM pg_class c 
JOIN pg_namespace n ON n.oid = c.relnamespace 
CROSS JOIN LATERAL (SELECT last_value, is_called FROM insurverse.seq_car_act_lead_no) s1
WHERE n.nspname = 'insurverse' AND c.relkind = 'S' AND c.relname = 'seq_car_act_lead_no';
