# P1 - UAT-ISV vs Prod Helm config comparison

Sources: `origin/uat-isv:helm/helm-uat-isv.yaml` vs `origin/main:helm/helm-prod.yaml` (fetched 2026-09-28). Secret-like keys masked (only differs/same/missing shown).

**Skipped** - no helm on either branch: c-oic-realtime, configuration, go-db-query, go-echo-marketing-service, go-echo-oic, go-echo-pt-maxme, isv-bible, node-oic, ops-monitor, NextJs/nextjs-webapp. `go-fiber-queue-service`: helm-uat-isv.yaml exists but **no helm-prod.yaml on main** (not comparable). deploy_jobs: not a git repo.

## 0. Top findings

1. **DANGER - go-echo-amlo-service**: UAT-ISV `Amlo_1..Amlo_14` point to AMLO **production** paths `https://apiservice.amlo.go.th/v1/...`, while Prod points to `/dev/v1/...` (inverted). UAT-ISV sanction checks hit the real AMLO prod API; Prod may be hitting AMLO dev. `Amlo_X_API_KEY` differs.
2. **DANGER - isv-test (same value in both envs)**: `SHOPEE_URL_DOMAIN=https://partner.shopeemobile.com` (Shopee **live** partner API) with identical `SHOPEE_APP_PARTNER_ID`/`SHOPEE_APP_SHOP_ID` (partner key differs); `META_CAPI_URL=graph.facebook.com` with **same** `META_CAPI_PIXEL_ID` and same access token -> UAT-ISV test conversions are sent to the production Meta pixel; `WORDPRESS_API_URL=https://insurverse.co.th/` (prod website); `EMAIL_API_KEY/SECRET` same as prod; `SERVICE_API_URL=isv-api-dev.flybkk.com` (dev host in **Prod** too).
3. **go-echo-home-service helm-uat-isv.yaml is invalid YAML**: lines 119-122 (`- name: ENC_KEY`, `- name: IV`) are appended after `readinessProbe` with list indentation -> parse error at line 119 col 11. `helm upgrade -f` would fail; if hand-fixed, ENC_KEY/IV (used by code) are missing from env.
4. **Effective resources differ structurally**: the chart templates only `.Values.resources` (verified in purchase/home/isv-test/python-doc charts on main). Most Prod files put limits under `config.resources` (ignored) -> Prod pods run **without requests/limits**; UAT-ISV sets top-level `resources` (typically limit 500m CPU / 1Gi). UAT-ISV is CPU-capped where Prod is not -> load/latency tests are not representative.
5. **go-echo-notification-service**: 16 env keys missing in UAT-ISV (RENEWAL_*, SMS_*, EMAIL_RENEWAL_*, EMAIL_ENDORSE_PROBLEM_*). Code defaults then differ from Prod: RENEWAL_DISPATCH_RATE_PER_SEC 5 (prod 2), RENEWAL_DISPATCH_RETRY_BASE_MS 1000 (prod 30000), RENEWAL_ALLOWED_PARTNERS empty (prod `shopee,silkspan`), RENEWAL_EXCLUDED_PROMO_CODES empty (prod `KUMKA,KUMKA15`), RENEWAL_PWA_BASE_URL empty (no code default -> renewal links become relative/broken), SMS_URL default `110.49.202.49:10080` / SMS_CODE `35140601001` (prod `110.49.174.171:10080` / `45140601001`).
6. **Internal-vs-public URL pattern swapped** (backoffice, home, pa, ta, uam, amlo, internal): UAT-ISV `Backend_Notification` = internal `http://backend-notification-service:8080/...`, Prod = public `https://api.insurverse.co.th/api/v1/notification/`; `Backend_Saleforce` / `Backend_Uam` the opposite (UAT-ISV public, Prod internal). lead-policy `EMAIL_URL`: UAT-ISV internal `/api/v1/notification` vs Prod public `/api/v1/notification/email` (path suffix differs!). Auth/timeouts/ingress behaviour differ.
7. **Prod-side oddities**: analytics & auth Prod `Base_Url=https://sandbox-uat-api.insurverse.co.th/`; amlo Prod uses AMLO `/dev/`; isv-test Prod `SERVICE_API_URL` = flybkk **dev**.
8. **go-fiber-policy-service business constants**: `CUSTOMER_GROUP_ID` 8 vs 22, `PARTNER_COMPANY_CODE` B6028 vs B63345 (likely env data IDs - confirm DB master rows match).
9. **Scaling/probes**: python-fastapi-document-service Prod HPA 3-15 (CPU70/Mem75) + dedicated node pool (`nodeSelector.group=doc-service` + toleration) vs UAT-ISV fixed 2 replicas; java jasper 2 vs 4 replicas; consent 1 vs 3; isv-test Prod has startupProbe and tighter liveness/readiness (fail 3) vs UAT-ISV (initialDelay 60, fail 10); analytics & oauth2 UAT-ISV probes faster (delay 15/fail 5 vs 60/10).
10. go-echo-uam-service UAT-ISV CMI realtime uses public IP `35.240.226.193` while every other UAT-ISV service uses `10.91.0.6`; UAM OCR path `/mstekycapi/api/OCRService` vs Prod `/api/OCRService`.

