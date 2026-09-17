# [15] SF-PolicyTransaction

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-PolicyTransaction`
- **Total Rows Parsed**: `174`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpolicytransaction`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertpolicytransaction |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 | Col20 | Col21 | Col22 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | SF Field (old) | Type | External Key | Required Field | SF Field Label | SF Field Label (old) | Remark |  |  |  |  |  | 5.0 |  | AI |  | CR21 |  |
| 1 | Transaction ID | transactionID | Id |  | Text(18) | Y |  |  |  | Using for Update Endorsement |  |  |  |  |  | transactionID | 1 | transactionID | 1 | transactionID | 1 |
| 2 | Policy Number | insurancePolicyId | Policy_Number__c |  | Text(255) | Y | Y |  |  | เลขที่ของ  Policy Id  กรณี Transaction GCP x10 เก็บข้อมูลการสลักหลังในรูปแบบ History จะไม่ทำการแก้ไข Transaction ที่เคยเกิดขึ้นไปแล้ว |  | Policy_Header | Policy_No |  |  | insurancePolicyId | 1 | insurancePolicyId | 1 | insurancePolicyId | 1 |
| 3 | Status | status |  |  | Picklist |  | Y |  |  | New = รายการเปิดสลักหลัง รออัพเดตเอกสาร Submit = เอกสารครบ พร้อมนำไปให้เจ้าหน้าที่ตรวจสอบ |  |  |  |  |  | status | 1 | status | 1 | status | 1 |
| 4 | Type | type | Type |  | Array[Picklist] |  | Y |  |  | ระบุ Field ที่ต้องการแก้ไข เช่น  cancellation = กรณียกเลิกกรมธรรม์ ownerPrefixName ownerDistrictId เป็นต้น |  | Policy_Header | SF_Endorse_type |  |  | type | 1 | type | 1 | type | 1 |
| 5 | Owner Prefix | ownerPrefixName | Owner_Prefix_Id__c | Old_Owner_Prefix_Id__c | Text(50) |  |  | คำนำหน้า | คำนำหน้า (ค่าเดิม) | รย 23 คำนำหน้าชื่อผู้เอาประกัน |  | Policy_Header | Owner_prefix_name |  |  | ownerPrefixName | 1 | ownerPrefixName | 1 | ownerPrefixName | 1 |
| 6 | Owner Firstname | ownerFirstName | Owner_First_Name__c | Old_Owner_First_Name__c | Text(255) |  |  | ชื่อ | ชื่อ (ค่าเดิม) | รย 23 ชื่อผู้เอาประกัน |  | Policy_Header | Owner_first_name |  |  | ownerFirstName | 1 | ownerFirstName | 1 | ownerFirstName | 1 |
| 7 | Owner Lastname | ownerLastName | Owner_Last_Name__c | Old_Owner_Last_Name__c | Text(255) |  |  | นามสกุล | นามสกุล (ค่าเดิม) | รย 23 นามสกุลผู้เอาประกัน |  | Policy_Header | Owner_last_name |  |  | ownerLastName | 1 | ownerLastName | 1 | ownerLastName | 1 |
| 8 | Owner Address | ownerAddress | Owner_Address_No__c | Old_Owner_Address_No__c | Text(500) |  |  | บ้านเลขที่ | บ้านเลขที่ (ค่าเดิม) | รย 23 ที่อยู่ ผู้เอาประกัน |  | Policy_Header | Owner_address |  |  | ownerAddress | 1 | ownerAddress | 1 | ownerAddress | 1 |
| 9 | Owner Province | ownerProvince | Owner_Province__c | Old_Owner_Province__c | Text(255) |  |  | จังหวัด |  | รย 23 |  |  |  |  |  | ownerProvince | 1 | ownerProvince | 1 | ownerProvince | 1 |
| 10 | Owner Province ID | ownerProvinceId | Owner_Province_Id__c | Old_Owner_Province_Id__c | Text(255) |  |  | รหัสจังหวัด | รหัสจังหวัด (ค่าเดิม) | รย 23 รหัสจังหวัด ผู้เอาประกัน |  | Policy_Header | Owner_province_id |  |  | ownerProvinceId | 1 | ownerProvinceId | 1 | ownerProvinceId | 1 |
| 11 | Owner Subdistrict | ownerSubdistrict | Owner_Subdistrict__c | Old_Owner_Subdistrict__c | Text(255) |  |  | แขวง/ตำบล |  | รย 23 |  |  |  |  |  | ownerSubdistrict | 1 | ownerSubdistrict | 1 | ownerSubdistrict | 1 |
| 12 | Owner_subdistrict_id | ownerSubdistrictId | Owner_Subdistrict_Id__c | Old_Owner_Subdistrict_Id__c | Text(255) |  |  | รหัสแขวง/ตำบล | รหัสแขวง/ตำบล (ค่าเดิม) | รย 23 รหัสแขวง/ตำบล ผู้เอาประกัน |  | Policy_Header | Owner_subdistrict_id |  |  | ownerSubdistrictId | 1 | ownerSubdistrictId | 1 | ownerSubdistrictId | 1 |
| 13 | Owner District | ownerDistrict | Owner_District__c | Old_Owner_District_Id__c | Text(255) |  |  | เขต/อำเภอ |  | รย 23 |  |  |  |  |  | ownerDistrict | 1 | ownerDistrict | 1 | ownerDistrict | 1 |
| 14 | Owner_district_id | ownerDistrictId | Owner_District_Id__c | Old_Owner_District_Id__c | Text(255) |  |  | รหัสเขต/อำเภอ | รหัสเขต/อำเภอ (ค่าเดิม) | รย 23 รหัสเขต/อำเภอ ผู้เอาประกัน |  | Policy_Header | Owner_district_id |  |  | ownerDistrictId | 1 | ownerDistrictId | 1 | ownerDistrictId | 1 |
| 15 | Owner_zipcode | ownerZipcode | Owner_Zipcode__c | Old_Owner_Zipcode__c | Text(10) |  |  | รหัสไปรษณีย์ | รหัสไปรษณีย์ (ค่าเดิม) | รย 23 รหัสไปรษณีย์ ผู้เอาประกัน (5 หลัก) |  | Policy_Header | Owner_zipcode |  |  | ownerZipcode | 1 | ownerZipcode | 1 | ownerZipcode | 1 |
| 16 | Car Color | carColor | Car_Color__c | Old_Car_Color__c | Text(255) |  |  | สีรถ |  | รย 17  (SF-PolicyAttachment (URL) เอกสารสำเนาทะเบียนรถ) |  |  |  |  |  | carColor | 1 | carColor | 1 | carColor | 1 |
| 17 | Car Color ID | carColorID | Car_Color_ID__c |  | Text(255) |  |  | รหัสสีรถ |  | รย 17  (SF-PolicyAttachment (URL) เอกสารสำเนาทะเบียนรถ) |  |  |  |  |  | carColorID | 1 | carColorID | 1 | carColorID | 1 |
| 18 | Car_license no | carLicenseNo | Car_License_No__c | Old_Car_License_No__c | Text(10) |  |  | ป้ายเลขทะเบียนรถ | ป้ายเลขทะเบียนรถ (ค่าเดิม) | รย 17 ป้ายเลขทะเบียน (SF-PolicyAttachment (URL) เอกสารสำเนาทะเบียนรถ) |  | Policy_Header | Car_license_no |  |  | carLicenseNo | 1 | carLicenseNo | 1 | carLicenseNo | 1 |
| 19 | Car license provice | carLicenseProvice | Car_License_Provice__c | Old_Car_License_Provice__c | Text(255) |  |  | รหัสจังหวัดที่จดทะเบียนรถ | จังหวัดที่จดทะเบียนรถ (ค่าเดิม) | รย 17 จังหวัด ที่จด (SF-PolicyAttachment (URL) เอกสารสำเนาทะเบียนรถ) R1 ส่งมาเป็นรหัสทะเบียนรถ |  | Policy_Header | Car_license_provice |  |  | carLicenseProvice | 1 | carLicenseProvice | 1 | carLicenseProvice | 1 |
| 20 | Car serial no | carSerialNo | Car_Serial_No__c | Old_Car_Serial_No__c | Text(255) |  |  | ตัวถังรถ | ตัวถังรถ (ค่าเดิม) | รย 17 ตัวถังรถ (SF-PolicyAttachment (URL) เอกสารสำเนาทะเบียนรถ) |  | Policy_Header | Car_serial_no |  |  | carSerialNo | 1 | carSerialNo | 1 | carSerialNo | 1 |
| 21 | Policy Startdate | startDate | Policy_Startdate__c | Old_Policy_Startdate__c | Datetime |  |  | วันเริ่มต้นคุ้มครอง | วันเริ่มต้นคุ้มครอง (ค่าเดิม) | รย 19 วันเริ่มต้นคุ้มครอง 90วันนับจากวันชำระเงิน กรณีวันปัจจุบัน now() ล่วงหน้าเวลาเป็น 00:01 Fix **ยังไม่เริ่มคุ้มครองเท่านั้น ถึงจะแก้ไขวันเริ่มคุ้มครองใหม่ได้ |  | Policy_Header | Policy_Startdate |  |  | startDate | 1 | startDate | 1 | startDate | 1 |
| 22 | Policy Enddate | endDate | Policy_Etartdate__c | Old_Policy_Etartdate__c | Datetime |  |  | วันสิ้นสุดคุ้มครอง | วันสิ้นสุดคุ้มครอง (ค่าเดิม) | รย 19 วันสิ้นสุดคุ้มครอง เวลาต้องเป็น 16:30 Fix **ยังไม่เริ่มคุ้มครองเท่านั้น ถึงจะแก้ไขวันเริ่มคุ้มครองใหม่ได้ |  | Policy_Header | Policy_Enddate |  |  | endDate | 1 | endDate | 1 | endDate | 1 |
| 23 | effective_date | effectiveDate | Endors_Datetime__c |  | Datetime |  | Y | วันที่มีผลบังคับใช้ |  | กรอกเพิ่มเติมสำหรับ PWA เป็นเวลาปัจจุบัน UTC+0 |  | Policy_Header | Effective_Startdate |  |  | effectiveDate | 1 | effectiveDate | 1 | effectiveDate | 1 |
| 24 | Source | source | Source__c |  | Picklist |  | Y | ช่องทางในการแจ้ง |  | PWA Mobile |  |  |  |  |  | source | 1 | source | 1 | source | 1 |
| 25 | Deli_Flag | deliFlag | Delivery_Flag__c |  | Text(1) |  |  | Y = จัดส่งรูปเล่มกรมธรรม์, N = ไม่จัดส่งรูปเล่มกรมธรรม์ |  |  |  |  |  |  |  | deliFlag | 1 | deliFlag | 1 | deliFlag | 1 |
| 26 | Delivery address | deliAddress | Delivery_Address__c | Old_Delivery_Address__c | Text(500) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliAddress | 1 | deliAddress | 1 | deliAddress | 1 |
| 27 | Delivery Province | deliProvince | Delivery_Province__c | Old_Delivery_Province__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliProvince | 1 | deliProvince | 1 | deliProvince | 1 |
| 28 | Delivery province_id | deliProvinceId | Delivery_Province_ID__c | Old_Delivery_Province_ID__c | Text(255) |  |  | รหัสที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliProvinceId | 1 | deliProvinceId | 1 | deliProvinceId | 1 |
| 29 | Delivery Subdistrict | deliSubdistrict | Delivery_Subdistrict__c | Old_Delivery_Subdistrict__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliSubdistrict | 1 | deliSubdistrict | 1 | deliSubdistrict | 1 |
| 30 | Delivery_subdistrict_id | deliSubdistrictId | Delivery_Subdistrict_ID__c | Old_Delivery_Subdistrict_ID__c | Text(255) |  |  | รหัสที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliSubdistrictId | 1 | deliSubdistrictId | 1 | deliSubdistrictId | 1 |
| 31 | Delivery District | deliDistrict | Delivery_District__c | Old_Delivery_District__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliDistrict | 1 | deliDistrict | 1 | deliDistrict | 1 |
| 32 | Delivery_district_id | deliDistrictId | Delivery_District_ID__c | Old_Delivery_District_ID__c | Text(255) |  |  | รหัสที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliDistrictId | 1 | deliDistrictId | 1 | deliDistrictId | 1 |
| 33 | Delivery_zipcode | deliZipcode | Delivery_Zipcode__c | Old_Delivery_Zipcode__c | Text(255) |  |  | ที่อยู่จัดส่งเอกสาร |  |  |  |  |  |  |  | deliZipcode | 1 | deliZipcode | 1 | deliZipcode | 1 |
| 34 | Owner Birthdate | ownerBirthdate | Owner_Birthdate__c | Old_Owner_Birthdate__c | Date |  |  | วันเดือนปีเกิด |  |  |  |  |  |  |  | ownerBirthdate | 1 | ownerBirthdate | 1 | ownerBirthdate | 1 |
| 35 | Owner Id Card | ownerCardId | Owner_ID_Card__c | Old_Owner_ID_Card__c | Text(13) |  |  | เลขบัตรประชาชน |  |  |  |  |  |  |  | ownerCardId | 1 | ownerCardId | 1 | ownerCardId | 1 |
| 36 | Car Color ID | carColorID | Car_Color_ID__c |  | Text(255) |  |  | รหัสสีรถ |  |  |  |  |  |  |  | carColorID | 1 | carColorID | 1 | carColorID | 1 |
| 37 | Car Color | carColor | Car_Color__c | Old_Car_Color__c | Text(255) |  |  | สีรถ |  |  |  |  |  |  |  | carColor | 1 | carColor | 1 | carColor | 1 |
| 38 | Car License Type Code | carLicenseTypeCode | Car_License_Type_Code__c |  | Text(255) |  |  | รหัสประเภททะเบียนรถ |  | license = ป้ายขาว, license_red = ป้ายแดง |  |  |  |  |  | carLicenseTypeCode | 1 | carLicenseTypeCode | 1 | carLicenseTypeCode | 1 |
| 39 | Car License Type | carLicenseType | Car_License_Type__c | Old_Car_License_Type__c | Picklist |  |  | ประเภททะเบียนรถ |  |  |  |  |  |  |  | carLicenseType | 1 | carLicenseType | 1 | carLicenseType | 1 |
| 40 | Beneficiary Type Code | beneTypeCode | Beneficiary_Type_Code__c |  | Text(255) |  |  | รหัสประเภทผู้รับผลประโยชน์ |  | financial, person |  |  |  |  |  | beneTypeCode | 1 | beneTypeCode | 1 | beneTypeCode | 1 |
| 41 | Beneficiary Type | beneType | Beneficiary_Type__c | Old_Beneficiary_Type__c | Picklist |  |  | ประเภทผู้รับผลประโยชน์ |  | สถาบันการเงิน, บุคคล |  |  |  |  |  | beneType | 1 | beneType | 1 | beneType | 1 |
| 42 | Benificiary Title Name | beneTitle | Beneficiary_Title__c | Old_Beneficiary_Title__c | Text(50) |  |  | คำนำหน้าผู้รับผลประโยชน์ |  |  |  |  |  |  |  | beneTitle | 1 | beneTitle | 1 | beneTitle | 1 |
| 43 | Benificiary First Name | beneFirstname | Beneficiary_Firstname__c | Old_Beneficiary_Firstname__c | Text(255) |  |  | ชื่อผู้รับผลประโยชน์ |  |  |  |  |  |  |  | beneFirstname | 1 | beneFirstname | 1 | beneFirstname | 1 |
| 44 | Benificiary Last Name | beneLastname | Beneficiary_Lastname__c | Old_Beneficiary_Lastname__c | Text(255) |  |  | นามสกุลผู้รับผลประโยชน์ |  |  |  |  |  |  |  | beneLastname | 1 | beneLastname | 1 | beneLastname | 1 |
| 45 | Driver Action | driveAction |  | ได้จากการเลือก รย | Picklist |  |  | Add = รย26 / Edit = รย28 / Delete = รย27 หมายเหตุ ส่งทุกครั้งถ้ามี รย 26 27 28 |  |  |  |  |  |  |  | driveAction | 1 | driveAction | 1 | driveAction | 1 |
| 46 | Driver Prefix Code 1 | par1PrefixCode | Driver_1_Prefix_Code__c |  | Text(255) |  |  | รหัสคำนำหน้าผู้ขับขี่ 1 |  | mr = นาย ms = นางสาว mrs = นาง |  |  |  |  |  | par1PrefixCode | 1 | par1PrefixCode | 1 | par1PrefixCode | 1 |
| 47 | Driver Prefix 1 | par1Prefix | Driver_1_Prefix__c | Old_Driver_1_Prefix__c | Text(50) |  |  | คำนำหน้าผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1Prefix | 1 | par1Prefix | 1 | par1Prefix | 1 |
| 48 | Driver Firstname 1 | par1Firstname | Driver_1_Firstname__c | Old_Driver_1_Firstname__c | Text(255) |  |  | ชื่อผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1Firstname | 1 | par1Firstname | 1 | par1Firstname | 1 |
| 49 | Driver Lastname 1 | par1Lastname | Driver_1_Lastname__c | Old_Driver_1_Lastname__c | Text(255) |  |  | นามสกุลผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1Lastname | 1 | par1Lastname | 1 | par1Lastname | 1 |
| 50 | Driver License No 1 | par1DriverNo | Driver_1_License__c | Old_Driver_1_License__c | Text(255) |  |  | เลขที่ใบขับขี่ 1 |  |  |  |  |  |  |  | par1DriverNo | 1 | par1DriverNo | 1 | par1DriverNo | 1 |
| 51 | Driver Citizen ID 1 | par1CitizenId | Driver_1_ID__c | Old_Driver_1_ID__c | Text(20) |  |  | บัตรประชาชนผู้ขับขี่ 1 |  |  |  |  |  |  |  | par1CitizenId | 1 | par1CitizenId | 1 | par1CitizenId | 1 |
| 52 | Driver Prefix Code 2 | par2PrefixCode | Driver_2_Prefix_Code__c |  | Text(255) |  |  | รหัสคำนำหน้าผู้ขับขี่ 2 |  | mr = นาย ms = นางสาว mrs = นาง |  |  |  |  |  | par2PrefixCode | 1 | par2PrefixCode | 1 | par2PrefixCode | 1 |
| 53 | Driver Prefix 2 | par2Prefix | Driver_2_Prefix__c | Old_Driver_2_Prefix__c | Text(50) |  |  | คำนำหน้าผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2Prefix | 1 | par2Prefix | 1 | par2Prefix | 1 |
| 54 | Driver Firstname 2 | par2Firstname | Driver_2_Firstname__c | Old_Driver_2_Firstname__c | Text(255) |  |  | ชื่อผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2Firstname | 1 | par2Firstname | 1 | par2Firstname | 1 |
| 55 | Driver Lastname 2 | par2Lastname | Driver_2_Lastname__c | Old_Driver_2_Lastname__c | Text(255) |  |  | นามสกุลผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2Lastname | 1 | par2Lastname | 1 | par2Lastname | 1 |
| 56 | Driver License No 2 | par2DriverNo | Driver_2_License__c | Old_Driver_2_License__c | Text(255) |  |  | เลขที่ใบขับขี่ 2 |  |  |  |  |  |  |  | par2DriverNo | 1 | par2DriverNo | 1 | par2DriverNo | 1 |
| 57 | Driver Citizen ID 2 | par2CitizenId | Driver_2_ID__c | Old_Driver_2_ID__c | Text(20) |  |  | บัตรประชาชนผู้ขับขี่ 2 |  |  |  |  |  |  |  | par2CitizenId | 1 | par2CitizenId | 1 | par2CitizenId | 1 |
| 58 | Car Brand | carBrand | Car_Brand__c | Old_Car_Brand__c | Text(255) |  |  | ยี่ห้อรถ | ยี่ห้อรถ (ค่าเดิม) | รย 17 ยี่ห้อรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  |  |  |  |  | carBrand | 1 | carBrand | 1 | carBrand | 1 |
| 59 | Car Model | carModel | Car_Model__c | Old_Car_Model__c | Text(255) |  |  | รุ่นรถ | รุ่นรถ (ค่าเดิม) | รย 17 รุ่นรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  |  |  |  |  | carModel | 1 | carModel | 1 | carModel | 1 |
| 60 | Base Premium | basicPremAmt | Base_Premium__c | Old_Base_Premium__c | Currency(16, 2) |  |  | เบี้ยพื้นฐาน (ประกันกลุ่ม 1 ชั้น 1,3) |  |  |  |  |  |  |  | basicPremAmt | 1 | basicPremAmt | 1 | basicPremAmt | 1 |
| 61 | Base Premium v5 | basicPremV5Amt | Base_Premium_V5__c | Old_Base_Premium_V5__c | Currency(16, 2) |  |  | เบี้ยพื้นฐาน (ประกันกลุ่ม 5 ชั้น 2+,3+) |  |  |  |  |  |  |  | basicPremV5Amt | 1 | basicPremV5Amt | 1 | basicPremV5Amt | 1 |
| 62 | Usage | usage | Usage__c | From Select Car Model | Integer |  |  | การใช้รถ |  |  |  |  |  |  |  | usage | 1 | usage | 1 | usage | 1 |
| 63 | Usage Tariff | usageTariff | Usage_Tariff__c | From Select Car Model | Percent (6,4) |  |  | Tariff การใช้รถ |  |  |  |  |  |  |  | usageTariff | 1 | usageTariff | 1 | usageTariff | 1 |
| 64 | Car CC / Wg / Seat | carCc | Car_CC__c | Old_Car_CC__c | Text(255) |  |  | ซีซีรถ | ซีซีรถ (ค่าเดิม) | รย 17 ซีซีรถ กรณีไม่กระทบเบี้ย / กระทบเบี้ย รย 17 18 |  |  |  |  |  | carCc | 1 | carCc | 1 | carCc | 1 |
| 65 | Car CC Condition | carCcCondition | Car_CC_Condition__c | From Select Car CC | Text(255) |  |  | ช่วงซีซีกำหนดตาม Master Data |  |  |  |  |  |  |  | carCcCondition | 1 | carCcCondition | 1 | carCcCondition | 1 |
| 66 | Car CC Tariff | carCcTariff | Car_CC_Tariff__c | From Select Car CC | Percent (6,4) |  |  | Tariff ซีซีรถ |  |  |  |  |  |  |  | carCcTariff | 1 | carCcTariff | 1 | carCcTariff | 1 |
| 67 | Driver Birthdate 1 | driverBrithdate1 | Driver_1_Birthdate__c | Old_Driver_1_Birthdate__c | Date |  |  | วันเกิดผู้ขับขี่ 1 |  |  |  |  |  |  |  | driverBrithdate1 | 1 | driverBrithdate1 | 1 | driverBrithdate1 | 1 |
| 68 | Driver Birthdate 2 | driverBrithdate2 | Driver_2_Birthdate__c | Old_Driver_2_Birthdate__c | Date |  |  | วันเกิดผู้ขับขี่ 2 |  |  |  |  |  |  |  | driverBrithdate2 | 1 | driverBrithdate2 | 1 | driverBrithdate2 | 1 |
| 69 | Driver Age | driverAge | Driver_Age_Range__c | From Calculate Driver Age (ดูจากคนน้อยสุด) | Text(255) |  |  | ช่วงอายุผู้ขับขี่ |  |  |  |  |  |  |  | driverAge | 1 | driverAge | 1 | driverAge | 1 |
| 70 | Driver Age Discount | driverAgeDisc | Driver_Discount__c | Old_Driver_Discount__c | Currency(16, 2) |  |  | ส่วนลดผู้ขับขี่ |  |  |  |  |  |  |  | driverAgeDisc | 1 | driverAgeDisc | 1 | driverAgeDisc | 1 |
| 71 | Driver Age Tariff | driverAgeTariff | Driver_Age_Tariff__c | From Calculate Driver Age (ดูจากคนน้อยสุด) | Number (6,4) |  |  | Tariff อายุผู้ขับขี่ |  |  |  |  |  |  |  | driverAgeTariff | 1 | driverAgeTariff | 1 | driverAgeTariff | 1 |
| 72 | Car Year | carYear | Car_Year__c | Old_Car_Year__c | Text(4) |  |  | ปีที่จดทะเบียนรถ (ใน Bluebook) |  |  |  |  |  |  |  | carYear | 1 | carYear | 1 | carYear | 1 |
| 73 | Car Year Tariff | carYearTariff | Car_Year_Tariff__c | From Select Car Year | Percent (6,4) |  |  | Tariff ปีที่จดทะเบียนรถ (ใน Bluebook) |  |  |  |  |  |  |  | carYearTariff | 1 | carYearTariff | 1 | carYearTariff | 1 |
| 74 | SI Amount | siAmt | SI_Amount__c | Old_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน |  |  |  |  |  |  |  | siAmt | 1 | siAmt | 1 | siAmt | 1 |
| 75 | Have Accessory | accessHave | Have_Accessory__c | Old_Have_Accessory__c | Boolean |  |  | มีคุ้มครองอุปกรณ์ตบแต่ง |  |  |  |  |  |  |  | accessHave | 1 | accessHave | 1 | accessHave | 1 |
| 76 | Accessory SI Amount | accessSiAmt | Accessory_SI_Amount__c | Old_Accessory_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันอุปกรณ์ตบแต่ง |  |  |  |  |  |  |  | accessSiAmt | 1 | accessSiAmt | 1 | accessSiAmt | 1 |
| 77 | Accessory Name Code | accessNameCode | Accessory_Name_Code__c |  | Array(String) |  |  | รายการรหัสอุปกรณ์ตกแต่ง |  |  |  |  |  |  |  | accessNameCode | 1 | accessNameCode | 1 | accessNameCode | 1 |
| 78 | Accessory Name | accessName | Accessory_Name__c | Old_Accessory_Name__c | Array(String) |  |  | รายการอุปกรณ์ตกแต่ง |  |  |  |  |  |  |  | accessName | 1 | accessName | 1 | accessName | 1 |
| 79 | Car Group | carGroup | Car_Group__c | From Select Car Model | Text(255) |  |  | กลุ่มรถ |  |  |  |  |  |  |  | carGroup | 1 | carGroup | 1 | carGroup | 1 |
| 80 | Car Group Tariff | carGroupTariff | Car_Group_Tariff__c | From Select Car Model | Percent (6,4) |  |  | Tariff กลุ่มรถ |  |  |  |  |  |  |  | carGroupTariff | 1 | carGroupTariff | 1 | carGroupTariff | 1 |
| 81 | TPBI per passenger SI Amount | tpbiPassSiAmt | TPBI_SI_Amount__c | Old_TPBI_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันคุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/คน |  |  |  |  |  |  |  | tpbiPassSiAmt | 1 | tpbiPassSiAmt | 1 | tpbiPassSiAmt | 1 |
| 82 | TPBI per passenger Tariff | tpbiPassTariff | TPBI_Tariff__c | From Select TPBI SI | Percent (6,4) |  |  | Tariff คุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/คน |  |  |  |  |  |  |  | tpbiPassTariff | 1 | tpbiPassTariff | 1 | tpbiPassTariff | 1 |
| 83 | TPBI per event SI Amount | tpbiEventSiAmt | TPBI_Event_SI_Amount__c | Old_TPBI_Event_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันคุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tpbiEventSiAmt | 1 | tpbiEventSiAmt | 1 | tpbiEventSiAmt | 1 |
| 84 | TPBI per event Tariff | tpbiEventTariff | TPBI_Event_Tariff__c | From Select TPBI_E SI | Percent (6,4) |  |  | Tariff คุ้มครองชีวิต ร่างกาย และอนามัยของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tpbiEventTariff | 1 | tpbiEventTariff | 1 | tpbiEventTariff | 1 |
| 85 | TPPD SI Amount | tppdSiAmt | TPPD_SI_Amount__c | Old_TPPD_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกันคุ้มครองทรัพย์สินของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tppdSiAmt | 1 | tppdSiAmt | 1 | tppdSiAmt | 1 |
| 86 | TPPD Tariff | tppdTariff | TPPD_Tariff__c | From Select TPPD SI | Percent (6,4) |  |  | Tariff คุ้มครองทรัพย์สินของบุคคลภายนอก/ครั้ง |  |  |  |  |  |  |  | tppdTariff | 1 | tppdTariff | 1 | tppdTariff | 1 |
| 87 | Total exclude MV Amount | totalExMvAmt | Total_ex_MV_Amount__c | Old_Total_ex_MV_Amount__c | Currency(16, 2) |  |  | เบี้ยหลัก |  |  |  |  |  |  |  | totalExMvAmt | 1 | totalExMvAmt | 1 | totalExMvAmt | 1 |
| 88 | Premium V5 OD | premiumV5Od | Premium_V5_OD__c | Old_Premium_V5_OD__c | Currency(16, 2) |  |  | เบี้ยประกัน 2+3+ |  |  |  |  |  |  |  | premiumV5Od | 1 | premiumV5Od | 1 | premiumV5Od | 1 |
| 89 | MV01 SI Amount | mv01SiAmt | MV01_SI_Amount__c | Old_MV01_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv01SiAmt | 1 | mv01SiAmt | 1 | mv01SiAmt | 1 |
| 90 | MV01 Premium Amount | mv01PremAmt | MV01_Premium__c | Old_MV01_Premium__c | Currency(16, 2) |  |  | เบี้ยประกัน รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv01PremAmt | 1 | mv01PremAmt | 1 | mv01PremAmt | 1 |
| 91 | MV02 SI Amount | mv02SiAmt | MV02_SI_Amount__c | Old_MV02_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv02SiAmt | 1 | mv02SiAmt | 1 | mv02SiAmt | 1 |
| 92 | MV02 Premium Amount | mv02PremAmt | MV02_Premium__c | Old_MV02_Premium__c | Currency(16, 2) |  |  | เบี้ยประกัน รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv02PremAmt | 1 | mv02PremAmt | 1 | mv02PremAmt | 1 |
| 93 | MV03 SI Amount | mv03SiAmt | MV03_SI_Amount__c | Old_MV03_SI_Amount__c | Currency(16, 2) |  |  | ทุนประกัน รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv03SiAmt | 1 | mv03SiAmt | 1 | mv03SiAmt | 1 |
| 94 | MV03 Premium Amount | mv03PremAmt | MV03_Premium__c | Old_MV03_Premium__c | Currency(16, 2) |  |  | เบี้ยประกัน รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 |  |  |  |  |  |  |  | mv03PremAmt | 1 | mv03PremAmt | 1 | mv03PremAmt | 1 |
| 95 | Have Camera | cctvHave | Have_Camera__c | Old_Have_Camera__c | Boolean |  |  | มีกล้องติดรถ |  |  |  |  |  |  |  | cctvHave | 1 | cctvHave | 1 | cctvHave | 1 |
| 96 | Camera Discount Percent | cctvPercent | From Policy |  | Number (6,4) |  |  | ส่วนลดกล้องติดรถ (%) |  |  |  |  |  |  |  | cctvPercent | 1 | cctvPercent | 1 | cctvPercent | 1 |
| 97 | Fleet Discount Percent | fleetDiscPer | Fleet_Discount_Percent__c | Old_Fleet_Discount_Percent__c | Number (6,4) |  |  | % ส่วนลดกลุ่ม |  |  |  |  |  |  |  | fleetDiscPer | 1 | fleetDiscPer | 1 | fleetDiscPer | 1 |
| 98 | Fleet Discount Amount | fleetDiscAmt | Fleet_Discount_Amount__c | Old_Fleet_Discount_Amount__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดกลุ่ม |  |  |  |  |  |  |  | fleetDiscAmt | 1 | fleetDiscAmt | 1 | fleetDiscAmt | 1 |
| 99 | NCB Discount Percent | ncbDiscPer | NCB_Discount_Percent__c | Old_NCB_Discount_Percent__c | Number (6,4) |  |  | % ส่วนลดประวัติดี |  |  |  |  |  |  |  | ncbDiscPer | 1 | ncbDiscPer | 1 | ncbDiscPer | 1 |
| 100 | NCB Discount Amount | ncbDiscAmt | NCB_Discount_Amount__c | Old_NCB_Discount_Amount__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดประวัติดี |  |  |  |  |  |  |  | ncbDiscAmt | 1 | ncbDiscAmt | 1 | ncbDiscAmt | 1 |
| 101 | Other Discount Percent | otherDiscPer | Other_Discount_Percent__c | Old_Other_Discount_Percent__c | Number (6,4) |  |  | % ส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |  |  |  |  |  |  |  | otherDiscPer | 1 | otherDiscPer | 1 | otherDiscPer | 1 |
| 102 | Other Discount Amount | otherDiscAmt | Other_Discount_Amount__c | Old_Other_Discount_Amount__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |  |  |  |  |  |  |  | otherDiscAmt | 1 | otherDiscAmt | 1 | otherDiscAmt | 1 |
| 103 | Extend Enddate | extendEnddate | Extend_Enddate__c | Old_Extend_Enddate__c | Datetime |  |  | ขยายวันคุ้มครองสิ้นสุด (Default 16.30) |  |  |  |  |  |  |  | extendEnddate | 1 | extendEnddate | 1 | extendEnddate | 1 |
| 104 | Extend Date Premium Amount | extendPremAmt | Extend_Date_Premium_Amount__c | Old_Extend_Date_Premium_Amount__c | Currency(16, 2) |  |  | เบี้ยประกันขยายวันคุ้มครองสิ้นสุด |  |  |  |  |  |  |  | extendPremAmt | 1 | extendPremAmt | 1 | extendPremAmt | 1 |
| 105 | Duty Amount | dutyAmt | Duty_Amount__c | Old_Duty_Amount__c | Currency(16, 2) |  |  | ค่าอากรแสตมป์ |  |  |  |  |  |  |  | dutyAmt | 1 | dutyAmt | 1 | dutyAmt | 1 |
| 106 | Vat Amount | vatAmt | Vat_Amount__c | Old_Vat_Amount__c | Currency(16, 2) |  |  | จำนวนเงิน Vat |  |  |  |  |  |  |  | vatAmt | 1 | vatAmt | 1 | vatAmt | 1 |
| 107 | Cancellation Reason | cancelReason | Reason_For_Cancel__c |  | Text(2000) |  |  | เหตุผลการยกเลิก |  |  |  |  |  |  |  | cancelReason | 1 | cancelReason | 1 | cancelReason | 1 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | transactionNumber | 0 | par3PrefixCode | 0 |

