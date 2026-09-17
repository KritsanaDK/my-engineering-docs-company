# [12] SF-PolicyCoverage

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-PolicyCoverage`
- **Total Rows Parsed**: `44`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpolicycoverage`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertpolicycoverage |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Upsert Policy Coverage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field | GCP Remark |  | 5.0 |  |  | AI |  |  | CR21 |  |
| 0 |  |  |  | Array |  |  |  |  |  |  |  | 0 |  |  | 0 |  |  | 0 |
| 1 | Coverage ID | coverageID | CategoryCode , External_ID__c | Text(18) | Y | Y | Unique ID Coverage |  | Policy_No + Coverage_type OD = ค่าซาก FT = ไฟไหม้ น้ำถ่วม TPBI = ค่ารักษาพยาบาลคู่กรณี ต่อคน (แก้ไข R2.5) TPBI_E = ค่ารักษาพยาบาลคู่กรณี ต่อครั้ง (เพิ่ม R2.5) TPPD = ค่าทรัพย์สินคู่กรณี ต่อครั้ง MV01 = ประกันอุบัติเหตุ MV02 = ค่ารักษาพยาบาลบุคคลในรถ  MV03 = ค่าประกันตัวผู้ขับขี่ Access = คุ้มครองอุปกรณ์ตกแต่ง |  | coverageID | 1 |  | coverageID | 1 |  | coverageID | 1 |
| 2 | Insurance Policy | insurancePolicyId | InsurancePolicyId | Master-Detail(Insurance Policy) | Y | Y | เลขที่ของ  Policy Id | Policy_No |  |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |
| 3 | Category | category | Category | Picklist |  | Y | The category that the coverage belongs to : Coverage Discount Rider Clause Deductible Limit Component |  | Fix Coverage |  | category | 1 |  | category | 1 |  | category | 1 |
| 4 | Premium Amount | premiumAmount | PremiumAmount, StandardPremiumAmount | Currency(16, 2) |  |  | The premium paid by the customer for this coverage. | SI_ + Coverage_Type + _Ans |  |  | premiumAmount | 1 |  | premiumAmount | 1 |  | premiumAmount | 1 |
| 5 | Deductible Amount | deductibleAmount | DeductibleAmount | Currency(16, 2) |  |  | The deductible amount that the customer must pay. | Prem_ + Coverage_Type | ตามลำดับทุนที่เลือกไว้ (Ans) |  | deductibleAmount | 1 |  | deductibleAmount | 1 |  | deductibleAmount | 1 |
| 6 | Effective Date | effectiveDate | EffectiveDate | Date/Time |  |  | The date from which the coverage is in effect. | Policy_Startdate |  |  | effectiveDate | 1 |  | effectiveDate | 1 |  | effectiveDate | 1 |
| 7 | Expiration Date | expirationDate | ExpirationDate | Date/Time |  |  | The date on which the coverage expires. | Policy_Enddate |  |  | expirationDate | 1 |  | expirationDate | 1 |  | expirationDate | 1 |
| 8 | Coverage Code | coverageCode | Coverage_Code__c |  |  |  |  |  | สมัครใจ OD, FT , TPBI, TPPD, MV01, MV02, MV03, Access พรบ coverdeath, coverinjury, coveracc |  | coverageCode | 1 |  | coverageCode | 1 |  | coverageCode | 1 |
| 9 | Coverage Name | coverageName | CoverageName | Text(255) |  |  | The name of the coverage. |  | ชื่อไทยมาแสดง OD = ค่าซาก FT = ไฟไหม้ น้ำถ่วม TPBI = ค่ารักษาพยาบาลคู่กรณี ต่อครั้ง TPPD = ค่าทรัพย์สินคู่กรณี ต่อครั้ง MV01 = ประกันอุบัติเหตุ MV02 = ค่ารักษาพยาบาลบุคคลในรถ  MV03 = ค่าประกันตัวผู้ขับขี่ Access = คุ้มครองอุปกรณ์ตกแต่ง |  | coverageName | 1 |  | coverageName | 1 |  | coverageName | 1 |

