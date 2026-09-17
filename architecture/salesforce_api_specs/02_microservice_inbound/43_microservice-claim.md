# [43] Microservice-Claim

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Claim`
- **Total Rows Parsed**: `126`

## API Specification Overview

- **Endpoint URL**: `https://isv-api-dev.flybkk.com/api/v1/sf/saleforceControllerAPI`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://isv-api-dev.flybkk.com/api/v1/sf/saleforceControllerAPI |
| --- | --- |
| URL UAT | https://sandbox-uat-api.insurverse.co.th/api/v1/sf/saleforceControllerAPI |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |
| No | Create Account |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Table | GCP Field | GCP Remark |
| 1 | Function API | fn |  | Text |  |  | Fix: Claim |  |  |  |
| 2 | SRID | surveyReportID | Survey_Report_ID__c | int | Y | Y | transaction id | sf_claim | survey_report_id |  |
| 3 | Send SMS | sendSMS |  | Boolean |  | Y |  | sf_claim | send_sms |  |
| 4 | REF_NOTIFY_NO | refNotifyNo | Notify_No__c | Text(20) | Y | Y | เลขรับแจ้ง | sf_claim | ref_notify_no |  |
| 5 | REF_CLAIM_NO | refClaimNo | Claim_No__c | Text(20) |  | Y | เลขที่เคลม | sf_claim | ref_claim_no |  |
| 6 | ADD_NO | addOn | Add_No | Decimal(1,0) |  |  | ครั้งที่การเปิดใบค่าใช้จ่าย (จำนวนรอบ) | sf_claim | add_on |  |
| 7 | SURVEYID | surveyID |  | Decimal(4,0) |  |  | หมายเลขบริษัทเซอร์เวย์. (Fix: 9999) | sf_claim | survey_id |  |
| 8 | SURVEYBRID | surveyBrID |  | Decimal(4,0) |  |  | หมายเลขสาขาบริษัทเซอร์เวย์ (Fix: 9999) | sf_claim | survey_br_id |  |
| 9 | POS_STATUS | posStatus |  | Decimal(1,0) |  |  | สถานะของใบเซอร์เวย์ ณ ปัจจุบัน 2 สถานะ 0=Surveyer ปิดงาน ณ สถานที่เกิดเหตุ , 3=เจ้าหน้าที่สินไหมอนุมัติแล้ว | sf_claim | pos_status |  |
| 10 | PRB_NUMBER | prbNumber | Compulsory_Policy_No__c | Text(30) |  |  | กรมธรรม์(พรบ.) | sf_claim | prb_number |  |
| 11 | ACC_POLICY_NO | accPolicyNo | PolicyNumber.Name | Text(30) |  |  | กรมธรรม์เลขที่ | sf_claim | acc_policy_no |  |
| 12 | ASSURED_NAME | assuredName | Account.Name | Text(200) |  |  | ผู้เอาประกันภัย | sf_claim | assured_name |  |
| 13 | POLICY_TYPE | policyType | claim.PolicyNumber.Policy_Sub_Type__c | Text(150) |  |  | ประกันประเภท | sf_claim | policy_type |  |
| 14 | POLICY_START | policyStart | claim.PolicyNumber.EffectiveDate | Datetime |  |  | วันที่เริ่มต้นกรมธรรม์ | sf_claim | policy_start |  |
| 15 | POLICY_END | policyEnd | claim.PolicyNumber.ExpirationDate | Datetime |  |  | วันที่สิ้นสุดกรมธรรม์ | sf_claim | policy_end |  |
| 16 | OPO_PAY | opoPay | OPO_Pay | Decimal(16,2) |  |  | รับเงินจำนวน (OPO_RESULT=1) | sf_claim | opo_pay |  |
| 17 | ACC_DATE | accidentDate | Loss_Date__c | Datetime |  |  | เวลาที่เกิดเหตุ | sf_claim | accident_date |  |
| 18 | ACC_PLACE | accidentPlace | Loss_Place__c | text(255) |  |  | สถานที่เกิดเหตุ | sf_claim | accident_place |  |
| 19 | ACC_DISTRICT | accidentDistrict | Loss_District__c | Text(50) |  |  | อำเภอเกิดเหตุ | sf_claim | accident_district |  |
| 20 | ACC_PROVINCE | accidentProvince | Loss_Province__c | Text(50) |  |  | จังหวัดเกิดเหตุ | sf_claim | accident_province |  |
| 21 | ACC_TYPE | accidentType | Cause_Of_Loss_Formula__c | Text(200) |  |  | ลักษณะการเกิดเหตุ | sf_claim | accident_type |  |
| 22 | ACC_DETAIL | accidentDetail | Accident_Detail__c | Text(255) |  |  | ข้อมูลการเกิดเหตุ | sf_claim | accident_detail |  |
| 23 | ACC_CAUSE | accidentCause | Accident_Cause__c | int |  |  | เป็นฝ่ายประมาท (1=ผู้ขับขี่รถประกัน, 2=ผู้ขับขี่รถคู่กรณี, 3=ประมาททั้งสองฝ่าย, 4=รอสรุปผลคดี) | sf_claim | accident_cause |  |
| 24 | ACC_CALL | accidentCall | Accident_Call_Name__c | Text(255) |  |  | ผู้แจ้ง | sf_claim | accident_call |  |
| 25 | ACC_CALL_DATE | accidentCallDate | report.Survey_Date__c, Accident_Call_Date__c | Datetime |  |  | วันที่รับแจ้ง | sf_claim | accident_call_date |  |
| 26 | ACC_ASSIGN | accidentAssign | report.Accident_Assign_Date__c | Datetime |  |  | วันที่จ่ายงาน | sf_claim | accident_assign |  |
| 27 | ACC_REACH | accidentReach | report.Accident_Reach_Date__c | Datetime |  |  | ถึงที่เกิดเหตุเวลา | sf_claim | accident_reach |  |
| 28 | ACC_FINISH | accidentFinish | report.Accident_Finish_Date__c | Datetime |  |  | วันที่สำรวจภัยเสร็จ | sf_claim | accident_finish |  |
| 29 | POLICE_NAME | policeName | Police_Name__c | Text(255) |  |  | ชื่อพนักงานสอบสวน | sf_claim | police_name |  |
| 30 | POLICE_STATION | policeStation | Police_Station__c | Text(255) |  |  | สถานีตำรวจ | sf_claim | police_station |  |
| 31 | POLICE_COMMENT | policeComment | Police_Comment__c | Text(255) |  |  | ความคิดเห็นพนักงานสอบสวน | sf_claim | police_comment |  |
| 32 | POLICE_DATE | policeDate | Police_Date__c | Datetime |  |  | วันที่สอบสวน | sf_claim | police_date |  |
| 33 | BOOK_NUMBER | bookNumber | Book_Number__c | Text(255) |  |  | ประจำวันข้อที่ | sf_claim | book_number |  |
| 34 | SURVEYOR_NAME | surveyorName | report.Surveyor_Name__c | Text(255) |  |  | ชื่อบริษัทเซอร์เวย์. (DP) | sf_claim | surveyor_name |  |
| 35 | ACC_SURV | accidentSurveyor | report.Accident_Surveyor__c | Text(255) |  |  | ผู้ตรวจสอบ (ชื่อพนักงานสำรวจ) | sf_claim | accident_surveyor |  |
| 36 | SURV_COMMENT | surveyorComment | report.Surveyor_Comment__c | Text(65,000) |  |  | ความเห็นรวมของเซอร์เวย์ | sf_claim | surveyor_comment |  |
| 37 | SURV_DATE | surveyDate | Notify_Date__c | Datetime |  |  | วันที่ส่งรายงาน | sf_claim | survey_date |  |
| 38 | REMARK | remark | Remark__c | Text(255) |  |  | หมายเหตุ | sf_claim | remark |  |
| 39 | SURV_CAR | carDetail | ClaimItem (Object) | Array |  |  | ราการรถที่เกิดเหตุ | sf_claim | car_detail |  |
| 40.1 | Record ID | recordID | External_ID__c | Text(255) | Y | Y | Unique ID Car | sf_claim_car_detail | record_id |  |
| 40.2 | RSKNO | index | Index_Number__c | Number(18,0) |  |  | index number. (รถประกัน=0 , TP = 1,2,…) | sf_claim_car_detail | index |  |
| 40.3 | CAR_REGNO | carRegisterNo | Car_Register_No__c | Text(10) |  |  | ทะเบียนรถ | sf_claim_car_detail | car_register_no |  |
| 40.4 | CAR_PROVINCE | carProvince | Car_Province__c | Text(255) |  |  | จังหวัดของทะเบียนรถ | sf_claim_car_detail | car_province |  |
| 40.5 | CAR_PROVINCE_ID | carProvinceId | masterProvince.get(item.Car_Province__c) | int |  |  | รหัสจังหวัดของทะเบียนรถ เพิ่มใหม่ 26/05/66 | sf_claim_car_detail | car_province_id |  |
| 40.6 | CAR_BRAND | carBrand | Car_Brand_Formula__c | Text(255) |  |  | ยี่ห้อ | sf_claim_car_detail | car_brand |  |
| 40.7 | CAR_MODEL | carModel | Car_Model_Formula__c | Text(255) |  |  | รุ่น | sf_claim_car_detail | car_model |  |
| 40.8 | CAR_COLOR | carColor | Car_Color__c | Text(255) |  |  | สี | sf_claim_car_detail | car_color |  |
| 40.9 | CHASSISNO | chassisNo | Chassis_No__c | Text(255) |  |  | เลขตัวถัง | sf_claim_car_detail | chassis_no |  |
| 40.10 | ENGINENO | engineNo | Engine_No__c | Text(255) |  |  | เลขเครื่องยนต์ | sf_claim_car_detail | engine_no |  |
| 40.11 | DRI_GENDER | driverGender | Driver_Gender__c | Picklist |  |  | เพศผู้ขับขี่ (ชาย, หญิง) | sf_claim_car_detail | driver_gender |  |
| 40.12 | DRI_NAME | driverName | Driver_Name__c | Text(255) |  |  | ชื่อผู้ขับขี่ | sf_claim_car_detail | driver_name |  |
| 40.13 | DRI_TELNO | driverTel | Driver_Tel__c | Text(40) |  |  | เบอร์โทรผู้ขับขี่ | sf_claim_car_detail | driver_tel |  |
| 40.14 | DRI_BIRTHDAY | driverBirthday | Driver_Birthday__c | Datetime |  |  | วันเกิด | sf_claim_car_detail | driver_birthday |  |
| 40.15 | DRI_AGE | driverAge | Driver_Age__c | Number(18,0) |  |  | อายุ | sf_claim_car_detail | driver_age |  |
| 40.16 | DRI_ADDRESS | driverAddress | Driver_Address__c | Text(255) |  |  | ที่อยู่ผู้ขับขี่ | sf_claim_car_detail | driver_address |  |
| 40.17 | DRI_DRVID | driverLicenseNo | Driver_License_No__c | Text(13) |  |  | เลขที่ใบขับขี่ | sf_claim_car_detail | driver_license_no |  |
| 40.18 | DRI_DRVTYPE | driverLicenseType | Driver_License_Type__c | Text(255) |  |  | ประเภทใบขับขี่ | sf_claim_car_detail | driver_license_type |  |
| 40.19 | DRI_DRVPLACE | driverLicensePlace | Driver_License_Place__c | Text(255) |  |  | จังหวัดที่ออกใบขับขี่ | sf_claim_car_detail | driver_license_place |  |
| 40.20 | DRI_DRVDATE_START | driverLicenseStart | driver_License_Start__c | Date |  |  | ออกให้วันที่ | sf_claim_car_detail | driver_license_start |  |
| 40.21 | DRI_DRVDATE_END | driverLicenseExpired | Driver_License_Expired__c | Date |  |  | วันหมดอายุใบขับขี่ | sf_claim_car_detail | driver_license_expired |  |
| 40.22 | DRI_RELATION | driverRelation | Driver_Relation | Text(50) |  |  | ความสัมพันธ์กับเจ้าของรถ | sf_claim_car_detail | driver_relation |  |
| 40.23 | HAVE_INSURANCE | haveInsurance | Have_Insurance | Text(50) |  |  | มีประกันภัยของที่ไหน (เฉพาะ TYPE >= 1) | sf_claim_car_detail | have_insurance |  |
| 40.24 | POLICYNO | policyNo | Policy_No | Text(30) |  |  | กรมธรรม์ (เฉพาะ TYPE >= 1) | sf_claim_car_detail | policy_no |  |
| 40.25 | CLAIMNO | claimNo | Claim_No | Text(30) |  |  | หมายเลขเคลมที่ (เฉพาะ TYPE >= 1) | sf_claim_car_detail | claim_no |  |
| 40.26 | POLICY_TYPE | policyType | Policy_Type | Text(255) |  |  | ประกันประเภท (เฉพาะ TYPE >= 1) | sf_claim_car_detail | policy_type |  |
| 40.27 | DRI_CARDID | driverIDCard | Driver_ID_Card__c | Text(13) |  |  | เลขที่บัตรประชาชน | sf_claim_car_detail | driver_id_card |  |
| 40.28 | OPO_RECOVERY | opoRecovery | Opo_Recovery__c | Number(18,0) |  |  | เรียกร้องค่าเสียหายจากคู่กรณี | sf_claim_car_detail | opo_recovery |  |
| 40.29 | TOTAL_DAMAGE_COST | totalDamageCost | Total_Damage_Cost__c | Number(18,0) |  |  | ค่าประมาณการความเสียหายรวม | sf_claim_car_detail | total_damage_cost |  |
| 40.30 | DAMAGE_LIST[] | damageList | Damage_List__c (Object) | Array |  |  | รายการชิ้นส่วนที่เสียหาย | sf_claim_car_detail | damage_list |  |
| 40.30.1 | "part" | part | Main_Part__c+Sub_Part__c | Text(255) |  |  | ชื่อชิ้นส่วน | sf_claim_car_detail | (JSON Array) damage_list |  |
| 40.30.2 | "damagedLevel" | damageLevel | Damage_Level__c | Picklist |  |  | ระดับความเสียหาย (A,B,C,D) | sf_claim_car_detail | (JSON Array) damage_list |  |
| 40.30.3 | "damage_type" | damageType | Damage_Type__c | Picklist |  |  | ประเภทความเสียหาย (บุบ ครูด ดุ้ง แตก) | sf_claim_car_detail | (JSON Array) damage_list |  |
| 40.30.4 | "damage_cost" | damageCost | Damage_Cost__c | Number(18,0) |  |  | ค่าประมาณความเสียหาย | sf_claim_car_detail | (JSON Array) damage_list |  |
| 40.30.5 | "memo" | memo | Memo__c | Text(255) |  |  | หมายเหตุ | sf_claim_car_detail | (JSON Array) damage_list |  |
| 41 | SURV_INJ | injured | ClaimParticipant (Object) | Array |  |  | ผู้บาดเจ็บ/เสียชีวิต ARRAY | sf_claim | injured |  |
| 41.1 | Record ID | recordID | External_ID__c | Text(255) | Y | Y | Unique ID Injury | sf_claim_injured | record_id |  |
| 41.2 | RSKNO | index | Index_Number__c | Number(18,0) |  |  | index number | sf_claim_injured | index |  |
| 41.3 | GENDER | gender | Gender__c | Text(255) |  |  | เพศ | sf_claim_injured | gender |  |
| 41.4 | NAME | name | Name__c | Text(255) |  |  | ชื่อ | sf_claim_injured | name |  |
| 41.5 | TEL_NO | tel | Tel__c | Text(40) |  |  | เบอร์โทร | sf_claim_injured | tel |  |
| 41.6 | IDCARD_NO | idCard | Id_Card__c | Text(13) |  |  | เลขที่บัตรประชาชน | sf_claim_injured | id_card |  |
| 41.7 | ADDRESS | address | Address__c | Text(255) |  |  | ที่อยู่ | sf_claim_injured | address |  |
| 41.8 | BIRTHDAY | birthday | Birthday__c | Date |  |  | วันเกิด | sf_claim_injured | birthday |  |
| 41.9 | AGE | age | Age__c | Number(18,0) |  |  | อายุ | sf_claim_injured | age |  |
| 41.10 | PERSON_TYPE | personType | Person_Type__c | Picklist |  |  | ประเภทผู้บาดเจ็บ  01 = “ผู้ขับขี่ – รถประกัน”   02 = “ผู้ขับขี่ - รถคู่กรณี”   03 = “ผู้โดยสาร - รถประกัน”  04 = “ผู้โดยสาร - รถคู่กรณี”   05 = “บุคคลภายนอกรถ” | sf_claim_injured | person_type |  |
| 41.11 | PERSON_TYPE_TEXT | personTypeText | Person_Type_Text__c | Picklist |  |  | ประเภทผู้บาดเจ็บ | sf_claim_injured | person_type_text |  |
| 41.12 | CAR_REGNO | carRegisterNo | Car_Register_No__c | Text(255) |  |  | ทะเบียนรถ (ถ้าเป็นบุคคลที่อยู่ในรถ) | sf_claim_injured | car_register_no |  |
| 41.13 | WOUNDED_TYPE | woundedType | Wounded_Type__c | Picklist |  |  | ลักษณะอาการบาดเจ็บ  01 = “บาดเจ็บ – เล็กน้อย”  02 = “บาดเจ็บ - ปานกลาง”  03 = “บาดเจ็บ - สาหัส”  04 = “ทุพพลภาพ”  05 = “เสียชีวิตก่อนรักษา”  06 = “เสียชีวิตหลังรักษา” | sf_claim_injured | wounded_type |  |
| 41.14 | WOUNDED_TYPE_TEXT | woundedTypeText | Wounded_Type_Text__c | Picklist |  |  | ลักษณะอาการบาดเจ็บ | sf_claim_injured | wounded_type_text |  |
| 41.15 | INJURE_DETAIL | injuredDetail | Injured_Detail__c | Text(255) |  |  | อาการบาดเจ็บ | sf_claim_injured | injured_detail |  |
| 41.16 | HOS_NAME | hospitalName | Hospital_Name__c | Text(255) |  |  | โรงพยาบาลที่เข้ารักษา | sf_claim_injured | hospital_name |  |
| 41.17 | COST | cost | Cost__c | Number(18,0) |  |  | ประมาณค่ารักษา | sf_claim_injured | cost |  |
| 41.18 | REMARK | remark | Remark__c | Text(255) |  |  | หมายเหตุ | sf_claim_injured | remark |  |
| 42 | SURV_ASSET [] | asset | ClaimItem (Object) | Array |  |  | ทรัพย์สิน | sf_claim | asset |  |
| 42.1 | Record ID | recordID | External_ID__c | Text(255) | Y | Y | Unique ID Asset | sf_claim_asset | record_id |  |
| 42.2 | RSKNO | index | Index_Number__c | Number(18,0) |  |  | index number | sf_claim_asset | index |  |
| 42.3 | ASSET_NAME | assetName | Asset_Name__c | Text(255) |  |  | ชื่อทรัพย์สิน | sf_claim_asset | asset_name |  |
| 42.4 | OWNER_NAME | ownerName | Owner_Name__c | Text(255) |  |  | ชื่อเจ้าของ | sf_claim_asset | owner_name |  |
| 42.5 | TELNO | tel | Tel__c | Text(40) |  |  | เบอร์โทรเจ้าของ | sf_claim_asset | tel |  |
| 42.6 | ADDRESS | address | Address__c | Text(255) |  |  | ที่อยู่เจ้าของ | sf_claim_asset | address |  |
| 42.7 | IDCARD_NO | idCard | Id_Card__c | Text(13) |  |  | เลขที่บัตรประชาชนเจ้าของ | sf_claim_asset | id_card |  |
| 42.8 | DAMAGE_DETAIL | damageDetail | Damage_Detail__c | Text(255) |  |  | รายละเอียดความเสียหาย | sf_claim_asset | damage_detail |  |
| 42.9 | COST | cost | Cost__c | Number(18,0) |  |  | ประมาณค่าเสียหาย | sf_claim_asset | cost |  |
| 42.10 | REMARK | remark | Remark__c | Text(255) |  |  | หมายเหตุ | sf_claim_asset | remark |  |
| 43 | ACC_DISTRICT_ID | accidentDistrictID | Amphur__c | int |  |  | รหัสอำเภอเกิดเหตุ | sf_claim | accident_district_id |  |
| 44 | ACC_PROVINCE_ID | accidentProvinceID | Province__c | int |  |  | รหัสจังหวัดเกิดเหตุ | sf_claim | accident_province_id |  |

