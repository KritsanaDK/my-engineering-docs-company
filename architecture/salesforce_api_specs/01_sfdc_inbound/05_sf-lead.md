# [05] SF-Lead

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Lead`
- **Total Rows Parsed**: `42`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertlead`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertlead |
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
| 1 | Lead ID | leadID | ID | Text(18) | Y |  | lead Unique ID generate by Salesforce |
| 2 | Cookie ID | cookieID | Cookie_Id__c | Text(255) |  |  | for Website |
| 3 | Salutation | salutation | Salutation | Text(40) |  |  | คำนำหน้าชื่อ |
| 4 | Firstname | firstname | FirstName | Text(40) |  | Y | ชื่อ |
| 5 | Lastname | lastname | LastName | Text(80) |  | Y | นามสกุล |
| 6 | Identity_Number | IdNumber | Identity_Number__c | Text(13) |  |  |  |
| 7 | Identity_Type | IdType | Identity_Type__c | Picklist |  |  | 1 = Citizen ID, 2 = Passport Number |
| 8 | Interest_Product | interestProduct | Interest_Product__c | Text(255) |  |  | สินค้าที่สนใจ |
| 9 | Interaction_App_Detail | interactionAppDetail | Interaction_App_Detail__c | Text(2000) |  |  | ข้อมูลการเข้าใช้งาน Moible App/PWA |
| 10 | Lead Source | leadSource | LeadSource | Text(255) |  |  | ช่องทางการติดต่อ |
| 11 | Mobile Phone | mobilePhone | MobilePhone | Text(40) |  |  | เบอร์โทรศัพท์ |
| 12 | Fax | fax | Fax | Text(40) |  |  |  |
| 13 | Email | email | Email | Text(80) |  |  | อีเมลติดต่อ |
| 14 | Street | street | Street__c | Text(255) |  |  | ถนน |
| 15 | City | city | City__c | Text(40) |  |  | แขวง |
| 16 | District | district | District__c | Text(40) |  |  | เขต |
| 17 | State | state | State__c | Text(80) |  |  | จังหวัด |
| 18 | Country | country | Country__c | Text(80) |  |  | ประเทศ |
| 19 | PostalCode | postalCode | Postal_Code__c | Text(20) |  |  | รหัสไปรษณีย์ |
| 20 | Car_Brand | carBrand | Car_Brand__c | Text(255) |  |  | ยี่ห้อรถ |
| 21 | Car_Model | carModel | Car_Model__c | Text(255) |  |  | รุ่นรถ |
| 22 | Car_Year | carYear | Car_Year__c | Text(4) |  |  | ปีผลิตรถ |

### Example / Code Payload (Row 34)
**Example Request**
```json
{
  "salutation": "",
  "firstname": "เป็ดพาล้อ",
  "lastname": "แซ่เสี้ยม",
  "interestProduct": "ประกันภัยรถยนต์ประเภท 1",
  "leadSource": "PWA",
  "mobilePhone": "0988888888",
  "email": "pedpalo@mail.com",
  "carBrand": "Nissan",
  "carModel": "X-Trail",
  "carYear": "2014"
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Lead ID | leadID | Id | Text(18) | Y |  | Using for update data |

### Example / Code Payload (Row 41)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "leadID": "00Q4x00000OQsDrEAL"
}
```

### Example / Code Payload (Row 42)
**Example Response
(Error)**
```json
{
  "timeStamp": "2024-01-10T04:12:45",
  "statuscode": "2000",
  "message": "Cannot insert LeadUpsert failed. First exception on row 0; first error: DUPLICATES_DETECTED, Use one of these records?: []",
  "leadId": null
}
```
