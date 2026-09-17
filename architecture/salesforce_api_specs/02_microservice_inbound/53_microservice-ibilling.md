# [53] Microservice-iBilling

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-iBilling`
- **Total Rows Parsed**: `63`

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
| No | Upsert Invoice |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Table | GCP Field | GCP Remark |
| 1 | Function API | fn |  | Text |  |  | Fix: iBilling |  |  |  |
| 2 | TXN_SURV_BILL | billing |  | Object |  |  |  |  |  |  |
| 2.1 | SRID | surveyReportID |  | int | Y | Y | transaction id | sf_claim_ibilling | survey_report_id |  |
| 2.2 | REF_NOTIFY_NO | refNotifyNo |  | Text(20) | Y | Y | เลขรับแจ้ง | sf_claim_ibilling | ref_notify_no |  |
| 2.3 | REF_CLAIM_NO | refClaimNo |  | Text(20) |  | Y | เลขที่เคลม | sf_claim_ibilling | ref_claim_no |  |
| 2.4 | SUR_FEE | surveyFee |  | Number(18,0) |  |  | ค่าบริการเซอร์เวย์ เสนอ | sf_claim_ibilling | survey_fee |  |
| 2.5 | INS_FEE | insuranceFee |  | Number(18,0) |  |  | ค่าบริการประกัน อนุมัติ | sf_claim_ibilling | insurance_fee |  |
| 2.6 | SUR_TRANS | surveyTransportation |  | Number(18,0) |  |  | ค่าเดินทาง/ค่าพาหนะเซอร์เวย์ เสนอ | sf_claim_ibilling | survey_transportation |  |
| 2.7 | INS_TRANS | insuranceTransportation |  | Number(18,0) |  |  | ค่าเดินทาง/ค่าพาหนะประกัน อนุมัติ | sf_claim_ibilling | insurance_transportation |  |
| 2.8 | SUR_OTHER | surveyOther |  | Number(18,0) |  |  | ค่าใช้จ่ายอื่นๆซอร์เวย์ เสนอ | sf_claim_ibilling | survey_other |  |
| 2.9 | INS_OTHER | insuranceOther |  | Number(18,0) |  |  | ค่าใช้จ่ายอื่นๆประกัน อนุมัติ | sf_claim_ibilling | insurance_other |  |
| 2.10 | OTHER_DESC | otherDescription |  | Text(255) |  |  | ค่าใช้จ่ายอื่นๆ | sf_claim_ibilling | other_description |  |
| 2.11 | BILL_NO | billingNo |  | Text(255) |  |  | เลขที่ใบแจ้งหนี้ | sf_claim_ibilling | billing_no |  |
| 2.12 | BILL_DATE | billingDate |  | Date |  |  | วันที่วางบิล | sf_claim_ibilling | billing_date |  |
| 2.13 | SUR_CLAIM | surveyClaim |  | Number(18,0) |  |  | ค่าเรียกร้องเซอร์เวย์ อนุมัติ | sf_claim_ibilling | survey_claim |  |
| 2.14 | INS_CLAIM | insuranceClaim |  | Number(18,0) |  |  | ค่าเรียกร้องประกัน อนุมัติ | sf_claim_ibilling | insurance_claim |  |
| 2.15 | SUR_DAILY | surveyDaily |  | Number(18,0) |  |  | ค่าคัดประจำวันเซอร์เวย์ เสนอ | sf_claim_ibilling | survey_daily |  |
| 2.16 | INS_DAILY | insuranceDaily |  | Number(18,0) |  |  | ค่าคัดประจำวันประกัน อนุมัติ | sf_claim_ibilling | insurance_daily |  |
| 2.17 | SR_SEND_DATE | sendDate |  | Date |  |  | วันที่เสนอราคา | sf_claim_ibilling | send_date |  |
| 2.18 | SR_SEND_BY | sendBy |  | Text(255) |  |  | ชื่อผู้เสนอราคา | sf_claim_ibilling | send_by |  |
| 2.19 | SR_APPROVE_DATE | approveDate |  | Date |  |  | วันที่อนุมัติ | sf_claim_ibilling | approve_date |  |
| 2.20 | SR_APPROVE_BY | approveBy |  | Text(255) |  |  | ชื่อผู้อนุมัติ | sf_claim_ibilling | approve_by |  |
| 3 | TXN_SURV_PAY | pay | Pay__c | Object |  |  |  |  |  |  |
| 3.1 | PAYID | payID | Pay_ID__c | Text(20) |  |  |  | sf_claim_pay | pay_id |  |
| 3.2 | SRID | srID | SR_ID__C | Text(20) |  |  |  | sf_claim_pay | sr_id |  |
| 3.3 | SRREFID | srrefID | SRREF_ID__c | Text(255) |  |  |  | sf_claim_pay | srref_id |  |
| 3.4 | ADD_NO | addNo | Add_No__c | Number(18,0) |  |  |  | sf_claim_pay | add_no |  |
| 3.5 | SURVEYID | surveyID | Survey_ID__c | Text(255) |  |  |  | sf_claim_pay | survey_id |  |
| 3.6 | SURVEYOR_NAME | surveyorName | Surveyor_Name__c | Text(255) |  |  |  | sf_claim_pay | surveyor_name |  |
| 3.7 | REF_CLAIM_NO | refClaimNo | Ref_Claim_No__c | Text(255) |  |  |  | sf_claim_pay | ref_claim_no |  |
| 3.8 | ACC_CLAIMREF_NO | accClaimRefNo | Acc_Claim_Ref__No__c | Text(255) |  |  |  | sf_claim_pay | acc_claim_ref_no |  |
| 3.9 | ACC_POLICY_NO | accPolicyNo | Acc_Policy_No__c | Text(255) |  |  |  | sf_claim_pay | acc_policy_no |  |
| 3.10 | CAR_REGNO | carRegNo | Car_Reg_No__c | Text(255) |  |  |  | sf_claim_pay | car_reg_no |  |
| 3.11 | UNITPRICE | unitPrice | Unit_Price__c | Number(16,2) |  |  |  | sf_claim_pay | unit_price |  |
| 3.12 | INC_VAT | incVat | Inc_Vat__c | Number(18,0) |  |  |  | sf_claim_pay | inc_vat |  |
| 3.13 | SEND_DATE | sendDate | Send_Date_Pay__c | Text(255) |  |  |  | sf_claim_pay | send_date |  |
| 3.14 | CHECK_DATE | checkDate | Check_Date__c | Text(255) |  |  |  | sf_claim_pay | check_date |  |
| 3.15 | CHECKERID | checkrID | Checker_ID__c | Text(255) |  |  |  | sf_claim_pay | checkr_id |  |
| 3.16 | APPROVEID | approveID | Approve_ID__c | Text(255) |  |  |  | sf_claim_pay | approve_id |  |
| 3.17 | ACC_DATE | accDate | Acc_Date__c | Text(255) |  |  |  | sf_claim_pay | acc_date |  |
| 3.18 | ACC_CALL_DATE | accCallDate | Acc_Call_Date__c | Text(255) |  |  |  | sf_claim_pay | acc_call_date |  |
| 3.19 | POS_STATUS | posStatus | Pos_Status__c | Number(18,0) |  |  | Fix: 25 | sf_claim_pay | pos_status |  |
| 3.20 | VENDOR | vendor | Vendor__c | Text(255) |  |  |  | sf_claim_pay | vendor |  |

### Example / Code Payload (Row 56)
**Example Request**
```json
{
    "fn": "iBilling",
    "billing": [
        {
            "surveyReportID": "xxxxxxxx",
            "refNotifyNo": "xxx",
            "refClaimNo": "xxxxx",
            "surveyFee": 1111,
            "insuranceFee": 2222,
            "surveyTransportation": 3333,
            "insuranceTransportation": 4444,
            "surveyOther": 55555,
            "insuranceOther": 66666,
            "otherDescription": 2222,
            "billingNo": "4133r",
            "billingDate": "2023-09-09",
            "surveyClaim": 2222,
            "insuranceClaim": 3333,
            "surveyDaily": 44444,
            "insuranceDaily": 5555,
            "sendDate": "2023-09-09",
            "sendBy": "พัด",
            "approveDate": "2023-09-09",
            "approveBy": "พัด"
        },
        {
            "surveyReportID": "xxxxxxxx3",
            "refNotifyNo": "xxx3",
            "refClaimNo": "xxxxx3",
            "surveyFee": 1111,
            "insuranceFee": 2222,
            "surveyTransportation": 3333,
            "insuranceTransportation": 4444,
            "surveyOther": 55555,
            "insuranceOther": 66666,
            "otherDescription": 2222,
            "billingNo": "4133r",
            "billingDate": "2023-09-09",
            "surveyClaim": 2222,
            "insuranceClaim": 3333,
            "surveyDaily": 44444,
            "insuranceDaily": 5555,
            "sendDate": "2023-09-09",
            "sendBy": "พัด",
            "approveDate": "2023-09-09",
            "approveBy": "พัด"
        }
    ]
}
```

| No | Source - Field Name | Source - Field Name (Service Model) | SF Field | Col5 | Type | External Key | Required Field | Col9 | Col10 | Remark | GCP Table | GCP Field | GCP Remark |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Response title | title |  |  | Text(50) |  | Y |  |  |  |  |  |  |
| 2 | Status code | status |  |  | Int |  | Y |  |  |  |  |  |  |
| 3 | Description | description |  |  | Text(500) |  | Y |  |  |  |  |  |  |
| 4 | Result | result |  |  | Object |  | Y |  |  |  |  |  |  |

### Example / Code Payload (Row 62)
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

### Example / Code Payload (Row 63)
**Example Response
(Error)**
```json
{
    "title": "Unsuccess",
    "status": 401,
    "description": "Error Message already exists.",
    "result": {}
}
```
