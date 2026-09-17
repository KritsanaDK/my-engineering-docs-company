# [47] Microservice-ClaimPayment

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-ClaimPayment`
- **Total Rows Parsed**: `55`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/upsertclaimpayment`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/upsertclaimpayment |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field |
| 0 |  |  |  | Array |  |  |  | Table : sf_claim_payment |
| 1 | REF_CLAIM_NO | claimId | ClaimId | Text(21) | Y | Y | เลขเคลม | claim_id |
| 2 | CLAIMID | coverageID | External_Id__c | Text(20) | Y | Y | หมายเลข e-Claim | coverage_id |
| 3 | INSURERBRID | insurerId |  | Decimal(9,0) |  |  | รหัสสาขาประกัน | insurer_id |
| 4 | REPAIRERID | repairerId |  | Decimal(9,0) |  |  | รหัสอู่-ศูนย์บริการ บริษัทประกัน Map Data | repairer_id |
| 5 | REPAIRER_BRANCHID | repairerBranch |  | Decimal(9,0) |  |  | รหัสสาขาอู่-ศูนย์บริการ บริษัทประกัน Map Data | repairer_branch |
| 6 | ACC_CLAIMREF_NO | accClaimRefNo |  | Text(20) |  |  | เลขที่รับแจ้ง | acc_claim_ref_no |
| 7 | ACC_POLICY_NO | accPolicyNo |  | Text(50) |  |  | เลขที่กรมธรรม์ | acc_policy_no |
| 8 | C_CAR_REGNO | cCarRegNo |  | Text(20) |  |  | ทะเบียนรถ | c_car_reg_no |
| 9 | CAR_PROVINCEID | carProvinceId |  | Integer |  |  | รหัสจังหวัดทะเบียนรถ บริษัทประกัน Map Data | car_province_id |
| 10 | CARIDENNO | carIdenNo |  | Integer |  |  | รถคันที่เกิดอุบัติเหตุ 0 = รถประกัน 1,2,3... = รถคู่กรณีคันที่ 1,2,3.. | car_iden_no |
| 11 | LABOR_PRICE | laborPrice |  | Decimal(16, 2) |  |  | ค่าแรง (ก่อน vat) | labor_price |
| 12 | PART_PRICE | partPrice |  | Decimal(16, 2) |  |  | ค่าอะไหล่ (ก่อน vat) | part_price |
| 13 | OTHER_PRICE | otherPrice |  | Decimal(16, 2) |  |  | ค่าใช้จ่ายอื่น ๆ (ก่อน vat) | other_price |
| 14 | C_DEDUCTION | cDeduction |  | Decimal(16, 2) |  |  | ค่า เสียหายส่วนแรก | c_deduction |
| 15 | C_DEDUCTIONSRC | cDeductionSrc |  | Text(3) |  |  | ประเภทค่าเสยีหายส่วนแรก  "ins" = ประกันเรียกเก็บ - ไม่หักจากค่าซ่อม "rep" = อู่เรียกเก็บ - หักจากค่าซ่อม "rno" = อู่เรียกเก็บ – ไม่หักจากค่าซ่อม “ino” = ไม่เรียกเก็บ | c_deduction_src |
| 16 | UNITPRICE | unitPrice |  | Decimal(16, 2) |  |  | ยอดสุทธิ | unit_price |
| 17 | VAT | vat |  | Decimal(16, 2) |  |  | ภาษีมูลค่าเพิ่ม | vat |
| 18 | SEND_DATE | sendDate |  | Datetime |  |  | วันที่ส่งตรวจสอบ (วันที่อู่ขอวางบิล) | send_date |
| 19 | CHECK_DATE | checkDate |  | Datetime |  |  | วันที่ตรวจเอกสารผ่าน (วันทีข้อมูลผ่านการตรวจสอบ) | check_date |
| 20 | CHECKERID | checkerId |  | Decimal(16, 2) |  |  | รหัสผู้ตรวจเอกสาร | checker_id |
| 21 | APPROVE_DATE | approveDate |  | Datetime |  |  | วันที่อนุมัติจ่าย (วันทีข้อมูลผ่านการอนุมัติจ่าย) | approve_date |
| 22 | APPROVEID | approveId |  | Decimal(16, 2) |  |  | รหัสผู้อนุมัติจ่าย คนสุดท้าย | approve_id |
| 23 | DUE_DATE_1 | dueDate |  | Datetime |  |  | วันที่นัดรับเงิน | due_date |
| 24 | CLAIM_STATUS | claimStatus |  | Text(2) |  |  | สถานะการวางบิล (25 = นัดรับเงินแล้ว) | claim_status |
| 25 | TXN_PAY_IMAGE | txnPayImage |  | Array |  |  | ข้อมูลรูปภาพที่เกี่ยวข้อง | Table : sf_claim_payment_txn_pay_image |
| 25.1 | IMAGEID | imageId |  | Decimal(9, 0) |  |  | หมายเลขลำดับ | image_id |
| 25.2 | CLAIMID | claimId |  | Text(20) |  |  | ลำดับที่ขอ | claim_id |
| 25.3 | IMAGE_PATH | imagePath |  | Text(50) |  |  | ชื่อไฟลร์รูปภาพ | image_path |
| 25.4 | TAXINVOICENO | taxInvoinceNo |  | Text(20) |  |  | ใบกำกับภาษี/ใบแจ้งหนี้/ใบเสร็จ เลขที่ | tax_invoince_no |
| 25.5 | CREATE_DATE | createDate |  | Datetime |  |  | ใบก ากับภาษี/ใบแจ้งหนี้/ใบเสร็จ ลงวันที่ | create_date |
| 25.6 | IMAGE_TYPE | imageType |  | Text(50) |  |  | ประเภทของรูปภาพ Tax = ใบก ากับภาษี Invoice = ใบแจ้งหนี้ | image_type |

### Example Request

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | CLAIMID | coverageID | External_Id__c | Text(20) | Y |  | หมายเลข e-Claim |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 54)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimPaymentId": "1easWlKqP1",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "claimPaymentId": "1easWlKqP2",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 55)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimPaymentId": "1easWlKqP1",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "claimPaymentId": "1easWlKqP2",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
