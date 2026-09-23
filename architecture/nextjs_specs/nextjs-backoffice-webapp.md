# nextjs-backoffice-webapp — Frontend Spec (internal "Insurverse" back office)

Source: `/Users/kritsanawathaniyanon/Code/NextJs/nextjs-backoffice-webapp` (package name `backoffice`, v0.1.0)
Generated: 2026-09-23 from a static read of the source only (nothing was installed, built or run). Items marked ⚠️ are inferred and not verified.

---

## 1. Overview

| Item | Value |
|---|---|
| Next.js | `^13.5.11` (React 18.2.0, TypeScript 5.2) |
| Router | **Pages Router** (`src/pages/`). No `app/` directory, no `middleware.ts`, no `src/pages/api/*` routes, no server actions. |
| Rendering | Every page is effectively client-rendered. `AuthorizationProvider` is loaded with `dynamic(..., { ssr: false })` and wraps every page, so nothing meaningful renders on the server. |
| Build output | `output: 'standalone'`, run with `node server.js` (`Dockerfile.fast`, node 20.11-alpine, port 3000). `deploy.sh` prompts for `.env.uat` or `.env.uat-isv`. `.gitlab-ci.yml` only `include:`s shared templates ⚠️ pipeline contents not visible. |
| State | Redux Toolkit + `next-redux-wrapper` (`src/store/{auth,general}`), used lightly. Most state is server state. |
| Server state | `@tanstack/react-query` v4. Every backend call is wrapped in a `useQuery` or `useMutation` hook under `src/services/**`. |
| UI | MUI v5 (`material`, `lab`, `icons-material`, `x-data-grid`), Emotion, Tailwind (`tailwind-merge`, `class-variance-authority`), Radix scroll-area, Recharts, Swiper, react-toastify, nprogress |
| Forms / validation | `react-hook-form` + `@hookform/resolvers` + `zod` (`src/schemas/`, plus inline zod schemas in services) |
| Files | `xlsx` (Excel import and export), `js-file-download`, base64 file conversion (`src/utils/misc/file-convert.ts`) |
| Crypto | `crypto-js` AES-256-CBC in `src/utils/fns/encryption.ts`, used to encrypt the `expire` query parameter of renewal payment links |
| Code layout | `src/pages/*` are thin wrappers → `src/modules/<feature>/*View.tsx` → `src/services/<feature>/use*Service.ts` |
| Tests | Jest + Testing Library (a few `*.test.tsx`, e.g. permission service, blacklist dialog, FixSalesforceUpdate) |

### Environment variables (names only)
Files: `.env`, `.env.development`, `.env.production`, `.env.uat`, `.env.uat-isv`. Declared in `src/interface/environment.d.ts` and exposed through `next.config.mjs → env` (so they are **inlined at build time**):

- `API_BASE_URL`: backend gateway base. In every env file the value ends in `/api/v1`.
- `PWA_BASE_URL`: customer PWA (`nextjs-webapp`) base, used to build renewal summary/payment links (`src/utils/fns/summaryLinkGenerator.ts`). Missing from `.env` and `.env.production`.
- Build/runtime only: `ANALYZE` (bundle analyzer), `NODE_ENV`.

### API base URL
- A single axios instance: `src/utils/fns/axios.ts` → `axios.create({ baseURL: process.env.API_BASE_URL })`.
- **All** service paths are relative to that base, so the effective URL is `<gateway>/api/v1/<prefix>/...`. The gateway or ingress routes by the first path segment (the table below is based on the route registrations found in `/Users/kritsanawathaniyanon/Code/Go/*`):

| Path prefix | Backend service |
|---|---|
| `/backoffice/*` (incl. `/backoffice/tqm/*`, `/backoffice/blacklist*`, `/backoffice/report/*`, `/backoffice/masterdata/*`) | `go-echo-backoffice-service` |
| `/backoffice-lead-policy/*` | `go-echo-lead-policy-service` |
| `/premium/*` (`premiumAPI`, `actAPI`, `utilityAPI`) | `nodejs-express-premium-service` |
| `/purchase/*` | `go-echo-purchase-service` |
| `/uam/*` | `go-echo-uam-service` (Salesforce sync or attachments) |
| `/notification/*` | `go-echo-notification-service` ⚠️ (the path string also appears in other services) |
| `/isv-test/*` | `isv-test` (Go "test/utility" service that is used by real renewal flows, see §7) |

