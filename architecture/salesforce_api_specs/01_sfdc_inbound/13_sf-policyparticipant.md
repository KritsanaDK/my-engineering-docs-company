# [13] SF-PolicyParticipant

- **Category**: `sfdc_inbound`
- **Source Sheet**: `SF-PolicyParticipant`
- **Total Rows Parsed**: `60`

## API Specification Overview

- **Endpoint URL**: `/services/apexrest/upsertpolicyparticipant`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### แ

### Request Message

### END POINT

| URL | /services/apexrest/upsertpolicyparticipant |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | Col15 | Col16 | Col17 | Col18 | Col19 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| No | Upsert Policy Participant |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark | GCP Field | GCP Remark |  | 5.0 |  |  | AI |  |  | CR21 |  |
| 0 |  |  |  | Array |  |  |  |  |  |  |  | 0 |  |  | 0 |  |  | 0 |
| 1 | Participant ID | participantID | External_ID__c | Text(18) | Y | Y | Unique ID Participant | Policy_No | Policy_No + Participant_Type Owner = เจ้าของ Buyer = ผู้ซื้อ Bene = ผู้รับผลประโยชน์ Driver_1 = ผู้ขับขี่คนที่ 1 Driver_2 = ผู้ขับขี่คนที่ 2 |  | participantID | 1 |  | participantID | 1 |  | participantID | 1 |
| 2 | InsurancePolicyId | insurancePolicyId | InsurancePolicyId | Master-Detail(Insurance Policy) | Y | Y | เลขที่ของ  Policy Id | Policy_No |  |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |  | insurancePolicyId | 1 |
| 3 | PrimaryParticipantAccountId | accountID | PrimaryParticipantAccountId | Lookup(Account) | Y |  | Unique ID Account |  |  |  | accountID | 1 |  | accountID | 1 |  | accountID | 1 |
| 4 | Role | role | Role | Picklist (Multi-Select) |  |  | The roles that the participant has in the policy Member Beneficiary |  | Owner = เจ้าของ Buyer = ผู้ซื้อ Bene = ผู้รับผลประโยชน์ Driver_1 = ผู้ขับขี่คนที่ 1 Driver_2 = ผู้ขับขี่คนที่ 2 |  | role | 1 |  | role | 1 |  | role | 1 |
| 5 | BeneficiarySharePercentage | beneficiarySharePercentage | BeneficiarySharePercentage | Percent(3, 0) |  |  | The percentage of the total benefits that goes to the nominee. |  |  |  | beneficiarySharePercentage | 1 |  | beneficiarySharePercentage | 1 |  | beneficiarySharePercentage | 1 |
|  | BeneficiaryType | beneType | Beneficiary_Type__c | Text |  |  | person หรือ financial |  |  |  | beneType | 1 |  | beneType | 1 |  | beneType | 1 |
| 6 | IsMinorBeneficiary | isMinorBeneficiary | IsMinorBeneficiary | Boolean |  |  | Indicates whether the nominee is a minor. Default is False |  |  |  | isMinorBeneficiary | 1 |  | isMinorBeneficiary | 1 |  | isMinorBeneficiary | 1 |
| 7 | EffectiveDate | effectiveDate | EffectiveDate | Date/Time |  |  | The date from which the participant is active on the policy. | Policy_Startdate |  |  | effectiveDate | 1 |  | effectiveDate | 1 |  | effectiveDate | 1 |
| 8 | ExpirationDate | expirationDate | ExpirationDate | Date/Time |  |  | The date from which the participant is deactivated on the policy | Policy_Enddate |  |  | expirationDate | 1 |  | expirationDate | 1 |  | expirationDate | 1 |
| 9 | RelationshipToInsured | relationship | RelationshipToInsured | Picklist |  |  | Participant relationship with the insured: Aunt Brother Brother-in-law Cousin Daughter Daughter-in-law Ex-husband Ex-wife Father Father-in-law Granddaughter Grandfather Grandmother Grandson Half Sister Have one parent in common Husband Mother Mother-in-law Nephew Niece Sister Sister-in-law Son Son-in-law Step Brother Step Daughter Step Father Step Mother Step Sister Step Son Uncle Wife | Par_relation |  |  | relationship | 1 |  | relationship | 1 |  | relationship | 1 |
| 10 | IsActiveParticipant | isActiveParticipant | IsActiveParticipant | Boolean |  |  | Indicates whether the participant is an active participant on the policy.  The default value is False. |  | Fix active |  | isActiveParticipant | 1 |  | isActiveParticipant | 1 |  | isActiveParticipant | 1 |
| 11 | IsCompany | isCompany |  | Boolean |  |  |  |  |  |  | isCompany | 1 |  | isCompany | 1 |  | isCompany | 1 |
| 12 | Participant Contact attribute | contactInfo | vlocity_ins_fsc__AttributesSelectedValues__c | Object |  | Y | Participant contact information attribute |  |  |  | contactInfo | 1 |  | contactInfo | 1 |  | contactInfo | 1 |
| 12.1 | Salutation | salutation | vlocity_ins_fsc__ParticipantName__c | Text(40) |  |  |  | prefix_name |  |  | salutation | 1 |  | salutation | 1 |  | salutation | 1 |
| 12.2 | Firstname | firstname | vlocity_ins_fsc__ParticipantName__c | Text(40) |  |  |  | first_name |  |  | firstname | 1 |  | firstname | 1 |  | firstname | 1 |
| 12.3 | Lastname | lastname | vlocity_ins_fsc__ParticipantName__c | Text(80) |  |  | ระบุต่อท้ายด้วย (Owner หรือ Payer) | last_name |  |  | lastname | 1 |  | lastname | 1 |  | lastname | 1 |
| 12.4 | Mobile Phone | mobilePhone |  | Text(40) |  |  |  | phone |  |  | mobilePhone | 1 |  | mobilePhone | 1 |  | mobilePhone | 1 |
| 12.5 | Email | email |  | Text(40) |  |  |  |  |  |  | email | 1 |  | email | 1 |  | email | 1 |
| 12.6 | birth date | birthdate |  | Date |  |  |  | birth_date | วันเกิด |  | birthdate | 1 |  | birthdate | 1 |  | birthdate | 1 |
| 12.7 | citizen id | citizenId |  | Text(13) |  |  |  | citizen_id | เลขบัตรประจำตัวประชาชน |  | citizenId | 1 |  | citizenId | 1 |  | citizenId | 1 |
| 12.8 | address no | addressNo |  | Text(255) |  |  |  | address_no |  |  | addressNo | 1 |  | addressNo | 1 |  | addressNo | 1 |
| 12.9 | building | building |  | Text(255) |  |  |  | building |  |  | building | 1 |  | building | 1 |  | building | 1 |
| 12.10 | village | village |  | Text(255) |  |  |  | village |  |  | village | 1 |  | village | 1 |  | village | 1 |
| 12.11 | alley | alley |  | Text(255) |  |  |  | alley |  |  | alley | 1 |  | alley | 1 |  | alley | 1 |
| 12.12 | road | road |  | Text(255) |  |  |  | road |  |  | road | 1 |  | road | 1 |  | road | 1 |
| 12.13 | province id | provinceId |  | Int(32) |  |  |  | province_id |  |  | provinceId | 1 |  | provinceId | 1 |  | provinceId | 1 |
| 12.14 | province | province |  | Text(255) |  |  |  |  |  |  | province | 1 |  | province | 1 |  | province | 1 |
| 12.15 | subdistrict id | subdistrictId |  | Int(32) |  |  |  | subdistrict_id |  |  | subdistrictId | 1 |  | subdistrictId | 1 |  | subdistrictId | 1 |
| 12.16 | subdistrict | subdistrict |  | Text(255) |  |  |  |  |  |  | subdistrict | 1 |  | subdistrict | 1 |  | subdistrict | 1 |
| 12.17 | district id | districtId |  | Int(32) |  |  |  | district_id |  |  | districtId | 1 |  | districtId | 1 |  | districtId | 1 |
| 12.18 | district id | district |  | Text(255) |  |  |  |  |  |  | district | 1 |  | district | 1 |  | district | 1 |
| 12.19 | zipcode | zipcode |  | Text(45) |  |  |  | zipcode |  |  | zipcode | 1 |  | zipcode | 1 |  | zipcode | 1 |
| 12.20 | Occupation | occupation |  | Text(255) |  |  |  | Occupation | อาชีพ |  | occupation | 1 |  | occupationId | 0 |  | occupation | 1 |
| 12.21 | Driver license no | driverLicenseNo |  | Text(50) |  |  |  | Driver_license_no | เลขใบอณุญาตขับขี่ |  | driverLicenseNo | 1 |  | occupation | 1 |  | occupationTQM | 0 |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | driverLicenseType | 0 |  | occupationPWA | 0 |

