# go-echo-uam-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-uam-service` (Go module `insurverse_uam`).
> Generated from route registration (`main.go`, `router/router.go`) and handler code in `controllers/`. `docs/docs.go` / `swagger/docs.go` were not used as a source of truth.
> Spec date: 2026-09-23. Read-only analysis; nothing was executed.
> FX-02 (2026-09-24): updated from branch `fix/fx-02-uam` — `registeraccount_email_auto` response, `ocr_passport_reader_service` error body, CMI realtime pre-send validation (7 OIC fields), DB pool env vars, in-cluster `Backend_Notification` (helm-prod), SF account `mobilePhone` fallback.

---

## Overview (ภาพรวม)

| Item | Value |
|---|---|
| Purpose | "User Access Management" service for Insurverse. In practice it is a catch-all service: customer account (register / verify / OTP / password reset / profile / SSO link), motor policy issuance after payment (`create_policy_form`), CMI realtime (OIC พ.ร.บ.) and IIA (SOAP) submission, IIA auto-endorse (RY05…RY28), Salesforce sync (account / policy / attachments / claim / lead), AMLO blacklist check, e-KYC (YIP / Eikonnex OCR, face recognition, passport MRZ), master data (geo, car model, TA country/state), public TA policy-document download. |
| Framework | Go 1.22 + Echo v4.11.1, `sqlx` + `lib/pq` (PostgreSQL). Raw SQL only. Firebase Admin SDK (SSO ID-token check), GCS (`cloud.google.com/go/storage`), reCAPTCHA Enterprise client. |
| Port | `HTTP_PORT` env (default `8080`). Helm `containerPort: 8080`. |
| Base path | `/api/v1/uam/` (`constant.API_V_SERVICE`). One route is registered **without** `api/`: `/v1/uam/decrypt_lead_no` (Echo adds the leading `/`). `/healthcheck` is at the root. |
| DB schema | `insurverse` (PostgreSQL). `Login` also reads `public.users`. Pool: max open 80, max idle 10 (FX-02: overridable via `DB_MAX_*` / `DB_CONN_*` env vars, see below). |
| Response envelope | Mostly `models.JsonReturn` → `{ "title": string, "status": int, "description": string, "result": any }`. Salesforce-style replies use `JsonReturn_SF` (`timeStamp, statuscode, message, accountId, policyNumber, fileId …`). Some errors are plain text (`c.String`) or `{"error": "..."}` (JWT middleware). |
| Startup | `recaptchaenterprise.NewClient(key.json)` (fatal on error) → `constant.Load_Env()` → `PostgresConn` → `GCPConnect` (`key.json`) → `FirebaseConnect` → `SalesforceConn` (token fetched with retry) → routes. |

### Environment variables (names only / ชื่อตัวแปรเท่านั้น)

Read by `constant.Load_Env()` (`ENV` = `LOCAL` or empty → loads `local.env`; `dev`/`uat`/`prod` switch some built-in defaults, e.g. email lists):
`ENV`, `HTTP_PORT`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASS`, `DB_NAME`, `Recaptcha_Key`, `ProjectID`, `Base_Url`, `Backend_Doc`, `Backend_Auth`, `Backend_Core`, `Backend_File`, `Backend_Notification`, `Backend_Purchase`, `Backend_Premium`, `Backend_Saleforce`, `Url_Fontend` (typo is in the code), `SF_EndPoint`, `SF_ClientID`, `SF_ClientSecret`, `SF_UserName`, `SF_Password`, `Token_EKYC_Face_Recognition`, `Token_EKYC_Ocr`, `Token_YIP_PassportMRZ`, `URL_YIP_OCRService`, `URL_YIP_FaceRecogService`, `URL_YIP_Passport`, `URL_CMI_Realtime_Policy`, `URL_CMI_Realtime_Policy_Endorse`, `Url_IIA`, `URL_Eikonnex_Ocr_Book`, `Token_Car_Registration_Book`, `URL_Eikonnex_Ocrservice_Driving`, `Token_Driving_License`, `GCS_BUCKET`, `KUBS_IP` (CIDR for `RestrictIPs`), `ENC_KEY`, `IV` (AES-256 lead-number encryption).
DB pool (FX-02 (2026-09-24), read in `webserver/dbConnect.go`; unset / invalid / non-positive → default): `DB_MAX_OPEN_CONNS` (default `80`), `DB_MAX_IDLE_CONNS` (`10`), `DB_CONN_MAX_LIFETIME` (Go duration, `1h`), `DB_CONN_MAX_IDLE_TIME` (`30m`). Defaults equal the previous hard-coded values.
FX-02 (2026-09-24): `helm/helm-prod.yaml` `Backend_Notification` now points in-cluster to `http://backend-notification-service:8080/api/v1/notification/` (was the public `https://api.insurverse.co.th/...` URL).
Helm also sets `Backend_Analytics`, `Backend_Consent`, `Backend_Uam`, `YIP_EKCY` (not read by `Load_Env` — ⚠️ unverified whether used).

Every variable has a **hard-coded fallback literal** in `constants/constant.go` when the env var is empty (see S1).

### External / third-party calls (การเรียกระบบภายนอก)

| Target | Method + path | Caller |
|---|---|---|
| Internal notification | `POST {Backend_Notification}email` · `sms` · `push_notification_id` | OTP / register / reset / AMLO alert / claim SMS / point notification. FX-02 (2026-09-24): shared HTTP client with a **30 s timeout** (was no timeout). |
| Internal auth | `POST {Backend_Auth}login_sso` (body `{email}`) → returns login tokens | `registeraccount_sso` |
| Internal document | `GET {Backend_Doc}policy/{policyNo}` | `create_policy_form` (`SendPolicyNo`) |
| Internal purchase | `POST {Base_Url_Purchase}update-sf-payment` (`Backend_Purchase_SF_Update`) | `create_policy_form`, `job_update_sfpolicy` |
| Self (loopback) | `POST http://localhost{Port}/api/v1/uam/create_policy_pure` | `car_inspect_step` |
| Salesforce | OAuth password grant `SF_EndPoint`; `POST {instance_url}/services/apexrest/upsertaccount` · `upsertpolicy` · `upsertpolicyattachment` · `upsertpolicyattachmenturl` · `upsertpolicytransaction` · `upsertclaim` · `upsertclaimattachmenturl` · `upsertlead` | SF routes, `create_policy_form`, profile updates |
| OIC CMI realtime | `POST {URL_CMI_Realtime_Policy}` (PKISendPolicyREST) · `{URL_CMI_Realtime_Policy_Endorse}` (PKISendEndorseREST) — plain `http://` IP in the default | `cmi_realtime_service`, `cmi_realtime_endorse_service`, `create_policy_form` |
| IIA (SOAP) | `POST {Url_IIA}IIAGatewayWS/WSToTemp.asmx` (`application/soap+xml`) | `iia_act_service`, `rush_iia`, `create_policy_form` |
| IIA auto-endorse | `POST {Url_IIA}ServiceAutoEndorse/api/import/ry{5,11,17,18,19,20,23,24,28}` (basic credentials from constants) | `ry05`…`ry28` |
| YIP e-KYC | `{URL_YIP_OCRService}`, `{URL_YIP_FaceRecogService}`, `{URL_YIP_Passport}` (token headers) | `ocr_*`, `facerecog_service`, `ocr_passport_reader_service` |
| Eikonnex OCR | `POST {URL_Eikonnex_Ocr_Book}` (car-reg book), `{URL_Eikonnex_Ocrservice_Driving}` (driving licence), multipart | `ocr_car_registration_book`, `ocr_thai_driving_license_card` |
| Google | Firebase `VerifyIDToken`; reCAPTCHA Enterprise `CreateAssessment` (prod only); GCS upload (bucket `GCS_BUCKET`) | SSO, `validate_phone`, uploads |

