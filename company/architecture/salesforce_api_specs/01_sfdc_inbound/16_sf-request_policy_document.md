# [16] SF-Request Policy Document

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Request Policy Document`
- **Total Rows Parsed**: `29`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/requestpolicydocument`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/requestpolicydocument |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Policy Number | policyNumber | Name, External_ID__c | Text(255) | Y | Y | เลขที่ของ  Policy |

### Example / Code Payload (Row 13)
**Example Request**
```json
{
        "policyNumber" : "MV-0023-C-000023m"
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | URL | url |  | Text(255) |  |  | Url for access Policy Document (ตัวจริง) |

### Example / Code Payload (Row 20)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "url": "https://www.google.com"
}
```

### Example / Code Payload (Row 21)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Policy number not found",
  "timestamp": "2022-01-28T11:24:53"
}
```

| Filename | Related | Store | Source | Col5 |
| --- | --- | --- | --- | --- |
| Policy | Policy | SF (Base64) | X10 |  |
| Endrosement | Policy | SF (Base64) | X10, SF |  |
| Car Inspect | Policy | SF (Base64) | X10 | อนาคตต้องเอาออก เพราะ X10 ต่อกับ iSurvey ตรง |
| Policy Payment | Policy | GCP (URL) | 2C2P |  |
| Car Damage | Claim | GCP (URL) | iSurvey, SF, EMCS |  |
| Garage Billing | Claim | GCP (URL) | EMCS |  |
| Other Billing | Claim | GCP (URL) | SF |  |
