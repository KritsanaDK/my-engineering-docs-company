# ISV Platform — API Spec Index

Generated: 2026-09-23 · Source: code in `~/Code/Go` and `~/Code/NextJs` (read-only scan) · DB reference: UAT-ISV (`insurverse`)

Related:
- Next.js specs → [../nextjs_specs/](../nextjs_specs/)
- DB schema spec → [../../database/schema_spec/README.md](../../database/schema_spec/README.md)
- Stored functions (catalogued) → [../../database/functions/README.md](../../database/functions/README.md)
- Salesforce sheets → [../salesforce_api_specs/README.md](../salesforce_api_specs/README.md)

> ⚠️ Each spec was derived from source code. Column names / function signatures were **not** re-checked against the live DB per endpoint — see each file's "Notes / ⚠️ unverified" section.

## 1. Services

| Service | Lang / FW | Routes | Auth | Spec |
|---|---|---|---|---|
| go-echo-purchase-service | Go / Echo | 25 | ⚠️ none | [spec](go-echo-purchase-service.md) |
| go-echo-lead-policy-service | Go / Echo | 35 | Keycloak + CheckPermission | [spec](go-echo-lead-policy-service.md) |
| go-echo-core-service | Go / Echo | 31 | ValidateToken on `get-policy` only | [spec](go-echo-core-service.md) |
| go-echo-auth-service | Go / net/http | 6 | JWT (issuer) | [spec](go-echo-auth-service.md) |
| go-echo-uam-service | Go / Echo | 80 | JWT on 12 routes (hard-coded HS256 key); rest ⚠️ none | [spec](go-echo-uam-service.md) |
| go-oauth2-server | Go | 12 | OAuth2 (partners) | [spec](go-oauth2-server.md) |
| go-echo-consent-service | Go / Echo | 9 | see spec | [spec](go-echo-consent-service.md) |
| go-echo-amlo-service | Go / Echo | 18 | see spec | [spec](go-echo-amlo-service.md) |
| go-echo-backoffice-service | Go / Echo | 53 | Keycloak (cron routes ⚠️ none) | [spec](go-echo-backoffice-service.md) |
| go-echo-internal-service | Go / Echo | 2 | Basic Auth | [spec](go-echo-internal-service.md) |
| go-echo-analytics-service | Go / Echo (BigQuery) | 3 | static bearer | [spec](go-echo-analytics-service.md) |
| go-echo-marketing-service | — (README only) | 0 | — | [spec](go-echo-marketing-service.md) |
| go-echo-notification-service | Go / Echo | 35 | see spec | [spec](go-echo-notification-service.md) |
| go-echo-file-service | Go / Echo (GCS, Vision) | 6 | ⚠️ none | [spec](go-echo-file-service.md) |
| go-echo-home-service | Go / Echo | 6 | ⚠️ none | [spec](go-echo-home-service.md) |
| go-echo-pa-service | Go / Echo | 6 | ⚠️ none | [spec](go-echo-pa-service.md) |
| go-echo-ta-service | Go / Echo | 5 | ⚠️ none | [spec](go-echo-ta-service.md) |
| go-echo-pt-maxme | Go / Echo | 13 | partial (ISV leads ⚠️ none) | [spec](go-echo-pt-maxme.md) |
| go-echo-saleforce-service | Go / Echo | 9 (+12 fn) | see spec | [spec](go-echo-saleforce-service.md) |
| go-echo-oic | Go | 1 | see spec | [spec](go-echo-oic.md) |
| c-oic-realtime | — | 2 + templates | see spec | [spec](c-oic-realtime.md) |
| node-oic | Node (CLI/batch) | 0 | — | [spec](node-oic.md) |
| go-e-api | Go | 26 | see spec | [spec](go-e-api.md) |
| go-db-query | Go | 2 | JWT (⚠️ any holder) | [spec](go-db-query.md) |
| go-fiber-policy-service | Go / Fiber | 20 | ⚠️ none | [spec](go-fiber-policy-service.md) |
| go-fiber-queue-service | Go / Fiber | 4 | see spec | [spec](go-fiber-queue-service.md) |
| isv-test | Go / Echo (real HTTP service) | 91 | ⚠️ mostly none (4 Basic Auth, 1 reCAPTCHA) | [spec](isv-test.md) |
| node_iia_service | Node | 13 | see spec | [spec](node_iia_service.md) |
| nodejs-express-marketing-service | Node / Express | 2 | ⚠️ none | [spec](nodejs-express-marketing-service.md) |
| nodejs-express-premium-service | Node / Express | 10 routes (38 ops via `{fn}` dispatch) | ⚠️ none (fn allow-list only) | [spec](nodejs-express-premium-service.md) |
| java-spring-boot-jasper-report-service | Java / Spring Boot | 19 | ⚠️ none | [spec](java-spring-boot-jasper-report-service.md) |
| python-fastapi-document-service | Go / Fiber (despite name) | 25 | ⚠️ none | [spec](python-fastapi-document-service.md) |

