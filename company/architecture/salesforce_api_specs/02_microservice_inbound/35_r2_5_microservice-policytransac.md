# [35] R2.5 Microservice-PolicyTransac

- **Category**: `microservice_inbound`
- **Source Sheet**: `R2.5 Microservice-PolicyTransac`
- **Total Rows Parsed**: `194`

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

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 | Col20 | Col21 | Col22 | Col23 | Col24 | Col25 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | SF Field (old) | Type | External Key | Required Field | SF Field Label | SF Field Label (old) | Remark | Example Data | GCP Table | GCP Field | GCP Remark |  | 5.0 |  |  | AI |  |  | CR 21 |  |  |
| 1 | Function API | fn |  |  | Text |  |  |  |  | Fix: PolicyTransacti |  |  |  |  |  | fn | 1 |  | fn | 1 |  | fn | 1 |  |
| 2 | Policy Number | insurancePolicyId | Policy_Number__c |  | Text(255) | Y | Y |  |  | เลขที่ของ  Policy Id  กรณี Transaction GCP x10 เก็บข้อมูลการสลักหลังในรูปแบบ History จะไม่ทำการแก้ไข Transaction ที่เคยเกิดขึ้นไปแล้ว |  | Policy_Header | Policy_No |  |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |  |
| 3 | Salesforce ID | salesforceID | Id |  | Text(18) | Y |  |  |  | Endorsment ID ของ Salesforce |  |  |  |  |  | salesforceID | 1 |  | salesforceID | 1 |  | salesforceID | 1 |  |
| 4 | Type | type | Type |  | Array[Picklist] |  | Y |  |  | ระบุ Field ที่ต้องการแก้ไข เช่น  cancellation = กรณียกเลิกกรมธรรม์ ownerPrefixName ownerDistrictId เป็นต้น ** รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง //  รยภ 00 ยกเลิกประกันชั้น 2+3+ |  | Policy_Header | SF_Endorse_type |  |  | type | 1 |  | type | 1 |  | type | 1 |  |
| 5 | Owner_prefix_name | ownerPrefixName | Owner_Prefix_Id__c | Old_Owner_Prefix_Id__c | Text(50) |  |  | คำนำหน้า | คำนำหน้า (ค่าเดิม) | รย 23 คำนำหน้าชื่อผู้เอาประกัน |  | Policy_Header | Owner_prefix_name |  |  | ownerPrefixName | 1 |  | ownerPrefixName | 1 |  | ownerPrefixName | 1 |  |
| 6 | Owner_first_name | ownerFirstName | Owner_First_Name__c | Old_Owner_First_Name__c | Text(255) |  |  | ชื่อ | ชื่อ (ค่าเดิม) | รย 23 ชื่อผู้เอาประกัน |  | Policy_Header | Owner_first_name |  |  | ownerFirstName | 1 |  | ownerFirstName | 1 |  | ownerFirstName | 1 |  |
| 7 | Owner_last_name | ownerLastName | Owner_Last_Name__c | Old_Owner_Last_Name__c | Text(255) |  |  | นามสกุล | นามสกุล (ค่าเดิม) | รย 23 นามสกุลผู้เอาประกัน |  | Policy_Header | Owner_last_name |  |  | ownerLastName | 1 |  | ownerLastName | 1 |  | ownerLastName | 1 |  |
| 8 | Owner_address | ownerAddress | Owner_Address_No__c | Old_Owner_Address_No__c | Text(500) |  |  | บ้านเลขที่ | บ้านเลขที่ (ค่าเดิม) | รย 23 ที่อยู่ ผู้เอาประกัน |  | Policy_Header | Owner_address |  |  | ownerAddress | 1 |  | ownerAddress | 1 |  | ownerAddress | 1 |  |
| 9 | Owner_province_id | ownerProvinceId | Owner_Province_Id__c | Old_Owner_Province_Id__c | Text(255) |  |  | รหัสจังหวัด | รหัสจังหวัด (ค่าเดิม) | รย 23 รหัสจังหวัด ผู้เอาประกัน |  | Policy_Header | Owner_province_id |  |  | ownerProvinceId | 1 |  | ownerProvinceId | 1 |  | ownerProvinceId | 1 |  |
| 10 | Owner_subdistrict_id | ownerSubdistrictId | Owner_Subdistrict_Id__c | Old_Owner_Subdistrict_Id__c | Text(255) |  |  | รหัสแขวง/ตำบล | รหัสแขวง/ตำบล (ค่าเดิม) | รย 23 รหัสแขวง/ตำบล ผู้เอาประกัน |  | Policy_Header | Owner_subdistrict_id |  |  | ownerSubdistrictId | 1 |  | ownerSubdistrictId | 1 |  | ownerSubdistrictId | 1 |  |
| 11 | Owner_district_id | ownerDistrictId | Owner_District_Id__c | Old_Owner_District_Id__c | Text(255) |  |  | รหัสเขต/อำเภอ | รหัสเขต/อำเภอ (ค่าเดิม) | รย 23 รหัสเขต/อำเภอ ผู้เอาประกัน |  | Policy_Header | Owner_district_id |  |  | ownerDistrictId | 1 |  | ownerDistrictId | 1 |  | ownerDistrictId | 1 |  |
| 12 | Owner_zipcode | ownerZipcode | Owner_Zipcode__c | Old_Owner_Zipcode__c | Text(10) |  |  | รหัสไปรษณีย์ | รหัสไปรษณีย์ (ค่าเดิม) | รย 23 รหัสไปรษณีย์ ผู้เอาประกัน (5 หลัก) |  | Policy_Header | Owner_zipcode |  |  | ownerZipcode | 1 |  | ownerZipcode | 1 |  | ownerZipcode | 1 |  |
| 13 | Owner Birthdate | ownerBirthdate | Owner_Birthdate__c | Old_Owner_Birthdate__c | Date |  |  | วันเดือนปีเกิด |  |  |  |  |  |  |  | ownerBirthdate | 1 |  | ownerBirthdate | 1 |  | ownerBirthdate | 1 |  |
| 14 | Owner Id Card | ownerCardId | Owner_ID_Card__c | Old_Owner_ID_Card__c | Text(13) |  |  | เลขบัตรประชาชน |  |  |  |  |  |  |  | ownerCardId | 1 |  | ownerCardId | 1 |  | ownerCardId | 1 |  |
| 15 | Payer Tel | ownerTel | Owner_Tel__c | Old_Owner_Tel__c | Text(40) |  |  | เบอร์โทรศัพท์ |  |  |  |  |  |  |  | ownerTel | 1 |  | ownerTel | 1 |  | ownerTel | 1 |  |
| 16 | Payer Email | ownerEmail | Owner_Email__c | Old_Owner_Email__c | Text(40) |  |  | อีเมล |  |  |  |  |  |  |  | ownerEmail | 1 |  | ownerEmail | 1 |  | ownerEmail | 1 |  |
| 17 | Car Color | carColor | Car_Color__c, Car_Color_ID__c | Old_Car_Color__c |  |  |  | สีรถ |  |  |  |  |  |  |  | carColor | 1 |  | carColor | 1 |  | carColor | 1 |  |
| 18 | Car License Type | carLicenseType | Car_License_Type__c, Car_License_Type_Code__c | Old_Car_License_Type__c | Picklist |  |  | ประเภททะเบียนรถ |  |  |  |  |  |  |  | carLicenseType | 1 |  | carLicenseType | 1 |  | carLicenseType | 1 |  |
| 19 | Car_license no | carLicenseNo | Car_License_No__c | Old_Car_License_No__c | Text(10) |  |  | ป้ายเลขทะเบียนรถ | ป้ายเลขทะเบียนรถ (ค่าเดิม) | รย 17 ป้ายเลขทะเบียน |  | Policy_Header | Car_license_no |  |  | carLicenseNo | 1 |  | carLicenseNo | 1 |  | carLicenseNo | 1 |  |
| 20 | Car license provice | carLicenseProvice | Car_License_Provice__c | Old_Car_License_Provice__c | Text(255) |  |  | จังหวัดที่จดทะเบียนรถ | จังหวัดที่จดทะเบียนรถ (ค่าเดิม) | รย 17 จังหวัด ที่จด |  | Policy_Header | Car_license_provice |  |  | carLicenseProvice | 1 |  | carLicenseProvice | 1 |  | carLicenseProvice | 1 |  |
| 21 | Car serial no | carSerialNo | Car_Serial_No__c | Old_Car_Serial_No__c | Text(255) |  |  | ตัวถังรถ | ตัวถังรถ (ค่าเดิม) | รย 17 ตัวถังรถ |  | Policy_Header | Car_serial_no |  |  | carSerialNo | 1 |  | carSerialNo | 1 |  | carSerialNo | 1 |  |
| 22 | Car Brand | carBrand | Car_Brand | Old_Car_Brand | Text(255) |  |  | ยี่ห้อรถ | ยี่ห้อรถ (ค่าเดิม) | รย 17 ยี่ห้อรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  | Policy_Header,  Policy_coverage_premium | Brand |  |  | carBrand | 1 |  | carBrand | 1 |  | carBrand | 1 |  |
| 23 | Car Model | carModel | Car_Model | Old_Car_Model | Text(255) |  |  | รุ่นรถ | รุ่นรถ (ค่าเดิม) | รย 17 รุ่นรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  | Policy_Header,  Policy_coverage_premium | Model |  |  | carModel | 1 |  | carModel | 1 |  | carModel | 1 |  |
| 24 | Car CC | carCc | Car_CC | Old_Car_CC | Text(255) |  |  | ซีซีรถ | ซีซีรถ (ค่าเดิม) | รย 17 ซีซีรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  | Policy_Header | CC |  |  | carCc | 1 |  | carCc | 1 |  | carCc | 1 |  |
| 25 | Policy Startdate | startDate | Policy_Startdate__c | Old_Policy_Startdate__c | Datetime |  |  | วันเริ่มต้นคุ้มครอง | วันเริ่มต้นคุ้มครอง (ค่าเดิม) | รย 19 วันเริ่มต้นคุ้มครอง กรณีล่วงหน้าเวลาเป็น 00:01 Fix **ยังไม่เริ่มคุ้มครองเท่านั้น ถึงจะแก้ไขวันเริ่มคุ้มครองใหม่ได้ |  | Policy_Header | Policy_Startdate |  |  | startDate | 1 |  | startDate | 1 |  | startDate | 1 |  |
| 26 | Policy Enddate | endDate | Policy_Etartdate__c | Old_Policy_Etartdate__c | Datetime |  |  | วันสิ้นสุดคุ้มครอง | วันสิ้นสุดคุ้มครอง (ค่าเดิม) | รย 19 วันสิ้นสุดคุ้มครอง เวลาต้องเป็น 16:30 Fix **ยังไม่เริ่มคุ้มครองเท่านั้น ถึงจะแก้ไขวันเริ่มคุ้มครองใหม่ได้ |  | Policy_Header | Policy_Enddate |  |  | endDate | 1 |  | endDate | 1 |  | endDate | 1 |  |
| 27 | Approve Status | apprStatus | Status |  | Text(255) |  |  | Approved, Rejected (สำหรับรายการที่ส่งมาจาก PWA) |  |  |  |  |  |  |  | apprStatus | 1 |  | apprStatus | 1 |  | apprStatus | 1 |  |
| 28 | Approver Prefix | apprPrefixName | ApproverPrefix__c |  | Text(50) |  |  | คำนำหน้าผู้อนุมัติกรณีสลักหลัง |  |  |  | Policy_Header | Appr_prefix_name |  |  | apprPrefixName | 1 |  | apprPrefixName | 1 |  | apprPrefixName | 1 |  |
| 29 | Approver Firstname | apprFirstName | ApproverFirstName__c |  | Text(255) |  | Y | ชื่อผู้อนุมัติกรณีสลักหลัง |  |  |  | Policy_Header | Appr_first_name |  |  | apprFirstName | 1 |  | apprFirstName | 1 |  | apprFirstName | 1 |  |
| 30 | Approver Lastname | apprLastName | ApproverLastName__c |  | Text(255) |  |  | นามสกุลผู้อนุมัติกรณีสลักหลัง |  |  |  | Policy_Header | Appr_last_name |  |  | apprLastName | 1 |  | apprLastName | 1 |  | apprLastName | 1 |  |
| 31 | Approver Comment | apprComment | ApproverComment__c |  | Text(4000) |  |  | Comment ของ ผู้อนุมัติ |  |  |  |  |  |  |  | apprComment | 1 |  | apprComment | 1 |  | apprComment | 1 |  |
| 32 | effective_date | effectiveDate | Endors_Datetime__c |  | Datetime |  |  | วันที่มีผลบังคับใช้ |  |  |  | Policy_Header | Effective_Startdate |  |  | effectiveDate | 1 |  | effectiveDate | 1 |  | effectiveDate | 1 |  |
| 33 | Deli_Flag | deliFlag | Delivery_Flag__c |  | Text(1) |  |  | Y = จัดส่งรูปเล่มกรมธรรม์, N = ไม่จัดส่งรูปเล่มกรมธรรม์ |  |  |  |  |  |  |  | deliFlag | 1 |  | deliFlag | 1 |  | deliFlag | 1 |  |
| 34 | Delivery address | deliAddress | Delivery_Address__c | Old_Delivery_Address__c | Text(500) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliAddress | 1 |  | deliAddress | 1 |  | deliAddress | 1 |  |
| 35 | Delivery province_id | deliProvinceId | Delivery_Province__c, Delivery_Province_ID__c | Old_Delivery_Province__c, Old_Delivery_Province_ID__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliProvinceId | 1 |  | deliProvinceId | 1 |  | deliProvinceId | 1 |  |
| 36 | Delivery_subdistrict_id | deliSubdistrictId | Delivery_Subdistrict__c, Delivery_Subdistrict_ID__c | Old_Delivery_Subdistrict__c, Old_Delivery_Subdistrict_ID__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliSubdistrictId | 1 |  | deliSubdistrictId | 1 |  | deliSubdistrictId | 1 |  |
| 37 | Delivery_district_id | deliDistrictId | Delivery_District__c, Delivery_District_ID__c | Old_Delivery_District__c, Old_Delivery_District_ID__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliDistrictId | 1 |  | deliDistrictId | 1 |  | deliDistrictId | 1 |  |
| 38 | Delivery_zipcode | deliZipcode | Delivery_Zipcode__c | Old_Delivery_Zipcode__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliZipcode | 1 |  | deliZipcode | 1 |  | deliZipcode | 1 |  |
| 39 | Beneficiary Type | beneType | Beneficiary_Type__c, Beneficiary_Type_Code__c | Old_Beneficiary_Type__c | Picklist |  |  | ประเภทผู้รับผลประโยชน์ |  | Finance, Person |  |  |  |  |  | beneType | 1 |  | beneType | 1 |  | beneType | 1 |  |
| 40 | Benificiary Title Name | beneTitle | Beneficiary_Title__c | Old_Beneficiary_Title__c | Text(50) |  |  | คำนำหน้าผู้รับผลประโยชน์ |  |  |  |  |  |  |  | beneTitle | 1 |  | beneTitle | 1 |  | beneTitle | 1 |  |
| 41 | Benificiary First Name | beneFirstname | Beneficiary_Firstname__c | Old_Beneficiary_Firstname__c | Text(255) |  |  | ชื่อผู้รับผลประโยชน์ |  |  |  |  |  |  |  | beneFirstname | 1 |  | beneFirstname | 1 |  | beneFirstname | 1 |  |
| 42 | Benificiary Last Name | beneLastname | Beneficiary_Lastname__c | Old_Beneficiary_Lastname__c | Text(255) |  |  | นามสกุลผู้รับผลประโยชน์ |  |  |  |  |  |  |  | beneLastname | 1 |  | beneLastname | 1 |  | beneLastname | 1 |  |
| 43 | Driver Action | driveAction |  | ได้จากการเลือก รย | Picklist |  |  | Add = รย26 / Edit = รย28 / Delete = รย27 หมายเหตุ ส่งทุกครั้งถ้ามี รย 26 27 28 |  |  |  |  |  |  |  | driveAction | 1 |  | driveAction | 1 |  | driveAction | 1 |  |
| 44 | Driver Prefix 1 | par1Prefix | Driver_1_Prefix__c, Driver_1_Prefix_Code__c | Old_Driver_1_Prefix__c | Text(50) |  |  | คำนำหน้าผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1Prefix | 1 |  | par1Prefix | 1 |  | par1Prefix | 1 |  |
| 45 | Driver Firstname 1 | par1Firstname | Driver_1_Firstname__c | Old_Driver_1_Firstname__c | Text(255) |  |  | ชื่อผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1Firstname | 1 |  | par1Firstname | 1 |  | par1Firstname | 1 |  |
| 46 | Driver Lastname 1 | par1Lastname | Driver_1_Lastname__c | Old_Driver_1_Lastname__c | Text(255) |  |  | นามสกุลผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1Lastname | 1 |  | par1Lastname | 1 |  | par1Lastname | 1 |  |
| 47 | Driver License No 1 | par1DriverNo | Driver_1_License__c | Old_Driver_1_License__c | Text(255) |  |  | เลขที่ใบขับขี่ 1 |  |  |  |  |  |  |  | par1DriverNo | 1 |  | par1DriverNo | 1 |  | par1DriverNo | 1 |  |
| 48 | Driver Citizen ID 1 | par1CitizenId | Driver_1_ID__c | Old_Driver_1_ID__c | Text(20) |  |  | บัตรประชาชนผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1CitizenId | 1 |  | par1CitizenId | 1 |  | par1CitizenId | 1 |  |
| 49 | Driver Prefix 2 | par2Prefix | Driver_2_Prefix__c, Driver_2_Prefix_Code__c | Old_Driver_2_Prefix__c | Text(50) |  |  | คำนำหน้าผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2Prefix | 1 |  | par2Prefix | 1 |  | par2Prefix | 1 |  |
| 50 | Driver Firstname 2 | par2Firstname | Driver_2_Firstname__c | Old_Driver_2_Firstname__c | Text(255) |  |  | ชื่อผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2Firstname | 1 |  | par2Firstname | 1 |  | par2Firstname | 1 |  |
| 51 | Driver Lastname 2 | par2Lastname | Driver_2_Lastname__c | Old_Driver_2_Lastname__c | Text(255) |  |  | นามสกุลผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2Lastname | 1 |  | par2Lastname | 1 |  | par2Lastname | 1 |  |
| 52 | Driver License No 2 | par2DriverNo | Driver_2_License__c | Old_Driver_2_License__c | Text(255) |  |  | เลขที่ใบขับขี่ 2 |  |  |  |  |  |  |  | par2DriverNo | 1 |  | par2DriverNo | 1 |  | par2DriverNo | 1 |  |
| 53 | Driver Citizen ID 2 | par2CitizenId | Driver_2_ID__c | Old_Driver_2_ID__c | Text(20) |  |  | บัตรประชาชนผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2CitizenId | 1 |  | par2CitizenId | 1 |  | par2CitizenId | 1 |  |
| 54 | Coverage | coverageDetail |  |  | Object |  |  |  |  |  |  |  |  |  |  | coverageDetail | 1 |  | coverageDetail | 1 |  | coverageDetail | 1 |  |
| 54.1 | Field Name | fieldName |  |  | Array[Picklist] |  |  | Field ที่มีการแก้ไข |  |  |  |  |  |  |  | fieldName | 1 |  | fieldName | 1 |  | fieldName | 1 |  |
| 54.2 | Policy Type | policyType | From Policy |  | Text(5) |  |  | ชั้นประกัน |  |  |  |  |  |  |  | policyType | 1 |  | policyType | 1 |  | policyType | 1 |  |
| 54.3 | Coverage day count | coverageDayCount | From Policy |  | Integer |  |  | จำนวนวันที่คุ้มครองไปแล้ว |  |  |  |  |  |  |  | coverageDayCount | 1 |  | coverageDayCount | 1 |  | coverageDayCount | 1 |  |
| 54.4 | Car Brand | carBrand | Car_Brand__c | Old_Car_Brand__c | Text(255) |  |  | ยี่ห้อรถ | ยี่ห้อรถ (ค่าเดิม) | รย 17 ยี่ห้อรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  |  |  |  |  | carBrand | 1 |  | carBrand | 1 |  | carBrand | 1 |  |
| 54.5 | Car Model | carModel | Car_Model__c | Old_Car_Model__c | Text(255) |  |  | รุ่นรถ | รุ่นรถ (ค่าเดิม) | รย 17 รุ่นรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  |  |  |  |  | carModel | 1 |  | carModel | 1 |  | carModel | 1 |  |
| 54.6 | GarageType | garageType | From Policy |  | Text(2) |  |  | ประเภทอู่ซ่อม |  |  |  |  |  |  |  | garageType | 1 |  | garageType | 1 |  | garageType | 1 |  |
| 54.7 | Base Premium | basicPremAmt | Base_Premium__c | Old_Base_Premium__c | Currency(16, 2) |  |  | เบี้ยพื้นฐาน (ประกันกลุ่ม 1 ชั้น 1,3) |  |  |  |  |  |  |  | basicPremAmt | 1 |  | basicPremAmt | 1 |  | basicPremAmt | 1 |  |
| 54.8 | Base Premium v5 | basicPremV5Amt | Base_Premium_V5__c | Old_Base_Premium_V5__c | Currency(16, 2) |  |  | เบี้ยพื้นฐาน (ประกันกลุ่ม 5 ชั้น 2+,3+) |  |  |  |  |  |  |  | basicPremV5Amt | 1 |  | basicPremV5Amt | 1 |  | basicPremV5Amt | 1 |  |
| 54.9 | Premium v5 OD | premiumV5Od | Premium_V5_OD__c | Old_Premium_V5_OD__c | Currency(16, 2) |  |  | เบี้ยประกันชั้น 2+3+ |  |  |  |  |  |  |  | premiumV5Od | 1 |  | premiumV5Od | 1 |  | premiumV5Od | 1 |  |
| 54.10 | Usage | usage | Usage__c | From Select Car Model | Integer |  |  | การใช้รถ |  |  |  |  |  |  |  | usage | 1 |  | usage | 1 |  | usage | 1 |  |
| 54.11 | Usage Tariff | usageTariff | Usage_Tariff__c | From Select Car Model | Percent (6,4) |  |  | Tariff การใช้รถ |  |  |  |  |  |  |  | usageTariff | 1 |  | usageTariff | 1 |  | usageTariff | 1 |  |
| 54.12 | Car CC | carCc | Car_CC__c | Old_Car_CC__c | Text(255) |  |  | ซีซีรถ | ซีซีรถ (ค่าเดิม) | รย 17 ซีซีรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  |  |  |  |  | carCc | 1 |  | carCc | 1 |  | carCc | 1 |  |
| 54.13 | Car CC Condition | carCcCondition | Car_CC_Condition__c | From Select Car CC | Text(255) |  |  | ช่วงซีซีกำหนดตาม Master Data |  |  |  |  |  |  |  | carCcCondition | 1 |  | carCcCondition | 1 |  | carCcCondition | 1 |  |
| 54.14 | Car CC Tariff | carCcTariff | Car_CC_Tariff__c | From Select Car CC | Percent (6,4) |  |  | Tariff ซีซีรถ |  |  |  |  |  |  |  | carCcTariff | 1 |  | carCcTariff | 1 |  | carCcTariff | 1 |  |
| 54.15 | Driver Birthdate 1 | driverBrithdate1 | Driver_1_Birthdate__c | Old_Driver_1_Birthdate__c | Date |  |  | วันเกิดผู้ขับขี่ 1 |  |  |  |  |  |  |  | driverBrithdate1 | 1 |  | driverBrithdate1 | 1 |  | driverBrithdate1 | 1 |  |
| 54.16 | Driver Birthdate 2 | driverBrithdate2 | Driver_2_Birthdate__c | Old_Driver_2_Birthdate__c | Date |  |  | วันเกิดผู้ขับขี่ 2 |  |  |  |  |  |  |  | driverBrithdate2 | 1 |  | driverBrithdate2 | 1 |  | driverBrithdate2 | 1 |  |
| 54.17 | Driver Age | driverAge | Driver_Age_Range__c | From Calculate Driver Age (ดูจากคนน้อยสุด) | Text(255) |  |  | ช่วงอายุผู้ขับขี่ |  |  |  |  |  |  |  | driverAge | 1 |  | driverAge | 1 |  | driverBirthdate3 | 0 | ใหม่ |
| 54.18 | Driver Age Discount | driverAgeDisc | Driver_Discount__c | Old_Driver_Discount__c | Currency(16, 2) |  |  | ส่วนลดผู้ขับขี่ |  |  |  |  |  |  |  | driverAgeDisc | 1 |  | driverAgeDisc | 1 |  | driverBirthdate4 | 0 | ใหม่ |
| 54.19 | Driver Age Tariff | driverAgeTariff | Driver_Age_Tariff__c | From Calculate Driver Age (ดูจากคนน้อยสุด) | Number (6,4) |  |  | Tariff อายุผู้ขับขี่ |  |  |  |  |  |  |  | driverAgeTariff | 1 |  | driverAgeTariff | 1 |  | driverBirthdate5 | 0 | ใหม่ |
| 54.20 | Car Year | carYear | Car_Year__c | Old_Car_Year__c | Text(4) |  |  | ปีที่จดทะเบียนรถ (ใน Bluebook) |  |  |  |  |  |  |  | carYear | 1 |  | carYear | 1 |  | driverAge | 1 |  |
| 54.21 | Car Year Tariff | carYearTariff | Car_Year_Tariff__c | From Select Car Year | Percent (6,4) |  |  | Tariff ปีที่จดทะเบียนรถ (ใน Bluebook) |  |  |  |  |  |  |  | carYearTariff | 1 |  | carYearTariff | 1 |  | driverAgeDisc | 1 |  |
| 54.22 | SI Amount | siAmt | SI_Amount__c | Old_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน |  |  |  |  |  |  |  | siAmt | 1 |  | siAmt | 1 |  | driverAgeTariff | 1 |  |
| 54.23 | OD Premium Amount | odAmt | OD_Premium__c | Old_OD_Premium__c | Currency(16, 2) |  |  | เบี้ยประกันค่าซาก (ไม่ได้ใช้งาน) |  |  |  |  |  |  |  | odAmt | 1 |  | odAmt | 1 |  | carYear | 1 |  |
| 54.24 | FT Premium Amount | ftAmt | FT_Premium__c | Old_FT_Premium__c | Currency(16, 2) |  |  | เบี้ยประกันไฟไหม้ น้ำท่วม (ไม่ได้ใช้งาน) |  |  |  |  |  |  |  | ftAmt | 1 |  | ftAmt | 1 |  | carYearTariff | 1 |  |
| 54.25 | Have Accessory | accessHave | Have_Accessory__c | Old_Have_Accessory__c | Boolean |  |  | มีคุ้มครองอุปกรณ์ตบแต่ง |  |  |  |  |  |  |  | accessHave | 1 |  | accessHave | 1 |  | siAmt | 1 |  |
| 54.26 | Accessory SI Amount | accessSiAmt | Accessory_SI_Amount__c | Old_Accessory_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันอุปกรณ์ตบแต่ง |  |  |  |  |  |  |  | accessSiAmt | 1 |  | accessSiAmt | 1 |  | odAmt | 1 |  |
| 54.27 | Accessory Premium Amount | accessPremAmt | Accessory_Premium__c | Old_Accessory_Premium__c | Currency(16, 2) |  |  | เบี้ยประกันอุปกรณ์ตบแต่ง (ไม่ได้ใช้งาน) |  |  |  |  |  |  |  | accessPremAmt | 1 |  | accessPremAmt | 1 |  | ftAmt | 1 |  |
| 54.28 | Accessory Name | accessName | Accessory_Name__c, Accessory_Name_Code__c, | Old_Accessory_Name__c | Array(String) |  |  | รายการอุปกรณ์ตกแต่ง |  |  |  |  |  |  |  | accessName | 1 |  | accessName | 1 |  | accessHave | 1 |  |
| 54.29 | SI Tariff | siTariff | SI_Tariff__c | From Select SI + Accessory | Percent (6,4) |  |  | Tariff ทุนประกัน+ทุนอุปกรณ์ตกแต่ง ถ้าไม่เจอให้ +1 ลำดับที่สูงกว่าถัดไป | {   "si": 50000,   "tariff": 100 }, {   "si": 60000,   "tariff": 100 }, |  |  |  |  |  |  | siTariff | 1 |  | siTariff | 1 |  | accessSiAmt | 1 |  |
| 54.30 | SI V5 Tariff | siV5Tariff |  | From Select SI + Accessory (2+3+) | Percent (6,4) |  |  | Tariff ทุนประกัน+ทุนอุปกรณ์ตกแต่ง สำหรับ 2+3+ ต้องระบุเพิ่ม ถ้าไม่เจอให้ +1 ลำดับที่สูงกว่าถัดไป (Base Premium + Base Premium V5) * isV5Tariff |  |  |  |  |  |  |  | siV5Tariff | 1 |  | siV5Tariff | 1 |  | accessPremAmt | 1 |  |
| 54.31 | Car Group | carGroup | Car_Group__c | From Select Car Model | Text(255) |  |  | กลุ่มรถ |  |  |  |  |  |  |  | carGroup | 1 |  | carGroup | 1 |  | accessName | 1 |  |
| 54.32 | Car Group Tariff | carGroupTariff | Car_Group_Tariff__c | From Select Car Model | Percent (6,4) |  |  | Tariff กลุ่มรถ |  |  |  |  |  |  |  | carGroupTariff | 1 |  | carGroupTariff | 1 |  | siTariff | 1 |  |
| 54.33 | TPBI per passenger SI Amount | tpbiPassSiAmt | TPBI_SI_Amount__c | Old_TPBI_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันคุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/คน |  |  |  |  |  |  |  | tpbiPassSiAmt | 1 |  | tpbiPassSiAmt | 1 |  | siV5Tariff | 1 |  |
| 54.34 | TPBI per passenger Premium Amount | tpbiPassPremAmt | TPBI_Premium__c | Old_TPBI_Premium__c | Currency(16, 2) |  |  | เบี้ยประกันคุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/คน (ไม่ได้ใช้งาน) |  |  |  |  |  |  |  | tpbiPassPremAmt | 1 |  | tpbiPassPremAmt | 1 |  | carGroup | 1 |  |
| 54.35 | TPBI per passenger Tariff | tpbiPassTariff | TPBI_Tariff__c | From Select TPBI SI | Percent (6,4) |  |  | Tariff คุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/คน |  |  |  |  |  |  |  | tpbiPassTariff | 1 |  | tpbiPassTariff | 1 |  | carGroupTariff | 1 |  |
| 54.36 | TPBI per event SI Amount | tpbiEventSiAmt | TPBI_Event_SI_Amount__c | Old_TPBI_Event_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันคุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tpbiEventSiAmt | 1 |  | tpbiEventSiAmt | 1 |  | tpbiPassSiAmt | 1 |  |
| 54.37 | TPBI per event Premium Amount | tpbiEventPremAmt | TPBI_Event_Premium__c | Old_TPBI_Event_Premium__c | Currency(16, 2) |  |  | เบี้ยประกันคุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/ครั้ง (ไม่ได้ใช้งาน) |  |  |  |  |  |  |  | tpbiEventPremAmt | 1 |  | tpbiEventPremAmt | 1 |  | tpbiPassPremAmt | 1 |  |
| 54.38 | TPBI per event Tariff | tpbiEventTariff | TPBI_Event_Tariff__c | From Select TPBI_E SI | Percent (6,4) |  |  | Tariff คุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tpbiEventTariff | 1 |  | tpbiEventTariff | 1 |  | tpbiPassTariff | 1 |  |
| 54.39 | TPPD SI Amount | tppdSiAmt | TPPD_SI_Amount__c | Old_TPPD_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันคุ้มครองทรัพย์สินของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tppdSiAmt | 1 |  | tppdSiAmt | 1 |  | tpbiEventSiAmt | 1 |  |
| 54.40 | TPPD Premium Amount | tppdPremAmt | TPPD_Premium__c | Old_TPPD_Premium__c | Currency(16, 2) |  |  | เบี้ยประกันคุ้มครองทรัพย์สินของบุคคลภายนอก/ครั้ง (ไม่ได้ใช้งาน) |  |  |  |  |  |  |  | tppdPremAmt | 1 |  | tppdPremAmt | 1 |  | tpbiEventPremAmt | 1 |  |
| 54.41 | TPPD Tariff | tppdTariff | TPPD_Tariff__c | From Select TPPD SI | Percent (6,4) |  |  | Tariff คุ้มครองทรัพย์สินของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tppdTariff | 1 |  | tppdTariff | 1 |  | tpbiEventTariff | 1 |  |
| 54.42 | Total exclude MV Amount | totalExMvAmt | Total_ex_MV_Amount__c | Old_Total_ex_MV_Amount__c | Currency(16, 2) |  |  | เบี้ยหลัก |  |  |  |  |  |  |  | totalExMvAmt | 1 |  | totalExMvAmt | 1 |  | tppdSiAmt | 1 |  |
| 54.43 | MV01 SI Amount | mv01SiAmt | MV01_SI_Amount__c | Old_MV01_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv01SiAmt | 1 |  | mv01SiAmt | 1 |  | tppdPremAmt | 1 |  |
| 54.44 | MV01 Premium Amount | mv01PremAmt | MV01_Premium__c | Old_MV01_Premium__c | Currency(16, 2) |  |  | เบี้ยประกัน รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv01PremAmt | 1 |  | mv01PremAmt | 1 |  | tppdTariff | 1 |  |
| 54.45 | MV02 SI Amount | mv02SiAmt | MV02_SI_Amount__c | Old_MV02_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv02SiAmt | 1 |  | mv02SiAmt | 1 |  | totalExMvAmt | 1 |  |
| 54.46 | MV02 Premium Amount | mv02PremAmt | MV02_Premium__c | Old_MV02_Premium__c | Currency(16, 2) |  |  | เบี้ยประกัน รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv02PremAmt | 1 |  | mv02PremAmt | 1 |  | mv01SiAmt | 1 |  |
| 54.47 | MV03 SI Amount | mv03SiAmt | MV03_SI_Amount__c | Old_MV03_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv03SiAmt | 1 |  | mv03SiAmt | 1 |  | mv01PremAmt | 1 |  |
| 54.48 | MV03 Premium Amount | mv03PremAmt | MV03_Premium__c | Old_MV03_Premium__c | Currency(16, 2) |  |  | เบี้ยประกัน รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv03PremAmt | 1 |  | mv03PremAmt | 1 |  | mv02SiAmt | 1 |  |
| 54.49 | Have Camera | cctvHave | Have_Camera__c | Old_Have_Camera__c | Boolean |  |  | มีกล้องติดรถ |  |  |  |  |  |  |  | cctvHave | 1 |  | cctvHave | 1 |  | mv02PremAmt | 1 |  |
| 54.50 | Camera Discount Percent | cctvPercent | From Policy |  | Number (6,4) |  |  | ส่วนลดกล้องติดรถ (%) |  |  |  |  |  |  |  | cctvPercent | 1 |  | cctvPercent | 1 |  | mv03SiAmt | 1 |  |
| 54.51 | Total MV Amount | totalMvAmt | Total_MV_Amount__c | MV01+MV02+MV03 | Currency(16, 2) |  |  | เบี้ยแนบ |  |  |  |  |  |  |  | totalMvAmt | 1 |  | totalMvAmt | 1 |  | mv03PremAmt | 1 |  |
| 54.52 | Fleet Discount Percent | fleetDiscPer | Fleet_Discount_Percent__c | Old_Fleet_Discount_Percent__c | Number (6,4) |  |  | % ส่วนลดกลุ่ม |  |  |  |  |  |  |  | fleetDiscPer | 1 |  | fleetDiscPer | 1 |  | cctvHave | 1 |  |
| 54.53 | Fleet Discount Amount | fleetDiscAmt | Fleet_Discount_Amount__c | Old_Fleet_Discount_Amount__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดกลุ่ม |  |  |  |  |  |  |  | fleetDiscAmt | 1 |  | fleetDiscAmt | 1 |  | cctvPercent | 1 |  |
| 54.54 | NCB Discount Percent | ncbDiscPer | NCB_Discount_Percent__c | Old_NCB_Discount_Percent__c | Number (6,4) |  |  | % ส่วนลดประวัติดี |  |  |  |  |  |  |  | ncbDiscPer | 1 |  | ncbDiscPer | 1 |  | totalMvAmt | 1 |  |
| 54.55 | NCB Discount Amount | ncbDiscAmt | NCB_Discount_Amount__c | Old_NCB_Discount_Amount__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดประวัติดี |  |  |  |  |  |  |  | ncbDiscAmt | 1 |  | ncbDiscAmt | 1 |  | fleetDiscPer | 1 |  |
| 54.56 | Other Discount Percent | otherDiscPer | Other_Discount_Percent__c | Old_Other_Discount_Percent__c | Number (6,4) |  |  | % ส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |  |  |  |  |  |  |  | otherDiscPer | 1 |  | otherDiscPer | 1 |  | fleetDiscAmt | 1 |  |
| 54.57 | Other Discount Amount | otherDiscAmt | Other_Discount_Amount__c | Old_Other_Discount_Amount__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |  |  |  |  |  |  |  | otherDiscAmt | 1 |  | otherDiscAmt | 1 |  | ncbDiscPer | 1 |  |
| 54.58 | Total Discount Amount | totalDiscAmt | Total_Discount_Amount__c | Feet+NCB+Other |  |  |  |  |  |  |  |  |  |  |  | totalDiscAmt | 1 |  | totalDiscAmt | 1 |  | ncbDiscAmt | 1 |  |
| 54.59 | Extend Enddate | extendEnddate | Extend_Enddate__c | Old_Extend_Enddate__c | Datetime |  |  | ขยายวันคุ้มครองสิ้นสุด (Default 16.30) |  |  |  |  |  |  |  | extendEnddate | 1 |  | extendEnddate | 1 |  | otherDiscPer | 1 |  |
| 54.60 | Extend day count | extendDayCount | Extend_Day__c | คำนวณจากข้อมูล Policy | Integer |  |  | จำนวนวันขยายวันคุ้มครองสิ้นสุด (คิดจากวันที่ซื้อ) |  |  |  |  |  |  |  | extendDayCount | 1 |  | extendDayCount | 1 |  | otherDiscAmt | 1 |  |
| 54.61 | Extend Date Premium Amount | extendPremAmt | Extend_Date_Premium_Amount__c | Old__Extend_Date_Premium_Amount__c | Currency(16, 2) |  |  | เบี้ยประกันขยายวันคุ้มครองสิ้นสุด |  |  |  |  |  |  |  | extendPremAmt | 1 |  | extendPremAmt | 1 |  | totalDiscAmt | 1 |  |
| 54.62 | Net Premium Amount (exclude duty & vat) | premAmt | Net_Premium_Amount__c | totalMvAmt + totalExMvAmt + premiumV5Od - totalDiscAmt + extendPremAmt | Currency(16, 2) |  |  | เบี้ยประกันสุทธิก่อนอากรและ Vat |  |  |  |  |  |  |  | premAmt | 1 |  | premAmt | 1 |  | extendEnddate | 1 |  |
| 54.63 | Duty Amount | dutyAmt | Duty_Amount__c | Old_Duty_Amount__c | Currency(16, 2) |  |  | ค่าอากรแสตมป์ |  |  |  |  |  |  |  | dutyAmt | 1 |  | dutyAmt | 1 |  | extendDayCount | 1 |  |
| 54.64 | Vat Percent | vatPer | Vat_Percent__c | vatAmt / (premAmt + dutyAmt) * 100 | Number (6,4) |  |  | % Vat |  |  |  |  |  |  |  | vatPer | 1 |  | vatPer | 1 |  | extendPremAmt | 1 |  |
| 54.65 | Vat Amount | vatAmt | Vat_Amount__c | Old_Vat_Amount__c | Currency(16, 2) |  |  | จำนวนเงิน Vat |  |  |  |  |  |  |  | vatAmt | 1 |  | vatAmt | 1 |  | premAmt | 1 |  |
| 54.66 | Total Amount (include duty & vat) | totalAmt | Total_Amount__c | premAmt + dutyAmt + vatAmt | Currency(16, 2) |  |  | เบี้ยประกันที่ต้องชำระ |  |  |  |  |  |  |  | totalAmt | 1 |  | totalAmt | 1 |  | dutyAmt | 1 |  |
| 40.64 | Compulsory Policy Net Premium Amount (exclude duty & vat) | actPremAmt |  |  | Currency(16, 2) |  |  | พรบ เบี้ยประกันสุทธิก่อนอากรและ Vat |  |  |  |  |  |  |  |  |  |  |  |  |  | vatPer | 1 |  |
| 40.65 | Compulsory Policy Duty Amount | actDutyAmt |  |  | Currency(16, 2) |  |  | พรบ ค่าอากรแสตมป์ |  |  |  |  |  |  |  |  |  |  |  |  |  | vatAmt | 1 |  |
| 40.66 | Compulsory Policy Vat Percent | actVatPer |  |  | Number (6,4) |  |  | พรบ % Vat |  |  |  |  |  |  |  |  |  |  |  |  |  | totalAmt | 1 |  |
| 40.67 | Compulsory Policy Vat Amount | actVatAmt |  |  | Currency(16, 2) |  |  | พรบ จำนวนเงิน Vat |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorSummary | 0 |  |
| 40.68 | Compulsory Policy Total Amount (include duty & vat) | actTotalAmt |  |  | Currency(16, 2) |  |  | พรบ เบี้ยประกันที่ต้องชำระ |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorTariff | 0 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 113 |  | 120 |  |  | 120 |  | vatPer | 1 |  |

