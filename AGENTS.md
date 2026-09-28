# AGENTS.md - Golden Rules for Agent Behavior

This document defines the engineering standards, operational constraints, and behavioral protocols for AI agents across all workspaces and platforms (Antigravity IDE, Claude Code CLI, Claude Desktop, Cursor, OpenAI Codex).

---

## 🌐 PART A: Universal Core Rules (ใช้ได้กับทุกโปรเจกต์ ทั้งงานบริษัทและงานส่วนตัว)

### 📌 Rule 1: Mandatory Implementation Plan First (ต้องทำแผนงานก่อนเสมอ)
- **Always Plan Before Execution**: Before modifying any code, executing git operations (merge, revert, push), or running deployment commands, the AI agent MUST create a detailed step-by-step Implementation Plan and wait for explicit user approval.
- **No Unapproved Actions**: Never execute modifying operations without user consent.

### 📌 Rule 2: Bilingual Communication (อธิบายสองภาษา Thai & English)
- **TH & EN Explanations**: Always provide all responses, explanations, summaries, and plan outlines in both Thai (🇹🇭) and English (🇬🇧).

### 📌 Rule 3: Mandatory DB Schema & Field Verification (ต้องตรวจสอบ Field ใน Database ก่อนแก้ไขเสมอ)
- **Always Verify Column & Table Existence**: Before modifying code, writing SQL queries, updating stored procedures, or creating database migration scripts, the AI agent MUST strictly inspect and confirm that the referenced columns (fields), tables, and data types actually exist in the database schema (via `information_schema.columns`, `pg_attribute`, table DDL, or live schema checks).
- **No Column Hallucinations or Blind Assumptions**: Never assume or guess field names, table relationships, or column types without verifying against the actual database schema or schema definitions first.

### 📌 Rule 4: Mandatory Output Truncation & Token Optimization (ต้องตัดทอนและกรอง Log เสมอ)
- **Always Filter & Limit Command Output**: When executing terminal commands, running tests, checking logs, querying database rows, or viewing files, the AI agent MUST strictly filter, truncate, and limit the output using tools such as `head`, `tail`, `grep`, `LIMIT`, or slicing ranges.
- **Prevent Context Bloat & Conserve Tokens**: Never dump raw, voluminous outputs directly into the conversation context. Always extract and display only the relevant summaries, errors, and key data points.

### 📌 Rule 5: Mandatory 3-Repository Machine Migration Sync (สำรองข้อมูล 3 Repos สำหรับย้ายเครื่องเสมอ)
- **Always Maintain 3-Repo Sync**: When requested to backup, sync, or prepare for machine migration (`sync backup`, `backup ย้ายเครื่อง`, `backup 3 repo`), the AI agent MUST strictly:
  1. Sync deployment jobs: Mirror `/Users/kritsanawathaniyanon/Code/Go/deploy_jobs/` to `/Users/kritsanawathaniyanon/Code/docs/company/releases/deploy_jobs/`.
  2. Maintain and push all 3 core repositories to GitHub `origin main`:
     - **`my-antigravity-skills`** (`~/.gemini/config`)
     - **`my-engineering-docs`** (`~/Code/docs`)
     - **`my-keystores`** (`~/.keystores`)
  3. Verify all 3 repositories report `working tree clean` and provide updated commit summaries.
  4. Run `~/.gemini/config/scripts/sync_ai_config.sh` so every AI tool (Antigravity/Gemini, Claude Code, Codex, Cursor) points at the same AGENTS.md and the same skills.
- **Skills Live Only Here**: Custom skills exist ONLY in the `my-antigravity-skills` repo and its local clone `~/.gemini/config/skills/`. AI tool folders (`~/.claude/skills`, `~/.codex/skills`, `~/.cursor/skills`, …) may contain only symlinks to that clone — never copies. Never place skills inside project folders or project repos.
- **Never Upload Skills or Rules to External Services**: The AI agent MUST NEVER upload, import, or suggest uploading custom skills, AGENTS.md, or memory to any external cloud skill marketplaces.

