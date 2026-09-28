# [44] Microservice-ClaimCoverage

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-ClaimCoverage`
- **Total Rows Parsed**: `298`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/upsertclaimcoverage`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/upsertclaimcoverage |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field |
| 0 |  |  |  | Array |  |  |  | Table : sf_claim_coverage |
| 1 | REF_CLAIM_NO | claimId | Claim.Claim_No__c | Text | Y | Y | เลขเคลม | claim_id |
| 2 | CLAIMLOGID | coverageId | Claim.CLAIMLOGID | Text(20) | Y | Y | หมายเลข e-Claim | coverage_id |
| 3 | CLAIMID | claimLogId | Claim.CLAIMID | Text(20) | Y | Y | หมายเลข ลำดับข้อมูล (Log) | claim_log_id |
| 4 | REPAIRERID | repairerId | REPAIRERID | Number (18,0) |  |  | รหัสอู่/ศูนย์ | repairer_id |
| 5 | REPAIRER_NAME | repairerName | REPAIRER_NAME | Text (100) |  |  | ชื่ออู่/ศูนย์ | repairer_name |
| 6 | REPAIRER_BRANCHID | repairerBranchId | REPAIRER_BRANCHID | Number (18,0) |  |  | รหัสสาขาอู่/ศูนย์ | repairer_branch_id |
| 7 | REPAIRER_BRANCHNAME | repairerBranchName | REPAIRER_BRANCHNAME | Text (100) |  |  | ชื่อสาขาอู่/ศูนย์ | repairer_branch_name |
| 8 | USER_NAME | userName | USER_NAME | Text(255) |  |  | ชื่อ -นามสกุล ผู้สร้างเคลม | user_name |
| 9 | INSURERBRID | insurerBrId | INSURERBRID | Integer |  |  | รหัสสาขาบริษัทประกัน | insurer_br_id |
| 10 | INSURERBR_NAME | InsurerBrName | INSURERBR_NAME | Text(100) |  |  | สาขาบริษัทประกัน | Insurer_br_name |
| 11 | REF_CLAIM_NO | refClaimNo | REF_CLAIM_NO | Lookup (Claim) | Y | Y | เลขเคลม | ref_claim_no |
| 12 | ACC_POLICY_NO | accPolicyNo | ACC_POLICY_NO | Text (50) | Y |  | เลขกรมธรรม์ | acc_policy_no |
| 13 | ACC_CLAIMREF_NO | accClaimRegNo | ACC_CLAIMREF_NO | Text (20) | Y |  | เลขรับแจ้ง | acc_claim_reg_no |
| 14 | C_CAR_REGNO | carRegNo | C_CAR_REGNO | Text (20) |  |  | ทะเบียนรถ | car_reg_no |
| 15 | CAR_PROVINCEID | carProvinceId | CAR_PROVINCEID | Integer |  |  | รหัสจังหวัดรถ | car_province_id |
| 16 | CHASSINO | chassiNo | CHASSINO | Text (31) |  |  | เลขตัวถัง | chassi_no |
| 17 | C_ENGINENO | engineNo | C_ENGINENO | Text(31) |  |  | เลขเครื่องยนต์ | engine_no |
| 18 | CPT_ID | cPTId | CPT_ID | Numeric |  |  | ชนิดสีที่พ่น ("1" = แห้งช้ำ, "2" = แห้งเร็ว  "3" = มุก, "4" = โอปอ) | c_pt_id |
| 19 | CCL_ID | cCLId | CCL_ID | Numeric |  |  | รหัสสีรถ | c_cl_id |
| 20 | CAR_KM | carKM | CAR_KM | Text(20) |  |  | หมายเลขกิโลเมตร | car_km |
| 21 | CMFG | cMFG | CMFG | Text (20) |  |  | ยี่ห้อรถ | c_mfg |
| 22 | CMODEL | cModel | CMODEL | Text (50) |  |  | รุ่นรถ | c_model |
| 23 | C_DSTYEAR | cDstYear | C_DSTYEAR | Text(10) |  |  | ปี-เดือน-ที่ผลิตรถ | c_dst_year |
| 24 | CTRIMLEVEL | cTrimLevel | CTRIMLEVEL | Text(50) |  |  | แบบ | c_trim_level |
| 25 | CVECHTYP | cVechTyp | CVECHTYP | Text(20) |  |  | ลักษณะตัวรถ | c_vech_typ |
| 26 | C_ENGSIZE | cEngSize | C_ENGSIZE | Text(5) |  |  | ซีซี | c_eng_size |
| 27 | CAR_DESC_ID | carDesId | CAR_DESC_ID | Integer |  |  | สภาพรถ 0 = ไม่ระบุ  1=ขับเคลื่อนได้  2=ขับเคลื่อนไม่ได้ | car_des_id |
| 28 | CARIDENNO | carIdenNo | CARIDENNO | Integer |  |  | รถคันที่เกิดอุบัติเหตุ 0 = รถประกัน  1,2,3… = รถคู่กรณีคันที่ 1,2,3.. | car_iden_no |
| 29 | C_DEDUCTIONSRC | cDeductionSrc | C_DEDUCTIONSRC | Text(3) |  |  | ค่ำเสียหายส่วนแรก  "ins" = ประกันเรียกเก็บ - ไม่หักจากค่าซ่อม  "rep" = อู่เรียกเก็บ - หักจากค่าซ่อม  "rno" = อู่เรียกเก็บ – ไม่หักจำกค่าซ่อม  “ino” = ไม่เรียกเก็บ | c_deduction_src |
| 30 | C_DEDUCTION | cDeduction | C_DEDUCTIONSRC | Number (18,2) |  |  | ค่ำเสียหำยส่วนแรก (จำนวนเงิน) | c_deduction |
| 31 | REP_OVERALL_PRICE | repOverallPrice | REP_OVERALL_PRICE | Number (18,2) |  |  | ส่วนลดราคาค่าแรงจากอู่ซ่อม | rep_overall_price |
| 32 | INS_OVERALL_PRICE | insOverallPrice | INS_OVERALL_PRICE | Number (18,2) |  |  | ส่วนลดราคาค่าแรงจากประกัน | ins_overall_price |
| 33 | REP_SALE_PART_PRICE | repSalePartPrice | REP_SALE_PART_PRICE | Number (18,2) |  |  | ส่วนลดราคาอะไหล่จากอู่ | rep_sale_part_price |
| 34 | INS_SALE_PART_PRICE | insSalePartPrice | INS_SALE_PART_PRICE | Number (18,2) |  |  | ส่วนลดราคาอะไหล่จากประกัน | ins_sale_part_price |
| 35 | REP_GET_NAME | repGetName | REP_GET_NAME | Text (100) |  |  | ชื่อผู้รับรถ | rep_get_name |
| 36 | REP_FINISH_DATE | repFinishDate | REP_FINISH_DATE | DateTime |  |  | วันที่ซ่อมรถเสร็จ | rep_finish_date |
| 37 | GET_CAR_BACK_DATE | getCarBackDate | GET_CAR_BACK_DATE | DateTime |  |  | วันที่รับรถ | get_car_back_date |
| 38 | GET_CAR_RELATED_INSUREE | getCarRelatedInsuree | GET_CAR_RELATED_INSUREE | Text |  |  | ผู้รับรถเกี่ยวข้องกับผู้เอาประกันเป็น | get_car_related_insuree |
| 39 | GET_CAR_NAME | getCarName | GET_CAR_NAME | Text (100) |  |  | ชื่อผู้รับรถกลับ | get_car_name |
| 40 | ASSIGN_NAME | assignName | ASSIGN_NAME | Text(100) |  |  | เจ้ำหน้ำที่ส่งมอบรถ | assign_name |
| 41 | RELATED_INSUREE_IDCARD | relatedInsureeIdCard | RELATED_INSUREE_IDCARD | Text (20) |  |  | หมายเลขบัตรประชาชน / หมายเลขใบขับขี่ผู้รับรถ | related_insuree_id_card |
| 42 | RELATED_INSUREE_PHONE | relatedInsureePhone | RELATED_INSUREE_PHONE | Text (20) |  |  | หมายเลขโทรศัพท์ผู้รับรถ | related_insuree_phone |
| 43 | DRIVER_MOBILE_GETCAR | driverMobileGetCar | DRIVER_MOBILE_GETCAR | Text (10) |  |  | หมายเลขโทรศัพท์มือถือผู้รับรถ | driver_mobile_get_car |
| 44 | CLAIM_STATUS | claimStatus | CLAIM_STATUS | Picklist |  |  | สถานะเคลม | claim_status |
| 45 | REP_ESTIMATE_DAYS | repEstimateDays | REP_ESTIMATE_DAYS | Number (18,0) |  |  | จำนวนวันที่คาดว่าจะซ่อมเสร็จ | rep_estimate_days |
| 46 | ADD_NO | addNo | ADD_NO | Integer |  |  | ครั้งที่อนุมัติ | add_no |
| 47 | REP_CONTACT_DATE | repContactDate | REP_CONTACT_DATE | DateTime |  |  | วันที่นำรถติดต่อขอซ่อม | rep_contact_date |
| 48 | JOBNO | jobNo | JOBNO | Text(50) |  |  | Job No | job_no |
| 49 | ACC_INSUREE_NAME | accInsureeName | ACC_INSUREE_NAME | Text (120) |  |  | ชื่อผู้เอาประกัน | acc_insuree_name |
| 50 | ACC_DATE | accDate | ACC_DATE | DateTime |  |  | วันที่แจ้งเกิดอุบัติเหตุ | acc_date |
| 51 | ACC_INSURED_VALUE | accInsuredValue | ACC_INSURED_VALUE | Float |  |  | จำนวนเงินคุ้มครอง | acc_insured_value |
| 52 | HEAVY_DAMAGE | heavyDamage | HEAVY_DAMAGE | Integer |  |  | 0= เคลมทั่วไป, 1 = เคลมรถหนัก | heavy_damage |
| 53 | ACC_POLICY_TYPE_ID | accPolicyTypeId | ACC_POLICY_TYPE_ID | Integer |  |  | ประเภทกรมธรรม์  0 = ไม่ระบุ,  1 = ประกันภัยชั้น 1,  2 = ประกันภัยชั้น 2,  3 = ประกันภัยชั้น 3,  4 = พรบ. | acc_policy_type_id |
| 54 | ACC_OCC_DATE | accOccDate | ACC_OCC_DATE | DateTime |  |  | วันที่เกิดอุบัติเหตุ | acc_occ_date |
| 55 | DRIVER_NAME | driverName | DRIVER_NAME | Text (100) |  |  | ชื่อผู้ขับขี่ | driver_name |
| 56 | DRIVER_IDCARD | driverIdCard | DRIVER_IDCARD | Text (20) |  |  | เลขบัตรประชาชน (ผู้ขับขี่) | driver_id_card |
| 57 | DRIVER_PASSPORTNO | driverPassportNo | DRIVER_PASSPORTNO | Text (20) |  |  | เลขที่ใบขับขี่ (ผู้ขับขี่) | driver_passport_no |
| 58 | DRIVER_PHONE_NO | driverPhoneNo | DRIVER_PHONE_NO | Text (30) |  |  | หมายเลขโทรศัพท์ (ผู้ขับขี่) | driver_phone_no |
| 59 | OWN_IDCARD | ownIdCard | OWN_IDCARD | Text(15) |  |  | หมายเลขบัตรประชาชน(ผู้เอาประกันภัย) | own_id_card |
| 60 | OWN_PPT_ID | ownPptId | OWN_PPT_ID | SmallInt |  |  | ประเภทใบขับขี่ (ผู้เอาประกันภัย) | own_ppt_id |
| 61 | OWN_PASSPORTNO | ownPassportNo | OWN_PASSPORTNO | Text(10) |  |  | เลขที่ใบขับขี่ (ผู้เอาประกันภัย) | own_passport_no |
| 62 | OWN_ADDRESS | ownAddress | OWN_ADDRESS | Text(255) |  |  | ที่อยู่ (ผู้เอาประกันภัย) | own_address |
| 63 | OWN_PPN_ISSUE_PLACE | ownPpnIssuePlace | OWN_PPN_ISSUE_PLACE | Text(50) |  |  | สถานที่ออกบัตร(ผู้เอาประกันภัย) | own_ppn_issue_place |
| 64 | OWN_CITY | ownCity | OWN_CITY | Text(50) |  |  | อำเภอ (ผู้เอาประกันภัย) | own_city |
| 65 | OWN_PROVINCEID | ownProvinceId | OWN_PROVINCEID | Integer |  |  | จังหวัด (ผู้เอาประกันภัย) | own_province_id |
| 66 | OWN_PPN_EXPIRE_DATE | ownPpnExpireDate | OWN_PPN_EXPIRE_DATE | DateTime |  |  | วันหมดอายุบัตร (ผู้เอาประกันภัย) | own_ppn_expire_date |
| 67 | OWN_POSTCODE | ownPostcode | OWN_POSTCODE | Text(5) |  |  | รหัสไปรษณีย์ (ผู้เอาประกันภัย) | own_postcode |
| 68 | OWN_HOME_PHONE | ownHomePhone | OWN_HOME_PHONE | Text(30) |  |  | โทรศัพท์ที่บ้าน ที่ทำงาน (ผู้เอาประกันภัย) | own_home_phone |
| 69 | OWN_MOBILE | ownMobilePhone | OWN_MOBILE | Text(20) |  |  | เบอร์มือถือ (ผู้เอาประกันภัย) | own_mobile_phone |
| 70 | OWN_EMAIL | ownEmail | OWN_EMAIL | Text(100) |  |  | อีเมล (ผู้เอาประกันภัย) | own_email |
| 71 | OWN_FAX | ownFax | OWN_FAX | Text(20) |  |  | เบอร์แฟกซ์ (ผู้เอาประกันภัย) | own_fax |
| 72 | CLAIM_TYPE | claimType | CLAIM_TYPE | Picklist |  |  | D = เปิดเคลมที่อู่ C= เคลมต่อเนื่อง | claim_type |
| 73 | BY_WHEN | byWhen | BY_WHEN | DateTime |  |  | วันที่ทำรายการ | by_when |
| 74 | CLAIM_PROP | claimProp | CLAIM_PROP | Text(3000) |  |  | คุณสมบัติของเคลม | claim_prop |
| 75 | CLAIM_DATE | claimDate | CLAIM_DATE | DateTime |  |  | วันที่อู่สร้างเคลม | claim_date |
| 76 | REP_BRING_DATE | repBringDate | REP_BRING_DATE | DateTime |  |  | วันที่นำรถมาซ่อม | rep_bring_date |
| 77 | REP_BRING_NAME | repBringName | REP_BRING_NAME | Text (100) |  |  | ชื่อผู้นำรถมาซ่อม | rep_bring_name |
| 78 | REP_BRING_PHONE | repBringPhone | REP_BRING_PHONE | Text (50) |  |  | หมายเลขโทรศัพท์ผู้นำรถมาซ่อม | rep_bring_phone |
| 79 | REP_BRING_MOBILE | repBringMobile | REP_BRING_MOBILE | Text (10) |  |  | หมายเลขโทรศัพท์มือถือผู้นำรถมาซ่อม | rep_bring_mobile |
| 80 | REP_ACKNOWLEDGE_NAME | repAcknowledgeName | REP_ACKNOWLEDGE_NAME | Text(100) |  |  | ผู้รับรายงาน | rep_acknowledge_name |
| 81 | SUM_LABOR | sumLabor | SUM_LABOR | Number(18,2) |  |  | ค่าแรงก่อน Vat | sum_labor |
| 82 | SUM_PART | sumPart | SUM_PART | Number(18,2) |  |  | ค่าอะไหล่ก่อน Vat | sum_part |
| 83 | SUM_OTHER | sumOther | SUM_OTHER | Number(18,2) |  |  | ค่าใช้จ่ายอื่นๆก่อน Vat | sum_other |
| 84 | ORIGINATORID | originatorId | ORIGINATORID | Integer |  |  | รหัสสาขาศูนย์/อู่ | originator_id |
| 85 | ORIGINATOR_NAME | originatorName | ORIGINATOR_NAME | Text(100) |  |  | ชื่อสาขาศูนย์/อู่ | originator_name |
| 86 | IS_CLAIMCOUNTER | isClaimCounter | IS_CLAIMCOUNTER | Picklist |  |  | Claim Counter 0 = ไม่เป็น Claim Counter 1 = เป็น Claim Counter | is_claim_counter |
| 87 | TXN_LABOR | txnLabor | Labor_Price__c | Array |  |  | รายการค่าแรง TXN_LABOR_CANCEL is included, String to represent array of labor | Table : sf_claim_coverage_txn_labor |
| 87.1 | LABORID | laborId | LABORID | Number |  |  | หมายเลขค่าแรง | labor_id |
| 87.2 | E_GENDESC | eGenDesc | E_GENDESC | Text(100) |  |  | รายการค่าแรง(อังกฤษ) | e_gen_desc |
| 87.3 | T_GENDESC | tGenDesc | T_GENDESC | Text(100) |  |  | รายการค่าแรง(ไทย) | t_gen_desc |
| 87.4 | REP_LEVEL | repLevel | REP_LEVEL | Text(20) |  |  | ระดับความเสียหาย เสนอ | rep_level |
| 87.5 | REL_PRICE | relPrice | REP_PRICE | Number(18,2) |  |  | ราคากลางอู่ | rel_price |
| 87.6 | REP_EDIT_PRICE | repEditPrice | REP_EDIT_PRICE | Number(18,2) |  |  | ราคาเสนอ | rep_edit_price |
| 87.7 | REP_REASON | repReason | REP_REASON | Text(1000) |  |  | ความคิดเห็นอู่ | rep_reason |
| 87.8 | INS_LEVEL | insLevel | INS_LEVEL | Text(20) |  |  | ระดับความเสียหาย อนุมัติ | ins_level |
| 87.9 | INS_PRICE | insPrice | INS_PRICE | Number(18,2) |  |  | ราคากลางประกัน | ins_price |
| 87.10 | INS_EDIT_PRICE | insEditPrice | INS_EDIT_PRICE | Number(18,2) |  |  | ราคาอนุมัติ | ins_edit_price |
| 87.11 | INS_REASON | insReason | INS_REASON | Text(1000) |  |  | ความคิดเห็นประกัน | ins_reason |
| 87.12 | IMAGE_PATH | imagePath | IMAGE_PATH | Text(255) |  |  | ชื่อไฟล์รูปค่าแรง | image_path |
| 87.13 | ADD_NO | addNo | ADD_NO | Number |  |  | ลำดับครั้งที่อนุมัติ | add_no |
| 87.14 | STATUS | status | STATUS | Test(10) |  |  | สถานะ (ไม่อนุมัติ, ขอยกเลิก) | status |
| 87.15 | BY_WHEN | byWhen | BY_WHEN | DateTime |  |  | วันที่ทำรายการ | by_when |
| 87.16 | DELDATE | delDate | DELDATE | DateTime |  |  | วันที่ลบรายการ | del_date |
| 88 | TXN_PARTPRICE | txnPartPrice | Part_Price__c | Array |  |  | รายการค่าอะไหล่ TXN_PARTPRICE_CANCEL is included, String to represent array of labor | Table : sf_claim_coverage_txn_part_price |
| 88.1 | PARTPRICEID | partPriceId | PARTPRICEID | Number |  |  | หมายเลขค่าอะไหล่ | part_price_id |
| 88.2 | CMFGPARTNO | cMFGPartNo | CMFGPARTNO | Text(20) |  |  | หมายเลขอะไหล่ | c_mfg_part_no |
| 88.3 | T_PARTDESC | tPartDesc | T_PARTDESC | Text(255) |  |  | รายการอะไหล่ (ไทย) | t_part_desc |
| 88.4 | E_PARTDESC | ePartDesc | E_PARTDESC | Text(255) |  |  | รายการอะไหล่ (อังกฤษ) | e_part_desc |
| 88.5 | REP_PARTTYPE_DESC_T | repPartTypeDesc | REP_PARTTYPE_DESC_T | Text(255) |  |  | ประเภทอะไหล่ (ไทย) เสนอ | rep_part_type_desc_t |
| 88.6 | REP_PARTTYPE_DESC_E | repPartTypeDesc | REP_PARTTYPE_DESC_E | Text(255) |  |  | ประเภทอะไหล่ (อังกฤษ) เสนอ | rep_part_type_desc_e |
| 88.7 | PART_SHIP | partShip | PART_SHIP | Text(50) |  |  | ผู้จัดอะไหล่ | part_ship |
| 88.8 | FPRICE | fPrice | FPRICE | Number(18,2) |  |  | ราคาอะไหล่เต็ม | f_price |
| 88.9 | PARTNUMBER | partNumber | PARTNUMBER | SmallInt |  |  | จำนวนชิ้นอะไหล่ | part_number |
| 88.10 | REP_PRICE | repPrice | REP_PRICE | Number(18,2) |  |  | ราคากลางอู่ | rep_price |
| 88.11 | REP_EDIT_PRICE | repEditPrice | REP_EDIT_PRICE | Number(18,2) |  |  | ราคาเสนอ | rep_edit_price |
| 88.12 | REP_COMMENT | repComment | REP_COMMENT | Text(1000) |  |  | ความคิดเห็นอู่ | rep_comment |
| 88.13 | INS_PARTTYPE_DESC_T | insPartTypeDescT | INS_PARTTYPE_DESC_T | Text(255) |  |  | ประเภทอะไหล่ (ไทย) อนุมัติ | ins_part_type_desc_t |
| 88.14 | INS_PARTTYPE_DESC_E | insPartTypeDescE | INS_PARTTYPE_DESC_E | Text(255) |  |  | ประเภทอะไหล่ (อังกฤษ) อนุมัติ | ins_part_type_desc_e |
| 88.15 | INS_PRICE | insPrice | INS_PRICE | Number(18,2) |  |  | ราคากลางประกัน | ins_price |
| 88.16 | INS_EDIT_PRICE | insEditPrice | INS_EDIT_PRICE | Number(18,2) |  |  | ราคาอนุมัติ | ins_edit_price |
| 88.17 | DISCOUNT | discount | DISCOUNT | Number(18,2) |  |  | % ส่วนลดแต่ละรายการที่อนุมัติ | discount |
| 88.18 | INSUREE_COMMENT | insureeComment | INSUREE_COMMENT | Text(1000) |  |  | ความคิดเห็นประกัน | insuree_comment |
| 88.19 | ADD_NO | addNo | ADD_NO | Number |  |  | ลำดับครั้งที่อนุมัติ | add_no |
| 88.20 | STATUS | status | STATUS | Test(10) |  |  | สถานะ (ไม่อนุมัติ, ขอยกเลิก) | status |
| 88.21 | BY_WHEN | byWhen | BY_WHEN | DateTime |  |  | วันที่ทำรายการ | by_when |
| 88.22 | DELDATE | delDate | DELDATE | DateTime |  |  | วันที่ลบรายการ | del_date |
| 89 | TXN_OTHER | txnOther | Other_Price__c | Array |  |  | รายการค่าใช้จ่ายอื่นๆ TXN_OTHER_CANCEL is included, String to represent array of labor | Table : sf_claim_coverage_txn_other |
| 89.1 | PARTPRICEID | otherId | OTHERID | Number |  |  | หมายเลขค่าใช้จ่ายอื่นๆ | other_id |
| 89.2 | DESCRIPTION | description | DESCRIPTION | Text(1000) |  |  | รายการ | description |
| 89.3 | PRICE_REP | priceRep | PRICE_REP | Text(1000) |  |  | ราคาเสนออู่ | price_rep |
| 89.4 | PRICE_INS | priceIns | PRICE_INS | Text(1000) |  |  | ราคากลาง | price_ins |
| 89.5 | REP_COMMENT | repCommment | REP_COMMENT | Text(1000) |  |  | ความคิดเห็นอู่ | rep_commment |
| 89.6 | INS_COMMENT | insComment | INS_COMMENT | Text(1000) |  |  | ความคิดเห็นประกัน | ins_comment |
| 89.7 | ADD_NO | addNo | ADD_NO | Number |  |  | ลำดับครั้งที่อนุมัติ | add_no |
| 89.8 | STATUS | status | STATUS | Test(10) |  |  | สถานะ (ไม่อนุมัติ, ขอยกเลิก) | status |
| 89.9 | BY_WHEN | byWhen | BY_WHEN | DateTime |  |  | วันที่ทำรายการ | by_when |
| 89.10 | DELDATE | delDate | DELDATE | DateTime |  |  | วันที่ลบรายการ | del_date |
| 90 | TXN_CLAIM_ACTIVITIES | txnClaimActivities | Activity__c | Array |  |  | ข้อมูลติดตามการทำงาน ของการทำเคลม | Table : sf_claim_coverage_txn_claim_activities |
| 90.1 | CLAIM_ACTID | claimActId | CLAIM_ACTID | Number |  |  | หมายเลข TXN_CLAIM_ACTIVITIES | claim_act_id |
| 90.2 | CLAIM_ACT_DATE | claimActDate | CLAIM_ACT_DATE | DateTime |  |  | วันที่ทำรายการ | claim_act_date |
| 90.3 | USERID | userId | USERID | Number |  |  | รหัสประจำตัวผู้ดำเนินการ | user_id |
| 90.4 | USER_FNAME | userFName | USER_FNAME | Text(255) |  |  | ชื่อผู้ดำเนินการ | user_f_name |
| 90.5 | USER_LNAME | userLName | USER_LNAME | Text(255) |  |  | นามสกุลผู้ดำเนินการ | user_l_name |
| 90.6 | MSTATUS_NAME | mStatusName | MSTATUS_NAME | Text(100) |  |  | สถานะเคลม | m_status_name |
| 90.7 | ROLE_NAME | roleName | ROLE_NAME | Text(255) |  |  | ตำแหน่งที่รับผิดชอบถาดงาน | role_name |
| 90.8 | MEM_NAME | memName | MEM_NAME | Text(255) |  |  | สาขา | mem_name |
| 90.9 | MEM_HEAD_NAME | memHeadName | MEM_HEAD_NAME | Text(255) |  |  | สำนักงานใหญ่ | mem_head_name |
| 90.10 | STATUSID | statusID | STATUSID | Number (9) |  |  | รหัสสถานะเคลม | status_id |
| 91 | TXN_COMMENT | txnComment | Comment__c | Object |  |  | รายการความคิดเห็น |  |
| 91.1 | REP_COMMENT | repComment | REP_COMMENT | Text(3000) |  |  | ความคิดเห็นอู่ | txn_com_rep_comment |
| 91.2 | INS_COMMENT | insComment | INS_COMMENT | Text(6000) |  |  | ความคิดเห็นประกัน | txn_com_ins_comment |
| 92 | TXN_CLAIM_TIME_REPAIR | txnClaimTimeRepaire | Claim_Time_Repair__c | Object |  |  | ข้อมูลระยะเวลาการซ่อม |  |
| 92.1 | REP_TIME_COMMENT | repTimeComment | REP_TIME_COMMENT | Text(2000) |  |  | หมายเหตุ | txn_ctr_rep_time_comment |
| 92.2 | IMAGE_PART | imagePart | IMAGE_PART | Text(1000) |  |  | รูปรับรถ | txn_ctr_image_part |
| 92.3 | DATE_REPAIR | dateRepair | DATE_REPAIR | Decimal(10,0) |  |  | จำนวนวันที่ซ่อม (คำนวณจากค่าแรง) | txn_ctr_date_repair |
| 92.4 | EST_REPAIR_DATE | estRepairDate | EST_REPAIR_DATE | DateTime |  |  | วันที่คาดว่าจะซ่อมเสร็จ | txn_ctr_est_repair_date |
| 92.5 | EDIT_EST_REPAIR_DATE | editEstRepairDate | EDIT_EST_REPAIR_DATE | DateTime |  |  | วันที่คาดว่าจะซ่อมเสร็จที่ถูกแก้ไข | txn_ctr_edit_est_repair_date |
| 93 | TXN_ACCIDENT | txnAccident | Accident__c | Array |  |  | ข้อมูลอุบัติเหตุ | Table : sf_claim_coverage_txn_accident |
| 93.1 | ACC_CMFG | accCMFG | ACC_CMFG | Text(15) |  |  | ยี่ห้อรถยนต์ | acc_c_mfg |
| 93.2 | ACC_CMODEL | accModel | ACC_CMODEL | Text(30) |  |  | รุ่นรถ | acc_model |
| 93.3 | ACC_YEAR | accYear |  | Text(5) |  |  | ปีจดทะเบียนรถ | acc_year |
| 93.4 | GEAR_TYP | gearTyp |  | Text(1) |  |  | ประเภทเกียร์ 1=เกียร์ธรรมดา 2=เกียร์อัตโนมัติ | gear_typ |
| 93.5 | DRIVER_AGE | driverAge |  | SmallInt |  |  | อายุผู้ขับขี่รถประกัน | driver_age |
| 93.6 | DRIVER_BIRTH | driverBirth |  | DateTime |  |  | วันเดือนปีเกิดผู้ขับขี่รถประกัน | driver_birth |
| 93.7 | DRIVER_ADDRESS | driverAddress |  | Text(255 |  |  | ที่อยู่ผู้ขับขี่รถประกัน | driver_address |
| 93.8 | ACC_INSURER_REF | accInsurerRef |  | Text(25) |  |  | หมายเลขอ้างอิงของบริษัทประกัน | acc_insurer_ref |
| 93.9 | POLICY_ST_DATE | policyStDate |  | DateTime |  |  | วันที่เริ่มคุ้มครอง | policy_st_date |
| 93.10 | POLICY_END_DATE | policyEndDate |  | DateTime |  |  | วันที่สิ้นสุดการคุ้มครอง | policy_end_date |
| 93.11 | USED_TYP | userTyp |  | Text(1) |  |  | ประเภทจดทะเบียนรถประกัน 1=ส่วนบุคคล, 2=นิติบุคคล, 3=ราชการ, 4=รัฐวิสาหกิจ | user_typ |
| 93.12 | XUSED_TYP | xUserTyp |  | Text(1) |  |  | ประเภทจดทะเบียนรถคู่กรณี 1=ส่วนบุคคล, 2=นิติบุคคล, 3=ราชการ, 4=รัฐวิสาหกิจ | x_user_typ |
| 93.13 | LIABILITY_TYP | liabilityTyp |  | Text(10) |  |  | รถประกันเป็นฝ่าย 1=ถูก, 2=ผิด, 3=ประมาทร่วม | liability_typ |
| 93.14 | ACC_TIME | accTime |  | Text(10) |  |  | เวลาที่เกิดอุบัติเหตุ | acc_time |
| 93.15 | DRIVER_PPN_ISSUE_PLACE | driverPpnIssuePlace |  | Text(2) |  |  | สถานที่ออกบัตร(จังหวัด) รถประกัน | driver_ppnIssue_place |
| 93.16 | DRIVER_PPN_ISSUE_DATE | driverPpnIssueDate |  | DateTime |  |  | วันที่ออกบัตร รถประกัน | driver_ppnIssue_date |
| 93.17 | DRIVER_NO | driverNo |  | Text(1) |  |  | แบบประกัน - ระบุผู้ขับขี่ 1=ระบุ, 2=ไม่ระบุ | driver_no |
| 93.18 | XDRIVER_NAME | xDriverName |  | Text(100) |  |  | ชื่อผู้ขับขี่รถคู่กรณี | x_driver_name |
| 93.19 | XDRIVER_AGE | xDriverAge |  | SmallInt |  |  | อายุผู้ขับขี่รถคู่กรณี | x_driver_age |
| 93.20 | XDRIVER_BIRTH | xDriverBirth |  | DateTime |  |  | วันเดือนปีเกิดผู้ขับขี่รถคู่กรณี | x_driver_birth |
| 93.21 | XOWNNER_NAME | xOewnerName |  | Text(100) |  |  | ชื่อเจ้าของรถคู่กรณี | x_oewner_name |
| 93.22 | XDRIVER_PASSPORT_NO | xDriverPassportNo |  | Text(15) |  |  | หมายเลขใบขับขี่รถคู่กรณี | x_driver_passport_no |
| 93.23 | XDRIVER_PPN_ISSUE_PLACE | xDriverPpnIssuePlace |  | Text(50) |  |  | สถานที่ออกบัตร รถคู่กรณี | x_driver_ppnIssue_place |
| 93.24 | XDRIVER_PPN_ISSUE_DATE | xDriverPpnIssueDate |  | DateTime |  |  | วันที่อนุญาต | x_driver_ppnIssue_date |
| 93.25 | XDRIVER_ADDRESS | xDriverAddress |  | Text(255) |  |  | ที่อยู่ผู้ขับขี่รถคู่กรณี | x_driver_address |
| 93.26 | XDRIVER_CARDID | xDriverCardId |  | Text(20) |  |  | บัตรประจำตัวประชาชนรถคู่กรณี | x_driver_card_id |
| 93.27 | ACC_RELATED_INSUREE | accRelatedInsuree |  | Text(50) |  |  | ผู้ขับขี่เกี่ยวข้องกับผู้เอาประกันเป็น | acc_related_insuree |
| 93.28 | ACC_XRELATED_INSUREE | accXRelatedInsuree |  | Text(50) |  |  | ความสัมพันธ์กับเจ้าของรถคู่กรณี | acc_x_related_insuree |
| 93.29 | ACC_PLACE | accPlace |  | Text(255) |  |  | สถานที่เกิดเหตุ | acc_place |
| 93.30 | ACC_AMPHUR | accAmphur |  | Text(255) |  |  | เขต/อำเภอสถานที่เกิดเหตุ | acc_amphur |
| 93.31 | ACC_PROVINCE | accProvince |  | Text(255) |  |  | จังหวัดสถานที่เกิดเหตุ | acc_province |
| 93.32 | XCAR_REGNO | xCarRegNo |  | Text(10) |  |  | ทะเบียนรถคู่กรณี | x_car_reg_no |
| 93.33 | XINSURERID | xInsurerId |  | Text(10) |  |  | บริษัทประกันภัยรถคู่กรณี | x_insurer_id |
| 93.34 | ACC_XCMFG | accXCMFG |  | Text(20) |  |  | ยี่ห้อรถยนต์รถคู่กรณี | acc_x_c_mfg |
| 93.35 | ACC_XCMODEL | accXCModel |  | Text(20) |  |  | รุ่นรถ คู่กรณี | acc_x_c_model |
| 93.36 | XPPT_ID | xPPTId |  | Text(2) |  |  | ประเภทใบขับขี่รถคู่กรณี 1=รถยนต์ส่วนบุคคลตลอดชีพ, 2=รถจักรยานยนต์ตลอดชีพ, 3=รถยนต์สามล้อส่วนบุคคลตลอดชีพ, 4=รถยนต์ส่วนบุคคลชนิดชั่วคราว, 5=รถยนต์สามล้อส่วนบุคคลชนิดชั่วคราว, 6=รถจักรยานยนต์ชนิดชั่วคราว, 7=ขับรถยนต์ส่วนบุคคลชนิด (5ปี), 8=ขับรถยนต์สามล้อส่วนบุคคลชนิด (5ปี), 9=รถจักรยานยนต์ (5ปี), 10=รถยนต์สาธารณะ (3ปี), 11=รถยนต์สามล้อสาธารณะ (3ปี), 12=รถบดถนน (5ปี), 13=รถแทรกเตอร์ (5ปี), 14=รถใช้งานเกษตรกรรม, 15=รถระหว่างประเทศสำหรับรถยนต์ส่วนบุคคลหรือรถจักรยานยนต์ | x_ppt_id |
| 93.37 | PPT_ID | pPTId |  | Text(2) |  |  | ประเภทใบขับขี่รถประกัน 1=รถยนต์ส่วนบุคคลตลอดชีพ, 2=รถจักรยานยนต์ตลอดชีพ, 3=รถยนต์สามล้อส่วนบุคคลตลอดชีพ, 4=รถยนต์ส่วนบุคคลชนิดชั่วคราว, 5=รถยนต์สามล้อส่วนบุคคลชนิดชั่วคราว, 6=รถจักรยานยนต์ชนิดชั่วคราว, 7=ขับรถยนต์ส่วนบุคคลชนิด (5ปี), 8=ขับรถยนต์สามล้อส่วนบุคคลชนิด (5ปี), 9=รถจักรยานยนต์ (5ปี), 10=รถยนต์สาธารณะ (3ปี), 11=รถยนต์สามล้อสาธารณะ (3ปี), 12=รถบดถนน (5ปี), 13=รถแทรกเตอร์ (5ปี), 14=รถใช้งานเกษตรกรรม, 15=รถระหว่างประเทศสำหรับรถยนต์ส่วนบุคคลหรือรถจักรยานยนต์ | ppt_id |
| 93.38 | XCCL_ID | xCCLId |  | SmallInt |  |  | สีรถคู่กรณี | x_ccl_id |
| 93.39 | XCLAIMREF_NO | xClaimRefId |  | Text(21) |  |  | เลขที่เคลม รถคู่กรณี | x_claim_ref_id |
| 93.40 | ACC_XCLAIM_REF_NO | accXClaimRefNo |  | Text(20) |  |  | เลขรัขแจ้ง รถคู่กรณี | acc_x_claim_ref_no |
| 93.41 | XPOLICY_TYPE_ID | xPolicyTypeId |  | Integer |  |  | ประเภทกรมธรรม์รถคู่กรณี 1=ประกันภัยชั้น1, 2=ประกันภัยชั้น2, 3=ประกันภัยชั้น3, 4=พ.ร.บ. | x_policy_type_id |
| 93.42 | DOC_REF | docRef |  | Text(200) |  |  | เอกสารอ้างอิง 1=สำเนากรมธรรม์ 2=สำเนาทะเบียนรถ 3=บันทึกประจำวัน 0=สำเนาใบอนุญาติขับขี่ เอกสารอื่นๆที่ user พิมพ์เอง | doc_ref |
| 93.43 | XDRIVER_PHONE_NO | xDriverPhoneNo |  | Text(30) |  |  | เบอร์โทรศัพท์ ผู้ขับขี่รถคู่กรณี | x_driver_phone_no |
| 93.44 | ACC_XPOLICY_NO | accXPolicyNo |  | Text(20) |  |  | เลขกรมธรรม์รถคู่กรณี | acc_x_policy_no |
| 93.45 | LABOR_PRICE | laborPrice |  | Number(18, 2) |  |  | ประมาณค่าซ่อม | labor_price |
| 93.46 | PART_PRICE | partPrice |  | Number(18, 2) |  |  | ประมาณค่าอะไหล่ | part_price |
| 93.47 | RISK_CODE | riskCode |  | Text(6) |  |  | รหัสภัยยานยนต์ | risk_code |
| 93.48 | DRIVER_SEX | driverSex |  | Text(1) |  |  | เพศ ชาย / หญิง - รถประกัน | driver_sex |
| 93.49 | XDRIVER_SEX | xDriverSex |  | Text(1) |  |  | เพศ ชาย / หญิง - รถคู่กรณี | x_driver_sex |
| 93.50 | XDRIVER_PROVINCE | xDriverProvince |  | Text(3) |  |  | จังหวัดรถ รถคู่กรณี | x_driver_province |
| 93.51 | ACC_DESC | accDesc |  | Text(255) |  |  | ลักษณะการเกิดอุบัติเหตุ  0=ชนเสา  1=ถูกก้อนหิน  2=ชนกองวัสดุ  3=ชนต้นไม้  4=ชนฟุตบาท  5=ชนประตู  6=ชนกำแพง  7=ชนรั้ว  8=วัตถุหล่นใส่  9=ชนสัตว์  10=ภัยอื่นๆ  11=จอดไว้ถูกชน  12=ถูกขูดขีด  13=ตกข้างทาง  14=ถูกกลั่นแกล้ง  15=ยางระเบิด  16=ชนคู่กรณีไม่เอาความ  17=คู่กรณีชนแล้วหลบหนี  18=ลักทรัพย์และอุปกรณ์  19=คู่กรณีเฉี่ยวชน  20=รถน้ำท่วม  สำเหตุอื่นๆ ที่ user พิมพ์เอง | acc_desc |
| 93.52 | LABOR_DETAIL | laborDetial |  | Text(200) |  |  | รายการค่าซ่อม  L0=กันชนหน้ำ  L1=กันชนหลัง  L2=ฝากระโปรงหน้า  L3=ฝากระโปรงหลัง  L4=บังโคลนหน้าซ้าย  L5=บังโคลนหน้าขวา  L6=บังโคลนหลังซ้าย  L7=บังโคลนหลังขวา  L8=ประตูหน้ำซ้าย  L9=ประตูหน้ำขวา  L10=ประตูหลังซ้าย  L11=ประตูหลังขวา  L12=กระจังหน้า  L13=แผงข้างกระบะ  L14=แผงข้างตัวถังด้านมีประตูเลื่อน (รถตู้)  L15=แผงข้างตัวถังด้านไม่มีประตูเลื่อน (รถตู้)  L16=หลังคา | labor_detial |
| 93.53 | PART_DETAIL | partDetail |  | Text(200) |  |  | รายการค่าอะไหล่  P0=ไฟใหญ่หน้าซ้าย  P1=ไฟใหญ่หน้าขวา  P2=ไฟเลี้ยวหน้าซ้าย  P3=ไฟเลี้ยวหน้าขวา  P4=ไฟหรี่หน้าซ้าย  P5=ไฟหรี่หน้าขวา  P6=ไฟเลี้ยวกันชนหน้าซ้าย  P7=ไฟเลี้ยวกันชนหน้าขวา  P8=ไฟท้ายซ้าย  P9=ไฟท้ำยขวา  P10=กระจกมองข้างซ้าย  P11=กระจกมองข้างขวา  P12=กระจกบังลมหน้า  P13=กระจกบังลมหลัง | part_detail |
| 94 | TXN_CLAIMCOUNTER | txnClaimCounter | Claim_Counter_Detail__c | Array |  |  | ข้อมูลเคลมเคาน์เตอร์ | Table : sf_claim_coverage_txn_claim_counter |
| 94.1 | CC_LOGID | ccLogId |  | Number(10,0) |  |  | หมายเลข ลำดับข้อมูล | cc_log_id |
| 94.2 | CCID | ccId |  | Integer |  |  | หมายเลข ลำดับข้อมูล | cc_id |
| 94.3 | REPID | repId |  | Text(13) |  |  | * กรณี บริษัทประกันภัยที่มีการ Map Patee Code เฉพาะคู่ค้าที่ไม่มีในระบบ EMCS | rep_id |
| 94.4 | ACC_INS_NAME | accInsName |  | Text(100) |  |  | ชื่อผู้เอาประกัน | acc_ins_name |
| 94.5 | ACC_INS_TEL | accInsTel |  | Text(30) |  |  | หมายเลขโทรศัพท์ ของผู้เอาประกัน | acc_ins_tel |
| 94.6 | CONTACTNAME | contactName |  | Text(100) |  |  | ชื่อผู้มาติดต่อ | contact_name |
| 94.7 | CONTACTTEL | contactTel |  | Text(30) |  |  | หมายเลขโทรศัพท์ ของผู้มาติดต่อ | contact_tel |
| 94.8 | ATTORNEY | attorney |  | Text(1) |  |  | ผู้มาติดต่อเป็นผู้รับมอบอำนาจ Y= ใช่ | attorney |
| 94.9 | CHECKCAR | checkCar |  | Text(1) |  |  | ตรวจสภาพหลังซ่อม | check_car |
| 94.10 | CHECK_BACKPART | checkBackPart |  | Text(1) |  |  | ตรวจสอบคืนซากอะไหล่ Y=คือนซาก N=ไม่คืนซาก | check_back_part |
| 94.11 | REP_NONLIST_NAME | repNonlistName |  | Text(100) |  |  | ชื่ออู่-ศูนย์ / ทำจ่าย | rep_nonlist_name |
| 94.12 | REP_NONLIST_ADDRESS | repNonlistAddress |  | Text(255) |  |  | ที่อยู่อู่-ศูนย์ / สถานที่จัดส่งอะไหล่ | rep_nonlist_address |
| 94.13 | REP_NONLIST_TEL | repNonlintTel |  | Text(50) |  |  | เบอร์โทรศัพท์อู่-ศูนย์ | rep_nonlint_tel |
| 94.14 | GETMONEY | getMoney |  | Text(1) |  |  | วิธีการจ่ายเงิน Null = ไม่ระบุ, M= เงินสด, T= โอนเงินเข้าบัญชี, C=สั่งจ่ายเช็ค | get_money |
| 94.15 | TOTAL_COST | totalCost |  | Float |  |  | ยอดเงินรวม | total_cost |
| 94.16 | GET_ADDRESS | getAddress |  | Text(255) |  |  | สถานที่ติดต่อ ผู้รับเงิน | get_address |
| 94.17 | GET_TEL | getTel |  | Text(30) |  |  | เบอร์โทรศัพท์ ผู้รับเงิน | get_tel |
| 94.18 | GET_IDCARD | getIdCard |  | Text(20) |  |  | บัตรประชาชนเลขที่ ผู้รับเงิน | get_id_card |
| 94.19 | GET_NAME | getName |  | Text(100) |  |  | ชื่อผู้มาติดต่อ รับเงิน | get_name |
| 94.20 | GET_CHEQNAME | getCheqName |  | Text(100) |  |  | สั่งจ่ายเช็คในนาม | get_cheq_name |
| 94.21 | BANK_ID | bankId |  | Text(3) |  |  | รหัสธนาคาร เช่น 002 | bank_id |
| 94.22 | BANK_NAME | bankName |  | Text(100) |  |  | ธนาคาร - สาขา เช่น ธนาคารกสิการไทย สาขาสีลม | bank_name |
| 94.23 | BANK_BRANCH_ID | bankBranchId |  | Text(4) |  |  | รหัสสาขาธนาคาร เช่น 0118 | bank_branch_id |
| 94.24 | BANK_BRANCH_NAME | bankBranchName |  | Text(80) |  |  | ชื่อสาขา เช่น สาขาสีลม | bank_branch_name |
| 94.25 | GET_IDBOOKBANK | getIdBookBank |  | Text(50) |  |  | เลขที่บัญชีธนาคาร เช่น 123-456-789-0 | get_id_book_bank |
| 94.26 | GET_NAMEBOOKBANK | getNameBookBank |  | Text(100) |  |  | ชื่อบัญชีธนาคาร เช่น นางสาวสุดสวย ใจดี | get_name_book_bank |
| 94.27 | GET_CONTACTNAME | getContactName |  | Text(100) |  |  | ชื่อผู้มาติดต่อ | get_contact_name |
| 94.28 | CHECKCAR_DATE | checkCarDate |  | DateTIme |  |  | วันที่ตรวจสภาพระ | check_car_date |
| 94.29 | GETCHECK_DATE | getCheckDate |  | DateTIme |  |  | วันที่นัดรับเช็ค | get_check_date |
| 94.30 | COMMENT_CHECKCAR | commentCheckCar |  | Text(100) |  |  | ความเห็น ของผู้ตรวจสภาพรถ | comment_check_car |
| 94.31 | CHECKCAR_NAME | checkCarName |  | Text(100) |  |  | ชื่อผู้ตรวจสภาพรถ | check_car_name |
| 94.32 | GET_MONEYNAME | getMoneyName |  | Text(100) |  |  | ชื่อผู้รับเงิน | get_money_name |
| 94.33 | ASSET_TYPE | assetType |  | Text(50) |  |  | ประเภททรัพย์สิน | asset_type |
| 94.34 | ASSET_NAME | assetName |  | Text(100) |  |  | ชื่อเจ้าของทรัพย์สิน | asset_name |
| 94.35 | ASSET_ADDRESS | assetAddress |  | Text(200) |  |  | ที่อยู่เจ้าของทรัพย์สิน | asset_address |
| 94.36 | ASSET_TEL | assetTel |  | Text(20) |  |  | เบอร์ติดต่อเจ้าของทรัพย์สิน | asset_tel |
| 94.37 | ASSET_DETAIL | assetDetail |  | Text(200) |  |  | รายละเอียดความเสียหาย | asset_detail |
| 94.38 | INJURED_NAME | injuredName |  | Text(50) |  |  | ชื่อผู้บาดเจ็บ | injured_name |
| 94.39 | INJURED_AGE | injuredIdAge |  | SmallInt |  |  | อายุผู้บาดเจ็บ | injured_id_age |
| 94.40 | INJURED_IDCARD | injuredIdCard |  | Text(15) |  |  | เลขที่บัตรประชาชนผู้บาดเจ็บ | injured_id_card |
| 94.41 | INJURED_ADDRESS | injuredAddress |  | Text(100 |  |  | ที่อยู่ผู้บาดเจ็บ | injured_address |
| 94.42 | INJURED_TEL | injuredTel |  | Text(20) |  |  | เบอร์โทรศัพท์ผู้บาดเจ็บ | injured_tel |
| 94.43 | INJURED_HOSPITAL | injuredHospital |  | Text(50) |  |  | เข้ารับการรักษาพยาบาลที่สถานที่พยาบาล | injured_hospital |
| 94.44 | INJURED_TIME | injuredTime |  | Text(50) |  |  | ระยะเวลาที่ใช้ในการรักษา | injured_time |
| 94.45 | INJURED_ST | injuredSt |  | DateTIme |  |  | รักษาพยาบาลตั้งแต่วันที่ | injured_st |
| 94.46 | INJURED_END | injuredEnd |  | DateTime |  |  | รักษาพยาบาลถึงวันที่ | injured_end |
| 94.47 | INJURED_DETAIL | injuredDetail |  | Text(200) |  |  | รายละเอียดการรักษา | injured_detail |
| 94.48 | CLAIMCOUNTER_TYPE | claimCounterType |  | Text(1) |  |  | ประเภทเคลมเคาน์เตอร์ 1 = รถยนต์ | claim_counter_type |
| 95 | TXN_CAR_ONREPAIR | txnCarOnRepair | Car_On_Repair__c | Array |  |  |  | Table : sf_claim_coverage_txn_car_on_repair |
| 95.1 | Id | Id |  | Number |  |  | เลขที่อ้างอิง (PK) | id |
| 95.2 | InOut_CarId | inOutCarId |  | Text(20) |  |  | เลขที่ใบรับรถ | in_out_car_id |
| 95.3 | Car_OnRepair | carOnRepair |  | Text(1) |  |  | ลูกค้าใช้รถระหว่างซ่อม (0=ไม่ใช้, 1=ใช้) | car_on_repair |
| 95.4 | C_RegNo | cRegNo |  | Text(20) |  |  | ทะเบียนรถลูกค้าใช้ | c_reg_no |
| 95.5 | Use_date | useDate |  | DateTIme |  |  | วันทีใช้รถ | use_date |
| 95.6 | Use_Time | useTime |  | Text(20) |  |  | เวลาใช้ | use_time |
| 95.7 | Return_date | returnDate |  | DateTIme |  |  | วันที่คืน | return_date |
| 95.8 | Retun_Time | returnTime |  | Text(20) |  |  | เวาลาที่คืน | return_time |
| 95.9 | Km_Start | kmStart |  | Number(18) |  |  | หมายเลข กม. เริ่มต้น | km_start |
| 95.10 | Km_finish | kmFinish |  | Number(18) |  |  | หมายเลข กม. สิ้นสุด | km_finish |
| 95.11 | UseCar_name | useCarName |  | Text(100) |  |  | ชื่อ-สกุล ผู้ใช้รถ | use_car_name |
| 95.12 | ReturnCar_name | returnCarName |  | Text(100) |  |  | ชื่อ-สกุล ผู้คืนรถ | return_car_name |
| 95.13 | Image_part | imagePart |  | Text(1000) |  |  | รูปเอกสารใบรับ-ส่งรถใช้ระหว่างซ่อม | image_part |

### Example Request

| No | Update Payment | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Claim Coverage Log ID | claimLogId |  | Text(20) | Y |  |  |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 297)
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

### Example / Code Payload (Row 298)
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
