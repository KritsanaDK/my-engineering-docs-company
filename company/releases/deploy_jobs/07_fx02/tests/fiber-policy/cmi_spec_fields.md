# CMI policy payload — System Validation (Error) rules

Source: OIC `CMIRT_Manual_WS.pdf` (Service Description v3.0), "ตารางรวมโครงสร้างรายการข้อมูลกรมธรรม์และข้อกำหนดการจัดส่ง",
downloaded 2026-09-24 from https://onlinewebcmi.oic.or.th/IDMSCMIS_P3/Content/Manual/CMIRT_Manual_WS.pdf

| # | Field | Type/size | System validation (Error) | Business rule (Error) |
|---|---|---|---|---|
| 1 | CompanyCode | string(4) | not null/blank, length = 4 | must be in table 1 |
| 2 | PolicyNumber | string(30) | not null/blank, ≤ 30 | |
| 3 | ContractDt | date yyyymmdd | not null/blank, valid date | |
| 4 | EffectiveDt | date yyyymmdd | not null/blank, valid date | ≥ ContractDt; < EndDt |
| 5 | EndDt | date yyyymmdd | not null/blank, valid date | ≥ ContractDt; > EffectiveDt |
| 6 | VehicleTypeCode | string(5) | not null/blank | in table 2 |
| 7 | RegisteredProvinceCode | string(2) | not null/blank | in table 3; non-THA → "00"; government plate → "GV"; red plate / plate unknown → "99" |
| 8 | Country | string(3) | not null/blank | in table 4 |
| 9 | PlateNumber | string(20) | not null/blank | non-THA unknown → "AA"; red plate → "ใหม่"; no plate → "ไม่มีทะเบียน" |
| 10 | ChassisVINNumber | string(50) | not null/blank | |
| 11 | InsuredUniqueID | string(20) | not null/blank | 13-digit → check digit; J/H/P/C/S prefixes |
| 12 | InsuredName | string(120) | not null/blank, ≤ 120 | |
| 13 | InsuredSurname | string(50) | ≤ 50 (blank allowed for juristic) | |
| 14 | AgentBrokerLicenseNumber | string(20) | not null/blank, ≤ 20 | checked against OIC licence DB; 4 digits = company code |
| 15 | IssuedCounter | string(15) | ≤ 15 | |
| 16 | VehicleBrand | string(15) | not null/blank, ≤ 15 | |
| 17 | VehicleModel | string(65) | not null/blank, ≤ 65 | |
| 18 | VehicleColor | string(65) | not null/blank, ≤ 65 | |
| 19 | ReferenceNumber | string(35) | | if set, must exist at OIC |

OIC pending report 2026-09-04 (`2046_Error7Fields25690904.xlsx`, 19 rows): 1SYS0007 ×17 (province empty), 1SYS0008 ×1 (plate empty), 1SYS0009 ×1 (chassis empty).
