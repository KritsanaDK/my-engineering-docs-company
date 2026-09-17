# [04] SFCD OAuth 2.0 Authentication

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SFCD OAuth 2.0 Authentication`
- **Total Rows Parsed**: `33`

## API Specification Overview

- **Endpoint URL**: `https://login.salesforce.com/services/oauth2/token`
- **HTTP Method**: `POST`

## Raw & Structured Data Specification

| Col1 | DEV | SIT | UAT | Production |
| --- | --- | --- | --- | --- |
| End Point | https://test.salesforce.com/services/oauth2/token | https://test.salesforce.com/services/oauth2/token | https://test.salesforce.com/services/oauth2/token | https://login.salesforce.com/services/oauth2/token |
| Client ID | <redacted> | <redacted> | <redacted> | <redacted> |
| Client Secret | <redacted> | <redacted> | <redacted> | <redacted> |
| UserName | integration@insurverse.co.th.dev2 | integration@insurverse.co.th.dev2 | integration@insurverse.co.th.uat2 | integration@insurverse.co.th |
| Password | <redacted> | <redacted> | <redacted> | <redacted> |
| Token | <redacted> | <redacted> | <redacted> | <redacted> |
| instance_url | https://test.salesforce.com | https://test.salesforce.com | https://test.salesforce.com | https://login.salesforce.com |

### 1. Request an Access Token

| Request ใช้สำหรับเรียกขอ Token จากระบบ Salesforce เพื่อให้สามารถนำ token ไปใช้งานในการเข้าถึงระบบ Salesforce ได้ |
| --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/x-www-form-urlencoded | Col3 | Col4 |
| --- | --- | --- | --- |
| Body | Description |  | ExampleValue |
| grant_type | ประเภทของการ Authentication โดยให้ระบุเป็น password เสมอ |  | password |
| client_id | ระบุข้อมูล Client ID ของ Environment หรือ Salesforce Organization ที่ต้องการทำ Authentication |  | <redacted> |
| client_secret | ระบุข้อมูล Client Secret ของ Environment หรือ Salesforce Organization ที่ต้องการทำ Authentication |  | <redacted> |
| username | ระบุ User Name บนระบบ Salesforce |  | insurverse@beryl8.com.integ.dev |
| password | ระบุ Password และ Token ของ User Name นั้นโดยให้ระบุค่า Token ต่อจาก Passord |  | <redacted> |

### Example

| Example request | grant_type=password&client_id=<redacted> &client_secret=<redacted>&username=insurverse@beryl8.com.integ.dev&password=<redacted> |
| --- | --- |

### 2. Response

### Response จากการเรียกขอ Token จากระบบ Salesforce

| Body | Description | Col3 | ExampleValue |
| --- | --- | --- | --- |
| access_token | เป็น Token สำหรับใช้งานเพื่อเข้าถึงระบบ Salesforce ด้วย Session ID นั้นๆ |  | <redacted> |
| instant_url | ใช้เป็น Endpoint สำหรับเข้าถึงระบบ Salesforce |  | https://tipinsurverse--dev.sandbox.my.salesforce.com |
| id | ข้อมูล Salesofce ID ของ User และ  Role |  | https://test.salesforce.com/id/00D1y0000008qhVEAQ/0051y00000MWyGKAA1 |
| token_type | ประเภทของ Token |  | Bearer |
| issued_at | time in milliseconds เมือ่ Signature ถูกสร้าง |  | 1676016592577 |
| signature | Base64-encoded HMAC-SHA256 signature signed with the client_secret (private key) containing the concatenated ID and issued_at. Used to verify that the identity URL hasn’t changed since the server sent it. |  | PgJq+TSjJQXGq5/m+/I/Kg/MvE2LxIeIj9P0cL4OXNA= |

### Example

### Example / Code Payload (Row 33)
**Example response**
```json
{
    "access_token": "<redacted>",
    "instance_url": "https://tipinsurverse--dev.sandbox.my.salesforce.com",
    "id": "https://test.salesforce.com/id/00D1y0000008qhVEAQ/0051y00000MWyGKAA1",
    "token_type": "Bearer",
    "issued_at": "1676016592577",
    "signature": "PgJq+TSjJQXGq5/m+/I/Kg/MvE2LxIeIj9P0cL4OXNA="
}
```
