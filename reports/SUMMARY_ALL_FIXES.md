# 📋 รายงานสรุปผลการแก้ไขปัญหาทั้งหมด (Summary of All Fixes)

**ชื่อ Branch รวม**: `hotfix/ws1-policy-issue`  
**สภาพแวดล้อม (Target Environment)**: `UAT-ISV` / `UAT` / `SIT` / `DEV`  
**วันที่บันทึก**: 24 สิงหาคม 2569  

---

## 📌 1. ภาพรวมการแก้ไขรายประเด็น (Executive Summary)

| ลำดับ | รายการปัญหาที่พบ | สาเหตุหลัก (Root Cause) | แนวทางการแก้ไข (Solution) | Repositories & Commits |
| :---: | :--- | :--- | :--- | :--- |
| **1** | **สร้าง Account แจ้งรหัสผ่านไม่ตรงเงื่อนไข** | ฟังก์ชัน `PasswordChecker` ไม่ผ่านเงื่อนไขตัวอักษรพิมพ์เล็ก-ใหญ่ผสมตัวเลขและอักขระพิเศษสำหรับ `Insure@2026` | ปรับปรุง Regex/Validation Logic ใน `go-echo-uam-service` ให้รองรับเงื่อนไข `Insure@2026` พร้อมเพิ่ม Unit Test ครอบคลุม | `go-echo-uam-service`<br>Commit: `cc9a0f8` |
| **2** | **หน้าเงื่อนไขการรับประกันภัยแสดงเฉพาะ พ.ร.บ.** | เงื่อนไขบนหน้า Frontend Term & Condition ดึงเฉพาะข้อความเงื่อนไข พ.ร.บ. ในทุกชั้นประกัน | ปรับ Logic ใน `nextjs-webapp` ให้ดึงข้อความเงื่อนไขที่ถูกต้องตามสินค้า (MV เดี่ยว, MV+Act คู่, MC เดี่ยว) | `nextjs-webapp`<br>Commit: `75f41a37` |
| **3** | **ได้รับอีเมลซ้ำ และไฟล์แนบไม่ถูกต้อง** | ระบบส่งอีเมลฉบับ Broker ซ้ำซ้อนก่อน แล้วจึงส่งฉบับ Direct ที่มีไฟล์ไม่ครบ | ปรับ `python-fastapi-document-service` ให้ส่งอีเมลฉบับเดียว พร้อมแนบไฟล์ครบ 3 ไฟล์ (ตารางกธ., เงื่อนไข 2026, บริการช่วยเหลือฉุกเฉิน) | `python-fastapi-document-service`<br>Commit: `aba3fa4` |
| **4** | **หน้าตารางกธ. อาชีพไม่ถูกต้อง (ออกรับจ้างฯ)** | มีการ Hardcode หรือ Fallback ค่าอาชีพเป็น "รับจ้าง / พนักงานบริษัท" ใน Flow บันทึก Lead | ปรับ `isv-test` และ `go-echo-lead-policy-service` ให้นำค่าอาชีพที่ผู้ใช้เลือกจริงจากฟอร์มบันทึกลงฐานข้อมูล | `isv-test`<br>`go-echo-lead-policy-service`<br>Commit: `beb18dc` |
| **5** | **เอกสารใบเสร็จชั้น 2+ และ Card ไม่ครบ** | `PolicyType` ส่งค่า `"2+"` เข้า Jasper Service แต่ Jasper Template รองรับเฉพาะ `"2p"` / `"3p"` | เพิ่มฟังก์ชัน Convert `2+` -> `2p` และ `3+` -> `3p` ใน `python-fastapi-document-service` ทำให้สร้างใบเสร็จชั้น 2+ สำเร็จ | `python-fastapi-document-service`<br>Commit: `aba3fa4` |
| **6** | **ช่องความเสียหายส่วนแรก MV ขึ้น [Blank]** | Template Jasper 2026 ไม่ได้ผูกตัวแปร Parameter `fix_4` | ตรวจสอบและแมป `fix_4 = "0.00"` ลงใน Template MV 2026 ทุกชั้นประกันใน `java-spring-boot-jasper-report-service` | `java-spring-boot-jasper-report-service`<br>Commit: `de889e8` |
| **7** | **เลือกส่งไปรษณีย์ "ตามที่อยู่ ปชช" บันทึกไม่ผ่าน** | Frontend ส่ง `address_no` ไปใน `deliAddrLine1` ทำให้ Backend เข้าใจผิดว่าเป็นที่อยู่ใหม่ (`addressSameCardID = false`) | ส่ง `checkedDeli` และ `addressSameCardId: true` จาก Frontend และปรับ Backend ให้อ่าน Flag นี้เพื่อใช้ที่อยู่บัตรประชาชน | `nextjs-webapp` (`346d9fd3`)<br>`isv-test` (`0aa5bee`) |
| **8** | **เอกสารกรมธรรม์และใบเสร็จ MC ใน SF และหน้าการ์ดไม่มี** | `isv-test` ไม่ได้เรียก Trigger Document Service (`GET /api/v1/doc/act/{policyNo}`) หลังออกกรมธรรม์สำเร็จ | เพิ่ม Background Goroutine เรียก Trigger Document Service ทันทีหลังออกกรมธรรม์ ทั้งซื้อคู่ (MV+Act) และซื้อเดี่ยว (MC) | `isv-test`<br>Commit: `0aa5bee` |
| **9** | **วันที่บนหน้าตารางกธ. MC/MV และใบเสร็จไม่ถูกต้อง** | SQL Query สลับไปดึง `Payment_date` มาใช้เป็นวันทำสัญญาและวันทำกธ. | ปรับ `mc_query.go` และ `mv_query.go` ให้:<br>- **หน้าตารางกธ. (MC & MV)**: วันทำสัญญา & วันทำกธ. = **วันที่กรอกข้อมูล** (`Create_date`)<br>- **ใบเสร็จ**: วันทำสัญญา = **วันที่กรอกข้อมูล** (`Create_date`), ลงวันที่ & วันที่ชำระเงิน = **วันที่ชำระเงิน** (`Payment_date`) | `python-fastapi-document-service`<br>Commit: `36501e8` |
| **10** | **ใบเสร็จ MC อาชีพไม่ถูกต้อง (ออกรับจ้างฯ)** | `oauth_controller.go` มีการ Hardcode `occ_001` และ Frontend ไม่ได้ส่งฟิลด์ `occupation` ของ MC | ปรับ Frontend ให้ส่ง `occupationCode` / `occupation` และปลด Hardcode ใน Backend `isv-test` | `nextjs-webapp` (`d0286b41`)<br>`isv-test` (`653182f`) |
| **11** | **Helm Deployment Error บน GitLab Runner** | Kubernetes Service `backend-isv-test-service` มีอยู่แล้วใน Namespace แต่ขาด Helm Ownership Metadata | แนะนำและจัดเตรียมคำสั่ง Annotate / Label Helm Ownership หรือ Delete Service เพื่อให้ Helm เข้าควบคุม | Kubernetes / CI Config |

