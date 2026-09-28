# [50] Microservice-Claim ReserveAdjus

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Claim ReserveAdjus`
- **Total Rows Parsed**: `69`

## API Specification Overview

- **Endpoint URL**: `https://isv-api-dev.flybkk.com/api/v1/iia/claim/claim_coverage`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Request Message

### END POINT

| URL | https://isv-api-dev.flybkk.com/api/v1/iia/claim/claim_coverage |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/iia/claim/claim_coverage |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |  |  |  | GCP Field |
| 0 |  |  |  | Array |  |  |  |  |  |  |  |
| 1 | Claim Number | claimId | Name | Text(20) | Y | Y | เลขเคลม |  |  |  |  |
| 2 | Policy Number | policyNumber | PolicyNumberId | Text(20) |  |  | เลขกรมธรรม์ | SF มีฟิลด์นี้อยู่แล้ว แต่เป็น Type Lookup(Insurance Policy) |  |  |  |
| 3 | Status | status | Status | Picklist |  |  | Status ของ Claim อยู่ใน Level ไหนบน IIA Claim Status - OP (On Process) - CL (Closed Claim) - RO (Reopen Claim) - IN (In Process) - RS (Receive Settle) - ST (Settle) - CC (Cancel) - RV (Reserve) |  |  |  |  |
| 4 | Claim Type | claimType | Claim_Type__c | Text(255) |  |  | Claim Type. eg.PURELOSS, Cosmetic, Other (เฉพาะรถประกัน) |  |  |  |  |
| 5 | Responsiblity | responsibility | Responsibility__c | Text(255) |  |  | ถูก/ผิด |  |  |  |  |
| 6 | Payment Type | paymentType | Payment_Type__c | Text(255) |  |  | รูปแบบการปิดจ่าย |  |  |  |  |
| 7 | Total Loss Reserve | totalLossReserve | Total_Loss_Reserve__c | Decimal(16,2) |  |  | ค่าประมาณการ |  |  |  |  |
| 8 | Total Loss Settlement | totalLossSettlement | Total_Loss_Settlement__c | Decimal(16,2) |  |  | ยอดเงินที่จ่ายออกไป |  |  |  |  |
|  | Total Loss Outstanding |  | Total_Loss_Outstanding__c |  |  |  | totalLossReserve - totalLossSettlement (ทศนิยมสองตำแหน่ง) |  |  |  |  |
| 9 | Total Recovery | totalRecovery | Total_Recovery__c | Decimal(16,2) |  |  | ยอดเงินที่เก็บได้จากคู่กรณี |  |  |  |  |
| 10 | Claim Item | claimItem |  | Array |  |  | รายการความเสียหายใน Claim |  |  |  |  |
| 10.1 | Coverage Number | coverageID | Coverage_Number__c | Text(20) | Y | Y | หมายเลข Unique ของทรัพย์สินภายใน Claim. (coverageType-itemNo) |  |  |  |  |
| 10.2 | eClaimId | eClaimId | ClaimID__C | Text(20) | Y |  | eClaim |  |  |  |  |
| 10.3 | Item No | itemNo | Item_No__c | Integer |  |  | ลำดับที่ |  |  |  |  |
| 10.4 | Coverage Type | coverageType | Coverage_Type__c | Picklist |  |  | ประเภทของการเบิก (Loss Code Group) IV        Insure Vehicle TV        Third Party Vehicle TP        Third Party Property DV        Driver PN        Insured Passenger PR        Driver Related Passenger ON        Third Party Injury OR        Third Party Driver Related Injury |  |  |  |  |
| 10.5 | EMCS Status | emcsStatus |  | Picklist |  |  | สถานะการซ่อม | รอเช็คกับทาง Insurverse EMCS ว่าสามารถส่งมาให้ได้หรือไม่ |  |  |  |
| 10.5 |  |  | EMCS สถานะการคุมราคา | Picklist |  |  | สถานะการคุมราคา (เสนอราคา, ยังไม่เสนอราคา, รออนุมัติ, อนุมัติ, ไม่อนุมัติ) | รอเช็คกับทาง Insurverse EMCS ว่าสามารถส่งมาให้ได้หรือไม่ |  |  |  |
| 10.6 | Car Detail | carDetail |  | Object |  | Y (Car) | Contain Car Detail |  |  |  |  |
| 10.6.1 | Repairer Code | repairerCode | REPAIRERID__c | Text(255) |  |  | รหัสอู่/ศูนย์ |  |  |  |  |
| 10.6.2 | Repaire Bring Date | repBringDate | REP_BRING_DATE__c | DateTime |  |  | วันที่นำรถมาซ่อม (REP_BRING_DATE) |  |  |  |  |
| 10.6.3 | Get Car Back Date | getCarBackDate | GET_CAR_BACK_DATE__c | DateTime |  |  | วันที่รับรถ (GET_CAR_BACK_DATE) |  |  |  |  |
| 10.6.4 | Repairer Name | repairerName | REPAIRER_NAME__c | Text(255) |  |  | ชื่ออู่/ศูนย์ |  |  |  |  |
| 10.6.5 | Originator Code | originatorCode | Originator_Code__c | Text(255) |  |  | รหัสร้านกระจก |  |  |  |  |
| 10.6.6 | Originator Name | originatorName | Originator_Name__c | Text(255) |  |  | ชื่อร้านกระจก |  |  |  |  |
| 10.6.7 | Car License | carLicense | C_CAR_REGNO__c | Text(255) |  |  | ทะเบียนรถ |  |  |  |  |
| 10.6.8 | Policy Number | policyNumber | Policy_Number__c | Text(255) |  |  | เลขที่ ก/ธ |  |  |  |  |
| 10.6.9 | Claim Number | claimNumber | Claim_Number__c | Text(255) |  |  | เลขที่สินไหม |  |  |  |  |
| 10.6.8 | Time to Repaire | timeToRepair |  | Array |  |  |  |  |  |  |  |
| 10.6.10 | IMAGE_PART | imagePart | Image_Part__c | Text(1000) |  |  | รูปรับรถ | Text Area(Rich) |  |  |  |
| 10.6.11 | Invoice Path | invoicePath |  | Text(1000) |  |  | ใบกำกับภาษี/ใบแจ้งหนี้/ใบเสร็จ เลขที่ |  |  |  |  |
| 10.6.12 | Repairer Comment | repComment |  | Text(3000) |  |  | ความคิดเห็นอู่ |  |  |  |  |
| 10.6.13 | Insurance Comment | insComment |  | Text(6000) |  |  | ความคิดเห็นบริษัทประกัน |  |  |  |  |
| 10.7 | Injury Detail | injuryDetail |  | Object |  | Y (Injury) | Contain Injury Detail |  |  |  |  |
| 10.7.1 | Firstname | firstname | First_Name_Injurer__c | Text(255) |  |  | ชื่อผู้บาดเจ็บ |  |  |  |  |
| 10.7.2 | Lastname | lastname | Last_Name_Injurer__c | Text(255) |  |  | นามสกุลผู้บาดเจ็บ |  |  |  |  |
| 10.7.3 | Citizen ID | citizenID | Citizen_ID_Injurer__c | Text(18) |  |  | เลขบัตรประชาชนผู้บาดเจ็บ |  |  |  |  |
| 10.8 | Property Detail | propertyDetail |  | Object |  | Y (Property) | Contain Property Detail |  |  |  |  |
| 10.8.1 | Name | name | Property_Name__c | Text(255) |  |  | ชื่อทรัพย์สิน |  |  |  |  |
| 10.8.2 | Owner Firstname | ownerFirstname | First_Name_Property_Owner__c | Text(255) |  |  | ชื่อเจ้าของทรัพย์สิน |  |  |  |  |
| 10.8.3 | Owner Lastname | ownerLastname | Last_Name_Property_Owner__c | Text(255) |  |  | นามสกุลเจ้าของทรัพย์สิน |  |  |  |  |
| 10.8.4 | Owner Citizen ID | ownerCitizenID | Citizen_ID_Property_Owner__c | Text(18) |  |  | เลขบัตรประชาชนเจ้าของทรัพย์สิน |  |  |  |  |
|  | REP_TIME_COMMENT | repTimeComment |  | Text(2000) |  |  | หมายเหตุ |  |  |  |  |
|  | DATE_REPAIR | dateRepaire |  | Decimal(10, 0) |  |  | จำนวนวันที่ซ่อม |  |  |  |  |
|  | EST_REPAIR_DATE |  |  | DateTime |  |  | วันที่คาดว่าจะซ่อมเสร็จ |  |  |  |  |
|  | EDIT_EST_REPAIR_DATE |  |  | DateTime |  |  | วันที่คาดว่าจะซ่อมเสร็จที่ถูกแก้ไข |  |  |  |  |

