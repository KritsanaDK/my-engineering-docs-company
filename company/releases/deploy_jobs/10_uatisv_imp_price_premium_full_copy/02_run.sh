#!/bin/bash
# Run 02_apply_uatisv.sql against UAT-ISV with the CSV path substituted (psql does not expand :vars inside \copy).
set -euo pipefail
CSV=${1:?csv from 01}; D=$(cd "$(dirname "$0")" && pwd)
[ -f "$CSV" ] || { echo "no csv"; exit 1; }
source ~/Code/docs/company/infrastructure/env/uat_isv.env
TMP=$(mktemp); trap 'rm -f "$TMP"' EXIT
sed "s#__CSV__#${CSV}#" "$D/02_apply_uatisv.sql" > "$TMP"
PGPASSWORD="$DB_PASSWORD" /opt/homebrew/opt/libpq/bin/psql -h "$DB_PUBLIC_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -At -v ON_ERROR_STOP=1 -f "$TMP"
