# lead-policy FX-02 — การพิสูจน์ว่า SQL สลักหลัง CMI แก้ถูก (อ่านอย่างเดียว)

`diff_endorse_cmi_old_vs_new.sql` รัน query ของ `GetDataForEndorseCMI` ทั้ง **เวอร์ชัน main (Prod)** และ **เวอร์ชัน fix/fx-02-lead-policy**
กับสลักหลังทุกรายการใน DB (ตัด `= $1` เป็น `is not null` และตัด `limit 1`) แล้วเทียบผลทีละแถว — ไม่มีการเขียน DB

รัน (read-only บังคับด้วย `default_transaction_read_only=on`):
```bash
PGPASSWORD=... psql "host=<db> user=<user> dbname=insurverse options=-cdefault_transaction_read_only=on" -At -F' | ' -f diff_endorse_cmi_old_vs_new.sql
```

## ผลบน UAT (2026-09-24, 6,035 สลักหลัง)
| ตรวจ | ผล |
|---|---|
| สลักหลังที่ query เดิมหาเจอ | 1,294 |
| ได้ payload **เหมือนเดิมทุก field** | **1,282** |
| ต่างกัน **เฉพาะ `contract_dt`** | 12 — ตรงกับ 12 รายการที่ `contract_dt > effective_dt` (2BUS0004) พอดี, ค่าใหม่น้อยกว่าเดิมทุกรายการ |
| สลักหลังที่เดิมหาไม่เจอ แต่ตอนนี้เจอผ่าน `Policy_No` | 1,020 (2BUS0215) |
| สลักหลังที่ได้มากกว่า 1 แถว | 0 (ทั้งเก่าและใหม่) |
| query ใหม่มี `contract_dt > effective_dt` | 0 |
| ไม่มี reference/receive no → ตอบ 400 แทนส่ง CMI | 66 (32 รายการเดิมถูกส่งไป CMI และถูกปฏิเสธ) |

## Pre-flight บน Prod (คนที่มีสิทธิ์ Prod รัน)
รันไฟล์เดียวกันแบบ read-only บน Prod — ผ่านเมื่อ: `only in old` = จำนวน `old: contract_dt > endorse_effective_dt` และทุกแถวที่ต่างต่างเฉพาะ `contract_dt`, `endorses with >1 row` = 0

## ยังไม่ได้ทดสอบ (2026-09-24)
| Ticket | สิ่งที่ยังไม่ได้ทดสอบ | เหตุผล | ต้องการ |
|---|---|---|---|
| FX-01 #17 | E2E: ส่งอีเมลผ่าน lead-policy → `EMAIL_URL` ในคลัสเตอร์ (reset password / endorse email แนบ PDF ใหญ่) | ทุก endpoint ต้องใช้ token backoffice (Keycloak) และ UAT-ISV ไม่มีข้อมูลสลักหลัง | bearer token backoffice ที่มี `EDIT_PASSWORD_PERMISSION` (+ `RESEND_ENDORSE_PERMISSION`) |
| Keycloak nil guard | กรณี KCClient เป็น nil จริง | ต้องทำให้ Keycloak ต่อไม่ได้ตอน start บน UAT-ISV ที่ใช้ร่วมกัน | — (ยืนยันด้วย code review: ผู้เรียก 5 จุดเช็ค error) |

ทดสอบแล้ว: unit test `TestHTTP`/`TestBadRequest` ผ่าน · deploy `:354` ready 2/2, restart 0, ไม่มี panic · endpoint ตอบ 401 JSON เมื่อไม่มี token
