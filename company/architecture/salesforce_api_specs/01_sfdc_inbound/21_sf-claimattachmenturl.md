# [21] SF-ClaimAttachmentURL

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-ClaimAttachmentURL`
- **Total Rows Parsed**: `38`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertclaimattachmenturl`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertclaimattachmenturl |
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
| 6 | Case | caseID | Case__c | Text(18) | Y |  |  | case_id |  |
| 7 | Claim Number | claimNumber | Claim__c | Text | Y |  | Claim Unique ID or Notify No | claim_number or RefNotiNo |  |
| 8 | E Claim ID | eClaimID | Claim_Coverage__c | Text | Y |  | Claim Coverage External ID | e_claim_id |  |
| 9 | SRID | surveyorReportID | Surveyor_Report__c | Text(20) | Y |  | Surveyor Report ID | surveyor_report_id |  |
| 10 | Item Number | itemID | Claim_Item__c/Claim_Participant__c | Text(30) | Y |  | เลข Unique ID ของรายการที่เสียหาย (Car, Injury, Asset) | item_id |  |
|  | Note ID | noteID |  | Text(18) |  |  | เลข Unique ID ของรายการบันทึกข้อความ |  |  |
| 11 | IsDeleted | isDeleted |  | Boolean |  | Y | for delete file | 1 |  |
| 12 | URL | url | url__c | Text(255) |  | Y | URL สำหรับ Access file | url |  |
|  | File Type | fileType | File_Type__c | Text(255) |  |  | ประเภทของ File ได้แก่ - เอกสารอนุมัติซ่อม - ใบรับรถ - รูปภาพประกอบ - ใบเรียกเก็บเงิน - อื่นๆ |  |  |

### Example / Code Payload (Row 27)
**Example Request**
```json
[
  {
    "fileID": "06878000001Je2iAAC",
    "name": "1692158299251_1692110802526.jpeg",
    "contentType": "image/jpeg",
    "description": "tp",
    "thumbnail": "Thumbnail Encoded Image",
    "caseID": "50078000004Qs5BAAS",
    "claimNumber": "CC-23-MV-00379",
    "eClaimID": null,
    "surveyorReportID": null,
    "itemID": null,
    "isDeleted": false,
    "url": "https://storage.googleapis.com/insurverse-storage-uat/1692158299251_1692110802526.jpeg"
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

### Example / Code Payload (Row 37)
**Example Response
(Success)**
```json
{
  "timeStamp": "2023-08-15T11:03:23",
  "statusCode": "0000",
  "message": "Success",
  "data": [
    {
      "isSuccess": true,
      "fileID": "a8605000000CduZAAS",
      "errorMessage": "()"
    }
  ]
}
```

### Example / Code Payload (Row 38)
**Example Response
(Error)**
```json
{
  "timeStamp": "2023-08-16T03:58:23",
  "statusCode": "1000",
  "message": "Upsert Claim Attachment URL failed due to exception: System.QueryException, List has no rows for assignment to SObject, Class.WSUpsertClaimAttachmentUrlController.getFileURL: line 186, column 1\nClass.WSUpsertClaimAttachmentUrlController.processRequest: line 33, column 1\nClass.WSUpsertClaimAttachmentUrlService.upsertPolicy: line 9, column 1",
  "data": null
}
```
