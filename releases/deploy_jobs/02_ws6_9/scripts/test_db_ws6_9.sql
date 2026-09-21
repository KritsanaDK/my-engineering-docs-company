-- ============================================================================
-- 🧪 WS6 - WS9 Database Verification & Test Script (PostgreSQL)
-- Target DB: UAT-ISV (136.85.102.224) / Production (34.126.145.44)
-- Standard Test Citizen ID: 1111111111119 (Rule 4 Compliance)
-- ============================================================================

\timing on

-- ----------------------------------------------------------------------------
-- 1. [WS6] Check `no_cancel_flag` column on `Policy_Header`
-- ----------------------------------------------------------------------------
SELECT 
    table_schema, 
    table_name, 
    column_name, 
    data_type, 
    column_default, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'Policy_Header' 
  AND column_name = 'no_cancel_flag';

-- ----------------------------------------------------------------------------
-- 2. [WS6] Test `fn_format_utc_timestamp_th` (+7 Hours Timezone Shift)
-- ----------------------------------------------------------------------------
SELECT 
    '2026-09-15 03:30:00+00'::timestamptz AS input_utc,
    insurverse.fn_format_utc_timestamp_th('2026-09-15 03:30:00+00'::timestamptz) AS output_thai_time,
    CASE 
        WHEN insurverse.fn_format_utc_timestamp_th('2026-09-15 03:30:00+00'::timestamptz) = '2026-09-15 10:30:00' 
        THEN '✅ PASS' 
        ELSE '❌ FAIL' 
    END AS test_result;

-- ----------------------------------------------------------------------------
-- 3. [WS7] Test `fn_policy_renewal` 90-Day Guardrail
-- ----------------------------------------------------------------------------
SELECT 
    p.proname AS function_name,
    CASE 
        WHEN pg_get_functiondef(p.oid) LIKE '%90%' 
         AND pg_get_functiondef(p.oid) LIKE '%ER007%' 
        THEN '✅ 90-DAY GUARDRAIL PRESENT'
        ELSE '⚠️ MISSING OR LEGACY'
    END AS renewal_status,
    length(pg_get_functiondef(p.oid)) AS function_length
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname = 'fn_policy_renewal' 
  AND n.nspname = 'insurverse';

-- ----------------------------------------------------------------------------
-- 4. [WS8] Test `insurverse.promo_code` Table Existence & COALESCE(create_by)
-- ----------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_promos,
    COUNT(CASE WHEN create_by IS NULL THEN 1 END) AS null_creator_count
FROM insurverse.promo_code;

-- Test safe query used in exportController.go
SELECT 
    promo_code, 
    COALESCE(create_by, 'SYSTEM') AS created_by,
    created_at
FROM insurverse.promo_code
LIMIT 5;

-- ----------------------------------------------------------------------------
-- 5. [WS9] Test Concurrency Advisory Locks & DB Pool
-- ----------------------------------------------------------------------------
SELECT 
    count(*) AS total_active_connections,
    state
FROM pg_stat_activity
WHERE datname = 'insurverse'
GROUP BY state;
