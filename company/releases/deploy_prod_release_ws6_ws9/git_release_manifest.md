# GitLab Release Manifest: Workstreams WS6 - WS9
# บันทึกความพร้อมของ Git Branch และ Merge Requests

เอกสารฉบับนี้รวบรวมข้อมูล Git Branch, ลิงก์สำหรับสร้าง GitLab Merge Request (MR) เข้าสู่สาขา `main` (Production) และขอบเขตการเปลี่ยนแปลงของทุกบริการที่เกี่ยวข้อง

---

## 🚀 รายการ Microservices ที่ต้อง Merge ขึ้น Production (main)

| ลำดับ | Microservice | ขอบเขตงาน (Workstreams) | Source Branch | Target Branch | 🔗 ลิงก์สร้าง Merge Request (GitLab) |
| :---: | :--- | :---: | :---: | :---: | :--- |
| **1** | **`go-echo-uam-service`** | **WS6, WS7, WS8, WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-uam-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) |
| **2** | **`go-echo-backoffice-service`** | **WS8** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-backoffice-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) |
| **3** | **`go-echo-notification-service`** | **WS9** | `uat-isv` | `main` | 👉 [Create MR to `main`](https://isv-gl-s.insurverse.co.th/insurverse/backend/go-echo-notification-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=uat-isv&merge_request%5Btarget_branch%5D=main) |

---

## 📝 รายละเอียดโค้ดที่เปลี่ยนแปลงในแต่ละบริการ:

### 1. `go-echo-uam-service`:
- **WS6**: รองรับการสลักหลังยกเลิก (`no_cancel_flag = 'Y'`), ปรับ mapping เบอร์โทรผู้ซื้อส่งขึ้น Salesforce
- **WS7**: ล็อกอาชีพผู้เอาประกันตามกรมธรรม์เดิม (`Owner_occupation` locking)
- **WS8**: ปรับ Query กรองเฉพาะ Active Policies (`NOW() <= "Policy_Enddate"`)
- **WS9**: พัฒนา REST API `GET /api/v1/uam/report/reconcile` และเพิ่ม Configurable Connection Pooling (`DB_MAX_OPEN_CONNS=50`, `DB_MAX_IDLE_CONNS=25`)

### 2. `go-echo-backoffice-service`:
- **WS8**: ปรับระบบโปรโมชันให้เชื่อมต่อกับตารางจริง `insurverse.promo_code` และฟังก์ชัน Export รายงาน Promo Code ป้องกันค่า NULL Pointer

### 3. `go-echo-notification-service`:
- **WS9**: เพิ่ม Dynamic SMTP Configuration และ Required Headers (`Reply-To`, `Message-ID`, `X-Priority`) เพื่อแก้อีเมลตกหล่นใน Hotmail/Outlook/Live