### Example / Code Payload (Row 120)
**example**
```json
{
  "doc": null,
  "type": [
    "effectiveDate",
    "par1PrefixCode",
    "par1Prefix"
  ],
  "insurancePolicyId": "MV-0024-A-000055",
  "ownerPrefixName": null,
  "ownerFirstName": null,
  "ownerLastName": null,
  "ownerAddress": null,
  "ownerProvince": null,
  "ownerProvinceId": null,
  "ownerSubdistrict": null,
  "ownerSubdistrictId": null,
  "ownerDistrict": null,
  "ownerDistrictId": null,
  "ownerZipcode": null,
  "carColor": null,
  "carLicenseNo": null,
  "carLicenseProvice": null,
  "carSerialNo": null,
  "effectiveDate": "2024-02-09T17:01:00.000Z",
  "source": "PWA",
  "deliAddress": null,
  "deliProvinceId": null,
  "deliSubdistrictId": null,
  "deliDistrictId": null,
  "deliZipcode": null,
  "deliFlag": null,
  "status": "Submit",
  "carLicenseProvince": null,
  "ownerBirthdate": null,
  "ownerCardId": null,
  "carLicenseType": null,
  "beneType": null,
  "beneTitle": null,
  "beneFirstname": null,
  "beneLastname": null,
  "driveAction": "Edit",
  "par1Prefix": "นาย",
  "par1Firstname": "บุญยัง",
  "par1Lastname": "โลเปซ",
  "par1DriverNo": "22222222",
  "par1CitizenId": "1472715289655",
  "par2Prefix": null,
  "par2Firstname": null,
  "par2Lastname": null,
  "par2DriverNo": null,
  "par2CitizenId": null,
  "carBrand": "Toyota",
  "carModel": "Yaris",
  "basicPremAmt": 2533.34,
  "basicPremV5Amt": 0,
  "usage": 110,
  "usageTariff": 100,
  "carCc": null,
  "carCcCondition": null,
  "carCCTariff": null,
  "driverBrithdate1": "1990-01-02",
  "driverBrithdate2": null,
  "driverAge": "25-35",
  "driverAgeDisc": null,
  "driverAgeTariff": 90,
  "carYear": null,
  "carYearTariff": null,
  "siAmt": 0,
  "accessHave": null,
  "accessSIAmt": null,
  "accessName": null,
  "carGroup": "5",
  "carGroupTariff": 100,
  "tpbiPassSIAmt": 1000000,
  "tpbiPassTariff": 100,
  "tpbiEventSIAmt": 10000000,
  "tpbiEventTariff": 100,
  "tppdSIAmt": 2500000,
  "tppdTariff": 100,
  "totalExMvAmt": null,
  "mv01SIAmt": 200000,
  "mv01PremAmt": null,
  "mv02SIAmt": 200000,
  "mv02PremAmt": null,
  "mv03SIAmt": 300000,
  "mv03PremAmt": null,
  "cctvHave": null,
  "cctvPercent": 0,
  "fleetDiscPer": 0,
  "fleetDiscAmt": null,
  "ncbDiscPer": 40,
  "ncbDiscAmt": null,
  "otherDiscPer": 7,
  "otherDiscAmt": null,
  "extendEnddate": null,
  "extendPremAmt": null,
  "dutyAmt": null,
  "vatAmt": null,
  "premiumV5Od": null,
  "carLicenseProvinceId": null,
  "deliProvince": null,
  "deliSubdistrict": null,
  "deliDistrict": null,
  "carColorID": null,
  "carLicenseTypeCode": null,
  "beneTypeCode": null,
  "par1PrefixCode": "mr",
  "par2PrefixCode": null,
  "cancelReason": null
}
```
**endorseDocType**
**0**
**par3Prefix**
**0**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | endorseDocName | 0 | par3Firstname | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| No | Insert Policy Transaction |  |  |  |  |  |  |  |  |  |  |  |  |  | 107 |  | 107 |  | 107 | par3Lastname | 0 |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field |  | Type | External Key | Required Field |  |  | Remark |  | GCP Table | GCP Field | GCP Remark |  |  |  |  |  | par3DriverNo | 0 |
| 1 | Response title | title |  |  | Text(50) |  | Y |  |  |  |  |  |  |  |  |  |  |  |  | par3CitizenId | 0 |
| 2 | Status code | status |  |  | Int |  | Y |  |  |  |  |  |  |  |  |  |  |  |  | driverBirthdate3 | 0 |
| 3 | Description | description |  |  | Text(500) |  | Y |  |  |  |  |  |  |  |  |  |  |  |  | par4PrefixCode | 0 |
| 4 | Result | result |  |  | Object |  | Y |  |  |  |  |  |  |  |  |  |  |  |  | par4Prefix | 0 |
| 4.1 | Policy Number | insurancePolicyId |  |  | Text(255) | Y |  |  |  |  |  |  |  |  |  |  |  |  |  | par4Firstname | 0 |
| 4.2 | Endorsment SF ID | transactionID | ID |  | Text(18) | Y |  |  |  | x10 : salesforce_id |  |  |  |  |  |  |  |  |  | par4Lastname | 0 |
| 4.3 | Is Success | isSuccess |  |  | Boolean |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4DriverNo | 0 |
| 4.4 | Error Message | errorMessage |  |  | Text(255) |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4CitizenId | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBirthdate4 | 0 |

