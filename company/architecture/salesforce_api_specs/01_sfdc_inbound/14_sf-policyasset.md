# [14] SF-PolicyAsset

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-PolicyAsset`
- **Total Rows Parsed**: `70`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpolicyasset`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | /services/apexrest/upsertpolicyasset |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Upsert Policy Asset |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field | GCP Remark |  | 5.0 |  |  | AI |  |  | CR21 |  |
| 0 |  |  |  | Array |  |  |  |  |  |  |  | 0 |  |  | 0 |  |  | 0 |
| 1 | Asset ID | assetId | External_ID__c | Text(18) | Y | Y | Unique ID Asset | Policy_No | Policy_No + '-A01' |  | assetId | 1 |  | assetId | 1 |  | assetId | 1 |
| 2 | InsurancePolicyId | insurancePolicyId | InsurancePolicyId | Master-Detail(Insurance Policy) | Y | Y | เลขที่ของ  Policy Id | Policy_No |  |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |
| 3 | AssetName | assetName | AssetName | Text(255) |  |  | The insured customer property. | Brand + Model + Year |  |  | assetName | 1 |  | assetName | 1 |  | assetName | 1 |
| 6 | IsActive | isActive | IsActive | Boolean |  |  | Indicates whether the insurance policy asset is active. Default False |  | Fix active |  | isActive | 1 |  | isActive | 1 |  | isActive | 1 |
| 8 | Asset Attribute | assetAttribute | vlocity_ins_fsc__AttributesSelectedValues__c | Object |  | Y | Attribute of asset |  |  |  | assetAttribute | 1 |  | assetAttribute | 1 |  | assetAttribute | 1 |
| 8.1 | Brand | avMake |  | Text(255) |  |  |  | Brand |  |  | avMake | 1 |  | avMake | 1 |  | avMake | 1 |
| 8.2 | Model | avModel |  | Text(255) |  |  |  | Model |  |  | avModel | 1 |  | avModel | 1 |  | avModel | 1 |
| 8.3 | Year | avYear |  | Text(255) |  |  |  | Year |  |  | avYear | 1 |  | avYear | 1 |  | avYear | 1 |
| 8.4 | Year Tariff | yearTariff |  | Percent (6,4) |  |  |  |  |  |  | yearTariff | 1 |  | yearTariff | 1 |  | yearTariff | 1 |
| 8.5 | Color | avColor |  | Text(255) |  |  |  | Car_color |  |  | avColor | 1 |  | modelYear | 0 |  | modelYear | 0 |
| 8.6 | Color ID | avColorID |  | Text(255) |  |  | รหัสจาก CMI Realtime |  |  |  | avColorID | 1 |  | vehicleCode | 0 |  | vehicleCode | 0 |
| 8.7 | License Number | avLicNum |  | Text(255) |  |  |  |  |  |  | avLicNum | 1 |  | avColor | 1 |  | avColor | 1 |
| 8.8 | Lincense State | avLicState |  | Text(255) |  |  |  |  |  |  | avLicState | 1 |  | avColorID | 1 |  | avColorID | 1 |
| 8.9 | Vin | avVin |  | Text(255) |  |  |  |  |  |  | avVin | 1 |  | avLicNum | 1 |  | avLicNum | 1 |
| 8.10 | Body Type | avBodyType |  | Text(255) |  |  |  | BodyType |  |  | avBodyType | 1 |  | avLicState | 1 |  | avLicState | 1 |
| 8.11 | CC | avCC |  | Text(255) |  |  | CC ที่ลูกค้ากรอก |  |  |  | avCC | 1 |  | avVin | 1 |  | avVin | 1 |
| 8.12 | CC Range | carCc |  | Text(255) |  |  | CC ช่วงสำหรับ Tariff |  |  |  | carCc | 1 |  | avBodyType | 1 |  | avBodyType | 1 |
| 8.13 | CC Tariff | carCcTariff |  | Percent (6,4) |  |  |  |  |  |  | carCcTariff | 1 |  | avCC | 1 |  | avCC | 1 |
| 8.14 | License Type | carLicenseType |  | Text(255) |  |  |  |  |  |  | carLicenseType | 1 |  | carCc | 1 |  | carCc | 1 |
| 8.15 | Comp Code | compCode |  | Text(255) |  |  | ประเภทการใช้รถ (พรบ) |  |  |  | compCode | 1 |  | carCcTariff | 1 |  | carCcTariff | 1 |
| 8.16 | Usage | usage |  | Integer |  |  | ประเภทการใช้รถ (สมัครใจ) |  |  |  | usage | 1 |  | seatingCapacity | 0 |  | seatingCapacity | 0 |
| 8.17 | Usage Tariff | usageTariff |  | Percent (6,4) |  |  |  |  |  |  | usageTariff | 1 |  | vehicleWeight | 0 |  | vehicleWeight | 0 |
| 8.18 | Group | carGroup |  | Text(255) |  |  | กลุ่มรถยนต์จาก Tariff |  |  |  | carGroup | 1 |  | transmissionType | 0 |  | transmissionType | 0 |
| 8.19 | Group Tariff | carGroupTariff |  | Percent (6,4) |  |  |  |  |  |  | carGroupTariff | 1 |  | carLicenseType | 1 |  | carLicenseType | 1 |
| 8.20 | Flag CCTV | cctvFlag | Have_Camera__c | Boolean |  |  | TRUE = มีส่วนลดกล้อง ,FALSE = ไม่มีส่วนลด |  |  |  | cctvFlag | 1 |  | compCode | 1 |  | compCode | 1 |
| 8.21 | CCTV Percent Discount | cctvPercent | Camera_Percent_Discount__c | Percent (6,4) |  |  | % ส่วนลดที่ได้จากการเลือกส่วนลดกล้องติดรถ |  |  |  | cctvPercent | 1 |  | usage | 1 |  | usage | 1 |
| 8.22 | Flag Accessory | accessFlag |  | Boolean |  |  | TRUE = มีความคุ้มครองอุปกรณ์ตกแต่ง ,FALSE = ไม่มีอุปกรณ์ตกแต่ง |  |  |  | accessFlag | 1 |  | usageTariff | 1 |  | usageTariff | 1 |

