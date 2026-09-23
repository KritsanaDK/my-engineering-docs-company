# java-spring-boot-jasper-report-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/java-spring-boot-jasper-report-service` (Maven artifact `jasper_report`, package `org.workshop.jasper_report`).
> Generated from the Spring controllers (`controller/*.java`: `@RequestMapping` / `@PostMapping` / `@GetMapping`), the repositories (template selection and parameter maps), the DTOs, and the `.jrxml` sources inside `export_jasper_studio_project.zip` (read with `unzip -p`, not extracted). `Jasper.postman_collection.json` was not used as a source.
> Spec date: 2026-09-23. Read-only analysis. Nothing was built or run.

---

## Overview (ภาพรวม)

| Item | Value |
|---|---|
| Purpose | A **stateless PDF rendering service**. Each endpoint takes a flat JSON body of pre-formatted strings, maps it to Jasper parameters, fills a pre-compiled `.jasper` template with `JREmptyDataSource`, can merge extra pages (RY endorsements, CCTV/accessory attachments, TQM cover PDF), can password-protect the PDF, and streams `application/pdf` back. |
| Products covered | Motor voluntary policy (MV 1/2+/3/3+), motor compulsory (MC / พ.ร.บ.), endorsements (RY / RYP / PR), receipts / tax invoices / debit-credit notes, PA, TA, Home, tax-deduction certificate (ลดหย่อนภาษี), claim survey reports, TQM partner pack |
| Framework | Spring Boot 3.5.0 (`spring-boot-starter-web`, `-validation`), JasperReports 7.0.3 (`jasperreports`, `-pdf`, `-barcode4j`), PDFBox (merge and encrypt), BouncyCastle, Caffeine (template cache), `dotenv-java` |
| Port | `server.port` in `application.properties`. The Dockerfile has `EXPOSE 8080` and runs `java -jar app.jar`. |
| Base path | `/api/v1/jasper-report/{mv,mc,endorse,receipt,pa,ta,home,tax,tqm}`. The health check is `/healthcheck`. |
| DB | **None.** There is no JDBC, JPA or DataSource dependency. The templates contain no `<queryString>` (checked: 0 in all 111 zip `.jrxml`). The "repository" classes only render templates. |
| Template storage | Compiled `.jasper` files on the classpath under `src/main/resources/report/**` (341 files). They are loaded by `CaffeineJasperCache.getTemplate(path)` (`getResourceAsStream` + `JRLoader.loadObject`, cached). |
| Success response | HTTP 200, `Content-Type: application/pdf`, `Content-Disposition: attachment; filename=policy_document.pdf` (`tqm_document.pdf` for TQM) |
| Error response | `MakeResponse.handleErrorRequest` → `{ "status": "error", "message": "<msg>", "data": null }` with 400 or 500. `GlobalExceptionHandler` → `CustomResponse` 500 `"An unexpected error occurred: <ex.getMessage()>"`, 400 for `IllegalArgumentException` and bean validation, plus handlers for `CustomException`, `RepositoryException` and `NotFoundException`. |

### Environment variables (names only / ชื่อตัวแปรเท่านั้น)

- `application.properties` keys: `spring.application.name`, `spring.profiles.active`, `server.port`.
- Helm (`helm/helm-uat-isv.yaml`): `ENV`, `JAVA_TOOL_OPTIONS`.
- `config/EnvConfigLoader` loads `.env.local` (optional) into system properties at startup. No code reads specific keys from it.

### External / third-party calls (การเรียกระบบภายนอก)

| Target | How | Caller |
|---|---|---|
| **Any URL supplied by the client** | `ImageResizer.resizeImageFromURL` → `new URL(imageUrl)` + `ImageIO.read` | `POST /mv/claim/third-party`, `POST /mv/claim/insurance` (`img1_place`, `img1_insured`, `img1_other`, `img2_other`, `img3_other`) |
| QR code content | `qrcode_attached_file_url` is passed as a Jasper parameter (it is rendered as a QR/barcode, not fetched) ⚠️ unverified in the compiled template | MV, MC, TQM policy |

No other outbound HTTP, message queue or DB calls exist.

---

## Auth & Middleware (การยืนยันตัวตน)

- **No authentication or authorization.** There is no `spring-boot-starter-security`, no filter, and no interceptor.
- No CORS configuration (Spring default, so no cross-origin headers). The service is meant to be called server-to-server (for example by the document/core services). ⚠️ The callers were not traced in this pass.
- Validation: every controller has `@Validated`, so the `@Pattern` checks on the path variables run. `@Valid @RequestBody` is present, but **the DTOs have no constraint annotations** (0 `@NotNull`/`@NotBlank`/`@Size` across 18 DTOs). Body validation therefore does nothing. The only checks are the manual ones in the controllers (encryption password, `flag_access`, `endorse_type`, `policy_type`).
- `encrypt` field: when present, and when required, it is used as **both the user and owner password** of the output PDF (`JasperHelper.exportPdf*WithEncryption` or `AttractRYUtils.encryptPdf` via PDFBox `StandardProtectionPolicy`).

---

## Endpoint Summary

**19 endpoints** (18 business endpoints + health check).

| # | Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|---|
| 1 | GET | `/healthcheck` | none | `controller/HealthCheck.java:12` `liveness` | Returns `"alive"` |
| 2 | POST | `/api/v1/jasper-report/mv/policy/{policyType}/{docType}` | none | `controller/MVController.java:34` `genDocumentPolicyMV` | Motor voluntary policy schedule (+ RY/CCTV/accessory attachments) |
| 3 | POST | `/api/v1/jasper-report/mv/claim/third-party` | none | `controller/MVController.java:73` `genDocumentClaimThirdPartyMV` | Third-party claim survey report with photos |
| 4 | POST | `/api/v1/jasper-report/mv/claim/insurance` | none | `controller/MVController.java:98` `genDocumentClaimInsuranceMV` | Insured-party claim survey report with photos |
| 5 | POST | `/api/v1/jasper-report/mc/policy/{docType}` | none | `controller/MCController.java:29` `genDocumentPolicyMC` | Compulsory (พ.ร.บ.) policy |
| 6 | POST | `/api/v1/jasper-report/endorse/ry/{docType}` | none | `controller/EndorsementController.java:34` `genDocumentEndorsementRY` | Motor endorsement RY (types 1/3) |
| 7 | POST | `/api/v1/jasper-report/endorse/ryp/{docType}` | none | `controller/EndorsementController.java:73` `genDocumentEndorsementRYP` | Motor endorsement RYP (types 2+/3+) |
| 8 | POST | `/api/v1/jasper-report/endorse/pr/{docType}` | none | `controller/EndorsementController.java:112` `genDocumentEndorsementPR` | Compulsory endorsement PR |
| 9 | POST | `/api/v1/jasper-report/receipt/mv` | none | `controller/ReceiptController.java:30` `genDocumentMVReceipt` | MV receipt / tax invoice |
| 10 | POST | `/api/v1/jasper-report/receipt/mc` | none | `controller/ReceiptController.java:62` `genDocumentMCReceipt` | MC receipt / tax invoice |
| 11 | POST | `/api/v1/jasper-report/receipt/no-vat` | none | `controller/ReceiptController.java:91` `genDocumentNoVatAReceipt` | Non-VAT receipt (PA) |
| 12 | POST | `/api/v1/jasper-report/receipt/tax-invoice` | none | `controller/ReceiptController.java:116` `genDocumentTaxInvoice` | Tax invoice (Home / TA inbound) |
| 13 | POST | `/api/v1/jasper-report/receipt/endorse/{productType}` | none | `controller/ReceiptController.java:141` `genDocumentReceiptEndorse` | Endorsement receipt (`mv`/`mc`/`mvc`) |
| 14 | POST | `/api/v1/jasper-report/receipt/endorse/motor-debt/{receiptType}` | none | `controller/ReceiptController.java:180` `genDocumentReceiptMotorDebt` | Debit / credit note (`increase`/`decrease`) |
| 15 | POST | `/api/v1/jasper-report/pa/policy/{docType}` | none | `controller/PAController.java:31` `genDocumentPolicyPA` | PA policy (+ cover page) |
| 16 | POST | `/api/v1/jasper-report/ta/policy/{docType}` | none | `controller/TAController.java:29` `genDocumentPolicyTA` | Travel policy (+ package / add-on pages) |
| 17 | POST | `/api/v1/jasper-report/home/policy/{docType}` | none | `controller/HomeController.java:31` `genDocumentPolicyHome` | Home / condo policy (+ cover page) |
| 18 | POST | `/api/v1/jasper-report/tax/deduction/{docType}` | none | `controller/TaxController.java:30` `genDocumentTaxDeduction` | Tax-deduction certificate |
| 19 | POST | `/api/v1/jasper-report/tqm/{policyType}/{docType}` | none | `controller/TqmController.java:33` `genDocumentTqm` | TQM partner pack: MV policy + receipt + attachments (+ `tqm.pdf` for original) |

Path-variable patterns: `docType` = `original|copy`. `policyType` (MV, TQM) = `1|2p|3|3p`. `productType` = `mv|mc|mvc`. `receiptType` = `increase|decrease`.

---

## Endpoints

All business endpoints return a **PDF stream** on success. The error bodies are JSON (see Overview). Every body field is an optional **string** unless stated otherwise (they are display values: pre-formatted Thai dates and amounts).

### 1. `GET /healthcheck`
**200:** `alive` (text).

### 2. `POST /api/v1/jasper-report/mv/policy/{policyType}/{docType}`
**Body:** `PolicyMVRequest` (78 props). Key groups:

| Group | JSON fields |
|---|---|
| Control | `encrypt` (PDF password, used for original), `oic_version` (non-empty → 2026 template set), `is_broker`, `broker_name`, `broker_license_no`, `qrcode_attached_file_url`, `ref_policy_no` |
| Policy header | `ph_comp_code`, `ph_full_policy_no`, `ph_policy_no`, `ph_car_act_no`, `ph_policy_startdate_th`, `ph_policy_enddate_th`, `ph_effective_startdate_1/2`, `ph_endorse_id` |
| Insured / drivers | `ph_owner_full_name`, `ph_owner_occupation`, `ph_owner_full_address`, `ph_par_full_name_1..5`, `ph_par_birth_date_1/2_th`, `ph_par_occupation_1..5`, `ph_bene_full_name` |
| Vehicle | `ph_usage`, `ph_group`, `ph_brand`, `ph_model`, `ph_car_license_no`, `ph_car_license_provice`, `ph_car_serial_no`, `ph_year`, `ph_bodytype`, `ph_full_seat`, `ph_car_price`, `garage_type` |
| Coverage / premium | `pc_si_tpbi_limit`, `pc_si_tppd_limit`, `pc_si_limit_1/2`, `pc_si_mv01_limit_1/2`, `pc_seat_1/2`, `pc_si_mv02_limit`, `pc_si_mv03_limit`, `pc_total_amt_exclude_mv`, `pc_total_amt_mv`, `pc_namedage_amt`, `pc_si_dd_amt`, `pc_fleet_disc_perc`, `pc_ncb_disc_perc`, `pc_other_disc_amt`, `pc_total_disc_amt`, `pc_perm_amt`, `pc_duty_amt`, `pc_vat_amt`, `pc_total_amt`, `pc_premium_v5_od`, `ph_sc_premium_amt`, `pc_total_premium_amt`, `pc_change_*` |
| Attachments | `pc_flag_cctv` (`Y` → camera attachment page), `flag_access` (`Y` → accessory page), `si_access`, `access_name` |

