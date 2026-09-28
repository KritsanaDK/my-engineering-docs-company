# [59] Microservice-Delete File URL

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Delete File URL`
- **Total Rows Parsed**: `26`

## API Specification Overview

- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### E

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/sf/notification/noti |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/sf/notification/noti |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 0 |  |  |  | Array |  |  |  |
| 1 | File ID | fileID | File_ID__c/Id | Text(18) | Y | Y | Attachment Unique ID |

### Example / Code Payload (Row 15)
**Example Request**
```json
[ { "fileID": "5001y0000018pGJAAY" } ]
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Title | title |  | Text |  |  |  |
| 2 | Status | status |  | Int |  |  |  |
| 3 | Description | description |  | Text |  |  |  |
| 4 | Data | data |  | Array |  |  |  |
| 4.1 | File ID | fileID | ID | Text(18) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 25)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "data" : [
    {
      "fileID": "5001y0000018pGJAAY",
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
  "message": "Policy number not found",
  "timestamp": "2022-01-28T11:24:53"
}
```