### Example / Code Payload (Row 133)
**Example Response
(Success)**
```json
{
  "timeStamp": "2024-01-10T05:01:23",
  "statusCode": "0000",
  "result": {
    "transactionID": "0k9O20000000OGrIAM",
    "isSuccess": true,
    "insurancePolicyId": "0YTO20000000DEzOAM",
    "errorMessage": null
  },
  "message": "Success"
}
```
**par5PrefixCode**
**0**

### Example / Code Payload (Row 134)
**Example Response
(Error)**
```json
{
  "timeStamp": "2023-09-14T07:52:30",
  "statusCode": "1000",
  "result": null,
  "message": "Some error Message"
}
```
**par5Prefix**
**0**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 | Col20 | par5Firstname | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5Lastname | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5DriverNo | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5CitizenId | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBirthdate5 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1OccupationPWA | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1OccupationTQM | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par2OccupationPWA | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par2OccupationTQM | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3OccupationPWA | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3OccupationTQM | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4OccupationPWA | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4OccupationTQM | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5OccupationPWA | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5OccupationTQM | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ownerOccupationPWA | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ownerOccupationTQM | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par1Occupation | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par2Occupation | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par3Occupation | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par4Occupation | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | par5Occupation | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ownerOccupation | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | packageId | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | scPremiumAmt | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | garageType | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior1 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior2 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior3 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior4 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior5 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent1 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent2 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent3 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent4 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverConsent5 | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorSummary | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorTariff | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorDisc | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 107 |
