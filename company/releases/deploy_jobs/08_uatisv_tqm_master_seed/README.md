# 08 — UAT-ISV: seed TQM master data (not applied)

**Why:** the FX-02 fiber-policy E2E (TQM batch `GET /policy/tqm/cmi`) cannot run on UAT-ISV:
- `tqm_allow_process` is empty → the batch lock never acquires → `process not acquired, skipping`
- `tqm_car_license_provice` is empty → every TQM lead's plate province is empty (UAT has 78 rows)

**Scope:** UAT-ISV only, data only (no DDL), copied from UAT. Pre-state: both tables had 0 rows (checked 2026-09-25), so rollback deletes everything.
**Run:** `psql <uat-isv> -f 01_seed_tqm_master_uatisv.sql` → expect `3 | 78`. Rollback: `99_rollback.sql`.
