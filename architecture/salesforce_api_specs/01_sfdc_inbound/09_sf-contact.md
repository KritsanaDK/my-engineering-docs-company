# [09] SF-Contact

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Contact`
- **Total Rows Parsed**: `28`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertcontact`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertcontact |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Invoice |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Contact ID | contactID | Id | Text(18) | Y |  | Contact Unique ID |
| 2 | Salutation | salutation | Salutation | Text(40) |  | Y | คำนำหน้า |
| 3 | Firstname | firstname | FirstName | Text(40) |  | Y | ชื่อ |
| 4 | Lastname | lastname | LastName | Text(80) |  | Y | นามสกุล |
| 5 | Account ID | accountID | AccountID | Text(18) |  | Y | ลูกค้าที่สัมพันธ์กับ Contact |
| 6 | Fax | fax | Fax | Text(10) |  |  |  |
| 7 | Mobile Phone | mobilePhone | MobilePhone | Text(40) |  |  | ชื่อผู้ติดต่อ |
| 8 | Title | title | Title | Text(128) |  |  | ตำแหน่ง |

### Example / Code Payload (Row 20)
**Example Request**
```json
{
    "contactID": "0034x00001H6WfdAAF",
    "salutation": "นาย",
    "firstname": "สมชาย",
    "lastname": "ใจดี",
    "accountID": "0014x00001OkYKoAAN"
  }
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Contact ID | contactID | Id | Text(18) | Y |  |  |

### Example / Code Payload (Row 27)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "contactID": "0034x00001H6WfdAAF" 
}
```

### Example / Code Payload (Row 28)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Missing required field lastname",
  "timestamp": "2022-01-28T11:24:53"
}
```
