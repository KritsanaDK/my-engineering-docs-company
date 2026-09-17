# [56] Microservice-Noti (Email)

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Noti (Email)`
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

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/sf/notification/email |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/sf/notification/email |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Sender | sender |  |  |  | Y | ผู้ส่ง |
| 2 | Subject | subject |  |  |  | Y | หัวข้อ/เรื่อง |
| 3 | Content | content |  |  |  | Y | ข้อความที่ต้องการแสดงผลรองรับ HTML |
| 4 | E-mail to | email |  | Array |  | Y | ส่งให้กับ |
| 5 | Attach File | attach |  | Array |  | Y | ไฟล์แนบ |

### Example / Code Payload (Row 18)
**Example Request**
```json
{
    "sender": "epolicy",
    "subject": "Test",
    "content": "<html><head><title>Page Title</title></head><body><h1>My First Heading</h1><p>My first paragraph.</p></body></html>",
    "email": [
        "chaipipat.pidej@gmail.com"
    ],
    "attach": [
        {
            "filename": "test1.csv",
            "filebase64": "data:application/csv;base64,cGxheWVyX2lkLGV4dGVybmFsX3VzZXJfaWQsZmlyc3RfbmFtZQ=="
        },
                {
            "filename": "test2.csv",
            "filebase64": "data:application/csv;base64,cGxheWVyX2lkLGV4dGVybmFsX3VzZXJfaWQsZmlyc3RfbmFtZQ=="
        }
    ]
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Title | title |  | Text |  |  |  |
| 2 | Status | status |  | Int |  |  |  |
| 3 | Description | description |  | Text |  |  |  |
| 4 | Result | result |  | Text |  |  |  |

### Example / Code Payload (Row 25)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 0,
    "description": "",
    "result": ""
}
```

### Example Response
(Error)
