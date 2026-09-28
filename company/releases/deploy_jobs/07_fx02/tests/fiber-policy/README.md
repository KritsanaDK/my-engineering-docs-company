# fiber-policy FX-02 — CMI pre-send validation

**Change:** `SendCMIRealTime` checks OIC's seven mandatory fields (ContractDt, EffectiveDt, EndDt, VehicleTypeCode ≤5,
RegisteredProvinceCode ≤2, PlateNumber ≤20, ChassisVINNumber ≤50 — not blank; dates yyyymmdd) before calling CMI.
A failing record is **not sent and not altered**: logged in `log_cmi_realtime` (status 422, remark lists the fields) and the
TQM data-problem notification carries the same list. Spec: `cmi_spec_fields.md`.

## Tests
- Unit: `go test -vet=off ./internal/service/ -run 'TestValidateCMIRealtime|TestCMIValidationResponse'` (vet off: main has pre-existing vet errors)
- Data (read-only): `validator_preflight.sql`

## Result on UAT (2026-09-24)
| | count |
|---|---|
| acts | 6,879 |
| accepted by OIC (reference no set) | 5,421 |
| validator blocks | 62 |
| — not yet accepted | 58 |
| — accepted by OIC anyway | 4 (3 × province NULL, created 2026-06-03; 1 × vehicleTypeCode `1.10.2Y` = 7 chars) |

The 4 were accepted by OIC's **UAT** gateway. OIC **Prod** rejects both cases (pending report 2026-09-04: 1SYS0007 empty province;
OIC email: 2SYS0006 vehicle type length). A first draft that also required colour/brand/name blocked OIC-accepted records, so the
validator is limited to the seven fields.

## Pre-flight on Prod (person with Prod access)
Run `validator_preflight.sql` read-only on Prod. Expect "blocks but OIC accepted" = 0; any row must be explained before merge.

## Not tested
- E2E through `GET /policy/tqm/cmi` (issues real policies from TQM drafts and calls CMI) — needs a TQM draft with a missing province on UAT-ISV.

## Data to fix (not code)
- `Car_Comp_Code = '1.10.2Y'` (UAT: MC-0026-G-001677) — confirmed **wrong data** by the user 2026-09-24; fix the value, do not truncate in code.
- OIC pending report 2026-09-04: 17 × province empty (mostly TQM), 1 × no plate/chassis (MC-0025-L-026480).
- `data_fix_candidates.sql` lists every active act with these problems — run read-only on Prod, fix, resubmit.

## E2E — TQM batch on UAT-ISV, 2026-09-25 (backend-policy-service:876)
Prereq: job `deploy_jobs/08_uatisv_tqm_master_seed` (UAT-ISV had no `tqm_allow_process` / `tqm_car_license_provice` rows, so the batch could not run).
File: `e2e/cmi_tqm_e2e.txt` → `gs://insurverse-tqm-uat/fx02-e2e/` → `POST /policy/tqm/cmi` → `GET /policy/tqm/cmi`.
Rule 4 identity, birth date 01/01/2008, CodeTqm `B6028`, CorpStatus `1`.

| Lead | Plate province | Result |
|---|---|---|
| MC-0826-Z-900003 | `ZZ` (unknown → empty) | **not sent to CMI** · `log_cmi_realtime` 422 "Not sent to CMI", `PRE-CMI: registeredProvinceCode is empty` · `tqm_request_status` DATA_PROBLEM · `tqm_notification_job` DATA_PROBLEM/WAITING with the same error |
| MC-0826-Z-900004 | `สบ` (Saraburi) | sent to OIC UAT · ref `V03-2046-20260925-1120-00003475`, receive `…0000000193` · SUCCESS · IIA SUCCESS |

Channel of the OIC pending report (2026-09-04, 17 distinct policies): 15 × `MC-0826-*` = TQM batch (this service), 2 × `MC-0025*` = uam path (see tests/uam).
Test data to clean up: drafts MC-0826-Z-900001..900004, GCS `gs://insurverse-tqm-uat/fx02-e2e/`.

### More TQM batch cases (2026-09-25, file `e2e/cmi_tqm_cases2.txt`)
| Lead | Case | Result |
|---|---|---|
| MC-0826-Z-900005 | plate empty | 422 `plateNumber is empty` · DATA_PROBLEM (1SYS0008) |
| MC-0826-Z-900006 | chassis empty | 422 `chassisVINNumber is empty` · DATA_PROBLEM (1SYS0009) |
| MC-0826-Z-900009 | vehicle type `1.10.2Y` | stopped earlier by the existing allow-list (validateFieldsCMI) · DATA_PROBLEM · no CMI call |
| MC-0826-Z-900010 | province + plate + chassis empty | 422 lists all three · DATA_PROBLEM |
| MC-0826-Z-900011 | complete | CMI ref `V03-2046-20260925-1134-00003476` · SUCCESS |
| (07/08) | plate > 20 / chassis > 50 | cannot enter through the TQM import: `tqm_lead_cmi.plate_id` varchar(8), `chasis_id` varchar(30) |

⚠️ Existing bug found: when one row of a TQM file fails to insert (e.g. value too long), the whole import transaction aborts but `POST /tqm/cmi` still answers `0000 Success`.
