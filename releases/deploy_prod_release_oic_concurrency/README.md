# คู่มือขั้นตอนการขึ้นระบบ Production (OIC Act Payment & Concurrency Hardening)
# Production Deployment Runbook: OIC Act & Concurrency (WS1 + WS5)

> **เอกสารคู่มือขั้นตอนการขึ้นระบบจริงสำหรับทีม DevOps / Developer**  
> ครอบคลุมขั้นตอนการ Backup, รัน SQL Migration สำหรับ 4 Stored Procedures (WS1 & WS5), Deploy WebApp Frontend, ตรวจสอบผล และแผน Rollback

---

## 📁 โครงสร้างไฟล์ในโฟลเดอร์นี้ (Folder Contents)

| ชื่อไฟล์ (File) | คำอธิบาย (Description) |
| :--- | :--- |
| [`01_backup_pre_deploy.sh`](01_backup_pre_deploy.sh) | **Step 1:** สคริปต์สำรองข้อมูล Function เดิมบน Production ก่อนเริ่ม Migration |
| [`02_deploy_migration.sql`](02_deploy_migration.sql) | **Step 2:** สคริปต์ SQL Migration หลัก (4 Stored Procedures ครอบด้วย `BEGIN ... COMMIT`) |
| [`03_verify_post_deploy.sql`](03_verify_post_deploy.sql) | **Step 3:** คำสั่ง SQL ตรวจสอบความพร้อมและทดสอบสร้างเลข Invoice/Quotation |
| [`04_rollback.sql`](04_rollback.sql) | **Step 4:** สคริปต์คำแนะนำและ Template สำหรับ Rollback ฉุกเฉิน |
| [`git_release_manifest.md`](git_release_manifest.md) | บันทึก Git Branches, Commit details และลิงก์ Merge Request ขึ้น `main` |

---

## 🎯 ขอบเขตการเปลี่ยนแปลง (Scope of Changes)

### 1. Database (4 Core Stored Procedures):
- **`insurverse.fn_lead_to_car_act`**: ออกเลข พ.ร.บ. Standalone (MC) รองรับ Concurrency ด้วย Transaction Advisory Lock + Collision Detection Loop
- **`insurverse.fn_policy_to_car_act`**: ออกเลข พ.ร.บ. คู่สมัครใจ (MV + MC)
- **`insurverse.fn_policy_invoiceno_iia`**: สร้างเลขที่ใบแจ้งหนี้ (Invoice No) ป้องกัน Race Condition
- **`insurverse.fn_policy_quatationno_iia`**: สร้างเลขที่ใบเสนอราคา (Quotation No) ป้องกัน Race Condition

### 2. Frontend (`nextjs-webapp`):
- **Branch**: `hotfix/oic`
- แก้ไขปัญหา Payment Callback timeout / infinite loading (`SuccessPayment.tsx`)
- เพิ่มการ Sanitization ข้อมูล OIC Act เพื่อความปลอดภัยและถูกต้องตามมาตรฐาน คปภ.

---

## 🚀 ลำดับขั้นตอนการขึ้นระบบ (Step-by-Step Deployment Steps)

### ขั้นตอนที่ 1: สำรองข้อมูลเดิมบน Production Database
รันสคริปต์ Backup เพื่อบันทึกคำนิยามเดิมของทั้ง 4 Functions:
```bash
cd /Users/kritsanawathaniyanon/Code/docs/releases/deploy_prod_release_oic_concurrency

# กำหนดค่า Connection String ไปยัง Production Database
export DB_HOST="<PROD_DB_HOST>"
export DB_PORT="5432"
export DB_USER="<PROD_DB_USER>"
export DB_NAME="insurverse"

# รันสคริปต์ Backup
bash 01_backup_pre_deploy.sh
```

### ขั้นตอนที่ 2: รันสคริปต์ SQL Migration บน Production
สคริปต์ครอบคลุมด้วย `BEGIN; ... COMMIT;` และ `DROP ... CREATE OR REPLACE` ปลอดภัย 100%:
```bash
psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 -f 02_deploy_migration.sql
```

### ขั้นตอนที่ 3: ตรวจสอบความถูกต้องของระบบฐานข้อมูล (Verification)
รันสคริปต์ตรวจสอบความปลอดภัยของ Concurrency และทดสอบการสร้างเลข Invoice / Quotation:
```bash
psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -f 03_verify_post_deploy.sql
```
**เกณฑ์ความสำเร็จ (Success Criteria):**
- ทั้ง 4 ฟังก์ชันต้องขึ้นสถานะ: `✅ CONCURRENCY SAFE (Advisory Lock + Loop)`
- การทดสอบ `fn_policy_invoiceno_iia` และ `fn_policy_quatationno_iia` ต้องผ่านโดยไม่มี error

### ขั้นตอนที่ 4: Deploy Frontend `nextjs-webapp`
1. ตรวจสอบและ Merge Branch `hotfix/oic` เข้าสู่ `main` ตามคำแนะนำใน [`git_release_manifest.md`](git_release_manifest.md)
2. สั่ง Trigger CI/CD Pipeline หรือรันสคริปต์ Deploy:
```bash
cd /Users/kritsanawathaniyanon/Code/NextJs/nextjs-webapp
# ตัวอย่าง: ./deploy.sh
```

---

## ⚠️ แผนการแก้ไขฉุกเฉิน (Emergency Rollback Plan)
หากพบปัญหาผิดปกติหลังการอัปเดตฟังก์ชันในฐานข้อมูล:
1. เรียกคืนนิยามฟังก์ชันเดิมจากไฟล์ Backup ที่สร้างไว้ใน ขั้นตอนที่ 1:
```bash
psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -f backups/backup_prod_oic_functions_<TIMESTAMP>.sql
```
2. รัน `03_verify_post_deploy.sql` เพื่อตรวจสอบสถานะฟังก์ชันอีกครั้ง

