# Schema `public` — Tables

> Generated 2026-09-23 from **UAT-ISV** (`insurverse` DB), read-only catalog metadata. Row counts are `pg_class.reltuples` estimates (0 / -1 = never analyzed).

Back to [README](README.md) · [Functions & Triggers](functions_and_triggers.md)

**3 tables.** Tables flagged *(snapshot?)* look like dated/backup copies by name.

## Index

| # | Table | Cols | Est. rows | PK | Note |
|---|---|---|---|---|---|
| 1 | [policy_header](#policy_header) | 14 | 0 | policy_id |  |
| 2 | [system_init_log](#system_init_log) | 4 | 0 | id |  |
| 3 | [users](#users) | 8 | 0 | id |  |

---

## policy_header

`public.policy_header` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_id` | uuid | NO | `uuid_generate_v4()` |  |
| 2 | `policy_no` | character varying(100) | YES |  |  |
| 3 | `quotation_no` | character varying(100) | YES |  |  |
| 4 | `invoice_no` | character varying(100) | YES |  |  |
| 5 | `insured_name` | character varying(255) | YES |  |  |
| 6 | `insured_email` | character varying(255) | YES |  |  |
| 7 | `insured_phone` | character varying(50) | YES |  |  |
| 8 | `zipcode` | character varying(20) | YES |  |  |
| 9 | `owner_zipcode` | character varying(20) | YES |  |  |
| 10 | `deli_zipcode` | character varying(20) | YES |  |  |
| 11 | `payment_channel` | character varying(50) | YES | `'WEB'::character varying` |  |
| 12 | `status` | character varying(50) | YES | `'DRAFT'::character varying` |  |
| 13 | `created_at` | timestamp with time zone | YES | `CURRENT_TIMESTAMP` |  |
| 14 | `updated_at` | timestamp with time zone | YES | `CURRENT_TIMESTAMP` |  |

**Primary key:** `policy_id` (policy_header_pkey)

**Constraints:**

- UNIQUE `policy_header_policy_no_key`: `UNIQUE (policy_no)`

**Indexes:**

- `idx_policy_header_policy_no`: `CREATE INDEX idx_policy_header_policy_no ON public.policy_header USING btree (policy_no)`
- `idx_policy_header_status`: `CREATE INDEX idx_policy_header_status ON public.policy_header USING btree (status)`
- `policy_header_pkey`: `CREATE UNIQUE INDEX policy_header_pkey ON public.policy_header USING btree (policy_id)`
- `policy_header_policy_no_key`: `CREATE UNIQUE INDEX policy_header_policy_no_key ON public.policy_header USING btree (policy_no)`

---

## system_init_log

`public.system_init_log` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('system_init_log_id_seq'::regclass)` |  |
| 2 | `environment` | character varying(50) | YES | `'uat-isv'::character varying` |  |
| 3 | `postgres_version` | character varying(50) | YES | `'PostgreSQL 17'::character varying` |  |
| 4 | `initialized_at` | timestamp with time zone | YES | `CURRENT_TIMESTAMP` |  |

**Primary key:** `id` (system_init_log_pkey)

**Indexes:**

- `system_init_log_pkey`: `CREATE UNIQUE INDEX system_init_log_pkey ON public.system_init_log USING btree (id)`

---

## users

`public.users` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | character varying(50) | NO |  |  |
| 2 | `email` | character varying(255) | NO |  |  |
| 3 | `password_hash` | character varying(255) | NO |  |  |
| 4 | `name` | character varying(255) | NO |  |  |
| 5 | `role` | character varying(50) | NO | `'user'::character varying` |  |
| 6 | `partner_id` | character varying(50) | YES |  |  |
| 7 | `created_at` | timestamp with time zone | NO | `CURRENT_TIMESTAMP` |  |
| 8 | `updated_at` | timestamp with time zone | NO | `CURRENT_TIMESTAMP` |  |

**Primary key:** `id` (users_pkey)

**Constraints:**

- CHECK `users_role_check`: `CHECK (((role)::text = ANY ((ARRAY['super_admin'::character varying, 'admin'::character varying, 'manager'::character varying, 'user'::character varying, 'partner'::character varying, 'vendor'::character varying, 'service_account'::character varying, 'auditor'::character varying])::text[])))`
- UNIQUE `users_email_key`: `UNIQUE (email)`

**Indexes:**

- `idx_users_partner_id`: `CREATE INDEX idx_users_partner_id ON public.users USING btree (partner_id) WHERE (partner_id IS NOT NULL)`
- `idx_users_role`: `CREATE INDEX idx_users_role ON public.users USING btree (role)`
- `users_email_key`: `CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email)`
- `users_pkey`: `CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id)`
