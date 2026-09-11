-- ==================================================================
-- Master Database Initialization Script for uat-isv Environment
-- Option 3A: Clean Schema & Initial Migrations (PostgreSQL 17)
-- ==================================================================

-- 1. Enable Required PostgreSQL Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. Master Policy & Sequence Functions (Advisory Locks for Race Conditions)
CREATE OR REPLACE FUNCTION fn_policy_advisory_lock(lock_key text)
RETURNS boolean AS $$
BEGIN
    PERFORM pg_advisory_xact_lock(hashtext(lock_key));
    RETURN true;
END;
$$ LANGUAGE plpgsql;

-- 3. Core Policy Header Table Baseline
CREATE TABLE IF NOT EXISTS policy_header (
    policy_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    policy_no VARCHAR(100) UNIQUE,
    quotation_no VARCHAR(100),
    invoice_no VARCHAR(100),
    insured_name VARCHAR(255),
    insured_email VARCHAR(255),
    insured_phone VARCHAR(50),
    zipcode VARCHAR(20),
    owner_zipcode VARCHAR(20),
    deli_zipcode VARCHAR(20),
    payment_channel VARCHAR(50) DEFAULT 'WEB',
    status VARCHAR(50) DEFAULT 'DRAFT',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for fast lookup
CREATE INDEX IF NOT EXISTS idx_policy_header_status ON policy_header(status);
CREATE INDEX IF NOT EXISTS idx_policy_header_policy_no ON policy_header(policy_no);

-- 4. Initial Audit Log
CREATE TABLE IF NOT EXISTS system_init_log (
    id SERIAL PRIMARY KEY,
    environment VARCHAR(50) DEFAULT 'uat-isv',
    postgres_version VARCHAR(50) DEFAULT 'PostgreSQL 17',
    initialized_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO system_init_log (environment, postgres_version) 
VALUES ('uat-isv', 'PostgreSQL 17');
