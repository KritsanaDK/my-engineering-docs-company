# FX-02 — แผนแก้ Error ราย Service (Plan)

> **สถานะ:** 🟡 DRAFT — ปรับปรุง 2026-09-24 (หลังประเมินความเสี่ยงราย Repo)
> **เป้าหมาย:** Merge เข้า `main` โดยไม่พัง · Business บน Prod ไม่เปลี่ยน · Service ที่แก้ต้องไม่เพิ่ม Error บน Prod
> **การอนุมัติ:** งานบน UAT-ISV ทำได้เลย · ขึ้น Prod ต้องมี **รายงานการแก้ไข** ก่อนทุก Wave (คนเป็นผู้ Merge)

---

## 0. กติกา

1. ทุกการแก้ต้องโยงกลับได้กับ: **(ก)** Error ที่เกิดบน Prod · **(ข)** Spec / อีเมลของ คปภ. (03 ก.ย. 2569, 459 รายการ) · **(ค)** Ticket FX-01 / WS6–9 — อย่างอื่นให้ **เหมือน Prod**
2. Input ที่ Prod ทำงานได้วันนี้ → ผลต้องเหมือนเดิม · เปลี่ยนได้เฉพาะ "Error → ผลที่ถูกต้อง"
3. **1 Branch ต่อ 1 Repo:** `fix/fx-02-<service>` จาก `origin/main --no-track` · Branch เดิม (`fix/fx-01-*`, `hotfix/ws*`, `hotfix/oic`, `fix/oic-uam`) เป็นข้อมูลอ้างอิง ไม่เปิด MR
4. **1 Commit = 1 Ticket** · Ticket ที่รอคำตอบไว้ท้าย Branch (ตัดออกได้โดยไม่กระทบตัวอื่น)
5. ห้ามมีใน MR: `.sql` ใน Repo service, `helm-uat-isv.yaml`, `.gitlab-ci.yml`, script/load-test, ค่าทดสอบ (`1111111111119`, `CL004`, `"1.10"`, `'ป้ายแดง'`), โค้ดหลอกผลลัพธ์ (เช่น `7f0beed`)
6. การเปลี่ยนที่ต้องขึ้นคู่กันต้อง **รองรับทั้งเวอร์ชันเก่าและใหม่** (ลำดับ Deploy ผิดก็ไม่พัง)
7. ค่า Helm ของ Prod อยู่ใน `helm-prod.yaml` ของ MR เท่านั้น (ไม่ Patch มือ)

---

## 1. สภาพแวดล้อมทดสอบ = Prod (ต้องเสร็จก่อนทดสอบใดๆ)

> DB ของ UAT-ISV ปัจจุบัน **ใช้เป็นหลักฐานไม่ได้** (ต่างจาก Prod: function 3+39, คอลัมน์ 10, ตาราง 48, sequence 37, DEFAULT หลายคอลัมน์)
> Backup สถานะปัจจุบันไว้แล้ว: `07_fx02/backup_uatisv_20260924/` (schema ทั้งหมด + SHA ทุก Branch)

| # | งาน | ผู้ทำ | สถานะ |
|---|---|---|---|
| 1.1 | Backup จาก Prod (schema; ถ้ามีข้อมูลต้อง Mask PDPA) | เจ้าของ Prod | ⏳ รอ |
| 1.2 | Restore ลง **DB ใหม่** บน instance UAT-ISV (เช่น `insurverse_prodclone`) — ไม่แตะ DB เดิม | Claude + voranunb | ⏳ |
| 1.3 | Mask ข้อมูลส่วนบุคคล → ข้อมูลทดสอบ (Rule 4) · Reset sequence จาก MAX | Claude | ⏳ |
| 1.4 | ยืนยัน Fingerprint = Prod (ตาราง, คอลัมน์, DEFAULT, function, sequence, trigger, view) diff = 0 | Claude | ⏳ |
| 1.5 | ชี้ service ของ uat-isv ไป DB ใหม่ (หลังแจ้งทีม) · ตกลงวิธีจัดการ Branch `uat-isv` (ห้าม Force-push) | ทีม | ⏳ |

---

## 2. แผนราย Service

สัญลักษณ์ความเสี่ยง: 🔴 สูง · 🟠 ปานกลาง–สูง · 🟡 ปานกลาง · 🟢 ต่ำ · 🔁 = ใช้ Commit เดิมเป็นแนวทาง

