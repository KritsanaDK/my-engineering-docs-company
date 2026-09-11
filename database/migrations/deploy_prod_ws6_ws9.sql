-- ============================================================================
-- PRODUCTION DEPLOYMENT SCRIPT: WORKSTREAMS WS6 - WS9
-- Target Environment: PRODUCTION (PostgreSQL)
-- Database: insurverse
-- Generated: 2026-09-08
-- ============================================================================

\set ON_ERROR_STOP on
SET search_path TO insurverse, public;

BEGIN;

-- ============================================================================
-- 1. DDL: TABLE EXTENSIONS & COLUMNS (Safe & Idempotent)
-- ============================================================================

-- [WS6] Add no_cancel_flag for cancellation endorsements
ALTER TABLE insurverse."Policy_Header" 
ADD COLUMN IF NOT EXISTS no_cancel_flag VARCHAR(1) DEFAULT 'N';

COMMENT ON COLUMN insurverse."Policy_Header".no_cancel_flag IS 'Flag indicating cancellation endorsement status (Y/N)';

-- [WS7] Add Owner_occupation for insured occupation locking
ALTER TABLE insurverse."Policy_Header" 
ADD COLUMN IF NOT EXISTS "Owner_occupation" VARCHAR(100) DEFAULT '';

-- [WS8 & WS9] Performance Indexes for Filter & Join
CREATE INDEX IF NOT EXISTS idx_policy_header_enddate 
ON insurverse."Policy_Header"("Policy_Enddate");

CREATE INDEX IF NOT EXISTS idx_sf_claim_ref_notify_no 
ON insurverse.sf_claim(ref_notify_no);

-- ============================================================================
-- 2. STORED FUNCTIONS (WS6 & WS7)
-- ============================================================================

-- [WS6] Timezone Formatter: UTC -> Asia/Bangkok (+7 Hours)
CREATE OR REPLACE FUNCTION insurverse.fn_format_utc_timestamp_th(p_timestamp timestamp without time zone)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF p_timestamp IS NULL THEN
        RETURN '';
    END IF;
    -- Add 7 hours to UTC timestamp to match Thailand ICT time
    RETURN to_char(p_timestamp + INTERVAL '7 HOUR', 'YYYY-MM-DD"T"HH24:MI:SS.MS');
END;
$function$;

