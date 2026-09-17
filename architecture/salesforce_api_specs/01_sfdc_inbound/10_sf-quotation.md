# [10] SF-Quotation

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Quotation`
- **Total Rows Parsed**: `34`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertquotation`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertquotation |
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
| 1 | Quote ID | quoteID | Id | Text(18) | Y |  | Unique Quote ID |
| 2 | Account ID | accountID | Account__c | Text(18) | Y |  |  |
| 3 | Policy Name | policyName | Policy_Name__c | Text(255) |  | Y | สินค้าที่สนใจ |
| 4 | Policy Detail | policyDetail | Policy_Detail__c | Text(32000) |  |  |  |
| 5 | Status | status | Status__c | Text(255) Picklist? |  | Y | กำลังตัดสินใจ, ยกเลิก |
| 6 | Total Premium | totalPremium | Total_Premium | Number(16,2) |  |  | Total price??? |
| 7 | Firstname | firstname | FirstName__c | Text(40) |  | Y | ชื่อ |
| 8 | Lastname | lastname | LastName__c | Text(80) |  | Y | นามสกุล |
| 9 | Cookie_ID | cookieID | Cookie_ID__c | Text(30) |  | Y | Cookie ID ของ API (ใช้สำหรับแจ้ง Noti ไปยัง App) |
| 10 | Phone | phone | Phone | Text(40) |  | Y | เบอร์โทรศัพท์ |
| 11 | Email | email | Email | Text(80) |  |  | อีเมลติดต่อ |
| 12 | Car_Brand | carBrand | Car_Brand__c | Text(255) |  | Y | ยี่ห้อรถ |
| 13 | Car_Model | carModel | Car_Model__c | Text(255) |  | Y | รุ่นรถ |
| 14 | Car_Year | carYear | Car_Year__c | Text(4) Picklist |  | Y | ปีผลิตรถ |

### Example / Code Payload (Row 26)
**Example Request**
```json
{
    "quoteID": "a2d4x000003RG4ZAAW",
    "accountID": "0014x00001OkYKoAAN",
    "policyName": "ประกันภัยรถยนต์ประเภท 1 (ซ่อมอู่ห้าง)",
    "status": "กำลังตัดสินใจ",
    "firstname": "สมชาย",
    "lastname": "ใจดี"
    "phone": "0891111111"
  }
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Quote ID | quoteID | Id | Text(18) | Y |  | Using for Update Data |

### Example / Code Payload (Row 33)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "quoteID": "a2d4x000003RG4ZAAW"
}
```

### Example / Code Payload (Row 34)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53"
}
```
