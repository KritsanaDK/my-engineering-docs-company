-- =============================================================================
-- STEP 3: POST-DEPLOYMENT VERIFICATION SCRIPT
-- Target Environment: PRODUCTION
-- Description: Verifies that all 4 core functions have been updated with
--              pg_advisory_xact_lock and concurrency protections.
-- =============================================================================

\echo '=================================================================='
\echo '🔍 Checking Stored Procedure Concurrency Hardening Status...'
\echo '=================================================================='

SELECT 
    p.proname AS function_name,
    pg_get_function_identity_arguments(p.oid) AS arguments,
    CASE 
        WHEN prosrc ILIKE '%pg_advisory_xact_lock%' AND prosrc ILIKE '%LOOP%' THEN '✅ CONCURRENCY SAFE (Advisory Lock + Loop)'
        WHEN prosrc ILIKE '%pg_advisory_xact_lock%' THEN '⚠️ PARTIAL (Advisory Lock Only)'
        ELSE '❌ VULNERABLE TO RACE CONDITION'
    END AS concurrency_status,
    p.provolatile AS volatility
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'insurverse'
  AND p.proname IN (
    'fn_lead_to_car_act',
    'fn_policy_to_car_act',
    'fn_policy_invoiceno_iia',
    'fn_policy_quatationno_iia'
  )
ORDER BY p.proname;

\echo '=================================================================='
\echo '🧪 Testing Sequence Generators (fn_policy_invoiceno_iia & fn_policy_quatationno_iia)...'
\echo '=================================================================='

DO $$
DECLARE
    v_inv TEXT;
    v_quot TEXT;
BEGIN
    SELECT insurverse.fn_policy_invoiceno_iia() INTO v_inv;
    SELECT insurverse.fn_policy_quatationno_iia() INTO v_quot;
    
    RAISE NOTICE 'Sample Generated Invoice No   : %', v_inv;
    RAISE NOTICE 'Sample Generated Quotation No : %', v_quot;
    
    IF v_inv IS NULL OR length(v_inv) < 10 THEN
        RAISE EXCEPTION '❌ Invoice number generation failed or format invalid!';
    END IF;
    
    IF v_quot IS NULL OR length(v_quot) < 10 THEN
        RAISE EXCEPTION '❌ Quotation number generation failed or format invalid!';
    END IF;
    
    RAISE NOTICE '✅ All sequence generator smoke tests PASSED successfully!';
END $$;

\echo '=================================================================='
\echo '🎉 Post-deployment verification complete.'
\echo '=================================================================='
