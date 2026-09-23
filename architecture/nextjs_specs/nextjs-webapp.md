# nextjs-webapp — Frontend Spec (customer-facing "Insurverse" PWA)

Source: `/Users/kritsanawathaniyanon/Code/NextJs/nextjs-webapp` (package name `insurverse`, v0.1.0)
Generated: 2026-09-23 by static read of source only (nothing built or run). Items marked ⚠️ are inferred / not verified.

---

## 1. Overview

| Item | Value |
|---|---|
| Next.js | `13.5.11` (React 18.2.0, TypeScript 5) |
| Router | **Pages Router** (`src/pages/`). No `app/` directory. No `middleware.ts`. |
| Build output | `output: 'standalone'` (next.config.js). Repo also has `out/`, `_redirects`, `_headers` (Cloudflare Pages), `Dockerfile*`, `nginx.conf.template`, `Jenkinsfile`, `.gitlab-ci.yml`. |
| PWA | `next-pwa` v5 (service worker, disabled in dev) |
| State | Redux Toolkit + `next-redux-wrapper` (`src/store/*`: auth, purchase, shopping, travel, act, eKyc, my-insurance, home-insurance, car-inspection, counter) + browser storage hooks (`src/hooks/storage/*`) |
| Server state | `@tanstack/react-query` v4 (every service is a `useQuery`/`useMutation` hook) |
| UI | MUI v5 (`@mui/material`, `@mui/icons-material`, `@mui/x-date-pickers`), Emotion, Swiper, react-slick, framer-motion, react-spring |
| Forms | `react-hook-form` + `@hookform/resolvers` + `yup` (`src/schemas/`) |
| HTTP client | `axios` single instance in `src/utils/axios.ts` (`baseURL = process.env.API_BASE_URL`) |
| Auth libs | Custom JWT (backend `/api/v1/auth/login`), `firebase` v12 (Google / Facebook social login), `cookies-next` |
| Other | `react-webcam` + `browser-image-compression` (eKYC / car inspection photos), `qrcode`, Hotjar, GTM, OneTrust, Salesforce live-chat, BigQuery analytics |

### Environment variables (names only)
Build-time env is resolved in `next.config.js`: `ENV | APP_ENV | CI_COMMIT_REF_NAME | CF_PAGES_BRANCH` → maps to `config/env/{dev,uat,uat-isv,sit,prod}.js` (`main`→`prod`). The three URL values below come from that file unless overridden by process env.

- URLs: `API_BASE_URL`, `PATH_MENU_BASE_URL`, `REDIRECT_URL`
- Tracking / 3rd-party: `GTM`, `GTM_PARTNER`, `ONETRUHT`, `NEXT_PUBLIC_HOTJAR_ID`, `RECAPTCHA_TOKEN`, `MERCHANT_ID`
- Firebase: `API_KEY`, `AUTH_DOMAIN`, `PROJECT_ID`, `STORAGE_BUCKET`, `MESSAGING_SENDER_ID`, `APP_ID`, `MEASUREMENT_ID`
- Salesforce chat: `CHAT_ENPOINT`, `CHAT_ENPOINTDUMMY`, `CHAT_KEY`, `CHAT_DEPLOYID`, `CHAT_BUTTONID`, `CHAT_ENPOINTJS`
- Crypto: `ENCRYPTION_KEY`, `ENCRYPTION_IV`, `ENCRYPTION_MAXME_PARTNER`, `ENCRYPTION_MAXME_KEY`, `ENCRYPTION_MAXME_IV`
- Misc: `ENV`, `IS_SHOW_LOG` (keeps console in prod build), `NODE_ENV`
- Env files present: `.env.local`, `.env.production`, `.env.sit`, `.env.uat`, `.env.uat-isv` (all same key set).

> Note: all of these are inlined into the client bundle via `next.config.js > env` (no `NEXT_PUBLIC_` separation), so `ENCRYPTION_*` values are shipped to the browser. ⚠️ security review recommended.

### API base URL
- One gateway host for everything: `API_BASE_URL` (e.g. uat-isv → `https://insurverse-uat-isv-api.insurverse.co.th`). All service paths are absolute on that host: `/api/v1/<service-prefix>/...`.
- `PATH_MENU_BASE_URL` = landing/menu URL used after login/logout; `REDIRECT_URL` = where `/` redirects (WordPress site in prod; on uat-isv it points to the app itself → falls back to `/shopping/compulsory`).

---

## 2. Routes / pages (125 page routes)

Auth column: **AuthCheck** = wrapped in `components/authorization/AuthCheck` (directly or via `AccountLayout`) → redirects to `/login?callback_url=...` if no user. **Renew-bypass** = AuthCheck skips login when renew mode is set (`?renew=true` or sessionStorage `purchaseRenew`/`actRenewMode`). **Soft** = page is public but some actions push to `/login` (e.g. payment summary). **No** = public.

