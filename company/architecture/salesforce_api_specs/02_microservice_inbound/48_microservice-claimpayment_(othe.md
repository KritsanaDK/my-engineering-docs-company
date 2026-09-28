# [48] Microservice-ClaimPayment (Othe

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-ClaimPayment (Othe`
- **Total Rows Parsed**: `75`

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

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |
| No | Upsert Claim Payment |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |  | GCP Field |
| 0 |  |  |  | Array |  |  |  |  | Table : sf_claim_payment_other |
| 1 | Claim Number | claimId | ClaimId | Text(20) | Y | Y | เลขเคลม |  | claim_id |
| 2 | Coverage Number | coverageID | External_Id__c | Text(20) | Y | Y | หมายเลข e-Claim |  | coverage_id |
| 3 | Claim Coverage Type | coverageType |  |  |  | Y | ประเภทของการเบิก (Loss Code Group) - Vehicle F&T - Injury Person - Property - Expense |  | coverage_type |
| 4 | Claim Payment Id | claimPaymentId |  | Text(7) | Y | Y |  |  | claim_payment_id |
| 5 | Losscode | lossCode |  | Array |  |  |  |  | Table : sf_claim_payment_other_loss_code |
| 5.1 | Losscode ID | lossCodeId |  | Text(10) |  |  |  |  | loss_code_id |
| 5.2 | Total Payment | totalPayment |  | Decimal(16,2) |  |  |  |  | total_payment |
| 5.3 | Settle | settle |  | Picklist |  |  | O, R, F, |  | settle |
| 5.4 | Refund | refund |  | Picklist |  |  | Y, N |  | refund |
| 6 | Payee Detail | payeeDetails |  | Object |  |  |  |  |  |
| 6.1 | Payment No | paymentno |  | Text | Y | Y | เลข Unique ID สำหรับการจ่าย |  | payment_no |
| 6.2 | Edit Date | editdate | LastModifiedDate | Date |  |  | วันที่แก้ไขล่าสุด |  | edit_date |
| 6.3 | Edit Time | edittime | LastModifiedDate | Text(8) |  |  | เวลาที่แก้ไขล่าสุด |  | edit_time |
| 6.4 | Salutation | salutation |  | Text |  |  | คำนำหน้าชื่อ | x | salutation |
| 6.5 | Fisrt Name | firstName |  | Text |  |  | ชื่อจริง payee |  | first_name |
| 6.6 | Last Name | lastName |  | Text |  |  | นามสกุล payee |  | last_name |
| 6.7 | Address | address |  | text |  |  | ที่อยู่ payee | x | address |
|  |  |  | Province_ID__c | text |  |  |  |  | province_id , province_name |
|  |  |  | Amphur_ID__c | text |  |  |  |  | amphur_id , amphur_name |
|  |  |  | District_ID__c | text |  |  |  |  | district_id , district_name |
|  |  |  | Zip_Code__c | text |  |  |  |  | zipcode |
| 6.8 | Description | description |  | Text |  |  | คำอธิบาย |  | description |
| 6.9 | Payee Type | payeeType |  | Picklist/Text |  |  | ประเภทของ Payee |  |  |
| 6.10 | Tel No. | tel |  | Text |  |  | เบอโทร Payee |  | tel |
| 6.11 | Income Tax No. | incomeTaxNo |  | Text |  |  |  |  |  |
| 6.12 | Tax Type | taxType |  | Picklist/Text |  |  | ประเภทของภาษี |  |  |
| 6.13 | Payment Type | paymentType |  | Picklist |  |  | จ่ายแยก/จ่ายรวม |  |  |
| 6.14 | Branch Code | branchCode |  | Lookup/Text |  |  | รหัสของสาขาที่จ่าย |  |  |
| 6.15 | Branch Name | branchName |  | Lookup/Text |  |  | ชื่อของสาขาที่จ่าย |  |  |
| 6.16 | Contact Person type | contactPersonType |  | Picklist/Text |  |  | Insured/Payee/Other |  |  |
| 6.17 | WHT Rate | whtRate |  | Decimal(16,2) |  |  |  |  |  |
| 6.18 | Invoice Date | invoiceDate |  | Date |  |  | วันที่ออก Invoice |  |  |
| 6.19 | Invoice No. | invoiceNo |  | Text |  |  | เลข Invoice |  |  |
| 6.20 | Tax Invoice No | taxInvoiceNo |  | Text |  |  |  |  |  |
| 6.21 | Tax Invoice Date | taxInvoiceDate |  | date |  |  |  |  |  |
| 6.22 | Payment Type | paymentType |  | Lookup? |  |  | รหัสประเภทของการจ่าย | x | payment_type |
| 6.23 | Payment Type Text | paymentTypeText |  | Lookup? |  |  | ประเภทของการจ่าย |  | payment_type_text |
| 6.24 | Cross Type | crossType |  | Lookup? |  |  |  |  |  |
| 6.25 | Cross Type Text | crossTypeText |  | Text |  |  |  |  |  |
| 6.26 | Payment Date | paymentDate |  | date |  |  | วันกำหนดการจ่าย |  | payment_date |
| 6.27 | Have Payment Date | hvPaymnetDate |  | Boolean |  |  | มีการกำหนดวันจ่าย |  | hv_paymnet_date |
| 6.28 | one time | oneTimeDetail |  | Object |  |  | ข้อมูล One Time: ข้อมูลธนาคารและเลข บช |  |  |
| 6.28.1 | Bank Code | bankCode |  | Lookup/Text |  |  | รหัสธนาคาร | x | bank_code |
| 6.28.2 | Bank | Bank |  | Lookup/Text |  |  | ชื่อธนาคาร |  | bank |
| 6.28.3 | Branch Code | branchCode |  | Lookup/Text |  |  | รหัสสาขาธนาคาร |  |  |
| 6.28.4 | Bank Branch | Bank Brach |  | Lookup/Text |  |  | ชื่อสาขาธนาคาร |  |  |
| 6.28.5 | Account No. | accountNo |  | Text |  |  | เลขที่ บช |  | account_no |
| 6.29 | Total Amount | totalAmount |  | Decimal |  |  | ยอดจ่าย |  | total_amount |
| 6.30 | withHolding Tax | withholdingTax |  | Decimal |  |  |  |  |  |
| 6.31 | NetAmount | netAmount |  | Decimal |  |  | รวมยอด |  |  |
| 6.32 | TotalReceiveAmount | totalReceiveAmt |  | Decimal |  |  | รวมยอดรับ |  |  |

### Example / Code Payload (Row 64)
**Example Request**
```json
[
  {
    "claimId":"CC-23-MV-00014",
    "coverageID":"R01023041008",
    "coverageType":"Injury Person",
    "claimPaymentId":"0987654321",
    "lossCode":[
      {
        "lossCodeId":"LOSS01DV123P",
        "totalPayment":5000.00,
        "settle":"O",
        "refund":"Y"
      }
    ],
    "payeeDetail":{
      "paymentNo":"1234567890",
      "editDate":"23-05-2023",
      "editTime":"12:00:00",
      "salutation":"นาย",
      "firstName":"รัชฎา",
      "lastName":"ปกรณ์",
      "address":"122 ม.3 ต.บางพระ อ.ศรีราชา จ.ชลบุรี",
      "desctiption":"จ่ายค่าซ่อมรถคู่กรณีเลขทะเบียน 123456 กท",
      "payeeType":"ผู้ประสบภัย",
      "tel":"0982751107",
      "incomeTaxNo":null,
      "taxType":"ภาษีเงินได้ หัก ณ ที่จ่าย",
      "paymentType":"จ่ายรวม",
      "branchCode":"000",
      "branchName":"บริษัท ทิพย์ประกันภัย จำกัด (มหาชน)",
      "contactPersonType":"Payee",
      "whtRate":"0.00",
      "invoiceDate":null,
      "invoiceNo":null,
      "taxInvoiceNo":null,
      "taxInvoiceDate":null,
      "paymentType":"Mc",
      "paymentTypeText":"Media Clearing",
      "crossType":null,
      "crossTypeText":null,
      "paymentDate":null,
      "hvPaymnetDate":true,
          "oneTimeDetail":{
            "bankCode":"006",
            "Bank":"ธ. กรุงไทย จำกัด (มหาชน)",
            "branchCode":"0056",
            "Bank Brach":"สาขาถนนอโศก-ดินแดน",
            "accountNo":"0560"
          },
      "totalAmount":5000.00,
      "withholdingTax":0.00,
      "netAmount":5000.00,
      "totalReceiveAmt":0.00
    }
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
| 4.1 | Claim Payment Id | claimPaymentId |  | Text(7) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 74)
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

### Example / Code Payload (Row 75)
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