- The `Authorization: Bearer <token>` header is set globally on the axios instance (`axios.defaults.headers.common`) by `AuthorizationProvider` whenever a token cookie exists.
- A response interceptor handles only **401**: it shows a toast, clears the `user-auth` cookie and hard-redirects to `/login` after about 5 s.
- Exception: `EndorsementHistoryView.tsx` makes 4 raw `fetch()` calls to `${API_BASE_URL}/uam/...` **without** the Authorization header.

---

## 2. Routes / pages (35 page routes)

Every route except `/login` requires a logged-in user (a token cookie exists). "Permission" is the client-side check done by `AuthorizationProvider` against the menu definition (`src/components/layouts/constants.tsx`) using prefix match (`pathname.startsWith(menu.link)`). Effective roles = the permission API list (`user-role` cookie) ∪ Keycloak `realm_access.roles` from the JWT. No page sets `Component.role` (the only one is commented out), so the `RolePage` / `resource_access.account.roles` check in `LoggedProvider` is currently unused.

### 2.1 Core / auth / profile

| URL | File | Auth | Permission | Purpose |
|---|---|---|---|---|
| `/login` | `pages/login.tsx` | No (a logged-in user is redirected to `/`) | – | Username/password → OTP (2-step) login |
| `/` | `pages/index.tsx` | Yes | – | Welcome/dashboard (user info from `getuser_info`) |
| `/profile` | `pages/profile/index.tsx` | Yes | – | Shows the current user's info (`getuser_info`) |
| `/profile/user-management` | `pages/profile/user-management/index.tsx` | Yes | – | ⚠️ **Mock only**: DataGrid of 100 randomly generated users, no API |
| `/profile/user-management/create` | `pages/profile/user-management/create.tsx` | Yes | – | ⚠️ Mock form, no API |
| `/404` | `pages/404.tsx` | – | – | Not found |

### 2.2 Management menu

| URL | File → module | Auth | Permission | Purpose |
|---|---|---|---|---|
| `/lead-policy` | `lead-policy/index.tsx` → `LeadPolicyView` | Yes | `view_lead_policy` | Search leads/policies (keyword, product type, paging) |
| `/lead-policy/detail?leadNo=&policyNo=` | `lead-policy/detail/index.tsx` → `LeadPolicyDetailView` | Yes | `view_lead_policy` (prefix) + in-page: `resend_policy`, `resend_endorse`, `cmi_realtime`, `update_car_inspection_status`, `edit_email`, `edit_password` | Lead/policy detail: information, product (MV/MC/TA/PA/Home-Condo), car inspection, endorsement history, CMI realtime history, history log, Salesforce fix tools |
| `/lead-policy/detail/change-email` | `…/change-email/index.tsx` → `ChangeEmailView` | Yes | `view_lead_policy` + `edit_email` | Change the customer's login email |
| `/lead-policy/detail/change-password` | `…/change-password/index.tsx` → `ChangePasswordView` | Yes | `view_lead_policy` + `edit_password` | Set a password, or email or generate a reset link |
| `/promotion` | `promotion/index.tsx` → `PromotionView` | Yes | `promotion` | List, delete and bulk-status promotions; export promo-code report |
| `/promotion/create` | `promotion/create.tsx` → `PromotionCreateView` | Yes | `promotion` | Create a promotion, import codes (Excel) |
| `/promotion/[_edit]` | `promotion/[_edit].tsx` → `PromotionEditView` | Yes | `promotion` | Edit a promotion |
| `/loyalty` | `loyalty/index.tsx` → `LoyaltyView` | Yes | `loyalty` | List loyalty campaigns (reuses promotion list APIs) and export a report |
| `/loyalty/create` | `loyalty/create.tsx` → `LoyaltyCreateView` | Yes | `loyalty` | Create a loyalty campaign |
| `/loyalty/[_edit]` | `loyalty/[_edit].tsx` → `LoyaltyEditView` | Yes | `loyalty` | Edit a loyalty campaign |
| `/redemption-report` | `redemption-report/index.tsx` → `RedemptionReport` | Yes | `report` | Premium redemption report and promo-code Excel export |
| `/premium-calculation` | `premium-calculation/index.tsx` → `PremiumCalView` | Yes | `premium_calculation` | Trigger the premium recalculation job (`utilityAPI fn=startCloudRun`) |
| `/upload-master` | `upload-master/index.tsx` → `UploadMasterView` | Yes | `upload_master` | Upload, import or delete motor master data and ACT master data (base64 Excel → `utilityAPI`) |
| `/history-log` | `history-log/index.tsx` → `HistoryLogView` | Yes | `history_log` | Audit/history log search and detail |
| `/renewal-policy` | `renewal-policy/index.tsx` → `RenewalPolicyTabView` | Yes | `renew` OR `renew_info` (Keycloak realm roles) | 4 tabs: renewal info/payment link, connect policy, batch upload, generate renewal links |
| `/blacklist` | `blacklist/index.tsx` → `BlacklistView` | Yes | `blacklist_maker` OR `blacklist_checker` | Blacklist list/detail, request removal |
| `/blacklist-requests` | `blacklist-requests/index.tsx` → `BlacklistRequestsView` | Yes | `blacklist_maker` OR `blacklist_checker` (maker: add/edit/delete/resubmit; checker: approve/reject) | Maker–checker requests |

