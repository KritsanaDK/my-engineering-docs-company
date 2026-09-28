# [54] Microservice-VRA Request

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-VRA Request`
- **Total Rows Parsed**: `23`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/api/vrarequest`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/api/vrarequest |
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
| 1 | Reference ID | refId | ID | Text(255) | Y | Y | Unique ID invitation ID |
| 2 | URL | url | tspa__customerLink__c | Text(255) |  | Y |  |
| 3 | Account ID | accountID | Account__c | Text(18) | Y | Y | Unique ID Account |
| 4 | Agent Name | agentName | Owner.Name | Text(255) |  |  |  |

### Example / Code Payload (Row 16)
**Example Request**
```json
{
  "refID": "a24N0000002IYOxIAO",
  "url": "https://ka-uat.sf-na.techsee.me/app/02bg7uxf/sf",
  "accountID": "0014x00001OkYKoAAN",
  "agentName": "สมชาย ใจดี"
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |

### Example / Code Payload (Row 22)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53"
}
```

### Example / Code Payload (Row 23)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Missing required field Account ID",
  "timestamp": "2022-01-28T11:24:53"
}
```
