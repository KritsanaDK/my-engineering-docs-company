# [08] SF-Policy

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-Policy`
- **Total Rows Parsed**: `120`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpolicy`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### compulsoryPolicy

### Request Message

### END POINT

| URL | /services/apexrest/upsertpolicy |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 | Col20 | Col21 | Col22 | Col23 | Col24 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Upsert Policy |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field | GCP Remark |  | 5.0 |  | isExisted | AI |  |  |  | SFDC | isExist 4.0 |  | CR21 |  |  |
| 1 | Policy Number | policyNumber | Name, External_ID__c | Text(255) | Y | Y | เลขที่ของ  Policy | Policy_No Car_Act_No |  |  | policyNumber | 1 |  | policyNumber | 1 |  |  | policyNumber | 1 |  | policyNumber | 1 |  |
| 2 | Account | accountID | NameInsuredId | Text(18) | Y | Y | Unique ID Account |  |  |  | accountID | 1 |  | accountID | 1 |  |  | compulsoryPolicy | 1 |  | accountID | 1 |  |
| 3 | Compulsory Policy | compulsoryPolicy | Compulsory__c | Text(18) | Y |  | เลขที่กรมธรรม์ของ พรบ. (กรณีซื้อพร้อมกันส่งมาก่อน สมัครใจ) | Car_Act_No | กรณีซื้อพร้อมพรบ |  | compulsoryPolicy | 1 |  | requestID | 0 | 1 |  | accountID | 1 |  | requestID | 0 | AI |
| 4 | PolicyName | policyName | PolicyName | Text(255) |  |  | ชื่อกรมธรรม์ที่ซื้อ ประกอบด้วย ชั้นประกัน + ซ่อมที่ไหน + Brand + Model + Year | ประกันชั้น' + Type + ซ่อม + GarageType + Brand + Model + Year | ex. ประกันชั้น 1 ซ่อม G Honda Accord 2013 |  | policyName | 1 |  | compulsoryPolicy | 1 |  |  | requestID | 0 | AI | compulsoryPolicy | 1 |  |
| 5 | EffectiveDate | effectiveDate | EffectiveDate | Date/Time |  | Y | The date from which the policy is in effect. | Policy_Startdate |  |  | effectiveDate | 1 |  | policyName | 1 |  |  | agentId | 0 | AI | policyName | 1 |  |
| 6 | ExpirationDate | expirationDate | ExpirationDate | Date/Time |  | Y | The date on which the policy expires. (Actual) | Policy_Enddate |  |  | expirationDate | 1 |  | effectiveDate | 1 |  |  | policyName | 1 |  | effectiveDate | 1 |  |
| 7 | Extend Startdate | extendStartdate | Extend_Startdate__c | Date/Time |  |  | วันที่สิ้นสุดกรมธรรม์ตอนซื้อ (Original) |  |  |  | extendStartdate | 1 |  | expirationDate | 1 |  |  | effectiveDate | 1 |  | expirationDate | 1 |  |
| 8 | PremiumAmount | premiumAmount | PremiumAmount, StandardPremiumAmount | Currency(16, 2) |  |  | The premium paid by the policy owner for the current billing period. | GCP - Total_Amt |  |  | premiumAmount | 1 |  | extendStartdate | 1 |  |  | expirationDate | 1 |  | extendStartdate | 1 |  |
| 9 | Base Premium | basePremium | Base_Premium__c | Currency(16, 2) |  |  | เบี้ยพื้นฐาน |  |  |  | basePremium | 1 |  | premiumAmount | 1 |  |  | extendStartdate | 1 |  | premiumAmount | 1 |  |
| 10 | Base Premium V5 | basePremiumV5 | Base_Premium_V5__c | Currency(16, 2) |  |  | เบี้ยพื้นฐาน (ร.ย.ภ.10) |  |  |  | basePremiumV5 | 1 |  | basePremium | 1 |  |  | premiumAmount | 1 |  | basePremium | 1 |  |
| 11 | PaymentDueDate | paymentDueDate | PaymentDueDate | Date/Time |  |  | The date on which the next payment of the premium is due. | Payment_Date |  |  | paymentDueDate | 1 |  | basePremiumV5 | 1 |  |  | basePremium | 1 |  | basePremiumV5 | 1 |  |
| 12 | CancellationDate | cancellationDate | CancellationDate | Date/Time |  |  | The date on which the insurance policy was canceled. |  |  |  | cancellationDate | 1 |  | paymentDueDate | 1 |  |  | basePremiumV5 | 1 |  | paymentDueDate | 1 |  |
| 13 | Renewal Policy | renewalPolicy | RenewedFromPolicyId | Text(18) |  |  |  |  |  |  | renewalPolicy | 1 |  | cancellationDate | 1 |  |  | paymentDueDate | 1 |  | cancellationDate | 1 |  |
| 14 | RenewalDate | renewalDate | RenewalDate | Date/Time |  |  | The date on which the policy is expected to be renewed. The actual renewal date may  be different |  |  |  | renewalDate | 1 |  | renewalPolicy | 1 |  |  | cancellationDate | 1 |  | renewalPolicy | 1 |  |
| 15 | PolicyDescription | policyDescription | PolicyDescription | Long Text Area(32000) |  |  | The description of the insurance policy. |  |  |  | policyDescription | 1 |  | renewalDate | 1 |  |  | renewalPolicy | 1 |  | renewalDate | 1 |  |
| 16 | Status | status | Status | Picklist |  | Y |  | Policy_Status | ACT, INC รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง // ประกันชั้น 2+3+ รยภ 00 ยกเลิก |  | status | 1 |  | policyDescription | 1 |  |  | renewalDate | 1 |  | policyDescription | 1 |  |
| 17 | Need Car Inspect | needCarInspect | Need_Car_Inspect__c | Boolean |  |  |  | Car_Inspect_Status |  |  | needCarInspect | 1 |  | status | 1 |  |  | policyDescription | 1 |  | status | 1 |  |
| 18 | PlanTier | planTier | PlanTier | Picklist |  | Y | The class that the insurance policy belongs to. For example, silver, gold, or platinum. | GCP - Type |  |  | planTier | 1 |  | needCarInspect | 1 |  |  | status | 1 |  | needCarInspect | 1 |  |
| 19 | PolicyType | policyType | PolicyType | Picklist |  | Y | The type of the insurance policy. For example, home, auto, annuity, or life. Fix Auto |  |  |  | policyType | 1 |  | planTier | 1 |  |  | needCarInspect | 1 |  | planTier | 1 |  |
| 20 | Policy Sub Type | policySubType | Policy_Sub_Type__c | Picklist |  | Y | ภาคบังคับ (พ.ร.บ.) ภาคสมัครใจ |  | แยกตาม Policy_No หรือ Car_Act_No |  | policySubType | 1 |  | policyType | 1 |  |  | subStatus | 0 | ??? | policyType | 1 |  |
| 21 | GarageType | garageType | Garage_Type__c | Text(255) |  |  | ประเภทสถานที่ซ่อม ซ่อมอู่ หรือ ซ่อมศูนย์ จาก Master Data |  |  |  | garageType | 1 |  | policySubType | 1 |  |  | planTier | 1 |  | policySubType | 1 |  |
| 22 | Driver Age Range | driverAgeRange | Driver_Age_Range__c | Text(255) |  |  | ช่วงอายุผู้ขับขี่ |  |  |  | driverAgeRange | 1 |  | garageType | 1 |  |  | policyType | 1 |  | garageType | 1 |  |
| 23 | Driver Age Discount | driverAgeDiscount | Driver_Age_Discount__c | Number (6,4) |  |  | ส่วนลดผู้ขับขี่ |  |  |  | driverAgeDiscount | 1 |  | driverAgeRange | 1 |  |  | policySubType | 1 |  | driverAgeRange | 1 |  |
| 24 | Driver Age Tariff | driverAgeTariff | Driver_Age_Tariff__c | Percent(16, 2) |  |  | Tariff อายุผู้ขับขี่ |  |  |  | driverAgeTariff | 1 |  | driverAgeDiscount | 1 |  |  | garageType | 1 |  | driverAgeDiscount | 1 |  |
| 25 | Total SI | siTotal | SI_Total__c | Currency(16, 2) |  |  | ทุนประกันรถรวมทุนประกันอุปกรณ์ตกแต่ง (SI (OD/FT) + SI_Access) |  |  |  | siTotal | 1 |  | driverAgeTariff | 1 |  |  | driverAgeRange | 1 |  | driverAgeTariff | 1 |  |
| 26 | SI Tariff | siTariff | SI_Tariff__c | Percent (6,4) |  |  | Tariff ทุนประกันรวม |  |  |  | siTariff | 1 |  | siTotal | 1 |  |  | driverAgeDiscount | 1 |  | siTotal | 1 |  |
| 27 | SI V5 Tariff | siV5Tariff | SI_V5_Tariff__c | Percent (6,4) |  |  | Tariff ทุนประกันรวม เพิ่มเติมสำหรับ 2+,3+ |  |  |  | siV5Tariff | 1 |  | siTariff | 1 |  |  | driverAgeTariff | 1 |  | siTariff | 1 |  |
| 28 | Total Amt exclude mv | totalAmtExcludeMv | Total_Amount_Exclude_mv__c | Currency(16, 2) |  |  |  | Total_Amt_exclude_mv | เบี้ยประกันตามความคุ้มครองหลัก |  | totalAmtExcludeMv | 1 |  | siV5Tariff | 1 |  |  | siTotal | 1 |  | siV5Tariff | 1 |  |
| 29 | Premium V5 OD | premiumV5Od | Premium_V5_OD__c | Currency(16, 2) |  |  | เบี้ยประกันสำหรับ 2+3+ |  |  |  | premiumV5Od | 1 |  | totalAmtExcludeMv | 1 |  |  | siTariff | 1 |  | totalAmtExcludeMv | 1 |  |
| 30 | Total Amt mv | totalAmtMv | Total_Amt_mv__c | Currency(16, 2) |  |  |  | Total_Amt_mv | เบี้ยประกันตามเอกสารแนบท้าย |  | totalAmtMv | 1 |  | premiumV5Od | 1 |  |  | siV5Tariff | 1 |  | premiumV5Od | 1 |  |
| 31 | Fleet Discount Percent | fleetDiscountPercent | Fleet_Discount_Percent__c | Number(16,2) |  |  | % ส่วนลดกลุ่ม |  |  |  | fleetDiscountPercent | 1 |  | totalAmtMv | 1 |  |  | totalAmtExcludeMv | 1 |  | totalAmtMv | 1 |  |
| 32 | Fleet Discount Amount | fleetDiscAmt | Fleet_Disc_Amt__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดกลุ่ม | Fleet_Disc_Amt | ราคาส่วนลดกลุ่ม |  | fleetDiscAmt | 1 |  | firstDamageDiscountOnVehicle | 0 |  |  | premiumV5Od | 1 |  | firstDamageDiscountOnVehicle | 0 | ไม่ใช้ |
| 33 | NCB Discount Percent | ncbDiscountPercent | NCB_Discount_Percent__c | Number(16,2) |  |  | % ส่วนลดประวัติดี |  |  |  | ncbDiscountPercent | 1 |  | firstDamageDiscountOnProperty | 0 |  |  | totalAmtMv | 1 |  | firstDamageDiscountOnProperty | 0 | ไม่ใช้ |
| 34 | NCB Disc Amt | ncbDiscAmt | NCB_Disc_Amt__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดประวัติดี | NCB_Disc_Amt | ราคาส่วนลดประวัติดี |  | ncbDiscAmt | 1 |  | fleetDiscountPercent | 1 |  |  | fleetDiscountPercent | 1 |  | fleetDiscountPercent | 1 |  |
| 35 | Other Discount Percent | OtherDiscountPercent | Other_Discount_Percent__c | Number(16,2) |  |  | % ส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |  |  |  | OtherDiscountPercent | 1 |  | fleetDiscAmt | 1 |  |  | fleetDiscAmt | 1 |  | fleetDiscAmt | 1 |  |
| 36 | Other Discount Amount | otherDiscAmt | Other_Disc_Amt__c | Currency(16, 2) |  |  | จำนวนเงินส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ | Other_Disc_Amt | ราคาส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |  | otherDiscAmt | 1 |  | ncbDiscountPercent | 1 |  |  | ncbDiscountPercent | 1 |  | ncbDiscountPercent | 1 |  |
| 37 | Extend Date Premium Amount | extendPremAmt | Extend_Date_Premium__c | Number(16,2) |  |  | เบี้ยประกันขยายวันคุ้มครองสิ้นสุด |  |  |  | extendPremAmt | 1 |  | ncbDiscAmt | 1 |  |  | ncbDiscAmt | 1 |  | ncbDiscAmt | 1 |  |
| 38 | Promotion Code | promoCode | Promotion_Code__c | Text(255) |  |  | รหัส Promo Code ที่ลูกค้ากรอกตอนซื้อ |  |  |  | promoCode | 1 |  | OtherDiscountPercent | 1 |  |  | OtherDiscountPercent | 1 |  | OtherDiscountPercent | 1 |  |
| 39 | Promotion Group | promoGroup | Promotion_Group__c | Text(255) |  |  | ชื่อ Campaign |  |  |  | promoGroup | 1 |  | otherDiscAmt | 1 |  |  | otherDiscAmt | 1 |  | otherDiscAmt | 1 |  |
| 40 | Promotion Code Percent | promoCodePer | Promotion_Code_Percent__c | Decimal(16,2) |  |  | Percent ของ Promo Code |  |  |  | promoCodePer | 1 |  | additionalPremiumPercentageOver200 | 0 |  |  | extendPremAmt | 1 |  | additionalPremiumPercentageOver200 | 0 | ไม่ใช้ |
| 41 | Promotion Code Amount | promoCodeAmt | Promotion_Code_Amount__c | Decimal(16,2) |  |  | Amount ของ Promo Code |  |  |  | promoCodeAmt | 1 |  | claimHistoryIncreaseOver200 | 0 |  |  | promoCode | 1 |  | claimHistoryIncreaseOver200 | 0 | ไม่ใช้ |
| 42 | Promotion Code Premium | promoPremium | Promotion_Code_Premium__c | Text(255) |  |  | ชื่อสินค้าที่เป็นของแถม |  |  |  | promoPremium | 1 |  | extendPremAmt | 1 |  |  | promoGroup | 1 |  | extendPremAmt | 1 |  |
| 43 | Promotion Code Premium Description | promoPremiumDesc | Promotion_Code_Premium_Description__c | Text(500) |  |  | รายละเอียดสินค้าที่เป็นของแถม |  |  |  | promoPremiumDesc | 1 |  | promoCode | 1 |  |  | promoCodePer | 1 |  | promoCode | 1 |  |
| 44 | No Cancel Flag | noCancelFlag | No_Cancel_Flag__c | Text(1) |  |  | Y = ห้ามสลักหลังยกเลิก , N = สามารถสลักหลังยกเลิกได้ |  |  |  | noCancelFlag | 1 |  | promoGroup | 1 |  |  | promoCodeAmt | 1 |  | promoGroup | 1 |  |
| 45 | No Cancel Reason | noCancelReason | No_Cancel_Reason__c | Text(500) |  |  | เหตุผลในการห้ามสลักหลังยกเลิก |  |  |  | noCancelReason | 1 |  | promoCodePer | 1 |  |  | promoPremium | 1 |  | promoCodePer | 1 |  |
| 46 | No Cancel Date | noCancelAt | No_Cancel_Date__c | datetime |  |  | เวลาที่ update ห้ามสลักหลังยกเลิก |  |  |  | noCancelAt | 1 |  | promoCodeAmt | 1 |  |  | promoPremiumDesc | 1 |  | promoCodeAmt | 1 |  |
| 47 | Total Disc Amt | totalDiscAmt | Total_Disc_Amt__c | Currency(16, 2) |  |  |  | Total_Disc_Amt | ราคารวมส่วนลด Fleet + NCB + Other |  | totalDiscAmt | 1 |  | promoPremium | 1 |  |  | noCancelFlag | 1 |  | promoPremium | 1 |  |
| 48 | Perm Amt | permAmt | Perm_Amt__c | Currency(16, 2) |  |  |  | Perm_Amt | เบี้ยประกันสุทธิ |  | permAmt | 1 |  | promoPremiumDesc | 1 |  |  | noCancelReason | 1 |  | promoPremiumDesc | 1 |  |
| 49 | Duty Amt | dutyAmt | Duty_Amt__c | Currency(16, 2) |  |  |  | Duty_Amt | อากรแสตมป์ |  | dutyAmt | 1 |  | noCancelFlag | 1 |  |  | noCancelAt | 1 |  | noCancelFlag | 1 |  |
| 50 | Vat Amt | vatAmt | Vat_Amt__c | Currency(16, 2) |  |  |  | Vat_Amt | ภาษีมูลค่าเพิ่ม |  | vatAmt | 1 |  | noCancelReason | 1 |  |  | totalDiscAmt | 1 |  | noCancelReason | 1 |  |
| 51 | Vat Percent | vatPer | Vat_Percent__c | Currency(6, 4) |  |  |  |  |  |  | vatPer | 1 |  | noCancelAt | 1 |  |  | permAmt | 1 |  | noCancelAt | 1 |  |
| 52 | Total Amt | totalAmt | Total_Amt__c | Currency(16, 2) |  |  |  | Total_Amt | เบี้ยประกันรวม |  | totalAmt | 1 |  | totalDiscAmt | 1 |  |  | dutyAmt | 1 |  | totalDiscAmt | 1 |  |
| 53 | Deli_Flag | deliFlag | Delivery_Flag__c | Text(1) |  |  | Y = จัดส่งรูปเล่มกรมธรรม์, N = ไม่จัดส่งรูปเล่มกรมธรรม์ | Flag_Deli | y = จัดส่งรูปเล่มกรมธรรม์, n = ไม่จัดส่งรูปเล่มกรมธรรม์ |  | deliFlag | 1 |  | permAmt | 1 |  |  | vatAmt | 1 |  | permAmt | 1 |  |
| 54 | Deli_Addr | deliAddr | Delivery_Address__c | Text(255) |  |  | ที่อยู่สำหรับจัดส่งกรมธรรม์ | Deli_Addr | ที่อยู่สำหรับจัดส่งกรมธรรม์ |  | deliAddr | 1 |  | dutyAmt | 1 |  |  | vatPer | 1 |  | dutyAmt | 1 |  |
| 55 | Deli_subdistrict_id | deliSubdistrictId | Delivery_Subdistrict_ID__c | Int(32) |  |  | รหัส แขวง/ตำบลสำหรับจัดส่งกรมธรรม์ | Deli_subdistrict_id | แขวง/ตำบลสำหรับจัดส่งกรมธรรม์ |  | deliSubdistrictId | 1 |  | vatAmt | 1 |  |  | totalAmt | 1 |  | vatAmt | 1 |  |
| 56 |  | deliSubdistrict | Delivery_Subdistrict__c | Text(255) |  |  | แขวง/ตำบลสำหรับจัดส่งกรมธรรม์ |  |  |  | deliSubdistrict | 1 |  | vatPer | 1 |  |  | deliFlag | 1 |  | vatPer | 1 |  |
| 57 | Deli_district_id | deliDistrictId | Delivery_District_ID__c | Int(32) |  |  | รหัส เขต/อำเภอสำหรับจัดส่งกรมธรรม์ | Deli_district_id | เขต/อำเภอสำหรับจัดส่งกรมธรรม์ |  | deliDistrictId | 1 |  | totalAmt | 1 |  |  | deliAddr | 1 |  | totalAmt | 1 |  |
| 58 |  | deliDistrict | Delivery_District__c | Text(255) |  |  | เขต/อำเภอสำหรับจัดส่งกรมธรรม์ |  |  |  | deliDistrict | 1 |  | deliFlag | 1 |  |  | deliSubdistrictId | 1 |  | deliFlag | 1 |  |
| 59 | Deli_province_id | deliProvinceId | Delivery_Province_ID__c | Int(32) |  |  | รหัส จังหวัดสำหรับจัดส่งกรมธรรม์ | Deli_province_id | จังหวัดสำหรับจัดส่งกรมธรรม์ |  | deliProvinceId | 1 |  | deliAddr | 1 |  |  | deliSubdistrict | 1 |  | deliAddr | 1 |  |
| 60 |  | deliProvince | Delivery_Province__c | Text(255) |  |  | จังหวัดสำหรับจัดส่งกรมธรรม์ |  |  |  | deliProvince | 1 |  | deliSubdistrictId | 1 |  |  | deliDistrictId | 1 |  | deliSubdistrictId | 1 |  |
| 61 | Deli_zipcode | deliZipcode | Delivery_Zipcode__c | Text(45) |  |  | รหัสไปรษณีย์สำหรับจัดส่งกรมธรรม์ | Deli_zipcode | รหัสไปรษณีย์สำหรับจัดส่งกรมธรรม์ |  | deliZipcode | 1 |  | deliSubdistrict | 1 |  |  | deliDistrict | 1 |  | deliSubdistrict | 1 |  |
| 62 | Policy Coverage | policyCoverage |  | Array |  |  | Ref |  |  |  | policyCoverage | 1 |  | deliDistrictId | 1 |  |  | deliProvinceId | 1 |  | deliDistrictId | 1 |  |
| 63 | Policy Participant | policyParticipant |  | Array |  |  | Ref |  |  |  | policyParticipant | 1 |  | deliDistrict | 1 |  |  | deliProvince | 1 |  | deliDistrict | 1 |  |
| 64 | Policy Asset | policyAsset |  | Array |  |  | Ref |  |  |  | policyAsset | 1 |  | deliProvinceId | 1 |  |  | deliZipcode | 1 |  | deliProvinceId | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  | salesChannel | 0 | 1 | deliProvince | 1 |  |  | salesChannel | 0 | 5.0 | deliProvince | 1 |  |

