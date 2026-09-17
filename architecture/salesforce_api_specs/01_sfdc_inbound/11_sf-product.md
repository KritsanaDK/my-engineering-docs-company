# [11] SF-Product

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Product`
- **Total Rows Parsed**: `28`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertproduct`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertproduct |
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
| 0 |  |  |  | Array |  |  |  |
| 1 | Product ID | productID | Id | Text(18) | Y |  | product Unique ID |
| 2 | ProductType | productType | ProductType | Picklist |  | Y | Coverage Spec, Insured Item Spec, Insured Party Spec, Product |
| 3 | ProductName | productName | Name | Text(255) |  | Y | ชื่อสินค้า |
| 4 | IsActive | isActive | IsActive | Boolean |  | Y | true, false |

### Example / Code Payload (Row 17)
**Example Request**
```json
[
  {
    "productType": "Coverage Spec",
    "productName": "Bodily Injury & Property Damage",
    "isActive": true
  }
]
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Product ID | productID | Id | Text(18) | Y |  |  |
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
      "productID": "P00001",
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
      "productID": "P00001",
      "isSuccess": false,
      "errorMessage": "Error Message"
    }
  ]
}
```
