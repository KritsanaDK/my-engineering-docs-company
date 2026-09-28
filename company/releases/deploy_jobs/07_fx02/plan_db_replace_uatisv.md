# แผน: แทนที่ DB ของ UAT-ISV ด้วย DB ของ Prod

> **สถานะ:** 🟡 DRAFT (วางแผน ยังไม่ลงมือ) · 2026-09-24
> **เป้าหมาย:** UAT-ISV DB = Prod ทุกอย่าง (schema, function, trigger, index, sequence, ข้อมูล) เพื่อให้ผล E2E เชื่อถือได้
> **ขอบเขต:** DB เท่านั้น — โค้ด (`uat-isv` branch) สลับไป `main` ในช่วงเวลาเดียวกัน (ขั้น 7) แต่วางแผนแยก

## ข้อมูลตั้งต้น (ตรวจแล้ว 2026-09-24, อ่านอย่างเดียว)

| รายการ | UAT-ISV | Prod |
|---|---|---|
| Engine | Cloud SQL PostgreSQL 17.11 | Cloud SQL (`insureverse-prod`) — version ⏳ |
| DB | `insurverse` 137 MB | ⏳ ขนาด |
| Schema | `insurverse` (300 ตาราง), `public` (3 ตาราง) | `insurverse` 252 ตาราง · `public` ⏳ |
| Extension | `plpgsql`, `uuid-ossp`, `pgcrypto` | ⏳ |
| User ที่ Service ใช้ | `pgpool` (`cloudsqlsuperuser`) — ทุก Service ชี้ `insurverse` ที่ `136.85.102.224` | — |
| Connection ขณะตรวจ | 27 (`pgpool`) | — |
| Backup ที่มีแล้ว | Schema ทั้งหมด `07_fx02/backup_uatisv_20260924/` | Schema dump `isv-bible/.database/prod/` (`dd86d0d`) |

**แนวทางสลับ:** Restore ลง **DB ใหม่** แล้ว **เปลี่ยนชื่อ DB สลับกัน** (`insurverse` → `insurverse_isv_old`, `insurverse_prodclone` → `insurverse`) — Service ไม่ต้องแก้ config (ใช้ชื่อ `insurverse` เดิม) และ Rollback = เปลี่ยนชื่อกลับ

---

## Step 0 — ตัดสินใจ / ตกลง (คน)

| # | เรื่อง | ตัวเลือก | ผู้ตัดสิน |
|---|---|---|---|
| 0.1 | เอาข้อมูล Prod มาไหม | **(ก)** Schema + ข้อมูลทั้งหมด แล้ว Mask · **(ข)** Schema + Master data (`mas_*`, ตารางเบี้ย/ราคา/config) + ตัวอย่างที่ Mask | หัวหน้า + เจ้าของข้อมูล (PDPA) |
| 0.2 | ใคร Export จาก Prod | ผู้ดูแล Prod (Claude แตะ Prod ไม่ได้ — Rule 12) | หัวหน้า |
| 0.3 | ช่วงเวลาสลับ | ช่วงที่ทีมไม่ทดสอบ (voranunb, napat, kIttabeth, panita.p) | ทีม |
| 0.4 | ข้อมูลบน UAT-ISV เดิมที่ต้องเก็บ | ข้อมูลทดสอบของทีม / ฟีเจอร์ที่ยังไม่ขึ้น Prod (เช่น renewal ของ voranunb, OTP) จะหายจาก DB ที่ใช้งาน (ยังอยู่ใน `insurverse_isv_old`) | ทีม |

**เสร็จเมื่อ:** ตกลงเป็นลายลักษณ์อักษรครบ 4 ข้อ

---

## Step 1 — ปิดช่องทางส่งออกก่อนมีข้อมูลจริง (สำคัญที่สุด)

> ถ้าใช้ข้อมูลจริง (0.1 ก) งาน cron/batch บน UAT-ISV จะส่งถึงลูกค้าจริงได้