### Example / Code Payload (Row 77)
**Example Request**
```json
{
  "vatPer": 7,
  "vatAmt": 111.37,
  "totalDiscAmt": 1349,
  "totalAmtMv": 291,
  "totalAmtExcludeMv": 2642,
  "totalAmt": 1702.37,
  "subStatus": null,
  "status": "ACT",
  "siV5Tariff": null,
  "siTotal": 0,
  "siTariff": null,
  "renewalPolicy": null,
  "renewalDate": null,
  "promoPremiumDesc": null,
  "promoPremium": null,
  "promoGroup": null,
  "promoCodePer": 0,
  "promoCodeAmt": 0,
  "promoCode": null,
  "premiumV5Od": 0,
  "premiumAmount": 1702.37,
  "policyType": "Auto",
  "policySubType": "ภาคสมัครใจ",
  "policyParticipant": [
    {
      "totalTermAmount": null,
      "totalStandardAmount": null,
      "termTaxAmount": null,
      "termPremiumAmount": null,
      "termFeeAmount": null,
      "standardTaxAmount": null,
      "standardPremiumAmount": null,
      "standardFeeAmount": null,
      "role": "Owner",
      "relationship": null,
      "productId": null,
      "participantID": "MV-0024-A-000237-Owner",
      "isPolicyholder": null,
      "isMinorBeneficiary": false,
      "isActiveParticipant": true,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "contactInfo": {
        "zipcode": "18260",
        "village": null,
        "subdistrictId": 976,
        "subdistrict": "ทับกวาง",
        "salutation": "นางสาว",
        "road": null,
        "provinceId": 10,
        "province": "สระบุรี",
        "occupation": null,
        "mobilePhone": "",
        "lastname": "เด่นดี (Owner)",
        "firstname": "ดาวเด่น",
        "email": null,
        "driverLicenseNo": null,
        "districtId": 124,
        "district": "แก่งคอย",
        "citizenId": "3872337778158",
        "building": null,
        "birthdate": "1995-09-06T00:00:00Z",
        "alley": null,
        "addressNo": "55"
      },
      "contactID": null,
      "beneType": null,
      "beneficiarySharePercentage": null,
      "accountID": "001O2000007X8AyIAK"
    },
    {
      "totalTermAmount": null,
      "totalStandardAmount": null,
      "termTaxAmount": null,
      "termPremiumAmount": null,
      "termFeeAmount": null,
      "standardTaxAmount": null,
      "standardPremiumAmount": null,
      "standardFeeAmount": null,
      "role": "Payer",
      "relationship": null,
      "productId": null,
      "participantID": "MV-0024-A-000237-Payer",
      "isPolicyholder": null,
      "isMinorBeneficiary": false,
      "isActiveParticipant": true,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "contactInfo": {
        "zipcode": null,
        "village": null,
        "subdistrictId": null,
        "subdistrict": null,
        "salutation": null,
        "road": null,
        "provinceId": null,
        "province": null,
        "occupation": null,
        "mobilePhone": "0917305968",
        "lastname": "Santeh (Payer)",
        "firstname": "Panida",
        "email": "panida.s@extend-it-resource.com",
        "driverLicenseNo": null,
        "districtId": null,
        "district": null,
        "citizenId": null,
        "building": null,
        "birthdate": null,
        "alley": null,
        "addressNo": null
      },
      "contactID": null,
      "beneType": null,
      "beneficiarySharePercentage": null,
      "accountID": "001O2000007X81FIAS"
    }
  ],
  "policyNumber": "MV-0024-A-000237",
  "policyName": "ประกันชั้น 3 Toyota Camry 2021",
  "policyDescription": "ประกันชั้น 3 Toyota Camry 2021",
  "policyCoverage": [
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 460.64,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 1000000,
      "coverageName": "ค่ารักษาพยาบาลคู่กรณี ต่อคน",
      "coverageID": "MV-0024-A-000237-TPBI",
      "coverageCode": "TPBI",
      "coverageAttribute": {
        "Prem": "460.64",
        "SI": "1000000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 921.27,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 2500000,
      "coverageName": "ค่าทรัพย์สินคู่กรณี ต่อครั้ง",
      "coverageID": "MV-0024-A-000237-TPPD",
      "coverageCode": "TPPD",
      "coverageAttribute": {
        "Prem": "921.27",
        "SI": "2500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 125,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 500000,
      "coverageName": "ประกันอุบัติเหตุ",
      "coverageID": "MV-0024-A-000237-MV01",
      "coverageCode": "MV01",
      "coverageAttribute": {
        "Prem": "125.00",
        "SI": "500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 125,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 500000,
      "coverageName": "ค่ารักษาพยาบาลบุคคลในรถ ",
      "coverageID": "MV-0024-A-000237-MV02",
      "coverageCode": "MV02",
      "coverageAttribute": {
        "Prem": "125.00",
        "SI": "500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 41,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 500000,
      "coverageName": "ค่าประกันตัวผู้ขับขี่",
      "coverageID": "MV-0024-A-000237-MV03",
      "coverageCode": "MV03",
      "coverageAttribute": {
        "Prem": "41.00",
        "SI": "500000.00"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    },
    {
      "totalStandardAmount": null,
      "tariff": null,
      "premiumAmount": 0,
      "insurancePolicyId": "MV-0024-A-000237",
      "expirationDate": "2025-01-11T00:00:00.000Z",
      "effectiveDate": "2024-01-10T00:00:00.000Z",
      "deductibleAmount": 10000000,
      "coverageName": "ค่ารักษาพยาบาลคู่กรณี ต่อครั้ง",
      "coverageID": "MV-0024-A-000237-TPBI_E",
      "coverageCode": "TPBI_E",
      "coverageAttribute": {
        "Prem": "0",
        "SI": "10000000.0000"
      },
      "category": "Coverage",
      "assetId": "MV-0024-A-000237-A01"
    }
  ],
  "policyAsset": [
    {
      "totalTermAmount": null,
      "totalStandardAmount": null,
      "productId": null,
      "participantID": null,
      "licProvice": "กรุงเทพมหานคร",
      "licNum": "7กต3273",
      "isActive": true,
      "insurancePolicyId": "MV-0024-A-000237",
      "engineNo": "MRHES16803P402XXX",
      "description": null,
      "chassisNo": "MRHES16803P402XXX",
      "assetName": "Toyota Camry 2021",
      "assetId": "MV-0024-A-000237-A01",
      "assetAttribute": {
        "yearTariff": 100,
        "usageTariff": 100.0000,
        "usage": 110,
        "compCode": "1.10",
        "cctvPercent": 5,
        "cctvFlag": true,
        "carLicenseType": "ป้ายขาว",
        "carGroupTariff": 100.0000,
        "carGroup": "3",
        "carCcTariff": null,
        "carCc": "",
        "avYear": "2021",
        "avVin": "MRHES16803P402XXX",
        "avValue": null,
        "avSymbol": null,
        "avStyle": null,
        "avStabillization": null,
        "avRestraints": null,
        "avRatedDriverUM": null,
        "avRatedDriverName": null,
        "avRatedDriverCOMP": null,
        "avRatedDriverCOLL": null,
        "avRatedDriverBIPD": null,
        "avRateddDriverMEDD": null,
        "avModel": "Camry",
        "avMileage": null,
        "avMake": "Toyota",
        "avLicState": "กรุงเทพมหานคร",
        "avLicNum": "7กต3273",
        "avHistoric": null,
        "avGaragePostalCode": null,
        "avColor": "น้ำเงิน",
        "avClaimSev": null,
        "avClaimFrequency": null,
        "avCC": "2500",
        "avBrakes": null,
        "avBodyType": "เก๋ง 2 ตอน",
        "avAntiTheft": null,
        "avAltFuel": null,
        "accessName": "",
        "accessFlag": false,
        "accessCode": null
      }
    }
  ],
  "planTier": "3",
  "permAmt": 1584,
  "paymentDueDate": "2024-01-09T10:40:21.000Z",
  "OtherDiscountPercent": 10,
  "otherDiscAmt": 176,
  "noCancelReason": null,
  "noCancelFlag": "N",
  "noCancelAt": null,
  "needCarInspect": true,
  "ncbDiscountPercent": 40,
  "ncbDiscAmt": 1173,
  "garageType": "G",
  "fleetDiscountPercent": 0,
  "fleetDiscAmt": 0,
  "extendStartdate": "2025-01-11T09:30:00.000Z",
  "extendPremAmt": 0,
  "expirationDate": "2025-01-11T09:30:00.000Z",
  "effectiveDate": "2024-01-10T17:01:00.000Z",
  "dutyAmt": 7,
  "driverAgeTariff": 100,
  "driverAgeRange": "Unnamed",
  "driverAgeDiscount": 0,
  "deliZipcode": "",
  "deliSubdistrictId": null,
  "deliSubdistrict": "",
  "deliProvinceId": null,
  "deliProvince": "",
  "deliFlag": "N",
  "deliDistrictId": null,
  "deliDistrict": "",
  "deliAddr": "",
  "compulsoryPolicy": "MC-0024-A-000102",
  "cancellationDate": null,
  "basePremiumV5": 3500,
  "basePremium": 2201.5089,
  "accountID": "001O2000007X8AyIAK"
}
```
**subChannel**
**0**
**1**
**deliZipcode**
**1**
**subChannel**
**0**
**5.0**
**deliZipcode**
**1**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | paymentProvider | 0 | 1 | policyCoverage | 1 | Col17 | Col18 | paymentProvider | 0 | 5.0 | policyCoverage | 1 | Col24 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| No | Upsert Policy |  |  |  |  |  |  |  |  |  | paymentOption | 0 | 1 | policyParticipant | 1 |  |  | paymentOption | 0 | 5.0 | policyParticipant | 1 |  |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |  |  |  | paymentRemark | 0 | 1 | policyAsset | 1 |  |  | paymentRemark | 0 | 5.0 | policyAsset | 1 |  |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |  |  |  |  |  |  | agentId | 0 |  |  |  |  |  | agentId | 0 |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |  |  | 64 |  | 64 |  |  | 64 |  |  |  |  |  | requestId | 0 | ไม่ใช้ |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |  |  |  |  |  |  |  |  |  |  |  |  |  | notiId | 0 | ไม่ใช้ |
| 4 | Policy Number | policyNumber | Name, External_ID__c | Text(255) | Y |  | เลขที่ของ  Policy ใช้สำหรับแก้ไข Policy |  |  |  |  |  |  |  |  |  |  |  |  |  | customerType | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | coporateInsuredBranch | 0 | ไม่ใช้ |

### Example / Code Payload (Row 86)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "policyNumber": "1234567890"
}
```
**contractDate**
**0**
**ไม่ใช้**

### Example / Code Payload (Row 87)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53"
}
```
**policyPrintFax**
**0**
**ไม่ใช้**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 | Col20 | Col21 | notificationDateAD | 0 | ไม่ใช้ |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | notificationTime | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | previousInsuranceCompanyName | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | previousInsurancePolicyNumber | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | insuranceTypeCode | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | insuranceTypeName | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceNamePrefix | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceFirstName | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceLastName | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceHouseNumebr | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceMoo | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceBuildingVillage | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceAlley | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceSoi | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceRoad | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceSubDistrict | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceDistrict | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceMinorDistrict | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoiceProvinceCode | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | taxInvoicePostalCode | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | receiptIssueDate | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | receiptNumber | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | photoCapture | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | salesTeam | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | remark | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | esy | 0 | ไม่ใช้ |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | oicVersion | 0 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | scPremiumAmt | 0 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | policyCreatedDate | 0 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | premiumVersion | 0 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorSummary | 0 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorTariff | 0 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorDiscount | 0 |  |
