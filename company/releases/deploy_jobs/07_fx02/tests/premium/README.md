# premium FX-02 — FX-01 #13 Lead_No (no DB change, no lock)

**Fix (`fix/fx-02-premium` e208625):** `saveLeadCoveragePremium` inserts with `MAX("Lead_No")+1 … RETURNING "Lead_No"`
and retries up to 5× on 23505 (20–100 ms jitter). Before: second statement `SELECT MAX("Lead_No")` returned the
lead number — under load another customer's lead.

## Verified (2026-09-24)
- Sequelize with `QueryTypes.INSERT` + `RETURNING` → `query[0][0] = {"Lead_No": n}` (temp table on UAT-ISV, rolled back)
- duplicate key surfaces as `err.parent.code = err.original.code = "23505"` (same probe)
- `Lead_coverage_premium` has one unique constraint (PK `Lead_No`) on Prod → 23505 can only be a Lead_No collision

## To do before push (tomorrow)
1. `concurrent_save_lead.js`: `premiumAPI fn=loadPremium` → pick one rate row + checksum → fire 50 parallel
   `fn=saveLeadCoveragePremium`, each with a unique marker (Email `kritsana.w.os+fx02-<i>@horixon-t8.com`, Rule 4 identity).
   Pass: 50 × 200, no 23505 to the client, 50 distinct Lead_No, and for each response the decoded Lead_No row carries
   that request's own marker.
2. Same run while calling `fn_policy_renewal(<test policy>, false, true)` → retries visible in logs, no client error.
3. Cleanup SQL for the 50 test leads (by marker) — run only with approval.
4. Baseline: run step 1 against current uat-isv (main code) first → expect 23505 and/or wrong Lead_No returned.

## Results on UAT-ISV (2026-09-24 evening)
Script: `concurrent_save_lead.py N` (go-e-api `PUT /api/v1/lead/motor`, hbdisv, Nissan Almera 2024 class 1 G;
`*Ans` fields are option **seq**, not amounts — the go-e-api spec example `"siAns": 300000` is wrong).

| Run | Code | Result |
|---|---|---|
| baseline 50 concurrent | main (`7ea6ed0`, = Prod) | **20/50 OK, 30 × 503**; premium log 95 `duplicate key` (23505) |
| 3 concurrent × 20 rounds (during rollout) | mixed old/new pods | 17/20 — the 3 failures came from the old pod (44 `duplicate key value`, 0 retries) |
| **3 concurrent × 20 rounds** (real peak per user: ≤3) | fix (`6d9537b`) | **20/20 rounds, 60/60 OK, 0 mismatches**; 9 retries absorbed |
| **stress 50 concurrent** | fix | **50/50 OK, distinct 92676..92725, 0 mismatches**; retries: 25×attempt1, 15×attempt2, 5×attempt3, 2×attempt4 (none exhausted 5) |

Test leads left on UAT-ISV: ~131 rows, email `kritsana.w.os+fx02-%@horixon-t8.com` → `cleanup_leads.sql` (on approval).
