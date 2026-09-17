# Technical Analysis: ข้อขัดแย้งและจุดผิดพลาดใน Salesforce Integration Spec V4.0
# Technical Analysis: Inconsistencies and Conflicts in Salesforce Integration Spec V4.0

> **เอกสารอ้างอิงต้นฉบับ:** `Technical Doc_ InsurVerse - Integration_Spec_SF V4.0.xlsx`  
> **วันที่จัดทำ:** 17 กันยายน 2026 (2026-09-17)  
> **ผู้จัดทำ:** AI Pair Programmer (Antigravity) ร่วมกับ Kritsana Watthaniyanon  
> **สถานะ:** Active Architecture & Troubleshooting Reference  
> **ระบบที่เกี่ยวข้อง:** `go-echo-saleforce-service`, `go-echo-uam-service`, `go-echo-purchase-service`, Salesforce (SFDC)

---

## 📌 1. วัตถุประสงค์ (Executive Objective)
เอกสารฉบับนี้จัดทำขึ้นเพื่อบันทึก **ข้อขัดแย้งเชิงโครงสร้าง (Architectural Conflicts)**, **จุดซ้ำซ้อนของ Endpoint (Duplicate Endpoint Overlaps)**, **ความไม่สอดคล้องของ Casing (Naming Inconsistencies)**, และ **กับดักเชิงตรรกะ (Logic Traps)** ที่ปรากฏอยู่ในเอกสาร **Salesforce Integration Spec V4.0 (จำนวน 72 Sheets)** เพื่อใช้เป็นคู่มืออ้างอิงหลักสำหรับทีมวิศวกรรมในการป้องกันและแก้ไข Bug ในระบบจริงได้อย่างถูกต้อง

---

## 🔍 2. สรุป 5 ข้อขัดแย้งหลักใน Spec V4.0 (The 5 Major Conflicts)

### ⚠️ Conflict 1: Versioning & Overlapping Endpoints (URL เดียวกันแต่ Spec สองเวอร์ชัน)

#### 📍 ปัญหาที่พบ:
ในเอกสารมีหลาย Sheet ที่กำหนดให้ยิงไปยัง **Endpoint URL เดียวกันของ Backend** แต่โครงสร้าง Request Body และชื่อฟิลด์แตกต่างกันอย่างสิ้นเชิง โดยไม่มีการแยก Path Versioning (`/v1/`, `/v2/`):

#### 1.1 `R1 Microservice-PolicyTransacti` vs `R2.5 Microservice-PolicyTransac`
* **Endpoint URL เดียวกัน:** `POST /api/v1/sf/saleforceControllerAPI`
* **ตารางเปรียบเทียบฟิลด์:**

| ฟิลด์ (Field Name) | Sheet: R1 PolicyTransacti | Sheet: R2.5 PolicyTransac | ผลกระทบหากส่งคนละเวอร์ชัน |
| :--- | :---: | :---: | :--- |
| `fn` | มี (Text) | มี (Text) | ผ่าน |
| `insurancePolicyId` | มี (Text) | มี (Text) | ผ่าน |
| `salesforceID` | **ไม่มี ❌** | **มี ✅ (Id)** | R1 จะไม่รู้ SF Record ID |
| `ownerCardId` | **ไม่มี ❌** | **มี ✅ (ID Card)** | ข้อมูลเลขบัตร ปชช หลุดหายใน R1 |
| `ownerTel` | **ไม่มี ❌** | **มี ✅ (Tel)** | ข้อมูลเบอร์โทรหลุดหายใน R1 |
| `ownerEmail` | **ไม่มี ❌** | **มี ✅ (Email)** | ข้อมูลอีเมลหลุดหายใน R1 |
| `carLicenseNo` | **มี ✅** | **ไม่มี ❌** | R2.5 ทำเลขทะเบียนรถหลุดหาย |
| `carLicenseProvice`| **มี ✅** | **ไม่มี ❌** | R2.5 ทำจังหวัดทะเบียนรถหลุดหาย |

