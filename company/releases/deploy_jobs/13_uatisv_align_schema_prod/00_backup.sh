#!/bin/bash
# Rule 3: back up every object this job touches, UAT-ISV only. Output: backup/<object>_YYYYMMDD_HHMMSS.sql
set -euo pipefail
cd "$(dirname "$0")"
set -a; source ~/Code/docs/company/infrastructure/env/uat_isv.env; set +a
export PGPASSWORD="$DB_PASSWORD"
B=/opt/homebrew/opt/libpq/bin; TS=$(date +%Y%m%d_%H%M%S)
CONN=(-h "$DB_PUBLIC_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME")
"$B/pg_dump" "${CONN[@]}" --schema-only --no-owner --no-privileges -t 'insurverse.v_lead_policy_product' > "backup/backup_v_lead_policy_product_${TS}.sql"
"$B/pg_dump" "${CONN[@]}" --schema-only --no-owner --no-privileges \
  -t insurverse.iia_commission -t insurverse.tqm_car_mapping -t insurverse.tqm_group_premium -t insurverse.tqm_premium \
  -t insurverse.shopee_product_form -t 'insurverse."Policy_Car_Act_Discount_Premium"' > "backup/backup_tables_ddl_${TS}.sql"
ls -la backup/
