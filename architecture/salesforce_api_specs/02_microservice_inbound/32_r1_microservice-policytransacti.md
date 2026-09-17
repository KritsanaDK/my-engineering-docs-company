# [32] R1 Microservice-PolicyTransacti

- **Category**: `microservice_inbound`
- **Source Sheet**: `R1 Microservice-PolicyTransacti`
- **Total Rows Parsed**: `51`

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

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | SF Field (old) | Type | External Key | Required Field | SF Field Label | SF Field Label (old) | Remark | GCP Table | GCP Field | GCP Remark |
| 1 | Function API | fn |  |  | Text |  |  |  |  | Fix: PolicyTransacti |  |  |  |
| 2 | Policy Number | insurancePolicyId | Policy_Number__c |  | Text(255) | Y | Y |  |  | เลขที่ของ  Policy Id  กรณี Transaction GCP x10 เก็บข้อมูลการสลักหลังในรูปแบบ History จะไม่ทำการแก้ไข Transaction ที่เคยเกิดขึ้นไปแล้ว | Policy_Header | Policy_No |  |
| 3 | Type | type | Type |  | Array[Picklist] |  | Y |  |  | ระบุ Field ที่ต้องการแก้ไข เช่น  cancellation = กรณียกเลิกกรมธรรม์ ownerPrefixName ownerDistrictId เป็นต้น ** รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง //  รยภ 00 ยกเลิกประกันชั้น 2+3+ | Policy_Header | SF_Endorse_type |  |
| 4 | Owner_prefix_name | ownerPrefixName | Owner_Prefix_Id__c | Old_Owner_Prefix_Id__c | Text(50) |  |  | คำนำหน้า | คำนำหน้า (ค่าเดิม) | รย 23 คำนำหน้าชื่อผู้เอาประกัน | Policy_Header | Owner_prefix_name |  |
| 5 | Owner_first_name | ownerFirstName | Owner_First_Name__c | Old_Owner_First_Name__c | Text(255) |  |  | ชื่อ | ชื่อ (ค่าเดิม) | รย 23 ชื่อผู้เอาประกัน | Policy_Header | Owner_first_name |  |
| 6 | Owner_last_name | ownerLastName | Owner_Last_Name__c | Old_Owner_Last_Name__c | Text(255) |  |  | นามสกุล | นามสกุล (ค่าเดิม) | รย 23 นามสกุลผู้เอาประกัน | Policy_Header | Owner_last_name |  |
| 7 | Owner_address | ownerAddress | Owner_Address_No__c | Old_Owner_Address_No__c | Text(500) |  |  | บ้านเลขที่ | บ้านเลขที่ (ค่าเดิม) | รย 23 ที่อยู่ ผู้เอาประกัน | Policy_Header | Owner_address |  |
| 8 | Owner_province_id | ownerProvinceId | Owner_Province_Id__c | Old_Owner_Province_Id__c | Text(255) |  |  | รหัสจังหวัด | รหัสจังหวัด (ค่าเดิม) | รย 23 รหัสจังหวัด ผู้เอาประกัน | Policy_Header | Owner_province_id |  |
| 9 |  |  | Owner_Province__c | Old_Owner_Province_Id__c | Text(255) |  |  | รหัสจังหวัด | รหัสจังหวัด (ค่าเดิม) |  |  |  |  |
| 10 | Owner_subdistrict_id | ownerSubdistrictId | Owner_Subdistrict_Id__c | Old_Owner_Subdistrict_Id__c | Text(255) |  |  | รหัสแขวง/ตำบล | รหัสแขวง/ตำบล (ค่าเดิม) | รย 23 รหัสแขวง/ตำบล ผู้เอาประกัน | Policy_Header | Owner_subdistrict_id |  |
| 11 |  |  | Owner_Subdistrict__c | Old_Owner_Subdistrict__c | Text(255) |  |  | รหัสแขวง/ตำบล | รหัสแขวง/ตำบล (ค่าเดิม) |  |  |  |  |
| 12 | Owner_district_id | ownerDistrictId | Owner_District_Id__c | Old_Owner_District_Id__c | Text(255) |  |  | รหัสเขต/อำเภอ | รหัสเขต/อำเภอ (ค่าเดิม) | รย 23 รหัสเขต/อำเภอ ผู้เอาประกัน | Policy_Header | Owner_district_id |  |
| 13 |  |  | Owner_District__c | Old_Owner_District__c | Text(255) |  |  | รหัสเขต/อำเภอ | รหัสเขต/อำเภอ (ค่าเดิม) |  |  |  |  |
| 14 | Owner_zipcode | ownerZipcode | Owner_Zipcode__c | Old_Owner_Zipcode__c | Text(10) |  |  | รหัสไปรษณีย์ | รหัสไปรษณีย์ (ค่าเดิม) | รย 23 รหัสไปรษณีย์ ผู้เอาประกัน (5 หลัก) | Policy_Header | Owner_zipcode |  |
| 15 | Car_license no | carLicenseNo | Car_License_No__c | Old_Car_License_No__c | Text(10) |  |  | ป้ายเลขทะเบียนรถ | ป้ายเลขทะเบียนรถ (ค่าเดิม) | รย 17 ป้ายเลขทะเบียน | Policy_Header | Car_license_no |  |
| 16 | Car license provice | carLicenseProvice | Car_License_Provice__c | Old_Car_License_Provice__c | Text(255) |  |  | จังหวัดที่จดทะเบียนรถ | จังหวัดที่จดทะเบียนรถ (ค่าเดิม) | รย 17 จังหวัด ที่จด | Policy_Header | Car_license_provice |  |
| 17 | Car serial no | carSerialNo | Car_Serial_No__c | Old_Car_Serial_No__c | Text(255) |  |  | ตัวถังรถ | ตัวถังรถ (ค่าเดิม) | รย 17 ตัวถังรถ | Policy_Header | Car_serial_no |  |
| 18 | Car Brand | carBrand | Car_Brand | Old_Car_Brand | Text(255) |  |  | ยี่ห้อรถ | ยี่ห้อรถ (ค่าเดิม) | รย 17 ยี่ห้อรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 | Policy_Header,  Policy_coverage_premium | Brand |  |
| 19 | Car Model | carModel | Car_Model | Old_Car_Model | Text(255) |  |  | รุ่นรถ | รุ่นรถ (ค่าเดิม) | รย 17 รุ่นรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 | Policy_Header,  Policy_coverage_premium | Model |  |
| 20 | Car CC | carCc | Car_CC | Old_Car_CC | Text(255) |  |  | ซีซีรถ | ซีซีรถ (ค่าเดิม) | รย 17 ซีซีรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 | Policy_Header | CC |  |
| 21 | Policy Startdate | startDate | Policy_Startdate__c | Old_Policy_Startdate__c | Datetime |  |  | วันเริ่มต้นคุ้มครอง | วันเริ่มต้นคุ้มครอง (ค่าเดิม) | รย 19 วันเริ่มต้นคุ้มครอง กรณีล่วงหน้าเวลาเป็น 00:01 Fix **ยังไม่เริ่มคุ้มครองเท่านั้น ถึงจะแก้ไขวันเริ่มคุ้มครองใหม่ได้ | Policy_Header | Policy_Startdate |  |
| 22 | Policy Enddate | endDate | Policy_Etartdate__c | Old_Policy_Etartdate__c | Datetime |  |  | วันสิ้นสุดคุ้มครอง | วันสิ้นสุดคุ้มครอง (ค่าเดิม) | รย 19 วันสิ้นสุดคุ้มครอง เวลาต้องเป็น 16:30 Fix **ยังไม่เริ่มคุ้มครองเท่านั้น ถึงจะแก้ไขวันเริ่มคุ้มครองใหม่ได้ | Policy_Header | Policy_Enddate |  |
| 23 | Appr_prefix_name | apprPrefixName | ApproverPrefix__c |  | Text(50) |  |  | คำนำหน้าผู้อนุมัติกรณีสลักหลัง |  |  | Policy_Header | Appr_prefix_name |  |
| 24 | Appr_first_name | apprFirstName | ApproverFirstName__c |  | Text(255) |  |  | ชื่อผู้อนุมัติกรณีสลักหลัง |  |  | Policy_Header | Appr_first_name |  |
| 25 | Appr_last_name | apprLastName | ApproverLastName__c |  | Text(255) |  |  | นามสกุลผู้อนุมัติกรณีสลักหลัง |  |  | Policy_Header | Appr_last_name |  |
| 26 | effective_date | effectiveDate | Endors_Datetime__c |  | Datetime |  |  | วันที่มีผลบังคับใช้ |  |  | Policy_Header | Effective_Startdate |  |

