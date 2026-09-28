# [64] Microservice-FileAttachment

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-FileAttachment`
- **Total Rows Parsed**: `31`

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

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Table | GCP Field | GCP Remark |
| 1 | Function API | fn |  | Text |  |  | Fix: fileAttachment |  |  |  |
| 2 | File ID | fileID | ID | Text(18) | Y |  | Attachment Unique ID | sf_claim_attech | file_id |  |
| 3 | Name | name | Name | Text(255) |  | Y | Name of the attached file. Maximum size is 255 characters. Label is File Name. | sf_claim_attech | name |  |
| 4 | Content Type | contentType | Contenttype | Text(255) |  | Y | https://en.wikipedia.org/wiki/Media_type The content type of the attachment. If the Don't allow HTML uploads as attachments or document records security setting is enabled for your organization, you cannot upload files with the following file extensions: .htm, .html, .htt, .htx, .mhtm, .mhtml, .shtm, .shtml, .acgi, .svg.  When you insert a document or attachment through the API, make sure that this field is set to the appropriate MIME type. | sf_claim_attech | content_type |  |
| 5 | Description | description | Description | Text(255) |  |  | File Description | sf_claim_attech | description |  |
| 6 | Body | body | Body | base64 |  | Y | Required. Encoded file data. | sf_claim_attech | body |  |
| 7 | Case ID | caseID |  | Text(18) | Y |  |  | sf_claim_attech | case_id |  |
| 8 | Chat ID | chatID |  | Text(80) | Y |  | External Token |  |  |  |

### Example / Code Payload (Row 21)
**Example Request**
```json
{
  "ID": "5001y0000018pGJAAY",
  "Name": "diagram.png",
  "Contenttype": "image/png",
  "Description": "",
  "Body": "iVBORw0KGgoAAAAN...",
  "claimNumber": "5001y0000019K9BAAU"
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field |  | Type | External Key | Required Field |
| 1 | Response title | title |  |  | Text(50) |  | Y |
| 2 | Status code | status |  |  | Int |  | Y |
| 3 | Description | description |  |  | Text(500) |  | Y |
| 4 | Result | result |  |  | Object |  | Y |
| 4.1 | File ID | fileID | ID | Text(18) | Y |  |  |
| 4.2 | URL | fileURL |  | Text(255) |  |  | URL for access file |

### Example / Code Payload (Row 30)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 200,
    "description": "",
    "result": {
        "fileID": "5",
        "fileURL": "https://storage.googleapis.com/insurverse-storage-develop/เอกสารเปลี่ยนชื่อ.jpg"
    }
}
```

### Example / Code Payload (Row 31)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Policy number not found",
  "timestamp": "2022-01-28T11:24:53"
}
```