### 📌 Rule 6: Safe Git Operations & Explicit Branching (แตก Branch จาก origin/main และใช้ --no-track เสมอ)
- **Branch from `origin/main` Only**: Every new branch MUST be created from `origin/main` with explicit `--no-track` (e.g. `git checkout --no-track -b <branch_name> origin/main`). The AI agent MUST NEVER allow Git to automatically attach upstream tracking to `main`.
- **Verify Clean Local Branch**: After creating a branch, always verify with `git branch -vv` that the newly created branch has NO upstream tracking bracket pointing to `main`.

### 📌 Rule 7: Multi-LLM Universal Handover Protocol (มาตรฐานการส่งต่องานระหว่าง AI)
- Follow the `multi-llm-collaboration` protocol when switching between Gemini, Claude, Cursor, and Codex:
  1. Ensure latest changes are committed locally or summarized in `implementation_plan.md`.
  2. Do not copy raw chat transcripts; use standard structured handovers.
  3. Point the destination model to `AGENTS.md` (or symlinked `CLAUDE.md`) and the relevant operational skill.

---

## 🏢 PART B: Enterprise InsurTech Rules (ใช้เฉพาะงานบริษัท Horixon-T8 / InsurVerse)
> **Full Spec:** Read [`rules/insurtech_rules.md`](rules/insurtech_rules.md) for complete details.
> **Scope:** Applicable under `~/Code/Go/*`, `~/Code/NextJs/*`, and `~/Code/docs/*`.
> **Identity:** `kritsana.w.os@horixon-t8.com`

- **Rule I-1: Mandatory DB Stored Object Backup**: Before modifying DB functions (`CREATE OR REPLACE`), extract existing definitions into a timestamped backup SQL file.
- **Rule I-2: Mandatory Test Citizen ID**: Strictly use `1111111111119` (Mr. Kritsana Watthaniyanon, Saraburi address) for all test insurance issuances.
- **Rule I-3: Mandatory Production Deployment Pack**: Prepare Git readiness, dynamic sequence `setval`, minimal safe DDL/DML, and rollback plans before prod deploys.
- **Rule I-4: Mandatory Dual-Inspection**: Cross-examine Go/Node application code and PostgreSQL stored procedures (`fn_lead_to_car_act`, etc.) in parallel.
- **Rule I-5: Push Feature Branches Only**: May push to `fix/fx-01-...` with explicit refspec; NEVER push directly to `main` and NEVER enable auto-merge. Merging into `main` is done only by a human.
- **Rule I-6: Mandatory Spec Sync**: Always update API specs in `~/Code/docs/company/architecture/api_specs/` whenever endpoints, handlers, DTOs, or DB tables change.
- **Rule I-7: Environment Scope & Safety**: Act ONLY on **UAT-ISV** (`136.85.102.224`). NEVER touch UAT or Production. E2E payments via real 2C2P sandbox links. Never trigger CI for `nextjs-backoffice-webapp`.

---

## 💻 PART C: Personal & Independent SaaS Rules (งานส่วนตัว)

### 📋 ImmiSync SaaS (`~/Documents/Code/immisync`)
> **Full Spec:** Read [`rules/immisync_rules.md`](rules/immisync_rules.md) and skill `immisync-operations`.
> **Identity:** KritsanaDK (`kritsana.dk@gmail.com`)
- Enforce mandatory Primary Tenant Owner with randomized passwords and clipboard copy.
- Enforce standardized 8-field Thai address with office address inheritance toggle.
- Maintain foreign labor compliance document integrity (Passport, Visa, Work Permit, Pink Card, TM30, TM47) with ID reuse on upsert.
- White-label LINE Official Account Messaging API integration per tenant.
- Direct push to personal GitHub (`KritsanaDK/*`) `main` is permitted when requested by the owner.

### 📱 Mobile & Flutter (`~/Documents/flutter/*`)
> **Full Spec:** Read [`rules/mobile_flutter_rules.md`](rules/mobile_flutter_rules.md) and skill `wvocs-flutter-operations`.
> **Identity:** KritsanaDK (`kritsana.dk@gmail.com`)
- Strict OpenJDK 17 LTS toolchain for Flutter/Gradle builds.
- Automated versioning and build management with `./build.sh`.
- Clean architecture: decouple UI overlays from Providers.