### Example / Code Payload (Row 40)
**8.23**
**Accessory Code**
**accessCode**
**Array(Text)**
```json
["wheel","skirt","pipe"]
```
**accessCode**
**1**
**carGroup**
**1**
**carGroup**
**1**

| 8.24 | Accessory Name TH | accessName | Col4 | Text | Col6 | Col7 | เช่น ล้อ,สเกริตรอบคัน,ท่อ | Col9 | Col10 | Col11 | accessName | 1 | Col14 | carGroupTariff | 1 | Col17 | carGroupTariff | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 9 | LicNumber | licNum | LicNumber__c | Text(255) |  |  | ทะเบียนรถ | Car_license_no |  |  | licNum | 1 |  | cctvFlag | 1 |  | cctvFlag | 1 |
| 10 | License Province | licProvice | License_Province__c | Text(2) |  |  | จังหวัดของทะเบียนรถ (Format เป็นตัวย่อ) | Car_license_provice |  |  | licProvice | 1 |  | cctvPercent | 1 |  | cctvPercent | 1 |
| 11 | Chassis No | chassisNo | Chassis_No__c | Text(30) |  |  | หมายเลขตัวถัง | Car_serial_no |  |  | chassisNo | 1 |  | accessFlag | 1 |  | accessFlag | 1 |
| 12 | Engine No | engineNo | Engine_No__c | Text(50) |  |  | หมายเลขเครื่องยนต์ |  |  |  | engineNo | 1 |  | specialEquipmentDescription | 0 |  | specialEquipmentDescription | 0 |
| 13 | Primary Participant | participantID | PrimaryPolicyParticipantId | Text(18) | Y |  |  |  |  |  | participantID | 1 |  | accessCode | 1 |  | accessCode | 1 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | accessName | 1 |  | accessName | 1 |

### Example / Code Payload (Row 48)
**Example Request**
```json
[
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
  ]
```
**licNum**
**1**
**carPrice**
**0**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | licProvice | 1 | Col17 | carPriceDate | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| No | Upsert Policy Asset |  |  |  |  |  |  |  |  |  |  |  |  | chassisNo | 1 |  | licNum | 1 |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |  |  |  |  |  |  | engineNo | 1 |  | licProvice | 1 |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |  |  |  |  |  |  | participantID | 1 |  | chassisNo | 1 |
| 2 | Message | message |  | Text(1000) |  | Y |  |  |  |  |  |  |  | chargerInsuranceValue | 0 |  | engineNo | 1 |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |  |  |  |  |  |  | evChargerSerialNumber | 0 |  | participantID | 1 |
| 4 | Result | result |  | Array |  | Y |  |  |  |  |  |  |  | evChargerPrice | 0 |  | chargerInsuranceValue | 0 |
| 4.1 | Asset ID | assetId | ID | Text(18) | Y |  | Using for Update Asset Detail |  |  |  |  |  |  | evChargerBrand | 0 |  | evChargerSerialNumber | 0 |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |  |  |  |  |  |  | evChargerModel | 0 |  | evChargerPrice | 0 |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |  |  |  |  |  |  | otherEvChargerDetails | 0 |  | evChargerBrand | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | batterySerialNumber | 0 |  | evChargerModel | 0 |

### Example / Code Payload (Row 60)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "assetId": "2cK5x000001Paj3ZMS",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```
**batteryPrice**
**0**
**otherEvChargerDetails**
**0**

### Example / Code Payload (Row 61)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "assetId": "0cY4x000000Twj3EAC",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "assetId": "0cY4x000000Twj6EAC",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
**batteryBrand**
**0**
**batterySerialNumber**
**0**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | batteryModel | 0 | Col17 | batteryPrice | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | batteryReplacementDate | 0 |  | batteryBrand | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | otherBatteryDetails | 0 |  | batteryModel | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | vehiclePriceAtInsuranceYear | 0 |  | batteryReplacementDate | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | horsePower | 0 |  | otherBatteryDetails | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 0 |  | vehiclePriceAtInsuranceYear | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | horsePower | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 0 |
|  |  |  |  |  |  |  |  |  |  | 34 |  | 34 |  |  | 34 |  |  | 34 |
