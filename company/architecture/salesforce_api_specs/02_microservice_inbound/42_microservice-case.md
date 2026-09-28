# [42] Microservice-Case

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Case`
- **Total Rows Parsed**: `32`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/upsertcase`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/upsertcase |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Invoice |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 0 |  |  |  | Array |  |  |  |
| 1 | Case Number | caseNumber | Name | Text(80) | Y | Y | เลขที่ Case |
| 2 | Account ID | accountID | AccountId | Text(18) | Y | Y | Unique ID Account |
| 3 | Subject | subject | Subject | Text(255) |  | Y | ชื่อ Case |
| 4 | Description | description | Description | Text(32000) |  | Y | รายละเอียด Case |
| 5 | Status | status | Status | Picklist |  |  | สถานะ Case |
| 6 | Agent Name | agentName | Owner.Name | Text(80) |  |  | ชื่อผู้รับผิดชอบ Case |
| 7 | Solution | solution | Solution__c | Text(255) |  |  | วิธีการแก้ไขปัญหา |
| 8 | Report Date | reportDate | CreatedDate | Datetime |  |  | วันที่แจ้งปัญหา |

### Example / Code Payload (Row 21)
**Example Request**
```json
[
 {
   "caseNumber": "CASE-12345",
   "accountID": "ACCT-6789",
   "subject": "Billing issue",
   "description": "I was charged for a service that I did not receive",
   "status": "Open",
   "agentName": "John Smith",
   "solution": null,
   "reportDate": "2023-02-22"
 }
]
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Case Number | caseNumber |  | Text(80) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 31)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "caseNumber": "VPCNC2200007",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 32)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "caseNumber": "VPCNC2200007",
      "isSuccess": false,
      "errorMessage": "Error Message"
    }
  ]
}
```