---

## Auth & Middleware (การยืนยันตัวตน)

Global middleware (`main.go`, added after `router.New`, applied to every route at request time): `middleware.CORS()` (default = allow all origins `*`), `middleware.Secure()`, `middleware.Logger()`, `middlewares.LoggerMiddleware("UAM")`, `middleware.Recover()`. Validator = go-playground `validator.New()` (errors → HTTP 400).

`LoggerMiddleware` writes **every** request (except `/healthcheck` and the 7 OCR routes) to `insurverse.log_internal_interface` (api_name, url, method, **request headers**, **request body**, status). Response body is not logged (`nil`).

Route groups (`router/router.go`):
- `std` group → `middlewares.SanitizeHTML()`: rejects any body containing `<` or `>` with `400 {"title":"What wrong with your request content?"}`.
- `NoSanitizeHTML` group → no sanitising (OCR / e-KYC image routes).

Per-route middleware:

| Middleware | Where | Behaviour |
|---|---|---|
| `middlewares.ValidateToken` | 12 routes marked `JWT` below | Requires `Authorization: Bearer <jwt>`; HS256 with a **hard-coded** key in `middlewares/Validate.go`; checks `exp`; stores claims in the **package-global** `middlewares.JWTClaims` (see S3). Errors: `401 {"error":"Invalid token not found" | "Invalid token" | "Token has expired"}`. The token is issued by another service (auth service ⚠️ unverified); this service's own `Login` signs with a different key and claim (`name`, not `id`), so its tokens do **not** pass `ValidateToken`. |
| `middlewares.CheckID_and_Token(c, id)` | called inside `update_profile_*`, `update_lang` | Re-parses the bearer token and requires `claims["id"] == body.id`. |
| `middlewares.RestrictIPs` | `get_policy_renewal_b2b` | Allows loopback or `c.RealIP()` inside CIDR `KUBS_IP`; else `403 "Access Denied"`. `RealIP()` trusts `X-Forwarded-For` / `X-Real-IP` (no `IPExtractor` configured — S7). |
| `RateLimiterWithConfig(RatelimitEmail)` | `forget_password`, `validate_email`, `edit_email_validate_ref`, `policy_doc_request_otp` | In-memory, per pod; key = JSON `email` in body; rate 1 per 10 min, burst 2. One shared store for all 4 routes. `RatelimitPhone` is declared but never used. |

### Roles / permissions model (บทบาทและสิทธิ์)

**There is no RBAC in this service.** Findings:
- No role/permission tables are read. `sec_user.user_type` is selected by `get_user` and returned, but no handler checks it.
- The JWT claim struct in `middlewares/jwt.go` has `Admin bool`, but it is always `false` and never checked.
- Authorisation is only: (a) "has a valid HS256 token" (`ValidateToken`), and (b) for 4 profile routes, "body `id` equals token `id`" (`CheckID_and_Token`). `get_user` / `get_claim_status_and_history` / edit-email routes take the user id from the token claims only.
- Keycloak code (`controllers/keycloakController.go`, `IntrospectToken`, Keycloak client constants) exists but is **not wired** to any route.
- "Service-to-service" routes (policy issuance, CMI, IIA, Salesforce, AMLO, endorse) have **no auth at all**; they rely on network placement (⚠️ ingress exposure unverified — see S2).
- Business "roles" that do appear are Salesforce participant roles (`Owner`, `Driver_1/2`, `Beneficiary`, `Payer`) inside SF payloads — not access control.
- Email distribution lists `ComplianceEmailList` / `AgentEmailList` (in constants, switched by `ENV`) receive AMLO / agent notifications.

---

## Endpoint Summary

