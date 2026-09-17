# [36] Microservice-Account

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Account`
- **Total Rows Parsed**: `41`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/createaccount`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/createaccount |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Create Account |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Account ID | accountID | Id | Text(18) | Y | Y | Account Unique ID |
| 2 | Company Name | companyName | Name | Text(255) |  | Y (Cooperate) |  |
| 3 | Salutation | salutation | Salutation | Text(40) |  |  | คำนำหน้าชื่อ |
| 4 | Firstname | firstname | FirstName | Text(40) |  | Y (Person) | ชื่อ |
| 5 | Lastname | lastname | LastName | Text(80) |  | Y (Person) | นามสกุล |
| 6 | Identity Number | idNumber | Identity_Number__c | Text(13) |  | Y |  |
| 7 | Identity Type | idType | Identity_Type__c | Picklist |  | Y | Citizen ID, Passport Number |
| 8 | Phone | phone | Phone | Text(40) |  | Y | เบอร์โทรศัพท์ |
| 9 | Fax | fax | Fax | Text(40) |  |  |  |
| 10 | Email | email | Email | Text(80) |  | Y | อีเมลติดต่อ |
| 11 | Street | street | BillingStreet | Text(255) |  | Y | ถนน |
| 12 | City | city | BillingCity | Text(40) |  | Y | แขวง |
| 13 | State | state | BillingState | Text(80) |  | Y | จังหวัด |
| 14 | Country | country | BillingCountry | Text(80) |  | Y | ประเทศ |
| 15 | PostalCode | postalCode | BillingPostalCode | Text(20) |  | Y | รหัสไปรษณีย์ |
| 16 | Customer Type | customerType | Customer_Type__c | Picklist |  | Y | Person, Cooperate |
| 17 | KYC Level | kycLevel | KYC_Level__c | Picklist |  |  |  |
| 18 | Line ID | lineID | Line__c | Text(255) |  |  |  |
| 19 | Twitter ID | twitterID | Twitter__c | Text(255) |  |  |  |
| 20 | Facebook ID | facebookID | Facebook__c | Text(255) |  |  |  |
| 21 | Youtube ID | youtubeID | Youtube__c | Text(255) |  |  |  |
| 22 | Instagram ID | instagramID | Instragram__c | Text(255) |  |  |  |

### Example / Code Payload (Row 33)
**Example Request**
```json
{
    "salutation": "นาย",
    "firstname": "สมชาย",
    "lastname": "ใจดี",
    "idNumber": "6475561060843",
    "idType": "Citizen ID",
    "phone": "0891111111",
    "email": "somchai@test.com",
    "street": "33/4 The Nine Tower Rama 9",
    "city": "ห้วยขวาง",
    "state": "Bangkok",
    "country": "Thailand",
    "postalCode" : "10310",
    "customerType": "Person"
  }
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Account ID | accountID | ID | Text(18) | Y |  | Using for update data |

### Example / Code Payload (Row 40)
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

### Example / Code Payload (Row 41)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Missing Required Field Lastname",
  "timestamp": "2022-01-28T11:24:53"
}
```