### 2.3 TQM Management menu (no required role: any logged-in user)

| URL | File → module | Auth | Permission | Purpose |
|---|---|---|---|---|
| `/adjust-tqm` | `adjust-tqm/index.tsx` → `AdjustTQMView` | Yes | none (role commented out) | Upload TQM group premium and premium detail (Excel) |
| `/car-inspect` | `car-inspect/index.tsx` → `CarInspectionView` | Yes | none | TQM car-inspection list and status |
| `/car-inspect/[id]` | `car-inspect/[id].tsx` → `CarInspectionEditView` | Yes | none | Edit or save a car inspection (problem master data) |
| `/edit-policy` | `edit-policy/index.tsx` → `EditPolicyView` | Yes | none | "ตรวจสอบก่อนออกกรมธรรม์": list of policies with problems |
| `/edit-policy/[id]` | `edit-policy/[id].tsx` → `EditPolicyUploadView` | Yes | none | Fix the CMI/VMI problem data of one policy |
| `/mapping-car-master` | `mapping-car-master/index.tsx` | Yes | none | ⚠️ Placeholder page (static text only), not in the menu |

### 2.4 Reports menu

| URL | File → module | Auth | Permission | Purpose |
|---|---|---|---|---|
| `/monthly-policy-province` | `monthly-policy-province/index.tsx` → `MonthlyPolicyProvinceView` | Yes | none | Monthly policy count by province |

### 2.5 Dev/demo pages (not in the menu, reachable by any logged-in user)

| URL | File | Purpose |
|---|---|---|
| `/components/calendar` | `components/calendar.tsx` | Date-picker demo |
| `/components/chart` | `components/chart.tsx` | Recharts demo |
| `/components/pokemon` | `components/pokemon.tsx` | Demo; calls `GET /api/v2/pokemon-species/aegislash` on the backend base URL (a broken leftover) |
| `/components/table` | `components/table/index.tsx` | DataGrid demo |
| `/components/table/[edit]` | `components/table/[edit].tsx` | DataGrid edit demo |

---

## 3. Next.js API routes / middleware

- **None.** No `src/pages/api/*`, no `app/**/route.ts`, no server actions, no `middleware.ts`, no `getServerSideProps` auth.
- Every guard runs in the browser: `src/components/authorization/AuthorizationProvider.tsx` (client-only through `dynamic(ssr:false)`) plus in-component `useHasRole(...)` checks.
- `next.config.mjs` has no rewrites, redirects or headers. `_headers` and `_redirects` exist but are empty.

---

## 4. Backend API calls

### 4.1 Call table (92 axios call sites + 4 raw `fetch` = 96; about 87 distinct method+path)

All paths are relative to `API_BASE_URL` (`…/api/v1`). Service names: **BO** = `go-echo-backoffice-service`, **LP** = `go-echo-lead-policy-service`, **PREM** = `nodejs-express-premium-service`, **PUR** = `go-echo-purchase-service`, **UAM** = `go-echo-uam-service`, **NOTI** = `go-echo-notification-service` ⚠️, **ISVT** = `isv-test`. Types are the TS generics or zod schemas named in `src/services/**/types`.

#### Auth / user
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| Login step 1 | POST | `/backoffice/login` | BO | `{username,password}` → `LoginResponse` (new `{Status,Result{success,username,message}}` or legacy `{status,result}`) |
| Login OTP | POST | `/backoffice/request_otp` | BO | `requestOtpSchema` → `RequestOtpResponse` |
| Login OTP | POST | `/backoffice/verify_otp` | BO | `verifyOtpSchema` → `VerifyOtpResponse` (hook exists; ⚠️ the UI uses the variant below) |
| Login OTP | POST | `/backoffice/verify_otp_and_return_jwt` | BO | `verifyOtpAndReturnJwtSchema` → `VerifyOtpAndReturnJwtResponse` (`access_token`, …) |
| Every page (guard), home, profile, renewal | POST | `/backoffice/getuser_info` | BO | `{token}` → `UserInfoData` (Keycloak userinfo, `resource_access`) |
| After login / role hook | GET | `/backoffice-lead-policy/user/permission` (×2 call sites) | LP | – → `{title,status,description,result:string[]}` (app permissions) |

