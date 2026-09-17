# [07] SF-PaymentPremium

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-PaymentPremium`
- **Total Rows Parsed**: `37`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpaymentpremium`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertpaymentpremium |
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
| 0 |  |  |  | Array |  |  |  |
| 1 | Payment ID | paymentID | Payment_ID__c | Text(18) | Y |  | Unique ID Payment |
| 2 | Voluntary Number | policyNumber | Name, External_ID__c | Text(255) | Y |  | เลขที่ของ  Policy ภาคสมัครใจ |
| 3 | Compulsory Number | compulsoryNumber | Compulsory_Policy__c | Text(255) | Y |  | เลขที่ของ  Policy ภาคบังคับ |
| 4 | Account_ID | accountID | Account_ID__c | Text(18) | Y | Y | Account Unique ID |
| 5 | Lead_ID | leadID | Lead_ID__c | Text(18) | Y |  | Lead Unique ID |
| 6 | Premium_Amount | premiumAmount | Premium_Amount__c | Currency(16,2) |  | Y |  |
| 7 | Paid_Date | paidDate | Paid_Date__c | Date |  | Y |  |
| 8 | Total_Paid_Amount | totalPaidAmount | Total_Paid_Amount__c | Number(16,2) |  | Y |  |
| 9 | Car Brand | carBrand | Car_Brand__c | Text(255) |  |  | ยี่ห้อรถ |
| 10 | Car Model | carModel | Car_Model__c | Text(255) |  |  | รุ่นรถ |
| 11 | Car Year | carYear | Car_Year__c | Text(4) |  |  | ปีรถ |
| 12 | Policy Type | policyType | Policy_Type__c | Text(2) |  |  | ประเภทกรมธรรม์ 1, 2+, 3+, 3, 0 |
| 13 | Have Compulsory | haveCompulsory | Have_Compulsory__c | Boolean |  |  | มีภาคบังคับ |

### Example / Code Payload (Row 26)
**Example Request**
```json
[
  {
    "paymentID": "VPCNC2200007",
    "policyNumber": "P00001",
    "premiumAmount": 7000,
    "paidDate": "2022-03-11",
    "totalPaidAmount": 0
  },
  {
    "paymentID": "VPCNC2200008",
    "policyNumber": "P00002",
    "premiumAmount": 12000,
    "paidDate": "2022-03-21",
    "totalPaidAmount": 210656.44
  }
]
```
```json
[
 {
   "paymentID":"P2401107901",
   "policyNumber":"MV-0024-A-000240",
   "compulsoryNumber":"MC-0024-A-000113",
   "premiumAmount":"18320.3",
   "paidDate":"2024-01-10",
   "totalPaidAmount":18320.3,
   "accountID":"001O2000007X81FIAS",
   "carBrand":"Mazda",
   "carModel":"CX-3",
   "carYear":"2020",
   "policyType":"1",
   "haveCompulsory":true
  }
]
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Payment ID | paymentID | Id | Text(18) | Y |  | Using for update date |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 36)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "paymentID": "VPCNC2200007",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "paymentID": "VPCNC2200008",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```
```json
{
  "timeStamp": "2024-01-10T03:59:11",
  "statusCode": "0000",
  "result": [
    {
      "paymentID": "a89O20000006NI5IAM",
      "isSuccess": true,
      "errorMessage": ""
    }
  ],
  "message": "Success"
}
```

### Example / Code Payload (Row 37)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "paymentID": "VPCNC2200007",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "paymentID": "VPCNC2200008",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
