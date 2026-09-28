# คู่มือขั้นตอนการขึ้นระบบ Production (WS6 - WS9 Production Runbook)
# Production Deployment Runbook: Workstreams WS6 - WS9

> **เอกสารคู่มือขั้นตอนการขึ้นระบบจริงสำหรับทีม DevOps / Developer**  
> ครอบคลุมขั้นตอนการ Backup, รัน SQL Migration, Deploy Microservices, ตรวจสอบผล และแผน Rollback

---

## 📁 โครงสร้างไฟล์ในโฟลเดอร์นี้ (Folder Contents)

| ชื่อไฟล์ (File) | คำอธิบาย (Description) |
| :--- | :--- |
| [`01_backup_pre_deploy.sh`](01_backup_pre_deploy.sh) | **Step 1:** สคริปต์สำรองข้อมูล Function เดิมบน Production ก่อนแก้ไข (Mandatory Rule 3) |
| [`02_deploy_migration.sql`](02_deploy_migration.sql) | **Step 2:** สคริปต์ SQL Migration หลัก (DDL, Indexes, Functions, Sequences) |
| [`03_verify_post_deploy.sql`](03_verify_post_deploy.sql) | **Step 3:** คำสั่ง SQL ตรวจสอบความถูกต้องของ DB หลังรันเสร็จ (Health Check) |
| [`04_rollback.sql`](04_rollback.sql) | **Step 4:** สคริปต์สำหรับ Rollback กรณีเกิดเหตุฉุกเฉิน |
| [`configs/`](configs/) | โฟลเดอร์เก็บ Helm Values และไฟล์ Config สิ่งแวดล้อม (`.yaml`, `.env`) |
| [`git_release_manifest.md`](git_release_manifest.md) | บันทึก Git Branches และลิงก์ GitLab Merge Request ทั้งหมด |

---

## 🚀 ลำดับขั้นตอนการขึ้นระบบ (Step-by-Step Deployment Steps)

### ขั้นตอนที่ 1: ดำเนินการ Merge Request บน GitLab
1. เข้าลิงก์ Merge Request ใน [`git_release_manifest.md`](git_release_manifest.md)
2. ทำการ Approve และ Merge ทั้ง 3 บริการเข้าสู่สาขา `main`:
   - `go-echo-uam-service`
   - `go-echo-backoffice-service`
   - `go-echo-notification-service`

### ขั้นตอนที่ 2: สำรองข้อมูลเดิมบน Production Database (Rule 3)
รันสคริปต์ Backup เพื่อเก็บนิยามฟังก์ชันเดิมไว้เป็น Safety Net:
```bash
# กำหนดค่า Connection String ไปยัง Production
export DB_HOST="<PROD_HOST>"
export DB_PORT="5432"
export DB_USER="<PROD_USER>"
export DB_NAME="insurverse"

# รันสคริปต์ Backup
bash 01_backup_pre_deploy.sh
```

### ขั้นตอนที่ 3: รันสคริปต์ SQL Migration บน Production
ใช้คำสั่ง `psql` เพื่อรันสคริปต์ SQL (คำสั่งครอบ Transaction `BEGIN ... COMMIT` ปลอดภัย 100%):
```bash
psql -h <PROD_HOST> -p 5432 -U <PROD_USER> -d insurverse -v ON_ERROR_STOP=1 -f 02_deploy_migration.sql
```

### ขั้นตอนที่ 4: ตรวจสอบผลการ Migration (Verification)
รันสคริปต์ตรวจสอบความถูกต้องของ Schema, Function และ Sequence:
```bash
psql -h <PROD_HOST> -p 5432 -U <PROD_USER> -d insurverse -f 03_verify_post_deploy.sql
```

### ขั้นตอนที่ 5: Deploy Microservices บน Kubernetes Cluster
Deploy หรือ Restart Pods ของ Microservices เพื่อรับการตั้งค่าใหม่:
- **`go-echo-uam-service`**: ตรวจสอบว่า Connection Pool (`DB_MAX_OPEN_CONNS=50`, `DB_MAX_IDLE_CONNS=25`) ใช้งานตาม [`configs/uam_helm_pool_config.yaml`](configs/uam_helm_pool_config.yaml)
- **`go-echo-notification-service`**: ตรวจสอบว่า Headers SMTP ทำงานตาม [`configs/notification_smtp_headers.env`](configs/notification_smtp_headers.env)
- **`go-echo-backoffice-service`**: ตรวจสอบการเปิดใช้งานหน้า Export Promo Code

### ขั้นตอนที่ 6: ทดสอบ Health Check บริการ
```bash
# Health Check API
curl -i https://<PROD_API_DOMAIN>/health
```

---

## 🔄 แผนการ Rollback กรณีฉุกเฉิน (Emergency Rollback)
หากเกิดเหตุขัดข้อง สามารถ Rollback ฐานข้อมูลและบริการได้ดังนี้:
1. **Rollback Database:**
   ```bash
   # คืนค่า Function เดิมจากไฟล์ Backup
   psql -h <PROD_HOST> -p 5432 -U <PROD_USER> -d insurverse -f backups/backup_prod_functions_<TIMESTAMP>.sql

   # ถอน Index และ Default
   psql -h <PROD_HOST> -p 5432 -U <PROD_USER> -d insurverse -f 04_rollback.sql
   ```
2. **Rollback Microservices:**
   - สั่ง Revert หรือ Rollout undo deployment บน Kubernetes ไปยังเวอร์ชันก่อนหน้า:
     ```bash
     kubectl rollout undo deployment/<DEPLOYMENT_NAME> -n <NAMESPACE>
     ```