### 2.1 Core / auth / member
| URL path | File | Auth | Purpose | Main components |
|---|---|---|---|---|
| `/` | pages/index.tsx | No | Redirect to `REDIRECT_URL` or `/shopping/compulsory` | Loader |
| `/404` | pages/404.tsx | No | Not found | Typography |
| `/login` | pages/login/index.tsx | No | Email/password + social login; supports `?page=` / `?callback_url=` | components/authorization/login/Login, SocialLoginButton |
| `/logout` | pages/logout/index.tsx | No | Redux `setLogout`, redirect to `PATH_MENU_BASE_URL` | — |
| `/autologin` | pages/autologin/index.tsx | No | Token-in-URL auto login (`auto_login_token_check`) then redirect | useAutoLoginQuery, useUserQuery |
| `/register` | pages/register/index.tsx | No | Register (email + OTP / SSO) | components/authorization/register |
| `/forgot-password` | pages/forgot-password/index.tsx | No | Request reset | ForgotPassword |
| `/new-password` | pages/new-password/index.tsx | No | Set new password from link | useCheckUpdatePassword, useNewPassword |
| `/referral` | pages/referral/index.tsx | No | Store `referral_code` cookie/localStorage | useReferralStorage |
| `/privacy-policy` | pages/privacy-policy/index.tsx | No | Static | — |
| `/chat-mobile` | pages/chat-mobile/index.tsx | No | Salesforce live chat (mobile) | LiveChatMobile |
| `/member/menus` | pages/member/menus.tsx | AuthCheck | Member menu | AccountLayout |
| `/member/profile` | pages/member/profile/index.tsx | AuthCheck (AccountLayout) | Edit name/DOB/phone/email | modules/my-profile |
| `/member/profile/success` | pages/member/profile/success.tsx | ⚠️ none found | Profile update success | PaperAlert |
| `/member/policy` | pages/member/policy/index.tsx | AuthCheck (AccountLayout) | My policies list (tabs by product) | useMyInsurance, ClaimDialog |
| `/member/policy/[_car]` | pages/member/policy/[_car]/index.tsx | AuthCheck (AccountLayout) | Policy detail by group (getStaticProps/paths) | modules/my-insurance |
| `/member/policy/[_car]/summary` | .../summary/index.tsx | AuthCheck (AccountLayout) | Policy summary | SummaryPolicy |
| `/member/policy/[_car]/summary/send-request` | .../send-request/index.tsx | AuthCheck | Endorsement / change request | SendRequest (policy_transaction) |
| `/member/policy/[_car]/summary/send-request/success` | .../success.tsx | AuthCheck | Request success | PaperAlert |
| `/member/policy/endorsement` | pages/member/policy/endorsement/index.tsx | ⚠️ no guard found | Endorsement form (PA/Home/TA) | BasicEndorsementForm |
| `/member/policy/endorsement/status` | .../status.tsx | ⚠️ no guard found | Endorsement status | EndosementStatus |

### 2.2 Motor voluntary (car insurance) & compulsory (ACT/CMI)
| URL path | File | Auth | Purpose | Main components |
|---|---|---|---|---|
| `/shopping/car-insurance` | pages/shopping/car-insurance/index.tsx | Soft | Car selection + premium plans + lead form | ShoppingTabs, FormPayment, CheckPermim |
| `/shopping/car-insurance/success` | .../success.tsx | No | "Contact back" success | PaperAlert |
| `/shopping/compulsory` | pages/shopping/compulsory/index.tsx | No | ACT vehicle type selector | vehicle-selector |
| `/shopping/compulsory/fuel-hybrid` | .../fuel-hybrid/index.tsx | No | ACT fuel/hybrid category list | loadActPremium |
| `/shopping/compulsory/fuel-hybrid/[code]` | .../fuel-hybrid/[code]/index.tsx | No | ACT car detail by code | — |
| `/shopping/compulsory/fuel-hybrid/[code]/insurance` | .../[code]/insurance.tsx | No | ACT options / insured car | act/options-insurance/CardInsurance |
| `/shopping/compulsory/ev` | .../ev/index.tsx | No | ACT EV list | — |
| `/shopping/compulsory/ev/[code]` | .../ev/[code]/index.tsx | No | ACT EV detail | — |
| `/shopping/compulsory/ev/[code]/insurance` | .../ev/[code]/insurance.tsx | No | ACT EV options | CardInsurance |
| `/purchase/car-insurverse` | pages/purchase/car-insurverse/index.tsx | Soft / Renew-bypass | Purchase summary (lead, promo, OTP phone) | modules/purchase |
| `/purchase/car-insurverse/promotions` | .../promotions.tsx | No | Promotion list | PromotionPage |
| `/purchase/payment/term-and-condition` | pages/purchase/payment/term-and-condition/index.tsx | Soft | T&C + payment consent | purchase/term-and-condition/TermAndCondition |
| `/purchase/payment` | pages/purchase/payment/index.tsx | Soft | Select payment method → 2C2P redirect | FormPaymentSelect |
| `/purchase/payment/payment_success` | .../payment_success.tsx | No | Motor payment result (check-payment) | SuccessPayment |
| `/purchase/payment/payment-success` | .../payment-success.tsx | No | Payment result (TA-inbound target of `/api/payment/callback`) | PaymentSuccessNational |
| `/policy` | pages/policy/index.tsx | ⚠️ none in page | Post-payment policy owner/vehicle form + OCR | modules/policy/PolicyMain |
| `/policy/success` | pages/policy/success.tsx | No | Policy submitted | SuccessContainer |
| `/confirm-policy` | pages/confirm-policy/index.tsx | No | Confirm motor/ACT policy by `confirmNo` | ConfirmPolicyPage |
| `/car-inspection` | pages/car-inspection/index.tsx | No (login redirect commented out) | Car inspection landing | modules/car-inspection |
| `/car-inspection/vehicle-inspection` | .../vehicle-inspection.tsx | No | Photo capture (car detect) | CarImages |
| `/car-inspection/success` | .../success.tsx | No | Done | PurchaseLayout |
| `/accessories-inspection` | pages/accessories-inspection/index.tsx | No | Accessories inspection landing | modules/accessories-inspection |
| `/accessories-inspection/vehicle-inspection` | .../vehicle-inspection.tsx | No | Photo capture | AccessoriesImages |
| `/accessories-inspection/success` | .../success.tsx | No | Done | PurchaseLayout |
| `/ekyc` | pages/ekyc/index.tsx | No | eKYC landing | CardEkyc, EkycSuccess |
| `/ekyc/form` | pages/ekyc/form.tsx | No | eKYC OCR + face recog + form | modules/ekyc/Tap |

