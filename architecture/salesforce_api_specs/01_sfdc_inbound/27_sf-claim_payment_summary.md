# [27] SF-Claim Payment Summary

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Claim Payment Summary`
- **Total Rows Parsed**: `74`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertclaimpaymentsummary`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertclaimpaymentsummary |
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
| 0 |  |  |  | Array |  |  |  | Table : sf_claim_payment_other |
| 1 | Claim Number | claimId | ClaimId | Text(20) | Y | Y | เลขเคลม | claim_id |
| 2 | Coverage Number | coverageID | External_Id__c | Text(20) | Y | Y | หมายเลข e-Claim | coverage_id |
| 3 | Claim Coverage Type | coverageType |  |  |  | Y | ประเภทของการเบิก (Loss Code Group) - Vehicle F&T - Injury Person - Property - Expense | coverage_type |
| 2 | Claim Payment Id | claimPaymentId |  | Text(7) | Y | Y |  | claim_payment_id |
| 3 | Losscode | lossCode |  | Array |  |  |  | Table : sf_claim_payment_other_loss_code |
| 3.1 | Losscode ID | lossCodeId |  | Text(10) |  |  |  | loss_code_id |
| 3.2 | Total Payment | totalPayment |  | Decimal(16,2) |  |  |  | total_payment |
| 3.3 | Settle | settle |  | Picklist |  |  | O, R, F, | settle |
| 3.4 | Refund | refund |  | Picklist |  |  | Y, N | refund |
| 4 | Payee Detail | payeeDetails |  | Object |  |  |  |  |
| 4.1 | Payment No | paymentno |  | Text | Y | Y | เลข Unique ID สำหรับการจ่าย | payment_no |
| 4.2 | Edit Date | editdate | LastModifiedDate | Date |  |  | วันที่แก้ไขล่าสุด | edit_date |
| 4.3 | Edit Time | edittime | LastModifiedDate | Text(8) |  |  | เวลาที่แก้ไขล่าสุด | edit_time |
| 4.4 | Salutation | salutation |  | Text |  |  | คำนำหน้าชื่อ | salutation |
| 4.5 | Fisrt Name | firstName |  | Text |  |  | ชื่อจริง payee | first_name |
| 4.6 | Last Name | lastName |  | Text |  |  | นามสกุล payee | last_name |
| 4.7 | Address | address |  | text |  |  | ที่อยู่ payee | address |
| 4.8 | Province |  | Province_ID__c | text |  |  | ที่อยู่ payee | province_id , province_name |
| 4.9 | Auphur |  | Amphur_ID__c | text |  |  | ที่อยู่ payee | amphur_id , amphur_name |
| 4.10 | District |  | District_ID__c | text |  |  | ที่อยู่ payee | district_id , district_name |
| 4.11 | Zipcode |  | Zip_Code__c | text |  |  |  | zipcode |
| 4.12 | Description | description |  | Text |  |  | ที่อยู่ payee | description |
| 4.13 | Payee Type | payeeType |  | Picklist/Text |  |  | ประเภทของ Payee |  |
| 4.13 | Tel No. | tel |  | Text |  |  | เบอโทร Payee | tel |
| 6.15 | Income Tax No. | incomeTaxNo |  | Text |  |  |  |  |
| 6.16 | Tax Type | taxType |  | Picklist/Text |  |  | ประเภทของภาษี |  |
| 6.17 | Payment Type | paymentType |  | Picklist |  |  | จ่ายแยก/จ่ายรวม |  |
| 6.18 | Branch Code | branchCode |  | Lookup/Text |  |  | รหัสของสาขาที่จ่าย |  |
| 6.19 | Branch Name | branchName |  | Lookup/Text |  |  | ชื่อของสาขาที่จ่าย |  |
| 6.20 | Contact Person type | contactPersonType |  | Picklist/Text |  |  | Insured/Payee/Other |  |
| 6.21 | WHT Rate | whtRate |  | Decimal(16,2) |  |  |  |  |
| 6.22 | Invoice Date | invoiceDate |  | Date |  |  | วันที่ออก Invoice |  |
| 6.23 | Invoice No. | invoiceNo |  | Text |  |  | เลข Invoice |  |
| 6.24 | Tax Invoice No | taxInvoiceNo |  | Text |  |  |  |  |
| 6.25 | Tax Invoice Date | taxInvoiceDate |  | date |  |  |  |  |
| 4.14 | Payment Type | paymentType |  | Lookup? |  |  | รหัสประเภทของการจ่าย | payment_type |
| 4.15 | Payment Type Text | paymentTypeText |  | Lookup? |  |  | ประเภทของการจ่าย | payment_type_text |
| 6.24 | Cross Type | crossType |  | Lookup? |  |  |  |  |
| 6.25 | Cross Type Text | crossTypeText |  | Text |  |  |  |  |
| 4.16 | Payment Date | paymentDate |  | date |  |  | วันกำหนดการจ่าย | payment_date |
| 4.17 | Have Payment Date | hvPaymnetDate |  | Boolean |  |  | มีการกำหนดวันจ่าย | hv_paymnet_date |
| 4.18 | Bank Code | bankCode |  | Lookup/Text |  |  | รหัสธนาคาร | bank_code |
| 4.19 | Bank | Bank |  | Lookup/Text |  |  | ชื่อธนาคาร | bank |
| 6.28.3 | Branch Code | branchCode |  | Lookup/Text |  |  | รหัสสาขาธนาคาร |  |
| 6.28.4 | Bank Branch | Bank Brach |  | Lookup/Text |  |  | ชื่อสาขาธนาคาร |  |
| 4.20 | Account No. | accountNo |  | Text |  |  | เลขที่ บช | account_no |
| 4.21 | Total Amount | totalAmount |  | Decimal |  |  | ยอดจ่าย | total_amount |
| 6.30 | withHolding Tax | withholdingTax |  | Decimal |  |  |  |  |
| 6.31 | NetAmount | netAmount |  | Decimal |  |  | รวมยอด |  |
| 6.32 | TotalReceiveAmount | totalReceiveAmt |  | Decimal |  |  | รวมยอดรับ |  |

### Example / Code Payload (Row 63)
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

### Example / Code Payload (Row 73)
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

### Example / Code Payload (Row 74)
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
