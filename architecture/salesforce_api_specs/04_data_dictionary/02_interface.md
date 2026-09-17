# [02] Interface

- **Category**: `data_dictionary`
- **Source Sheet**: `Interface`
- **Total Rows Parsed**: `83`

## Raw & Structured Data Specification

| Col1 | Source | Microservice | Destination | SFDC | Col6 | Col7 | Col8 | Col9 | Col10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| No | Sheet | Interface Name | Description | HTTP Method | Type | Interval | Trigger by | Release | Remark |
| 1 | SFCD OAuth 2.0 Authentication | SFDC Authentication | Get access token for auterization other service | POST | Single |  | - | R1 |  |
| 2 | SAP-SF_Upsert Account | Update Account | Upsert list account information by Customer ID | POST | Bulk | Real-time | Update Account on SAP |  |  |
| 3 | SAP-SF_Upsert Contact | Update Contact | Upsert list address information by Contact ID | POST | Bulk | Real-time | Update Contact on SAP |  |  |
| 2 | SF - Lead | Upsert Lead | Lead is user in guest mode login | POST | Single | Real-time |  | R1 |  |
| 3 | SF - Account | Upsert Account | Account is user that have KYC information | POST | Single | Real-time |  | R1 |  |
| 4 | SF - Contact | Upsert Contact | Contact is person who related with account, eg., witness | POST | Single | Real-time |  |  | อาจจะไม่เชื่อม |
| 5 | SF - Quotation | Upsert Quotation | Information about policy DIY that user select on mobile application | POST | Single | Real-time |  |  | อาจจะไม่เชื่อม |
| 6 | SF - Product | Upsert Product |  | POST | Multiple | Real-time |  |  | อาจจะไม่เชื่อม |
| 4 | SF - Payment Premium | Upsert Payment Premium | Payment detail related with account and policy | POST | Multiple | Real-time |  | R1 |  |
| 5 | SF - Policy | Upsert Policy | Policy overview detail, eg., start-end date, buyer, insure person, total pemium | POST | Single | Real-time |  | R1 |  |
| 6 | SF - Policy Coverage | Upsert Policy Coverage | Detail policy coverage includes Comprehensive, Collision, and Personal injury coverage | POST | Multiple | Real-time |  | x |  |
| 7 | SF - Policy Participant | Upsert Policy Participant | Represents relationship between person and policy | POST | Multiple | Real-time |  | x |  |
| 8 | SF - Policy Asset | Upsert Policy Asset | Represents relationship between car and policy | POST | Multiple | Real-time |  | x |  |
| 6 | SF - Policy Transaction | Insert Policy Transaction | Represents a transaction related to a change that affects the premium of an insurance policy, such as an endorsement, renewal, or cancellation. | POST | Multiple | Real-time |  | R2.5/R3.5 |  |
|  | SF-Request Policy Document | Request Policy Document (ตัวจริง) | Request URL for access for Policy Document, the link that have expire date | POST | Single | Real-time |  |  |  |
| 7 | SF - Policy Attachment | Upsert Policy Attachment | file size not excced 36MB (For Policy (สำเนา), Endrosement and Car Inspect) | POST | Single | Real-time |  | R1 |  |
| 8 | SF-PolicyAttachment (URL) | Upsert Policy Attachment (URL GCP) | Using for update URL for access file that related to policy on GCP to salesforce (For policy (ตัวจริง) Payment) | POST | Multiple | Real-time |  | R1 |  |
| 9 | SF - Case | Upsert Case | Insert/Update case detail form other channel | POST | Single | Real-time |  | R1 |  |
| 10 | SF - Claim | Upsert Claim | Insert/Update claim detail from mobile app | POST | Single | Real-time |  | R3 |  |
| 11 | SF - Claim Attachment | Upload Claim Attachment (URL GCP) | file size not excced 36MB (For Car Damage, ใบแจ้งซ่อม, Garage Billing, etc) | POST | Multiple | Real-time |  | R1 |  |
| 12 | SF-Claim Reserve/Adjust | Upsert Claim Reserve/Adjust | Update Reserve/Adjust detail from IIA to SF | POST | Multiple | Real-time |  | R2.0 |  |
| 13 | SF-Claim Payment Summary | Upsert Claim Payment Summary | Update Payment Summary detail from IIA to SF | POST | Multiple | Real-time |  |  |  |
| 14 | SF-Claim Paid | Update Paid Info | Update Paid Information form IIA to SF | POST | Multiple | Daily |  |  |  |
| 15 | SF-Claim Recovery | Upsert Claim Recovery | Update Recovery Detail from IIA to SF | POST | Multiple | Real-time |  |  |  |
| 16 | SF - Update Customer Location | Update customer current location | track customers' behavior | POST | Single | Real-time |  |  | maybe in the future phase |
| 13 | SF - Get knowledge | Get Knowledge | Get all public knowledge category and content | POST | Multiple | Daily |  |  |  |
| 13 | SF - File Attachment | Upsert File Attachment | file size not excced 36MB | POST | Multiple | Daily |  | R3.5 |  |
|  | Source | SFDC | Destination | Microservice |  |  |  |  |  |
| No | Sheet | Interface Name | Description | HTTP Method | Type | Interval | Trigger by | Confirm | Remark |
| 1 | Microservice OAuth 2.0 Authentication | Microservice Authentication | Get access token for auterization other service | POST | Single |  | - | R1 |  |
| 2 | Microservice - Account | Update Account |  | POST | Single | Real-time |  |  | อาจจะไม่เชื่อม |
| 3 | Microservice - Policy | Update Policy | Using for update policy overview detail, eg., start-end date, buyer, insure person, total pemium | POST | Single | Real-time |  |  |  |
| 4 | Microservice - PolicyCoverage | Upsert Policy Coverage | Using for update policy coverage include Comprehensive, Collision, and Personal injury coverage | POST | Multiple | Real-time |  |  |  |
| 5 | Microservice - PolicyParticipant | Upsert Policy Participant | Using for update relationship between person and policy | POST | Multiple | Real-time |  |  |  |
| 6 | Microservice - PolicyAsset | Upsert Policy Asset | Using for update presents relationship between person and policy | POST | Multiple | Real-time |  |  |  |
| 2 | Microservice - Get Motor Master | Get Policy Motor Master Value | Get all car brand, model, year, etc. (Request policy number) | POST | Multiple |  |  | R2.5 |  |
| 3 | Microservice - GetPolicyMotorCoverage | Get Policy Motor Coverage Possible Value | Return all coverage possible value include (OD, TPPD, TTPI, etc) | POST | Multiple |  |  | R2.5 |  |
| 4 | Microservice - PolicyTransaction | Upsert Policy Transactiom | Using for create/update a transaction related to a change that affects the premium of an insurance policy, such as an endorsement, renewal, or cancellation. In case affects the premium, microservice should send sms for customer paid or refund. | POST | Single | Real-time |  | R2.5 |  |
| 5 | Microservice - PolicyAttahment | Upsert Policy Attachment | file size not excced 36MB | POST | Single | Real-time |  | R1 |  |
| 4 | Microservice - CalculatePolicyPremium | Calculate Policy Premium | Using for endorsment that effect policy premium | POST | Single | Real-time |  |  | รอสูตรการคำนวน / to be discussed with IIA/IT TIP |
| 6 | Microservice - Case | Upsert Case | Using for create/update case endorsement on PWA and Mobile App | POST | Single | Real-time |  |  |  |
| 6 | Microservice - Claim | Upsert Claim | Create/Update claim to third party system like SF, iSurvey | POST | Single | Real-time |  | R1 |  |
| 6 | Microservice - ClaimCoverage | Upsert Claim Coverage (Auto) | Create/Update claim coverage from EMCS to IIA using claimID for external ID (2.7.1) | POST | Multiple | Real-time |  |  | https://drive.google.com/file/d/12pOI1KTx2taf7Xus3naGCIGUu9x5zH6a/view?usp=share_link |
|  |  | Master Expense and Deduct |  |  |  |  |  |  |  |
| 7 | Microservice - ClaimCoverage (Other) | Upsert Claim Coverage (Health, Asset) | Create/Update claim coverage from SF to IIA | POST | Multiple | Real-time |  |  |  |
| 8 | Microservice - ClaimPayment | Upsert Claim Payment (Auto) | Create/Update claim payment from EMCS to IIA  (2.6) | POST | Multiple | Real-time |  |  | https://drive.google.com/file/d/1T5uf_xtA0dkBOdnbdcWP7BN4beDLuzRo/view?usp=share_link |
| 9 | Microservice - ClaimPayment (Other) | Upsert Claim Payment (Health, Asset) | Create/Update claim payment form SF to IIA | POST | Multiple | Real-time |  |  |  |
| 10 | Microservice-Recovery | Upsert Recovery | Create/Update claim recovery from SF to IIA | POST | Multiple | Real-time |  |  |  |
| 11 | Microservice-ClaimAttachment (EMCS) | Upsert Claim Attachment (EMCS) | Using for notify GCP to get file from EMCS  (2.2.2) | POST | Multiple | Real-time |  |  |  |
| 7 | Microservice-ClaimAttachment(SF) | Upsert Claim Attachment (SF) | Using for upload file from Salesforce to GCP | POST | Single | Real-time |  | R1 |  |
| 8 | Mocroservice-iBilling | iBilling | Using forword billing form iSurvey to IIA | POST | Multiple | Real-time |  | R1 |  |
| 9 | Microservice - VRA Request | VRA Request | Send link to join face to face video call to Mobile app | POST | Single | Real-time |  |  |  |
| 14 | Microservice - Notification | Notification | Using for send SMS or InApp Noti | POST | Single | Real-time |  | x |  |
| 9 | Microservice - Send SMS | Send SMS | Using for send SMS | POST | Single | Real-time |  | R1 |  |
| 12 | Microservice - Noti App | Noti App | Using for send InApp Noti | POST | Single | Real-time |  |  |  |
| 13 | Microservice - Deleted File URL | Delete File URL | Using for delete file URL on GCP | POST | Multiple | Real-time |  |  |  |
| 10 | Microservice - Customer Detail | Update Customer Detail | Using for Customer Detail from SF, eg. Email | POST | Single | Real-time |  | R2.5 |  |
| 15 | Microservice-Update Policy | Update Policy | Using for update policy's detail eg. Address (without  lor yor) | POST | Single | Real-time |  | R2.5 |  |
| 11 | Microservice-Resend policy Email | Resend Policy Email | Using for resend policy email (policy+compulsory) | GET | Single | Real-time |  | R2.5 |  |
| 15 | Microservice-Resend compulsory Email | Resend Compulsory Email | Using for resend compulsory email | GET | Single | Real-time |  |  |  |
| 12 | Microservice-Resend endores Email | Resend Endorsement Email | Using for resend endorsement email | GET | Single | Real-time |  | R2.5 |  |
| 13 | Microservice-File Attachment | Upsert File Attachment | Using for upload file from Salesforce to GCP | POST | Single | Real-time |  | R3.5 |  |
| 14 | Microservice-BusinessHour | Setup Business Hour | Using for Update Business Hour from Salesforce | POST | Single | Real-time |  | R3.5 |  |
|  | Source | IIA | Destination | Microservice |  |  |  |  |  |
| No | Sheet | Interface Name | Description | HTTP Method | Type | Interval | Trigger by | Confirm | Remark |
| 1 | Microservice-Claim Reserve/Adjust (Revise) | Upsert Claim Reserve/Adjust | Update Reserve/Adjust detail from IIA to SF | POST | Multiple | Real-time |  | R2.0 |  |
|  | Source | Salesforce | Destination | AWS |  |  |  |  |  |
| No | Sheet | Interface Name | Description | HTTP Method | Type | Interval | Trigger by | Confirm | Remark |
| 1 |  | AWS Authentication | Get access token for auterization other service | POST | Single | Real-time |  | R3.5 |  |
| 2 | AWS-Offline Message | Get Offline Message | Using for get message that leaving out business hour | POST | Single | Real-time |  | R3.5 | ติดเรื่องไฟล์ |
| 3 | AWS-BusinessHour | Setup Business Hour | Using for Update Business Hour from Salesforce | POST | Single | Real-time |  | R3.5 | Ready to Test |
| 4 | AWS-Boardcast | Boardcast Message | Using for send message to social channel in case chat was end | POST | Single | Real-time |  | R3.5 | Line 100% : FB 100% |
| 5 | AWS-SendFile | Send File | Using for send file to social channel | POST | Single | Real-time |  | R3.5 | 0 |
|  | Source | AWS | Destination | Salesforce |  |  |  |  |  |
| No | Sheet | Interface Name | Description | HTTP Method | Type | Interval | Trigger by | Confirm | Remark |
| 1 | Microservice OAuth 2.0 Authentication | Microservice Authentication | Get access token for auterization other service | POST | Single |  | - | R1 |  |
| 2 | Salesforce-Create Chat | Create a Chat Session | Mapping Field for create chat |  |  |  |  | R3.5 |  |
|  | Source | AWS | Destination | Microservice |  |  |  |  |  |
| No | Sheet | Interface Name | Description | HTTP Method | Type | Interval | Trigger by | Confirm | Remark |
| 1 | Microservice OAuth 2.0 Authentication | Microservice Authentication | Get access token for auterization other service | POST | Single |  | - | R1 |  |
| 2 | Microservice-File Attachment | Upsert File Attachment | Using for upload file from Salesforce to GCP | POST | Single | Real-time |  | R3.5 | Target 8 Dec |
