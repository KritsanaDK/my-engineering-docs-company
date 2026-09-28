# [31] Microservice Authen

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice Authen`
- **Total Rows Parsed**: `35`

## API Specification Overview

- **Endpoint URL**: `https://api.insurverse.co.th/api/v1/auth/login`
- **HTTP Method**: `POST`
- **Headers**:
  - `Content-Type: application/json`

## Raw & Structured Data Specification

| Col1 | DEV | UAT | Production |
| --- | --- | --- | --- |
| End Point | https://isv-api-dev.flybkk.com/api/v1/auth/login | https://sandbox-uat-api.insurverse.co.th/api/v1/auth/login | https://api.insurverse.co.th/api/v1/auth/login |
| email | api@sf.com | api@sf.com | api@sf.com |
| hashpassword | @ddsLjso$1dcv | @ddsLjso$1dcv | @ddsLjso$1dcv |

### 1. Request an Access Token

### ใข้สำหรับเรียกขอ Token

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 |
| --- | --- | --- |
| Body | Description | ExampleValue |
| email | E-mail สำหรับขอ Token | api@sf.com |
| hashpassword | password สำหรับขอ Token | @ddsLjso$1dcv |

### Example

### Example / Code Payload (Row 15)
**Example request**
```json
{
    "email":"api@sf.com",
    "hashpassword":"@ddsLjso$1dcv"
}
```

### 2. Response

### Response จากการเรียกขอ Token จากระบบ

| No | Body | Description | ExampleValue |
| --- | --- | --- | --- |
| 1 | title |  | Authen Service |
| 2 | status |  | 200 |
| 3 | description |  |  |
| 4 | result |  |  |
| 4.1 | prefix_name |  |  |
| 4.2 | first_name |  |  |
| 4.3 | last_name |  |  |
| 4.4 | email |  | api@sf.com |
| 4.5 | mobile |  |  |
| 4.6 | email_verified |  | true |
| 4.7 | mobile_verified |  | false |
| 4.8 | id |  | 40186ca0-f079-488e-b0eb-b173d9c467e6 |
| 4.9 | token |  | eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcmVmaXhfbmFtZSI6IiIsImZpcnN0X25hbWUiOiIiLCJsYXN0X25hbWUiOiIiLCJlbWFpbCI6ImFwaUBzZi5jb20iLCJtb2JpbGUiOiIiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibW9iaWxlX3ZlcmlmaWVkIjpmYWxzZSwiaWQiOiI0MDE4NmNhMC1mMDc5LTQ4OGUtYjBlYi1iMTczZDljNDY3ZTYiLCJ0b2tlbiI6IiIsImV4cCI6MTY4MDU5MzY0MywiaWF0IjoxNjgwNTA3MjQzfQ.din5xQjvqBbSmlmkIZeJumwyqQZ8C8J9CJteUD7tDWk |
| 4.10 | exp |  | 1680593643 |
| 4.11 | iat |  | 1680507243 |

### Example

### Example / Code Payload (Row 35)
**Example response**
```json
{
    "title": "Authen Service",
    "status": 200,
    "description": "",
    "result": {
        "prefix_name": "",
        "first_name": "",
        "last_name": "",
        "email": "api@sf.com",
        "mobile": "",
        "email_verified": true,
        "mobile_verified": false,
        "id": "40186ca0-f079-488e-b0eb-b173d9c467e6",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcmVmaXhfbmFtZSI6IiIsImZpcnN0X25hbWUiOiIiLCJsYXN0X25hbWUiOiIiLCJlbWFpbCI6ImFwaUBzZi5jb20iLCJtb2JpbGUiOiIiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibW9iaWxlX3ZlcmlmaWVkIjpmYWxzZSwiaWQiOiI0MDE4NmNhMC1mMDc5LTQ4OGUtYjBlYi1iMTczZDljNDY3ZTYiLCJ0b2tlbiI6IiIsImV4cCI6MTY4MDU5MzY0MywiaWF0IjoxNjgwNTA3MjQzfQ.din5xQjvqBbSmlmkIZeJumwyqQZ8C8J9CJteUD7tDWk",
        "exp": 1680593643,
        "iat": 1680507243
    }
}
```