| ช่องทาง | ตรวจอะไร | ต้องเป็น |
|---|---|---|
| Email (notification SMTP/SENDER) | host, sender | กล่องทดสอบ / ปิด |
| SMS (thaibulk) | endpoint, key | ปิด / sandbox |
| Salesforce | `SF_EndPoint` | Sandbox |
| คปภ. CMI / IIA | `URL_CMI_*`, `Url_IIA` | Endpoint UAT ของ คปภ./IIA |
| 2C2P | endpoint, merchant | Sandbox |
| Shopee / TQM / partner callback | URL | Sandbox / ปิด |
| Cron (renewal noti, noti expire, SF sync, IIA reconcile, CMI resubmit) | ตาราง schedule ทุก service | **พักไว้** จนผ่าน Step 8 |

- **ผู้ทำ:** Claude ตรวจ (อ่านอย่างเดียว จาก `helm-uat-isv.yaml` ทุก Repo) → ทีมแก้ config ที่ยังชี้ของจริง
- **เสร็จเมื่อ:** ตารางครบทุก Service ทุกช่องทางเป็น sandbox/ปิด · cron พักแล้ว
- **ไม่ผ่าน:** หยุด ไม่ Restore ข้อมูลจริง

---

## Step 2 — Backup UAT-ISV เต็ม (Rule 3)

```bash
pg_dump -h <UATISV> -U pgpool -d insurverse -Fc --no-owner --no-privileges \
        -f backup_uatisv_full_$(date +%Y%m%d_%H%M%S).dump      # schema + data
```
- **เสร็จเมื่อ:** ไฟล์ .dump + `pg_restore --list` อ่านได้ + จำนวน object ตรง

---

## Step 3 — Export จาก Prod (ผู้ดูแล Prod)

- วิธีที่แนะนำ: `gcloud sql export sql` ลง GCS (Cloud SQL native) หรือ `pg_dump -Fc` ด้วยสิทธิ์อ่านอย่างเดียว
- ตามข้อ 0.1: ทั้ง DB หรือ `--schema-only` + `--data-only -t 'insurverse.mas_*' -t <ตารางเบี้ย/config>`
- ต้องรวม: ทุก schema ที่ใช้ (`insurverse`, `public`), sequence values (`setval`), extensions
- ส่งมาพร้อม: ขนาดไฟล์, จำนวน object, เวลา export, PostgreSQL version
- **เสร็จเมื่อ:** ได้ไฟล์ + ข้อมูลประกอบ

---

## Step 4 — Restore ลง DB ใหม่ (ไม่แตะ DB เดิม)

```sql
CREATE DATABASE insurverse_prodclone;           -- บน instance UAT-ISV
-- ใน insurverse_prodclone:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; CREATE EXTENSION IF NOT EXISTS pgcrypto;
```
```bash
pg_restore -h <UATISV> -U pgpool -d insurverse_prodclone --no-owner --no-privileges -j 4 prod.dump
```
- Owner/Grant: ให้ `pgpool` เป็นเจ้าของ/มีสิทธิ์ครบ (ตามที่ Service ใช้)
- **เสร็จเมื่อ:** Restore ไม่มี Error · จำนวนตาราง/function/sequence = ที่ Prod แจ้ง
- **ไม่ผ่าน:** `DROP DATABASE insurverse_prodclone` แล้วเริ่มใหม่ (DB เดิมไม่กระทบ)

---

## Step 5 — ทำความสะอาดข้อมูล (ถ้ามีข้อมูลจริง)

| กลุ่ม | ตาราง (ตัวอย่าง) | วิธี |
|---|---|---|
| ข้อมูลส่วนบุคคล | `Policy_Header`, `Policy_Header_Trans`, `Lead_*`, `Policy_Car_Act_*`, `sec_user`, `ekyc_ocr`, `claim_request*`, `lead_*_participant`, `lead_info_customer` | Mask: ชื่อ/นามสกุล → ค่าทดสอบ, เลขบัตร → เลขทดสอบที่ checksum ถูก (ไม่ซ้ำกัน), เบอร์ → 06xxxxxxxx ปลอม, อีเมล → `u<id>@example.test`, ที่อยู่ → `1 หมู่ 1` (Rule 4) · **คงรูปแบบ/ความยาว** ของทะเบียนรถ, เลขตัวถัง ไว้ใช้ทดสอบ คปภ. |
| Password / Token | `sec_user` (password hash), `jwt_tokens`, `shopee_app_access_token`, `shopee_app_authorized`, token SF/partner ใน config table | เปลี่ยน hash เป็นรหัสทดสอบ · TRUNCATE ตาราง token |
| Log ที่มี Payload | `api_payload_logs`, `callback_logs*`, `log_activity*`, `email_logs`, `log_*` | TRUNCATE (หรือเก็บเฉพาะ record ที่ใช้ทดสอบ คปภ. หลัง Mask) |
| Record คปภ. 459 รายการ | ตาม error code | เก็บไว้ (Mask ชื่อ/เลขบัตร) ใช้ทดสอบการแก้ |