* **ผลกระทบจริงในระบบ:** หาก Backend ของ InsurVerse Bind Struct ตาม R1 ตอนที่ Salesforce ยิง R2.5 เข้ามา ฟิลด์ `ownerCardId` และ `ownerTel` จะถูก Drop ทิ้ง กลายเป็น `""` (Empty string) นำไปสู่ปัญหาข้อมูลลูกค้าไม่สมบูรณ์
* **กรณีอื่นที่ซ้อนทับกัน:**
  * `SF-Claim ReserveAdjust` vs `SF-Claim ReserveAdjust (Revise)`
  * `SF-PolicyAttachment` (Base64 Binary) vs `SF-PolicyAttachment (URL)` (GCP Cloud Storage URL) vs `SF - Claim Attachment (Back Up)`
  * `Microservice-Notification (Old)` vs `Microservice-Noti (Email)` / `(SMS)` / `(App)`

---

### ⚠️ Conflict 2: Response Key Casing Inconsistency (ตัวพิมพ์ใหญ่-เล็กไม่ตรงกัน)

#### 📍 ปัญหาที่พบ:
โครงสร้าง Response ระหว่างสถานะ **สำเร็จ (Success)** และ **ล้มเหลว (Error)** ใช้ตัวพิมพ์ใหญ่-เล็ก (CamelCase vs Lowercase) ไม่ตรงกันในหลาย Sheet:

#### ตัวอย่างใน Sheet `SF-Lead`:
* **Success Payload:**
  ```json
  {
    "statuscode": "0000",
    "message": "Success",
    "timestamp": "2022-01-28T11:24:53",
    "leadID": "00Q4x00000OQsDrEAL"
  }
  ```
  *(สังเกต: `timestamp` เป็นตัวพิมพ์เล็กทั้งหมด, `leadID` ใช้ ID ตัวพิมพ์ใหญ่)*

* **Error Payload:**
  ```json
  {
    "statuscode": "2000",
    "message": "Cannot insert LeadUpsert failed...",
    "timeStamp": "2024-01-10T04:12:45",
    "leadId": null
  }
  ```
  *(สังเกต: `timeStamp` มี S ตัวใหญ่, `leadId` ใช้ d ตัวเล็ก)*

* **ผลกระทบต่อภาษา Go (Go JSON Unmarshaling):**
  ใน Go Struct หากประกาศ Tag:
  ```go
  type LeadResponse struct {
      StatusCode string `json:"statuscode"`
      Message    string `json:"message"`
      Timestamp  string `json:"timestamp"` // ❌ ถ้า Error เข้ามาเป็น timeStamp จะ Unmarshal ไม่เข้า!
      LeadID     string `json:"leadID"`    // ❌ ถ้า Error เข้ามาเป็น leadId จะ Unmarshal ไม่เข้า!
  }
  ```
  ทำให้การดึงค่า `Timestamp` หรือ `LeadID` ตอน Error ได้ค่าว่างและไม่สามารถวิเคราะห์ Log ได้

---

### ⚠️ Conflict 3: Semantic Mismatch: "Upsert" vs `DUPLICATES_DETECTED` (ชื่อ Upsert แต่ไส้ในเป็น Insert)

#### 📍 ปัญหาที่พบ:
* ใน Sheet `SF-Lead` กำหนดชื่อ Endpoint ว่า: `/services/apexrest/upsertlead` และบรรยายว่าทำหน้าที่ **"Upsert Lead"**
* แต่ตัวอย่าง Error ใน Spec ระบุว่า:
  ```text
  Cannot insert LeadUpsert failed. First exception on row 0; first error: DUPLICATES_DETECTED, Use one of these records?: []
  ```