## 1. Summary

| repo | #EXPECTED | #REVIEW | #MISSING |
|---|---|---|---|
| go-e-api | 11 | 6 | 1 |
| go-echo-amlo-service | 6 | 24 | 0 |
| go-echo-analytics-service | 8 | 13 | 0 |
| go-echo-auth-service | 5 | 4 | 0 |
| go-echo-backoffice-service | 22 | 11 | 1 |
| go-echo-consent-service | 11 | 5 | 0 |
| go-echo-core-service | 10 | 1 | 0 |
| go-echo-file-service | 7 | 9 | 0 |
| go-echo-home-service | 18 | 11 | 8 |
| go-echo-internal-service | 9 | 10 | 0 |
| go-echo-lead-policy-service | 16 | 3 | 0 |
| go-echo-notification-service | 11 | 9 | 21 |
| go-echo-pa-service | 20 | 11 | 6 |
| go-echo-purchase-service | 18 | 10 | 0 |
| go-echo-saleforce-service | 13 | 9 | 1 |
| go-echo-ta-service | 20 | 11 | 6 |
| go-echo-uam-service | 23 | 5 | 0 |
| go-fiber-policy-service | 21 | 10 | 0 |
| go-oauth2-server | 8 | 7 | 0 |
| isv-test | 10 | 6 | 19 |
| java-spring-boot-jasper-report-service | 2 | 5 | 1 |
| node_iia_service | 16 | 8 | 2 |
| nodejs-express-marketing-service | 12 | 10 | 0 |
| nodejs-express-premium-service | 11 | 10 | 0 |
| python-fastapi-document-service | 17 | 11 | 11 |
| **total** | 325 | 219 | 77 |

REVIEW counts include each individual resources.* key; they are consolidated in section 2b.

## 2a. REVIEW items (excluding resources)