#### Lead / policy (`/lead-policy*`)
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| Search | GET | `/backoffice-lead-policy/leadpolicy` | LP | query `{keyword, page, …}` → `leadPolicySchema` |
| Search filter | GET | `/backoffice-lead-policy/leadpolicy/product-type` | LP | → product-type list |
| Detail | GET | `/backoffice-lead-policy/leadpolicy/detail` | LP | query `{leadNo, policyNo}` → `leadPolicyDetailSchema` |
| Detail: resend policy email | POST | `/backoffice-lead-policy/leadpolicy/email` | LP | lead/policy no → status (`resend_policy`) |
| Product tab | GET | `/backoffice-lead-policy/leadpolicy/product/mv` | LP | motor voluntary product |
| Product tab | GET | `/backoffice-lead-policy/leadpolicy/product/mc` | LP | motor compulsory product |
| Product tab | GET | `/backoffice-lead-policy/leadpolicy/product/travel` | LP | travel product |
| Product tab | GET | `/backoffice-lead-policy/leadpolicy/product/personal-accident` | LP | PA product |
| Product tab | GET | `/backoffice-lead-policy/leadpolicy/product/home-condo` | LP | home/condo product |
| Car inspection | PUT | `/backoffice-lead-policy/leadpolicy/inspect` | LP | update inspection status (`update_car_inspection_status`) |
| Car inspection | PUT | `/backoffice-lead-policy/leadpolicy/inspect/undo` | LP | undo inspection status |
| Endorsement history | GET | `/backoffice-lead-policy/endorsement` | LP | → endorsement list |
| Endorsement history | GET | `/backoffice-lead-policy/endorsement/endorsement-type` | LP | → type list |
| Endorsement history | POST | `/backoffice-lead-policy/endorsement/email` | LP | resend endorsement email (`resend_endorse`) |
| Endorsement repair (raw fetch, **no auth header**) | POST | `/uam/sfattachment_policy_endorse` | UAM | `{id: endorseNo}` |
| Endorsement repair (raw fetch, **no auth header**) | POST | `/uam/sfattachmenturl_policy_endorse_tax` | UAM | ⚠️ endorse attachment, tax |
| Endorsement repair (raw fetch, **no auth header**) | POST | `/uam/sfattachmenturl_policy_endorse_dedebt` | UAM | ⚠️ endorse attachment, decrease-debt |
| Endorsement repair (raw fetch, **no auth header**) | POST | `/uam/sfattachmenturl_policy_endorse_indebt` | UAM | ⚠️ endorse attachment, increase-debt |
| CMI realtime history | GET | `/backoffice-lead-policy/cmi` | LP | → CMI submission history |
| CMI realtime history | GET | `/backoffice-lead-policy/cmi/resubmit` | LP | → resubmit preview/list |
| CMI realtime history | POST | `/backoffice-lead-policy/cmi/resubmit` | LP | resubmit to CMI (`cmi_realtime`) |
| CMI realtime history | POST | `/backoffice-lead-policy/cmi` | LP | submit to CMI |
| CMI realtime history | POST | `/backoffice-lead-policy/cmi/endorse` | LP | endorse to CMI |
| Fix Salesforce | POST | `/uam/create_policy_pure` | UAM | re-create SF policy (voluntary) |
| Fix Salesforce | POST | `/uam/create_policy_act` | UAM | re-create SF policy (ACT) |
| Fix Salesforce | POST | `/uam/sfattachment_policy` | UAM | re-push policy attachment |
| Fix Salesforce | POST | `/uam/sfattachment_policy_act` | UAM | re-push ACT attachment |
| Fix Salesforce | POST | `/purchase/update-sf-payment` | PUR | re-push payment to SF |
| Fix Salesforce | POST | `/purchase/update-sf-payment-act` | PUR | re-push ACT payment to SF |
| Change email | GET | `/backoffice-lead-policy/user/email/policy` | LP | → policies bound to the email |
| Change email | PUT | `/backoffice-lead-policy/user/email` | LP | new email |
| Change password | PUT | `/backoffice-lead-policy/user/password` | LP | set password |
| Change password | POST | `/backoffice-lead-policy/user/password/email` | LP | send reset email |
| Change password | POST | `/backoffice-lead-policy/user/password/link` | LP | generate reset link |

