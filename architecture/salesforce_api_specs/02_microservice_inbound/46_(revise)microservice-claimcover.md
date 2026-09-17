# [46] (Revise)Microservice-ClaimCover

- **Category**: `microservice_inbound`
- **Source Sheet**: `(Revise)Microservice-ClaimCover`
- **Total Rows Parsed**: `140`

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

| Content-Type | application/json | Col3 | Col4 | Col5 | Col6 | Col7 | Col8 | Col9 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Authorization | Bearer + (access token) |  |  |  |  |  |  |  |
| No | Update Payment |  |  |  |  |  |  |  |
|  | Field Name | Source - Field Name (Service Model) | SF Field | Type | External Key | Required Field | Remark |  |
| 1 | Claim Number | claimId | ClaimId | Text(20) | Y | Y | เลขเคลม |  |
| 2 | Coverage Number | coverageID | External_Id__c | Text(20) | Y | Y | หมายเลข e-Claim |  |
| 3 | Policy Number |  |  |  |  |  |  |  |
| 4 | Item No | itemNo | itemno__c | Number |  |  |  |  |
| 5 | Sequence No | sequenceNo | seqno__c | Number |  |  |  |  |
| 6 | Motor Seq No | motorSeqNo | motorseqno__c | Number |  |  |  |  |
| 3 | Claim Coverage Type | coverageType |  | Text |  |  | ประเภทของการเบิก (Loss Code Group) - Vehicle F&T - Injury Person - Property - Expense | itemType? |
| 4 | Losscode |  |  | Array |  |  |  |  |
|  | Loss Type |  |  |  |  |  | Loss, Salavge, Deduct, Expense |  |
| 4.1 | Losscode ID |  |  |  |  |  |  |  |
| 4.2 | Amount |  |  |  |  |  |  |  |

### 4.3

### 4.4