### Example / Code Payload (Row 58)
**Example Request**
```json
[
  {
    "claimId": "CC-23-MV-00086",
    "policyNumber": "MV-0023-E-006535",
    "status": "OP",
    "claimType": "PURELOSS",
    "responsibility": "ฝ่ายถูก",
    "paymentType": null,
    "totalLossReserve": 30000,
    "totalLossSettlement": 25000,
    "totalRecovery": 25000,
    "claimItem": [
      {
        "coverageID": "IV_0",
        "itemNo": 0,
        "coverageType": "IV",
        "emcsStatus": 7,
        "carDetail": {
          "repairerCode": "12",
          "repairerName": "อู่ ถาวรการาจ",
          "originatorCode": "23",
          "originatorName": "3M",
          "carLicense": "หห3566",
          "policyNumber": "MV-0023-E-006535",
          "claimNumber": "CC-23-MV-00086",
          "imagePart": "หห3566_doc.pdf"
        }
      },
      {
        "coverageID": "TV_1",
        "itemNo": 1,
        "coverageType": "TV",
        "emcsStatus": 3,
        "carDetail": {
          "repairerCode": "37",
          "repairerName": "บจก. ลิบเฮงการาจ",
          "originatorCode": "23",
          "originatorName": "3M",
          "carLicense": "ทท934",
          "policyNumber": "11002-008-22052043",
          "claimNumber": "A00623V000904"
        }
      },
      {
        "coverageID": "DV_1",
        "itemNo": 1,
        "coverageType": "DV",
        "injuryDetail": {
          "firstname": "ป๊อปปี้",
          "lastname": "เทสเตอร์",
          "citizenID": "1864859511728"
        }
      },
      {
        "coverageID": "ON_2",
        "itemNo": 2,
        "coverageType": "ON",
        "injuryDetail": {
          "firstname": "เชอรี่",
          "lastname": "สีเขียว",
          "citizenID": "2156223219534"
        }
      },
      {
        "coverageID": "TP_1",
        "itemNo": 1,
        "coverageType": "TP",
        "propertyDetail": {
          "name": "มือถือ",
          "ownerFirstname": "เชอรี่",
          "ownerLastname": "สีเขียว",
          "ownerCitizenID": "2156223219534"
        }
      }
    ]
  }
]
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Claim Number | claimId |  | Text(20) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 68)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimId": "CC-23-MV-00086",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 69)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update incomplete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimId": "CC-23-MV-00086",
      "isSuccess": false,
      "errorMessage": "Claim not found"
    }
  ]
}
```