Auth legend: `none` = no auth; `JWT` = `ValidateToken`; `JWT+ID` = `ValidateToken` + `CheckID_and_Token`; `IP` = `RestrictIPs`; `RL` = email rate limit. All `/api/v1/uam/*` routes are `POST` except swagger.

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | `router/router.go:188` `healthcheck` | Returns `OK` |
| 2 | GET | `/api/v1/uam/swagger/*` | none | `echoSwagger.WrapHandler` | Swagger UI |
| 3 | POST | `/api/v1/uam/ocr_car_registration_book` | none (no sanitize) | `controllers/eikonnexController.go:27` `Ocr_Car_Registration_Book` | Eikonnex OCR of car registration book (multipart `file`) |
| 4 | POST | `/api/v1/uam/ocr_thai_driving_license_card` | none (no sanitize) | `eikonnexController.go:120` `Ocr_Thai_Driving_License_Card` | Eikonnex OCR of Thai driving licence |
| 5 | POST | `/api/v1/uam/get_user` | JWT | `controllers/userController.go:1771` `GetUser` | Current user profile + loyalty + promo + SSO |
| 6 | POST | `/api/v1/uam/update_profile_name` | JWT+ID | `userController.go:1895` `UpdateUserProfileName` | Update prefix / name, push to SF |
| 7 | POST | `/api/v1/uam/update_profile_phone` | JWT+ID | `userController.go:2019` `UpdateUserProfilePhone` | Update mobile, push to SF |
| 8 | POST | `/api/v1/uam/update_profile_dob` | JWT+ID | `userController.go:2100` `UpdateUserProfileDOB` | Update DOB, push to SF |
| 9 | POST | `/api/v1/uam/update_lang` | JWT+ID | `userController.go:2183` `UpdateLang` | Update language |
| 10 | POST | `/api/v1/uam/get_carband_all` | none | `controllers/carbandController.go:22` `GetCarband_All` | Car model master ⚠️ SQLi (S4) |
| 11 | POST | `/api/v1/uam/get_geo` | none | `controllers/provinceController.go:36` `GetGeo` | Province / district / subdistrict / zipcode lookup ⚠️ SQLi (S4) |
| 12 | POST | `/api/v1/uam/get_ta_country` | none | `provinceController.go:134` `GetTACountry` | Country master (TA) |
| 13 | POST | `/api/v1/uam/get_ta_state` | none | `provinceController.go:162` `GetTAState` | State master by country |
| 14 | POST | `/api/v1/uam/login` | none | `userController.go:1690` `Login` | Legacy login against `public.users` (plain-text password) |
| 15 | POST | `/api/v1/uam/registeraccount_email` | none | `userController.go:1520` `Registeraccount_Email` | Register with email + password (needs `hashcode` from #25) |
| 16 | POST | `/api/v1/uam/registeraccount_email_auto` | none | `userController.go:463` `Registeraccount_Email_Auto` | Auto-create account with generated password, email it |
| 17 | POST | `/api/v1/uam/registeraccount_sso` | none (Firebase ID token in body) | `userController.go:617` `Registeraccount_SSO` | SSO check / register / link / auto-login ⚠️ S5 |
| 18 | POST | `/api/v1/uam/forget_password` | RL | `userController.go:2228` `ForgetPassword` | Send reset link ⚠️ SQLi (S4) |
| 19 | POST | `/api/v1/uam/update_password` | none (reference_id) | `userController.go:2345` `UpdatePassword` | Set new password via reset reference |
| 20 | POST | `/api/v1/uam/check_update_password` | none | `userController.go:2416` `CheckUpdatePasswordLink` | Check reset reference is valid |
| 21 | POST | `/api/v1/uam/ekyc_formsubmit` | none | `controllers/ekycController.go:513` `EKYCFormSubmit` | Upsert `ekyc_user` |
| 22 | POST | `/api/v1/uam/verify_account` | none | `userController.go:2458` `VerifyAccount` | Confirm account by OTP (`user_confirm`) |
| 23 | POST | `/api/v1/uam/validate_email` | RL | `userController.go:71` `ValidateEmail` | Email not used → send email OTP |
| 24 | POST | `/api/v1/uam/validate_phone` | none (reCAPTCHA in prod) | `userController.go:152` `ValidatePhone` | Send SMS OTP |
| 25 | POST | `/api/v1/uam/validate_email_otp` | none | `userController.go:255` `ValidateEmailOTP` | Verify email OTP → returns `hashcode` |
| 26 | POST | `/api/v1/uam/validate_phone_otp` | none | `userController.go:328` `ValidatePhoneOTP` | Verify SMS OTP |
| 27 | POST | `/api/v1/uam/policy_doc_request_otp` | RL | `controllers/policyDocumentController.go:94` `PolicyDocRequestOTP` | Public TA (Vacay) policy doc: send OTP |
| 28 | POST | `/api/v1/uam/policy_doc_download` | none (OTP) | `policyDocumentController.go:175` `PolicyDocDownload` | Public TA policy doc: verify OTP → signed URL |
| 29 | POST | `/api/v1/uam/create_policy_form` | none | `controllers/policyController.go:637` `CreatePolicyForm` | **Issue motor policy** from paid lead (+ACT, CMI, IIA, SF, points) |
| 30 | POST | `/api/v1/uam/car_inspect_step` | none | `policyController.go:282` `CarInspectStep` | Mark car inspection success → call `create_policy_pure` |
| 31 | POST | `/api/v1/uam/create_policy_pure` | none | `policyController.go:463` `CreatePolicyPure_Service` | Push motor policy to Salesforce |
| 32 | POST | `/api/v1/uam/create_policy_act` | none | `controllers/salesforceController.go:1960` `CreatePolicyAct_Service` | Push ACT policy to Salesforce |
| 33 | POST | `/api/v1/uam/cmi_realtime_service` | none | `controllers/cmiRealtimeController.go:27` `CMIRealTime_Service` | Send ACT to OIC CMI realtime, save result |
| 34 | POST | `/api/v1/uam/cmi_realtime_endorse_service` | none | `cmiRealtimeController.go:147` `CMIRealTime_Endorse_Service` | CMI realtime endorsement |
| 35 | POST | `/api/v1/uam/iia_act_service` | none | `controllers/soapController.go:28` `IiaAct_Service` | Send ACT to IIA (SOAP) |
| 36 | POST | `/api/v1/uam/policy_attachment_more` | none | `salesforceController.go:2847` `PolicyAttachmentMore_Service` | Push extra attachments to SF |
| 37 | POST | `/api/v1/uam/rush_iia` | none | `policyController.go:38` `Rush_IIA` | Re-send policy / ACT to IIA |
| 38 | POST | `/api/v1/uam/check_amlo_blacklist` | none | `controllers/amloController.go:23` `Check_Amlo_Blacklist_Service` | AMLO blacklist check (+ compliance email) |
| 39 | POST | `/api/v1/uam/get_policy` | none | `policyController.go:1825` `GetPolicy` | Look up policy by no. or plate+province ⚠️ S6 |
| 40 | POST | `/api/v1/uam/get_phone_otp` | none | `userController.go:2888` `GetPhoneOTP` | Send SMS OTP (no reCAPTCHA, no RL) |
| 41 | POST | `/api/v1/uam/get_phone_otp_verify` | none | `userController.go:2963` `GetPhoneOTPVerify` | Verify SMS OTP |
| 42 | POST | `/api/v1/uam/get_claim_status_and_history` | JWT | `policyController.go:1917` `GetClaimStatusAndHistory` | Claim status via `fn_claim_status_history` |
| 43 | POST | `/api/v1/uam/synce_sso` | JWT | `userController.go:1089` `SyncSSOWithUserID` | Link / unlink SSO to current user |
| 44 | POST | `/api/v1/uam/upload_base64_to_gcp` | JWT | `controllers/utilsController.go:20` `UploadBase64ToGCP` | Upload base64 files to GCS (public-read) |
| 45 | POST | `/api/v1/uam/log_mobile` | none | `controllers/logController.go:156` `LogMobile` | Insert mobile device log |
| 46 | POST | `/api/v1/uam/get_policy_renewal` | JWT | `policyController.go:1670` `GetPolicyRenewal` | Renewal policy form data |
| 47 | POST | `/api/v1/uam/get_policy_renewal_b2b` | IP | `policyController.go:1670` `GetPolicyRenewal` | Same handler, for internal callers (purchase service) |
| 48 | POST | `/api/v1/uam/edit_email_validate_password` | JWT | `userController.go:2522` `Edit_email_validate_password` | Change email step 1: check password → ref |
| 49 | POST | `/api/v1/uam/edit_email_validate_ref` | JWT, RL | `userController.go:2594` `Edit_email_validate_ref` | Step 2: new email + ref → email OTP |
| 50 | POST | `/api/v1/uam/edit_email_validate_otp` | JWT | `userController.go:2718` `Edit_email_validate_otp` | Step 3: OTP → `fn_profile_email_change`, SF |
| 51–59 | POST | `/api/v1/uam/ry05` · `ry11` · `ry17` · `ry18` · `ry19` · `ry20` · `ry23` · `ry24` · `ry28` | none | `controllers/policyendorseController.go:433` / `495` / `556` / `617` / `684` / `745` / `807` / `868` / `930` `IIAEndorse_R*` | IIA auto-endorse report RY5…RY28 for one policy |
| 60 | POST | `/api/v1/uam/get_ocr_service` | none (no sanitize) | `ekycController.go:203` `Get_OCR_Service` | Read saved OCR + blacklist check |
| 61 | POST | `/api/v1/uam/ocr_reader_service` | none (no sanitize) | `ekycController.go:606` `OCRReader_Service` | YIP OCR of ID card (no save) |
| 62 | POST | `/api/v1/uam/ocr_service` | none (no sanitize) | `ekycController.go:47` `OCR_Service` | Save OCR result + blacklist check |
| 63 | POST | `/api/v1/uam/facerecog_service` | none (no sanitize) | `ekycController.go:386` `FaceRecog_Service` | YIP face match (threshold from `sys_param`) |
| 64 | POST | `/api/v1/uam/ocr_passport_reader_service` | none (no sanitize) | `ekycController.go:894` `PassportMRZ_Service` | YIP passport MRZ |
| 65 | POST | `/api/v1/uam/upsert_account` | none | `salesforceController.go:3801` `UpsertAccountService` | Proxy to SF `upsertaccount` |
| 66 | POST | `/api/v1/uam/sfattachment_policy` | none | `salesforceController.go:1886` `SFPolicyAttachment_Service` | SF attachments (policy docs) |
| 67 | POST | `/api/v1/uam/sfattachment_policy_act` | none | `salesforceController.go:1825` `SFPolicyAttachment_Act_Service` | SF attachments (ACT docs) |
| 68 | POST | `/api/v1/uam/sfattachment_receipt` | none | `salesforceController.go:1928` `SFPolicyAttachment_Receipt_Service` | SF attachment (receipt) |
| 69 | POST | `/api/v1/uam/sfattachment_receipt_act` | none | `salesforceController.go:1856` `SFPolicyAttachment_Act_Receipt_Service` | SF attachment (ACT receipt) |
| 70 | POST | `/api/v1/uam/sfattachment_policy_endorse` | none | `policyendorseController.go:25` `SFPolicyAttachment_Endorse_Service` | SF attachment (endorse) |
| 71 | POST | `/api/v1/uam/sfattachmenturl_policy_endorse_tax` | none | `policyendorseController.go:169` `SFPolicyAttachmentUrl_Endorse_Tax_Service` | SF attachment URL (e-tax) |
| 72 | POST | `/api/v1/uam/sfattachmenturl_policy_endorse_dedebt` | none | `policyendorseController.go:256` `SFPolicyAttachmentUrl_Endorse_DeDebt_Service` | SF attachment URL (debit note) |
| 73 | POST | `/api/v1/uam/sfattachmenturl_policy_endorse_indebt` | none | `policyendorseController.go:343` `SFPolicyAttachmentUrl_Endorse_Indebt_Service` | SF attachment URL (credit note) |
| 74 | POST | `/api/v1/uam/job_update_sfpolicy` | none | `salesforceController.go:2879` `JobUpdateSFPolicy` | Call purchase `update-sf-payment` |
| 75 | POST | `/api/v1/uam/drop_lead` | none | `salesforceController.go:1197` `Drop_Lead` | Save lead + SF `upsertlead` |
| 76 | POST | `/api/v1/uam/policy_transaction` | none | `salesforceController.go:421` `SFPolicyTransaction` | Endorsement request from SF → DB + SF |
| 77 | POST | `/api/v1/uam/upsert_claim` | none | `salesforceController.go:207` `UpsertClaim` | Claim request → DB + SF + SMS |
| 78 | POST | `/api/v1/uam/upsert_claim_upload_file` | none | `salesforceController.go:33` `UpsertClaimUploadFile` | Claim attachment → GCS + DB + SF |
| 79 | POST | `/v1/uam/decrypt_lead_no` | none | `utilsController.go:62` `DecryptLeadNo` | AES-decrypt lead number ⚠️ S8 |
| 80 | POST | `/api/v1/uam/test` | none | `controllers/testController.go:12` `TestController` | Test stub (hard-coded policy nos.) |

Total: **80 routes** registered in `router/router.go` (incl. `/healthcheck` and swagger; the RY row counts 9). Commented-out routes (`del_sso`, `test_agent`, Keycloak `createuser` / `loginkeycloak`) are not registered.

---

## Endpoints

Conventions:
- Every handler does `c.Bind` then (usually) `c.Validate`; bind error → `400` plain text; validation error → `400 JsonReturn{result: <validator error>}`.
- `lead_no` fields that are "encrypted" use `helper.Aes256Decode` (AES-256 with `ENC_KEY`/`IV`).
- OTPs: 6 digits (`helper.GenerateOTP(6)`), stored in `insurverse.temp_otp` with a random `ref_id`, 5-minute expiry (text in SMS), `active=false` until used.

### 1–2. `GET /healthcheck`, `GET /api/v1/uam/swagger/*`
`200 text "OK"`. No DB. Swagger may be stale.

### 3–4. Eikonnex OCR — `ocr_car_registration_book`, `ocr_thai_driving_license_card`
**Body:** `multipart/form-data`, field `file` (image). Forwarded as multipart to Eikonnex with the token header; response converted by `ConvertToOcrCarRegistration2` / `ConvertToThaiDrivingLicenseCard2`.
**Response:** `200 JsonReturn{result: <parsed OCR fields>}`; 400 when `file` is missing; 500 on upstream failure. **DB:** none. Not logged by `LoggerMiddleware`.

### 5. `POST /api/v1/uam/get_user` (JWT)
**Body:** none used (user id = `JWTClaims["id"]`).
**Response 200:** `JsonReturn{title:"Success", result: SecUser}` — columns from `sec_user` (`user_id, username, name, mid_name, last_name, email, reset_status, identification_no, identity_type, isonline, user_type, accesskey, user_status, create_date, …, mobile, email_verified, mobile_verified, last_login, phone_verified, token, prefix_name, user_dob, sf_account, sf_lead, citizen_id, address, province_id, subdistrict_id, district_id, zipcode, countryid, language`) plus computed `loyalty_point`, `loyalty_history` (json), `redeem_inventory` (json), `referal_code`, `sso_details` (json).
**Errors:** 400 `Data not found` / missing `id` claim; 500.
**DB:** `sec_user`, `loyalty_point_trans`, `promo_code_trans`, `promo_code`, `sec_user_sso`, fn `fn_loyalty_referal_code(user_id)`.
⚠️ Returns `token` and `accesskey` columns to the client (content not verified).

### 6–9. Profile updates (JWT+ID)
| Route | Body (`models.*`) |
|---|---|
| `update_profile_name` | `UpdateProfileName { id, prefix, first_name, last_name }` |
| `update_profile_phone` | `UpdateProfilePhone { id, phone }` |
| `update_profile_dob` | `UpdateProfileDOB { id, dob (RFC3339 time) }` |
| `update_lang` | `UpdateLang { id, lang (e.g. "th-th") }` |

`id` must equal the token `id` claim (else 401). `UPDATE insurverse.sec_user …`; name/phone/DOB then read `sec_user` + `payment` and call Salesforce `upsertaccount` (`helper.UpsertAccount`). **Response:** `200 JsonReturn{title:"Success"}`; 400 / 401 / 500.

### 10. `POST /api/v1/uam/get_carband_all`
**Body:** `{ "limit": "<string>" }` (optional). SQL: `"SELECT * FROM insurverse.carmodel" + " limit " + limit` — **string concatenation** (S4).
**Response:** `200 JsonReturn{result: [carmodel rows]}`; 400 `"Erro GetCarband"`.

### 11. `POST /api/v1/uam/get_geo`
**Body** (`Geo_F`): `province_id int`, `district_id int`, `subdistrict_id int`, `zipcode_id string` (all optional filters).
Builds 4 queries by concatenation over `province`, `district`, `subdistrict`, `zipcode`; `zipcode_id` is a raw string (S4).
**Response:** `200 JsonReturn{result: { province:[…], district:[…], subdistrict:[…], zipcode:[…] }}` ⚠️ exact keys unverified.

### 12–13. `get_ta_country`, `get_ta_state`
`get_ta_country`: no body → rows of `mas_country`. `get_ta_state`: `{ "countryID": int }` → rows of `mas_state`. `200 JsonReturn{result:[…]}`.

### 14. `POST /api/v1/uam/login` — legacy
**Body** (`models.User`): `username` (required), `password` (required), others ignored.
`SELECT first_name FROM public.users WHERE first_name=$1 AND password=$2` (plain-text password compare). On match → JWT (HS256, hard-coded key, claim `name`, exp ≈ now+25h).
**Response:** `200 {status:200, result:{token}}`; not found → `200 {result:"ไม่พบข้อมูล"}`. ⚠️ Looks unused / dead (S9).

### 15. `POST /api/v1/uam/registeraccount_email`
**Body** (`UserEntity_F`)
| Field | Type | Required | Notes |
|---|---|---|---|
| customer_id | string | no | |
| first_name, last_name | string | no | |
| email | string | no* | must be unused (`CheckEmail`) |
| phone | string | no | |
| password | string | yes | `helper.PasswordChecker` rules |
| hashcode | string | no* | must equal `MD5("<static salt>" + email)` from #25 |

Tx: `INSERT sec_user` (bcrypt hash, `email_verified`), `INSERT user_confirm`. **200** `{title:"Success Registed", result:{customer_id}}`; 400 email used / hash mismatch / password rule; 500.

### 16. `POST /api/v1/uam/registeraccount_email_auto`
**Body** (`RegisterAuto`): `first_name`*, `last_name`*, `email`*, `mobile`, `occupation`, `occupation_code`.
If email exists → updates name fields only. Else generates an 8-char password, `INSERT sec_user` (bcrypt), emails the **plain password** + reset link (`Url_Fontend`). No auth, no rate limit (S10).

**Responses — FX-02 (2026-09-24):**
- Email already exists → **200** `{ "title": "Email already exists", "status": 200, "result": { "is_new_account": false, "email": "<email>" } }` (was **500**).
- New account created → **200** `{ "title": "Success Auto Registed", "status": 200, "result": { "is_new_account": true, "email": "<email>" } }` (was `result: {}`).
- 500 on DB / mail errors.

Frontend (`nextjs-webapp`) shows the "account created" dialog only when `status == 200` and `result.is_new_account !== false`.

### 17. `POST /api/v1/uam/registeraccount_sso`
**Body** (`Register_SSO`)
| Field | Type | Required |
|---|---|---|
| uid | string | – (must equal Firebase token UID) |
| first_name, last_name | string | – |
| email_sso | string | – (used for lookup / register / login) |
| email_sec | string | – |
| sso_type | string | yes (e.g. google / apple / facebook ⚠️) |
| user_info.stsTokenManager.accessToken | string | yes in practice (Firebase ID token) |
| is_check_login | bool | yes |
| is_sync | bool | yes |

Flow: `Firebase.VerifyIDToken` → 401 if invalid or `uid` ≠ token UID. Look up `sec_user_sso` by uid+type. `is_check_login=true` → returns `{is_register, is_sync}` flags. `is_check_login=false` → login / auto-register (`AutoRegisterSSO`: `INSERT sec_user`, email with generated password) / link (`SaveSSOWithID`: insert/update `sec_user_sso`) and then `LoginSSO(email)` → `POST {Backend_Auth}login_sso` and returns the auth-service response.
**Responses:** 200 with login payload or flags; 400 conflicts (masked emails); 401; 500. ⚠️ S5 (email not bound to the verified token).

### 18. `POST /api/v1/uam/forget_password` (RL)
**Body** (`ForgetPassword_F`): `email`, `phone`, `type` (`"web"` → by email, else by phone).
`SELECT … FROM sec_user WHERE ` + `"email = '" + email + "'"` — **SQL injection** (S4). Then `INSERT reset_password` (ref, 24h? expiry ⚠️) and email link `{Url_Fontend}new-password?reference_id=…&expired_at=…`.
**200** `{title:"Success"}`; 400 `Data not found`; 500.

### 19–20. `update_password`, `check_update_password`
`update_password` (`UpdatePassword_F`): `password`*, `reference_id`*. Reads `reset_password` (not consumed, not expired) → bcrypt → `UPDATE sec_user`, `UPDATE reset_password SET consumed`. `check_update_password` (`CheckUpdatePassword`): `reference_id`* → 200 if valid. Errors 400/500.

### 21. `POST /api/v1/uam/ekyc_formsubmit`
**Body** (`EkycUser`): `id`*, `citizen_id`*, `prefix_id`, `first_name`, `last_name`, `birth_date`, address fields, `province_id`, `district_id`, `subdistrict_id`, `zipcode`, `country_id`, `phone`. Upsert into `ekyc_user`. No auth (S2).

### 22. `POST /api/v1/uam/verify_account`
**Body** (`UserConfirm_F`): `customer_id`*, `type`*, `ref_id`, `otp`*. Checks `user_confirm` → `UPDATE user_confirm`, `UPDATE sec_user SET email_verified=true`.

### 23–26. Email / phone OTP
| Route | Body | Action |
|---|---|---|
| `validate_email` (RL) | `{ email* }` | 400 if email in `sec_user`; else `INSERT temp_otp(email,…)` + email OTP. `200 {title:"Success Validated Email"}` |
| `validate_phone` | `{ mobile*, type, product, recaptchaToken* }` | prod only: reCAPTCHA score ≥ 0.1 else 400. Disables old OTPs, `INSERT temp_otp(phone,…,product)`, SMS. `200 {result:{refCode, expiredAt}}` |
| `validate_email_otp` | `{ email*, otp* }` | Latest `temp_otp` for email; expired / wrong (`count+1`) / used → 400. Marks active. `200 {result:{hashcode}}` |
| `validate_phone_otp` | `{ mobile*, otp*, product }` | Same for phone |

⚠️ OTP attempt counter is incremented but never enforced (S11).

### 27–28. Public TA policy document (Vacay partner)
`policy_doc_request_otp` (RL): `{ email*, identity_id* }` → finds `policy_ta_premium` ⨝ `lead_ta_participant` by email + owner card id + fixed partner code → `INSERT temp_otp` + email → `200 {result:{ref_id}}`; `404` if no policy (S12).
`policy_doc_download`: `{ email*, identity_id*, ref_id*, otp* }` → checks OTP (expiry, max attempts `policyDocOTPMaxAttempts` = 5, count) → `200 {result:{policy_no, policy_url, password_hint}}` (`policy_url_ref` = signed, password-protected PDF).

### 29. `POST /api/v1/uam/create_policy_form` — Motor policy issuance (ออกกรมธรรม์รถ)
Called by the frontend after payment (and by purchase service for renewal). **No auth.**
**Body** (`models.PolicyForm`)
| Field | Type | Notes |
|---|---|---|
| person.lead_no | string | **required**; AES-encrypted `Lead_No` |
| person.prefix_id / prefix_label / first_name / last_name / birth_date / citizen_id | string | owner data; `ValidateBirthday` |
| person.address_no, province_id, district_id, subdistrict_id, zipcode (+ labels) | | owner address |
| person.financial_name | string? | beneficiary / finance |
| person.driver_count, is_driver_edited, drivers[] | | named drivers |
| person.occupation, occupation_code | string | |
| car.act | bool | also issue ACT |
| car.vin, color, size, cc | string | `cc` must be numeric |
| car.vehicle_registration_* | string | plate, colour, province |
| car.effective_date_coverage_start/end, effective_date_rd_start/end | string | |
| car.receive_document, address_same_card_id, address fields | | delivery address |
| car.ref_policy_no, policy_no, is_new_car_inspect, is_access_inspect, act_lead_no (AES) | | renewal / inspection / ACT lead |
| bypass | string | ⚠️ semantics unverified (skips some checks) |

**Processing (high level):**
1. Decrypt lead; AMLO blacklist (`Check_Blacklist` → `Check_Amlo_Blacklist`, emails compliance); 502/500 on failure; blocked → 200 with message.
2. Checks `Lead_coverage_premium."Payment_status"`; de-duplicates previous `Policy_coverage_premium` rows without header (DELETE + DELETE `log_sf_policy`); duplicate check → `200 "ตรวจพบข้อมูลซ้ำในระบบ!"`; date-overlap check.
3. `GenPolicyNo("MV")` — `SELECT last FROM policy_no` + `INSERT policy_no` (no lock, S13). `INSERT log_sf_policy`.
4. Tx: build `Policy_Header` / `Policy_coverage_premium` / `policy_participant` from lead; `UPDATE Policy_coverage_premium`.
5. If ACT: `fn_policy_to_car_act(policyNo)` → `UPDATE Policy_Car_Act_Discount_Premium`; `CMI_Realtime("can", car_act_no)`; `IIA_Lot_No = fn_policy_lotno_iia()`.
6. `fn_policy_renewal_inspect_email(policyNo)`, `fn_update_point_policy(prefix, policyNo|car_act_no)` → `SendNoti` (push).
7. `SendIiaPolicy(policyNo)` + `SendIiaPolicy_Act` (IIA SOAP, `log_iia_policy`).
8. goroutines: `UpsertPolicyService` (SF upsertaccount/upsertpolicy, `fn_check_sf_account`, `UPDATE policy_participant`), `SendPolicyNo` (doc service), purchase `update-sf-payment`, `INSERT Policy_Regis_Evident`, `SendAttach_9`.
**Response:** `200 JsonReturn{title:"Success", result:{policy_no, …}}` ⚠️ exact result keys unverified; 400 bad lead/cc; 500 many stages (Thai message "พบปัญหาบางประการ โปรดติดต่อเจ้าหน้าที่").
**DB:** `Lead_coverage_premium`, `Lead_Car_Act_Discount_Premium`, `Policy_Header`, `Policy_coverage_premium`, `Policy_Car_Act_Discount_Premium`, `Policy_Regis_Evident`, `policy_participant`, `policy_no`, `log_sf_policy`, `log_iia_policy`, `log_cmi_realtime`, fns above.

### 30. `POST /api/v1/uam/car_inspect_step`
**Body** (`PolicyPure_F`): `{ id* }` (policy no). Reads `Policy_Header` (type must be supported, cross-check VIN), `UPDATE Policy_Header SET Car_Inspect_Status='success'` (only if empty), then loopback `POST /api/v1/uam/create_policy_pure`. 400 `Invalid Policy Type` / `Policy Not Found` / `Cross Check Failed`; 500.

### 31–32. `create_policy_pure`, `create_policy_act`
**Body:** `{ id* }` (policy no / car ACT no). Builds SF payloads (`CreatePolicyPure` / `CreatePolicyAct`: reads `Policy_Header`, `Policy_coverage_premium`, `Policy_Car_Act_Discount_Premium`, participants, TQM tables; `fn_check_sf_account`) → SF `upsertaccount` + `upsertpolicy` (or TQM variant) → `UPDATE policy_participant`, `log_sf_policy`. Response `JsonReturn_SF`.

### 33–34. CMI realtime
**Body** (`CMIRealtimeService`): `{ id* (car_act_no), type }` (`type` e.g. `new`/`can` ⚠️). Calls OIC CMI; `UPDATE Policy_Car_Act_Discount_Premium` (CMI result fields); `log_cmi_realtime`. **200** `{result: <CMI response>}`; any `CMI_Realtime` / `CMI_Realtime_Endorse` failure → **400** `{title: cmiFailureTitle(err), status:400, result:{}}` (on a CMI rejection that still returned reference/receive numbers, the numbers are saved first); 400 on bind/validate; 500 on DB errors. Endorse variant reads `Policy_endorse_detail`, `mas_cmi_*`, `company_detail`, `tqm_lead_cmi`.

Failure titles by `cmiStage` (`CMIError.Title()`): `lookup` → "ไม่พบข้อมูลกรมธรรม์ในระบบ", `call` → "เรียกระบบ CMI ไม่สำเร็จ", `decode` → "อ่านคำตอบจากระบบ CMI ไม่ได้", `rejected` → "CMI ปฏิเสธรายการ : <reason>", **`invalid` (new, FX-02)** → "ข้อมูลไม่ครบตามข้อกำหนด คปภ. : <reason>".

**FX-02 (2026-09-24) — pre-send OIC validation (`controllers/cmi_validate.go` `validateCMIRow`)**, applied to both policy (`CMI_Realtime`, also used by `create_policy_form`) and endorse. A record failing any rule is **not sent** to CMI; the row is logged via `Log_CMI` (`log_cmi_realtime`) and the handler answers 400 with stage `invalid`; `<reason>` lists every problem joined by `; `. Nothing is trimmed or filled in. Same rules as `go-fiber-policy-service`.

| Field | Rule |
|---|---|
| `contractDt`, `effectiveDt`, `endDt` | not blank, valid `yyyymmdd` date |
| `vehicleTypeCode` | not blank, ≤ 5 chars |
| `registeredProvinceCode` | not blank, ≤ 2 chars |
| `plateNumber` | not blank, ≤ 20 chars |
| `chassisVINNumber` | not blank, ≤ 50 chars |

Endorse only: if the main policy has no CMI `ReferenceNumber` → not sent, stage `invalid`, reason `main policy has no CMI reference number` (OIC 2BUS0227).

Payload query changes (FX-02): `agentBrokerLicenseNumber` = `'ว00019/2546'` when `car_act.partner_code` is `TQM` (case-insensitive), else `company_detail.regist_id` — in both the policy query (`q1`) and the endorse query (`q2_cmi_realtime_endorse`). Endorse `contractDt` is capped at the policy start date (`car_act."Start_date"` +7h, `yyyymmdd`) when later (OIC 2BUS0004); a NULL contract date stays NULL.

### 35, 37. IIA (SOAP)
`iia_act_service` (`IIA_Act_F {id*, type}`) → `SendIiaPolicy_Act(id)` → `200 {title:"IIA Act Success", result:{…}}`; failure → title from `iiaFailureTitle`. `rush_iia` (`{id*, type}`; `type != "act"` → policy) → `SendIiaPolicy` / `SendIiaPolicy_Act`. DB (payload build): `Policy_Header`, `Policy_coverage_premium`, `Policy_Car_Act_Discount_Premium`, `payment`, `payment_act`, `promo_code_trans`, `mas_partner`, `mas_cmi_color`, `sys_param`, geo tables; fns `fn_address_clean_dist`, `fn_format_utc_timestamp`, `fn_policy_package_iia`, `fn_policy_usage_to_comp`, `fn_policy_comp_to_usage`; writes `log_iia_policy`.

### 36, 66–73. Salesforce attachments
**Body:** `{ id* }` (policy / ACT / endorse no.). Calls `SendAttach_N` → SF `upsertpolicyattachmenturl` / `upsertpolicyattachment` with document URLs, then updates attachment flags (`Update_Attach_Policy_Header`, `…_Car_Act_Discount_Premium`, `…_Regis_Evident`, `…_Endorse`, `…_Etax`). Response `JsonReturn_SF`. DB: those tables + `log_sf_policy`.

### 38. `POST /api/v1/uam/check_amlo_blacklist`
**Body** (`QueryBlacklistModel`): `lead_no`* (AES), `check_type`* (lead group: motor / act / ta / pa / home ⚠️), `owner_firstname`, `owner_lastname`, `owner_citizen_id`, `policy_no`. Query joins lead/policy participant tables with `amlo_idnumber`. Match → emails `ComplianceEmailList`. **200** `{result:[BlacklistModel]}` ⚠️ shape unverified.

### 39. `POST /api/v1/uam/get_policy`
**Body** (`GetPolicy`): `policyNo`, `policyGroupType`, `carLicenseNo`, `carLicenseProvice`. By policy no. → `Policy_Header` or `Policy_Car_Act_Discount_Premium`; or by plate+province → latest active policy with `Car_Inspect_Status`. **200** `{result:[{policyNo, policyGroupType, carLicenseNo, carLicenseProvice, car_inspect_status}]}`. No auth (S6).

### 40–41. `get_phone_otp`, `get_phone_otp_verify`
`{ phone* }` → disable old, `INSERT temp_otp`, SMS → `200 {result:{refCode…}}` ⚠️. Verify: `{ phone*, otp* }` → same checks as #26.

### 42. `POST /api/v1/uam/get_claim_status_and_history` (JWT)
**Body:** `{ id* }` (ignored; user id from token). `select insurverse.fn_claim_status_history($1)` → `200 {result: <json>}`.

### 43. `POST /api/v1/uam/synce_sso` (JWT)
**Body** (`SynceSSO`): `uid`*, `sso_type`*, `active`* (bool), `first_name`, `last_name`, `email`, `user_info` (Firebase token). Verifies Firebase token, links/unlinks `sec_user_sso` for the token user.

### 44. `POST /api/v1/uam/upload_base64_to_gcp` (JWT)
**Body:** `{ path*: string, data*: [{ base64, name }] }` → `helper.UploadFileToGCP` → `https://storage.googleapis.com/{bucket}/{path}/{name}`. Sets bucket default ACL `AllUsers: READER` (S14). **200** `{title:"Success", result:[urls]}`.

### 45. `POST /api/v1/uam/log_mobile`
**Body** (`LogMobile`, all optional): `user_id, version_app, device_brand, device_model, device_name, device_platform, source_type, remark` → `INSERT log_mobile`.

### 46–47. `get_policy_renewal` (JWT) / `get_policy_renewal_b2b` (IP)
**Body** (`PolicyRenewalFrontend`): `lead_no` (AES), `policy_no`. `select insurverse.fn_policy_renewal_ref(lead)` → maps to `PolicyForm` → re-encrypts lead nos. **200** `{result: PolicyForm}`; 400 decrypt / not found; 500. Purchase service calls the b2b route then `create_policy_form`.

### 48–50. Change email (JWT)
1. `edit_email_validate_password` `{ password* }` → `GetUserByEmailPassword` (user from token) → `INSERT log_email_change` → `{result:{ref_id}}`.
2. `edit_email_validate_ref` (RL) `{ email_new*, ref_id* }` → `UPDATE log_email_change`, `INSERT temp_otp`, OTP email to new address.
3. `edit_email_validate_otp` `{ ref_id*, otp* }` → OTP check → `fn_profile_email_change(...)`, `UPDATE log_email_change`, SF `upsertaccount`.

### 51–59. IIA auto-endorse `ry05` … `ry28`
**Body** (`IIA_RY_F`): `{ id* }` (policy no; `MV-` prefix → motor query, else ACT query). Builds the RY payload from policy/endorse tables and posts to `{Url_IIA}ServiceAutoEndorse/api/import/ryN` (`HTTP_IIA_ENDORSE`); writes `log_iia_policy`. **200** `{result: IIA_RY_Result}`; 500 `{result:{error}}`.
RY11 (cancel) does **not** change `Policy_Header."Policy_Status"` or `no_cancel_flag` (the WS6 `'C'` / `no_cancel_flag='Y'` update was removed 2026-09-24, `1458623`: `'C'` is not a known status — the cancel flow uses `'INC'`, e.g. `fn_update_point_cancel` — and `no_cancel_flag` means "may not be cancelled" and is sent to CMI). Pending business confirmation of the correct status.

### 60–64. YIP e-KYC (no sanitize)
| Route | Body | Notes |
|---|---|---|
| `ocr_service` | `Ekyc_OCR_F_SAVE` (id, side, prefix_id*, prefix_en_id*, first/last name TH*/EN*, dateofbirth_th*/en*, citizen_id*, address_no*, province/district/subdistrict_id*, zipcode*, …, lead_no*, lead_group_type, policy_no, similarity*) | Upsert `ekyc_ocr`, then blacklist check. `similarity` is client-supplied (S15). |
| `get_ocr_service` | `{ citizen_id*, lead_no*, lead_group_type*, first_name, last_name }` | `CustomOCR` read + blacklist |
| `ocr_reader_service` | `{ imgsource* (base64), side, citizen_id, Return_portrait_* flags }` | Proxy to YIP OCR |
| `facerecog_service` | `{ trans_id, imgsource*, imgtarget* }` | Proxy to YIP face; threshold from `sys_param` |
| `ocr_passport_reader_service` | `PassportMRZ_F { trans_id, … }` | Proxy to YIP MRZ; `log_yipinsoi`. FX-02 (2026-09-24): provider failure → **500** `{title:"OCR service unavailable", status:500, description:"Passport OCR could not be read, please enter the details manually"}` (was empty `JsonReturn{}`); the `status` in the provider reply is read as int or float64, so the handler no longer panics. |

### 65. `upsert_account` — body `UpsertAccount { accountID, accountType, leadId, salutation, firstname, lastname, birthdate, idNumber, idType, mobilePhone, email, street, city, state, country, postalCode, customerType, paymentStatus }` → SF `upsertaccount`.

FX-02 (2026-09-24): in the policy-driven SF account payload (`query2_1_ct`, used by `CreatePolicyPure` / `UpsertPolicyService` from `create_policy_form` and `create_policy_pure`), `mobilePhone` = `Policy_Header."Owner_phone"`, falling back to `Policy_Header."phone"` (buyer) when blank, else `''`.

### 74. `job_update_sfpolicy` — `{ id* }` → `POST {Backend_Purchase_SF_Update}`.

### 75. `drop_lead` — `DropleadModel_F { firstname*, lastname*, email*, mobilePhone*, leadSource* }` → `INSERT lead_info_customer` + SF `upsertlead`.

### 76. `policy_transaction` — `SFPolicyTransaction_F` (large: `doc[]`, `type[]`, `insurancePolicyId`, owner / delivery address, car, beneficiary, drivers `par1*`/`par2*`, premium tariffs, `status`, `transactionID`, …). Reads `Policy_Header`, `mas_tariff`; AMLO endorse check; `fn_policy_endorse_request(...)` (NamedQuery); attachments; SF `upsertpolicytransaction`.

### 77–78. Claims
`upsert_claim` (`UpsertClaim`: `refNotifyNo, status, requestClaimId, prbNumber, accPolicyNo, accidentCause, accidentDate, requestPhone, accidentCallDate, tpPhone, remark, source, customerType, requestLocLat/Long, flagInjuryed, flagUnableDriving, flagAtIncident`) → `INSERT/UPDATE claim_request`, SF `upsertclaim`, SMS.
`upsert_claim_upload_file` (`SFClaimUpload`: `file_type*, name*, ref_notify_no, base64*, base64_type*, file_case_code*`) → GCS (`policy_cliam` folder) → `claim_request_attach` → SF `upsertclaimattachmenturl`.

### 79. `POST /v1/uam/decrypt_lead_no`
**Body:** `{ "lead_no": "<AES ciphertext>" }` → `200 {title:"Success", result:{lead_no:"<plain>"}}`; 400. No auth (S8).

### 80. `POST /api/v1/uam/test` — runs two hard-coded reads, returns `"Test Controller is working!"`.

---

## DB Usage (schema `insurverse`)

| Table / function | R/W | Endpoints |
|---|---|---|
| `sec_user` | R/W | #5–9, #15–19, #22, #23, #43, #48–50 |
| `sec_user_sso` | R/W | #5, #17, #43 |
| `temp_otp` | R/W | #23–28, #40–41, #49–50 |
| `reset_password` | R/W | #18–20 |
| `user_confirm` | R/W | #15, #22 |
| `log_email_change` | R/W | #48–50 |
| `loyalty_point_trans`, `promo_code_trans`, `promo_code` | R | #5, IIA payload |
| `public.users` | R | #14 |
| `Lead_coverage_premium`, `Lead_Car_Act_Discount_Premium` | R | #29, #38 |
| `Policy_Header` | R/W | #29, #30, #31, #39, #76, IIA |
| `Policy_coverage_premium` | R/W (INSERT/UPDATE/DELETE) | #29, #31, IIA |
| `Policy_Car_Act_Discount_Premium` | R/W | #29, #32–35, #39 |
| `Policy_Regis_Evident` | W | #29, attachments |
| `policy_participant` | W | #29, #31, #32 |
| `policy_no` | R/W (running no.) | #29 |
| `Policy_endorse_detail`, `Policy_Header_Trans`, `Policy_Car_Act_Discount_Premium_Trans` | R | #34, #51–59, #76 ⚠️ |
| `payment`, `payment_act` | R | #6–8, #50, IIA payload |
| `lead_ta_*`, `lead_pa_*`, `lead_home_*`, `mas_home_building_type`, `amlo_idnumber` | R | #38, #29, e-KYC blacklist |
| `policy_ta_premium`, `lead_ta_participant` | R | #27–28 |
| `ekyc_ocr`, `ekyc_user` | R/W | #21, #60, #62 |
| `claim_request`, `claim_request_attach` | R/W | #77, #78 |
| `lead_info_customer` | W | #75 |
| `tqm_lead_cmi`, `tqm_lead_vmi`, `tqm_package_config`, `tqm_premium` | R | #31, #32, #34 |
| `province`, `district`, `subdistrict`, `zipcode`, `mas_country`, `mas_state`, `carmodel` | R | #10–13, payloads |
| `mas_cmi_color`, `mas_cmi_province`, `mas_cmi_brand_model`, `company_detail`, `mas_partner`, `mas_tariff`, `sys_param` | R | CMI / IIA / endorse / face |
| `log_internal_interface` | W | every request (middleware) |
| `log_sf_policy`, `log_sf_policy_trans`, `log_sf_policy_trans_request` | W | SF calls |
| `log_iia_policy`, `log_cmi_realtime`, `log_yipinsoi`, `log_mobile` | W | IIA / CMI / YIP / #45 |
| `fn_policy_to_car_act(policy_no)` | fn (policy → ACT) | #29 |
| `fn_lead_to_car_act` | fn — only referenced in a comment in this service (called by purchase service) | – |
| `fn_policy_lotno_iia()` | fn | #29 |
| `fn_policy_renewal_inspect_email(policy_no)` | fn | #29 |
| `fn_update_point_policy(type, policy_no)` | fn | #29 |
| `fn_policy_renewal_ref(int)` | fn | #46, #47 |
| `fn_claim_status_history(user_id)` | fn | #42 |
| `fn_profile_email_change(...)` | fn | #50 |
| `fn_loyalty_referal_code(user_id)` | fn | #5 |
| `fn_check_sf_account(...)` | fn | #29, #31, #32 |
| `fn_policy_endorse_request(...)` | fn | #76 |
| `fn_display_access`, `fn_address_clean_dist`, `fn_format_utc_timestamp`, `fn_policy_package_iia`, `fn_policy_usage_to_comp`, `fn_policy_comp_to_usage` | fn (read-only formatting) | SF / IIA payloads |

Repo also holds `script/fn_lead_to_car_act.sql`, `script/fn_policy_to_car_act.sql`, `backup/backup_fn_*_20260828_170738*.sql`, `ws1_database_patches.sql` (not executed by the service).

---

## Notes / ⚠️ unverified items (security findings first)

- **S1 ⚠️ Hard-coded secrets in source.** `constants/constant.go` contains literal fallback values for: `Key_AES256`/`IV_AES256`, Salesforce `SF_ClientID`/`SF_ClientSecret`/`SF_UserName`/`SF_Password`, IIA endorse user/password, YIP tokens, Eikonnex tokens, reCAPTCHA key, Keycloak client credential, and a full Firebase service-account JSON **with private key** (`CredentialJsonFirebase`). JWT HMAC keys are literals in `middlewares/Validate.go` and `middlewares/jwt.go`. GCP key files `key.json` and `insurverse-develop-key.json` are in the repo root. Helm files (`helm/*.yaml`) set secrets as plain `value:` (0 `secretKeyRef`). Values were **not** copied here. All should be rotated and moved to a secret store.
- **S2 ⚠️ Most routes have no auth.** Only 12 routes use `ValidateToken`. Policy issuance (`create_policy_form`), CMI/IIA submit, Salesforce push, claims, AMLO, e-KYC, `decrypt_lead_no`, `test` are open. Ingress exposure of `/api/v1/uam/*` was not verified.
- **S3 ⚠️ Global JWT claims (cross-user data race).** `ValidateToken` writes the parsed claims into package-level `middlewares.JWTClaims` (and the token string into a package-level `token`). `get_user`, `get_claim_status_and_history`, `synce_sso`, edit-email read that global. Under concurrent requests one user can get another user's id → wrong-user data / actions.
- **S4 ⚠️ SQL injection.** `forget_password` (email/phone concatenated into `WHERE`, public, rate-limit keyed on the same field), `get_carband_all` (`limit` concatenated), `get_geo` (`zipcode_id` concatenated). Int fields in `get_geo` are safe (`strconv.Itoa`).
- **S5 ⚠️ SSO account takeover risk.** `registeraccount_sso` verifies the Firebase token and `uid`, but never compares `email_sso` with the email in the verified token. With `is_check_login=false`, a valid token for any Firebase account + a victim's `email_sso` can reach the branch that links the SSO to the victim's `sec_user` (`SaveSSOWithID`) and calls `LoginSSO(victim email)`, which returns auth tokens. Needs confirmation by test (⚠️ code-read only).
- **S6** `get_policy` is public and returns policy no. / type / inspection status by licence plate + province (data enumeration).
- **S7** `RestrictIPs` uses `c.RealIP()`, which trusts `X-Forwarded-For` / `X-Real-IP` when no `IPExtractor` is set; a client able to reach the pod directly (or through a proxy that passes the header) may spoof an internal IP. Default `KUBS_IP` is `127.0.0.1`.
- **S8** `decrypt_lead_no` is a public decryption oracle for the AES lead numbers that other APIs treat as opaque. It is also registered at `/v1/uam/…` (missing `api/`), probably by mistake.
- **S9** `login` compares plain-text passwords in `public.users` and signs a token with a different key/claims than `ValidateToken` expects; appears dead.
- **S10** `registeraccount_email_auto` is public, creates accounts for any email and mails a generated plain-text password (spam / account squatting).
- **S11** OTP brute force: `validate_email_otp`, `validate_phone_otp`, `get_phone_otp_verify`, `verify_account`, `edit_email_validate_otp` increment `temp_otp.count` but never block on it (only `policy_doc_download` enforces a max). `validate_phone` / `get_phone_otp` have no rate limit (SMS pumping); `get_phone_otp` has no reCAPTCHA either.
- **S12** `policy_doc_request_otp` returns 404 vs 200, revealing whether an email + ID pair owns a Vacay TA policy.
- **S13** `GenPolicyNo` reads the last row of `policy_no` and inserts the next number with no lock/sequence → duplicate policy numbers under concurrency. `GenPolicyNoUnique` (with `FOR UPDATE`) exists but is not used by `create_policy_form`. `create_policy_form` also has no idempotency lock beyond the duplicate check.
- **S14** `UploadFileToGCP` sets the bucket default object ACL to `AllUsers:READER` and uses the client-supplied `path` / `name` in the object key (public files, path control).
- **S15** e-KYC `ocr_service` stores a client-supplied `similarity` score; the server does not recompute it.
- **S16** `LoggerMiddleware` stores full request headers (bearer tokens) and bodies (passwords, OTPs, citizen IDs, base64 images on non-excluded routes) in `log_internal_interface`.
- **S17** Email rate limiter is in-memory per pod, keyed on the raw JSON `email` (case / whitespace variants bypass it) and shared across 4 routes.
- **N1** CMI default endpoint is plain `http://` to an IP address.
- **N2** Many `c.JSON(..., Result: err)` return raw Go error objects to the client.
- **N3** Response shapes marked ⚠️ were inferred from code paths, not from a live call.
- **N4** DB function signatures and column types were taken from the SQL text in Go only; **not** verified against the live schema (`pg_proc` / `information_schema`) — ⚠️ unverified.
