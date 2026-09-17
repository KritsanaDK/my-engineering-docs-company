# [18] SF-PolicyAttachment (URL)

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-PolicyAttachment (URL)`
- **Total Rows Parsed**: `33`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpolicyattachmenturl`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertpolicyattachmenturl |
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
| 0 |  |  |  | Array |  |  |  |
| 1 | File ID | fileID | File_ID__c | Text(18) | Y |  | Attachment Unique ID |
| 2 | Name | name | File_Name__c | Text(255) |  | Y | Name of the attached file. Maximum size is 255 characters. Label is File Name. |
| 3 | Content Type | contentType | Content_Type__c | Text(255) |  | Y | https://en.wikipedia.org/wiki/Media_type The content type of the attachment. If the Don't allow HTML uploads as attachments or document records security setting is enabled for your organization, you cannot upload files with the following file extensions: .htm, .html, .htt, .htx, .mhtm, .mhtml, .shtm, .shtml, .acgi, .svg.  When you insert a document or attachment through the API, make sure that this field is set to the appropriate MIME type. |
| 4 | Description | description | Description__c | Text(255) |  |  | File Description |
| 5 | Thumbnail | thumbnail | Thumbnail__c | base64 |  | Y | Required. Encoded file data.  (Not Exceed 1MB) |
| 6 | Policy Number | insurancePolicyId | Insurance_Policy__c | Text(255) | Y | Y | เลขที่ของ  Policy Id |
| 7 | TransactionNumber | transactionNumber | Insurance_Policy_Transaction__c | Text(18) | Y |  | An identifier for the transaction from an external system. x10 : transactionID |
| 8 | Is Deleted | isDeleted |  | Boolean |  | Y | for delete file |
| 9 | URL | url | url__c | Text(255) |  | Y | URL สำหรับ Access file |

### Example / Code Payload (Row 22)
**Example Request**
```json
[
  {
    "name": "MV-0023-H-000077 กรมธรรม์ฉบับสำเนา",
    "contentType": "image/jpeg",
    "description": "กรมธรรม์ฉบับสำเนา",
    "thumbnail": "Encoded Thumbnail Image",
    "insurancePolicyId": "MV-0023-H-000077",
    "isDeleted": false,
    "url": "https://storage.googleapis.com/insurverse-storage-develop/1691046676416760355.pdf"
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
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 32)
**Example Response
(Success)**
```json
{
  "timeStamp": "2023-08-03T07:11:33",
  "statusCode": "0000",
  "message": "Success",
  "data": [
    {
      "isSuccess": true,
      "fileID": "a8677000000GuvlAAC",
      "errorMessage": "()"
    }
  ]
}
```

### Example / Code Payload (Row 33)
**Example Response
(Error)**
```json
{
  "timeStamp": "2023-08-03T07:01:10",
  "statusCode": "1000",
  "message": "Missing Required Field: ((Database.Error[getFields=();getMessage=Foreign key external ID: mv-0023-h-000066 not found for field External_ID__c in entity InsurancePolicy;getStatusCode=INVALID_FIELD;]))",
  "data": null
}
```
