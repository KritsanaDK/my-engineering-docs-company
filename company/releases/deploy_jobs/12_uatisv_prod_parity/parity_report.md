# UAT-ISV vs Prod — Parity Report (Phase 1 + 2 partial)

**Date:** 2026-09-28 · **Method:** read-only (git fetch/show, SELECT on UAT-ISV, `curl`/`openssl` from laptop). No Prod access — Prod = `helm-prod.yaml` on `origin/main` + `isv-bible/.database/prod/` (dump 2026-09-24).
**Detail:** `detail/p1_code.md` · `detail/p1_config.md` · `detail/p1_db.md`

## Verdict

| Area | Same as Prod? | Summary |
|---|---|---|
| App code | ✅ | `uat-isv` re-cut from `main` on 2026-09-25 16:23–17:10 (backup `uat-isv-old`). **FX-02 fixes are no longer on UAT-ISV.** Extra code only on uat-isv: backoffice export endpoint, core `province.json`, ta DB-pool fix, nextjs Loading-loop fix |
| DB logic | ✅ except 1 view | All Prod functions/triggers match (incl. `fn_policy_to_car_act`, `fn_policy_quatationno_iia`, `fn_policy_renewal`, `fn_lead_to_car_act`). **`v_lead_policy_product` differs** |
| DB tables | ⚠️ | Missing id defaults on 4 tables, `shopee_product_form` NOT NULL/defaults, 1 index, timestamp precision on Policy_Header |
| Config (helm) | ❌ | 239 REVIEW / 77 MISSING keys; 2 third-party "danger" items; home-service helm file broken |
| Third-party reach (laptop) | ⚠️ | 7/10 reachable; eKYC UAT + FlyBKK dev no DNS; AMLO timeout |
| Third-party from pods / whitelist | ⏸ | Not run — `gcloud` token expired (needs interactive `gcloud auth login`) |

## Findings — must fix / decide (by risk)

| # | Level | Where | Finding | Suggested action |
|---|---|---|---|---|
| 1 | HIGH | amlo helm | UAT-ISV → `apiservice.amlo.go.th/v1/*` (14 URLs); **Prod → `/dev/v1/*`**. Looks inverted: Prod may be calling AMLO test, UAT-ISV the real one | Ask AMLO / owner which path is production; fix Prod values via MR (human) |
| 2 | HIGH | isv-test helm | Same value in both envs: Shopee live partner API + same partner/shop ID, Facebook CAPI same pixel + token, WordPress prod site `insurverse.co.th`. UAT-ISV tests hit **live** Shopee / FB pixel / WP | Do not run Shopee/FB/shortlink tests on UAT-ISV until sandbox values set |
| 3 | HIGH | home helm-uat-isv | `ENC_KEY`/`IV` appended under `readinessProbe` with wrong indent → YAML invalid; next `helm upgrade` fails and keys missing | Fix indentation on uat-isv |
| 4 | HIGH | notification helm-uat-isv | 16 env keys missing → code defaults: renewal rate 5 vs 2/s, retry 1s vs 30s, `RENEWAL_ALLOWED_PARTNERS`/`EXCLUDED_PROMO_CODES` empty, `RENEWAL_PWA_BASE_URL` empty (relative links), different SMS URL/code | Copy non-secret Prod values into helm-uat-isv |
| 5 | MED | DB view | `v_lead_policy_product`: Prod picks SUCCESS payment first, then newest (`id` tiebreak); UAT-ISV picks newest even if FAILED/PENDING | Deploy job: replace view with Prod body (backup first, Rule 3) |
| 6 | MED | DB tables | No id default on `iia_commission`, `tqm_car_mapping`, `tqm_group_premium`, `tqm_premium`; `shopee_product_form` 9 cols lack NOT NULL/default; missing `idx_pcadp_car_act_lead_no`; `Policy_Header(_Trans)` Effective dates `timestamp(0)` on Prod vs full precision | Deploy job (align DDL to Prod) |
| 7 | MED | isv-test helm | 10 keys missing (`CLIENT_ID/SECRET`, `OAUTH_URL`, `POLICY_SERVICE_URL`, `PWA_BASE_URL`, `RECAPTCHA_SECRET_KEY`, `WORDPRESS_SHORT_LINK_KEY` …) | Add to uat-isv |
| 8 | MED | resources | Chart reads `.Values.resources`; most Prod files put limits under `config.resources` (ignored) → Prod likely unlimited, UAT-ISV capped 500m/1Gi. doc-service Prod HPA 3–15 on own node pool vs UAT-ISV 2 fixed | Load tests on UAT-ISV won't reflect Prod; confirm with `kubectl get` on Prod (human) |
| 9 | MED | fiber-policy | `CUSTOMER_GROUP_ID` 8 vs 22, `PARTNER_COMPANY_CODE` B6028 vs B63345 | Check against master data |
| 10 | LOW | uam | CMI URL public `35.240.226.193` (others use `10.91.0.6`); OCR path `/mstekycapi/api/OCRService` vs `/api/OCRService` | Confirm |
| 11 | LOW | several | Internal vs public URL style swapped (notification/SF/uam URLs); Prod analytics/auth `Base_Url=sandbox-uat-api…` | Review |
| 12 | INFO | security | Same `ENC_KEY`/`IV`/`KEY_AES256`/`PAYMENT_SECRET_KEY`/`ISV_COOKIE_TOKEN` in UAT-ISV and Prod; Prod DB password stored in plain text in `helm-prod.yaml` in git | Security follow-up (rotate / move to Secret) |