### Example / Code Payload (Row 48)
**Example Request**
```json
[
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
  ]
```
**driverLicenseNo**
**1**
**occupationId**
**0**

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 | Col10 | Col11 | Col12 | Col13 | Col14 | driverLicenseIssueDate | 0 | Col17 | driverLicenseType | 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| No | Upsert Policy Participant |  |  |  |  |  |  |  |  |  |  |  |  | departmentOfLandTransport | 0 |  | driverLicenseNo | 1 |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |  |  |  |  |  |  | driverLicenseExpireDate | 0 |  | driverLicenseIssueDate | 0 |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |  |  |  |  |  |  |  |  |  | departmentOfLandTransport | 0 |
| 2 | Message | message |  | Text(1000) |  | Y |  |  |  |  |  |  |  |  |  |  | driverLicenseExpireDate | 0 |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |  |  |  |  |  |  |  |  |  | driverConsent | 0 |
| 4 | Result | result |  | Array |  | Y |  |  |  |  |  |  |  |  |  |  | driverBehavior | 0 |
| 4.1 | Participant ID | participantID | ID | Text(18) | Y |  | Using for Update Participant Detail |  |  |  |  |  |  |  |  |  | driverConsent | 0 |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |  |  | 34 |  | 34 |  |  | 34 |  |  | 34 |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

### Example / Code Payload (Row 59)
**Example Response
(Success)**
```json
{
  "statuscode": "0000",
  "message": "Success",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "participantID": "0cY4x000000Twj3EAC",
      "isSuccess": true,
      "errorMessage": null
    }
  ]
}
```

### Example / Code Payload (Row 60)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53",
  "result": [
    {
      "participantID": "0cY4x000000Twj3EAC",
      "isSuccess": true,
      "errorMessage": null
    },
    {
      "participantID": "0cY4x000000Twj6EAC",
      "isSuccess": false,
      "errorMessage": "Some Error Message"
    }
  ]
}
```
