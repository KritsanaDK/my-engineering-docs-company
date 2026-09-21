# 📋 คู่มือและแบบฟอร์มการทดสอบสำหรับ QA/Tester: WS6 - WS9
# QA/Tester Test Specification & Execution Checklist (WS6 - WS9)

> **เป้าหมาย:** ใช้เป็นเอกสารคู่มือสำหรับ QA / Tester ในการทดสอบและบันทึกผล (Sign-off) ระบบหลังบ้าน WS6–WS9 บนสภาพแวดล้อม **UAT-ISV**  
> **สภาพแวดล้อม (Environment):**  
> * **Web / Backoffice Portal:** `https://insurverse-uat-isv-app.insurverse.co.th`  
> * **API Base URL:** `https://insurverse-uat-isv-api.insurverse.co.th`  
> * **Database Host:** `136.85.102.224:5432` (DB: `insurverse`)  
>  
> **ข้อมูลทดสอบมาตรฐาน (Mandatory Test Data - Rule 4):**  
> * **Citizen ID (เลขบัตรประชาชน):** `1111111111119`  
> * **ชื่อ-นามสกุล:** นาย กฤษณะ วัฒนายนนต์ (Mr. Kritsana Watthaniyanon)  
> * **เบอร์โทรศัพท์:** `0628696603`  
> * **อีเมล:** `kritsana.w.os@horixon-t8.com`  
> * **ที่อยู่:** `1 หมู่ 1` ต.ปากเพรียว อ.เมือง จ.สระบุรี `18110` (`provinceId: 10`, `districtId: 124`, `subdistrictId: 979`)  

---

## 📊 1. ตารางสรุปผลการทดสอบ (QA Test Execution Sign-off Matrix)

| รหัสเคส (ID) | หมวดงาน | หัวข้อการทดสอบ (Test Scenario) | วิธีการทดสอบ | ผลลัพธ์ (Result) | Tester Sign-off | หมายเหตุ |
| :---: | :---: | :--- | :---: | :---: | :---: | :--- |
| **TC-WS6-01** | WS6 | ตรวจสอบ Schema คอลัมน์ `no_cancel_flag` | DB Query | [ ] PASS  [ ] FAIL | | ไม่พบ error column not found |
| **TC-WS6-02** | WS6 | Timezone สลักหลังปรับเป็นเวลาไทย (+7 ชม.) | API / DB | [ ] PASS  [ ] FAIL | | เวลาตรงกับ GMT+7 ไม่เป็น UTC |
| **TC-WS6-03** | WS6 | ตรวจสอบ `prem_version` สืบทอดไม่เป็น NULL | API / DB | [ ] PASS  [ ] FAIL | | มีเวอร์ชันเบี้ยผูกถูกต้อง |
| **TC-WS6-04** | WS6 | แมปเบอร์โทรและข้อมูลผู้ซื้อส่งขึ้น Salesforce | UI / API | [ ] PASS  [ ] FAIL | | เบอร์ผู้ซื้อขึ้นใน Contact SF |
| **TC-WS6-05** | WS6 | Concurrency Load Test ตรวจสอบสลักหลัง (50 VUs) | Script / Tool | [ ] PASS  [ ] FAIL | | ไม่มี Deadlock หรือ Timeout |
| **TC-WS7-01** | WS7 | บล็อกการต่ออายุล่วงหน้าเกิน 90 วัน (`ER007`) | UI / API | [ ] PASS  [ ] FAIL | | แสดงข้อความเตือนไม่อยู่ในรอบ |
| **TC-WS7-02** | WS7 | อนุญาตต่ออายุเมื่อเหลือวันคุ้มครอง <= 90 วัน | UI / API | [ ] PASS  [ ] FAIL | | เข้าสู่หน้าคำนวณเบี้ยต่ออายุได้ |
| **TC-WS7-03** | WS7 | คัดลอกข้อมูลผู้ขับขี่ 1–5 เข้า Lead ต่ออายุ | UI / API | [ ] PASS  [ ] FAIL | | ผู้ขับขี่ 1-5 มาครบอัตโนมัติ |
| **TC-WS7-04** | WS7 | ล็อกอาชีพผู้เอาประกันเป็น Read-Only ในงานต่ออายุ | Web Portal | [ ] PASS  [ ] FAIL | | แก้ไขช่องอาชีพไม่ได้ |
| **TC-WS7-05** | WS7 | Concurrency Load Test ฟังก์ชันต่ออายุ (50 VUs) | Script / Tool | [ ] PASS  [ ] FAIL | | ผ่าน 100% เบี้ยคำนวณแม่นยำ |
| **TC-WS8-01** | WS8 | ตรวจสอบการเชื่อมต่อตาราง `insurverse.promo_code` | DB Query | [ ] PASS  [ ] FAIL | | พบคลังโค้ดส่วนลด 10,000+ รายการ |
| **TC-WS8-02** | WS8 | Export รายงานโค้ดส่วนลดป้องกัน NULL Pointer | Backoffice UI | [ ] PASS  [ ] FAIL | | กด Export CSV/Excel ได้ปกติ |
| **TC-WS8-03** | WS8 | กรองกรมธรรม์หมดอายุออกจากหน้ารายการ Active | Backoffice UI | [ ] PASS  [ ] FAIL | | ไม่แสดงกรมธรรม์ Expired ใน Active |
| **TC-WS9-01** | WS9 | ตรวจสอบ Headers อีเมลป้องกันตก Junk (`Reply-To`) | Email Client | [ ] PASS  [ ] FAIL | | พบ Header ครบตามมาตรฐาน RFC |
| **TC-WS9-02** | WS9 | เรียกดู Reconcile Report ผ่าน REST API | API / Postman | [ ] PASS  [ ] FAIL | | ตอบกลับ HTTP 200 JSON ครบถ้วน |
| **TC-WS9-03** | WS9 | Concurrency Load Test รายงาน Reconcile (100 VUs) | Script / Tool | [ ] PASS  [ ] FAIL | | 100 Concurrent สำเร็จ < 350ms |