### Example / Code Payload (Row 119)
**Example Request**
```json
{
    "fn": "Claim",
    "surveyReportID": "SR000001",
    "refNotifyNo": "NO000001",
    "refClaimNo": "CL0000001",
    "accidentDate": "2023-03-01 10:35:20",
    "accidentPlace": "1115 Rama III Rd, Chong Nonsi",
    "accidentDistrict": "Yan Nawa",
    "accidentProvince": "10120",
    "accidentType": "เคลมสด",
    "accidentDetail": "รถชนประตู",
    "accidentCause": "ถอยรถ",
    "accidentCall": "0929505991",
    "accidentCallDate": "2023-03-01 10:36:12",
    "accidentAssign": "2023-03-01 10:38:39",
    "accidentReach": "2023-03-01 10:52:43",
    "accidentFinish": "2023-03-01 10:58:51",
    "policeName": "Santhana",
    "policeStation": "Yan Nawa",
    "policeComment": "ชนทำไม",
    "policeDate": "2023-03-01 10:52:43",
    "bookNumber": "บันทึประจำวัน 0001",
    "surveyorName": "DP",
    "accidentSurveyor": "SomChai",
    "surveyorComment": "ชนไม่หนัก",
    "surveyDate": "2023-03-01 10:38:39",
    "remark": "Comment",
    "carDetail": [
        {
            "index": 1,
            "carRegisterNo": "กข1234",
            "carProvince": "กรุงเทพมหานคร",
            "carBrand": "Toyota",
            "carModel": "Cammry",
            "carColor": "White",
            "chassisNo": "XZB50-0002870",
            "engineNo": "N04C",
            "driverGender": "Male",
            "driverName": "Jaidee",
            "driverTel": "0987654321",
            "driverBirthday": "2000-01-01",
            "driverAge": "24",
            "driverAddress": "Sripaya",
            "driverLicenseNo": "1104214021414",
            "driverLicenseType": "รถยนต์",
            "driverLicensePlace": "Bangrak",
            "driverLicenseExpired": "2024-01-01",
            "driverIDCard": "11012424124141",
            "opoRecovery": 25000,
            "totalDamageCost": 40000,
            "damageList": [
                {
                    "part": "กันชนหลัง",
                    "damageLevel": "A",
                    "damageType": "แตก",
                    "damageCost": 10000,
                    "memo": "ต้องเปลี่ยนใหม่"
                },
                {
                    "part": "ไฟ้ท้ายคู่",
                    "damageLevel": "A",
                    "damageType": "แตก",
                    "damageCost": 5000,
                    "memo": "เปลี่ยนแค่โคม"
                }
            ]
        }
    ],
    "injured": [
        {
            "index": 1,
            "gender": "Female",
            "name": "Jane",
            "tel": "0876543219",
            "idCard": "110513134341",
            "address": "1115 Rama III Rd, Chong Nonsi, Yan Nawa, 10120",
            "birthday": "1990-02-24",
            "age": "34",
            "personType": "05",
            "personTypeText": "บุคคลภายนอกรถ",
            "carRegisterNo": "",
            "woundedType": "01",
            "woundedTypeText": "บาดเจ็บ – เล็กน้อย",
            "injuredDetail": "ข้อเท้าพลิก",
            "hospitalName": "Saint Loui",
            "cost": 5000,
            "remark": ""
        }
    ],
    "asset": [
        {
            "index": "1",
            "assetName": "ประตูบ้าน",
            "ownerName": "Jane",
            "tel": "09876543219",
            "address": "1115 Rama III Rd, Chong Nonsi, Yan Nawa, 10120",
            "idCard": "110513134341",
            "damageDetail": "ประตูล้ม",
            "cost": "20000",
            "remark": "ค่าซ่อม"
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

### Example / Code Payload (Row 125)
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

### Example / Code Payload (Row 126)
**Example Response
(Error)**
```json
{
    "statusCode": 400,
    "message": "Unexpected token / in JSON at position 987",
    "error": "Bad Request"
}
```
