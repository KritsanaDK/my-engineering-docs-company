# [19] SF-Case

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Case`
- **Total Rows Parsed**: `35`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertcase`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertcase |
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
| 1 | CaseNumber | caseNumber | Id | Text(18) | Y |  | เลขที่ Case |
| 2 | AccountId | accountID | AccountId | Text(18) | Y |  | Unique ID Account |
| 3 | Customer Name | name | Contact_Name__c | Text(255) |  | Y | ชื่อผู้ติดต่อ |
| 4 | Phone | phone | Contact_Phone__c | Text(40) |  | Y | เบอร์โทรศัพท์ |
| 5 | Email | email | Contact_Email__c | Text(255) |  | Y | อีเมล |
| 6 | Policy Number | policyNumber | Insurance_Policy__c | Text(255) |  |  | เลขที่ของ  Policy |
| 7 | Subject | subject | Subject | Text(255) |  | Y | ชื่อ Case (Inquiry = เรื่องที่ติดต่อ, Complain = Fix value Complain) |
| 8 | Description | description | Description | Long Text Area(32000) |  |  | รายละเอียด Case |
| 9 | Case Type | caseType | Type | Picklist |  | Y | สนใจซื้อประกัน สอบถามข้อมูลกรมธรรม์/ความคุ้มครอง แก้ไขข้อมูลกรมธรรม์ สอบถามการเคลม สอบถามข้อมูลทั่วไป แจ้งเรื่องร้องเรียน |
| 10 | Case Origin | caseOrigin | Origin | Picklist |  | Y | Website PWA Mobile App |
| 11 | Report Date | reportDate | Notify_Date__c | Datetime |  | Y | วันที่แจ้งปัญหา |
| 12 | Source | source |  | Picklist |  |  | Contact Us (Default) Chat |

### Example / Code Payload (Row 24)
**Example Request**
```json
{
  "name": "Contact Name",
  "phone": "0929505991",
  "email": "test@gmail.com",
  "subject": "Subject",
  "caseType": "สนใจซื้อประกัน",
  "reportDate": "2023-03-01T12:00:00"
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field |  | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |  |
| 4 | Result | result |  | Array |  | Y |  |  |
| 4.1 | CaseNumber | caseNumber | Id | Text(18) | Y |  |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |  |

### Example / Code Payload (Row 34)
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

### Example / Code Payload (Row 35)
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