---

## 🛠️ 2. รายละเอียดเชิงลึกของการแก้ไขแต่ละ Service (Technical Details)

### 2.1 `nextjs-webapp` (Frontend Web Application)
- **ไฟล์ที่แก้ไข**:
  - `src/services/mv-service/types.ts`: เพิ่ม `checkedDeli?: boolean` และ `addressSameCardId?: boolean` ใน `SubmitMVPolicyInput`
  - `src/types/actFormData.ts`: เพิ่ม `checkedDeli`, `addressSameCardId`, `occupationCode`, `occupation` ใน `ActApiPayload`
  - `src/modules/mv/MvTermAndCondition.tsx`: ปรับการส่ง Flag `checkedDeli` และ `addressSameCardId`
  - `src/modules/act/components/ActTermAndCondition.tsx`: ปรับการส่ง Flag การจัดส่งและอาชีพของผู้เอาประกันภัย
- **Commits**: `75f41a37`, `346d9fd3`, `d0286b41`

---

### 2.2 `isv-test` (Backend ISV Gateway Service)
- **ไฟล์ที่แก้ไข**:
  - `controller/mv_controller.go`:
    - เพิ่มฟิลด์ `CheckedDeli` และ `AddressSameCardID` ใน `MVPolicyRequest`
    - แก้ไข Logic คำนวณ `addressSameCardID` ให้เคารพ Flag เมื่อเลือก "ตามที่อยู่ ปชช"
    - เพิ่ม Goroutine สั่ง Trigger สร้างเอกสาร พ.ร.บ. (`triggerActPolicyDocuments`) หลังออกกรมธรรม์ MV+Act สำเร็จ
  - `controller/oauth_controller.go`:
    - เพิ่มฟิลด์ `OccupationCode` และ `Occupation` ใน `MotorRequest`
    - ยกเลิกการ Hardcode `occ_001` และนำค่าจริงที่ผู้ใช้เลือกส่งต่อไปยัง Lead API
    - เพิ่ม Goroutine สั่ง Trigger สร้างเอกสาร พ.ร.บ. สำหรับการซื้อ MC Standalone
  - `helm/helm-uat-isv.yaml`: ปรับค่า `Url_Fontend` ให้ถูกต้อง
- **Commits**: `61e2651`, `0aa5bee`, `653182f`

---