---

## 🔬 2. รายละเอียดขั้นตอนการทดสอบทีละเคส (Step-by-Step Test Cases)

### 🔹 กลุ่มที่ 1: Workstream 6 (Salesforce & Endorsement)

#### 📝 TC-WS6-01: ตรวจสอบ Schema คอลัมน์ `no_cancel_flag`
* **วัตถุประสงค์:** รองรับการยกเลิกสลักหลังโดยไม่ทำให้ฟังก์ชันบันทึกข้อมูลล้มเหลว
* **ขั้นตอนการทดสอบ (DB Check):**
  1. เปิด DBeaver หรือ Cloud SQL Studio เชื่อมต่อ Database UAT-ISV
  2. รันคำสั่ง:
     ```sql
     SELECT column_name, data_type, column_default 
     FROM information_schema.columns 
     WHERE table_name = 'Policy_Header' AND column_name = 'no_cancel_flag';
     ```
* **สิ่งที่คาดหวัง:** พบคอลัมน์ `no_cancel_flag` ชนิด `character varying(1)` ค่า Default `'N'`

#### 📝 TC-WS6-02: ตรวจสอบการแสดงผลเวลาสลักหลังตามเวลาไทย (Timezone Asia/Bangkok)
* **วัตถุประสงค์:** แก้ปัญหาเวลาสลักหลังในระบบแสดงช้ากว่าเวลาจริง 7 ชั่วโมง
* **ขั้นตอนการทดสอบ:**
  1. ยิงทดสอบฟังก์ชัน Database หรือตรวจสอบหน้าใบสลักหลัง:
     ```sql
     SELECT insurverse.fn_format_utc_timestamp_th('2026-09-15 03:30:00+00'::timestamptz) AS result;
     ```
* **สิ่งที่คาดหวัง:** ผลลัพธ์ต้องได้ `'2026-09-15 10:30:00'` (เวลาเพิ่มขึ้น 7 ชั่วโมงพอดี)

