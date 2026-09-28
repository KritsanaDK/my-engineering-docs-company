# uam FX-02 — tests (fix/fx-02-uam, uat-isv 320a326)

| # | Ticket | Commit | Test | Result |
|---|---|---|---|---|
| 9 | WS9 DB pool env | 09893e7 | unit `TestPoolEnv*` | ✅ defaults = Prod (80/10/1h/30m), env overrides, invalid → default |
| 2 | FX-01 #23 OCR | a16d860 | unit `TestResponseStatus` (float64 status used to panic) | ✅ · status stays 500 so the web keeps using onError |
| 1 | FX-01 #16 notification | 40258c3 | unit `TestEmailService*`, `TestNotificationClientHasTimeout` | ✅ unreachable/502 → false (no nil panic); 30s timeout · E2E: mail after deploy |
| 4 | OIC 2BUS0004 | 21a1d6f | `diff_q2_contractDt.sql` on UAT (1,294 endorsements) | ✅ 1,138 identical, 156 differ only in contractDt = the 156 later than effectiveDt; 0 left |
| 6 | OIC 2SYS0019 | 9f1ef4e | `diff_q1_broker.sql` on UAT (6,879 acts) | ✅ 5,126 identical; 1,753 changed, all TQM, only agentBrokerLicenseNumber |
| 5 | OIC 2BUS0227 | 919048f | unit `TestCMIInvalidTitleAndNotRejected`; UAT count | ✅ 29 / 1,294 endorsements without reference would be held back |
| 3 | OIC 1SYS0007/08/09 | c6e3883 | unit `TestValidateCMIRow`; `validator_preflight_q1.sql` | ✅ 62 / 6,879 held back; 4 accepted by OIC UAT gateway (3 empty province, 1 `1.10.2Y`) — OIC Prod rejects both |
| 7 | Auto-register 200 | aa7cf16 | API after deploy: new email → `is_new_account:true`; existing → 200 `is_new_account:false`; web checklist | ⏳ after deploy |
| 8 | WS6-04 phone | b57e692 | UAT count | ✅ 215 / 9,264 policies gain the buyer's phone; others unchanged |

Pre-flight on Prod (read-only, person with access): run the three `.sql` files; expect the same shape
(only violating rows change; "blocks but OIC accepted" = 0 or explained).
Also: Service `backend-notification-service:8080` in uam's namespace (helm-prod `Backend_Notification`).

Unit: `go test -vet=off ./controllers/ ./webserver/ -run 'TestPoolEnv|TestResponseStatus|TestEmailService|TestNotificationClient|TestCMIInvalid|TestValidateCMIRow'`
(vet off: main has pre-existing vet errors).

## E2E — missing plate province via web flow, UAT-ISV 2026-09-25
`CAR_PROV=99 bash ../e2e/create_invoice.sh act` → A260925970019 → simulated payment → policy MC-0026-I-002615 issued,
**CMI not called**: purchase got `ข้อมูลไม่ครบตามข้อกำหนด คปภ. : registeredProvinceCode is empty`; `log_cmi_realtime` remark
`cmi realtime invalid failed for MC-0026-I-002615: registeredProvinceCode is empty`. Complete-data control: MC-0026-I-002604 got CMI numbers.

### More web-flow cases (2026-09-25)
| Case | Result |
|---|---|
| plate empty / chassis empty | rejected at data entry by premium actAPI (`"Car_license_no" / "Car_serial_no" is not allowed to be empty`) — cannot reach CMI |
| plate 23 chars (A260925140020 → MC-0026-I-002626) | policy issued, **CMI not called**: `plateNumber is longer than 20 characters (got 23)` |
| Endorsement cases (2BUS0227, 2BUS0004, 1SYS on q2) | not run: UAT-ISV has 0 rows in `Policy_endorse_detail`; creating one needs SF → saleforce-service `PolicyTransacti` (JWT). Covered by the UAT differentials (156/1,294 contractDt capped; 29/1,294 held back). |