### 2.1 go-echo-analytics-service — `fix/fx-02-analytics` 🟢
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #25 | Graceful drain เมื่อ SIGTERM + probe/preStop ใน `helm-prod.yaml` | 🔁 `d28bb6c`, `03_fixes/helm_patches/patch_analytics_prod.yaml` |

- **เสี่ยงเกิด Error จาก:** ค่า probe/preStop ผิด
- **ตรวจก่อน Merge:** endpoint ของ probe มีจริงบน main · `terminationGracePeriodSeconds` ≥ drain + shutdown · diff helm กับค่าปัจจุบันของ Prod
- **ทดสอบ:** ยิง `OPTIONS /analytics` ระหว่าง rollout → 503 = 0
- **วัดบน Prod:** 503 ระหว่าง rollout (log LB) · **Rollback:** Revert MR / `helm rollback`

### 2.2 isv-test — `fix/fx-02-isv-test` 🟢
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #15 | Short link: ใส่ User-Agent + แก้ URL (`//wp-json`) | 🔁 `92688d2` |

- **เสี่ยงเกิด Error จาก:** shortify ล่ม → ช้าลง 10 วินาที
- **ตรวจก่อน Merge:** ถ้า shortify ล้มเหลวต้อง Fallback เป็นลิงก์ยาว · timeout สั้นกว่าผู้เรียก
- **ทดสอบ:** สร้าง short link กับ shortify จริง + จำลอง shortify ล่ม
- **วัดบน Prod:** จำนวน short link ล้มเหลว

### 2.3 python-fastapi-document-service — `fix/fx-02-document` 🟡
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #6 | หาเอกสารสลักหลังไม่เจอเพราะ replica ตามไม่ทัน → Retry 3 ครั้ง (0.5/1/2 วินาที) | 🔁 `35c58b7` |

- **เสี่ยงเกิด Error จาก:** เวลาเพิ่มถึง 3.5 วินาที → ผู้เรียก timeout
- **ตรวจก่อน Merge:** timeout ของทุกตัวที่เรียกเอกสารสลักหลัง ≥ เวลาเดิม + 3.5 วินาที
- **ทดสอบ:** กรณีปกติผลเหมือน Prod · ⚠️ UAT-ISV ไม่มี replica → จำลอง "ไม่พบครั้งแรก" ด้วย unit test
- **วัดบน Prod:** จำนวน "no endorse found"

### 2.4 go-e-api — `fix/fx-02-e-api` 🟡
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #27 | Response ที่ไม่ใช่ JSON จาก ISV → คืน Error ที่อ่านได้ (status + ตัวอย่าง body) | 🔁 `374cbca` |

- **ไม่รวม:** `7f0beed` (ตอบ partner ว่าสำเร็จทั้งที่ purchase ไม่ได้รับ — โค้ดทดสอบ) · `patch_go_e_api_prod.yaml` (ทำให้ premium/purchase/uam 404)
- ⚠️ **ต้นเหตุ #27 (ISV_HOST วิ่งผ่าน LB สาธารณะ) ยังไม่แก้ในรอบนี้** → HTML 503 เดิมยังเกิดได้ แค่ Log อ่านออก · แยกเป็นงานสืบต้นเหตุ
- **ทดสอบ:** API เบี้ย/ชำระเงินของ partner กรณีปกติเหมือน Prod · กรณี ISV ตอบ HTML → ได้ Error JSON
- **วัดบน Prod:** response ที่ไม่ใช่ JSON ต่อ partner

### 2.5 go-oauth2-server — `fix/fx-02-oauth2` 🟠
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #24 | Graceful drain 10 วินาที + shutdown timeout 15 วินาที · memory 128Mi/256Mi, cpu 200m, probe 15s/threshold 5 ใน `helm-prod.yaml` | 🔁 `bc47a8e`, `patch_oauth2_prod.yaml` |

- **เสี่ยงเกิด Error จาก:** helm ผิด → CrashLoop/OOM → **partner/API ทุกตัวขอ token ไม่ได้**
- **ตรวจก่อน Merge:** diff helm กับค่าปัจจุบันของ Prod · memory ไม่ต่ำกว่าที่ใช้อยู่ · endpoint probe มีจริง · เตรียมคำสั่ง `helm rollback`
- **ทดสอบ:** ยิง `POST /services/oauth/v2/token` ต่อเนื่องระหว่าง rollout → 503 = 0
- **วัดบน Prod:** token error rate, restart count

