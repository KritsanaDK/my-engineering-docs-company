# [26] SF-FileAttachmentURL

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-FileAttachmentURL`
- **Total Rows Parsed**: `33`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertfileattachmenturl`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertfileattachmenturl |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field | GCP Remark |
| 0 |  |  |  | Array |  |  |  |  |  |
| 1 | File ID | fileID | File_ID__c | Text(18) | Y |  | Attachment Unique ID | file_id |  |
| 2 | Name | name | File_Name__c | Text(255) |  | Y | Name of the attached file. Maximum size is 255 characters. Label is File Name. | name |  |
| 3 | Content Type | contentType | Content_Type__c | Text(255) |  | Y | https://en.wikipedia.org/wiki/Media_type The content type of the attachment. If the Don't allow HTML uploads as attachments or document records security setting is enabled for your organization, you cannot upload files with the following file extensions: .htm, .html, .htt, .htx, .mhtm, .mhtml, .shtm, .shtml, .acgi, .svg.  When you insert a document or attachment through the API, make sure that this field is set to the appropriate MIME type. | content_type |  |
| 4 | Description | description | Description__c | Text(255) |  |  | File Description | description |  |
| 5 | Thumbnail | thumbnail | Thumbnail__c | base64 |  | Y | Required. Encoded file data.   (Not Exceed 1MB) | รูปแปลงเป็น Thumbnail |  |
| 6 | Chat ID | chatID |  | Text(18) | Y |  |  |  |  |
| 7 | Case ID | caseID |  | Text(18) | Y |  |  |  |  |
| 11 | IsDeleted | isDeleted |  | Boolean |  | Y | for delete file | 1 |  |
| 12 | URL | url | url__c | Text(255) |  | Y | URL สำหรับ Access file | url |  |

### Example / Code Payload (Row 22)
**Example Request**
```json
[
  {
    "fileID": "240110F0000080",
    "name": "file_489938583042916710.docx",
    "contentType": "image/jpeg",
    "description": null,
    "thumbnail": "Encoded Thumbnail Image",
    "chatID": "c188e5bf-9a33-5fc0-a692-588dfc208964",
    "caseID": null,
    "isDeleted": false,
    "url": "https://storage.googleapis.com/insurverse-storage-develop/20240110033057997_NIDDMH.docx"
  }
]
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Data | data |  | Array |  |  |  |
| 4.1 | File ID | fileID | ID | Text(18) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message |  |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 32)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "data" : [
    {
      "fileID": "123456789",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 33)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Policy number not found",
  "timestamp": "2022-01-28T11:24:53"
}
```
