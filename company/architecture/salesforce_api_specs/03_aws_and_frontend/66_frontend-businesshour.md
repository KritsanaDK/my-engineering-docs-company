# [66] frontend-BusinessHour

- **Category**: `aws_and_frontend`
- **Source Sheet**: `frontend-BusinessHour`
- **Total Rows Parsed**: `23`

## API Specification Overview

- **HTTP Method**: `GET`
- **Headers**:
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/sf/businesshr |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/sf/businesshr |

### HTTP

| Methods | GET |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| API-KEY | (access token) |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Start Time | startTime |  | Time |  | Y | Start time for business hour |
| 2 | End Time | endTime |  | Time |  | Y | End time for business hour |
| 3 | Display Message | displayMessage |  | Text(2000) |  | Y | Message should dispay in case customer call service out off business hour |

### Example / Code Payload (Row 16)
**Example Request**
```json
{
  "startTime": "8:00",
  "endTime": "17:00",
  "displayMessage": "xxxxxx"
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Response title | title |  | Text(50) |  | Y | Success |
| 2 | Status code | status |  | Int |  | Y |  |
| 3 | Description | description |  | Text(500) |  |  |  |

### Example / Code Payload (Row 22)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 200,
    "description": ""
}
```

### Example / Code Payload (Row 23)
**Example Response
(Error)**
```json
{
    "title": "Fail",
    "status": 100,
    "description": "Unknown Error"
}
```
