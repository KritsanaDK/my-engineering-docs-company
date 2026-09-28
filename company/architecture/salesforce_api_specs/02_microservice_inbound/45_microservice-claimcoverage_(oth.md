# [45] Microservice-ClaimCoverage (Oth

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-ClaimCoverage (Oth`
- **Total Rows Parsed**: `217`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/upsertclaimcoverage`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/upsertclaimcoverage |
| --- | --- |

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
| 1 | Claim Number | claimId | ClaimId | Text(20) | Y | Y | เลขเคลม |  |  |  |  |
| 2 | Coverage Number | coverageID | CLAIMID__c | Text(20) | Y | Y | หมายเลข e-Claim |  |  |  |  |
| 3 | Policy Number | policyNumber |  | Text(20) |  |  | เลขกรมธรรม์ |  |  |  |  |
| 4 | Item No | itemNo |  | Integer |  |  | ลำดับที่ |  |  |  |  |
| 5 | Claim Coverage Type | claimCoverageType |  | Picklist |  |  | ประเภทของการเบิก (Loss Code Group) IV        Insure Vehicle TV        Third Party Vehicle TP        Third Party Property DV        Driver PN        Insured Passenger PR        Driver Related Passenger ON        Third Party Injury OR        Third Party Driver Related Injury |  |  |  |  |
|  | Claim Coverage Status | claimCoverageStatus |  | Picklist |  |  |  |  |  |  |  |
|  | EMCS Status | emcsStatus |  | Picklist |  |  |  |  |  |  |  |
|  | Status |  |  |  |  |  | Active/Delete |  |  |  |  |
| 6 | Losscode | losscode |  | Array |  |  | รายการ Losscode ที่ต้องการเบิก |  |  |  |  |
| 6.1 | Loss Type | lossType | Loss_Type__c | Picklist |  |  | Loss, Salvage, Deduct, Expense |  |  |  |  |
| 6.2 | Loss Code ID | locccodeID | Loss_Code__c | Text(100) |  |  | Extenal Id from Master_Loss_Code_Claim_Motor__c |  |  |  |  |
| 6.3 | Amount | amount | Reverse_Amount__c | Currency(16, 2) |  |  | ยอดประมาณการ |  |  |  |  |
| 6.4 | Waive Flag | waiveFlag | Wve_Flag__c | Text(1) |  |  | Y, N |  |  |  |  |
| 6.5 | Waive Amount | waiveAmount | Wve_Amount__c | Decimal(16,2) |  |  | For Deduct |  |  |  |  |
| 6.6 | Document No | documentNo | Doc_No__c | Text(255) |  |  | For Deduct |  |  |  |  |
| 6.7 | Document Date | documentDate | Doc_Date__c | Date |  |  | For Deduct |  |  |  |  |
| 6.8 | Document Status | documentStatus | Doc_Status__c | Text(255) |  |  | For Deduct |  |  |  |  |
|  | Delete? |  |  |  |  |  |  |  |  |  |  |
| 7 | Car Detail | carDetail |  | Object |  | Y (Car) | Contain Car Detail |  |  | Page Layout |  |
| 7.1 | Can Recovery | canRecovery | Car_Insure__c | Boolean |  |  | สามารถเรียกร้องได้ไหม | canrecovery |  | Driver |  |
| 7.2 | Voluntary Policy | voluntaryPolicy | Voluntary_Policy__c | Text(255) |  |  | เลข Policy สมัครใจ | tpvpolicyno |  | Driver |  |
| 7.3 | Voluntary Insurance Company (BR Code) | voluntaryCompanyBrCode | Voluntary_Insurance_Company__c.Brcode__c | Text(100) |  |  | Insurance Company (BR Code) สมัครใจ | tpvinsentbrcode |  | Driver |  |
| 7.4 | Voluntary Insurance Company (Entity ID) | voluntaryCompanyEntityID | Voluntary_Insurance_Company__c.entityid__c | Text(100) |  |  | Insurance Company (Entity ID) สมัครใจ | tpvinsentityid |  | Driver |  |
| 7.5 | Voluntary Effective Date | voluntaryEffectiveDate | Voluntary_Effective_Date__c | Date |  |  | วันที่เริ่มมีผล | tpveffectivedate |  | Driver |  |
| 7.6 | Voluntary Expiry Date | voluntaryExpiryDate | Voluntary_Expiry_Date__c | Date |  |  | วันที่หมดอายุ | tpvexpirydate |  | Driver |  |
| 7.7 | Voluntary Class | voluntaryClass | Voluntary_Class__c | Picklist |  |  | ประกันชั้น 1, 2, 3 | tpvclass |  | Driver |  |
| 7.8 | Voluntary Claim No. | voluntaryClaimNo | Voluntary_Claim_No__c | Text(255) |  |  | เลขเคลม สมัครใจ | tpvclaimno |  | Driver |  |
| 7.9 | Voluntary TPPD | voluntaryTPPD | Voluntary_TPPD__c | Demcimal(16,2) |  |  | ค่าทรัพย์สินคู่กรณี (ต่อครั้ง) |  |  | Driver |  |
| 7.10 | Compulsory Policy | compulsoryPolicy | Compulsory_Policy__c | Text(255) |  |  | เลข Policy บังคับ | tpcpolicyno |  | Driver |  |
| 7.11 | Compulsory Company Name (BR Code) | compulsoryCompanyBrCode | Compulsory_Insurance_Company__c.Brcode__c | Text(100) |  |  | Insurance Company (BR Code) บังคับ | tpcinsentbrcode | เช่น รุ่นรถ + Master | Driver |  |
| 7.12 | Compulsory Company Name (Entity ID) | compulsoryCompanyEntityID | Compulsory_Insurance_Company__c.entityid__c | Text(100) |  |  | Insurance Company (Entity ID) บังคับ | tpcinsentityid |  | Driver |  |
| 7.13 | Compulsory Effective Date | compulsoryEffectiveDate | Compulsory_Effective_Date__c | Date |  |  | วันที่เริ่มมีผล | tpceffdate |  | Driver |  |
| 7.14 | Compulsory Expiry Date | compulsoryExpiryDate | Compulsory_Expiry_Date__c | Date |  |  | วันที่หมดอายุ | tpcexpdate |  | Driver |  |
| 7.15 | Compulsory Claim No. | compulsoryClaimNo | Compulsory_Claim_No__c | Text(255) |  |  | เลขเคลม บังคับ | tpcclaimno |  | Driver |  |
| 7.16 | License No | carRegisterNo | Car_Register_No__c | Text(10) |  |  | เลขทะเบียนรถ | tplicenseno |  |  |  |
| 7.17 | License Place | carProvince | Car_Province__c | Text(255) |  |  | รหัสจังหวัด ของทะเบียนรถ | tpprovinceid |  |  |  |
| 7.18 | Unregistered Plate | carUnregister | Car_Unregister__c | Boolean |  |  | รถป้ายแดง? | tpunregister |  | Driver |  |
| 7.19 | Brand | carBrand | Car_Brand__c | Text(255) |  |  | รหัส ยี่ห้อรถ | tpbrandid |  | Driver |  |
| 7.20 | Model Year | carModel | Car_Model__c | Text(255) |  |  | รหัส รุ่นรถ | tpmodelid |  | Driver |  |
| 7.21 | Color | carColor | Car_Color__c | Text(255) |  |  | รหัส สีรถ | tpcolorid |  |  |  |
| 7.22 | Chassis No | chassisNo | Chassis_No__c | Text(255) |  |  | เลขคัสซี | tpchassisno |  |  |  |
| 7.23 | Engine No. | engineNo | Engine_No__c | Text(255) |  |  | เลขตัวถัง | tpengineno |  |  |  |
| 7.25 | Loss Initial Damage | lossInitialDamage | Loss_Initial_Damage__c | Number(16,2) |  |  | ประมาณการความเสียหายเบื้องต้น | lossinitialdamage |  | Driver |  |
| 7.26 | Car Description | carDescription | Car_Description__c | Text(255) |  |  | รายละเอียดรถ | tpcardesc |  | Driver |  |
| 7.27 | Prescription | prescription | Prescription__c | Picklist |  |  | 1, 2, None | prescription | มาเปลี่ยน labelทีหลัง | Driver |  |
| 7.28 | Prescription Date | prescriptionDate | Prescription_Date__c | Date |  |  | Loss Date + prescription | prescriptiondate | มาเปลี่ยน labelทีหลัง | Driver |  |
| 7.29 | Driver Title | driverTitle | Driver_Title__c | Text(255) |  |  | คำนำหน้าชื่อ ผู้ขับขี่ |  |  | Driver |  |
| 7.30 | Driver Title ID | driverTitleID | Driver_Title_ID__c | Text(255) |  |  | รหัสคำนำหน้าชื่อ ผู้ขับขี่ | titleid |  | Driver |  |
| 7.31 | Driver First Name | driverFirstName | Driver_FirstName__c | Text(255) |  |  | ชื่อ ผู้ขับขี่ | firstname |  | Driver |  |
| 7.32 | Driver Last Name | driverLastName | Driver_LastName__c | Text(255) |  |  | นามสกุล ผู้ขับขี่ | lastname |  | Driver |  |
| 7.33 | Driver Relation | driverRelation | driver_Relation__c | Text(50) |  |  | ความสัมพันธ์กับเจ้าของรถ ผู้ขับขี่ |  |  |  |  |
| 7.34 | Driver Relation Code | driverRelationCode | Driver_Relation_ID__c | Text(50) |  |  | รหัสความสัมพันธ์กับเจ้าของรถ ผู้ขับขี่ | relationid |  |  |  |
| 7.35 | Driver Birthday | driverBirthday | Driver_Birthday__c | Date |  |  | วันเกิด ผู้ขับขี่ | birthdate |  |  |  |
| 7.36 | Driver Age | driverAge | Driver_Age__c | Integer |  |  | อายุ ผู้ขับขี่ |  |  |  |  |
| 7.37 | Driver Gender | driverGender | Driver_Gender__c | Picklist |  |  | เพศ ผู้ขับขี่ | sex |  |  |  |
| 7.38 | Driver Occupation | driverOccupation | Driver_Occupation__c | Text(255) |  |  | ตำแหน่งงาน ผู้ขับขี่ | occupationid |  | Driver |  |
| 7.39 | Driver License No | driverLicenseNo | Driver_License_No__c | Text(255) |  |  | เลขที่ใบขับขี่ ผู้ขับขี่ |  |  |  |  |
| 7.40 | Driver License Type Text | driverLicenseTypeText | Driver_License_Type_Text__c | Text(255) |  |  | ประเภทใบขับขี่ ผู้ขับขี่ |  |  |  |  |
| 7.41 | Driver License Type Code | driverLicenseTypeCode | Driver_License_Type_Code__c | Text(255) |  |  | รหัสประเภทใบขับขี่ ผู้ขับขี่ |  |  |  |  |
| 7.42 | Driver License Issue Date | driverLicenseIssueDate | Driver_License_Issue_Date__c | Date |  |  | วันที่ออกบัตร ผู้ขับขี่ |  |  |  |  |
| 7.43 | Driver License Expiry Date | driverLicenseExpiryDate | Driver_License_Expiry_Date__c | Date |  |  | วันที่บัตรหมดอายุ ผู้ขับขี่ |  |  |  |  |
| 7.44 | Driver ID Card . | driverIDCard | Driver_ID_Card__c | Text(255) |  |  | เลขที่บัตรประจำตัว ผู้ขับขี่ | personalid |  |  |  |
| 7.45 | Driver ID Card Type Text | driverIDCardTypeText | Driver_ID_Type__c | Text(255) |  |  | ประเภทบัตรประจำตัว ผู้ขับขี่ |  |  | Driver |  |
| 7.46 | Driver ID Card Type Code | driverIDCardTypeCode | Driver_ID__c | Text(255) |  |  | รหัสประเภทบัตรประจำตัว ผู้ขับขี่ |  |  | Driver |  |
| 7.47 | Driver ID Card Expiry Date | driverIDCardExpiryDate | Driver_ID_Card_Expired__c | Date |  |  | วันที่บัตรหมดอายุ ผู้ขับขี่ | expirydate |  | Driver |  |
| 7.48 | Driver Place | driverAddress | Driver_Address__c | Text(255) |  |  | ที่อยู่ ผู้ขับขี่ | address |  |  |  |
| 7.49 | Driver No | driverNo | Driver_No__c | Text(255) |  |  | บ้านเลขที่ ผู้ขับขี่ | no |  | Driver |  |
| 7.50 | Driver Moo | driverMoo | Driver_Moo__c | Text(255) |  |  | หมู่ ผู้ขับขี่ | moo |  | Driver |  |
| 7.51 | Driver Soi | driverSoi | Driver_Soi__c | Text(255) |  |  | ซอย ผู้ขับขี่ | soi |  | Driver |  |
| 7.52 | Driver Road | driverRoad | Driver_Road__c | Text(255) |  |  | ถนน ผู้ขับขี่ | road |  | Driver |  |
| 7.53 | Driver District | driverDistrict | Driver_District__c | Text(255) |  |  | ตำบล ผู้ขับขี่ |  |  | Driver |  |
| 7.54 | Driver District ID | driverDistrictID | Driver_District_ID__c | Text(255) |  |  | รหัสตำบล ผู้ขับขี่ | districtid |  | Driver |  |
| 7.55 | Driver Amphur | driverAmphur | Driver_Amphur__c | Text(255) |  |  | อำเภอ ผู้ขับขี่ |  |  | Driver |  |
| 7.56 | Driver Amphur ID | driverAmphurID | Driver_Amphur_ID__c | Text(255) |  |  | รหัสอำเภอ ผู้ขับขี่ | amphurid |  | Driver |  |
| 7.57 | Driver Province | driverProvince | Driver_Province__c | Text(255) |  |  | จังหวัด ผู้ขับขี่ |  |  | Driver |  |
| 7.58 | Driver Province ID | driverProvinceID | Driver_Province_ID__c | Text(255) |  |  | รหัสจังหวัด ผู้ขับขี่ | provinceid |  | Driver |  |
| 7.59 | Driver Zip Code | driverZipCode | Driver_Zip_Code__c | Text(10) |  |  | รหัสไปรษณีย์ ผู้ขับขี่ | zipcode |  | Driver |  |
| 7.60 | Driver Country | driverCountry | Driver_Country__c | Text(255) |  |  | ประเทศ ผู้ขับขี่ |  |  | Driver |  |
| 7.61 | Driver Country ID | driverCountryID | Driver_Country_ID__c | Text(255) |  |  | รหัสประเทศ ผู้ขับขี่ | countryid |  | Driver |  |
| 7.62 | Driver Tel No. | driverTel | Driver_Tel__c | Phone |  |  | เบอร์โทรศัพท์ ผู้ขับขี่ | telno |  |  |  |
| 7.63 | Driver Fax No. | driverFax | Driver_Fax__c | Phone |  |  | แฟกซ์ ผู้ขับขี่ | faxno |  | Driver |  |
| 7.64 | Driver E-Mail | driverEmail | Driver_Email__c | Text(80) |  |  | อีเมล ผู้ขับขี่ | email |  | Driver |  |
| 7.65 | Owner Title | ownerTitle | Title__c | Text(255) |  |  | คำนำหน้าชื่อ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.66 | Owner Title ID | ownerTitleID | Title_ID__c | Text(255) |  |  | รหัสคำนำหน้าชื่อ เจ้าของกรมธรรม์ |  |  |  |  |
| 7.67 | Owner First Name | ownerFirstName | FirstName__c | Text(255) |  |  | ชื่อ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.68 | Owner Last Name | ownerLastName | LastName__c | Text(255) |  |  | นามสกุล เจ้าของกรมธรรม์ |  | add เข้า injury | Driver |  |
| 7.69 | Owner Relation | ownerRelation | Relation__c | Text(50) |  |  | ความสัมพันธ์กับเจ้าของรถ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.70 | Owner Relation Code | ownerRelationID | Relation_ID__c | Text(50) |  |  | รหัสความสัมพันธ์กับเจ้าของรถ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.71 | Owner Birthday | ownerBirthday | Birthday__c | Date |  |  | วันเกิด เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.72 | Owner Age | ownerAge | Age__c | Integer |  |  | อายุ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.73 | Owner Sex | ownerGender | Gender__c | Picklist |  |  | เพศ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.74 | Owner Occupation | ownerOccupation | Occupation__c | Text(255) |  |  | ตำแหน่งงาน เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.75 | Owner ID Card | ownerIDCard | Id_Card__c | Text(255) |  |  | เลขที่บัตรประจำตัว เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.76 | Owner ID Card Type Text | ownerIDCardTypeText | Id_Type__c | Text(255) |  |  | ประเภทบัตรประจำตัว เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.77 | Owner ID Card Type Code | ownerIDCardTypeCode | Id_Type_ID__c | Text(255) |  |  | รหัสประเภทบัตรประจำตัว เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.78 | Owner ID Card Expiry Date | ownerIDCardExpiryDate | Id_Card_Expired__c | Date |  |  | วันที่บัตรหมดอายุ เจ้าของกรมธรรม์ |  |  |  |  |
| 7.79 | Owner Place | ownerAddress | Address__c | Text(255) |  |  | ที่อยู่ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.80 | Owner No | ownerNo | No__c | Text(255) |  |  | บ้านเลขที่ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.81 | Owner Moo | ownerMoo | Moo__c | Text(255) |  |  | หมู่ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.82 | Owner Soi | ownerSoi | Soi__c | Text(255) |  |  | ซอย เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.83 | Owner Road | ownerRoad | Road__c | Text(255) |  |  | ถนน เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.84 | Owner District | ownerDistrict | District__c | Text(255) |  |  | ตำบล เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.85 | Owner District ID | ownerDistrictID | District_ID__c | Text(255) |  |  | รหัสตำบล เจ้าของกรมธรรม์ |  |  |  |  |
| 7.86 | Owner Amphur | ownerAmphur | Amphur__c | Text(255) |  |  | อำเภอ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.87 | Owner Amphur ID | ownerAmphurID | Amphur_ID__c | Text(255) |  |  | รหัสอำเภอ เจ้าของกรมธรรม์ |  |  |  |  |
| 7.88 | Owner Province | ownerProvince | Province__c | Text(255) |  |  | จังหวัด เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.89 | Owner Province ID | ownerProvinceID | Province_ID__c | Text(255) |  |  | รหัสจังหวัด เจ้าของกรมธรรม์ |  |  |  |  |
| 7.90 | Owner Zip Code | ownerZipCode | Zip_Code__c | Text(255) |  |  | รหัสไปรษณีย์ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.91 | Owner Tel No. | ownerTel | Tel__c | Text(40) |  |  | เบอร์โทรศัพท์ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.92 | Owner Fax No. | ownerFax | Fax__c | Text(40) |  |  | แฟกซ์ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 7.93 | Owner E-Mail | ownerEmail | Email__c | Text(80) |  |  | อีเมล เจ้าของกรมธรรม์ |  |  | Driver |  |
| 8 | Injury Detail | injuryDetail |  | Object |  | Y |  |  |  | Driver |  |
| 8.1 | Person Type | personType | Person_Type__c | Picklist |  |  | รหัสประเภทผู้บาดเจ็บ | itemtype |  | Injury |  |
| 8.2 | Person Type Text | personTypeText | Person_Type_Text__c | Text(255) |  |  | ประเภทผู้บาดเจ็บ |  |  | injury |  |
| 8.3 | Title | title | Title__c | Text(40) |  |  | คำนำหน้า |  |  |  |  |
| 8.4 | Title ID | titleID | Title_ID__c | Text(255) |  |  | คำนำหน้าชื่อ | titleid |  |  |  |
| 8.5 | First Name | firstname | FirstName__c | Text(80) |  |  | ชื่อ | firstname |  |  |  |
| 8.6 | Last Name | lastname | LastName__c | Text(255) |  |  | นามสกุล | lastname |  |  |  |
| 8.7 | Relation | relation | Relation__c | Text(255) |  |  | ความสัมพันธ์กับเจ้าของรถ | relationid |  |  |  |
| 8.8 | Relation Code | relationID | Relation_ID__c | Text(255) |  |  | รหัสความสัมพันธ์กับเจ้าของรถ |  |  |  |  |
| 8.9 | Birthday | birthday | Birthday__c | Date |  |  | วันเกิด | birthdate |  |  |  |
| 8.10 | Age | age | Age__c | Integer |  |  | อายุ |  |  |  |  |
| 8.11 | Gender | gender | Gender__c | Text(255) |  |  | เพศ |  |  | injury |  |
| 8.12 | Occupation | occupation | Occupation__c | Text(255) |  |  | ตำแหน่งงาน | occupationid |  |  |  |
| 8.13 | ID Card | idCard | Id_Card__c | Text(255) |  |  | เลขที่บัตรประจำตัว | personalid |  |  |  |
| 8.14 | ID Type | idType | Id_Type__c | Text(255) |  |  | ประเภทบัตรประจำตัว |  |  |  |  |
| 8.15 | ID Type ID | idTypeCode | Id_Type_ID__c | Text(255) |  |  | รหัสประเภทบัตรประจำตัว |  |  |  |  |
| 8.16 | ID Card Expiry Date | idCardExpiryDate | Id_Card_Expired__c | Date |  |  | วันที่บัตรหมดอายุ | expirydate |  |  |  |
| 8.17 | Place | address | Address__c | Text(255) |  |  | ที่อยู่ | address |  |  |  |
| 8.18 | No | no | No__c | Text(255) |  |  | บ้านเลขที่ | no | addบน Ownner |  |  |
| 8.19 | Moo | moo | Moo__c | Text(255) |  |  | หมู่ | moo |  |  |  |
| 8.20 | Soi | soi | Soi__c | Text(255) |  |  | ซอย | soi |  |  |  |
| 8.21 | Road | road | Road__c | Text(255) |  |  | ถนน | road |  |  |  |
| 8.22 | District | district | District__c | Text(255) |  |  | ตำบล |  |  |  |  |
| 8.23 | District ID | districtID | District_ID__c | Text(255) |  |  | รหัสตำบล | districtid |  |  |  |
| 8.24 | Amphur | amphur | Amphur__c | Text(255) |  |  | อำเภอ |  |  |  |  |
| 8.25 | Amphur ID | amphurID | Amphur_ID__c | Text(255) |  |  | รหัสอำเภอ | amphurid |  |  |  |
| 8.26 | Province | province | Province__c | Text(255) |  |  | จังหวัด |  |  |  |  |
| 8.27 | Province ID | provinceID | Province_ID__c | Text(255) |  |  | รหัสจังหวัด | provinceid |  |  |  |
| 8.28 | Zip Code | zipCode | Zip_Code__c | Text(10) |  |  | รหัสไปรษณีย์ |  |  |  |  |
| 8.29 | Country | country | Country__c | Text(255) |  |  | ประเทศ | zipcode |  |  |  |
| 8.30 | Country ID | countryID | Country_ID__c | Text(255) |  |  | รหัสประเทศ | countryid |  |  |  |
| 8.31 | Tel No. | driverTel | Tel__c | Text(40) |  |  | เบอร์โทรศัพท์ | telno |  |  |  |
| 8.32 | Fax No. | driverFax | Fax__c | Text(40) |  |  | แฟกซ์ | faxno |  |  |  |
| 8.33 | E-Mail | driverEmail | Email__c | Text(80) |  |  | อีเมล | email |  |  |  |
| 8.34 | Injured Details | injuredDetail | Injured_Detail__c | Text(255) |  |  | อาการบาดเจ็บ |  |  | injury |  |
| 8.35 | Wounded Type | woundedType | Wounded_Type_Text__c | Text(255) |  |  | ลักษณะอาการบาดเจ็บ |  |  | injury |  |
| 8.36 | Hospital Name | hospitalName | Hospital_Name__c | Text(255) |  |  | โรงพยาบาลที่เข้ารักษา |  |  | injury |  |
| 9 | Property Detail | propertyDetail | Object = ClaimItem(Asset) |  |  | Y |  |  |  |  |  |
| 9.1 | Type | propertyType | Asset_Name__c | Text(255) |  |  | ประเภทของทรัพย์สิน | tppropertytype |  |  |  |
| 9.2 | Place | propertyAddress | Asset_Address__c | Text(255) |  |  | ที่อยู่เจ้าของ | address |  |  |  |
|  | No | propertyNo |  | Text(255) |  |  | เลขที่บ้าน | no |  |  |  |
|  | Moo | propertyMoo |  | Text(255) |  |  | หมู่ | noo |  |  |  |
| 9.3 | Soi | propertySoi | Asset_Soi__c | Text(255) |  |  | ซอย | soi |  |  |  |
| 9.4 | Road | propertyRoad | Asset_Road__c | Text(255) |  |  | ถนน | road |  |  |  |
| 9.5 | District | propertyDistrict | Asset_District__c | Text(255) |  |  | ตำบล |  |  |  |  |
| 9.6 | District ID | propertyDistrictID | Asset_District_ID__c | Text(255) |  |  | รหัสตำบล | districtid |  |  |  |
| 9.7 | Amphur | propertyAmphur | Asset_Amphur__c | Text(255) |  |  | อำเภอ |  |  |  |  |
| 9.8 | Amphur ID | propertyAmphurID | Asset_Amphur_ID__c | Text(255) |  |  | รหัสอำเภอ | amphurid |  |  |  |
| 9.9 | Province | propertyProvince | Asset_Province__c | Text(255) |  |  | จังหวัด |  |  |  |  |
| 9.10 | Province ID | propertyProvinceID | Asset_Province_ID__c | Text(255) |  |  | รหัสจังหวัด | provinceid |  |  |  |
| 9.11 | Zip Code | propertyZipCode | Asset_Zip_Code__c | Text(10) |  |  | รหัสไปรษณีย์ |  |  |  |  |
| 9.12 | Owner Title | ownerTitle | Title__c | Text(255) |  |  | คำนำหน้าชื่อ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.13 | Owner Title ID | ownerTitleID | Title_ID__c | Text(255) |  |  | รหัสคำนำหน้าชื่อ เจ้าของกรมธรรม์ | titleid |  |  |  |
| 9.14 | Owner First Name | ownerFirstName | FirstName__c | Text(255) |  |  | ชื่อ เจ้าของกรมธรรม์ | firstname |  | Driver |  |
| 9.15 | Owner Last Name | ownerLastName | LastName__c | Text(255) |  |  | นามสกุล เจ้าของกรมธรรม์ | lastname |  | Driver |  |
| 9.16 | Owner Relation | ownerRelation | Relation__c | Text(50) |  |  | ความสัมพันธ์กับเจ้าของรถ เจ้าของกรมธรรม์ | relationid |  | Driver |  |
| 9.17 | Owner Relation Code | ownerRelationID | Relation_ID__c | Text(50) |  |  | รหัสความสัมพันธ์กับเจ้าของรถ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.18 | Owner Birthday | ownerBirthday | Birthday__c | Date |  |  | วันเกิด เจ้าของกรมธรรม์ | birthdate |  | Driver |  |
| 9.19 | Owner Age | ownerAge | Age__c | Integer |  |  | อายุ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.20 | Owner Sex | ownerGender | Gender__c | Picklist |  |  | เพศ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.21 | Owner Occupation | ownerOccupation | Occupation__c | Text(255) |  |  | ตำแหน่งงาน เจ้าของกรมธรรม์ | occupationid |  | Driver |  |
| 9.22 | Owner ID Card | ownerIDCard | Id_Card__c | Text(255) |  |  | เลขที่บัตรประจำตัว เจ้าของกรมธรรม์ | personalid |  | Driver |  |
| 9.23 | Owner ID Card Type Text | ownerIDCardTypeText | Id_Type__c | Text(255) |  |  | ประเภทบัตรประจำตัว เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.24 | Owner ID Card Type Code | ownerIDCardTypeCode | Id_Type_ID__c | Text(255) |  |  | รหัสประเภทบัตรประจำตัว เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.25 | Owner ID Card Expiry Date | ownerIDCardExpiryDate | Id_Card_Expired__c | Date |  |  | วันที่บัตรหมดอายุ เจ้าของกรมธรรม์ | expirydate |  |  |  |
| 9.26 | Owner Place | ownerAddress | Address__c | Text(255) |  |  | ที่อยู่ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.27 | Owner No | ownerNo | No__c | Text(255) |  |  | บ้านเลขที่ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.28 | Owner Moo | ownerMoo | Moo__c | Text(255) |  |  | หมู่ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.29 | Owner Soi | ownerSoi | Soi__c | Text(255) |  |  | ซอย เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.30 | Owner Road | ownerRoad | Road__c | Text(255) |  |  | ถนน เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.31 | Owner District | ownerDistrict | District__c | Text(255) |  |  | ตำบล เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.32 | Owner District ID | ownerDistrictID | District_ID__c | Text(255) |  |  | รหัสตำบล เจ้าของกรมธรรม์ |  |  |  |  |
| 9.33 | Owner Amphur | ownerAmphur | Amphur__c | Text(255) |  |  | อำเภอ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.34 | Owner Amphur ID | ownerAmphurID | Amphur_ID__c | Text(255) |  |  | รหัสอำเภอ เจ้าของกรมธรรม์ |  |  |  |  |
| 9.35 | Owner Province | ownerProvince | Province__c | Text(255) |  |  | จังหวัด เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.36 | Owner Province ID | ownerProvinceID | Province_ID__c | Text(255) |  |  | รหัสจังหวัด เจ้าของกรมธรรม์ |  |  |  |  |
| 9.37 | Owner Zip Code | ownerZipCode | Zip_Code__c | Text(255) |  |  | รหัสไปรษณีย์ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.38 | Owner Tel No. | ownerTel | Tel__c | Text(40) |  |  | เบอร์โทรศัพท์ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.39 | Owner Fax No. | ownerFax | Fax__c | Text(40) |  |  | แฟกซ์ เจ้าของกรมธรรม์ |  |  | Driver |  |
| 9.40 | Owner E-Mail | ownerEmail | Email__c | Text(80) |  |  | อีเมล เจ้าของกรมธรรม์ |  |  | Driver |  |

### Example / Code Payload (Row 203)
**Example Request (Vehicle)**
```json
[
  {
    "claimId": "",
    "coverageID": "",
    "policyNumber": "MV-0023-E-004077",
    "itemNo": 1,
    "claimCoverageType": "TV",
    "losscode": [
      {
        "lossType": "Loss",
        "locccodeID": "LOSSODL",
        "amount": 5000
      },
      {
        "lossType": "Loss",
        "locccodeID": "LOSSODS",
        "amount": 13000
      },
      {
        "lossType": "Deduct",
        "locccodeID": "OD Wrong Driver",
        "amount": 2000,
        "waiveFlag": "N",
        "waiveAmount": 0,
        "documentNo": "DOC001",
        "documentDate": "2023-05-12",
        "documentStatus": "Sent"
      }
    ],
    "carDetail": {
      "canRecovery": false,
      "voluntaryPolicy": "MV-0023-E-005280",
      "voluntaryCompanyBrCode": "000",
      "voluntaryCompanyEntityID": "437511",
      "voluntaryEffectiveDate": "2022-06-01",
      "voluntaryExpiryDate": "2023-05-31",
      "voluntaryClass": "1",
      "voluntaryClaimNo": "CC-23-MV-00073",
      "voluntaryTPPD": 100000,
      "compulsoryPolicy": "MC-0023-E-005280",
      "compulsoryCompanyBrCode": "000",
      "compulsoryCompanyEntityID": "437511",
      "compulsoryEffectiveDate": "2022-06-01",
      "compulsoryExpiryDate": "2023-05-31",
      "compulsoryClaimNo": "CC-23-MV-00073",
      "carRegisterNo": "3กก3333",
      "carProvince": "กรุงเทพมหานคร",
      "carUnregister": false,
      "carBrand": "11",
      "carModel": "11_2",
      "carColor": "3",
      "chassisNo": "POR1MEEPOROBO1123",
      "engineNo": "POR1MEEPOROBO1123"
    }
  }
]
```

### Example / Code Payload (Row 204)
**Example Request (Injury)**
```json
[
  {
    "claimId": "",
    "coverageID": "",
    "policyNumber": "MV-0023-E-004077",
    "itemNo": 1,
    "claimCoverageType": "DV",
    "losscode": [
      {
        "lossType": "Loss",
        "locccodeID": "LOSSTPBIM",
        "amount": 2300
      },
      {
        "lossType": "Loss",
        "locccodeID": "LOSSTPBIH",
        "amount": 700
      }
    ],
    "injuryDetail": {
      "personType": "DV",
      "personTypeText": "Driver",
      "title": "นาย",
      "titleID": "1",
      "firstname": "สวย",
      "lastname": "ดูดี",
      "relation": "น้องสาว",
      "relationID": "7",
      "birthday": "1990-02-12",
      "age": 33,
      "gender": "Male",
      "occupation": "พนักงานบริษัท",
      "idCard": "9605967735265",
      "idType": "บัตรประชาชน",
      "idTypeCode": "1",
      "idCardExpiryDate": "2030-02-12"
    }
  }
]
```

### Example / Code Payload (Row 205)
**Example Request (Property)**
```json
[
  {
    "claimId": "",
    "coverageID": "",
    "policyNumber": "MV-0023-E-004077",
    "itemNo": 1,
    "claimCoverageType": "TP",
    "losscode": [
      {
        "lossType": "Loss",
        "locccodeID": "LOSSTPPDL",
        "amount": 4000
      },
      {
        "lossType": "Loss",
        "locccodeID": "LOSSTPPDS",
        "amount": 30000
      }
    ],
    "propertyDetail": {
      "propertyType": "ประตูบ้าน",
      "address": "1 ดอนทราย ปากท่อ ราชบุรี",
      "soi": "8",
      "district": "คลองสาน",
      "districtID": "567",
      "amphur": "คลองสาน",
      "amphurID": "2",
      "province": "กรุงเทพมหานคร",
      "provinceID": "209",
      "zipCode": "10600",
      "country": "ประเทศไทย",
      "countryID": "1",
      "ownerName": "สวย ดูดี",
      "phone": "094124211"
    }
  }
]
```

### Example / Code Payload (Row 206)
**Example Request (Expense)**
```json
[
  {
    "claimId": "",
    "coverageID": "",
    "policyNumber": "MV-0023-E-004077",
    "claimCoverageType": "ON",
    "losscode": [
      {
        "lossType": "Expense",
        "locccodeID": "AW",
        "amount": 1000
      },
      {
        "lossType": "Expense",
        "locccodeID": "EO",
        "amount": 2000
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
| 4.1 | Coverage Number | coverageID | External_Id__c | Text(20) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 216)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimCovId": "VPCNC2200007",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "claimCovId": "VPCNC2200008",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 217)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "claimCovId": "VPCNC2200007",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "claimCovId": "VPCNC2200008",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
