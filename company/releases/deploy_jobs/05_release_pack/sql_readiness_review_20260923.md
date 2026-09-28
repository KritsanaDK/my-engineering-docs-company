# 🔍 SQL Readiness Review for Production — 2026-09-23

> ตรวจแบบอ่านอย่างเดียวบน UAT-ISV (ไม่มีการรัน DDL/DML) เทียบ signature + md5 body ของทุก function กับที่รันจริงบน UAT-ISV, ตรวจคอลัมน์ตาม Rule 6, และตรวจโครงสร้างตาม Rule 5
> Read-only review against UAT-ISV: every function's signature and body md5 vs live, Rule 6 column checks, Rule 5 structure.

## สรุป (Verdict)

| กลุ่ม | ไฟล์ | พร้อมขึ้น Prod? | ต้องรันไหม |
| :--- | :--- | :---: | :--- |
| **Job 04 (#13)** | `04_motor_lead_seq/sql/00→03`, `99_rollback` | ✅ **พร้อม** | ต้องรัน **ก่อน** merge premium `7e03e85` |
| **WS1 / WS5** | `01_oic/sql/ws1_ws5_concurrency_safe_master.sql`, purchase `ws1_database_patches.sql`, purchase+uam `ws5_database_patches.sql` | ⛔ **ไม่พร้อม — ห้ามรัน** | ไม่ต้อง (ขึ้น Prod แล้ว) — ยืนยันด้วย Step 0 |
| **WS6 / WS7** | `02_ws6_9/sql/ws6_ws7_combined_renewal_master.sql`, `ws6_salesforce_endorsement_patches.sql`, `ws7_renewal_guardrails_patches.sql`, uam `ws6_/ws7_database_patches.sql` | ⛔ **ไม่พร้อม — ห้ามรัน** | น่าจะไม่ต้อง — โค้ด WS6–9 บน UAT-ISV ทำงานกับ function เดิมบน DB; ยืนยันด้วย Step 0 |
| **WS9** | `02_ws6_9/sql/ws9_bigquery_english_view.sql` (= analytics `ws9_bigquery_column_migration.sql`) | 🟡 ตรวจจาก Postgres ไม่ได้ | รันใน BigQuery — ต้องตรวจชื่อคอลัมน์ใน BigQuery ก่อน |

**มีไฟล์เดียวที่พร้อม: Job 04**

---

## 1. WS1 / WS5 — ⛔

ไม่มีไฟล์ไหนตรงกับ function ที่รันบน UAT-ISV และ 3 ไฟล์ก็ไม่ตรงกันเอง:

| function | master | purchase ws1 | ws5 patch |
| :--- | :-: | :-: | :-: |
| `fn_lead_to_car_act(bigint)` | 91% (22 บรรทัดต่าง) | 89% (29) | – |
| `fn_policy_to_car_act(text)` | **32% (318)** | **40% (185)** | – |
| `fn_policy_invoiceno_iia()` | 72% (41) | – | **7% (81)** |
| `fn_policy_quatationno_iia()` | 70% (55) | – | **6% (97)** |

(% = ความเหมือนกับ body บน UAT-ISV ทีละบรรทัด)

- ไม่รู้ว่า Prod ใช้เวอร์ชันไหน → **Step 0** เทียบ md5 บน Prod กับ UAT-ISV (`00_prod_precheck_readonly.sql`)
- ทุกไฟล์ใช้ `DROP FUNCTION IF EXISTS` ก่อน `CREATE` → GRANT/COMMENT หาย และถ้ามี object อื่นพึ่งพาจะ error
- patch ใน repo (purchase/uam) ไม่มี `BEGIN/COMMIT` → ถ้าพังกลางไฟล์ DB ค้างครึ่งทาง (function ถูก DROP แล้วแต่ยังไม่ CREATE)
- ถ้าวันหน้าต้องใช้: สร้างไฟล์ Deploy ใหม่จาก `pg_get_functiondef()` ของ environment ที่ทดสอบผ่าน ห้ามใช้ 3 ไฟล์นี้

## 2. WS6 / WS7 — ⛔

| # | ปัญหา | ไฟล์ที่โดน |
| :-: | :--- | :--- |
| 1 | `fn_policy_renewal` ประกาศ **signature ผิด** `(p_policy_no varchar, p_flag_noti bool, p_flag_lead bool)` แต่ของจริงคือ `(in_policy_no text, in_flag_noti bool, in_flag_lead bool, in_bad_behavior bool DEFAULT false)` → `CREATE OR REPLACE` สร้าง **overload ตัวที่สอง** ไม่ได้แทนที่ | ทุกไฟล์ WS6/WS7 (5 ไฟล์) |
| 2 | ผลของข้อ 1: premium เรียก `fn_policy_renewal(:policy_no, :flag_noti, :flag_lead)` ด้วย literal → PostgreSQL เลือกตัว `text` (ตัวเดิม) → **ตัวใหม่ไม่ถูกเรียกเลย = logic WS6/WS7 ในไฟล์ไม่มีผล** และทิ้ง overload ค้างไว้ (ไม่มี DB function อื่นเรียก ตรวจแล้ว) | ทุกไฟล์ WS6/WS7 |
| 3 | body ในไฟล์ยาว 1.2–3.4 KB เทียบกับของจริง 107 KB → เป็นโครง (stub) ไม่ใช่ logic renewal ทั้งหมด ถ้าถูกเรียกเมื่อไหร่ renewal ผิด | ทุกไฟล์ WS6/WS7 |
| 4 | `no_cancel_flag = true` แต่คอลัมน์เป็น `varchar` → **error ทั้งไฟล์** | `ws6_ws7_combined_renewal_master.sql`, `ws6_salesforce_endorsement_patches.sql` (ฉบับใน uam ใช้ `= 'Y'` ถูกชนิด) |
| 5 | ตั้ง `"Policy_Status" = 'C'` — comment ของคอลัมน์ระบุค่า `ACT, INC, 11, 00` ไม่มี `'C'` → ต้องให้ Business ยืนยัน | ไฟล์ WS6 ทุกฉบับ |
| 6 | patch แยก (ws6/ws7) ไม่มี `BEGIN/COMMIT`, ไม่มี advisory lock, ไม่มี backup แถวก่อน `UPDATE` | ws6/ws7 patches |
| 7 | `fn_format_utc_timestamp_th`: ฉบับ ws6 patch = UAT-ISV ✅; ฉบับ combined master ต่างจาก UAT-ISV | combined master |

✅ Rule 6: คอลัมน์ที่ UPDATE อ้างถึงทั้ง 21 คอลัมน์ (`Policy_Header`, `Policy_coverage_premium`) มีจริงบน UAT-ISV
✅ คอลัมน์ที่ไฟล์คืนค่า (`rtn_*` 14 ตัว) ตรงกับที่ premium SELECT

## 3. ไฟล์ .sql ที่อยู่ใน repo service

| Repo | ไฟล์ | อยู่บน `uat-isv` |
| :--- | :--- | :-: |
| `go-echo-uam-service` | `ws6_database_patches.sql`, `ws7_database_patches.sql` | ✅ |
| `go-echo-analytics-service` | `ws9_bigquery_column_migration.sql` | ✅ |
| `go-echo-purchase-service` | `ws1_database_patches.sql` (branch ws7-renew), `ws5_database_patches.sql` (branch ws5) | – |
| `go-echo-uam-service` | `ws5_database_patches.sql` (branch ws5) | – |

ถ้า merge `uat-isv` → `main` ไฟล์เหล่านี้จะเข้า `main` ด้วย (ไม่ถูกรันอัตโนมัติ แต่คนอาจหยิบไปรันผิดตัว) → แนะนำลบออกจาก repo service และเก็บที่ `deploy_jobs` ที่เดียว

## 4. ขั้นต่อไป

1. คนที่มีสิทธิ์รัน `05_release_pack/sql/00_prod_precheck_readonly.sql` บน Prod → ส่งผลกลับ
2. ถ้า md5 Prod = UAT-ISV ทุก function → **ไม่ต้องรัน SQL ของ WS1–7 เลย** เหลือแค่ Job 04 (+ WS9 ใน BigQuery)
3. ถ้าต่าง → สร้างไฟล์ Deploy ใหม่จาก `pg_get_functiondef()` ของ UAT-ISV พร้อม backup จาก Prod, transaction, advisory lock, rollback — ต้องขออนุมัติก่อน
4. Data patch WS6 (`prem_version`, `Policy_Status='C'`): รอ Business ยืนยันความหมาย ก่อนเขียนไฟล์ใหม่ที่มี backup แถว + dry-run count
