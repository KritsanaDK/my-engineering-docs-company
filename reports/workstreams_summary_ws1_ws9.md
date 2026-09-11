# สรุปภาพรวมการแก้ไขปัญหางาน Workstream WS1 - WS9 (พร้อม GitLab MR Links)

เอกสารฉบับนี้รวบรวมรายละเอียดการวิเคราะห์ สาเหตุ แนวทางการแก้ไขปัญหาระบบ (Workstream WS1 - WS9) ครอบคลุมไมโครเซอร์วิสที่เกี่ยวข้อง สาขา Git Branch และลิงก์สำหรับสร้าง GitLab Merge Request (MR) ของทุกบริการ

---

## 📌 **WS1: จ่ายเงินแล้วกรมธรรม์ไม่ออก**

- **บริการที่เกี่ยวข้อง (Services):** `go-echo-uam-service`, `go-echo-purchase-service`, `PostgreSQL Database`
- **สถานะ (Status):** 🚀 **MERGED เข้า Production แล้ว (Merged to Prod)**
- **Git Branch:** `hotfix/ws1-policy-issue`
- **🔗 GitLab MR Links:**
  - 👉 [`go-echo-uam-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws1-policy-issue&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-purchase-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-purchase-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws1-policy-issue&merge_request%5Btarget_branch%5D=main)
- **ปัญหาสาเหตุ:**
  - เกิดสภาวะชนกัน (Race Condition) ขณะบันทึกข้อมูลและออกเลข พ.ร.บ. พร้อมกันในปริมาณมาก พบมากที่สุดในช่องทาง Shopee และขั้นตอนกรอกข้อมูลส่วนที่ 2
  - ระบบรีบไปอ่านข้อมูลก่อนที่ DB Transaction จะบันทึกเสร็จ จึงหาข้อมูลไม่เจอและล้มเหลว
  - ไม่สามารถใช้ PostgreSQL Sequence Object ปกติได้เนื่องจากเลข พ.ร.บ. มีรูปแบบเฉพาะตามสูตร `MC-00YY-M-XXXXX[MOD8]`
- **แนวทางการแก้ไข (Solution):**
  1. **WS1.1 (Transaction Boundary):** ครอบ DB Transaction (`tx.Beginx()`) ใน `policyController.go` ให้บันทึก `Policy_coverage_premium` และ `Policy_Header` เสร็จสิ้นก่อนอ่านข้อมูล
  2. **WS1.2 (Concurrency-Safe Numbering):** แก้ไข Stored Procedure ใน [`fn_lead_to_car_act.sql`](file:///Users/kritsanawathaniyanon/Code/Go/go-echo-uam-service/script/fn_lead_to_car_act.sql) และ [`fn_policy_to_car_act.sql`](file:///Users/kritsanawathaniyanon/Code/Go/go-echo-uam-service/script/fn_policy_to_car_act.sql) โดยใช้ `pg_advisory_xact_lock` ร่วมกับ `LOOP ... UNTIL NOT EXISTS`
  3. **WS1.3 (Shopee Channel Fix):** เพิ่ม Transaction Locking ใน Shopee Callback Handler ป้องกันการยิงแปลง Lead ซ้ำ
  4. **WS1.4 (Part 2 UI Sync):** ปรับ API Response หลังบันทึกข้อมูลส่วนที่ 2 ให้รอผลการ Commit จาก DB ก่อนคืนค่า JSON 200 เพื่อให้อัปเดต UI/การ์ดได้ถูกต้องทันที

---

## 📌 **WS2: ใบเสร็จ / เอกสาร E-Tax ไม่ออก**

- **บริการที่เกี่ยวข้อง (Services):** `python-fastapi-document-service`, `go-echo-uam-service`
- **สถานะ (Status):** 🚀 **MERGED เข้า Production แล้ว (Merged to Prod)**
- **Git Branch:** `hotfix/ws2-receipt-etax`
- **🔗 GitLab MR Links:**
  - 👉 [`python-fastapi-document-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/python-fastapi-document-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws2-receipt-etax&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-uam-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws2-receipt-etax&merge_request%5Btarget_branch%5D=main)