#### History log
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| `/history-log`, lead detail tab | GET | `/backoffice-lead-policy/history-log` | LP | query filters → log list |
| same | GET | `/backoffice-lead-policy/history-log/log-type` | LP | → log types |
| same | POST | `/backoffice-lead-policy/history-log/view-detail` | LP | log id → detail |

#### Promotion / loyalty / reports
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| Promotion & loyalty list | POST | `/backoffice/get_promotion` | BO | filters/paging → promotion list |
| Promotion & loyalty edit | POST | `/backoffice/get_promotion_id` | BO | id → promotion |
| Promotion create | POST | `/backoffice/create_promotion` | BO | → `PromotionCreateData` |
| Promotion edit | POST | `/backoffice/update_promotion` | BO | promotion payload |
| Promotion delete | POST | `/backoffice/delete_promotion` | BO | → `PromotionDeleteData` |
| Promotion/loyalty list | POST | `/backoffice/bulk_update_promotion_status` | BO | ids + status |
| Promotion create | POST | `/backoffice/import_promotion_codes` | BO | codes (Excel) → `ImportPromotionResult` |
| Promotion list | POST | `/backoffice/get_report_promo_code` | BO | → Excel report data |
| Loyalty create | POST | `/backoffice/create_loyalty` | BO | loyalty payload |
| Loyalty edit | POST | `/backoffice/update_loyalty` | BO | loyalty payload |
| Loyalty list | POST | `/backoffice/get_report_loyalty_management` | BO | → Excel report data |
| Loyalty form | POST | `/backoffice/get_loyalty_condition` | BO | → `LoyaltyConditionListRes` |
| Promotion/loyalty/report filters | POST | `/backoffice/get_product` | BO | → product list |
| `/redemption-report` | POST | `/backoffice/get_premium_redemption` | BO | filters → `RedemptionReportData` |
| `/redemption-report` export | POST | `/backoffice/get_report_promo_code_id` | BO | → Excel data |
| `/monthly-policy-province` | POST | `/backoffice/report/monthly-policy-by-province` | BO | month/year/province → `MonthlyPolicyProvinceResponse` |
| `/monthly-policy-province` | GET | `/backoffice/masterdata/provinces` | BO | → `ProvinceMasterResponse` |

#### Master data / premium
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| `/upload-master` | POST | `/premium/utilityAPI` | PREM | `{fn:'importMasterData'\|'importMasterDataAct'\|'deleteMasterData', fileBase64}` (300 s timeout) |
| `/premium-calculation` | POST | `/premium/utilityAPI` (same hook) | PREM | `{fn:'startCloudRun', …}` |

#### TQM
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| `/adjust-tqm` | POST | `/backoffice/tqm/import-group-premium` | BO | Excel upload |
| `/adjust-tqm` | POST | `/backoffice/tqm/import-premium-detail` | BO | Excel upload |
| `/car-inspect` | POST | `/backoffice/tqm/get-car-inspect-list` | BO | filters → `CarInspectListResponse` |
| `/car-inspect`, `[id]` | POST | `/backoffice/tqm/update-car-inspect-status` (×2 call sites) | BO | → `UpdateCarInspectResponse` |
| `/car-inspect/[id]` | POST | `/backoffice/tqm/save-car-inspect` | BO | → `SaveCarInspectStatusResponse` |
| `/car-inspect/[id]`, blacklist dialog | GET | `/backoffice/tqm/get-masterdata-problem` | BO | → problem/car master data |
| `/edit-policy` | POST | `/backoffice/tqm/get-policy-problem-list` | BO | → `PolicyListResponse` |
| `/edit-policy/[id]` | POST | `/backoffice/tqm/update-policy-problem-cmi` | BO | → `UpdatePolicyProblemCMIResponse` |
| `/edit-policy/[id]` | POST | `/backoffice/tqm/update-policy-problem-vmi` | BO | → `UpdatePolicyProblemVMIResponse` |

