# 📋 FX-01 สรุปสถานะ 27 ข้อ + ปัญหาที่พบเพิ่ม (Status Summary)

> **ณ วันที่:** 2026-09-23 · **สภาพแวดล้อมที่ทดสอบ:** `uat-isv` เท่านั้น (ไม่แตะ `uat` / Prod)
> **ฐานการทดสอบ:** E2E รอบเต็มด้วย `curl` + ชำระเงินจริงบน 2C2P sandbox (บัตร 5555…4444) ข้อมูลทดสอบตาม Rule 4
> **อ้างอิง:** Playbook `daily_troubleshooting_kb_20260915.md` · Release Pack `deploy_jobs/05_release_pack/`

---

## 0. ภาพรวม (Executive Summary)

| กลุ่ม | จำนวน |
| :--- | :---: |
| ✅ ขึ้น Prod (`main`) แล้ว | 10 |
| ✅ แก้แล้ว + ผ่าน E2E บน uat-isv → รอเปิด MR เข้า `main` | 8 |
| 🟡 แก้แล้วแต่ยังไม่ครบ / ยังไม่ได้ทดสอบซ้ำ | 7 |
| ℹ️ ไม่ใช่งานแก้โค้ด | 2 |
| 🆕 ปัญหาพบเพิ่ม — แก้แล้ว | 5 |
| 🆕 ปัญหาพบเพิ่ม — ยังไม่แก้ | 14 |

**เร่งด่วนที่สุด 3 เรื่อง:** N1 ช่องโหว่ Callback (เปิด MR ได้ทันที) · U1 ขอ one.th allow IP · U2 ตรวจ TA บน Prod

---

## 1. ปัญหา 27 ข้อเดิม

### ✅ ขึ้น Prod (`main`) แล้ว — 10 ข้อ

| # | ปัญหา | Service |
| :-: | :--- | :--- |
| 1 | IIA ไม่ส่ง / Log ไม่บอกเหตุผล | purchase / uam |
| 5 | พ.ร.บ. ออกเลขแต่ข้าม IIA/SF | purchase |
| 7 | 2C2P เลข Invoice ซ้ำ ลูกค้าจ่ายไม่ได้ | purchase |
| 8 | ประกันสมัครใจส่ง IIA ไม่ผ่าน (บรรเทาด้วย Reconcile) | policy |
| 9 | PA/Home ไม่เข้า IIA เมื่อไม่ส่งไปรษณีย์ | purchase |
| 10 | ตัดเงินซ้ำได้แม้ Lead จ่ายสำเร็จแล้ว | purchase |
| 14 | CMI ปฏิเสธทะเบียนผิดมาตรฐาน ขบ. | uam / policy |
| 21 | 2C2P Callback Panic จาก Type Assertion | purchase |
| 22 | Notification ต่อ TLS ไม่ผ่าน | notification |
| 26 | 2C2P Callback 502 Pod ปิดสายหนี | purchase |

### ✅ แก้แล้ว + ผ่าน E2E บน uat-isv — รอ MR เข้า `main` (8 ข้อ)

| # | ปัญหา | Branch | ผล E2E / หมายเหตุ |
| :-: | :--- | :--- | :--- |
| 13 | Motor Lead ชนซ้ำจาก MAX+1 | `fix/fx-01-premium` | 50 concurrent → Lead_No ไม่ซ้ำ 50/50 · ⚠️ **ต้องรัน DB Job 04 ก่อน merge** |
| 15 | URL Shortener โดน Cloudflare บล็อก | `fix/fx-01-isv-test` | 200 + short_url |
| 16 | UAM Email & OTP ล่ม | `fix/fx-01-uam` | validate_email / forget_password 200 · ⚠️ มี 3 commit นอกขอบเขต ต้อง Review |
| 23 | OCR Passport ล่ม (DNS NXDOMAIN) | `fix/fx-01-uam` | 200 + `can_manual` |
| 24 | oauth2 503 ระหว่าง Rollout | `fix/fx-01-oauth2` + helm | Rollout 3,568 req → 503 = 0 |
| 25 | CORS OPTIONS 503 | `fix/fx-01-analytics` + helm | Rollout → 503 = 0 |
| 27 | OpenAPI Motor ได้ HTML `<` | `fix/fx-01-e-api` | premium 200, error เป็น JSON |
| 6 | สลักหลังไม่ออกจาก Replica Lag | `fix/fx-01-document` | ตรวจโค้ดแล้ว **ยังไม่ได้ E2E** |

### 🟡 แก้แล้วแต่ยังไม่ครบ / ยังไม่ได้ทดสอบซ้ำ