| 5 | ccstatus | ccStatus | Col4 | Col5 | Col6 | Col7 | C = Delete | กรณีกรอกผิดแล้วลบเรคอร์ด | Col10 | Col11 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 6 | seqnotid | seqNotID |  |  |  |  | No. (ลำดับ Claim Item) |  |  |  |
| 7 | ccdate | ccDate |  | date |  |  | วันที่ลบ |  |  |  |
| 8 | Car Detail |  |  | Object = ClaimItem(Car) |  | Y (F&T) |  |  |  | Page Layout |
|  | tplicenseno | tplicenseno | C_CAR_REGNO__c |  |  |  |  |  |  | Driver |
|  | tpprovinceid | tpprovinceid | Car_Province__c |  |  |  |  | tpvpolicyno |  | Driver |
|  | tpunregister | tpunregister | Car_Unregister__c |  |  |  |  |  |  | Driver |
|  | tpbrandid | tpbrandid | Car_Brand__c |  |  |  |  | tpcinsentityid |  | Driver |
|  | tpmodelid | tpmodelid | Car_Model__c |  |  |  |  |  |  | Driver |
|  | tpspecid | tpspecid | Car_Spec__c |  |  |  |  |  |  | Driver |
|  | tpcolorid | tpcolorid | Car_Color__c |  |  |  |  |  |  | Driver |
|  | tpchassisno | tpchassisno | CHASSIS_NO__c |  |  |  |  |  |  | Driver |
|  | tpengineno | tpengineno | Engine_No__c |  |  |  |  |  |  | Driver |
|  | tpvinsentbrcode | tpvinsentbrcode | Voluntary_Insurance_Company__r.Brcode__c |  |  |  |  |  |  | Driver |
|  | tptpvinsentityid | tptpvinsentityid | Voluntary_Insurance_Company__r.entityid__c |  |  |  |  |  | เช่น รุ่นรถ + Master | Driver |
|  | titleid | titleid | Driver_Title__c |  |  |  |  |  |  | Driver |
|  | firstname | firstname | Driver_FirstName__c |  |  |  |  |  |  | Driver |
|  | lastname | lastname | Driver_LastName__c |  |  |  |  |  |  | Driver |
|  | sex | sex | Driver_Gender__c |  |  |  |  |  |  |  |
|  | relationid | relationid | driver_Relation__c |  |  |  |  |  |  | Driver |
|  | birthdate | birthdate | Driver_Birthday__c |  |  |  |  | tplicenseno |  |  |
|  | occupationid | occupationid | Driver_Occupation__c |  |  |  |  |  |  |  |
|  | personalid | personalid | Driver_ID_Card__c |  |  |  |  | tpprovinceid |  |  |
|  | expirydate | expirydate | Driver_ID_Card_Expired__c |  |  |  |  |  |  | Driver |
|  | address | address | Driver_Address__c |  |  |  |  |  |  |  |
|  | no | no | Driver_No__c |  |  |  |  | tpbrandid |  | Driver |
|  | moo | moo | Driver_Moo__c |  |  |  |  | tpmodelid |  | Driver |
|  | soi | soi | Driver_Soi__c |  |  |  |  |  |  |  |
|  | road | road | Driver_Road__c |  |  |  |  |  |  |  |
|  | districtid | districtid | Driver_District__c |  |  |  |  |  |  |  |
|  | amphurid | amphurid | Driver_Amphur__c |  |  |  |  |  |  |  |
|  | provinceid | provinceid | Driver_Province__c |  |  |  |  |  |  |  |
|  | countryid | countryid | Driver_Country__c |  |  |  |  |  |  |  |
|  | zipcode | zipcode | Driver_Zip_Code__c |  |  |  |  |  |  | Driver |
|  | telno | telno | Driver_Tel__c |  |  |  |  |  |  | Driver |
|  | faxno | faxno | Driver_Fax__c |  |  |  |  |  | มาเปลี่ยน labelทีหลัง | Driver |
|  | email | email | Driver_Email__c |  |  |  |  |  | มาเปลี่ยน labelทีหลัง | Driver |
|  | idtype | idtype | Driver_License_Type__c |  |  |  |  |  |  |  |
|  | canrecovery | canrecovery | Car_Insure__c |  |  |  |  |  |  | Driver |
|  | tpvpolicyno | tpvpolicyno | Policy_No__c |  |  |  |  |  |  | Driver |
|  | tpvclass | tpvclass | Voluntary_Class__c |  |  |  |  |  |  | Driver |
|  | tpveffectivedate | tpveffectivedate | Voluntary_Effective_Date__c |  |  |  |  |  |  | Driver |
|  | tpvexpirydate | tpvexpirydate | Voluntary_Expiry_Date__c |  |  |  |  |  |  |  |
|  | tpvclaimno | tpvclaimno | Voluntary_Claim_No__c |  |  |  |  |  |  |  |
|  | tpcpolicyno | tpcpolicyno | Compulsory_Policy__c |  |  |  |  |  |  |  |
|  | tpcinsentityid | tpcinsentityid | Compulsory_Company__r.entityid__c |  |  |  |  |  |  |  |
|  | tpceffdate | tpceffdate | Compulsory_Effective_Date__c |  |  |  |  |  |  |  |
|  | tpcexpdate | tpcexpdate | Compulsory_Expiry_Date__c |  |  |  |  |  |  |  |
|  | tpcclaimno | tpcclaimno | Compulsory_Claim_No__c |  |  |  |  |  |  |  |
|  | tpcinsentbrcode | tpcinsentbrcode | Compulsory_Company__r.Brcode__c |  |  |  |  |  |  |  |
|  | prescription | prescription | Prescription__c |  |  |  |  |  |  |  |
|  | prescriptiondate | prescriptiondate | Prescription_Date__c |  |  |  |  |  |  | Driver |
|  | modelyear | modelyear | Car_Model__c |  |  |  |  |  |  |  |
|  | lossinitialdamage | lossinitialdamage | Cost__c |  |  |  |  |  |  | Driver |
|  | tpcardesc | tpcardesc | Car_Description__c |  |  |  |  |  |  | Driver |
|  | Owner Address |  |  |  |  |  |  |  |  |  |
| 9 | Injury Detail | injuryDetails |  |  |  | Y (Injury Person) |  |  |  | Driver |
|  | titleid | titleid | Title__c |  |  |  |  |  |  |  |
|  | firstname | firstname | FirstName__c |  |  |  |  |  |  | Driver |
|  | lastname | lastname | LastName__c |  |  |  |  |  |  | Driver |
|  | sex | sex | Gender__c |  |  |  |  |  |  | Driver |
|  | relationid | relationid | Relation__c |  |  |  |  |  |  | Driver |
|  | birthdate | birthdate | Birthday__c |  |  |  |  |  |  | Driver |
|  | occupationid | occupationid | Occupation__c |  |  |  |  |  |  | Driver |
|  | personalid | personalid | Id_Card__c |  |  |  |  |  |  | Driver |
|  | expirydate | expirydate | Id_Card_Expired__c |  |  |  |  |  |  | Driver |
|  | address | address | Address__c |  |  |  |  |  |  |  |
|  | no | no | No__c |  |  |  |  |  |  | Driver |
|  | moo | moo | Moo__c |  |  |  |  |  |  | Driver |
|  | soi | soi | Soi__c |  |  |  |  |  |  | Driver |
|  | road | road | Road__c |  |  |  |  |  |  | Driver |
|  | districtid | districtid | Master_Address_r.District_ID__c |  |  |  |  |  |  | Driver |
|  | amphurid | amphurid | Master_Address_r.Amphur_ID__c |  |  |  |  |  |  |  |
|  | provinceid | provinceid | Master_Address_r.Province_ID__c |  |  |  |  |  |  | Driver |
|  | countryid | countryid |  |  |  |  |  |  |  | Driver |
|  | zipcode | zipcode | Zip_Code__c |  |  |  |  |  |  | อยู่ภายใต้ Driver Page Layout แต่เป็น Section เจ้าของกรมธรรม์ |
|  | telno | telno | Tel__c |  |  |  |  |  |  | Driver |
|  | faxno | faxno | Fax__c |  |  |  |  |  |  | Driver |
|  | email | email | Email__c |  |  |  |  |  | add เข้า injury | Driver |
|  | prescription | prescription | Prescription__c |  |  |  |  |  |  | Driver |
|  | prescriptiondate | prescriptiondate | Prescription_Date__c |  |  |  |  |  |  | Driver |
| 10 | Property Detail |  | Object = ClaimItem(Asset) |  |  | Y (Property) |  |  |  | Driver |
|  | tppropertytype | tppropertytype | Asset_Name__c |  |  |  |  |  |  | Driver |
|  | titleid | titleid | Title__c |  |  |  |  |  |  | Driver |
|  | firstname | firstname | FirstName__c |  |  |  |  |  |  | Driver |
|  | lastname | lastname | LastName__c |  |  |  |  |  |  | Driver |
|  | sex | sex | Gender__c |  |  |  |  |  |  | Driver |
|  | relationid | relationid | Relation__c |  |  |  |  |  |  |  |
|  | birthdate | birthdate | Birthday__c |  |  |  |  |  |  | Driver |
|  | occupationid | occupationid | Occupation__c |  |  |  |  |  |  | Driver |
|  | personalid | personalid | Id_Card__c |  |  |  |  |  |  | Driver |
|  | expirydate | expirydate | Id_Card_Expired__c |  |  |  |  |  |  | Driver |
|  | address | address | Address__c |  |  |  |  |  | Exist : ประมาณการความเสียหายเบื้องต้น        Loss_Initial_Damage__c | Driver |
|  | no | no | No__c |  |  |  |  |  |  | Driver |
|  | moo | moo | Moo__c |  |  |  |  |  |  | Driver |
|  | soi | soi | Soi__c |  |  |  |  |  |  |  |
|  | road | road | Road__c |  |  |  |  |  |  | Driver |
|  | districtid | districtid | District__c |  |  |  |  |  |  | Injury |
|  | amphurid | amphurid | Amphur__c |  |  |  |  |  |  |  |
|  | provinceid | provinceid | Province__c |  |  |  |  |  |  |  |
|  | countryid | countryid |  |  |  |  |  |  |  |  |
|  | zipcode | zipcode | Zip_Code__c |  |  |  |  |  |  |  |
|  | telno | telno | Tel__c |  |  |  |  |  |  |  |
|  | faxno | faxno | Fax__c |  |  |  |  |  |  |  |
|  | email | email | Email__c |  |  |  |  |  |  |  |

### Example Request

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

### Example / Code Payload (Row 139)
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

### Example / Code Payload (Row 140)
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
