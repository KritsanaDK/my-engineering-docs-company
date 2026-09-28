# 📸 Deploy Functions จาก UAT-ISV — 2026-09-23

> **ที่มา:** DB `insurverse` บน UAT-ISV ซึ่งผ่าน E2E แล้ว — export แบบอ่านอย่างเดียวด้วย `pg_get_functiondef()` (โครงสร้างเท่านั้น ไม่มีข้อมูล)
> **ขอบเขต:** เฉพาะ function ที่เกี่ยวกับรอบ Deploy นี้ (11 ตัว / 12 ไฟล์) — ใช้แทน SQL ใน `01_oic/sql` และ `02_ws6_9/sql` ที่ใช้ไม่ได้
> **Job 04 (#13, sequence) อยู่ที่ `04_motor_lead_seq/`** ไม่ได้อยู่ในโฟลเดอร์นี้

## Function ที่อยู่ในชุดนี้

| ไฟล์ | Signature | ทำไมอยู่ในชุด |
| :--- | :--- | :--- |
| `fn_lead_to_car_act__bigint.sql` | `fn_lead_to_car_act(lead_no bigint)` | WS1 ออกเลข พ.ร.บ. (advisory lock) |
| `fn_lead_to_car_act__integer.sql` | `fn_lead_to_car_act(lead_no integer)` | overload ตัวห่อของตัวบน |
| `fn_policy_to_car_act.sql` | `fn_policy_to_car_act(policy_no text)` | WS1 (advisory lock) |
| `fn_policy_barcode.sql` | `fn_policy_barcode()` | ถูกเรียกโดย `fn_policy_to_car_act` |
| `fn_policy_invoiceno_iia.sql` | `fn_policy_invoiceno_iia()` | WS5 เลข Invoice (advisory lock) |
| `fn_policy_quatationno_iia.sql` | `fn_policy_quatationno_iia()` | WS5 เลขใบเสนอราคา (advisory lock) |
| `fn_policy_book_iia.sql` | `fn_policy_book_iia()` | ถูกเรียกโดย `fn_policy_invoiceno_iia` |
| `fn_policy_lotno_iia.sql` | `fn_policy_lotno_iia()` | ถูกเรียกโดย `fn_lead_to_car_act(bigint)` |
| `fn_policy_renewal.sql` | `fn_policy_renewal(in_policy_no text, in_flag_noti bool, in_flag_lead bool, in_bad_behavior bool)` | WS6/WS7 Renewal (premium `saveLeadRenew` เรียก) |
| `fn_format_utc_timestamp_th.sql` | `fn_format_utc_timestamp_th(timestamp)` | WS6 |
| `fn_policy_renewal_noti.sql` | `fn_policy_renewal_noti()` | notification เรียก (โค้ดเปลี่ยนแค่ error handling) |
| `fn_policy_renewal_noti_log.sql` | `fn_policy_renewal_noti_log()` | notification เรียก (โค้ดเปลี่ยนแค่ error handling) |

ค่า md5 ของ UAT-ISV อยู่ใน `fingerprint_uatisv.txt`

## ขั้นตอนก่อน Deploy

```
1. คนที่มีสิทธิ์ Prod รัน 00_fingerprint_readonly.sql บน Prod (อ่านอย่างเดียว)
   psql -h <PROD_HOST> -U <USER> -d insurverse -X -q -A -t -F '|' \
        -c 'SET default_transaction_read_only = on' \
        -f 00_fingerprint_readonly.sql > fingerprint_prod.txt
2. ส่ง fingerprint_prod.txt ให้ Claude เทียบกับ fingerprint_uatisv.txt
   - md5 ตรงกัน           → ไม่ต้อง Deploy function นั้น
   - md5 ต่าง / MISSING    → ต้องดูทีละตัว (Prod อาจใหม่กว่า) แล้วค่อยใส่ใน Deploy Pack
3. Deploy Pack (เฉพาะตัวที่ต้อง): backup จาก Prod (pg_get_functiondef) + BEGIN/COMMIT
   + advisory lock + rollback → ขออนุมัติก่อนรัน
```

## หมายเหตุ

- ไม่พบ password / secret / API key ที่ hardcode ใน function (ตรวจ 2026-09-23)
- `pg_get_functiondef()` ไม่รวม GRANT — ถ้า Prod มี GRANT พิเศษ ให้ดึงจาก Prod ตอน backup
- export ทั้ง schema (132 functions + schema dump) เก็บไว้นอก repo ที่ scratchpad ของ session — ขอใหม่ได้ถ้าต้องการ