| # | ปัญหา | สถานะ |
| :-: | :--- | :--- |
| 17 | Backoffice ส่ง Policy Email ล้มเหลว | โค้ด `fix/fx-01-lead-policy` + helm `EMAIL_URL` ภายใน · **รอ User Backoffice สิทธิ์ `RESEND_POLICY`** |
| 4 | LB ตัด 30s (notification) | `fix/fx-01-notification` **แตกผิดฐาน (จาก uat-isv)** → ต้องทำใหม่จาก `main` + cherry-pick `ae17af1` |
| 3, 11, 12, 18, 19 | SF ขาดกรมธรรม์หลัก / SMS ต่ออายุผิด / Home 500 / ต่ออายุจ่ายไม่ได้ / SF LB 30s | บันทึกว่าแก้แล้ว แต่รอบนี้ยังไม่ได้ทดสอบซ้ำ |

### ℹ️ ไม่ใช่งานแก้โค้ด

| # | ปัญหา | สถานะ |
| :-: | :--- | :--- |
| 2 | SF มี Record ซ้ำ | Guard แล้ว + ทำ Manual |
| 20 | Cloud SQL CPU Spike 17:00 | มี SOP |

---

## 2. ปัญหาที่พบเพิ่มระหว่างทดสอบ

### ✅ แก้แล้ว (ผ่าน E2E บน uat-isv)

| # | ปัญหา | ระดับ | Branch / วิธีแก้ | หลักฐาน |
| :-: | :--- | :-: | :--- | :--- |
| N1 | **2C2P Callback ไม่ตรวจลายเซ็น JWT** — ปลอม "จ่ายสำเร็จ" ได้ **(ช่องโหว่บน Prod)** | 🔴 | `fix/fx-01-purchase-callback` | ปลอม / `alg:none` → 400 · ของจริงจาก 2C2P ผ่าน 8/8 |
| N2 | ผู้ซื้อไม่มีใน `sec_user` → `accountID` NULL → ไม่ส่ง CMI/SF **(บั๊กบน Prod)** | 🔴 | `fix/fx-01-purchase-sf-account` (cherry-pick `059c275`) | พ.ร.บ. อีเมลยังไม่สมัคร → ได้เลข CMI ✅ |
| N3 | TA ค้าง — GitLab `CHART_PATH` = `helm-dev.yaml` scope **All** → Deploy ใช้ DB dev ตั้งแต่ 9 ก.ย. | 🔴 | เพิ่ม `CHART_PATH` scope `uat-isv` ✅ + `fix/fx-01-ta` (Rollback เมื่อ panic, pool/timeout) | TA premium 0.2s · ซื้อจริงได้ `TA-0026-I-000011` |
| N4 | OIC (uam) branch เดิมมีงาน uat ปน | 🟠 | `fix/oic-uam` จาก `main` (19 commit ของเรา) | build + test CMI 6/6 |
| N5 | WS6 premium `prem_version` ไม่มีค่า default | 🟡 | `fix/ws6-premium` | Deploy แล้ว |

### ❌ ยังไม่ได้แก้

