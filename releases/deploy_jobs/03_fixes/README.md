# 📦 Deploy Job 03: Multi-Service Infrastructure & Network Fixes

โฟลเดอร์นี้รวบรวมแพ็กเกจการแก้ไขปัญหาเชิงโครงสร้างของ 5 Microservices (Issues #16, #17, #24, #25, #27) เพื่อเตรียมความพร้อมสำหรับการ Deploy บน Production

> [!CAUTION]
> **นโยบายเคร่งครัด:** ห้ามแก้ไขไฟล์ `helm-prod.yaml` ใน Repository ใดๆ โดยตรง ทุกการ Override ค่าสำหรับ Production ให้ใช้ไฟล์ในโฟลเดอร์ `helm_patches/` ร่วมกับคำสั่ง `helm upgrade --reuse-values -f`

---

## 📂 โครงสร้างโฟลเดอร์ (Directory Structure)

```text
03_fixes/
├── README.md                           # คำอธิบายภาพรวมโฟลเดอร์
├── deployment_plan_03_fixes.md         # แผนการ Deploy เต็มรูปแบบตามมาตรฐาน Rule 5
├── helm_patches/                       # ค่า Helm Values Override สำหรับ Production
│   ├── patch_uam_prod.yaml             # Issue #16: Backend_Notification Internal DNS
│   ├── patch_lead_policy_prod.yaml     # Issue #17: EMAIL_URL Internal DNS (แก้แนบ PDF ใหญ่)
│   ├── patch_go_e_api_prod.yaml        # Issue #27: ISV_HOST Internal DNS (แก้ HTML 503)
│   ├── patch_oauth2_prod.yaml          # Issue #24: Memory 256Mi / Delay 15s (แก้ LB 503)
│   └── patch_analytics_prod.yaml       # Issue #25: Delay 15s / preStop (แก้ CORS OPTIONS 503)
└── scripts/
    └── verify_internal_connectivity.sh # สคริปต์ทดสอบ Internal K8s Services
```

ดูรายละเอียดและคำสั่งการขึ้นระบบทั้งหมดได้ที่ 👉 [deployment_plan_03_fixes.md](file:///Users/kritsanawathaniyanon/Code/Go/deploy_jobs/03_fixes/deployment_plan_03_fixes.md)
