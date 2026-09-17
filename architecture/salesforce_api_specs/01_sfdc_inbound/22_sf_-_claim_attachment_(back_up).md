# [22] SF - Claim Attachment (Back Up)

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF - Claim Attachment (Back Up)`
- **Total Rows Parsed**: `27`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertclaimattachment`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertclaimattachment |
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
| 1 | File ID | fileID | ID | Text(18) | Y |  | Attachment Unique ID |
| 2 | Name | name | Name | Text(255) |  | Y | Name of the attached file. Maximum size is 255 characters. Label is File Name. |
| 3 | Content Type | contentType | Contenttype | Text(255) |  | Y | https://en.wikipedia.org/wiki/Media_type The content type of the attachment. If the Don't allow HTML uploads as attachments or document records security setting is enabled for your organization, you cannot upload files with the following file extensions: .htm, .html, .htt, .htx, .mhtm, .mhtml, .shtm, .shtml, .acgi, .svg.  When you insert a document or attachment through the API, make sure that this field is set to the appropriate MIME type. |
| 4 | Description | description | Description | Text(255) |  |  | File Description |
| 5 | Body | body | Body | base64 |  | Y | Required. Encoded file data. |
| 6 | Claim Number | claimNumber | Name | Text |  | Y | Clain Unique ID |
| 7 | IsDeleted | isDeleted | IsDeleted | Boolean |  | Y | for delete file |

### Example / Code Payload (Row 19)
**Example Request**
```json
{
  "fileID": "123456789",
  "name": "Claim Document",
  "contentType": "PDF",
  "description": "Document related to the claim",
  "body": "Base64 encoded string representation of the file contents",
  "claimNumber": "987654321",
  "isDeleted": false
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field |  | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |  |
| 4 | File ID | fileID | ID | Text(18) |  |  |  |  |

### Example / Code Payload (Row 26)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "fileID": "5001y0000018pGJAAY"
}
```

### Example / Code Payload (Row 27)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Policy number not found",
  "timestamp": "2022-01-28T11:24:53"
}
```