### 2.3 `python-fastapi-document-service` (Document & PDF Generation Service)
- **ไฟล์ที่แก้ไข**:
  - `internal/infrastructure/database/query/mc_query.go`:
    - ปรับ `GetPolicyMC`: ให้ `3_e_date` ดึงจาก `Create_date + INTERVAL '7 HOUR'` (วันที่กรอกข้อมูล) เสมอ
  - `internal/infrastructure/database/query/mv_query.go`:
    - ปรับ `GetPolicyMV`: ให้ `ph_effective_startdate` ดึงจาก `ph.Effective_Startdate` (วันที่กรอกข้อมูล) เสมอ
  - `internal/infrastructure/external/jasper_impl.go`:
    - เพิ่มฟังก์ชันแปลง `PolicyType` สำหรับ `2+` -> `2p` และ `3+` -> `3p` ป้องกัน Jasper Receipt Template Error
- **Commits**: `aba3fa4`, `36501e8`

---

### 2.4 `go-echo-uam-service` (User Authentication & Management Service)
- **ไฟล์ที่แก้ไข**:
  - `helper/utils.go`: ปรับปรุงฟังก์ชัน `PasswordChecker` ให้ตรวจสอบเงื่อนไขความซับซ้อนของรหัสผ่าน `Insure@2026` ได้ถูกต้อง
  - `helper/utils_test.go`: เพิ่ม Unit Test สำหรับทดสอบรหัสผ่านทุกกรณี
- **Commit**: `cc9a0f8`

---

### 2.5 `go-echo-lead-policy-service` (Lead & Policy Ingestion Service)
- **ไฟล์ที่แก้ไข**:
  - อัปเดตการ Mapping อาชีพและ Helm Configuration สำหรับ UAT-ISV
- **Commit**: `beb18dc`

---

### 2.6 `java-spring-boot-jasper-report-service` (JasperReports Engine)
- **ไฟล์ที่แก้ไข**:
  - ตรวจสอบความถูกต้องของ Template กรมธรรม์ 2026 (`MV_Policy_1_3_TH_Original_2026.jasper`, `MV_Policy_2p_TH_Original_2026.jasper`, `MV_Policy_3p_TH_Original_2026.jasper`) ให้แสดงค่า `fix_4: "0.00"`
  - อัปเดต `.gitignore` เพื่อความปลอดภัยของ Environment Files
- **Commit**: `de889e8`

---

## 🌿 3. ตารางสรุปสถานะ Git Branch ล่าสุดทุก Repositories

| Repository Path | Git Branch | Latest Commit Hash | Status |
| :--- | :---: | :---: | :---: |
| `/Users/kritsanawathaniyanon/Code/Go/isv-test` | `hotfix/ws1-policy-issue` | `653182f` | ✅ Clean & Tested |
| `/Users/kritsanawathaniyanon/Code/NextJs/nextjs-webapp` | `hotfix/ws1-policy-issue` | `d0286b41` | ✅ Clean & Updated |
| `/Users/kritsanawathaniyanon/Code/Go/python-fastapi-document-service` | `hotfix/ws1-policy-issue` | `36501e8` | ✅ Clean & Tested |
| `/Users/kritsanawathaniyanon/Code/Go/go-echo-uam-service` | `hotfix/ws1-policy-issue` | `cc9a0f8` | ✅ Clean & Tested |
| `/Users/kritsanawathaniyanon/Code/Go/go-echo-lead-policy-service` | `hotfix/ws1-policy-issue` | `beb18dc` | ✅ Clean & Tested |
| `/Users/kritsanawathaniyanon/Code/Go/java-spring-boot-jasper-report-service` | `hotfix/ws1-policy-issue` | `de889e8` | ✅ Clean |

---

## 🚀 4. คำสั่งสำหรับ Deploy บน Kubernetes (`uat-isv`)

กรณีพบปัญหา Helm Ownership บน GitLab Runner สามารถรันคำสั่งแก้ไขได้ดังนี้:

```bash
# 1. เชื่อมต่อ Cluster GKE uat-isv
gcloud container clusters get-credentials gke-uat-isv --project insurverse-uat --location asia-southeast1

# 2. ผูก Helm Ownership Metadata ให้กับ Service และ Deployment
kubectl -n insurverse annotate service backend-isv-test-service meta.helm.sh/release-name=backend-isv-test-service meta.helm.sh/release-namespace=insurverse --overwrite
kubectl -n insurverse label service backend-isv-test-service app.kubernetes.io/managed-by=Helm --overwrite

kubectl -n insurverse annotate deployment backend-isv-test-service meta.helm.sh/release-name=backend-isv-test-service meta.helm.sh/release-namespace=insurverse --overwrite 2>/dev/null || true
kubectl -n insurverse label deployment backend-isv-test-service app.kubernetes.io/managed-by=Helm --overwrite 2>/dev/null || true
```
