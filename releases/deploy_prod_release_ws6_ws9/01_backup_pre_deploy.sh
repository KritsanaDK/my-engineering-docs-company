#!/usr/bin/env bash
# ============================================================================
# STEP 1: PRE-DEPLOYMENT BACKUP SCRIPT (MANDATORY RULE 3)
# Target Environment: PRODUCTION
# Description: Extracts current definitions of functions before modifying them.
# ============================================================================

set -euo pipefail

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./backups"
mkdir -p "${BACKUP_DIR}"

BACKUP_FILE="${BACKUP_DIR}/backup_prod_functions_${TIMESTAMP}.sql"

echo "=================================================================="
echo "📦 Starting Pre-Deployment DB Function Backup: PRODUCTION"
echo "   Target file: ${BACKUP_FILE}"
echo "=================================================================="

# Variables (Please export or pass before running)
PROD_DB_HOST="${DB_HOST:-localhost}"
PROD_DB_PORT="${DB_PORT:-5432}"
PROD_DB_USER="${DB_USER:-pgpool}"
PROD_DB_NAME="${DB_NAME:-insurverse}"

# Backup specific functions that will be replaced
pg_dump -h "${PROD_DB_HOST}" -p "${PROD_DB_PORT}" -U "${PROD_DB_USER}" -d "${PROD_DB_NAME}" \
  --schema=insurverse \
  --schema-only \
  -t 'insurverse.fn_format_utc_timestamp_th' \
  -t 'insurverse.fn_policy_renewal_ref' \
  > "${BACKUP_FILE}"

echo "✅ Backup successfully saved to: ${BACKUP_FILE}"
echo "   Size: $(wc -c < "${BACKUP_FILE}") bytes"
echo "=================================================================="