| repo | key | uat-isv | prod | note |
|---|---|---|---|---|
| go-e-api | livenessProbe.httpGet.port | 8080 | 3000 |  |
| go-e-api | readinessProbe.httpGet.port | 8080 | 3000 |  |
| go-echo-amlo-service | Amlo_10 | https://apiservice.amlo.go.th/v1/version_check_iran | https://apiservice.amlo.go.th/dev/v1/version_check_iran | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_11 | https://apiservice.amlo.go.th/v1/hr-02 | https://apiservice.amlo.go.th/dev/v1/hr-02 | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_12 | https://apiservice.amlo.go.th/v1/version_check_hr-02 | https://apiservice.amlo.go.th/dev/v1/version_check_hr-02 | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_13 | https://apiservice.amlo.go.th/v1/hr-08 | https://apiservice.amlo.go.th/dev/v1/hr-08 | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_14 | https://apiservice.amlo.go.th/v1/version_check_hr-08 | https://apiservice.amlo.go.th/dev/v1/version_check_hr-08 | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_1 | https://apiservice.amlo.go.th/v1/freeze-05 | https://apiservice.amlo.go.th/dev/v1/freeze-05 | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_2 | https://apiservice.amlo.go.th/v1/version_check_freeze-05 | https://apiservice.amlo.go.th/dev/v1/version_check_freeze-05 | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_3 | https://apiservice.amlo.go.th/v1/al-qaida | https://apiservice.amlo.go.th/dev/v1/al-qaida | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_4 | https://apiservice.amlo.go.th/v1/version_check_al-qaida | https://apiservice.amlo.go.th/dev/v1/version_check_al-qaida | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_5 | https://apiservice.amlo.go.th/v1/taliban | https://apiservice.amlo.go.th/dev/v1/taliban | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_6 | https://apiservice.amlo.go.th/v1/version_check_taliban | https://apiservice.amlo.go.th/dev/v1/version_check_taliban | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_7 | https://apiservice.amlo.go.th/v1/dprk | https://apiservice.amlo.go.th/dev/v1/dprk | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_8 | https://apiservice.amlo.go.th/v1/version_check_dprk | https://apiservice.amlo.go.th/dev/v1/version_check_dprk | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_9 | https://apiservice.amlo.go.th/v1/iran | https://apiservice.amlo.go.th/dev/v1/iran | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Amlo_X_API_KEY | <secret differs> | <secret differs> | DANGER: UAT-ISV calls AMLO PRODUCTION /v1 paths; Prod calls /dev/v1 (inverted!) |
| go-echo-amlo-service | Backend_Notification | http://backend-notification-service:8080/api/v1/notification/ | https://api.insurverse.co.th/api/v1/notification/ | internal-vs-public URL pattern differs |
| go-echo-analytics-service | Base_Url | https://insurverse-uat-isv-api.insurverse.co.th/ | https://sandbox-uat-api.insurverse.co.th/ | Prod Base_Url points at sandbox-uat-api host (prod-side oddity) |
| go-echo-analytics-service | livenessProbe.failureThreshold | 5 | 10 |  |
| go-echo-analytics-service | livenessProbe.initialDelaySeconds | 15 | 60 |  |
| go-echo-analytics-service | readinessProbe.failureThreshold | 5 | 10 |  |
| go-echo-analytics-service | readinessProbe.initialDelaySeconds | 15 | 60 |  |
| go-echo-auth-service | Base_Url | https://insurverse-uat-isv-api.insurverse.co.th/ | https://sandbox-uat-api.insurverse.co.th/ | Prod Base_Url points at sandbox-uat-api host (prod-side oddity) |
| go-echo-auth-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-backoffice-service | Backend_Notification | http://backend-notification-service:8080/api/v1/notification/ | https://api.insurverse.co.th/api/v1/notification/ | internal-vs-public URL pattern differs |
| go-echo-backoffice-service | Backend_Saleforce | https://insurverse-uat-isv-api.insurverse.co.th/api/v1/sf/ | http://backend-saleforce-service:3001/api/v1/sf/ | internal-vs-public URL pattern differs |
| go-echo-backoffice-service | Url_Fontend | https://sandbox-uat-isv-insure.insurverse.co.th/ | https://insure.insurverse.co.th/ | UAT-ISV points at sandbox-uat-isv-insure host, other services use insurverse-uat-isv-app |
| go-echo-consent-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-consent-service | replicaCount | 1 | 3 |  |
| go-echo-core-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-file-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-home-service | Backend_Notification | http://backend-notification-service:8080/api/v1/notification/ | https://api.insurverse.co.th/api/v1/notification/ | internal-vs-public URL pattern differs |
| go-echo-home-service | Backend_Saleforce | https://insurverse-uat-isv-api.insurverse.co.th/api/v1/sf/ | http://backend-saleforce-service:3001/api/v1/sf/ | internal-vs-public URL pattern differs |
| go-echo-home-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-internal-service | Backend_Notification | http://backend-notification-service:8080/api/v1/notification/ | https://api.insurverse.co.th/api/v1/notification/ | internal-vs-public URL pattern differs |
| go-echo-internal-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-lead-policy-service | EMAIL_URL | http://backend-notification-service:8080/api/v1/notification/email | https://api.insurverse.co.th/api/v1/notification/email | internal-vs-public URL pattern differs |
| go-echo-notification-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-pa-service | Backend_Notification | http://backend-notification-service:8080/api/v1/notification/ | https://api.insurverse.co.th/api/v1/notification/ | internal-vs-public URL pattern differs |
| go-echo-pa-service | Backend_Saleforce | https://insurverse-uat-isv-api.insurverse.co.th/api/v1/sf/ | http://backend-saleforce-service:3001/api/v1/sf/ | internal-vs-public URL pattern differs |
| go-echo-pa-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-purchase-service | URL_FRONT_APP | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-purchase-service | URL_FRONT_TA | https://insurverse-uat-isv-app.insurverse.co.th/ | https://insure.insurverse.co.th | trailing-slash mismatch (URL concatenation risk) |
| go-echo-saleforce-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-ta-service | Backend_Notification | http://backend-notification-service:8080/api/v1/notification/ | https://api.insurverse.co.th/api/v1/notification/ | internal-vs-public URL pattern differs |
| go-echo-ta-service | Backend_Saleforce | https://insurverse-uat-isv-api.insurverse.co.th/api/v1/sf/ | http://backend-saleforce-service:3001/api/v1/sf/ | internal-vs-public URL pattern differs |
| go-echo-ta-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| go-echo-uam-service | Backend_Notification | http://backend-notification-service:8080/api/v1/notification/ | https://api.insurverse.co.th/api/v1/notification/ | internal-vs-public URL pattern differs |
| go-echo-uam-service | Backend_Saleforce | https://insurverse-uat-isv-api.insurverse.co.th/api/v1/sf/ | http://backend-saleforce-service:3001/api/v1/sf/ | internal-vs-public URL pattern differs |
| go-echo-uam-service | URL_CMI_Realtime_Policy | http://35.240.226.193/oicrt/cmi/PKISendPolicyREST | http://10.101.0.8/oicrt/cmi/PKISendPolicyREST | UAT-ISV uses public IP 35.240.226.193 while all other UAT-ISV services use 10.91.0.6 |
| go-echo-uam-service | URL_CMI_Realtime_Policy_Endorse | http://35.240.226.193/oicrt/cmi/PKISendEndorseREST | http://10.101.0.8/oicrt/cmi/PKISendEndorseREST | same as above |
| go-echo-uam-service | URL_YIP_OCRService | https://uat.ekycsolution.com/mstekycapi/api/OCRService | https://api.ekycsolution.com/api/OCRService | path differs structurally (/mstekycapi/api vs /api) |
| go-fiber-policy-service | CUSTOMER_GROUP_ID | 8 | 22 | business constant differs |
| go-fiber-policy-service | PARTNER_COMPANY_CODE | B6028 | B63345 | business constant (broker code) differs |
| go-oauth2-server | livenessProbe.failureThreshold | 5 | 10 |  |
| go-oauth2-server | livenessProbe.initialDelaySeconds | 15 | 60 |  |
| go-oauth2-server | readinessProbe.failureThreshold | 5 | 10 |  |
| go-oauth2-server | readinessProbe.initialDelaySeconds | 15 | 60 |  |
| isv-test | livenessProbe.failureThreshold | 10 | 3 |  |
| isv-test | livenessProbe.periodSeconds | 8 | 10 |  |
| isv-test | readinessProbe.failureThreshold | 10 | 3 |  |
| isv-test | readinessProbe.periodSeconds | 8 | 5 |  |
| java-spring-boot-jasper-report-service | replicaCount | 2 | 4 |  |
| nodejs-express-marketing-service | Backend_Uam | https://insurverse-uat-isv-api.insurverse.co.th/api/v1/uam/ | http://backend-uam-service:8080/api/v1/uam/ | internal-vs-public URL pattern differs |
| nodejs-express-marketing-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| nodejs-express-premium-service | Backend_Uam | https://insurverse-uat-isv-api.insurverse.co.th/api/v1/uam/ | http://backend-uam-service:8080/api/v1/uam/ | internal-vs-public URL pattern differs |
| nodejs-express-premium-service | Url_Fontend | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| python-fastapi-document-service | ETAX_PREFIX |  | None | empty string vs null |
| python-fastapi-document-service | FRONTEND_URL | https://insurverse-uat-isv-app.insurverse.co.th | https://insure.insurverse.co.th/ | trailing-slash mismatch (URL concatenation risk) |
| python-fastapi-document-service | volumes[digital-signature-condition-act].secret.items[0].key | condition-act.pdf | condition_act.pdf | secret item key name differs (hyphen vs underscore) |
| python-fastapi-document-service | volumes[digital-signature-condition-level-1].secret.items[0].key | condition-level-1.pdf | condition_level_1.pdf | secret item key name differs (hyphen vs underscore) |
| python-fastapi-document-service | volumes[digital-signature-condition-level-2p].secret.items[0].key | condition-level-2p.pdf | condition_level_2p.pdf | secret item key name differs (hyphen vs underscore) |
| python-fastapi-document-service | volumes[digital-signature-condition-level-3].secret.items[0].key | condition-level-3.pdf | condition_level_3.pdf | secret item key name differs (hyphen vs underscore) |
| python-fastapi-document-service | volumes[digital-signature-condition-level-3p].secret.items[0].key | condition-level-3p.pdf | condition_level_3p.pdf | secret item key name differs (hyphen vs underscore) |

