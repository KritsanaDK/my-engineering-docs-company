# [29] SF-Claim Recovery

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Claim Recovery`
- **Total Rows Parsed**: `39`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/updateclaimrecovery`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/updateclaimrecovery |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field |
| 0 |  |  |  | Array |  |  |  | Table : sf_claim_recovery |
| 1 | Claim Number | claimId | ClaimId | Text(20) | Y | Y | เลขเคลม | claim_id |
| 2 | Recovery Number | recoveryId | External_Id__c | Text(20) | Y | Y | Unique ID Recovery | recovery_id |
| 3 | Transaction No | transactionNo |  |  |  |  | Unique ID Recovery Transation | transaction_no |
| 4 | Third Party Type | tpType |  | Picklist |  | Y | ประเภทคู่กรณี - Insurance Company - Driver - Owner  - Other | tp_type |
| 5 | Company Code | companyCode |  | Text(30) |  |  | Using for tpType is "Insurance Company) | company_code |
| 6 | Third Party Name | tpName |  | Text(255) |  | Y | ชื่อผู้จ่ายเงิน | tp_name |
| 7 | Expect Date | expectDate |  | Datetime |  | Y | วันที่คาดว่าจะได้รับเงิน | expect_date |
| 8 | Expect Receive Amount | expectAmount |  | Number(16,2) |  | Y | เงินที่คาดว่าจะได้รับ | expect_amount |
| 9 | Receive Date | receiveDate |  | Datetime |  |  | วันที่ได้รับเงิน | receive_date |
| 10 | Receive Amount | receiveAmount |  | Number(16,2) |  |  | จำนวนเงินที่ได้รับ | receive_amount |
| 11 | Payee Name | name |  | Text |  |  |  |  |
| 12 | Payee Address | address |  | Text |  |  |  |  |
| 13 | Amount | amount |  | Number(16,2) |  |  |  |  |
| 14 | Reason | reason |  | Picklist? / Text? |  |  |  |  |
| 15 | Description | description |  | Text |  |  |  |  |

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

### Example / Code Payload (Row 38)
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

### Example / Code Payload (Row 39)
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
