# 🧪 แผนการทดสอบระบบ พ.ร.บ. คปภ. ฉบับสมบูรณ์ (OIC Master Test Plan)

> **เอกสารแผนการทดสอบระบบส่งข้อมูล พ.ร.บ. เรียลไทม์ (OIC / CMI Realtime)**  
> **สภาพแวดล้อมทดสอบ:** UAT-ISV (`136.85.102.224`) / UAT  
> **ข้อมูลผู้เอาประกันภัยทดสอบมาตรฐาน (ตามกฎข้อ 4 - Rule 4):**  
> * **Citizen ID:** `1111111111119`  
> * **ชื่อ-นามสกุล:** นาย กฤษณะ วัฒนายนนต์ (Mr. Kritsana Watthaniyanon)  
> * **อีเมล:** `kritsana.w.os@horixon-t8.com` | **เบอร์โทร:** `0628696603`  
> * **ที่อยู่:** `1 หมู่ 1` ต.ปากเพรียว อ.เมือง จ.สระบุรี `18110` (`provinceId: 10`, `districtId: 124`, `subdistrictId: 979`)  

---

## 📑 สารบัญหมวดการทดสอบ (Test Scope Overview)

| หมวดที่ | ขอบเขตการทดสอบ | จำนวนเคส | วัตถุประสงค์ |
| :---: | :--- | :---: | :--- |
| **หมวด 1** | **Data Sanitization & Boundary Constraints** | 7 เคส (TC-01 ถึง TC-07) | ตรวจสอบการคุมขนาดตัวอักษร, UTF-8 Multi-byte และ Fallback |
| **หมวด 2** | **Partner Routing & Business Logic** | 4 เคส (TC-08 ถึง TC-11) | ตรวจสอบใบอนุญาตนายหน้า (TQM / Direct) และเงื่อนไขสลักหลัง |
| **หมวด 3** | **Premium Calculation & Statutory Rates** | 2 เคส (TC-12 ถึง TC-13) | ตรวจสอบความถูกต้องของเบี้ยและภาษีตามประกาศ คปภ. |
| **หมวด 4** | **End-to-End Issuance & Concurrency Stress** | 3 เคส (TC-14 ถึง TC-16) | ออกเลขกรมธรรม์ MC และทดสอบ Concurrency 20-100 VUs |
| **หมวด 5** | **Failover, Replica Lag & Error Handling** | 2 เคส (TC-17 ถึง TC-18) | ตรวจสอบ Retry Backoff และการบันทึก Log เมื่อถูก Reject |

---

## 🔬 รายละเอียด Test Cases ทั้ง 18 เคส

### หมวดที่ 1: การตรวจสอบขนาดข้อมูลและ Sanitization (Data Sanitization)

