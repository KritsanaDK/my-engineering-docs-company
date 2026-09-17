# [17] SF-PolicyAttachment

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-PolicyAttachment`
- **Total Rows Parsed**: `28`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpolicyattachment`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertpolicyattachment |
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
| 6 | Policy Number | insurancePolicyId | InsurancePolicyId | Text(255) | Y | Y | เลขที่ของ  Policy Id |
| 7 | Is Deleted | isDeleted | IsDeleted | Boolean |  | Y | for delete file |
| 8 | Is Policy Document | isPolicyDocument |  | Boolean |  | Y | เป็นเอกสาร Policy |

### Example / Code Payload (Row 20)
**Example Request**
```json
{
  "name": " CI_1_รถด้านหน้า",
  "contentType": "image/jpeg",
  "description": "รถด้านหน้า_MV-0023-H-000066_1",
  "body": "Encoded Image String",
  "insurancePolicyId": "MV-0023-H-000066",
  "isDeleted": false,
  "isPolicyDocument": false
}
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | File ID | fileID | ID | Text(18) |  |  |  |

### Example / Code Payload (Row 27)
**Example Response
(Success)**
```json
{
  "timeStamp": "2023-08-03T07:02:46",
  "statusCode": "0000",
  "message": "Success",
  "fileId": "06977000000iAqFAAU"
}
```

### Example / Code Payload (Row 28)
**Example Response
(Error)**
```json
{
  "timeStamp": "2023-08-09T09:45:15",
  "statusCode": "1000",
  "message": "Some error Message"
}
```
