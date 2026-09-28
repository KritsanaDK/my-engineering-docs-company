# GitLab Release Manifest: OIC Act Payment & Concurrency Hardening (WS1 + WS5)
# บันทึกความพร้อมของ Git Branch และ Merge Requests

เอกสารฉบับนี้รวบรวมข้อมูล Git Branch, ลิงก์สำหรับสร้าง GitLab Merge Request (MR) เข้าสู่สาขา `main` (Production) และขอบเขตการเปลี่ยนแปลงของทุกบริการที่เกี่ยวข้อง

---

## 🚀 รายการ Repositories ที่ต้อง Deploy ขึ้น Production (main)

| ลำดับ | Service / Application | ขอบเขตงาน (Scope) | Source Branch | Target Branch | 🔗 ลิงก์สร้าง Merge Request (GitLab) |
| :---: | :--- | :---: | :---: | :---: | :--- |
| **1** | **`nextjs-webapp`** (Frontend) | **OIC Act Form, Payment Timeout Fix, Validation** | `hotfix/oic` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/frontend/nextjs-webapp/-/merge_requests/new?merge_request%5Bsource_branch%5D=hotfix/oic&merge_request%5Btarget_branch%5D=main) |
| **2** | **Database Migration** | **4 Core Concurrency-Safe Stored Procedures (WS1 + WS5)** | N/A (Run SQL) | `insurverse` (Prod DB) | Run `02_deploy_migration.sql` |

---

## 📝 รายละเอียดโค้ดและการเปลี่ยนแปลง:

### 1. `nextjs-webapp` (Frontend):
- **Branch**: `hotfix/oic`
- **Recent Commits**:
  - `1a6ea081`: fix: trigger confirmation modal when getCount reaches 10 or exceeds 9
  - `b59de319`: feat: allow null for birth_date and improve sanitizeLeadActInput type safety
  - `fe8f65d1`: fix: update vehicle registration number regex validation and input constraints for consistency
  - `e6b92554`: refactor: update navigation menu links, refine license plate regex validation
  - `fe7f0838`: fix(license-plate): require Thai consonants and numbers, reject numeric-only plates
- **Payment Handling**:
  - แก้ไขปัญหา infinite loading / timeout ใน `SuccessPayment.tsx` รองรับ redirect response จาก 2C2P ได้ถูกต้อง
  - ปรับปรุงการตรวจสอบข้อมูลผู้เอาประกัน OIC Act ให้ผ่านเกณฑ์ คปภ. (Sanitize payload ก่อนส่ง API)

### 2. Database Stored Procedures (`insurverse` DB):
- **WS1 (Policy Issuance)**:
  - `insurverse.fn_lead_to_car_act`: ป้องกัน Duplicate Key ตอนออกเลข พ.ร.บ. Standalone ด้วย Transaction Advisory Lock และ Collision Loop
  - `insurverse.fn_policy_to_car_act`: ป้องกันการแย่งเลข พ.ร.บ. คู่ประกันสมัครใจ (MV + MC)
- **WS5 (Invoicing & Quotation)**:
  - `insurverse.fn_policy_invoiceno_iia`: ป้องกัน Race Condition ในการสร้างเลขที่ใบแจ้งหนี้ (Invoice Number)
  - `insurverse.fn_policy_quatationno_iia`: ป้องกัน Race Condition ในการสร้างเลขที่ใบเสนอราคา (Quotation Number)