#### Blacklist (maker–checker)
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| `/blacklist` | POST | `/backoffice/blacklist/list` | BO | `BlacklistListParams` → list |
| `/blacklist` | POST | `/backoffice/blacklist/detail` | BO | id → detail |
| `/blacklist` | POST | `/backoffice/blacklist/remove/request` | BO | `BlacklistRemovalInput` |
| `/blacklist-requests` | POST | `/backoffice/blacklist-request/list` | BO | `BlacklistRequestListParams` → list |
| `/blacklist-requests` | POST | `/backoffice/blacklist-request/detail` | BO | id → detail |
| maker | POST | `/backoffice/blacklist-request/add` | BO | `BlacklistAddInput` |
| maker | POST | `/backoffice/blacklist-request/edit` | BO | edit input |
| maker | POST | `/backoffice/blacklist-request/delete` | BO | id |
| maker | POST | `/backoffice/blacklist-request/resubmit` | BO | id |
| checker | POST | `/backoffice/blacklist-request/approve` | BO | id |
| checker | POST | `/backoffice/blacklist-request/reject` | BO | id + reason ⚠️ |

#### Renewal (`/renewal-policy`)
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| Renewal info, Connect policy | POST | `/premium/premiumAPI` | PREM | `{fn:'saveLeadRenew', data:{flagLead, flagNoti, policyNo}}` → `SaveLeadRenewResponse` |
| Renewal info | POST | `/premium/premiumAPI` | PREM | `{fn:'getLeadCoveragePremium', data}` → `GetLeadCoveragePremiumResponse` |
| Renewal info (ACT) | POST | `/premium/actAPI` | PREM | `{fn:'getLeadActPremium', …}` |
| Renewal info | POST | `/purchase/create-payment-renewal` | PUR | → payment link |
| Renewal info (ACT) | POST | `/purchase/create-payment-act` | PUR | → payment link |
| Renewal info | POST | `/isv-test/short_link` | ISVT | long URL → short URL |
| Renewal info | POST | `/notification/sms` | NOTI ⚠️ | send the link by SMS |
| Renewal info | POST | `/backoffice-lead-policy/leadpolicy/encrypted` | LP | → `GetEncryptedDataResponse` (encrypted lead no.) |
| Renewal info | POST | `/backoffice-lead-policy/leadpolicy/claim` | LP | → claim info |
| Connect policy | POST | `/backoffice-lead-policy/renewal-payment` | LP | connect the renewal payment to the policy |
| Batch upload | POST | `/isv-test/renewal/process` | ISVT | multipart Excel → `ProcessRenewalBatchResponse` |
| Renewal links | POST | `/isv-test/renewal/excel-links` | ISVT | multipart Excel → `ProcessRenewalExcelLinksResponse` |

#### Demo
| Page/feature | Method | Path | Service | Request / response |
|---|---|---|---|---|
| `/components/pokemon` | GET | `/api/v2/pokemon-species/aegislash` | none (dead) | `PokemonSpecies` |

---

## 5. Auth flow

1. **Login (`/login`)**: `POST /backoffice/login {username,password}` (BO proxies to Keycloak with a password grant ⚠️). On success (`Status 200 && Result.success`) the UI switches to `OTP_VERIFICATION`. An `invalid_grant … Account is not fully set up` error shows a "contact admin to finish Keycloak setup" message.
2. **OTP**: `OtpVerification` → `POST /backoffice/request_otp`, then `POST /backoffice/verify_otp_and_return_jwt` → `{access_token, …}`.
3. **Token storage** (`useAuth().login`, `src/hooks/useAuthorization.ts`):
   - Cookie `user-auth` = `JSON.stringify({access_token})`, `path=/`. Session cookie, or 1-month `expires` when "remember me" is ticked. Set from JS, so it is **not HttpOnly** and `secure`/`sameSite` are not set.
   - `localStorage.auth_token` = access token and `localStorage.auth_success = 'true'` (set in `login.tsx`, never cleared on logout ⚠️).
   - Then `GET /backoffice-lead-policy/user/permission` with the new token → cookie `user-role` = JSON array of app permissions.
4. **Request auth**: `AuthorizationProvider` sets `axios.defaults.headers.common.Authorization = Bearer <token>` on every render while logged in.
5. **Refresh**: **none.** There is no refresh token handling. Any 401 → toast → clear the `user-auth` cookie → `window.location = /login`. A 1-month remember-me cookie outlives the Keycloak access token, so the user is simply bounced at the first 401.
6. **Guards (client only)**:
   - Not logged in → `router.push('/login')`. Logged in on `/login` → `/`.
   - `LoggedProvider` fetches `getuser_info` for every protected page and shows a spinner meanwhile. If a page declared `role` it would check `resource_access.account.roles` (no page does).
   - Route permission: `findMenuByPath(pathname)` + `canAccessMenu(menu, roles)`. On failure → `router.push('/')`. Extra fixed checks: `/lead-policy/detail/change-email` → `edit_email`, `/lead-policy/detail/change-password` → `edit_password`. Enforcement waits until the `user-role` cookie exists.
   - The sidebar shows `visibleMenus(roles)` only.
   - In-page actions use `useHasRole(ROLE_NAME.X)`.