```json
{ "encrypt": "1111111111119", "oic_version": "2026", "ph_policy_no": "V2609…", "ph_owner_full_name": "นาย กฤษณะ วัฒนายนนต์",
  "ph_brand": "TOYOTA", "ph_model": "YARIS", "pc_total_amt": "15,000.00", "pc_flag_cctv": "N", "flag_access": "N",
  "is_broker": "", "qrcode_attached_file_url": "" }
```
**Template selection** (`MVRepositoryImpl.policy`, `JasperFileNameUtils.getMvJasperFileName`):
- Legacy (no `oic_version`): `report/mv/policy/MV_Policy_1_3_TH[_Broker]_{Original|Copy}.jasper` for types 1/3, `MV_Policy_2p_3p_TH_{Original|Copy}.jasper` for 2+/3+.
- 2026 (`oic_version` set): `report/mv/policy/2026/MV_Policy_{1_3|2p|3p}_TH[_Broker]_{Original|Copy}_2026.jasper`, plus RY attachments (`RY_26`/`RY_31 _TH_*_2026`, via `AttractRYUtils.attractRYForMV`).
- `+ MV_Policy_Device_Camera_Attachment_TH.jasper` if `pc_flag_cctv=Y`, and `+ MV_Policy_Device_Modify_Attachment_TH.jasper` if `flag_access=Y`.
- The output is encrypted with `encrypt` only if `docType=original` **and** `encrypt` is non-empty.

**Hard-coded params:** `fix_1..fix_10` (for example `fix_2` = 10,000,000.00 legacy / 20,000,000.00 in 2026; `fix_9` = the attached RY list).
**Errors:** 400 `si_access, access_name field is required for flag_access = 'Y'` (⚠️ calls `getAccessName().isEmpty()` before the null check, so a missing `access_name` becomes a 500 NPE), 400 path-pattern violation, 500 `Failed to generate PDF document.` / `OutputStream Failed`.
⚠️ `is_broker` and `qrcode_attached_file_url` are dereferenced without null checks (`.equals("")`, `.isEmpty()`). Leaving them out probably causes a 500.

### 3. `POST /api/v1/jasper-report/mv/claim/third-party`
**Body:** `ClaimMVThirdPartyRequest`: `survey_date, ref_notify_no, ref_claim_no, policy_type, car_register_no_0/1, accident_place, accident_district, accident_province, car_brand_0/1, car_color_0/1, asset_name, full_accident_place, full_accident_notify, accident_type, acc_policy_no, img1_place, img1_insured, img1_other, img2_other, img3_other` (image **URLs**).
**Template:** `report/mv/claim/MV_Claim_Third_Party.jasper`. Each image is fetched server-side and resized.
**Outbound:** HTTP(S) GET to each `img*` URL. ⚠️ SSRF.