### 2.6 go-echo-notification-service — `fix/fx-02-notification` 🟠
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #4 | `GetNotiPolicyExpire` ทำงานแบบ async (แก้ timeout 30 วินาทีที่ GCP LB) | 🔁 `ae17af1` |
| WS9-01 | Header SMTP: `Reply-To`, `Message-ID`, `MIME-Version`, `X-Priority` | 🔁 `d4d9d0e` |

- **เสี่ยงเกิด Error จาก:** แก้จุดชนกับ main ใน `notificationController.go` ผิด · อีเมลไม่ออก · job ถูกข้ามถ้าเรียกซ้ำระหว่างทำงาน
- **ตรวจก่อน Merge:** review จุดชนทีละบรรทัด · scheduler ไม่ได้ใช้ `notifications_found`
- **ทดสอบ:** ส่งอีเมลจริงไป Gmail/Outlook (ดู header + ไม่ตก junk) · เรียก noti expire → ไม่ timeout
- **วัดบน Prod:** จำนวนอีเมลที่ส่งต่อชั่วโมงไม่ลดลง · 504 ของ noti expire

### 2.7 go-echo-purchase-service — `fix/fx-02-purchase` 🔴
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| sf_account | `sf_account` เป็น NULL → ไม่ 500 ใน SF_PAYMENT upsert | 🔁 `0ba98a7` |

- **ไม่รวม:** `85c3261` (ตรวจ JWT 2C2P — แยกเป็นงานความปลอดภัย), `75d8a39` (`FAILED`), WS5 invoice (เลื่อนรอบหน้า)
- **เสี่ยงเกิด Error จาก:** อยู่ในเส้นทางจ่ายเงิน → ออกกรมธรรม์ · เปลี่ยนชนิดข้อมูลใน `LeadCoveragePremiumEntity.go` เป็น nullable อาจกระทบจุดอื่น · SF อาจปฏิเสธ `accountID:""`
- **ตรวจก่อน Merge:** ทุกจุดที่ใช้ field ที่เปลี่ยนชนิด · SF upsert กับค่า `""`
- **ทดสอบ:** จ่ายเงินครบ flow ผ่าน 2C2P Sandbox (MV, MC, MV+MC) + lead ที่ `sf_account` เป็น NULL
- **Deploy:** ช่วงคนใช้น้อย · เฝ้า callback + การออกกรมธรรม์ชั่วโมงแรก
- **วัดบน Prod:** 500 ใน callback, จำนวนกรมธรรม์ที่ออกต่อชั่วโมง, SF sync error

### 2.8 nodejs-express-premium-service — `fix/fx-02-premium` 🔴
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #13 | Lead_No จาก `seq_lead_no` (DEFAULT + `RETURNING`) + **ลองใหม่ 1 ครั้งเมื่อเจอ 23505** | 🔁 `7e03e85` |
| OIC 2SYS0006 / 2SYS0010 | ตัดความยาวรหัสประเภทรถ 5, เลขบัตร 20 (ไม่ตัดเหลือ 13, ไม่ Fallback `"1.10"`) | 🔁 `e4a06b7` (บางส่วน) |
| WS6 | `prem_version` ใน Response ไม่เป็น null | 🔁 `2f0464b` ⏳ ยืนยันว่าเป็น Error |

- **เงื่อนไข:** Job 04 (`seq_lead_no`) ต้องรันบน Prod ก่อน Merge
- **เสี่ยงเกิด Error จาก (Sequence — เคยพังมาแล้ว 2 ก.ย.):**
  - ช่วง rolling deploy: Pod เก่า `MAX+1` ชนกับ Pod ใหม่ `nextval` (23505) → แก้ด้วยลองใหม่ + deploy ช่วงคนใช้น้อย + รัน `03_post_deploy_verify` ทันที
  - ตัวออกเลขตัวที่ 2 (`renewal-reprice.service.js` บน `dev`) → ห้ามมี `MAX("Lead_No")` บน main (สคริปต์ตรวจ)
