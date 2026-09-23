# 🚀 Production Deployment Pack: Motor Lead No Sequence (Job 04 — Issue #13)

> **สรุปภาพรวม (Deployment Overview)**
> * **ปัญหา:** `nodejs-express-premium-service` ออกเลข `Lead_No` ด้วย `MAX("Lead_No")+1` ทำให้ Insert ชนกัน (`duplicate key ... Lead_coverage_premium_pkey` 148 ครั้งใน 6 นาที) และลูกค้าอาจได้เลข Lead ของคนอื่นจาก `SELECT MAX("Lead_No")` ที่อ่านกลับ
> * **วิธีแก้:** ให้ DB ออกเลขจาก `insurverse.seq_lead_no` ผ่าน `DEFAULT` ของคอลัมน์ และโค้ดอ่านเลขกลับด้วย `RETURNING "Lead_No"`
> * **โค้ดที่ Deploy:** `7e03e85` บน `fix/fx-01-premium` (แตกจาก `main`, E2E ผ่านบน `uat-isv` 2026-09-23)
> * **ระดับความเสี่ยง:** ปานกลาง — มีการแก้ DDL คอลัมน์ Primary Key (ไม่แตะข้อมูลเดิม ไม่ Rewrite ตาราง)
> * **Downtime:** Zero Downtime (Rolling Update) — ล็อกตาราง `SHARE ROW EXCLUSIVE` ช่วงสั้นๆ ระหว่างรัน DDL (บล็อกเฉพาะ Insert/Update ไม่บล็อก Select)
> * **ลำดับที่ห้ามสลับ:** **DB (ขั้น 2) ต้องเสร็จก่อน Deploy โค้ด (ขั้น 3)** — `7e03e85` ไม่ใส่ `Lead_No` ใน INSERT แล้ว ถ้าคอลัมน์ยังไม่มี DEFAULT จะ Insert พังทุกครั้ง

---

## 📋 1. Git Readiness

| รายการ | ค่า |
| :--- | :--- |
| Repository | `nodejs-express-premium-service` |
| Source branch | `fix/fx-01-premium` |
| Commit | `7e03e85` — `fix(lead): allocate motor Lead_No from seq_lead_no DEFAULT and read back with RETURNING (FX-01 #13)` (2026-09-23) |
| Target branch | `main` (Merge โดยคนผ่าน MR Review เท่านั้น — ห้าม Auto-merge ตาม Rule 10) |
| ความสะอาดของ branch (ตรวจ 2026-09-23) | 1 commit เหนือ `origin/main`, 0 merge commit, ตามหลัง `main` 0 commit — ไม่มีงาน `uat-isv` ปน |
| อยู่บน `uat-isv` แล้ว | ✅ ใช่ (merge `52ff984`) — E2E: 50 request พร้อมกัน Lead_No ไม่ซ้ำ 50/50 |
| ไฟล์ที่เปลี่ยน | `controllers/premium.controller.js` (+23 / −18) — ตัด MAX+1, ใช้ DEFAULT + `RETURNING`, ตัด `Lead_No` จาก payload, กรองชื่อ field (กัน injection) |
| MR | https://isv-gl-s.insurverse.co.th/insurverse/backend/nodejs-express-premium-service/-/merge_requests/new?merge_request%5Bsource_branch%5D=fix%2Ffx-01-premium&merge_request%5Btarget_branch%5D=main |

**Branch ที่ไม่เกี่ยวข้อง / ห้ามใช้:** `hotfix/motor-lead-no-default` (`d031a3f` — อยู่บน uat-isv แต่ไม่ใช่ตัวที่ Promote)

| Branch | เหตุผล |
| :--- | :--- |
| `fix/motor-lead-no-sequence` (`d20771f`) | ตามหลัง `main` 28 commit และใช้ `pg_get_serial_sequence(...)` ซึ่งคืน **NULL** เพราะ `seq_lead_no` ไม่ได้ `OWNED BY` คอลัมน์ → Insert พัง |
| `fix/motor-lead-no-sequence-uat` (`310c36f`) | ตัวที่เคยถูก Revert (`7a21330`) ใช้แนวทางเดียวกับ `d20771f` |

---

## 🗄️ 2. Production-Safe DB Script

ไฟล์ทั้งหมดอยู่ใน `sql/` — ทดสอบ 2026-09-23 แล้ว: `00`, `01` รันจริงบน UAT-ISV (read-only); `02`, `03`, `99` รันกับตารางจำลองใน `pg_temp` ครบ 3 สถานการณ์ (DB ใหม่ไม่มี sequence / Pod เก่าแทรก MAX+1 ระหว่าง Rollout / รันซ้ำ) ได้เลขต่อเนื่องไม่ชนและไม่ถอยหลัง