* **ความขัดแย้ง:** ในทางสถาปัตยกรรม คำว่า **Upsert** (Update or Insert) จะต้องไม่เกิด Error `DUPLICATES_DETECTED` เมื่อพบ Record เดิม แต่จะต้องนำข้อมูลใหม่ไปเขียนทับ Record เก่าทันที
* **รากเหง้าของปัญหาจริง (Issue #2 ใน KB):** Salesforce ทำการ Insert เสมอเมื่อไม่มี `leadID` ส่งมา และเมื่อ Duplicate Rule ของ Salesforce ตรวจพบเบอร์โทรหรืออีเมลซ้ำ จึงพ่น Exception ขัดขวางทันที ทำให้ Backend พัง

---

### ⚠️ Conflict 4: Parent-Child Dependency Lock (กับดักการเรียงลำดับการสร้าง)

#### 📍 ปัญหาที่พบ:
* ใน Sheet `SF-Policy` (`/services/apexrest/upsertpolicy`):
  * ฟิลด์ `accountID` (Salesforce Account Record ID) ถูกระบุเป็น **Required Field: Y**
  * ฟิลด์ `compulsoryPolicy` (เลขที่ พ.ร.บ.) ถูกระบุเป็น **Required Field: Y**
* **ความขัดแย้งใน Flow ธุรกิจจริง:**
  1. **กรณีซื้อแบบ Guest:** ลูกค้ายังไม่มี `accountID` ในขั้นตอนแรก
  2. **กรณีซื้อประกันภาคสมัครใจเดี่ยวๆ (Standalone Motor MV):** ลูกค้าไม่ได้ซื้อ พ.ร.บ. คู่กัน ทำให้ไม่มีเลข `compulsoryPolicy`
* **รากเหง้าของปัญหาจริง (Issue #3 ใน KB):** หาก Backend ส่งกรมธรรม์ลูก หรือกรมธรรม์ที่ไม่มี Parent เข้า Salesforce ตาม Spec V4.0 ระบบ SF จะปฏิเสธทันทีเพราะหา `accountID` หรือ `compulsoryPolicy` ไม่เจอ

---

### ⚠️ Conflict 5: Bi-directional Synchronization Echo Loops (วงวนการอัปเดตแบบสะท้อนกลับ)

#### 📍 ปัญหาที่พบ:
ระบบมีการส่งข้อมูล 2 ทิศทางขนานกัน:
1. **InsurVerse ➔ Salesforce:** `SF-Policy` (อัปเดตสถานะกรมธรรม์)
2. **Salesforce ➔ InsurVerse:** `Microservice-Update Policy` (`POST /api/v1/policy/update_policy`)
* **ความขัดแย้ง:** ในทั้ง 2 ฝั่ง **ไม่มีฟิลด์ระบุแหล่งกำเนิด (Trigger Source Flag เช่น `source: "SF"` หรือ `source: "IV"`)**
* **ผลกระทบ:** เมื่อ Backend ส่งอัปเดตเข้า SF ➔ SF Trigger ให้ยิง Webhook กลับมา Backend ➔ Backend บันทึกและ Trigger ส่งกลับไป SF วนลูปไม่สิ้นสุด (Ping-Pong Sync Loop) สิ้นเปลือง API Quota ของ Salesforce อย่างรวดเร็ว

---

## 🛠️ 3. แนวทางปฏิบัติการและกฎการเขียนโค้ด (Engineering Guardrails)

เพื่อป้องกันไม่ให้เกิด Bug จากข้อขัดแย้งใน Spec ข้างต้น ทีมวิศวกรรมต้องยึดหลักปฏิบัติดังนี้:

### 1. การรองรับ Casing ในภาษา Go (Defensive Unmarshaling):
ต้องใช้ Custom Unmarshaler หรือ Struct Tag ที่รองรับทั้ง 2 แบบ:
```go
type SFBaseResponse struct {
    StatusCode string `json:"statuscode"`
    Message    string `json:"message"`
    Timestamp  string `json:"timestamp"`
    TimeStamp  string `json:"timeStamp"` // Fallback tag
}

func (r SFBaseResponse) GetTime() string {
    if r.Timestamp != "" {
        return r.Timestamp
    }
    return r.TimeStamp
}
```

### 2. ลำดับการส่งข้อมูลเข้า Salesforce (Strict Order):
```text
[Step 1: Account / Contact] ──► ได้ accountID
      │
      ▼
[Step 2: Compulsory ACT (ถ้ามี)] ──► ได้เลข พ.ร.บ.
      │
      ▼
[Step 3: Voluntary Policy (MV)] ──► ผูก accountID + compulsoryPolicy
      │
      ▼
[Step 4: Endorsement / Attachments] ──► ส่งไฟล์แนบ PDF และรายการลูก
```

### 3. การป้องกัน `DUPLICATES_DETECTED`:
ก่อนเรียก `/services/apexrest/upsertlead` หรือ `/services/apexrest/upsertpolicy`:
* ค้นหา Record เดิมใน Database/Salesforce ก่อน หากมีอยู่แล้วให้แนบ `leadID` หรือ `accountID` ไปด้วยเสมอ เพื่อบังคับให้ Salesforce ทำงานในโหมด Update แทนการ Insert

---
*เอกสารนี้ได้รับการบันทึกเข้าคลัง `Code/docs/architecture/` สำหรับเป็นมาตรฐานการพัฒนาและแก้ Bug ระบบร่วมกับ Salesforce*
