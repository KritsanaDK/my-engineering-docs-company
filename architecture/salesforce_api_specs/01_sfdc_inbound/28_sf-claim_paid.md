# [28] SF-Claim Paid

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Claim Paid`
- **Total Rows Parsed**: `29`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/updateclaimpaid`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/updateclaimpaid |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 0 |  |  |  | Array |  |  |  |
| 1 | Claim Number | claimId | ClaimId | Text(20) | Y | Y | เลขเคลม |
| 2 | Claim Payment Id | claimPaymentId | External_Id__c | Text(20) | Y | Y | หมายเลข Payment |
| 3 | Loss Code | lossCode |  | Text(255) | Y | Y | รหัสความเสียหาย |
| 4 | Paid Date | paidDate |  | Datetime |  | Y | วันที่จ่ายเงิน |
| 5 | Paid Amount | paidAmount |  | Number(16,2) |  | Y | ยอดเงินทีจ่ายแล้ว |

### Example Request

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Coverage Number | coverageID | External_Id__c | Text(20) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 28)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimPaymentId": "1easWlKqP1",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "claimPaymentId": "1easWlKqP2",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 29)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimPaymentId": "1easWlKqP1",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "claimPaymentId": "1easWlKqP2",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
