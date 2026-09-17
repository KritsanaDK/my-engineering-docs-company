# [72] Microservice-Resend compulsory 

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Resend compulsory `
- **Total Rows Parsed**: `22`

## API Specification Overview

- **HTTP Method**: `GET`
- **Headers**:
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### E

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/doc/act/repair/{MC_Policy_Number}/{Email} |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/doc/act/repair/{MC_Policy_Number}/{Email} |

### HTTP

| Methods | GET |
| --- | --- |

### Header

| Content-Type | application/json |
| --- | --- |

### Authorization

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Policy Number | MC_Policy_Number |  |  | Y | Y | เลขที่ของ  Policy Id เฉพาะกรมธรรม์ พรบ MC |
| 2 | Email | Email |  |  |  | Y | Email ที่ต้องการส่ง |

### Example Request

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
