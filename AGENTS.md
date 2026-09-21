# AGENTS.md - Golden Rules for Agent Behavior

## 📌 Rule 1: Mandatory Implementation Plan First (ต้องทำแผนงานก่อนเสมอ)
- **Always Plan Before Execution**: Before modifying any code, executing git operations (merge, revert, push), or running deployment commands, the AI agent MUST create a detailed step-by-step Implementation Plan and wait for explicit user approval.
- **No Unapproved Actions**: Never execute modifying operations without user consent.

## 📌 Rule 2: Bilingual Communication (อธิบายสองภาษา Thai & English)
- **TH & EN Explanations**: Always provide all responses, explanations, summaries, and plan outlines in both Thai (🇹🇭) and English (🇬🇧).

## 📌 Rule 3: Mandatory DB Function Backup (ต้อง Backup Function ใน DB ก่อนแก้ไขเสมอ)
- **Always Backup Before Modifying DB Objects**: Before creating, replacing (`CREATE OR REPLACE`), or modifying any PostgreSQL/MySQL stored procedure, function, trigger, or view on any database environment (UAT, UAT-ISV, Production), the AI agent MUST extract the existing definition and save a timestamped backup SQL file (e.g., `backup_<function_name>_YYYYMMDD_HHMMSS.sql` or in dedicated backup folders) before applying any changes.

## 📌 Rule 4: Mandatory Test Citizen ID (กำหนดเลขบัตรประชาชนทดสอบ = 1111111111119 เสมอ)
- **Always Use Standard Test Citizen ID**: For all test policy issuances, automated API runners, and test payload generations across UAT and UAT-ISV environments, the AI agent MUST strictly use:
  - **Citizen ID:** `1111111111119`
  - **First & Last Name:** `กฤษณะ วัฒนายนนต์` (Mr. Kritsana Watthaniyanon)
  - **Email:** `kritsana.w.os@horixon-t8.com`
  - **Phone:** `0628696603`
  - **Standard Address:** `1 หมู่ 1`
  - **Location Master IDs:** `provinceId: 10`, `districtId: 124`, `subdistrictId: 979`, `zipcode: "18110"` (จ.สระบุรี อ.เมือง ต.ปากเพรียว)

## 📌 Rule 5: Mandatory Production Deployment Pack (ต้องเตรียมความพร้อมก่อน Deploy Prod เสมอ)
- **Always Prepare Complete Production Package**: Whenever the user plans to deploy to Production, the AI agent MUST strictly prepare a comprehensive, structured Production Deployment Pack containing:
  1. **Git Readiness**: Target branch, GitLab Merge Request (MR) links, source branch comparisons, commit summaries, and version tags.
  2. **Production-Safe DB Script**: Minimal, exact DDL/DML migration scripts, dynamic sequence initialization (`setval` derived dynamically from `MAX(id) + 1` — NEVER hardcoded), stored procedure definitions with transaction advisory locks, and pre-deployment backup steps.
  3. **Deployment Prerequisites & Config**: Any required environment variables (`.env`), Helm values, Kubernetes Ingress/DNS routing, secrets, and third-party whitelist requirements (e.g. Cloud NAT IP).
  4. **Rollback & Health Verification Plan**: Post-deploy verification commands, health check endpoints, and clear rollback procedures.

## 📌 Rule 6: Mandatory DB Schema & Field Verification (ต้องตรวจสอบ Field ใน Database ก่อนแก้ไขเสมอ)
- **Always Verify Column & Table Existence**: Before modifying code, writing SQL queries, updating stored procedures, or creating database migration scripts, the AI agent MUST strictly inspect and confirm that the referenced columns (fields), tables, and data types actually exist in the database schema (via `information_schema.columns`, `pg_attribute`, table DDL, or live schema checks).
- **No Column Hallucinations or Blind Assumptions**: Never assume or guess field names, table relationships, or column types without verifying against the actual database schema or schema definitions first.

## 📌 Rule 7: Mandatory Output Truncation & Token Optimization (ต้องตัดทอนและกรอง Log เสมอ)
- **Always Filter & Limit Command Output**: When executing terminal commands, running tests, checking logs, querying database rows, or viewing files, the AI agent MUST strictly filter, truncate, and limit the output using tools such as `head`, `tail`, `grep`, `LIMIT`, or slicing ranges.
- **Prevent Context Bloat & Conserve Tokens**: Never dump raw, voluminous outputs (hundreds or thousands of lines of verbose logs/tables) directly into the conversation context. Always extract and display only the relevant summaries, errors, and key data points.

## 📌 Rule 8: Mandatory 3-Repository Machine Migration Sync (สำรองข้อมูล 3 Repos สำหรับย้ายเครื่องเสมอ)
- **Always Maintain 3-Repo Sync**: When requested to backup, sync, or prepare for machine migration (`sync backup`, `backup ย้ายเครื่อง`, `backup 3 repo`), the AI agent MUST strictly:
  1. Sync deployment jobs: Mirror `/Users/kritsanawathaniyanon/Code/Go/deploy_jobs/` to `/Users/kritsanawathaniyanon/Code/docs/releases/deploy_jobs/`.
  2. Maintain and push all 3 core repositories to GitHub `origin main`:
     - **`my-antigravity-skills`** (`~/.gemini/config`)
     - **`my-engineering-docs`** (`~/Code/docs`)
     - **`my-keystores`** (`~/.keystores`)
  3. Verify all 3 repositories report `working tree clean` and provide updated commit summaries.

## 📌 Rule 9: Mandatory Dual-Inspection: Code + DB Stored Procedures (ต้องตรวจสอบ Code และ DB Stored Procedure ควบคู่กันเสมอ)
- **Always Verify Both Application Code & Database Stored Objects**: For every bug fix, enhancement, policy issuance workflow, payment processing, or concurrency handling, the AI agent MUST strictly cross-examine BOTH the application source code (Go/Node.js/Python) and the underlying Database Stored Procedures/Functions/Triggers (e.g. `fn_lead_to_car_act`, `fn_policy_invoiceno_iia`, `fn_policy_renewal`, etc.) in parallel to prevent desynchronization and reduce errors.
- **Prevent Desynchronization & Logic Blind Spots**:
  1. Never assume business logic, validation, or safeguards reside solely in application code or solely in database procedures.
  2. Always verify parameter signatures, data type mappings (e.g. nullable columns to pointer types `*string`), advisory locks, transaction isolation, and return contracts between the application caller and the DB callee before implementing changes.
  3. Ensure that any modification to application code preserves constraints expected by DB functions, and any modification to DB functions maintains full compatibility with all calling services.