-- [WS7] Renewal Reference Handler: Locks Owner Occupation & Drivers
CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_ref(in_lead_no integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_JSON TEXT;
BEGIN
    WITH set_para AS (
        SELECT in_lead_no AS lead_no
    ),
    driver_info AS (
        SELECT
            "driver"."Policy_No",
            (d).*
        FROM insurverse."Policy_Header" AS "driver"
        INNER JOIN insurverse."Lead_coverage_premium" AS "lead"
            ON "lead"."ref_policy_no" = "driver"."Policy_No"
        CROSS JOIN LATERAL (
            VALUES
                (1, "driver"."Par_citizen_id_1", "driver"."Par_first_name_1", "driver"."Par_last_name_1", "driver"."Par_birth_date_1", "driver"."Par_prefix_name_1", "driver"."Par_occupation_1", "driver"."par_occupation_code_1", "driver"."Par_Driver_license_no_1", "driver"."par_driver_license_category_1"),
                (2, "driver"."Par_citizen_id_2", "driver"."Par_first_name_2", "driver"."Par_last_name_2", "driver"."Par_birth_date_2", "driver"."Par_prefix_name_2", "driver"."Par_occupation_2", "driver"."par_occupation_code_2", "driver"."Par_Driver_license_no_2", "driver"."par_driver_license_category_2"),
                (3, "driver"."par_citizen_id_3", "driver"."par_first_name_3", "driver"."par_last_name_3", "driver"."par_birth_date_3", "driver"."par_prefix_name_3", "driver"."par_occupation_3", "driver"."par_occupation_code_3", "driver"."par_driver_license_no_3", "driver"."par_driver_license_category_3"),
                (4, "driver"."par_citizen_id_4", "driver"."par_first_name_4", "driver"."par_last_name_4", "driver"."par_birth_date_4", "driver"."par_prefix_name_4", "driver"."par_occupation_4", "driver"."par_occupation_code_4", "driver"."par_driver_license_no_4", "driver"."par_driver_license_category_4"),
                (5, "driver"."par_citizen_id_5", "driver"."par_first_name_5", "driver"."par_last_name_5", "driver"."par_birth_date_5", "driver"."par_prefix_name_5", "driver"."par_occupation_5", "driver"."par_occupation_code_5", "driver"."par_driver_license_no_5", "driver"."par_driver_license_category_5")
        ) AS d("order_idx", "citizen_id", "first_name", "last_name", "birth_date", "prefix_label", "occupation", "occupation_code", "license_number", "license_category")
        WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para)
    ),
    unpivoted_lead_drivers AS (
        SELECT
            "lead"."Lead_No",
            "lead"."ref_policy_no",
            "lead"."cal_basic_renewal",
            ld.*
        FROM insurverse."Lead_coverage_premium" AS "lead"
        CROSS JOIN LATERAL (
            VALUES
                (1, "lead"."par_citizen_id_1", "lead"."par_first_name_1", "lead"."par_driver_license_no_1", "lead"."par_driver_license_category_1", "lead"."driver_behavior_1", "lead"."driver_behavior_consent_1", "lead"."YOB_Driver_1"),
                (2, "lead"."par_citizen_id_2", "lead"."par_first_name_2", "lead"."par_driver_license_no_2", "lead"."par_driver_license_category_2", "lead"."driver_behavior_2", "lead"."driver_behavior_consent_2", "lead"."YOB_Driver_2"),
                (3, "lead"."par_citizen_id_3", "lead"."par_first_name_3", "lead"."par_driver_license_no_3", "lead"."par_driver_license_category_3", "lead"."driver_behavior_3", "lead"."driver_behavior_consent_3", "lead"."YOB_Driver_3"),
                (4, "lead"."par_citizen_id_4", "lead"."par_first_name_4", "lead"."par_driver_license_no_4", "lead"."par_driver_license_category_4", "lead"."driver_behavior_4", "lead"."driver_behavior_consent_4", "lead"."YOB_Driver_4"),
                (5, "lead"."par_citizen_id_5", "lead"."par_first_name_5", "lead"."par_driver_license_no_5", "lead"."par_driver_license_category_5", "lead"."driver_behavior_5", "lead"."driver_behavior_consent_5", "lead"."YOB_Driver_5")
        ) AS ld("order_idx", "citizen_id", "first_name", "license_number", "license_category", "driver_behavior", "driver_behavior_consent", "yob")
        WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para)
    ),
    driver_list AS (
        SELECT
            jsonb_agg(
                jsonb_build_object(
                    'citizen_id', ld."citizen_id",
                    'first_name', ld."first_name",
                    'last_name', di."last_name",
                    'birth_date', di."birth_date",
                    'prefix_label', di."prefix_label",
                    'occupation', di."occupation",
                    'occupation_code', di."occupation_code",
                    'license_number', ld."license_number",
                    'license_category', ld."license_category",
                    'driver_behavior', ld."driver_behavior",
                    'driver_behavior_consent', ld."driver_behavior_consent",
                    'yob', ld."yob"
                ) ORDER BY ld."order_idx"
            ) AS drivers
        FROM unpivoted_lead_drivers ld
        LEFT JOIN driver_info di
            ON ld."order_idx" = di."order_idx"
        WHERE ld."citizen_id" IS NOT NULL
          AND ld."citizen_id" <> ''
    )
    SELECT
        jsonb_build_object(
            'lead_no', (SELECT lead_no FROM set_para),
            'ref_policy_no', "lead"."ref_policy_no",
            'cal_basic_renewal', "lead"."cal_basic_renewal",
            'owner_occupation', "policy"."Owner_occupation",
            'drivers', COALESCE((SELECT drivers FROM driver_list), '[]'::jsonb)
        )::text
    INTO RTN_JSON
    FROM insurverse."Lead_coverage_premium" AS "lead"
    LEFT JOIN insurverse."Policy_Header" AS "policy"
        ON "lead"."ref_policy_no" = "policy"."Policy_No"
    WHERE "lead"."Lead_No" = (SELECT lead_no FROM set_para);

    RETURN RTN_JSON;
END;
$function$;

-- ============================================================================
-- 3. DYNAMIC SEQUENCE SYNCHRONIZATION (Strictly MAX(id) + 1, Never Hardcoded)
-- ============================================================================

DO $$
BEGIN
    -- Synchronize seq_car_act_lead_no if sequence object exists
    IF EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE n.nspname = 'insurverse' AND c.relkind = 'S' AND c.relname = 'seq_car_act_lead_no'
    ) THEN
        PERFORM setval(
            'insurverse.seq_car_act_lead_no', 
            COALESCE((SELECT MAX("Car_Act_Lead_No") FROM insurverse."Lead_Car_Act_Discount_Premium"), 90100) + 1, 
            false
        );
    END IF;

    -- Synchronize seq_lead_no if sequence object exists
    IF EXISTS (
        SELECT 1 FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE n.nspname = 'insurverse' AND c.relkind = 'S' AND c.relname = 'seq_lead_no'
    ) THEN
        PERFORM setval(
            'insurverse.seq_lead_no', 
            COALESCE((SELECT MAX("Lead_No") FROM insurverse."Lead_coverage_premium"), 90100) + 1, 
            false
        );
    END IF;
END $$;

COMMIT;

-- ============================================================================
-- 4. POST-DEPLOYMENT VERIFICATION CHECKS (Read-Only)
-- ============================================================================

-- 1. Check columns
SELECT 'Policy_Header.no_cancel_flag' AS item, count(*) AS status 
FROM information_schema.columns 
WHERE table_schema = 'insurverse' AND table_name = 'Policy_Header' AND column_name = 'no_cancel_flag';

SELECT 'Policy_Header.Owner_occupation' AS item, count(*) AS status 
FROM information_schema.columns 
WHERE table_schema = 'insurverse' AND table_name = 'Policy_Header' AND column_name = 'Owner_occupation';

-- 2. Check functions
SELECT 'fn_format_utc_timestamp_th' AS item, insurverse.fn_format_utc_timestamp_th(NOW()::timestamp) AS test_val;

-- 3. Check indexes
SELECT indexname, tablename 
FROM pg_indexes 
WHERE schemaname = 'insurverse' AND indexname IN ('idx_policy_header_enddate', 'idx_sf_claim_ref_notify_no');