### 2.3 Renewal
| URL path | File | Auth | Purpose | Main components |
|---|---|---|---|---|
| `/renew/car-insurverse` | pages/renew/car-insurverse/index.tsx | AuthCheck / Renew-bypass | Renewal landing (policy renewal lookup) | RenewContainer |
| `/renew/car-insurverse/edit-renew` | .../edit-renew.tsx | No | Edit renewal coverage | ShoppingTabs, useRenewPremiumService |
| `/renew/car-insurverse/promotions` | .../promotions.tsx | No | Promotions | — |
| `/renew/car-insurverse/confirm-driver-info` | .../confirm-driver-info.tsx | No | Confirm driver | ConfirmDriverInfo |
| `/renew/car-insurverse/confirm-insurance-info` | .../confirm-insurance-info/index.tsx | No | Confirm insured info | renew/insurance-Info |
| `/renew/car-insurverse/confirm-insurance-info/success` | .../success.tsx | No | Success | SuccessContainer |
| `/renew/car-insurverse/summary` | .../summary.tsx | AuthCheck / Renew-bypass | Summary | SummaryPolicyContainer |
| `/renew/car-insurverse/term-and-condition` | .../term-and-condition.tsx | AuthCheck / Renew-bypass | T&C | renew/term-and-condition |
| `/renew/car-insurverse/payment` | .../payment/index.tsx | AuthCheck / Renew-bypass | Payment | renew/payment/FormPaymentSelect |
| `/renew/car-insurverse/purchase/payment_success` | .../purchase/payment_success.tsx | AuthCheck / Renew-bypass | Payment status | StatusContainer |
| `/renew/car-insurverse/purchase/select-delivery` | .../purchase/select-delivery.tsx | AuthCheck / Renew-bypass | Policy delivery choice | ReceivingPolicyContainer |
| `/renew/car-insurverse/purchase/select-delivery-success` | .../select-delivery-success.tsx | AuthCheck / Renew-bypass | Done | ReceivingPolicySuccess |
| `/renew/compulsory` | pages/renew/compulsory/index.tsx | No | ACT renewal | modules/renew/compulsory |
| `/renew/compulsory/summary` | .../summary.tsx | No | ACT renewal summary | SummaryPolicyAct |
| `/renew/compulsory/term-and-condition` | .../term-and-condition.tsx | AuthCheck / Renew-bypass | T&C | TermAndCondition |
| `/renew/compulsory/payment` | .../payment.tsx | AuthCheck / Renew-bypass | Payment | FormPaymentSelect |
| `/renew/compulsory/purchase/payment_success` | .../purchase/payment_success.tsx | AuthCheck / Renew-bypass | Status | StatusContainer |
| `/renew/compulsory/purchase/select-delivery` | .../purchase/select-delivery.tsx | AuthCheck / Renew-bypass | Delivery | ReceivingPolicyContainer |

