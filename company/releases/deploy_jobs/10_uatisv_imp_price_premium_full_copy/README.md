# 10 — UAT-ISV: replace Imp_Price_Premium with UAT's full copy (decision ก, 2026-09-25)

**Why:** UAT-ISV had 130,000 rows (31,926 active) vs UAT 363,862 (87,444 active) — a partial copy. Missing class/garage keys
(e.g. Toyota Yaris 2024 had only class 3) made partner MV/bundle leads fail with `8000 Data not found` and smoke MV 4.01–4.03
fail on `1_SC_0`. Keys present on both were identical row for row.
**Scope:** UAT-ISV only · data only · structure identical (80 cols, same order/types) · no PK/FK/trigger/dependent view.
**Lost by design:** UAT-ISV-only rows (116 renamed "Landcruiser Prado", 712 inactive) — kept in `_bk10_imp_price_premium`.
**Not included:** `sys_param duty_per` (0.004 vs 0.4) — pending decision.
**Run:** `bash 01_export_from_uat_readonly.sh <csv>` → `bash 02_run.sh <csv>` (expects 363,862 rows,
else rolls back) → wait ~60 s for premium-service cache. **Rollback:** `99_rollback_uatisv.sql`.
The CSV (~130 MB) is not stored in this folder.