- **ไม่รวม:** Joi บังคับ field เพิ่ม, `fd5709b`, `d031a3f`, `d44b772`
- **ทดสอบ:** Job 04 **บน DB ที่เหมือน Prod** (ยังไม่มี sequence) · สร้าง Motor Lead พร้อมกัน 50 รายการไม่ซ้ำ · response เหมือน Prod
- **วัดบน Prod:** 23505 ของ `Lead_coverage_premium`, error ตอนสร้าง lead

### 2.9 go-echo-lead-policy-service — `fix/fx-02-lead-policy` 🟡
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| FX-01 #17 | Non-JSON guard + `EMAIL_URL` ผ่าน Internal DNS ใน `helm-prod.yaml` | 🔁 `e7a7fbf`, `patch_lead_policy_prod.yaml` |
| OIC 2BUS0004 (สลักหลัง) | `contract_dt = LEAST(create_at, effective_date)` | 🔁 `c6a9363` |
| OIC 2BUS0215 / 2BUS0017 | Join สลักหลังด้วย `Policy_No` + ไม่ส่งเมื่อไม่มีเลขอ้างอิง | 🔁 `1ff3745`, `c6a9363` |
| — | Keycloak nil guard | 🔁 `1ff3745` (`utils/keycloak.go`) |

- **ไม่รวม:** `scripts/resubmit_batch.go`
- **ทดสอบ:** Payload CMI สลักหลังเทียบกับ Prod · ทุก Error code ที่เกี่ยวข้อง · ส่งอีเมลแนบ PDF ใหญ่

### 2.10 go-fiber-policy-service — `fix/fx-02-fiber-policy` 🟠
| Ticket | สิ่งที่แก้ | อ้างอิง |
|---|---|---|
| OIC 1SYS0007/0008/0009/0011/0013, 2SYS0006/0010/0011 | ตัดความยาวตาม Spec (ไม่ Trim, ไม่เปลี่ยน NULL→`""`) · สีว่าง → `Car_color` · จังหวัด: regex เฉพาะเมื่อ CAST ไม่ได้ (ไม่มี `OR`) | 🔁 `66552b6`…`9063c5c`, `0618cbb`, `31dc95b` |
| OIC 2BUS0004 | `contractDt ≤ effectiveDt` | 🔁 `42f4058` |
| OIC | `LEFT JOIN company_detail` + 2046 เมื่อไม่พบ | 🔁 `0618cbb` |

- **ไม่รวม:** เปลี่ยน Broker License ของ Non-TQM (Prod ใช้ `ว00019/2546` และผ่าน)
- **ทดสอบ:** Payload CMI record เดียวกันเหมือน Prod ทุก byte · record ที่เคย fail ผ่าน