- สคริปต์ Mask ทำเป็นไฟล์ SQL รันใน Transaction · ตรวจ Rule 6 (คอลัมน์มีจริง) ก่อนรัน
- ตรวจ Sequence: ทุก sequence ≥ MAX(id) ของตารางที่ใช้
- **เสร็จเมื่อ:** สคริปต์ตรวจ "ไม่เหลือข้อมูลจริง" ผ่าน (สุ่มตรวจ + pattern อีเมล/เบอร์จริง = 0) · sequence ผ่าน

---

## Step 6 — ยืนยัน = Prod

- Fingerprint เทียบกับ `isv-bible/.database/prod/` (หรือ Export ชุดเดียวกัน): ตาราง, คอลัมน์ (รวม `timestamp(0)`), DEFAULT, constraint, index, sequence, function (md5), trigger, view
- ต้องได้: **diff = 0** (ยกเว้นผลของการ Mask ที่เป็นข้อมูล ไม่ใช่ schema)
- ตรวจจุดที่เคยต่าง: ไม่มี `trg_sync_pcad_from_ph` · ไม่มี unique `lower(email)` · `Effective_Startdate` เป็น `timestamp(0)` · `fn_policy_to_car_act` / `quatationno` ไม่มีล็อก (แบบ Prod) · `Lead_No` ไม่มี DEFAULT
- **ไม่ผ่าน:** ห้ามสลับ

---

## Step 7 — สลับ (ช่วงเวลาที่ตกลง)

```sql
-- เชื่อมต่อผ่าน DB postgres
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname IN ('insurverse','insurverse_prodclone') AND pid <> pg_backend_pid();
ALTER DATABASE insurverse RENAME TO insurverse_isv_old;
ALTER DATABASE insurverse_prodclone RENAME TO insurverse;
```
- ทำพร้อมกับสลับโค้ด `uat-isv` → `main` (โค้ด uat-isv ปัจจุบันใช้ของที่มีแค่ UAT-ISV เช่น 10 คอลัมน์ใน `Policy_coverage_premium`)
- Service reconnect อัตโนมัติ → Smoke test: login, คำนวณเบี้ย, สร้าง lead, จ่ายเงิน sandbox, ออก พ.ร.บ.
- **Rollback:** terminate แล้ว rename กลับ (`insurverse` → `insurverse_prodclone`, `insurverse_isv_old` → `insurverse`)

---

## Step 8 — เฝ้าดู 1 วัน

- ไม่มีอีเมล/SMS/Callback ออกไปหาคนจริง (ดู log ของ notification, SF, CMI)
- ไม่มี Error ที่เกิดจาก Environment
- ผ่านแล้วค่อยเปิด cron ทีละตัว (ยังชี้ sandbox)

---

## หลังจากนี้

- Step 9: เริ่มแก้บั๊กตาม `plan_fx02.md` บน DB ที่เหมือน Prod
- เก็บ `insurverse_isv_old` ไว้อย่างน้อย 2 สัปดาห์ แล้วค่อยตกลงกับทีมว่าจะลบเมื่อไร

## ⏳ ต้องการข้อมูล

1. คำตอบ Step 0 (ข้อมูลจริงหรือ Master data, PDPA, ใคร Export, ช่วงเวลา)
2. ขนาด DB Prod และ PostgreSQL version
3. รายชื่อตาราง Master data/config ที่ระบบต้องใช้ (ถ้าเลือก 0.1 ข) — Claude ร่างให้ได้จากโค้ด
