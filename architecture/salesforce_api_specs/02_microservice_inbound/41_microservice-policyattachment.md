# [41] Microservice-PolicyAttachment

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-PolicyAttachment`
- **Total Rows Parsed**: `32`

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
| No | Update Payment |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Table | GCP Field | GCP Remark |
| 1 | Function API | fn |  | Text |  |  | Fix: PolicyAttachment |  |  |  |
| 2 | File ID | fileID | ID | Text(18) | Y |  | Attachment Unique ID | Policy_Regis_Evident | sf_file_id |  |
| 3 | Name | name | Name | Text(255) |  | Y | Name of the attached file. Maximum size is 255 characters. Label is File Name. | Policy_Regis_Evident | Evi_name |  |
| 4 | Content Type | contentType | Contenttype | Text(255) |  | Y | https://en.wikipedia.org/wiki/Media_type The content type of the attachment. If the Don't allow HTML uploads as attachments or document records security setting is enabled for your organization, you cannot upload files with the following file extensions: .htm, .html, .htt, .htx, .mhtm, .mhtml, .shtm, .shtml, .acgi, .svg.  When you insert a document or attachment through the API, make sure that this field is set to the appropriate MIME type. | Policy_Regis_Evident | Evi_type |  |
| 5 | Description | description | Description | Text(255) |  |  | File Description | Policy_Regis_Evident | Evi_desc |  |
| 6 | Body | body | Body | base64 |  | Y | Required. Encoded file data. | Policy_Regis_Evident | Evi_path |  |
| 7 | Policy Number | insurancePolicyId | InsurancePolicyId | Text(255) | Y | Y | เลขที่ของ  Policy Id | Policy_Regis_Evident | Policy_No |  |
| 8 | TransactionNumber | transactionNumber | TransactionNumber, External_ID__c | Text | Y |  | An identifier for the transaction from an external system. | Policy_Regis_Evident | SF_Policy_Id |  |
| 9 | IsDeleted | isDeleted | IsDeleted | Boolean |  | Y | for delete file | Policy_Regis_Evident | Evi_isdel |  |
| 10 | File Code | code |  | Picklist |  | Y | (Add 31/03/2023) ประเภทไฟล์ที่นำเข้า List  car_front = รูปหน้าด้านหน้ารถ car_back = รูปหน้าด้านหลังรถ car_left = รูปหน้าด้านซ้ายรถ car_right = รูปหน้าด้านขวารถ cctv = กล้อง carry_boy = แครี่บอย skirt = สเกิร์ตรอบคัน pipe = ปลายท่อ wheel = แมค/ล้อ endorse = เอกสารสลักหลังอื่นๆ access = อุปกรณ์ตกแต่งอื่นๆ | Policy_Regis_Evident | Evi_Sector_ID |  |

### Example / Code Payload (Row 23)
**Example Request**
```json
{
    "fn": "PolicyAttachment",
    "fileID": 2,
    "name": "เอกสารเปลี่ยนชื่อ",
    "contentType": "image/jpg",
    "description": "เอกสารเปลี่ยนชื่อ",
    "body": "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAADMElEQVR4nOzVwQnAIBQFQYXff81RUkQCOyDj1YOPnbXWPmeTRef+/3O/OyBjzh3CD95BfqICMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMK0CMO0TAAD//2Anhf4QtqobAAAAAElFTkSuQmCC",
    "insurancePolicyId": "MV-0023-C-00002m",
    "transactionNumber":"1",
    "isDeleted": false,
    "code": "endorse"
}
```

| Col1 | Source - Field Name | Source - Field Name (Service Model) | SF Field | Col5 | Type | External Key | Required Field | Col9 | Col10 | Remark | GCP Table | GCP Field | GCP Remark |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Response title | title |  |  | Text(50) |  | Y |  |  |  |  |  |  |
| 2 | Status code | status |  |  | Int |  | Y |  |  |  |  |  |  |
| 3 | Description | description |  |  | Text(500) |  | Y |  |  |  |  |  |  |
| 4 | Result | result |  |  | Object |  | Y |  |  |  |  |  |  |
| 4.1 | File ID | fileID |  |  | Text |  |  |  |  | Evi_path |  |  |  |
| 4.2 | File URL | fileURL |  |  | Text |  |  |  |  |  |  |  |  |

### Example / Code Payload (Row 31)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 200,
    "description": "",
    "result": {}
}
```

### Example / Code Payload (Row 32)
**Example Response
(Error)**
```json
{
    "title": "Unsuccess",
    "status": 401,
    "description": "Key (\"Policy_No\", \"Evi_ID\", \"Evi_Sector_ID\")=(MV-0023-C-00005m, 1, endorse) already exists.",
    "result": {}
}
```
