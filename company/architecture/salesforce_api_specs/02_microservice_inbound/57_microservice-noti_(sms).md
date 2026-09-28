# [57] Microservice-Noti (SMS)

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Noti (SMS)`
- **Total Rows Parsed**: `23`

## API Specification Overview

- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### E

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/api/v1/sf/notification/sms |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/sf/notification/sms |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Phone | phone |  | Array |  | Y | เบอร์โทรศัพท์ที่ต้องการส่ง SMS |
| 2 | Content | content |  | Text(2000) |  | Y | ข้อความ |

### Example / Code Payload (Row 15)
**Example Request**
```json
{
    "phone": ["0899999999","0899999999"],
    "content": "เรียนแจ้งลูกค้า ขอบคุณที่ใช้บริการ ISV"
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Title | title |  | Text |  |  |  |
| 2 | Status | status |  | Int |  |  |  |
| 3 | Description | description |  | Text |  |  |  |
| 4 | Result | result |  | Text |  |  |  |

### Example / Code Payload (Row 22)
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
