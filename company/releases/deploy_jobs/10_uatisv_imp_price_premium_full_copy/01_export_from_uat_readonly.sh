#!/bin/bash
# Read-only export of insurverse."Imp_Price_Premium" from UAT (connection forced read-only). Usage: 01_export_from_uat_readonly.sh <out.csv>
set -euo pipefail
OUT=${1:?out.csv}
export PGPASSWORD=$(grep -A1 'name: DATABASE_PASSWORD' ~/Code/Go/go-oauth2-server/helm/helm-uat.yaml | grep value | sed -E 's/.*value: *"?([^"]*)"?.*/\1/')
/opt/homebrew/opt/libpq/bin/psql "host=34.126.145.44 port=5432 user=pgpool dbname=insurverse sslmode=disable options=-cdefault_transaction_read_only=on" \
  -v ON_ERROR_STOP=1 -c "\copy (select * from insurverse.\"Imp_Price_Premium\") to '$OUT' with (format csv, header true)"
echo "rows: $(($(wc -l < "$OUT") - 1))"   # note: embedded newlines would inflate this; the apply step re-counts in SQL
