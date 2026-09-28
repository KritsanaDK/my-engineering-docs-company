# FX-02 — รายงานการแก้ไข (Change Report) / Change report

**วันที่:** 2026-09-24 · **ผู้เตรียม:** Claude (ร่วมกับ kritsana.w.os) · **สถานะ:** ทดสอบบน UAT-ISV แล้ว — รอ review / merge โดยคน
**หลักการ:** Business บน Prod ไม่เปลี่ยน · ทุกการแก้โยงกับ Error บน Prod / Spec คปภ. / Ticket · ไม่แก้ DB · ไม่ใส่ค่า default ปลอม · ไม่ตัดค่าเงียบๆ
**Branch:** `fix/fx-02-<service>` จาก `origin/main` (`--no-track`) · 1 commit = 1 ticket · ทดสอบบน `uat-isv` = main + fix-02 เท่านั้น
**หลักฐานการทดสอบ:** `deploy_jobs/07_fx02/tests/<service>/`

## สรุปราย Repo

| ลำดับขึ้น Prod | Repo | Branch / commits | Ticket | ผลต่อ Prod | หลักฐาน |
|---|---|---|---|---|---|
| 1 | go-echo-analytics-service | `fix/fx-02-analytics` `ae1923f` | FX-01 #25 | ระหว่าง rollout ไม่มี 503 (drain 10s + shutdown 15s) | rollout restart: 503 = 0 |
| 2 | isv-test | `fix/fx-02-isv-test` `2bdc433` | FX-01 #15 | short link ส่ง User-Agent + endpoint ไม่มี `//wp-json` | 4 ลิงก์ redirect ถูก · ⚠️ ยังไม่มีหลักฐาน WAF บน Prod |
| 3 | python-fastapi-document-service | `fix/fx-02-document` `3e49a39` | FX-01 #6 | หาเอกสารสลักหลังไม่เจอ → retry 3 ครั้ง (สูงสุด +3.5s) | unit 4 กรณี + UAT-ISV retry log |
| 4 | go-e-api | `fix/fx-02-e-api` `e1d944a` | FX-01 #27 | ISV ตอบไม่ใช่ JSON → error มี status/URL/snippet | unit + API อ่านอย่างเดียว 6 ตัวผ่าน |
| 5 | go-oauth2-server | `fix/fx-02-oauth2` `9e1a5cc` | FX-01 #24 | ระหว่าง rollout ไม่มี 503 (drain) · helm-prod ไม่แก้ | rollout restart: 214 req 503 = 0 |
| 6 | go-echo-notification-service | `fix/fx-02-notification` `3fafeb4` `7828632` | FX-01 #4, WS9-01 | `get_noti_policy_expire` ตอบทันที (query+ส่ง background, budget 10 นาทีเท่า Prod) · header Reply-To/Message-ID/MIME-Version/X-Priority | อีเมลเข้า Inbox · #4 ยังไม่ยิงจริง |
| 7 | nodejs-express-premium-service | `fix/fx-02-premium` `e208625` | FX-01 #13 | Lead_No: `RETURNING` + retry 23505 (ไม่แก้ DB, ไม่ใช้ Job 04) · แก้ปัญหาได้ Lead_No ของคนอื่น | baseline main 20/50 · fix 3×20 = 60/60, stress 50/50 |
| 8 | go-echo-lead-policy-service | `fix/fx-02-lead-policy` 4 commits | FX-01 #17, OIC 2BUS0004/0215/0017, Keycloak | ดูรายละเอียดด้านล่าง · helm-prod `EMAIL_URL` ภายในคลัสเตอร์ | differential UAT: 1,282 เหมือนเดิม, 12 แก้ contract_dt, 1,020 หาเจอเพิ่ม |
| 9 | go-fiber-policy-service | `fix/fx-02-fiber-policy` `286e989` | OIC 1SYS0007/08/09 | ตรวจ 7 ฟิลด์ก่อนส่ง CMI — ไม่ผ่านไม่ส่ง, แจ้ง TQM data problem | unit 16 + differential: บล็อก 62/6,879 |
| 10 | nextjs-webapp | `fix/fx-02-nextjs-webapp` `3398b4a3` | Auto-register (ก่อน uam #7) | popup "สร้างบัญชี" เฉพาะบัญชีใหม่ (รองรับ uam เก่า/ใหม่) | checklist หน้าเว็บ (ทดสอบโดยผู้ใช้) |
| 11 | go-echo-uam-service | `fix/fx-02-uam` 9 commits | FX-01 #16 #23, OIC 2BUS0004/0227, 2SYS0019, 1SYS, Auto-register, WS6-04, WS9 | ดูรายละเอียดด้านล่าง · helm-prod `Backend_Notification` ภายในคลัสเตอร์ | differential UAT + unit |
| 12 | go-echo-purchase-service | `fix/fx-02-purchase` | Auto-register ผู้ซื้อไม่มีบัญชี (sf_account NULL), nil-safe SF, LEFT JOIN, COALESCE ข้อมูลรถ | ผู้ซื้อไม่มีบัญชีได้บัญชี + SF Account อัตโนมัติ (ได้อีเมลบัญชี) · **ไม่ตรวจลายเซ็น callback (revert — ดูด้านล่าง)** | unit 7 + E2E ไม่มีบัญชี 2 เคส + regression 1 ✅ |

### lead-policy (4 commits)
- `d71563e` FX-01 #17: non-JSON response → error อ่านได้ · helm-prod `EMAIL_URL=http://backend-notification-service:8080/...`
- `2812ab7` 2BUS0004: สลักหลัง `contract_dt` = วันที่น้อยกว่าระหว่าง create_at / effective_date
- `9ea3bf0` 2BUS0215/0017: JOIN ด้วย `Policy_No` เฉพาะเมื่อ `Car_Act_No` ว่าง · ไม่มีเลขอ้างอิงกรมธรรม์หลัก → 400 ไม่ส่ง CMI
- `5613148` Keycloak nil → error (ไม่ panic)

### uam (9 commits)
- `09893e7` WS9 DB pool จาก env (default = Prod 80/10/1h/30m)
- `a16d860` FX-01 #23 OCR passport: ไม่ panic, ตอบ 500 พร้อมข้อความ (คง 500 ให้เว็บเข้า onError)
- `40258c3` FX-01 #16 notification: timeout 30s, ปิด body, ไม่ panic เมื่อเรียกไม่ได้ · helm-prod ภายในคลัสเตอร์
- `21a1d6f` 2BUS0004: สลักหลัง contractDt ≤ effectiveDt (156/1,294 เปลี่ยนเฉพาะ contractDt)
- `9f1ef4e` 2SYS0019: q1 TQM → `ว00019/2546` (1,753 แถวของ TQM เท่านั้น)
- `919048f` 2BUS0227: สลักหลังที่กรมธรรม์หลักยังไม่มีเลขอ้างอิง → ไม่ส่ง (29/1,294)
- `c6e3883` 1SYS: ตรวจ 7 ฟิลด์ก่อนส่ง CMI (62/6,879)
- `aa7cf16` Auto-register: อีเมลเดิม 200 `{is_new_account:false}` แทน 500 · ⚠️ partner `/user/isvregisterauto` (go-e-api) จะได้ 200 แทน 500
- `b57e692` WS6-04: เบอร์ผู้ซื้อไป SF เมื่อเบอร์ผู้เอาประกันว่าง (215/9,264)

### purchase (4 commits)
- ~~`6d7586e` ตรวจลายเซ็น JWT ของ callback 2C2P~~ → **revert `7719ca2`** (ดู "Prod-risk review")
- `1a03301` nil-safe `sf_account` / เลข พ.ร.บ. ใน SF payment (จาก 059c275)
- `6e1648d` `LEFT JOIN sec_user` ตอนส่ง payment พ.ร.บ. เข้า SF (บางส่วนของ 75d8a39 — ไม่เอาสถานะ FAILED)
- `a3f9f63` ผู้ซื้อไม่มีบัญชี → สมัครอัตโนมัติผ่าน uam `registeraccount_email_auto` ก่อนหา SF Account
- `1355b65` COALESCE ข้อมูลรถใน callback (NULL ไม่ทำให้ callback หยุดหลังจ่ายเงินแล้ว)

## ไม่รวมในรอบนี้
- **uam ticket 10–14** (WS6-02, WS7-04, WS8-03, WS9-02, WS6 cancel — `'C'` ไม่มีจริง ใช้ `INC`)
- **nextjs** 2BUS0216 (รอ spec ขบ.), 2BUS0018 (ต้องมีหลักฐาน), form length (Prod validate เข้มกว่าแล้ว)
- **premium** 2SYS0006/0010 (`1.10.2Y` = ข้อมูลผิด → แก้ข้อมูล), WS6 prem_version (ไม่มีหลักฐาน error)
- **DB**: ไม่มี DDL/DML บน Prod · Job 04 ไม่ใช้ · lock ของ to_car_act/quatationno แยกงาน · WS7 renewal รอ voranunb
- ที่ตัดทิ้งจาก uat-isv: fallback ปลอม (`1111111111119`, `1.10`, `CL004`, จังหวัด `'10'`), การตัดค่า, `7f0beed`, `0656ae8`, `90dc31f`, `69fe7ff`, `dfee0a5`, ไฟล์ `.sql`/script ใน repo service

## Pre-flight บน Prod (คนที่มีสิทธิ์ — อ่านอย่างเดียว)
1. Service `backend-notification-service:8080` อยู่ namespace เดียวกับ lead-policy และ uam
2. `tests/lead-policy/diff_endorse_cmi_old_vs_new.sql`, `tests/fiber-policy/validator_preflight.sql`, `tests/uam/*.sql` — ผลต้องเป็นรูปแบบเดียวกับ UAT
3. `tests/fiber-policy/data_fix_candidates.sql` — รายการที่ต้องแก้ข้อมูล + resubmit CMI
4. ค่า helm ที่เคย patch มือบน Prod (03_fixes) — `helm get values` เทียบกับ helm-prod.yaml ก่อน merge

## Rollback
Revert MR / `helm rollback <release>` — ไม่มีการแก้ DB จึงไม่ต้อง rollback DB

## Prod-risk review (2026-09-25) — ทุก `fix/fx-02-*`
Build ผ่าน 10 repo Go · unit test ไม่มี fail เพิ่มจาก main · SQL ที่เปลี่ยน 10 query PREPARE ผ่านบน UAT + UAT-ISV · helm-prod เปลี่ยนแค่ URL notification ภายในคลัสเตอร์ (6 service บน Prod ใช้อยู่แล้ว)

| ระดับ | Repo | เรื่อง | ผล |
|---|---|---|---|
| BLOCKER | purchase | ตรวจลายเซ็น callback: go-e-api `/payment/success` (partner EXMS) และ internal-service (backoffice) เซ็นด้วยคีย์ sandbox บน Prod ≠ คีย์ merchant ของ purchase → จะได้ 400 ทั้งหมด | **revert `7719ca2`** · งานต่อ: ให้ 2 service ใช้คีย์เดียวกันก่อนเปิดตรวจ · pre-flight `tests/purchase/prod_check_callback_signers.md` |
| HIGH | purchase | auto-register: partner ที่ส่งอีเมลกลาง/ปลอม → หลายคนได้บัญชีเดียวกัน | **รอตัดสินใจ** (คงไว้ / จำกัดเฉพาะเว็บ) |
| MEDIUM | notification | header MIME-Version ซ้ำ | แก้ `1ef8cd1` |
| MEDIUM | lead-policy | Policy_No ว่าง → หยิบกรมธรรม์คนอื่น · NULL เลข CMI → 500 | แก้ `bf42740` |
| MEDIUM | uam + nextjs | **ลำดับ deploy: nextjs-webapp ก่อนหรือพร้อม uam** | Prod pack |
| MEDIUM | uam + go-e-api | partner `/user/isvregisterauto` อีเมลเดิมได้ 200 แทน 500 | แจ้ง partner |
| LOW | purchase | NULL ข้อมูลรถ → 500 (UAT 0/19,305) | แก้ `1355b65` |
| LOW | uam | comment timeout ไม่ตรง | แก้ `bd3f986` |

## Prod-risk review รอบ 2 (2026-09-25) — วิธีต่างจากรอบ 1: ไล่ผู้เรียกทุก repo + config Prod vs UAT-ISV + adversarial review 2 ชุด
Build + unit test รอบ 2: ไม่มี fail เพิ่มจาก main · E2E รอบ 2 บน UAT-ISV ผ่าน 15 เคส (`tests/e2e/RESULTS_2026-09-25.md`)

| ระดับ | Repo | เรื่อง | ผล |
|---|---|---|---|
| HIGH | purchase | auto-register เทียบอีเมล case-sensitive → uam branch ซ้ำเขียนทับ `mobile` ของลูกค้าเดิม | แก้ `d2e2fec` (exact ก่อน แล้ว lower(); ส่งอีเมลตัวเล็กให้ uam; timeout 10s) · unit 2 เคสใหม่ |
| HIGH | lead-policy | Policy_No fallback จับได้แต่สลักหลังภาคสมัครใจ (UAT: 1,020 แถว v1_/v5_, v0_ ที่ไม่มี Car_Act_No = 0) → จะส่ง คปภ. ผิดประเภท | แก้ `4db34f2` เอา fallback ออก (join เหมือน Prod) |
| HIGH | purchase | auto-register รวมลูกค้า partner (อีเมลกลาง → บัญชีร่วม) | **รอตัดสินใจ** |
| MEDIUM | uam | สลักหลัง TQM ที่ `contract_date` = '' → ส่ง contractDt `00010101` (เป็นบน main อยู่แล้ว) | **รอตัดสินใจ** — นับบน Prod ก่อน |
| MEDIUM | uam + fiber | ตัวตรวจ 7 field อาจกันรายการที่ คปภ. เคยรับ (UAT-ISV: 0/21) | pre-flight บน Prod |
| LOW | purchase | ส่ง `accountID` ว่างเข้า SF upsertpayment | ถามทีม SF |

### ลำดับ deploy Prod และสิ่งที่ต้องแจ้ง
1. **nextjs-webapp ก่อนหรือพร้อม uam** (auto-register 200 + is_new_account)
2. fiber-policy กับ uam พร้อมกัน (กติกา 7 field เดียวกัน)
3. แจ้ง partner: `/user/isvregisterauto` อีเมลเดิมได้ 200 แทน 500
4. pre-flight ก่อน merge: `tests/purchase/prod_check_callback_signers.md`, `tests/fiber-policy/validator_preflight.sql`, `tests/uam/*.sql`, `kubectl get svc backend-notification-service -n <ns ของ lead-policy/uam>`