### 2.11 go-echo-uam-service — `fix/fx-02-uam` 🔴 (ใหญ่สุด)
| # | Ticket | สิ่งที่แก้ | อ้างอิง | สถานะ |
|---|---|---|---|---|
| 1 | FX-01 #16 | Notification ผ่าน Internal DNS (`helm-prod.yaml`) + แก้ loop / body leak / timeout | 🔁 `3c0d2ed` | ✅ |
| 2 | FX-01 #23 | OCR ล้มเหลวไม่ตอบ 500 เปล่า | 🔁 `3c0d2ed` | ✅ |
| 3 | OIC 1SYS/2SYS | ตัดความยาว, สี, จังหวัด (แบบ fiber #1) | 🔁 `62e21e2`, `0015a7a`, `d4bb9b3` | ✅ |
| 4 | OIC 2BUS0004 | `contractDt ≤ effectiveDt` | 🔁 `a53d255`, `7758378` | ✅ |
| 5 | OIC 2BUS0227 | ไม่มีเลขอ้างอิง → ไม่ส่ง field สลักหลัง (EndorseFlag คง `N`) | 🔁 `a9531df` | ✅ |
| 6 | OIC 2SYS0019 | TQM → `ว00019/2546` · Non-TQM คง `regist_id` | 🔁 `0e755f7` | ✅ |
| 7 | Auto-register | อีเมลเดิม 500 → **200 `{is_new_account:false}`** · ใหม่ 200 `{is_new_account:true}` | 🔁 `aeff2e3` / `206ccc4` (เลือกตัวเดียว) | ✅ **หลัง nextjs #4** |
| 8 | WS6-04 | เบอร์ผู้ซื้อขึ้น SF: `COALESCE("Owner_phone", phone)` | 🔁 `b660737` (เฉพาะ phone) | ✅ |
| 9 | WS9 | DB pool ผ่าน env, default = ค่า Prod (80/10/1h/30m) | 🔁 `f71b25d` (dbConnect) | ✅ |
| 10 | WS6-02 | เวลาสลักหลังบน SF +7 ชม. — หาจุดที่ส่งเวลา (ไม่มีโค้ดเรียก `fn_format_utc_timestamp_th`) | — | ⏳ |
| 11 | WS7-04 | อาชีพ Read-only ตอนต่ออายุ | 🔁 `0043379` | ⏳ |
| 12 | WS8-03 | กรองหมดอายุ **เฉพาะ Query หน้า Active Policies** (ห้ามแตะ cross-check วันคุ้มครอง) | ❌ ไม่ใช้ `28a38b6` | ⏳ |
| 13 | WS9-02 | Reconcile Report + **ต้องมี Auth** (ตอนนี้เรียกได้โดยไม่ login และมีข้อมูลส่วนบุคคล) | 🔁 `f71b25d` | ⏳ |
| 14 | WS6 cancel | สลักหลังยกเลิกแล้ว SF ยัง Active — ตั้งสถานะด้วยค่าที่ระบบรู้จัก (ห้าม `'C'` / `no_cancel_flag`) | — | ⏳ Business |

- **ไม่รวม:** `dfee0a5` (SSO auto-link), `/login` 401, SF upsert non-200 → error, `EndorseFlag X/U`, `28a38b6`
- **ทดสอบ:** Payload CMI เหมือน Prod · ทุก Error code ของ คปภ. · login/OCR/SF ผลเหมือน Prod · auto-register ทั้งอีเมลใหม่/เดิม

### 2.12 nextjs-webapp — `fix/fx-02-nextjs-webapp` 🟠
| # | Ticket | สิ่งที่แก้ | อ้างอิง | สถานะ |
|---|---|---|---|---|
| 1 | OIC 2BUS0216 | Regex ทะเบียนตามมาตรฐานกรมการขนส่งทางบก (ต้องรับรูปแบบที่ Prod รับได้และ ขบ. อนุญาต) | 🔁 `e3c8a9c2` (แก้ regex ใหม่) | ⏳ Spec ขบ. |
| 2 | OIC 2BUS0018 | ป้ายแดง → `'ใหม่'` · ไม่มีทะเบียน → `'ไม่มีทะเบียน'` | 🔁 `19317d2e` (แก้ค่า) | ✅ |
| 3 | OIC 1SYS0008/0009, 2SYS0011, 1SYS0013 | จำกัดความยาวที่ Form ตาม Spec | 🔁 `5e92cadc`, `9df8b46b` | ✅ |
| 4 | Auto-register | Popup เมื่อ `status===200 && result?.is_new_account !== false` ทุกจุดที่ใช้ `useCreateAccountMutation` | 🔁 `3ddd4c5f`, `7a7824d6`, `679b4fd9` | ✅ **ก่อน uam #7** |

- **ไม่รวม:** redirect 308→301, ตัด `partner_code`

### 2.13 DB (เจ้าของ DB รัน — Pack ตาม Rule 5)
| งาน | ไฟล์ | ก่อน |
|---|---|---|
| FX-01 #13 `seq_lead_no` | `04_motor_lead_seq/sql/00→03`, `99_rollback` | premium |
| ล็อก `to_car_act`, `quatationno` | `isv-bible/.database/migrations/2026-09-14-mc-and-quotation-allocator-locks.sql` | แยกได้ |
| WS7 (ER007, คัดลอกผู้ขับขี่) | บน Body ของ Prod `fn_policy_renewal` เท่านั้น | ⏳ voranunb |

### ไม่มีงานในรอบนี้
- **go-echo-backoffice-service** — ปัญหา promo export แก้บน main แล้ว (`7dc32eb` เป็นฟีเจอร์ใหม่)
- **node_iia_service** — ผลรวมเป็น 0 (revert แล้ว)

---

## 3. ด่านตรวจก่อนทดสอบ / ก่อน Merge (ทุก Repo)

| ด่าน | รายละเอียด |
|---|---|
| Guard script | บล็อก MR ที่มีไฟล์/ค่าต้องห้าม (กติกาข้อ 5) และ `MAX("Lead_No")` |
| Diff review | อ่าน `git diff origin/main..fix/fx-02-<svc>` ทีละบรรทัด ทุก hunk ต้องอยู่ในตารางข้อ 2 |
| Fingerprint | UAT-ISV (DB ใหม่) = Prod ก่อน E2E และก่อน Merge |
| E2E | ผลเหมือน Prod · ทุก Error code ของ คปภ. · Edge cases (จ่ายไม่สำเร็จ, อีเมลเดิม/SSO, พาสปอร์ต, ทะเบียนแบบต่างๆ, ป้ายแดง/ไม่มีทะเบียน, ลูกค้ามี พ.ร.บ. หมดอายุ, Partner/Manual payment, purchase ล่ม) · Citizen ID `1111111111119` · จ่ายผ่าน 2C2P Sandbox |
| Replay | ยิงซ้ำ Payload จริงจาก Log ของ Prod แล้ว diff (เมื่อได้ Log) |
| Pre-flight บน Prod | อ่านอย่างเดียว: env/secret/helm ที่ต้องใช้มีครบ · sequence ≥ MAX ทุกตาราง · คอลัมน์ที่พึ่ง DEFAULT มี DEFAULT |
| Review | คนที่สองตรวจ (voranunb สำหรับ DB/renewal, ผู้ดูแล คปภ. สำหรับ CMI) |
| รายงาน | รายงานการแก้ไขสำหรับขึ้น Prod ต่อ Wave |

---

## 4. ลำดับขึ้น Prod (เสี่ยงน้อยก่อน · ขั้นละ 1–2 Repo · เว้นดูผลทุกขั้น)

| ขั้น | Repo | เสี่ยง | เงื่อนไขก่อน Merge |
|---|---|---|---|
| 1 | analytics | 🟢 | helm-prod |
| 2 | isv-test | 🟢 | — |
| 3 | document | 🟡 | timeout ของผู้เรียก |
| 4 | go-e-api | 🟡 | — |
| 5 | oauth2 | 🟠 | helm diff กับ Prod, คำสั่ง rollback พร้อม |
| 6 | notification | 🟠 | ทดสอบอีเมลจริง |
| 7 | purchase | 🔴 | ช่วงคนใช้น้อย, เฝ้า callback |
| 8 | premium + Job 04 | 🔴 | Job 04 บน Prod ก่อน, ช่วงคนใช้น้อย |
| 9 | lead-policy | 🟡 | helm-prod (#17) |
| 10 | fiber-policy | 🟠 | Spec คปภ. ตรวจแล้ว |
| 11 | nextjs-webapp | 🟠 | ก่อน uam (auto-register) |
| 12 | uam | 🔴 | หลัง nextjs · เฉพาะ Ticket ที่พร้อม |
| ภายหลัง | ล็อก DB, WS7 renewal, Ticket ⏳, แก้ข้อมูล 459 รายการ + Resubmit CMI (ทดสอบกับ UAT ของ คปภ. ก่อน, ส่งทีละชุด) | | |

**เว้นดูผลระหว่างขั้น:** อย่างน้อย 30 นาที (Repo 🔴 แนะนำ 1 วันทำการ)
**Rollback ทันทีเมื่อ:** 5xx เพิ่ม > 2 เท่า · มี Error ชนิดใหม่ · CMI error code ใหม่ · 23505 เพิ่มขึ้น · อีเมล/กรมธรรม์ต่อชั่วโมงลดลง
**วิธี Rollback:** Revert MR / `helm rollback` · DB ใช้ Backup จาก Prod (Rule 3) หลัง rollback โค้ดแล้ว

---

## 5. รอข้อมูล

1. Backup Prod (schema หรือมีข้อมูล?) · สิทธิ์สร้าง DB ใหม่บน UAT-ISV / เปลี่ยน `DB_NAME`
2. ทีม: วิธีจัดการ Branch `uat-isv`
3. Ticket ต้นฉบับ WS6–9
4. Business: สถานะสลักหลังยกเลิก (WS6), WS7-04, WS9-02 ยังต้องการไหม, ยอมรับ Lead_No ข้ามเลข
5. Spec คปภ. (PDF — ติดตั้ง `poppler` เพื่ออ่าน) + มาตรฐานทะเบียน ขบ. · ยืนยันค่า `'ใหม่'` / `'ไม่มีทะเบียน'`
6. voranunb: WS7 ทำบน Body Prod หรือรอฟีเจอร์ renewal · Pgpool/replica บน Prod