## 2b. Effective resources / replicas (chart reads `.Values.resources` only; `config.resources` is ignored)

| repo | uat-isv replicas | uat-isv resources req/lim | prod replicas/HPA | prod effective resources | prod `config.resources` (ignored) |
|---|---|---|---|---|---|
| go-e-api | 2 | 100m/256Mi -> 500m/1024Mi | 3 | 50m/64Mi -> 100m/128Mi | none |
| go-echo-amlo-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-analytics-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 1000m/512Mi -> 2000m/1024Mi |
| go-echo-auth-service | 2 | none (only config.resources: 100m/256Mi -> 500m/1024Mi) | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-backoffice-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-consent-service | 1 | none (only config.resources: 100m/256Mi -> 500m/1024Mi) | 3 | none | 500m/512Mi -> 1000m/1024Mi |
| go-echo-core-service | 2 | none | 3 | none | none |
| go-echo-file-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 1000m/512Mi -> 2000m/1024Mi |
| go-echo-home-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-internal-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-lead-policy-service | 2 | none (only config.resources: 100m/256Mi -> 500m/1024Mi) | 2 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-notification-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-pa-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-purchase-service | 2 | 1000m/512Mi -> 2000m/1024Mi | 3 | none | 1000m/512Mi -> 2000m/1024Mi |
| go-echo-saleforce-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 500m/512Mi -> 1000m/1024Mi |
| go-echo-ta-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 100m/512Mi -> 200m/1024Mi |
| go-echo-uam-service | 2 | 100m/256Mi -> 300m/512Mi | 3 | 100m/256Mi -> 300m/512Mi | none |
| go-fiber-policy-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 500m/512Mi -> 1000m/1024Mi |
| go-oauth2-server | 2 | 50m/128Mi -> 200m/256Mi | 3 | 50m/64Mi -> 100m/128Mi | none |
| isv-test | 2 | 100m/256Mi -> 500m/1024Mi | 3 | 100m/128Mi -> 500m/512Mi | none |
| java-spring-boot-jasper-report-service | 2 | 500m/512Mi -> 2000m/2048Mi | 4 | 250m/768Mi -> 1000m/2548Mi | none |
| node_iia_service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 500m/512Mi -> 1000m/1024Mi |
| nodejs-express-marketing-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 500m/512Mi -> 1000m/1024Mi |
| nodejs-express-premium-service | 2 | 100m/256Mi -> 500m/1024Mi | 3 | none | 500m/512Mi -> 1000m/1024Mi |
| python-fastapi-document-service | 2 | 200m/512Mi -> 1000m/2048Mi | 3 HPA 3-15 | 100m/128Mi -> 500m/512Mi | none |

