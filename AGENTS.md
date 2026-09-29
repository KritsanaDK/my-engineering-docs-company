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

### 📌 Rule 5: Machine Sync by Profile — Company vs Personal (สำรอง/ย้ายเครื่องแยกตาม profile)
- **Two machine profiles** (`~/.gemini/sync_profile`): **company** machine = company work only; **personal** machine = personal work. Never put personal projects or `my-keystores` on the company machine.

  | Profile | Repos on the machine (→ local path) | Skills linked |
  |---|---|---|
  | `company` | `my-engineering-skills-company` (→ `~/.gemini/config`), `my-engineering-docs-company` (→ `~/Code/docs`) | `skills/company` |
  | `personal` | `my-engineering-skills` (→ `~/.gemini/config`), `my-engineering-docs` (→ `~/Code/docs`), `my-keystores` (→ `~/.keystores`) | `skills/personal` |

  Company and personal material live in **separate repos**; each machine clones only its own side, to the same local paths.

- **When asked to backup/sync/prepare a migration** (`sync backup`, `backup ย้ายเครื่อง`), the AI agent MUST:
  1. *(company)* Mirror `~/Code/Go/deploy_jobs/` → `~/Code/docs/company/releases/deploy_jobs/` and `~/worklogs/` → `~/Code/docs/company/worklogs/`; never commit DB dumps (`*.dump`) or `.env` files.
  2. Push the profile's repos to GitHub `origin main` and verify each reports `working tree clean`, with a commit summary.
  3. Run `~/.gemini/config/scripts/sync_ai_config.sh --profile <company|personal>`.
  4. Remind that git-ignored data is NOT in any repo and must be carried manually: Claude memory (`~/.gemini/config/memory/`), `.env*` secrets, `uat_isv.env`, DB dumps.
- **New machine**: `~/.gemini/config/scripts/setup-multi-ai.sh --init-machine <company|personal>` (full guide: `NEW_MACHINE_MIGRATION_GUIDE.md` in the personal docs repo).
- **Folder split**: company repos keep `skills/company/` and `~/Code/docs/company/`; personal repos keep `skills/personal/` and `~/Code/docs/personal/` — put new material in the matching repo and folder (no shared group: each skill belongs to one side).
- **Skills Live Only Here**: Custom skills exist ONLY in the profile's skills repo (`my-engineering-skills-company` or `my-engineering-skills`) and its local clone `~/.gemini/config/skills/`. AI tool folders (`~/.claude/skills`, `~/.codex/skills`, `~/.cursor/skills`, …) may contain only symlinks to that clone — never copies. Never place skills inside project folders or project repos.
- **Never Upload Skills or Rules to External Services**: The AI agent MUST NEVER upload, import, or suggest uploading custom skills, AGENTS.md, or memory to any external cloud skill marketplaces.

### 📌 Rule 6: Safe Git Operations & Explicit Branching (แตก Branch จาก origin/main และใช้ --no-track เสมอ)
- **Branch from `origin/main` Only**: Every new branch MUST be created from `origin/main` with explicit `--no-track` (e.g. `git checkout --no-track -b <branch_name> origin/main`). The AI agent MUST NEVER allow Git to automatically attach upstream tracking to `main`.
- **Verify Clean Local Branch**: After creating a branch, always verify with `git branch -vv` that the newly created branch has NO upstream tracking bracket pointing to `main`.

### 📌 Rule 7: Multi-LLM Universal Handover Protocol (มาตรฐานการส่งต่องานระหว่าง AI)
- When switching between Gemini, Claude, Cursor, and Codex:
  1. Ensure latest changes are committed locally or summarized in `implementation_plan.md`.
  2. Do not copy raw chat transcripts; use standard structured handovers.
  3. Point the destination model to `AGENTS.md` (or symlinked `CLAUDE.md`) and the relevant operational skill.
- Full protocol (role split, prompt templates): skill `multi-llm-collaboration` — personal machine only; on the company machine the three steps above are the whole rule.

---

## 🏢 PART B: Enterprise InsurTech Rules (ใช้เฉพาะงานบริษัท Horixon-T8 / InsurVerse)
> **Full Spec:** Read [`rules/insurtech_rules.md`](rules/insurtech_rules.md) for complete details.
> **Scope:** Applicable under `~/Code/Go/*`, `~/Code/NextJs/*`, and `~/Code/docs/company/*`.
> **Identity:** `kritsana.w.os@horixon-t8.com`

- **Rule I-1: Mandatory DB Stored Object Backup**: Before modifying DB functions (`CREATE OR REPLACE`), extract existing definitions into a timestamped backup SQL file.
- **Rule I-2: Mandatory Test Citizen ID**: Strictly use `1111111111119` (Mr. Kritsana Watthaniyanon, Saraburi address) for all test insurance issuances.
- **Rule I-3: Mandatory Production Deployment Pack**: Prepare Git readiness, dynamic sequence `setval`, minimal safe DDL/DML, and rollback plans before prod deploys.
- **Rule I-4: Mandatory Dual-Inspection**: Cross-examine Go/Node application code and PostgreSQL stored procedures (`fn_lead_to_car_act`, etc.) in parallel.
- **Rule I-5: Push Feature Branches Only**: May push to `fix/fx-01-...` with explicit refspec; NEVER push directly to `main` and NEVER enable auto-merge. Merging into `main` is done only by a human.
- **Rule I-6: Mandatory Spec Sync**: Always update API specs in `~/Code/docs/company/architecture/api_specs/` whenever endpoints, handlers, DTOs, or DB tables change.
- **Rule I-7: Environment Scope & Safety**: Act ONLY on **UAT-ISV** (`136.85.102.224`). NEVER touch UAT or Production. E2E payments via real 2C2P sandbox links. Never trigger CI for `nextjs-backoffice-webapp`.