#### 🔹 TC-01: ตรวจสอบเลขประจำตัวผู้เอาประกันภัย (Citizen ID / Insured Unique ID)
* **รหัสทดสอบ:** `OIC-DS-01`
* **ระบบที่ทดสอบ:** `nextjs-webapp` ➔ `actAPI` ➔ `go-echo-uam-service`
* **ข้อมูลนำเข้า (Input):** Citizen ID `1111111111119` (มี space หน้า/หลัง หรือเว้นวรรค)
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ฝั่ง Go ทำ `TrimSpace()` และจำกัดความยาวไม่เกิน 20 Runes
  * ใน JSON Request ส่งไป คปภ. ค่า `insuredUniqueID` ต้องเป็น `"1111111111119"` พอดี
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-02: ตรวจสอบป้ายทะเบียนรถยนต์ (Plate Number & Thai Regex)
* **รหัสทดสอบ:** `OIC-DS-02`
* **ระบบที่ทดสอบ:** `nextjs-webapp` ➔ `go-echo-uam-service` / `go-fiber-policy-service`
* **ข้อมูลนำเข้า (Input):**
  1. ทะเบียนมาตรฐาน: `1กข1234`
  2. ทะเบียนยาวพิเศษ: มีเว้นวรรค หรือความยาวเกิน 20 Runes
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ตัดช่องว่างและจำกัดความยาวสูงสุด 20 Runes (ไม่ตัดครึ่งตัวอักษรภาษาไทย)
  * ฟิลด์ `plateNumber` ใน JSON ตรงตามรูปแบบที่ คปภ. กำหนด
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-03: ตรวจสอบชื่อและนามสกุลผู้เอาประกัน (Insured Name & Surname 120 Runes)
* **รหัสทดสอบ:** `OIC-DS-03`
* **ระบบที่ทดสอบ:** `controllers/cmiRealtimeController.go` / `cmi_realtime.go`
* **ข้อมูลนำเข้า (Input):**
  * ชื่อ: `กฤษณะ` + ตัวอักษรไทยความยาวเกิน 120 ตัวอักษร
  * นามสกุล: `วัฒนายนนต์` + ตัวอักษรไทยความยาวเกิน 120 ตัวอักษร
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ใช้ `[]rune` ตัดความยาวที่ 120 ตัวอักษรพอดี
  * สระบน/ล่าง และวรรณยุกต์ตัวสุดท้ายไม่ขาด (ไม่มีอักขระขยะ ``)
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-04: ตรวจสอบหมายเลขตัวถังรถยนต์ (Chassis VIN Number 50 Chars)
* **รหัสทดสอบ:** `OIC-DS-04`
* **ข้อมูลนำเข้า (Input):** VIN Number ความยาว 60 ตัวอักษร
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ตัดเหลือไม่เกิน 50 ตัวอักษรพอดี
  * ฟิลด์ `chassisVINNumber` ใน payload ส่งไป คปภ. ไม่ Error Overflow
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-05: ตรวจสอบยี่ห้อและรุ่นรถยนต์ Fallback (Brand & Model Fallback `99999`)
* **รหัสทดสอบ:** `OIC-DS-05`
* **ข้อมูลนำเข้า (Input):** ข้อมูลรถที่ไม่มีในตาราง `mas_cmi_brand_model` (Brand = NULL, Model = NULL)
* **เกณฑ์การตรวจสอบ (Expectation):**
  * `vehicleBrand` ต้องได้ค่า `"99999"` (จาก Go Constant)
  * `vehicleModel` ต้องได้ค่า `"99999"` (จาก Go Constant)
  * ความยาว `vehicleModel` ต้องไม่เกิน 65 Runes
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-06: ตรวจสอบรหัสสีรถยนต์ Fallback (Vehicle Color Coalescence)
* **รหัสทดสอบ:** `OIC-DS-06`
* **ข้อมูลนำเข้า (Input):**
  1. เคสระบุสีตรงใน Master `mas_cmi_color` ➔ ได้ `color_id`
  2. เคสสีไม่ตรงใน Master ➔ Fallback เป็นค่าที่กรอกใน `Car_color`
  3. เคสไม่ระบุสีเลย ➔ ส่งเป็นค่าว่าง `""` ไม่ส่ง `NULL`
* **เกณฑ์การตรวจสอบ (Expectation):**
  * `vehicleColor` ความยาวไม่เกิน 65 Runes และไม่ Error
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-07: ตรวจสอบรหัสจังหวัดจดทะเบียน (Registered Province Code)
* **รหัสทดสอบ:** `OIC-DS-07`
* **ข้อมูลนำเข้า (Input):** `Car_license_provice` เป็น `"10"` หรือชื่อจังหวัด
* **เกณฑ์การตรวจสอบ (Expectation):**
  * Join กับ `mas_cmi_province` ด้วย Join Guard ป้องกัน Type Cast Crash
  * ได้รหัสจังหวัด 2 หลัก (เช่น `"10"`)
* **สถานะเป้าหมาย:** PASS ✅

---

### หมวดที่ 2: การตรวจสอบเงื่อนไขคู่ค้าและสลักหลัง (Partner Routing & Endorsement)

