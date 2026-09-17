# [39] Microservice-PolicyAsset

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-PolicyAsset`
- **Total Rows Parsed**: `59`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/upsertpolicyasset`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/upsertpolicyasset |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Policy Asset |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 0 |  |  |  | Array |  |  |  |
| 1 | Policy Number | insurancePolicyId | InsurancePolicyId | Text(255) | Y | Y | เลขที่ของ  Policy Id |
| 2 | AssetName | assetName | AssetName | Text(255) |  |  | The insured customer property. |
| 3 | IsActive | isActive | IsActive |  |  |  | Indicates whether the insurance policy asset is active. Default False |
| 4 | Description__c | description__c | Description__c | Text |  |  | Description of Vehicle |
| 5 | Asset Attribute | assetAttribute | vlocity_ins_fsc__AttributesSelectedValues__c | Text(json) |  |  | Attribute of asset |
| 5.1 | Brand | avMake |  | Text |  |  |  |
| 5.2 | Model | avModel |  | Text |  |  |  |
| 5.3 | Year | avYear |  | Text |  |  |  |
| 5.4 | Value | avValue |  | Decimal |  |  |  |
| 5.5 | Annual Mileage | avMileage |  | Number |  |  |  |
| 5.6 | Color | avColor |  | Text |  |  |  |
| 5.7 | Garage Location (PostalCode) | avGaragePostalCode |  | Text |  |  |  |
| 5.8 | Alternative Fuel | avAltFuel |  | Checkbox |  |  |  |
| 5.9 | Anti Theft | avAntiTheft |  | Checkbox |  |  |  |
| 5.10 | Stabilization | avStabillization |  | Checkbox |  |  |  |
| 5.11 | Restraints | avRestraints |  | Checkbox |  |  |  |
| 5.12 | Historic | avHistoric |  | Checkbox |  |  |  |
| 5.13 | Style | avStyle |  | Text |  |  |  |
| 5.14 | Brakes | avBrakes |  | Checkbox |  |  |  |
| 5.15 | Claim Frequency | avClaimFrequency |  | Number |  |  |  |
| 5.16 | Claim Severity | avClaimSev |  | Number |  |  |  |
| 5.17 | License Number | avLicNum |  | Text |  |  |  |
| 5.18 | Lincense State | avLicState |  | Text |  |  |  |
| 5.19 | Rated Driver - BIPD | avRatedDriver-BIPD |  | Number |  |  |  |
| 5.20 | Rated Driver - Comprehensive | avRatedDriver-COMP |  | Number |  |  |  |
| 5.21 | Rated Driver - Medical Payment | avRateddDriver-MEDD |  | Number |  |  |  |
| 5.22 | Rated Driver - Uninsured Motorist | avRatedDriver-UM |  | Number |  |  |  |
| 5.23 | Rated Driver Name | avRatedDriverName |  | Text |  |  |  |
| 5.24 | Symbol | avSymbol |  | Text |  |  |  |
| 5.25 | Vin | avVin |  | Text |  |  |  |
| 5.26 | Body Type | avBodyType |  | Text |  |  |  |
| 5.27 | Rated Driver Collision | avRatedDriver-COLL |  | Number |  |  |  |
| 6 | ProductId | productId | vlocity_ins_fsc__ParentProductId__c | Text() |  |  | Product ID that the participant are in (Fix: Vehicle) |
| 7 | License Number | licNum | LicNumber__c | Text |  |  | ทะเบียนรถ |
| 8 | Primary Participant | participantID | PrimaryPolicyParticipantId | Text(18) |  |  |  |

### Example / Code Payload (Row 48)
**Example Request**
```json
[
    {
      "insurancePolicyId": "IP1234567891",
      "customerPropertyId": "CP123456789",
      "sourceSystemIdentifier": "SSI123456789",
      "assetName": "My Car",
      "primaryPolicyParticipantId": "PPP123456789",
      "totalTermAmount": 900,
      "totalStandardAmount": 1000,
      "isActive": true,
      "description": "blue Honda Civic 2020 with custom spoiler Edit",
      "assetAttribute": {
        "avLicNum": "9395"
      },
      "licNum": "9395",
      "participantID": "PP12345"
    }
  ]
```

| No | Upsert Policy Asset | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Asset ID | assetId | ID | Text(18) | Y |  | Using for Update Asset Detail |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 58)
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

### Example / Code Payload (Row 59)
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
