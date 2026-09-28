# [30] SF - Update Customer Location

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF - Update Customer Location`
- **Total Rows Parsed**: `28`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/updatecustomerlocation`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/updatecustomerlocation |
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

### 0

### 1

### 2

### 3

### 4

### Example / Code Payload (Row 17)
**Example Request**
```json
[
  {
    "invoiceId": "VPCNC2200007",
    "paidDate": "10-03-2022",
    "totalPaidAmount": 190177.44
  },
  {
    "invoiceId": "VPCNC2200008",
    "paidDate": "21-03-2022",
    "totalPaidAmount": 210656.44
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
| 4.1 | Invoice Number | invoiceId |  | Text(7) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 27)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "invoiceId": "VPCNC2200007",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "invoiceId": "VPCNC2200008",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 28)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "invoiceId": "VPCNC2200007",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "invoiceId": "VPCNC2200008",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
