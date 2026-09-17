# [37] Microservice-Policy

- **Category**: `microservice_inbound`
- **Source Sheet**: `Microservice-Policy`
- **Total Rows Parsed**: `51`

## API Specification Overview

- **Endpoint URL**: `https://qas-o2gateway.insurverse.com/sd/customer/updatepolicy`
- **HTTP Method**: `POST`
- **Headers**:
  - `Authorization: Bearer + (access token)`
  - `Content-Type: application/json`

## Raw & Structured Data Specification

### Request Message

### END POINT

| URL | https://qas-o2gateway.insurverse.com/sd/customer/updatepolicy |
| --- | --- |

### HTTP

| Methods | POST |
| --- | --- |

### Header

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |
| No | Upsert Policy |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Policy Number | policyNumber | Name, External_ID__c | Text(255) | Y | Y | เลขที่ของ  Policy |
| 2 | Policy Name | policyName | PolicyName | Text |  |  | ชื่อกรมธรรม์ที่ซื้อ |
| 3 | Effective Start Date | effectiveDate | EffectiveDate | Date |  |  | The date from which the policy is in effect. |
| 4 | Expiration Date | effectiveDate | ExpirationDate | Date |  |  | The date on which the policy expires. |
| 5 | Premium Amount | premiumAmount | PremiumAmount | Decimal |  |  | The premium paid by the policy owner for the current billing period. |
| 6 | Payment Due Date | paymentDueDate | PaymentDueDate | Date |  |  | The date on which the next payment of the premium is due. |
| 7 | Cancellation Date | cancellationDate | CancellationDate | Date |  |  | The date on which the insurance policy was canceled. |
| 8 | Expected Renewal Date | renewalDate | RenewalDate | Date |  |  | The date on which the policy is expected to be renewed. The actual renewal date may  be different |
| 9 | Policy Description | policyDescription | PolicyDescription | Text(255) |  |  | The description of the insurance policy. |
| 10 | Status | status | Status | Picklist |  |  |  |
| 11 | SubStatus | subStatus | Substatus | Picklist |  |  |  |
| 12 | Policy Plan Tier | planTier | PlanTier | Picklist |  |  | The class that the insurance policy belongs to. For example, silver, gold, or platinum. |
| 13 | Policy of Type | policyType | PolicyType | Picklist |  |  | The type of the insurance policy. For example, home, auto, annuity, or life. |
| 14 | Policy Renewed | isRenewedPolicy | IsRenewedPolicy | Boolean |  |  | Indicates whether the policy is a renewed policy. The default value is False. |
| 15 | GrossWrittenPremium | grossWrittenPremium | GrossWrittenPremium | Decimal |  |  | The total expected premium amount for the insurance policy over the policy period. |
| 16 | Sale Date | saleDate | SaleDate | Date |  |  | The date on which the policy was sold. |
| 17 | Discount | discount | Discount | Decimal |  |  | The discount that was given on the policy. |
| 18 | Date Renewed | dateRenewed | DateRenewed | Date |  |  | The date on which the policy was last renewed. |
| 19 | Premium Calculation | premiumCalculationMethod | PremiumCalculationMethod | Picklist |  |  | The premium calculation method for a payment period. eg. Daily |
| 20 | Premium Payment Type | premiumPaymentType | PremiumPaymentType | Picklist |  |  | The type of premium payment, such as Advance or Arrears |
| 21 | Policy Term | policyTerm | PolicyTerm | Picklist |  |  | The time period for which the policy provides coverage. Possible values are: Annual Custom Daily Monthly Semi-Annual |
| 22 | Paid To Date | paidToDate | PaidToDate | Date |  |  | The date up to which the policy is paid for. |
| 23 | Term Premium Amount | termPremiumAmount | TermPremiumAmount | Decimal |  |  | The expected premium for the policy over the policy period, prorated based on the policy's effective dates |
| 24 | Term Fee Amount | termFeeAmount | TermFeeAmount | Decimal |  |  | The expected fee for the policy over the policy period, prorated based on the policy's  effective dates |
| 25 | Term Tax Amount | termTaxAmount | TermTaxAmount | Decimal |  |  | The expected tax on the policy over the policy period, prorated based on the policy's  effective dates. |
| 26 | Standard Premium Amount | standardPremiumAmount | StandardPremiumAmount | Decimal |  |  | The expected premium for the policy over the policy period |
| 27 | Standard Fee Amount | standardFeeAmount | StandardFeeAmount | Decimal |  |  | The expected fee for the policy over the policy period. |
| 28 | Standard Tax Amount | standardTaxAmount | StandardTaxAmount | Decimal |  |  | The expected tax on the policy over the policy period |
| 29 | Total Term Tax Amount | totalTermTaxAmount | TotalTermTaxAmount | Decimal |  |  | The current total term taxes of all policy versions. |
| 2 | No Cancel Flag | no_cancel_flag |  | Text(1) |  |  | Y = ห้ามสลักหลังยกเลิก , N = สามารถสลักหลังยกเลิกได้ |
| 3 | No Cancel Reason | no_cancel_reason |  | Text(500) |  |  | เหตุผลในการห้ามสลักหลังยกเลิก |
| 4 | No Cancel Date | no_cancel_at |  | datetime |  |  | เวลาที่ update ห้ามสลักหลังยกเลิก |

### Example / Code Payload (Row 43)
**Example Request**
```json
{
  "policyNumber": "12345",
  "policyName": "Home Insurance",
  "effectiveDate": "2022-01-01",
  "expirationDate": "2022-12-31",
  "premiumAmount": "1000",
  "paymentDueDate": "2022-01-15",
  "cancellationDate": "2022-05-01",
  "renewalDate": "2023-01-01",
  "policyDescription": "Insurance coverage for a single-family home",
  "status": "Active",
  "subStatus": "Current",
  "planTier": "Gold",
  "policyType": "Homeowners",
  "isActive": true,
  "isRenewedPolicy": false,
  "grossWrittenPremium": "10000",
  "saleDate": "2021-12-01",
  "discount": "0.1",
  "premiumCalculationMethod": "Standard",
  "premiumPaymentType": "Monthly",
  "policyTerm": "12",
  "paidToDate": "500",
  "termPremiumAmount": "500",
  "termFeeAmount": "50",
  "termTaxAmount": "100",
  "standardPremiumAmount": "500",
  "standardFeeAmount": "50",
  "standardTaxAmount": "100",
  "totalStandardAmount": "1000",
  "totalTermTaxAmount": "200"
}
```

| No | Upsert Policy | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | Source - Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |
| 1 | Status Code | statuscode |  | Text(10) |  | Y |  |
| 2 | Message | message |  | Text(1000) |  | Y |  |
| 3 | Time Stamp | timeStamp |  | Datetime |  | Y |  |
| 4 | Policy Number | policyNumber | Name, External_ID__c | Text(255) | Y |  | เลขที่ของ  Policy ใช้สำหรับแก้ไข Policy |

### Example / Code Payload (Row 50)
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

### Example / Code Payload (Row 51)
**Example Response
(Error)**
```json
{
  "statuscode": "1000",
  "message": "Create/Update data partial complete.",
  "timestamp": "2022-01-28T11:24:53"
}
```
