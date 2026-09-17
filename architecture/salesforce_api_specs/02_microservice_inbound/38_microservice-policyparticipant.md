# [38] Microservice-PolicyParticipant

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-PolicyParticipant`
- **Total Rows Parsed**: `49`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/insertpolicyparticipant`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Integration Field

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/insertpolicyparticipant |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Policy Participant |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 0 |  |  |  | Array |  |  |  |
| 1 | Participant ID | participantID | ID | Text(18) | Y |  | Unique ID Participant |
| 2 | Policy Number | insurancePolicyId | InsurancePolicyId | Text(255) | Y | Y | เลขที่ของ  Policy Id |
| 3 | Account ID | accountID | PrimaryParticipantAccountId | Text(18) | Y |  | Unique ID Account |
| 4 | Role | role | Role | Picklist |  |  | The roles that the participant has in the policy Member Beneficiary |
| 5 | Beneficiary Share Percentage | beneficiarySharePercentage | BeneficiarySharePercentage | Decimal |  |  | The percentage of the total benefits that goes to the nominee. |
| 6 | IsMinorBeneficiary | isMinorBeneficiary | IsMinorBeneficiary | Boolean |  |  | Indicates whether the nominee is a minor. Default is False |
| 7 | Effective Date Start | effectiveDate | EffectiveDate | Date |  |  | The date from which the participant is active on the policy. |
| 8 | Expiration Date | expirationDate | ExpirationDate | Date |  |  | The date from which the participant is deactivated on the policy |
| 9 | Relationship with Insured | relationship | RelationshipToInsured | Picklist |  |  | Participant relationship with the insured: Aunt Brother Brother-in-law Cousin Daughter Daughter-in-law Ex-husband Ex-wife Father Father-in-law Granddaughter Grandfather Grandmother Grandson Half Sister Have one parent in common Husband Mother Mother-in-law Nephew Niece Sister Sister-in-law Son Son-in-law Step Brother Step Daughter Step Father Step Mother Step Sister Step Son Uncle Wife |
| 10 | IsActiveParticipant | isActiveParticipant | IsActiveParticipant | Boolean |  |  | Indicates whether the participant is an active participant on the policy.  The default value is False. |
| 11 | Standard Premium Amount | standardPremiumAmount | StandardPremiumAmount | Decimal |  |  | The expected premium for the policy over the policy period. |
| 12 | Standard Tax Amount | standardTaxAmount | StandardTaxAmount | Decimal |  |  | The expected tax on the policy over the policy period. |
| 13 | Standard Fee Amount | standardFeeAmount | StandardFeeAmount | Decimal |  |  | The expected fee for the policy over the policy period. |
| 14 | Term Fee Amount | termFeeAmount | TermFeeAmount | Decimal |  |  | The expected fee for the policy over the policy period, prorated  based on the policy's effective dates. |
| 15 | Term Premium Amount | termPremiumAmount | TermPremiumAmount | Decimal |  |  | The expected premium for the policy over the policy period, prorated  based on the policy's effective dates. |
| 16 | Term Tax Amount | termTaxAmount | TermTaxAmount | Decimal |  |  | The expected tax on the policy over the policy period, prorated  based on the policy's effective dates. |
| 17 | Participant Contact attribute | contactInfo | vlocity_ins_fsc__AttributesSelectedValues__c | List<Contact> |  |  | Participant contact information attribute |
| 17.1 | Salutation | salutation |  | Text(40) |  |  |  |
| 17.2 | Firstname | firstname |  | Text(40) |  |  |  |
| 17.3 | Lastname | lastname |  | Text(80) |  |  |  |
| 17.4 | Phone | phone |  | Text(40) |  |  |  |
| 17.5 | Fax | fax |  | Text(10) |  |  |  |
| 17.6 | Mobile | mobile |  | Text(10) |  |  |  |
| 17.7 | Title | title |  | Text(128) |  |  |  |
| 18 | ProductId | productId | vlocity_ins_fsc__ParentProductId__c | Text() |  |  | Product ID that the participant are in (Fix: Auto Driver) |

### Example / Code Payload (Row 38)
**Example Request**
```json
[
{
  "participantID": "12345",
  "insurancePolicyId": "67890",
  "accountID": "09876",
  "contactID": "54321",
  "role": "Primary Beneficiary",
  "beneficiarySharePercentage": "50",
  "isMinorBeneficiary": false,
  "effectiveDate": "2022-01-01",
  "expirationDate": "2022-12-31",
  "relationship": "Spouse",
  "isActiveParticipant": true,
  "isPolicyholder": true,
  "totalStandardAmount": "10000",
  "totalTermAmount": "20000",
  "standardPremiumAmount": "1000",
  "standardTaxAmount": "200",
  "standardFeeAmount": "300",
  "termFeeAmount": "400",
  "termPremiumAmount": "500",
  "termTaxAmount": "600",
  "productId": "0001",
  "contactInfo": {
    "contactID": "54321",
    "salutation": "Mr.",
    "firstname": "John",
    "lastname": "Smith",
    "accountID": "09876",
    "phone": "555-555-5555",
    "fax": "555-555-5556",
    "mobile": "555-555-5557",
    "title": "Manager"
  }
}
]
```

| No | Upsert Policy Participant | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Result | result |  | Array |  | Y |  |
| 4.1 | Participant ID | participantID | ID | Text(18) | Y |  | Using for Update Participant Detail |
| 4.2 | Is Success | isSuccess |  | Boolean |  |  |  |
| 4.3 | Error Message | errorMessage |  | Text(2000) |  |  |  |

### Example / Code Payload (Row 48)
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

### Example / Code Payload (Row 49)
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
