# 🚀 Production Deployment Pack: Multi-Service Infrastructure & Network Fixes (Job 03)

> **สรุปภาพรวม (Deployment Overview)**
> * **วัตถุประสงค์:** แก้ไขปัญหาเชิงโครงสร้างเครือข่าย Hairpin Loop, Load Balancer 503 ((no backend)), และ Connection Timeout สำหรับ 5 Microservices
> * **กฎเหล็กที่บังคับใช้:** **ห้ามแก้ไขไฟล์ `helm-prod.yaml` ใน Repository ใดๆ โดยเด็ดขาด 100%** ทุกการปรับแต่งทำผ่าน Helm Values Patch Files ในโฟลเดอร์นี้
> * **ระดับความเสี่ยง (Risk Level):** ต่ำมาก (Low Risk - ปรับเปลี่ยนเฉพาะเส้นทาง Network DNS ภายใน Cluster และ Tuning Resource/Probes ไม่มีการแตะต้อง Database Schema หรือ Business Logic)
> * **ระยะเวลา Downtime:** **Zero Downtime (Rolling Update)**

---

## 📋 1. รายการระบบและปัญหาที่แก้ไข (Target Services & Issues)

| ลำดับ | ไมโครเซอร์วิส (Service Name) | หมายเลขปัญหา (Issue) | ปัญหาเดิม (Root Cause) | แนวทางแก้ไข (Patch Solution) | ไฟล์ Patch |
| :---: | :--- | :---: | :--- | :--- | :--- |
| **1** | **`go-echo-uam-service`** | **Issue #16 (P0)** | `Backend_Notification` ชี้เน็ตนอก เกิด Hairpin Loop Timeout 30s | Override ชี้ Internal DNS `http://backend-notification-service:8080/` | `helm_patches/patch_uam_prod.yaml` |
| **2** | **`go-echo-lead-policy-service`** | **Issue #17 (P1)** | `EMAIL_URL` ชี้เน็ตนอก ส่งผลให้แนบไฟล์ PDF ใหญ่เกิน 2MB โดน Gateway ตัด 2.2s | Override ชี้ Internal DNS `http://backend-notification-service:8080/api/v1/notification/email` | `helm_patches/patch_lead_policy_prod.yaml` |
| **3** | **`go-e-api` (OpenAPI Motor)** | **Issue #27 (P1)** | `ISV_HOST` ชี้เน็ตนอก ได้รับ HTML `<` (503) แทนที่จะเป็น JSON | Override ชี้ Internal Core Service `http://backend-core-service:8080` | `helm_patches/patch_go_e_api_prod.yaml` |
| **4** | **`go-oauth2-server`** | **Issue #24 (P2)** | Memory 128Mi เสี่ยง OOM และ Readiness Delay 60s นานเกินไป ทำให้ LB ตอบ 503 ((no backend)) | เพิ่ม Memory เป็น 256Mi และลด Readiness Delay เหลือ 15s | `helm_patches/patch_oauth2_prod.yaml` |
| **5** | **`go-echo-analytics-service`** | **Issue #25 (P2)** | Readiness Delay 60s ขาด preStop hook ทำให้ Preflight CORS OPTIONS โดน 503 | ลด Readiness Delay เหลือ 15s และเพิ่ม PreStop Hook (`sleep 15`) | `helm_patches/patch_analytics_prod.yaml` |

---

## 🛠️ 2. ขั้นตอนการ Deploy (Deployment Execution Commands)

> [!TIP]
> ทีม DevOps หรือ SRE สามารถเลือกใช้คำสั่ง `helm upgrade --reuse-values -f` หรือ `kubectl set env` ได้ตามความสะดวก:

### วิธีที่ 1: Deploy ผ่าน Helm Upgrade Values Override (แนะนำ)

```bash
# 1. Patch UAM Service (Issue #16)
helm upgrade backend-uam-service ./helm --reuse-values -f helm_patches/patch_uam_prod.yaml -n default

# 2. Patch Lead Policy Service (Issue #17)
helm upgrade backend-lead-policy-service ./helm --reuse-values -f helm_patches/patch_lead_policy_prod.yaml -n default

# 3. Patch OpenAPI Motor (Issue #27)
helm upgrade openapi-motor-service ./helm --reuse-values -f helm_patches/patch_go_e_api_prod.yaml -n default

# 4. Patch OAuth2 Server (Issue #24)
helm upgrade openapi-oauth-service ./helm --reuse-values -f helm_patches/patch_oauth2_prod.yaml -n default

# 5. Patch Analytics Service (Issue #25)
helm upgrade backend-analytics-service ./helm --reuse-values -f helm_patches/patch_analytics_prod.yaml -n default
```

### วิธีที่ 2: Deploy ผ่าน kubectl set env ตรง (กรณีเร่งด่วน / Hot-patch)

```bash
# Patch Backend_Notification ใน UAM ทันที
kubectl set env deployment/backend-uam-service Backend_Notification="http://backend-notification-service:8080/api/v1/notification/" -n default

# Patch EMAIL_URL ใน Lead Policy ทันที
kubectl set env deployment/backend-lead-policy-service EMAIL_URL="http://backend-notification-service:8080/api/v1/notification/email" -n default

# Patch ISV_HOST ใน OpenAPI Motor ทันที
kubectl set env deployment/openapi-motor-service ISV_HOST="http://backend-core-service:8080" -n default
```

---

## 🔍 3. การตรวจสอบผลหลังการ Deploy (Health Verification)

1. **ตรวจสอบสถานะ Pod Rolling Update:**
   ```bash
   kubectl rollout status deployment/backend-uam-service -n default
   kubectl rollout status deployment/backend-lead-policy-service -n default
   kubectl rollout status deployment/openapi-motor-service -n default
   kubectl rollout status deployment/openapi-oauth-service -n default
   kubectl rollout status deployment/backend-analytics-service -n default
   ```
2. **รันสคริปต์ตรวจสอบการเชื่อมต่อ Internal Service:**
   ```bash
   bash scripts/verify_internal_connectivity.sh default
   ```
3. **ทดสอบยิง API UAM OTP (Issue #16 Verification):**
   ```bash
   curl -s -X POST "https://api.insurverse.co.th/api/v1/uam/validate_email" \
     -H "Content-Type: application/json" \
     -d '{"email":"kritsana.w.os@horixon-t8.com"}' | jq .
   # ต้องตอบกลับ HTTP 200 ภายใน < 500ms (ไม่มีอาการค้าง 30 วินาที)
   ```

---

## ↩️ 4. ขั้นตอนการ Rollback (Rollback Procedure)

หากพบความผิดปกติหลังการ Deploy สามารถย้อนกลับไปยัง Release ก่อนหน้าได้ทันที:

```bash
helm rollback backend-uam-service 0 -n default
helm rollback backend-lead-policy-service 0 -n default
helm rollback openapi-motor-service 0 -n default
helm rollback openapi-oauth-service 0 -n default
helm rollback backend-analytics-service 0 -n default
```
