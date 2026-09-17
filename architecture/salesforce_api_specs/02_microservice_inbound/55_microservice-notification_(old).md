# [55] Microservice-Notification (Old)

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Notification (Old)`
- **Total Rows Parsed**: `26`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/api/notification`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/api/notification |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Table | GCP Field | GCP Remark |
| 1 | Source System | source |  | Picklist |  | Y | SF (Fix) | sf_notification | source |  |
| 2 | Notification Type | notiType |  | Picklist |  | Y | SMS/App/PWA | sf_notification | noti_type |  |
| 3 | Mobile Phone | mobilePhone | Phone__c | Array |  | Y (SMS) |  | sf_notification | mobile_phone |  |
| 4 | Account ID | accountID | Account__c | Array |  | Y (App/PWA) |  | sf_notification | account_id |  |
| 5 | Subject | subject | Subject__c | Text(255) |  | Y |  | sf_notification | subject |  |
| 6 | Message | message | Message__c | Text(2000) |  | Y |  | sf_notification | message |  |

### Example / Code Payload (Row 18)
**Example Request (SMS)**
```json
{
  "source": "SF",
  "notiType": "SMS",
  "mobilePhone": ["0929505991"],
  "subject": "Header",
  "message": "body"
}
```

### Example / Code Payload (Row 19)
**Example Request (App)**
```json
{
  "source": "SF",
  "notiType": "SMS",
  "accountID": ["0014x00001OkYKoAAN"],
  "subject": "Header",
  "message": "body"
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |

### Example / Code Payload (Row 25)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53"
}
```

### Example / Code Payload (Row 26)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Missing required field mobile phone",
  "timestamp": "2022-01-28T11:24:53"
}
```
