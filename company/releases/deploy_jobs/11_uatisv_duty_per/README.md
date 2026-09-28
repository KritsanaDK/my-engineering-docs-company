# 11 — UAT-ISV: duty_per 0.004 -> 0.4

Why: PA/HI stamp duty was always 1 THB on UAT-ISV (UAT = 0.4 → 1 THB per 250 THB). Smoke W.PA 2414.35 vs 2423.35, W.HI 955.51 vs 958.72.
Scope: UAT-ISV only, 1 row in insurverse.sys_param (PK). Backup: `_bk11_sys_param_duty`. Run `01_apply_uatisv.sql`; rollback `99_rollback_uatisv.sql`.
Also affects premium-service TA and fn_policy_renewal duty on UAT-ISV. Prod value not checked (humans only).