## 1b. Frontends

| App | Stack | Pages | Backend calls | Calls services | Spec |
|---|---|---|---|---|---|
| nextjs-webapp | Next.js | 125 page files + 2 API routes | see spec | see spec | [spec](../nextjs_specs/nextjs-webapp.md) |
| nextjs-backoffice-webapp | Next.js 13.5, Pages Router, CSR only | 35 | 96 (~87 distinct) | backoffice, lead-policy, premium, purchase, uam, isv-test, notification (⚠️) | [spec](../nextjs_specs/nextjs-backoffice-webapp.md) |

## 2. Service × DB matrix (schema `insurverse` unless noted)

| Service | Main tables | Stored functions |
|---|---|---|
| purchase | payment, payment_act, payment_ta, payment_transaction, payment_callback, Lead_coverage_premium, Lead/Policy_Car_Act_Discount_Premium, Policy_Header, Policy_coverage_premium, lead/policy_ta/pa/home_premium, log_iia_policy, sec_user | fn_policy_book_iia, fn_policy_quatationno_iia 🔒, fn_policy_invoiceno_iia 🔒, fn_lead_to_car_act 🔒, fn_ta/pa/home_policy_from_lead, fn_update_promo_active, fn_update_point_policy, fn_display_country(_th) |
| lead-policy | v_lead_policy_product, v_endorse_product, Policy_Header, Policy/Lead_coverage_premium, Policy_Regis_Evident, Policy_endorse_detail, Policy_email_confirm, log_cmi_realtime, payment tables, promo_code, sf_claim*, log_activity*, sec_user, renewal_payments | — |
| core | Imp_Price_Premium, Imp_Discount_Premium, mas_cmi_*, Policy_Header, Policy_Regis_Evident, Policy_email_confirm, *_Trans, payment tables; MySQL wp_posts/wp_postmeta/wp_users | fn_policy_my_policy, fn_display_buddha_date |
| auth | sec_user | — |
| oauth2 | public.mas_partner, public.log_openapi_interface | — |
| consent | consent_accept, consent_content, consent_purpose, consent_rop, lead_*_participant, SF_Lead, Lead_* | — |
| amlo | amlo_master, amlo_name, amlo_idnumber, Policy_*(+_Trans), policy_ta/pa/home_premium, sf_claim* | — |
| backoffice | sec_user, jwt_tokens, otp_*, promo_code(_trans), loyalty_condition, log_point_expire, tbl_blacklist(_request), tqm_*, Policy_*/Lead_*, public."User" | fn_noti_daily_promo_code, fn_update_point_expire(_noti), fn_update_promo_batch, fn_cleanup_expired_jwt |
| internal | payment, payment_act, Lead_* (read) | — |
| analytics | BigQuery insurverse_analytics.policy_daily_lastversion | — |
| notification | app_notification(_token), notification_*, thaibulk_*, log_noti_*, renewal_notification, renewal_template, batch_jobs, loyalty_point_trans | fn_policy_renewal, fn_policy_renewal_noti(_log) |
| file | — (GCS) | — |
| home | mas_home_*, lead_home_*, policy_home_premium, promo_code(_trans), payment_transaction, log_request_home | fn_loyalty_referal_code, crc32 |
| pa | mas_pa_*, lead_pa_*, policy_pa_premium, promo_code(_trans), payment_transaction, log_request_pa | fn_loyalty_referal_code, crc32 |
| ta | mas_ta_*, mas_country, mas_state, lead_ta_*, promo_code(_trans) | fn_loyalty_referal_code |
| pt-maxme | Lead_Car_Act_Discount_Premium (read), users | — |
| saleforce | log_sf_policy(_trans), Policy_Header, Policy_Car_Act_Discount_Premium, tqm_*, sf_claim_*, sf_file_attach, temp_otp, log_email_change | fn_sf_policy_endorse_financial, fn_update_point_cancel, fn_policy_endorse_master/_coverage, fn_policy/claim/file_fileid_sf, fn_claim_sr_log_id_iia, fn_profile_email_change |
| go-e-api | payment, payment_act, province/district/subdistrict/zipcode, mas_cmi_color, public.mas_partner, sales_channcel, log_openapi_interface | fn_policy_my_policy_search_optimized |
| go-db-query | public.api_key (unused) — executes arbitrary SQL | — |
| node-oic | calculate_premium_job, log_calculate_premium, sys_param | — |
| node_iia | lead_/policy_ ta/pa/home, log_request_*, log_iia_*, emcs_getimage_*, sf_claim_*, mas_ta_* | fn_policy_trans_history_{ta,pa,home}, crc32 |
| express-marketing | iia_data_sr_* (7) | — |
| document-service | lead_/policy_ ta/pa/home, payment, payment_ta, mas_*, sf_claim_*, log_internal_interface, log_sf_policy | fn_display_access, fn_display_country |
| premium | Imp_Price_Premium, Imp_Discount_Premium, Lead_coverage_premium, Lead/Policy_Car_Act_Discount_Premium, lead_ta_*, Policy_Header, Policy_coverage_premium, policy_overlap_whitelist, payment, payment_ta, promo_code, promo_group, promo_code_trans, sys_param, sec_user, sec_user_sso | fn_comp_to_usage, fn_loyalty_referal_code, fn_policy_renewal, fn_promo_promotion_list, fn_update_promo_book, fn_update_promo_active |
| jasper-report | — (no DB; data from request body) | — |
| uam | sec_user, sec_user_sso, temp_otp, reset_password, lead tables, Policy_Header, Policy_coverage_premium, Policy_Car_Act_Discount_Premium, policy_no, e-KYC / claim / log tables | fn_policy_to_car_act 🔒, fn_policy_lotno_iia 🔒, fn_update_point_policy, fn_policy_renewal_ref, fn_policy_renewal_inspect_email, fn_claim_status_history, fn_profile_email_change, fn_check_sf_account, fn_policy_endorse_request, fn_loyalty_referal_code |
| fiber-policy | tqm_lead_vmi, tqm_lead_cmi, tqm_request_status, tqm_allow_process (batch lock), policy tables, log_iia_policy, log_sf_policy, log_cmi_realtime | fn_policy_lotno_iia 🔒, fn_policy_invoiceno_iia 🔒, fn_check_sf_account |
| isv-test | consent, ThaiBulk email/key/webhook, renewal_payments, renew batch, Shopee, callback_logs, hbdisv_event, api_flow_log; BigQuery | — |