### Example / Code Payload (Row 139)
**Example Request**
```json
{
  "fn": "PolicyTransacti",
  "insurancePolicyId": "MV-0023-I-000011",
  "salesforceID": "MVE123456789",
  "type": ["ownerFirstName", "ownerDistrictId"],
  "ownerPrefixName": "นาย",
  "ownerFirstName": "สโมสร",
  "ownerLastName": "ธรรม์รงนาน",
  "ownerAddress": "123 ถนนสีแดง",
  "ownerProvinceId": "1",
  "ownerSubdistrictId": "8919",
  "ownerDistrictId": "26",
  "ownerZipcode": "10400",
  "ownerBirthdate": "1990-01-15",
  "ownerCardId": "1234567890123",
  "carColor": "CL007",
  "carLicenseType": "ป้ายแดง",
  "carLicenseNo": "นบ2511",
  "carLicenseProvice": "1",
  "carSerialNo": "BBDG36464622234",
  "startDate": "2023-09-09 17:01:00",
  "endDate": "2024-09-10 11:30:00",
  "apprStatus": "Approved",
  "apprPrefixName": "",
  "apprFirstName": "Approver",
  "apprLastName": "",
  "apprComment": "",
  "effectiveDate": "2023-09-01 12:00:00",
  "deliAddress": "123 ถนนสีแดง",
  "deliProvinceId": "1",
  "deliSubdistrictId": "8919",
  "deliDistrictId": "26",
  "deliZipcode": "10400",
  "beneType": "financial",
  "beneFirstname": "สโมสร",
  "beneLastname": "ธรรม์รงนาน",
  "driveAction": "Edit",
  "par1Prefix": "นาย",
  "par1Firstname": "สโมสร",
  "par1Lastname": "ธรรม์รงนาน",
  "par1DriverNo": "6771232436",
  "par2Prefix": "นางสาว",
  "par2Firstname": "มณี",
  "par2Lastname": "ธรรม์รงนาน",
  "par2DriverNo": "4737234534",
  "coverageDetail": {
    "fieldName": ["extendEnddate"],
    "policyType": "1",
    "coverageDayCount": 65,
    "carBrand": "Toyota",
    "carModel": "Camry",
    "garageType": "G",
    "basicPremAmt": 8800.00,
    "basicPremV5Amt": 8800.00,
    "usage": 110,
    "usageTariff": 112,
    "carCc": "1865",
    "carCcCondition": "<=2000",
    "carCcTariff": 112,
    "driverBrithdate1": "1985-03-20",
    "driverBrithdate2": "1992-08-10",
    "driverAge": "25-35",
    "driverAgeDisc": 1000.00,
    "driverAgeTariff": 85,
    "carYear": "2020",
    "carYearTariff": 102,
    "siAmt": 710000.00,
    "odAmt": 10000.00,
    "ftAmt": 5000.00,
    "accessHave": true,
    "accessSiAmt": 20000.00,
    "accessPremAmt": 100.00,
    "accessName": ["wheel", "pipe"],
    "siTariff": 168,
    "siV5Tariff": 137.41,
    "carGroup": "3",
    "carGroupTariff": 110,
    "tpbiPassSiAmt": 500000.00,
    "tpbiPassPremAmt": 200.00,
    "tpbiPassTariff": 100,
    "tpbiEventSiAmt": 10000000.00,
    "tpbiEventPremAmt": 0.00,
    "tpbiEventTariff": 100,
    "tppdSiAmt": 2500000.00,
    "tppdPremAmt": 200.00,
    "tppdTariff": 107,
    "totalExMvAmt": 15500.00,
    "mv01SiAmt": 10000.00,
    "mv01PremAmt": 100.00,
    "mv02SiAmt": 10000.00,
    "mv02PremAmt": 100.00,
    "mv03SiAmt": 10000.00,
    "mv03PremAmt": 100.00,
    "cctvHave": true,
    "cctvPercent": 5,
    "totalMvAmt": 300.00,
    "fleetDiscPer": 0.00,
    "fleetDiscAmt": 0.00,
    "ncbDiscPer": 50.00,
    "ncbDiscAmt": 7000.00,
    "otherDiscPer": 20,
    "otherDiscAmt": 2000.00,
    "totalDiscAmt": 9000.00,
    "extendEnddate": "2024-09-01T12:00:00Z",
    "extendDayCount": 30,
    "extendPremAmt": 1250.00,
    "premAmt": 6500.00,
    "dutyAmt": 26.00,
    "vatPer": 7.00,
    "vatAmt": 455.18,
    "totalAmt": 6977.78
  }
}
```
**vatAmt**
**1**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 | Col20 | Col21 | Col22 | totalAmt | 1 | Col25 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| No | Insert Policy Transaction |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorSummary | 0 | ใหม่ |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field |  | Type | External Key | Required Field |  |  | Remark |  | GCP Table | GCP Field | GCP Remark |  |  |  |  |  |  |  | driverBehaviorTariff | 0 | ใหม่ |
| 1 | Response title | title |  |  | Text(50) |  | Y |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorDisc | 0 | ใหม่ |
| 2 | Status code | status |  |  | Int |  | Y |  |  |  |  |  |  |  |  |  |  |  |  |  |  | actPremAmt | 0 | ไม่ใช้ |
| 3 | Description | description |  |  | Text(500) |  | Y |  |  |  |  |  |  |  |  |  |  |  |  |  |  | actDutyAmt | 0 | ไม่ใช้ |
| 4 | Result | result |  |  | Object |  | Y |  |  |  |  |  |  |  |  |  |  |  |  |  |  | actVatPer | 0 | ไม่ใช้ |
| 4.1 | Policy Number | insurancePolicyId |  |  | Text(255) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | actVatAmt | 0 | ไม่ใช้ |
| 4.2 | Transaction Number | transactionNumber | External_ID__c |  | Text(255) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | actTotalAmt | 0 | ไม่ใช้ |
| 4.3 | Document Type | endorseDocType | Document_Type__c |  | Text(255) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3Prefix | 0 | ใหม่ |
| 4.4 | Document Name | endorseDocName | Document_Name__c |  | Text(255) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3Firstname | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3Lastname | 0 | ใหม่ |