| # | ปัญหา | ระดับ | ต้องทำ |
| :-: | :--- | :-: | :--- |
| U1 | **ลายเซ็น PDF `uat-sign.one.th` ต่อจาก uat-isv ไม่ได้** (TCP timeout) → PA/Home/TA **ไม่มีอีเมลกรมธรรม์**, พ.ร.บ. ช้า ~2.5 นาที | 🔴 | ขอ one.th allow **`34.87.144.141`** (+ `uatservice-etax.one.th`) · โค้ด: connect timeout สั้น + fallback |
| U2 | **TA บน Prod อาจใช้ `helm-dev.yaml`** (variable All ตัวเดียวกัน) | 🔴 | ทีม Prod ตรวจ `helm get values backend-ta-service` · ตั้ง `CHART_PATH` แยกทุก scope แล้วลบแถว All |
| U3 | SQL Injection ใน uam `ForgetPassword` (Endpoint สาธารณะ) | 🔴 | เปลี่ยนเป็น Parameterized Query |
| U4 | `go-e-api` บน `uat-isv` ตั้ง `CHART_PATH` แบบ global — ถ้า merge `uat-isv` → `main` Prod อาจ deploy ด้วยค่า uat-isv | 🔴 | ห้าม merge `uat-isv` → `main` ทั้ง branch |
| U5 | SQL WS6/WS7 พัง, SQL WS1/WS5 ไม่ตรงกับ DB | 🟠 | ห้ามใช้ — ใช้ `06_uatisv_db_snapshot` + Prod precheck |
| U6 | Helm patch Prod แบบมือถูก CI ทับ (ไม่มี `--reuse-values`) | 🟠 | ย้ายค่าเข้า `helm-prod.yaml` ผ่าน MR |
| U7 | MV: IIA ปฏิเสธ `cc` ว่าง + SF `JSONException` → ไม่มีอีเมล MV | 🟠 | ทดสอบใหม่ด้วย `size` ถูกต้อง (น่าจะข้อมูลทดสอบ) + เพิ่ม validate |
| U8 | purchase ไม่มี graceful shutdown + Node เป็น Spot → 503 ตอน restart | 🟠 | ใส่ drain แบบ #24/#25 |
| U9 | renewal-reprice MAX+1 (branch ของ napat-k-t8) | 🟠 | ส่ง patch ให้เจ้าของ |
| U10 | Secret เป็น plain text ใน helm (EKYC token, CAD, JWT) | 🟡 | ย้ายไป Kubernetes Secret |
| U11 | Master เบี้ย MV บน uat-isv ไม่ครบ ("Data not found") | 🟡 | เติมข้อมูล master |
| U12 | consent / notification ของ uat-isv ส่งต่อผ่าน proxy ไป service จริงของ UAT | 🟡 | ระวังตอนสรุปผลทดสอบ |
| U13 | ยอด พ.ร.บ. float `499.04999…` · uam middleware ปฏิเสธ `<` · `uat_isv.env` ระบุ NAT IP ผิด | 🟡 | แก้ตามรอบ |
| U14 | ยังไม่ได้ทดสอบ: ต่ออายุ, สลักหลัง, Concurrency (#7), WS8/WS9 | – | ต้องเตรียมข้อมูล |

---

## 3. ผล E2E รอบเต็ม (2026-09-23 16:34–16:40)

| Flow | ผล | กรมธรรม์ / หลักฐาน | อีเมลกรมธรรม์ |
| :--- | :-: | :--- | :-: |
| Regression 9 ข้อ | ✅ 9/9 | #13, #15, #16×2, #22, #23, #24, #25, #27 | – |
| Security callback | ✅ | ปลอม + `alg:none` → 400 | – |
| MV ชั้น 1 | ✅ | `MV-0026-I-000044` · Invoice `2609/00182` | ❌ (U7) |
| MV + พ.ร.บ. (bundle) | ✅ | `MV-0026-I-000055` + `MC-0026-I-002535` · CMI ✅ | ❌ (U7) |
| พ.ร.บ. (สมัครแล้ว) | ✅ | `MC-0026-I-002524` · CMI ✅ | ✅ ช้า ~2.5 นาที (U1) |
| พ.ร.บ. (ยังไม่สมัคร) | ✅ | `MC-0026-I-002546` · CMI ✅ (N2) | ✅ ช้า ~2.5 นาที (U1) |
| PA | ✅ | `PA-0026-I-000022` | ❌ (U1) |
| Home | ✅ | `HI-0026-I-000011` | ❌ (U1) |
| TA | ✅ | `TA-0026-I-000011` | ❌ (U1) |

---

## 4. Branch พร้อมเปิด MR เข้า `main` (คนเป็นผู้ Merge)

| Repo | Branch | ขึ้นกับ |
| :--- | :--- | :--- |
| go-echo-purchase-service | `fix/fx-01-purchase-callback` | 🔴 ด่วน |
| go-echo-purchase-service | `fix/fx-01-purchase-sf-account` | 🔴 |
| nodejs-express-premium-service | `fix/fx-01-premium` | DB Job 04 ก่อน merge |
| nodejs-express-premium-service | `fix/ws6-premium` | – |
| go-echo-uam-service | `fix/fx-01-uam` | Review scope ก่อน |
| go-echo-uam-service | `fix/oic-uam` | E2E OIC ผ่านแล้ว |
| go-echo-ta-service | `fix/fx-01-ta` | – |
| go-oauth2-server / go-echo-analytics-service | `fix/fx-01-oauth2` / `fix/fx-01-analytics` | ค่า helm-prod ตามนโยบาย |
| go-e-api | `fix/fx-01-e-api` | – |
| go-echo-lead-policy-service | `fix/fx-01-lead-policy` | รอทดสอบ Backoffice |
| isv-test | `fix/fx-01-isv-test` | – |
| python-fastapi-document-service | `fix/fx-01-document` | – |

> ⚠️ `main` Deploy Prod อัตโนมัติ — กด Merge = ขึ้น Prod ทันที · ห้ามติ๊ก "Merge when pipeline succeeds"