- **ปัญหาสาเหตุ:**
  - การส่งสร้างเอกสารกับ INET แบบ Synchronous เกิด Timeout เมื่อ INET ตอบกลับช้า ส่งผลให้ `etax_url` หลุดหาย
  - เอกสารสลักหลังออกเพียงฉบับสำเนา ไม่มีฉบับจริงที่ลูกค้าต้องนำไปใช้ต่อภาษี
  - ข้อมูลที่อยู่/รหัสไปรษณีย์บนใบเสร็จสลักหลังไม่ครบถ้วนเมื่อ `zipcode` หลักเป็น NULL
- **แนวทางการแก้ไข (Solution):**
  1. **WS2.1 (Migrate E-Tax เป็น Tax R2):** เพิ่ม Environment Variable `ETAX_API_VERSION: "R2"` ใน Helm Values และรองรับ Async Retry Polling (`RetryETAX`) เมื่อเกิด Timeout
  2. **WS2.2 (ออกเอกสารฉบับจริง ORIGINAL):** ปรับปรุง `handleReceiptType` ใน [`debt.go`](file:///Users/kritsanawathaniyanon/Code/Go/python-fastapi-document-service/internal/documents/usecase/endorse/debt.go#L320) ให้บันทึกไฟล์ต้นฉบับ (`debtDecreaseOriginal` / `debtIncreaseOriginal`) ก่อนสร้างสำเนาเสมอ
  3. **WS2.3 (แยก E-Tax MC/MV):** แยกประเภทระหว่าง พ.ร.บ. (`MC`) และสมัครใจ (`MV`) ในการยิงสร้างใบเสร็จ/ใบลดหนี้ผ่าน `getMCReceiptCreditNoteEtax` และ `getMVReceiptCreditNoteEtax`
  4. **WS2.4 (ดึงรหัสไปรษณีย์ครบถ้วน):** เพิ่ม `COALESCE(NULLIF("policy"."zipcode", ''), NULLIF("policy"."Owner_zipcode", ''), NULLIF("policy"."Deli_zipcode", ''), '')` ใน SQL Query

---

## 📌 **WS3: ข้อมูลไม่เข้าระบบ คปภ (CMI)**

- **บริการที่เกี่ยวข้อง (Services):** `go-fiber-policy-service`, `c-oic-realtime`, `go-echo-uam-service`
- **สถานะ (Status):** 🚀 **MERGED เข้า Production แล้ว (Merged to Prod)**
- **Git Branch:** `hotfix/ws3-cmi-oic` (`go-fiber-policy-service`), `hotfix/ws3-endorse-renew` / `hotfix/oic-cmi` (`go-echo-uam-service`)
- **🔗 GitLab MR Link:**
  - 👉 [`go-fiber-policy-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-fiber-policy-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws3-cmi-oic&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-uam-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws3-endorse-renew&merge_request%5Btarget_branch%5D=main)
- **ปัญหาสาเหตุ:**
  - ข้อมูลกรมธรรม์ พ.ร.บ. ของรถ (MV/MC) ไม่ถูกส่งเข้าระบบ คปภ. ทำให้ลูกค้าต่อภาษี/จดทะเบียนรถไม่ได้ (พบรายการตกค้างสะสม 529 รายการ)
  - วันเริ่มคุ้มครองเกิดก่อนวันทำสัญญา (`Effective_Startdate` < `Payment_Date`) (209 รายการ)
  - เลขอ้างอิงเอกสาร (`cmi_reference_number`) หรือรหัสเอกสารเป็นค่าว่าง / NULL (192 รายการ)
  - ไม่พบกรมธรรม์หลักของสลักหลัง (34 รายการ) และรูปแบบทะเบียน/รหัสจังหวัดไม่ตรงตาม Master Table ของ คปภ. (`mas_cmi_province`)
- **แนวทางการแก้ไข (Solution):**
  1. **WS3.1 (แก้เงื่อนไขวันเริ่มคุ้มครอง):** เพิ่ม Validation ปรับ `Effective_Startdate` ให้เริ่มต้น ณ เวลาทำสัญญา/ชำระเงินเมื่อพบวันที่ย้อนหลัง
  2. **WS3.2 (แก้เลขอ้างอิงเอกสาร):** เติมค่า `cmi_reference_number` / `IIA_Ref_no` อัตโนมัติป้องกันค่าว่างก่อนส่ง Payload เข้า คปภ.
  3. **WS3.3 (แก้ Mapping กรมหลัก & ทะเบียน/จังหวัด):** ปรับการ `JOIN` ตาราง `mas_cmi_province` และ Sanitize รูปแบบเลขทะเบียนรถใน `cmi_realtime.go`
  4. **WS3.4 (ยิงซ่อมข้อมูลค้าง 529 รายการ):** พัฒนา/รัน Reconcile Worker (`GetListReconcileProblemCMI`) ใน `go-fiber-policy-service` เพื่อส่งซ้ำรายการที่ตกค้างเข้า คปภ. (`PKISendPolicyREST` / `PKISendEndorseREST`)

---

## 📌 **WS4: เคลม / กรมธรรม์ไม่เข้าระบบ IIA**

- **บริการที่เกี่ยวข้อง (Services):** `node_iia_service`, `go-echo-uam-service`
- **สถานะ (Status):** 🚀 **MERGED เข้า Production แล้ว (Merged to Prod)**
- **Git Branch:** `hotfix/ws4-caim`
- **🔗 GitLab MR Links:**
  - 👉 [`node_iia_service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/node_iia_service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws4-caim&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-uam-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws4-caim&merge_request%5Btarget_branch%5D=main)
- **ปัญหาสาเหตุ:**
  - ข้อมูลเคลมค้างสะสม 707 รายการที่ไม่ถูกส่งเข้า IIA เกิดจากอักขระพิเศษใน XML Payload ทำโครงสร้างพัง และไม่มี Job ดึงรายการค้างกลับมาส่งซ้ำ
  - กรมธรรม์ช่องทาง INET เดือน ก.ค. ถูกข้ามเนื่องจากเงื่อนไข Query ไม่รองรับ
- **แนวทางการแก้ไข (Solution):**
  1. **WS4.1 (Reconcile Job 15 นาที):** พัฒนา Cron Worker `NewReconcileCron` ใน [`reconcile_cron.go`](file:///Users/kritsanawathaniyanon/Code/Go/node_iia_service/internal/server/cron/reconcile_cron.go) ค้นหารายการค้าง ทำการ Sanitize อักขระด้วย `SanitizeXMLString` และยิงเข้า IIA อัตโนมัติ
  2. **WS4.2 (Manual Resend REST API):** เพิ่ม Endpoint `POST /api/v1/iia/claim/resend` ให้ทีม Ops กดสั่ง Resend ทันที
  3. **WS4.3 (รองรับ กรม INET เดือน ก.ค.):** ปรับ Query ให้รวมกรมธรรม์ช่องทาง INET (`Payment_channel IN ('INET', 'WEB')`)

---

## 📌 **WS5: เลขที่ Invoice / ใบเสร็จ ซ้ำกัน**

- **บริการที่เกี่ยวข้อง (Services):** `go-echo-uam-service`, `PostgreSQL Database`
- **สถานะ (Status):** ⏳ **รอการดำเนินการ / Ready for Review & Merge**
- **Git Branch:** `hotfix/ws5-invoice`
- **🔗 GitLab MR Link:**
  - 👉 [`go-echo-uam-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws5-invoice&merge_request%5Btarget_branch%5D=main)
- **ปัญหาสาเหตุ:**
  - จังหวะสร้างเอกสารพร้อมกันทำให้ฟังก์ชันออกเลข Invoice / Quotation ดึงเลขล่าสุดตัวเดียวกันมาออกซ้ำ
- **แนวทางการแก้ไข (Solution):**
  1. **WS5.1 (Concurrency Guard):** แก้ไข Stored Function `fn_policy_invoiceno_iia` และ `fn_policy_quatationno_iia` ใน PostgreSQL ให้ใช้ Transaction Advisory Lock (`pg_advisory_xact_lock`) ตาม Prefix เดือน/ปี พร้อมเพิ่ม Loop Check ก่อนออกเลข
  2. **WS5.2 (Integration Test):** ดำเนินการทดสอบ Concurrency Load Testing ครอบคลุมทุกช่องทางธุรกรรม (ซื้อใหม่, สลักหลัง, ต่ออายุ ทั้ง DIY และ Partner TQM)

---

## 📌 **WS6: ข้อมูล Salesforce ไม่ครบ / ทำสลักหลังไม่ได้**

- **บริการที่เกี่ยวข้อง (Services):** `go-echo-saleforce-service`, `go-echo-uam-service`
- **สถานะ (Status):** ✅ **MERGED เข้า uat-isv แล้ว (Merged to UAT-ISV) - พร้อม Deploy Prod**
- **Git Branch:** `hotfix/ws6-saleforce-endoesement`
- **🔗 GitLab MR Link:**
  - 👉 [`go-echo-uam-service` MR Link (to main)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws6-saleforce-endoesement&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-uam-service` MR Link (to uat-isv)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws6-saleforce-endoesement&merge_request%5Btarget_branch%5D=uat-isv)
- **ปัญหาสาเหตุ:**
  - เบอร์โทร/ข้อมูลผู้ซื้อไม่ขึ้นใน Salesforce (ต่ออายุ MC ไม่ส่งเบอร์ต่อ)
  - ระบบหยิบค่า `prem_version` ผิดชุด ทำให้กด Edit ทำสลักหลังไม่ได้
  - แก้ CC รถแล้วเบี้ยเป็น 0 / ออก RY ผิดตัว
  - วันที่มีผลสลักหลัง MC คลาดเคลื่อนไป 1 วัน
  - เมื่อสลักหลังยกเลิกแล้ว สถานะบน Salesforce ยังคงขึ้นเป็น "บังคับใช้" (Active)
- **แนวทางการแก้ไข (Solution):**
  1. **WS6.1 (เติมเบอร์โทรผู้ซื้อ):** เพิ่ม `COALESCE("Owner_phone", phone, '')` ใน `salesforceController.go`
  2. **WS6.2 (สืบทอด prem_version):** แก้ไข `fn_policy_renewal` และ Query ให้สืบทอด `prem_version` / `oic_version` จากกรมธรรม์เดิม
  3. **WS6.3 (แก้คำนวณเบี้ย CC):** ปรับ Logic คำนวณเบี้ย CC และเลือก Endorsement Code (RY19) ให้ตรงเงื่อนไข
  4. **WS6.4 (ปรับวันสลักหลัง MC):** ปรับการคำนวณวันเริ่มต้นสลักหลัง MC ให้บวก 7 วัน (`+7 days`)
  5. **WS6.5 (อัปเดตสถานะยกเลิก):** แก้ไข Payload อัปเดต `Policy_Status` เป็นสถานะยกเลิก และส่งไฟล์แนบสลักหลัง (RY11) เข้า Salesforce ทันทีหลังอนุมัติ

---

## 📌 **WS7: งานต่ออายุ (Renew) ทำงานไม่ถูกต้อง**

- **บริการที่เกี่ยวข้อง (Services):** `go-echo-uam-service`, `go-echo-purchase-service`
- **สถานะ (Status):** ✅ **MERGED เข้า uat-isv แล้ว (Merged to UAT-ISV) - พร้อม Deploy Prod**
- **Git Branch:** `hotfix/ws7-renew`
- **🔗 GitLab MR Links:**
  - 👉 [`go-echo-uam-service` MR Link (to main)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws7-renew&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-uam-service` MR Link (to uat-isv)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws7-renew&merge_request%5Btarget_branch%5D=uat-isv)
  - 👉 [`go-echo-purchase-service` MR Link (to main)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-purchase-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws7-renew&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-purchase-service` MR Link (to uat-isv)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-purchase-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws7-renew&merge_request%5Btarget_branch%5D=uat-isv)
- **ปัญหาสาเหตุ:**
  - หน้าต่ออายุใช้ Logic เดียวกับหน้าซื้อใหม่ ทำให้คำนวณเบี้ยใหม่ ส่วนลดประวัติดี (NCB) ผิดพลาด
  - ต่ออายุแล้วข้อมูลผู้ขับขี่ระบุชื่อหาย
  - ทำรายการต่ออายุล่วงหน้าได้เกิน 90 วัน
  - กดลิงก์ต่ออายุจาก Backoffice แล้วยอดเบี้ยเปลี่ยน หรือ Gen Link ไม่ได้
  - ผู้ใช้งานสามารถแก้อาชีพผ่านหน้าเว็บขณะทำต่ออายุได้
- **แนวทางการแก้ไข (Solution):**
  1. **WS7.1 (คัดลอกข้อมูลผู้ขับขี่):** ดึงข้อมูลผู้ขับขี่ระบุชื่อจากกรมธรรม์เดิม (`ref_policy_no`) มาใส่ใน Lead ต่ออายุใหม่
  2. **WS7.2 (บล็อกต่ออายุเกิน 90 วัน):** เพิ่ม Validation `NOW() >= Policy_Enddate - INTERVAL '90 days'`
  3. **WS7.3 (แยก Flow Renewal Link):** แยก Endpoint/Logic สำหรับ Renewal Link ใน Backoffice ล็อคส่วนลด NCB ตามมาตรฐาน คปภ.
  4. **WS7.4 (ล็อค Field อาชีพ):** ปรับ Field อาชีพให้ Read-only เมื่อเป็นต่ออายุ (`ref_policy_no != ''`) และตั้ง DB Default เป็น `''` พร้อมตรวจสอบ String Format

---

## 📌 **WS8: หน้า Backoffice แสดงผล / ฟังก์ชันผิด**

- **บริการที่เกี่ยวข้อง (Services):** `go-echo-backoffice-service`, `go-echo-uam-service`
- **สถานะ (Status):** ✅ **MERGED เข้า uat-isv แล้ว (Merged to UAT-ISV) - พร้อม Deploy Prod**
- **Git Branch:** `hotfix/ws8-backoffice`
- **🔗 GitLab MR Links:**
  - 👉 [`go-echo-backoffice-service` MR Link (to main)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-backoffice-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws8-backoffice&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-backoffice-service` MR Link (to uat-isv)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-backoffice-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws8-backoffice&merge_request%5Btarget_branch%5D=uat-isv)
  - 👉 [`go-echo-uam-service` MR Link (to main)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws8-backoffice&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-uam-service` MR Link (to uat-isv)](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix%2Fws8-backoffice&merge_request%5Btarget_branch%5D=uat-isv)
- **ปัญหาสาเหตุ:**
  - กด Export โปรโมชันแล้วเกิด Error 500 เนื่องจากตาราง `insurverse.mas_promo_code` ไม่ได้มีอยู่จริงใน Database (ตารางจริงคือ `insurverse.promo_code` และคอลัมน์ชื่อ `create_by`)
  - สถานะกรมธรรม์ที่หมดอายุแล้วยังคงแสดงผลเป็น `ACT` (Active) บนหน้าจอ
  - คอลัมน์ส่วนลด % (`promo_discount_per`) และส่วนลดจำนวนเงิน (`promo_discount_amt`) แสดงผลสลับกัน
- **แนวทางการแก้ไข (Solution):**
  1. **WS8.1 (ดึงข้อมูลโปรโมชันจากตารางจริง):** ซิงก์ `GetReportPromoCode` ใน [`promoController.go`](file:///Users/kritsanawathaniyanon/Code/Go/go-echo-backoffice-service/controllers/promoController.go#L1264) ให้ตรงตาม `main` (ดึงจาก `insurverse.promo_code`) และปรับ [`exportController.go`](file:///Users/kritsanawathaniyanon/Code/Go/go-echo-backoffice-service/controllers/exportController.go) ให้ใช้ `FROM insurverse.promo_code` พร้อม map `create_by AS created_by`
  2. **WS8.2 (กรองสถานะกรมธรรม์หมดอายุ):** เพิ่มเงื่อนไข `AND NOW() <= "Policy_Enddate"` ใน Query ของ `policyController.go`
  3. **WS8.3 (สลับคอลัมน์ส่วนลดให้ถูกต้อง):** ปรับ Struct Tags และ DTO mapping ของ `promo_discount_per` และ `promo_discount_amt` ให้ตรงคอลัมน์

---

## 📌 **WS9: ระบบพื้นฐาน / งานดูแลระบบ (Ops)**

- **บริการที่เกี่ยวข้อง (Services):** `go-echo-uam-service`, `go-echo-notification-service`, `go-echo-analytics-service`
- **สถานะ (Status):** ✅ **MERGED TO UAT-ISV & VERIFIED (ทดสอบผ่าน 100%)**
- **Git Branch:** `uat-isv` (merged from `hotfix/ws9-ops`)
- **🔗 GitLab MR Links:**
  - 👉 [`go-echo-uam-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-notification-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-notification-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main)
  - 👉 [`go-echo-analytics-service` MR Link](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-analytics-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main)
- **ปัญหาสาเหตุ:**
  - UAM เคยล่มจาก Connection ฐานข้อมูลล้น (Max Open Connections Unlimited)
  - WordPress ต้อง redeploy ทุกครั้งที่มีการสั่ง deploy
  - อีเมล Hotmail/Outlook ส่งไม่ถึงลูกค้าเนื่องจากขาด Required SMTP Headers
  - ทีมต้องการ Reconcile Report API สำหรับกระทบยอด และคอลัมน์ BigQuery View เป็นภาษาไทย
- **แนวทางการแก้ไข (Solution):**
  1. **WS9.1 (ปรับ Connection Pool UAM):** ปรับตั้งค่า DB Connection Pool ใน `webserver/dbConnect.go` ของ `go-echo-uam-service` (`DB_MAX_OPEN_CONNS=50`, `DB_MAX_IDLE_CONNS=25`, `ConnMaxLifetime: 15m`, `ConnMaxIdleTime: 5m`)
  2. **WS9.2 (แยก PVC WordPress):** แยก Persistent Volume Claim (PVC) ให้ `wp-content` ใน Helm Values เพื่อไม่ให้โดน Reset เมื่อ Redeploy
  3. **WS9.3 (เพิ่ม SMTP Headers Hotmail):** เพิ่ม SMTP Headers ใน `notificationController.go` (`Reply-To`, `Message-ID`, `MIME-Version: 1.0`, `X-Priority: 3`)
  4. **WS9.4 (พัฒนา Reconcile Report API):** พัฒนา REST API `GET /api/v1/uam/report/reconcile` ใน `go-echo-uam-service` (ทดสอบผ่าน HTTP 200 ดึงข้อมูล 140 รายการรวดเร็วใน 84ms)
  5. **WS9.5 (BigQuery Column Migration):** เพิ่ม Migration Script `ws9_bigquery_column_migration.sql` เปลี่ยนชื่อคอลัมน์ BigQuery View เป็นภาษาอังกฤษ

---

## 🧪 ผลการคอมไพล์และการตรวจสอบ (Verification Summary)

| Microservice                      | Target Branch                                                        | Verification Command | Status            |
| :-------------------------------- | :------------------------------------------------------------------- | :------------------- | :---------------- |
| `go-echo-uam-service`             | `uat-isv` (WS1, WS5, WS7, WS8, WS9)                                  | `go build ./...`     | ✅ SUCCESS (100%) |
| `python-fastapi-document-service` | `hotfix/ws2-receipt-etax`                                            | `go build ./...`     | ✅ SUCCESS (100%) |
| `node_iia_service`                | `hotfix/ws4-caim`                                                    | `go build ./...`     | ✅ SUCCESS (100%) |
| `go-echo-backoffice-service`      | `uat-isv` (WS8)                                                      | `go build ./...`     | ✅ SUCCESS (100%) |
| `go-echo-purchase-service`        | `uat-isv` (WS1, WS7)                                                 | `go build ./...`     | ✅ SUCCESS (100%) |
| `go-echo-notification-service`    | `uat-isv` (WS9)                                                      | `go build ./...`     | ✅ SUCCESS (100%) |
| `go-echo-analytics-service`       | `uat-isv` (WS9)                                                      | Script Validation    | ✅ SUCCESS (100%) |

---

## 🚀 ตาราง Microservices ที่ต้อง Merge และ Deploy ขึ้น Production (WS6 - WS9)

สำหรับการนำโค้ดขึ้น Production หรือ Release Pack ครอบคลุม **WS6 ถึง WS9** มี **3 Microservices** ที่มีโค้ด logic ใหม่และต้องทำการ Merge เข้าสู่สาขา `main` เพื่อ Deploy:

| ลำดับ | Microservice | Scope / Workstreams | Source Branch | Target Branch | 🔗 GitLab Merge Request Link | รายละเอียดโค้ดที่เปลี่ยนแปลง |
| :---: | :--- | :---: | :---: | :---: | :--- | :--- |
| **1** | **`go-echo-uam-service`** *(Core Backbone)* | **WS6, WS7, WS8, WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) | • **WS6**: รองรับสลักหลังยกเลิก (`no_cancel_flag = 'Y'`), แก้ไข phone mapping<br>• **WS7**: ล็อกอาชีพตามกรมธรรม์เดิมตอนต่ออายุ (`Occupation` locking)<br>• **WS8**: เพิ่ม Policy Expiry Check สำหรับ Active Policies<br>• **WS9**: REST API `GET /api/v1/uam/report/reconcile` และ Configurable DB Connection Pooling (`DB_MAX_OPEN_CONNS`, `DB_MAX_IDLE_CONNS`) |
| **2** | **`go-echo-backoffice-service`** | **WS8** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-backoffice-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) | • **WS8**: ปรับระบบโปรโมชันให้เชื่อมตรงกับ `insurverse.promo_code`<br>• เพิ่มฟังก์ชัน Export รายงาน Promo Code เป็น Excel/CSV พร้อม `COALESCE(create_by, '')` |
| **3** | **`go-echo-notification-service`** | **WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-notification-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) | • **WS9**: เพิ่ม Dynamic SMTP Configuration และ Required Headers (`Reply-To`, `Message-ID`, `X-Priority`) เพื่อแก้อีเมลตกหล่นใน Hotmail/Outlook/Live |

> ℹ️ **สถานะของ Services อื่นๆ:**
> - **`go-echo-purchase-service`**: โค้ด Go ได้ถูก Merge เข้าสู่สาขา `main` เรียบร้อยแล้วก่อนหน้านี้ (ไม่มี Go diff ค้าง)
> - **`go-echo-saleforce-service`**: โค้ด Go บน `uat-isv` เหมือนกับ `main` 100% (Logic สลักหลังของ WS6 อยู่ใน `go-echo-uam-service`)
> - **`go-echo-analytics-service`**: มีเพียงไฟล์สคริปต์ BigQuery View Migration (`ws9_bigquery_column_migration.sql`) ซึ่งรันบน BigQuery โดยตรง ไม่มีการแก้ Go binary

---

## 📊 ตารางสรุปสถานะการขึ้นระบบ Production (Production Deployment Status Overview)

| Workstream | รายละเอียดงาน | บริการหลักที่เกี่ยวข้อง | สถานะการขึ้นระบบ (Deployment Status) | หมายเหตุ / Actions |
| :--- | :--- | :--- | :--- | :--- |
| **WS1** | จ่ายเงินแล้วกรมธรรม์ไม่ออก | `go-echo-uam-service`, `go-echo-purchase-service`, PostgreSQL | 🚀 **MERGED TO PROD** | อัปเดต Stored Proc `fn_lead_to_car_act` บน Prod เรียบร้อย |
| **WS2** | ใบเสร็จ / เอกสาร E-Tax ไม่ออก | `python-fastapi-document-service`, `go-echo-uam-service` | 🚀 **MERGED TO PROD** | ใช้งาน Tax R2 พร้อม Async Polling |
| **WS3** | ข้อมูลไม่เข้าระบบ คปภ (CMI) | `go-fiber-policy-service`, `go-echo-uam-service` | 🚀 **MERGED TO PROD** | พร้อมรัน Reconcile Worker ส่งซ่อมข้อมูล 529 รายการ |
| **WS4** | เคลม / กรมธรรม์ไม่เข้าระบบ IIA | `node_iia_service`, `go-echo-uam-service` | 🚀 **MERGED TO PROD** | Reconcile Cron (15 นาที) ดึงเคลมค้าง 707 รายการอัตโนมัติ |
| **WS5** | เลขที่ Invoice / ใบเสร็จ ซ้ำกัน | `go-echo-uam-service`, PostgreSQL DB | ⏳ **Ready for Review / Merge** | รอทดสอบ Concurrency & Merge |
| **WS6** | ข้อมูล Salesforce ไม่ครบ / ทำสลักหลังไม่ได้ | `go-echo-saleforce-service`, `go-echo-uam-service` | ✅ **MERGED TO UAT-ISV** | ทดสอบผ่าน Live API & DB 100% (`no_cancel_flag='Y'`) |
| **WS7** | งานต่ออายุ (Renew) ทำงานไม่ถูกต้อง | `go-echo-uam-service`, `go-echo-purchase-service` | ✅ **MERGED TO UAT-ISV** | ทดสอบผ่าน Live API 100% (`fn_policy_renewal` 90-day lock) |
| **WS8** | หน้า Backoffice แสดงผล / ฟังก์ชันผิด | `go-echo-backoffice-service`, `go-echo-uam-service` | ✅ **MERGED TO UAT-ISV** | เชื่อม `insurverse.promo_code` + Export CSV ผ่าน 100% |
| **WS9** | ระบบพื้นฐาน / งานดูแลระบบ (Ops) | `go-echo-uam-service`, `go-echo-notification-service`, `analytics` | ✅ **MERGED TO UAT-ISV** | Reconcile Report API + Pool Config ทดสอบผ่าน 100% |


