# purchase — fix/fx-02-purchase tests

Branch `fix/fx-02-purchase` (from `origin/main`, `--no-track`):

| Commit | What | From |
|---|---|---|
| `6d7586e` | Verify the 2C2P callback JWT signature (security) | cherry-pick 85c3261 |
| `1a03301` | Nil-safe `sf_account` / compulsory number in the SF payment upsert (no panic) | cherry-pick 059c275 |
| `6e1648d` | `LEFT JOIN sec_user` for the ACT SF payment upsert in the callback | 75d8a39, **partial** (FAILED status not included: business change) |
| `a3f9f63` | Buyer without `sec_user` → auto-register via uam `registeraccount_email_auto` before the SF Payer lookup | new (option B, approved 2026-09-25) |

## Unit tests
`go test -vet=off -timeout 120s ./...` → all packages ok. New: `controllers/buyer_account_test.go`
(existing user → no call · MV buyer from `Lead_coverage_premium` · ACT buyer from `Lead_Car_Act_Discount_Premium` ·
no name → no register · uam error → logged only · empty email → no DB · HTTP client path/500/no URL).

## UAT-ISV E2E (after push to uat-isv; payment simulated while the 2C2P sandbox is down)
```bash
cd deploy_jobs/07_fx02/tests/e2e
NOREG=1 bash create_invoice.sh act      # -> A…  (email kritsana.w.os+fx02-noreg-act…)
NOREG=1 bash create_invoice.sh mv       # -> P…  + encLead
bash sim_callback.sh <invoice>
bash policy_form.sh mv <encLead>        # MV only
bash verify_e2e.sh <invoice>
```
Expect for each NOREG case:
- `== buyer account`: a `sec_user` row created at callback time, `sf_account` **not NULL**
- purchase log `buyer account: auto-registered`; SF `UpsertPayment … status_code=0000`
- auto-register email ("account + password") arrives at the `+noreg-` address (Rule 4 inbox)

Regression (buyer already registered — `create_invoice.sh` without NOREG): no `auto-registered` log line; flow unchanged.
Signature: a callback with a wrong signature → 400 `invalid payment callback token`.

## Cleanup (UAT-ISV only, after the run — not applied automatically)
`cleanup_noreg_users.sql`

## Result — UAT-ISV 2026-09-25 (image :148, payment simulated)
| Case | Invoice | sec_user before → after | sf_account | Policy / CMI | SF payment |
|---|---|---|---|---|---|
| ACT, no account | A260925910016 | none → created 03:32:56 | 001Ov00002B6Ji9IAF | MC-0026-I-002593 / ✅ | 0000 ×2 |
| MV, no account | P260925150005 | none → created 03:33:06 | 001Ov00002B5xZfIAJ | MV-0026-I-000080 | 0000 ×2 |
| ACT, registered (regression) | A260925890017 | existing (unchanged) | 001Ov00002B6JqDIAV | MC-0026-I-002604 / ✅ | 0000 ×2 |
purchase log: `buyer account: auto-registered` for the two no-account cases only.