#### 📝 TC-WS6-04: ตรวจสอบข้อมูลผู้ซื้อและเบอร์โทรศัพท์ส่งขึ้น Salesforce
* **วัตถุประสงค์:** ผู้ซื้อที่ต่ออายุหรือทำสลักหลังต้องมีเบอร์โทรศัพท์ปรากฏใน Salesforce
* **ขั้นตอนการทดสอบ (Web/API):**
  1. ทำรายการสลักหลังหรือต่ออายุโดยใช้เบอร์ `0628696603`
  2. ตรวจสอบข้อมูลใน Salesforce Object `Account` / `Contact` หรือตาราง `salesforce_sync_log`
* **สิ่งที่คาดหวัง:** ฟิลด์เบอร์โทรศัพท์ไม่ว่างเปล่า (`COALESCE` ดึงเบอร์ผู้ซื้อมาใส่ให้อัตโนมัติ)

---

### 🔹 กลุ่มที่ 2: Workstream 7 (Policy Renewal Guardrails)

#### 📝 TC-WS7-01: บล็อกการต่ออายุล่วงหน้าเกิน 90 วัน (`ER007`)
* **วัตถุประสงค์:** ป้องกันไม่ให้ลูกค้าต่ออายุกรมธรรม์ก่อนถึงกำหนดเวลาที่ คปภ. และบริษัทอนุญาต
* **ขั้นตอนการทดสอบ (Web UI & API):**
  1. กรอกเลขกรมธรรม์หรือทะเบียนที่ยังมีอายุเหลืออยู่ **มากกว่า 90 วัน** (เช่น หมดอายุอีก 120 วันข้างหน้า)
  2. เลขประจำตัวประชาชนผู้เอาประกัน: `1111111111119`
  3. กดปุ่ม "ตรวจสอบการต่ออายุ" หรือยิง API `POST /api/v1/purchase/renewal/check`
* **สิ่งที่คาดหวัง:** 
  * หน้าจอแสดง Alert แจ้งเตือน: *"ยังไม่ถึงช่วงเวลาต่ออายุ กรมธรรม์ของท่านยังมีความคุ้มครองเหลืออยู่"*
  * API คืนค่ารหัส Error: `ER007` หรือ `ERR_NOT_IN_RENEW_PERIOD` (HTTP 400)

#### 📝 TC-WS7-02 & TC-WS7-03: ต่ออายุช่วง <= 90 วัน และคัดลอกรายชื่อผู้ขับขี่ 1–5
* **วัตถุประสงค์:** ลูกค้าในระยะ 90 วันต้องต่ออายุได้ และข้อมูลผู้ขับขี่ต้องถูกดึงมาให้โดยไม่ต้องกรอกใหม่
* **ขั้นตอนการทดสอบ:**
  1. ใช้กรมธรรม์ที่เหลือวันคุ้มครอง **น้อยกว่าหรือเท่ากับ 90 วัน**
  2. กรอก Citizen ID `1111111111119` แล้วกดเข้าสู่ขั้นตอนต่ออายุ
  3. ตรวจสอบในหน้าจอแสดงข้อมูลผู้ขับขี่ (Driver Information)
* **สิ่งที่คาดหวัง:**
  * สามารถเข้าสู่หน้าสรุปเบี้ยต่ออายุได้สำเร็จ
  * รายชื่อผู้ขับขี่คนที่ 1 ถึง 5 ที่เคยระบุไว้ในกรมธรรม์ฉบับเดิม ถูกคัดลอกมาแสดงผลครบถ้วน

#### 📝 TC-WS7-04: ตรวจสอบการล็อกฟิลด์อาชีพ (Occupation Read-Only)
* **ขั้นตอนการทดสอบ:**
  1. ในหน้าจอตรวจสอบข้อมูลผู้เอาประกันภัยของงานต่ออายุ
  2. ทดลองคลิกเพื่อแก้ไขช่อง "อาชีพ" (Occupation)