### 2.4 Travel (outbound TA, inbound TA, partner, legacy)
| URL path | File | Auth | Purpose | Main components |
|---|---|---|---|---|
| `/shopping/travel` | pages/shopping/travel/index.tsx | No | Trip info (travel-multi) | TripSelectType, useLeadInfo |
| `/shopping/travel/select-package` | .../select-package.tsx | No | Choose TA package | SelectPackageSize |
| `/shopping/travel/traveler-info` | .../traveler-info.tsx | No | Traveller basic info | BasicTravelerInfoForm |
| `/shopping/travel/fullfillment` | .../fullfillment.tsx | Soft | Full traveller details (OCR passport) | BasicFullfillmentForm |
| `/shopping/travel/summary` | .../summary.tsx | No | Summary | NewSummaryDetails |
| `/shopping/travel/payment/term-and-condition` | .../payment/term-and-condition/index.tsx | Soft | T&C + consent | travel/purchase/TermAndCondition |
| `/shopping/travel/payment` | .../payment/index.tsx | No | Payment | travel/purchase/FormPaymentSelect |
| `/shopping/travel/payment/payment-success` | .../payment-success/index.tsx | No | Result | travel-multi/purchase/PaymentSuccess |
| `/shopping/travel/partner/[partner]/payment/payment-success` | .../partner/[partner]/payment/payment-success/index.tsx | No | Partner payment result | travel-partner PaymentSuccess |
| `/shopping/inbound-travel` (+ `/select-package`, `/traveler-info`, `/fullfillment`, `/summary`, `/payment`, `/payment/term-and-condition`, `/payment/payment-success`) | pages/shopping/inbound-travel/* (8 files) | Same pattern as TA | Inbound (foreigner) TA flow | TripSelectNationalType, *National components |
| `/partner/[partner]/travel` (+ `/select-package`, `/fullfillment`, `/summary`, `/payment`, `/payment/term-and-condition`) | pages/partner/[partner]/travel/* (6 files) | Same pattern | Partner-branded TA (e.g. rabbitcare) | modules/travel-partner |
| `/shopping/travel_discard/*` (9 files) | pages/shopping/travel_discard/* | Same | ⚠️ Legacy/discarded TA flow still routable | modules/travel |
| `/download-doc-ta-vacay` | pages/download-doc-ta-vacay/index.tsx | No (OTP) | Download TA policy doc via OTP | DownloadDocTaVacayMain |
| `/confirm-policy/ta`, `/confirm-policy/ta-inbound` | pages/confirm-policy/ta*.tsx | No | Confirm TA policy by confirmNo | PolicyConfirmStatus* |

### 2.5 Personal accident & Home
| URL path | File | Auth | Purpose | Main components |
|---|---|---|---|---|
| `/shopping/personal-accident` | .../personal-accident/index.tsx | No | DOB / start | dateOfBirthForm, usePaLead |
| `/shopping/personal-accident/select-package` | .../select-package.tsx | No | Package | select-package |
| `/shopping/personal-accident/healthcheck` | .../healthcheck.tsx | No | Health questions | healthcheck |
| `/shopping/personal-accident/fullfillment` | .../fullfillment.tsx | Soft | Insured details | BasicFullfillmentForm |
| `/shopping/personal-accident/summary` | .../summary.tsx | No | Summary | SummaryDetails |
| `/shopping/personal-accident/payment` (+ `/term-and-condition`, `/payment-success`) | .../payment/* | No | Payment / T&C / result | PA purchase components |
| `/shopping/home` | pages/shopping/home/index.tsx | No | Residential info | ResidentialInfoForm |
| `/shopping/home/select-package` | .../select-package.tsx | No | Main coverage | MainCoverageForm |
| `/shopping/home/fullfillment` | .../fullfillment.tsx | Soft | Owner + building address | FullfillmentForm, BuildingAddressDetailForm |
| `/shopping/home/summary` | .../summary.tsx | No | Summary | SummaryDetails |
| `/shopping/home/payment` (+ `/term-and-condition`, `/payment-success`) | .../payment/* | No | Payment / T&C / result | home purchase components |
| `/confirm-policy/personal-accident`, `/confirm-policy/home` | pages/confirm-policy/*.tsx | No | Confirm policy by confirmNo | PolicyConfirmStatus |

### 2.6 Shopee partner forms
| URL path | File | Auth | Purpose | Main components |
|---|---|---|---|---|
| `/form/act/shopee` | pages/form/act/shopee/index.tsx | No | Shopee ACT (CMI) policy form | ActFormContent |
| `/form/act/shopee/term-and-condition` | .../term-and-condition.tsx | No | T&C + submit | ActTermAndCondition |
| `/form/act/shopee/success`, `/fail` | .../success.tsx, fail.tsx | No | Result | SuccessPage / FailPage |
| `/form/mv/shopee` | pages/form/mv/shopee/index.tsx | No | Shopee voluntary motor form | MvShopeeFormContent |
| `/form/mv/shopee/term-and-condition` | .../term-and-condition.tsx | No | T&C + submit | MvTermAndCondition |
| `/form/mv/shopee/car-not-covered`, `/success`, `/fail` | .../*.tsx | No | Result / not covered | — |

### 2.7 Redirects (next.config.js, 301)
`*-2c2p` legacy return URLs → non-2c2p equivalents (e.g. `/purchase/payment/payment_success_2c2p` → `/purchase/payment/payment_success`, same for travel/PA/home/renew/compulsory).
Global headers: `X-Frame-Options: DENY`, `CSP: frame-ancestors 'none'`.

---

## 3. Next.js API routes / middleware

No `middleware.ts`, no server actions, no `app/` route handlers.

| Method | Path | File | What it does | Proxies to |
|---|---|---|---|---|
| POST | `/api/payment/callback?lead=&invoiceNo=&type=` | src/pages/api/payment/callback.ts | Converts gateway POST-back into **303 redirect** to `/purchase/payment/payment-success?lead=&invoiceNo=&type=` (default type `TA-INBOUND`). Other methods → 405. | Nothing (redirect only) |
| GET | `/api/time/now` | src/pages/api/time/now.ts | Returns `{year,month,day,iso}` in Asia/Bangkok | Nothing |

⚠️ `useServerNowQuery` calls `/api/time/now` through the shared axios instance whose `baseURL` is `API_BASE_URL`, so the request goes to the **API gateway host**, not this Next route — unless the gateway also serves it. Unverified.
⚠️ API routes only work when served by the Node standalone server (Docker); they do not exist on a static/Cloudflare Pages export.

---

## 4. Backend API calls

HTTP layer: `src/utils/axios.ts` (single axios instance, `baseURL=API_BASE_URL`; 401 → clear token + redirect `/login` except in renew mode). Services live in `src/services/<domain>/use*.ts` as react-query hooks. Bearer token is set globally by `AuthorizationProvider` (`axios.defaults.headers.common.Authorization`).
Exceptions using raw `axios` (no baseURL / no global token): `consent-service` (builds `API_BASE_URL + /api/v1/consent` and passes its own Bearer from `/consent/access/{flow}`), `analytics-service/useGetIPService` (external `https://geolocation-db.com/json/`), `utils/data-analytics.ts` (pokeapi demo).

**Command-style endpoints**: `/api/v1/premium/premiumAPI`, `/api/v1/premium/actAPI`, `/api/v1/premium/taAPI` take `{ fn: '<name>', data: {...} }`. The `fn` is listed in the table.

Target service is inferred from the path prefix and from grepping `/Users/kritsanawathaniyanon/Code/Go` for the route (⚠️ = weak match):

| Prefix | Inferred backend |
|---|---|
| `/api/v1/auth` | go-echo-auth-service ⚠️ (uam also matches) |
| `/api/v1/uam` | go-echo-uam-service |
| `/api/v1/premium` | nodejs-express-premium-service (premiumAPI/actAPI/taAPI routing.service.js) |
| `/api/v1/purchase` | go-echo-purchase-service |
| `/api/v1/core` | go-echo-core-service |
| `/api/v1/home` | go-echo-home-service |
| `/api/v1/pa` | go-echo-pa-service |
| `/api/v1/ta` | go-echo-ta-service |
| `/api/v1/iia` | node_iia_service |
| `/api/v1/consent` | go-echo-consent-service |
| `/api/v1/sf` | go-echo-saleforce-service |
| `/api/v1/file` | go-echo-file-service |
| `/api/v1/analytics` | go-echo-analytics-service |
| `/api/v1/policy` | go-fiber-policy-service (`/oic/driver_behavior` route found) ⚠️ |
| `/api/v1/isv-test` | isv-test (Go repo `isv-test`) |

### 4.1 Call table (141 call sites, ~100 distinct endpoints)

| Page / feature | Method | Backend path | Service | Req/Resp type (service file) |
|---|---|---|---|---|
| Login | POST | /api/v1/auth/login | auth | `{email, hashpassword}` → `LoginData` (auth-service/useAuthService) |
| Autologin | POST | /api/v1/auth/auto_login_token_check | auth | `{token}` → `AutoLoginTokenCheck` |
| Current user (global) | POST | /api/v1/uam/get_user | uam | `{id}` → `UserData` |
| Register | POST | /api/v1/uam/registeraccount_email | uam | `RegisterData` |
| Register (SSO/Firebase) | POST | /api/v1/uam/registeraccount_sso | uam | `SSOData` (useSSOService) |
| Auto-create account in shopping | POST | /api/v1/uam/registeraccount_email_auto | uam | (usePremiumShoppingService.useCreateAccountMutation) |
| Register / purchase OTP | POST | /api/v1/uam/validate_email, validate_email_otp, validate_phone, validate_phone_otp | uam | ValidateEmailData / ValidateEmailOTPData / ValidatePhoneData |
| Forgot / new password | POST | /api/v1/uam/forget_password, update_password, check_update_password | uam | ForgotPasswordData / NewPasswordData / CheckUpdatePassword |
| Profile edit | POST | /api/v1/uam/update_profile_name, update_profile_dob, update_profile_phone | uam | UpdateProfile*Data |
| Profile change email | POST | /api/v1/uam/edit_email_validate_password, edit_email_validate_ref, edit_email_validate_otp | uam | (my-profile/useMyProfileService) |
| Car premium check (shopping) | POST | /api/v1/premium/premiumAPI `fn=loadPremium` | premium | → `PremiumData` |
| Car lead save / update | POST | premiumAPI `fn=saveLeadCoveragePremium`, `updateLeadCoveragePremium`, `saveLeadCoveragePremiumPostPayment`, `saveBudgetLeadCoveragePremium`, `checkBudgetPremium` | premium | `PurchaseData` / `LeadCoverageData` |
| Purchase summary lead | POST | premiumAPI `fn=getLeadCoveragePremium`, `getLeadCoveragePremiumRenewal`, `calculatePromocode` | premium | `GetPurchaseData` / `GetPromoCodeData` |
| Contact-back lead | POST | premiumAPI `fn=dropLeadBudget` | premium | (useContactBackService) |
| Cross-expire check | POST | premiumAPI `fn=checkCrossExpireDate` | premium | (useCheckPremiumCross) |
| Renew edit | POST | premiumAPI `fn=updateEditInfoLeadCoveragePremium`, `saveLeadRenew` | premium | `PurchaseData` / `SaveLeadRenewData` |
| Promotions | GET | /api/v1/premium/promotions-list | premium | `PromotionListResponse` |
| ACT (compulsory) | POST | /api/v1/premium/actAPI `fn=loadActPremium, loadBrand, loadModel, loadModelYear, saveLeadActPremium, updateLeadActPremium, getLeadActPremium, updateReferalCodeLeadActPremium, submitActPolicy` | premium | PremiumActData / ActLoad*Type / SaveActLoadType / SubmitActPolicyResponse (act-service/useActService) |
| TA packages / lead | POST | /api/v1/premium/taAPI `fn=loadATPackage, getLeadTA, upsertLeadTA` | premium | PackageDataResponse / LeadResponse / SaveFullFillmentResponse |
| TA-multi lead | GET / POST | /api/v1/ta/getleadta/{leadTaNo}, /api/v1/ta/upsertleadta | ta | LeadResponse / SaveFullFillmentResponse |
| TA countries / states | POST | /api/v1/uam/get_ta_country, /api/v1/uam/get_ta_state | uam | CountryRawResponse / StateRawResponse |
| PA premium / lead | GET / POST | /api/v1/pa/premium, /api/v1/pa/getleadpa/{no}, /api/v1/pa/upsertleadpa | pa | premiumResponseType / LeadResponse / SaveFullFillmentResponse |
| Home premium / lead | GET / POST | /api/v1/home/premium, /api/v1/home/getleadhome/{no}, /api/v1/home/upsertleadhome | home | premiumResponseType / LeadResponse / SaveFullFillmentResponse |
| Motor payment | POST | /api/v1/purchase/create-payment, check-payment | purchase | `CreatePaymentData` (→ `webPaymentUrl`) / `CheckPaymentData` |
| ACT payment | POST | /api/v1/purchase/create-payment-act, check-payment-act | purchase | CreatePaymentDataAct / CheckPaymentDataAct |
| TA payment | POST | /api/v1/purchase/create-payment-ta, check-payment-ta | purchase | CreatePaymentDataResponse / CheckPaymentResponse |
| PA / Home payment | POST | /api/v1/purchase/create-payment-tran, check-payment-tran | purchase | (payment-service-diy/usePayment) |
| Renewal payment | POST | /api/v1/purchase/create-payment-renewal | purchase | CreatePaymentData |
| Payment check by invoice (TA/PA/Home success pages) | POST | /api/v1/isv-test/payment/check | isv-test | CheckPaymentByInvoiceResponse |
| Renewal check | POST | /api/v1/isv-test/payment/check-renewal | isv-test | CheckRenewalResponse |
| Renewal policy lookup | POST | /api/v1/uam/get_policy_renewal | uam | GetPolicyRenewData |
| Post-payment policy form | POST | /api/v1/uam/create_policy_form | uam | CreatePolicyResponse (policy-service) |
| Policy form OCR | POST | /api/v1/uam/ocr_thai_driving_license_card, ocr_car_registration_book, ocr_service, get_ocr_service | uam | OcrIdCardData / OcrIdCarReg / FileImportOcrData |
| eKYC | POST | /api/v1/uam/ocr_service, ocr_reader_service, ocr_passport_reader_service, facerecog_service, ekyc_formsubmit | uam | OCRData / OCRReaderType / FaceRecogData / FormSubmitData |
| Upload doc | POST | /api/v1/uam/upload_base64_to_gcp | uam | UploadFileGCPData |
| AMLO blacklist | POST | /api/v1/uam/check_amlo_blacklist | uam | (useCheckAmloService) |
| Car color / cars / occupation / menu | GET | /api/v1/core/get-car-color, get-all, get-pwa-occupation, get-menu | core | CarColorResponse / GetCarAll / GetPwaOccupationResponse / GetMenuResponse |
| My policies | GET | /api/v1/core/get-policy | core | MyInsuranceData |
| Policy change request | POST | /api/v1/uam/policy_transaction | uam | (useInsuranceService) |
| Endorsement request | POST | /api/v1/pa/requestendorse, /api/v1/home/requestendorse, /api/v1/iia/ta/request_endorse | pa / home / iia | RequestEndosementResponse |
| Confirm policy (motor/ACT) | GET | /api/v1/core/load-policy-info, load-caract-info, confirm-policy, confirm-caract `?confirmNo=` | core | ResultData |
| Confirm policy (TA/PA/Home) | GET | /api/v1/core/load-ta-info, confirm-ta, load-pa-info, confirm-pa, load-home-info, confirm-home `?confirmNo=` | core | PolicyResponse / ConfirmPolicyResponse |
| Car inspection | GET / POST | /api/v1/core/check-car-inspection, /api/v1/core/submit-car-inspection | core | CarCheckInspectionData / SubmitCarInspectionData |
| Car inspection photos | POST | /api/v1/file/upload, /api/v1/file/uploadbase64, /api/v1/file/uploadbase64/cardetect | file | UpdateFileInspectionData / UpdateCarInspectionData |
| Consent (T&C dialogs) | POST / GET | /api/v1/consent/access/{flow}, /purpose, /data-subject, /consent-receipt, /consent-receipt-group, /purpose/payment, /consent-receipt/payment, /consent-receipt/payment-group | consent | AccessTokenResponse / CollectionPointResponse / ConsentReceipt*Response |
| Shopping lead popup | POST | /api/v1/isv-test/consent/save, /api/v1/isv-test/consent/request-contact | isv-test | SaveConsentResponse / RequestContactResponse |
| Shopee ACT | POST | /api/v1/isv-test/shopee/validate_policy_form, /api/v1/isv-test/oauth/token (submit, 120 s timeout) | isv-test | ValidatePolicyFormResponse / SubmitActPolicyNewResponse |
| Shopee MV | POST | /api/v1/isv-test/mv/submit, /api/v1/isv-test/oauth/consent-details | isv-test | SubmitMVPolicyResponse |
| Date limit | POST | /api/v1/isv-test/check_date_limit `fn=checkDateLimit` | isv-test | DateLimitResponse |
| Salesforce master / chat hours | POST / GET | /api/v1/sf/saleforceControllerAPI `fn=getMotorMaster`, /api/v1/sf/businesshr | sf | SaleforceMasterData / BusinessHourResponse |
| OIC driver behaviour | POST | /api/v1/policy/oic/driver_behavior | policy (go-fiber-policy-service) ⚠️ | DriverBehaviorResponse |
| TA doc download | POST | /api/v1/uam/policy_doc_request_otp, policy_doc_download | uam | (no Bearer, OTP-based) |
| Priceza tracking | POST | /api/v1/isv-test/priceza_log, /api/v1/premium/taAPI | isv-test / premium | PricezaLogResponse / PricezaLeadResponse |
| Analytics | POST | /api/v1/analytics/analytics | analytics | (useGBQService) |
| Server time | GET | /api/time/now | ⚠️ see §3 | ServerNow |
| External | GET | https://geolocation-db.com/json/ (IP), https://pokeapi.co (demo) | 3rd party | — |

---

## 5. Auth flow

1. **Login** (`/login` → `components/authorization/login/Login.tsx`): `POST /api/v1/auth/login {email (lower-cased), hashpassword}`. Note: the field is named `hashpassword` but the form sends the **plain password** (⚠️ no client hashing seen).
2. **Token storage**: `localStorage['access-token'] = {id, token}` (`hooks/storage/access-token.ts`). User profile from `get_user` is stored in Redux `auth.userData` and in cookies `users` (domain-wide, e.g. `.insurverse.co.th`) and `users-isv` (`utils/cookies/users.ts`). Cookie `SessionId` is also removed on logout.
3. **Attach token**: `AuthorizationProvider` (in `_app.tsx`) sets `axios.defaults.headers.common.Authorization = Bearer <token>` on every render; it also prefetches `useUserQuery` (`POST /api/v1/uam/get_user {id}`).
4. **After login**: redirect to `?callback_url`, else `/?page`, else `PATH_MENU_BASE_URL`.
5. **Social login**: Firebase `GoogleAuthProvider` / `FacebookAuthProvider` (`utils/firebase`) → `POST /api/v1/uam/registeraccount_sso` (useSSOCombineAutoLogin). **Auto-login**: `/autologin?token=` → `POST /api/v1/auth/auto_login_token_check`.
6. **Refresh**: none. There is no refresh-token logic; a 401 from any call clears storage and hard-redirects to `/login` (skipped while in renew mode).
7. **Route guards**: client-side only. `AuthCheck` (dynamic, `ssr:false`) wraps member pages (via `AccountLayout`) and renew pages; it redirects to `/login?callback_url=<asPath>` when Redux `userData` is empty. Renew pages bypass it (`?renew=true` or sessionStorage flags). Purchase/payment pages have no guard but push to `/login` from some buttons (FormPayment, FormPaymentSummary).
8. **Roles/permissions**: none on the customer app.
9. **Logout**: `/logout` → Redux `setLogout()` → redirect to `PATH_MENU_BASE_URL`.

---

## 6. Main user flows

### 6.1 Voluntary motor (car insurance): quote → lead → payment → policy
1. `/shopping/car-insurance`: pick car (`GET /api/v1/core/get-all`), get plans (`premiumAPI fn=loadPremium`), OIC driver behaviour (`/api/v1/policy/oic/driver_behavior`).
2. Save lead (`premiumAPI fn=saveLeadCoveragePremium` / `saveBudgetLeadCoveragePremium`), optional auto-account (`uam/registeraccount_email_auto`), consent (`isv-test/consent/save`) → `/purchase/car-insurverse`.
3. `/purchase/car-insurverse`: load lead (`premiumAPI fn=getLeadCoveragePremium`), promotions (`premium/promotions-list`, `fn=calculatePromocode`), cross-expiry (`fn=checkCrossExpireDate`), phone OTP (`uam/validate_phone`, `validate_phone_otp`), `isv-test/payment/check-renewal`.
4. `/purchase/payment/term-and-condition`: consent (`consent/access`, `consent/purpose/payment`, `consent/consent-receipt/payment`).
5. `/purchase/payment`: `POST /api/v1/purchase/create-payment` (or `create-payment-act` for ACT / bundle; `create-payment-renewal` in renew mode) → browser goes to `webPaymentUrl` (2C2P).
6. Return → `/purchase/payment/payment_success?lead=&invoiceNo=&type=`: `purchase/check-payment` (or `check-payment-act`).
7. `/policy`: owner/driver/vehicle form with OCR (`uam/ocr_*`, `core/get-car-color`, `core/get-pwa-occupation`) → `POST /api/v1/uam/create_policy_form` → `/policy/success` → `/member/policy`.
8. Later: `/confirm-policy?confirmNo=` (`core/load-policy-info` + `core/confirm-policy`), car inspection pages (`core/check-car-inspection`, `file/uploadbase64/cardetect`, `core/submit-car-inspection`).

### 6.2 Compulsory (ACT / CMI)
1. `/shopping/compulsory` → `/fuel-hybrid` or `/ev` (`actAPI fn=loadActPremium`) → `/[code]/insurance` (`actAPI fn=loadBrand/loadModel/loadModelYear`, `isv-test/check_date_limit`, `/api/time/now`).
2. Save lead (`actAPI fn=saveLeadActPremium` / `updateLeadActPremium`) → `/purchase/car-insurverse` (`fn=getLeadActPremium`) → T&C → `/purchase/payment` (`purchase/create-payment-act`) → 2C2P → `payment_success` (`check-payment-act`) → `/policy`.

### 6.3 Travel (TA outbound; inbound and partner are the same shape)
1. `/shopping/travel` (countries `uam/get_ta_country`) → `/select-package` (`taAPI fn=loadATPackage`) → `/traveler-info` → `/fullfillment` (`ta/upsertleadta`, OCR passport) → `/summary` (`ta/getleadta/{no}`).
2. `/payment/term-and-condition` (consent payment-group) → `/payment` (`purchase/create-payment-ta` → 2C2P) → `/payment/payment-success` (`isv-test/payment/check` and/or `purchase/check-payment-ta`).
3. Inbound variant may return via `POST /api/payment/callback` → 303 → `/purchase/payment/payment-success`.

### 6.4 Personal accident / Home
`/shopping/{personal-accident|home}` (`pa|home/premium`) → select-package → (PA healthcheck) → fullfillment (`pa/upsertleadpa` | `home/upsertleadhome`) → summary (`getleadpa|getleadhome`) → T&C → payment (`purchase/create-payment-tran` → 2C2P) → payment-success (`isv-test/payment/check`, `check-payment-tran`, Priceza tracking).

### 6.5 Renewal
Link to `/renew/car-insurverse?renew=true...` (no login needed in renew mode) → `uam/get_policy_renewal` → confirm driver/insurance info → summary → T&C → payment (`purchase/create-payment-renewal`) → `purchase/payment_success` → select-delivery. ACT renewal goes through `/renew/compulsory/*` with `actAPI` + `create-payment-act`.

### 6.6 Shopee partner forms
`/form/act/shopee?order_sn=...` → validate (`isv-test/shopee/validate_policy_form`) → T&C → submit (`isv-test/oauth/token`, 120 s) → success/fail.
`/form/mv/shopee` → validate → T&C → `isv-test/mv/submit` (+ `isv-test/oauth/consent-details`) → success/fail/car-not-covered.

### 6.7 Member area
`/member/policy` (`core/get-policy`) → `[_car]` → summary → send-request (`uam/policy_transaction`, `uam/upload_base64_to_gcp`, `uam/check_amlo_blacklist`); endorsement (`pa|home/requestendorse`, `iia/ta/request_endorse`); profile edits (`uam/update_profile_*`, `edit_email_*`).

---

## 7. Notes / ⚠️ unverified items

- ⚠️ The backend service names are inferred from path prefixes and a grep of `~/Code/Go`; the gateway/ingress routing was not read.
- ⚠️ `/api/v1/isv-test/*` is used by production code paths (payment check, Shopee, consent, priceza, date limit). Check this is intended for prod.
- ⚠️ `useGBQService.ts` has a **hard-coded Bearer token** in source for `/api/v1/analytics/analytics` (value not copied here). Rotate it and move it to config.
- ⚠️ `ENCRYPTION_*` and Firebase/Chat keys are inlined into the client bundle via `next.config.js env`.
- ⚠️ Login sends the plain password in the `hashpassword` field.
- ⚠️ `/member/policy/endorsement*`, `/member/profile/success` and `/policy` have no `AuthCheck` in the page file (they may rely on API 401 only).
- ⚠️ `/api/time/now` is probably called on the API host (baseURL), not on the Next route.
- `shopping/travel_discard/*` and `pokemon-service` / `utils/data-analytics.ts` (pokeapi) look like dead or demo code but are still routable/bundled.
- `next.config.js` sets `eslint.ignoreDuringBuilds` and `typescript.ignoreBuildErrors = true`.
- There are no automated tests besides a Selenium `testISV.side` script.
