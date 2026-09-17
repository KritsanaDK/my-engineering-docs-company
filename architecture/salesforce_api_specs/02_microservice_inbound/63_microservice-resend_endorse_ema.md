# [63] Microservice-Resend endorse Ema

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Resend endorse Ema`
- **Total Rows Parsed**: `22`

## API Specification Overview

- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### E

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/doc/sf/resendEmailEndorse |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/doc/sf/resendEmailEndorse |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Endorsement Number | endorse_no |  | Text(20) | Y | Y | เลขที่ของ  Policy Id เฉพาะเลขสลักหลัง |
| 2 | Email | email |  | Text(40) |  | Y | Email ที่ต้องการส่ง |

### Example / Code Payload (Row 15)
**Example Request**
```json
{
"endorse_no" : "MV-0023-D-000775-011",
"email" : "chanin.chain@gmail.com"
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status | status |  | Int |  |  |  |
| 2 | Error_code | error_code |  | Int |  |  |  |
| 3 | Message | msg |  | Text |  |  |  |
| 4 | Result | result |  | Object |  |  |  |

### Example / Code Payload (Row 22)
**Example Response
(Success)**
```json
{
    "status": 200,
    "error_code": 0,
    "msg": "success",
    "result": {}
}
```