7. **Roles/permissions (Keycloak)**: effective roles = `user-role` cookie (app permissions from LP) ∪ JWT `realm_access.roles` (decoded client-side with `atob`, no signature check). Permission keys (`src/services/auth/permission/constants.ts`): `view_lead_policy, edit_email, edit_password, update_car_inspection_status, resend_policy, resend_endorse, cmi_realtime, promotion, loyalty, report, premium_calculation, upload_master, history_log, renew, renew_info, blacklist_maker, blacklist_checker`. Legacy `ROLE` enum (`user_role, admin_role, offline_access, manager, super_admin`) is only used for labels.
8. **Logout**: deletes the `user-auth` and `user-role` cookies, then `router.reload()`. No Keycloak end-session call, and localStorage is not cleared.

---

## 6. Main back-office workflows

### 6.1 Lead / policy search and servicing
1. `/lead-policy`: `GET leadpolicy/product-type` fills the filter, then `GET leadpolicy?keyword…` (LP) runs the paged search.
2. Click a row → `/lead-policy/detail?leadNo=&policyNo=` → `GET leadpolicy/detail`, then product tab `GET leadpolicy/product/{mv|mc|travel|personal-accident|home-condo}`.
3. Actions (each is permission-gated):
   - Resend the policy email: `POST leadpolicy/email` (`resend_policy`).
   - Car inspection: `PUT leadpolicy/inspect` and `PUT leadpolicy/inspect/undo` (`update_car_inspection_status`).
   - CMI: `GET cmi` history; `POST cmi`, `POST cmi/resubmit`, `POST cmi/endorse` (`cmi_realtime`).
   - Endorsements: `GET endorsement`, `GET endorsement/endorsement-type`, `POST endorsement/email` (`resend_endorse`). The "repair file" buttons use raw fetch to `/uam/sfattachment*_endorse*`.
   - Salesforce fix (`FixSalesforceUpdate`): `/uam/create_policy_pure|act`, `/uam/sfattachment_policy[_act]`, `/purchase/update-sf-payment[-act]`.
   - History log tab: `GET history-log`, `POST history-log/view-detail`.
4. Customer account: `/lead-policy/detail/change-email` (`GET user/email/policy` → `PUT user/email`). `/lead-policy/detail/change-password` (`PUT user/password`, or `POST user/password/email` / `POST user/password/link`).

### 6.2 Renewal (`/renewal-policy`, `renew` or `renew_info`)
1. **Tab 1, renewal info/payment** (`RenewalPaymentView`): `premiumAPI fn=saveLeadRenew` (policyNo → new renewal lead), then `premiumAPI fn=getLeadCoveragePremium` (and `actAPI fn=getLeadActPremium` for ACT) and `leadpolicy/claim` (claim info).
2. Create payment: `/purchase/create-payment-renewal` or `/purchase/create-payment-act`. Or build a PWA summary link client-side: `PWA_BASE_URL + renew/{car-insurverse|compulsory}/summary?Lead_No=&expire=<AES-encrypted ts, 7 days>&renew=true`. Also `leadpolicy/encrypted` for the encrypted lead no.
3. Shorten the link with `/isv-test/short_link` and send it by SMS with `/notification/sms`. `renew_info` users are view-only ⚠️ (full actions need `renew`).
4. **Tab 2, connect policy**: `saveLeadRenew`, then `POST /backoffice-lead-policy/renewal-payment`.
5. **Tab 3, batch upload**: Excel → `POST /isv-test/renewal/process` (multipart).
6. **Tab 4, renewal links**: Excel → `POST /isv-test/renewal/excel-links` → the returned file or links are downloaded.

### 6.3 Blacklist maker–checker (`/blacklist`, `/blacklist-requests`)
1. `/blacklist`: `blacklist/list` → `blacklist/detail` → a maker can `blacklist/remove/request`.
2. `/blacklist-requests`: `blacklist-request/list` and `/detail`. The add dialog loads `tqm/get-masterdata-problem`.
3. Maker: `add`, `edit`, `delete` (pending), `resubmit` (rejected).
4. Checker: `approve` or `reject` (pending). The server enforces roles (`middlewares/blacklist_role.go` in BO, per code comment).

