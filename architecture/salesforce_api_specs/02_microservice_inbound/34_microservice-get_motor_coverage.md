# [34] Microservice-Get Motor Coverage

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Get Motor Coverage`
- **Total Rows Parsed**: `62`

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

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |  | 5.0 |  |  | AI | CR 21 |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | Example Data |  |  |  |  |  |  |  |  |
| 1 | Function API | fn |  |  | Text |  | Fix : getMotorCoverage |  |  | fn | 1 |  | ไม่มีแก้ | fn | 1 |  |
| 2 | Policy Number | insurancePolicyId | Policy_Number__c | Text(255) | Y | Y | เลขที่ของ  Policy Id  สำหรับค้นหา Type, GarageType , Usage | MV-0023-F-000706 |  | insurancePolicyId | 1 |  |  | insurancePolicyId | 1 |  |
| 3 | Car Brand | carBrand |  | Text(255) |  | Y | ยี่ห้อรถ | Toyota |  | carBrand | 1 |  |  | carBrand | 1 |  |
| 4 | Car Model | carModel |  | Text(255) |  | Y | รุ่นรถ | Vios |  | carModel | 1 |  |  | carModel | 1 |  |
| 5 | Car Year | carYear |  | Integer |  | Y | ปีที่ผลิด | 2023 |  | carYear | 1 |  |  | carYear | 1 |  |
| 6 | Car Group | carGroup |  | Text(255) |  |  | กลุ่มรถ (IIA) |  |  | carGroup | 1 |  |  | carGroup | 1 |  |
| 7 | Car CC Condition | carCcCondition |  | Text(255) |  |  | ช่วงซีซีรถที่มีผลต่อการคำนวณเบี้ย |  |  | carCcCondition | 1 |  |  | carCcCondition | 1 |  |
| 8 | Named Age | namedAge |  | Text(255) |  | Y | ช่วงอายุผู้ขับขี่ที่มีผลต่อการคำนวณเบี้ย อายุน้อยสุดคำนวณจาก Driver 2 คน |  |  | namedAge | 1 |  |  | namedAge | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  | 8 |  |  | par1DriverNo | 0 | ไม่ใช้แล้ว |

### Example / Code Payload (Row 22)
**Example Request**
```json
{
  "fn": "getMotorCoverage",
  "insurancePolicyId": "MV-0023-H-000513",
  "carBrand": "Ford",
  "carModel": "EcoSport",
  "carYear": 2019,
  "carGroup": "4",
  "carCcCondition": "<=2000",
  "namedAge": "Unnamed"
}
```
**par1CitizenId**
**0**
**CR 21**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | par1Consent | 0 | CR 21 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| No | Insert Policy Transaction |  |  |  |  |  |  |  |  |  |  |  |  | par2DriverNo | 0 | ไม่ใช้แล้ว |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |  |  |  |  |  |  | par2CitizenId | 0 | CR 21 |
| 1 | Response title | title |  | Text(50) |  | Y |  |  |  | title | 1 |  |  | par2Consent | 0 | CR 21 |
| 2 | Status code | status |  | Int |  | Y |  |  |  | status | 1 |  |  | par3DriverNo | 0 | ไม่ใช้แล้ว |
| 3 | Description | description |  | Text(500) |  | Y |  |  |  | description | 1 |  |  | par3CitizenId | 0 | CR 21 |
| 4 | Data | data |  | Array |  |  |  |  |  | data | 1 |  |  | par3Consent | 0 | CR 21 |
| 4.1 | Coverage List | coverageList |  | Array |  |  |  |  |  | coverageList | 1 |  |  | par4DriverNo | 0 | ไม่ใช้แล้ว |
| 4.1.1 | Coverage Code | coverageCode |  | Text(255) | Y |  | รหัสความคุ้มครอง (OD/FT = SI) |  |  | coverageCode | 1 |  |  | par4CitizenId | 0 | CR 21 |
| 4.1.2 | Possible Value | possibleValue |  | Array |  |  | ค่าที่สามารถเลือกได้ |  |  | possibleValue | 1 |  |  | par4Consent | 0 | CR 21 |
| 4.1.2.1 | Sum Insure | si |  | Decimal(16,2) |  |  | ทุนประกัน |  |  | si | 1 |  |  | par5DriverNo | 0 | ไม่ใช้แล้ว |
| 4.1.2.2 | Tariff | tariff |  | Percent (6,4) |  |  | Factor สำหรับคำนวณเบี้ยประกันหลัก SI, Access, TPPD, TPBI, TPBI_E |  |  | tariff | 1 |  |  | par5CitizenId | 0 | CR 21 |
| 4.1.2.3 | Amount | amount |  | Decimal(16,2) |  |  | เบี้ยประกันสำหรับเบี้ยแนบ MV01, MV02, MV03 |  |  | amount | 1 |  |  | par5Consent | 0 | CR 21 |
| 4.2 | Sum Insured Master | si_detail |  | Array |  |  | ทุนประกันรถยนต์ SI + Access |  |  | si_detail | 1 |  |  | premiumVersion | 0 | CR 21 |
| 4.2.1 | Sum Insured | si |  | Decimal(16,2) |  |  |  |  |  | si | 1 |  |  |  | 8 |  |
| 4.2.2 | Tariff | tariff |  | Percent (6,4) |  |  |  |  |  | tariff | 1 |  |  | title | 1 |  |
| 4.3 | Base Premium V5 Master | si_base_v5_detail |  | Array |  |  | ทุนประกันรถยนต์ SI + Access สำหรับ ประกันชั้น 2+ 3+ ไม่รวมกับ SI ปกติ |  |  | si_base_v5_detail | 1 |  |  | status | 1 |  |
| 4.2.1 | Sum Insured | si |  | Decimal(16,2) |  |  |  |  |  | si | 1 |  |  | description | 1 |  |
| 4.2.2 | Tariff | tariff |  | Percent (6,4) |  |  |  |  |  | tariff | 1 |  |  | data | 1 |  |
| 4.3 | Coverage Status | success |  | Bool |  |  |  |  |  | success | 1 |  |  | coverageList | 1 |  |
| 4.4 | Coverage Alert Message | message |  | Text |  |  |  |  |  | message | 1 |  |  | coverageCode | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  | 18 |  |  | possibleValue | 1 |  |

### Example / Code Payload (Row 45)
**Example Response
(Success)**
```json
{
  "title": "Success",
  "status": 200,
  "description": "",
  "result": {
    "coverageList": [
      {
        "coverageCode": "SI",
        "possibleValue": [
          {
            "si": 480000
          },
          {
            "si": 540000
          },
          {
            "si": 600000
          },
          {
            "si": 660000
          },
          {
            "si": 720000
          }
        ]
      },
      {
        "coverageCode": "Access",
        "possibleValue": [
          {
            "si": 10000
          },
          {
            "si": 20000
          },
          {
            "si": 30000
          }
        ]
      },
      {
        "coverageCode": "TPPD",
        "possibleValue": [
          {
            "si": 1000000,
            "tariff": 100.8
          },
          {
            "si": 2500000,
            "tariff": 101.1
          },
          {
            "si": 5000000,
            "tariff": 101.55
          }
        ]
      },
      {
        "coverageCode": "TPBI",
        "possibleValue": [
          {
            "si": 500000,
            "tariff": 100
          },
          {
            "si": 1000000,
            "tariff": 101
          },
          {
            "si": 1500000,
            "tariff": 102
          }
        ]
      },
      {
        "coverageCode": "TPBI_E",
        "possibleValue": [
          {
            "si": "10000000",
            "tariff": 100
          }
        ]
      },
      {
        "coverageCode": "MV01",
        "possibleValue": [
          {
            "si": 100000
          },
          {
            "si": 200000
          },
          {
            "si": 500000
          }
        ]
      },
      {
        "coverageCode": "MV02",
        "possibleValue": [
          {
            "si": 100000
          },
          {
            "si": 200000
          },
          {
            "si": 500000
          }
        ]
      },
      {
        "coverageCode": "MV03",
        "possibleValue": [
          {
            "si": 200000
          },
          {
            "si": 300000
          },
          {
            "si": 500000
          }
        ]
      }
    ],
    "si_detail": [
      {
        "si": 50000,
        "tariff": 100
      },
      {
        "si": 60000,
        "tariff": 100
      },
      {
        "si": 70000,
        "tariff": 100
      },
      {
        "si": 80000,
        "tariff": 100
      },
      {
        "si": 90000,
        "tariff": 100
      },
      {
        "si": 100000,
        "tariff": 100
      },
      {
        "si": 110000,
        "tariff": 102
      },
      {
        "si": 120000,
        "tariff": 104
      },
      {
        "si": 130000,
        "tariff": 106
      },
      {
        "si": 140000,
        "tariff": 108
      },
      {
        "si": 150000,
        "tariff": 110
      },
      {
        "si": 160000,
        "tariff": 112
      },
      {
        "si": 170000,
        "tariff": 114
      },
      {
        "si": 180000,
        "tariff": 116
      },
      {
        "si": 190000,
        "tariff": 118
      },
      {
        "si": 200000,
        "tariff": 120
      },
      {
        "si": 210000,
        "tariff": 123
      },
      {
        "si": 220000,
        "tariff": 126
      },
      {
        "si": 230000,
        "tariff": 129
      },
      {
        "si": 240000,
        "tariff": 132
      },
      {
        "si": 250000,
        "tariff": 135
      },
      {
        "si": 260000,
        "tariff": 138
      },
      {
        "si": 270000,
        "tariff": 141
      },
      {
        "si": 280000,
        "tariff": 144
      },
      {
        "si": 290000,
        "tariff": 147
      },
      {
        "si": 300000,
        "tariff": 150
      },
      {
        "si": 310000,
        "tariff": 153
      },
      {
        "si": 320000,
        "tariff": 156
      },
      {
        "si": 330000,
        "tariff": 159
      },
      {
        "si": 340000,
        "tariff": 162
      },
      {
        "si": 350000,
        "tariff": 165
      },
      {
        "si": 360000,
        "tariff": 168
      },
      {
        "si": 370000,
        "tariff": 171
      },
      {
        "si": 380000,
        "tariff": 174
      },
      {
        "si": 390000,
        "tariff": 177
      },
      {
        "si": 400000,
        "tariff": 180
      },
      {
        "si": 410000,
        "tariff": 183
      },
      {
        "si": 420000,
        "tariff": 186
      },
      {
        "si": 430000,
        "tariff": 189
      },
      {
        "si": 440000,
        "tariff": 192
      },
      {
        "si": 450000,
        "tariff": 195
      },
      {
        "si": 460000,
        "tariff": 198
      },
      {
        "si": 470000,
        "tariff": 201
      },
      {
        "si": 480000,
        "tariff": 204
      },
      {
        "si": 490000,
        "tariff": 207
      },
      {
        "si": 500000,
        "tariff": 210
      },
      {
        "si": 510000,
        "tariff": 212
      },
      {
        "si": 520000,
        "tariff": 214
      },
      {
        "si": 530000,
        "tariff": 216
      },
      {
        "si": 540000,
        "tariff": 218
      },
      {
        "si": 550000,
        "tariff": 220
      },
      {
        "si": 560000,
        "tariff": 222
      },
      {
        "si": 570000,
        "tariff": 224
      },
      {
        "si": 580000,
        "tariff": 226
      },
      {
        "si": 590000,
        "tariff": 228
      },
      {
        "si": 600000,
        "tariff": 230
      },
      {
        "si": 610000,
        "tariff": 232
      },
      {
        "si": 620000,
        "tariff": 234
      },
      {
        "si": 630000,
        "tariff": 236
      },
      {
        "si": 640000,
        "tariff": 238
      },
      {
        "si": 650000,
        "tariff": 240
      },
      {
        "si": 660000,
        "tariff": 242
      },
      {
        "si": 670000,
        "tariff": 244
      },
      {
        "si": 680000,
        "tariff": 246
      },
      {
        "si": 690000,
        "tariff": 248
      },
      {
        "si": 700000,
        "tariff": 250
      },
      {
        "si": 710000,
        "tariff": 252
      },
      {
        "si": 720000,
        "tariff": 254
      },
      {
        "si": 730000,
        "tariff": 256
      },
      {
        "si": 740000,
        "tariff": 258
      },
      {
        "si": 750000,
        "tariff": 260
      },
      {
        "si": 760000,
        "tariff": 262
      },
      {
        "si": 770000,
        "tariff": 264
      },
      {
        "si": 780000,
        "tariff": 266
      },
      {
        "si": 790000,
        "tariff": 268
      },
      {
        "si": 800000,
        "tariff": 270
      },
      {
        "si": 810000,
        "tariff": 272
      },
      {
        "si": 820000,
        "tariff": 274
      },
      {
        "si": 830000,
        "tariff": 276
      },
      {
        "si": 840000,
        "tariff": 278
      },
      {
        "si": 850000,
        "tariff": 280
      },
      {
        "si": 860000,
        "tariff": 282
      },
      {
        "si": 870000,
        "tariff": 284
      },
      {
        "si": 880000,
        "tariff": 286
      },
      {
        "si": 890000,
        "tariff": 288
      },
      {
        "si": 900000,
        "tariff": 290
      },
      {
        "si": 910000,
        "tariff": 292
      },
      {
        "si": 920000,
        "tariff": 294
      },
      {
        "si": 930000,
        "tariff": 296
      },
      {
        "si": 940000,
        "tariff": 298
      },
      {
        "si": 950000,
        "tariff": 300
      },
      {
        "si": 960000,
        "tariff": 302
      },
      {
        "si": 970000,
        "tariff": 304
      },
      {
        "si": 980000,
        "tariff": 306
      },
      {
        "si": 990000,
        "tariff": 308
      },
      {
        "si": 1000000,
        "tariff": 310
      },
      {
        "si": 1050000,
        "tariff": 321
      },
      {
        "si": 1100000,
        "tariff": 332
      },
      {
        "si": 1150000,
        "tariff": 343
      },
      {
        "si": 1200000,
        "tariff": 354
      },
      {
        "si": 1250000,
        "tariff": 365
      },
      {
        "si": 1300000,
        "tariff": 376
      },
      {
        "si": 1350000,
        "tariff": 387
      },
      {
        "si": 1400000,
        "tariff": 398
      },
      {
        "si": 1450000,
        "tariff": 409
      },
      {
        "si": 1500000,
        "tariff": 420
      },
      {
        "si": 1550000,
        "tariff": 429
      },
      {
        "si": 1600000,
        "tariff": 438
      },
      {
        "si": 1650000,
        "tariff": 447
      },
      {
        "si": 1700000,
        "tariff": 456
      },
      {
        "si": 1750000,
        "tariff": 465
      },
      {
        "si": 1800000,
        "tariff": 474
      },
      {
        "si": 1850000,
        "tariff": 483
      },
      {
        "si": 1900000,
        "tariff": 492
      },
      {
        "si": 1950000,
        "tariff": 501
      },
      {
        "si": 2000000,
        "tariff": 510
      },
      {
        "si": 2100000,
        "tariff": 524
      },
      {
        "si": 2200000,
        "tariff": 538
      },
      {
        "si": 2300000,
        "tariff": 552
      },
      {
        "si": 2400000,
        "tariff": 566
      },
      {
        "si": 2500000,
        "tariff": 580
      },
      {
        "si": 2600000,
        "tariff": 592
      },
      {
        "si": 2700000,
        "tariff": 604
      },
      {
        "si": 2800000,
        "tariff": 616
      },
      {
        "si": 2900000,
        "tariff": 628
      },
      {
        "si": 3000000,
        "tariff": 640
      },
      {
        "si": 3100000,
        "tariff": 650
      },
      {
        "si": 3200000,
        "tariff": 660
      },
      {
        "si": 3300000,
        "tariff": 670
      },
      {
        "si": 3400000,
        "tariff": 680
      },
      {
        "si": 3500000,
        "tariff": 690
      },
      {
        "si": 3600000,
        "tariff": 700
      },
      {
        "si": 3700000,
        "tariff": 710
      },
      {
        "si": 3800000,
        "tariff": 720
      },
      {
        "si": 3900000,
        "tariff": 730
      },
      {
        "si": 4000000,
        "tariff": 740
      },
      {
        "si": 4200000,
        "tariff": 756
      },
      {
        "si": 4400000,
        "tariff": 772
      },
      {
        "si": 4600000,
        "tariff": 788
      },
      {
        "si": 4800000,
        "tariff": 804
      },
      {
        "si": 5000000,
        "tariff": 820
      },
      {
        "si": 5200000,
        "tariff": 836
      },
      {
        "si": 5400000,
        "tariff": 852
      },
      {
        "si": 5600000,
        "tariff": 868
      },
      {
        "si": 5800000,
        "tariff": 884
      },
      {
        "si": 6000000,
        "tariff": 900
      },
      {
        "si": 6500000,
        "tariff": 940
      },
      {
        "si": 7000000,
        "tariff": 980
      },
      {
        "si": 7500000,
        "tariff": 1020
      },
      {
        "si": 8000000,
        "tariff": 1060
      },
      {
        "si": 8500000,
        "tariff": 1100
      },
      {
        "si": 9000000,
        "tariff": 1140
      },
      {
        "si": 9500000,
        "tariff": 1180
      },
      {
        "si": 10000000,
        "tariff": 1220
      },
      {
        "si": 10500000,
        "tariff": 1260
      },
      {
        "si": 11000000,
        "tariff": 1300
      },
      {
        "si": 11500000,
        "tariff": 1340
      },
      {
        "si": 12000000,
        "tariff": 1380
      },
      {
        "si": 12500000,
        "tariff": 1420
      },
      {
        "si": 13000000,
        "tariff": 1460
      },
      {
        "si": 13500000,
        "tariff": 1500
      },
      {
        "si": 14000000,
        "tariff": 1540
      },
      {
        "si": 14500000,
        "tariff": 1580
      },
      {
        "si": 15000000,
        "tariff": 1620
      },
      {
        "si": 15500000,
        "tariff": 1660
      },
      {
        "si": 16000000,
        "tariff": 1700
      },
      {
        "si": 16500000,
        "tariff": 1740
      },
      {
        "si": 17000000,
        "tariff": 1780
      },
      {
        "si": 17500000,
        "tariff": 1820
      },
      {
        "si": 18000000,
        "tariff": 1860
      },
      {
        "si": 18500000,
        "tariff": 1900
      },
      {
        "si": 19000000,
        "tariff": 1940
      },
      {
        "si": 19500000,
        "tariff": 1980
      },
      {
        "si": 20000000,
        "tariff": 2020
      },
      {
        "si": 20500000,
        "tariff": 2060
      },
      {
        "si": 21000000,
        "tariff": 2100
      },
      {
        "si": 21500000,
        "tariff": 2140
      },
      {
        "si": 22000000,
        "tariff": 2180
      },
      {
        "si": 22500000,
        "tariff": 2220
      },
      {
        "si": 23000000,
        "tariff": 2260
      },
      {
        "si": 23500000,
        "tariff": 2300
      },
      {
        "si": 24000000,
        "tariff": 2340
      },
      {
        "si": 24500000,
        "tariff": 2380
      },
      {
        "si": 25000000,
        "tariff": 2420
      },
      {
        "si": 25500000,
        "tariff": 2460
      },
      {
        "si": 26000000,
        "tariff": 2500
      },
      {
        "si": 26500000,
        "tariff": 2540
      },
      {
        "si": 27000000,
        "tariff": 2580
      },
      {
        "si": 27500000,
        "tariff": 2620
      },
      {
        "si": 28000000,
        "tariff": 2660
      },
      {
        "si": 28500000,
        "tariff": 2700
      },
      {
        "si": 29000000,
        "tariff": 2740
      },
      {
        "si": 29500000,
        "tariff": 2780
      },
      {
        "si": 30000000,
        "tariff": 2820
      },
      {
        "si": 31000000,
        "tariff": 2900
      },
      {
        "si": 32000000,
        "tariff": 2980
      },
      {
        "si": 33000000,
        "tariff": 3060
      },
      {
        "si": 34000000,
        "tariff": 3140
      },
      {
        "si": 35000000,
        "tariff": 3220
      },
      {
        "si": 36000000,
        "tariff": 3300
      },
      {
        "si": 37000000,
        "tariff": 3380
      },
      {
        "si": 38000000,
        "tariff": 3460
      },
      {
        "si": 39000000,
        "tariff": 3540
      },
      {
        "si": 40000000,
        "tariff": 3620
      },
      {
        "si": 41000000,
        "tariff": 3700
      },
      {
        "si": 42000000,
        "tariff": 3780
      },
      {
        "si": 43000000,
        "tariff": 3860
      },
      {
        "si": 44000000,
        "tariff": 3940
      },
      {
        "si": 45000000,
        "tariff": 4020
      },
      {
        "si": 46000000,
        "tariff": 4100
      },
      {
        "si": 47000000,
        "tariff": 4180
      },
      {
        "si": 48000000,
        "tariff": 4260
      },
      {
        "si": 49000000,
        "tariff": 4340
      },
      {
        "si": 50000000,
        "tariff": 4420
      },
      {
        "si": 51000000,
        "tariff": 4500
      },
      {
        "si": 52000000,
        "tariff": 4580
      },
      {
        "si": 53000000,
        "tariff": 4660
      },
      {
        "si": 54000000,
        "tariff": 4740
      },
      {
        "si": 55000000,
        "tariff": 4820
      },
      {
        "si": 56000000,
        "tariff": 4900
      },
      {
        "si": 57000000,
        "tariff": 4980
      },
      {
        "si": 58000000,
        "tariff": 5060
      },
      {
        "si": 59000000,
        "tariff": 5140
      },
      {
        "si": 60000000,
        "tariff": 5220
      }
    ],
    "si_base_v5_detail": null
  }
}
```
**si**
**1**

### Example / Code Payload (Row 46)
**Example Response
(Error)**
```json
{
    "title": "Unsuccess",
    "status": 400,
    "description": "Unexpected token } in JSON at position 74",
    "result": {}
}
```
**tariff**
**1**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | amount | 1 | Col17 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | si_detail | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | si | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | tariff | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | si_base_v5_detail | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | si | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | tariff | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | success | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | message | 1 |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior1 | 0 | CR 21 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior2 | 0 | CR 21 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior3 | 0 | CR 21 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior4 | 0 | CR 21 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehavior5 | 0 | CR 21 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverBehaviorSummary | 0 | CR 21 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 18 |  |