| ขั้น | ไฟล์ | เขียนข้อมูล? | ทำอะไร |
| :---: | :--- | :---: | :--- |
| 0 | `sql/00_precheck_readonly.sql` | ❌ | ตรวจ DEFAULT, sequence, MAX, trigger บน Prod |
| 1 | `sql/01_backup_state.sql` | ❌ | บันทึกสถานะเดิมลงไฟล์ `backups/backup_lead_no_state_YYYYMMDD_HHMMSS.txt` (Rule 3) |
| 2 | `sql/02_migration_seq_lead_no.sql` | ✅ | `CREATE SEQUENCE IF NOT EXISTS` + `setval` แบบ Dynamic (`MAX+1`, ไม่ถอยต่ำกว่าเดิม) + `SET DEFAULT nextval(...)` ภายใต้ `pg_advisory_xact_lock` + `LOCK TABLE` |
| 4 | `sql/03_post_deploy_verify.sql` | ✅ (ส่วนที่ 1) | Resync sequence ข้ามเลขที่ Pod เก่าออกระหว่าง Rollout แล้วตรวจผล |
| — | `sql/99_rollback.sql` | ✅ | ใช้เฉพาะกรณีต้องคืนสภาพคอลัมน์ตาม backup (ปกติไม่ต้องใช้) |

**ข้อเท็จจริงจาก UAT-ISV (สภาพเป้าหมายที่ Prod ต้องเป็นหลังขั้น 2):**

```
lead_no_default     = nextval('insurverse.seq_lead_no'::regclass)
lead_no_type        = integer          (sequence เป็น bigint — ไม่มีปัญหาจนกว่าเลขเกิน 2,147,483,647)
serial_seq_owned_by = NULL (not OWNED BY)   ← 7e03e85 ไม่ต้องใช้ OWNED BY
non_internal_triggers = 0
```

**ตรวจ Stored Procedure คู่ขนาน (Rule 9):** ไม่มี function ใน schema `insurverse` ที่ Insert `Lead_coverage_premium` ด้วย `MAX("Lead_No")` — `fn_policy_renewal` ใช้ `lead_car_act_lead_no_seq` สำหรับ ACT (แก้ปัญหาเดียวกันไปแล้วเมื่อ 2026-09-02)

---

## ⚙️ 3. Deployment Prerequisites & Config

| รายการ | สถานะ |
| :--- | :--- |
| Environment variables / Secrets ใหม่ | ไม่มี |
| Helm values | ไม่เปลี่ยน |
| Ingress / DNS / Whitelist | ไม่เปลี่ยน |
| สิทธิ์ DB ที่ต้องใช้ | `CREATE` บน schema `insurverse`, เจ้าของตาราง `Lead_coverage_premium` (สำหรับ `ALTER TABLE`) |

### ลำดับการ Deploy

```bash
cd deploy_jobs/04_motor_lead_seq
mkdir -p backups

# ขั้น 0: Pre-check (read-only) — ถ้า lead_no_default เป็นค่าตามเป้าหมายแล้ว ข้ามขั้น 2 ได้
psql "$PROD_DSN" -v ON_ERROR_STOP=1 -At -f sql/00_precheck_readonly.sql

# ขั้น 1: Backup สถานะเดิม (Rule 3)
psql "$PROD_DSN" -v ON_ERROR_STOP=1 -At -f sql/01_backup_state.sql \
     -o backups/backup_lead_no_state_$(date +%Y%m%d_%H%M%S).txt

# ขั้น 2: DB Migration — ต้องเสร็จก่อนขั้น 3
psql "$PROD_DSN" -v ON_ERROR_STOP=1 -f sql/02_migration_seq_lead_no.sql

# ขั้น 3: Merge MR fix/fx-01-premium → main (โดยคน) แล้วรอ Pipeline Deploy ครบทุก Pod
kubectl -n <namespace> rollout status deployment/<premium-service-deployment>

# ขั้น 4: Resync + Verify (ต้องได้ ok = t)
psql "$PROD_DSN" -v ON_ERROR_STOP=1 -At -f sql/03_post_deploy_verify.sql
```