### Example / Code Payload (Row 22)
**10**
**Coverage Attribute**
**coverageAttribute**
**vlocity_ins_fsc__AttributesSelectedValues__c**
**Object**
**Attribute ของ Coverage ใส่ Attribute ตาม type ของ  Coverage**
```json
{'Amount':Prem_ + Coverage_Type}
```
**JSON**
**coverageAttribute**
**1**
**coverageAttribute**
**1**
**coverageAttribute**
**1**

| 10.1 | Premium | Prem | Col4 | Col5 | Col6 | Col7 | The premium paid by the customer for this coverage. (ค่าเบี้ย) | Col9 | Col10 | Col11 | Prem | 1 | Col14 | Prem | 1 | Col17 | Prem | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 10.2 | Sum Insure | SI |  |  |  |  | The deductible amount that the customer must pay. (ทุนประกัน) |  |  |  | SI | 1 |  | SI | 1 |  | SI | 1 |
| 11 | Asset ID | assetId | InsurancePolicyAssetId | Text(18) | Y | Y |  |  |  |  | assetId | 1 |  | assetId | 1 |  | assetId | 1 |
| 12 | Tariff | tariff | Tariff__c | Currency(16,2) |  |  |  |  |  |  | tariff | 1 |  | tariff | 1 |  | tariff | 1 |
| 13 | Possible Change Value |  |  | Array |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| 13.1 | SI |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| 13.2 | Tariff |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| 13.1 | Limit Range | limitRange | LimitRange | Picklist |  |  | The range of the coverage limit. For example, bodily injury coverage with  limits as USD 100,000 per person and USD 300,000 per accident. |  |  |  |  |  |  | limitRange |  |  |  |  |
| 13.2 | Limit Amount | limitAmount | LimitAmount | Decimal |  |  | The limit of the fixed coverage amount. For example, uninsured motorist  coverage of USD 1000. |  |  |  |  |  |  | limitAmount |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  | 14 |  | 14 |  |  | 14 |  |  | 14 |

### Example / Code Payload (Row 33)
**Example Request**
```json
[
  {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 460.64,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 1000000,
      "coverageName": "ค่ารักษาพยาบาลคู่กรณี ต่อคน",
      "coverageID": "MV-0024-A-000237-TPBI",
      "coverageCode": "TPBI",
      "coverageAttribute": {
        "Prem": "460.64",
        "SI": "1000000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 921.27,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 2500000,
      "coverageName": "ค่าทรัพย์สินคู่กรณี ต่อครั้ง",
      "coverageID": "MV-0024-A-000237-TPPD",
      "coverageCode": "TPPD",
      "coverageAttribute": {
        "Prem": "921.27",
        "SI": "2500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 125,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 500000,
      "coverageName": "ประกันอุบัติเหตุ",
      "coverageID": "MV-0024-A-000237-MV01",
      "coverageCode": "MV01",
      "coverageAttribute": {
        "Prem": "125.00",
        "SI": "500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 125,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 500000,
      "coverageName": "ค่ารักษาพยาบาลบุคคลในรถ ",
      "coverageID": "MV-0024-A-000237-MV02",
      "coverageCode": "MV02",
      "coverageAttribute": {
        "Prem": "125.00",
        "SI": "500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 41,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 500000,
      "coverageName": "ค่าประกันตัวผู้ขับขี่",
      "coverageID": "MV-0024-A-000237-MV03",
      "coverageCode": "MV03",
      "coverageAttribute": {
        "Prem": "41.00",
        "SI": "500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 0,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 10000000,
      "coverageName": "ค่ารักษาพยาบาลคู่กรณี ต่อครั้ง",
      "coverageID": "MV-0024-A-000237-TPBI_E",
      "coverageCode": "TPBI_E",
      "coverageAttribute": {
        "Prem": "0",
        "SI": "10000000.0000"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    }
]
```

| No | Upsert Policy Coverage | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Coverage ID | coverageID | ID | Text(18) | Y |  | Using for Update Coverage Detail |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 43)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "coverageID": "0cY4x000000Twj3EAC",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 44)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "coverageID": "0cY4x000000Twj3EAC",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "coverageID": "0cY4x000000Twj6EAC",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
