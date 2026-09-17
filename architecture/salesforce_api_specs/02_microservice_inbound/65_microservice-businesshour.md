# [65] Microservice-BusinessHour

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-BusinessHour`
- **Total Rows Parsed**: `25`

## API Specification Overview

- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/sf/saleforceControllerAPI |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/sf/saleforceControllerAPI |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Function API | fn |  | Text |  |  | Fix: livechatHour |
| 2 | Start Time | startTime |  | Time |  | Y | Start time for business hour |
| 3 | End Time | endTime |  | Time |  | Y | End time for business hour |
| 4 | Display Message Thai | displayMessageTH |  | Text(2000) |  | Y | Thai message should dispay in case customer call service out off business hour |
| 5 | Display Message English | displayMessageEN |  | Text(2000) |  | Y | English message should dispay in case customer call service out off business hour  Note : SF has only Message Thai then Display Message English will has same value with Display Message Thai |

### Example / Code Payload (Row 18)
**Example Request**
```json
{
  "fn":"livechatHour",
  "startTime": "8:00",
  "endTime": "17:00",
  "displayMessageEN": "xxxxxx",
  "displayMessageTH": "กกกกกก"
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Response title | title |  | Text(50) |  | Y |  |
| 2 | Status code | status |  | Int |  | Y |  |
| 3 | Description | description |  | Text(500) |  | Y |  |

### Example / Code Payload (Row 24)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 200,
    "description": ""
}
```

### Example / Code Payload (Row 25)
**Example Response
(Error)**
```json
{
    "title": "Fail",
    "status": 100,
    "description": "Unknown Error"
}
```
