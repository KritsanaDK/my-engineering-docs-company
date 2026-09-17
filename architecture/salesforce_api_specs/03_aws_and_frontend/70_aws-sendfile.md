# [70] AWS-SendFile

- **Category**: `aws_and_frontend`
- **Source Sheet**: `AWS-SendFile`
- **Total Rows Parsed**: `26`

## API Specification Overview

- **HTTP Method**: `POST`
- **Headers**:
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL SIT | https://insurverse.be8-omni.com/api/v1/sf/saleforceControllerAPI/sendfile |
| --- | --- |
| URL UAT | TBC |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| x-api-key | U09GtUSR6l3tfjVWo0bmf2XolZM1PW8w8Wj8bkWO |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Social ID | socialID | Social_ID__c | Text(30) | Y | Y | Unique ID for identiy user and message channel |
| 2 | Type | fileType |  | Picklist |  |  | https://developers.line.biz/en/docs/messaging-api/message-types/#text-messages Text, Image, Video  text , image , video , audio |
| 3 | URL | fileURL |  | Text(255) |  |  | Public URL that using for access file |
| 4 | Filename | filename |  | Text(255) |  |  | Filename |
| 5 | Channel ID | channelID | Channel_ID__c | Text(255) |  | Y |  |
| 6 | Channel Type | channelType | Channel__c | Picklist |  | Y | Line-Insurverse, Facebook-Insurverse |

### Example / Code Payload (Row 19)
**Example Request**
```json
{
  "socialID": "fafa0r230refakfff-3kf0",
  "fileType": "Message Hello",
  "fileURL": "https://www.google.com",
  "filename": "Text.jpg",
  "channelID": "XXXXX",
  "channelType": "Line-Insurverse"
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Response title | title |  | Text(50) |  | Y | Success |
| 2 | Status code | status |  | Int |  | Y |  |
| 3 | Description | description |  | Text(500) |  |  |  |

### Example / Code Payload (Row 25)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 200,
    "description": ""
}
```

### Example / Code Payload (Row 26)
**Example Response
(Error)**
```json
{
    "title": "Fail",
    "status": 100,
    "description": "Unknown Error"
}
```
