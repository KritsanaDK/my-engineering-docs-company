# Daily Troubleshooting Playbook & GCP Log Knowledge Base

**Date:** 2026-09-15 (Audit Updated: 2026-09-23 - Post Release af1dda7 & WS1-UAT-ISV 059c275; Schema Audit 2026-09-23: SQL ทุกข้อตรวจกับ `information_schema` + `EXPLAIN` บน UAT-ISV แล้ว — แก้ #11, #13, #18, #21, #22, #26)
**Topic:** GCP Production Logs Analysis & Resolution Guides (คู่มือวิเคราะห์และแก้ปัญหาจาก Log GCP)
**Status:** Audited against Git `origin/main` (ตรวจสอบสถานะจริงเทียบกับ Branch Main ของทุกระบบ)

---

| ระดับความสำคัญ (Priority)      | จำนวน (Count) | รายการปัญหา (Issues Included)                                                                                                              | ผลกระทบหลัก (Key Impact)                                                                                                               |
| :----------------------------- | :-----------: | :----------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------- |
| **P0 - Critical** (ด่วนที่สุด) |     **8**     | Issue #7, Issue #10, **Issue #13**, **Issue #16**, **Issue #18**, **Issue #21**, **Issue #22**, **Issue #26** <br>_(+ 3 เคสจริง: Lead 255955, Lead 257307, Lead 258748)_ | 2C2P Callback 502 ปิดสายหนี / SMTP TLS ล่ม E-Policy ส่งไม่ออก 591 ราย / 2C2P Panic เงินตัดแต่ E-Policy ไม่ออก / UAM ล่ม |
| **P1 - High** (สำคัญสูง)       |    **12**     | Issue #1, Issue #2, Issue #3, Issue #5, Issue #8, Issue #9, **Issue #14**, **Issue #15**, **Issue #17**, **Issue #19**, **Issue #23**, **Issue #27** | IIA Silent Fail / SF ขาดกรมธรรม์หลัก / CMI ปฏิเสธทะเบียน / OCR Passport DNS / OpenAPI Motor เบี้ยพัง / Shortener ติด WAF                |
| **P2 - Medium** (สำคัญปานกลาง) |     **7**     | Issue #4, Issue #6, Issue #11, Issue #12, **Issue #20**, **Issue #24**, **Issue #25**                                                    | Replica Lag / สลักหลังไม่ออก / ส่ง SMS ผิด / Cloud SQL CPU Spike / LB 503 ((no backend)) / CORS Preflight 503                            |
| **รวมทั้งหมด (Total)**         |    **27**     | **27 ปัญหาเชิงระบบ + 3 Incident เคสจริง**                                                                                                  | ครอบคลุม Purchase, Policy, UAM, Premium, SF, Lead-Policy, Document, Notification, Cloud SQL, OAuth, Analytics, OpenAPI                     |

---

## 2. 📑 สารบัญและชื่อปัญหาแบบสั้น: เปรียบเทียบสถานะ main vs uat-isv (Quick Reference)

| ลำดับ (No.) | ระดับ | ชื่อปัญหาแบบสั้น (Short Title) | ระบบที่พบ (Service) | 1. แก้ไขรึยัง<br>(Fix Ready) | 2. UAT-ISV<br>(Tested) | 3. PROD<br>(Live) | ผลกระทบและสถานะล่าสุด (Impact & Detail) |
| :---: | :---: | :--- | :--- | :---: | :---: | :---: | :--- |
| **1** | **P1** | **IIA ไม่ส่ง / Log ไม่บอกเหตุผล** _(IIA Silent Fail)_ | `purchase` / `uam` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | โค้ดบน `origin/main` (`edc8884`, `e0bfcd5`, `9d3b3a4`) มี Stage ชัดเจน + Retry Replica Lag |
| **2** | **P1** | **SF มี Record ซ้ำ** _(Salesforce Duplicate Record)_ | `uam-service` | ✅ ทำ Guard แล้ว | ⚠️ Manual | ⚠️ Manual | Salesforce แจ้ง Duplicate Record ต้องลบ/รวมใน SF (เสริม safe pointer check `059c275`) |
| **3** | **P1** | **SF ขาดกรมธรรม์หลัก** _(SF Missing Parent Policy)_ | `uam-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | มี Stored Proc `fn_sf_policy_endorse_financial` จัดการ Parent MV ก่อน Child MC (WS6) |
| **4** | **P2** | **Load Balancer ตัด 30s** _(GCP LB 30s Timeout)_ | `notification` | ✅ แก้แล้ว | ✅ ขึ้น uat-isv แล้ว | ⏳ รอขึ้น Prod | แก้เป็น Async Worker (Commit `ae17af1` บน branch `fix/fx-01-notification`) + K8s BackendConfig 300s ใน `deploy_jobs/03_fixes/` |
| **5** | **P1** | **พ.ร.บ. ออกเลขแต่ข้าม IIA/SF** _(ACT Skipped IIA/SF)_ | `purchase-service` | ✅ แก้แล้ว (DB) | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว (DB) | DB ฟังก์ชัน `fn_lead_to_car_act` มี Advisory Lock แล้ว ป้องกันเลขชน (รอเสริม Worker ใน Go) |
| **6** | **P2** | **สลักหลังไม่ออก จาก Replica Lag** _(Endorsement Replica Lag)_ | `document` / `uam` | ✅ แก้แล้ว | ✅ ขึ้น uat-isv แล้ว | ⏳ รอขึ้น Prod | แก้เป็น Exponential Backoff Retry (Commit `35c58b7` บน branch `fix/fx-01-document`) |
| **7** | **P0** | **2C2P เลข Invoice ซ้ำ ลูกค้าจ่ายไม่ได้** _(2C2P Invoice Lockout)_ | `purchase-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | DB ฟังก์ชัน `fn_policy_invoiceno_iia` ใส่ Advisory Lock และ Loop Check แล้ว ป้องกัน 100% |
| **8** | **P1** | **ประกันสมัครใจ (MV) ส่ง IIA ไม่ผ่านเงียบๆ** _(MV Silent IIA Fail)_ | `policy-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | Reconcile Cron ดึงรายการตกหล่นส่งซ้ำเข้า IIA อัตโนมัติทุก 15 นาที + เช็คผลใน UAM |
| **9** | **P1** | **PA/Home ไม่เข้า IIA เมื่อไม่ส่งไปรษณีย์** _(PA/Home NULL Address)_ | `purchase-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | แก้ struct รับ pointer `*string` ใน Go ไม่แก้ SQL (Commit `648f298`, `af1dda7`) |
| **10** | **P0** | **ส่งตัดเงินซ้ำได้แม้ Lead จ่ายสำเร็จแล้ว** _(Repeat Charge Bypass)_ | `purchase-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | แก้ `NamedExec` บน SELECT เป็น `SELECT 1 ... LIMIT 1` ป้องกันจ่ายซ้ำ (`c299fe4`, `af1dda7`) |
| **11** | **P2** | **ส่ง SMS ต่ออายุผิด ทั้งที่ซื้อ พ.ร.บ. ใหม่แล้ว** _(False Renewal SMS)_ | `notification` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | ตรวจสอบอายุ 90 วันและเลขตัวถังอยู่ใน `fn_policy_renewal` (WS7) บน uat-isv รอขึ้น Prod |
| **12** | **P2** | **Home Service HTTP 500 ไร้ Error Log** _(Silent 500 on GetLead)_ | `home-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | เปรียบเทียบ Error string ไม่ตรง (รวม branch `hot-fix-getlead` แล้วบน uat-isv รอขึ้น Prod) |
| **13** | **P0** | **Motor Lead ชนซ้ำจาก MAX()+1** _(Motor Lead MAX+1 Race)_ | `nodejs-express-premium-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | บน `uat-isv` คือ `d031a3f` (`hotfix/motor-lead-no-default`) ใช้ `seq_lead_no` — ⚠️ DDL `seq_motor_lead_no` เดิมใช้ไม่ได้ ดูผลตรวจใน Issue #13 |
| **14** | **P1** | **CMI ปฏิเสธทะเบียนผิดมาตรฐาน ขบ.** _(CMI Invalid Plate 2BUS0216)_ | `uam-service` / `policy-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | WS3 กรองทะเบียน/จังหวัดแล้ว + OIC Sanitization ใน `hotfix/oic-uat` |
| **15** | **P1** | **URL Shortener โดน Cloudflare บล็อก** _(Short Link WAF Block)_ | `isv-test` | ✅ แก้แล้ว | ❌ ยังไม่มี | ❌ ยังมีปัญหา | Commit `92688d2` บน `fix/fx-01-isv-test` (Local) — ใส่ User-Agent + ตัด `//` ครบ 3 จุดเรียก (`/short_link`, Renewal SMS, Shopee) |
| **16** | **P0** | **UAM Email & OTP ล่มทั้งระบบ** _(UAM Hairpin Loop Failure)_ | `uam-service` | 🟡 มี Patch แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | เตรียม Patch ใน `deploy_jobs/03_fixes/helm_patches/patch_uam_prod.yaml` ชี้ Internal DNS แล้ว |
| **17** | **P1** | **Backoffice ส่ง Policy Email ล้มเหลว** _(Large PDF Resend Gateway Fail)_ | `lead-policy-service` | 🟡 มี Patch แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | เตรียม Patch ใน `deploy_jobs/03_fixes/helm_patches/patch_lead_policy_prod.yaml` แล้ว |
| **18** | **P0** | **ลูกค้าชำระเงินต่ออายุไม่ได้** _(Missing ref_policy_no on Renewal)_ | `purchase-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | Guard ป้องกันข้อมูลหลุดถาวรอยู่ใน WS7 บน uat-isv (`fn_policy_renewal`) รอขึ้น Prod |
| **19** | **P1** | **Salesforce API โดน GCP LB ตัด 30s** _(SF Endorsement Waterfall Timeout)_ | `saleforce-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | งานปรับลด Waterfall อยู่ใน WS6 บน uat-isv รอขึ้น Prod |
| **20** | **P2** | **Cloud SQL CPU Spike 17:00 SOP** _(EOD Batch vs Deploy Diagnostic)_ | Cloud SQL (`insureverse-prod`) | ℹ️ มี SOP | ℹ️ ใช้งานอยู่ | ℹ️ ใช้งานอยู่ | CPU พุ่ง 28.4% จาก Daily EOD Batch SOP ให้เช็ค Query Insights ก่อนสรุปว่าเกิดจาก Deploy |
| **21** | **P0** | **2C2P Callback Panic จาก Type Assertion** _(Salesforce Auth Nil Panic)_ | `purchase-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | แก้ nil check ใน `saleforce.go` + `sync.RWMutex` (เสริม safe `sf_account` `059c275`) |
| **22** | **P0** | **ต่อ TLS ไม่ผ่าน (ใบรับรองไม่ถูก trust) — อีเมลไม่ออก** _(SMTP TLS Unknown Authority)_ | `notification-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | อัปเกรดเป็น Distroless Debian 12 รองรับ GlobalSign Root R46 (`700776d`) |
| **23** | **P1** | **OCR Passport Reader ล่มจาก DNS NXDOMAIN** _(OCR MRZ DNS Fail)_ | `uam-service` | ✅ แก้แล้ว | ✅ รวม uat-isv แล้ว | ⏳ รอขึ้น | Fallback ตอบ 200 + `can_manual: true` แทน 500 (Commit `3c0d2ed` บน `fix/fx-01-uam`) |
| **24** | **P2** | **GCP LB 503 ((no backend)) บน Partner Token** _(OAuth2 NEG Drop)_ | `openapi-oauth-service` | 🟡 มี Patch แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | เตรียม Patch ใน `deploy_jobs/03_fixes/helm_patches/patch_oauth2_prod.yaml` (Mem 256Mi/15s) แล้ว |
| **25** | **P2** | **CORS OPTIONS 503 ((no backend)) บน Analytics** _(Analytics Preflight Drop)_ | `backend-analytics-service` | 🟡 มี Patch แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | เตรียม Patch ใน `deploy_jobs/03_fixes/helm_patches/patch_analytics_prod.yaml` (PreStop) แล้ว |
| **26** | **P0** | **2C2P Callback 502 Pod ปิดสายหนี (3.1s)** _(2C2P Callback TCP Drop)_ | `purchase-service` | ✅ แก้แล้ว | ✅ ผ่านแล้ว | ✅ ขึ้นแล้ว | ขจัด Go Panic ตัดวงจร 502 TCP Drop ตอบกลับ 200 OK สมบูรณ์ (แก้คู่กับ #21) |
| **27** | **P1** | **OpenAPI Motor เบี้ยพัง ได้รับ HTML `<` (503)** _(OpenAPI Hairpin HTML Parse Fail)_ | `openapi-motor-service` | 🟡 มี Patch แล้ว | ✅ ผ่านแล้ว | ⏳ รอขึ้น | เตรียม Patch ใน `deploy_jobs/03_fixes/helm_patches/patch_go_e_api_prod.yaml` ชี้ Internal DNS แล้ว |

### 📌 สรุปสถานะสภาพแวดล้อม (Environment Status Summary)

| สถานะสภาพแวดล้อม (Environment Status) | จำนวน (Count) | รายการปัญหา (Issues Included) | รายละเอียดและความพร้อมในการปล่อยระบบ (Details & Deployment Readiness) |
| :--- | :---: | :--- | :--- |
| **✅ แก้แล้วบน Production (main / WS1–WS5 + 21 ก.ย. Release)** | **10 ข้อ** | **Issue #1, #5, #7, #8, #9, #10, #14, #21, #22, #26** | • **#1:** แก้ไขใน `go-echo-uam-service` (`edc8884`, `e0bfcd5`, `9d3b3a4`) แยก Stage Error และ Retry Replica Lag <br>• **#5, #7:** ปัญหา Concurrency DB Function (`fn_lead_to_car_act`, `fn_policy_invoiceno_iia`) เรียบร้อยแล้ว <br>• **#8, #14:** Reconcile IIA และ CMI Regex ทำงานแล้วบน Prod <br>• **#9, #10, #21, #26:** Deploy ขึ้น Production ผ่าน Commit `af1dda7` (21 ก.ย. 2026) แก้ PA/Home Null Address Pointer, NamedExec SELECT ป้องกันจ่ายซ้ำ, และ SF Auth Thread-Safety/Nil Panic ขจัดปัญหา 502 TCP Drop 100% <br>• **#22:** แก้ไขแล้วผ่าน Commit `700776d` (MR `ca1989b`) อัปเกรดเป็น Debian 12 รองรับ GlobalSign Root R46 |
| **⏳ อยู่ที่ Branch อื่น / UAT-ISV / พร้อมขึ้น Prod** | **7 ข้อ** | **Issue #3, #4, #6, #11, #13, #18, #19** | โค้ดและสคริปต์แก้เสร็จแล้ว Deploy และทดสอบบน `uat-isv` แล้ว รอคิว Deploy ขึ้น Prod (เช่น SF Endorsement WS6, Renewal 90 วัน WS7, Motor Lead Sequence, **#4 Async Notification**, และ **#6 Endorsement Retry `fix/fx-01-document`**) |
| **⚠️ ดำเนินการแก้ปัญหาเฉพาะหน้า (Manual Ops)** | **1 ข้อ** | **Issue #2** | การรวม/ลบ Duplicate Record ใน Salesforce แล้วยิง API สั่ง Re-trigger |
| **❌ ยังไม่ได้แก้ไขบน Production (main)** | **8 ข้อ** | **Issue #12, #15, #16, #17, #23, #24, #25, #27** | โค้ด/คอนฟิกบน `main` ยังไม่ได้รับการแก้ไข (โดย **#16, #17, #24, #25, #27** จัดเตรียม Patch พร้อมขึ้นไว้ใน `deploy_jobs/03_fixes/` แล้ว) |
| **ℹ️ แนวทางปฏิบัติการ (Operational SOP)** | **1 ข้อ** | **Issue #20** | SOP ตรวจสอบ Cloud SQL CPU ช่วง 17:00 ให้เช็ค Query Insights แยกแยะ Daily Batch ก่อนตัดสินใจ Rollback |
| **รวมทั้งหมด (Total)** | **27 ข้อ** | **ครอบคลุม 27 ปัญหาเชิงระบบ** | |

---

### 🏢 2.1 ตารางจัดกลุ่มปัญหาตามระบบและเซอร์วิส: เปรียบเทียบสถานะ main vs uat-isv (Issues Grouped by Service)

| ลำดับ | ระบบ / ไมโครเซอร์วิส (Service Name) | จำนวน | รายการปัญหา (Issues Included) | ระดับความสำคัญ | สถานะบน `main` (Production) | สถานะบน `uat-isv` |
| :---: | :--- | :---: | :--- | :---: | :--- | :--- |
| **1** | **`go-echo-purchase-service`** | **6 ข้อ** | • **Issue #5:** พ.ร.บ. ออกเลขแต่ข้าม IIA/SF <br>• **Issue #7:** 2C2P เลข Invoice ซ้ำ ลูกค้าจ่ายไม่ได้ <br>• **Issue #9:** PA/Home deli_address_th = NULL <br>• **Issue #10:** NamedExec SELECT จ่ายซ้ำทะลุ <br>• **Issue #18:** Renewal missing ref_policy_no <br>• **Issue #21 & #26:** 2C2P SF Auth Nil Panic & 502 TCP Drop | **P0 (4)**<br>P1 (2) | • **#5, #7, #9, #10, #21, #26:** ✅ แก้และ Deploy แล้วบน `origin/main` (Commit `af1dda7`) <br>• **#18:** ⏳ อยู่บน `origin/hotfix/ws7-renew` รอขึ้น Prod | • **#5, #7, #9, #10, #21, #26:** ✅ รวมบน `uat-isv` แล้ว <br>• **#18:** ✅ รวมใน WS7 บน `uat-isv` แล้ว <br>• **#21:** 🛡️ เสริม safe dereference `sf_account` (Commit `059c275` / `263a6ee`) |
| **2** | **`go-echo-uam-service`** | **6 ข้อ** | • **Issue #1:** IIA Silent Fail <br>• **Issue #2:** SF มี Record ซ้ำ <br>• **Issue #3:** SF ขาดกรมธรรม์หลัก (Parent Policy) <br>• **Issue #14:** CMI ปฏิเสธทะเบียน ขบ. (Regex) <br>• **Issue #16:** UAM Hairpin Loop Email & OTP <br>• **Issue #23:** OCR Passport MRZ DNS NXDOMAIN | **P0 (1)**<br>P1 (5) | • **#1, #14:** ✅ แก้แล้วบน `origin/main` <br>• **#2:** ⚠️ จัดการ Manual บน Salesforce <br>• **#3:** ⏳ อยู่บน `uat-isv (WS6)` รอขึ้น Prod <br>• **#16, #23:** ❌ ยังไม่แก้บน `origin/main` | • **#1, #14:** ✅ รวมบน `uat-isv` <br>• **#3:** ✅ รวมใน WS6 บน `uat-isv` แล้ว <br>• **#16:** ✅ แก้แล้วบน `uat-isv` (`helm-uat-isv.yaml` ชี้ Internal DNS `backend-notification-service:8080`) <br>• **#23:** ✅ รวม `fix/fx-01-uam` (`3c0d2ed`) บน `uat-isv` แล้ว |
| **3** | **`go-echo-notification-service`** | **3 ข้อ** | • **Issue #4:** GCP LB ตัด 30s (`get_noti_policy_expire`) <br>• **Issue #11:** ส่ง SMS ต่ออายุผิด ทั้งที่ซื้อใหม่แล้ว <br>• **Issue #22:** SMTP TLS Unknown Authority (อีเมลไม่ออก) | **P0 (1)**<br>P2 (2) | • **#22:** ✅ แก้แล้วบน `origin/main` (Distroless Debian 12) <br>• **#4:** ❌ ยังไม่แก้บน `origin/main` (ขาด BackendConfig 300s) <br>• **#11:** ⏳ อยู่บน `uat-isv (WS7)` รอขึ้น Prod | • **#22:** ✅ รวมบน `uat-isv` <br>• **#11:** ✅ รวมใน WS7 (`fn_policy_renewal` เช็ค Chassis 90 วัน) <br>• **#4:** ✅ รวมและ Deploy บน `uat-isv` แล้ว (Async Worker + Concurrency Guard) |
| **4** | **`nodejs-express-premium-service`** | **1 ข้อ** | • **Issue #13:** Motor Lead ชนซ้ำจาก `MAX()+1` Race | **P0 (1)** | ⏳ ยังไม่อยู่บน `main` — ต้องเลือกระหว่าง `d031a3f` / `d20771f` และเตรียม DDL ให้ตรง (ดู Issue #13) | ✅ แก้และทดสอบแล้วบน `uat-isv` (`d031a3f` ใช้ `DEFAULT nextval('seq_lead_no')`) |
| **5** | **`go-fiber-policy-service`** | **1 ข้อ** | • **Issue #8:** ประกันสมัครใจ (MV) ส่ง IIA ไม่ผ่านเงียบๆ | **P1 (1)** | ✅ แก้แล้วบน `origin/main` (WS4 Reconcile Cron ส่งซ้ำอัตโนมัติ) | ✅ รวมบน `uat-isv` แล้ว (WS4 + OIC Compliant) |
| **6** | **`go-echo-saleforce-service`** | **1 ข้อ** | • **Issue #19:** Salesforce API Waterfall โดน LB ตัด 30s | **P1 (1)** | ⏳ อยู่บน `origin/hotfix/ws6-saleforce-endoesement` รอขึ้น Prod | ✅ รวมบน `uat-isv` แล้ว (WS6 ปรับลด Waterfall) |
| **7** | **`go-echo-lead-policy-service`** | **1 ข้อ** | • **Issue #17:** Backoffice ส่ง Policy Email ล้มเหลว (PDF ใหญ่) | **P1 (1)** | ❌ ยังไม่แก้บน `origin/main` (`helm-prod.yaml` ชี้ Hairpin นอก Cluster) | ⏳ ปรับ Helm ชี้ Internal DNS บน `uat-isv` |
| **8** | **`go-e-api` (OpenAPI Motor)** | **1 ข้อ** | • **Issue #27:** OpenAPI Motor เบี้ยพัง ได้รับ HTML `<` (503) | **P1 (1)** | ❌ ยังไม่แก้บน `origin/main` (`helm-prod.yaml` ชี้ Hairpin นอก Cluster) | ⏳ ปรับ `ISV_HOST` และ HTTP Status Code Check บน `uat-isv` |
| **9** | **`isv-test`** | **1 ข้อ** | • **Issue #15:** URL Shortener โดน Cloudflare WAF บล็อก | **P1 (1)** | ❌ ยังไม่แก้บน `origin/main` (ขาด Custom User-Agent & Trim Slash) | ⏳ ทดสอบ Custom Header บน `uat-isv` |
| **10** | **`go-echo-home-service`** | **1 ข้อ** | • **Issue #12:** Home Service GetLead HTTP 500 ไร้ Error Log | **P2 (1)** | ❌ ยังไม่แก้บน `origin/main` (Error String Mismatch ใน `home_service.go`) | ✅ รวม branch `hot-fix-getlead` บน `uat-isv` แล้ว |
| **11** | **`python-fastapi-document-service`** | **1 ข้อ** | • **Issue #6:** เอกสารสลักหลังไม่ออก จาก Replica Lag | **P2 (1)** | ⏳ อยู่บน `fix/fx-01-document` (Commit `35c58b7`) รอขึ้น `main` | ✅ รวมและ Deploy บน `uat-isv` แล้ว (เพิ่ม Exponential Backoff Retry 3 ครั้ง ป้องกัน Replica Lag) |
| **12** | **`go-oauth2-server`** | **1 ข้อ** | • **Issue #24:** GCP LB 503 ((no backend)) บน Partner Token | **P2 (1)** | ❌ ยังไม่แก้บน `origin/main` (`helm-prod.yaml` Mem 128Mi / Delay 60s) | ✅ แก้แล้วบน `uat-isv` (`helm-uat-isv.yaml` Mem 256Mi / Delay 15s) |
| **13** | **`go-echo-analytics-service`** | **1 ข้อ** | • **Issue #25:** CORS OPTIONS 503 ((no backend)) Preflight | **P2 (1)** | ❌ ยังไม่แก้บน `origin/main` (`helm-prod.yaml` Delay 60s ขาด preStop hook) | ✅ แก้แล้วบน `uat-isv` (`helm-uat-isv.yaml` Delay 15s) |
| **14** | **Google Cloud SQL (`insureverse-prod`)** | **1 ข้อ** | • **Issue #20:** Cloud SQL CPU Spike 17:00 SOP | **P2 (1)** | ℹ️ **Operational SOP** (คู่มือ Query Insights แยกแยะ EOD Batch) | ℹ️ **Operational SOP** (คู่มือ Query Insights แยกแยะ EOD Batch) |
| **รวม** | **14 ระบบ / เซอร์วิส** | **27 ข้อ** | **ครอบคลุมครบ 27 ปัญหาเชิงระบบ** | **P0: 8, P1: 12, P2: 7** | **10 แก้บน main, 7 อยู่บน UAT/รอขึ้น Prod, 1 Manual, 1 SOP, 8 ค้างแก้** | **21 แก้/รวมแล้วบน uat-isv, 4 อยู่ระหว่างทดสอบ, 1 Manual, 1 SOP** |

---

### 🔍 2.2 รายงานการตรวจเช็ค 27 ปัญหาแบบคู่ขนาน: Code + Database Stored Procedure (Dual-Inspection Report)

> **เป้าหมาย:** ตรวจสอบความเชื่อมโยงระหว่าง **Application Code (Go / Node.js / Python / Helm)** ควบคู่กับ **Database Layer (Stored Procedures, Tables, Sequences, Advisory Locks)** ครบทั้ง 27 ข้อ

| No. | ชื่อปัญหา (Issue Title) | ระบบ (Service) | ฝั่ง Application Code (จุดที่เรียก/ไฟล์โค้ด) | ฝั่ง Database / Stored Procedure (ฟังก์ชัน & ตาราง) | สถานะความพร้อม (Status) |
| :-: | :--- | :--- | :--- | :--- | :--- |
| **1** | **IIA Silent Fail** | `uam-service` | `soapController.go` (สร้าง struct `IIAError`, ดัก stage, retry replica lag) | ไม่มี Stored Proc โดยตรง; อ่านตาราง `Policy_Car_Act_Discount_Premium` 6 queries และบันทึก `log_iia_policy` | ✅ **แก้แล้วบน `main`** (Commits: `edc8884`, `e0bfcd5`, `9d3b3a4`) |
| **2** | **SF Duplicate Record** | `uam-service` | `salesforceController.go` (ยิง Apex REST `/upsertpolicy`) | Stored Proc: `fn_check_sf_account` ตรวจสอบ user; ปัญหาเกิดจาก Duplicate Rules ฝั่ง Salesforce | ⚠️ **Manual Ops บน SF** (ลบ/รวม Record ซ้ำ) |
| **3** | **SF ขาดกรมธรรม์หลัก** | `uam-service` | `salesforceController.go` (ยิงสร้าง Parent MV ก่อน Child MC) | ตาราง `Policy_Header` (แม่) vs `Policy_Car_Act_Discount_Premium` (ลูก); Stored Proc: `fn_sf_policy_endorse_financial` (WS6) | ⏳ **อยู่ที่ `uat-isv (WS6)`** |
| **4** | **LB ตัด 30s (`get_noti_expire`)** | `notification` | `notificationUser.go` ปรับเป็น Async ตอบ 200 ทันที + Concurrency Guard | Query หนักใน Background; เตรียม K8s BackendConfig 300s ใน `deploy_jobs/03_fixes/` | ✅ **แก้และ Deploy บน UAT แล้ว** / รอขึ้น Prod |
| **5** | **พ.ร.บ. ข้าม IIA/SF** | `purchase-service` | `paymentController.go:1098` (เรียก `ConnectSaleforce` และ `ConnectIIA` แบบ Sync ขาด Retry Queue) | Stored Proc: **`insurverse.fn_lead_to_car_act(bigint)`** มี **PostgreSQL Advisory Lock** ป้องกันแย่งเลขแล้ว | ✅ **ฝั่ง DB แก้แล้วบน Prod (WS1)** / ฝั่ง Code ขาด Retry Worker |
| **6** | **สลักหลังไม่ออก จาก Replica Lag** | `document-service` | `GenerateAllEndorse` เพิ่ม Exponential Backoff Retry 3 ครั้ง | Database Read Replica ซิงก์ช้ากว่า Primary (100–500ms) ในตาราง `Policy_Endorsement` | ✅ **แก้และ Deploy บน UAT แล้ว** / รอขึ้น Prod |
| **7** | **2C2P Invoice Lockout** | `purchase-service` | `paymentController.go:1506` (`generateInvoiceId` ยังคำนวณจาก `count(*)`) | Stored Proc: **`insurverse.fn_policy_invoiceno_iia()`** มี **Advisory Lock และ Loop Check** ป้องกันเลขซ้ำ | ✅ **ฝั่ง DB แก้แล้วบน Prod (WS5)** / ฝั่ง Code Go ยังเป็น `count(*)` |
| **8** | **MV Silent IIA Fail** | `policy-service` | `issue.go:387` (`sendIiaPolicyNormal` กลืน error); UAM มี commit `9d3b3a4` เช็คผล | Stored Proc / Query Reconcile: `GetListReconcileProblemVMI` ตรวจสอบตาราง `log_iia_policy` ทุก 15 นาที | ✅ **แก้แล้วบน `main` (WS4)** (Reconcile Cron ทำงานบน Prod) |
| **9** | **PA NULL Address** | `purchase-service` | `coreController.go:1577` เปลี่ยน struct field เป็น `*string` (Go pointer) เพื่อรับค่า NULL จาก DB ได้ 100% แล้วแปลงด้วย `utils.NilToString` ป้องกัน driver crash | ตาราง `policy_pa_premium` คอลัมน์ `deli_address_th` เป็น `NULL` โดย **ไม่ต้องแตะ SQL ไม่ต้องใส่ `COALESCE` ใน Query** เพื่อความเร็วและเบา | ✅ **แก้แล้วบน `main`** (Commit `af1dda7` / `648f298`) |
| **10** | **Repeat Charge Bypass** | `purchase-service` | `paymentController.go:141` เปลี่ยนจาก `NamedExec` เป็น Simple Fast Query `SELECT 1 ... LIMIT 1` และใช้ Go ตรวจสอบค่า Scan | ตาราง `insurverse.payment` (ฟิลด์ `payment_status = 'SUCCESS'`) | ✅ **แก้แล้วบน `main`** (Commit `af1dda7` / `c299fe4`) |
| **11** | **False Renewal SMS** | `notification` | `renewal_prep.go:473` (เช็คเฉพาะ ref_policy_no) | Stored Proc: **`insurverse.fn_policy_renewal`** เพิ่มเช็ค `Chassis_No` คุ้มครองย้อนหลัง 90 วัน (WS7) | ⏳ **อยู่ที่ `uat-isv (WS7)`** (รอรัน DDL บน Prod DB) |
| **12** | **GetLeadHome HTTP 500** | `home-service` | `home_service.go:555` (สตริง Error Mismatch `"leadHomeNo not found."` vs `%d`) | DB คืน `pgx.ErrNoRows` จากตาราง `lead_home` แต่ Controller ดักสตริงไม่ตรง ทำให้พ่น 500 ไร้ log | ❌ **ยังไม่แก้บน `main`** (มี branch `hot-fix-getlead`) |
| **13** | **Motor Lead MAX()+1 Collision** | `premium-service` | `premium.controller.js:309` (คำนวณ `MAX("Lead_No")+1` ใน JavaScript) | ตาราง `Lead_coverage_premium` — UAT-ISV ใช้ `DEFAULT nextval('insurverse.seq_lead_no')` (ไม่มี `seq_motor_lead_no`; `pg_get_serial_sequence` คืน NULL) | ⏳ **บน `uat-isv` คือ `d031a3f` (`hotfix/motor-lead-no-default`)** — ต้องเลือก branch และเตรียม DDL ให้ตรงก่อนขึ้น Prod |
| **14** | **CMI Invalid Plate** | `uam-service` | `cmiRealtimeController.go` (ทำ Data Sanitization, Truncation, และ Plate Fallback) | ตาราง `Policy_Car_Act_Discount_Premium` ฟิลด์ `Car_license_no`, `Car_license_provice` | ✅ **แก้แล้วบน `main` (WS3)** / OIC Sanitization อยู่ใน `hotfix/oic-uat` |
| **15** | **Short Link WAF Block** | `isv-test` | `short_link.go` (ขาด User-Agent, มี Double Slash ใน URL) | ไม่มี DB เกี่ยวข้อง (เรียก REST API ไปยัง WordPress Shortify ภายนอก) | ❌ **ยังไม่แก้บน `main`** — โค้ดแก้แล้วบน `fix/fx-01-isv-test` (`92688d2`) ยังไม่ขึ้น UAT-ISV |
| **16** | **UAM Hairpin Loop** | `uam-service` | `helm/helm-prod.yaml:45` (`Backend_Notification` ชี้ออกเน็ตนอก) + `notificationController.go:54` defer bug | ตาราง `sec_user` (การยืนยัน Email/OTP) | ❌ **ยังไม่แก้บน `main` (วิกฤต)** (แก้ 1 บรรทัดใน Helm) |
| **17** | **Backoffice Email Gateway Fail** | `lead-policy-service` | `helm/helm-prod.yaml:51` (`EMAIL_URL` ชี้ออกเน็ตนอก) แนบ PDF หลาย MB โดน Gateway ตัด 2.2s | ตาราง `lead_policy`, ไฟล์ PDF กรมธรรม์ใน Storage/DB | ❌ **ยังไม่แก้บน `main`** (เปลี่ยน Helm ชี้ Internal DNS) |
| **18** | **Renewal missing ref_policy_no** | `purchase-service` | `paymentController.go:460` (บล็อก HTTP 400 ถ้า `ref_policy_no IS NULL`) | ตาราง `Lead_coverage_premium.ref_policy_no` ว่าง; Stored Proc `fn_policy_renewal` (WS7) ซ่อมผูกให้ | ⏳ **อยู่ที่ `uat-isv (WS7)`** (เคสจริงแก้ Manual SQL แล้ว) |
| **19** | **SF Waterfall LB ตัด 30s** | `saleforce-service` | `policy_transacti_service.go` รัน Waterfall เกิน 30s ขาด `BackendConfig timeoutSec: 120` | Stored Proc: **`insurverse.fn_sf_policy_endorse_financial`** ประมวลผลหนักข้ามหลายตาราง | ⏳ **อยู่ที่ `hotfix/ws6-saleforce-endoesement`** |
| **20** | **Cloud SQL CPU Spike 17:00** | Cloud SQL | ไม่มี Code Application เกี่ยวข้อง | Database Engine: ตรวจสอบ `pg_stat_activity`, Query Insights, Autovacuum, และ Daily EOD Batch Queries | ℹ️ **Operational SOP** (แนวทางปฏิบัติการ) |
| **21** | **2C2P SF Auth Nil Panic** | `purchase-service` | `thirdparty/saleforce.go:75` (เติม nil check + `sync.RWMutex`); เสริม safe dereference `sf_account` ใน `coreController.go:2850` (Commit `059c275` บน `uat-isv`) | ตาราง `payment` บันทึก `payment_status = SUCCESS` แล้ว แก้ Go Panic ทำให้ `Policy_Header` ถูกสร้างสำเร็จ 100% | ✅ **แก้แล้วบน `main`** (Commit `af1dda7` / `89e58fe`) |
| **22** | **SMTP TLS Unknown Authority** | `notification` | `Dockerfile` อัปเกรดเป็น `distroless/base-debian12` มี GlobalSign Root R46 | ตาราง `Policy_Header` (มี 591 กรมธรรม์ที่ออกช่วง 10:25–15:45 วันที่ 17 ก.ย. ค้างส่งอีเมล) | ✅ **แก้แล้วบน `main`** (Commit `700776d`) รอยิง SQL Resend |
| **23** | **OCR Passport MRZ DNS Fail** | `uam-service` | `ekycController.go:943` ขาด Graceful Fallback ไปหน้า Manual Input เมื่อ Downstream ตาย | ตาราง `log_yipinsoi` / `log_ekyc_solution` เก็บ error NXDOMAIN | ❌ **ยังไม่แก้บน `main`** — โค้ด Fallback เสร็จแล้วบน `fix/fx-01-uam` (`3c0d2ed`) รวม `uat-isv` แล้ว รอ MR เข้า `main` |
| **24** | **OAuth2 LB 503 ((no backend))** | `go-oauth2-server` | `helm/helm-prod.yaml` (`memory: 128Mi` OOMKill, `initialDelaySeconds: 60`) | ตาราง `oauth_access_tokens`, `oauth_clients` | ❌ **ยังไม่แก้บน `main`** (เพิ่ม Memory 256Mi, ลด Delay 15s) |
| **25** | **Analytics CORS 503 ((no backend))** | `analytics-service` | `helm/helm-prod.yaml` (`initialDelaySeconds: 60` ขาด `lifecycle.preStop`) | ตาราง `analytics_events` | ❌ **ยังไม่แก้บน `main`** (ลด Delay 15s + ใส่ preStop hook) |
| **26** | **2C2P Callback 502 TCP Drop** | `purchase-service` | `paymentController.go` ขจัด Go Panic ตอบกลับ HTTP 200 OK สมบูรณ์ (แก้คู่กับ Issue #21) | ตาราง `payment` เงินตัดและสร้าง `Policy_Header` ครบถ้วน | ✅ **แก้แล้วบน `main`** (Commit `af1dda7` / `89e58fe`) |
| **27** | **OpenAPI Motor เบี้ยพัง ได้ HTML `<`** | `go-e-api` | `helm/helm-prod.yaml` (`ISV_HOST` ชี้เน็ตนอก) + `repository.go:50` ขาดการเช็ค HTTP Status Code ก่อน Unmarshal | ตาราง `mas_motor_*` และ `log_partner_api` | ❌ **ยังไม่แก้บน `main`** (เปลี่ยน Internal DNS + เช็ค Status Code) |

#### 🎯 สรุปการแบ่งความรับผิดชอบ (Code vs Database Stored Procedures)

1. **ปัญหาที่เกิดจาก Code ล้วนๆ (15 ข้อ):**
   - **แก้เสร็จบน main แล้ว (6 ข้อ):** #1, #9, #10, #21, #22, #26
   - **ยังค้างรอแก้ไข (9 ข้อ):** #6, #12, #15, #16, #17, #23, #24, #25, #27
   - *แนวทางแก้:* แก้ไขใน Go Code, Dockerfile หรือ Helm Configuration โดยไม่ต้องแตะต้อง Stored Procedure ใน DB เลย
2. **ปัญหาที่ต้องอาศัย Database Stored Procedure / DDL (7 ข้อ):**
   - **#5:** `fn_lead_to_car_act` (มี Advisory Lock แล้วบน Prod)
   - **#7:** `fn_policy_invoiceno_iia` (มี Advisory Lock แล้วบน Prod)
   - **#11:** `fn_policy_renewal` (อยู่ใน WS7 บน `uat-isv`)
   - **#13:** ต้องเตรียม DDL Sequence บน Prod ให้ตรงกับ branch ที่เลือก (UAT-ISV ใช้ `seq_lead_no` ไม่ใช่ `seq_motor_lead_no`)
   - **#14:** Regex และ Manual SQL สำหรับเลขทะเบียนหลุดฟอร์แมต
   - **#18:** Stored Proc `fn_policy_renewal` ในการผูก `ref_policy_no`
   - **#19:** `fn_sf_policy_endorse_financial` (อยู่ใน WS6 บน `uat-isv`)
3. **ปัญหาเชิงปฏิบัติการและการจัดการข้อมูล (5 ข้อ):**
   - **#2 (Manual SF), #3 (Parent/Child Resend), #8 (Reconcile Cron), #20 (SOP Query Insights), #22 (SQL Resend 591 เคส)**


---

## 3. 🛠️ รายละเอียดของปัญหา และ การแก้ไข (Detailed Root Causes & Resolutions)

> 💡 **ข้อตกลงมาตรฐานทางสถาปัตยกรรม (Core Architecture Standard):**
> - **ไม่แก้ไข SQL ด้วย `COALESCE` หรือ `NULLIF`:** เพื่อลดเวลา Query และป้องกันการเพิ่มภาระ CPU/Execution Plan บน Database Engine ให้คง Query แบบ Simple/Raw เอาไว้
> - **ย้ายการตรวจสอบและแปลงค่ามาทำที่ Application Code (Go/Node/Python):** ใช้ Pointer Types (`*string`), Scanner Helpers (`utils.NilToString`), Comma-ok Assertion, และ Nil-checks ในระดับหน่วยความจำ (Memory) ที่เร็วกว่าและปลอดภัยกว่า

---

### Issue #1: IIA ไม่ส่ง / Log ไม่บอกเหตุผล (IIA Silent Fail)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว** (Commits: `edc8884`, `e0bfcd5`, `9d3b3a4`)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว** (แยก Stage Error ชัดเจน + Retry Replica Lag)

- **Log/ข้อความที่พบ:** `· IIA (IIA ไม่ผ่าน log ไม่บอกเหตุผล ดูใน log_iia_policy) · ต้องส่ง IIA ใหม่`
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service`, `go-echo-uam-service`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. ใน `paymentController.go` เมื่อเรียก API ไปยัง IIA หากเกิดข้อผิดพลาด Application จะ Log ข้อความ Generic เท่านั้น:
   ```text
   CONNECT IIA [ERROR]
   Reason : Someting wrong!
   ```
   เนื่องจากระบบป้องกันไม่ให้ Dump XML ตัวเต็มลง stdout ของคอนเทนเนอร์เพื่อป้องกัน Log บวมและ PII Data ทำให้บน GCP Cloud Logging ไม่เห็นสาเหตุที่แท้จริง
2. ข้อมูล Request, Response และ Error XML จริงถูกเก็บไว้ใน PostgreSQL Table `insurverse.log_iia_policy`

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **ตรวจสอบหาสาเหตุจริงใน Database:**
   ```sql
   SELECT id, create_at, api_name, policy_no, car_act_no, response_status, response_body, remark
   FROM insurverse.log_iia_policy
   WHERE (policy_no = '<TARGET_POLICY_NO>' OR car_act_no = '<TARGET_CAR_ACT_NO>')
   ORDER BY id DESC LIMIT 5;
   ```
2. **สั่งส่ง IIA ใหม่ (Manual Resend Flow):**
   - **Motor / พ.ร.บ. (ACT):**
     `POST /api/v1/policy/support/resend-iia`
     ```json
     { "policyType": "ACT", "policyNos": ["MC-0026-I-XXXXXX"] }
     ```
   - **Non-Motor (TA / PA / HOME):**
     `POST /api/v1/purchase/support/resend-iia`
     ```json
     { "policyType": "TA", "policyNos": ["TA-0026-XXXXXX"] }
     ```

---

### Issue #2: SF มี Record ซ้ำ (Salesforce Duplicate Record)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ⚠️ **ต้องจัดการเฉพาะหน้าบน Salesforce (Manual Ops)** (ลบ/รวม Record ซ้ำใน Salesforce แล้ว Re-trigger API)
  - **UAT-ISV (`origin/uat-isv`):** ⚠️ **จัดการบน Salesforce (Manual Ops)** (เสริม Safe Pointer Check `sf_account` ใน Commit `059c275` ป้องกัน Crash)

- **Log/ข้อความที่พบ:** `Salesforce (SF มี record ของเลขนี้ซ้ำ ต้องให้ทีม SF ลบตัวซ้ำ) · ต้องสร้าง record ใน Salesforce`
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-uam-service`, Salesforce Apex REST

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- เกิดจากในระบบ Salesforce มี Record ที่มีคีย์ตรงกัน (`Policy_No__c` หรือ `Car_Act_No__c`) อยู่แล้วจากการ Retry หรือ Manual Import
- เมื่อ Backend ทำการ Upsert ผ่าน Apex REST (`/services/apexrest/upsertpolicy`) จึงถูกปฏิเสธด้วย `DUPLICATES_DETECTED` หรือ Duplicate Rule Exception

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แจ้งทีม Salesforce Admin:** ให้ทำ Hard Delete หรือ Merge Record ที่ซ้ำในระบบ Salesforce ออก
2. **ส่ง Record เข้า Salesforce ใหม่จาก Backend:**
   - ประกันสมัครใจ (Motor): `POST /api/v1/uam/create_policy_pure` Body: `{"id": "<POLICY_NO>"}`
   - พ.ร.บ. (ACT): `POST /api/v1/uam/create_policy_act` Body: `{"id": "<CAR_ACT_NO>"}`
3. ตรวจสอบตาราง `insurverse.log_sf_policy` ว่าได้ `statusCode: "0000"`

---

### Issue #3: SF ขาดกรมธรรม์หลัก (SF Missing Parent Policy)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ⏳ **รอคิว Deploy ขึ้น Prod (อยู่ใน WS6)** (ปัจจุบันบน Prod ยังต้องใช้ Manual Resend ใบแม่ `MV` ก่อนใบลูก `MC`)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS6)** (มี Stored Proc `fn_sf_policy_endorse_financial` จัดการ Parent MV และ Child MC ครบถ้วน)

- **Log/ข้อความที่พบ:**
  - `Salesforce (SF ไม่มี record ของ MV-0025-D-015542 ที่อ้างถึง ต้องส่งใบนั้นเข้า SF ก่อน) · ต้องสร้าง record ใน Salesforce`
  - `Salesforce (SF ไม่มี record ของ MC-0025-I-019051 ที่อ้างถึง ต้องส่งใบนั้นเข้า SF ก่อน) · ต้องสร้าง record ใน Salesforce`
  - `MC-0026-I-031782 (lead 258748) · Salesforce (Create Policy Act Failed) · ต้องสร้าง record ใน Salesforce`
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-uam-service`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- รายการลูก (Child Record เช่น สลักหลัง Endorsement, สัญญาแนบท้าย, หรือ Transaction) มี Lookup อ้างอิงไปยังเลขกรมธรรม์หลัก เช่น `MV-0025-D-015542` (ประกันสมัครใจ) หรือ `MC-0025-I-019051` (พ.ร.บ.)
- เนื่องจากกรมธรรม์หลักยังไม่เคยถูกสร้างหรือส่งเข้า Salesforce ไม่สำเร็จตอนชำระเงิน ระบบ SF จึง Reject รายการลูกทั้งหมดเนื่องจากหา Parent Record ไม่พบ

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **ส่งกรมธรรม์หลักเข้า SF ก่อน (แยกตามประเภทกรมธรรม์):**
   - **ประกันสมัครใจ (Motor MV):** `POST /api/v1/uam/create_policy_pure` Body: `{"id": "MV-0025-D-015542"}`
   - **พ.ร.บ. (ACT MC):** `POST /api/v1/uam/create_policy_act` Body: `{"id": "MC-0025-I-019051"}`
   - **เคส พ.ร.บ. ค้างสร้าง (Lead 258748):** `POST /api/v1/uam/create_policy_act` Body: `{"id": "MC-0026-I-031782"}`
2. **ยืนยันสถานะ:** เช็ค `insurverse.log_sf_policy` ของเลขกรมธรรม์นั้นๆ ให้ขึ้นผลสำเร็จ (`statusCode: "0000"`)
3. **ส่งรายการลูกซ้ำ:** เมื่อ Parent มีอยู่ในระบบ SF แล้ว ให้สั่ง Re-trigger ส่งรายการลูกเข้า SF ตามลำดับ

---

### Issue #4: Load Balancer ตัด 30s (GCP LB 30s Timeout)

- **สถานะการแก้ไข (Status):**
  - **Application Code:** ✅ **แก้ไขโค้ดเรียบร้อยแล้ว** (Commit `ae17af1` บน branch `fix/fx-01-notification`: ตอบ HTTP 200 ทันที < 10ms, ย้าย DB queries เข้า Goroutine, พร้อม `sync.Mutex` Concurrency Guard)
  - **Production Staging (`main`):** ⏳ **รอ Deploy ขึ้น Prod** (เตรียม `BackendConfig timeoutSec: 300` และ Service Annotation ใน `deploy_jobs/03_fixes/`)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **Deploy บน UAT เรียบร้อยแล้ว** (นำโค้ด Async Worker จาก branch `fix/fx-01-notification` รวมเข้า UAT แล้ว)

- **Log/ข้อความที่พบ:** `POST /api/v1/notification/get_noti_policy_expire · 30.0 วินาที · LB ตัดทิ้ง ผู้ใช้ได้ 502`
- **ระดับความสำคัญ:** **P2 - Medium**
- **ระบบที่เกี่ยวข้อง:** `go-echo-notification-service`, Ingress BackendConfig

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- GCP External HTTP(S) Load Balancer มี Default Backend Service Timeout อยู่ที่ **30 วินาที**
- API `get_noti_policy_expire` ทำการรัน Stored Procedure คำนวณรายชื่อผู้หมดอายุแบบ Synchronous ใน Request Thread ซึ่งใช้เวลาเกิน 30 วินาที LB จึงตัดการเชื่อมต่อและตอบ **HTTP 502 Bad Gateway** ในขณะที่ Container ยังคงรันประมวลผลต่อใน Background

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แก้เชิงสถาปัตยกรรม (Code):** ปรับ API ให้ตอบ `HTTP 202 Accepted` ทันที แล้วส่งต่องานประมวลผลให้ Goroutine หรือ Cloud Tasks ทำแบบ Asynchronous
2. **แก้เชิงคอนฟิก (Infra):** เพิ่ม `timeoutSec: 300` ใน `BackendConfig` ของ Kubernetes Ingress

---

### Issue #5: พ.ร.บ. ออกเลขแต่ข้าม IIA/SF (ACT Skipped IIA/SF)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **ฝั่ง Database แก้ไขและ Deploy บน Prod แล้ว (WS1)** (Stored Proc `fn_lead_to_car_act` มี PostgreSQL Advisory Lock ป้องกันแย่งเลขแล้ว)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS1)** (มี DB Advisory Lock และ Retry Guard บน UAT-ISV)

- **Log/ข้อความที่พบ:** `อัปเดต: ACT ได้เลขกรมธรรม์แล้วแต่ไม่ได้ส่ง IIA และไม่ได้สร้าง record ใน Salesforce`
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service/controllers/paymentController.go:1098-1120`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- เมื่อชำระเงินสำเร็จ ระบบสร้าง `Car_Act_No` ลงตาราง `Policy_Car_Act_Discount_Premium` เรียบร้อยแล้ว
- จากนั้นโค้ดเรียก `ConnectSaleforce(carActNo)` และ `ConnectIIA(carActNo)` ตามลำดับ
- **จุดบกพร่อง:** หาก Step ใดล้มเหลว โค้ดทำเพียงแค่ `fmt.Println("[ERROR]")` โดย**ไม่มี Retry Worker, ไม่มีการแจ้ง Alert, และไม่ Rollback** ทำให้ลูกค้าได้เลข พ.ร.บ. แต่ระบบกำกับ IIA และ Salesforce ตกหล่น

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **Immediate Resend:**
   - ส่ง SF: `POST /api/v1/uam/create_policy_act` Body: `{"id": "<CAR_ACT_NO>"}`
   - ส่ง IIA: `POST /api/v1/policy/support/resend-iia` Body: `{"policyType": "ACT", "policyNos": ["<CAR_ACT_NO>"]}`
2. **Code Fix:** เพิ่ม Retry Queue (RabbitMQ หรือ DB Outbox Pattern) สำหรับ Job ที่ไม่สำเร็จ

---

### Issue #6: สลักหลังไม่ออก จาก Replica Lag (Endorsement Replica Lag)

- **สถานะการแก้ไข (Status):**
  - **Application Code:** ✅ **แก้ไขโค้ดเรียบร้อยแล้ว** (Commit `35c58b7` บน branch `fix/fx-01-document` แตกตรงจาก `main`: เพิ่ม Exponential Backoff Retry 4 ครั้ง: 500ms, 1s, 2s เมื่อเจอ Replica Lag)
  - **Production (`origin/main`):** ⏳ **รอ Deploy ขึ้น Prod**
  - **UAT-ISV (`origin/uat-isv`):** ✅ **Deploy บน UAT เรียบร้อยแล้ว** (นำโค้ด Exponential Backoff Retry จาก branch `fix/fx-01-document` รวมเข้า UAT แล้ว)

- **Log/ข้อความที่พบ:** `อัปเดต: เอกสารสลักหลังไม่ออก เพราะ doc-service อ่านสลักหลังก่อน replica ตามทัน`
- **ระดับความสำคัญ:** **P2 - Medium**
- **ระบบที่เกี่ยวข้อง:** `document-service`, `uam-service`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- Service บันทึกข้อมูลสลักหลังลง **Primary Cloud SQL** แล้วยิงสั่ง `document-service` ทันที
- `document-service` ต่อกับ **Read Replica** ซึ่งเกิด Replication Delay (100–500ms) ทำให้ Query หา Record ไม่พบ (`sql: no rows in result set`) และยกเลิกการออกเอกสาร PDF

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **Immediate Recovery:** สั่ง Gen ซ้ำเมื่อ Replica ซิงก์ทันแล้ว: `POST /api/v1/document/endorse/{sfPolicyID}`
2. **Code Fix:**
   - เพิ่ม Exponential Backoff Retry (3 ครั้ง: 500ms, 1s, 2s) ใน `document-service` เมื่อเจอ `ErrNoRows`
   - หรือเปลี่ยน Connection สำหรับ Endpoint สร้างเอกสาร Critical ไปต่อที่ Primary Database

---

### Issue #7: 2C2P เลข Invoice ซ้ำ ลูกค้าจ่ายไม่ได้ (2C2P Invoice Lockout)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **ฝั่ง Database แก้ไขและ Deploy บน Prod แล้ว (WS5)** (Stored Proc `fn_policy_invoiceno_iia` ใส่ Advisory Lock และ Loop Check ป้องกันเลข Invoice ชนซ้ำ)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS5)** (ทดสอบ Flow ออกเลข Invoice ไม่ซ้ำผ่านฉลุย)

- **Log/ข้อความที่พบ:** `อัปเดต: 2c2p ปฏิเสธด้วย Existing Invoice No. ลูกค้าจ่ายไม่ได้ทั้งวัน`
- **ระดับความสำคัญ:** **P0 - Critical**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service/controllers/paymentController.go:1540-1565`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- ฟังก์ชัน `generateInvoiceId` คำนวณเลข Invoice จาก `SELECT count(*) FROM table WHERE created_at BETWEEN ...`
- หากลูกค้าทำรายการไม่สำเร็จในครั้งแรก แล้วกดย้อนกลับมาจ่ายใหม่ หรือระบบส่งเลขเดิมซ้ำ 2C2P จะจำเลข Invoice ไว้ 24 ชั่วโมง และปฏิเสธทันทีด้วย Error `4099 Existing Invoice No.`
- เนื่องจากระบบไม่ได้สร้าง Invoice No ใหม่ให้ลูกค้า จึงส่งผลให้ลูกค้าติดหล่ม ไม่สามารถชำระเงินได้ตลอดทั้งวัน

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แก้ปัญหาเฉพาะหน้าให้ลูกค้า (เช่น Lead 255955):** บังคับ Generate เลข Invoice ใหม่ หรือสร้าง Lead/Transaction ใหม่เพื่อส่งเข้า 2C2P
2. **Code Fix ถาวร:**
   - เปลี่ยนการ Generate Invoice No เป็นระดับ Millisecond Timestamp + Random Unique Hex (หรือ DB Sequence)
   - เมื่อลูกค้า Refresh หรือเริ่มการจ่ายใหม่ ให้ **Force Generate New Invoice No เสมอ**

---

### Issue #8: ประกันสมัครใจ (MV) ส่ง IIA ไม่ผ่านเงียบๆ (MV Silent IIA Fail)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว (WS4)** (Reconcile Cron ทำงานทุก 15 นาที ดึงรายการตกหล่นส่งซ้ำเข้า IIA อัตโนมัติ)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS4 + OIC Compliant)** (Reconcile Cron และ CMI Service ทำงานสอดคล้องกัน)

- **Log/ข้อความที่พบ:** `อัปเดต: กรมธรรม์ภาคสมัครใจ (MV) ส่ง IIA ไม่ผ่านวันละครั้ง แต่ log ไม่บอกเหตุผล และไม่มีใครรู้`
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-fiber-policy-service/internal/service/issue.go:393`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- ในโค้ดบรรทัดที่ 393:
  ```go
  s.sendIiaPolicyNormal(ctx, policyNo) // โค้ดไม่ได้ดัก Error หรือนำค่า Return มาเช็คเลย
  ```
- เมื่อ IIA ปฏิเสธ โค้ดกลืน Error และเดินหน้าต่อไปสร้าง PDF จนสถานะกลายเป็น `Documented` สำเร็จ ทำให้ลูกค้าได้เอกสารครบ แต่ข้อมูลกรมธรรม์ในระบบกลาง IIA ว่างเปล่า

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **Immediate Resend:** `POST /api/v1/policy/support/resend-iia` Body: `{"policyType": "VMI", "policyNos": ["<POLICY_NO>"]}`
2. **Code Fix:** ดักจับ Error จาก `sendIiaPolicyNormal`: หาก Error ให้ส่ง Slack Alert และบันทึกสถานะ `IIA_FAILED` เพื่อให้ระบบ Auto-Retry

---

### Issue #9: PA/Home ไม่เข้า IIA เมื่อไม่เลือกส่งไปรษณีย์ (PA/Home NULL Address)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว (21 ก.ย. 2026, Commit `af1dda7` / `648f298`)** (ปรับ struct รับ pointer `*string` ใน Go ไม่แตะ SQL ป้องกัน NULL driver crash 100%)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว** (นำเข้าโค้ด pointer fix ครบถ้วน)

- **Log/ข้อความที่พบ:** `อัปเดต: PA / HI จ่ายแล้วไม่เข้า IIA เมื่อไม่เลือกส่งไปรษณีย์ (deli_address_th = NULL)`
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service/controllers/coreController.go:1577, 1663`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- Struct Go กำหนด `PostAddress1 string` เป็นชนิดสตริงธรรมดา (ไม่ใช่ Pointer)
- ใน SQL Query ขาดคำสั่ง `COALESCE`:
  ```sql
  "policy"."deli_address_th" as "PostAddress1"
  ```
- เมื่อลูกค้าเลือกรับ E-Policy ค่า `deli_address_th` จะเป็น `NULL` ทำให้ Library `sqlx.Get` พังทันทีด้วย Error `converting NULL to string is unsupported` ฟังก์ชันจึงหยุดทำงานและไม่ส่งข้อมูลเข้า IIA

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แก้ปัญหาข้อมูลที่ค้างใน DB (เฉพาะหน้า):**
   ```sql
   UPDATE insurverse.policy_pa_premium SET deli_address_th = '' WHERE deli_address_th IS NULL AND policy_pa_no = '<TARGET_PA_NO>';
   UPDATE insurverse.policy_home_premium SET deli_address_th = '' WHERE deli_address_th IS NULL AND policy_home_no = '<TARGET_HOME_NO>';
   ```
   แล้วสั่ง Resend IIA ผ่าน `POST /api/v1/purchase/support/resend-iia`
2. **Code Fix (สถาปัตยกรรมแก้ที่ Go Code - ไม่แก้ SQL ด้วย COALESCE/NULLIF):**
   - **หลักการ:** ไม่แตะ SQL และไม่ใส่ `COALESCE`/`NULLIF` ใน Query เพื่อไม่ให้ Database Engine ทำงานหนักและลดเวลา Query
   - **แนวทาง:** ปรับ Field ใน Struct Scan ของ Go (`coreController.go:1577`) จาก `string` เป็น `*string` (Pointer string) เพื่อให้ Go รับค่า `NULL` จาก Database ได้อย่างสมบูรณ์โดยไม่เกิด Driver Scan Error
   - จากนั้นใช้ฟังก์ชัน Helper ของ Go ในฝั่ง Application เช่น `utils.NilToString(data.PostAddress1)` แปลงค่า Pointer ที่เป็น nil ให้เป็น `""` (Empty String) ในระดับ Memory ก่อนนำไปส่ง IIA

---

### Issue #10: ส่งตัดเงินซ้ำได้แม้ Lead จ่ายสำเร็จแล้ว (Repeat Charge Bypass)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว (21 ก.ย. 2026, Commit `af1dda7` / `c299fe4`)** (เปลี่ยน `NamedExec` บน SELECT เป็น `SELECT 1 ... LIMIT 1` และ Scan ป้องกันการจ่ายเงินซ้ำ 100%)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว** (ทดสอบบล็อก Repeat Charge สำเร็จ)

- **Log/ข้อความที่พบ:** `อัปเดต: ส่งคำขอจ่ายเงินเข้าธนาคารได้ แม้ lead นั้นจ่ายสำเร็จไปแล้ว`
- **ระดับความสำคัญ:** **P0 - Critical**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service/controllers/paymentController.go:141-147`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- โค้ดตรวจสอบการจ่ายเงินเดิมใช้:
  ```go
  payment, _ := config.DbPostgres.NamedExec(`SELECT * FROM insurverse.payment WHERE "payment_status"=:payment_status AND "lead_no"=:lead_no`, ...)
  row, _ := payment.RowsAffected()
  ```
- **บั๊กใหญ่ทางเทคนิค:** `NamedExec` มีไว้สำหรับ DML การใช้กับคำสั่ง `SELECT` จะได้ `RowsAffected() = 0` เสมอ!
- ทำให้เงื่อนไขบล็อกการจ่ายซ้ำไม่ทำงาน (Always Bypassed) หากลูกค้ากดย้อนกลับมาหน้าจ่ายเงิน ระบบจะอนุญาตให้ส่งคำขอตัดเงินเข้าธนาคารซ้ำได้ เสี่ยงต่อการเกิด Double Charging

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **Code Fix เร่งด่วน:** เปลี่ยนไปใช้ `SELECT EXISTS(...)` ผ่าน `QueryRow` หรือ `sqlx.Get`:
   ```go
   var isPaid bool
   err := config.DbPostgres.Get(&isPaid, `SELECT EXISTS(SELECT 1 FROM insurverse.payment WHERE UPPER(payment_status) = 'SUCCESS' AND lead_no = $1)`, _LeadNo)
   if isPaid {
       return c.JSON(http.StatusBadRequest, &utils.Response{Result: false, Code: 400, Message: "this lead has already been paid"})
   }
   ```

---

### Issue #11: ส่ง SMS ต่ออายุผิด ทั้งที่ซื้อ พ.ร.บ. ใหม่แล้ว (False Renewal SMS)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ⏳ **รอคิว Deploy ขึ้น Prod (อยู่ใน WS7)** (รอรัน DDL ฟังก์ชัน `fn_policy_renewal` บน Production DB)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS7)** (ฟังก์ชัน `fn_policy_renewal` เช็คเลขตัวถัง `Chassis_No` คุ้มครองย้อนหลัง 90 วัน ไม่ส่ง SMS ซ้ำ)

- **Log/ข้อความที่พบ:** `อัปเดต: SMS เตือนต่ออายุยังส่งต่อ ทั้งที่ลูกค้าซื้อ พ.ร.บ. ใบใหม่ของรถคันเดิมแล้ว`
- **ระดับความสำคัญ:** **P2 - Medium**
- **ระบบที่เกี่ยวข้อง:** `go-echo-notification-service/controllers/renewal/renewal_prep.go:473-481`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

- Logic ตรวจสอบเฉพาะฟิลด์ `ref_policy_no` ว่าชี้มาที่กรมธรรม์เก่าหรือไม่เท่านั้น
- หากลูกค้าไม่ได้คลิกลิงก์ต่ออายุ แต่เข้ามาซื้อ พ.ร.บ. ใหม่ด้วยตัวเอง กรมธรรม์ใหม่จะไม่มี `ref_policy_no` ทำให้ระบบเข้าใจผิดว่ารถคันเดิมยังไม่ได้ต่ออายุ และส่ง SMS เตือนรบกวนลูกค้าอย่างต่อเนื่อง

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

- **Code Fix (SQL Logic):** เพิ่มเงื่อนไขตรวจสอบซ้ำด้วย **เลขตัวถังรถ (คอลัมน์จริงชื่อ `Car_serial_no`)** ที่ยังมีผลคุ้มครอง Active อยู่ (✅ Schema verified 2026-09-23: ไม่มีคอลัมน์ `Chassis_No` / `End_Date`):
  ```sql
  AND NOT EXISTS (
      SELECT 1 FROM insurverse."Policy_Car_Act_Discount_Premium" active_mc
       WHERE active_mc."Car_serial_no" = due_by_date."Car_serial_no"
         AND active_mc."End_date" > CURRENT_DATE
         AND active_mc."Car_Act_No" != due_by_date."Car_Act_No"
  )
  ```

---

### Issue #12: Home Service HTTP 500 ไร้ Error Log (Silent 500 on GetLead)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main)** (Error String Mismatch `"leadHomeNo not found."` vs `%d` ใน `home_service.go:555`)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว** (รวม Branch `hot-fix-getlead` ดักจับ `pgx.ErrNoRows` ถูกต้อง)

- **Log/ข้อความที่พบ:** `HTTP 500 · backend-home-service · GET /api/v1/home/getleadhome/{hex} · 18 ms · ขาด error log`
- **ระดับความสำคัญ:** **P2 - Medium**
- **ระบบที่เกี่ยวข้อง:** `go-echo-home-service/controllers/home_service.go:554-558, 718-723`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. **Error String Mismatch:**
   - ในฟังก์ชัน Store คืนค่า: `fmt.Sprintf("leadHomeNo %d not found.", leadHomeNo)` (มี ID แนบมา)
   - แต่ใน Controller ตรวจสอบแบบตายตัว: `if err.Error() == "leadHomeNo not found."` (ไม่มี ID)
   - เมื่อสตริงไม่ตรง เงื่อนไขเช็ค 404 หลุด ทำให้ระบบตอบกลับเป็น **HTTP 500 Internal Server Error**
2. **Missing Error Log:** โค้ดไม่ได้เรียก `slog.Error` หรือพิมพ์ Log ใดๆ ก่อนส่ง HTTP 500 ออกไป ทำให้ใน Cloud Logging ไม่พบสาเหตุของ Error

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

- **Code Fix:**
  ```go
  if err != nil {
      if errors.Is(err, pgx.ErrNoRows) || strings.Contains(err.Error(), "not found") {
          return echo.NewHTTPError(http.StatusNotFound, "leadHomeNo not found")
      }
      slog.Error("GetLeadHome error", "leadHomeNo", leadHomeNoData, "error", err)
      return echo.NewHTTPError(http.StatusInternalServerError, "Internal Server Error")
  }
  ```

---

### Issue #13: Motor Lead ชนซ้ำจาก MAX()+1 (Motor Lead MAX+1 Race Collision)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ⏳ **รอคิว Deploy ขึ้น Prod** (ยังไม่ได้เลือกว่าจะ Promote `d031a3f` หรือ `d20771f` — DDL ต้องตรงกับ branch ที่เลือก ดูผลตรวจด้านล่าง)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **แก้และทดสอบแล้วบน `uat-isv`** (โค้ด `d031a3f` จาก `hotfix/motor-lead-no-default` ใช้ `DEFAULT nextval('insurverse.seq_lead_no')` — ไม่ใช่ `seq_motor_lead_no` ดูผลตรวจด้านล่าง)

- **Log/ข้อความที่พบ:** `Motor lead duplicate key (Lead_No) · 148 บรรทัดใน 6 นาที · MAX()+1 race, premium.controller.js:309, ~3.5yr-old bug`
- **ระดับความสำคัญ:** **P0 - Critical**
- **ระบบที่เกี่ยวข้อง:** `nodejs-express-premium-service/controllers/premium.controller.js:309`

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. **บั๊กเก่าแก่ ~3.5 ปี (ตั้งแต่ 19 มี.ค. 2023 - Commit `111e2e9`):** โค้ดคำนวณ `Lead_No` สำหรับบันทึกใบเสนอราคา/Lead รถยนต์ภาคสมัครใจ (Motor) ใช้วิธี:
   ```javascript
   let insF = `"Lead_No"`;
   let insD = `CASE WHEN MAX("Lead_No") > 0 THEN MAX("Lead_No")+1 ELSE 1 END AS Lead_No`;
   ...
   let sql = `
       INSERT INTO "Lead_coverage_premium" ( ${insF} )
           SELECT ${insD} FROM "Lead_coverage_premium";
       SELECT MAX("Lead_No") "Lead_No" FROM "Lead_coverage_premium";
   `;
   ```
2. **Double Defects (ข้อบกพร่องวิกฤต 2 ประการ):**
   - **Race Condition Collision:** เมื่อมีผู้ใช้งานเข้ามากรอกคำนวณเบี้ยพร้อมกัน คำสั่ง `SELECT MAX("Lead_No")` จะทำงานในเสี้ยววินาทีเดียวกันและได้เลข `MAX` ตัวเดียวกันเป๊ะ ทำให้ทุก Transaction พยายาม Insert Primary Key ซ้ำกัน ส่งผลให้เกิด Error `duplicate key value violates unique constraint "Lead_coverage_premium_pkey"` (**148 Error ใน 6 นาที**)
   - **Silent Cross-Customer Data Hijacking:** คำสั่งที่สองที่ส่งคืน `Lead_No` ให้ User ใช้ `SELECT MAX("Lead_No")` หากมีคำขอของลูกค้าคนอื่น Insert เข้ามาคั่นกลาง ลูกค้าคนแรกจะได้รับเลข Lead ของอีกคนไปดำเนินการชำระเงินแทนทันที
3. **สาเหตุที่ยังหลุดอยู่บน Production:** เคยมี Merge Request !170 (Commit `310c36f`) พยายามแก้ แต่ถูก Revert (Commit `7a21330`) เนื่องจากยังไม่ได้สร้าง DB Sequence ล่วงหน้า และตัวแก้ล่าสุดใน branch `hotfix/motor-lead-no-default` (Commit `d031a3f`) ถูกเทสใน `uat-isv` แล้วแต่ยังไม่ได้ Promote และ Deploy ขึ้น Production (`origin/main`)

#### ⚠️ ผลตรวจจริง 2026-09-23 (Code + DB Dual-Inspection บน UAT-ISV) — ต้องอ่านก่อนเตรียม Prod Pack

| สิ่งที่ตรวจ | ผลจริง |
| :--- | :--- |
| Branch ที่ถูกต้อง | มี 3 ตัว: `fix/motor-lead-no-sequence` (`d20771f`), `fix/motor-lead-no-sequence-uat` (`310c36f` ตัวที่เคยถูก Revert), `hotfix/motor-lead-no-default` (`d031a3f`) — **ที่รวมอยู่บน `uat-isv` จริงคือ `d031a3f` เท่านั้น** (`d20771f` ไม่อยู่ทั้งใน `main` และ `uat-isv`) |
| Sequence บน UAT-ISV | **ไม่มี `seq_motor_lead_no`** — คอลัมน์ `Lead_No` ใช้ `DEFAULT nextval('insurverse.seq_lead_no')` (last_value = MAX(Lead_No) = 92369 ตรงกัน) |
| โค้ด `d20771f` | ใช้ `nextval(pg_get_serial_sequence('insurverse."Lead_coverage_premium"','Lead_No'))` ซึ่งบน UAT-ISV คืน **NULL** เพราะ `seq_lead_no` ไม่ได้ `OWNED BY` คอลัมน์ → ถ้า Deploy `d20771f` บน DB สภาพนี้ **Insert Motor Lead จะพังทุกครั้ง** |

**สรุป:** DDL ด้านล่าง (สร้าง `seq_motor_lead_no`) **ไม่ตรงกับทั้งโค้ดและ DB ที่ทดสอบบน UAT-ISV** ห้ามรันบน Prod ตามนี้ ต้องเลือกก่อนว่าจะ Promote branch ไหน แล้วเตรียม DDL ให้ตรง:
- ถ้าใช้ `d031a3f` (ตัวที่อยู่บน UAT-ISV): Prod ต้องมี `seq_lead_no` + `ALTER COLUMN "Lead_No" SET DEFAULT nextval('insurverse.seq_lead_no')` + `setval` จาก `MAX("Lead_No")`
- ถ้าใช้ `d20771f`: ต้องเพิ่ม `ALTER SEQUENCE insurverse.seq_lead_no OWNED BY insurverse."Lead_coverage_premium"."Lead_No";` และต้องทดสอบบน UAT-ISV ก่อน

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery) — ⚠️ DDL ข้อ 1 ด้านล่างเป็นร่างเดิม ใช้ไม่ได้ตามผลตรวจข้างบน

1. **เตรียม Database Sequence บน Production ให้พร้อม (Rule 5 Compliant):**
   ```sql
   CREATE SEQUENCE IF NOT EXISTS insurverse.seq_motor_lead_no;
   SELECT setval(
       'insurverse.seq_motor_lead_no',
       COALESCE((SELECT MAX("Lead_No") FROM insurverse."Lead_coverage_premium"), 0) + 1,
       false
   );
   ALTER TABLE insurverse."Lead_coverage_premium"
   ALTER COLUMN "Lead_No" SET DEFAULT nextval('insurverse.seq_motor_lead_no');
   ```
2. **Code Fix (`premium.controller.js`):** ปรับคำสั่ง SQL ให้ใช้ `VALUES (...)` และอ่านค่ากลับด้วย `RETURNING "Lead_No"`:
   ```javascript
   let sql = `
       INSERT INTO insurverse."Lead_coverage_premium" ( ${insF.join(", ")}, "Lead_No" )
       VALUES ( ${insD.join(", ")}, nextval('insurverse.seq_motor_lead_no') )
       RETURNING "Lead_No";
   `;
   ```
3. **Deploy & Promote:** ผสานโค้ดจาก `hotfix/motor-lead-no-default` เข้า `main` และ Deploy ขึ้น Production ทันที

---

### Issue #14: CMI ปฏิเสธทะเบียนรถผิดมาตรฐาน ขบ. (CMI Invalid License Plate 2BUS0216)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว (WS3)** (มี Regex และ Sanitization ทะเบียน/จังหวัด และแยกแยะป้ายแดง/ป้ายต่างจังหวัด)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS3 + OIC Validation)** (สอดคล้องกับมาตรฐาน คปภ. CMI Realtime Service)

- **Log/ข้อความที่พบ:** `CMI (CMI ปฏิเสธรายการ : 2BUS0216 รูปแบบเลขทะเบียนรถต้องถูกต้องตรงตามมาตรฐานกรมการขนส่งทางบก) · ต้องส่ง CMI ใหม่`
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-uam-service`, `go-fiber-policy-service`, OIC CMI Gateway

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. ระบบ CMI Realtime Gateway ของสำนักงาน คปภ. มี Business Rule ตรวจสอบความถูกต้องของเลขทะเบียนรถ (`Car_license_no` / `plateNumber`) ตามมาตรฐานกรมการขนส่งทางบก (ขบ.)
2. หากผู้ใช้งานหรือพาร์ทเนอร์กรอกข้อมูลที่มี:
   - **เครื่องหมายขีด หรือ เว้นวรรค:** เช่น `1กข-1234`, `กข 1234`
   - **ตัวอักษรภาษาอังกฤษ:** เช่น `1AB1234` (ป้ายทะเบียนไทยต้องเป็นพยัญชนะไทย)
   - **ข้อความแทนเลขทะเบียน (กรณีป้ายแดง/รถใหม่):** เช่น `ป้ายแดง`, `ไม่มี`, `ว่าง`, `-`, `NEW`
   - **ตัวเลขเกิน 4 หลัก:** เช่น `1กข12345`
3. CMI Gateway จะตอบกลับด้วย Error Code `2BUS0216` และปฏิเสธการรับประกันภัย (`FAIL`) ทำให้กรมธรรม์ พ.ร.บ. ค้างและไม่ได้รับการคุ้มครองในระบบกลาง

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **ตรวจสอบข้อมูลใน DB และ Log:**
   ```sql
   SELECT "Car_Act_No", "Car_license_no", "Car_license_provice", "Car_serial_no"
   FROM insurverse."Policy_Car_Act_Discount_Premium"
   WHERE "Car_Act_No" = '<TARGET_CAR_ACT_NO>';
   ```
2. **แก้ไขเลขทะเบียนให้ถูกต้องตาม Regex มาตรฐาน (`/^(?=.*[ก-ฮ])([0-9]{1,2})?[ก-๙]+[0-9]{1,4}$/`):**
   ```sql
   UPDATE insurverse."Policy_Car_Act_Discount_Premium"
   SET "Car_license_no" = '<เลขทะเบียนที่แก้ไขแล้ว เช่น 1กข1234>',
       "Update_date" = NOW()
   WHERE "Car_Act_No" = '<TARGET_CAR_ACT_NO>';
   ```
3. **สั่งส่ง CMI ใหม่ (Manual Resend):**
   - ยิง API: `POST /api/v1/uam/cmi_realtime_service` Body: `{"id": "<TARGET_CAR_ACT_NO>", "type": ""}`
   - ตรวจสอบว่าได้รับ `cmi_reference_number` และ `cmi_receive_number` เรียบร้อย

---

## 4. 🚨 กรณีศึกษาจาก Log จริง (Real Incident Cases)

### 📌 Incident Case A: Lead 255955 — ติดหล่ม `4099 Existing Invoice No.`

- **เหตุการณ์:** ชำระเงินไม่ผ่าน 4 ครั้ง โดยครั้งล่าสุดเกิดเมื่อ 14/09 16:55 ด้วย Error `4099 Existing Invoice No.` ยังชำระเงินไม่สำเร็จ
- **สาเหตุ:** หน้าเว็บหรือแอปส่งเลข `invoiceNo` เดิมที่เคยยิงเข้า 2C2P แล้วกลับไปยิงซ้ำ ซึ่ง 2C2P แคชเลขนี้ไว้ 24 ชม. ทำให้ลูกค้ารายนี้ไม่สามารถจ่ายเงินได้
- **Action ทันที:** สั่งสร้าง Transaction ใหม่ที่มี `invoiceNo` ชุดใหม่ให้กับ Lead 255955 เพื่อให้ลูกค้าชำระเงินได้ทันที

### 📌 Incident Case B: Lead 257307 — ส่งคำขอตัดเงินซ้ำหลังจ่ายสำเร็จแล้ว

- **เหตุการณ์:**
  - 14/09 11:56 ลูกค้าชำระเงินสำเร็จ (`SUCCESS`)
  - 14/09 12:25 มีรายการส่งคำขอตัดเงินเข้าธนาคารอีกครั้ง ได้รับผล `0003 Customer Cancellation` (ลูกค้าเห็นยอดซ้ำจึงกดยกเลิกเอง)
- **สาเหตุ:** ยืนยันบั๊ก Issue #10 (`NamedExec` คืนค่า 0) ทำให้ระบบไม่บล็อกการจ่ายซ้ำของ Lead ที่จ่ายสำเร็จแล้ว
- **Action ทันที:** ตรวจสอบ Statement บัญชีลูกค้าเพื่อยืนยันว่าไม่มีการตัดเงินซ้ำซ้อน และเร่ง Deploy Hotfix Issue #10

---

## 5. 🎯 แผนปฏิบัติการตามลำดับความสำคัญ (Execution Action Plan)

1. **ลำดับที่ 1 (ด่วนที่สุด - P0):**
   - **[NEW] แก้ปัญหา Motor Lead Collision (Issue #13):** เลือก branch (`d031a3f` ที่ทดสอบบน UAT-ISV แล้ว) เตรียม DDL `seq_lead_no` ให้ตรงกับที่ UAT-ISV ใช้ แล้ว Deploy เข้า `main` (⚠️ อย่าใช้ DDL `seq_motor_lead_no` เดิม)
   - ปลดล็อกให้ลูกค้า **Lead 255955** ด้วยการ Generate เลข Invoice ใหม่
   - แก้ไขบั๊ก `NamedExec` บน SELECT ใน `paymentController.go:141` เพื่อป้องกันการตัดเงินซ้ำ
2. **ลำดับที่ 2 (สำคัญสูง - P1):**
   - **[NEW] แก้ไขทะเบียนรถและส่ง CMI ใหม่ (Issue #14):** คลีนฟิลด์ `Car_license_no` ที่มีขีด/วรรค/ป้ายแดง แล้วยิงส่ง CMI ผ่าน `/cmi_realtime_service`
   - ส่ง `MV-0025-D-015542` และ `MC-0025-I-019051` เข้า Salesforce จากนั้นปล่อย Transaction ลูกที่ค้างอยู่
   - ปรับ Struct Go ใน `coreController.go` ให้เป็น Pointer `*string` ป้องกัน NULL Scan Error (ไม่แก้ SQL ด้วย COALESCE เพื่อลดเวลา Query)
   - ดัก Error IIA ใน `policy-service/internal/service/issue.go:393` และทำ Alert
3. **ลำดับที่ 3 (สำคัญปานกลาง - P2):**
   - แก้ไข Logic เช็คเลขตัวถังรถใน `renewal_prep.go` ป้องกันการส่ง SMS ต่ออายุผิด
   - แก้ไข String match ใน `home_service.go` และใส่ `slog.Error`
   - ปรับ Ingress `BackendConfig` Timeout หรือย้าย Worker ใน `notification-service`

---

### Issue #15: URL Shortener โดน Cloudflare บล็อก (Short Link WAF Block)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main)** (ขาด Custom User-Agent และ Trim Trailing Slash ทำให้ติด Cloudflare WAF)
  - **Application Code:** ✅ **แก้โค้ดแล้ว (Local)** Commit `92688d2` บน `fix/fx-01-isv-test` (แตกจาก `origin/main`) — เพิ่ม `util.ShortLinkEndpoint` (ตัด `/wp-json...` และ `/` ท้าย) + `User-Agent: Insurverse-Backend-Service/1.0` ครบ **3 จุดเรียก**: `controller/short_link.go`, `service/renew_policy_service.go` (SMS ต่ออายุ), `usecase/shopee/usecase.go` + Timeout 10s ให้ `/short_link`
  - **UAT-ISV (`origin/uat-isv`):** ❌ **ยังไม่ได้รวมเข้า `uat-isv`**
  - ℹ️ Fallback คืน Long URL: Renewal SMS และ Shopee มีอยู่แล้ว ส่วน `POST /short_link` ยังตอบ 500 (รอตัดสินใจเพราะเปลี่ยน API Contract)

- **Log/ข้อความที่พบ:**
  ```text
  POST /api/v1/isv-test/short_link · 3 ครั้งใน 8 นาที · ใช้เวลา 86 ms
  สาเหตุ:
  </div><!-- /.error-footer -->
  </div><!-- /#cf-error-details -->
  ```
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `isv-test` (`controller/short_link.go`), WordPress URL-Shortify Plugin, Cloudflare WAF

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. ข้อความ HTML `<!-- /#cf-error-details -->` คือหน้า HTML Error Page มาตรฐานของ **Cloudflare WAF / CDN**
2. ใน `isv-test/controller/short_link.go` ฟังก์ชัน `GetShortenedURL` ยิง POST ไปยัง `https://insurverse.co.th/wp-json/url-shortify/v1/links`
3. สาเหตุที่ Cloudflare บล็อกภายในเวลาเพียง **86 ms**:
   - **User-Agent ถูกบล็อก:** Go HTTP Client ไม่ได้ตั้งค่า User-Agent ทำให้ส่งค่าเริ่มต้นเป็น `Go-http-client/1.1` ซึ่งถูก Cloudflare Bot Fight Mode / Managed WAF Rules บล็อกทันที
   - **Double Slash ใน URL:** ใน `helm-prod.yaml`: `WORDPRESS_API_URL` มีค่าเป็น `https://insurverse.co.th/` เมื่อต่อกับ endpoint จึงกลายเป็น `//wp-json/...` ทำให้ WAF บางกฎมองเป็น Path Traversal / Normalization Anomaly
   - **Cloud NAT IP:** Egress IP ของ GKE ยังไม่ได้รับการยกเว้น (Bypass) ใน Cloudflare Security Rules

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แก้ไขโค้ด `isv-test/controller/short_link.go`:**
   - ตัด Trailing Slash ออก: `strings.TrimRight(cfg.WordpressApiURL, "/") + "/wp-json/url-shortify/v1/links"`
   - เพิ่ม Custom User-Agent: `req.Header.Set("User-Agent", "Insurverse-Backend-Service/1.0")`
   - เพิ่ม Fallback: หากย่อลิงก์ไม่สำเร็จ ให้ส่งคืน Long URL เดิมกลับไป ไม่พ่น HTTP 500 ขัดจังหวะผู้ใช้
2. **Cloudflare WAF Config:** ทำ WAF Bypass Rule สำหรับ Cloud NAT IP ของ Cluster บนโดเมน `insurverse.co.th`

---

### Issue #16: UAM Email & OTP ล่มทั้งระบบ (UAM Hairpin Loop Failure)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main - วิกฤต P0)** (`helm/helm-prod.yaml:45` ชี้ `Backend_Notification` ออกเน็ตนอกทำให้เกิด Hairpin Loop Timeout)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **แก้ไขแล้วบน `uat-isv`** (`helm/helm-uat-isv.yaml` ชี้ Internal DNS `http://backend-notification-service:8080/api/v1/notification/` เรียบร้อยแล้ว พร้อมนำไปใส่ใน `helm-prod.yaml`)
  - ⚠️ **ขัดกับนโยบาย `deploy_jobs/03_fixes/README.md`** (ห้ามแก้ `helm-prod.yaml` ตรง ให้ใช้ `helm_patches/patch_uam_prod.yaml`): Commit `3c0d2ed` บน `fix/fx-01-uam` **แก้ `helm/helm-prod.yaml` ตรงแล้ว** (`Backend_Notification` → Internal DNS) รวมถึงแก้ `defer res.Body.Close()` — ต้องตัดสินใจก่อน MR เข้า `main` ว่าจะเก็บการแก้ Helm ใน commit นี้ หรือถอยออกแล้วใช้ Helm Patch แทน (อย่าทำทั้งสองทาง)

- **Log/ข้อความที่พบ:**
  - `POST /api/v1/uam/forget_password · 4 ครั้งใน 8 นาที · ใช้เวลา 27 ms · Error on response. [ERROR] - <nil>`
  - `POST /api/v1/uam/validate_email · 3 ครั้งใน 8 นาที · ใช้เวลา 29 ms · <email>{..} [ERROR] - <nil>`
- **ระดับความสำคัญ:** **P0 - Critical (User Onboarding & Password Recovery Blocker)**
- **ระบบที่เกี่ยวข้อง:** `go-echo-uam-service` (`controllers/notificationController.go`, `helm-prod.yaml`)

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. **External Hairpin Loop:** ใน `go-echo-uam-service/helm/helm-prod.yaml:45` ตัวแปร `Backend_Notification` ถูกตั้งค่าเป็น `https://api.insurverse.co.th/api/v1/notification/` (ชี้ออกนอก Cluster ย้อนกลับเข้ามา) ต่างจากทุก Environment และ Service อื่นที่ชี้หา `http://backend-notification-service:8080/api/v1/notification/`
2. **Unauthorized Rejection:** โค้ดใน `notificationController.go:EmailService` ยิงออก Gateway ภายนอกโดย **ไม่มี Authorization Header** จึงถูก Ingress/WAF ปฏิเสธกลับมาใน 27–29 ms
3. **Log Bug (`[ERROR] - <nil>`):** โค้ดตรวจสอบ `if err != nil || res.StatusCode != 200` แล้วสั่งพิมพ์ `log.Println("Error on response.\n[ERROR] -", err)` ซึ่งเมื่อ HTTP Response ไม่ใช่ 200 แต่ `err == nil` จึงพิมพ์ค่า `<nil>` ออกมา
4. **Resource Leak Bug:** บรรทัด 54 สั่ง `defer resp.Body.Close()` (Request) แทนที่จะเป็น `defer res.Body.Close()` (Response)

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แก้ไข `go-echo-uam-service/helm/helm-prod.yaml` (แก้ทันที):**
   ```yaml
   - name: Backend_Notification
     value: http://backend-notification-service:8080/api/v1/notification/
   ```
2. **แก้ไข Bug ใน `notificationController.go`:** ปรับ `defer res.Body.Close()` และสั่งพิมพ์ `res.StatusCode` กับ Response Body ลง Log

---

### Issue #17: Backoffice ส่ง Policy Email ล้มเหลว (Large PDF Resend Gateway Fail)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main)** (`helm/helm-prod.yaml:51` ชี้ `EMAIL_URL` ออกเน็ตนอก แนบ PDF ใหญ่โดน Gateway ตัด 2.2s)
  - **UAT-ISV (`origin/uat-isv`):** ⏳ **อยู่ระหว่างปรับ Helm ชี้ Internal DNS บน `uat-isv`** (เพื่อส่ง PDF ตรงเข้า Notification Service ใน Cluster ไม่ผ่าน Ingress Gateway)

- **Log/ข้อความที่พบ:**
  ```text
  HTTP 500 · backend-lead-policy-service · 14:02
  POST /api/v1/backoffice-lead-policy/leadpolicy/email · 4 ครั้งใน 8 นาที · ใช้เวลา 2.2 วินาที
  2026/09/16 14:02:34 [HTTPClient][ERROR] invalid character '<' looking for beginning of value
  2026/09/16 14:02:34 [Notification][ERROR] invalid character '<' looking for beginning of value
  ```
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-lead-policy-service` (`pkg/lead-policy/service/lead_policy_service.go`, `utils/http_client.go`)

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. ฟังก์ชัน `ResendPolicyEmail` โหลด PDF กรมธรรม์ ใบเสร็จ และบริการฉุกเฉิน แปลงเป็น Base64 ขนาดหลาย Megabytes แล้วยิง POST ไปที่ `EMAIL_URL`
2. ใน `helm-prod.yaml:51`: `EMAIL_URL` ชี้ไปที่ `https://api.insurverse.co.th/api/v1/notification/email` (วิ่งอ้อมออก Internet ย้อนเข้าตัวเอง)
3. การอัปโหลด Payload ขนาดใหญ่ใช้เวลา 2.2 วินาที และ Gateway / Cloudflare ปฏิเสธด้วย HTML Error Page (เช่น 502 Bad Gateway หรือ 413 Payload Too Large)
4. โค้ดใน `utils/http_client.go:45` นำ HTML มา parse ด้วย `json.NewDecoder` ส่งผลให้พ่น Error `invalid character '<' looking for beginning of value` และคืน HTTP 500

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แก้ไข `go-echo-lead-policy-service/helm/helm-prod.yaml`:**
   ```yaml
   - name: EMAIL_URL
     value: http://backend-notification-service:8080/api/v1/notification/email
   ```
2. **แก้ไข `utils/http_client.go`:** ตรวจสอบ `resp.StatusCode` ก่อนเรียก JSON Decoder

---

### Issue #18: ลูกค้าชำระเงินต่ออายุไม่ได้ (Missing ref_policy_no on Renewal)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ⏳ **รอคิว Deploy ขึ้น Prod (อยู่ใน WS7 บน Branch `hotfix/ws7-renew`)** (มี Guard ตรวจสอบ `ref_policy_no` ป้องกันการจ่ายเงินค้าง)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS7)** (ผูก `ref_policy_no` อัตโนมัติในฟังก์ชัน `fn_policy_renewal`)

- **Log/ข้อความที่พบ:**
  ```text
  a customer could not pay · 4 บรรทัดใน 30 นาที
  our API refused create-payment with HTTP 400 (renewal form = lead has no ref_policy_no, "this lead_no is not renewal").
  Find the lead in purchase-service "[ PAYMENT CLIENT ]" at that second;
  ```
- **ระดับความสำคัญ:** **P0 - Critical (Payment Blocker)**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service` (`controllers/paymentController.go:460-492`)

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. ลูกค้ากดต่ออายุกรมธรรม์และพยายามชำระเงิน แต่ในตาราง `insurverse."Lead_coverage_premium"` ช่อง `ref_policy_no` เป็น `NULL` หรือค่าว่าง
2. ฟังก์ชัน `CreatePaymentRenewal` ตรวจสอบเงื่อนไข `SELECT CASE WHEN lcp."ref_policy_no" IS NULL ...` แล้วพบว่าเป็น `false` จึงคืน HTTP 400 `"this lead_no is not renewal"`
3. ระบบพิมพ์ Log ข้อมูลผู้ชำระเงินไว้ก่อนหน้าในวินาทีเดียวกัน: `[ PAYMENT CLIENT ] => {"invoiceNo":"...", "paymentType":"POLICY_RENEWAL", "leadNo":"...", ...}`

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **ค้นหา Lead No ใน Cloud Logging:**
   ```text
   resource.type="k8s_container"
   resource.labels.container_name="backend-purchase-service"
   "[ PAYMENT CLIENT ]" "POLICY_RENEWAL"
   ```
2. **อัปเดตผูกเลขกรมธรรม์เดิมใน Database:**

   ```sql
   -- ✅ Schema verified 2026-09-23 (UAT-ISV): ไม่มีตาราง Lead_Header และ Policy_Header ไม่มี id_card
   --    ใช้เลขบัตรผู้เอาประกันคนที่ 1 (par_citizen_id_1) ของ Lead จับคู่กับ Policy_Header."Par_citizen_id_1"
   -- 1. ค้นหากรมธรรม์เดิมของลูกค้า (แสดง 5 รายการ ให้คนเลือกใบที่ทะเบียน/เลขตัวถังตรงกับรถคันที่ต่ออายุ)
   SELECT ph."Policy_No", ph."Car_license_no", ph."Car_serial_no", ph."Policy_Enddate"
   FROM insurverse."Policy_Header" ph
   JOIN insurverse."Lead_coverage_premium" lcp ON lcp."Lead_No" = <LEAD_NO>
   WHERE ph."Par_citizen_id_1" = lcp.par_citizen_id_1
   ORDER BY ph."Policy_Enddate" DESC LIMIT 5;

   -- 2. ผูก ref_policy_no ให้ Lead เพื่อให้จ่ายเงินได้ทันที (กันเขียนทับค่าเดิมด้วย IS NULL)
   UPDATE insurverse."Lead_coverage_premium"
   SET "ref_policy_no" = '<ORIGINAL_POLICY_NO>'
   WHERE "Lead_No" = <LEAD_NO> AND "ref_policy_no" IS NULL;
   ```

---

### Issue #19: Salesforce API โดน GCP LB ตัด 30s (SF Endorsement Waterfall Timeout)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ⏳ **รอคิว Deploy ขึ้น Prod (อยู่ใน WS6 บน Branch `hotfix/ws6-saleforce-endoesement`)** (ขาด `BackendConfig timeoutSec: 120` และการปรับลด Waterfall)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว (WS6)** (ปรับลดการเรียก API แบบ Waterfall ซ้ำซ้อนลง)

- **Log/ข้อความที่พบ:**
  ```text
  HTTP 502 · backend-saleforce-service · 16:02
  POST /api/v1/sf/saleforceControllerAPI · 1 ครั้งใน 8 นาที · ใช้เวลา 30.9 วินาที
  สาเหตุ: load balancer รอครบ 30 วินาทีแล้วตัดทิ้ง (ผู้ใช้ได้ 502) แต่ service ยังทำงานต่อ ถ้ามี error จะตามมาใน log ทีหลัง
  ```
- **ระดับความสำคัญ:** **P1 - High**
- **ระบบที่เกี่ยวข้อง:** `go-echo-saleforce-service` (`controllers/policy_transacti_service.go`, `util/api/main.go`), GCP External HTTP(S) Load Balancer

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. GCP Load Balancer มีค่า Default Backend Service Timeout อยู่ที่ **30 วินาที**
2. Endpoint `saleforceControllerAPI` ประมวลผลแบบ Synchronous Waterfall (รัน DB Function `fn_sf_policy_endorse_financial` -> เรียก `UamCreatePolicyAct` -> ยิงออกภายนอกไปหา OIC CMI PKI Webservice) ทำให้เวลารวมเกิน 30 วินาที (30.9s)
3. LB ตัดการเชื่อมต่อไปหา Salesforce และคืน HTTP 502 แต่ **Pod ใน Kubernetes ยังคงรันประมวลผลต่อใน Background** เนื่องจาก Go Client Timeout ถูกตั้งไว้ที่ 2 นาที (120s) ทำให้เกิดสภาวะ Phantom Execution (SF คิดว่าพังแต่ในระบบทำงานสำเร็จ)

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **Infra Fix:** สร้าง `BackendConfig` CRD ผูกกับ Service เพื่อขยาย Timeout เป็น 120 วินาที:
   ```yaml
   apiVersion: cloud.google.com/v1
   kind: BackendConfig
   metadata:
     name: backend-saleforce-backendconfig
   spec:
     timeoutSec: 120
   ```
2. **Code Fix:** แยกการยิง CMI Realtime ออกไปทำงานใน Asynchronous Background Queue / Worker

---

### Issue #20: Cloud SQL CPU Spike 17:00 SOP (EOD Batch vs Deploy Diagnostic)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ℹ️ **คู่มือปฏิบัติการ (Operational SOP)** (ช่วง 17:00 CPU พุ่ง 28.4% ให้ตรวจสอบ Cloud SQL Query Insights และ `pg_stat_activity` แยก EOD Batch)
  - **UAT-ISV (`origin/uat-isv`):** ℹ️ **คู่มือปฏิบัติการ (Operational SOP)** (ใช้แนวทางวินิจฉัยเดียวกัน)

- **Log/ข้อความที่พบ:**
  ```text
  Cloud SQL insureverse-prod CPU 28.4% · ปกติช่วง 17:00 อยู่ที่ 8.48%
  สูงกว่าปกติเกิน 3 เท่าและเกิน 20% ติดกัน 2 รอบ ให้เช็ก Query Insights ก่อนสรุปว่าเกิดจาก deploy
  ```
- **ระดับความสำคัญ:** **P2 - Medium (Operational Alert & Triage SOP)**
- **ระบบที่เกี่ยวข้อง:** Google Cloud SQL PostgreSQL (`insureverse-prod`), Query Insights

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. Alert CPU พุ่ง 3.3 เท่าช่วงเวลา 17:00 น. บ่อยครั้งเกิดจาก **End-of-Day (EOD) Batch Jobs** เช่น งานกระทบยอดบัญชีประจำวัน, สรุปยอดขาย, Batch Invoicing, และ Autovacuum ทำงานพร้อมกัน
2. การสรุปทันทีว่าเกิดจาก Deploy ช่วงบ่ายอาจทำให้เกิด **False Rollback** โดยไม่จำเป็น

#### 🛠️ แนวทางปฏิบัติการ (Standard Operating Procedure - SOP)

1. **เปิด GCP Console → Cloud SQL → `insureverse-prod` → `Query Insights`:**
   - ตรวจสอบ **Database Load by Wait Event** (CPU, IO:DataFileRead, หรือ Lock)
   - ตรวจสอบตาราง **Top Queries:** หาก Query ที่กิน CPU สูงสุดเป็น Query เดิมของงาน Batch / EOD → **ห้าม Rollback ให้ปล่อยรันจนจบ**
   - หาก Top Query เป็น Query ฟีเจอร์ใหม่ที่เพิ่ง Deploy และรันแบบ Sequential Scan (Seq Scan) ขาด Index → ให้ดำเนินการสร้าง Index แบบ `CONCURRENTLY`
2. **ตรวจสอบ Process สดบน Database:**
   ```sql
   SELECT pid, now() - query_start AS duration, state, wait_event, query
   FROM pg_stat_activity
   WHERE state != 'idle' AND pid != pg_backend_pid()
   ORDER BY duration DESC LIMIT 10;
   ```

---

### Issue #21: 2C2P Callback Panic จาก Type Assertion (Salesforce Auth Nil Panic)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว (21 ก.ย. 2026, Commit `af1dda7` / `89e58fe`)** (ใส่ Nil Check และ `sync.RWMutex` ป้องกัน Race Condition บน Salesforce Auth Token Caching)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **แก้ไขและ Deploy บน `uat-isv` แล้ว** (รวม Commit `4480a29` และเสริม Safe Pointer Dereference `sf_account` ใน Commit `059c275` / `263a6ee`)

- **Log/ข้อความที่พบ:**
  ```text
  ต้นเหตุที่ลูกค้าจ่ายเงินแล้วค้าง ช่วง Salesforce ล่ม (ตั้งแต่ 15:02)
  backend-purchase-service panic กลาง callback ของ 2C2P ทุกครั้งที่ Salesforce auth ไม่ผ่าน
  สาเหตุอยู่ที่ thirdparty/saleforce.go:75 (type assertion ไม่เช็ก nil) 20 ครั้งตั้งแต่ 15:02 · ก่อนหน้านั้นและเมื่อวาน 0 ครั้ง
  2C2P ไม่ได้รับคำตอบเลยส่งซ้ำ ทำให้ lead เดิมโผล่หลายรอบ
  http: panic serving [ip:port]: interface conversion: interface {} is nil, not string
  ```
- **ระดับความสำคัญ:** **P0 - Critical (Payment Webhook Panic & Policy Issuance Blocked)**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service` (`thirdparty/saleforce.go:75`, `controllers/paymentController.go:902`, `main.go`)

#### 🔍 รายละเอียดของปัญหา (Problem Details & Root Cause)

1. **Unsafe Type Assertion:** ใน `thirdparty/saleforce.go:75` ฟังก์ชัน `SaleforceUpsertAccount` สั่ง:
   ```go
   access_token := config.SF_Temp["access_token"].(string)
   instance_url := config.SF_Temp["instance_url"].(string)
   ```
   โดยไม่ได้ใช้ `comma-ok` และไม่ได้เช็กว่า `config.SF_Temp` เป็น `nil` หรือไม่
2. **Uncaught Panic in net/http:** ใน `go-echo-purchase-service/main.go` **ไม่มีการลงทะเบียน `e.Use(middleware.Recover())`** ทำให้ Panic ทะลุ Echo Framework ออกไปถึง `net/http/server.go` ซึ่งตัดสาย TCP ทันทีพร้อมพ่น `http: panic serving`
3. **Mid-Flight Abortion (เงินตัดแล้วแต่กรมธรรม์ไม่ออก):**
   - ใน `paymentController.go:893` โค้ดสั่งตัดเงินสำเร็จและบันทึก `payment_status = SUCCESS` เรียบร้อยแล้ว
   - แต่เกิด Panic ที่บรรทัด 902 (`getSaleforceAccount`) ทำให้ขั้นตอนหลังจากนั้นทั้งหมด **ถูกตัดทิ้ง ไม่ได้รันเลย:**
     - ❌ E-Policy / PDF กรมธรรม์ไม่ออก
     - ❌ `CreatePolicyFormInternal` ไม่ออกเลขกรมธรรม์ต่ออายุ
     - ❌ ไม่ส่งข้อมูลเข้า IIA (คปภ.)
     - ❌ ไม่ส่งอีเมลยืนยันให้ลูกค้า
4. **2C2P Infinite Webhook Storm:** เมื่อ 2C2P ถูกตัดสายโดยไม่ได้รับ HTTP 200 OK จึงทำการ Auto-Retry ส่ง Webhook ซ้ำเรื่อยๆ ทำให้ Lead เดิมถูกยิงซ้ำและ Panic วนซ้ำไปถึง 20 ครั้ง

#### 🛠️ การแก้ไขปัญหา (Resolution & Recovery)

1. **แก้ Hotfix ใน `thirdparty/saleforce.go`:**
   ```diff
   -	access_token := config.SF_Temp["access_token"].(string)
   -	instance_url := config.SF_Temp["instance_url"].(string)
   +	if config.SF_Temp == nil {
   +		return "", false, errors.New("salesforce config is not initialized")
   +	}
   +	access_token, okToken := config.SF_Temp["access_token"].(string)
   +	instance_url, okUrl := config.SF_Temp["instance_url"].(string)
   +	if !okToken || !okUrl || access_token == "" || instance_url == "" {
   +		return "", false, errors.New("invalid salesforce access_token or instance_url")
   +	}
   ```
2. **ลงทะเบียน Recover ใน `main.go`:** เพิ่ม `e.Use(middleware.Recover())` — ✅ ตรวจ 2026-09-23: มีแล้วที่ `main.go:40` ทั้งบน `origin/main` และ `origin/uat-isv`
3. **แยก SF Sync ออกจาก Critical Path:** นำการซิงก์ Salesforce ออกจาก Blocking Path ของ 2C2P Callback ให้ไปรันใน Goroutine/Queue แทน
4. **ค้นหาและกู้คืนเคสลูกค้าที่ค้าง (Data Recovery SQL):**
   ```sql
   SELECT p."lead_no", p."invoice_no", p."amount", p."payment_status", p."updated_at"
   FROM insurverse.payment p
   WHERE p."updated_at" >= '2026-09-16 15:02:00'
     AND p."payment_status" = 'SUCCESS'
     AND NOT EXISTS (
         -- payment.lead_no เป็น integer แต่ Policy_Header."Lead_No" เป็น varchar ต้อง cast
         SELECT 1 FROM insurverse."Policy_Header" ph WHERE ph."Lead_No" = p."lead_no"::text
     )
   ORDER BY p."updated_at" DESC;
   ```

---

### Issue #22: ต่อ TLS ไม่ผ่าน (ใบรับรองไม่ถูก trust) — อีเมลกรมธรรม์ส่งไม่ออก (SMTP TLS Unknown Authority)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว (17 ก.ย. 2026, Commit `700776d` / MR `ca1989b`)** (อัปเกรด Base Image เป็น `distroless/base-debian12` มี GlobalSign Root R46 รองรับ TLS Handshake 100%)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวมบน `uat-isv` แล้ว** (ส่งอีเมลผ่าน TLS สำเร็จ 100%)

- **Log/ข้อความที่พบ:**
  ```text
  ต่อ TLS ไม่ผ่าน (ใบรับรองไม่ถูก trust) — อีเมลกรมธรรม์ส่งไม่ออก
  กระทบ: ลูกค้าไม่ได้รับอีเมลกรมธรรม์ (E-Policy) หรือการเรียกบริการภายนอกล้ม
  จำนวน: 75 ครั้งใน 30 นาที · ยอดสะสมล้มเหลว 591 ครั้ง (10:25–15:45) · ส่งสำเร็จ 0
  สาเหตุ: backend-notification-service ต่อ SMTP ไม่ได้: tls: failed to verify certificate: x509: certificate signed by unknown authority — ใบรับรองของ mail server ไม่ถูก trust (เปลี่ยน cert / CA ฝั่ง mail server หรือมีตัวกลางดัก TLS)
  หมายเหตุ: deploy notification-service (MR !99) เมื่อ 15:41 ไม่ใช่ต้นเหตุ — error เริ่มก่อน 5 ชั่วโมง และยังล้มต่อหลัง deploy
  ต้องทำ: เช็ก cert ของ SMTP server / CA ใน image แล้วส่งอีเมลกรมธรรม์ซ้ำให้ลูกค้าที่ออกตั้งแต่ 10:25
  ```
- **ระดับความสำคัญ:** **P0 - Critical (E-Policy Delivery Broken Across All Lines of Business)**
- **ระบบที่เกี่ยวข้อง:** `go-echo-notification-service` (`controllers/notificationController.go`, `constants/constant.go`, `Dockerfile`), SMTP Server (`mail.dhipaya.co.th:25` / SMTP Relay)
- **ช่วงเวลาและผลกระทบ:**
  - เริ่มเกิดอาการ: ตั้งแต่เวลา **10:25 น. (17 ก.ย. 2026)** จนถึงปัจจุบัน
  - ปริมาณความเสียหาย: ส่งล้มเหลว **591 ครั้ง (10:25–15:45)** · ส่งสำเร็จ **0 ครั้ง** _(เมื่อวานช่วงเวลาเดียวกันส่งสำเร็จ 91 ครั้ง, ก่อนหน้านี้ไม่เคยพบ error นี้)_
  - ผลกระทบทางธุรกิจ: ลูกค้าที่ออกกรมธรรม์ (พ.ร.บ. และประกันภัยรถยนต์ภาคสมัครใจ) ทุกรายไม่ได้รับอีเมลกรมธรรม์ (E-Policy) เข้ากล่องจดหมาย

#### 🔍 รายละเอียดของปัญหาและการวิเคราะห์หาสาเหตุ (RCA & Problem Details)

1. **การพิสูจน์ตัดประเด็น Deployment MR !99:**
   - มีการ Deploy `notification-service` (MR !99) เมื่อเวลา 15:41 น.
   - **ข้อเท็จจริง:** Error SMTP เกิดขึ้นสะสมตั้งแต่ 10:25 น. (ก่อนหน้าการ Deploy นานกว่า 5 ชั่วโมง) และยังคงล้มเหลวต่อเนื่องหลัง Deploy จึงสรุปได้ 100% ว่า **MR !99 ไม่ใช่ต้นเหตุของปัญหา**
2. **สาเหตุทางเทคนิค (Technical Root Cause):**
   - ใน `go-echo-notification-service/controllers/notificationController.go:342` มีการเรียกใช้:
     ```go
     d := mail.NewDialer(smtpHost, smtpPort, smtpUser, smtpPass)
     ```
   - ฟังก์ชัน `d.DialAndSend()` ของไลบรารี Go Mail จะทำการ Negotiate STARTTLS อัตโนมัติ โดยเรียก `crypto/tls` มาตรวจสอบความถูกต้องของ Certificate เทียบกับ System Root CA Bundle
   - Container Image ถูกสร้างจาก `FROM gcr.io/distroless/base-debian11` ซึ่งมีเฉพาะ Root CA มาตรฐานสากล
   - **จุดที่ล้มเหลว:** Mail Server ปลายทาง (`mail.dhipaya.co.th`) มีการเปลี่ยนหรือต่ออายุ Certificate ใหม่ที่เป็น Internal Enterprise CA / Self-signed หรือ Intermediate CA ใน Chain ไม่ครบถ้วน หรือมี Network Gateway/Firewall ดักจับ TLS Traffic ทำให้ Go ตัดการเชื่อมต่อทันทีด้วยข้อผิดพลาด `x509: certificate signed by unknown authority`

#### 🛠️ การแก้ไขปัญหาและการฟื้นฟูระบบ (Resolution & Recovery)

1. **การตรวจสอบ Certificate Chain จาก Pod จริง (Investigation Command):**
   ```bash
   # ตรวจสอบ Certificate และ Chain ที่ส่งมาจาก SMTP Server
   openssl s_client -connect mail.dhipaya.co.th:25 -starttls smtp -showcerts
   ```
2. **แนวทางแก้ไขด่วนใน Go Code (Emergency Hotfix):**
   - เปิดให้อ่านค่า `SMTP_INSECURE_SKIP_VERIFY` ผ่าน Environment Variable เพื่อรองรับกรณีฉุกเฉิน:
     ```go
     d := mail.NewDialer(smtpHost, smtpPort, smtpUser, smtpPass)
     if os.Getenv("SMTP_INSECURE_SKIP_VERIFY") == "true" {
         d.TLSConfig = &tls.Config{InsecureSkipVerify: true}
     }
     ```
3. **แนวทางแก้ไขถาวรด้าน Security (Permanent Enterprise CA Fix):**
   - นำไฟล์ `.crt` ของ Enterprise CA เพิ่มเข้าไปใน Distroless Image หรือ Mount ผ่าน Kubernetes Secret ไปยัง `/etc/ssl/certs/`
4. **สคริปต์ SQL ดึงรายชื่อกรมธรรม์ที่ต้องยิง Resend อีเมล (Data Recovery SQL):**
   ```sql
   -- ค้นหากรมธรรม์ที่ออกตั้งแต่ 10:25 วันที่ 17 ก.ย. 2026 เพื่อเตรียมส่งอีเมล E-Policy ซ้ำ
   -- ✅ Schema verified 2026-09-23 (UAT-ISV): Policy_Header ไม่มี id_card / car_license_no / created_at
   SELECT 
       ph."Policy_No",
       ph."Lead_No",
       ph."Owner_citizen_id",
       ph."email",
       ph."Car_license_no",
       ph."Policy_Startdate",
       ph."Create_date"
   FROM insurverse."Policy_Header" ph
   WHERE ph."Create_date" >= '2026-09-17 10:25:00'
   ORDER BY ph."Create_date" ASC;
   ```

---

### Issue #23: OCR Passport Reader ล่มจาก DNS NXDOMAIN (eKYC MRZ Service Unavailable)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main)** (DNS หา `api.ekycsolution.com` ไม่เจอ ขาด Graceful Fallback ไปหน้า Manual Input)
  - **Application Code:** ✅ **แก้โค้ดแล้ว** (Commit `3c0d2ed` บน branch `fix/fx-01-uam` แตกจาก `main` — ตอบ HTTP 200 + `"is_success": false, "can_manual": true` ตาม diff ด้านล่างทุกบรรทัด)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **รวม `fix/fx-01-uam` เข้า `uat-isv` แล้ว** (ตรวจ 2026-09-23: branch เป็น ancestor ของ `origin/uat-isv`) — ต้องให้ Frontend ทดสอบว่าสลับไปหน้ากรอกมือเมื่อได้ `can_manual: true`

- **Log/ข้อความที่พบ:**
  ```text
  HTTP 500 (error ในโค้ด) · backend-uam-service · 15:19
  POST /api/v1/uam/ocr_passport_reader_service · 2 ครั้งใน 7 นาที · ใช้เวลา 59 ms
  ERROR HTTPCustoms : HTTP request failed error="Post \"https://api.ekycsolution.com/api/MRZService\": dial tcp: lookup api.ekycsolution.com on <ip>:53: no such host"
  ```
- **ระดับความสำคัญ:** **P1 - High (OCR KYC Feature Broken / Unhandled Downstream Error)**
- **ระบบที่เกี่ยวข้อง:** `go-echo-uam-service` (`controllers/ekycController.go:943`, `constants/constant.go`, `helm/helm-prod.yaml`)
- **ช่วงเวลาและผลกระทบ:**
  - เวลาที่เกิดเหตุ: **15:19 น. (17 ก.ย. 2026)**
  - ความถี่: พบ 2 ครั้งใน 7 นาที อัตรา Response Time เร็วมาก (59 ms) เนื่องจาก DNS lookup fail ทันที
  - ผลกระทบต่อผู้ใช้: ลูกค้าที่อัปโหลดรูปหนังสือเดินทาง (Passport) เพื่อทำ OCR สกัดข้อมูลสำหรับซื้อประกัน ไม่สามารถอ่านข้อมูลอัตโนมัติได้ ทำให้หน้าบ้านได้รับ HTTP 500 และบังคับให้ผู้ใช้ต้องพิมพ์กรอกข้อมูลเองแบบ Manual

#### 🔍 รายละเอียดของปัญหาและการวิเคราะห์หาสาเหตุ (RCA & Problem Details)

1. **DNS Resolution Failure (NXDOMAIN):**
   - ใน `helm/helm-prod.yaml` กำหนดค่า:
     ```yaml
     - name: URL_YIP_Passport
       value: https://api.ekycsolution.com/api/MRZService
     ```
   - จากการทดสอบตรวจสอบ DNS ระดับโลก (`nslookup api.ekycsolution.com`) พบว่าโดเมน **ไม่มีอยู่ในสารบบ DNS (NXDOMAIN: Non-Existent Domain)** ทำให้ Kubernetes DNS (`<ip>:53`) ตอบกลับทันทีว่า `no such host`
   - สาเหตุอาจเกิดจาก Third-party Provider (Yipinsoi / eKYC Solution) ไม่ได้ต่ออายุ Domain, เกิด DNS Outage ฝั่งผู้ให้บริการ, หรือมีการเปลี่ยนแปลง Hostname ปลายทางโดยไม่ได้แจ้งล่วงหน้า
2. **Missing Graceful Degradation in Application Code:**
   - ใน `go-echo-uam-service/controllers/ekycController.go:943-954`:
     ```go
     res, err := helper.HTTPCustoms(&input)
     if err != nil {
         logYipinsoi.ResponseStatus = http.StatusInternalServerError
         logYipinsoi.ResponseBody = err.Error()
         ...
         slog.Error("/api/v1/uam/ocr_passport_reader_service", "Error calling PassportMRZ : ", err)
         return c.JSON(http.StatusInternalServerError, models.JsonReturn{})
     }
     ```
   - เมื่อ Endpoint ภายนอกล้มเหลว โค้ดส่ง `HTTP 500 Internal Server Error` กลับไปที่ Frontend ทันที โดยไม่มี Message อธิบาย และไม่มี Fallback Signal ทำให้ Frontend แสดง Error Popup แทนที่จะสลับไปหน้ากรอกข้อมูล Manual อย่างราบรื่น

#### 🛠️ การแก้ไขปัญหาและการฟื้นฟูระบบ (Resolution & Recovery)

1. **Vendor Triage & Domain Verification:**
   - ติดต่อผู้ให้บริการ (Yipinsoi / eKYC Solution) เพื่อยืนยันว่า Domain `api.ekycsolution.com` ใช้งาน URL ใด หรือมีการย้ายไปใช้ IP/Domain ใด (เช่น `uat.ekycsolution.com` หรือ Domain ภายใน)
2. **Code Graceful Degradation ใน `ekycController.go`:**
   - ปรับปรุง Error Handling ให้คืน HTTP 200 หรือ HTTP 503 พร้อม JSON ที่ระบุสถานะให้ชัดเจน เพื่อให้หน้าบ้านแนะนำผู้ใช้กรอกข้อมูลเองโดยไม่ทำให้ Flow สะดุด:
     ```diff
     -	return c.JSON(http.StatusInternalServerError, models.JsonReturn{})
     +	return c.JSON(http.StatusOK, map[string]interface{}{
     +		"status":      http.StatusOK,
     +		"is_success":  false,
     +		"can_manual":  true,
     +		"description": "OCR service temporarily unavailable, please enter details manually",
     +	})
     ```
3. **ตรวจสอบ Endpoint OCR อื่นๆ:**
   - ตรวจสอบว่า `URL_YIP_OCRService` (`https://api.ekycsolution.com/api/OCRService`) และ `URL_YIP_FaceRecogService` ได้รับผลกระทบจาก Domain ล่มเช่นเดียวกันหรือไม่

---

### Issue #24: GCP LB 503 ((no backend)) บน Partner OAuth2 Token (Zero Pod Ready)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main)** (`helm/helm-prod.yaml` กำหนด Memory 128Mi เสี่ยง OOM และ Readiness Delay 60s นานเกินไป ทำให้ LB ตอบ 503 ((no backend)))
  - **UAT-ISV (`origin/uat-isv`):** ✅ **แก้ไขแล้วบน `uat-isv`** (`helm/helm-uat-isv.yaml` ขยาย Memory Limit เป็น 256Mi และลด Readiness Delay เหลือ 15s)

- **Log/ข้อความที่พบ:**
  ```text
  HTTP 503 POST /services/oauth/v2/token ((no backend))
  1x in 8m, last 12:39, took 0.521599s | cause: no error line logged by the service around the response
  ```
- **ระดับความสำคัญ:** **P2 - Medium (Ingress Zero-Backend Dropout / Partner Token Handshake Failure)**
- **ระบบที่เกี่ยวข้อง:** `openapi-oauth-service` (`go-oauth2-server`), GCP External HTTP(S) Load Balancer, Container-Native NEG
- **ช่วงเวลาและผลกระทบ:**
  - เวลาที่เกิดเหตุ: **12:39 น. (17 ก.ย. 2026)**
  - ความถี่: เกิด 1 ครั้งในรอบ 8 นาที ใช้เวลา 0.52 วินาที (521 ms)
  - ผลกระทบต่อผู้ใช้: พันธมิตรทางธุรกิจภายนอก (B2B Partners เช่น Shopee, Kerry) ไม่สามารถขอ Access Token สำหรับยิง API ส่ง Lead ประกันภัยเข้าสู่ระบบได้ในช่วงเวลาดังกล่าว

#### 🔍 รายละเอียดของปัญหาและการวิเคราะห์หาสาเหตุ (RCA & Problem Details)

1. **ทำไมใน Container ถึงไม่มี Error Log? (The Missing Log Mystery):**
   - ข้อความ **`((no backend))`** เป็น Error String เฉพาะของ **Google Cloud HTTP(S) Load Balancer**
   - เกิดขึ้นเมื่อ LB พยายามส่งต่อ Request ไปยัง Network Endpoint Group (NEG) แต่ในขณะนั้น **ไม่มี Pod ใดใน Kubernetes ที่อยู่ในสถานะ Healthy/Ready เลย (0 Ready Endpoints)**
   - GCP LB พยายามรอ Connection นาน 0.52 วินาที แล้วตัดสายตอบกลับ HTTP 503 ทันที
   - เนื่องจาก **Request ถูกตัดที่ระดับ Load Balancer จึงไม่เคยวิ่งไปถึง Pod** ทำให้ Fiber Engine ภายใน `go-oauth2-server` ไม่มีการบันทึก Log ใดๆ
2. **ทำไม Pod ใน NEG ถึงหายไปชั่วคราวตอน 12:39 น.? (Root Cause):**
   - เมื่อตรวจสอบไฟล์ [helm-prod.yaml](file:///Users/kritsanawathaniyanon/Code/Go/go-oauth2-server/helm/helm-prod.yaml) พบจุดเปราะบาง 2 จุดหลัก:
     1. **Memory Limit ต่ำมาก (`memory: 128Mi`):** Go Runtime และ Fiber Framework หากมีทราฟฟิกพุ่งสูง หรือจังหวะคืน Memory ช้า จะทำให้ Pod ถูกเคอร์เนลสั่งฆ่าด้วยสถานะ **OOMKilled (Exit Code 137)** ทันที
     2. **Readiness Probe ดีเลย์สูงเกินไป (`initialDelaySeconds: 60`):** เมื่อ Pod รีสตาร์ต Kubernetes จะรอถึง **60 วินาที** ก่อนเริ่มตรวจสอบความพร้อม ทำให้เกิดช่วงสูญญากาศ (Dead Zone) ที่ Load Balancer ไม่มี Pod สำรองใช้งาน ส่งผลให้เกิด HTTP 503 `((no backend))`

#### 🛠️ การแก้ไขปัญหาและการป้องกันระยะยาว (Resolution & Hardening)

1. **คำสั่งตรวจสอบสถานะ Pod และประวัติ OOMKill บน Cluster:**
   ```bash
   # ตรวจสอบว่ามี Pod โดน Restart หรือ OOMKill หรือไม่
   kubectl -n production describe pod -l app=openapi-oauth-service | grep -E "(Restart Count|Last State|OOMKilled|Terminated)"
   ```
2. **ปรับปรุง Resource Limits และ Probes ใน `helm-prod.yaml`:**
   ```diff
    resources:
      requests:
        cpu: 50m
   -    memory: 64Mi
   +    memory: 128Mi
      limits:
   -    cpu: 100m
   -    memory: 128Mi
   +    cpu: 200m
   +    memory: 256Mi
    
    readinessProbe:
      httpGet:
        path: /readyz
        port: 3000
   -  initialDelaySeconds: 60
   +  initialDelaySeconds: 15
      timeoutSeconds: 3
      periodSeconds: 8
   ```
3. **เพิ่ม Lifecycle Hook `preStop` เพื่อทำ Graceful Draining:**
   - เพิ่ม `lifecycle.preStop.exec.command: ["sleep", "5"]` เพื่อให้ Pod ยังรับ Request เดิมจนจบก่อนถูกดึงออกจาก Ingress NEG

---

### Issue #25: CORS OPTIONS 503 ((no backend)) บน Analytics Service (Preflight NEG Drop)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main)** (`helm/helm-prod.yaml` Readiness Delay 60s ขาด `lifecycle.preStop` ทำให้ Browser Preflight CORS OPTIONS โดน 503)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **แก้ไขแล้วบน `uat-isv`** (`helm/helm-uat-isv.yaml` ลด Readiness Delay เหลือ 15s และเพิ่ม PreStop Hook)

- **Log/ข้อความที่พบ:**
  ```text
  HTTP 503 OPTIONS /api/v1/analytics/analytics ((no backend))
  1x in 8m, last 12:19, took 1.141599s | cause: no error line logged by the service around the response
  ```
- **ระดับความสำคัญ:** **P2 - Medium (Frontend CORS Preflight Failure / Data Loss)**
- **ระบบที่เกี่ยวข้อง:** `backend-analytics-service` ([go-echo-analytics-service](file:///Users/kritsanawathaniyanon/Code/Go/go-echo-analytics-service/helm/helm-prod.yaml)), GCP External HTTP(S) Load Balancer
- **ช่วงเวลาและผลกระทบ:**
  - เวลาที่เกิดเหตุ: **12:19 น. (17 ก.ย. 2026)**
  - ความถี่: พบ 1 ครั้งใน 8 นาที ใช้เวลา 1.14 วินาที (1,141 ms)
  - ผลกระทบต่อผู้ใช้: คำขอ `OPTIONS` คือ Browser CORS Preflight เมื่อตอบกลับด้วย HTTP 503 เบราว์เซอร์จะบล็อกคำขอ `POST /api/v1/analytics/analytics` ทันที และพ่น CORS Policy Error ใน Console ทำให้ Event พฤติกรรมผู้ใช้สูญหาย

#### 🔍 รายละเอียดของปัญหาและการวิเคราะห์หาสาเหตุ (RCA & Problem Details)

1. **สาเหตุที่ Service ไม่มี Error Log:**
   - สถานะ `((no backend))` เกิดจาก GCP Load Balancer ไม่พบ Pod ที่พร้อมรับงานใน Network Endpoint Group (NEG) ในจังหวะที่เบราว์เซอร์ส่ง Preflight เข้ามา LB พยายามรอ Connection ครบ 1.14 วินาทีแล้วตัดสายตอบ 503 ทันที Request จึงไม่เคยไปถึง Container Pod
2. **สาเหตุเชิงโครงสร้างใน Helm Config (Systemic Pattern เดียวกับ Issue #24):**
   - ใน `helm-prod.yaml` กำหนดค่า:
     ```yaml
     readinessProbe:
       httpGet:
         path: /healthcheck
         port: 8080
       initialDelaySeconds: 60
     ```
   - การตั้ง `initialDelaySeconds: 60` สูงเกินไป ทำให้เมื่อ Pod มีการรีสตาร์ตหรือเกิด Node Rolling Update ตัว Pod ใหม่จะไม่ถูกเพิ่มเข้า NEG เป็นเวลานานกว่า 1 นาที ส่งผลให้เกิด Dead Zone ที่ LB ไม่มี Endpoint ส่งงาน

#### 🛠️ การแก้ไขปัญหาและการป้องกันระยะยาว (Resolution & Hardening)

1. ปรับลด `readinessProbe.initialDelaySeconds` ใน `helm-prod.yaml` จาก 60 วินาที เหลือ **15 วินาที**
2. เพิ่ม `lifecycle.preStop.exec.command: ["sleep", "5"]` เพื่อป้องกันการดึง Pod ออกจาก Ingress ก่อน Connection เดิมประมวลผลเสร็จ

---

### Issue #26: 2C2P Callback 502 Pod ปิดสายหนี (backend_connection_closed)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ✅ **แก้ไขและ Deploy บน Prod (main) แล้ว (21 ก.ย. 2026, Commit `af1dda7` / `89e58fe`)** (ขจัด Go Panic ใน Callback Loop ทำให้ 2C2P ได้รับ HTTP 200 OK ไม่ตัดสาย TCP Drop 502)
  - **UAT-ISV (`origin/uat-isv`):** ✅ **แก้ไขและ Deploy บน `uat-isv` แล้ว** (แก้คู่ขนานกับ Issue #21 ใน Commit `4480a29` และ `263a6ee`)

- **Log/ข้อความที่พบ:**
  ```text
  HTTP 502 (pod ไม่ตอบ/หมดเวลา) · backend-purchase-service · 15:25
  POST /api/v1/purchase/callback · 1 ครั้งใน 8 นาที · ใช้เวลา 3.1 วินาที
  สาเหตุ: load balancer ติดต่อ pod ไม่ได้ — pod อาจกำลัง restart หรือปิดการเชื่อมต่อก่อน (backend_connection_closed_before_data_sent_to_client)
  ```
- **ระดับความสำคัญ:** **P0 - Critical (Payment Webhook Disruption / Risk of Phantom Success)**
- **ระบบที่เกี่ยวข้อง:** `go-echo-purchase-service` (`controllers/paymentController.go`, `thirdparty/saleforce.go`), 2C2P Payment Gateway, GCP Load Balancer
- **ช่วงเวลาและผลกระทบ:**
  - เวลาที่เกิดเหตุ: **15:25 น. (17 ก.ย. 2026)**
  - ผลกระทบ: 2C2P ส่ง Callback ยืนยันการตัดเงินของลูกค้าเข้ามา แต่ได้รับ HTTP 502 กลับไป ทำให้ 2C2P ทำการยิง Retry ซ้ำ และมีความเสี่ยงสูงที่ลูกค้าถูกตัดเงินแล้วแต่การสร้าง E-Policy / IIA / อีเมลถูกตัดตอนกลางคัน

#### 🔍 รายละเอียดของปัญหาและการวิเคราะห์หาสาเหตุ (RCA & Problem Details)

1. **ทำไม Load Balancer แจ้ง `backend_connection_closed_before_data_sent_to_client` (3.1s)?**
   - อาการนี้เกิดขึ้นเมื่อ Load Balancer เชื่อมต่อกับ Pod สำเร็จและกำลังรอ Response Body แต่จู่ๆ **Pod ฝั่ง Backend ทำการปิด TCP Socket ทิ้งกะทันหัน** ก่อนส่ง Response Header/Body
   - ใน Go `net/http` พฤติกรรมนี้เกิดขึ้นได้จาก 2 กรณีหลัก:
     1. **Go Runtime Panic:** เกิด Panic ภายใน Goroutine ของ Callback โดยไม่มี `middleware.Recover()` ดักจับ (ลักษณะเดียวกับ **Issue #21: Salesforce Auth Nil Panic**) ตัว Server จะตัดสาย TCP ทันที
     2. **OOMKilled หรือ Pod Crash:** Pod กิน Memory เกินขีดจำกัดจน Kernel สั่ง SIGKILL ดับกะทันหันขณะกำลังทำงาน
2. **ความเชื่อมโยงกับเวลา 3.1 วินาที:**
   - เวลา 3.1 วินาทีชี้ชัดว่าคำขอไม่ได้ตายตั้งแต่ต้นทาง แต่ได้ทำงานไปแล้วบางส่วน (เช่น บันทึก `payment_status = SUCCESS` ลงฐานข้อมูล และเริ่มเรียก Salesforce หรือ IIA) ก่อนจะเกิด Panic หรือถูกตัดสาย

#### 🛠️ การตรวจสอบด่วนและการกู้คืน (Immediate Triage & Recovery)

1. **ค้นหา Lead ที่ถูกตัดเงินเวลา 15:20–15:30 น. ทันที (Data Integrity SQL):**
   ```sql
   -- ตรวจสอบเคสที่ 2C2P Callback เข้ามาตอน 15:25 น. ว่าเงินตัดสำเร็จแต่กรมธรรม์ออกครบหรือไม่
   SELECT 
       p."lead_no", 
       p."invoice_no", 
       p."amount", 
       p."payment_status", 
       p."updated_at",
       ph."Policy_No"
   FROM insurverse.payment p
   LEFT JOIN insurverse."Policy_Header" ph ON ph."Lead_No" = p."lead_no"::text  -- integer vs varchar
   WHERE p."updated_at" BETWEEN '2026-09-17 15:20:00' AND '2026-09-17 15:30:00'
   ORDER BY p."updated_at" DESC;
   ```
2. **หากพบว่า `payment_status = 'SUCCESS'` แต่ `Policy_No IS NULL`:**
   - ให้ดำเนินการ Re-trigger Flow การออกกรมธรรม์ทันที เพื่อป้องกันลูกค้าได้รับผลกระทบ
3. **การแก้ไขเชิงป้องกันถาวร (Permanent Fix):**
   - เร่งปล่อย Hotfix ป้องกัน Panic ใน `thirdparty/saleforce.go` และลงทะเบียน `middleware.Recover()` ใน `main.go` ตามแนวทางของ **Issue #21**

---

### Issue #27: OpenAPI Motor Premium 503 (HTML Unmarshal Error via Hairpin Loop)

- **สถานะการแก้ไข (Status):**
  - **Production (`origin/main`):** ❌ **ยังไม่ได้รับการแก้ไขบน Prod (main)** (`helm/helm-prod.yaml` `ISV_HOST` ชี้ Hairpin นอก Cluster + `repository.go:50` ขาดการตรวจสอบ HTTP Status Code ก่อน Unmarshal ทำให้ Code พังเมื่อเจอ HTML `<`)
  - **UAT-ISV (`origin/uat-isv`):** ⏳ **อยู่ระหว่างปรับ `ISV_HOST` และ HTTP Status Code Check บน `uat-isv`**

- **Log/ข้อความที่พบ:**
  ```text
  HTTP 503 (ระบบไม่พร้อม) · openapi-motor-service · 13:43
  GET /api/v1/motor/premium · 6 ครั้งใน 8 นาที · ใช้เวลา 106 ms
  ERROR [GetMotorPremiumInternal] Error: invalid character '<' looking for beginning of value
  service ตอบกลับว่า API, System Fail Error
  ```
- **ระดับความสำคัญ:** **P1 - High (Partner API Disruption / Lead Generation Blocked)**
- **ระบบที่เกี่ยวข้อง:** `openapi-motor-service` ([go-e-api](file:///Users/kritsanawathaniyanon/Code/Go/go-e-api)), Cloudflare WAF, External Ingress
- **ช่วงเวลาและผลกระทบ:**
  - เวลาที่เกิดเหตุ: **13:43 น. (17 ก.ย. 2026)**
  - ความถี่: เกิด 6 ครั้งในรอบ 8 นาที ตอบกลับรวดเร็วมาก (106 ms)
  - ผลกระทบต่อผู้ใช้: พันธมิตรภายนอก (Brokers/Partners) ที่เรียกขอเบี้ยประกันรถยนต์และสร้าง Lead ผ่าน OpenAPI ไม่สามารถคำนวณราคาได้ โดยได้รับ HTTP 503 "API, System Fail Error"

#### 🔍 รายละเอียดของปัญหาและการวิเคราะห์หาสาเหตุ (RCA & Problem Details)

1. **ที่มาของ Error `invalid character '<' looking for beginning of value`:**
   - ในภาษา Go ข้อความ Error นี้มาจากฟังก์ชัน `json.Unmarshal()` เมื่อ Payload ที่ส่งเข้ามาเริ่มต้นด้วยตัวอักษร `<` ซึ่งเป็นโครงสร้างของ **HTML Page (`<!DOCTYPE html>` หรือ `<html>`)** ไม่ใช่ JSON Object ที่ขึ้นต้นด้วย `{` หรือ `[`
2. **ทำไมถึงได้รับหน้าเว็บ HTML ภายในเวลา 106 ms? (Hairpin NAT Loop):**
   - เมื่อตรวจสอบไฟล์คอนฟิก [helm-prod.yaml](file:///Users/kritsanawathaniyanon/Code/Go/go-e-api/helm/helm-prod.yaml#L52-L53) ของ `go-e-api` พบว่า:
     ```yaml
     - name: ISV_HOST
       value: "https://api.insurverse.co.th"
     ```
   - Service ภายในคลัสเตอร์ Kubernetes ไม่ได้ยิงหา Service ปลายทางผ่าน Internal DNS แต่ยิงวนลูปออกไปยังโดเมนสาธารณะ **`https://api.insurverse.co.th` (Hairpin Loop)**
   - คำขอจึงต้องวิ่งผ่าน **Cloudflare WAF / GCP External Load Balancer** ซึ่งเกิดการตรวจจับหรือมี Rate Limit / Security Rule ทำให้ Cloudflare หรือ Ingress บล็อกคำขอและส่งหน้าเว็บ Error HTML กลับมาอย่างรวดเร็ว (106 ms)
3. **ข้อบกพร่องในโค้ด [repository.go:50-59](file:///Users/kritsanawathaniyanon/Code/Go/go-e-api/internal/motor/repository/repository.go#L50-L59):**
   - โค้ดนำผลลัพธ์จาก `s.fetchPost()` ไปสั่ง `json.Unmarshal([]byte(apiResult), &r)` โดยตรง **โดยไม่ได้ตรวจสอบว่า `httpCode >= 400` หรือไม่ และไม่ได้เช็คว่า Content-Type เป็น `application/json` หรือไม่** ทำให้เกิด Error แตกกระจายและตอบกลับ HTTP 503 สู่พาร์ตเนอร์

#### 🛠️ การแก้ไขปัญหาและการป้องกันระยะยาว (Resolution & Hardening)

1. **ปรับปรุง Helm Config เปลี่ยนจาก Hairpin เป็น Internal DNS (Primary Fix):**
   - ปรับ `ISV_HOST` ใน `helm-prod.yaml` ให้ชี้ Kubernetes Service ภายในคลัสเตอร์โดยตรง (เช่น `http://backend-core-service:8080` หรือ `http://backend-premium-service:3001`) เพื่อไม่ให้ทราฟฟิกวิ่งออกเน็ตนอกและไม่ติด Cloudflare WAF
2. **ปรับปรุง Defensive Coding ใน `repository.go`:**
   ```diff
    apiResult, httpCode, err := s.fetchPost(s.cfg.ISV.Endpoint.Premium, string(jsonData))
    if err != nil {
        slog.Error(fmt.Sprintf("[%s] Request Error: %s", s.cfg.ISV.Endpoint.Premium, err.Error()))
        return
    }
   +if httpCode >= 400 {
   +    slog.Error(fmt.Sprintf("[%s] Downstream returned HTTP %d: %s", s.cfg.ISV.Endpoint.Premium, httpCode, apiResult))
   +    return r, fmt.Errorf("downstream service returned status %d", httpCode)
   +}
    err = json.Unmarshal([]byte(apiResult), &r)
   ```
