# [40] Microservice - CalculatePolicyP

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice - CalculatePolicyP`
- **Total Rows Parsed**: `27`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/calculatepolicypremium`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/calculatepolicypremium |
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

### 1

### 2

### 3

### 4

### Example / Code Payload (Row 16)
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
| 4 | Result | result |  | Object |  | Y |  |

### 4.1

### 4.2

### 4.3

### Example / Code Payload (Row 26)
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

### Example / Code Payload (Row 27)
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
