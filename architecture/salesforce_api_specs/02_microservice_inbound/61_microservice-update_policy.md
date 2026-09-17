# [61] Microservice-Update Policy

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Update Policy`
- **Total Rows Parsed**: `31`

## API Specification Overview

- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### E

### Request Message

### END POINT

| URL SIT | https://isv-api-dev.flybkk.com/ |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/ |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Policy Number | insurancePolicyId | InsurancePolicyId | Text(255) | Y | Y | เลขที่ของ  Policy Id |
| 2 | New Account ID | accountID | NameInsuredId | Text(18) | Y |  | Account Unique ID |
| 3 | No Cancel Flag | no_cancel_flag |  | Text(1) |  |  | Y = ห้ามสลักหลังยกเลิก , N = สามารถสลักหลังยกเลิกได้ |
| 4 | No Cancel Reason | no_cancel_reason |  | Text(500) |  |  | เหตุผลในการห้ามสลักหลังยกเลิก |
| 5 | No Cancel Date | no_cancel_at |  | datetime |  |  | เวลาที่ update ห้ามสลักหลังยกเลิก |
| 6 | Deli_Flag | deliFlag | Delivery_Flag__c | Text(1) |  |  | Y = จัดส่งรูปเล่มกรมธรรม์, N = ไม่จัดส่งรูปเล่มกรมธรรม์ |
| 7 | Deli_Addr | deliAddr | Delivery_Address__c | Text(255) |  |  | ที่อยู่สำหรับจัดส่งกรมธรรม์ |
| 8 | Deli_subdistrict_id | deliSubdistrictId | Delivery_Subdistrict_ID__c | Int(32) |  |  | รหัส แขวง/ตำบลสำหรับจัดส่งกรมธรรม์ |
| 9 | Deli_district_id | deliDistrictId | Delivery_District_ID__c | Int(32) |  |  | รหัส เขต/อำเภอสำหรับจัดส่งกรมธรรม์ |
| 10 | Deli_province_id | deliProvinceId | Delivery_Province_ID__c | Int(32) |  |  | รหัส จังหวัดสำหรับจัดส่งกรมธรรม์ |
| 11 | Deli_zipcode | deliZipcode | Delivery_Zipcode__c | Text(45) |  |  | รหัสไปรษณีย์สำหรับจัดส่งกรมธรรม์ |

### Example / Code Payload (Row 24)
**Example Request**
```json
{
  "accountID": "5001y0000018pGJAAY",
}
```

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Title | title |  | Text |  |  |  |
| 2 | Status | status |  | Int |  |  |  |
| 3 | Description | description |  | Text |  |  |  |

### Example / Code Payload (Row 30)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53"
```

### Example / Code Payload (Row 31)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Account ID not found",
  "timestamp": "2022-01-28T11:24:53"
}
```