🔒 = uses `pg_advisory_xact_lock`.

## 3. Security findings (from the scan — ⚠️ not yet verified, nothing fixed)

| Severity | Service | Finding |
|---|---|---|
| 🔴 High | go-db-query | Runs any SQL sent by any JWT holder; JWT secret has hardcoded fallback |
| 🔴 High | purchase | `/callback` does not verify 2C2P signature; no auth on any route; `/env` public |
| 🔴 High | purchase | send-iia routes build SQL with `fmt.Sprintf` (SQL injection) |
| 🔴 High | isv-test | `POST /mc/policy` no auth / no payment check → calls e-API `payment/success` (free ACT policy?); `GET /thaibulksms/api_keys` returns API secrets; `/proxy/*` open reverse proxy |
| 🔴 High | uam | Likely SSO account takeover (`registeraccount_sso` doesn't match email to Firebase token — needs test); SQL injection in `forget_password`, `get_carband_all`, `get_geo`; shared global user (cross-user data); Firebase/SF/IIA/AES secrets in `constants/constant.go` |
| 🟠 Med | uam | Public `decrypt_lead_no`; open policy-issuance routes; no OTP attempt limit; policy number generated without lock |
| 🟠 Med | fiber-policy | No auth; `upload-policy` fetches any URL → partner SFTP (SSRF); draft routes read any GCS object; empty `OIC_TOKEN` accepted |
| 🟡 Low | isv-test | `/movement/*` creates DB tables on GET; consent/payment data readable without auth |
| 🔴 High | premium | No real auth; public `GET /deleteUser?email=` (SQL injection); public admin fns wipe ACT price table / edit rates / `bypassCarInspection`; `fn=decode` decrypts lead numbers |
| 🔴 High | premium | GCP service-account keys (prod/uat/dev) in `credentials/` and repo root, not in `.gitignore` |
| 🟠 Med | jasper-report | No auth (fake policy/receipt/tax PDFs); SSRF via image URL on claim endpoints |
| 🔴 High | core, file, analytics, node-oic | GCP `key.json` / service-account keys committed to repo |
| 🟠 Med | auth | Hardcoded JWT/bcrypt/AES keys; `/refresh_token` unauthenticated + shared global (wrong-user token); cookie lacks HttpOnly/Secure |
| 🟠 Med | lead-policy | Passwords/hashes logged; history-log API returns old password hashes |
| 🟠 Med | notification | ThaiBulk / OneSignal / Firebase private key hardcoded |
| 🟠 Med | home, pa, ta, file, document, express-marketing | No auth |
| 🟠 Med | home, pa, ta | AMLO check runs after lead is saved |
| 🟠 Med | saleforce, node_iia | Salesforce credentials in URL query string |
| 🟠 Med | go-e-api | Logs Bearer JWT, citizen ID, address to DB; APP_DEBUG default true |
| 🟡 Low | saleforce | Claim `sc_id` = MAX+1 without lock |
| 🟡 Low | oauth2 | APP_DEBUG logs config incl. secrets; CORS `*` |
| 🟡 Low | backoffice | Cron endpoints no auth; hardcoded dev notification URL |
| 🟡 Low | queue-service | Logs DB password at startup |
| 🟡 Low | nextjs-webapp | Hardcoded Bearer token in frontend |
| 🟠 Med | nextjs-backoffice | AES key/IV for renewal payment links hardcoded in `src/utils/fns/encryption.ts` (shipped to browser) |
| 🟠 Med | nextjs-backoffice | Permission checks only client-side; TQM, monthly report and demo pages need no permission |
| 🟡 Low | nextjs-backoffice | 4 raw `fetch` calls to `/uam/sfattachment*_endorse*` send no auth header; token in JS-readable cookie + localStorage |
| 🟡 Low | nextjs-backoffice | `.env.production` points to a `*-dev` host and lacks `PWA_BASE_URL` |
| 🟡 Low | DB | `payment.lead_no` is `integer` but `fn_lead_to_car_act(lead_no bigint)` |