#### 🔹 TC-08: ตรวจสอบคู่ค้า TQM (TQM Broker License Resolution)
* **รหัสทดสอบ:** `OIC-PR-08`
* **เงื่อนไข (Pre-condition):** กรมธรรม์มี `partner_code = 'TQM'`
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ฟิลด์ `agentBrokerLicenseNumber` ใน JSON Request ต้องเป็น **`"ว00019/2546"`**
  * ฟิลด์ `partnerCode` **ต้องไม่ปรากฏใน JSON Payload** (ป้องกัน Data Leakage ด้วย `json:"-"`)
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-09: ตรวจสอบกรมธรรม์ช่องทางตรง (Direct Channel Company Code)
* **รหัสทดสอบ:** `OIC-PR-09`
* **เงื่อนไข (Pre-condition):** กรมธรรม์ช่องทางตรงของ Insurverse (`partner_code = NULL` หรือ `""`)
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ฟิลด์ `agentBrokerLicenseNumber` ได้ค่า **`"2046"`** (หรือ regist_id ของ Insurverse)
  * ฟิลด์ `companyCode` ได้ค่า **`"2046"`**
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-10: ตรวจสอบความถูกต้องของวันที่ (Contract Date vs Effective Date)
* **รหัสทดสอบ:** `OIC-PR-10`
* **เงื่อนไข (Pre-condition):** วันที่ทำสัญญามากกว่าวันเริ่มคุ้มครอง (`contractDt > effectiveDt`)
* **เกณฑ์การตรวจสอบ (Expectation):**
  * Go Code ปรับ `contractDt = effectiveDt` อัตโนมัติ ป้องกัน คปภ. Reject
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-11: ตรวจสอบฟิลด์สลักหลังเมื่อออกกรมธรรม์ใหม่ (New Policy Endorsement Guard)
* **รหัสทดสอบ:** `OIC-PR-11`
* **เงื่อนไข (Pre-condition):** กรมธรรม์ออกใหม่ (`referenceNumber` ว่าง)
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ฟิลด์ `ReferenceNumber`, `ReceiveNumber`, `EndorseFlag`, `EndorseRefNumber`, `EndorseEffectiveDt` ถูกตั้งเป็น `nil`
  * JSON Request ไม่ส่งฟิลด์สลักหลังออกไปรบกวน คปภ.
* **สถานะเป้าหมาย:** PASS ✅

---

### หมวดที่ 3: การคำนวณเบี้ยประกันภัย พ.ร.บ. (Premium Rates)

#### 🔹 TC-12: ตรวจสอบเบี้ยรถยนต์นั่งส่วนบุคคล 1.10 (Sedan Rate Verification)
* **รหัสทดสอบ:** `OIC-PRM-12`
* **ประเภทรถ:** รถเก๋งส่วนบุคคลไม่เกิน 7 ที่นั่ง (รหัส 1.10)
* **เกณฑ์การตรวจสอบ (Expectation):**
  * เบี้ยสุทธิ (Net Premium): **464.40 บาท**
  * อากรแสตมป์ + ภาษี (Vat & Stamp): **34.65 บาท**
  * เบี้ยรวมทั้งสิ้น (Total Gross): **499.05 บาท**
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-13: ตรวจสอบเบี้ยรถกระบะบรรทุก 3.20 (Pickup Rate Verification)
* **รหัสทดสอบ:** `OIC-PRM-13`
* **ประเภทรถ:** รถกระบะบรรทุกน้ำหนักไม่เกิน 3 ตัน (รหัส 3.20)
* **เกณฑ์การตรวจสอบ (Expectation):**
  * คำนวณเบี้ยสุทธิและภาษีอากรถูกต้องตรงตามตารางพิกัด คปภ.
* **สถานะเป้าหมาย:** PASS ✅

---

### หมวดที่ 4: การออกกรมธรรม์และการทดสอบ Concurrency (Issuance & Load Test)

