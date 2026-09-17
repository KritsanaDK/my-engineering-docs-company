# [06] SF-Account

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Account`
- **Total Rows Parsed**: `48`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertaccount`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertaccount |
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
| 1 | Account ID | accountID | Id | Text(18) | Y |  | Account Unique ID |
| 2 | Lead | leadID | Lead__c | Text(18) | Y |  | Lead Unique ID |
| 3 | Cookie ID | cookieID | Cookie_Id__c | Text(255) | Y |  |  |
| 4 | Name | companyName | Name | Name |  | Y (Cooperate) |  |
| 5 | Salutation | salutation | Salutation | Text(40) |  |  | คำนำหน้าชื่อ |
| 6 | Firstname | firstname | FirstName | Text(40) |  | Y (Person) | ชื่อ |
| 7 | Lastname | lastname | LastName | Text(80) |  | Y (Person) | นามสกุล |
| 8 | Identity_Number | idNumber | Identity_Number__c | Text(13) |  | Y |  |
| 9 | Identity_Type | idType | Identity_Type__c | Picklist |  | Y | 1 = Citizen ID, 2 = Passport Number |
| 10 | Mobile Phone | mobilePhone | PersonMobilePhone | Text(40) |  | Y | เบอร์โทรศัพท์ |
| 11 | Fax | fax | Fax | Fax |  |  |  |
| 12 | Email | email | PersonEmail | Email |  | Y | อีเมลติดต่อ |
| 13 | Birthdate | birthdate | PersonBirthdate | Date |  |  | วันเกิด YYYY-MM-DD |
| 14 | Street | street | Street__c | Text(255) |  |  | ถนน |
| 15 | City | city | City__c | Text(40) |  |  | แขวง |
| 16 | Distrct | district | District__c | Text(40) |  |  | เขต |
| 17 | State | state | State__c | Text(80) |  |  | จังหวัด |
| 18 | Country | country | Country__c | Text(80) |  |  | ประเทศ |
| 19 | PostalCode | postalCode | Postal_Code__c | Text(20) |  |  | รหัสไปรษณีย์ |
| 20 | Customer_Type | customerType | Customer_Type__c | Picklist |  | Y | Person, Cooperate |
| 21 | KYC_Level | kycLevel | KYC_Level__c | Picklist |  |  |  |
| 22 | Line | lineID | Line__c | Text(255) |  |  |  |
| 23 | Twitter | twitterID | Twitter__c | Text(255) |  |  |  |
| 24 | Facebook | facebookID | Facebook__c | Text(255) |  |  |  |
| 25 | Youtube | youtubeID | Youtube__c | Text(255) |  |  |  |
| 26 | Instragram | instagramID | Instragram__c | Text(255) |  |  |  |
| 27 | Payment_Status | paymentStatus | Payment_Status__c | Picklist |  | Y | ปกติ, ผิดชำระ |
| 28 | Account Type | accountType | Account_Type__c | Picklist |  |  | Owner, Payer |

### Example / Code Payload (Row 40)
**Example Request**
```json
{
    "leadID": "00Q4x00000OQsDrEAL",
    "salutation": "นาย",
    "firstname": "สมชาย",
    "lastname": "ใจดี",
    "idNumber": "6475561060843",
    "idType": "Citizen ID",
    "mobilePhone": "0891111111",
    "email": "somchai@test.com",
    "street": "33/4 The Nine Tower Rama 9",
    "city": "ห้วยขวาง",
    "state": "Bangkok",
    "country": "Thailand",
    "postalCode" : "10310",
    "customerType": "Person",
    "paymentStatus": "ปกติ"
  }
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Account ID | accountID | ID | Text(18) | Y |  | Using for update data |

### Example / Code Payload (Row 47)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "accountID": "0014x00001OkYKoAAN"
}
```

### Example / Code Payload (Row 48)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Missing Required Field Lastname",
  "timestamp": "2022-01-28T11:24:53"
}
```
