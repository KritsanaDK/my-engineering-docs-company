# [23] SF - Get Knowledge

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF - Get Knowledge`
- **Total Rows Parsed**: `26`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/getknowledge`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/getknowledge |
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
| 1 | Language | language | Language | Picklist | Y |  | en_US, th |

### Example / Code Payload (Row 13)
**Example Request**
```json
{
   "language": "en_US"
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Knowledge ID | knowledgeID | Id | Text(18) | Y |  |  |
| 4.2 | Language | language | language | Text(255) |  |  |  |
| 4.3 | Title | title | Title | Text(2000) |  |  |  |
| 4.4 | Summary | summary | Summary | Text(1000) |  |  |  |
| 4.5 | Detail | detail | Answer__c | Text(32000) |  |  |  |

### Example / Code Payload (Row 25)
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

### Example / Code Payload (Row 26)
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
