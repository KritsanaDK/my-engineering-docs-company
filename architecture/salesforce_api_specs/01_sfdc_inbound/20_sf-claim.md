# [20] SF-Claim

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Claim`
- **Total Rows Parsed**: `40`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertclaim`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertclaim |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |
| No | Upsert Invoice |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | Mapping PWA Request |
| 1 | REF_NOTIFY_NO | refNotifyNo | Notify_No__c | Text(20) | Y |  | เลขรับแจ้ง | ref_notify_no |
| 2 | STATUS | status | PWA_Status__c | Picklist |  |  | New = create, in-process Submit = จบ flow |  |
| 3 | REQUEST_CLAIM_ID | requestClaimId |  | int |  |  | เลขรัับแจ้งจาก Microservice | request_claim_id |
| 4 | PRB_NUMBER | prbNumber | Compulsory__c | Text(30) |  |  | กรมธรรม์(พรบ.) | policy_no |
| 5 | ACC_POLICY_NO | accPolicyNo | PolicyNumber.External_ID__c | Text(30) |  |  | กรมธรรม์เลขที่ | policy_no |
| 6 | ACC_DATE | accidentDate | Loss_Date__c | Datetime |  | Y | เวลาที่เกิดเหตุ | accident_date |
| 7 | ACC_CAUSE | accidentCause | Accident_Cause__c | int |  |  | เป็นฝ่ายประมาท (1=ผู้ขับขี่รถประกัน, 2=ผู้ขับขี่รถคู่กรณี, 3=ประมาททั้งสองฝ่าย, 4=รอสรุปผลคดี) | accident_cause |
| 8 | REQUEST_PHONE | requestPhone | Informer_Mobile__c | text(20) |  | Y | เบอร์ผู้แจ้ง | request_phone |
| 9 | TP_PHONE | tpPhone | Third_Party_Phone__c | text(20) |  |  | เบอร์คู่กรณี | tp_phone |
| 10 | ACC_CALL_DATE | accidentCallDate | Accident_Call_Date__c | Datetime |  | Y | วันที่รับแจ้ง | request_date |
| 11 | REMARK | remark | Remark__c | Text(255) |  |  | หมายเหตุ | remark |
| 12 | SOURCE | source | SourceSystem | Text(50) |  |  | แหล่งที่มา Mobile App | source |
| 13 | CUSTOMER_TYPE | customerType | Customer_Type__c | Text(50) |  |  | Guest , Login | customer_type |
| 14 | REQUEST_LOC_LAT | requestLocLat | Latitude__c | Decimal(16,6) |  |  | สถานที่แจ้ง ละติจูด | request_loc_lat |
| 15 | REQUEST_LOC_LONG | requestLocLong | Longitude__c | Decimal(16,6) |  |  | สถานที่แจ้ง ลองติจูด | request_loc_long |
| 16 | FLAG_INJURYED | flagInjuryed | Have_Injury__c | bool |  |  | มีคนบาดเจ็บหรือไม่ | flag_injuryed |
| 17 | FLAG_UNABLE_DRIVING | flagUnableDriving | Car_Cannot_Move__c | bool |  |  | ไม่สามารถรถขับต่อได้หรือไม่ | flag_unable_driving |
| 18 | FLAG_AT_INCIDENT | flagAtIncident | Stay_In_Accident__c | bool |  |  | อยู่ในที่เกิดเหตุหรือไม่ | flag_at_incident |

### Example / Code Payload (Row 30)
**Example Request**
```json
{
  "status": "New",
  "requestClaimId": 1157,
  "prbNumber": "MV-0023-K-002011",
  "accPolicyNo": "MV-0023-K-002011",
  "accidentCause": 3,
  "accidentDate": "2024-01-9T14:11:18",
  "requestPhone": "0932931602",
  "accidentCallDate": "2024-01-9T14:11:18",
  "tpPhone": "",
  "remark": "TEST",
  "source": "Mobile App",
  "customerType": "Login",
  "requestLocLat": 37.785834,
  "requestLocLong": -122.406417,
  "flagInjuryed": false,
  "flagUnableDriving": false,
  "flagAtIncident": false,
  "CreateBy": "3d7d491c-cff8-4420-afeb-0362fa16139f",
  "UpdateDate": null,
  "UpdateBy": ""
}
```

| No | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Response title | title |  | Text(50) |  |  |  |  |
| 2 | Status code | status |  | Int |  |  |  |  |
| 3 | Description | description |  | Text(500) |  |  |  |  |
| 4 | Result | result |  | Object |  |  |  |  |
| 4.1 | REF_NOTIFY_NO | refNotifyNo | Notify_No__c | Text(20) | Y | Y | เลขรับแจ้ง | ref_notify_no |
| 4.2 | ACC_POLICY_NO | accPolicyNo | PolicyNumber.Name | Text(30) |  |  | กรมธรรม์เลขที่ | policy_no |
| 4.3 | REQUEST_CLAIM_ID | requestClaimId |  | int |  |  | เลขรัับแจ้งจาก Microservice | request_claim_id |

### Example / Code Payload (Row 39)
**Example Response
(Success)**
```json
{
  "timestamp": "2024-01-09T14:11:24",
  "statuscode": "0000",
  "result": {
    "requestClaimId": 1157,
    "refNotifyNo": "NA24-MV-01135",
    "accPolicyNo": "MV-0023-K-002011"
  },
  "message": "Success"
}
```

### Example / Code Payload (Row 40)
**Example Response
(Error)**
```json
{
    "statusCode": 400,
    "message": "Unexpected token / in JSON at position 987",
    "error": "Bad Request"
}
```