### 4. `POST /api/v1/jasper-report/mv/claim/insurance`
**Body:** `ClaimMVInsuranceRequest`: `survey_date, ref_notify_no, ref_claim_no, policy_type, car_register_no_0, car_brand_0, car_color_0, full_accident_place, full_accident_notify, accident_type, acc_policy_no, img1_place, img1_insured, img1_other, img2_other, img3_other`.
**Template:** `report/mv/claim/MV_Claim_Insurance.jasper`. **Outbound:** image URLs (SSRF, same as #3).

### 5. `POST /api/v1/jasper-report/mc/policy/{docType}`
**Body:** `PolicyMCRequest`: `ref_policy_no, encrypt, 1_barcode, 2_ca_no, 3_e_date, 3_e_date_1/2/3, 4_c_code, 5_p_no, 6_qua_no, ph_owner_full_name, ph_owner_full_address, 15_p_startdate, 16_p_enddate, 17_car_comp, 18_brand, 19_model, 20_lic_no, 21_lic_prov, 22_serial_no, 23_bodytype, 24_seat_size_wg, 25_prem, 26_discount, 27_net_prem, 28_stamp, 29_vat, 30_total, 31_car_use_text, 32_c_name, 33_p_book, qrcode_attached_file_url, is_broker, broker_name, broker_license_no, oic_version`.
**Template:** `report/mc/policy/MC_Policy_TH_{Original|Copy}.jasper`, or in 2026 `report/mc/policy/2026/MC_Policy_TH[_Broker]_{Original|Copy}_2026.jasper`. Encrypted if original and `encrypt` is set. (Unlike PA/TA/Home/Tax, a password is not *required*.)

### 6–8. Endorsements `POST /api/v1/jasper-report/endorse/{ry|ryp|pr}/{docType}`
**Bodies:** `EndorseRYRequest` (70 props), `EndorseRYPRequest` (68), `EndorsePRRequest` (38). They share the MV policy fields plus `endorse_type`, `ph_endorse_id`, `38_extend_s_date`, `pc_change_prem_amt`, `pc_change_prem_amt_2`, `pc_change_duty_amt`, `pc_change_vat_amt`, `pc_change_total_amt`, `cctv_action`, `accessory_action`, `deduct`, `partner_code` and `oic_version`. RYP adds `type` (`2+`/`3+`), `pc_total_amt_exclude_mv_v5` and `pc_total_disc_amt_v5`. PR uses the MC numeric-prefixed fields (`4_c_code`, `34_p_book`, `35_p_invoice`, `36_endorse_date`, `ph_change_takes_effect`, `15_p_startdate` … `30_total`, `5_p_no`, `3_e_date_3`).
**`endorse_type`** is mapped by `shared/helper/MappingEndorseType.java`:
- v0 (PR): `v0_05, v0_11, v0_17, v0_19, v0_23` → `PR_{05|11|17|19|23}_TH`
- v1 (RY): `v1_05, v1_11, v1_17, v1_18, v1_18_p, v1_19, v1_20, v1_23, v1_24, v1_26, v1_27, v1_28, v1_31` → `RY_xx_TH`
- v5 (RYP): `v5_05, v5_11, v5_17, v5_18, v5_18_p, v5_19, v5_20, v5_23, v5_24, v5_26, v5_27, v5_28` → `RYP_xx_TH[_2+|_3+]` (and `RYP_01_TH`)

**Template path:** `report/endorsement/[2026/]{base}_{Original|Copy}[_2026].jasper`, plus camera or accessory attachment pages (`MV_Policy_Device_Camera_Attachment[_Cancel]_TH.jasper`, `MV_Policy_Device_Modify_Attachment_TH.jasper`) depending on `cctv_action`/`accessory_action` for `*_18`/`*_20`. Encrypted if original and `encrypt` is set.
**Errors:** 400 `endorse_type is not found`.

### 9–10. `POST /api/v1/jasper-report/receipt/{mv|mc}`
**Body:** `ReceiptPolicyRequest` (53 props): `policy_type` (required for `/mv`: `1|2p|3|3p`; `/mc` forces the MC value), `1_p_book, 2_p_invoice, 3_e_startdate, 11_zipcode, 12_citizen, 13_occupation, 14_total_amt_text, 15_perm_amt, 16_duty_amt, 17_perm_duty_amt, 18_vat_amt, 18_vat_per, 19_total_amt, 20_p_no, 21_p_quat, 22_usage, 23_brand, 24_model, 25_car_lin, 26_car_lin_prov, 27_car_serial, 28_seat_size_wg, 30_p_start, 31_p_end_d, 31_p_end_d_time, 33_si, 34_access, 35..42_par1/2_*, 70..73_par3_*, 43_car_use_text, 44_p_e_start, 45_paydate_day/month/year, 47_owner_full_name, 48_owner_full_address, 49_owner_full_country, 50_select_par, 51_appr_name, 52_policy_year_count, oic_version, partner_code`.
**Template:** `report/receipt/Policy_Receipt_TH.jasper` (legacy), `report/receipt/2026/Policy_Receipt_TH_2026.jasper` (`oic_version` set), or `report/tqm/receipt/Policy_Receipt_TH_TQM.jasper` (`partner_code` = `tqm`).
**Errors:** 400 `policy_type must be '1' or '2p', '3', '3p'`.

### 11. `POST /api/v1/jasper-report/receipt/no-vat`
**Body:** `ReceiptNoVatRequest`: `1_policy_book, 1_policy_invoice, 1_policy_paydate(_day/_month/_year), 3_amt_net, 3_amt_stamp, 3_amt_net_stamp, 3_amt_vat, 3_amt_total, full_name, address, subdistrict_and_district, province_and_zipcode, 2_owner_card_id, number_to_text, 4_pay_invoice, 4_policy_startdate, 4_policy_enddate, 4_policy_quo, 5_receiver, 6_approver, policy_year`.
**Template:** `report/receipt/Receipt_Non_Vat.jasper`.

### 12. `POST /api/v1/jasper-report/receipt/tax-invoice`
**Body:** `TaxInvoiceRequest`: the #11 fields plus `3_vat_per` and `policy_type` (`inbound` → `Tax_Invoice_Inbound.jasper` with `branch_no="-"`, otherwise `Tax_Invoice.jasper`).

### 13. `POST /api/v1/jasper-report/receipt/endorse/{productType}`
**Body:** `ReceiptPolicyEndorseRequest` (68 props): `partnercheck`, `policy_type`, `prev_1_p_book`, `prev_2_p_invoice`, `prev_3_e_startdate`, the receipt fields from #9, `53_endorse_no`, `58_first_create_date`, `59_first_payment_date_*`, `60_receipt_total_amt_text`, `61..65_receipt_*_amt`, `66_receipt_book`, `67_receipt_invoice`, `68_receipt_quat`, `69_receipt_startdate`, `70..81_par3..5_*`, `oic_version`.
**Template:** `report/receipt/[2026/]Motor_Receipt_Adjustment[_2026].jasper`. When `partnercheck=Y` it uses TQM (`report/tqm/receipt/Motor_Receipt_TQM.jasper`) ⚠️ exact branch not fully traced.
**Errors:** 400 `policy_type` when `productType=mv` and it is invalid.

### 14. `POST /api/v1/jasper-report/receipt/endorse/motor-debt/{receiptType}`
**Body:** `ReceiptMotorDebtRequest` (35 props): `1_p_book, 2_p_invoice, 3_e_startdate, full_insur_name, full_address_1/2, 12_citizen, 15_perm_amt, 16_duty_amt, 17_perm_duty_amt, 20_p_no, 21_p_quat, 26_car_lin_prov, 30_p_start_d, 31_p_end_d, 44_p_e_start_day/month/year, 53_endorse_no, 54..59_new/change_*, 62_c_prem_duty_vat_amt, 63_c_total_amt(_2), 64_old_p_invoice, 72_old_p_book, 65_account_txt, 66_reason_txt, 67_year_count, 68_approve_name, partner_code`.
**Template:** `Motor_Debt_{Increase|Decrease}.jasper` (`report/receipt/`), or `_TQM` (`report/tqm/receipt/`) when `partner_code` is tqm.

### 15. `POST /api/v1/jasper-report/pa/policy/{docType}`
**Body:** `PolicyPARequest`: `encrypt` (**required for original**), `package_code`, `1_comp_code, 1_policy_no, full_name, address, subdistrict_and_district, province_and_zipcode, 3_owner_card_id, 3_owner_occup, 3_owner_occup_class, 3_owner_age, 4_bene_full_name, 5_bene_relation, 6_p_startdate, 6_p_starttime, 6_p_enddate, 7_cover_si_1/2, 7_prem_amt_1/2, 8_discount_amt, 8_prem_amt, 8_duty_amt, 8_total_amt, 9_policy_date`.
**`package_code` → template:** `SPA2023001` → `PA_Policy_Death_Inheritance`, `SPA2023002` → `…_Inheritance_Medical`, `SPA2023003` → `PA_Policy_Death_Debt`, `SPA2023004` → `…_Debt_Medical`. The file is `report/pa/{name}_{Original|Copy}.jasper` + `{name}_Cover.jasper`.
**Errors:** 400 `Encryption field is required for original documents.`

### 16. `POST /api/v1/jasper-report/ta/policy/{docType}`
**Body:** `PolicyTARequest` (47 props): `encrypt` (**required for original**), `2_comp_name, 3_policy_no, 3_policy_type` (`inbound` → Inbound templates; also drives the single/multi-trip flags), `full_name_and_tel, full_name, full_address, package_name` (`S|M|L`), `4_owner_phone, 5_owner_card_id, 5_owner_age, 6_bene_info, 7_bene_relation, 8_cover_no, 8_travel_target, 9_travel_country, 10_travel_cover_loc, 11_travel_day/startdate/starttime/enddate/endtime, 12_amt_discount/net/stamp/tax/total, 14_policy_createdate_1/2, 6_si_amt … 19_si_amt, 9/13/16_min_amt, 9/13/16_max_amt`, `flag_add_on` (**boolean**).
**Templates:** `report/ta/TA_Policy[_Inbound]_{Original|Copy}.jasper`, plus `TA_Policy[_Inbound]_Package_{S|M|L}.jasper`, plus `TA_Addon_Coverage_{1_1,1_2,2_1}.jasper` when `flag_add_on`.

### 17. `POST /api/v1/jasper-report/home/policy/{docType}`
**Body:** `PolicyHomeRequest`: `encrypt` (**required for original**), `building_code` (`HHI2023001` → `Home_Policy_Home`, `HHI2023002` → `Home_Policy_Condo`), `4_resident_type, full_name, policy_no, full_address, full_build, 6_p_startdate, 6_p_starttime, 6_p_enddate, 7_cover_si_1..8, 7_cover_si_include_1_2, flag_glass, flag_theft, flag_third_party, 8_prem_amt, 8_duty_amt, 8_vat_amt, 8_total_amt, 9_policy_date, 4_fullname_bene`.
**Templates:** `report/home/{name}_{Original|Copy}.jasper` + `{name}_Cover.jasper`.

### 18. `POST /api/v1/jasper-report/tax/deduction/{docType}`
**Body:** `TaxDeductionRequest`: `encrypt` (**required for original**), `1_tax_dd_no, 1_tax_dd_date, 2_full_name, 2_full_addrees_tax, 2_full_addrees_sub_and_district, 2_address_province_and_zipcode, 3_owner_card_id, 3_policy_no, 4_payment_date, 4_invoince_no, 4_total_amt, 4_tax_dd_amt`.
**Template:** `report/tax/Tax_DD.jasper`.

### 19. `POST /api/v1/jasper-report/tqm/{policyType}/{docType}`
**Body:** `TqmRequest` (123 props). This is the MV policy fields (#2) plus the receipt fields (#9), `ph_owner_full_address_2`, `deduct` and `pc_change_*`.
**Flow:** it builds the MV policy pages (the same template rules as #2). If `1_p_book` or `2_p_invoice` is non-empty, it appends the TQM receipt (`Policy_Receipt_TH_TQM.jasper`), then the CCTV/accessory/RY attachments. For `original` it merges the static `src/main/resources/tqm.pdf`. `oic_version` null → `generateTqmDocument`, otherwise `generateTqmDocumentNewOIC`.
**Errors:** 400 `ACCESS_REQUIRED` (same NPE risk as #2).

---

## Report templates (.jrxml) and parameters (รายการเทมเพลตรายงานและพารามิเตอร์)

**Where the sources are:** only **1** `.jrxml` is in `src/` (`src/main/resources/report/endorsement/RYP_23_TH_Copy.jrxml`, 61 params). The Jasper Studio sources are in `export_jasper_studio_project.zip`: **111** `.jrxml` entries (4 of them are `__MACOSX` resource forks, so **107 real**). The runtime uses **341** compiled `.jasper` files. **No `.jrxml` source exists** for the `*_2026`, `*_Broker*`, `*_TQM`, `RY_31`, `MV_Policy_Device_Camera_Attachment_Cancel_TH` and `2+`/`3+` RYP variants. ⚠️ Only the compiled forms exist, so their parameters are known only from the Java parameter maps.

All templates use parameters only (`JREmptyDataSource`, no SQL). Every parameter is a `String`, filled from the DTO with `Objects.requireNonNullElse(x, "")`.

### Template inventory (zip `export_jasper_studio_project/`)

| Folder | Templates (param count) |
|---|---|
| `MV_Policy/` | `MV_Policy_1_3_TH_Original` (62), `MV_Policy_1_3_TH_Copy` (62), `MV_Policy_1_3_TH_QRCode_Copy` (62), `MV_Policy_2p_3p_TH_Original` (60), `MV_Policy_2p_3p_TH_Copy` (60), `MV_Policy_Device_Camera_Attachment_TH` (3), `MV_Policy_Device_Modify_Attachment_TH` (5) |
| `MC_Policy/` | `MC_Policy_TH_Original` (32), `MC_Policy_TH_Copy` (32), `Policy_Receipt_TH` (52) |
| `Endorsement/` RY | `RY_{05,17}_TH_{Original,Copy}` (60), `RY_{11,18,19,20,23,24,26,27,28}_TH_{Original,Copy}` (59) |
| `Endorsement/` RYP | `RYP_{01,19,20,23,24,26,27,28}_TH_{Original,Copy}` (55), `RYP_{05,17,18}_TH_{Original,Copy}` (56) |
| `Endorsement/` PR | `PR_{11,17,19,23}_TH_{Original,Copy}` (32), `PR_05_TH_{Original,Copy}` (33) |
| `Endorsement/` receipts | `Motor_Receipt_Adjustment` (55), `Motor_Debt_Increase` (36), `Motor_Debt_Decrease` (33) |
| `PA/` | `PA_Policy_Death_{Debt,Debt_Medical,Inheritance,Inheritance_Medical}_{Original,Copy}` (37), `…_Cover` (3), `Receipt_Non_Vat` (25), `Tax_DD` (12) |
| `TA/` | `TA_Policy_{Original,Copy}` (32), `TA_Policy_Inbound_{Original,Copy}` (33), `TA_Policy[_Inbound]_Package_{S,M,L}` (1), `TA_Addon_Coverage_1_1` (7), `TA_Addon_Coverage_2_1` (7), `TA_Addon_Coverage_1_2` (6), `Tax_Invoice_Inbound` (24) |
| `Home/` | `Home_Policy_{Home,Condo}_{Original,Copy}` (25), `Home_Policy_{Home,Condo}_Cover` (12), `Tax_Invoice` (25) |
| `Claim/` | `MV_Claim_Third_Party` (28), `MV_Claim_Insurance` (21), `Blank_A4` (1) |
| `MyReports/` | `Blank_A4` (22), `MC_Policy` (0): scratch files, not used at runtime |

### Parameters by template family (from the `.jrxml` `<parameter name=…>`)

| Family (representative template) | Parameters |
|---|---|
| **MV policy 1/3** (`MV_Policy_1_3_TH_Original`) | `ref_policy_no, ph_comp_code, ph_full_policy_no, ph_car_act_no, ph_owner_full_name, ph_owner_occupation, ph_owner_full_address, ph_par_full_name_1/2, ph_par_birth_date_1/2_th, ph_par_occupation_1/2, ph_bene_full_name, ph_policy_startdate_th, ph_policy_enddate_th, ph_usage, ph_group, ph_brand, ph_model, ph_car_license_no, ph_car_license_provice, ph_car_serial_no, ph_year, ph_bodytype, ph_full_seat, pc_si_tpbi_limit, pc_si_tppd_limit, pc_si_limit_1/2, pc_si_mv01_limit_1/2, pc_seat_1/2, pc_si_mv02_limit, pc_si_mv03_limit, pc_total_amt_exclude_mv, pc_total_amt_mv, pc_namedage_amt, pc_si_dd_amt, pc_fleet_disc_perc, pc_ncb_disc_perc, pc_other_disc_amt, pc_total_disc_amt, pc_perm_amt, pc_duty_amt, pc_vat_amt, pc_total_amt, ph_effective_startdate_1/2, fix_1..fix_10, qrcode_attached_file_url, qrcode_title` |
| **MV policy 2+/3+** (`MV_Policy_2p_3p_TH_Original`) | Same as 1/3 minus `pc_total_amt_mv`, `pc_namedage_amt`, `fix_9`, plus `pc_premium_v5_od` |
| MV attachments | Camera: `ph_policy_startdate_th, ph_policy_enddate_th, ph_policy_no`. Modify: the same plus `si_access, access_name` |
| Java-only extra params passed to MV/TQM (used by the 2026 compiled templates) | `encrypt, pc_premium_v5_od, ph_policy_no, pc_flag_cctv, flag_access, si_access, access_name, broker_name, broker_license_no, ph_par_full_name_3..5, ph_par_occupation_3..5, ph_car_price, ph_sc_premium, garage_type, pc_total_premium` |
| **RY endorsement** (`RY_05_TH_Original`) | The MV policy header, insured, vehicle and coverage params plus `ph_endorse_id, 38_extend_s_date, pc_change_prem_amt, pc_change_prem_amt_2, pc_change_duty_amt, pc_change_vat_amt, pc_change_total_amt, fix_1..fix_7, fix_10, fix_11` |
| **RYP endorsement** (`RYP_05_TH_Original`) | Like RY, but `pc_total_amt_exclude_mv_v5, pc_total_disc_amt_v5, pc_premium_v5_od, fix_8` and no birth-date/`pc_total_amt_mv` |
| **PR endorsement** (`PR_05_TH_Original`) | `4_c_code, ph_endorse_id, 34_p_book, 3_e_date, 35_p_invoice, ph_owner_full_name, ph_owner_full_address, 36_endorse_date, ph_change_takes_effect, 15_p_startdate, 16_p_enddate, 17_car_comp, 18_brand, 19_model, 20_lic_no, 21_lic_prov, 22_serial_no, 23_bodytype, 24_seat_size_wg, 25_prem, 26_discount, 27_net_prem, 28_stamp, 29_vat, 30_total, 31_car_use_text, 38_extend_s_date, pc_change_*, 5_p_no` |
| **MC policy** (`MC_Policy_TH_Original`) | `1_barcode, 2_ca_no, 3_e_date, 3_e_date_1/2, 4_c_code, 5_p_no, 6_qua_no, ph_owner_full_name, ph_owner_full_address, 15_p_startdate, 16_p_enddate, 17_car_comp, 18_brand, 19_model, 20_lic_no, 21_lic_prov, 22_serial_no, 23_bodytype, 24_seat_size_wg, 25_prem, 26_discount, 27_net_prem, 28_stamp, 29_vat, 30_total, 31_car_use_text, 32_c_name, 33_p_book, ref_policy_no, qrcode_attached_file_url, qrcode_title` |
| **Policy receipt** (`Policy_Receipt_TH`) | `1_p_book, 2_p_invoice, 3_e_startdate, 15_perm_amt, 16_duty_amt, 17_perm_duty_amt, 18_vat_per, 18_vat_amt, 19_total_amt, 20_p_no, 21_p_quat, 22_usage, 23_brand, 24_model, 25_car_lin, 26_car_lin_prov, 27_car_serial, 28_seat_size_wg, 30_p_start, 31_p_end_d, 33_si, 34_access, 44_p_e_start, 45_paydate_day/month/year, fix_1, fix_2, 43_car_use_text, 47_owner_full_name, 48_owner_full_address, 49_owner_full_country, 11_zipcode, 12_citizen, 13_occupation, 52_policy_year_count, policy_type_1, policy_type_mc, policy_type_3, policy_type_5, 14_total_amt_text, 50_select_par_no/yes, 51_appr_name, 35..42_par1/2_{name,dob,occ,citizen}` |
| **Endorse receipt** (`Motor_Receipt_Adjustment`) | The receipt set with `61_receipt_perm_amt, 62_receipt_duty_amt, 63_receipt_perm_duty_amt, 64_receipt_vat_amt, 65_receipt_total_amt, 66_receipt_book, 67_receipt_invoice, 68_receipt_quat, 69_receipt_startdate, 58_first_create_date, 59_first_payment_date_day/month/year, 60_receipt_total_amt_text` |
| **Debit/credit note** (`Motor_Debt_Increase`) | `1_p_book, 2_p_invoice, 3_e_startdate, full_insur_name, full_address_1/2, 12_citizen, 15_perm_amt, 16_duty_amt, 17_perm_duty_amt, 20_p_no, 21_p_quat, 26_car_lin_prov, 30_p_start_d, 31_p_end_d, fix_1, fix_2, 53_endorse_no, 54_new_prem_amt, 55_new_duty_amt, 56_new_prem_duty_amt, 57_change_prem_amt, 58_change_duty_amt, 59_change_prem_duty_amt, 62_c_prem_duty_vat_amt, 63_c_total_amt(_2), 64_old_p_invoice, 72_old_p_book, 65_account_txt, 66_reason_txt, 67_year_count, 68_approve_name, 44_p_e_start_day/month/year` (the Decrease template has no `44_*`) |
| **PA policy** (`PA_Policy_Death_Debt_Original`) | `1_comp_code, 1_policy_no, 2_owner_title/firstname/lastname, address, 2_owner_subdistrict/district/province/zipcode, 3_owner_card_id, 3_owner_occup, 3_owner_occup_class, 3_owner_age, 4_bene_title/firstname/lastname, 4_bene_full_name, 5_bene_relation, 6_p_startdate, 6_p_starttime, 6_p_enddate, 7_cover_si_1/2, 7_prem_amt_1/2, 8_discount_amt, 8_prem_amt, 8_duty_amt, 8_total_amt, 9_policy_date, 9_policy_date_1, 0_package_id, to_email, full_name, subdistrict_and_district, province_and_zipcode`. Cover: `1_policy_no, 7_cover_si_1, 7_cover_si_2` |
| **Home policy** (`Home_Policy_Home_Original`) | `full_name, policy_no, full_address, full_build, 4_resident_type_owner, 4_resident_type_renter, 6_p_startdate, 6_p_starttime, 6_p_enddate, 7_cover_si_1..3, 7_cover_si_5..8, 7_cover_si_include_1_2, flag_glass, flag_theft, flag_third_party, 8_prem_amt, 8_duty_amt, 8_vat_amt, 8_total_amt, 9_policy_date`. Cover: `policy_no, 6_p_startdate, 6_p_enddate, 7_cover_si_1..8, 4_fullname_bene` |
| **TA policy** (`TA_Policy_Original`; Inbound adds `journey`) | `1_stamp_txt, 2_comp_name, 3_policy_no, 3_policy_type_single_trip, 3_policy_type_multi_trip, full_name_and_tel, full_name, full_address, 4_owner_phone, 5_owner_card_id, 5_owner_age, 6_bene_info, 7_bene_relation, 8_cover_no, 8_travel_target_{leisure,business,study,other}, 9_travel_country, 10_travel_cover_loc, 11_travel_day, 11_travel_startdate/starttime/enddate/endtime, 12_amt_discount/net/stamp/tax/total, 14_policy_createdate_1/2`. Package pages: `3_policy_no`. Add-ons: `3_policy_no` + `6..10_si_amt, 9_min/max_amt` (1_1) or `11..14_si_amt, 13_min/max_amt` (1_2) |
| **Tax invoice / Non-VAT receipt** (`Home/Tax_Invoice`, `PA/Receipt_Non_Vat`, `TA/Tax_Invoice_Inbound` adds `branch_no`) | `1_policy_book, 1_policy_invoice, 1_policy_paydate(_day/_month/_year), full_name, address, subdistrict_and_district, province_and_zipcode, number_to_text, 2_owner_card_id, 3_amt_net, 3_amt_stamp, 3_amt_net_stamp, 3_amt_vat, 3_vat_per, 3_amt_total, 4_pay_invoice, 4_policy_quo, 4_policy_startdate, 4_policy_enddate, 5_receiver, 6_approver, policy_year` |
| **Tax deduction** (`PA/Tax_DD`) | `1_tax_dd_no, 2_full_name, 2_full_addrees_tax, 2_full_addrees_sub_and_district, 2_address_province_and_zipcode, 1_tax_dd_date, 3_owner_card_id, 3_policy_no, 4_payment_date, 4_invoince_no, 4_total_amt, 4_tax_dd_amt` |
| **Claim reports** (`MV_Claim_Third_Party`; Insurance is a subset) | `survey_date, ref_notify_no, ref_claim_no, policy_type, car_register_no_0/1, accident_place, accident_district, accident_province, car_brand_0/1, car_color_0/1, asset_name, full_accident_place, full_accident_notify, accident_type, acc_policy_no, img{1_place,1_insured,1_other,2_other,3_other}` (image stream) + `…_url` |

---

## DB Usage

**None.** This service has no database connection, no JDBC/JPA dependency, and no SQL in its templates. All data arrives in the request body. The callers (for example the Go document/core services) own the DB reads. ⚠️ The callers were not traced in this pass.

| Table / function | R/W | Endpoints |
|---|---|---|
| — | — | — |

---

## Notes / ⚠️ unverified items

### Security findings (ข้อค้นพบด้านความปลอดภัย)
1. **No authentication.** Anyone who can reach the service can render official-looking policy, receipt, tax-invoice and tax-deduction PDFs with arbitrary content (document forgery). It should be reachable only on the internal network. ⚠️ Ingress exposure was not verified from the Helm files.
2. **SSRF:** the claim endpoints (#3, #4) fetch any client-supplied URL with `java.net.URL` (http, https, and also `file:`/`jar:` schemes), for example cloud metadata or internal services. There is no allow-list.
3. **The PDF password is the `encrypt` value sent by the caller, and it is used as both the user and the owner password.** ⚠️ Probably a citizen ID or date of birth, so it is weak. The owner password equals the user password, so the permission restrictions do not really protect anything.
4. **Bean validation does nothing.** The DTOs have no constraints, and several null dereferences (`getAccessName().isEmpty()` before the null check, `getIsBroker().equals("")`, `getQrcodeAttachedFileUrl().isEmpty()`) turn into 500s. `GlobalExceptionHandler` echoes `ex.getMessage()` back to the client (information leak).
5. Up to 5 claim images (`img1_place`, `img1_insured`, `img1_other`, `img2_other`, `img3_other`) are fetched and resized per request with no connect/read timeout set in `ImageResizer`. ⚠️ Slow or huge remote images can tie up request threads (DoS).

### Gaps
- `ReceiptTAPolicyRequest` DTO is defined but no controller uses it.
- Most `.jrxml` sources live only in a zip. None exist for the 2026, broker or TQM variants, so those templates can't be edited or reviewed from source.
- The zip also contains `__MACOSX` junk and scratch `MyReports/*`.
- TQM original merges `tqm.pdf` from the classpath. `TqmController` passes the literal string `"@src/main/resources/tqm.pdf"`. ⚠️ How that path is resolved at runtime was not verified (the default in `AttractRYUtils` is `tqm.pdf`).
- The exact TQM branch conditions in `ReceiptRepositoryImpl.printReceiptEndorse` (`partnercheck`) were only partly traced.
