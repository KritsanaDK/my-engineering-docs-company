# [52] Microservice-ClaimAttachment (E

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-ClaimAttachment (E`
- **Total Rows Parsed**: `23`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/claim/attachmentfileemcs`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/claim/attachmentfileemcs |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 0 |  |  |  | Array |  |  |  |
| 1 | Claim Number | claimNumber | Claim_No__c | Text(80) | Y | Y | Clain Unique ID |
| 2 | eClaim ID | eClaimID |  | Text(80) | Y |  | หมายเลข e-Claim (Claim Coverage External ID) |
| 3 | File Name | fileName |  | Text(255) |  |  | Path for Request File |

### Example / Code Payload (Row 16)
**Example Request**
```json
[
  {
    "claimNumber": "5001y0000019K9BAAU",
    "isApprovedFix": false
  }
]
```

| No | Upsert Invoice | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |

### Example / Code Payload (Row 22)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53"
}
```

### Example / Code Payload (Row 23)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Policy number not found",
  "timestamp": "2022-01-28T11:24:53"
}
```