#### 🔹 TC-14: ทดสอบการออกเลขกรมธรรม์ พ.ร.บ. หมวด MC (End-to-End Issuance)
* **รหัสทดสอบ:** `OIC-E2E-14`
* **ขั้นตอน:** สร้าง Lead ➔ ชำระเงินจำลอง ➔ เรียก `fn_lead_to_car_act`
* **เกณฑ์การตรวจสอบ (Expectation):**
  * สร้าง Record ใน `Policy_Car_Act_Discount_Premium` สำเร็จ
  * ได้เลขกรมธรรม์รูปแบบ `MC-0026-I-XXXXXX`
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-15: ทดสอบการส่งข้อมูลเรียลไทม์ไป คปภ. (CMI Realtime Transmission)
* **รหัสทดสอบ:** `OIC-E2E-15`
* **ขั้นตอน:** ตรวจสอบตาราง `insurverse.log_cmi_realtime` หลังออกกรมธรรม์
* **เกณฑ์การตรวจสอบ (Expectation):**
  * บันทึก Request Header, Request Body, Response Status และ Response Body ครบถ้วน
  * `response_status = 200` และได้ `ReferenceNumber`, `ReceiveNumber` กลับมาบันทึกลงกรมธรรม์
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-16: ทดสอบการยิงพร้อมกันระดับสูง (High-Concurrency Load Test 20-100 VUs)
* **รหัสทดสอบ:** `OIC-LOAD-16`
* **ขั้นตอน:** รันสคริปต์ยิงออกเลขกรมธรรม์พร้อมกัน 20, 50, 100 เธรดพร้อมกันในเสี้ยววินาที
* **เกณฑ์การตรวจสอบ (Expectation):**
  * อัตราความสำเร็จ **100% (Zero Failure)**
  * ไม่มี Error `duplicate key value violates unique constraint "MC_NO"`
  * `pg_advisory_xact_lock(hashtext('fn_lead_to_car_act'))` ทำงานถูกต้อง
* **สถานะเป้าหมาย:** PASS ✅

---

### หมวดที่ 5: การรองรับ Failover, Replica Lag & Logging (Resilience)

#### 🔹 TC-17: ทดสอบกลไก Retry Backoff เมื่อเกิด Replica Lag
* **รหัสทดสอบ:** `OIC-RES-17`
* **ขั้นตอน:** จำลองสถานการณ์อ่านข้อมูลจาก Replica ทันทีหลัง Write แล้วเจอ `sql.ErrNoRows`
* **เกณฑ์การตรวจสอบ (Expectation):**
  * ฟังก์ชัน `retryOnNoRows` ใน Go รัน Exponential Backoff (1s, 2s, 4s ครอบคลุม ~7s)
  * อ่านข้อมูลได้สำเร็จโดยไม่ต้อง Manual re-trigger
* **สถานะเป้าหมาย:** PASS ✅

#### 🔹 TC-18: ทดสอบการจัดการกรณี คปภ. Reject หรือ Timeout
* **รหัสทดสอบ:** `OIC-RES-18`
* **ขั้นตอน:** ทดสอบยิงเคสที่ข้อมูลไม่ถูกต้องเข้า CMI Sandbox
* **เกณฑ์การตรวจสอบ (Expectation):**
  * บันทึก Remark และ Error Code ลงใน `log_cmi_realtime` อย่างชัดเจน
  * ไม่เขียนทับเลขอ้างอิงเดิมของกรมธรรม์ที่มีอยู่แล้ว
* **สถานะเป้าหมาย:** PASS ✅

---

## 📊 สรุป Matrix การทดสอบ

```
[หมวด 1: Sanitization] ───► TC-01 ถึง TC-07 (7 Cases) ──► UTF-8 Safe, []rune
[หมวด 2: Partner/Rules] ──► TC-08 ถึง TC-11 (4 Cases) ──► TQM License, json:"-"
[หมวด 3: Premium Rates] ──► TC-12 ถึง TC-13 (2 Cases) ──► 499.05 THB Accuracy
[หมวด 4: Concurrency]   ──► TC-14 ถึง TC-16 (3 Cases) ──► Advisory Lock, 100 VUs
[หมวด 5: Resilience]    ──► TC-17 ถึง TC-18 (2 Cases) ──► Retry Backoff Lag
                                 ───────────────────────
                                 รวมทั้งสิ้น: 18 Test Cases
```
