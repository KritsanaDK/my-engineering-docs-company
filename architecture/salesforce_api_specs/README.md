# Salesforce & Microservice Integration Specification V4.0

> **System:** InsurVerse Integration Hub (Microservices <-> Salesforce DC / VRA / AWS Connect)
> **Source:** `Technical Doc_ InsurVerse - Integration_Spec_SF V4.0.xlsx`
> **Total Interfaces / Sheets:** 72

---

## Directory Index

- [`01_sfdc_inbound/`](01_sfdc_inbound/): Microservice calling Salesforce APEX REST APIs
- [`02_microservice_inbound/`](02_microservice_inbound/): Salesforce calling Microservice Inbound APIs
- [`03_aws_and_frontend/`](03_aws_and_frontend/): AWS Connect Contact Center & Frontend integrations
- [`04_data_dictionary/`](04_data_dictionary/): Master Interface Table, Coverage Attribute Specs, and Code Matrices
- [`../salesforce_integration_spec_v4_conflicts.md`](../salesforce_integration_spec_v4_conflicts.md): Comprehensive Analysis of Spec & Field Conflicts

---

## Complete Sheet Catalog

| No. | Sheet Name | Category | Total Rows | Documentation Link |
| :--- | :--- | :--- | :--- | :--- |
| 01 | `Sheet6` | `misc` | 4 | [01_sheet6.md](01_sheet6.md) |
| 02 | `Interface` | `data_dictionary` | 83 | [02_interface.md](04_data_dictionary/02_interface.md) |
| 03 | `Attribute Coverage Spec` | `data_dictionary` | 11 | [03_attribute_coverage_spec.md](04_data_dictionary/03_attribute_coverage_spec.md) |
| 04 | `SFCD OAuth 2.0 Authentication` | `sfdc_inbound` | 33 | [04_sfcd_oauth_2_0_authentication.md](01_sfdc_inbound/04_sfcd_oauth_2_0_authentication.md) |
| 05 | `SF-Lead` | `sfdc_inbound` | 42 | [05_sf-lead.md](01_sfdc_inbound/05_sf-lead.md) |
| 06 | `SF-Account` | `sfdc_inbound` | 48 | [06_sf-account.md](01_sfdc_inbound/06_sf-account.md) |
| 07 | `SF-PaymentPremium` | `sfdc_inbound` | 37 | [07_sf-paymentpremium.md](01_sfdc_inbound/07_sf-paymentpremium.md) |
| 08 | `SF-Policy` | `sfdc_inbound` | 120 | [08_sf-policy.md](01_sfdc_inbound/08_sf-policy.md) |
| 09 | `SF-Contact` | `sfdc_inbound` | 28 | [09_sf-contact.md](01_sfdc_inbound/09_sf-contact.md) |
| 10 | `SF-Quotation` | `sfdc_inbound` | 34 | [10_sf-quotation.md](01_sfdc_inbound/10_sf-quotation.md) |
| 11 | `SF-Product` | `sfdc_inbound` | 28 | [11_sf-product.md](01_sfdc_inbound/11_sf-product.md) |
| 12 | `SF-PolicyCoverage` | `sfdc_inbound` | 44 | [12_sf-policycoverage.md](01_sfdc_inbound/12_sf-policycoverage.md) |
| 13 | `SF-PolicyParticipant` | `sfdc_inbound` | 60 | [13_sf-policyparticipant.md](01_sfdc_inbound/13_sf-policyparticipant.md) |
| 14 | `SF-PolicyAsset` | `sfdc_inbound` | 70 | [14_sf-policyasset.md](01_sfdc_inbound/14_sf-policyasset.md) |
| 15 | `SF-PolicyTransaction` | `sfdc_inbound` | 174 | [15_sf-policytransaction.md](01_sfdc_inbound/15_sf-policytransaction.md) |
| 16 | `SF-Request Policy Document` | `sfdc_inbound` | 29 | [16_sf-request_policy_document.md](01_sfdc_inbound/16_sf-request_policy_document.md) |
| 17 | `SF-PolicyAttachment` | `sfdc_inbound` | 28 | [17_sf-policyattachment.md](01_sfdc_inbound/17_sf-policyattachment.md) |
| 18 | `SF-PolicyAttachment (URL)` | `sfdc_inbound` | 33 | [18_sf-policyattachment_(url).md](01_sfdc_inbound/18_sf-policyattachment_(url).md) |
| 19 | `SF-Case` | `sfdc_inbound` | 35 | [19_sf-case.md](01_sfdc_inbound/19_sf-case.md) |
| 20 | `SF-Claim` | `sfdc_inbound` | 40 | [20_sf-claim.md](01_sfdc_inbound/20_sf-claim.md) |
| 21 | `SF-ClaimAttachmentURL` | `sfdc_inbound` | 38 | [21_sf-claimattachmenturl.md](01_sfdc_inbound/21_sf-claimattachmenturl.md) |
| 22 | `SF - Claim Attachment (Back Up)` | `sfdc_inbound` | 27 | [22_sf_-_claim_attachment_(back_up).md](01_sfdc_inbound/22_sf_-_claim_attachment_(back_up).md) |
| 23 | `SF - Get Knowledge` | `sfdc_inbound` | 26 | [23_sf_-_get_knowledge.md](01_sfdc_inbound/23_sf_-_get_knowledge.md) |
| 24 | `SF-Claim ReserveAdjust` | `sfdc_inbound` | 227 | [24_sf-claim_reserveadjust.md](01_sfdc_inbound/24_sf-claim_reserveadjust.md) |
| 25 | `SF-Claim ReserveAdjust (Revise)` | `sfdc_inbound` | 69 | [25_sf-claim_reserveadjust_(revise).md](01_sfdc_inbound/25_sf-claim_reserveadjust_(revise).md) |
| 26 | `SF-FileAttachmentURL` | `sfdc_inbound` | 33 | [26_sf-fileattachmenturl.md](01_sfdc_inbound/26_sf-fileattachmenturl.md) |
| 27 | `SF-Claim Payment Summary` | `sfdc_inbound` | 74 | [27_sf-claim_payment_summary.md](01_sfdc_inbound/27_sf-claim_payment_summary.md) |
| 28 | `SF-Claim Paid` | `sfdc_inbound` | 29 | [28_sf-claim_paid.md](01_sfdc_inbound/28_sf-claim_paid.md) |
| 29 | `SF-Claim Recovery` | `sfdc_inbound` | 39 | [29_sf-claim_recovery.md](01_sfdc_inbound/29_sf-claim_recovery.md) |
| 30 | `SF - Update Customer Location` | `sfdc_inbound` | 28 | [30_sf_-_update_customer_location.md](01_sfdc_inbound/30_sf_-_update_customer_location.md) |
| 31 | `Microservice Authen` | `microservice_inbound` | 35 | [31_microservice_authen.md](02_microservice_inbound/31_microservice_authen.md) |
| 32 | `R1 Microservice-PolicyTransacti` | `microservice_inbound` | 51 | [32_r1_microservice-policytransacti.md](02_microservice_inbound/32_r1_microservice-policytransacti.md) |
| 33 | `Microservice-Get Motor Master` | `microservice_inbound` | 70 | [33_microservice-get_motor_master.md](02_microservice_inbound/33_microservice-get_motor_master.md) |
| 34 | `Microservice-Get Motor Coverage` | `microservice_inbound` | 62 | [34_microservice-get_motor_coverage.md](02_microservice_inbound/34_microservice-get_motor_coverage.md) |
| 35 | `R2.5 Microservice-PolicyTransac` | `microservice_inbound` | 194 | [35_r2_5_microservice-policytransac.md](02_microservice_inbound/35_r2_5_microservice-policytransac.md) |
| 36 | `Microservice-Account` | `microservice_inbound` | 41 | [36_microservice-account.md](02_microservice_inbound/36_microservice-account.md) |
| 37 | `Microservice-Policy` | `microservice_inbound` | 51 | [37_microservice-policy.md](02_microservice_inbound/37_microservice-policy.md) |
| 38 | `Microservice-PolicyParticipant` | `microservice_inbound` | 49 | [38_microservice-policyparticipant.md](02_microservice_inbound/38_microservice-policyparticipant.md) |
| 39 | `Microservice-PolicyAsset` | `microservice_inbound` | 59 | [39_microservice-policyasset.md](02_microservice_inbound/39_microservice-policyasset.md) |
| 40 | `Microservice - CalculatePolicyP` | `microservice_inbound` | 27 | [40_microservice_-_calculatepolicyp.md](02_microservice_inbound/40_microservice_-_calculatepolicyp.md) |
| 41 | `Microservice-PolicyAttachment` | `microservice_inbound` | 32 | [41_microservice-policyattachment.md](02_microservice_inbound/41_microservice-policyattachment.md) |
| 42 | `Microservice-Case` | `microservice_inbound` | 32 | [42_microservice-case.md](02_microservice_inbound/42_microservice-case.md) |
| 43 | `Microservice-Claim` | `microservice_inbound` | 126 | [43_microservice-claim.md](02_microservice_inbound/43_microservice-claim.md) |
| 44 | `Microservice-ClaimCoverage` | `microservice_inbound` | 298 | [44_microservice-claimcoverage.md](02_microservice_inbound/44_microservice-claimcoverage.md) |
| 45 | `Microservice-ClaimCoverage (Oth` | `microservice_inbound` | 217 | [45_microservice-claimcoverage_(oth.md](02_microservice_inbound/45_microservice-claimcoverage_(oth.md) |
| 46 | `(Revise)Microservice-ClaimCover` | `microservice_inbound` | 140 | [46_(revise)microservice-claimcover.md](02_microservice_inbound/46_(revise)microservice-claimcover.md) |
| 47 | `Microservice-ClaimPayment` | `microservice_inbound` | 55 | [47_microservice-claimpayment.md](02_microservice_inbound/47_microservice-claimpayment.md) |
| 48 | `Microservice-ClaimPayment (Othe` | `microservice_inbound` | 75 | [48_microservice-claimpayment_(othe.md](02_microservice_inbound/48_microservice-claimpayment_(othe.md) |
| 49 | `Microservice-Recovery` | `microservice_inbound` | 39 | [49_microservice-recovery.md](02_microservice_inbound/49_microservice-recovery.md) |
| 50 | `Microservice-Claim ReserveAdjus` | `microservice_inbound` | 69 | [50_microservice-claim_reserveadjus.md](02_microservice_inbound/50_microservice-claim_reserveadjus.md) |
| 51 | `Microservice-ClaimAttachment` | `microservice_inbound` | 36 | [51_microservice-claimattachment.md](02_microservice_inbound/51_microservice-claimattachment.md) |
| 52 | `Microservice-ClaimAttachment (E` | `microservice_inbound` | 23 | [52_microservice-claimattachment_(e.md](02_microservice_inbound/52_microservice-claimattachment_(e.md) |
| 53 | `Microservice-iBilling` | `microservice_inbound` | 63 | [53_microservice-ibilling.md](02_microservice_inbound/53_microservice-ibilling.md) |
| 54 | `Microservice-VRA Request` | `microservice_inbound` | 23 | [54_microservice-vra_request.md](02_microservice_inbound/54_microservice-vra_request.md) |
| 55 | `Microservice-Notification (Old)` | `microservice_inbound` | 26 | [55_microservice-notification_(old).md](02_microservice_inbound/55_microservice-notification_(old).md) |
| 56 | `Microservice-Noti (Email)` | `microservice_inbound` | 26 | [56_microservice-noti_(email).md](02_microservice_inbound/56_microservice-noti_(email).md) |
| 57 | `Microservice-Noti (SMS)` | `microservice_inbound` | 23 | [57_microservice-noti_(sms).md](02_microservice_inbound/57_microservice-noti_(sms).md) |
| 58 | `Microservice-Noti (App)` | `microservice_inbound` | 23 | [58_microservice-noti_(app).md](02_microservice_inbound/58_microservice-noti_(app).md) |
| 59 | `Microservice-Delete File URL` | `microservice_inbound` | 26 | [59_microservice-delete_file_url.md](02_microservice_inbound/59_microservice-delete_file_url.md) |
| 60 | `Microservice-Customer Detail` | `microservice_inbound` | 27 | [60_microservice-customer_detail.md](02_microservice_inbound/60_microservice-customer_detail.md) |
| 61 | `Microservice-Update Policy` | `microservice_inbound` | 31 | [61_microservice-update_policy.md](02_microservice_inbound/61_microservice-update_policy.md) |
| 62 | `Microservice-Resend policy Emai` | `microservice_inbound` | 23 | [62_microservice-resend_policy_emai.md](02_microservice_inbound/62_microservice-resend_policy_emai.md) |
| 63 | `Microservice-Resend endorse Ema` | `microservice_inbound` | 22 | [63_microservice-resend_endorse_ema.md](02_microservice_inbound/63_microservice-resend_endorse_ema.md) |
| 64 | `Microservice-FileAttachment` | `microservice_inbound` | 31 | [64_microservice-fileattachment.md](02_microservice_inbound/64_microservice-fileattachment.md) |
| 65 | `Microservice-BusinessHour` | `microservice_inbound` | 25 | [65_microservice-businesshour.md](02_microservice_inbound/65_microservice-businesshour.md) |
| 66 | `frontend-BusinessHour` | `aws_and_frontend` | 23 | [66_frontend-businesshour.md](03_aws_and_frontend/66_frontend-businesshour.md) |
| 67 | `AWS-Offline Message` | `aws_and_frontend` | 24 | [67_aws-offline_message.md](03_aws_and_frontend/67_aws-offline_message.md) |
| 68 | `AWS-BusinessHour` | `aws_and_frontend` | 23 | [68_aws-businesshour.md](03_aws_and_frontend/68_aws-businesshour.md) |
| 69 | `AWS-Boardcast` | `aws_and_frontend` | 25 | [69_aws-boardcast.md](03_aws_and_frontend/69_aws-boardcast.md) |
| 70 | `AWS-SendFile` | `aws_and_frontend` | 26 | [70_aws-sendfile.md](03_aws_and_frontend/70_aws-sendfile.md) |
| 71 | `Salesforce-Create Chat` | `aws_and_frontend` | 11 | [71_salesforce-create_chat.md](03_aws_and_frontend/71_salesforce-create_chat.md) |
| 72 | `Microservice-Resend compulsory ` | `microservice_inbound` | 22 | [72_microservice-resend_compulsory.md](02_microservice_inbound/72_microservice-resend_compulsory.md) |
