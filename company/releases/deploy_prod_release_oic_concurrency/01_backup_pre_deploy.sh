#!/usr/bin/env bash
# ============================================================================
# STEP 1: PRE-DEPLOYMENT BACKUP SCRIPT
# Target Environment: PRODUCTION
# Description: Extracts current definitions of 4 core functions before applying
#              the OIC & Concurrency migration.
# Functions:
#   - insurverse.fn_lead_to_car_act
#   - insurverse.fn_policy_to_car_act
#   - insurverse.fn_policy_invoiceno_iia
#   - insurverse.fn_policy_quatationno_iia
# ============================================================================

set -euo pipefail

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/backups"
mkdir -p "${BACKUP_DIR}"

BACKUP_FILE="${BACKUP_DIR}/backup_prod_oic_functions_${TIMESTAMP}.sql"

echo "=================================================================="
echo "📦 Starting Pre-Deployment DB Function Backup: PRODUCTION"
echo "   Target file: ${BACKUP_FILE}"
echo "=================================================================="

# Variables (Please export or pass before running)
PROD_DB_HOST="${DB_HOST:-localhost}"
PROD_DB_PORT="${DB_PORT:-5432}"
PROD_DB_USER="${DB_USER:-pgpool}"
PROD_DB_NAME="${DB_NAME:-insurverse}"

echo "Extracting existing function definitions from ${PROD_DB_NAME} on ${PROD_DB_HOST}:${PROD_DB_PORT}..."

# Backup using psql / pg_dump query
PGPASSWORD="${DB_PASSWORD:-}" psql -h "${PROD_DB_HOST}" -p "${PROD_DB_PORT}" -U "${PROD_DB_USER}" -d "${PROD_DB_NAME}" -At -c "
SELECT pg_get_functiondef(p.oid) || ';'
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'insurverse'
  AND p.proname IN (
    'fn_lead_to_car_act',
    'fn_policy_to_car_act',
    'fn_policy_invoiceno_iia',
    'fn_policy_quatationno_iia'
  );
" > "${BACKUP_FILE}"

if [ -s "${BACKUP_FILE}" ]; then
  echo "✅ Backup successfully saved to: ${BACKUP_FILE}"
  echo "   Size: $(wc -c < "${BACKUP_FILE}") bytes"
else
  echo "⚠️ Warning: Backup file is empty or database was not reachable with current credentials."
  echo "   Please verify DB connection details if running against remote database."
fi
echo "=================================================================="