* **สิ่งที่คาดหวัง:** ฟิลด์อาชีพต้องเป็นสีเทา / Disabled / Read-Only ไม่สามารถพิมพ์หรือเปลี่ยนค่าได้

---

### 🔹 กลุ่มที่ 3: Workstream 8 (Backoffice Promotion & Expiration Filter)

#### 📝 TC-WS8-02: Export ข้อมูล Promo Code ป้องกัน Crash
* **วัตถุประสงค์:** Backoffice สามารถ Export รายการโค้ดส่วนลดได้ ไม่เกิด Error 500
* **ขั้นตอนการทดสอบ (Backoffice Portal):**
  1. ล็อกอินเข้าสู่ Backoffice Portal UAT-ISV
  2. ไปที่เมนู **Promotion Management** ➔ **Promo Code List**
  3. กดปุ่ม **"Export to Excel"** หรือ **"Export to CSV"**
* **สิ่งที่คาดหวัง:** 
  * ดาวน์โหลดไฟล์สำเร็จ ไม่ขึ้นหน้าจอ Error 500
  * คอลัมน์ "สร้างโดย" (Created By) ที่เคยมีค่าว่าง จะแสดงค่า Default (เช่น `SYSTEM` หรือชื่อผู้สร้าง) ไม่ทำให้โปรแกรมแครช

#### 📝 TC-WS8-03: กรองกรมธรรม์หมดอายุออกจากรายการ Active Policies
* **ขั้นตอนการทดสอบ:**
  1. ไปที่เมนู **Policy Management** ➔ แท็บ **Active Policies**
  2. ตรวจสอบกรมธรรม์ที่หมดอายุไปแล้ว (Policy End Date < ปัจจุบัน)
* **สิ่งที่คาดหวัง:** กรมธรรม์ที่หมดอายุจะไม่ปรากฏในแท็บ Active โดยจะย้ายไปอยู่ในแท็บ "Expired" หรือ "ประวัติกรมธรรม์"

---

### 🔹 กลุ่มที่ 4: Workstream 9 (SMTP & Reconcile Reports)

#### 📝 TC-WS9-01: ตรวจสอบ Email Headers ป้องกันตก Junk
* **ขั้นตอนการทดสอบ:**
  1. สั่งออกกรมธรรม์ทดสอบหรือกด Resend Email จากระบบ
  2. เปิดดู Original / Source ของอีเมลในโปรแกรมรับเมล (Outlook / Gmail)
* **สิ่งที่คาดหวัง:** พบ Headers:
  * `Reply-To: support@insurverse.co.th` (หรืออีเมลบริการลูกค้า)
  * `Message-ID: <...>`
  * `X-Priority: 3`

#### 📝 TC-WS9-02: เรียกดู Reconcile Report ผ่าน API
* **cURL Command:**
```bash
curl -X GET "https://insurverse-uat-isv-api.insurverse.co.th/api/v1/uam/report/reconcile?date=2026-09-15" \
     -H "Accept: application/json"
```
* **สิ่งที่คาดหวัง:** ได้รับ HTTP 200 OK และข้อมูล Array รายการกระทบยอดระหว่างระบบอย่างถูกต้อง

---

## 🛠️ 3. สรุปคำสั่งรันโหลดเทสสำหรับ QA Automation

หาก QA ต้องการรัน Concurrency Load Test เพื่อพิสูจน์ความทนทานของระบบ สามารถสั่งรันจาก Terminal:
```bash
# 1. ทดสอบ API Reconcile Report 50 ผู้ใช้งานพร้อมกัน
cd /Users/kritsanawathaniyanon/Code/Go/deploy_jobs
go run ./02_ws6_9/scripts/test_load -concurrency=50 -endpoint=reconcile

# 2. ทดสอบ Connectivity Probe 50 ผู้ใช้งานพร้อมกัน
go run ./02_ws6_9/scripts/test_load -concurrency=50 -endpoint=health

# 3. ตรวจสอบสถานะ DB Schema & Stored Procedures
go run ./02_ws6_9/scripts/manage_db -action=verify
```