### 6.4 Promotion and loyalty
1. List: `get_promotion` (+ `get_product` filter) → `bulk_update_promotion_status` / `delete_promotion`, and export with `get_report_promo_code` (loyalty: `get_report_loyalty_management`).
2. Create: `create_promotion` + `import_promotion_codes` (Excel). Loyalty: `get_loyalty_condition` → `create_loyalty`.
3. Edit: `get_promotion_id` → `update_promotion` / `update_loyalty`.
4. Report: `/redemption-report` → `get_premium_redemption`, with Excel from `get_report_promo_code_id`.

### 6.5 Master data and premium
1. `/upload-master`: choose the type (motor / compulsory / delete-motor) → Excel converted to base64 → `POST /premium/utilityAPI {fn, fileBase64}` (300 s timeout).
2. `/premium-calculation`: `POST /premium/utilityAPI {fn:'startCloudRun'}` triggers the recalculation job ⚠️ (Cloud Run job, per the name).

### 6.6 TQM
1. `/adjust-tqm`: upload `tqm/import-group-premium`, then `tqm/import-premium-detail`.
2. `/car-inspect`: `tqm/get-car-inspect-list` → `/car-inspect/[id]` (`tqm/get-masterdata-problem`, `tqm/save-car-inspect`, `tqm/update-car-inspect-status`).
3. `/edit-policy`: `tqm/get-policy-problem-list` → `/edit-policy/[id]` → `tqm/update-policy-problem-cmi` / `-vmi`.

### 6.7 Reports
- `/monthly-policy-province`: `masterdata/provinces` + `report/monthly-policy-by-province`.

### 6.8 User management
- ⚠️ **Not implemented.** `/profile/user-management*` renders mock data only. Back-office users and roles are managed directly in Keycloak (inferred from the login error text).

---

## 7. Notes / ⚠️ unverified items

**Security observations**
1. **Hardcoded AES key and IV in client code** (`src/utils/fns/encryption.ts`, values not reproduced here). They ship in the JS bundle, so anyone can forge or extend the `expire` parameter of renewal summary links. The PWA presumably decrypts with the same key ⚠️. Move link signing to the backend.
2. **Access token in JS-readable storage**: the `user-auth` cookie is not HttpOnly or Secure, and `localStorage.auth_token` is never cleared on logout. Both are exposed to XSS and linger after logout.
3. **All authorization is client-side** in the frontend. The TQM pages (`/adjust-tqm`, `/car-inspect*`, `/edit-policy*`), `/monthly-policy-province` and the demo pages have **no role requirement**. Server-side role enforcement is confirmed only for blacklist (per the code comment). The BO/LP routes seen use `ExtractTokenToGlobalVar` (token presence). ⚠️ Per-permission checks on the backend were not verified.
4. **Unauthenticated calls**: 4 raw `fetch` calls to `/uam/sfattachment*_endorse*` send no Bearer token, so those UAM endpoints must be open ⚠️. `isv-test` routes `short_link`, `renewal/process` and `renewal/excel-links` are registered without auth middleware in `isv-test/router/router.go`.
5. **Production traffic depends on the `isv-test` service** (renewal batch, renewal links, short links). Its name suggests test tooling, so confirm it is production-grade and deployed in prod.
6. Realm roles are decoded from the JWT client-side without verification. This is fine for UI gating only.
7. No token refresh and no Keycloak logout (end-session) call. Remember-me lasts 1 month, but the token expires much sooner.

**Config / correctness**
8. `.env.production` points `API_BASE_URL` at a `*-dev` host (not an insurverse domain) and has no `PWA_BASE_URL`, so renewal summary links would start with an empty base in a prod build ⚠️. Env vars are inlined at build time through `next.config env`, so the image must be built per environment.
9. `deploy.sh` only offers UAT and UAT-ISV. The `.gitlab-ci.yml` includes remote templates ⚠️ (deploy path not visible).
10. `findMenuByPath` uses prefix matching: `/blacklist-requests` matches the `/blacklist` entry first. This is harmless because the roles are the same.
11. Dead or leftover code: `RolePage` page-role mechanism (unused), `usePokemonService` + `/components/*` demo pages, `/mapping-car-master` placeholder, mock user management, `verify_otp` hook unused ⚠️.
12. `/notification/sms` → `go-echo-notification-service` is inferred. The path string appears in several services.
13. Request and response shapes are summarized from TS type/schema names only. Full field lists live in `src/services/**/types/*.ts`.