## 2c. MISSING items

| repo | key | uat-isv | prod | note |
|---|---|---|---|---|
| go-e-api | APP_PORT | 8080 | <ABSENT> |  |
| go-echo-backoffice-service | YIP_EKCY | <masked> | <ABSENT> | UAT-ISV only (value masked) |
| go-echo-home-service | ENC_KEY | <ABSENT> | <secret> | used by code; lost in UAT-ISV due to broken YAML tail |
| go-echo-home-service | IV | <ABSENT> | <secret> | used by code; lost in UAT-ISV due to broken YAML tail |
| go-echo-home-service | LEAD_EXPIRE_MINUTE | 1440 | <ABSENT> | not referenced in code |
| go-echo-home-service | YIP_EKCY | <masked> | <ABSENT> | UAT-ISV only (value masked) |
| go-echo-home-service | volumeMounts[google-cloud-key].mountPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-home-service | volumeMounts[google-cloud-key].readOnly | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-home-service | volumeMounts[google-cloud-key].subPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-home-service | volumes[google-cloud-key].secret.secretName | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-notification-service | EMAIL_ENDORSE_PROBLEM_RECEIVER | <ABSENT> | mathuroset@insurverse.co.th | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | EMAIL_ENDORSE_PROBLEM_RECEIVER_CC | <ABSENT> |  | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | EMAIL_RENEWAL_SUMMARY_CC | <ABSENT> | pojjanee.n@horixon-t8.com,panita.p@horixon-t8.com | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | EMAIL_RENEWAL_SUMMARY_RECEIVER | <ABSENT> | aunchernj@insurverse.co.th,wannapah@insurverse.co.th | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_ALLOWED_PARTNERS | <ABSENT> | shopee,silkspan | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_DB_WRITE_ATTEMPTS | <ABSENT> | 3 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_DB_WRITE_BACKOFF_MS | <ABSENT> | 500 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_DISPATCH_MAX_RETRY | <ABSENT> | 3 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_DISPATCH_RATE_PER_SEC | <ABSENT> | 2 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_DISPATCH_RETRY_BASE_MS | <ABSENT> | 30000 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_DISPATCH_WORKERS | <ABSENT> | 5 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_EXCLUDED_PROMO_CODES | <ABSENT> | KUMKA,KUMKA15 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_ISV_TEST_BASE_URL | <ABSENT> | http://backend-isv-test-service:8080 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | RENEWAL_PWA_BASE_URL | <ABSENT> | https://insure.insurverse.co.th | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | SMS_CHARGE | <ABSENT> | 66800602371 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | SMS_CODE | <ABSENT> | 45140601001 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | SMS_URL | <ABSENT> | http://110.49.174.171:10080 | code default applies in UAT-ISV (see top finding 5) |
| go-echo-notification-service | volumeMounts[google-cloud-key].mountPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-notification-service | volumeMounts[google-cloud-key].readOnly | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-notification-service | volumeMounts[google-cloud-key].subPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-notification-service | volumes[google-cloud-key].secret.secretName | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-pa-service | URL_CMI_Realtime_Policy_Endorse | <ABSENT> | http://10.101.0.8/oicrt/cmi/PKISendEndorseREST | not referenced in code |
| go-echo-pa-service | YIP_EKCY | <masked> | <ABSENT> | UAT-ISV only (value masked) |
| go-echo-pa-service | volumeMounts[google-cloud-key].mountPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-pa-service | volumeMounts[google-cloud-key].readOnly | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-pa-service | volumeMounts[google-cloud-key].subPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-pa-service | volumes[google-cloud-key].secret.secretName | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-saleforce-service | GCS_BUCKET | <ABSENT> | insurverse-storage | not referenced in code (saleforce) |
| go-echo-ta-service | URL_CMI_Realtime_Policy_Endorse | <ABSENT> | http://10.101.0.8/oicrt/cmi/PKISendEndorseREST | not referenced in code |
| go-echo-ta-service | YIP_EKCY | <masked> | <ABSENT> | UAT-ISV only (value masked) |
| go-echo-ta-service | volumeMounts[google-cloud-key].mountPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-ta-service | volumeMounts[google-cloud-key].readOnly | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-ta-service | volumeMounts[google-cloud-key].subPath | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| go-echo-ta-service | volumes[google-cloud-key].secret.secretName | <secret> | <ABSENT> | google-cloud-key SA mount only in UAT-ISV (Prod likely uses Workload Identity); home chart on main does not te |
| isv-test | affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matc | <ABSENT> | <masked> |  |
| isv-test | affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | <ABSENT> | kubernetes.io/hostname |  |
| isv-test | affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | <ABSENT> | 100 |  |
| isv-test | CLIENT_ID | <ABSENT> | <secret> | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | CLIENT_SECRET | <ABSENT> | <secret> | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | ClientIDBPMC | <ABSENT> | <secret> | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | ClientSecretBPMC | <ABSENT> | <secret> | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | OAUTH_URL | <ABSENT> | https://api.insurverse.co.th | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | POLICY_SERVICE_URL | <ABSENT> | https://thumb--p.insurverse.co.th/CheckPolicy/checkpol.asmx | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | PWA_BASE_URL | <ABSENT> | https://insure.insurverse.co.th/ | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | RECAPTCHA_SECRET_KEY | <ABSENT> | <secret> | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | SHOPEE_TEST_ORDER_PREFIX | <ABSENT> | ISVTEST | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | WORDPRESS_SHORT_LINK_KEY | <ABSENT> | <secret> | referenced by isv-test code - UAT-ISV runs with empty/default value |
| isv-test | livenessProbe.initialDelaySeconds | 60 | <ABSENT> |  |
| isv-test | readinessProbe.initialDelaySeconds | 60 | <ABSENT> |  |
| isv-test | startupProbe.failureThreshold | <ABSENT> | 20 |  |
| isv-test | startupProbe.httpGet.path | <ABSENT> | /healthcheck |  |
| isv-test | startupProbe.httpGet.port | <ABSENT> | 8080 |  |
| isv-test | startupProbe.periodSeconds | <ABSENT> | 5 |  |
| java-spring-boot-jasper-report-service | JAVA_TOOL_OPTIONS | -XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0 -XX:+UseG1GC | <ABSENT> | JVM heap tuning only in UAT-ISV |
| node_iia_service | EMAIL_SUPPORT | <ABSENT> | support@insurverse.co.th |  |
| node_iia_service | Url_Fontend | <ABSENT> | https://insure.insurverse.co.th/ |  |
| python-fastapi-document-service | autoscaling.enabled | <ABSENT> | True |  |
| python-fastapi-document-service | autoscaling.maxReplicas | <ABSENT> | 15 |  |
| python-fastapi-document-service | autoscaling.minReplicas | <ABSENT> | 3 |  |
| python-fastapi-document-service | autoscaling.targetCPUUtilizationPercentage | <ABSENT> | 70 |  |
| python-fastapi-document-service | autoscaling.targetMemoryUtilizationPercentage | <ABSENT> | 75 |  |
| python-fastapi-document-service | nodeSelector.environment | uat-isv | <ABSENT> |  |
| python-fastapi-document-service | nodeSelector.group | <ABSENT> | doc-service |  |
| python-fastapi-document-service | tolerations[0].effect | <ABSENT> | NoSchedule |  |
| python-fastapi-document-service | tolerations[0].key | <ABSENT> | doc-service |  |
| python-fastapi-document-service | tolerations[0].operator | <ABSENT> | Equal |  |
| python-fastapi-document-service | tolerations[0].value | <ABSENT> | true |  |