### Example / Code Payload (Row 152)
**Example Response
(Success)**
```json
{
    "title": "Success",
    "status": 200,
    "description": "",
    "result": {
  "fn": "PolicyTransacti",
  "insurancePolicyId": "MV-0023-I-000011",
  "salesforceID": "MVE123456789",
  "type": ["ownerFirstName", "ownerDistrictId"],
  "ownerPrefixName": "Mr.",
  "ownerFirstName": "John",
  "ownerLastName": "Doe",
  "ownerAddress": "123 Main Street",
  "ownerProvinceId": "12345",
  "ownerSubdistrictId": "67890",
  "ownerDistrictId": "District1",
  "ownerZipcode": "12345",
  "ownerBirthdate": "1990-01-15",
  "ownerCardId": "1234567890123",
  "carColor": "Blue",
  "carLicenseType": "Private",
  "carLicenseNo": "ABC123",
  "carLicenseProvice": "Province1",
  "carSerialNo": "Serial123",
  "startDate": "2023-09-01T12:00:00Z",
  "endDate": "2024-09-01T12:00:00Z",
  "apprStatus": "Approved",
  "apprPrefixName": "Mr.",
  "apprFirstName": "James",
  "apprLastName": "Smith",
  "apprComment": "Approved without issues",
  "effectiveDate": "2023-09-01T12:00:00Z",
  "deliAddress": "456 Elm Street",
  "deliProvinceId": "67890",
  "deliSubdistrictId": "12345",
  "deliDistrictId": "District2",
  "deliZipcode": "67890",
  "beneType": "BeneficiaryType1",
  "beneFirstname": "Alice",
  "beneLastname": "Johnson",
  "driveAction": "DriveActionType1",
  "par1Prefix": "Mr.",
  "par1Firstname": "Robert",
  "par1Lastname": "Wilson",
  "par1DriverNo": "Driver123",
  "par2Prefix": "Ms.",
  "par2Firstname": "Emily",
  "par2Lastname": "Davis",
  "par2DriverNo": "Driver456",
  "coverageDetail": {
    "fieldName": ["carCc", "driverAge"],
    "policyType": "Type1",
    "coverageDayCount": 365,
    "carBrand": "Toyota",
    "carModel": "Camry",
    "garageType": "GT",
    "basicPremAmt": 5000.00,
    "basicPremV5Amt": 5500.00,
    "usage": 2,
    "usageTariff": 5.25,
    "carCc": "2000cc",
    "carCcCondition": "Excellent",
    "carCcTariff": 4.75,
    "driverBrithdate1": "1985-03-20",
    "driverBrithdate2": "1992-08-10",
    "driverAge": "25-60",
    "driverAgeDisc": 1000.00,
    "driverAgeTariff": 7.25,
    "carYear": "2020",
    "carYearTariff": 6.50,
    "siAmt": 25000.00,
    "odAmt": 10000.00,
    "ftAmt": 5000.00,
    "accessHave": true,
    "accessSiAmt": 1500.00,
    "accessPremAmt": 750.00,
    "accessName": ["Access1", "Access2"],
    "siTariff": 5.75,
    "siV5Tariff": 6.00,
    "carGroup": "Group1",
    "carGroupTariff": 6.25,
    "tpbiPassSiAmt": 5000.00,
    "tpbiPassPremAmt": 2000.00,
    "tpbiPassTariff": 4.25,
    "tpbiEventSiAmt": 7500.00,
    "tpbiEventPremAmt": 3000.00,
    "tpbiEventTariff": 4.50,
    "tppdSiAmt": 10000.00,
    "tppdPremAmt": 4000.00,
    "tppdTariff": 4.75,
    "totalExMvAmt": 30000.00,
    "mv01SiAmt": 10000.00,
    "mv01PremAmt": 4000.00,
    "mv02SiAmt": 7500.00,
    "mv02PremAmt": 3000.00,
    "mv03SiAmt": 5000.00,
    "mv03PremAmt": 2000.00,
    "cctvHave": true,
    "cctvPercent": 2.50,
    "totalMvAmt": 35000.00,
    "fleetDiscPer": 3.00,
    "fleetDiscAmt": 1050.00,
    "ncbDiscPer": 10.00,
    "ncbDiscAmt": 3500.00,
    "otherDiscPer": 2.50,
    "otherDiscAmt": 875.00,
    "totalDiscAmt": 5425.00,
    "extendEnddate": "2024-09-01T12:00:00Z",
    "extendDayCount": 30,
    "extendPremAmt": 125.00,
    "premAmt": 10000.00,
    "dutyAmt": 500.00,
    "vatPer": 7.00,
    "vatAmt": 700.00,
    "totalAmt": 11025.00
  }
}

}
```
**par3DriverNo**
**0**
**ใหม่**

### Example / Code Payload (Row 153)
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
**par3CitizenId**
**0**
**ใหม่**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 | Col20 | Col21 | Col22 | par4Prefix | 0 | ใหม่ |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4Firstname | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4Lastname | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4DriverNo | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4CitizenId | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5Prefix | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5Firstname | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5Lastname | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5DriverNo | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5CitizenId | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | scPremiumAmt | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | garageType | 1 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | packageId | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1Occupation | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par2Occupation | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1Occupation | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par2Occupation | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1Occupation | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ownerOccupation | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1OccupationPWA | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1OccupationTQM | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par2OccupationPWA | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par2OccupationTQM | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3OccupationPWA | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3OccupationTQM | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4OccupationPWA | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4OccupationTQM | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5OccupationPWA | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5OccupationTQM | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ownerOccupationPWA | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ownerOccupationTQM | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior1 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior2 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior3 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior4 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior5 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent1 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent2 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent3 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent4 | 0 | ใหม่ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent5 | 0 | ใหม่ |