### Example / Code Payload (Row 39)
**Example Request**
```json
{
    "fn": "PolicyTransacti",
    "insurancePolicyId": "MV-0023-C-00005m",
    "type": ["ownerPrefixName","ownerAddress"],
    "ownerPrefixName": "นาย",
    "ownerFirstName": "ชัยพิ",
    "ownerLastName": "พัฒน์",
    "ownerAddress": "123/22",
    "ownerProvinceId": 1,
    "ownerSubdistrictId": 1,
    "ownerDistrictId": 1,
    "ownerZipcode": "1234",
    "carLicenseNo": "1กก1111",
    "carLicenseProvice": 1,
    "carSerialNo": "11111",
    "carBrand": "honda",
    "carModel": "cccc",
    "carCc": "3000",
    "startDate": "2023-04-04 00:01:00.000",
    "endDate": "2023-04-03 16:30:00.000",
    "apprPrefixName": "",
    "apprFirstName": "autoconver",
    "apprLastName": ""
}
```

| No | Insert Policy Transaction | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field |  | Type | External Key | Required Field |  |  | Remark | GCP Table | GCP Field | GCP Remark |
| 1 | Response title | title |  |  | Text(50) |  | Y |  |  |  |  |  |  |
| 2 | Status code | status |  |  | Int |  | Y |  |  |  |  |  |  |
| 3 | Description | description |  |  | Text(500) |  | Y |  |  |  |  |  |  |
| 4 | Result | result |  |  | Object |  | Y |  |  |  |  |  |  |
| 4.1 | Policy Number | insurancePolicyId |  |  | Text(255) |  |  |  |  |  |  |  |  |
| 4.2 | Transaction Number | transactionNumber | External_ID__c |  | Text(255) |  |  |  |  |  |  |  |  |
| 4.3 | Document Type | endorseDocType | Document_Type__c |  | Text(255) |  |  |  |  |  |  |  |  |
| 4.4 | Document Name | endorseDocName | Document_Name__c |  | Text(255) |  |  |  |  |  |  |  |  |

### Example / Code Payload (Row 50)
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

### Example / Code Payload (Row 51)
**Example Response
(Error)**
```json
{
    "title": "Unsuccess",
    "status": 401,
    "description": "Key (\"Policy_No\", \"Effective_Startdate\")=(MV-0023-C-00005m, 2023-04-03 00:00:00) already exists.",
    "result": {}
}
```