> [!NOTE]
> **ช่วง Rolling Deploy:** ระหว่างที่ Pod เก่า (MAX+1) กับ Pod ใหม่ (sequence) ทำงานพร้อมกัน ยังมีโอกาสชนได้แบบเดียวกับที่เกิดอยู่ทุกวันนี้ (ไม่ได้เสี่ยงเพิ่ม) ขั้น 4 จะเลื่อน sequence ข้ามเลขที่ Pod เก่าออกไป หลังจากนั้นจะไม่มีตัวออกเลขตัวที่ 2 อีก

---

## ✅ 4. Rollback & Health Verification Plan

### ตรวจหลัง Deploy
1. `sql/03_post_deploy_verify.sql` ต้องได้ `ok = t`
2. สร้างใบเสนอราคา Motor ทดสอบ 1 รายการ (ข้อมูลทดสอบตาม Rule 4) → ต้องได้ `Lead_No` ใหม่ และหน้าจ่ายเงินเปิดได้
3. Cloud Logging 30 นาทีหลัง Deploy ต้องไม่พบ:
   ```text
   resource.labels.container_name="backend-premium-service"
   "duplicate key value violates unique constraint" "Lead_coverage_premium_pkey"
   ```
   และไม่พบ `Failed to create lead`

### Rollback
| สถานการณ์ | ทำอะไร |
| :--- | :--- |
| โค้ดใหม่มีปัญหา | Rollback **เฉพาะ Image** ของ premium-service กลับเวอร์ชันก่อนหน้า — **ไม่ต้องแตะ DB** เพราะโค้ดเดิมใส่ `Lead_No` เองทุกครั้ง ไม่ใช้ DEFAULT |
| ต้องคืนสภาพคอลัมน์จริงๆ | ถอยโค้ดให้ครบทุก Pod ก่อน แล้วค่อยรัน `sql/99_rollback.sql` ตามค่าในไฟล์ backup (⚠️ ห้ามรันขณะ `7e03e85` ยังทำงาน) |

---

## ⚠️ 5. ความเสี่ยงที่ต้องปิดก่อน Feature ถัดไปเข้า `main`

`services/renewal-reprice.service.js:798` (อยู่บน `dev` และ `origin/feat/renewal-wait-to-process-8`) ยัง Insert `Lead_coverage_premium` ด้วย `MAX("Lead_No") + 1` และใส่ `"Lead_No"` เอง ถ้า Feature นี้เข้า `main` หลัง Job 04 จะกลายเป็น **ตัวออกเลขตัวที่ 2** ทำให้ sequence ไปชนเลขที่มีอยู่แล้ว (`23505`) — แบบเดียวกับที่ `fn_policy_renewal` เคยทำกับ ACT

- แพตช์แก้: `patches/0001-fix-renewal-drop-MAX-1-Lead_No-allocation-in-renewal.patch` — ตัด `"Lead_No"` ออกจาก INSERT ให้ DEFAULT ออกเลข คง `RETURNING "Lead_No"` ไว้ (ผ่าน `node --check` และ `EXPLAIN` บน UAT-ISV)
  - ไฟล์ `renewal-reprice.service.js` ยังไม่มีบน `main` จึง **ไม่ทำ branch แก้เอง** (นโยบาย: แตก branch จาก `main` เท่านั้น) — ส่งแพตช์ให้เจ้าของ Feature (`napat-k-t8`) นำไปใช้บน `feat/renewal-wait-to-process-*` เอง:
    ```bash
    git am deploy_jobs/04_motor_lead_seq/patches/0001-fix-renewal-drop-MAX-1-Lead_No-allocation-in-renewal.patch
    ```
- Job 04 ต้อง Deploy **ก่อน** Feature นี้ เพราะแพตช์พึ่ง DEFAULT ของคอลัมน์

**สิ่งที่ทีม Feature ต้องรู้เพิ่ม (ตรวจ 2026-09-23):**
1. `feat/renewal-wait-to-process-8` ยังมี `controllers/premium.controller.js` แบบ `MAX+1` เดิม (ไม่มี `7e03e85`) — ตอน Merge เข้า `main` หลัง Job 04 จะชนกัน ต้องเลือกฝั่ง `7e03e85`
2. `LEAD_COLUMNS` ใช้คอลัมน์ `renew_change_package_reason_code` ซึ่ง **ไม่มีใน `Lead_coverage_premium` บน UAT-ISV** และไม่พบ Migration ใน repo / `docs` / `deploy_jobs` — Feature นี้ต้องมี DDL เพิ่มคอลัมน์ก่อนขึ้น UAT-ISV / Prod
