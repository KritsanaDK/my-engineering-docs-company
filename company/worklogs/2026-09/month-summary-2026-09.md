# 📊 Monthly Performance Summary: 2026-09

## 🏆 Key Business Impact & Major Milestones
- **Architecture & Concurrency**: ออกแบบและทดสอบ PostgreSQL Advisory Locks (WS1-WS9) ป้องกันการออกกรมธรรม์และตัดเงินซ้ำซ้อน
- **OIC & Compliance**: ควบคุม Data Sanitization & Strict Validations 100% ตามมาตรฐาน คปภ.
- **DevOps & Stability**: Migrate โดเมนสู่ `.co.th` ทุก Microservices และอัปเดตระบบเซ็น Digital Certificate

## 🌟 Leadership & People Contribution
### 🗓️ วันที่ 2026-09-11
- **Root Cause OAuth บน UAT-ISV**: ตรวจสอบพบว่า repository `go-oauth2-server` ยังไม่มี branch `uat-isv` และไม่มีไฟล์ `helm-uat-isv.yaml` ส่งผลให้ OAuth service ตัวจริงไม่เคยถูก deploy ลงบนสภาพแวดล้อม UAT-ISV จึงจำเป็นต้องใช้ Mock Service ทดแทนชั่วคราว
- **Next Step**: เตรียมตรวจสอบ Configuration และ Secret ของ JWT Token ระหว่าง OAuth ตัวจริงกับ `go-e-api` เพื่อให้ Sign / Verify Signature ตรงกันก่อนเปิดใช้งานจริง

## 📈 Workload & Engineering Metrics
- **Total Active Repositories**: 23 repos
- **Total Git Commits**: 86 commits
- **Services Handled**: `go-e-api`, `go-echo-analytics-service`, `go-echo-auth-service`, `go-echo-backoffice-service`, `go-echo-core-service`, `go-echo-file-service`, `go-echo-home-service`, `go-echo-internal-service`, `go-echo-lead-policy-service`, `go-echo-notification-service`, `go-echo-pa-service`, `go-echo-purchase-service`, `go-echo-saleforce-service`, `go-echo-ta-service`, `go-echo-uam-service`, `go-fiber-policy-service`, `go-fiber-queue-service`, `isv-test`, `nextjs-webapp`, `node_iia_service`, `nodejs-express-marketing-service`, `nodejs-express-premium-service`, `python-fastapi-document-service`

## 📚 Self-Improvement & Technical Learnings
- พัฒนาทักษะเชิงลึกด้าน Database Advisory Locking, Concurrency Stress Testing, และ OIC Regulatory System Architecture

## 📅 Daily Highlights Breakdown
### 🗓️ 2026-09-07
**TH**: - วิเคราะห์ปัญหาฟังก์ชัน saveLeadCoveragePremium และความถูกต้องของ LeadNo
- ทบทวนสถาปัตยกรรม Issuance Concurrency (Workstream WS1–WS9)
- แก้ไขตารางโปรโมชันใน go-echo-backoffice-service เตรียมขึ้นทดสอบบน UAT

**EN**: - Investigated saveLeadCoveragePremium and LeadNo handling while reviewing WS1–WS9 policy issuance concurrency architecture.
- Merged promo table fixes in go-echo-backoffice-service for UAT verification.

### 🗓️ 2026-09-08
**TH**: - สำรองข้อมูล (Backup) ฐานข้อมูล UAT-ISV ทั้ง Table, Function และ Sequence ลงเครื่อง
- วางแนวทางการทดสอบ Flow การออกกรมธรรม์ WS6–WS9 ผ่าน Frontend
- วิเคราะห์โครงสร้างและทดสอบตาราง Imp_Discount_Premium สำหรับคำนวณส่วนลดเบี้ยประกัน

**EN**: - Created a complete local backup of the UAT-ISV database schema, functions, and sequences.
- Evaluated frontend testing flows for WS6–WS9 and analyzed discount premium table structures.

### 🗓️ 2026-09-09
**TH**: - ปรับเปลี่ยนและ Migrate โดเมนบน Helm Chart ทุก Microservices จาก .dev เป็น .co.th
- อัปเดตและทดสอบ Digital Certificate (INET CAD Token) สำหรับเซ็นเอกสารใน python-fastapi-document-service
- ตรวจสอบความถูกต้องของ CI/CD Pipeline และการเชื่อมต่อระหว่างระบบหลังย้ายโดเมน

**EN**: - Migrated service domains from .dev to .co.th across all Helm charts and verified CI/CD pipelines.
- Updated renewed INET CAD digital certificate token in python-fastapi-document-service for PDF signing.

### 🗓️ 2026-09-10
**TH**: - ปรับปรุง Validation และ Data Sanitization ฝั่ง Frontend ใน nextjs-webapp ให้ตรงตามเกณฑ์ คปภ. (OIC)
- เพิ่ม Guardrail ตรวจสอบความยาวและรูปแบบข้อมูลฝั่ง Backend ใน nodejs-express-premium-service และ go-fiber-policy-service
- ปรับปรุงการจำแนกและดึงข้อมูล agentBrokerLicenseNumber ตาม Partner Code ให้ถูกต้อง

**EN**: - Implemented strict OIC compliance validations and field bounds across frontend (nextjs-webapp) and backend services.
- Refactored broker license number resolution dynamically based on partner codes.

### 🗓️ 2026-09-11
**TH**: - ปรับปรุง Regex ตรวจสอบเลขทะเบียนรถยนต์ให้ถูกต้องตามเกณฑ์อักษรไทย และปรับปรุง Type Safety ให้ birth_date รับ Null ได้
- เพิ่ม Modal Confirmation เมื่อจำนวนการดึงข้อมูลถึงเกณฑ์ (>= 10) พร้อมอัปเดตเมนูการนำทาง
- ตรวจสอบพบสาเหตุ OAuth ตัวจริงไม่เคยถูก deploy ลง UAT-ISV (ขาด branch และ helm) พร้อมวางแนวทางเทียบ JWT config กับ go-e-api
- สร้างและทดสอบระบบ Worklog Tracker เพื่อบันทึกประวัติการทำงานอัตโนมัติลง ~/worklogs/

**EN**: - Refined vehicle license plate regex validations to enforce Thai character standards and improved input sanitization type safety.
- Added confirmation modal triggers on threshold counts and updated navigation links.
- Identified missing UAT-ISV OAuth deployment and planned JWT alignment with go-e-api.