## 3. Third-party host mapping (uat-isv -> prod)

Internal insurverse hosts, DB and in-cluster services omitted. `<masked>` = key name is secret-like; classification given instead.

| uat-isv host | prod host | repos | keys | assessment |
|---|---|---|---|---|
| apiservice.amlo.go.th | apiservice.amlo.go.th | amlo | Amlo_1, Amlo_10, Amlo_11, Amlo_12 (+10) | **SAME host in both -> UAT-ISV hits PROD/shared endpoint** |
| <masked> | <masked> | backoffice, lead-policy, purchase, uam | KEYCLOAK_HOST, KEY_2C2P_URL, Keycloak_Host, RESET_PASSWORD_URL (+1) | check (no non-prod marker; test infra IP/host) |
| test.salesforce.com | login.salesforce.com | backoffice, consent, go-fiber-policy, home, node_iia_service, nodejs-express-marketing, nodejs-express-premium, pa, purchase, saleforce, ta, uam | SALEFORCE_AUTH_URL, SF_ENDPOINT, SF_EndPoint | OK (non-prod) |
| 10.91.0.6 | 10.101.0.8 | backoffice, go-fiber-policy, home, isv-test, lead-policy, pa, ta | CMIPolicyAPIEnv, CMI_ENDORSE_URL, CMI_Realtime_Endorse_URL, CMI_Realtime_URL (+3) | check (no non-prod marker; test infra IP/host) |
| uat.ekycsolution.com | api.ekycsolution.com | backoffice, home, pa, ta, uam | URL_YIP_FaceRecogService, URL_YIP_OCRService | OK (non-prod) |
| 34.143.223.165 | 10.109.0.5 | core | DB_HOST_MYSQL | check (no non-prod marker; test infra IP/host) |
| 34.124.214.183 | ftp.tqm.co.th | go-fiber-policy | FTP_ADDRESS | check (no non-prod marker; test infra IP/host) |
| graph.facebook.com | graph.facebook.com | isv-test | META_CAPI_URL | **SAME host in both -> UAT-ISV hits PROD/shared endpoint** |
| isv-api-dev.flybkk.com | isv-api-dev.flybkk.com | isv-test | SERVICE_API_URL | **SAME host in both -> UAT-ISV hits PROD/shared endpoint** |
| partner.shopeemobile.com | partner.shopeemobile.com | isv-test | SHOPEE_URL_DOMAIN | **SAME host in both -> UAT-ISV hits PROD/shared endpoint** |
| demo.emcsthai.com | eclaim5.blueventuregroup.co.th | node_iia_service | EMCS_ENDPOINT | OK (non-prod) |
| (code default 110.49.202.49) | 110.49.174.171 | notification | SMS_URL | absent in UAT-ISV -> code default SMS gateway |
| None | 10.101.0.8 | pa, ta | URL_CMI_Realtime_Policy_Endorse | absent in UAT-ISV |
| uat-sign.one.th | sign.one.th | python-fastapi-document | CERTIFICATE_URL | OK (non-prod) |
| uatservice-etax.one.th | service-etax.one.th | python-fastapi-document | ETAX_STATUS_URL, ETAX_URL | OK (non-prod) |
| 35.240.226.193 | 10.101.0.8 | uam | URL_CMI_Realtime_Policy, URL_CMI_Realtime_Policy_Endorse | check (no non-prod marker; test infra IP/host) |

Masked-key host classification: purchase `KEY_2C2P_URL` UAT-ISV = sandbox host, Prod = production host (OK); uam `URL_YIP_Passport` UAT-ISV = uat host (OK); lead-policy `RESET_PASSWORD_URL` UAT-ISV = uat-isv host (OK); `Keycloak_Host`/`KEYCLOAK_HOST` are IPs in both, differ (OK).
