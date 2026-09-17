# [60] Microservice-Customer Detail

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Customer Detail`
- **Total Rows Parsed**: `27`

## API Specification Overview

- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### E

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/sf/customerDetail |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/sf/customerDetail |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Account ID | accountID | Id | Text(18) | Y | Y | Account Unique ID |
| 2 | Email | email | Email__c | Email | Y |  | อีเมลติดต่อ |
| 3 | Phone | phone | Phone__c | Text(40) |  |  | เบอร์โทร |
| 4 | Title | prefix | Buyer_Prefix__c | Text(50) |  |  | คำนำหน้าชื่อ |
| 5 | Firstname | firstname | First_Name__c | Text(255) |  |  | ชื่อผู้ซื้อ |
| 6 | Lastname | lastname | Last_Name__c | Text(255) |  |  | นามสกุลผู้ซื้อ |
| 7 | Birthdate | birthdate | Birth_Date__c | Date |  |  | วันเดือนปีเกิดผู้ซื้อ |

### Example / Code Payload (Row 20)
**Example Request**
```json
{
  "accountID": "5001y0000018pGJAAY",
  "email":"it-resource@gmail.com",
  "phone":"0891231234",
  "firstname":"สนทธา",
  "lastname":"ธรรม์มา",
  "birthdate":"2023-04-03"
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Title | title |  | Text |  |  |  |
| 2 | Status | status |  | Int |  |  |  |
| 3 | Description | description |  | Text |  |  |  |

### Example / Code Payload (Row 26)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 200,
    "description": "",
    "result": {}
}
```

### Example / Code Payload (Row 27)
**Example Response
(Error)**
```json
{
    "title": "Unsuccess",
    "status": 401,
    "description": "Key (\"email\")=(aaa@gmail.com) already exists.",
    "result": {}
}
```