## Third-party reachability (from laptop, 2026-09-28)

| Host (UAT-ISV) | Prod counterpart | DNS | HTTPS | Cert expires |
|---|---|---|---|---|
| test.salesforce.com | login.salesforce.com | ✅ | 200 | 2027-02-21 |
| demo.emcsthai.com (IIA) | eclaim5 | ✅ | 200 | 2027-01-01 |
| uat-sign.one.th (INET sign) | prod one.th | ✅ | 404 on `/` (normal) | 2027-04-02 |
| uatservice-etax.one.th | prod one.th | ✅ | 200 | 2027-04-02 |
| uat.ekycsolution.com | api.ekycsolution.com | ❌ **no DNS** | — | — |
| apiservice.amlo.go.th | same host | ✅ | ❌ timeout 10s (maybe IP whitelist) | — |
| partner.shopeemobile.com | same (**live**) | ✅ | 307 | **2026-10-29** |
| graph.facebook.com | same (**live**) | ✅ | 400 on `/` (normal) | 2026-10-04 |
| isv-api-dev.flybkk.com | same (dev in Prod too) | ❌ **no DNS** | — | — |
| storage.googleapis.com | same | ✅ | 400 on `/` (normal) | 2026-12-03 |

Not yet checked (not in helm URLs): 2C2P sandbox, OIC CMI (`10.91.0.6` internal), SMTP/SMS, TQM SFTP, WordPress.

## Next
1. User: `gcloud auth login` → run Phase 2 inside pods (egress IP `34.87.103.190` whitelist, 2C2P, CMI, SMTP/SMS, TQM SFTP).
2. Decide fixes #1–#7 (config on uat-isv branch; DB items as deploy job, backup first).
3. Phase 3 E2E after answers on payment method and which third parties may receive real sends.

## Step 3 — deploy + third-party from inside the cluster (2026-09-28 ~10:05)
Cluster `gke-uat-isv`, namespace `insurverse`. Test pod `curlimages/curl` (auto-deleted), connection checks only.

**Deploy vs uat-isv HEAD:** all services running their latest uat-isv commit except
- amlo: running image from 2026-08-20; missing `31e8e15` distroless debian12 (GlobalSign R46) that Prod has → needs redeploy
- home: pipeline for `d9e2bb5` (helm ENC_KEY/IV, broken indent) never deployed; pod already has ENC_KEY/IV
- core: `bc7379b` rolling out 10:04

**Egress IP = 34.87.144.141** (skill doc says INET whitelist IP is 34.87.103.190 → mismatch, verify with INET/partners)

| Target | Result |
|---|---|
| Salesforce test / IIA demo / one.th sign + etax / 2C2P sandbox (403 on `/`) / insurverse.co.th / Shopee | ✅ TLS OK |
| uat.ekycsolution.com | ❌ DNS not found |
| apiservice.amlo.go.th | ❌ timeout (likely IP whitelist) |
| SMS 110.49.202.49 (code default; Prod uses 110.49.174.171) | ❌ timeout |
| CMI 10.91.0.6 / 35.240.226.193 | ⚠️ 503 Microsoft-HTTPAPI on bare IP (normal without host binding); CMI worked in E2E 2026-09-25 |
| TQM SFTP 34.124.214.183:440 | ✅ TCP connect |
| mail.dhipaya.co.th:25 | ✅ TCP connect · 587/465 ❌ |

## Step 1 follow-up — code aligned to main (2026-09-28)
- backoffice `dcc01ec`, core `bc7379b` pushed to uat-isv, rolled out OK (app code = main)
- ta: kept FX-01 pool fix (user decision); amlo: image from 08-20, redeploy pending
- nextjs-webapp: Cloud Run was running `f397e7a2` (84 commits / 35 files off main). Aligned uat-isv `f244269b` (only .dockerignore, .gcloudignore, Dockerfile.nginx, config/env/uat-isv.js differ from main; 2c2p redirects removed), deployed via `deploy.sh` → revision `nextjs-webapp-00109-8pm`, buildId `rIhCJgt9HfI3mfxhTSrHn`, API = insurverse-uat-isv-api. uat-isv push runs no CI (`workflow: when: never`).
