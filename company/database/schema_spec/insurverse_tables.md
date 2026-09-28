# Schema `insurverse` — Tables

> Generated 2026-09-23 from **UAT-ISV** (`insurverse` DB), read-only catalog metadata. Row counts are `pg_class.reltuples` estimates (0 / -1 = never analyzed).

Back to [README](README.md) · [Functions & Triggers](functions_and_triggers.md)

**300 tables.** Tables flagged *(snapshot?)* look like dated/backup copies by name.

## Index

| # | Table | Cols | Est. rows | PK | Note |
|---|---|---|---|---|---|
| 1 | [Act_Renewal_Reminder](#act_renewal_reminder) | 7 | 0 | — |  |
| 2 | [Imp_Discount_Premium](#imp_discount_premium) | 24 | 23,665 | — |  |
| 3 | [Imp_Discount_Premium_bak_20260630](#imp_discount_premium_bak_20260630) | 24 | 23,171 | — | *(snapshot?)* |
| 4 | [Imp_Price_Premium](#imp_price_premium) | 80 | 130,000 | — |  |
| 5 | [Imp_Price_Premium_20251118](#imp_price_premium_20251118) | 72 | 0 | — | *(snapshot?)* |
| 6 | [Imp_Price_Premium_bak_20260630](#imp_price_premium_bak_20260630) | 80 | 0 | — | *(snapshot?)* |
| 7 | [Lead_Car_Act_Discount_Premium](#lead_car_act_discount_premium) | 115 | 286 | Car_Act_Lead_No |  |
| 8 | [Lead_coverage_premium](#lead_coverage_premium) | 283 | 278 | Lead_No |  |
| 9 | [Lead_coverage_premium_2](#lead_coverage_premium_2) | 212 | 0 | — | *(snapshot?)* |
| 10 | [Lead_coverage_premium_20260810](#lead_coverage_premium_20260810) | 278 | 0 | — | *(snapshot?)* |
| 11 | [OIC_Perc_Discount_by_Day](#oic_perc_discount_by_day) | 8 | 0 | Range_start,Range_end |  |
| 12 | [OIC_Perc_Return_Act_by_Day](#oic_perc_return_act_by_day) | 8 | 0 | Range_start,Range_end |  |
| 13 | [OIC_Perc_Return_by_Day](#oic_perc_return_by_day) | 8 | 0 | Range_start,Range_end |  |
| 14 | [Policy_Car_Act_Discount_Premium](#policy_car_act_discount_premium) | 134 | 246 | Car_Act_No |  |
| 15 | [Policy_Car_Act_Discount_Premium_8aug](#policy_car_act_discount_premium_8aug) | 129 | 0 | — | *(snapshot?)* |
| 16 | [Policy_Car_Act_Discount_Premium_Trans](#policy_car_act_discount_premium_trans) | 134 | 0 | Car_Act_No,Effective_Startdate,Create_date |  |
| 17 | [Policy_Car_Act_Discount_Premium_Trans_20260810](#policy_car_act_discount_premium_trans_20260810) | 132 | 0 | — | *(snapshot?)* |
| 18 | [Policy_Header](#policy_header) | 162 | 140 | Policy_No |  |
| 19 | [Policy_Header_20260810](#policy_header_20260810) | 157 | 0 | — | *(snapshot?)* |
| 20 | [Policy_Header_Trans](#policy_header_trans) | 162 | 0 | Policy_No,Effective_Startdate,Create_date |  |
| 21 | [Policy_Header_Trans_20260810](#policy_header_trans_20260810) | 157 | 0 | — | *(snapshot?)* |
| 22 | [Policy_Regis_Evident](#policy_regis_evident) | 16 | 0 | Policy_No,Evi_ID,Evi_Sector_ID |  |
| 23 | [Policy_coverage_premium](#policy_coverage_premium) | 280 | 0 | Policy_No |  |
| 24 | [Policy_coverage_premium_2](#policy_coverage_premium_2) | 200 | 0 | — | *(snapshot?)* |
| 25 | [Policy_coverage_premium_20260810](#policy_coverage_premium_20260810) | 265 | 0 | — | *(snapshot?)* |
| 26 | [Policy_coverage_premium_Trans](#policy_coverage_premium_trans) | 270 | 0 | Policy_No,Effective_Startdate,Create_date |  |
| 27 | [Policy_coverage_premium_Trans_20260810](#policy_coverage_premium_trans_20260810) | 265 | 0 | — | *(snapshot?)* |
| 28 | [Policy_email_confirm](#policy_email_confirm) | 13 | 0 | id |  |
| 29 | [Policy_endorse_detail](#policy_endorse_detail) | 27 | 0 | id |  |
| 30 | [SequelizeMeta](#sequelizemeta) | 1 | 0 | — |  |
| 31 | [Sys_Domain](#sys_domain) | 7 | 10 | Dom_code |  |
| 32 | [Sys_Sub_domain](#sys_sub_domain) | 8 | 0 | Dom_code,Sub_dom_code |  |
| 33 | [act](#act) | 12 | 0 | — |  |
| 34 | [activity_type](#activity_type) | 2 | 0 | id |  |
| 35 | [amlo_idnumber](#amlo_idnumber) | 14 | 0 | — |  |
| 36 | [amlo_master](#amlo_master) | 29 | 0 | — |  |
| 37 | [amlo_name](#amlo_name) | 24 | 0 | — |  |
| 38 | [api_flow_log](#api_flow_log) | 13 | 83 | id |  |
| 39 | [api_payload_logs](#api_payload_logs) | 13 | 0 | — |  |
| 40 | [app_notification](#app_notification) | 19 | 0 | — |  |
| 41 | [app_notification_token](#app_notification_token) | 4 | 0 | — |  |
| 42 | [batch_jobs](#batch_jobs) | 10 | 0 | id |  |
| 43 | [batch_payment_errors](#batch_payment_errors) | 5 | 0 | — |  |
| 44 | [calculate_premium_job](#calculate_premium_job) | 4 | 0 | id |  |
| 45 | [callback_logs](#callback_logs) | 30 | 115 | id |  |
| 46 | [callback_logs_prod](#callback_logs_prod) | 30 | 0 | — | *(snapshot?)* |
| 47 | [carmodel](#carmodel) | 4 | 0 | — |  |
| 48 | [claim_request](#claim_request) | 24 | 0 | claim_request_id |  |
| 49 | [claim_request_attach](#claim_request_attach) | 21 | 0 | id |  |
| 50 | [company_detail](#company_detail) | 32 | 0 | comp_code |  |
| 51 | [consent_accept](#consent_accept) | 9 | 3 | id |  |
| 52 | [consent_content](#consent_content) | 9 | 15 | id |  |
| 53 | [consent_marketing](#consent_marketing) | 12 | 0 | id |  |
| 54 | [consent_purpose](#consent_purpose) | 13 | 10 | id |  |
| 55 | [consent_rop](#consent_rop) | 22 | 103 | id |  |
| 56 | [cs_impersonation](#cs_impersonation) | 11 | 0 | — |  |
| 57 | [district](#district) | 5 | 929 | districtid |  |
| 58 | [district_12sep67](#district_12sep67) | 5 | 929 | — | *(snapshot?)* |
| 59 | [district_add](#district_add) | 5 | 980 | — | *(snapshot?)* |
| 60 | [ekyc_ocr](#ekyc_ocr) | 26 | 0 | id |  |
| 61 | [email_api_keys](#email_api_keys) | 8 | 0 | id |  |
| 62 | [email_logs](#email_logs) | 13 | 0 | id |  |
| 63 | [email_webhooks](#email_webhooks) | 8 | 0 | id |  |
| 64 | [emcs_getimage_ar](#emcs_getimage_ar) | 9 | 0 | emcs_ar_id |  |
| 65 | [emcs_getimage_detail](#emcs_getimage_detail) | 20 | 0 | id |  |
| 66 | [hbdisv_event](#hbdisv_event) | 6 | 0 | — |  |
| 67 | [iia_commission](#iia_commission) | 25 | 0 | id |  |
| 68 | [iia_data_sr_claim_motor_movement](#iia_data_sr_claim_motor_movement) | 57 | 0 | approvedate,claimno,rectype,estimateno |  |
| 69 | [iia_data_sr_claim_motor_movement_allocate_expense](#iia_data_sr_claim_motor_movement_allocate_expense) | 75 | 0 | approvedate,claimno,estimateno,rectype |  |
| 70 | [iia_data_sr_claim_nonmotor_movement](#iia_data_sr_claim_nonmotor_movement) | 34 | 0 | approvedate,dfclaimno,estimateno |  |
| 71 | [iia_data_sr_motor_claim_lastversion](#iia_data_sr_motor_claim_lastversion) | 54 | 0 | claimno |  |
| 72 | [iia_data_sr_nonmotor_claim_lastversion](#iia_data_sr_nonmotor_claim_lastversion) | 38 | 0 | id |  |
| 73 | [iia_data_sr_policy_daily](#iia_data_sr_policy_daily) | 91 | 0 | reportdate,dfpolicyno,endorseseries |  |
| 74 | [iia_data_sr_policy_daily_lastversion](#iia_data_sr_policy_daily_lastversion) | 62 | 0 | dfpolicyno |  |
| 75 | [imp_discount_premium](#imp_discount_premium) | 24 | 41,969 | — |  |
| 76 | [imp_discount_premium_020925](#imp_discount_premium_020925) | 23 | 0 | — | *(snapshot?)* |
| 77 | [imp_discount_premium_040226](#imp_discount_premium_040226) | 23 | 0 | — | *(snapshot?)* |
| 78 | [imp_discount_premium_160226](#imp_discount_premium_160226) | 23 | 0 | — | *(snapshot?)* |
| 79 | [imp_discount_premium_20260703](#imp_discount_premium_20260703) | 24 | 0 | — | *(snapshot?)* |
| 80 | [imp_discount_premium_20260727](#imp_discount_premium_20260727) | 23 | 0 | — | *(snapshot?)* |
| 81 | [imp_discount_premium_20260806](#imp_discount_premium_20260806) | 23 | 0 | — | *(snapshot?)* |
| 82 | [imp_discount_premium_20260810](#imp_discount_premium_20260810) | 23 | 0 | — | *(snapshot?)* |
| 83 | [imp_discount_premium_20260820](#imp_discount_premium_20260820) | 23 | 0 | — | *(snapshot?)* |
| 84 | [imp_price_premium_020925](#imp_price_premium_020925) | 72 | 0 | — | *(snapshot?)* |
| 85 | [imp_price_premium_040226](#imp_price_premium_040226) | 80 | 0 | — | *(snapshot?)* |
| 86 | [imp_price_premium_160226](#imp_price_premium_160226) | 80 | 0 | — | *(snapshot?)* |
| 87 | [imp_price_premium_20260806](#imp_price_premium_20260806) | 80 | 0 | — | *(snapshot?)* |
| 88 | [imp_price_premium_20260810](#imp_price_premium_20260810) | 80 | 0 | — | *(snapshot?)* |
| 89 | [imp_price_premium_20260820](#imp_price_premium_20260820) | 80 | 0 | — | *(snapshot?)* |
| 90 | [imp_price_premium_bk_20260727](#imp_price_premium_bk_20260727) | 80 | 0 | — | *(snapshot?)* |
| 91 | [jwt_tokens](#jwt_tokens) | 5 | 0 | id |  |
| 92 | [lead_consent](#lead_consent) | 4 | 0 | id |  |
| 93 | [lead_home_coverage](#lead_home_coverage) | 33 | 0 | lead_home_no |  |
| 94 | [lead_home_coverage_trans](#lead_home_coverage_trans) | 33 | 0 | lead_home_no,sf_policy_id |  |
| 95 | [lead_home_participant](#lead_home_participant) | 35 | 0 | lead_home_no |  |
| 96 | [lead_home_participant_trans](#lead_home_participant_trans) | 35 | 0 | lead_home_no,sf_policy_id |  |
| 97 | [lead_home_premium](#lead_home_premium) | 52 | 0 | lead_home_no |  |
| 98 | [lead_home_premium_tariff](#lead_home_premium_tariff) | 22 | 0 | lead_home_no,home_premium_tariff_id |  |
| 99 | [lead_info_customer](#lead_info_customer) | 12 | 0 | lead_info_id |  |
| 100 | [lead_pa_beneficiary](#lead_pa_beneficiary) | 17 | 0 | lead_pa_no,bene_index |  |
| 101 | [lead_pa_beneficiary_trans](#lead_pa_beneficiary_trans) | 17 | 0 | lead_pa_no,bene_index,sf_policy_id |  |
| 102 | [lead_pa_coverage](#lead_pa_coverage) | 22 | 0 | lead_pa_no,pa_coverage_id |  |
| 103 | [lead_pa_coverage_trans](#lead_pa_coverage_trans) | 22 | 0 | lead_pa_no,pa_coverage_id,sf_policy_id |  |
| 104 | [lead_pa_participant](#lead_pa_participant) | 27 | 0 | lead_pa_no,owner_index |  |
| 105 | [lead_pa_participant_trans](#lead_pa_participant_trans) | 27 | 0 | lead_pa_no,owner_index,sf_policy_id |  |
| 106 | [lead_pa_premium](#lead_pa_premium) | 45 | 0 | lead_pa_no |  |
| 107 | [lead_ta_package](#lead_ta_package) | 14 | 0 | lead_ta_no,ta_package_id |  |
| 108 | [lead_ta_package_trans](#lead_ta_package_trans) | 14 | 0 | lead_ta_no,ta_package_id,sf_policy_id |  |
| 109 | [lead_ta_participant](#lead_ta_participant) | 60 | 0 | lead_ta_no,owner_index |  |
| 110 | [lead_ta_participant_trans](#lead_ta_participant_trans) | 55 | 0 | lead_ta_no,owner_index,sf_policy_id |  |
| 111 | [lead_ta_premium](#lead_ta_premium) | 49 | 0 | lead_ta_no |  |
| 112 | [log_activity](#log_activity) | 8 | 0 | id |  |
| 113 | [log_activity_ref](#log_activity_ref) | 3 | 0 | id |  |
| 114 | [log_api_thaibulk](#log_api_thaibulk) | 13 | 0 | — |  |
| 115 | [log_calculate_premium](#log_calculate_premium) | 4 | 0 | id |  |
| 116 | [log_cmi_realtime](#log_cmi_realtime) | 12 | 0 | id |  |
| 117 | [log_email_change](#log_email_change) | 8 | 0 | ref_id |  |
| 118 | [log_email_renewal](#log_email_renewal) | 8 | 110 | id |  |
| 119 | [log_email_resend](#log_email_resend) | 13 | 0 | id |  |
| 120 | [log_emcs_claim](#log_emcs_claim) | 14 | 0 | id |  |
| 121 | [log_etax_trans](#log_etax_trans) | 12 | 0 | id |  |
| 122 | [log_iia_claim](#log_iia_claim) | 12 | 0 | id |  |
| 123 | [log_iia_policy](#log_iia_policy) | 12 | 144 | id |  |
| 124 | [log_iia_policy_trans](#log_iia_policy_trans) | 11 | 0 | id |  |
| 125 | [log_internal_interface](#log_internal_interface) | 13 | 2,328 | id |  |
| 126 | [log_mobile](#log_mobile) | 10 | 0 | id |  |
| 127 | [log_noti_push](#log_noti_push) | 10 | 106 | id |  |
| 128 | [log_noti_renewal](#log_noti_renewal) | 22 | 0 | id |  |
| 129 | [log_openapi_interface](#log_openapi_interface) | 12 | 455 | id |  |
| 130 | [log_point_expire](#log_point_expire) | 7 | 0 | id |  |
| 131 | [log_priceza](#log_priceza) | 11 | 1 | id |  |
| 132 | [log_request_home](#log_request_home) | 14 | 0 | — |  |
| 133 | [log_request_pa](#log_request_pa) | 14 | 0 | id |  |
| 134 | [log_request_ta](#log_request_ta) | 14 | 0 | id |  |
| 135 | [log_sf_policy](#log_sf_policy) | 12 | 804 | id |  |
| 136 | [log_sf_policy_trans](#log_sf_policy_trans) | 110 | 0 | id |  |
| 137 | [log_sf_policy_trans_20260810](#log_sf_policy_trans_20260810) | 104 | 0 | — | *(snapshot?)* |
| 138 | [log_sf_policy_trans_request](#log_sf_policy_trans_request) | 159 | 0 | id |  |
| 139 | [log_tariff_renewal](#log_tariff_renewal) | 4 | 0 | — |  |
| 140 | [log_thaibulk_send](#log_thaibulk_send) | 12 | 0 | — |  |
| 141 | [log_workflow_process](#log_workflow_process) | 12 | 0 | id |  |
| 142 | [log_yipinsoi](#log_yipinsoi) | 10 | 0 | id |  |
| 143 | [loyalty_condition](#loyalty_condition) | 19 | 0 | loyalty_con_id |  |
| 144 | [loyalty_point_trans](#loyalty_point_trans) | 15 | 0 | point_trans_id |  |
| 145 | [mas_car_prices](#mas_car_prices) | 7 | 0 | — |  |
| 146 | [mas_cmi_brand_model](#mas_cmi_brand_model) | 4 | 4,493 | brand_id,model_id |  |
| 147 | [mas_cmi_color](#mas_cmi_color) | 3 | 107 | color_id |  |
| 148 | [mas_cmi_color_7_5_24](#mas_cmi_color_7_5_24) | 3 | 0 | — | *(snapshot?)* |
| 149 | [mas_cmi_province](#mas_cmi_province) | 4 | 81 | cmi_prov_id |  |
| 150 | [mas_cmi_province_tqm](#mas_cmi_province_tqm) | 5 | 0 | — | *(snapshot?)* |
| 151 | [mas_country](#mas_country) | 10 | 189 | country_id |  |
| 152 | [mas_country_21jan](#mas_country_21jan) | 9 | 0 | — | *(snapshot?)* |
| 153 | [mas_country_30032567](#mas_country_30032567) | 9 | 0 | — | *(snapshot?)* |
| 154 | [mas_home_building_type](#mas_home_building_type) | 12 | 2 | home_building_type_id |  |
| 155 | [mas_home_coverage](#mas_home_coverage) | 17 | 11 | home_coverage_id |  |
| 156 | [mas_home_coverage_group](#mas_home_coverage_group) | 11 | 4 | home_coverage_group_id |  |
| 157 | [mas_home_material_type](#mas_home_material_type) | 13 | 3 | home_material_type_id |  |
| 158 | [mas_home_premium_tariff](#mas_home_premium_tariff) | 19 | 18 | home_premium_tariff_id |  |
| 159 | [mas_home_premium_tariff_2](#mas_home_premium_tariff_2) | 19 | 0 | — | *(snapshot?)* |
| 160 | [mas_home_province](#mas_home_province) | 4 | 77 | home_province_id |  |
| 161 | [mas_home_resident_type](#mas_home_resident_type) | 13 | 2 | home_resident_type_id |  |
| 162 | [mas_limite_purchase](#mas_limite_purchase) | 5 | 2 | id |  |
| 163 | [mas_mv_config](#mas_mv_config) | 6 | 0 | — |  |
| 164 | [mas_other_description](#mas_other_description) | 11 | 0 | mas_other_type,mas_other_code |  |
| 165 | [mas_pa_age_range](#mas_pa_age_range) | 7 | 3 | pa_age_range_id |  |
| 166 | [mas_pa_coverage](#mas_pa_coverage) | 23 | 5 | pa_coverage_id |  |
| 167 | [mas_pa_heath_question](#mas_pa_heath_question) | 7 | 2 | pa_question_id |  |
| 168 | [mas_pa_occupation](#mas_pa_occupation) | 10 | 27 | pa_occupation_id |  |
| 169 | [mas_pa_package](#mas_pa_package) | 17 | 4 | pa_package_id |  |
| 170 | [mas_pa_premium_tariff](#mas_pa_premium_tariff) | 10 | 15 | pa_premium_tariff_id |  |
| 171 | [mas_partner](#mas_partner) | 13 | 2 | partner_code |  |
| 172 | [mas_policy_product](#mas_policy_product) | 9 | 0 | product_code,sub_product_code |  |
| 173 | [mas_product_type](#mas_product_type) | 2 | 0 | id |  |
| 174 | [mas_renewal_config](#mas_renewal_config) | 21 | 0 | id |  |
| 175 | [mas_renewal_ncb](#mas_renewal_ncb) | 15 | 0 | id |  |
| 176 | [mas_renewal_premium](#mas_renewal_premium) | 13 | 0 | id |  |
| 177 | [mas_state](#mas_state) | 10 | 3,695 | state_id |  |
| 178 | [mas_ta_coverage](#mas_ta_coverage) | 20 | 27 | ta_coverage_id |  |
| 179 | [mas_ta_description](#mas_ta_description) | 7 | 22 | mas_ta_type,mas_ta_code |  |
| 180 | [mas_ta_package](#mas_ta_package) | 24 | 16 | ta_package_id |  |
| 181 | [mas_ta_package_coverage](#mas_ta_package_coverage) | 15 | 82 | ta_pack_cover_id |  |
| 182 | [mas_ta_package_coverage_26may2025](#mas_ta_package_coverage_26may2025) | 15 | 58 | — | *(snapshot?)* |
| 183 | [mas_ta_premium](#mas_ta_premium) | 12 | 965 | ta_premium_id |  |
| 184 | [mas_ta_premium_26may2025](#mas_ta_premium_26may2025) | 12 | 905 | — | *(snapshot?)* |
| 185 | [mas_ta_travel_type](#mas_ta_travel_type) | 11 | 3 | ta_travel_type_id |  |
| 186 | [mas_tariff](#mas_tariff) | 14 | 0 | tariff_id |  |
| 187 | [notification_business_rules](#notification_business_rules) | 19 | 0 | — |  |
| 188 | [notification_queue](#notification_queue) | 20 | 0 | — |  |
| 189 | [notification_templates_extended](#notification_templates_extended) | 13 | 0 | — |  |
| 190 | [otp_daily_requests](#otp_daily_requests) | 4 | 0 | id |  |
| 191 | [otp_settings](#otp_settings) | 5 | 0 | id |  |
| 192 | [otp_verification](#otp_verification) | 10 | 0 | id |  |
| 193 | [payment](#payment) | 23 | 1 | id |  |
| 194 | [payment_act](#payment_act) | 23 | 173 | id |  |
| 195 | [payment_callback](#payment_callback) | 8 | 38 | cb_no |  |
| 196 | [payment_ta](#payment_ta) | 15 | 0 | id |  |
| 197 | [payment_transaction](#payment_transaction) | 17 | 0 | id |  |
| 198 | [policy_cache_new](#policy_cache_new) | 0 | 0 | — |  |
| 199 | [policy_form_submissions](#policy_form_submissions) | 12 | 6 | id |  |
| 200 | [policy_form_templates](#policy_form_templates) | 9 | 6 | id |  |
| 201 | [policy_home_endorse_detail](#policy_home_endorse_detail) | 26 | 0 | id |  |
| 202 | [policy_home_premium](#policy_home_premium) | 63 | 0 | policy_home_no |  |
| 203 | [policy_home_premium_trans](#policy_home_premium_trans) | 63 | 0 | policy_home_no,sf_policy_id |  |
| 204 | [policy_no](#policy_no) | 4 | 106 | id |  |
| 205 | [policy_optimized_email_list](#policy_optimized_email_list) | 1 | 0 | email |  |
| 206 | [policy_overlap_whitelist](#policy_overlap_whitelist) | 9 | 0 | id |  |
| 207 | [policy_pa_endorse_detail](#policy_pa_endorse_detail) | 26 | 0 | id |  |
| 208 | [policy_pa_premium](#policy_pa_premium) | 64 | 0 | policy_pa_no |  |
| 209 | [policy_pa_premium_trans](#policy_pa_premium_trans) | 64 | 0 | policy_pa_no,sf_policy_id |  |
| 210 | [policy_participant](#policy_participant) | 11 | 162 | par_id |  |
| 211 | [policy_ta_coverage](#policy_ta_coverage) | 12 | 0 | policy_ta_no,ta_coverage_id |  |
| 212 | [policy_ta_coverage_trans](#policy_ta_coverage_trans) | 12 | 0 | policy_ta_no,ta_coverage_id,sf_policy_id |  |
| 213 | [policy_ta_endorse_detail](#policy_ta_endorse_detail) | 25 | 0 | id |  |
| 214 | [policy_ta_premium](#policy_ta_premium) | 60 | 0 | policy_ta_no |  |
| 215 | [policy_ta_premium_trans](#policy_ta_premium_trans) | 60 | 0 | policy_ta_no,sf_policy_id |  |
| 216 | [policy_workflow_process](#policy_workflow_process) | 13 | 0 | flow_process_id |  |
| 217 | [prefix](#prefix) | 2 | 0 | — |  |
| 218 | [promo_code](#promo_code) | 38 | 9,261 | promo_code_id |  |
| 219 | [promo_code_16oct](#promo_code_16oct) | 38 | 0 | — | *(snapshot?)* |
| 220 | [promo_code_26_4](#promo_code_26_4) | 38 | 0 | — | *(snapshot?)* |
| 221 | [promo_code_28042025](#promo_code_28042025) | 38 | 0 | — | *(snapshot?)* |
| 222 | [promo_code_30_4](#promo_code_30_4) | 38 | 0 | — | *(snapshot?)* |
| 223 | [promo_code_tep](#promo_code_tep) | 37 | 0 | — | *(snapshot?)* |
| 224 | [promo_code_trans](#promo_code_trans) | 13 | 0 | promo_trans_id |  |
| 225 | [promo_condition](#promo_condition) | 13 | 0 | promo_condition_id |  |
| 226 | [promo_group](#promo_group) | 16 | 0 | promo_group_id |  |
| 227 | [province](#province) | 5 | 78 | provinceid |  |
| 228 | [province_12sep67](#province_12sep67) | 5 | 78 | — | *(snapshot?)* |
| 229 | [province_add](#province_add) | 5 | 156 | — | *(snapshot?)* |
| 230 | [reconcile](#reconcile) | 18 | 1,241 | — |  |
| 231 | [renew_policy_batches](#renew_policy_batches) | 13 | 0 | — |  |
| 232 | [renew_policy_records](#renew_policy_records) | 38 | 0 | — |  |
| 233 | [renew_promocode_percent](#renew_promocode_percent) | 8 | 0 | — |  |
| 234 | [renewal_notification](#renewal_notification) | 16 | 0 | id |  |
| 235 | [renewal_payments](#renewal_payments) | 6 | 0 | id |  |
| 236 | [renewal_template](#renewal_template) | 13 | 0 | id |  |
| 237 | [request_contact](#request_contact) | 8 | 0 | id |  |
| 238 | [reset_password](#reset_password) | 9 | 0 | — |  |
| 239 | [rtn_json](#rtn_json) | 1 | 0 | — |  |
| 240 | [running_book_invoice](#running_book_invoice) | 5 | 0 | — |  |
| 241 | [running_quotation](#running_quotation) | 4 | 0 | — |  |
| 242 | [running_receipt](#running_receipt) | 4 | 0 | — |  |
| 243 | [sec_group](#sec_group) | 8 | 0 | group_code |  |
| 244 | [sec_group_menu](#sec_group_menu) | 6 | 0 | group_code,menu_id |  |
| 245 | [sec_group_user](#sec_group_user) | 6 | 0 | group_code,user_id |  |
| 246 | [sec_menu](#sec_menu) | 11 | 0 | menu_id |  |
| 247 | [sec_menu_scr](#sec_menu_scr) | 8 | 0 | menu_scr_id,menu_id,scr_id |  |
| 248 | [sec_screen](#sec_screen) | 12 | 0 | scr_id |  |
| 249 | [sec_user](#sec_user) | 39 | 3 | email |  |
| 250 | [sec_user_sso](#sec_user_sso) | 22 | 0 | user_id,sso_type |  |
| 251 | [sf_business_hour](#sf_business_hour) | 10 | 0 | id |  |
| 252 | [sf_claim](#sf_claim) | 63 | 0 | survey_report_id,ref_notify_no,ref_claim_no |  |
| 253 | [sf_claim_asset](#sf_claim_asset) | 14 | 0 | record_id,survey_report_id,ref_notify_no,ref_claim_no |  |
| 254 | [sf_claim_attech](#sf_claim_attech) | 18 | 0 | file_id |  |
| 255 | [sf_claim_backup](#sf_claim_backup) | 63 | 0 | — | *(snapshot?)* |
| 256 | [sf_claim_car_detail](#sf_claim_car_detail) | 34 | 0 | record_id,survey_report_id,ref_notify_no,ref_claim_no |  |
| 257 | [sf_claim_coverage](#sf_claim_coverage) | 15 | 0 | claim_id |  |
| 258 | [sf_claim_coverage_item](#sf_claim_coverage_item) | 31 | 0 | claim_id,coverage_id |  |
| 259 | [sf_claim_ibilling](#sf_claim_ibilling) | 25 | 0 | survey_report_id,ref_notify_no,ref_claim_no |  |
| 260 | [sf_claim_injured](#sf_claim_injured) | 22 | 0 | record_id,survey_report_id,ref_notify_no,ref_claim_no |  |
| 261 | [sf_claim_pay](#sf_claim_pay) | 22 | 0 | survey_report_id,ref_notify_no,ref_claim_no |  |
| 262 | [sf_file_attach](#sf_file_attach) | 12 | 0 | — |  |
| 263 | [shopee_app_access_token](#shopee_app_access_token) | 11 | 0 | id |  |
| 264 | [shopee_app_authorized](#shopee_app_authorized) | 7 | 0 | id |  |
| 265 | [shopee_product_form](#shopee_product_form) | 21 | 57 | — |  |
| 266 | [subdistrict](#subdistrict) | 9 | 7,469 | subdistrictid |  |
| 267 | [subdistrict_10jan](#subdistrict_10jan) | 9 | 0 | — | *(snapshot?)* |
| 268 | [subdistrict_12sep67](#subdistrict_12sep67) | 9 | 7,468 | — | *(snapshot?)* |
| 269 | [subdistrict_add](#subdistrict_add) | 9 | 7,660 | — | *(snapshot?)* |
| 270 | [sys_param](#sys_param) | 17 | 159 | dom_code,sub_dom_code,para_code |  |
| 271 | [sys_param_20260810](#sys_param_20260810) | 17 | 0 | — | *(snapshot?)* |
| 272 | [tbl_blacklist](#tbl_blacklist) | 13 | 47 | blacklist_id |  |
| 273 | [tbl_blacklist_request](#tbl_blacklist_request) | 17 | 47 | request_id |  |
| 274 | [temp_claims](#temp_claims) | 5 | 0 | id |  |
| 275 | [temp_otp](#temp_otp) | 12 | 118 | id |  |
| 276 | [thaibulk_configs](#thaibulk_configs) | 8 | 0 | id |  |
| 277 | [thaibulk_events](#thaibulk_events) | 8 | 0 | id |  |
| 278 | [thaibulk_templates](#thaibulk_templates) | 7 | 0 | id |  |
| 279 | [thaibulk_webhook_logs](#thaibulk_webhook_logs) | 8 | 0 | — |  |
| 280 | [tqm_allow_process](#tqm_allow_process) | 2 | 0 | api_name |  |
| 281 | [tqm_car_inspect_result](#tqm_car_inspect_result) | 13 | 0 | request_id |  |
| 282 | [tqm_car_license_provice](#tqm_car_license_provice) | 3 | 0 | pv_code |  |
| 283 | [tqm_car_mapping](#tqm_car_mapping) | 11 | 0 | id |  |
| 284 | [tqm_cargroup](#tqm_cargroup) | 11 | 0 | — |  |
| 285 | [tqm_district](#tqm_district) | 5 | 0 | full_code |  |
| 286 | [tqm_endorse_document_status](#tqm_endorse_document_status) | 4 | 0 | endorse_detail_id |  |
| 287 | [tqm_group_premium](#tqm_group_premium) | 14 | 0 | id |  |
| 288 | [tqm_lead_cmi](#tqm_lead_cmi) | 58 | 0 | reference_id |  |
| 289 | [tqm_lead_vmi](#tqm_lead_vmi) | 183 | 0 | sale_book_code |  |
| 290 | [tqm_notification_job](#tqm_notification_job) | 7 | 0 | sale_book_code |  |
| 291 | [tqm_package_config](#tqm_package_config) | 10 | 0 | package_id |  |
| 292 | [tqm_premium](#tqm_premium) | 38 | 0 | id |  |
| 293 | [tqm_province](#tqm_province) | 3 | 0 | province_code |  |
| 294 | [tqm_request_status](#tqm_request_status) | 5 | 0 | sale_book_code,insurance_type |  |
| 295 | [tqm_salutation](#tqm_salutation) | 2 | 0 | code |  |
| 296 | [tqm_sub_district](#tqm_sub_district) | 5 | 0 | subdistrict_code |  |
| 297 | [user_confirm](#user_confirm) | 9 | 0 | id |  |
| 298 | [zipcode](#zipcode) | 5 | 7,470 | zipcode_id |  |
| 299 | [zipcode_12sep67](#zipcode_12sep67) | 5 | 7,468 | — | *(snapshot?)* |
| 300 | [zipcode_add](#zipcode_add) | 5 | 22,288 | — | *(snapshot?)* |

---

## Act_Renewal_Reminder

`insurverse.Act_Renewal_Reminder` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `Car_Act_Lead_No` | bigint | YES |  |  |
| 3 | `reminder_date` | date | YES |  |  |
| 4 | `coverage_years` | smallint | YES |  |  |
| 5 | `status` | character varying | YES |  |  |
| 6 | `create_date` | timestamp without time zone | YES |  |  |
| 7 | `update_date` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `Car_Act_Lead_No` → Lead_Car_Act_Discount_Premium

---

## Imp_Discount_Premium

`insurverse.Imp_Discount_Premium` · kind: table · est. rows: **23,665**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  | ยี่ห้อรถ |
| 2 | `Model` | character varying(255) | YES |  | รุ่นรถ |
| 3 | `Year` | character varying(255) | YES |  | ปีจดทะเบียน |
| 4 | `Doors` | smallint | YES |  | จำนวนประตู |
| 5 | `Seat` | smallint | YES |  | จำนวนที่นั่ง |
| 6 | `Wg` | integer | YES |  | น้ำหนัก |
| 7 | `Group` | character varying(255) | YES |  | กลุ่มรถ |
| 8 | `Type` | smallint | YES |  | ชั้นประกัน |
| 9 | `Sedan` | character varying(255) | YES |  | ประเภท Sedan หรือไม่ |
| 10 | `BodyType` | character varying(255) | YES |  | รูปร่างรถ |
| 11 | `Start_date` | timestamp without time zone | YES |  | วันที่เริ่มมีผลใช้งาน |
| 12 | `End_date` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลใช้งาน |
| 13 | `Create_date` | timestamp without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  | ประเภทการใช้รถ |
| 18 | `Premium` | numeric | YES |  | เบี้นประกันก่อนลดราคา |
| 19 | `Discount` | numeric | YES |  | ส่วนลด |
| 20 | `Net_Premium` | numeric | YES |  | เบี้ยประกันสุทธิหลังลดราคา |
| 21 | `Stamp` | numeric | YES |  | ค่าอากร |
| 22 | `Vat` | numeric | YES |  | ค่าภาษี |
| 23 | `Total` | numeric | YES |  | เบี้ยประกันรวมที่ต้องชำระ |
| 24 | `coverage_years` | smallint | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `Comp_Code` → company_detail

---

## Imp_Discount_Premium_bak_20260630

`insurverse.Imp_Discount_Premium_bak_20260630` · kind: table · est. rows: **23,171** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp without time zone | YES |  |  |
| 12 | `End_date` | timestamp without time zone | YES |  |  |
| 13 | `Create_date` | timestamp without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |
| 24 | `coverage_years` | smallint | YES |  |  |

**Primary key:** _none_

---

## Imp_Price_Premium

`insurverse.Imp_Price_Premium` · kind: table · est. rows: **130,000**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  | ยี่ห้อรถ |
| 2 | `Model` | character varying(255) | YES |  | รุ่นรถ |
| 3 | `Year` | character varying(255) | YES |  | ปีจดทะเบียน |
| 4 | `Doors` | smallint | YES |  | จำนวนประตู |
| 5 | `Seat` | smallint | YES |  | จำนวนที่นั่ง |
| 6 | `Wg` | integer | YES |  | น้ำหนัก |
| 7 | `Group` | character varying(255) | YES |  | กลุ่มรถ |
| 8 | `Usage` | smallint | YES |  | ประเภทการใช้รถ |
| 9 | `Type` | character varying(5) | YES |  | ชั้นประกัน |
| 10 | `GarageType` | character varying(2) | YES |  | ประเภทอู่ซ่อม |
| 11 | `NamedAge` | character varying(255) | YES |  | ช่วงอายุส่วนลดผู้ขับขี่ |
| 12 | `MinSI` | integer | YES |  | ทุนประกันต่ำสุด |
| 13 | `MaxSI` | integer | YES |  | ทุนประกันสูงสุด |
| 14 | `Split` | integer | YES |  | ช่วงระหว่างทุนประกัน |
| 15 | `SI_1` | integer | YES |  | ทุนประกันรถตัวเลือกที่ 1 |
| 16 | `SI_2` | integer | YES |  | ทุนประกันรถตัวเลือกที่ 2 |
| 17 | `SI_3` | integer | YES |  | ทุนประกันรถตัวเลือกที่ 3 |
| 18 | `SI_4` | integer | YES |  | ทุนประกันรถตัวเลือกที่ 4 |
| 19 | `SI_5` | integer | YES |  | ทุนประกันรถตัวเลือกที่ 5 |
| 20 | `Prem_OD_1` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) ตัวเลือกที่ 1 |
| 21 | `Prem_OD_2` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) ตัวเลือกที่ 2 |
| 22 | `Prem_OD_3` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) ตัวเลือกที่ 3 |
| 23 | `Prem_OD_4` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) ตัวเลือกที่ 4 |
| 24 | `Prem_OD_5` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) ตัวเลือกที่ 5 |
| 25 | `Prem_FT_1` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำท่วม) ตัวเลือกที่ 1 |
| 26 | `Prem_FT_2` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำท่วม) ตัวเลือกที่ 2 |
| 27 | `Prem_FT_3` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำท่วม) ตัวเลือกที่ 3 |
| 28 | `Prem_FT_4` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำท่วม) ตัวเลือกที่ 4 |
| 29 | `Prem_FT_5` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำท่วม) ตัวเลือกที่ 5 |
| 30 | `SI_TPBI_1` | integer | YES |  | รย 20 ค่ารักษาพยาบาลคู่กรณี ต่อคน ตัวเลือกที่ 1 |
| 31 | `SI_TPBI_2` | integer | YES |  | รย 20 ค่ารักษาพยาบาลคู่กรณี ต่อคน ตัวเลือกที่ 2 |
| 32 | `SI_TPBI_3` | integer | YES |  | รย 20 ค่ารักษาพยาบาลคู่กรณี ต่อคน ตัวเลือกที่ 3 |
| 33 | `Prem_TPBI_1` | real | YES |  | รย 20 เบี้นประกันค่ารักษาพยาบาลคู่กรณี ต่อคน ตัวเลือกที่ 1 |
| 34 | `Prem_TPBI_2` | real | YES |  | รย 20 เบี้นประกันค่ารักษาพยาบาลคู่กรณี ต่อคน ตัวเลือกที่ 2 |
| 35 | `Prem_TPBI_3` | real | YES |  | รย 20 เบี้นประกันค่ารักษาพยาบาลคู่กรณี ต่อคน ตัวเลือกที่ 3 |
| 36 | `SI_TPPD_1` | integer | YES |  | รย 20 ค่าทรัพย์สินคู่กรณี ต่อคน ตัวเลือกที่ 1 |
| 37 | `SI_TPPD_2` | integer | YES |  | รย 20 ค่าทรัพย์สินคู่กรณี ต่อคน ตัวเลือกที่ 2 |
| 38 | `SI_TPPD_3` | integer | YES |  | รย 20 ค่าทรัพย์สินคู่กรณี ต่อคน ตัวเลือกที่ 3 |
| 39 | `Prem_TPPD_1` | real | YES |  | รย 20 เบี้ยประกันค่าทรัพย์สินคู่กรณี ต่อคน ตัวเลือกที่ 1 |
| 40 | `Prem_TPPD_2` | real | YES |  | รย 20 เบี้ยประกันค่าทรัพย์สินคู่กรณี ต่อคน ตัวเลือกที่ 2 |
| 41 | `Prem_TPPD_3` | real | YES |  | รย 20 เบี้ยประกันค่าทรัพย์สินคู่กรณี ต่อคน ตัวเลือกที่ 3 |
| 42 | `SI_MV01_1` | integer | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 1 |
| 43 | `SI_MV01_2` | integer | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 2 |
| 44 | `SI_MV01_3` | integer | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 3 |
| 45 | `Prem_MV01_1` | real | YES |  | รย 01 เบี้ยประกันประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 1 |
| 46 | `Prem_MV01_2` | real | YES |  | รย 01 เบี้ยประกันประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 2 |
| 47 | `Prem_MV01_3` | real | YES |  | รย 01 เบี้ยประกันประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 3 |
| 48 | `SI_MV02_1` | integer | YES |  | รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 1 |
| 49 | `SI_MV02_2` | integer | YES |  | รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 2 |
| 50 | `SI_MV02_3` | integer | YES |  | รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 3 |
| 51 | `Prem_MV02_1` | real | YES |  | รย 03 เบี้ยประกันค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 1 |
| 52 | `Prem_MV02_2` | real | YES |  | รย 03 เบี้ยประกันค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 2 |
| 53 | `Prem_MV02_3` | real | YES |  | รย 03 เบี้ยประกันค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 3 |
| 54 | `SI_MV03_1` | integer | YES |  | รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 1 |
| 55 | `SI_MV03_2` | integer | YES |  | รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 2 |
| 56 | `SI_MV03_3` | integer | YES |  | รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 3 |
| 57 | `Prem_MV03_1` | real | YES |  | รย 03 เบี้ยประกันค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 1 |
| 58 | `Prem_MV03_2` | real | YES |  | รย 03 เบี้ยประกันค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 2 |
| 59 | `Prem_MV03_3` | real | YES |  | รย 03 เบี้ยประกันค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 ตัวเลือกที่ 3 |
| 60 | `Sedan` | character varying(255) | YES |  | ประเภท Sedan หรือไม่? |
| 61 | `CC` | character varying(255) | YES |  | จำนวนช่วงซีซี |
| 62 | `SI_Access_1` | integer | YES |  | ทุนประกันอุปกรณ์ตกแต่ง ตัวเลือกที่ 1 |
| 63 | `SI_Access_2` | integer | YES |  | ทุนประกันอุปกรณ์ตกแต่ง ตัวเลือกที่ 2 |
| 64 | `SI_Access_3` | integer | YES |  | ทุนประกันอุปกรณ์ตกแต่ง ตัวเลือกที่ 3 |
| 65 | `Prem_Access_1` | real | YES |  | เบี้ยประกันทุนประกันอุปกรณ์ตกแต่ง ตัวเลือกที่ 1 |
| 66 | `Prem_Access_2` | real | YES |  | เบี้ยประกันทุนประกันอุปกรณ์ตกแต่ง ตัวเลือกที่ 2 |
| 67 | `Prem_Access_3` | real | YES |  | เบี้ยประกันทุนประกันอุปกรณ์ตกแต่ง ตัวเลือกที่ 3 |
| 68 | `BodyType` | character varying(255) | YES |  | รูปร่างรถ |
| 69 | `Start_date` | timestamp without time zone | YES |  | วันที่เริ่มมีผลใช้งาน |
| 70 | `End_date` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลใช้งาน |
| 71 | `CCTV` | integer | YES |  | ส่วนลดกล้อง |
| 72 | `OIC_Status` | smallint | YES |  | 1 = ขายได้ 2=ขายไม่ได้  |
| 73 | `driver_behavior` | integer | YES |  | พฤติกรรมผู้ขับขี่ |
| 74 | `sc_prem_amt_1` | real | YES |  | เบี้ยซ่อมห้าง รย 31 ตัวเลือกที่ 1 |
| 75 | `sc_prem_amt_2` | real | YES |  | เบี้ยซ่อมห้าง รย 31 ตัวเลือกที่ 2 |
| 76 | `sc_prem_amt_3` | real | YES |  | เบี้ยซ่อมห้าง รย 31 ตัวเลือกที่ 3 |
| 77 | `sc_prem_amt_4` | real | YES |  | เบี้ยซ่อมห้าง รย 31 ตัวเลือกที่ 4 |
| 78 | `sc_prem_amt_5` | real | YES |  | เบี้ยซ่อมห้าง รย 31 ตัวเลือกที่ 5 |
| 79 | `is_active` | boolean | YES |  | สถานะการใช้งาน |
| 80 | `version` | integer | YES |  | เลข version |

**Primary key:** _none_

**Indexes:**

- `Imp_Price_Premium_Brand_Model_Year_idx_copy2`: `CREATE INDEX "Imp_Price_Premium_Brand_Model_Year_idx_copy2" ON insurverse."Imp_Price_Premium" USING btree ("Brand", "Model")`
- `Imp_Price_Premium_Brand_Model_Year_idx_copy2_copy2`: `CREATE INDEX "Imp_Price_Premium_Brand_Model_Year_idx_copy2_copy2" ON insurverse."Imp_Price_Premium" USING btree ("Brand", "Model")`

---

## Imp_Price_Premium_20251118

`insurverse.Imp_Price_Premium_20251118` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp without time zone | YES |  |  |
| 70 | `End_date` | timestamp without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |

**Primary key:** _none_

---

## Imp_Price_Premium_bak_20260630

`insurverse.Imp_Price_Premium_bak_20260630` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp without time zone | YES |  |  |
| 70 | `End_date` | timestamp without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |
| 73 | `driver_behavior` | integer | YES |  |  |
| 74 | `sc_prem_amt_1` | real | YES |  |  |
| 75 | `sc_prem_amt_2` | real | YES |  |  |
| 76 | `sc_prem_amt_3` | real | YES |  |  |
| 77 | `sc_prem_amt_4` | real | YES |  |  |
| 78 | `sc_prem_amt_5` | real | YES |  |  |
| 79 | `is_active` | boolean | YES |  |  |
| 80 | `version` | integer | YES |  |  |

**Primary key:** _none_

---

## Lead_Car_Act_Discount_Premium

`insurverse.Lead_Car_Act_Discount_Premium` · kind: table · est. rows: **286**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Car_Act_Lead_No` | bigint | NO |  | รหัส Lead พรบ |
| 2 | `Brand` | character varying(255) | YES |  |  |
| 3 | `Model` | character varying(255) | YES |  |  |
| 4 | `Year` | character varying(255) | YES |  |  |
| 5 | `Doors` | smallint | YES |  |  |
| 6 | `Seat` | smallint | YES |  |  |
| 7 | `Wg` | integer | YES |  |  |
| 8 | `Group` | character varying(255) | YES |  |  |
| 9 | `Type` | character varying(50) | YES |  |  |
| 10 | `Sedan` | character varying(255) | YES |  |  |
| 11 | `BodyType` | character varying(255) | YES |  |  |
| 12 | `Start_date` | timestamp without time zone | YES |  | วันเริ่มคุ้มครอง |
| 13 | `End_date` | timestamp without time zone | YES |  | วันสิ้นสุดคุ้มครอง |
| 14 | `Create_date` | timestamp without time zone | YES | `now()` |  |
| 15 | `Create_by` | character varying(50) | YES |  |  |
| 16 | `Update_date` | timestamp without time zone | YES |  |  |
| 17 | `Update_by` | character varying(50) | YES |  |  |
| 18 | `Payment_status` | character varying(50) | YES |  | สถานะจ่าย |
| 19 | `Payment_channel` | character varying(50) | YES |  | ช่องทางจ่าย |
| 20 | `Payment_type` | character varying(50) | YES |  | ประเภทจ่าย |
| 21 | `Payment_No` | character varying(50) | YES |  | หมายเลขสำคัญจ่าย |
| 22 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 23 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 24 | `Payment_result` | character varying(50) | YES |  |  |
| 25 | `Recept_no` | character varying(50) | YES |  |  |
| 26 | `Tax_No` | character varying(50) | YES |  |  |
| 27 | `Flex_field1` | character varying(255) | YES |  |  |
| 28 | `Flex_field2` | character varying(255) | YES |  |  |
| 29 | `Flex_field3` | character varying(255) | YES |  |  |
| 30 | `Policy_Quatation_No` | character varying(50) | YES |  | Ref. ใบเสนอราคา |
| 31 | `Policy_Invoice_No` | character varying(50) | YES |  | Ref. ใบเสร็จ |
| 32 | `IIA_Ref_no` | character varying(50) | YES |  | Ref. IIA |
| 33 | `prefix_name` | character varying(50) | YES |  | ปร 01 ผู้เอาประกัน |
| 34 | `first_name` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 35 | `last_name` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 36 | `birth_date` | date | YES |  | ปร 01 ผู้เอาประกัน |
| 37 | `citizen_id` | character varying(13) | YES |  |  |
| 38 | `province_id` | integer | YES |  |  |
| 39 | `subdistrict_id` | integer | YES |  |  |
| 40 | `district_id` | integer | YES |  |  |
| 41 | `zipcode` | character varying(45) | YES |  |  |
| 42 | `countryid` | integer | YES |  |  |
| 43 | `phone` | character varying(45) | YES |  |  |
| 44 | `IsKYC` | character varying(50) | YES |  |  |
| 45 | `KYC_id` | character varying(50) | YES |  |  |
| 46 | `KYC_date` | timestamp without time zone | YES |  |  |
| 47 | `Occupation` | character varying(255) | YES |  | อาชีพ |
| 48 | `Remark` | character varying(255) | YES |  | หมายเหตุ |
| 49 | `Car_Comp_Code` | character varying(50) | YES |  | Code การใช้รถ  |
| 50 | `Premium` | numeric | YES |  |  |
| 51 | `Discount` | numeric | YES |  |  |
| 52 | `Net_Premium` | numeric | YES |  |  |
| 53 | `Stamp` | numeric | YES |  |  |
| 54 | `Vat` | numeric | YES |  |  |
| 55 | `Total` | numeric | YES |  |  |
| 56 | `CC` | character varying(255) | YES |  |  |
| 57 | `Car_license_no` | character varying(50) | YES |  | รย 17 ป้ายเลขทะเบียน |
| 58 | `Car_license_provice` | character varying(50) | YES |  | รย 17 จังหวัด ที่จด |
| 59 | `Car_serial_no` | character varying(50) | YES |  | รย 17 ตัวถังรถ |
| 60 | `Effective_Startdate` | timestamp without time zone | NO |  |  |
| 61 | `Effective_Enddate` | timestamp without time zone | YES |  |  |
| 62 | `cmi_reference_number` | character varying(50) | YES |  | รหัสอ้างอิง CMI Realtime |
| 63 | `cmi_receive_number` | character varying(50) | YES |  | รหัสรับ CMI Realtime |
| 64 | `cmi_endorse_ref_number` | character varying(50) | YES |  | รหัสอ้างอิงสลักหลัง CMI Realtime |
| 65 | `cmi_endorse_receive_number` | character varying(50) | YES |  | รหัสรับสลักหลัง CMI Realtime |
| 66 | `cmi_update_date` | timestamp without time zone | YES |  | วันที่เวลาส่งข้อมูล CMI Realtime |
| 67 | `Comp_Code` | character varying(255) | YES |  | ชื่อย่อบริษัท ISV (Default) |
| 68 | `Policy_book` | character varying(50) | YES |  | เล่มที่กรมธรรม์ |
| 69 | `Deli_Addr_line1` | character varying(255) | YES |  | ที่อยู่จัดส่ง |
| 70 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 71 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 72 | `Deli_province_id` | integer | YES |  |  |
| 73 | `Deli_subdistrict_id` | integer | YES |  |  |
| 74 | `Deli_district_id` | integer | YES |  |  |
| 75 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 76 | `Deli_countryid` | integer | YES |  |  |
| 77 | `Car_license_type` | character varying(50) | YES |  | [Policy]-[Car_license_type] ป้ายแดง จดทะเบียน |
| 78 | `Policy_Ref_no` | character varying(50) | YES |  | Ref. อ้างอิง |
| 79 | `Policy_QR_code` | character varying(255) | YES |  | วันคุ้มครองกรมธรรม์ + ตัวเลขตัวถัง |
| 80 | `Car_color` | character varying(255) | YES |  | สีรถ |
| 81 | `Lead_No` | integer | YES |  |  |
| 82 | `Policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 83 | `Policy_Barcode` | character varying(50) | YES |  | ISV Barcode บนกรมธรรม์ |
| 84 | `Policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 85 | `address` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 86 | `email` | character varying(255) | YES |  |  |
| 87 | `Bene_Type` | character varying(50) | YES |  | รย 24 ไฟแนนซ์ บุคคล |
| 88 | `Bene_Title` | character varying(50) | YES |  | ที่อยู่ผู้รับผลประโยชน์ |
| 89 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 90 | `Bene_Midname` | character varying(255) | YES |  |  |
| 91 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 92 | `Bene_ID_card` | character varying(50) | YES |  | หมายเลขเอกสารผู้รับผลประโยชน์ |
| 93 | `Receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 94 | `Receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 95 | `SF_Epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 96 | `SF_Etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 97 | `Payment_date` | timestamp without time zone | YES |  |  |
| 98 | `IIA_Lot_No` | character varying(20) | YES |  | IIA Lot no. |
| 99 | `Flag_Deli` | character(1) | YES |  | y = จัดส่งรูปเล่มกรมธรรม์, n = ไม่จัดส่งรูปเล่มกรมธรรม์ |
| 100 | `SF_Policy_id` | character varying(255) | YES |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 101 | `promo_trans_id` | bigint | YES |  |  |
| 102 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 103 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 104 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 105 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 106 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 107 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 108 | `ref_policy_no` | character varying(50) | YES |  | อ้างอิงเลขกรมธรรม์เดิมสำหรับต่อกรมธรรม์ |
| 109 | `partner_code` | character varying(10) | YES |  | รหัส partner |
| 110 | `occupation_code` | character varying(50) | YES |  | รหัส อาชีพ |
| 111 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 112 | `coverage_years` | smallint | YES | `1` |  |
| 113 | `hp` | integer | YES |  |  |
| 114 | `engineType` | character varying(3) | NO | `'ICE'::character varying` |  |
| 115 | `customer_id` | character varying(100) | YES |  |  |

**Primary key:** `Car_Act_Lead_No` (Policy_Car_Act_Discount_Premium_copy1_pkey2)

**Inferred references (naming convention, NOT enforced FK):** `Comp_Code` → company_detail, `Deli_countryid` → mas_country, `Deli_district_id` → district, `Deli_province_id` → province, `Deli_subdistrict_id` → subdistrict, `Lead_No` → Lead_coverage_premium, `countryid` → mas_country, `district_id` → district, `partner_code` → mas_partner, `promo_trans_id` → promo_code_trans, `province_id` → province, `ref_policy_no` → Policy_Header, `subdistrict_id` → subdistrict

**Constraints:**

- CHECK `Lead_Car_Act_Discount_Premium_hp_check`: `CHECK (((hp >= 1) AND (hp <= 9999)))`

**Indexes:**

- `Policy_Car_Act_Discount_Premium_copy1_pkey2`: `CREATE UNIQUE INDEX "Policy_Car_Act_Discount_Premium_copy1_pkey2" ON insurverse."Lead_Car_Act_Discount_Premium" USING btree ("Car_Act_Lead_No")`
- `idx_lcadp_ref_policy_no`: `CREATE INDEX idx_lcadp_ref_policy_no ON insurverse."Lead_Car_Act_Discount_Premium" USING btree (ref_policy_no)`
- `index_lead_car_act_discount_premium`: `CREATE INDEX index_lead_car_act_discount_premium ON insurverse."Lead_Car_Act_Discount_Premium" USING btree ("Car_Act_Lead_No")`

---

## Lead_coverage_premium

`insurverse.Lead_coverage_premium` · kind: table · est. rows: **278**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Lead_No` | integer | NO | `nextval('insurverse.seq_lead_no'::regclass)` |  |
| 2 | `Lead_Startdate` | timestamp without time zone | YES |  |  |
| 3 | `Lead_Enddate` | timestamp without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  | กลุ่มรถ (แยกราคา) |
| 11 | `Usage` | smallint | YES |  | การใช้รถ 110 ส่วนบุคคล 320 รถบรรทุกหรือรถกระบะ 2 ประตู |
| 12 | `Type` | character varying(50) | YES |  | ชั้นประกัน |
| 13 | `BodyType` | character varying(255) | YES |  | แบบตัวถัง |
| 14 | `GarageType` | character varying(2) | YES |  | ซ่อมอู่ ซ่อมห้าง |
| 15 | `NamedAge` | character varying(255) | YES |  | ช่วงอายุผู้ขับขี่ (เลือกคนอายุน้อยสุด) |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  | ทุนประกัน |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  |  |
| 25 | `SI_Start` | timestamp without time zone | YES |  |  |
| 26 | `SI_End` | timestamp without time zone | YES |  |  |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  | Tariff คปภ. ส่วนทุนประกัน |
| 28 | `Prem_OD_1` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  |  |
| 34 | `OD_Start` | timestamp without time zone | YES |  |  |
| 35 | `OD_End` | timestamp without time zone | YES |  |  |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  |  |
| 37 | `OD_Amt` | numeric | YES |  |  |
| 38 | `Prem_FT_1` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำถ่วม) |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  |  |
| 44 | `FT_Start` | timestamp without time zone | YES |  |  |
| 45 | `FT_End` | timestamp without time zone | YES |  |  |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  |  |
| 47 | `FT_Amt` | numeric | YES |  |  |
| 48 | `SI_TPBI_1` | integer | YES |  | รย 20 ค่ารักษาพยาบาลคู่กรณี ต่อครั้ง |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  | ราคาเบี้ยประกัน (ค่ารักษาพยาบาลคู่กรณี) |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  |  |
| 55 | `SI_TPBI_Start` | timestamp without time zone | YES |  |  |
| 56 | `SI_TPBI_End` | timestamp without time zone | YES |  |  |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  | Tariff คปภ. ส่วนค่ารักษาพยาบาลคู่กรณี |
| 58 | `SI_TPBI_Amt` | numeric | YES |  |  |
| 59 | `SI_TPPD_1` | integer | YES |  | รย 20 ค่าทรัพย์สินคู่กรณี ต่อครั้ง |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  | ราคาเบี้ยประกัน (ค่าทรัพย์สินคู่กรณี) |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  |  |
| 66 | `SI_TPPD_Start` | timestamp without time zone | YES |  |  |
| 67 | `SI_TPPD_End` | timestamp without time zone | YES |  |  |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  |  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  |  |
| 70 | `SI_MV01_1` | integer | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  |  |
| 77 | `SI_MV01_Start` | timestamp without time zone | YES |  |  |
| 78 | `SI_MV01_End` | timestamp without time zone | YES |  |  |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  |  |
| 80 | `SI_MV01_Amt` | numeric | YES |  |  |
| 81 | `SI_MV02_1` | integer | YES |  | รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  | รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  | รย 20 คุ้มครองอุปกรณ์ตกแต่ง |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  | พรบ กรณีสลักหลังออกเป็น ปร 01 |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 120 | `Discount` | numeric(18,4) | YES |  | พรบ |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  | เบี้ยประกันสุทธิ |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  | อากรแสตมป์ |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  | ภาษีมูลค่าเพิ่ม |
| 124 | `Total_Amt` | numeric(18,4) | YES |  | เบี้ยประกันรวม |
| 125 | `Payment_status` | character varying(50) | YES |  | สถานะจ่าย |
| 126 | `Payment_channel` | character varying(50) | YES |  | ช่องทางจ่าย |
| 127 | `Payment_type` | character varying(50) | YES |  | ประเภทจ่าย |
| 128 | `Payment_No` | character varying(50) | YES |  | หมายเลขสำคัญจ่าย |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp without time zone | YES | `now()` |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  | % ส่วนลดกลุ่ม |
| 142 | `NCB_Disc_perc` | numeric | YES |  | % ส่วนลดประวัติดี |
| 143 | `Other_Disc_perc` | numeric | YES |  | % ส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |
| 144 | `Surcharge_Amt` | numeric | YES |  | ส่วนเพิ่มประวัติเสีย |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  | เบี้ยประกันตามความคุ้มครองหลัก |
| 146 | `Total_Amt_mv` | numeric | YES |  | เบี้ยประกันตามเอกสารแนบท้าย |
| 147 | `Par_code` | character varying(50) | YES |  |  |
| 148 | `Email` | character varying(255) | YES |  |  |
| 149 | `Mobile` | character varying(255) | YES |  |  |
| 150 | `Flag_Car_Act` | character(1) | YES |  | Y = ซื้อพร้อมพรบ, N = ไม่ซื้อพรบ |
| 151 | `Flag_CCTV` | character(1) | YES |  | Y = มีกล้อง, N = ไม่มีกล้อง |
| 152 | `Flag_Driver` | character(1) | YES |  | Y = ระบุผู้ขับขี่, N = ไม่ระบุขับขี่ |
| 153 | `Fleet_Disc_Amt` | numeric | YES |  | ราคาส่วนลดกลุ่ม |
| 154 | `NCB_Disc_Amt` | numeric | YES |  | ราคาส่วนลดประวัติดี |
| 155 | `Other_Disc_Amt` | numeric | YES |  | ราคาส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |
| 156 | `FirstName` | character varying(255) | YES |  | ชื้อผู้ชื้อ |
| 157 | `LastName` | character varying(255) | YES |  | นามสกุลผู้ชื้อ |
| 158 | `Total_Disc_Amt` | numeric | YES |  | ราคารวมส่วนลด Fleet + NCB + Other |
| 159 | `NamedAge_Amt` | numeric | YES |  | ราคาส่วนลดช่วงอายุผู้ขับขี่ |
| 160 | `SI_DD_1` | integer | YES |  | ความเสียหายส่วนแรก |
| 161 | `SI_DD_2` | integer | YES |  |  |
| 162 | `SI_DD_3` | integer | YES |  |  |
| 163 | `Prem_DD_1` | real | YES |  |  |
| 164 | `Prem_DD_2` | real | YES |  |  |
| 165 | `Prem_DD_3` | real | YES |  |  |
| 166 | `SI_DD_Ans` | integer | YES |  |  |
| 167 | `SI_DD_Start` | timestamp without time zone | YES |  |  |
| 168 | `SI_DD_End` | timestamp without time zone | YES |  |  |
| 169 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 170 | `SI_DD_Amt` | numeric | YES |  |  |
| 171 | `Flag_Access` | character(1) | YES |  | Y = คุ้มครองอุปกรณ์ตบแต่ง, N = ไม่คุ้มครองอุปกรณ์ตบแต่ง |
| 172 | `CCTV` | integer | YES |  |  |
| 173 | `Access_para_code` | character varying(255) | YES |  | เก็บ code อุปกรณ์ตบแต่งที่เลือก |
| 174 | `YOB_Driver_1` | character(4) | YES |  | ปีเกิดผู้ขับขี่คนที่ 1 |
| 175 | `YOB_Driver_2` | character(4) | YES |  | ปีเกิดผู้ขับขี่คนที่ 2 |
| 176 | `Payment_Date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 177 | `Prem_ACT` | real | YES |  | ราคา พรบ |
| 178 | `Basic_Premium` | numeric | YES |  | เบี้ยพื้นฐาน |
| 179 | `SI_Limit` | numeric | YES |  | ทุนประกัน (ที่เลือก) |
| 180 | `SI_TPBI_Limit` | numeric | YES |  | ทุนค่ารักษาพยาบาลคู่กรณีต่อครั้ง (ที่เลือก) |
| 181 | `SI_TPPD_Limit` | numeric | YES |  | ทุนค่าทรัพย์สินคู่กรณีต่อครั้ง (ที่เลือก) |
| 182 | `SI_MV01_Limit` | numeric | YES |  | ทุนประกันอุบัติเหตุ (ที่เลือก) |
| 183 | `SI_MV02_Limit` | numeric | YES |  | ทุนค่ารักษาพยาบาลบุคคลในรถ (ที่เลือก) |
| 184 | `SI_MV03_Limit` | numeric | YES |  | ทุนค่าประกันตัวผู้ขับขี่ (ที่เลือก) |
| 185 | `SI_Access_Limit` | numeric | YES |  | ทุนคุ้มครองอุปกรณ์ตกแต่ง (ที่เลือก) |
| 186 | `SF_Lead` | character varying(50) | YES |  | Salesforce Lead No. SF-Lead |
| 187 | `Driver_Discount` | numeric | YES |  | ราคาส่วนลดคนขับ |
| 188 | `premium_v5_od` | numeric | YES |  |  |
| 189 | `Policy_book` | character varying(50) | YES |  |  |
| 190 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 191 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 192 | `Policy_book_act` | character varying(50) | YES |  |  |
| 193 | `Policy_Quatation_No_act` | character varying(50) | YES |  |  |
| 194 | `Policy_Invoice_No_act` | character varying(50) | YES |  |  |
| 195 | `promo_trans_id` | bigint | YES |  |  |
| 196 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 197 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 198 | `cover_day_count` | smallint | YES |  |  |
| 199 | `driver_age` | smallint | YES |  |  |
| 200 | `budget_lead_amt` | numeric(16,4) | YES |  |  |
| 201 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 202 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 203 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 204 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 205 | `basic_premium_v5` | numeric | YES |  | เบี้ยพื้นฐาน v5 รย10 |
| 206 | `ref_policy_no` | character varying(50) | YES |  | อ้างอิงเลขกรมธรรม์เดิมสำหรับต่อกรมธรรม์ |
| 207 | `renewal_mv_startdate` | timestamp without time zone | YES |  | เวลาเริ่มความคุ้มครองต่ออายุสมัครใจ |
| 208 | `renewal_mv_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดความคุ้มครองต่ออายุสมัครใจ |
| 209 | `renewal_mc_startdate` | timestamp without time zone | YES |  | เวลาเริ่มความคุ้มครองต่ออายุพรบ |
| 210 | `renewal_mc_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดความคุ้มครองต่ออายุพรบ |
| 211 | `cal_basic_renewal` | boolean | YES | `false` | true ต่ออายุปกติไม่ต้องแก้ไข basic_premium, false ต่ออายุ DIY แก้ไข basic_premium ตามปกติ |
| 212 | `partner_code` | character varying(10) | YES |  | รหัส partner |
| 213 | `cc_ans` | character varying(20) | YES |  | ขนาดรถยนต์ที่เลือก |
| 214 | `par_prefix_name_1` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 1 |
| 215 | `par_first_name_1` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 1 |
| 216 | `par_last_name_1` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 1 |
| 217 | `par_birth_date_1` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 1 |
| 218 | `par_citizen_id_1` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 1 |
| 219 | `par_driver_license_no_1` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 1 |
| 220 | `par_occupation_1` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 1 |
| 221 | `par_prefix_name_2` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 2 |
| 222 | `par_first_name_2` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 2 |
| 223 | `par_last_name_2` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 2 |
| 224 | `par_birth_date_2` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 2 |
| 225 | `par_citizen_id_2` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 2 |
| 226 | `par_driver_license_no_2` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 2 |
| 227 | `par_occupation_2` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 2 |
| 228 | `par_prefix_name_3` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 3 |
| 229 | `par_first_name_3` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 3 |
| 230 | `par_last_name_3` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 3 |
| 231 | `par_birth_date_3` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 3 |
| 232 | `par_citizen_id_3` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 3 |
| 233 | `par_driver_license_no_3` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 3 |
| 234 | `par_occupation_3` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 3 |
| 235 | `par_prefix_name_4` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 4 |
| 236 | `par_first_name_4` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 4 |
| 237 | `par_last_name_4` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 4 |
| 238 | `par_birth_date_4` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 4 |
| 239 | `par_citizen_id_4` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 4 |
| 240 | `par_driver_license_no_4` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 4 |
| 241 | `par_occupation_4` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 4 |
| 242 | `par_prefix_name_5` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 5 |
| 243 | `par_first_name_5` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 5 |
| 244 | `par_last_name_5` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 5 |
| 245 | `par_birth_date_5` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 5 |
| 246 | `par_citizen_id_5` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 5 |
| 247 | `par_driver_license_no_5` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 5 |
| 248 | `par_occupation_5` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 5 |
| 249 | `driver_behavior_1` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 1 |
| 250 | `driver_behavior_2` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 2 |
| 251 | `driver_behavior_3` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 3 |
| 252 | `driver_behavior_4` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 4 |
| 253 | `driver_behavior_5` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 5 |
| 254 | `driver_behavior_cal` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ ที่นำมาใช้ |
| 255 | `driver_behavior_disc_perc` | real | YES |  | ส่วนลดผู้ขับขี่ (percent) |
| 256 | `driver_behavior_disc_amt` | numeric | YES |  | ส่วนลดผู้ขับขี่ (baht) |
| 257 | `car_price` | numeric | YES |  | ราคารถยนต์ ณ วันที่ทำประกัน |
| 258 | `car_price_date` | date | YES |  | วันที่ของราคารถยนต์ ณ วันที่ทำประกัน |
| 259 | `sc_premium_amt_1` | real | YES |  | เบี้ยซ่อมห้าง |
| 260 | `sc_premium_amt_2` | real | YES |  | เบี้ยซ่อมห้าง |
| 261 | `sc_premium_amt_3` | real | YES |  | เบี้ยซ่อมห้าง |
| 262 | `sc_premium_amt_4` | real | YES |  | เบี้ยซ่อมห้าง |
| 263 | `sc_premium_amt_5` | real | YES |  | เบี้ยซ่อมห้าง |
| 264 | `sc_premium_amt_ans` | integer | YES |  | เบี้ยซ่อมห้าง ที่เลือก (ตามทุนประกัน) |
| 265 | `prem_version` | smallint | YES |  | เวอร์ชั่นของ master price premium |
| 266 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 267 | `driver_behavior_consent_1` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 1 |
| 268 | `driver_behavior_consent_2` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 2 |
| 269 | `driver_behavior_consent_3` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 3 |
| 270 | `driver_behavior_consent_4` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 4 |
| 271 | `driver_behavior_consent_5` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 5 |
| 272 | `par_occupation_code_1` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 1 |
| 273 | `par_occupation_code_2` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 2 |
| 274 | `par_occupation_code_3` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 3 |
| 275 | `par_occupation_code_4` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 4 |
| 276 | `par_occupation_code_5` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 5 |
| 277 | `sc_premium_amt` | numeric | YES |  | เบี้ยซ่อมห้าง |
| 278 | `driver_behavior` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ (master) |
| 279 | `par_driver_license_category_1` | character varying(20) | YES |  |  |
| 280 | `par_driver_license_category_2` | character varying(20) | YES |  |  |
| 281 | `par_driver_license_category_3` | character varying(20) | YES |  |  |
| 282 | `par_driver_license_category_4` | character varying(20) | YES |  |  |
| 283 | `par_driver_license_category_5` | character varying(20) | YES |  |  |

**Primary key:** `Lead_No` (Lead_coverage_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `partner_code` → mas_partner, `promo_trans_id` → promo_code_trans, `ref_policy_no` → Policy_Header

**Indexes:**

- `Lead_coverage_premium_pkey`: `CREATE UNIQUE INDEX "Lead_coverage_premium_pkey" ON insurverse."Lead_coverage_premium" USING btree ("Lead_No")`
- `idx_lead_coverage_premium_ref_policy_no`: `CREATE INDEX idx_lead_coverage_premium_ref_policy_no ON insurverse."Lead_coverage_premium" USING btree (ref_policy_no)`
- `index_lead_coverage_premium`: `CREATE INDEX index_lead_coverage_premium ON insurverse."Lead_coverage_premium" USING btree ("Lead_No")`

---

## Lead_coverage_premium_2

`insurverse.Lead_coverage_premium_2` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Lead_No` | integer | YES |  |  |
| 2 | `Lead_Startdate` | timestamp without time zone | YES |  |  |
| 3 | `Lead_Enddate` | timestamp without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  |  |
| 11 | `Usage` | smallint | YES |  |  |
| 12 | `Type` | character varying(50) | YES |  |  |
| 13 | `BodyType` | character varying(255) | YES |  |  |
| 14 | `GarageType` | character varying(2) | YES |  |  |
| 15 | `NamedAge` | character varying(255) | YES |  |  |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  |  |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  |  |
| 25 | `SI_Start` | timestamp without time zone | YES |  |  |
| 26 | `SI_End` | timestamp without time zone | YES |  |  |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  |  |
| 28 | `Prem_OD_1` | real | YES |  |  |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  |  |
| 34 | `OD_Start` | timestamp without time zone | YES |  |  |
| 35 | `OD_End` | timestamp without time zone | YES |  |  |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  |  |
| 37 | `OD_Amt` | numeric | YES |  |  |
| 38 | `Prem_FT_1` | real | YES |  |  |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  |  |
| 44 | `FT_Start` | timestamp without time zone | YES |  |  |
| 45 | `FT_End` | timestamp without time zone | YES |  |  |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  |  |
| 47 | `FT_Amt` | numeric | YES |  |  |
| 48 | `SI_TPBI_1` | integer | YES |  |  |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  |  |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  |  |
| 55 | `SI_TPBI_Start` | timestamp without time zone | YES |  |  |
| 56 | `SI_TPBI_End` | timestamp without time zone | YES |  |  |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  |  |
| 58 | `SI_TPBI_Amt` | numeric | YES |  |  |
| 59 | `SI_TPPD_1` | integer | YES |  |  |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  |  |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  |  |
| 66 | `SI_TPPD_Start` | timestamp without time zone | YES |  |  |
| 67 | `SI_TPPD_End` | timestamp without time zone | YES |  |  |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  |  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  |  |
| 70 | `SI_MV01_1` | integer | YES |  |  |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  |  |
| 77 | `SI_MV01_Start` | timestamp without time zone | YES |  |  |
| 78 | `SI_MV01_End` | timestamp without time zone | YES |  |  |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  |  |
| 80 | `SI_MV01_Amt` | numeric | YES |  |  |
| 81 | `SI_MV02_1` | integer | YES |  |  |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  |  |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  |  |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  |  |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  |  |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  |  |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  |  |
| 120 | `Discount` | numeric(18,4) | YES |  |  |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  |  |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  |  |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  |  |
| 124 | `Total_Amt` | numeric(18,4) | YES |  |  |
| 125 | `Payment_status` | character varying(50) | YES |  |  |
| 126 | `Payment_channel` | character varying(50) | YES |  |  |
| 127 | `Payment_type` | character varying(50) | YES |  |  |
| 128 | `Payment_No` | character varying(50) | YES |  |  |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp without time zone | YES |  |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  |  |
| 142 | `NCB_Disc_perc` | numeric | YES |  |  |
| 143 | `Other_Disc_perc` | numeric | YES |  |  |
| 144 | `Surcharge_Amt` | numeric | YES |  |  |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  |  |
| 146 | `Total_Amt_mv` | numeric | YES |  |  |
| 147 | `Par_code` | character varying(50) | YES |  |  |
| 148 | `Email` | character varying(255) | YES |  |  |
| 149 | `Mobile` | character varying(255) | YES |  |  |
| 150 | `Flag_Car_Act` | character(1) | YES |  |  |
| 151 | `Flag_CCTV` | character(1) | YES |  |  |
| 152 | `Flag_Driver` | character(1) | YES |  |  |
| 153 | `Fleet_Disc_Amt` | numeric | YES |  |  |
| 154 | `NCB_Disc_Amt` | numeric | YES |  |  |
| 155 | `Other_Disc_Amt` | numeric | YES |  |  |
| 156 | `FirstName` | character varying(255) | YES |  |  |
| 157 | `LastName` | character varying(255) | YES |  |  |
| 158 | `Total_Disc_Amt` | numeric | YES |  |  |
| 159 | `NamedAge_Amt` | numeric | YES |  |  |
| 160 | `SI_DD_1` | integer | YES |  |  |
| 161 | `SI_DD_2` | integer | YES |  |  |
| 162 | `SI_DD_3` | integer | YES |  |  |
| 163 | `Prem_DD_1` | real | YES |  |  |
| 164 | `Prem_DD_2` | real | YES |  |  |
| 165 | `Prem_DD_3` | real | YES |  |  |
| 166 | `SI_DD_Ans` | integer | YES |  |  |
| 167 | `SI_DD_Start` | timestamp without time zone | YES |  |  |
| 168 | `SI_DD_End` | timestamp without time zone | YES |  |  |
| 169 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 170 | `SI_DD_Amt` | numeric | YES |  |  |
| 171 | `Flag_Access` | character(1) | YES |  |  |
| 172 | `CCTV` | integer | YES |  |  |
| 173 | `Access_para_code` | character varying(255) | YES |  |  |
| 174 | `YOB_Driver_1` | character(4) | YES |  |  |
| 175 | `YOB_Driver_2` | character(4) | YES |  |  |
| 176 | `Payment_Date` | timestamp without time zone | YES |  |  |
| 177 | `Prem_ACT` | real | YES |  |  |
| 178 | `Basic_Premium` | numeric | YES |  |  |
| 179 | `SI_Limit` | numeric | YES |  |  |
| 180 | `SI_TPBI_Limit` | numeric | YES |  |  |
| 181 | `SI_TPPD_Limit` | numeric | YES |  |  |
| 182 | `SI_MV01_Limit` | numeric | YES |  |  |
| 183 | `SI_MV02_Limit` | numeric | YES |  |  |
| 184 | `SI_MV03_Limit` | numeric | YES |  |  |
| 185 | `SI_Access_Limit` | numeric | YES |  |  |
| 186 | `SF_Lead` | character varying(50) | YES |  |  |
| 187 | `Driver_Discount` | numeric | YES |  |  |
| 188 | `premium_v5_od` | numeric | YES |  |  |
| 189 | `Policy_book` | character varying(50) | YES |  |  |
| 190 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 191 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 192 | `Policy_book_act` | character varying(50) | YES |  |  |
| 193 | `Policy_Quatation_No_act` | character varying(50) | YES |  |  |
| 194 | `Policy_Invoice_No_act` | character varying(50) | YES |  |  |
| 195 | `promo_trans_id` | bigint | YES |  |  |
| 196 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 197 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 198 | `cover_day_count` | smallint | YES |  |  |
| 199 | `driver_age` | smallint | YES |  |  |
| 200 | `budget_lead_amt` | numeric(16,4) | YES |  |  |
| 201 | `affiliate_source` | character varying(255) | YES |  |  |
| 202 | `affiliate_code` | character varying(255) | YES |  |  |
| 203 | `referal_source` | character varying(255) | YES |  |  |
| 204 | `referal_code` | character varying(255) | YES |  |  |
| 205 | `basic_premium_v5` | numeric | YES |  |  |
| 206 | `ref_policy_no` | character varying(50) | YES |  |  |
| 207 | `renewal_mv_startdate` | timestamp without time zone | YES |  |  |
| 208 | `renewal_mv_enddate` | timestamp without time zone | YES |  |  |
| 209 | `renewal_mc_startdate` | timestamp without time zone | YES |  |  |
| 210 | `renewal_mc_enddate` | timestamp without time zone | YES |  |  |
| 211 | `cal_basic_renewal` | boolean | YES |  |  |
| 212 | `partner_code` | character varying(10) | YES |  |  |

**Primary key:** _none_

---

## Lead_coverage_premium_20260810

`insurverse.Lead_coverage_premium_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Lead_No` | integer | YES |  |  |
| 2 | `Lead_Startdate` | timestamp(6) without time zone | YES |  |  |
| 3 | `Lead_Enddate` | timestamp(6) without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  |  |
| 11 | `Usage` | smallint | YES |  |  |
| 12 | `Type` | character varying(50) | YES |  |  |
| 13 | `BodyType` | character varying(255) | YES |  |  |
| 14 | `GarageType` | character varying(2) | YES |  |  |
| 15 | `NamedAge` | character varying(255) | YES |  |  |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  |  |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  |  |
| 25 | `SI_Start` | timestamp(6) without time zone | YES |  |  |
| 26 | `SI_End` | timestamp(6) without time zone | YES |  |  |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  |  |
| 28 | `Prem_OD_1` | real | YES |  |  |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  |  |
| 34 | `OD_Start` | timestamp(6) without time zone | YES |  |  |
| 35 | `OD_End` | timestamp(6) without time zone | YES |  |  |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  |  |
| 37 | `OD_Amt` | numeric | YES |  |  |
| 38 | `Prem_FT_1` | real | YES |  |  |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  |  |
| 44 | `FT_Start` | timestamp(6) without time zone | YES |  |  |
| 45 | `FT_End` | timestamp(6) without time zone | YES |  |  |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  |  |
| 47 | `FT_Amt` | numeric | YES |  |  |
| 48 | `SI_TPBI_1` | integer | YES |  |  |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  |  |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  |  |
| 55 | `SI_TPBI_Start` | timestamp(6) without time zone | YES |  |  |
| 56 | `SI_TPBI_End` | timestamp(6) without time zone | YES |  |  |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  |  |
| 58 | `SI_TPBI_Amt` | numeric | YES |  |  |
| 59 | `SI_TPPD_1` | integer | YES |  |  |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  |  |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  |  |
| 66 | `SI_TPPD_Start` | timestamp(6) without time zone | YES |  |  |
| 67 | `SI_TPPD_End` | timestamp(6) without time zone | YES |  |  |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  |  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  |  |
| 70 | `SI_MV01_1` | integer | YES |  |  |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  |  |
| 77 | `SI_MV01_Start` | timestamp(6) without time zone | YES |  |  |
| 78 | `SI_MV01_End` | timestamp(6) without time zone | YES |  |  |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  |  |
| 80 | `SI_MV01_Amt` | numeric | YES |  |  |
| 81 | `SI_MV02_1` | integer | YES |  |  |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp(6) without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp(6) without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  |  |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp(6) without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp(6) without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  |  |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp(6) without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp(6) without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  |  |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  |  |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  |  |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  |  |
| 120 | `Discount` | numeric(18,4) | YES |  |  |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  |  |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  |  |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  |  |
| 124 | `Total_Amt` | numeric(18,4) | YES |  |  |
| 125 | `Payment_status` | character varying(50) | YES |  |  |
| 126 | `Payment_channel` | character varying(50) | YES |  |  |
| 127 | `Payment_type` | character varying(50) | YES |  |  |
| 128 | `Payment_No` | character varying(50) | YES |  |  |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  |  |
| 142 | `NCB_Disc_perc` | numeric | YES |  |  |
| 143 | `Other_Disc_perc` | numeric | YES |  |  |
| 144 | `Surcharge_Amt` | numeric | YES |  |  |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  |  |
| 146 | `Total_Amt_mv` | numeric | YES |  |  |
| 147 | `Par_code` | character varying(50) | YES |  |  |
| 148 | `Email` | character varying(255) | YES |  |  |
| 149 | `Mobile` | character varying(255) | YES |  |  |
| 150 | `Flag_Car_Act` | character(1) | YES |  |  |
| 151 | `Flag_CCTV` | character(1) | YES |  |  |
| 152 | `Flag_Driver` | character(1) | YES |  |  |
| 153 | `Fleet_Disc_Amt` | numeric | YES |  |  |
| 154 | `NCB_Disc_Amt` | numeric | YES |  |  |
| 155 | `Other_Disc_Amt` | numeric | YES |  |  |
| 156 | `FirstName` | character varying(255) | YES |  |  |
| 157 | `LastName` | character varying(255) | YES |  |  |
| 158 | `Total_Disc_Amt` | numeric | YES |  |  |
| 159 | `NamedAge_Amt` | numeric | YES |  |  |
| 160 | `SI_DD_1` | integer | YES |  |  |
| 161 | `SI_DD_2` | integer | YES |  |  |
| 162 | `SI_DD_3` | integer | YES |  |  |
| 163 | `Prem_DD_1` | real | YES |  |  |
| 164 | `Prem_DD_2` | real | YES |  |  |
| 165 | `Prem_DD_3` | real | YES |  |  |
| 166 | `SI_DD_Ans` | integer | YES |  |  |
| 167 | `SI_DD_Start` | timestamp(6) without time zone | YES |  |  |
| 168 | `SI_DD_End` | timestamp(6) without time zone | YES |  |  |
| 169 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 170 | `SI_DD_Amt` | numeric | YES |  |  |
| 171 | `Flag_Access` | character(1) | YES |  |  |
| 172 | `CCTV` | integer | YES |  |  |
| 173 | `Access_para_code` | character varying(255) | YES |  |  |
| 174 | `YOB_Driver_1` | character(4) | YES |  |  |
| 175 | `YOB_Driver_2` | character(4) | YES |  |  |
| 176 | `Payment_Date` | timestamp(6) without time zone | YES |  |  |
| 177 | `Prem_ACT` | real | YES |  |  |
| 178 | `Basic_Premium` | numeric | YES |  |  |
| 179 | `SI_Limit` | numeric | YES |  |  |
| 180 | `SI_TPBI_Limit` | numeric | YES |  |  |
| 181 | `SI_TPPD_Limit` | numeric | YES |  |  |
| 182 | `SI_MV01_Limit` | numeric | YES |  |  |
| 183 | `SI_MV02_Limit` | numeric | YES |  |  |
| 184 | `SI_MV03_Limit` | numeric | YES |  |  |
| 185 | `SI_Access_Limit` | numeric | YES |  |  |
| 186 | `SF_Lead` | character varying(50) | YES |  |  |
| 187 | `Driver_Discount` | numeric | YES |  |  |
| 188 | `premium_v5_od` | numeric | YES |  |  |
| 189 | `Policy_book` | character varying(50) | YES |  |  |
| 190 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 191 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 192 | `Policy_book_act` | character varying(50) | YES |  |  |
| 193 | `Policy_Quatation_No_act` | character varying(50) | YES |  |  |
| 194 | `Policy_Invoice_No_act` | character varying(50) | YES |  |  |
| 195 | `promo_trans_id` | bigint | YES |  |  |
| 196 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 197 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 198 | `cover_day_count` | smallint | YES |  |  |
| 199 | `driver_age` | smallint | YES |  |  |
| 200 | `budget_lead_amt` | numeric(16,4) | YES |  |  |
| 201 | `affiliate_source` | character varying(255) | YES |  |  |
| 202 | `affiliate_code` | character varying(255) | YES |  |  |
| 203 | `referal_source` | character varying(255) | YES |  |  |
| 204 | `referal_code` | character varying(255) | YES |  |  |
| 205 | `basic_premium_v5` | numeric | YES |  |  |
| 206 | `ref_policy_no` | character varying(50) | YES |  |  |
| 207 | `renewal_mv_startdate` | timestamp(6) without time zone | YES |  |  |
| 208 | `renewal_mv_enddate` | timestamp(6) without time zone | YES |  |  |
| 209 | `renewal_mc_startdate` | timestamp(6) without time zone | YES |  |  |
| 210 | `renewal_mc_enddate` | timestamp(6) without time zone | YES |  |  |
| 211 | `cal_basic_renewal` | boolean | YES |  |  |
| 212 | `partner_code` | character varying(10) | YES |  |  |
| 213 | `cc_ans` | character varying(20) | YES |  |  |
| 214 | `par_prefix_name_1` | character varying(50) | YES |  |  |
| 215 | `par_first_name_1` | character varying(255) | YES |  |  |
| 216 | `par_last_name_1` | character varying(255) | YES |  |  |
| 217 | `par_birth_date_1` | date | YES |  |  |
| 218 | `par_citizen_id_1` | character varying(20) | YES |  |  |
| 219 | `par_driver_license_no_1` | character varying(20) | YES |  |  |
| 220 | `par_occupation_1` | character varying(255) | YES |  |  |
| 221 | `par_prefix_name_2` | character varying(50) | YES |  |  |
| 222 | `par_first_name_2` | character varying(255) | YES |  |  |
| 223 | `par_last_name_2` | character varying(255) | YES |  |  |
| 224 | `par_birth_date_2` | date | YES |  |  |
| 225 | `par_citizen_id_2` | character varying(20) | YES |  |  |
| 226 | `par_driver_license_no_2` | character varying(20) | YES |  |  |
| 227 | `par_occupation_2` | character varying(255) | YES |  |  |
| 228 | `par_prefix_name_3` | character varying(50) | YES |  |  |
| 229 | `par_first_name_3` | character varying(255) | YES |  |  |
| 230 | `par_last_name_3` | character varying(255) | YES |  |  |
| 231 | `par_birth_date_3` | date | YES |  |  |
| 232 | `par_citizen_id_3` | character varying(20) | YES |  |  |
| 233 | `par_driver_license_no_3` | character varying(20) | YES |  |  |
| 234 | `par_occupation_3` | character varying(255) | YES |  |  |
| 235 | `par_prefix_name_4` | character varying(50) | YES |  |  |
| 236 | `par_first_name_4` | character varying(255) | YES |  |  |
| 237 | `par_last_name_4` | character varying(255) | YES |  |  |
| 238 | `par_birth_date_4` | date | YES |  |  |
| 239 | `par_citizen_id_4` | character varying(20) | YES |  |  |
| 240 | `par_driver_license_no_4` | character varying(20) | YES |  |  |
| 241 | `par_occupation_4` | character varying(255) | YES |  |  |
| 242 | `par_prefix_name_5` | character varying(50) | YES |  |  |
| 243 | `par_first_name_5` | character varying(255) | YES |  |  |
| 244 | `par_last_name_5` | character varying(255) | YES |  |  |
| 245 | `par_birth_date_5` | date | YES |  |  |
| 246 | `par_citizen_id_5` | character varying(20) | YES |  |  |
| 247 | `par_driver_license_no_5` | character varying(20) | YES |  |  |
| 248 | `par_occupation_5` | character varying(255) | YES |  |  |
| 249 | `driver_behavior_1` | integer | YES |  |  |
| 250 | `driver_behavior_2` | integer | YES |  |  |
| 251 | `driver_behavior_3` | integer | YES |  |  |
| 252 | `driver_behavior_4` | integer | YES |  |  |
| 253 | `driver_behavior_5` | integer | YES |  |  |
| 254 | `driver_behavior_cal` | integer | YES |  |  |
| 255 | `driver_behavior_disc_perc` | real | YES |  |  |
| 256 | `driver_behavior_disc_amt` | numeric | YES |  |  |
| 257 | `car_price` | numeric | YES |  |  |
| 258 | `car_price_date` | date | YES |  |  |
| 259 | `sc_premium_amt_1` | real | YES |  |  |
| 260 | `sc_premium_amt_2` | real | YES |  |  |
| 261 | `sc_premium_amt_3` | real | YES |  |  |
| 262 | `sc_premium_amt_4` | real | YES |  |  |
| 263 | `sc_premium_amt_5` | real | YES |  |  |
| 264 | `sc_premium_amt_ans` | integer | YES |  |  |
| 265 | `prem_version` | smallint | YES |  |  |
| 266 | `oic_version` | character varying(20) | YES |  |  |
| 267 | `driver_behavior_consent_1` | boolean | YES |  |  |
| 268 | `driver_behavior_consent_2` | boolean | YES |  |  |
| 269 | `driver_behavior_consent_3` | boolean | YES |  |  |
| 270 | `driver_behavior_consent_4` | boolean | YES |  |  |
| 271 | `driver_behavior_consent_5` | boolean | YES |  |  |
| 272 | `par_occupation_code_1` | character varying(50) | YES |  |  |
| 273 | `par_occupation_code_2` | character varying(50) | YES |  |  |
| 274 | `par_occupation_code_3` | character varying(50) | YES |  |  |
| 275 | `par_occupation_code_4` | character varying(50) | YES |  |  |
| 276 | `par_occupation_code_5` | character varying(50) | YES |  |  |
| 277 | `driver_behavior` | integer | YES |  |  |
| 278 | `sc_premium_amt` | numeric | YES |  |  |

**Primary key:** _none_

---

## OIC_Perc_Discount_by_Day

`insurverse.OIC_Perc_Discount_by_Day` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Range_start` | smallint | NO |  | ช่วงส่วนลดเริ่มต้น |
| 2 | `Range_end` | smallint | NO |  | ช่วงส่วนลดสิ้นสุด |
| 3 | `Perc_discount` | numeric | YES |  |  |
| 4 | `Remark` | character varying(255) | YES |  |  |
| 5 | `Create_date` | timestamp without time zone | YES |  |  |
| 6 | `Create_user` | character varying(50) | YES |  |  |
| 7 | `Update_date` | timestamp without time zone | YES |  |  |
| 8 | `Update_user` | character varying(50) | YES |  |  |

**Primary key:** `Range_start,Range_end` (OIC_Perc_Discount_by_Day_pkey)

**Indexes:**

- `OIC_Perc_Discount_by_Day_pkey`: `CREATE UNIQUE INDEX "OIC_Perc_Discount_by_Day_pkey" ON insurverse."OIC_Perc_Discount_by_Day" USING btree ("Range_start", "Range_end")`

---

## OIC_Perc_Return_Act_by_Day

`insurverse.OIC_Perc_Return_Act_by_Day` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Range_start` | smallint | NO |  | เดือนที่คุ้มครอง |
| 2 | `Range_end` | smallint | NO |  | เดือนที่สิ้นสุดคุ้มครอง |
| 3 | `Perc_return` | numeric | YES |  | จำนวน % ที่ต้องชำระคืน |
| 4 | `Remark` | character varying(255) | YES |  |  |
| 5 | `Create_date` | timestamp without time zone | YES |  |  |
| 6 | `Create_user` | character varying(50) | YES |  |  |
| 7 | `Update_date` | timestamp without time zone | YES |  |  |
| 8 | `Update_user` | character varying(50) | YES |  |  |

**Primary key:** `Range_start,Range_end` (OIC_Prec_Return_Act_by_Day_pkey)

**Indexes:**

- `OIC_Prec_Return_Act_by_Day_pkey`: `CREATE UNIQUE INDEX "OIC_Prec_Return_Act_by_Day_pkey" ON insurverse."OIC_Perc_Return_Act_by_Day" USING btree ("Range_start", "Range_end")`

---

## OIC_Perc_Return_by_Day

`insurverse.OIC_Perc_Return_by_Day` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Range_start` | smallint | NO |  | ช่วงนับวันที่เริ่มต้น |
| 2 | `Range_end` | smallint | NO |  | ช่วงนับวันที่สิ้นสุด |
| 3 | `Perc_return` | numeric | YES |  | จำนวน % ที่ต้องชำระคืน |
| 4 | `Remark` | character varying(255) | YES |  |  |
| 5 | `Create_date` | timestamp without time zone | YES |  |  |
| 6 | `Create_user` | character varying(50) | YES |  |  |
| 7 | `Update_date` | timestamp without time zone | YES |  |  |
| 8 | `Update_user` | character varying(50) | YES |  |  |

**Primary key:** `Range_start,Range_end` (OIC_Perc_Discount_by_Day_copy1_pkey)

**Indexes:**

- `OIC_Perc_Discount_by_Day_copy1_pkey`: `CREATE UNIQUE INDEX "OIC_Perc_Discount_by_Day_copy1_pkey" ON insurverse."OIC_Perc_Return_by_Day" USING btree ("Range_start", "Range_end")`

---

## Policy_Car_Act_Discount_Premium

`insurverse.Policy_Car_Act_Discount_Premium` · kind: table · est. rows: **246**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Car_Act_No` | character varying(50) | NO |  | รหัส พรบ |
| 2 | `Policy_No` | character varying(50) | YES |  | รหัสกรมธรรม์ |
| 3 | `Brand` | character varying(255) | YES |  |  |
| 4 | `Model` | character varying(255) | YES |  |  |
| 5 | `Year` | character varying(255) | YES |  |  |
| 6 | `Doors` | smallint | YES |  |  |
| 7 | `Seat` | smallint | YES |  |  |
| 8 | `Wg` | integer | YES |  |  |
| 9 | `Group` | character varying(255) | YES |  |  |
| 10 | `Type` | character varying(50) | YES |  |  |
| 11 | `Sedan` | character varying(255) | YES |  |  |
| 12 | `BodyType` | character varying(255) | YES |  |  |
| 13 | `Start_date` | timestamp without time zone | YES |  | วันเริ่มคุ้มครอง |
| 14 | `End_date` | timestamp without time zone | YES |  | วันสิ้นสุดคุ้มครอง |
| 15 | `Create_date` | timestamp without time zone | YES |  |  |
| 16 | `Create_by` | character varying(50) | YES |  |  |
| 17 | `Update_date` | timestamp without time zone | YES |  |  |
| 18 | `Update_by` | character varying(50) | YES |  |  |
| 19 | `Payment_status` | character varying(50) | YES |  | สถานะจ่าย |
| 20 | `Payment_channel` | character varying(50) | YES |  | ช่องทางจ่าย |
| 21 | `Payment_type` | character varying(50) | YES |  | ประเภทจ่าย |
| 22 | `Payment_No` | character varying(50) | YES |  | หมายเลขสำคัญจ่าย |
| 23 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 24 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 25 | `Payment_result` | character varying(50) | YES |  |  |
| 26 | `Recept_no` | character varying(50) | YES |  |  |
| 27 | `Tax_No` | character varying(50) | YES |  |  |
| 28 | `Flex_field1` | character varying(255) | YES |  |  |
| 29 | `Flex_field2` | character varying(255) | YES |  |  |
| 30 | `Flex_field3` | character varying(255) | YES |  |  |
| 31 | `Policy_Quatation_No` | character varying(50) | YES |  | Ref. ใบเสนอราคา |
| 32 | `Policy_Invoice_No` | character varying(50) | YES |  | Ref. ใบเสร็จ |
| 33 | `IIA_Ref_no` | character varying(50) | YES |  | Ref. IIA |
| 34 | `prefix_name` | character varying(50) | YES |  | ปร 01 ผู้เอาประกัน |
| 35 | `first_name` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 36 | `last_name` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 37 | `birth_date` | date | YES |  | ปร 01 ผู้เอาประกัน |
| 38 | `citizen_id` | character varying(13) | YES |  |  |
| 39 | `province_id` | integer | YES |  |  |
| 40 | `subdistrict_id` | integer | YES |  |  |
| 41 | `district_id` | integer | YES |  |  |
| 42 | `zipcode` | character varying(45) | YES |  |  |
| 43 | `countryid` | integer | YES |  |  |
| 44 | `phone` | character varying(45) | YES |  |  |
| 45 | `IsKYC` | character varying(50) | YES |  |  |
| 46 | `KYC_id` | character varying(50) | YES |  |  |
| 47 | `KYC_date` | timestamp without time zone | YES |  |  |
| 48 | `Occupation` | character varying(255) | YES |  | อาชีพ |
| 49 | `Remark` | character varying(255) | YES |  | หมายเหตุ |
| 50 | `Car_Comp_Code` | character varying(50) | YES |  | Code การใช้รถ  |
| 51 | `Premium` | numeric | YES |  |  |
| 52 | `Discount` | numeric | YES |  |  |
| 53 | `Net_Premium` | numeric | YES |  |  |
| 54 | `Stamp` | numeric | YES |  |  |
| 55 | `Vat` | numeric | YES |  |  |
| 56 | `Total` | numeric | YES |  |  |
| 57 | `CC` | character varying(255) | YES |  |  |
| 58 | `Car_license_no` | character varying(50) | YES |  | รย 17 ป้ายเลขทะเบียน |
| 59 | `Car_license_provice` | character varying(50) | YES |  | รย 17 จังหวัด ที่จด |
| 60 | `Car_serial_no` | character varying(50) | YES |  | รย 17 ตัวถังรถ |
| 61 | `Effective_Startdate` | timestamp without time zone | NO |  |  |
| 62 | `Effective_Enddate` | timestamp without time zone | YES |  |  |
| 63 | `cmi_reference_number` | character varying(50) | YES |  | รหัสอ้างอิง CMI Realtime |
| 64 | `cmi_receive_number` | character varying(50) | YES |  | รหัสรับ CMI Realtime |
| 65 | `cmi_endorse_ref_number` | character varying(50) | YES |  | รหัสอ้างอิงสลักหลัง CMI Realtime |
| 66 | `cmi_endorse_receive_number` | character varying(50) | YES |  | รหัสรับสลักหลัง CMI Realtime |
| 67 | `cmi_update_date` | timestamp without time zone | YES |  | วันที่เวลาส่งข้อมูล CMI Realtime |
| 68 | `Comp_Code` | character varying(255) | YES |  | ชื่อย่อบริษัท ISV (Default) |
| 69 | `Policy_book` | character varying(50) | YES |  | เล่มที่กรมธรรม์ |
| 70 | `Deli_Addr_line1` | character varying(255) | YES |  | ที่อยู่จัดส่ง |
| 71 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 72 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 73 | `Deli_province_id` | integer | YES |  |  |
| 74 | `Deli_subdistrict_id` | integer | YES |  |  |
| 75 | `Deli_district_id` | integer | YES |  |  |
| 76 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 77 | `Deli_countryid` | integer | YES |  |  |
| 78 | `Car_license_type` | character varying(50) | YES |  | [Policy]-[Car_license_type] ป้ายแดง จดทะเบียน |
| 79 | `Policy_Ref_no` | character varying(50) | YES |  | Ref. อ้างอิง |
| 80 | `Policy_QR_code` | character varying(255) | YES |  | วันคุ้มครองกรมธรรม์ + ตัวเลขตัวถัง |
| 81 | `Car_color` | character varying(255) | YES |  | สีรถ |
| 82 | `Lead_No` | integer | YES |  |  |
| 83 | `Policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 84 | `Policy_Barcode` | character varying(50) | YES |  | ISV Barcode บนกรมธรรม์ |
| 85 | `Policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 86 | `address` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 87 | `email` | character varying(255) | YES |  |  |
| 88 | `Bene_Type` | character varying(50) | YES |  | รย 24 ไฟแนนซ์ บุคคล |
| 89 | `Bene_Title` | character varying(50) | YES |  | ที่อยู่ผู้รับผลประโยชน์ |
| 90 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 91 | `Bene_Midname` | character varying(255) | YES |  |  |
| 92 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 93 | `Bene_ID_card` | character varying(50) | YES |  | หมายเลขเอกสารผู้รับผลประโยชน์ |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 98 | `Payment_date` | timestamp without time zone | YES |  |  |
| 99 | `IIA_Lot_No` | character varying(20) | YES |  | IIA Lot no. |
| 100 | `Flag_Deli` | character(1) | YES |  | y = จัดส่งรูปเล่มกรมธรรม์, n = ไม่จัดส่งรูปเล่มกรมธรรม์ |
| 101 | `SF_Policy_id` | character varying(255) | YES |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 102 | `Car_Act_Lead_No` | bigint | YES |  | รหัส Lead พรบ |
| 103 | `Policy_Status` | character varying(50) | YES |  | ACT, INC รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง // ประกันชั้น 2+3+ รยภ 00 ยกเลิก |
| 104 | `Appr_prefix_name` | character varying(50) | YES |  | คำนำหน้าผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 105 | `Appr_first_name` | character varying(255) | YES |  | ชื่อผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 106 | `Appr_last_name` | character varying(255) | YES |  | นามสกุลผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 107 | `cmi_status` | character varying(255) | YES |  | สถานะ success = สำเร็จ, dup = ซ้ำ |
| 108 | `Change_Perm_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันสุทธิ หลังการสลักหลัง |
| 109 | `Change_Duty_Amt` | numeric | YES |  | ส่วนต่างอากรแสตมป์ หลังการสลักหลัง |
| 110 | `Change_Vat_Amt` | numeric | YES |  | ส่วนต่างภาษีมูลค่าเพิ่ม หลังการสลักหลัง |
| 111 | `Change_Total_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันรวม หลังการสลักหลัง |
| 112 | `par_id` | integer | YES |  |  |
| 113 | `promo_trans_id` | bigint | YES |  |  |
| 114 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 115 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 116 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 117 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 118 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 119 | `Extend_Start` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองเริ่มต้น |
| 120 | `Extend_End` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองสิ้นสุด |
| 121 | `extend_amt` | numeric(16,4) | YES |  | ค่าเบี้ยเพิ่มกรณีสลักหลังขยายวันคุ้มครอง |
| 122 | `mas_premium` | numeric | YES |  | ราคาเบี้ยเต็มจาก master data รองรับสลักหลัง |
| 123 | `mas_discount` | numeric | YES |  | ราคาส่วนลดจาก master data รองรับสลักหลัง |
| 124 | `mas_net_premium` | numeric | YES |  | ราคาหลังหักส่วนลดจาก master data รองรับสลักหลัง |
| 125 | `mas_stamp` | numeric | YES |  | ราคาอากรจาก master data รองรับสลักหลัง |
| 126 | `mas_vat` | numeric | YES |  | ราคาภาษีจาก master data รองรับสลักหลัง |
| 127 | `mas_total` | numeric | YES |  | ราคารวมจาก master data รองรับสลักหลัง |
| 128 | `ref_policy_no` | character varying(50) | YES |  | อ้างอิงเลขกรมธรรม์เดิมสำหรับต่อกรมธรรม์ |
| 129 | `partner_code` | character varying(10) | YES |  | รหัส partner |
| 130 | `occupation_code` | character varying(50) | YES |  | รหัส อาชีพ |
| 131 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 132 | `hp` | integer | YES |  |  |
| 133 | `engineType` | character varying(3) | NO | `'ICE'::character varying` |  |
| 134 | `customer_id` | character varying(100) | YES |  |  |

**Primary key:** `Car_Act_No` (Car_Act_Discount_Premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Car_Act_Lead_No` → Lead_Car_Act_Discount_Premium, `Comp_Code` → company_detail, `Deli_countryid` → mas_country, `Deli_district_id` → district, `Deli_province_id` → province, `Deli_subdistrict_id` → subdistrict, `Lead_No` → Lead_coverage_premium, `Policy_No` → Policy_Header, `countryid` → mas_country, `district_id` → district, `par_id` → policy_participant, `partner_code` → mas_partner, `promo_trans_id` → promo_code_trans, `province_id` → province, `ref_policy_no` → Policy_Header, `subdistrict_id` → subdistrict

**Constraints:**

- CHECK `Policy_Car_Act_Discount_Premium_hp_check`: `CHECK (((hp >= 1) AND (hp <= 9999)))`

**Indexes:**

- `Car_Act_Discount_Premium_pkey`: `CREATE UNIQUE INDEX "Car_Act_Discount_Premium_pkey" ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Car_Act_No")`
- `idx_pcadp_lead_no`: `CREATE INDEX idx_pcadp_lead_no ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Lead_No")`
- `idx_pcadp_pair_lookup`: `CREATE INDEX idx_pcadp_pair_lookup ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Car_license_no", "Car_serial_no") WHERE ((("Policy_Status")::text = 'ACT'::text) AND ("Policy_No" IS NULL) AND ("Car_serial_no" IS NOT NULL) AND (("Car_serial_no")::text <> ''::text))`
- `idx_pcadp_policy_no`: `CREATE INDEX idx_pcadp_policy_no ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Policy_No")`
- `idx_pcadp_ref_policy_no`: `CREATE INDEX idx_pcadp_ref_policy_no ON insurverse."Policy_Car_Act_Discount_Premium" USING btree (ref_policy_no)`

---

## Policy_Car_Act_Discount_Premium_8aug

`insurverse.Policy_Car_Act_Discount_Premium_8aug` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Car_Act_No` | character varying(50) | YES |  |  |
| 2 | `Policy_No` | character varying(50) | YES |  |  |
| 3 | `Brand` | character varying(255) | YES |  |  |
| 4 | `Model` | character varying(255) | YES |  |  |
| 5 | `Year` | character varying(255) | YES |  |  |
| 6 | `Doors` | smallint | YES |  |  |
| 7 | `Seat` | smallint | YES |  |  |
| 8 | `Wg` | integer | YES |  |  |
| 9 | `Group` | character varying(255) | YES |  |  |
| 10 | `Type` | character varying(50) | YES |  |  |
| 11 | `Sedan` | character varying(255) | YES |  |  |
| 12 | `BodyType` | character varying(255) | YES |  |  |
| 13 | `Start_date` | timestamp without time zone | YES |  |  |
| 14 | `End_date` | timestamp without time zone | YES |  |  |
| 15 | `Create_date` | timestamp without time zone | YES |  |  |
| 16 | `Create_by` | character varying(50) | YES |  |  |
| 17 | `Update_date` | timestamp without time zone | YES |  |  |
| 18 | `Update_by` | character varying(50) | YES |  |  |
| 19 | `Payment_status` | character varying(50) | YES |  |  |
| 20 | `Payment_channel` | character varying(50) | YES |  |  |
| 21 | `Payment_type` | character varying(50) | YES |  |  |
| 22 | `Payment_No` | character varying(50) | YES |  |  |
| 23 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 24 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 25 | `Payment_result` | character varying(50) | YES |  |  |
| 26 | `Recept_no` | character varying(50) | YES |  |  |
| 27 | `Tax_No` | character varying(50) | YES |  |  |
| 28 | `Flex_field1` | character varying(255) | YES |  |  |
| 29 | `Flex_field2` | character varying(255) | YES |  |  |
| 30 | `Flex_field3` | character varying(255) | YES |  |  |
| 31 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 32 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 33 | `IIA_Ref_no` | character varying(50) | YES |  |  |
| 34 | `prefix_name` | character varying(50) | YES |  |  |
| 35 | `first_name` | character varying(255) | YES |  |  |
| 36 | `last_name` | character varying(255) | YES |  |  |
| 37 | `birth_date` | date | YES |  |  |
| 38 | `citizen_id` | character varying(13) | YES |  |  |
| 39 | `province_id` | integer | YES |  |  |
| 40 | `subdistrict_id` | integer | YES |  |  |
| 41 | `district_id` | integer | YES |  |  |
| 42 | `zipcode` | character varying(45) | YES |  |  |
| 43 | `countryid` | integer | YES |  |  |
| 44 | `phone` | character varying(45) | YES |  |  |
| 45 | `IsKYC` | character varying(50) | YES |  |  |
| 46 | `KYC_id` | character varying(50) | YES |  |  |
| 47 | `KYC_date` | timestamp without time zone | YES |  |  |
| 48 | `Occupation` | character varying(255) | YES |  |  |
| 49 | `Remark` | character varying(255) | YES |  |  |
| 50 | `Car_Comp_Code` | character varying(50) | YES |  |  |
| 51 | `Premium` | numeric | YES |  |  |
| 52 | `Discount` | numeric | YES |  |  |
| 53 | `Net_Premium` | numeric | YES |  |  |
| 54 | `Stamp` | numeric | YES |  |  |
| 55 | `Vat` | numeric | YES |  |  |
| 56 | `Total` | numeric | YES |  |  |
| 57 | `CC` | character varying(255) | YES |  |  |
| 58 | `Car_license_no` | character varying(50) | YES |  |  |
| 59 | `Car_license_provice` | character varying(50) | YES |  |  |
| 60 | `Car_serial_no` | character varying(50) | YES |  |  |
| 61 | `Effective_Startdate` | timestamp without time zone | YES |  |  |
| 62 | `Effective_Enddate` | timestamp without time zone | YES |  |  |
| 63 | `cmi_reference_number` | character varying(50) | YES |  |  |
| 64 | `cmi_receive_number` | character varying(50) | YES |  |  |
| 65 | `cmi_endorse_ref_number` | character varying(50) | YES |  |  |
| 66 | `cmi_endorse_receive_number` | character varying(50) | YES |  |  |
| 67 | `cmi_update_date` | timestamp without time zone | YES |  |  |
| 68 | `Comp_Code` | character varying(255) | YES |  |  |
| 69 | `Policy_book` | character varying(50) | YES |  |  |
| 70 | `Deli_Addr_line1` | character varying(255) | YES |  |  |
| 71 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 72 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 73 | `Deli_province_id` | integer | YES |  |  |
| 74 | `Deli_subdistrict_id` | integer | YES |  |  |
| 75 | `Deli_district_id` | integer | YES |  |  |
| 76 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 77 | `Deli_countryid` | integer | YES |  |  |
| 78 | `Car_license_type` | character varying(50) | YES |  |  |
| 79 | `Policy_Ref_no` | character varying(50) | YES |  |  |
| 80 | `Policy_QR_code` | character varying(255) | YES |  |  |
| 81 | `Car_color` | character varying(255) | YES |  |  |
| 82 | `Lead_No` | integer | YES |  |  |
| 83 | `Policy_url_ref` | character varying(500) | YES |  |  |
| 84 | `Policy_Barcode` | character varying(50) | YES |  |  |
| 85 | `Policy_url_copy_ref` | character varying(500) | YES |  |  |
| 86 | `address` | character varying(255) | YES |  |  |
| 87 | `email` | character varying(255) | YES |  |  |
| 88 | `Bene_Type` | character varying(50) | YES |  |  |
| 89 | `Bene_Title` | character varying(50) | YES |  |  |
| 90 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 91 | `Bene_Midname` | character varying(255) | YES |  |  |
| 92 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 93 | `Bene_ID_card` | character varying(50) | YES |  |  |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  |  |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  |  |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  |  |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  |  |
| 98 | `Payment_date` | timestamp without time zone | YES |  |  |
| 99 | `IIA_Lot_No` | character varying(20) | YES |  |  |
| 100 | `Flag_Deli` | bpchar | YES |  |  |
| 101 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 102 | `Car_Act_Lead_No` | bigint | YES |  |  |
| 103 | `Policy_Status` | character varying(50) | YES |  |  |
| 104 | `Appr_prefix_name` | character varying(50) | YES |  |  |
| 105 | `Appr_first_name` | character varying(255) | YES |  |  |
| 106 | `Appr_last_name` | character varying(255) | YES |  |  |
| 107 | `cmi_status` | character varying(255) | YES |  |  |
| 108 | `Change_Perm_Amt` | numeric | YES |  |  |
| 109 | `Change_Duty_Amt` | numeric | YES |  |  |
| 110 | `Change_Vat_Amt` | numeric | YES |  |  |
| 111 | `Change_Total_Amt` | numeric | YES |  |  |
| 112 | `par_id` | integer | YES |  |  |
| 113 | `promo_trans_id` | bigint | YES |  |  |
| 114 | `promo_discount_per` | numeric | YES |  |  |
| 115 | `promo_discount_amt` | numeric | YES |  |  |
| 116 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 117 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 118 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 119 | `Extend_Start` | timestamp without time zone | YES |  |  |
| 120 | `Extend_End` | timestamp without time zone | YES |  |  |
| 121 | `extend_amt` | numeric | YES |  |  |
| 122 | `mas_premium` | numeric | YES |  |  |
| 123 | `mas_discount` | numeric | YES |  |  |
| 124 | `mas_net_premium` | numeric | YES |  |  |
| 125 | `mas_stamp` | numeric | YES |  |  |
| 126 | `mas_vat` | numeric | YES |  |  |
| 127 | `mas_total` | numeric | YES |  |  |
| 128 | `ref_policy_no` | character varying(50) | YES |  |  |
| 129 | `partner_code` | character varying(10) | YES |  |  |

**Primary key:** _none_

---

## Policy_Car_Act_Discount_Premium_Trans

`insurverse.Policy_Car_Act_Discount_Premium_Trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Car_Act_No` | character varying(50) | NO |  | รหัส พรบ |
| 2 | `Policy_No` | character varying(50) | YES |  | รหัสกรมธรรม์ |
| 3 | `Brand` | character varying(255) | YES |  |  |
| 4 | `Model` | character varying(255) | YES |  |  |
| 5 | `Year` | character varying(255) | YES |  |  |
| 6 | `Doors` | smallint | YES |  |  |
| 7 | `Seat` | smallint | YES |  |  |
| 8 | `Wg` | integer | YES |  |  |
| 9 | `Group` | character varying(255) | YES |  |  |
| 10 | `Type` | character varying(50) | YES |  |  |
| 11 | `Sedan` | character varying(255) | YES |  |  |
| 12 | `BodyType` | character varying(255) | YES |  |  |
| 13 | `Start_date` | timestamp without time zone | YES |  | วันเริ่มคุ้มครอง |
| 14 | `End_date` | timestamp without time zone | YES |  | วันสิ้นสุดคุ้มครอง |
| 15 | `Create_date` | timestamp without time zone | NO |  |  |
| 16 | `Create_by` | character varying(50) | YES |  |  |
| 17 | `Update_date` | timestamp without time zone | YES |  |  |
| 18 | `Update_by` | character varying(50) | YES |  |  |
| 19 | `Payment_status` | character varying(50) | YES |  | สถานะจ่าย |
| 20 | `Payment_channel` | character varying(50) | YES |  | ช่องทางจ่าย |
| 21 | `Payment_type` | character varying(50) | YES |  | ประเภทจ่าย |
| 22 | `Payment_No` | character varying(50) | YES |  | หมายเลขสำคัญจ่าย |
| 23 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 24 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 25 | `Payment_result` | character varying(50) | YES |  |  |
| 26 | `Recept_no` | character varying(50) | YES |  |  |
| 27 | `Tax_No` | character varying(50) | YES |  |  |
| 28 | `Flex_field1` | character varying(255) | YES |  |  |
| 29 | `Flex_field2` | character varying(255) | YES |  |  |
| 30 | `Flex_field3` | character varying(255) | YES |  |  |
| 31 | `Policy_Quatation_No` | character varying(50) | YES |  | Ref. ใบเสนอราคา |
| 32 | `Policy_Invoice_No` | character varying(50) | YES |  | Ref. ใบเสร็จ |
| 33 | `IIA_Ref_no` | character varying(50) | YES |  | Ref. IIA |
| 34 | `prefix_name` | character varying(50) | YES |  | ปร 01 ผู้เอาประกัน |
| 35 | `first_name` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 36 | `last_name` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 37 | `birth_date` | date | YES |  | ปร 01 ผู้เอาประกัน |
| 38 | `citizen_id` | character varying(13) | YES |  |  |
| 39 | `province_id` | integer | YES |  |  |
| 40 | `subdistrict_id` | integer | YES |  |  |
| 41 | `district_id` | integer | YES |  |  |
| 42 | `zipcode` | character varying(45) | YES |  |  |
| 43 | `countryid` | integer | YES |  |  |
| 44 | `phone` | character varying(45) | YES |  |  |
| 45 | `IsKYC` | character varying(50) | YES |  |  |
| 46 | `KYC_id` | character varying(50) | YES |  |  |
| 47 | `KYC_date` | timestamp without time zone | YES |  |  |
| 48 | `Occupation` | character varying(255) | YES |  | อาชีพ |
| 49 | `Remark` | character varying(255) | YES |  | หมายเหตุ |
| 50 | `Car_Comp_Code` | character varying(50) | YES |  | Code การใช้รถ  |
| 51 | `Premium` | numeric | YES |  |  |
| 52 | `Discount` | numeric | YES |  |  |
| 53 | `Net_Premium` | numeric | YES |  |  |
| 54 | `Stamp` | numeric | YES |  |  |
| 55 | `Vat` | numeric | YES |  |  |
| 56 | `Total` | numeric | YES |  |  |
| 57 | `CC` | character varying(255) | YES |  |  |
| 58 | `Car_license_no` | character varying(50) | YES |  | รย 17 ป้ายเลขทะเบียน |
| 59 | `Car_license_provice` | character varying(50) | YES |  | รย 17 จังหวัด ที่จด |
| 60 | `Car_serial_no` | character varying(50) | YES |  | รย 17 ตัวถังรถ |
| 61 | `Effective_Startdate` | timestamp without time zone | NO |  |  |
| 62 | `Effective_Enddate` | timestamp without time zone | YES |  |  |
| 63 | `cmi_reference_number` | character varying(50) | YES |  | รหัสอ้างอิง CMI Realtime |
| 64 | `cmi_receive_number` | character varying(50) | YES |  | รหัสรับ CMI Realtime |
| 65 | `cmi_endorse_ref_number` | character varying(50) | YES |  | รหัสอ้างอิงสลักหลัง CMI Realtime |
| 66 | `cmi_endorse_receive_number` | character varying(50) | YES |  | รหัสรับสลักหลัง CMI Realtime |
| 67 | `cmi_update_date` | timestamp without time zone | YES |  | วันที่เวลาส่งข้อมูล CMI Realtime |
| 68 | `Comp_Code` | character varying(255) | YES |  | ชื่อย่อบริษัท ISV (Default) |
| 69 | `Policy_book` | character varying(50) | YES |  | เล่มที่กรมธรรม์ |
| 70 | `Deli_Addr_line1` | character varying(255) | YES |  | ที่อยู่จัดส่ง |
| 71 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 72 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 73 | `Deli_province_id` | integer | YES |  |  |
| 74 | `Deli_subdistrict_id` | integer | YES |  |  |
| 75 | `Deli_district_id` | integer | YES |  |  |
| 76 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 77 | `Deli_countryid` | integer | YES |  |  |
| 78 | `Car_license_type` | character varying(50) | YES |  | [Policy]-[Car_license_type] ป้ายแดง จดทะเบียน |
| 79 | `Policy_Ref_no` | character varying(50) | YES |  | Ref. อ้างอิง |
| 80 | `Policy_QR_code` | character varying(255) | YES |  | วันคุ้มครองกรมธรรม์ + ตัวเลขตัวถัง |
| 81 | `Car_color` | character varying(255) | YES |  | สีรถ |
| 82 | `Lead_No` | integer | YES |  |  |
| 83 | `Policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 84 | `Policy_Barcode` | character varying(50) | YES |  | ISV Barcode บนกรมธรรม์ |
| 85 | `Policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 86 | `address` | character varying(255) | YES |  | ปร 01 ผู้เอาประกัน |
| 87 | `email` | character varying(255) | YES |  |  |
| 88 | `Bene_Type` | character varying(50) | YES |  | รย 24 ไฟแนนซ์ บุคคล |
| 89 | `Bene_Title` | character varying(50) | YES |  | ที่อยู่ผู้รับผลประโยชน์ |
| 90 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 91 | `Bene_Midname` | character varying(255) | YES |  |  |
| 92 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 93 | `Bene_ID_card` | character varying(50) | YES |  | หมายเลขเอกสารผู้รับผลประโยชน์ |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 98 | `Payment_date` | timestamp without time zone | YES |  |  |
| 99 | `IIA_Lot_No` | character varying(20) | YES |  | IIA Lot no. |
| 100 | `Flag_Deli` | character(1) | YES |  | y = จัดส่งรูปเล่มกรมธรรม์, n = ไม่จัดส่งรูปเล่มกรมธรรม์ |
| 101 | `SF_Policy_id` | character varying(255) | YES |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 102 | `Car_Act_Lead_No` | bigint | YES |  | รหัส Lead พรบ |
| 103 | `Policy_Status` | character varying(50) | YES |  | ACT, INC รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง // ประกันชั้น 2+3+ รยภ 00 ยกเลิก |
| 104 | `Appr_prefix_name` | character varying(50) | YES |  | คำนำหน้าผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 105 | `Appr_first_name` | character varying(255) | YES |  | ชื่อผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 106 | `Appr_last_name` | character varying(255) | YES |  | นามสกุลผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 107 | `cmi_status` | character varying(255) | YES |  | สถานะ success = สำเร็จ, dup = ซ้ำ |
| 108 | `Change_Perm_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันสุทธิ หลังการสลักหลัง |
| 109 | `Change_Duty_Amt` | numeric | YES |  | ส่วนต่างอากรแสตมป์ หลังการสลักหลัง |
| 110 | `Change_Vat_Amt` | numeric | YES |  | ส่วนต่างภาษีมูลค่าเพิ่ม หลังการสลักหลัง |
| 111 | `Change_Total_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันรวม หลังการสลักหลัง |
| 112 | `par_id` | integer | YES |  |  |
| 113 | `promo_trans_id` | bigint | YES |  |  |
| 114 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 115 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 116 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 117 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 118 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 119 | `Extend_Start` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองเริ่มต้น |
| 120 | `Extend_End` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองสิ้นสุด |
| 121 | `extend_amt` | numeric(16,4) | YES |  | ค่าเบี้ยเพิ่มกรณีสลักหลังขยายวันคุ้มครอง |
| 122 | `mas_premium` | numeric | YES |  | ราคาเบี้ยเต็มจาก master data รองรับสลักหลัง |
| 123 | `mas_discount` | numeric | YES |  | ราคาส่วนลดจาก master data รองรับสลักหลัง |
| 124 | `mas_net_premium` | numeric | YES |  | ราคาหลังหักส่วนลดจาก master data รองรับสลักหลัง |
| 125 | `mas_stamp` | numeric | YES |  | ราคาอากรจาก master data รองรับสลักหลัง |
| 126 | `mas_vat` | numeric | YES |  | ราคาภาษีจาก master data รองรับสลักหลัง |
| 127 | `mas_total` | numeric | YES |  | ราคารวมจาก master data รองรับสลักหลัง |
| 128 | `ref_policy_no` | character varying(50) | YES |  | อ้างอิงเลขกรมธรรม์เดิมสำหรับต่อกรมธรรม์ |
| 129 | `partner_code` | character varying(10) | YES |  | รหัส partner |
| 130 | `occupation_code` | character varying(50) | YES |  | รหัส อาชีพ |
| 131 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 132 | `hp` | integer | YES |  |  |
| 133 | `engineType` | character varying(3) | NO | `'ICE'::character varying` |  |
| 134 | `customer_id` | character varying(100) | YES |  |  |

**Primary key:** `Car_Act_No,Effective_Startdate,Create_date` (Policy_Car_Act_Discount_Premium_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Car_Act_Lead_No` → Lead_Car_Act_Discount_Premium, `Car_Act_No` → Policy_Car_Act_Discount_Premium, `Comp_Code` → company_detail, `Deli_countryid` → mas_country, `Deli_district_id` → district, `Deli_province_id` → province, `Deli_subdistrict_id` → subdistrict, `Lead_No` → Lead_coverage_premium, `Policy_No` → Policy_Header, `countryid` → mas_country, `district_id` → district, `par_id` → policy_participant, `partner_code` → mas_partner, `promo_trans_id` → promo_code_trans, `province_id` → province, `ref_policy_no` → Policy_Header, `subdistrict_id` → subdistrict

**Constraints:**

- CHECK `Policy_Car_Act_Discount_Premium_Trans_hp_check`: `CHECK (((hp >= 1) AND (hp <= 9999)))`

**Indexes:**

- `Policy_Car_Act_Discount_Premium_copy1_pkey`: `CREATE UNIQUE INDEX "Policy_Car_Act_Discount_Premium_copy1_pkey" ON insurverse."Policy_Car_Act_Discount_Premium_Trans" USING btree ("Car_Act_No", "Effective_Startdate", "Create_date")`

---

## Policy_Car_Act_Discount_Premium_Trans_20260810

`insurverse.Policy_Car_Act_Discount_Premium_Trans_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Car_Act_No` | character varying(50) | YES |  |  |
| 2 | `Policy_No` | character varying(50) | YES |  |  |
| 3 | `Brand` | character varying(255) | YES |  |  |
| 4 | `Model` | character varying(255) | YES |  |  |
| 5 | `Year` | character varying(255) | YES |  |  |
| 6 | `Doors` | smallint | YES |  |  |
| 7 | `Seat` | smallint | YES |  |  |
| 8 | `Wg` | integer | YES |  |  |
| 9 | `Group` | character varying(255) | YES |  |  |
| 10 | `Type` | character varying(50) | YES |  |  |
| 11 | `Sedan` | character varying(255) | YES |  |  |
| 12 | `BodyType` | character varying(255) | YES |  |  |
| 13 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 14 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 15 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 16 | `Create_by` | character varying(50) | YES |  |  |
| 17 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 18 | `Update_by` | character varying(50) | YES |  |  |
| 19 | `Payment_status` | character varying(50) | YES |  |  |
| 20 | `Payment_channel` | character varying(50) | YES |  |  |
| 21 | `Payment_type` | character varying(50) | YES |  |  |
| 22 | `Payment_No` | character varying(50) | YES |  |  |
| 23 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 24 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 25 | `Payment_result` | character varying(50) | YES |  |  |
| 26 | `Recept_no` | character varying(50) | YES |  |  |
| 27 | `Tax_No` | character varying(50) | YES |  |  |
| 28 | `Flex_field1` | character varying(255) | YES |  |  |
| 29 | `Flex_field2` | character varying(255) | YES |  |  |
| 30 | `Flex_field3` | character varying(255) | YES |  |  |
| 31 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 32 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 33 | `IIA_Ref_no` | character varying(50) | YES |  |  |
| 34 | `prefix_name` | character varying(50) | YES |  |  |
| 35 | `first_name` | character varying(255) | YES |  |  |
| 36 | `last_name` | character varying(255) | YES |  |  |
| 37 | `birth_date` | date | YES |  |  |
| 38 | `citizen_id` | character varying(13) | YES |  |  |
| 39 | `province_id` | integer | YES |  |  |
| 40 | `subdistrict_id` | integer | YES |  |  |
| 41 | `district_id` | integer | YES |  |  |
| 42 | `zipcode` | character varying(45) | YES |  |  |
| 43 | `countryid` | integer | YES |  |  |
| 44 | `phone` | character varying(45) | YES |  |  |
| 45 | `IsKYC` | character varying(50) | YES |  |  |
| 46 | `KYC_id` | character varying(50) | YES |  |  |
| 47 | `KYC_date` | timestamp(6) without time zone | YES |  |  |
| 48 | `Occupation` | character varying(255) | YES |  |  |
| 49 | `Remark` | character varying(255) | YES |  |  |
| 50 | `Car_Comp_Code` | character varying(50) | YES |  |  |
| 51 | `Premium` | numeric | YES |  |  |
| 52 | `Discount` | numeric | YES |  |  |
| 53 | `Net_Premium` | numeric | YES |  |  |
| 54 | `Stamp` | numeric | YES |  |  |
| 55 | `Vat` | numeric | YES |  |  |
| 56 | `Total` | numeric | YES |  |  |
| 57 | `CC` | character varying(255) | YES |  |  |
| 58 | `Car_license_no` | character varying(50) | YES |  |  |
| 59 | `Car_license_provice` | character varying(50) | YES |  |  |
| 60 | `Car_serial_no` | character varying(50) | YES |  |  |
| 61 | `Effective_Startdate` | timestamp(6) without time zone | YES |  |  |
| 62 | `Effective_Enddate` | timestamp(6) without time zone | YES |  |  |
| 63 | `cmi_reference_number` | character varying(50) | YES |  |  |
| 64 | `cmi_receive_number` | character varying(50) | YES |  |  |
| 65 | `cmi_endorse_ref_number` | character varying(50) | YES |  |  |
| 66 | `cmi_endorse_receive_number` | character varying(50) | YES |  |  |
| 67 | `cmi_update_date` | timestamp(6) without time zone | YES |  |  |
| 68 | `Comp_Code` | character varying(255) | YES |  |  |
| 69 | `Policy_book` | character varying(50) | YES |  |  |
| 70 | `Deli_Addr_line1` | character varying(255) | YES |  |  |
| 71 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 72 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 73 | `Deli_province_id` | integer | YES |  |  |
| 74 | `Deli_subdistrict_id` | integer | YES |  |  |
| 75 | `Deli_district_id` | integer | YES |  |  |
| 76 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 77 | `Deli_countryid` | integer | YES |  |  |
| 78 | `Car_license_type` | character varying(50) | YES |  |  |
| 79 | `Policy_Ref_no` | character varying(50) | YES |  |  |
| 80 | `Policy_QR_code` | character varying(255) | YES |  |  |
| 81 | `Car_color` | character varying(255) | YES |  |  |
| 82 | `Lead_No` | integer | YES |  |  |
| 83 | `Policy_url_ref` | character varying(500) | YES |  |  |
| 84 | `Policy_Barcode` | character varying(50) | YES |  |  |
| 85 | `Policy_url_copy_ref` | character varying(500) | YES |  |  |
| 86 | `address` | character varying(255) | YES |  |  |
| 87 | `email` | character varying(255) | YES |  |  |
| 88 | `Bene_Type` | character varying(50) | YES |  |  |
| 89 | `Bene_Title` | character varying(50) | YES |  |  |
| 90 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 91 | `Bene_Midname` | character varying(255) | YES |  |  |
| 92 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 93 | `Bene_ID_card` | character varying(50) | YES |  |  |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  |  |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  |  |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  |  |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  |  |
| 98 | `Payment_date` | timestamp(6) without time zone | YES |  |  |
| 99 | `IIA_Lot_No` | character varying(20) | YES |  |  |
| 100 | `Flag_Deli` | character(1) | YES |  |  |
| 101 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 102 | `Car_Act_Lead_No` | bigint | YES |  |  |
| 103 | `Policy_Status` | character varying(50) | YES |  |  |
| 104 | `Appr_prefix_name` | character varying(50) | YES |  |  |
| 105 | `Appr_first_name` | character varying(255) | YES |  |  |
| 106 | `Appr_last_name` | character varying(255) | YES |  |  |
| 107 | `cmi_status` | character varying(255) | YES |  |  |
| 108 | `Change_Perm_Amt` | numeric | YES |  |  |
| 109 | `Change_Duty_Amt` | numeric | YES |  |  |
| 110 | `Change_Vat_Amt` | numeric | YES |  |  |
| 111 | `Change_Total_Amt` | numeric | YES |  |  |
| 112 | `par_id` | integer | YES |  |  |
| 113 | `promo_trans_id` | bigint | YES |  |  |
| 114 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 115 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 116 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 117 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 118 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 119 | `Extend_Start` | timestamp(6) without time zone | YES |  |  |
| 120 | `Extend_End` | timestamp(6) without time zone | YES |  |  |
| 121 | `extend_amt` | numeric(16,4) | YES |  |  |
| 122 | `mas_premium` | numeric | YES |  |  |
| 123 | `mas_discount` | numeric | YES |  |  |
| 124 | `mas_net_premium` | numeric | YES |  |  |
| 125 | `mas_stamp` | numeric | YES |  |  |
| 126 | `mas_vat` | numeric | YES |  |  |
| 127 | `mas_total` | numeric | YES |  |  |
| 128 | `ref_policy_no` | character varying(50) | YES |  |  |
| 129 | `partner_code` | character varying(10) | YES |  |  |
| 130 | `occupation_code` | character varying(50) | YES |  |  |
| 131 | `oic_version` | character varying(20) | YES |  |  |
| 132 | `customer_id` | character varying(100) | YES |  |  |

**Primary key:** _none_

---

## Policy_Header

`insurverse.Policy_Header` · kind: table · est. rows: **140**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | NO |  |  |
| 2 | `Policy_Startdate` | timestamp without time zone | YES |  | รย 19 วันเริ่มต้นคุ้มครอง กรณีล่วงหน้าเวลาเป็น 00:01 Fix |
| 3 | `Policy_Enddate` | timestamp without time zone | YES |  | รย 19 วันสิ้นสุดคุ้มครอง เวลาต้องเป็น 16:30 Fix |
| 4 | `Policy_Status` | character varying(50) | YES |  | ACT, INC รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง // ประกันชั้น 2+3+ รยภ 00 ยกเลิก |
| 5 | `Policy_Quatation_No` | character varying(50) | YES |  | Ref. ใบเสนอราคา |
| 6 | `Policy_Invoice_No` | character varying(50) | YES |  | Ref. ใบเสร็จ |
| 7 | `Car_Act_No` | character varying(50) | YES |  | Ref. พรบ. |
| 8 | `IIA_Ref_no` | character varying(50) | YES |  | Ref. IIA |
| 9 | `Policy_ETax_No` | character varying(50) | YES |  | Ref. e-Tax  |
| 10 | `Par_code` | character varying(50) | YES |  | รหัส mas_participant |
| 11 | `Payment_Status` | character varying(50) | YES |  | ชำระการจ่ายเงิน Ref. Res จาก 2C2P |
| 12 | `Create_date` | timestamp without time zone | YES |  |  |
| 13 | `Create_by` | character varying(50) | YES |  |  |
| 14 | `Update_date` | timestamp without time zone | YES |  |  |
| 15 | `Update_by` | character varying(50) | YES |  |  |
| 16 | `Car_Inspect_code` | character varying(50) | YES |  | Ref. Car Inspect ภายนอก |
| 17 | `Car_Inspect_Status` | character varying(50) | YES |  | Car Inspect สถานะตรวจสอบ ถ้าครบ 'success' , ถ้าไม่ครบ 'process' |
| 18 | `Car_Inspect_Result` | character varying(50) | YES |  | Car Inspect ภายนอก ผลการตรวจสอบ  |
| 19 | `Car_inspect_date` | timestamp without time zone | YES |  | Car Inspect ภายนอก วันที่ตรวจสอบ  |
| 20 | `SF_Policy_id` | character varying(255) | YES |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 21 | `Deli_Addr_line1` | character varying(255) | YES |  | ที่อยู่จัดส่ง |
| 22 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 23 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 24 | `Deli_province_id` | integer | YES |  |  |
| 25 | `Deli_subdistrict_id` | integer | YES |  |  |
| 26 | `Deli_district_id` | integer | YES |  |  |
| 27 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 28 | `Deli_countryid` | integer | YES |  |  |
| 29 | `phone` | character varying(50) | YES |  |  |
| 30 | `email` | character varying(255) | YES |  |  |
| 31 | `Brand` | character varying(255) | YES |  |  |
| 32 | `Model` | character varying(255) | YES |  |  |
| 33 | `Year` | character varying(255) | YES |  | กรณีไม่กระทบเบี้ย รย 17 / กระทบเบี้ย รย 17 18 20 |
| 34 | `Doors` | smallint | YES |  |  |
| 35 | `Seat` | smallint | YES |  |  |
| 36 | `Wg` | integer | YES |  |  |
| 37 | `Group` | character varying(255) | YES |  |  |
| 38 | `Usage` | smallint | YES |  |  |
| 39 | `Type` | character varying(50) | YES |  | กรณีประกัน 2+ 3+ สลักหลังทุกชนิดออก รยภ 01 |
| 40 | `BodyType` | character varying(255) | YES |  |  |
| 41 | `GarageType` | character varying(2) | YES |  |  |
| 42 | `NamedAge` | character varying(255) | YES |  |  |
| 43 | `CC` | character varying(255) | YES |  |  |
| 44 | `Car_license_no` | character varying(50) | YES |  | รย 17 ป้ายเลขทะเบียน |
| 45 | `Car_license_provice` | integer | YES |  | รย 17 จังหวัด ที่จด |
| 46 | `Car_serial_no` | character varying(50) | YES |  | รย 17 ตัวถังรถ |
| 47 | `Bene_Type` | character varying(50) | YES |  | รย 24 ไฟแนนซ์ บุคคล |
| 48 | `Bene_Title` | character varying(50) | YES |  | ที่อยู่ผู้รับผลประโยชน์ |
| 49 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 50 | `Bene_Midname` | character varying(255) | YES |  |  |
| 51 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 52 | `Bene_ID_card` | character varying(50) | YES |  | หมายเลขเอกสารผู้รับผลประโยชน์ |
| 53 | `Extend_Start` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองเริ่มต้น |
| 54 | `Extend_End` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองสิ้นสุด |
| 55 | `Car_license_type` | character varying(50) | YES |  | [Policy]-[Car_license_type] ป้ายแดง จดทะเบียน |
| 56 | `Policy_Ref_no` | character varying(50) | YES |  | Ref. อ้างอิง |
| 57 | `Policy_QR_code` | character varying(255) | YES |  | วันคุ้มครองกรมธรรม์ + ตัวเลขตัวถัง |
| 58 | `Car_color` | character varying(255) | YES |  | สีรถ |
| 59 | `Lead_No` | character varying(50) | YES |  |  |
| 60 | `Effective_Startdate` | timestamp without time zone | NO |  | Policy เริ่มใช้ตามเงื่อนไขใหม่ (Version Control) |
| 61 | `Effective_Enddate` | timestamp without time zone | YES |  | Policy สิ้นสุดการใช้ตามเงื่อนไข |
| 62 | `Flag_Deli` | character(1) | YES |  | y = จัดส่งรูปเล่มกรมธรรม์, n = ไม่จัดส่งรูปเล่มกรมธรรม์ |
| 63 | `Comp_Code` | character varying(50) | YES |  | ชื่อย่อบริษัท ISV (Default) |
| 64 | `Policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 65 | `id` | bigint | NO |  |  |
| 66 | `Policy_Barcode` | character varying(50) | YES |  | ISV Barcode บนกรมธรรม์ |
| 67 | `Policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 68 | `Par_first_name_1` | character varying(255) | YES |  | ข้อมูลขนขับ คนที่  1 |
| 69 | `Par_last_name_1` | character varying(255) | YES |  |  |
| 70 | `Par_birth_date_1` | date | YES |  |  |
| 71 | `Par_occupation_1` | character varying(255) | YES |  |  |
| 72 | `Par_first_name_2` | character varying(255) | YES |  | ข้อมูลคนขับ คนที่ 2 |
| 73 | `Par_last_name_2` | character varying(255) | YES |  |  |
| 74 | `Par_birth_date_2` | date | YES |  |  |
| 75 | `Par_occupation_2` | character varying(255) | YES |  |  |
| 76 | `Owner_first_name` | character varying(255) | YES |  | ผู้เอา กรมธรรม์ |
| 77 | `Owner_last_name` | character varying(255) | YES |  |  |
| 78 | `Owner_birth_date` | date | YES |  |  |
| 79 | `Par_prefix_name_1` | character varying(50) | YES |  |  |
| 80 | `Par_prefix_name_2` | character varying(50) | YES |  |  |
| 81 | `Owner_prefix_name` | character varying(50) | YES |  |  |
| 82 | `Owner_address` | character varying(500) | YES |  |  |
| 83 | `Owner_province_id` | integer | YES |  |  |
| 84 | `Owner_subdistrict_id` | integer | YES |  |  |
| 85 | `Owner_district_id` | integer | YES |  |  |
| 86 | `Owner_zipcode` | character varying(45) | YES |  |  |
| 87 | `Owner_countryid` | integer | YES |  |  |
| 88 | `Owner_phone` | character varying(45) | YES |  |  |
| 89 | `Owner_occupation` | character varying(255) | YES |  |  |
| 90 | `Owner_citizen_id` | character varying(20) | YES |  | ผู้เอากรมธรรม์รหัสบัตรประชาชน |
| 91 | `Policy_book` | character varying(50) | YES |  | เล่มที่กรมธรรม์ |
| 92 | `Par_Driver_license_no_1` | character varying(20) | YES |  | รย 28 ผู้ขับขี่ 1 เลขที่ใบขับขี่ |
| 93 | `Par_Driver_license_no_2` | character varying(20) | YES |  | รย 28 ผู้ขับขี่ 2 เลขที่ใบขับขี่ |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 98 | `SF_Endorse_type` | character varying(50) | YES |  | SF อ้างอิงประเภทสลักหลัง  |
| 99 | `Par_citizen_id_1` | character varying(20) | YES |  | บัตรประชาชน ขับขี่คนที่ 1 |
| 100 | `Par_citizen_id_2` | character varying(20) | YES |  | บัตรประชาชน ขับขี่คนที่ 2 |
| 101 | `IIA_Lot_No` | character varying(20) | YES |  | IIA Lot no. |
| 102 | `Appr_prefix_name` | character varying(50) | YES |  | คำนำหน้าผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 103 | `Appr_first_name` | character varying(255) | YES |  | ชื่อผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 104 | `Appr_last_name` | character varying(255) | YES |  | นามสกุลผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 105 | `par_id` | integer | YES |  |  |
| 106 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 107 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 108 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 109 | `ref_policy_no` | character varying(50) | YES |  | อ้างอิงเลขกรมธรรม์เดิมสำหรับต่อกรมธรรม์ |
| 110 | `partner_code` | character varying(10) | YES |  | รหัส partner |
| 111 | `cc_ans` | character varying(20) | YES |  | ขนาดรถยนต์ที่เลือก |
| 112 | `par_prefix_name_3` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 3 |
| 113 | `par_first_name_3` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 3 |
| 114 | `par_last_name_3` | character varying(255) | YES |  | นามสกลุ ผู้ขับขี่ 3 |
| 115 | `par_birth_date_3` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 3 |
| 116 | `par_citizen_id_3` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 3 |
| 117 | `par_driver_license_no_3` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 3 |
| 118 | `par_occupation_3` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 3 |
| 119 | `par_prefix_name_4` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 4 |
| 120 | `par_first_name_4` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 4 |
| 121 | `par_last_name_4` | character varying(255) | YES |  | นามสกลุ ผู้ขับขี่ 4 |
| 122 | `par_birth_date_4` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 4 |
| 123 | `par_citizen_id_4` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 4 |
| 124 | `par_driver_license_no_4` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 4 |
| 125 | `par_occupation_4` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 4 |
| 126 | `par_prefix_name_5` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 5 |
| 127 | `par_first_name_5` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 5 |
| 128 | `par_last_name_5` | character varying(255) | YES |  | นามสกลุ ผู้ขับขี่ 5 |
| 129 | `par_birth_date_5` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 5 |
| 130 | `par_citizen_id_5` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 5 |
| 131 | `par_driver_license_no_5` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 5 |
| 132 | `par_occupation_5` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 5 |
| 133 | `driver_behavior_1` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 1 |
| 134 | `driver_behavior_2` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 2 |
| 135 | `driver_behavior_3` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 3 |
| 136 | `driver_behavior_4` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 4 |
| 137 | `driver_behavior_5` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 5 |
| 138 | `driver_behavior_cal` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ ที่นำมาใช้ |
| 139 | `driver_behavior_disc_perc` | real | YES |  | ส่วนลดผู้ขับขี่ (percent) |
| 140 | `driver_behavior_disc_amt` | numeric | YES |  | ส่วนลดผู้ขับขี่ (baht) |
| 141 | `car_price` | numeric | YES |  | ราคารถยนต์ ณ วันที่ทำประกัน |
| 142 | `car_price_date` | date | YES |  | วันที่ของราคารถยนต์ ณ วันที่ทำประกัน |
| 143 | `sc_premium_amt` | numeric | YES |  | เบี้ยซ่อมห้าง (baht) |
| 144 | `prem_version` | smallint | YES |  | เวอร์ชั่นของ master price premium |
| 145 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 146 | `driver_behavior_consent_1` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 1 |
| 147 | `driver_behavior_consent_2` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 2 |
| 148 | `driver_behavior_consent_3` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 3 |
| 149 | `driver_behavior_consent_4` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 4 |
| 150 | `driver_behavior_consent_5` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 5 |
| 151 | `bene_occupation` | character varying(255) | YES |  | อาชีพผู้รับผลประโยชน์ |
| 152 | `par_occupation_code_1` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 1 |
| 153 | `par_occupation_code_2` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 2 |
| 154 | `par_occupation_code_3` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 3 |
| 155 | `par_occupation_code_4` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 4 |
| 156 | `par_occupation_code_5` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 5 |
| 157 | `bene_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้รับผลประโยชน์ |
| 158 | `par_driver_license_category_1` | character varying(20) | YES |  |  |
| 159 | `par_driver_license_category_2` | character varying(20) | YES |  |  |
| 160 | `par_driver_license_category_3` | character varying(20) | YES |  |  |
| 161 | `par_driver_license_category_4` | character varying(20) | YES |  |  |
| 162 | `par_driver_license_category_5` | character varying(20) | YES |  |  |

**Primary key:** `Policy_No` (Policy_Header_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Car_Act_No` → Policy_Car_Act_Discount_Premium, `Comp_Code` → company_detail, `Deli_countryid` → mas_country, `Deli_district_id` → district, `Deli_province_id` → province, `Deli_subdistrict_id` → subdistrict, `Lead_No` → Lead_coverage_premium, `Owner_countryid` → mas_country, `Owner_district_id` → district, `Owner_province_id` → province, `Owner_subdistrict_id` → subdistrict, `par_id` → policy_participant, `partner_code` → mas_partner

**Indexes:**

- `Policy_Header_copy1_pkey`: `CREATE UNIQUE INDEX "Policy_Header_copy1_pkey" ON insurverse."Policy_Header" USING btree ("Policy_No")`
- `idx_ph_greatest_enddate_dt`: `CREATE INDEX idx_ph_greatest_enddate_dt ON insurverse."Policy_Header" USING btree (((GREATEST("Policy_Enddate", "Extend_End"))::date)) WHERE (("Policy_Status")::text = 'ACT'::text)`
- `idx_policy_header_policy_no`: `CREATE INDEX idx_policy_header_policy_no ON insurverse."Policy_Header" USING btree ("Policy_No")`
- `idx_policy_header_ref_policy_no`: `CREATE INDEX idx_policy_header_ref_policy_no ON insurverse."Policy_Header" USING btree (ref_policy_no)`

**Triggers:** `trg_sync_pcad_from_ph` → `insurverse.trg_fn_sync_pcad_from_ph()`

---

## Policy_Header_20260810

`insurverse.Policy_Header_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | YES |  |  |
| 2 | `Policy_Startdate` | timestamp(6) without time zone | YES |  |  |
| 3 | `Policy_Enddate` | timestamp(6) without time zone | YES |  |  |
| 4 | `Policy_Status` | character varying(50) | YES |  |  |
| 5 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 6 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 7 | `Car_Act_No` | character varying(50) | YES |  |  |
| 8 | `IIA_Ref_no` | character varying(50) | YES |  |  |
| 9 | `Policy_ETax_No` | character varying(50) | YES |  |  |
| 10 | `Par_code` | character varying(50) | YES |  |  |
| 11 | `Payment_Status` | character varying(50) | YES |  |  |
| 12 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 13 | `Create_by` | character varying(50) | YES |  |  |
| 14 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 15 | `Update_by` | character varying(50) | YES |  |  |
| 16 | `Car_Inspect_code` | character varying(50) | YES |  |  |
| 17 | `Car_Inspect_Status` | character varying(50) | YES |  |  |
| 18 | `Car_Inspect_Result` | character varying(50) | YES |  |  |
| 19 | `Car_inspect_date` | timestamp(6) without time zone | YES |  |  |
| 20 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 21 | `Deli_Addr_line1` | character varying(255) | YES |  |  |
| 22 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 23 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 24 | `Deli_province_id` | integer | YES |  |  |
| 25 | `Deli_subdistrict_id` | integer | YES |  |  |
| 26 | `Deli_district_id` | integer | YES |  |  |
| 27 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 28 | `Deli_countryid` | integer | YES |  |  |
| 29 | `phone` | character varying(50) | YES |  |  |
| 30 | `email` | character varying(255) | YES |  |  |
| 31 | `Brand` | character varying(255) | YES |  |  |
| 32 | `Model` | character varying(255) | YES |  |  |
| 33 | `Year` | character varying(255) | YES |  |  |
| 34 | `Doors` | smallint | YES |  |  |
| 35 | `Seat` | smallint | YES |  |  |
| 36 | `Wg` | integer | YES |  |  |
| 37 | `Group` | character varying(255) | YES |  |  |
| 38 | `Usage` | smallint | YES |  |  |
| 39 | `Type` | character varying(50) | YES |  |  |
| 40 | `BodyType` | character varying(255) | YES |  |  |
| 41 | `GarageType` | character varying(2) | YES |  |  |
| 42 | `NamedAge` | character varying(255) | YES |  |  |
| 43 | `CC` | character varying(255) | YES |  |  |
| 44 | `Car_license_no` | character varying(50) | YES |  |  |
| 45 | `Car_license_provice` | integer | YES |  |  |
| 46 | `Car_serial_no` | character varying(50) | YES |  |  |
| 47 | `Bene_Type` | character varying(50) | YES |  |  |
| 48 | `Bene_Title` | character varying(50) | YES |  |  |
| 49 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 50 | `Bene_Midname` | character varying(255) | YES |  |  |
| 51 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 52 | `Bene_ID_card` | character varying(50) | YES |  |  |
| 53 | `Extend_Start` | timestamp(6) without time zone | YES |  |  |
| 54 | `Extend_End` | timestamp(6) without time zone | YES |  |  |
| 55 | `Car_license_type` | character varying(50) | YES |  |  |
| 56 | `Policy_Ref_no` | character varying(50) | YES |  |  |
| 57 | `Policy_QR_code` | character varying(255) | YES |  |  |
| 58 | `Car_color` | character varying(255) | YES |  |  |
| 59 | `Lead_No` | character varying(50) | YES |  |  |
| 60 | `Effective_Startdate` | timestamp(0) without time zone | YES |  |  |
| 61 | `Effective_Enddate` | timestamp(0) without time zone | YES |  |  |
| 62 | `Flag_Deli` | character(1) | YES |  |  |
| 63 | `Comp_Code` | character varying(50) | YES |  |  |
| 64 | `Policy_url_ref` | character varying(500) | YES |  |  |
| 65 | `id` | bigint | YES |  |  |
| 66 | `Policy_Barcode` | character varying(50) | YES |  |  |
| 67 | `Policy_url_copy_ref` | character varying(500) | YES |  |  |
| 68 | `Par_first_name_1` | character varying(255) | YES |  |  |
| 69 | `Par_last_name_1` | character varying(255) | YES |  |  |
| 70 | `Par_birth_date_1` | date | YES |  |  |
| 71 | `Par_occupation_1` | character varying(255) | YES |  |  |
| 72 | `Par_first_name_2` | character varying(255) | YES |  |  |
| 73 | `Par_last_name_2` | character varying(255) | YES |  |  |
| 74 | `Par_birth_date_2` | date | YES |  |  |
| 75 | `Par_occupation_2` | character varying(255) | YES |  |  |
| 76 | `Owner_first_name` | character varying(255) | YES |  |  |
| 77 | `Owner_last_name` | character varying(255) | YES |  |  |
| 78 | `Owner_birth_date` | date | YES |  |  |
| 79 | `Par_prefix_name_1` | character varying(50) | YES |  |  |
| 80 | `Par_prefix_name_2` | character varying(50) | YES |  |  |
| 81 | `Owner_prefix_name` | character varying(50) | YES |  |  |
| 82 | `Owner_address` | character varying(500) | YES |  |  |
| 83 | `Owner_province_id` | integer | YES |  |  |
| 84 | `Owner_subdistrict_id` | integer | YES |  |  |
| 85 | `Owner_district_id` | integer | YES |  |  |
| 86 | `Owner_zipcode` | character varying(45) | YES |  |  |
| 87 | `Owner_countryid` | integer | YES |  |  |
| 88 | `Owner_phone` | character varying(45) | YES |  |  |
| 89 | `Owner_occupation` | character varying(255) | YES |  |  |
| 90 | `Owner_citizen_id` | character varying(20) | YES |  |  |
| 91 | `Policy_book` | character varying(50) | YES |  |  |
| 92 | `Par_Driver_license_no_1` | character varying(20) | YES |  |  |
| 93 | `Par_Driver_license_no_2` | character varying(20) | YES |  |  |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  |  |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  |  |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  |  |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  |  |
| 98 | `SF_Endorse_type` | character varying(50) | YES |  |  |
| 99 | `Par_citizen_id_1` | character varying(20) | YES |  |  |
| 100 | `Par_citizen_id_2` | character varying(20) | YES |  |  |
| 101 | `IIA_Lot_No` | character varying(20) | YES |  |  |
| 102 | `Appr_prefix_name` | character varying(50) | YES |  |  |
| 103 | `Appr_first_name` | character varying(255) | YES |  |  |
| 104 | `Appr_last_name` | character varying(255) | YES |  |  |
| 105 | `par_id` | integer | YES |  |  |
| 106 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 107 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 108 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 109 | `ref_policy_no` | character varying(50) | YES |  |  |
| 110 | `partner_code` | character varying(10) | YES |  |  |
| 111 | `cc_ans` | character varying(20) | YES |  |  |
| 112 | `par_prefix_name_3` | character varying(50) | YES |  |  |
| 113 | `par_first_name_3` | character varying(255) | YES |  |  |
| 114 | `par_last_name_3` | character varying(255) | YES |  |  |
| 115 | `par_birth_date_3` | date | YES |  |  |
| 116 | `par_citizen_id_3` | character varying(20) | YES |  |  |
| 117 | `par_driver_license_no_3` | character varying(20) | YES |  |  |
| 118 | `par_occupation_3` | character varying(255) | YES |  |  |
| 119 | `par_prefix_name_4` | character varying(50) | YES |  |  |
| 120 | `par_first_name_4` | character varying(255) | YES |  |  |
| 121 | `par_last_name_4` | character varying(255) | YES |  |  |
| 122 | `par_birth_date_4` | date | YES |  |  |
| 123 | `par_citizen_id_4` | character varying(20) | YES |  |  |
| 124 | `par_driver_license_no_4` | character varying(20) | YES |  |  |
| 125 | `par_occupation_4` | character varying(255) | YES |  |  |
| 126 | `par_prefix_name_5` | character varying(50) | YES |  |  |
| 127 | `par_first_name_5` | character varying(255) | YES |  |  |
| 128 | `par_last_name_5` | character varying(255) | YES |  |  |
| 129 | `par_birth_date_5` | date | YES |  |  |
| 130 | `par_citizen_id_5` | character varying(20) | YES |  |  |
| 131 | `par_driver_license_no_5` | character varying(20) | YES |  |  |
| 132 | `par_occupation_5` | character varying(255) | YES |  |  |
| 133 | `driver_behavior_1` | integer | YES |  |  |
| 134 | `driver_behavior_2` | integer | YES |  |  |
| 135 | `driver_behavior_3` | integer | YES |  |  |
| 136 | `driver_behavior_4` | integer | YES |  |  |
| 137 | `driver_behavior_5` | integer | YES |  |  |
| 138 | `driver_behavior_cal` | integer | YES |  |  |
| 139 | `driver_behavior_disc_perc` | real | YES |  |  |
| 140 | `driver_behavior_disc_amt` | numeric | YES |  |  |
| 141 | `car_price` | numeric | YES |  |  |
| 142 | `car_price_date` | date | YES |  |  |
| 143 | `sc_premium_amt` | numeric | YES |  |  |
| 144 | `prem_version` | smallint | YES |  |  |
| 145 | `oic_version` | character varying(20) | YES |  |  |
| 146 | `driver_behavior_consent_1` | boolean | YES |  |  |
| 147 | `driver_behavior_consent_2` | boolean | YES |  |  |
| 148 | `driver_behavior_consent_3` | boolean | YES |  |  |
| 149 | `driver_behavior_consent_4` | boolean | YES |  |  |
| 150 | `driver_behavior_consent_5` | boolean | YES |  |  |
| 151 | `bene_occupation` | character varying(255) | YES |  |  |
| 152 | `par_occupation_code_1` | character varying(50) | YES |  |  |
| 153 | `par_occupation_code_2` | character varying(50) | YES |  |  |
| 154 | `par_occupation_code_3` | character varying(50) | YES |  |  |
| 155 | `par_occupation_code_4` | character varying(50) | YES |  |  |
| 156 | `par_occupation_code_5` | character varying(50) | YES |  |  |
| 157 | `bene_occupation_code` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## Policy_Header_Trans

`insurverse.Policy_Header_Trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | NO |  |  |
| 2 | `Policy_Startdate` | timestamp without time zone | YES |  | รย 19 วันเริ่มต้นคุ้มครอง กรณีล่วงหน้าเวลาเป็น 00:01 Fix |
| 3 | `Policy_Enddate` | timestamp without time zone | YES |  | รย 19 วันสิ้นสุดคุ้มครอง เวลาต้องเป็น 16:30 Fix |
| 4 | `Policy_Status` | character varying(50) | YES |  | ACT, INC รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง // ประกันชั้น 2+3+ รยภ 00 ยกเลิก |
| 5 | `Policy_Quatation_No` | character varying(50) | YES |  | Ref. ใบเสนอราคา |
| 6 | `Policy_Invoice_No` | character varying(50) | YES |  | Ref. ใบเสร็จ |
| 7 | `Car_Act_No` | character varying(50) | YES |  | Ref. พรบ. |
| 8 | `IIA_Ref_no` | character varying(50) | YES |  | Ref. IIA |
| 9 | `Policy_ETax_No` | character varying(50) | YES |  | Ref. e-Tax  |
| 10 | `Par_code` | character varying(50) | YES |  | รหัส mas_participant |
| 11 | `Payment_Status` | character varying(50) | YES |  | ชำระการจ่ายเงิน Ref. Res จาก 2C2P |
| 12 | `Create_date` | timestamp without time zone | NO |  |  |
| 13 | `Create_by` | character varying(50) | YES |  |  |
| 14 | `Update_date` | timestamp without time zone | YES |  |  |
| 15 | `Update_by` | character varying(50) | YES |  |  |
| 16 | `Car_Inspect_code` | character varying(50) | YES |  | Ref. Car Inspect ภายนอก |
| 17 | `Car_Inspect_Status` | character varying(50) | YES |  | Car Inspect สถานะตรวจสอบ ถ้าครบ 'success' , ถ้าไม่ครบ 'process' |
| 18 | `Car_Inspect_Result` | character varying(50) | YES |  | Car Inspect ภายนอก ผลการตรวจสอบ  |
| 19 | `Car_inspect_date` | timestamp without time zone | YES |  | Car Inspect ภายนอก วันที่ตรวจสอบ  |
| 20 | `SF_Policy_id` | character varying(255) | YES |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 21 | `Deli_Addr_line1` | character varying(255) | YES |  | ที่อยู่จัดส่ง |
| 22 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 23 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 24 | `Deli_province_id` | integer | YES |  |  |
| 25 | `Deli_subdistrict_id` | integer | YES |  |  |
| 26 | `Deli_district_id` | integer | YES |  |  |
| 27 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 28 | `Deli_countryid` | integer | YES |  |  |
| 29 | `phone` | character varying(50) | YES |  |  |
| 30 | `email` | character varying(255) | YES |  |  |
| 31 | `Brand` | character varying(255) | YES |  |  |
| 32 | `Model` | character varying(255) | YES |  |  |
| 33 | `Year` | character varying(255) | YES |  | กรณีไม่กระทบเบี้ย รย 17 / กระทบเบี้ย รย 17 18 20 |
| 34 | `Doors` | smallint | YES |  |  |
| 35 | `Seat` | smallint | YES |  |  |
| 36 | `Wg` | integer | YES |  |  |
| 37 | `Group` | character varying(255) | YES |  |  |
| 38 | `Usage` | smallint | YES |  |  |
| 39 | `Type` | character varying(50) | YES |  | กรณีประกัน 2+ 3+ สลักหลังทุกชนิดออก รยภ 01 |
| 40 | `BodyType` | character varying(255) | YES |  |  |
| 41 | `GarageType` | character varying(2) | YES |  |  |
| 42 | `NamedAge` | character varying(255) | YES |  |  |
| 43 | `CC` | character varying(255) | YES |  |  |
| 44 | `Car_license_no` | character varying(50) | YES |  | รย 17 ป้ายเลขทะเบียน |
| 45 | `Car_license_provice` | integer | YES |  | รย 17 จังหวัด ที่จด |
| 46 | `Car_serial_no` | character varying(50) | YES |  | รย 17 ตัวถังรถ |
| 47 | `Bene_Type` | character varying(50) | YES |  | รย 24 ไฟแนนซ์ บุคคล |
| 48 | `Bene_Title` | character varying(50) | YES |  | ที่อยู่ผู้รับผลประโยชน์ |
| 49 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 50 | `Bene_Midname` | character varying(255) | YES |  |  |
| 51 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 52 | `Bene_ID_card` | character varying(50) | YES |  | หมายเลขเอกสารผู้รับผลประโยชน์ |
| 53 | `Extend_Start` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองเริ่มต้น |
| 54 | `Extend_End` | timestamp without time zone | YES |  | รย 05 ขยายระเวลาคุ้มครองสิ้นสุด |
| 55 | `Car_license_type` | character varying(50) | YES |  | [Policy]-[Car_license_type] ป้ายแดง จดทะเบียน |
| 56 | `Policy_Ref_no` | character varying(50) | YES |  | Ref. อ้างอิง |
| 57 | `Policy_QR_code` | character varying(255) | YES |  | วันคุ้มครองกรมธรรม์ + ตัวเลขตัวถัง |
| 58 | `Car_color` | character varying(255) | YES |  | สีรถ |
| 59 | `Lead_No` | character varying(50) | YES |  |  |
| 60 | `Effective_Startdate` | timestamp without time zone | NO |  | Policy เริ่มใช้ตามเงื่อนไขใหม่ (Version Control) |
| 61 | `Effective_Enddate` | timestamp without time zone | YES |  | Policy สิ้นสุดการใช้ตามเงื่อนไข |
| 62 | `Flag_Deli` | character(1) | YES |  | y = จัดส่งรูปเล่มกรมธรรม์, n = ไม่จัดส่งรูปเล่มกรมธรรม์ |
| 63 | `Comp_Code` | character varying(50) | YES |  | ชื่อย่อบริษัท ISV (Default) |
| 64 | `Policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 65 | `id` | bigint | YES |  |  |
| 66 | `Policy_Barcode` | character varying(50) | YES |  | ISV Barcode บนกรมธรรม์ |
| 67 | `Policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 68 | `Par_first_name_1` | character varying(255) | YES |  | ข้อมูลขนขับ คนที่  1 |
| 69 | `Par_last_name_1` | character varying(255) | YES |  |  |
| 70 | `Par_birth_date_1` | date | YES |  |  |
| 71 | `Par_occupation_1` | character varying(255) | YES |  |  |
| 72 | `Par_first_name_2` | character varying(255) | YES |  | ข้อมูลคนขับ คนที่ 2 |
| 73 | `Par_last_name_2` | character varying(255) | YES |  |  |
| 74 | `Par_birth_date_2` | date | YES |  |  |
| 75 | `Par_occupation_2` | character varying(255) | YES |  |  |
| 76 | `Owner_first_name` | character varying(255) | YES |  | ผู้เอา กรมธรรม์ |
| 77 | `Owner_last_name` | character varying(255) | YES |  |  |
| 78 | `Owner_birth_date` | date | YES |  |  |
| 79 | `Par_prefix_name_1` | character varying(50) | YES |  |  |
| 80 | `Par_prefix_name_2` | character varying(50) | YES |  |  |
| 81 | `Owner_prefix_name` | character varying(50) | YES |  |  |
| 82 | `Owner_address` | character varying(500) | YES |  |  |
| 83 | `Owner_province_id` | integer | YES |  |  |
| 84 | `Owner_subdistrict_id` | integer | YES |  |  |
| 85 | `Owner_district_id` | integer | YES |  |  |
| 86 | `Owner_zipcode` | character varying(45) | YES |  |  |
| 87 | `Owner_countryid` | integer | YES |  |  |
| 88 | `Owner_phone` | character varying(45) | YES |  |  |
| 89 | `Owner_occupation` | character varying(255) | YES |  |  |
| 90 | `Owner_citizen_id` | character varying(20) | YES |  | ผู้เอากรมธรรม์รหัสบัตรประชาชน |
| 91 | `Policy_book` | character varying(50) | YES |  | เล่มที่กรมธรรม์ |
| 92 | `Par_Driver_license_no_1` | character varying(20) | YES |  | รย 28 ผู้ขับขี่ 1 เลขที่ใบขับขี่ |
| 93 | `Par_Driver_license_no_2` | character varying(20) | YES |  | รย 28 ผู้ขับขี่ 2 เลขที่ใบขับขี่ |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 98 | `SF_Endorse_type` | character varying(50) | YES |  | SF อ้างอิงประเภทสลักหลัง  |
| 99 | `Par_citizen_id_1` | character varying(20) | YES |  | บัตรประชาชน ขับขี่คนที่ 1 |
| 100 | `Par_citizen_id_2` | character varying(20) | YES |  | บัตรประชาชน ขับขี่คนที่ 2 |
| 101 | `IIA_Lot_No` | character varying(20) | YES |  | IIA Lot no. |
| 102 | `Appr_prefix_name` | character varying(50) | YES |  | คำนำหน้าผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 103 | `Appr_first_name` | character varying(255) | YES |  | ชื่อผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 104 | `Appr_last_name` | character varying(255) | YES |  | นามสกุลผู้อนุมัติกรณีสลักหลังหรืออื่นๆ |
| 105 | `par_id` | integer | YES |  |  |
| 106 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 107 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 108 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 109 | `ref_policy_no` | character varying(50) | YES |  | อ้างอิงเลขกรมธรรม์เดิมสำหรับต่อกรมธรรม์ |
| 110 | `partner_code` | character varying(10) | YES |  | รหัส partner |
| 111 | `cc_ans` | character varying(20) | YES |  | ขนาดรถยนต์ที่เลือก |
| 112 | `par_prefix_name_3` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 3 |
| 113 | `par_first_name_3` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 3 |
| 114 | `par_last_name_3` | character varying(255) | YES |  | นามสกลุ ผู้ขับขี่ 3 |
| 115 | `par_birth_date_3` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 3 |
| 116 | `par_citizen_id_3` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 3 |
| 117 | `par_driver_license_no_3` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 3 |
| 118 | `par_occupation_3` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 3 |
| 119 | `par_prefix_name_4` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 4 |
| 120 | `par_first_name_4` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 4 |
| 121 | `par_last_name_4` | character varying(255) | YES |  | นามสกลุ ผู้ขับขี่ 4 |
| 122 | `par_birth_date_4` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 4 |
| 123 | `par_citizen_id_4` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 4 |
| 124 | `par_driver_license_no_4` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 4 |
| 125 | `par_occupation_4` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 4 |
| 126 | `par_prefix_name_5` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 5 |
| 127 | `par_first_name_5` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 5 |
| 128 | `par_last_name_5` | character varying(255) | YES |  | นามสกลุ ผู้ขับขี่ 5 |
| 129 | `par_birth_date_5` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 5 |
| 130 | `par_citizen_id_5` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 5 |
| 131 | `par_driver_license_no_5` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 5 |
| 132 | `par_occupation_5` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 5 |
| 133 | `driver_behavior_1` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 1 |
| 134 | `driver_behavior_2` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 2 |
| 135 | `driver_behavior_3` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 3 |
| 136 | `driver_behavior_4` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 4 |
| 137 | `driver_behavior_5` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 5 |
| 138 | `driver_behavior_cal` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ ที่นำมาใช้ |
| 139 | `driver_behavior_disc_perc` | real | YES |  | ส่วนลดผู้ขับขี่ (percent) |
| 140 | `driver_behavior_disc_amt` | numeric | YES |  | ส่วนลดผู้ขับขี่ (baht) |
| 141 | `car_price` | numeric | YES |  | ราคารถยนต์ ณ วันที่ทำประกัน |
| 142 | `car_price_date` | date | YES |  | วันที่ของราคารถยนต์ ณ วันที่ทำประกัน |
| 143 | `sc_premium_amt` | numeric | YES |  | เบี้ยซ่อมห้าง (baht) |
| 144 | `prem_version` | smallint | YES |  | เวอร์ชั่นของ master price premium |
| 145 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 146 | `driver_behavior_consent_1` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 1 |
| 147 | `driver_behavior_consent_2` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 2 |
| 148 | `driver_behavior_consent_3` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 3 |
| 149 | `driver_behavior_consent_4` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 4 |
| 150 | `driver_behavior_consent_5` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 5 |
| 151 | `bene_occupation` | character varying(255) | YES |  | อาชีพผู้รับผลประโยชน์ |
| 152 | `par_occupation_code_1` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 1 |
| 153 | `par_occupation_code_2` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 2 |
| 154 | `par_occupation_code_3` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 3 |
| 155 | `par_occupation_code_4` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 4 |
| 156 | `par_occupation_code_5` | character varying(50) | YES |  | รหัส อาชีพ ผู้ขับขี่ 5 |
| 157 | `bene_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้รับผลประโยชน์ |
| 158 | `par_driver_license_category_1` | character varying(20) | YES |  |  |
| 159 | `par_driver_license_category_2` | character varying(20) | YES |  |  |
| 160 | `par_driver_license_category_3` | character varying(20) | YES |  |  |
| 161 | `par_driver_license_category_4` | character varying(20) | YES |  |  |
| 162 | `par_driver_license_category_5` | character varying(20) | YES |  |  |

**Primary key:** `Policy_No,Effective_Startdate,Create_date` (Policy_Header_copy2_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Car_Act_No` → Policy_Car_Act_Discount_Premium, `Comp_Code` → company_detail, `Deli_countryid` → mas_country, `Deli_district_id` → district, `Deli_province_id` → province, `Deli_subdistrict_id` → subdistrict, `Lead_No` → Lead_coverage_premium, `Owner_countryid` → mas_country, `Owner_district_id` → district, `Owner_province_id` → province, `Owner_subdistrict_id` → subdistrict, `Policy_No` → Policy_Header, `par_id` → policy_participant, `partner_code` → mas_partner, `ref_policy_no` → Policy_Header

**Indexes:**

- `Policy_Header_copy2_pkey`: `CREATE UNIQUE INDEX "Policy_Header_copy2_pkey" ON insurverse."Policy_Header_Trans" USING btree ("Policy_No", "Effective_Startdate", "Create_date")`

---

## Policy_Header_Trans_20260810

`insurverse.Policy_Header_Trans_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | YES |  |  |
| 2 | `Policy_Startdate` | timestamp(6) without time zone | YES |  |  |
| 3 | `Policy_Enddate` | timestamp(6) without time zone | YES |  |  |
| 4 | `Policy_Status` | character varying(50) | YES |  |  |
| 5 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 6 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 7 | `Car_Act_No` | character varying(50) | YES |  |  |
| 8 | `IIA_Ref_no` | character varying(50) | YES |  |  |
| 9 | `Policy_ETax_No` | character varying(50) | YES |  |  |
| 10 | `Par_code` | character varying(50) | YES |  |  |
| 11 | `Payment_Status` | character varying(50) | YES |  |  |
| 12 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 13 | `Create_by` | character varying(50) | YES |  |  |
| 14 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 15 | `Update_by` | character varying(50) | YES |  |  |
| 16 | `Car_Inspect_code` | character varying(50) | YES |  |  |
| 17 | `Car_Inspect_Status` | character varying(50) | YES |  |  |
| 18 | `Car_Inspect_Result` | character varying(50) | YES |  |  |
| 19 | `Car_inspect_date` | timestamp(6) without time zone | YES |  |  |
| 20 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 21 | `Deli_Addr_line1` | character varying(255) | YES |  |  |
| 22 | `Deli_Addr_line2` | character varying(255) | YES |  |  |
| 23 | `Deli_Addr_line3` | character varying(255) | YES |  |  |
| 24 | `Deli_province_id` | integer | YES |  |  |
| 25 | `Deli_subdistrict_id` | integer | YES |  |  |
| 26 | `Deli_district_id` | integer | YES |  |  |
| 27 | `Deli_zipcode` | character varying(45) | YES |  |  |
| 28 | `Deli_countryid` | integer | YES |  |  |
| 29 | `phone` | character varying(50) | YES |  |  |
| 30 | `email` | character varying(255) | YES |  |  |
| 31 | `Brand` | character varying(255) | YES |  |  |
| 32 | `Model` | character varying(255) | YES |  |  |
| 33 | `Year` | character varying(255) | YES |  |  |
| 34 | `Doors` | smallint | YES |  |  |
| 35 | `Seat` | smallint | YES |  |  |
| 36 | `Wg` | integer | YES |  |  |
| 37 | `Group` | character varying(255) | YES |  |  |
| 38 | `Usage` | smallint | YES |  |  |
| 39 | `Type` | character varying(50) | YES |  |  |
| 40 | `BodyType` | character varying(255) | YES |  |  |
| 41 | `GarageType` | character varying(2) | YES |  |  |
| 42 | `NamedAge` | character varying(255) | YES |  |  |
| 43 | `CC` | character varying(255) | YES |  |  |
| 44 | `Car_license_no` | character varying(50) | YES |  |  |
| 45 | `Car_license_provice` | integer | YES |  |  |
| 46 | `Car_serial_no` | character varying(50) | YES |  |  |
| 47 | `Bene_Type` | character varying(50) | YES |  |  |
| 48 | `Bene_Title` | character varying(50) | YES |  |  |
| 49 | `Bene_Firstname` | character varying(255) | YES |  |  |
| 50 | `Bene_Midname` | character varying(255) | YES |  |  |
| 51 | `Bene_Lastname` | character varying(255) | YES |  |  |
| 52 | `Bene_ID_card` | character varying(50) | YES |  |  |
| 53 | `Extend_Start` | timestamp(6) without time zone | YES |  |  |
| 54 | `Extend_End` | timestamp(6) without time zone | YES |  |  |
| 55 | `Car_license_type` | character varying(50) | YES |  |  |
| 56 | `Policy_Ref_no` | character varying(50) | YES |  |  |
| 57 | `Policy_QR_code` | character varying(255) | YES |  |  |
| 58 | `Car_color` | character varying(255) | YES |  |  |
| 59 | `Lead_No` | character varying(50) | YES |  |  |
| 60 | `Effective_Startdate` | timestamp(0) without time zone | YES |  |  |
| 61 | `Effective_Enddate` | timestamp(0) without time zone | YES |  |  |
| 62 | `Flag_Deli` | character(1) | YES |  |  |
| 63 | `Comp_Code` | character varying(50) | YES |  |  |
| 64 | `Policy_url_ref` | character varying(500) | YES |  |  |
| 65 | `id` | bigint | YES |  |  |
| 66 | `Policy_Barcode` | character varying(50) | YES |  |  |
| 67 | `Policy_url_copy_ref` | character varying(500) | YES |  |  |
| 68 | `Par_first_name_1` | character varying(255) | YES |  |  |
| 69 | `Par_last_name_1` | character varying(255) | YES |  |  |
| 70 | `Par_birth_date_1` | date | YES |  |  |
| 71 | `Par_occupation_1` | character varying(255) | YES |  |  |
| 72 | `Par_first_name_2` | character varying(255) | YES |  |  |
| 73 | `Par_last_name_2` | character varying(255) | YES |  |  |
| 74 | `Par_birth_date_2` | date | YES |  |  |
| 75 | `Par_occupation_2` | character varying(255) | YES |  |  |
| 76 | `Owner_first_name` | character varying(255) | YES |  |  |
| 77 | `Owner_last_name` | character varying(255) | YES |  |  |
| 78 | `Owner_birth_date` | date | YES |  |  |
| 79 | `Par_prefix_name_1` | character varying(50) | YES |  |  |
| 80 | `Par_prefix_name_2` | character varying(50) | YES |  |  |
| 81 | `Owner_prefix_name` | character varying(50) | YES |  |  |
| 82 | `Owner_address` | character varying(500) | YES |  |  |
| 83 | `Owner_province_id` | integer | YES |  |  |
| 84 | `Owner_subdistrict_id` | integer | YES |  |  |
| 85 | `Owner_district_id` | integer | YES |  |  |
| 86 | `Owner_zipcode` | character varying(45) | YES |  |  |
| 87 | `Owner_countryid` | integer | YES |  |  |
| 88 | `Owner_phone` | character varying(45) | YES |  |  |
| 89 | `Owner_occupation` | character varying(255) | YES |  |  |
| 90 | `Owner_citizen_id` | character varying(20) | YES |  |  |
| 91 | `Policy_book` | character varying(50) | YES |  |  |
| 92 | `Par_Driver_license_no_1` | character varying(20) | YES |  |  |
| 93 | `Par_Driver_license_no_2` | character varying(20) | YES |  |  |
| 94 | `Receipt_url_ref` | character varying(500) | YES |  |  |
| 95 | `Receipt_url_copy_ref` | character varying(500) | YES |  |  |
| 96 | `SF_Epolicy_file_id` | character varying(50) | YES |  |  |
| 97 | `SF_Etax_file_id` | character varying(50) | YES |  |  |
| 98 | `SF_Endorse_type` | character varying(50) | YES |  |  |
| 99 | `Par_citizen_id_1` | character varying(20) | YES |  |  |
| 100 | `Par_citizen_id_2` | character varying(20) | YES |  |  |
| 101 | `IIA_Lot_No` | character varying(20) | YES |  |  |
| 102 | `Appr_prefix_name` | character varying(50) | YES |  |  |
| 103 | `Appr_first_name` | character varying(255) | YES |  |  |
| 104 | `Appr_last_name` | character varying(255) | YES |  |  |
| 105 | `par_id` | integer | YES |  |  |
| 106 | `no_cancel_flag` | character varying(1) | YES |  |  |
| 107 | `no_cancel_reason` | character varying(500) | YES |  |  |
| 108 | `no_cancel_at` | timestamp without time zone | YES |  |  |
| 109 | `ref_policy_no` | character varying(50) | YES |  |  |
| 110 | `partner_code` | character varying(10) | YES |  |  |
| 111 | `cc_ans` | character varying(20) | YES |  |  |
| 112 | `par_prefix_name_3` | character varying(50) | YES |  |  |
| 113 | `par_first_name_3` | character varying(255) | YES |  |  |
| 114 | `par_last_name_3` | character varying(255) | YES |  |  |
| 115 | `par_birth_date_3` | date | YES |  |  |
| 116 | `par_citizen_id_3` | character varying(20) | YES |  |  |
| 117 | `par_driver_license_no_3` | character varying(20) | YES |  |  |
| 118 | `par_occupation_3` | character varying(255) | YES |  |  |
| 119 | `par_prefix_name_4` | character varying(50) | YES |  |  |
| 120 | `par_first_name_4` | character varying(255) | YES |  |  |
| 121 | `par_last_name_4` | character varying(255) | YES |  |  |
| 122 | `par_birth_date_4` | date | YES |  |  |
| 123 | `par_citizen_id_4` | character varying(20) | YES |  |  |
| 124 | `par_driver_license_no_4` | character varying(20) | YES |  |  |
| 125 | `par_occupation_4` | character varying(255) | YES |  |  |
| 126 | `par_prefix_name_5` | character varying(50) | YES |  |  |
| 127 | `par_first_name_5` | character varying(255) | YES |  |  |
| 128 | `par_last_name_5` | character varying(255) | YES |  |  |
| 129 | `par_birth_date_5` | date | YES |  |  |
| 130 | `par_citizen_id_5` | character varying(20) | YES |  |  |
| 131 | `par_driver_license_no_5` | character varying(20) | YES |  |  |
| 132 | `par_occupation_5` | character varying(255) | YES |  |  |
| 133 | `driver_behavior_1` | integer | YES |  |  |
| 134 | `driver_behavior_2` | integer | YES |  |  |
| 135 | `driver_behavior_3` | integer | YES |  |  |
| 136 | `driver_behavior_4` | integer | YES |  |  |
| 137 | `driver_behavior_5` | integer | YES |  |  |
| 138 | `driver_behavior_cal` | integer | YES |  |  |
| 139 | `driver_behavior_disc_perc` | real | YES |  |  |
| 140 | `driver_behavior_disc_amt` | numeric | YES |  |  |
| 141 | `car_price` | numeric | YES |  |  |
| 142 | `car_price_date` | date | YES |  |  |
| 143 | `sc_premium_amt` | numeric | YES |  |  |
| 144 | `prem_version` | smallint | YES |  |  |
| 145 | `oic_version` | character varying(20) | YES |  |  |
| 146 | `driver_behavior_consent_1` | boolean | YES |  |  |
| 147 | `driver_behavior_consent_2` | boolean | YES |  |  |
| 148 | `driver_behavior_consent_3` | boolean | YES |  |  |
| 149 | `driver_behavior_consent_4` | boolean | YES |  |  |
| 150 | `driver_behavior_consent_5` | boolean | YES |  |  |
| 151 | `bene_occupation` | character varying(255) | YES |  |  |
| 152 | `par_occupation_code_1` | character varying(50) | YES |  |  |
| 153 | `par_occupation_code_2` | character varying(50) | YES |  |  |
| 154 | `par_occupation_code_3` | character varying(50) | YES |  |  |
| 155 | `par_occupation_code_4` | character varying(50) | YES |  |  |
| 156 | `par_occupation_code_5` | character varying(50) | YES |  |  |
| 157 | `bene_occupation_code` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## Policy_Regis_Evident

`insurverse.Policy_Regis_Evident` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | NO |  | กรณี สมัครใจใช้ Policy_No กรณีพรบคือ Car_Act_No |
| 2 | `Evi_ID` | integer | NO |  | running |
| 3 | `Evi_path` | character varying(500) | YES |  | URL ที่อยู่ไฟล์ ที่อยู่รูปภาพ |
| 4 | `Create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `Create_by` | character varying(50) | YES |  |  |
| 6 | `Update_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `Update_by` | character varying(50) | YES |  |  |
| 8 | `Evi_type` | character varying(50) | YES |  | file type pdf, image dom=Regis, sub_dom=Evi_type |
| 9 | `Evi_Sector_ID` | character varying(50) | NO |  | รหัสส่วนของรถ เช่น ด้านหน้า ล้อแม็ก กล้อง ใส่ sys_para - para_code dom=Premium, sub_dom=Car_Sector |
| 10 | `sf_file_id` | character varying(18) | YES |  | Ref. SF File ID |
| 11 | `Evi_name` | character varying(500) | YES |  | ชื่อสำหรับรับจาก SF |
| 12 | `Evi_desc` | character varying(500) | YES |  | รายละเอียดสำหรับรับจาก SF |
| 13 | `Evi_isdel` | boolean | YES |  | true=ยกเลิก/ลบ, false=ใช้งานอยู่ |
| 14 | `SF_Policy_id` | character varying(255) | YES |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 15 | `salesforce_id` | character varying(18) | YES |  |  |
| 16 | `salesforce_id_at` | timestamp without time zone | YES |  | วันที่รับ endorsmentSFId จาก response  |

**Primary key:** `Policy_No,Evi_ID,Evi_Sector_ID` (Policy_Regis_Evident_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Policy_No` → Policy_Header

**Indexes:**

- `Policy_Regis_Evident_pkey`: `CREATE UNIQUE INDEX "Policy_Regis_Evident_pkey" ON insurverse."Policy_Regis_Evident" USING btree ("Policy_No", "Evi_ID", "Evi_Sector_ID")`

---

## Policy_coverage_premium

`insurverse.Policy_coverage_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | NO |  |  |
| 2 | `Effective_Startdate` | timestamp without time zone | NO |  |  |
| 3 | `Effective_Enddate` | timestamp without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  | กลุ่มรถ (แยกราคา) |
| 11 | `Usage` | smallint | YES |  | การใช้รถ 110 ส่วนบุคคล 320 รถบรรทุกหรือรถกระบะ 2 ประตู |
| 12 | `Type` | character varying(50) | YES |  | ชั้นประกัน |
| 13 | `BodyType` | character varying(255) | YES |  | แบบตัวถัง |
| 14 | `GarageType` | character varying(2) | YES |  | ซ่อมอู่ ซ่อมห้าง |
| 15 | `NamedAge` | character varying(255) | YES |  | ช่วงอายุผู้ขับขี่ (เลือกคนอายุน้อยสุด) |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  | ทุนประกัน |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_2 |
| 25 | `SI_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 26 | `SI_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  | Tariff คปภ. ส่วนทุนประกัน |
| 28 | `Prem_OD_1` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = Prem_OD_2 |
| 34 | `OD_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 35 | `OD_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 37 | `OD_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 38 | `Prem_FT_1` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำถ่วม) |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = Prem_FT_2 |
| 44 | `FT_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 45 | `FT_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 47 | `FT_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 48 | `SI_TPBI_1` | integer | YES |  | รย 20 ค่ารักษาพยาบาลคู่กรณี ต่อคน |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  | ราคาเบี้ยประกัน (ค่ารักษาพยาบาลคู่กรณี) |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_TPBI_2 |
| 55 | `SI_TPBI_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 56 | `SI_TPBI_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 58 | `SI_TPBI_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 59 | `SI_TPPD_1` | integer | YES |  | รย 20 ค่าทรัพย์สินคู่กรณี ต่อครั้ง |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  | ราคาเบี้ยประกัน (ค่าทรัพย์สินคู่กรณี) |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_TPPD_2 |
| 66 | `SI_TPPD_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 67 | `SI_TPPD_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 70 | `SI_MV01_1` | integer | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_MV01_2 |
| 77 | `SI_MV01_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 78 | `SI_MV01_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 80 | `SI_MV01_Amt` | numeric | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |
| 81 | `SI_MV02_1` | integer | YES |  | รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  | รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  | รย 20 คุ้มครองอุปกรณ์ตกแต่ง |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  | พรบ กรณีสลักหลังออกเป็น ปร 01 |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 120 | `Discount` | numeric(18,4) | YES |  | พรบ |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  | เบี้ยประกันสุทธิ Total_Amt_exclude_mv + Total_Amt_mv - Total_Disc_Amt |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  | อากรแสตมป์ Math.round(Prem_Amt*0.4%) |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  | ภาษีมูลค่าเพิ่ม ((Prem_Amt+Duty_Amt)*7)/100 |
| 124 | `Total_Amt` | numeric(18,4) | YES |  | เบี้ยประกันรวม Prem_Amt+Duty_Amt+Vat_Amt |
| 125 | `Payment_status` | character varying(50) | YES |  | สถานะจ่าย |
| 126 | `Payment_channel` | character varying(50) | YES |  | ช่องทางจ่าย |
| 127 | `Payment_type` | character varying(50) | YES |  | ประเภทจ่าย |
| 128 | `Payment_No` | character varying(50) | YES |  | หมายเลขสำคัญจ่าย |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp without time zone | YES |  |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  | % ส่วนลดกลุ่ม |
| 142 | `NCB_Disc_perc` | numeric | YES |  | % ส่วนลดประวัติดี |
| 143 | `Other_Disc_perc` | numeric | YES |  | % ส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |
| 144 | `Surcharge_Amt` | numeric | YES |  | ส่วนเพิ่มประวัติเสีย |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  | เบี้ยประกันตามความคุ้มครองหลัก |
| 146 | `Total_Amt_mv` | numeric | YES |  | เบี้ยประกันตามเอกสารแนบท้าย |
| 147 | `Flag_Car_Act` | character(1) | YES |  | y = ซื้อพร้อมพรบ, n = ไม่ซื้อพรบ |
| 148 | `Flag_CCTV` | character(1) | YES |  | y = มีกล้อง, n = ไม่มีกล้อง |
| 149 | `Flag_Driver` | character(1) | YES |  | y = ระบุผู้ขับขี่, n = ไม่ระบุขับขี่ |
| 150 | `Fleet_Disc_Amt` | numeric | YES |  | ราคาส่วนลดกลุ่ม |
| 151 | `NCB_Disc_Amt` | numeric | YES |  | ราคาส่วนลดประวัติดี |
| 152 | `Other_Disc_Amt` | numeric | YES |  | ราคาส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |
| 153 | `Total_Disc_Amt` | numeric | YES |  | ราคารวมส่วนลด Fleet + NCB + Other |
| 154 | `Lead_No` | integer | YES |  |  |
| 155 | `NamedAge_Amt` | numeric | YES |  | ราคาส่วนลดช่วงอายุผู้ขับขี่ |
| 156 | `SI_DD_1` | integer | YES |  | ความเสียหายส่วนแรก |
| 157 | `SI_DD_2` | integer | YES |  |  |
| 158 | `SI_DD_3` | integer | YES |  |  |
| 159 | `Prem_DD_1` | real | YES |  |  |
| 160 | `Prem_DD_2` | real | YES |  |  |
| 161 | `Prem_DD_3` | real | YES |  |  |
| 162 | `SI_DD_Ans` | integer | YES |  |  |
| 163 | `SI_DD_Start` | timestamp without time zone | YES |  |  |
| 164 | `SI_DD_End` | timestamp without time zone | YES |  |  |
| 165 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 166 | `SI_DD_Amt` | numeric | YES |  |  |
| 167 | `Flag_Access` | character(1) | YES |  | y = คุ้มครองอุปกรณ์ตบแต่ง, n = ไม่คุ้มครองอุปกรณ์ตบแต่ง |
| 168 | `Access_para_code` | character varying(255) | YES |  | เก็บ code อุปกรณ์ตบแต่งที่เลือก |
| 169 | `YOB_Driver_1` | character(4) | YES |  | ปีเกิดผู้ขับขี่คนที่ 1 |
| 170 | `YOB_Driver_2` | character(4) | YES |  | ปีเกิดผู้ขับขี่คนที่ 2 |
| 171 | `Payment_Date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 172 | `Basic_Premium` | numeric | YES |  | เบี้ยพื้นฐาน |
| 173 | `Change_Perm_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันสุทธิ หลังการสลักหลัง |
| 174 | `Change_Duty_Amt` | numeric | YES |  | ส่วนต่างอากรแสตมป์ หลังการสลักหลัง |
| 175 | `Change_Vat_Amt` | numeric | YES |  | ส่วนต่างภาษีมูลค่าเพิ่ม หลังการสลักหลัง |
| 176 | `Change_Total_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันรวม หลังการสลักหลัง |
| 177 | `SI_Limit` | numeric | YES |  | ทุนประกัน (ที่เลือก) |
| 178 | `SI_TPBI_Limit` | numeric | YES |  | ทุนค่ารักษาพยาบาลคู่กรณีต่อครั้ง (ที่เลือก) |
| 179 | `SI_TPPD_Limit` | numeric | YES |  | ทุนค่าทรัพย์สินคู่กรณีต่อครั้ง (ที่เลือก) |
| 180 | `SI_MV01_Limit` | numeric | YES |  | ทุนประกันอุบัติเหตุ (ที่เลือก) |
| 181 | `SI_MV02_Limit` | numeric | YES |  | ทุนค่ารักษาพยาบาลบุคคลในรถ (ที่เลือก) |
| 182 | `SI_MV03_Limit` | numeric | YES |  | ทุนค่าประกันตัวผู้ขับขี่ (ที่เลือก) |
| 183 | `SI_Access_Limit` | numeric | YES |  | ทุนคุ้มครองอุปกรณ์ตกแต่ง (ที่เลือก) |
| 184 | `sf_payment_prem` | character varying(50) | YES |  | Ref สถานะชำระเงินให้ SF |
| 185 | `Prem_ACT` | real | YES |  |  |
| 186 | `SF_Lead` | character varying(255) | YES |  |  |
| 187 | `SI_DD_Limit` | numeric | YES |  |  |
| 188 | `CCTV` | integer | YES |  |  |
| 189 | `Driver_Discount` | numeric | YES |  | ราคาส่วนลดคนขับ |
| 190 | `premium_v5_od` | numeric | YES |  |  |
| 191 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 192 | `promo_trans_id` | bigint | YES |  |  |
| 193 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 194 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 195 | `cover_day_count` | smallint | YES |  |  |
| 196 | `driver_age` | smallint | YES |  |  |
| 197 | `extend_amt` | numeric(16,4) | YES |  | ค่าเบี้ยเพิ่มกรณีสลักหลังขยายวันคุ้มครอง |
| 198 | `SI_TPBI_E_Limit` | numeric | YES |  |  |
| 199 | `SI_TPBI_E_Amt` | numeric | YES |  |  |
| 200 | `basic_premium_v5` | numeric | YES |  | เบี้ยพื้นฐาน v5 รย10 |
| 201 | `cc_ans` | character varying(20) | YES |  | ขนาดรถยนต์ที่เลือก |
| 202 | `par_prefix_name_1` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 1 |
| 203 | `par_first_name_1` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 1 |
| 204 | `par_last_name_1` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 1 |
| 205 | `par_birth_date_1` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 1 |
| 206 | `par_citizen_id_1` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 1 |
| 207 | `par_driver_license_no_1` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 1 |
| 208 | `par_occupation_1` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 1 |
| 209 | `par_prefix_name_2` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 2 |
| 210 | `par_first_name_2` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 2 |
| 211 | `par_last_name_2` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 2 |
| 212 | `par_birth_date_2` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 2 |
| 213 | `par_citizen_id_2` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 2 |
| 214 | `par_driver_license_no_2` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 2 |
| 215 | `par_occupation_2` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 2 |
| 216 | `par_prefix_name_3` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 3 |
| 217 | `par_first_name_3` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 3 |
| 218 | `par_last_name_3` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 3 |
| 219 | `par_birth_date_3` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 3 |
| 220 | `par_citizen_id_3` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 3 |
| 221 | `par_driver_license_no_3` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 3 |
| 222 | `par_occupation_3` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 3 |
| 223 | `par_prefix_name_4` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 4 |
| 224 | `par_first_name_4` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 4 |
| 225 | `par_last_name_4` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 4 |
| 226 | `par_birth_date_4` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 4 |
| 227 | `par_citizen_id_4` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 4 |
| 228 | `par_driver_license_no_4` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 4 |
| 229 | `par_occupation_4` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 4 |
| 230 | `par_prefix_name_5` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 5 |
| 231 | `par_first_name_5` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 5 |
| 232 | `par_last_name_5` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 5 |
| 233 | `par_birth_date_5` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 5 |
| 234 | `par_citizen_id_5` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 5 |
| 235 | `par_driver_license_no_5` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 5 |
| 236 | `par_occupation_5` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 5 |
| 237 | `driver_behavior_1` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 1 |
| 238 | `driver_behavior_2` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 2 |
| 239 | `driver_behavior_3` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 3 |
| 240 | `driver_behavior_4` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 4 |
| 241 | `driver_behavior_5` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 5 |
| 242 | `driver_behavior_cal` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ ที่นำมาใช้ |
| 243 | `driver_behavior_disc_perc` | real | YES |  | ส่วนลดผู้ขับขี่ (percent) |
| 244 | `driver_behavior_disc_amt` | numeric | YES |  | ส่วนลดผู้ขับขี่ (baht) |
| 245 | `car_price` | numeric | YES |  | ราคารถยนต์ ณ วันที่ทำประกัน |
| 246 | `car_price_date` | date | YES |  | วันที่ของราคารถยนต์ ณ วันที่ทำประกัน |
| 247 | `sc_premium_amt_1` | real | YES |  | เบี้ยซ่อมห้าง |
| 248 | `sc_premium_amt_2` | real | YES |  | เบี้ยซ่อมห้าง |
| 249 | `sc_premium_amt_3` | real | YES |  | เบี้ยซ่อมห้าง |
| 250 | `sc_premium_amt_4` | real | YES |  | เบี้ยซ่อมห้าง |
| 251 | `sc_premium_amt_5` | real | YES |  | เบี้ยซ่อมห้าง |
| 252 | `sc_premium_amt_ans` | integer | YES |  | เบี้ยซ่อมห้าง ที่เลือก (ตามทุนประกัน) |
| 253 | `prem_version` | smallint | YES |  | เวอร์ชั่นของ master price premium |
| 254 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 255 | `driver_behavior_consent_1` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 1 |
| 256 | `driver_behavior_consent_2` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 2 |
| 257 | `driver_behavior_consent_3` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 3 |
| 258 | `driver_behavior_consent_4` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 4 |
| 259 | `driver_behavior_consent_5` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 5 |
| 260 | `par_occupation_code_1` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 1 |
| 261 | `par_occupation_code_2` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 2 |
| 262 | `par_occupation_code_3` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 3 |
| 263 | `par_occupation_code_4` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 4 |
| 264 | `par_occupation_code_5` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 5 |
| 265 | `sc_premium_amt` | numeric | YES |  | เบี้ยซ่อมห้าง |
| 266 | `par_driver_license_category_1` | character varying(20) | YES |  |  |
| 267 | `par_driver_license_category_2` | character varying(20) | YES |  |  |
| 268 | `par_driver_license_category_3` | character varying(20) | YES |  |  |
| 269 | `par_driver_license_category_4` | character varying(20) | YES |  |  |
| 270 | `par_driver_license_category_5` | character varying(20) | YES |  |  |
| 271 | `first_name` | character varying(255) | YES | `''::character varying` |  |
| 272 | `last_name` | character varying(255) | YES | `''::character varying` |  |
| 273 | `email` | character varying(255) | YES | `''::character varying` |  |
| 274 | `phone` | character varying(255) | YES | `''::character varying` |  |
| 275 | `Policy_book` | character varying(255) | YES | `''::character varying` |  |
| 276 | `Policy_Quatation_No` | character varying(255) | YES | `''::character varying` |  |
| 277 | `Policy_Invoice_No` | character varying(255) | YES | `''::character varying` |  |
| 278 | `ref_policy_no` | character varying(255) | YES | `''::character varying` |  |
| 279 | `renewal_mc_startdate` | timestamp without time zone | YES |  |  |
| 280 | `renewal_mc_enddate` | timestamp without time zone | YES |  |  |

**Primary key:** `Policy_No` (Policy_coverage_premium_copy1_pkey2)

**Inferred references (naming convention, NOT enforced FK):** `Lead_No` → Lead_coverage_premium, `Policy_No` → Policy_Header, `promo_trans_id` → promo_code_trans, `ref_policy_no` → Policy_Header

**Indexes:**

- `Policy_coverage_premium_copy1_pkey2`: `CREATE UNIQUE INDEX "Policy_coverage_premium_copy1_pkey2" ON insurverse."Policy_coverage_premium" USING btree ("Policy_No")`

---

## Policy_coverage_premium_2

`insurverse.Policy_coverage_premium_2` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | YES |  |  |
| 2 | `Effective_Startdate` | timestamp(6) without time zone | YES |  |  |
| 3 | `Effective_Enddate` | timestamp(6) without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  |  |
| 11 | `Usage` | smallint | YES |  |  |
| 12 | `Type` | character varying(50) | YES |  |  |
| 13 | `BodyType` | character varying(255) | YES |  |  |
| 14 | `GarageType` | character varying(2) | YES |  |  |
| 15 | `NamedAge` | character varying(255) | YES |  |  |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  |  |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  |  |
| 25 | `SI_Start` | timestamp(6) without time zone | YES |  |  |
| 26 | `SI_End` | timestamp(6) without time zone | YES |  |  |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  |  |
| 28 | `Prem_OD_1` | real | YES |  |  |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  |  |
| 34 | `OD_Start` | timestamp(6) without time zone | YES |  |  |
| 35 | `OD_End` | timestamp(6) without time zone | YES |  |  |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  |  |
| 37 | `OD_Amt` | numeric | YES |  |  |
| 38 | `Prem_FT_1` | real | YES |  |  |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  |  |
| 44 | `FT_Start` | timestamp(6) without time zone | YES |  |  |
| 45 | `FT_End` | timestamp(6) without time zone | YES |  |  |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  |  |
| 47 | `FT_Amt` | numeric | YES |  |  |
| 48 | `SI_TPBI_1` | integer | YES |  |  |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  |  |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  |  |
| 55 | `SI_TPBI_Start` | timestamp(6) without time zone | YES |  |  |
| 56 | `SI_TPBI_End` | timestamp(6) without time zone | YES |  |  |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  |  |
| 58 | `SI_TPBI_Amt` | numeric | YES |  |  |
| 59 | `SI_TPPD_1` | integer | YES |  |  |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  |  |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  |  |
| 66 | `SI_TPPD_Start` | timestamp(6) without time zone | YES |  |  |
| 67 | `SI_TPPD_End` | timestamp(6) without time zone | YES |  |  |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  |  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  |  |
| 70 | `SI_MV01_1` | integer | YES |  |  |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  |  |
| 77 | `SI_MV01_Start` | timestamp(6) without time zone | YES |  |  |
| 78 | `SI_MV01_End` | timestamp(6) without time zone | YES |  |  |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  |  |
| 80 | `SI_MV01_Amt` | numeric | YES |  |  |
| 81 | `SI_MV02_1` | integer | YES |  |  |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp(6) without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp(6) without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  |  |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp(6) without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp(6) without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  |  |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp(6) without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp(6) without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  |  |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  |  |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  |  |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  |  |
| 120 | `Discount` | numeric(18,4) | YES |  |  |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  |  |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  |  |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  |  |
| 124 | `Total_Amt` | numeric(18,4) | YES |  |  |
| 125 | `Payment_status` | character varying(50) | YES |  |  |
| 126 | `Payment_channel` | character varying(50) | YES |  |  |
| 127 | `Payment_type` | character varying(50) | YES |  |  |
| 128 | `Payment_No` | character varying(50) | YES |  |  |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  |  |
| 142 | `NCB_Disc_perc` | numeric | YES |  |  |
| 143 | `Other_Disc_perc` | numeric | YES |  |  |
| 144 | `Surcharge_Amt` | numeric | YES |  |  |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  |  |
| 146 | `Total_Amt_mv` | numeric | YES |  |  |
| 147 | `Flag_Car_Act` | character(1) | YES |  |  |
| 148 | `Flag_CCTV` | character(1) | YES |  |  |
| 149 | `Flag_Driver` | character(1) | YES |  |  |
| 150 | `Fleet_Disc_Amt` | numeric | YES |  |  |
| 151 | `NCB_Disc_Amt` | numeric | YES |  |  |
| 152 | `Other_Disc_Amt` | numeric | YES |  |  |
| 153 | `Total_Disc_Amt` | numeric | YES |  |  |
| 154 | `Lead_No` | integer | YES |  |  |
| 155 | `NamedAge_Amt` | numeric | YES |  |  |
| 156 | `SI_DD_1` | integer | YES |  |  |
| 157 | `SI_DD_2` | integer | YES |  |  |
| 158 | `SI_DD_3` | integer | YES |  |  |
| 159 | `Prem_DD_1` | real | YES |  |  |
| 160 | `Prem_DD_2` | real | YES |  |  |
| 161 | `Prem_DD_3` | real | YES |  |  |
| 162 | `SI_DD_Ans` | integer | YES |  |  |
| 163 | `SI_DD_Start` | timestamp(6) without time zone | YES |  |  |
| 164 | `SI_DD_End` | timestamp(6) without time zone | YES |  |  |
| 165 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 166 | `SI_DD_Amt` | numeric | YES |  |  |
| 167 | `Flag_Access` | character(1) | YES |  |  |
| 168 | `Access_para_code` | character varying(255) | YES |  |  |
| 169 | `YOB_Driver_1` | character(4) | YES |  |  |
| 170 | `YOB_Driver_2` | character(4) | YES |  |  |
| 171 | `Payment_Date` | timestamp(6) without time zone | YES |  |  |
| 172 | `Basic_Premium` | numeric | YES |  |  |
| 173 | `Change_Perm_Amt` | numeric | YES |  |  |
| 174 | `Change_Duty_Amt` | numeric | YES |  |  |
| 175 | `Change_Vat_Amt` | numeric | YES |  |  |
| 176 | `Change_Total_Amt` | numeric | YES |  |  |
| 177 | `SI_Limit` | numeric | YES |  |  |
| 178 | `SI_TPBI_Limit` | numeric | YES |  |  |
| 179 | `SI_TPPD_Limit` | numeric | YES |  |  |
| 180 | `SI_MV01_Limit` | numeric | YES |  |  |
| 181 | `SI_MV02_Limit` | numeric | YES |  |  |
| 182 | `SI_MV03_Limit` | numeric | YES |  |  |
| 183 | `SI_Access_Limit` | numeric | YES |  |  |
| 184 | `sf_payment_prem` | character varying(50) | YES |  |  |
| 185 | `Prem_ACT` | real | YES |  |  |
| 186 | `SF_Lead` | character varying(255) | YES |  |  |
| 187 | `SI_DD_Limit` | numeric | YES |  |  |
| 188 | `CCTV` | integer | YES |  |  |
| 189 | `Driver_Discount` | numeric | YES |  |  |
| 190 | `premium_v5_od` | numeric | YES |  |  |
| 191 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 192 | `promo_trans_id` | bigint | YES |  |  |
| 193 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 194 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 195 | `cover_day_count` | smallint | YES |  |  |
| 196 | `driver_age` | smallint | YES |  |  |
| 197 | `extend_amt` | numeric(16,4) | YES |  |  |
| 198 | `SI_TPBI_E_Limit` | numeric | YES |  |  |
| 199 | `SI_TPBI_E_Amt` | numeric | YES |  |  |
| 200 | `basic_premium_v5` | numeric | YES |  |  |

**Primary key:** _none_

---

## Policy_coverage_premium_20260810

`insurverse.Policy_coverage_premium_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | YES |  |  |
| 2 | `Effective_Startdate` | timestamp(6) without time zone | YES |  |  |
| 3 | `Effective_Enddate` | timestamp(6) without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  |  |
| 11 | `Usage` | smallint | YES |  |  |
| 12 | `Type` | character varying(50) | YES |  |  |
| 13 | `BodyType` | character varying(255) | YES |  |  |
| 14 | `GarageType` | character varying(2) | YES |  |  |
| 15 | `NamedAge` | character varying(255) | YES |  |  |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  |  |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  |  |
| 25 | `SI_Start` | timestamp(6) without time zone | YES |  |  |
| 26 | `SI_End` | timestamp(6) without time zone | YES |  |  |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  |  |
| 28 | `Prem_OD_1` | real | YES |  |  |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  |  |
| 34 | `OD_Start` | timestamp(6) without time zone | YES |  |  |
| 35 | `OD_End` | timestamp(6) without time zone | YES |  |  |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  |  |
| 37 | `OD_Amt` | numeric | YES |  |  |
| 38 | `Prem_FT_1` | real | YES |  |  |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  |  |
| 44 | `FT_Start` | timestamp(6) without time zone | YES |  |  |
| 45 | `FT_End` | timestamp(6) without time zone | YES |  |  |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  |  |
| 47 | `FT_Amt` | numeric | YES |  |  |
| 48 | `SI_TPBI_1` | integer | YES |  |  |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  |  |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  |  |
| 55 | `SI_TPBI_Start` | timestamp(6) without time zone | YES |  |  |
| 56 | `SI_TPBI_End` | timestamp(6) without time zone | YES |  |  |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  |  |
| 58 | `SI_TPBI_Amt` | numeric | YES |  |  |
| 59 | `SI_TPPD_1` | integer | YES |  |  |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  |  |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  |  |
| 66 | `SI_TPPD_Start` | timestamp(6) without time zone | YES |  |  |
| 67 | `SI_TPPD_End` | timestamp(6) without time zone | YES |  |  |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  |  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  |  |
| 70 | `SI_MV01_1` | integer | YES |  |  |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  |  |
| 77 | `SI_MV01_Start` | timestamp(6) without time zone | YES |  |  |
| 78 | `SI_MV01_End` | timestamp(6) without time zone | YES |  |  |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  |  |
| 80 | `SI_MV01_Amt` | numeric | YES |  |  |
| 81 | `SI_MV02_1` | integer | YES |  |  |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp(6) without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp(6) without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  |  |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp(6) without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp(6) without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  |  |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp(6) without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp(6) without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  |  |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  |  |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  |  |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  |  |
| 120 | `Discount` | numeric(18,4) | YES |  |  |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  |  |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  |  |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  |  |
| 124 | `Total_Amt` | numeric(18,4) | YES |  |  |
| 125 | `Payment_status` | character varying(50) | YES |  |  |
| 126 | `Payment_channel` | character varying(50) | YES |  |  |
| 127 | `Payment_type` | character varying(50) | YES |  |  |
| 128 | `Payment_No` | character varying(50) | YES |  |  |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  |  |
| 142 | `NCB_Disc_perc` | numeric | YES |  |  |
| 143 | `Other_Disc_perc` | numeric | YES |  |  |
| 144 | `Surcharge_Amt` | numeric | YES |  |  |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  |  |
| 146 | `Total_Amt_mv` | numeric | YES |  |  |
| 147 | `Flag_Car_Act` | character(1) | YES |  |  |
| 148 | `Flag_CCTV` | character(1) | YES |  |  |
| 149 | `Flag_Driver` | character(1) | YES |  |  |
| 150 | `Fleet_Disc_Amt` | numeric | YES |  |  |
| 151 | `NCB_Disc_Amt` | numeric | YES |  |  |
| 152 | `Other_Disc_Amt` | numeric | YES |  |  |
| 153 | `Total_Disc_Amt` | numeric | YES |  |  |
| 154 | `Lead_No` | integer | YES |  |  |
| 155 | `NamedAge_Amt` | numeric | YES |  |  |
| 156 | `SI_DD_1` | integer | YES |  |  |
| 157 | `SI_DD_2` | integer | YES |  |  |
| 158 | `SI_DD_3` | integer | YES |  |  |
| 159 | `Prem_DD_1` | real | YES |  |  |
| 160 | `Prem_DD_2` | real | YES |  |  |
| 161 | `Prem_DD_3` | real | YES |  |  |
| 162 | `SI_DD_Ans` | integer | YES |  |  |
| 163 | `SI_DD_Start` | timestamp(6) without time zone | YES |  |  |
| 164 | `SI_DD_End` | timestamp(6) without time zone | YES |  |  |
| 165 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 166 | `SI_DD_Amt` | numeric | YES |  |  |
| 167 | `Flag_Access` | character(1) | YES |  |  |
| 168 | `Access_para_code` | character varying(255) | YES |  |  |
| 169 | `YOB_Driver_1` | character(4) | YES |  |  |
| 170 | `YOB_Driver_2` | character(4) | YES |  |  |
| 171 | `Payment_Date` | timestamp(6) without time zone | YES |  |  |
| 172 | `Basic_Premium` | numeric | YES |  |  |
| 173 | `Change_Perm_Amt` | numeric | YES |  |  |
| 174 | `Change_Duty_Amt` | numeric | YES |  |  |
| 175 | `Change_Vat_Amt` | numeric | YES |  |  |
| 176 | `Change_Total_Amt` | numeric | YES |  |  |
| 177 | `SI_Limit` | numeric | YES |  |  |
| 178 | `SI_TPBI_Limit` | numeric | YES |  |  |
| 179 | `SI_TPPD_Limit` | numeric | YES |  |  |
| 180 | `SI_MV01_Limit` | numeric | YES |  |  |
| 181 | `SI_MV02_Limit` | numeric | YES |  |  |
| 182 | `SI_MV03_Limit` | numeric | YES |  |  |
| 183 | `SI_Access_Limit` | numeric | YES |  |  |
| 184 | `sf_payment_prem` | character varying(50) | YES |  |  |
| 185 | `Prem_ACT` | real | YES |  |  |
| 186 | `SF_Lead` | character varying(255) | YES |  |  |
| 187 | `SI_DD_Limit` | numeric | YES |  |  |
| 188 | `CCTV` | integer | YES |  |  |
| 189 | `Driver_Discount` | numeric | YES |  |  |
| 190 | `premium_v5_od` | numeric | YES |  |  |
| 191 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 192 | `promo_trans_id` | bigint | YES |  |  |
| 193 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 194 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 195 | `cover_day_count` | smallint | YES |  |  |
| 196 | `driver_age` | smallint | YES |  |  |
| 197 | `extend_amt` | numeric(16,4) | YES |  |  |
| 198 | `SI_TPBI_E_Limit` | numeric | YES |  |  |
| 199 | `SI_TPBI_E_Amt` | numeric | YES |  |  |
| 200 | `basic_premium_v5` | numeric | YES |  |  |
| 201 | `cc_ans` | character varying(20) | YES |  |  |
| 202 | `par_prefix_name_1` | character varying(50) | YES |  |  |
| 203 | `par_first_name_1` | character varying(255) | YES |  |  |
| 204 | `par_last_name_1` | character varying(255) | YES |  |  |
| 205 | `par_birth_date_1` | date | YES |  |  |
| 206 | `par_citizen_id_1` | character varying(20) | YES |  |  |
| 207 | `par_driver_license_no_1` | character varying(20) | YES |  |  |
| 208 | `par_occupation_1` | character varying(255) | YES |  |  |
| 209 | `par_prefix_name_2` | character varying(50) | YES |  |  |
| 210 | `par_first_name_2` | character varying(255) | YES |  |  |
| 211 | `par_last_name_2` | character varying(255) | YES |  |  |
| 212 | `par_birth_date_2` | date | YES |  |  |
| 213 | `par_citizen_id_2` | character varying(20) | YES |  |  |
| 214 | `par_driver_license_no_2` | character varying(20) | YES |  |  |
| 215 | `par_occupation_2` | character varying(255) | YES |  |  |
| 216 | `par_prefix_name_3` | character varying(50) | YES |  |  |
| 217 | `par_first_name_3` | character varying(255) | YES |  |  |
| 218 | `par_last_name_3` | character varying(255) | YES |  |  |
| 219 | `par_birth_date_3` | date | YES |  |  |
| 220 | `par_citizen_id_3` | character varying(20) | YES |  |  |
| 221 | `par_driver_license_no_3` | character varying(20) | YES |  |  |
| 222 | `par_occupation_3` | character varying(255) | YES |  |  |
| 223 | `par_prefix_name_4` | character varying(50) | YES |  |  |
| 224 | `par_first_name_4` | character varying(255) | YES |  |  |
| 225 | `par_last_name_4` | character varying(255) | YES |  |  |
| 226 | `par_birth_date_4` | date | YES |  |  |
| 227 | `par_citizen_id_4` | character varying(20) | YES |  |  |
| 228 | `par_driver_license_no_4` | character varying(20) | YES |  |  |
| 229 | `par_occupation_4` | character varying(255) | YES |  |  |
| 230 | `par_prefix_name_5` | character varying(50) | YES |  |  |
| 231 | `par_first_name_5` | character varying(255) | YES |  |  |
| 232 | `par_last_name_5` | character varying(255) | YES |  |  |
| 233 | `par_birth_date_5` | date | YES |  |  |
| 234 | `par_citizen_id_5` | character varying(20) | YES |  |  |
| 235 | `par_driver_license_no_5` | character varying(20) | YES |  |  |
| 236 | `par_occupation_5` | character varying(255) | YES |  |  |
| 237 | `driver_behavior_1` | integer | YES |  |  |
| 238 | `driver_behavior_2` | integer | YES |  |  |
| 239 | `driver_behavior_3` | integer | YES |  |  |
| 240 | `driver_behavior_4` | integer | YES |  |  |
| 241 | `driver_behavior_5` | integer | YES |  |  |
| 242 | `driver_behavior_cal` | integer | YES |  |  |
| 243 | `driver_behavior_disc_perc` | real | YES |  |  |
| 244 | `driver_behavior_disc_amt` | numeric | YES |  |  |
| 245 | `car_price` | numeric | YES |  |  |
| 246 | `car_price_date` | date | YES |  |  |
| 247 | `sc_premium_amt_1` | real | YES |  |  |
| 248 | `sc_premium_amt_2` | real | YES |  |  |
| 249 | `sc_premium_amt_3` | real | YES |  |  |
| 250 | `sc_premium_amt_4` | real | YES |  |  |
| 251 | `sc_premium_amt_5` | real | YES |  |  |
| 252 | `sc_premium_amt_ans` | integer | YES |  |  |
| 253 | `prem_version` | smallint | YES |  |  |
| 254 | `oic_version` | character varying(20) | YES |  |  |
| 255 | `driver_behavior_consent_1` | boolean | YES |  |  |
| 256 | `driver_behavior_consent_2` | boolean | YES |  |  |
| 257 | `driver_behavior_consent_3` | boolean | YES |  |  |
| 258 | `driver_behavior_consent_4` | boolean | YES |  |  |
| 259 | `driver_behavior_consent_5` | boolean | YES |  |  |
| 260 | `par_occupation_code_1` | character varying(50) | YES |  |  |
| 261 | `par_occupation_code_2` | character varying(50) | YES |  |  |
| 262 | `par_occupation_code_3` | character varying(50) | YES |  |  |
| 263 | `par_occupation_code_4` | character varying(50) | YES |  |  |
| 264 | `par_occupation_code_5` | character varying(50) | YES |  |  |
| 265 | `sc_premium_amt` | numeric | YES |  |  |

**Primary key:** _none_

---

## Policy_coverage_premium_Trans

`insurverse.Policy_coverage_premium_Trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | NO |  |  |
| 2 | `Effective_Startdate` | timestamp without time zone | NO |  |  |
| 3 | `Effective_Enddate` | timestamp without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  | กลุ่มรถ (แยกราคา) |
| 11 | `Usage` | smallint | YES |  | การใช้รถ 110 ส่วนบุคคล 320 รถบรรทุกหรือรถกระบะ 2 ประตู |
| 12 | `Type` | character varying(50) | YES |  | ชั้นประกัน |
| 13 | `BodyType` | character varying(255) | YES |  | แบบตัวถัง |
| 14 | `GarageType` | character varying(2) | YES |  | ซ่อมอู่ ซ่อมห้าง |
| 15 | `NamedAge` | character varying(255) | YES |  | ช่วงอายุผู้ขับขี่ (เลือกคนอายุน้อยสุด) |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  | ทุนประกัน |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_2 |
| 25 | `SI_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 26 | `SI_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  | Tariff คปภ. ส่วนทุนประกัน |
| 28 | `Prem_OD_1` | real | YES |  | ราคาเบี้ยประกัน (ค่าซาก) |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = Prem_OD_2 |
| 34 | `OD_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 35 | `OD_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 37 | `OD_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 38 | `Prem_FT_1` | real | YES |  | ราคาเบี้ยประกัน (ไฟไหม้ น้ำถ่วม) |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = Prem_FT_2 |
| 44 | `FT_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 45 | `FT_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 47 | `FT_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 48 | `SI_TPBI_1` | integer | YES |  | รย 20 ค่ารักษาพยาบาลคู่กรณี ต่อคน |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  | ราคาเบี้ยประกัน (ค่ารักษาพยาบาลคู่กรณี) |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_TPBI_2 |
| 55 | `SI_TPBI_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 56 | `SI_TPBI_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 58 | `SI_TPBI_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 59 | `SI_TPPD_1` | integer | YES |  | รย 20 ค่าทรัพย์สินคู่กรณี ต่อครั้ง |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  | ราคาเบี้ยประกัน (ค่าทรัพย์สินคู่กรณี) |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_TPPD_2 |
| 66 | `SI_TPPD_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 67 | `SI_TPPD_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  | เบี้ยประกันสุทธิ Prem - OIC_disct_perc |
| 70 | `SI_MV01_1` | integer | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  | ลำดับที่เลือก เช่น 2 = SI_MV01_2 |
| 77 | `SI_MV01_Start` | timestamp without time zone | YES |  | วันที่เริ่มต้นคุ้มครอง (วันที่เพิ่ม/แก้ไข) |
| 78 | `SI_MV01_End` | timestamp without time zone | YES |  | วันที่สิ้นสุดคุ้มครอง (วันที่สิ้นสุดกรมธรรม์) |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  | ส่วนลดเวลาคุ้มครอง (สลักหลัง) เริ่มที่ 0 = คุ้มครองครบปีไม่มีส่วนลด อื่นๆดู OIC_Perc_Discount_by_Day  |
| 80 | `SI_MV01_Amt` | numeric | YES |  | รย 01 ประกันอุบัติเหตุ / กรณีสลักหลัง รย 20 |
| 81 | `SI_MV02_1` | integer | YES |  | รย 02 ค่ารักษาพยาบาลบุคคลในรถ / กรณีสลักหลัง รย 20 |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  | รย 03 ค่าประกันตัวผู้ขับขี่ / กรณีสลักหลัง รย 20 |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  | รย 20 คุ้มครองอุปกรณ์ตกแต่ง |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  | พรบ กรณีสลักหลังออกเป็น ปร 01 |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  | พรบ |
| 120 | `Discount` | numeric(18,4) | YES |  | พรบ |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  | เบี้ยประกันสุทธิ Total_Amt_exclude_mv + Total_Amt_mv - Total_Disc_Amt |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  | อากรแสตมป์ Math.round(Prem_Amt*0.4%) |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  | ภาษีมูลค่าเพิ่ม ((Prem_Amt+Duty_Amt)*7)/100 |
| 124 | `Total_Amt` | numeric(18,4) | YES |  | เบี้ยประกันรวม Prem_Amt+Duty_Amt+Vat_Amt |
| 125 | `Payment_status` | character varying(50) | YES |  | สถานะจ่าย |
| 126 | `Payment_channel` | character varying(50) | YES |  | ช่องทางจ่าย |
| 127 | `Payment_type` | character varying(50) | YES |  | ประเภทจ่าย |
| 128 | `Payment_No` | character varying(50) | YES |  | หมายเลขสำคัญจ่าย |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp without time zone | NO |  |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  | % ส่วนลดกลุ่ม |
| 142 | `NCB_Disc_perc` | numeric | YES |  | % ส่วนลดประวัติดี |
| 143 | `Other_Disc_perc` | numeric | YES |  | % ส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |
| 144 | `Surcharge_Amt` | numeric | YES |  | ส่วนเพิ่มประวัติเสีย |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  | เบี้ยประกันตามความคุ้มครองหลัก |
| 146 | `Total_Amt_mv` | numeric | YES |  | เบี้ยประกันตามเอกสารแนบท้าย |
| 147 | `Flag_Car_Act` | character(1) | YES |  | y = ซื้อพร้อมพรบ, n = ไม่ซื้อพรบ |
| 148 | `Flag_CCTV` | character(1) | YES |  | y = มีกล้อง, n = ไม่มีกล้อง |
| 149 | `Flag_Driver` | character(1) | YES |  | y = ระบุผู้ขับขี่, n = ไม่ระบุขับขี่ |
| 150 | `Fleet_Disc_Amt` | numeric | YES |  | ราคาส่วนลดกลุ่ม |
| 151 | `NCB_Disc_Amt` | numeric | YES |  | ราคาส่วนลดประวัติดี |
| 152 | `Other_Disc_Amt` | numeric | YES |  | ราคาส่วนลดอื่นๆ รย 18 กรณีเพิ่ม/ลดกล้องหน้ารถ |
| 153 | `Total_Disc_Amt` | numeric | YES |  | ราคารวมส่วนลด Fleet + NCB + Other |
| 154 | `Lead_No` | integer | YES |  |  |
| 155 | `NamedAge_Amt` | numeric | YES |  | ราคาส่วนลดช่วงอายุผู้ขับขี่ |
| 156 | `SI_DD_1` | integer | YES |  | ความเสียหายส่วนแรก |
| 157 | `SI_DD_2` | integer | YES |  |  |
| 158 | `SI_DD_3` | integer | YES |  |  |
| 159 | `Prem_DD_1` | real | YES |  |  |
| 160 | `Prem_DD_2` | real | YES |  |  |
| 161 | `Prem_DD_3` | real | YES |  |  |
| 162 | `SI_DD_Ans` | integer | YES |  |  |
| 163 | `SI_DD_Start` | timestamp without time zone | YES |  |  |
| 164 | `SI_DD_End` | timestamp without time zone | YES |  |  |
| 165 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 166 | `SI_DD_Amt` | numeric | YES |  |  |
| 167 | `Flag_Access` | character(1) | YES |  | y = คุ้มครองอุปกรณ์ตบแต่ง, n = ไม่คุ้มครองอุปกรณ์ตบแต่ง |
| 168 | `Access_para_code` | character varying(255) | YES |  | เก็บ code อุปกรณ์ตบแต่งที่เลือก |
| 169 | `YOB_Driver_1` | character(4) | YES |  | ปีเกิดผู้ขับขี่คนที่ 1 |
| 170 | `YOB_Driver_2` | character(4) | YES |  | ปีเกิดผู้ขับขี่คนที่ 2 |
| 171 | `Payment_Date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 172 | `Basic_Premium` | numeric | YES |  | เบี้ยพื้นฐาน |
| 173 | `Change_Perm_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันสุทธิ หลังการสลักหลัง |
| 174 | `Change_Duty_Amt` | numeric | YES |  | ส่วนต่างอากรแสตมป์ หลังการสลักหลัง |
| 175 | `Change_Vat_Amt` | numeric | YES |  | ส่วนต่างภาษีมูลค่าเพิ่ม หลังการสลักหลัง |
| 176 | `Change_Total_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันรวม หลังการสลักหลัง |
| 177 | `SI_Limit` | numeric | YES |  | ทุนประกัน (ที่เลือก) |
| 178 | `SI_TPBI_Limit` | numeric | YES |  | ทุนค่ารักษาพยาบาลคู่กรณีต่อครั้ง (ที่เลือก) |
| 179 | `SI_TPPD_Limit` | numeric | YES |  | ทุนค่าทรัพย์สินคู่กรณีต่อครั้ง (ที่เลือก) |
| 180 | `SI_MV01_Limit` | numeric | YES |  | ทุนประกันอุบัติเหตุ (ที่เลือก) |
| 181 | `SI_MV02_Limit` | numeric | YES |  | ทุนค่ารักษาพยาบาลบุคคลในรถ (ที่เลือก) |
| 182 | `SI_MV03_Limit` | numeric | YES |  | ทุนค่าประกันตัวผู้ขับขี่ (ที่เลือก) |
| 183 | `SI_Access_Limit` | numeric | YES |  | ทุนคุ้มครองอุปกรณ์ตกแต่ง (ที่เลือก) |
| 184 | `sf_payment_prem` | character varying(50) | YES |  | Ref สถานะชำระเงินให้ SF |
| 185 | `Prem_ACT` | real | YES |  |  |
| 186 | `SF_Lead` | character varying(255) | YES |  |  |
| 187 | `SI_DD_Limit` | numeric | YES |  |  |
| 188 | `CCTV` | integer | YES |  |  |
| 189 | `Driver_Discount` | numeric | YES |  | ราคาส่วนลดคนขับ |
| 190 | `premium_v5_od` | numeric | YES |  |  |
| 191 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 192 | `promo_trans_id` | bigint | YES |  |  |
| 193 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 194 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 195 | `cover_day_count` | smallint | YES |  |  |
| 196 | `driver_age` | smallint | YES |  |  |
| 197 | `extend_amt` | numeric(16,4) | YES |  | ค่าเบี้ยเพิ่มกรณีสลักหลังขยายวันคุ้มครอง |
| 198 | `SI_TPBI_E_Limit` | numeric | YES |  |  |
| 199 | `SI_TPBI_E_Amt` | numeric | YES |  |  |
| 200 | `basic_premium_v5` | numeric | YES |  | เบี้ยพื้นฐาน v5 รย10 |
| 201 | `cc_ans` | character varying(20) | YES |  | ขนาดรถยนต์ที่เลือก |
| 202 | `par_prefix_name_1` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 1 |
| 203 | `par_first_name_1` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 1 |
| 204 | `par_last_name_1` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 1 |
| 205 | `par_birth_date_1` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 1 |
| 206 | `par_citizen_id_1` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 1 |
| 207 | `par_driver_license_no_1` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 1 |
| 208 | `par_occupation_1` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 1 |
| 209 | `par_prefix_name_2` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 2 |
| 210 | `par_first_name_2` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 2 |
| 211 | `par_last_name_2` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 2 |
| 212 | `par_birth_date_2` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 2 |
| 213 | `par_citizen_id_2` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 2 |
| 214 | `par_driver_license_no_2` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 2 |
| 215 | `par_occupation_2` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 2 |
| 216 | `par_prefix_name_3` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 3 |
| 217 | `par_first_name_3` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 3 |
| 218 | `par_last_name_3` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 3 |
| 219 | `par_birth_date_3` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 3 |
| 220 | `par_citizen_id_3` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 3 |
| 221 | `par_driver_license_no_3` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 3 |
| 222 | `par_occupation_3` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 3 |
| 223 | `par_prefix_name_4` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 4 |
| 224 | `par_first_name_4` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 4 |
| 225 | `par_last_name_4` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 4 |
| 226 | `par_birth_date_4` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 4 |
| 227 | `par_citizen_id_4` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 4 |
| 228 | `par_driver_license_no_4` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 4 |
| 229 | `par_occupation_4` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 4 |
| 230 | `par_prefix_name_5` | character varying(50) | YES |  | คำนำหน้าชื่อ ผู้ขับขี่ 5 |
| 231 | `par_first_name_5` | character varying(255) | YES |  | ชื่อ ผู้ขับขี่ 5 |
| 232 | `par_last_name_5` | character varying(255) | YES |  | นามสกุล ผู้ขับขี่ 5 |
| 233 | `par_birth_date_5` | date | YES |  | วันเดือนปีเกิด ผู้ขับขี่ 5 |
| 234 | `par_citizen_id_5` | character varying(20) | YES |  | หมายเลขบัตร ปชช / passport ผู้ขับขี่ 5 |
| 235 | `par_driver_license_no_5` | character varying(20) | YES |  | หมายเลขใบขับขี่ ผู้ขับขี่ 5 |
| 236 | `par_occupation_5` | character varying(255) | YES |  | อาชีพ ผู้ขับขี่ 5 |
| 237 | `driver_behavior_1` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 1 |
| 238 | `driver_behavior_2` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 2 |
| 239 | `driver_behavior_3` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 3 |
| 240 | `driver_behavior_4` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 4 |
| 241 | `driver_behavior_5` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ 5 |
| 242 | `driver_behavior_cal` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ ที่นำมาใช้ |
| 243 | `driver_behavior_disc_perc` | real | YES |  | ส่วนลดผู้ขับขี่ (percent) |
| 244 | `driver_behavior_disc_amt` | numeric | YES |  | ส่วนลดผู้ขับขี่ (baht) |
| 245 | `car_price` | numeric | YES |  | ราคารถยนต์ ณ วันที่ทำประกัน |
| 246 | `car_price_date` | date | YES |  | วันที่ของราคารถยนต์ ณ วันที่ทำประกัน |
| 247 | `sc_premium_amt_1` | real | YES |  | เบี้ยซ่อมห้าง |
| 248 | `sc_premium_amt_2` | real | YES |  | เบี้ยซ่อมห้าง |
| 249 | `sc_premium_amt_3` | real | YES |  | เบี้ยซ่อมห้าง |
| 250 | `sc_premium_amt_4` | real | YES |  | เบี้ยซ่อมห้าง |
| 251 | `sc_premium_amt_5` | real | YES |  | เบี้ยซ่อมห้าง |
| 252 | `sc_premium_amt_ans` | integer | YES |  | เบี้ยซ่อมห้าง ที่เลือก (ตามทุนประกัน) |
| 253 | `prem_version` | smallint | YES |  | เวอร์ชั่นของ master price premium |
| 254 | `oic_version` | character varying(20) | YES |  | เวอร์ชั่นของ oic |
| 255 | `driver_behavior_consent_1` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 1 |
| 256 | `driver_behavior_consent_2` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 2 |
| 257 | `driver_behavior_consent_3` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 3 |
| 258 | `driver_behavior_consent_4` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 4 |
| 259 | `driver_behavior_consent_5` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 5 |
| 260 | `par_occupation_code_1` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 1 |
| 261 | `par_occupation_code_2` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 2 |
| 262 | `par_occupation_code_3` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 3 |
| 263 | `par_occupation_code_4` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 4 |
| 264 | `par_occupation_code_5` | character varying(50) | YES |  | รหัส อาชีพผู้ขับขี่ 5 |
| 265 | `sc_premium_amt` | numeric | YES |  | เบี้ยซ่อมห้าง |
| 266 | `par_driver_license_category_1` | character varying(20) | YES |  |  |
| 267 | `par_driver_license_category_2` | character varying(20) | YES |  |  |
| 268 | `par_driver_license_category_3` | character varying(20) | YES |  |  |
| 269 | `par_driver_license_category_4` | character varying(20) | YES |  |  |
| 270 | `par_driver_license_category_5` | character varying(20) | YES |  |  |

**Primary key:** `Policy_No,Effective_Startdate,Create_date` (Policy_coverage_premium_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Lead_No` → Lead_coverage_premium, `Policy_No` → Policy_Header, `promo_trans_id` → promo_code_trans

**Indexes:**

- `Policy_coverage_premium_copy1_pkey`: `CREATE UNIQUE INDEX "Policy_coverage_premium_copy1_pkey" ON insurverse."Policy_coverage_premium_Trans" USING btree ("Policy_No", "Effective_Startdate", "Create_date")`

---

## Policy_coverage_premium_Trans_20260810

`insurverse.Policy_coverage_premium_Trans_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Policy_No` | character varying(50) | YES |  |  |
| 2 | `Effective_Startdate` | timestamp(6) without time zone | YES |  |  |
| 3 | `Effective_Enddate` | timestamp(6) without time zone | YES |  |  |
| 4 | `Brand` | character varying(255) | YES |  |  |
| 5 | `Model` | character varying(255) | YES |  |  |
| 6 | `Year` | character varying(255) | YES |  |  |
| 7 | `Doors` | smallint | YES |  |  |
| 8 | `Seat` | smallint | YES |  |  |
| 9 | `Wg` | integer | YES |  |  |
| 10 | `Group` | character varying(255) | YES |  |  |
| 11 | `Usage` | smallint | YES |  |  |
| 12 | `Type` | character varying(50) | YES |  |  |
| 13 | `BodyType` | character varying(255) | YES |  |  |
| 14 | `GarageType` | character varying(2) | YES |  |  |
| 15 | `NamedAge` | character varying(255) | YES |  |  |
| 16 | `MinSI` | integer | YES |  |  |
| 17 | `MaxSI` | integer | YES |  |  |
| 18 | `Split` | integer | YES |  |  |
| 19 | `SI_1` | integer | YES |  |  |
| 20 | `SI_2` | integer | YES |  |  |
| 21 | `SI_3` | integer | YES |  |  |
| 22 | `SI_4` | integer | YES |  |  |
| 23 | `SI_5` | integer | YES |  |  |
| 24 | `SI_Ans` | integer | YES |  |  |
| 25 | `SI_Start` | timestamp(6) without time zone | YES |  |  |
| 26 | `SI_End` | timestamp(6) without time zone | YES |  |  |
| 27 | `SI_OIC_disct_perc` | numeric(18,4) | YES |  |  |
| 28 | `Prem_OD_1` | real | YES |  |  |
| 29 | `Prem_OD_2` | real | YES |  |  |
| 30 | `Prem_OD_3` | real | YES |  |  |
| 31 | `Prem_OD_4` | real | YES |  |  |
| 32 | `Prem_OD_5` | real | YES |  |  |
| 33 | `OD_Ans` | integer | YES |  |  |
| 34 | `OD_Start` | timestamp(6) without time zone | YES |  |  |
| 35 | `OD_End` | timestamp(6) without time zone | YES |  |  |
| 36 | `OD_OIC_disct_perc` | numeric | YES |  |  |
| 37 | `OD_Amt` | numeric | YES |  |  |
| 38 | `Prem_FT_1` | real | YES |  |  |
| 39 | `Prem_FT_2` | real | YES |  |  |
| 40 | `Prem_FT_3` | real | YES |  |  |
| 41 | `Prem_FT_4` | real | YES |  |  |
| 42 | `Prem_FT_5` | real | YES |  |  |
| 43 | `FT_Ans` | integer | YES |  |  |
| 44 | `FT_Start` | timestamp(6) without time zone | YES |  |  |
| 45 | `FT_End` | timestamp(6) without time zone | YES |  |  |
| 46 | `FT_OIC_disct_perc` | numeric | YES |  |  |
| 47 | `FT_Amt` | numeric | YES |  |  |
| 48 | `SI_TPBI_1` | integer | YES |  |  |
| 49 | `SI_TPBI_2` | integer | YES |  |  |
| 50 | `SI_TPBI_3` | integer | YES |  |  |
| 51 | `Prem_TPBI_1` | real | YES |  |  |
| 52 | `Prem_TPBI_2` | real | YES |  |  |
| 53 | `Prem_TPBI_3` | real | YES |  |  |
| 54 | `SI_TPBI_Ans` | integer | YES |  |  |
| 55 | `SI_TPBI_Start` | timestamp(6) without time zone | YES |  |  |
| 56 | `SI_TPBI_End` | timestamp(6) without time zone | YES |  |  |
| 57 | `SI_TPBI_OIC_disct_perc` | numeric | YES |  |  |
| 58 | `SI_TPBI_Amt` | numeric | YES |  |  |
| 59 | `SI_TPPD_1` | integer | YES |  |  |
| 60 | `SI_TPPD_2` | integer | YES |  |  |
| 61 | `SI_TPPD_3` | integer | YES |  |  |
| 62 | `Prem_TPPD_1` | real | YES |  |  |
| 63 | `Prem_TPPD_2` | real | YES |  |  |
| 64 | `Prem_TPPD_3` | real | YES |  |  |
| 65 | `SI_TPPD_Ans` | integer | YES |  |  |
| 66 | `SI_TPPD_Start` | timestamp(6) without time zone | YES |  |  |
| 67 | `SI_TPPD_End` | timestamp(6) without time zone | YES |  |  |
| 68 | `SI_TPPD_OIC_disct_perc` | numeric | YES |  |  |
| 69 | `SI_TPPD_Amt` | numeric | YES |  |  |
| 70 | `SI_MV01_1` | integer | YES |  |  |
| 71 | `SI_MV01_2` | integer | YES |  |  |
| 72 | `SI_MV01_3` | integer | YES |  |  |
| 73 | `Prem_MV01_1` | real | YES |  |  |
| 74 | `Prem_MV01_2` | real | YES |  |  |
| 75 | `Prem_MV01_3` | real | YES |  |  |
| 76 | `SI_MV01_Ans` | integer | YES |  |  |
| 77 | `SI_MV01_Start` | timestamp(6) without time zone | YES |  |  |
| 78 | `SI_MV01_End` | timestamp(6) without time zone | YES |  |  |
| 79 | `SI_MV01_OIC_disct_perc` | numeric | YES |  |  |
| 80 | `SI_MV01_Amt` | numeric | YES |  |  |
| 81 | `SI_MV02_1` | integer | YES |  |  |
| 82 | `SI_MV02_2` | integer | YES |  |  |
| 83 | `SI_MV02_3` | integer | YES |  |  |
| 84 | `Prem_MV02_1` | real | YES |  |  |
| 85 | `Prem_MV02_2` | real | YES |  |  |
| 86 | `Prem_MV02_3` | real | YES |  |  |
| 87 | `SI_MV02_Ans` | integer | YES |  |  |
| 88 | `SI_MV02_Start` | timestamp(6) without time zone | YES |  |  |
| 89 | `SI_MV02_End` | timestamp(6) without time zone | YES |  |  |
| 90 | `SI_MV02_OIC_disct_perc` | numeric | YES |  |  |
| 91 | `SI_MV02_Amt` | numeric | YES |  |  |
| 92 | `SI_MV03_1` | integer | YES |  |  |
| 93 | `SI_MV03_2` | integer | YES |  |  |
| 94 | `SI_MV03_3` | integer | YES |  |  |
| 95 | `Prem_MV03_1` | real | YES |  |  |
| 96 | `Prem_MV03_2` | real | YES |  |  |
| 97 | `Prem_MV03_3` | real | YES |  |  |
| 98 | `SI_MV03_Ans` | integer | YES |  |  |
| 99 | `SI_MV03_Start` | timestamp(6) without time zone | YES |  |  |
| 100 | `SI_MV03_End` | timestamp(6) without time zone | YES |  |  |
| 101 | `SI_MV03_OIC_disct_perc` | numeric | YES |  |  |
| 102 | `SI_MV03_Amt` | numeric | YES |  |  |
| 103 | `Sedan` | character varying(255) | YES |  |  |
| 104 | `CC` | character varying(255) | YES |  |  |
| 105 | `SI_Access_1` | integer | YES |  |  |
| 106 | `SI_Access_2` | integer | YES |  |  |
| 107 | `SI_Access_3` | integer | YES |  |  |
| 108 | `Prem_Access_1` | real | YES |  |  |
| 109 | `Prem_Access_2` | real | YES |  |  |
| 110 | `Prem_Access_3` | real | YES |  |  |
| 111 | `SI_Access_Ans` | integer | YES |  |  |
| 112 | `SI_Access_Start` | timestamp(6) without time zone | YES |  |  |
| 113 | `SI_Access_End` | timestamp(6) without time zone | YES |  |  |
| 114 | `SI_Access_OIC_disct_perc` | numeric | YES |  |  |
| 115 | `SI_Access_Amt` | numeric | YES |  |  |
| 116 | `Perm_BEF_Discount` | numeric(18,4) | YES |  |  |
| 117 | `Duty_BEF_Discout` | numeric(18,4) | YES |  |  |
| 118 | `Vat_BEF_Discout` | numeric(18,4) | YES |  |  |
| 119 | `Total_BEF_Discout` | numeric(18,4) | YES |  |  |
| 120 | `Discount` | numeric(18,4) | YES |  |  |
| 121 | `Perm_Amt` | numeric(18,4) | YES |  |  |
| 122 | `Duty_Amt` | numeric(18,4) | YES |  |  |
| 123 | `Vat_Amt` | numeric(18,4) | YES |  |  |
| 124 | `Total_Amt` | numeric(18,4) | YES |  |  |
| 125 | `Payment_status` | character varying(50) | YES |  |  |
| 126 | `Payment_channel` | character varying(50) | YES |  |  |
| 127 | `Payment_type` | character varying(50) | YES |  |  |
| 128 | `Payment_No` | character varying(50) | YES |  |  |
| 129 | `Payment_Ref1` | character varying(50) | YES |  |  |
| 130 | `Payment_Ref2` | character varying(50) | YES |  |  |
| 131 | `Payment_result` | character varying(50) | YES |  |  |
| 132 | `Recept_no` | character varying(50) | YES |  |  |
| 133 | `Tax_No` | character varying(50) | YES |  |  |
| 134 | `Flex_field1` | character varying(255) | YES |  |  |
| 135 | `Flex_field2` | character varying(255) | YES |  |  |
| 136 | `Flex_field3` | character varying(255) | YES |  |  |
| 137 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 138 | `Create_by` | character varying(50) | YES |  |  |
| 139 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 140 | `Update_by` | character varying(50) | YES |  |  |
| 141 | `Fleet_Disc_perc` | numeric | YES |  |  |
| 142 | `NCB_Disc_perc` | numeric | YES |  |  |
| 143 | `Other_Disc_perc` | numeric | YES |  |  |
| 144 | `Surcharge_Amt` | numeric | YES |  |  |
| 145 | `Total_Amt_exclude_mv` | numeric | YES |  |  |
| 146 | `Total_Amt_mv` | numeric | YES |  |  |
| 147 | `Flag_Car_Act` | character(1) | YES |  |  |
| 148 | `Flag_CCTV` | character(1) | YES |  |  |
| 149 | `Flag_Driver` | character(1) | YES |  |  |
| 150 | `Fleet_Disc_Amt` | numeric | YES |  |  |
| 151 | `NCB_Disc_Amt` | numeric | YES |  |  |
| 152 | `Other_Disc_Amt` | numeric | YES |  |  |
| 153 | `Total_Disc_Amt` | numeric | YES |  |  |
| 154 | `Lead_No` | integer | YES |  |  |
| 155 | `NamedAge_Amt` | numeric | YES |  |  |
| 156 | `SI_DD_1` | integer | YES |  |  |
| 157 | `SI_DD_2` | integer | YES |  |  |
| 158 | `SI_DD_3` | integer | YES |  |  |
| 159 | `Prem_DD_1` | real | YES |  |  |
| 160 | `Prem_DD_2` | real | YES |  |  |
| 161 | `Prem_DD_3` | real | YES |  |  |
| 162 | `SI_DD_Ans` | integer | YES |  |  |
| 163 | `SI_DD_Start` | timestamp(6) without time zone | YES |  |  |
| 164 | `SI_DD_End` | timestamp(6) without time zone | YES |  |  |
| 165 | `SI_DD_OIC_disct_perc` | numeric | YES |  |  |
| 166 | `SI_DD_Amt` | numeric | YES |  |  |
| 167 | `Flag_Access` | character(1) | YES |  |  |
| 168 | `Access_para_code` | character varying(255) | YES |  |  |
| 169 | `YOB_Driver_1` | character(4) | YES |  |  |
| 170 | `YOB_Driver_2` | character(4) | YES |  |  |
| 171 | `Payment_Date` | timestamp(6) without time zone | YES |  |  |
| 172 | `Basic_Premium` | numeric | YES |  |  |
| 173 | `Change_Perm_Amt` | numeric | YES |  |  |
| 174 | `Change_Duty_Amt` | numeric | YES |  |  |
| 175 | `Change_Vat_Amt` | numeric | YES |  |  |
| 176 | `Change_Total_Amt` | numeric | YES |  |  |
| 177 | `SI_Limit` | numeric | YES |  |  |
| 178 | `SI_TPBI_Limit` | numeric | YES |  |  |
| 179 | `SI_TPPD_Limit` | numeric | YES |  |  |
| 180 | `SI_MV01_Limit` | numeric | YES |  |  |
| 181 | `SI_MV02_Limit` | numeric | YES |  |  |
| 182 | `SI_MV03_Limit` | numeric | YES |  |  |
| 183 | `SI_Access_Limit` | numeric | YES |  |  |
| 184 | `sf_payment_prem` | character varying(50) | YES |  |  |
| 185 | `Prem_ACT` | real | YES |  |  |
| 186 | `SF_Lead` | character varying(255) | YES |  |  |
| 187 | `SI_DD_Limit` | numeric | YES |  |  |
| 188 | `CCTV` | integer | YES |  |  |
| 189 | `Driver_Discount` | numeric | YES |  |  |
| 190 | `premium_v5_od` | numeric | YES |  |  |
| 191 | `SF_Policy_id` | character varying(255) | YES |  |  |
| 192 | `promo_trans_id` | bigint | YES |  |  |
| 193 | `promo_discount_per` | numeric(10,4) | YES |  |  |
| 194 | `promo_discount_amt` | numeric(16,4) | YES |  |  |
| 195 | `cover_day_count` | smallint | YES |  |  |
| 196 | `driver_age` | smallint | YES |  |  |
| 197 | `extend_amt` | numeric(16,4) | YES |  |  |
| 198 | `SI_TPBI_E_Limit` | numeric | YES |  |  |
| 199 | `SI_TPBI_E_Amt` | numeric | YES |  |  |
| 200 | `basic_premium_v5` | numeric | YES |  |  |
| 201 | `cc_ans` | character varying(20) | YES |  |  |
| 202 | `par_prefix_name_1` | character varying(50) | YES |  |  |
| 203 | `par_first_name_1` | character varying(255) | YES |  |  |
| 204 | `par_last_name_1` | character varying(255) | YES |  |  |
| 205 | `par_birth_date_1` | date | YES |  |  |
| 206 | `par_citizen_id_1` | character varying(20) | YES |  |  |
| 207 | `par_driver_license_no_1` | character varying(20) | YES |  |  |
| 208 | `par_occupation_1` | character varying(255) | YES |  |  |
| 209 | `par_prefix_name_2` | character varying(50) | YES |  |  |
| 210 | `par_first_name_2` | character varying(255) | YES |  |  |
| 211 | `par_last_name_2` | character varying(255) | YES |  |  |
| 212 | `par_birth_date_2` | date | YES |  |  |
| 213 | `par_citizen_id_2` | character varying(20) | YES |  |  |
| 214 | `par_driver_license_no_2` | character varying(20) | YES |  |  |
| 215 | `par_occupation_2` | character varying(255) | YES |  |  |
| 216 | `par_prefix_name_3` | character varying(50) | YES |  |  |
| 217 | `par_first_name_3` | character varying(255) | YES |  |  |
| 218 | `par_last_name_3` | character varying(255) | YES |  |  |
| 219 | `par_birth_date_3` | date | YES |  |  |
| 220 | `par_citizen_id_3` | character varying(20) | YES |  |  |
| 221 | `par_driver_license_no_3` | character varying(20) | YES |  |  |
| 222 | `par_occupation_3` | character varying(255) | YES |  |  |
| 223 | `par_prefix_name_4` | character varying(50) | YES |  |  |
| 224 | `par_first_name_4` | character varying(255) | YES |  |  |
| 225 | `par_last_name_4` | character varying(255) | YES |  |  |
| 226 | `par_birth_date_4` | date | YES |  |  |
| 227 | `par_citizen_id_4` | character varying(20) | YES |  |  |
| 228 | `par_driver_license_no_4` | character varying(20) | YES |  |  |
| 229 | `par_occupation_4` | character varying(255) | YES |  |  |
| 230 | `par_prefix_name_5` | character varying(50) | YES |  |  |
| 231 | `par_first_name_5` | character varying(255) | YES |  |  |
| 232 | `par_last_name_5` | character varying(255) | YES |  |  |
| 233 | `par_birth_date_5` | date | YES |  |  |
| 234 | `par_citizen_id_5` | character varying(20) | YES |  |  |
| 235 | `par_driver_license_no_5` | character varying(20) | YES |  |  |
| 236 | `par_occupation_5` | character varying(255) | YES |  |  |
| 237 | `driver_behavior_1` | integer | YES |  |  |
| 238 | `driver_behavior_2` | integer | YES |  |  |
| 239 | `driver_behavior_3` | integer | YES |  |  |
| 240 | `driver_behavior_4` | integer | YES |  |  |
| 241 | `driver_behavior_5` | integer | YES |  |  |
| 242 | `driver_behavior_cal` | integer | YES |  |  |
| 243 | `driver_behavior_disc_perc` | real | YES |  |  |
| 244 | `driver_behavior_disc_amt` | numeric | YES |  |  |
| 245 | `car_price` | numeric | YES |  |  |
| 246 | `car_price_date` | date | YES |  |  |
| 247 | `sc_premium_amt_1` | real | YES |  |  |
| 248 | `sc_premium_amt_2` | real | YES |  |  |
| 249 | `sc_premium_amt_3` | real | YES |  |  |
| 250 | `sc_premium_amt_4` | real | YES |  |  |
| 251 | `sc_premium_amt_5` | real | YES |  |  |
| 252 | `sc_premium_amt_ans` | integer | YES |  |  |
| 253 | `prem_version` | smallint | YES |  |  |
| 254 | `oic_version` | character varying(20) | YES |  |  |
| 255 | `driver_behavior_consent_1` | boolean | YES |  |  |
| 256 | `driver_behavior_consent_2` | boolean | YES |  |  |
| 257 | `driver_behavior_consent_3` | boolean | YES |  |  |
| 258 | `driver_behavior_consent_4` | boolean | YES |  |  |
| 259 | `driver_behavior_consent_5` | boolean | YES |  |  |
| 260 | `par_occupation_code_1` | character varying(50) | YES |  |  |
| 261 | `par_occupation_code_2` | character varying(50) | YES |  |  |
| 262 | `par_occupation_code_3` | character varying(50) | YES |  |  |
| 263 | `par_occupation_code_4` | character varying(50) | YES |  |  |
| 264 | `par_occupation_code_5` | character varying(50) | YES |  |  |
| 265 | `sc_premium_amt` | numeric | YES |  |  |

**Primary key:** _none_

---

## Policy_email_confirm

`insurverse.Policy_email_confirm` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `Policy_No` | character varying(50) | YES |  | เลขกรมธรรม์สมัครใจ |
| 3 | `Car_Act_No` | character varying(50) | YES |  | เลขกรมธรรม์พรบ |
| 4 | `flag_confirm` | boolean | YES |  | true ยืนยัน, false ไม่ยินยอม |
| 5 | `created_at` | timestamp without time zone | NO | `now()` |  |
| 6 | `updated_at` | timestamp without time zone | NO | `now()` |  |
| 7 | `confirm_at` | timestamp without time zone | YES |  |  |
| 8 | `ref_id` | character varying(500) | YES |  | เลขอ้างอิง |
| 9 | `expired_at` | timestamp without time zone | YES |  | วันหมดอายุ |
| 10 | `SF_Policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 11 | `policy_ta_no` | character varying(50) | YES |  | เลขประกันเดินทาง |
| 12 | `policy_pa_no` | character varying(50) | YES |  | เลขประกันอุบัติเหตุ |
| 13 | `policy_home_no` | character varying(50) | YES |  | เลขประกันไฟไหม้ |

**Primary key:** `id` (Policy_email_confirm_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Car_Act_No` → Policy_Car_Act_Discount_Premium, `Policy_No` → Policy_Header, `policy_home_no` → policy_home_premium, `policy_pa_no` → policy_pa_premium, `policy_ta_no` → policy_ta_premium

**Indexes:**

- `Policy_email_confirm_pkey`: `CREATE UNIQUE INDEX "Policy_email_confirm_pkey" ON insurverse."Policy_email_confirm" USING btree (id)`

---

## Policy_endorse_detail

`insurverse.Policy_endorse_detail` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `Policy_No` | character varying(50) | YES |  |  |
| 3 | `Car_Act_No` | character varying(50) | YES |  | Ref. พรบ. |
| 4 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 5 | `doc_type` | character varying(500) | YES |  | ประเภทเอกสาร รย รยภ ปร |
| 6 | `SF_Policy_id` | character varying(255) | NO |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 7 | `Policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 8 | `Policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 9 | `Receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 10 | `Receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 11 | `SF_Epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 12 | `SF_Etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 13 | `debt_increase_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเพิ่มหนี้ PDF จาก I-NET |
| 14 | `debt_increase_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเพิ่มหนี้ PDF จาก I-NET |
| 15 | `debt_decrease_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบลดหนี้ PDF จาก I-NET |
| 16 | `debt_decrease_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบลดหนี้ PDF จาก I-NET |
| 17 | `Policy_book` | character varying(50) | YES |  |  |
| 18 | `Policy_Quatation_No` | character varying(50) | YES |  |  |
| 19 | `Policy_Invoice_No` | character varying(50) | YES |  |  |
| 20 | `effective_date` | timestamp without time zone | YES |  | วันที่บังคับใช้ |
| 21 | `prev_Policy_book` | character varying(50) | YES |  |  |
| 22 | `prev_Policy_Quatation_No` | character varying(50) | YES |  |  |
| 23 | `prev_Policy_Invoice_No` | character varying(50) | YES |  |  |
| 24 | `prev_SF_Policy_id` | character varying(255) | YES |  |  |
| 25 | `Change_Total_Amt` | numeric | YES |  | ส่วนต่างเบี้ยประกันรวม หลังการสลักหลัง |
| 26 | `cctv_action` | text | YES |  |  |
| 27 | `accessory_action` | text | YES |  |  |

**Primary key:** `id` (Policy_endorse_detail_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Car_Act_No` → Policy_Car_Act_Discount_Premium, `Policy_No` → Policy_Header

**Indexes:**

- `Policy_endorse_detail_pkey`: `CREATE UNIQUE INDEX "Policy_endorse_detail_pkey" ON insurverse."Policy_endorse_detail" USING btree (id)`

---

## SequelizeMeta

`insurverse.SequelizeMeta` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `name` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## Sys_Domain

`insurverse.Sys_Domain` · kind: table · est. rows: **10**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Dom_code` | character varying(50) | NO |  | รหัสกลุ่มตัวแปร |
| 2 | `Dom_name` | character varying(255) | YES |  | ชื่อกลุ่มตัวแปร |
| 3 | `Dom_desc` | text | YES |  | รายละเอียดกลุ่มตัวแปร |
| 4 | `Create_date` | timestamp without time zone | YES |  |  |
| 5 | `Create_by` | character varying(50) | YES |  |  |
| 6 | `Update_date` | timestamp without time zone | YES |  |  |
| 7 | `Update_by` | character varying(50) | YES |  |  |

**Primary key:** `Dom_code` (Sys_Domain_pkey)

**Indexes:**

- `Sys_Domain_pkey`: `CREATE UNIQUE INDEX "Sys_Domain_pkey" ON insurverse."Sys_Domain" USING btree ("Dom_code")`

---

## Sys_Sub_domain

`insurverse.Sys_Sub_domain` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Dom_code` | character varying(50) | NO |  | รหัสกลุ่มตัวแปร |
| 2 | `Sub_dom_code` | character varying(50) | NO |  | รหัสกลุ่มย่อยตัวแปร |
| 3 | `Sub_dom_name` | character varying(255) | YES |  | ชื่อกลุ่มย่อยตัวแปร |
| 4 | `Sub_dom_desc` | text | YES |  | รายละเอียดกลุ่มย่อยตัวแปร |
| 5 | `Create_date` | timestamp without time zone | YES |  |  |
| 6 | `Create_by` | character varying(50) | YES |  |  |
| 7 | `Update_date` | timestamp without time zone | YES |  |  |
| 8 | `Update_by` | character varying(50) | YES |  |  |

**Primary key:** `Dom_code,Sub_dom_code` (Sys_Sub_domain_pkey)

**Inferred references (naming convention, NOT enforced FK):** `Dom_code` → Sys_Domain

**Indexes:**

- `Sys_Sub_domain_pkey`: `CREATE UNIQUE INDEX "Sys_Sub_domain_pkey" ON insurverse."Sys_Sub_domain" USING btree ("Dom_code", "Sub_dom_code")`

---

## act

`insurverse.act` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `create_at` | timestamp without time zone | YES |  |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(255) | YES |  |  |
| 12 | `car_act_no` | character varying(255) | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `policy_no` → Policy_Header

---

## activity_type

`insurverse.activity_type` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.activity_type_id_seq'::regclass)` |  |
| 2 | `activity_type` | character varying(50) | NO |  |  |

**Primary key:** `id` (activity_type_pkey)

**Indexes:**

- `activity_type_pkey`: `CREATE UNIQUE INDEX activity_type_pkey ON insurverse.activity_type USING btree (id)`

---

## amlo_idnumber

`insurverse.amlo_idnumber` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ENTITY_ID` | character varying(255) | YES |  |  |
| 2 | `SYS_ID` | character varying(255) | YES |  |  |
| 3 | `ID_TYPE_CODE` | character varying(255) | YES |  |  |
| 4 | `ID_TYPE` | character varying(255) | YES |  |  |
| 5 | `ID_VALUE` | character varying(255) | YES |  |  |
| 6 | `ID_COUNTRY` | character varying(255) | YES |  |  |
| 7 | `ID_ISSUEDATE` | character varying(255) | YES |  |  |
| 8 | `ID_EXPIRYDATE` | character varying(255) | YES |  |  |
| 9 | `ID_ADDN_REF` | character varying(255) | YES |  |  |
| 10 | `SUB_ENTITY_ID` | character varying(255) | YES |  |  |
| 11 | `INFO_SOURCE` | character varying(255) | YES |  |  |
| 12 | `ORG_ID` | character varying(255) | YES |  |  |
| 13 | `BATCH_NO` | character varying(255) | YES |  |  |
| 14 | `BATCH_DATE` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## amlo_master

`insurverse.amlo_master` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ENTITY_ID` | character varying(255) | YES |  |  |
| 2 | `INFO_SOURCE` | character varying(255) | YES |  |  |
| 3 | `ENTITY_TYPE` | character varying(255) | YES |  |  |
| 4 | `BRIEF_NAME` | character varying(255) | YES |  |  |
| 5 | `GENDER` | character varying(255) | YES |  |  |
| 6 | `EXISTING_STATUS` | character varying(255) | YES |  |  |
| 7 | `BIRTH_PLACE` | character varying(255) | YES |  |  |
| 8 | `PROFILE_NOTES` | character varying | YES |  |  |
| 9 | `DATE_OF_BIRTH` | character varying(255) | YES |  |  |
| 10 | `DATE_OF_DEATH` | character varying(255) | YES |  |  |
| 11 | `ACTIVE_STATUS` | character varying(255) | YES |  |  |
| 12 | `COMP_CODE` | character varying(255) | YES |  |  |
| 13 | `DECEASED` | character varying(255) | YES |  |  |
| 14 | `HIGH_RISK_COUNTRY` | character varying(255) | YES |  |  |
| 15 | `HIGH_RISK_COUNTRY_SCORE` | character varying(255) | YES |  |  |
| 16 | `FALSE_POSITIVE` | character varying(255) | YES |  |  |
| 17 | `FALSE_POSITIVE_EXPIRY_DT` | character varying(255) | YES |  |  |
| 18 | `BATCH_NO` | character varying(255) | YES |  |  |
| 19 | `BATCH_DATE` | character varying(255) | YES |  |  |
| 20 | `APPROVAL_STATUS` | character varying(255) | YES |  |  |
| 21 | `RJ_REMARKS` | character varying(255) | YES |  |  |
| 22 | `APPROVED_BY` | character varying(255) | YES |  |  |
| 23 | `APPROVED_DT` | character varying(255) | YES |  |  |
| 24 | `APPROVED_TM` | character varying(255) | YES |  |  |
| 25 | `ACTION` | character varying(255) | YES |  |  |
| 26 | `LAST_UPDATE_DATE` | character varying(255) | YES |  |  |
| 27 | `STAMP_DTTM` | character varying(255) | YES |  |  |
| 28 | `USER_ID` | character varying(255) | YES |  |  |
| 29 | `MODE_MN` | character varying(255) | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `COMP_CODE` → company_detail

---

## amlo_name

`insurverse.amlo_name` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ENTITY_ID` | character varying(255) | YES |  |  |
| 2 | `SYS_ID` | character varying(255) | YES |  |  |
| 3 | `NAME_TYPE` | character varying(255) | YES |  |  |
| 4 | `FIRST_NAME` | character varying(255) | YES |  |  |
| 5 | `MIDDLE_NAME` | character varying(255) | YES |  |  |
| 6 | `SURNAME` | character varying(255) | YES |  |  |
| 7 | `SUFFIX` | character varying(255) | YES |  |  |
| 8 | `ENTITY_NAME` | character varying(255) | YES |  |  |
| 9 | `ENGLISH_NAME` | character varying | YES |  |  |
| 10 | `SINGLE_STRING_NAME` | character varying | YES |  |  |
| 11 | `ORIGINAL_SCRIPT_NAME` | character varying | YES |  |  |
| 12 | `FALSE_POSITIVE` | character varying | YES |  |  |
| 13 | `FALSE_POSITIVE_EXPIRY_DT` | character varying | YES |  |  |
| 14 | `APPROVAL_STATUS` | character varying(255) | YES |  |  |
| 15 | `SUB_ENTITY_ID` | character varying(255) | YES |  |  |
| 16 | `CATEGORY` | character varying(255) | YES |  |  |
| 17 | `HIGH_RISK_COUNTRY` | character varying(255) | YES |  |  |
| 18 | `HIGH_RISK_COUNTRY_SCORE` | character varying(255) | YES |  |  |
| 19 | `INFO_SOURCE` | character varying | YES |  |  |
| 20 | `ORG_ID` | character varying(255) | YES |  |  |
| 21 | `ACTION` | character varying(255) | YES |  |  |
| 22 | `ID_REF_NO` | character varying(255) | YES |  |  |
| 23 | `BATCH_NO` | character varying(255) | YES |  |  |
| 24 | `BATCH_DATE` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## api_flow_log

`insurverse.api_flow_log` · kind: table · est. rows: **83**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `flow_id` | uuid | NO |  |  |
| 3 | `step_name` | text | NO |  |  |
| 4 | `url` | text | NO |  |  |
| 5 | `method` | text | NO |  |  |
| 6 | `product_type` | text | NO |  |  |
| 7 | `request_data` | jsonb | YES |  |  |
| 8 | `response_data` | jsonb | YES |  |  |
| 9 | `status` | text | NO |  |  |
| 10 | `error_message` | text | YES |  |  |
| 11 | `lead_no` | text | YES |  |  |
| 12 | `invoice_no` | text | YES |  |  |
| 13 | `created_at` | timestamp without time zone | YES | `now()` |  |

**Primary key:** `id` (api_flow_log_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium

**Indexes:**

- `api_flow_log_pkey`: `CREATE UNIQUE INDEX api_flow_log_pkey ON insurverse.api_flow_log USING btree (id)`

---

## api_payload_logs

`insurverse.api_payload_logs` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `payment_id` | integer | YES |  |  |
| 3 | `ref_policy_no` | character varying(255) | YES |  |  |
| 4 | `lead_no` | character varying(255) | YES |  |  |
| 5 | `api_endpoint` | character varying(500) | YES |  |  |
| 6 | `request_payload` | jsonb | YES |  |  |
| 7 | `response_payload` | jsonb | YES |  |  |
| 8 | `status_code` | integer | YES |  |  |
| 9 | `duration_ms` | integer | YES |  |  |
| 10 | `error_message` | text | YES |  |  |
| 11 | `created_at` | timestamp without time zone | YES |  |  |
| 12 | `created_by` | character varying(100) | YES |  |  |
| 13 | `policy_no` | character varying(255) | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium, `payment_id` → payment, `policy_no` → Policy_Header, `ref_policy_no` → Policy_Header

---

## app_notification

`insurverse.app_notification` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `source` | character varying(50) | YES |  | sf หรืออื่นๆ เช่น app , pwa เป็นต้น |
| 2 | `noti_type` | character varying(50) | YES |  | p_get,p_used,p_expired,promo,new_pro |
| 3 | `mobile_phone` | character varying(32000) | YES |  | เฉพาะ SMS เบอร์โทร (JSON Array) |
| 4 | `account_id` | character varying(32000) | YES |  | เฉพาะ App/PWA sf_account (JSON Array) |
| 5 | `subject` | character varying(255) | YES |  | หัวข้อ |
| 6 | `message` | character varying(2000) | YES |  | รายละเอียด |
| 7 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(50) | YES |  |  |
| 9 | `update_date` | timestamp without time zone | YES |  |  |
| 10 | `update_by` | character varying(50) | YES |  |  |
| 11 | `app_noti_id` | bigint | NO |  | Running no. |
| 12 | `icon_type` | character varying(255) | YES |  | ประเภท icon แสดงผล info,danger,warning หรืออื่นๆ |
| 13 | `user_id` | character varying(36) | YES |  | key จาก user_sec |
| 14 | `flag_read` | boolean | YES | `false` | TRUE = อ่านแล้ว , FALSE = ยังไม่อ่าน |
| 15 | `flag_read_date` | timestamp without time zone | YES |  | เวลาที่กดอ่าน |
| 16 | `redirect_url` | character varying(500) | YES |  | สำหรับ URL Redirect |
| 17 | `image_url` | character varying(500) | YES |  | สำหรับแสดงรูปภาพ |
| 18 | `is_active` | boolean | YES | `true` |  |
| 19 | `noti_date` | timestamp without time zone | YES |  | เวลาแจ้งเตือนล่าสุด |

**Primary key:** _none_

---

## app_notification_token

`insurverse.app_notification_token` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `user_id` | character varying | NO |  |  |
| 2 | `noti_token` | character varying | YES |  |  |
| 3 | `create_at` | timestamp without time zone | YES |  |  |
| 4 | `update_at` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

---

## batch_jobs

`insurverse.batch_jobs` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `job_name` | character varying(255) | NO |  |  |
| 3 | `status` | character varying(20) | NO | `'PENDING'::character varying` |  |
| 4 | `metadata` | jsonb | YES |  |  |
| 5 | `error_message` | text | YES |  |  |
| 6 | `retry_count` | smallint | NO | `0` |  |
| 7 | `created_at` | timestamp with time zone | NO | `now()` |  |
| 8 | `created_by` | character varying(255) | NO | `'SYSTEM'::character varying` |  |
| 9 | `updated_at` | timestamp with time zone | NO | `now()` |  |
| 10 | `updated_by` | character varying(255) | NO | `'SYSTEM'::character varying` |  |

**Primary key:** `id` (batch_jobs_pkey)

**Indexes:**

- `batch_jobs_pkey`: `CREATE UNIQUE INDEX batch_jobs_pkey ON insurverse.batch_jobs USING btree (id)`
- `idx_batch_jobs_job_name_updated`: `CREATE INDEX idx_batch_jobs_job_name_updated ON insurverse.batch_jobs USING btree (job_name, updated_at DESC)`
- `idx_batch_jobs_status`: `CREATE INDEX idx_batch_jobs_status ON insurverse.batch_jobs USING btree (status)`

---

## batch_payment_errors

`insurverse.batch_payment_errors` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `renewal_payment_id` | integer | YES |  |  |
| 3 | `ref_policy_no` | character varying(255) | YES |  |  |
| 4 | `error_message` | text | YES |  |  |
| 5 | `created_at` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `ref_policy_no` → Policy_Header

---

## calculate_premium_job

`insurverse.calculate_premium_job` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `job_id` | character varying(500) | YES |  |  |
| 4 | `job_status` | integer | YES |  | 0=ยังไม่เริ่ม 1=กำลังทำงาน 2=ทำงานเสร็จสิ้น |

**Primary key:** `id` (log_calculate_premium_copy1_pkey)

**Indexes:**

- `log_calculate_premium_copy1_pkey`: `CREATE UNIQUE INDEX log_calculate_premium_copy1_pkey ON insurverse.calculate_premium_job USING btree (id)`

---

## callback_logs

`insurverse.callback_logs` · kind: table · est. rows: **115**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.callback_logs_id_seq'::regclass)` |  |
| 2 | `order_sn` | character varying(255) | NO |  |  |
| 3 | `item_id` | bigint | YES |  |  |
| 4 | `item_name` | character varying(255) | YES |  |  |
| 5 | `item_sku` | character varying(100) | YES |  |  |
| 6 | `model_sku` | character varying(100) | YES |  |  |
| 7 | `buyer_user_id` | bigint | YES |  |  |
| 8 | `buyer_username` | character varying(100) | YES |  |  |
| 9 | `order_status` | character varying(50) | YES |  |  |
| 10 | `total_amount` | numeric(12,2) | YES |  |  |
| 11 | `currency` | character varying(10) | YES |  |  |
| 12 | `recipient_name` | character varying(255) | YES |  |  |
| 13 | `recipient_phone` | character varying(50) | YES |  |  |
| 14 | `recipient_address` | text | YES |  |  |
| 15 | `raw_order_detail_data` | text | YES |  |  |
| 16 | `form_link` | character varying(255) | YES |  |  |
| 17 | `customer_phone` | character varying(50) | YES |  |  |
| 18 | `sms_status` | boolean | YES | `false` |  |
| 19 | `sms_content` | text | YES |  |  |
| 20 | `sms_recipients` | text | YES |  |  |
| 21 | `process_status` | character varying(50) | YES | `'pending'::character varying` |  |
| 22 | `created_at` | timestamp with time zone | NO |  |  |
| 23 | `updated_at` | timestamp with time zone | NO |  |  |
| 24 | `policy_no` | text | YES |  |  |
| 25 | `policy_status` | character varying(50) | YES | `'pending'::character varying` |  |
| 26 | `form_submission_id` | integer | YES |  |  |
| 27 | `ref_code` | text | YES |  |  |
| 28 | `expired_at` | timestamp with time zone | YES |  |  |
| 29 | `lead_no` | text | YES |  |  |
| 30 | `invoice_no` | character varying(255) | YES |  |  |

**Primary key:** `id` (callback_logs_pkey)

**Foreign keys:**

- `form_submission_id` → `insurverse.policy_form_submissions(id)` — callback_logs_form_submission_id_fkey

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium, `policy_no` → Policy_Header

**Constraints:**

- UNIQUE `callback_logs_order_sn_unique`: `UNIQUE (order_sn)`

**Indexes:**

- `callback_logs_order_sn_unique`: `CREATE UNIQUE INDEX callback_logs_order_sn_unique ON insurverse.callback_logs USING btree (order_sn)`
- `callback_logs_pkey`: `CREATE UNIQUE INDEX callback_logs_pkey ON insurverse.callback_logs USING btree (id)`
- `idx_callback_logs_expired_at`: `CREATE INDEX idx_callback_logs_expired_at ON insurverse.callback_logs USING btree (expired_at)`
- `idx_callback_logs_invoice_no`: `CREATE INDEX idx_callback_logs_invoice_no ON insurverse.callback_logs USING btree (invoice_no)`
- `idx_callback_logs_lead_no`: `CREATE INDEX idx_callback_logs_lead_no ON insurverse.callback_logs USING btree (lead_no)`
- `idx_callback_logs_order_sn`: `CREATE INDEX idx_callback_logs_order_sn ON insurverse.callback_logs USING btree (order_sn)`
- `idx_callback_logs_policy_no`: `CREATE INDEX idx_callback_logs_policy_no ON insurverse.callback_logs USING btree (policy_no)`
- `idx_callback_logs_policy_status`: `CREATE INDEX idx_callback_logs_policy_status ON insurverse.callback_logs USING btree (policy_status)`
- `idx_callback_logs_process_status`: `CREATE INDEX idx_callback_logs_process_status ON insurverse.callback_logs USING btree (process_status)`
- `idx_callback_logs_ref_code`: `CREATE INDEX idx_callback_logs_ref_code ON insurverse.callback_logs USING btree (ref_code)`
- `idx_callback_logs_ref_code_order_sn`: `CREATE INDEX idx_callback_logs_ref_code_order_sn ON insurverse.callback_logs USING btree (ref_code, order_sn)`
- `idx_callback_logs_sku`: `CREATE INDEX idx_callback_logs_sku ON insurverse.callback_logs USING btree (item_sku, model_sku)`
- `idx_callback_logs_sms_status`: `CREATE INDEX idx_callback_logs_sms_status ON insurverse.callback_logs USING btree (sms_status)`

---

## callback_logs_prod

`insurverse.callback_logs_prod` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `order_sn` | character varying(255) | YES |  |  |
| 3 | `item_id` | bigint | YES |  |  |
| 4 | `item_name` | character varying(255) | YES |  |  |
| 5 | `item_sku` | character varying(100) | YES |  |  |
| 6 | `model_sku` | character varying(100) | YES |  |  |
| 7 | `buyer_user_id` | bigint | YES |  |  |
| 8 | `buyer_username` | character varying(100) | YES |  |  |
| 9 | `order_status` | character varying(50) | YES |  |  |
| 10 | `total_amount` | numeric | YES |  |  |
| 11 | `currency` | character varying(10) | YES |  |  |
| 12 | `recipient_name` | character varying(255) | YES |  |  |
| 13 | `recipient_phone` | character varying(50) | YES |  |  |
| 14 | `recipient_address` | text | YES |  |  |
| 15 | `raw_order_detail_data` | text | YES |  |  |
| 16 | `form_link` | character varying(255) | YES |  |  |
| 17 | `customer_phone` | character varying(50) | YES |  |  |
| 18 | `sms_status` | boolean | YES |  |  |
| 19 | `sms_content` | text | YES |  |  |
| 20 | `sms_recipients` | text | YES |  |  |
| 21 | `process_status` | character varying(50) | YES |  |  |
| 22 | `created_at` | timestamp with time zone | YES |  |  |
| 23 | `updated_at` | timestamp with time zone | YES |  |  |
| 24 | `policy_no` | text | YES |  |  |
| 25 | `policy_status` | character varying(50) | YES |  |  |
| 26 | `form_submission_id` | integer | YES |  |  |
| 27 | `ref_code` | text | YES |  |  |
| 28 | `expired_at` | timestamp with time zone | YES |  |  |
| 29 | `lead_no` | text | YES |  |  |
| 30 | `invoice_no` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## carmodel

`insurverse.carmodel` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `year` | character varying(4) | YES |  |  |
| 2 | `make` | character varying(50) | YES |  |  |
| 3 | `model` | character varying(50) | YES |  |  |
| 4 | `body_styles` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## claim_request

`insurverse.claim_request` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `claim_request_id` | bigint | NO |  |  |
| 2 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 3 | `create_by` | character varying(50) | YES |  |  |
| 4 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `update_by` | character varying(50) | YES |  |  |
| 6 | `ref_notify_no` | character varying(20) | YES |  | เลขรับแจ้ง |
| 7 | `status` | character varying(50) | YES |  | New = รายการเปิดสลักหลัง รออัพเดตเอกสาร, Submit = เอกสารครบ พร้อมนำไปให้เจ้าหน้าที่ตรวจสอบ |
| 8 | `prb_number` | character varying(30) | YES |  | กรมธรรม์(พรบ.) |
| 9 | `acc_policy_no` | character varying(30) | YES |  | กรมธรรม์เลขที่ |
| 10 | `accident_date` | timestamp without time zone | YES |  | เวลาที่เกิดเหตุ |
| 11 | `accident_cause` | smallint | YES |  | เป็นฝ่ายประมาท (1=ผู้ขับขี่รถประกัน, 2=ผู้ขับขี่รถคู่กรณี, 3=ประมาททั้งสองฝ่าย, 4=รอสรุปผลคดี) |
| 12 | `request_phone` | character varying(20) | YES |  | เบอร์ผู้แจ้ง |
| 13 | `tp_phone` | character varying(20) | YES |  | เบอร์คู่กรณี |
| 14 | `accident_call_date` | timestamp without time zone | YES | `now()` | วันที่รับแจ้ง |
| 15 | `remark` | text | YES |  | หมายเหตุ |
| 16 | `source` | character varying(50) | YES |  | แหล่งที่มา Mobile App, PWA |
| 17 | `customer_type` | character varying(50) | YES |  | Guest , Login |
| 18 | `request_loc_lat` | numeric(16,6) | YES |  | สถานที่แจ้ง ละติจูด |
| 19 | `request_loc_long` | numeric(16,6) | YES |  | สถานที่แจ้ง ลองติจูด |
| 20 | `flag_injuryed` | boolean | YES |  | มีคนบาดเจ็บหรือไม่ |
| 21 | `flag_unable_driving` | boolean | YES |  | ไม่สามารถรถขับต่อได้หรือไม่ |
| 22 | `flag_at_incident` | boolean | YES |  | อยู่ในที่เกิดเหตุหรือไม่ |
| 23 | `sms_request_at` | timestamp without time zone | YES |  | วันที่เวลาส่ง sms ผู้แจ้งล่าสุด |
| 24 | `sms_tp_at` | timestamp without time zone | YES |  | วันที่เวลาส่ง sms คู่กรณีล่าสุด |

**Primary key:** `claim_request_id` (claim_header_pkey)

**Indexes:**

- `claim_header_pkey`: `CREATE UNIQUE INDEX claim_header_pkey ON insurverse.claim_request USING btree (claim_request_id)`

---

## claim_request_attach

`insurverse.claim_request_attach` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `file_id` | character varying(18) | YES |  |  |
| 2 | `name` | character varying(255) | NO |  |  |
| 3 | `content_type` | character varying(255) | YES |  |  |
| 4 | `description` | character varying(255) | YES |  |  |
| 5 | `body` | character varying(32000) | YES |  | Base64 |
| 6 | `case_id` | character varying(18) | YES |  |  |
| 7 | `claim_number` | character varying(80) | YES |  | Claim Unique ID |
| 8 | `e_claim_id` | character varying(80) | YES |  | Claim Coverage External ID |
| 9 | `surveyor_report_id` | character varying(20) | YES |  | Surveyor Report ID |
| 10 | `item_id` | character varying(30) | YES |  | เลข Unique ID ของรายการที่เสียหาย (Car, Injury, Asset) |
| 11 | `create_date` | timestamp without time zone | YES |  |  |
| 12 | `create_by` | character varying(50) | YES |  |  |
| 13 | `update_date` | timestamp without time zone | YES |  |  |
| 14 | `update_by` | character varying(50) | YES |  |  |
| 15 | `type` | character varying(255) | YES |  |  |
| 16 | `url` | character varying(500) | YES |  |  |
| 17 | `file_type` | character varying(50) | YES |  | ประเภทรูปภาพแบ่งตามหมวด ได้แก่ insured, place, asset1, tp, asset2 |
| 18 | `note_id` | character varying(18) | YES |  | เลข Unique ID ของรายการบันทึกข้อความ |
| 19 | `ref_notify_no` | character varying(20) | YES |  | เลขรับแจ้ง |
| 20 | `id` | integer | NO |  |  |
| 21 | `file_case_code` | character varying(50) | YES |  | insured,reason,car,tp,tp_car |

**Primary key:** `id` (claim_request_attach_pkey)

**Indexes:**

- `claim_request_attach_pkey`: `CREATE UNIQUE INDEX claim_request_attach_pkey ON insurverse.claim_request_attach USING btree (id)`

---

## company_detail

`insurverse.company_detail` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `comp_code` | character varying(50) | NO |  | ชื่อย่อบริษัท |
| 2 | `title_code` | character varying(50) | YES |  |  |
| 3 | `name` | character varying(50) | NO |  | ชื่อบริษัท |
| 4 | `mid_name` | character varying(50) | YES |  |  |
| 5 | `last_name` | character varying(50) | YES |  |  |
| 6 | `dob` | timestamp without time zone | YES |  |  |
| 7 | `addr_line1` | character varying(500) | YES |  |  |
| 8 | `addr_line2` | character varying(500) | YES |  |  |
| 9 | `addr_sub_distict` | character varying(50) | YES |  |  |
| 10 | `addr_distict` | character varying(50) | YES |  |  |
| 11 | `addr_province` | character varying(50) | YES |  |  |
| 12 | `addr_state` | character varying(50) | YES |  |  |
| 13 | `addr_postcode` | character varying(50) | YES |  |  |
| 14 | `addr_country` | character(10) | YES |  |  |
| 15 | `regist_id` | character varying(50) | YES |  | รหัสบริษัท |
| 16 | `tax_id` | character varying(50) | YES |  |  |
| 17 | `tel_ctry_code` | character varying(50) | YES |  |  |
| 18 | `tel_no` | character varying(50) | YES |  |  |
| 19 | `fax_no` | character varying(50) | YES |  |  |
| 20 | `email` | character varying(50) | YES |  |  |
| 21 | `facebook` | character varying(50) | YES |  |  |
| 22 | `line` | character varying(50) | YES |  |  |
| 23 | `contact_person` | character varying(50) | YES |  |  |
| 24 | `status` | character varying(50) | YES |  |  |
| 25 | `descripiton` | character varying(500) | YES |  |  |
| 26 | `path_img` | character varying(200) | YES |  |  |
| 27 | `home` | character varying(50) | YES |  |  |
| 28 | `create_date` | timestamp without time zone | YES |  |  |
| 29 | `create_user` | character varying(50) | YES |  |  |
| 30 | `update_date` | timestamp without time zone | YES |  |  |
| 31 | `update_user` | character varying(50) | YES |  |  |
| 32 | `branch_name` | character varying(255) | YES |  | ชื่อสาขา |

**Primary key:** `comp_code` (company_detail_pkey)

**Indexes:**

- `company_detail_pkey`: `CREATE UNIQUE INDEX company_detail_pkey ON insurverse.company_detail USING btree (comp_code)`

---

## consent_accept

`insurverse.consent_accept` · kind: table · est. rows: **3**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `identifier` | character varying | NO |  |  |
| 3 | `customer_id` | character varying | YES |  |  |
| 4 | `status` | insurverse.consent_accept_status_enum | NO | `'ACCEPTED'::insurverse.consent_accept_status_enum` |  |
| 5 | `accepted_date` | timestamp without time zone | YES |  |  |
| 6 | `rejected_date` | timestamp without time zone | YES |  |  |
| 7 | `created_at` | timestamp without time zone | NO | `now()` |  |
| 8 | `updated_at` | timestamp without time zone | NO | `now()` |  |
| 9 | `purposeId` | uuid | YES |  |  |

**Primary key:** `id` (PK_70744c395b6bda04d0ebc749da2)

**Indexes:**

- `IDX_70744c395b6bda04d0ebc749da`: `CREATE UNIQUE INDEX "IDX_70744c395b6bda04d0ebc749da" ON insurverse.consent_accept USING btree (id)`
- `IDX_badd5a05f48b9da7be663b31fb`: `CREATE INDEX "IDX_badd5a05f48b9da7be663b31fb" ON insurverse.consent_accept USING btree (identifier)`
- `IDX_consent_accept_identifier`: `CREATE INDEX "IDX_consent_accept_identifier" ON insurverse.consent_accept USING btree (identifier)`
- `IDX_d581f8dcb5ee3b33ed0f28beb2`: `CREATE INDEX "IDX_d581f8dcb5ee3b33ed0f28beb2" ON insurverse.consent_accept USING btree (status)`
- `IDX_ff36b94c6a483b9ec4b07bbf00`: `CREATE INDEX "IDX_ff36b94c6a483b9ec4b07bbf00" ON insurverse.consent_accept USING btree (customer_id)`
- `PK_70744c395b6bda04d0ebc749da2`: `CREATE UNIQUE INDEX "PK_70744c395b6bda04d0ebc749da2" ON insurverse.consent_accept USING btree (id)`

---

## consent_content

`insurverse.consent_content` · kind: table · est. rows: **15**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `name` | character varying | NO |  |  |
| 3 | `default` | boolean | NO |  |  |
| 4 | `active` | boolean | NO | `false` |  |
| 5 | `description` | text | NO |  |  |
| 6 | `language` | character varying(7) | NO |  |  |
| 7 | `created_at` | timestamp without time zone | NO | `now()` |  |
| 8 | `updated_at` | timestamp without time zone | NO | `now()` |  |
| 9 | `purposeId` | uuid | YES |  |  |

**Primary key:** `id` (PK_c7d7f1b1ecce6713b6ee56e18ef)

**Foreign keys:**

- `purposeId` → `insurverse.consent_purpose(id)` — FK_cd788b3c7101ff2e6ea304839d6

**Indexes:**

- `IDX_50da61caa698240c004c3f05e7`: `CREATE INDEX "IDX_50da61caa698240c004c3f05e7" ON insurverse.consent_content USING btree (name)`
- `IDX_c7d7f1b1ecce6713b6ee56e18e`: `CREATE UNIQUE INDEX "IDX_c7d7f1b1ecce6713b6ee56e18e" ON insurverse.consent_content USING btree (id)`
- `PK_c7d7f1b1ecce6713b6ee56e18ef`: `CREATE UNIQUE INDEX "PK_c7d7f1b1ecce6713b6ee56e18ef" ON insurverse.consent_content USING btree (id)`

---

## consent_marketing

`insurverse.consent_marketing` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `firstname` | character varying(100) | YES |  |  |
| 3 | `lastname` | character varying(100) | YES |  |  |
| 4 | `identity_card` | character varying(20) | YES |  |  |
| 5 | `identity_card_type` | character varying(20) | YES |  |  |
| 6 | `email` | character varying(100) | YES |  |  |
| 7 | `contact_number` | character varying(20) | YES |  |  |
| 8 | `consent_flag` | character varying(3) | YES |  |  |
| 9 | `consent_from` | character varying(50) | YES |  |  |
| 10 | `date_created` | timestamp without time zone | YES |  |  |
| 11 | `date_updated` | timestamp without time zone | YES |  |  |
| 12 | `update_from` | character varying(100) | YES |  |  |

**Primary key:** `id` (consent_marketing_pk)

**Indexes:**

- `consent_marketing_pk`: `CREATE UNIQUE INDEX consent_marketing_pk ON insurverse.consent_marketing USING btree (id)`

---

## consent_purpose

`insurverse.consent_purpose` · kind: table · est. rows: **10**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `name` | character varying | NO |  |  |
| 3 | `version` | double precision | NO | `'1'::double precision` |  |
| 4 | `required` | boolean | NO |  |  |
| 5 | `dataElements` | character varying | YES |  |  |
| 6 | `active` | boolean | NO | `false` |  |
| 7 | `active_start_date` | timestamp without time zone | YES |  |  |
| 8 | `active_end_date` | timestamp without time zone | YES |  |  |
| 9 | `retention_period_start_date` | timestamp without time zone | YES |  |  |
| 10 | `retention_period_end_date` | timestamp without time zone | YES |  |  |
| 11 | `tags` | character varying | YES |  |  |
| 12 | `created_at` | timestamp without time zone | NO | `now()` |  |
| 13 | `updated_at` | timestamp without time zone | NO | `now()` |  |

**Primary key:** `id` (PK_93bc4735bdbfeccd0afa1309096)

**Indexes:**

- `IDX_93bc4735bdbfeccd0afa130909`: `CREATE UNIQUE INDEX "IDX_93bc4735bdbfeccd0afa130909" ON insurverse.consent_purpose USING btree (id)`
- `PK_93bc4735bdbfeccd0afa1309096`: `CREATE UNIQUE INDEX "PK_93bc4735bdbfeccd0afa1309096" ON insurverse.consent_purpose USING btree (id)`

---

## consent_rop

`insurverse.consent_rop` · kind: table · est. rows: **103**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `consent_accept_id` | character varying | YES |  |  |
| 3 | `access_control` | character varying | YES |  |  |
| 4 | `dataElements` | character varying | YES |  |  |
| 5 | `rawDataElements` | character varying | YES |  |  |
| 6 | `identifier` | character varying | YES |  |  |
| 7 | `customer_id` | character varying | YES |  |  |
| 8 | `purpose_name` | character varying | YES |  |  |
| 9 | `version` | double precision | NO |  |  |
| 10 | `required` | boolean | YES |  |  |
| 11 | `active_start_date` | timestamp without time zone | YES |  |  |
| 12 | `active_end_date` | timestamp without time zone | YES |  |  |
| 13 | `retention_period_start_date` | timestamp without time zone | YES |  |  |
| 14 | `retention_period_end_date` | timestamp without time zone | YES |  |  |
| 15 | `description` | text | YES |  |  |
| 16 | `status` | character varying | YES |  |  |
| 17 | `accepted_date` | timestamp without time zone | YES |  |  |
| 18 | `rejected_date` | timestamp without time zone | YES |  |  |
| 19 | `created_at` | timestamp without time zone | YES |  |  |
| 20 | `updated_at` | timestamp without time zone | YES |  |  |
| 21 | `consent_rop_created_at` | timestamp without time zone | NO | `now()` |  |
| 22 | `consent_rop_updated_at` | timestamp without time zone | NO | `now()` |  |

**Primary key:** `id` (PK_a66cad742d34896335d028e7b77)

**Inferred references (naming convention, NOT enforced FK):** `consent_accept_id` → consent_accept

**Indexes:**

- `IDX_26041dcc056ef860fe1ec81e48`: `CREATE INDEX "IDX_26041dcc056ef860fe1ec81e48" ON insurverse.consent_rop USING btree (identifier)`
- `IDX_7018f30959ce57ed1960bcea74`: `CREATE INDEX "IDX_7018f30959ce57ed1960bcea74" ON insurverse.consent_rop USING btree (consent_accept_id)`
- `IDX_a66cad742d34896335d028e7b7`: `CREATE UNIQUE INDEX "IDX_a66cad742d34896335d028e7b7" ON insurverse.consent_rop USING btree (id)`
- `IDX_a6fc8596ba9c9247b906f68023`: `CREATE INDEX "IDX_a6fc8596ba9c9247b906f68023" ON insurverse.consent_rop USING btree (customer_id)`
- `PK_a66cad742d34896335d028e7b77`: `CREATE UNIQUE INDEX "PK_a66cad742d34896335d028e7b77" ON insurverse.consent_rop USING btree (id)`

---

## cs_impersonation

`insurverse.cs_impersonation` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | YES |  |  |
| 2 | `ref_token` | text | YES |  |  |
| 3 | `cs_user` | text | YES |  |  |
| 4 | `customer_id` | text | YES |  |  |
| 5 | `customer_email` | text | YES |  |  |
| 6 | `reason` | text | YES |  |  |
| 7 | `consumed` | boolean | YES |  |  |
| 8 | `consumed_at` | timestamp with time zone | YES |  |  |
| 9 | `expired_at` | timestamp with time zone | YES |  |  |
| 10 | `source_ip` | text | YES |  |  |
| 11 | `created_at` | timestamp with time zone | YES |  |  |

**Primary key:** _none_

---

## district

`insurverse.district` · kind: table · est. rows: **929**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `districtid` | integer | NO |  |  |
| 2 | `diprovince` | integer | YES |  |  |
| 3 | `dicode` | character(4) | YES |  |  |
| 4 | `diname` | character varying(150) | YES |  |  |
| 5 | `dinameen` | character varying(150) | YES |  |  |

**Primary key:** `districtid` (district_pkey)

**Indexes:**

- `district_pkey`: `CREATE UNIQUE INDEX district_pkey ON insurverse.district USING btree (districtid)`

---

## district_12sep67

`insurverse.district_12sep67` · kind: table · est. rows: **929** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `districtid` | integer | YES |  |  |
| 2 | `diprovince` | integer | YES |  |  |
| 3 | `dicode` | bpchar | YES |  |  |
| 4 | `diname` | character varying(150) | YES |  |  |
| 5 | `dinameen` | character varying(150) | YES |  |  |

**Primary key:** _none_

---

## district_add

`insurverse.district_add` · kind: table · est. rows: **980** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `districtid` | integer | YES |  |  |
| 2 | `diprovince` | integer | YES |  |  |
| 3 | `dicode` | bpchar | YES |  |  |
| 4 | `diname` | character varying(150) | YES |  |  |
| 5 | `dinameen` | character varying(150) | YES |  |  |

**Primary key:** _none_

---

## ekyc_ocr

`insurverse.ekyc_ocr` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | character varying(36) | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `side` | character varying(10) | YES |  |  |
| 3 | `id_number` | character varying(13) | YES |  |  |
| 4 | `name_th` | character varying(50) | YES |  |  |
| 5 | `first_name_en` | character varying(50) | YES |  |  |
| 6 | `last_name_en` | character varying(50) | YES |  |  |
| 7 | `date_of_birth_th` | character varying(50) | YES |  |  |
| 8 | `date_of_birth_en` | character varying(50) | YES |  |  |
| 9 | `religion_th` | character varying(50) | YES |  |  |
| 10 | `address_th` | character varying(100) | YES |  |  |
| 11 | `date_of_issue_th` | character varying(50) | YES |  |  |
| 12 | `date_of_issue_en` | character varying(50) | YES |  |  |
| 13 | `date_of_expiry_th` | character varying(50) | YES |  |  |
| 14 | `date_of_expiry_en` | character varying(50) | YES |  |  |
| 15 | `serial_number` | character varying(50) | YES |  |  |
| 16 | `trans_id` | character varying(50) | YES |  |  |
| 17 | `updated_at` | timestamp without time zone | YES | `now()` |  |
| 18 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 19 | `lead_group_type` | character varying(50) | YES |  | mv, mc, ta, pa, home |
| 20 | `lead_no` | integer | YES |  |  |
| 21 | `policy_group_type` | character varying(50) | YES |  | mv, mc, ta, pa, home |
| 22 | `policy_no` | character varying(50) | YES |  |  |
| 23 | `similarity` | numeric | YES |  |  |
| 24 | `face_recognition_at` | timestamp without time zone | YES |  |  |
| 25 | `ocr_url` | text | YES |  |  |
| 26 | `face_url` | text | YES |  |  |

**Primary key:** `id` (ekyc_ocr_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium, `policy_no` → Policy_Header

**Indexes:**

- `ekyc_ocr_pkey`: `CREATE UNIQUE INDEX ekyc_ocr_pkey ON insurverse.ekyc_ocr USING btree (id)`

---

## email_api_keys

`insurverse.email_api_keys` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `name` | character varying(255) | NO |  |  |
| 3 | `api_key` | character varying(255) | NO |  |  |
| 4 | `api_secret` | character varying(255) | NO |  |  |
| 5 | `webhook_url` | character varying(500) | YES |  |  |
| 6 | `is_active` | boolean | YES | `true` |  |
| 7 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 8 | `updated_at` | timestamp without time zone | YES | `now()` |  |

**Primary key:** `id` (email_api_keys_pkey)

**Constraints:**

- UNIQUE `email_api_keys_api_key_key`: `UNIQUE (api_key)`
- UNIQUE `unique_name`: `UNIQUE (name)`

**Indexes:**

- `email_api_keys_api_key_key`: `CREATE UNIQUE INDEX email_api_keys_api_key_key ON insurverse.email_api_keys USING btree (api_key)`
- `email_api_keys_pkey`: `CREATE UNIQUE INDEX email_api_keys_pkey ON insurverse.email_api_keys USING btree (id)`
- `unique_name`: `CREATE UNIQUE INDEX unique_name ON insurverse.email_api_keys USING btree (name)`

---

## email_logs

`insurverse.email_logs` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `email` | character varying(255) | NO |  |  |
| 3 | `first_name` | character varying(100) | YES |  |  |
| 4 | `last_name` | character varying(100) | YES |  |  |
| 5 | `phone` | character varying(20) | YES |  |  |
| 6 | `template_uuid` | uuid | NO |  |  |
| 7 | `subject` | character varying(255) | NO |  |  |
| 8 | `status` | character varying(20) | YES |  |  |
| 9 | `message_id` | character varying(255) | YES |  |  |
| 10 | `response_log` | text | YES |  |  |
| 11 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 12 | `updated_at` | timestamp without time zone | YES | `now()` |  |
| 13 | `api_key_id` | uuid | YES |  |  |

**Primary key:** `id` (email_logs_pkey)

**Foreign keys:**

- `api_key_id` → `insurverse.email_api_keys(id)` — fk_api_key

**Constraints:**

- CHECK `email_logs_status_check`: `CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('sent'::character varying)::text, ('failed'::character varying)::text, ('delivered'::character varying)::text])))`
- UNIQUE `email_logs_email_unique`: `UNIQUE (email)`
- UNIQUE `email_logs_message_id_key`: `UNIQUE (message_id)`

**Indexes:**

- `email_logs_email_unique`: `CREATE UNIQUE INDEX email_logs_email_unique ON insurverse.email_logs USING btree (email)`
- `email_logs_message_id_key`: `CREATE UNIQUE INDEX email_logs_message_id_key ON insurverse.email_logs USING btree (message_id)`
- `email_logs_pkey`: `CREATE UNIQUE INDEX email_logs_pkey ON insurverse.email_logs USING btree (id)`

---

## email_webhooks

`insurverse.email_webhooks` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `message_id` | character varying(255) | NO |  |  |
| 3 | `recipient` | character varying(255) | NO |  |  |
| 4 | `status` | character varying(20) | YES |  |  |
| 5 | `reason` | character varying(255) | YES |  |  |
| 6 | `click_url` | text | YES |  |  |
| 7 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 8 | `updated_at` | timestamp without time zone | YES | `now()` |  |

**Primary key:** `id` (email_webhooks_pkey)

**Foreign keys:**

- `message_id` → `insurverse.email_logs(message_id)` — fk_message_id

**Constraints:**

- CHECK `email_webhooks_status_check`: `CHECK (((status)::text = ANY (ARRAY[('delivered'::character varying)::text, ('failed'::character varying)::text, ('opened'::character varying)::text, ('clicked'::character varying)::text])))`

**Indexes:**

- `email_webhooks_pkey`: `CREATE UNIQUE INDEX email_webhooks_pkey ON insurverse.email_webhooks USING btree (id)`

---

## emcs_getimage_ar

`insurverse.emcs_getimage_ar` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `emcs_ar_id` | integer | NO |  |  |
| 2 | `claim_id` | character varying(20) | YES |  | หมายเลข e-Claim |
| 3 | `app_no` | smallint | YES |  | ลำดับครั้งที่อนุมัติ |
| 4 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `create_by` | character varying(50) | YES |  |  |
| 6 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `update_by` | character varying(50) | YES |  |  |
| 8 | `image_path_url` | character varying(500) | YES |  | url รูปภาพ |
| 9 | `sf_file_id` | character varying(50) | YES |  | SF file ID |

**Primary key:** `emcs_ar_id` (emcs_getimage_ar_pkey)

**Indexes:**

- `emcs_getimage_ar_pkey`: `CREATE UNIQUE INDEX emcs_getimage_ar_pkey ON insurverse.emcs_getimage_ar USING btree (emcs_ar_id)`

---

## emcs_getimage_detail

`insurverse.emcs_getimage_detail` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  | Primary key |
| 2 | `claim_id` | character varying(20) | YES |  | หมายเลข e-Claim |
| 3 | `im_id` | integer | YES |  | รหัสรูป |
| 4 | `image_desc` | character varying(255) | YES |  | คําอธบายรูป |
| 5 | `image_path` | character varying(255) | YES |  | ชื่อไฟล์รูปภาพ |
| 6 | `add_no` | integer | YES |  | ลำดับครั้งที่อนุมัติ |
| 7 | `image_type` | smallint | YES |  | ประเภทรูป |
| 8 | `by_when` | timestamp without time zone | YES |  | วันที่ทำรายการ |
| 9 | `by_whom` | integer | YES |  | รหัสผู้แนบรูป |
| 10 | `car_iden_no` | smallint | YES |  | รถคันที่เกิดอุบัติเหตุ |
| 11 | `ref_claim_no` | character varying(21) | YES |  | เลขเคลม |
| 12 | `sequence_id` | integer | YES |  | ลำดับการขอใช้ WS |
| 13 | `cross_result` | character varying(1) | YES |  | ผลการรับข้อมูล |
| 14 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 15 | `create_by` | character varying(50) | YES |  |  |
| 16 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 17 | `update_by` | character varying(50) | YES |  |  |
| 18 | `image_path_url` | character varying(500) | YES |  | url รูปภาพ |
| 19 | `sf_file_id` | character varying(50) | YES |  | SF file ID |
| 20 | `cross_result_at` | timestamp without time zone | YES |  | เวลาที่ส่งผลการรับข้อมูล |

**Primary key:** `id` (emcs_getimage_detail_pkey)

**Indexes:**

- `emcs_getimage_detail_pkey`: `CREATE UNIQUE INDEX emcs_getimage_detail_pkey ON insurverse.emcs_getimage_detail USING btree (id)`

---

## hbdisv_event

`insurverse.hbdisv_event` · kind: table · est. rows: **0**

> table keep track on hbdisv event 2025 to give free mc

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `policy_no` | text | YES |  |  |
| 3 | `request_body` | text | YES |  |  |
| 4 | `response_body` | text | YES |  |  |
| 5 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 6 | `last_updated` | timestamp without time zone | YES | `now()` |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

---

## iia_commission

`insurverse.iia_commission` · kind: table · est. rows: **0**

> Commission table for IIA system

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  | Primary key - auto increment |
| 2 | `agn1groupno` | integer | YES | `1` | Agent group number - default = 1 |
| 3 | `agn1brcode` | character varying(10) | YES | `'000'::character varying` | Agent branch code - default = 000 |
| 4 | `agn1entityid` | integer | YES |  | Agent entity ID - TQM UAT=6028, PROD=63345 |
| 5 | `agn1code` | character varying(20) | YES |  | Agent code - TQM UAT=B6028, PROD=B63345 |
| 6 | `agn1level` | character(1) | YES | `'B'::bpchar` | Agent level - TQM = B |
| 7 | `agn1masterflag` | character(1) | YES | `'Y'::bpchar` | Agent master flag - TQM = Y |
| 8 | `agncommrate1` | numeric(5,2) | YES |  | Agent commission rate (%) - TQM com-rate |
| 9 | `agnshare1` | integer | YES | `100` | Agent share - TQM = 100 |
| 10 | `customergroupid` | integer | YES |  | Customer group ID - TQM UAT=8, PROD=22 |
| 11 | `outletcode` | character varying(10) | YES | `'08'::character varying` | Outlet code - TQM = 08 |
| 12 | `departmentid` | integer | YES |  | Department ID |
| 13 | `ovtype1` | integer | YES | `6` | Override type - TQM = 6 |
| 14 | `description1` | character varying(255) | YES |  | Description field |
| 15 | `adjcommrate1` | numeric(5,2) | YES |  | Adjusted commission rate (%) - TQM adjust com-rate |
| 16 | `aobrcode` | character varying(10) | YES | `'000'::character varying` | AO branch code - default = 000 |
| 17 | `aoentityid` | integer | YES |  | AO entity ID - TQM UAT=13, PROD=60257 |
| 18 | `agn1groupbrcode` | character varying(10) | YES | `'000'::character varying` | Agent group branch code - TQM = 000 |
| 19 | `agn1groupid` | integer | YES |  | Agent group ID - TQM group id |
| 20 | `partner_code` | character varying(50) | YES |  | Partner code - e.g., TQM |
| 21 | `policy_type` | character varying(50) | YES |  | MC,MV |
| 22 | `created_date` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` | Record creation date |
| 23 | `updated_date` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` | Record last update date |
| 24 | `created_by` | character varying(50) | YES |  | User who created the record |
| 25 | `updated_by` | character varying(50) | YES |  | User who last updated the record |

**Primary key:** `id` (iia_commission_pkey)

**Inferred references (naming convention, NOT enforced FK):** `partner_code` → mas_partner

**Constraints:**

- CHECK `chk_adjcommrate1`: `CHECK (((adjcommrate1 >= (0)::numeric) AND (adjcommrate1 <= (100)::numeric)))`
- CHECK `chk_agn1level`: `CHECK ((agn1level = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar])))`
- CHECK `chk_agn1masterflag`: `CHECK ((agn1masterflag = ANY (ARRAY['Y'::bpchar, 'N'::bpchar])))`
- CHECK `chk_agncommrate1`: `CHECK (((agncommrate1 >= (0)::numeric) AND (agncommrate1 <= (100)::numeric)))`

**Indexes:**

- `idx_iia_commission_agn1code`: `CREATE INDEX idx_iia_commission_agn1code ON insurverse.iia_commission USING btree (agn1code)`
- `idx_iia_commission_agn1entityid`: `CREATE INDEX idx_iia_commission_agn1entityid ON insurverse.iia_commission USING btree (agn1entityid)`
- `idx_iia_commission_created_date`: `CREATE INDEX idx_iia_commission_created_date ON insurverse.iia_commission USING btree (created_date)`
- `idx_iia_commission_customergroupid`: `CREATE INDEX idx_iia_commission_customergroupid ON insurverse.iia_commission USING btree (customergroupid)`
- `idx_iia_commission_partner_code`: `CREATE INDEX idx_iia_commission_partner_code ON insurverse.iia_commission USING btree (partner_code)`
- `iia_commission_pkey`: `CREATE UNIQUE INDEX iia_commission_pkey ON insurverse.iia_commission USING btree (id)`

**Triggers:** `update_iia_commission_updated_date` → `insurverse.update_updated_date_column()`

---

## iia_data_sr_claim_motor_movement

`insurverse.iia_data_sr_claim_motor_movement` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `txid` | integer | YES |  |  |
| 2 | `txbrcode` | character varying(3) | YES |  |  |
| 3 | `claimno` | character varying(20) | NO |  |  |
| 4 | `approvedate` | date | NO |  |  |
| 5 | `estimateno` | integer | NO |  |  |
| 6 | `notifyno` | character varying(20) | YES |  |  |
| 7 | `lossdate` | date | YES |  |  |
| 8 | `losstime` | character varying(8) | YES |  |  |
| 9 | `notifydate` | date | YES |  |  |
| 10 | `notifytime` | character varying(8) | YES |  |  |
| 11 | `notifyusercode` | character varying(10) | YES |  |  |
| 12 | `informname` | character varying(100) | YES |  |  |
| 13 | `informtelno` | character varying(30) | YES |  |  |
| 14 | `informdate` | date | YES |  |  |
| 15 | `informtime` | character varying(8) | YES |  |  |
| 16 | `customergroupid` | integer | YES |  |  |
| 17 | `claimusercode` | character varying(10) | YES |  |  |
| 18 | `cdfpolicyno` | character varying(20) | YES |  |  |
| 19 | `vdfpolicyno` | character varying(20) | YES |  |  |
| 20 | `poltxbrcode` | character varying(3) | YES |  |  |
| 21 | `poltxid` | integer | YES |  |  |
| 22 | `dfpolicyno` | character varying(20) | YES |  |  |
| 23 | `subclass` | character varying(3) | YES |  |  |
| 24 | `effectivedate` | date | YES |  |  |
| 25 | `outletcode` | character varying(3) | YES |  |  |
| 26 | `loss_province` | character varying(30) | YES |  |  |
| 27 | `loss_amphur` | character varying(30) | YES |  |  |
| 28 | `causeofloss` | character varying(100) | YES |  |  |
| 29 | `t_place` | character varying(50) | YES |  |  |
| 30 | `t_soi` | character varying(30) | YES |  |  |
| 31 | `t_road` | character varying(50) | YES |  |  |
| 32 | `place` | character varying(250) | YES |  |  |
| 33 | `insurednameli` | character varying(100) | YES |  |  |
| 34 | `drivername` | character varying(100) | YES |  |  |
| 35 | `licenseno` | character varying(10) | YES |  |  |
| 36 | `brand` | character varying(20) | YES |  |  |
| 37 | `model` | character varying(30) | YES |  |  |
| 38 | `chassisno` | character varying(30) | YES |  |  |
| 39 | `contacttype` | character varying(150) | YES |  |  |
| 40 | `servicetype` | character varying(24) | YES |  |  |
| 41 | `closedate` | date | YES |  |  |
| 42 | `responsibility` | character varying(150) | YES |  |  |
| 43 | `status` | character varying(2) | YES |  |  |
| 44 | `claim_name` | character varying(100) | YES |  |  |
| 45 | `sex` | character varying(1) | YES |  |  |
| 46 | `birthday` | date | YES |  |  |
| 47 | `cestloss` | numeric(21,6) | YES |  |  |
| 48 | `vestloss` | numeric(21,6) | YES |  |  |
| 49 | `estdeduct` | numeric(21,6) | YES |  |  |
| 50 | `vestsurveyfee` | numeric(21,6) | YES |  |  |
| 51 | `vesthandfee` | numeric(21,6) | YES |  |  |
| 52 | `loaddate` | timestamp without time zone | YES |  |  |
| 53 | `rectype` | character varying(50) | NO |  |  |
| 54 | `receivedd` | numeric(13,6) | YES | `0` |  |
| 55 | `receivedsalvage` | numeric(13,6) | YES | `0` |  |
| 56 | `receivedrecov` | numeric(13,6) | YES | `0` |  |
| 57 | `groupcode` | integer | YES |  |  |

**Primary key:** `approvedate,claimno,rectype,estimateno` (iia_data_sr_claim_motor_movement_pk)

**Inferred references (naming convention, NOT enforced FK):** `dfpolicyno` → iia_data_sr_policy_daily_lastversion, `groupcode` → sec_group

**Indexes:**

- `idx_iia_claim_motor_movement_loaddate`: `CREATE INDEX idx_iia_claim_motor_movement_loaddate ON insurverse.iia_data_sr_claim_motor_movement USING btree (loaddate)`
- `iia_data_sr_claim_motor_movement_pk`: `CREATE UNIQUE INDEX iia_data_sr_claim_motor_movement_pk ON insurverse.iia_data_sr_claim_motor_movement USING btree (approvedate, claimno, rectype, estimateno)`

---

## iia_data_sr_claim_motor_movement_allocate_expense

`insurverse.iia_data_sr_claim_motor_movement_allocate_expense` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `rectype` | character varying(20) | NO |  |  |
| 2 | `txid` | integer | YES |  |  |
| 3 | `txbrcode` | character varying(10) | YES |  |  |
| 4 | `claimno` | character varying(50) | NO |  |  |
| 5 | `approvedate` | date | NO |  |  |
| 6 | `estimateno` | integer | NO |  |  |
| 7 | `notifyno` | character varying(50) | YES |  |  |
| 8 | `lossdate` | date | YES |  |  |
| 9 | `losstime` | character varying(8) | YES |  |  |
| 10 | `notifydate` | date | YES |  |  |
| 11 | `notifytime` | character varying(8) | YES |  |  |
| 12 | `notifyusercode` | character varying(50) | YES |  |  |
| 13 | `informname` | character varying(255) | YES |  |  |
| 14 | `informtelno` | character varying(30) | YES |  |  |
| 15 | `informdate` | date | YES |  |  |
| 16 | `informtime` | character varying(8) | YES |  |  |
| 17 | `customergroupid` | integer | YES |  |  |
| 18 | `claimusercode` | character varying(50) | YES |  |  |
| 19 | `cdfpolicyno` | character varying(50) | YES |  |  |
| 20 | `vdfpolicyno` | character varying(50) | YES |  |  |
| 21 | `poltxbrcode` | character varying(10) | YES |  |  |
| 22 | `poltxid` | integer | YES |  |  |
| 23 | `dfpolicyno` | character varying(50) | YES |  |  |
| 24 | `subclass` | character varying(10) | YES |  |  |
| 25 | `effectivedate` | date | YES |  |  |
| 26 | `outletcode` | character varying(20) | YES |  |  |
| 27 | `loss_province` | character varying(255) | YES |  |  |
| 28 | `loss_amphur` | character varying(255) | YES |  |  |
| 29 | `causeofloss` | text | YES |  |  |
| 30 | `t_place` | character varying(255) | YES |  |  |
| 31 | `t_soi` | character varying(255) | YES |  |  |
| 32 | `t_road` | character varying(255) | YES |  |  |
| 33 | `place` | character varying(255) | YES |  |  |
| 34 | `insurednameli` | character varying(255) | YES |  |  |
| 35 | `drivername` | character varying(255) | YES |  |  |
| 36 | `licenseno` | character varying(50) | YES |  |  |
| 37 | `brand` | character varying(100) | YES |  |  |
| 38 | `model` | character varying(100) | YES |  |  |
| 39 | `chassisno` | character varying(50) | YES |  |  |
| 40 | `contacttype` | character varying(100) | YES |  |  |
| 41 | `servicetype` | character varying(100) | YES |  |  |
| 42 | `closedate` | date | YES |  |  |
| 43 | `responsibility` | character varying(100) | YES |  |  |
| 44 | `status` | character varying(10) | YES |  |  |
| 45 | `claim_name` | character varying(255) | YES |  |  |
| 46 | `sex` | character varying(5) | YES |  |  |
| 47 | `birthday` | date | YES |  |  |
| 48 | `cestloss` | numeric(18,6) | YES |  |  |
| 49 | `vestloss` | numeric(18,6) | YES |  |  |
| 50 | `estdeduct` | numeric(18,6) | YES |  |  |
| 51 | `vestsurveyfee` | numeric(18,6) | YES |  |  |
| 52 | `vesthandfee` | numeric(18,6) | YES |  |  |
| 53 | `received_dd` | numeric(18,6) | YES |  |  |
| 54 | `received_salvage` | numeric(18,6) | YES |  |  |
| 55 | `received_recov` | numeric(18,6) | YES |  |  |
| 56 | `estimated_towing` | numeric(18,6) | YES |  |  |
| 57 | `estimated_od_labor` | numeric(18,6) | YES |  |  |
| 58 | `estimated_od_spare` | numeric(18,6) | YES |  |  |
| 59 | `estimated_od_ry` | numeric(18,6) | YES |  |  |
| 60 | `estimated_excess_od` | numeric(18,6) | YES |  |  |
| 61 | `estimated_surveyfee` | numeric(18,6) | YES |  |  |
| 62 | `estimated_fire_and_theft` | numeric(18,6) | YES |  |  |
| 63 | `estimated_stolencar` | numeric(18,6) | YES |  |  |
| 64 | `estimated_damage` | numeric(18,6) | YES |  |  |
| 65 | `estimated_salvage` | numeric(18,6) | YES |  |  |
| 66 | `injuredflag` | character varying(1) | YES |  |  |
| 67 | `estimated_tppd` | numeric(18,6) | YES |  |  |
| 68 | `estimated_tppd_labor` | numeric(18,6) | YES |  |  |
| 69 | `estimated_tppd_spare` | numeric(18,6) | YES |  |  |
| 70 | `estimated_tppd_other` | numeric(18,6) | YES |  |  |
| 71 | `estimated_tpbi` | numeric(18,6) | YES |  |  |
| 72 | `totalloss` | character varying(1) | YES |  |  |
| 73 | `kfk_ck` | character varying(50) | YES |  |  |
| 74 | `groupcode` | integer | YES |  |  |
| 75 | `loaddate` | timestamp without time zone | YES |  |  |

**Primary key:** `approvedate,claimno,estimateno,rectype` (pk_iia_claim_motor_movement_allocate_expense)

**Inferred references (naming convention, NOT enforced FK):** `dfpolicyno` → iia_data_sr_policy_daily_lastversion, `groupcode` → sec_group

**Indexes:**

- `idx_iia_claim_motor_movement_alloc_exp_loaddate`: `CREATE INDEX idx_iia_claim_motor_movement_alloc_exp_loaddate ON insurverse.iia_data_sr_claim_motor_movement_allocate_expense USING btree (loaddate)`
- `pk_iia_claim_motor_movement_allocate_expense`: `CREATE UNIQUE INDEX pk_iia_claim_motor_movement_allocate_expense ON insurverse.iia_data_sr_claim_motor_movement_allocate_expense USING btree (approvedate, claimno, estimateno, rectype)`

---

## iia_data_sr_claim_nonmotor_movement

`insurverse.iia_data_sr_claim_nonmotor_movement` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `dfpolicyno` | character varying(20) | YES |  |  |
| 2 | `dfclaimno` | character varying(20) | NO |  |  |
| 3 | `claimdate` | date | YES |  |  |
| 4 | `notifyno` | character varying(20) | YES |  |  |
| 5 | `lossdate` | date | YES |  |  |
| 6 | `losstime` | character varying(8) | YES |  |  |
| 7 | `notifydate` | date | YES |  |  |
| 8 | `notifytime` | character varying(8) | YES |  |  |
| 9 | `notifyusercode` | character varying(10) | YES |  |  |
| 10 | `informedby` | character varying(255) | YES |  |  |
| 11 | `informeddate` | date | YES |  |  |
| 12 | `informedtime` | character varying(8) | YES |  |  |
| 13 | `assigneeusercode` | character varying(10) | YES |  |  |
| 14 | `t_lossplace` | character varying(50) | YES |  |  |
| 15 | `causeofloss` | character varying(100) | YES |  |  |
| 16 | `loss_province` | character varying(30) | YES |  |  |
| 17 | `loss_amphur` | character varying(30) | YES |  |  |
| 18 | `status` | character varying(2) | YES |  |  |
| 19 | `insuranceclass` | character varying(2) | YES |  |  |
| 20 | `subclass` | character varying(3) | YES |  |  |
| 21 | `dname` | character varying(100) | YES |  |  |
| 22 | `customergroupid` | integer | YES |  |  |
| 23 | `projcode` | character varying(10) | YES |  |  |
| 24 | `approvedate` | date | NO |  |  |
| 25 | `estimateno` | integer | NO |  |  |
| 26 | `bhtloss` | numeric(21,6) | YES |  |  |
| 27 | `bhtfee` | numeric(21,6) | YES |  |  |
| 28 | `bhtsalvage` | numeric(21,6) | YES |  |  |
| 29 | `birthday` | date | YES |  |  |
| 30 | `claim_name_sex` | character varying(1) | YES |  |  |
| 31 | `claim_name_birthday` | date | YES |  |  |
| 32 | `claim_hospital` | character varying(100) | YES |  |  |
| 33 | `disease` | character varying(100) | YES |  |  |
| 34 | `loaddate` | timestamp without time zone | YES |  |  |

**Primary key:** `approvedate,dfclaimno,estimateno` (iia_data_sr_claim_nonmotor_movement_pk)

**Inferred references (naming convention, NOT enforced FK):** `dfpolicyno` → iia_data_sr_policy_daily_lastversion

**Indexes:**

- `iia_data_sr_claim_nonmotor_movement_pk`: `CREATE UNIQUE INDEX iia_data_sr_claim_nonmotor_movement_pk ON insurverse.iia_data_sr_claim_nonmotor_movement USING btree (approvedate, dfclaimno, estimateno)`

---

## iia_data_sr_motor_claim_lastversion

`insurverse.iia_data_sr_motor_claim_lastversion` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `txid` | integer | YES |  |  |
| 2 | `txbrcode` | character varying(3) | YES |  |  |
| 3 | `claimno` | character varying(20) | NO |  |  |
| 4 | `approvedate` | date | YES |  |  |
| 5 | `notifyno` | character varying(20) | YES |  |  |
| 6 | `lossdate` | date | YES |  |  |
| 7 | `notifydate` | date | YES |  |  |
| 8 | `notifyusercode` | character varying(10) | YES |  |  |
| 9 | `informname` | character varying(100) | YES |  |  |
| 10 | `informtelno` | character varying(30) | YES |  |  |
| 11 | `informdate` | date | YES |  |  |
| 12 | `informtime` | character varying(8) | YES |  |  |
| 13 | `customergroupid` | integer | YES |  |  |
| 14 | `poltxbrcode` | character varying(3) | YES |  |  |
| 15 | `poltxid` | integer | YES |  |  |
| 16 | `dfpolicyno` | character varying(20) | YES |  |  |
| 17 | `subclass` | character varying(3) | YES |  |  |
| 18 | `effectivedate` | date | YES |  |  |
| 19 | `outletcode` | character varying(3) | YES |  |  |
| 20 | `causeofloss` | character varying(100) | YES |  |  |
| 21 | `t_place` | character varying(50) | YES |  |  |
| 22 | `t_soi` | character varying(30) | YES |  |  |
| 23 | `t_road` | character varying(50) | YES |  |  |
| 24 | `place` | character varying(250) | YES |  |  |
| 25 | `insuredname` | character varying(100) | YES |  |  |
| 26 | `drivername` | character varying(100) | YES |  |  |
| 27 | `licenseno` | character varying(10) | YES |  |  |
| 28 | `brand` | character varying(20) | YES |  |  |
| 29 | `model` | character varying(30) | YES |  |  |
| 30 | `contacttype` | character varying(150) | YES |  |  |
| 31 | `servicetype` | character varying(24) | YES |  |  |
| 32 | `responsibility` | character varying(150) | YES |  |  |
| 33 | `status` | character varying(2) | YES |  |  |
| 34 | `claim_name` | character varying(100) | YES |  |  |
| 35 | `insure_telno` | character varying(25) | YES |  |  |
| 36 | `sex` | character varying(1) | YES |  |  |
| 37 | `birthday` | date | YES |  |  |
| 38 | `cestloss` | numeric(20,6) | YES |  |  |
| 39 | `vestloss` | numeric(20,6) | YES |  |  |
| 40 | `estdeduct` | numeric(20,6) | YES |  |  |
| 41 | `vestsurveyfee` | numeric(20,6) | YES |  |  |
| 42 | `vesthandfee` | numeric(20,6) | YES |  |  |
| 43 | `estimated_od` | numeric(32,6) | YES |  |  |
| 44 | `estimated_ft` | numeric(32,6) | YES |  |  |
| 45 | `estimated_tppd` | numeric(32,6) | YES |  |  |
| 46 | `estimated_tpbi` | numeric(32,6) | YES |  |  |
| 47 | `settle_closs` | numeric(32,6) | YES |  |  |
| 48 | `settle_vloss` | numeric(32,6) | YES |  |  |
| 49 | `settle_vsurvey` | numeric(32,6) | YES |  |  |
| 50 | `settle_vhandfee` | numeric(32,6) | YES |  |  |
| 51 | `received_deduct` | numeric(32,6) | YES |  |  |
| 52 | `received_recov` | double precision | YES |  |  |
| 53 | `loaddate` | timestamp(6) without time zone | YES |  |  |
| 54 | `groupcode` | integer | YES |  |  |

**Primary key:** `claimno` (iia_data_sr_motor_claim_lastversion_pkey)

**Inferred references (naming convention, NOT enforced FK):** `dfpolicyno` → iia_data_sr_policy_daily_lastversion, `groupcode` → sec_group

**Indexes:**

- `iia_data_sr_motor_claim_lastversion_pkey`: `CREATE UNIQUE INDEX iia_data_sr_motor_claim_lastversion_pkey ON insurverse.iia_data_sr_motor_claim_lastversion USING btree (claimno)`

---

## iia_data_sr_nonmotor_claim_lastversion

`insurverse.iia_data_sr_nonmotor_claim_lastversion` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `dfpolicyno` | character varying(20) | YES |  |  |
| 2 | `dfclaimno` | character varying(20) | NO |  |  |
| 3 | `c_destription` | character varying(255) | YES |  |  |
| 4 | `claimdate` | date | YES |  |  |
| 5 | `nofifyno` | character varying(20) | YES |  |  |
| 6 | `lossdate` | date | YES |  |  |
| 7 | `losstime` | character varying(8) | YES |  |  |
| 8 | `notifydate` | date | YES |  |  |
| 9 | `notifytime` | character varying(8) | YES |  |  |
| 10 | `notifyusercode` | character varying(10) | YES |  |  |
| 11 | `informedby` | character varying(255) | YES |  |  |
| 12 | `informeddate` | date | YES |  |  |
| 13 | `informedtime` | character varying(8) | YES |  |  |
| 14 | `assigneeusercode` | character varying(10) | YES |  |  |
| 15 | `t_lossplace` | character varying(50) | YES |  |  |
| 16 | `causeofloss` | character varying(100) | YES |  |  |
| 17 | `loss_province` | character varying(30) | YES |  |  |
| 18 | `loss_amphur` | character varying(30) | YES |  |  |
| 19 | `status` | character varying(2) | YES |  |  |
| 20 | `insuranceclass` | character varying(2) | YES |  |  |
| 21 | `subclass` | character varying(3) | YES |  |  |
| 22 | `dname` | character varying(100) | YES |  |  |
| 23 | `customergroupid` | integer | YES |  |  |
| 24 | `projcode` | character varying(10) | YES |  |  |
| 25 | `birthday` | date | YES |  |  |
| 26 | `sex` | character varying(1) | YES |  |  |
| 27 | `approvedate` | date | YES |  |  |
| 28 | `estimateno` | integer | YES |  |  |
| 29 | `estoss` | numeric(20,6) | YES |  |  |
| 30 | `estfee` | numeric(20,6) | YES |  |  |
| 31 | `estsalvage` | numeric(20,6) | YES |  |  |
| 32 | `settle_net` | numeric(32,6) | YES |  |  |
| 33 | `claim_name_sex` | character varying(1) | YES |  |  |
| 34 | `claim_name_birthday` | date | YES |  |  |
| 35 | `claim_hospital` | character varying(100) | YES |  |  |
| 36 | `disease` | character varying(100) | YES |  |  |
| 37 | `loaddate` | timestamp without time zone | YES | `now()` |  |
| 38 | `id` | integer | NO | `nextval('insurverse.iia_data_sr_nonmotor_claim_lastversion_id_seq'::regclass)` |  |

**Primary key:** `id` (iia_data_sr_nonmotor_claim_lastversion_pkey)

**Inferred references (naming convention, NOT enforced FK):** `dfpolicyno` → iia_data_sr_policy_daily_lastversion

**Constraints:**

- UNIQUE `unique_dfclaimno`: `UNIQUE (dfclaimno)`

**Indexes:**

- `iia_data_sr_nonmotor_claim_lastversion_pkey`: `CREATE UNIQUE INDEX iia_data_sr_nonmotor_claim_lastversion_pkey ON insurverse.iia_data_sr_nonmotor_claim_lastversion USING btree (id)`
- `unique_dfclaimno`: `CREATE UNIQUE INDEX unique_dfclaimno ON insurverse.iia_data_sr_nonmotor_claim_lastversion USING btree (dfclaimno)`

---

## iia_data_sr_policy_daily

`insurverse.iia_data_sr_policy_daily` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `txbrcode` | character varying(50) | NO |  |  |
| 2 | `reportdate` | date | NO |  |  |
| 3 | `effdate` | date | YES |  |  |
| 4 | `expdate` | date | YES |  |  |
| 5 | `class` | character varying(50) | YES |  |  |
| 6 | `subclass` | character varying(50) | YES |  |  |
| 7 | `outletcode` | character varying(50) | YES |  |  |
| 8 | `dfpolicyno` | character varying(50) | NO |  |  |
| 9 | `projcode_jared` | character varying(50) | YES |  |  |
| 10 | `projname` | character varying(50) | YES |  |  |
| 11 | `projcode_jupc` | character varying(50) | YES |  |  |
| 12 | `insuredname` | character varying(100) | YES |  |  |
| 13 | `department` | character varying(150) | YES |  |  |
| 14 | `accountowner` | character varying(100) | YES |  |  |
| 15 | `customergroupid_jare` | integer | YES |  |  |
| 16 | `custgroupname_jare` | character varying(150) | YES |  |  |
| 17 | `customergroupid_jupc` | integer | YES |  |  |
| 18 | `customergroupname_jupc` | character varying(150) | YES |  |  |
| 19 | `previouspolicyno` | character varying(50) | YES |  |  |
| 20 | `endorseseries` | integer | NO |  |  |
| 21 | `policystatus` | character varying(50) | YES |  |  |
| 22 | `originator_original` | character varying(50) | YES |  |  |
| 23 | `max_endorseseries` | integer | YES |  |  |
| 24 | `max_txid` | integer | YES |  |  |
| 25 | `max_txbrcode` | character varying(50) | YES |  |  |
| 26 | `originator_updated` | character varying(50) | YES |  |  |
| 27 | `originator_1` | character varying(80) | YES |  |  |
| 28 | `originator_2` | character varying(80) | YES |  |  |
| 29 | `updated_reportdate` | date | YES |  |  |
| 30 | `contact_fastname` | character varying(200) | YES |  |  |
| 31 | `contact_lastname` | character varying(50) | YES |  |  |
| 32 | `motorclass` | character varying(50) | YES |  |  |
| 33 | `typeofinsurance` | character varying(50) | YES |  |  |
| 34 | `licenseno` | character varying(50) | YES |  |  |
| 35 | `chassisno` | character varying(30) | YES |  |  |
| 36 | `engineno` | character varying(30) | YES |  |  |
| 37 | `compulsorycode` | character varying(50) | YES |  |  |
| 38 | `newvoluntarycode` | character varying(50) | YES |  |  |
| 39 | `t_brand` | character varying(50) | YES |  |  |
| 40 | `t_model` | character varying(50) | YES |  |  |
| 41 | `licensecode_jare` | character varying(50) | YES |  |  |
| 42 | `agentcode_jare` | character varying(50) | YES |  |  |
| 43 | `agentname` | character varying(100) | YES |  |  |
| 44 | `rprefdate` | date | YES |  |  |
| 45 | `suminsure` | double precision | YES |  |  |
| 46 | `dfgpremium` | double precision | YES |  |  |
| 47 | `std_comm` | numeric(32,6) | YES |  |  |
| 48 | `ov_comm` | numeric(32,6) | YES |  |  |
| 49 | `noc` | numeric(50,0) | YES |  |  |
| 50 | `incurredloss` | numeric(32,6) | YES |  |  |
| 51 | `advisorcode` | character varying(50) | YES |  |  |
| 52 | `advisorname1` | character varying(100) | YES |  |  |
| 53 | `advisorname2` | character varying(100) | YES |  |  |
| 54 | `advisorname3` | character varying(100) | YES |  |  |
| 55 | `ta_destination_th` | character varying(255) | YES |  |  |
| 56 | `ta_destination_en` | character varying(255) | YES |  |  |
| 57 | `ta_objective_th` | character varying(255) | YES |  |  |
| 58 | `ta_objective_en` | character varying(255) | YES |  |  |
| 59 | `risk_code` | character varying(50) | YES |  |  |
| 60 | `occupancy` | character varying(100) | YES |  |  |
| 61 | `countperson` | numeric(32,0) | YES |  |  |
| 62 | `type_of_navy` | character varying(50) | YES |  |  |
| 63 | `motor_registeryear` | character varying(50) | YES |  |  |
| 64 | `birthday` | character varying(129) | YES |  |  |
| 65 | `sex` | character varying(50) | YES |  |  |
| 66 | `agentteam_adjust` | character varying(50) | YES |  |  |
| 67 | `channel_agent` | character varying(50) | YES |  |  |
| 68 | `agent_adjust_code` | character varying(50) | YES |  |  |
| 69 | `agent_type_sales` | character varying(50) | YES |  |  |
| 70 | `agent_adjust_name` | character varying(100) | YES |  |  |
| 71 | `originator_3` | character varying(80) | YES |  |  |
| 72 | `originator_4` | character varying(80) | YES |  |  |
| 73 | `originator_5` | character varying(80) | YES |  |  |
| 74 | `originator_6` | character varying(80) | YES |  |  |
| 75 | `outletname` | character varying(50) | YES |  |  |
| 76 | `firstpolicyno` | character varying(20) | YES |  |  |
| 77 | `firstpolicy_effective` | date | YES |  |  |
| 78 | `province_address` | character varying(50) | YES |  |  |
| 79 | `entity_insurename` | character varying(50) | YES |  |  |
| 80 | `tax` | double precision | YES |  |  |
| 81 | `duty` | double precision | YES |  |  |
| 82 | `commamt` | double precision | YES |  |  |
| 83 | `commrate` | numeric(50,4) | YES |  |  |
| 84 | `age` | numeric(50,0) | YES |  |  |
| 85 | `ed_t_title` | character varying(255) | YES |  |  |
| 86 | `ed_date` | date | YES |  |  |
| 87 | `ed_effectivedate` | date | YES |  |  |
| 88 | `ed_expirydate` | date | YES |  |  |
| 89 | `loaddate` | timestamp(6) without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 90 | `motor_province` | character varying(100) | YES |  |  |
| 91 | `groupcode` | integer | YES |  |  |

**Primary key:** `reportdate,dfpolicyno,endorseseries` (iia_data_sr_policy_daily_pkey)

**Inferred references (naming convention, NOT enforced FK):** `dfpolicyno` → iia_data_sr_policy_daily_lastversion, `groupcode` → sec_group

**Indexes:**

- `iia_data_sr_policy_daily_pkey`: `CREATE UNIQUE INDEX iia_data_sr_policy_daily_pkey ON insurverse.iia_data_sr_policy_daily USING btree (reportdate, dfpolicyno, endorseseries)`

---

## iia_data_sr_policy_daily_lastversion

`insurverse.iia_data_sr_policy_daily_lastversion` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `reportdate_issued` | date | YES |  |  |
| 2 | `dfpolicyno` | character varying(20) | NO |  |  |
| 3 | `new_renew` | character varying(5) | YES |  |  |
| 4 | `previouspolicyno` | character varying(20) | YES |  |  |
| 5 | `policystatus` | character varying(2) | YES |  |  |
| 6 | `insurancestatus` | character varying(2) | YES |  |  |
| 7 | `effectivedate` | date | YES |  |  |
| 8 | `expirydate` | date | YES |  |  |
| 9 | `trans_date` | date | YES |  |  |
| 10 | `bordereauxdate` | date | YES |  |  |
| 11 | `insuranceclass` | character varying(2) | YES |  |  |
| 12 | `subclass` | character varying(3) | YES |  |  |
| 13 | `customergroupid` | integer | YES |  |  |
| 14 | `lv_1` | character varying(50) | YES |  |  |
| 15 | `lv_2` | character varying(50) | YES |  |  |
| 16 | `lv_3` | character varying(50) | YES |  |  |
| 17 | `lv_4` | character varying(50) | YES |  |  |
| 18 | `lv_5` | character varying(50) | YES |  |  |
| 19 | `lv_6` | character varying(50) | YES |  |  |
| 20 | `departmentid` | integer | YES |  |  |
| 21 | `depname` | character varying(255) | YES |  |  |
| 22 | `projcode` | character varying(10) | YES |  |  |
| 23 | `projname` | character varying(50) | YES |  |  |
| 24 | `insure_name` | character varying(100) | YES |  |  |
| 25 | `polsuminsure` | numeric(20,6) | YES |  |  |
| 26 | `polnetgrossprem` | numeric(20,6) | YES |  |  |
| 27 | `poltax` | numeric(20,6) | YES |  |  |
| 28 | `polduty` | numeric(20,6) | YES |  |  |
| 29 | `poltotalprem` | numeric(20,6) | YES |  |  |
| 30 | `licenseno` | character varying(10) | YES |  |  |
| 31 | `chasissno` | character varying(30) | YES |  |  |
| 32 | `compulsorycode` | character varying(5) | YES |  |  |
| 33 | `voluntarycode` | character varying(5) | YES |  |  |
| 34 | `typeofinsurance` | character varying(2) | YES |  |  |
| 35 | `typeofnavy` | character varying(6) | YES |  |  |
| 36 | `motor_class` | character varying(1) | YES |  |  |
| 37 | `motor_package` | character varying(255) | YES |  |  |
| 38 | `loaddate` | timestamp(6) without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 39 | `covertpbiperson` | numeric(20,6) | YES |  |  |
| 40 | `covertpbiacc` | numeric(20,6) | YES |  |  |
| 41 | `covertppd` | numeric(20,6) | YES |  |  |
| 42 | `covermv01dv1` | numeric(20,6) | YES |  |  |
| 43 | `covermv01pg1` | numeric(20,6) | YES |  |  |
| 44 | `covermv03` | numeric(20,6) | YES |  |  |
| 45 | `mv02noperson` | integer | YES |  |  |
| 46 | `province_address` | character varying(100) | YES |  |  |
| 47 | `motor_province` | character varying(100) | YES |  |  |
| 48 | `originator1` | character varying(100) | YES |  |  |
| 49 | `originator2` | character varying(100) | YES |  |  |
| 50 | `originator3` | character varying(100) | YES |  |  |
| 51 | `originator4` | character varying(100) | YES |  |  |
| 52 | `originator5` | character varying(100) | YES |  |  |
| 53 | `originator6` | character varying(100) | YES |  |  |
| 54 | `brand` | character varying(50) | YES |  |  |
| 55 | `model` | character varying(50) | YES |  |  |
| 56 | `ta_destination_th` | character varying(150) | YES |  |  |
| 57 | `ta_destination_en` | character varying(150) | YES |  |  |
| 58 | `ta_objective_th` | character varying(150) | YES |  |  |
| 59 | `ta_objective_en` | character varying(150) | YES |  |  |
| 60 | `rprefdate` | timestamp(6) without time zone | YES |  |  |
| 61 | `registeryear` | character varying(4) | YES |  |  |
| 62 | `groupcode` | integer | YES |  |  |

**Primary key:** `dfpolicyno` (iia_data_sr_policy_daily_lastversion_pkey)

**Inferred references (naming convention, NOT enforced FK):** `groupcode` → sec_group

**Indexes:**

- `iia_data_sr_policy_daily_lastversion_pkey`: `CREATE UNIQUE INDEX iia_data_sr_policy_daily_lastversion_pkey ON insurverse.iia_data_sr_policy_daily_lastversion USING btree (dfpolicyno)`

---

## imp_discount_premium

`insurverse.imp_discount_premium` · kind: table · est. rows: **41,969**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `brand` | character varying(255) | YES |  |  |
| 2 | `model` | character varying(255) | YES |  |  |
| 3 | `year` | character varying(255) | YES |  |  |
| 4 | `doors` | smallint | YES |  |  |
| 5 | `seat` | smallint | YES |  |  |
| 6 | `wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `type` | smallint | YES |  |  |
| 9 | `sedan` | character varying(255) | YES |  |  |
| 10 | `bodytype` | character varying(255) | YES |  |  |
| 11 | `start_date` | timestamp without time zone | YES |  |  |
| 12 | `end_date` | timestamp without time zone | YES |  |  |
| 13 | `create_date` | timestamp without time zone | YES |  |  |
| 14 | `create_by` | character varying(50) | YES |  |  |
| 15 | `update_date` | timestamp without time zone | YES |  |  |
| 16 | `update_by` | character varying(50) | YES |  |  |
| 17 | `comp_code` | character varying(50) | YES |  |  |
| 18 | `premium` | numeric | YES |  |  |
| 19 | `discount` | numeric | YES |  |  |
| 20 | `net_premium` | numeric | YES |  |  |
| 21 | `stamp` | numeric | YES |  |  |
| 22 | `vat` | numeric | YES |  |  |
| 23 | `total` | numeric | YES |  |  |
| 24 | `coverage_years` | integer | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `comp_code` → company_detail

---

## imp_discount_premium_020925

`insurverse.imp_discount_premium_020925` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp without time zone | YES |  |  |
| 12 | `End_date` | timestamp without time zone | YES |  |  |
| 13 | `Create_date` | timestamp without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |

**Primary key:** _none_

---

## imp_discount_premium_040226

`insurverse.imp_discount_premium_040226` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp without time zone | YES |  |  |
| 12 | `End_date` | timestamp without time zone | YES |  |  |
| 13 | `Create_date` | timestamp without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |

**Primary key:** _none_

---

## imp_discount_premium_160226

`insurverse.imp_discount_premium_160226` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp without time zone | YES |  |  |
| 12 | `End_date` | timestamp without time zone | YES |  |  |
| 13 | `Create_date` | timestamp without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |

**Primary key:** _none_

---

## imp_discount_premium_20260703

`insurverse.imp_discount_premium_20260703` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp without time zone | YES |  |  |
| 12 | `End_date` | timestamp without time zone | YES |  |  |
| 13 | `Create_date` | timestamp without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |
| 24 | `coverage_years` | smallint | YES |  |  |

**Primary key:** _none_

---

## imp_discount_premium_20260727

`insurverse.imp_discount_premium_20260727` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 12 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 13 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |

**Primary key:** _none_

---

## imp_discount_premium_20260806

`insurverse.imp_discount_premium_20260806` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 12 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 13 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |

**Primary key:** _none_

---

## imp_discount_premium_20260810

`insurverse.imp_discount_premium_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 12 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 13 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |

**Primary key:** _none_

---

## imp_discount_premium_20260820

`insurverse.imp_discount_premium_20260820` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Type` | smallint | YES |  |  |
| 9 | `Sedan` | character varying(255) | YES |  |  |
| 10 | `BodyType` | character varying(255) | YES |  |  |
| 11 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 12 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 13 | `Create_date` | timestamp(6) without time zone | YES |  |  |
| 14 | `Create_by` | character varying(50) | YES |  |  |
| 15 | `Update_date` | timestamp(6) without time zone | YES |  |  |
| 16 | `Update_by` | character varying(50) | YES |  |  |
| 17 | `Comp_Code` | character varying(50) | YES |  |  |
| 18 | `Premium` | numeric | YES |  |  |
| 19 | `Discount` | numeric | YES |  |  |
| 20 | `Net_Premium` | numeric | YES |  |  |
| 21 | `Stamp` | numeric | YES |  |  |
| 22 | `Vat` | numeric | YES |  |  |
| 23 | `Total` | numeric | YES |  |  |

**Primary key:** _none_

---

## imp_price_premium_020925

`insurverse.imp_price_premium_020925` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp without time zone | YES |  |  |
| 70 | `End_date` | timestamp without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |

**Primary key:** _none_

---

## imp_price_premium_040226

`insurverse.imp_price_premium_040226` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp without time zone | YES |  |  |
| 70 | `End_date` | timestamp without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |
| 73 | `driver_behavior` | integer | YES |  |  |
| 74 | `sc_prem_amt_1` | real | YES |  |  |
| 75 | `sc_prem_amt_2` | real | YES |  |  |
| 76 | `sc_prem_amt_3` | real | YES |  |  |
| 77 | `sc_prem_amt_4` | real | YES |  |  |
| 78 | `sc_prem_amt_5` | real | YES |  |  |
| 79 | `is_active` | boolean | YES |  |  |
| 80 | `version` | integer | YES |  |  |

**Primary key:** _none_

---

## imp_price_premium_160226

`insurverse.imp_price_premium_160226` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp without time zone | YES |  |  |
| 70 | `End_date` | timestamp without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |
| 73 | `driver_behavior` | integer | YES |  |  |
| 74 | `sc_prem_amt_1` | real | YES |  |  |
| 75 | `sc_prem_amt_2` | real | YES |  |  |
| 76 | `sc_prem_amt_3` | real | YES |  |  |
| 77 | `sc_prem_amt_4` | real | YES |  |  |
| 78 | `sc_prem_amt_5` | real | YES |  |  |
| 79 | `is_active` | boolean | YES |  |  |
| 80 | `version` | integer | YES |  |  |

**Primary key:** _none_

---

## imp_price_premium_20260806

`insurverse.imp_price_premium_20260806` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 70 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |
| 73 | `driver_behavior` | integer | YES |  |  |
| 74 | `sc_prem_amt_1` | real | YES |  |  |
| 75 | `sc_prem_amt_2` | real | YES |  |  |
| 76 | `sc_prem_amt_3` | real | YES |  |  |
| 77 | `sc_prem_amt_4` | real | YES |  |  |
| 78 | `sc_prem_amt_5` | real | YES |  |  |
| 79 | `is_active` | boolean | YES |  |  |
| 80 | `version` | integer | YES |  |  |

**Primary key:** _none_

---

## imp_price_premium_20260810

`insurverse.imp_price_premium_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 70 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |
| 73 | `driver_behavior` | integer | YES |  |  |
| 74 | `sc_prem_amt_1` | real | YES |  |  |
| 75 | `sc_prem_amt_2` | real | YES |  |  |
| 76 | `sc_prem_amt_3` | real | YES |  |  |
| 77 | `sc_prem_amt_4` | real | YES |  |  |
| 78 | `sc_prem_amt_5` | real | YES |  |  |
| 79 | `is_active` | boolean | YES |  |  |
| 80 | `version` | integer | YES |  |  |

**Primary key:** _none_

---

## imp_price_premium_20260820

`insurverse.imp_price_premium_20260820` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 70 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |
| 73 | `driver_behavior` | integer | YES |  |  |
| 74 | `sc_prem_amt_1` | real | YES |  |  |
| 75 | `sc_prem_amt_2` | real | YES |  |  |
| 76 | `sc_prem_amt_3` | real | YES |  |  |
| 77 | `sc_prem_amt_4` | real | YES |  |  |
| 78 | `sc_prem_amt_5` | real | YES |  |  |
| 79 | `is_active` | boolean | YES |  |  |
| 80 | `version` | integer | YES |  |  |

**Primary key:** _none_

---

## imp_price_premium_bk_20260727

`insurverse.imp_price_premium_bk_20260727` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `Brand` | character varying(255) | YES |  |  |
| 2 | `Model` | character varying(255) | YES |  |  |
| 3 | `Year` | character varying(255) | YES |  |  |
| 4 | `Doors` | smallint | YES |  |  |
| 5 | `Seat` | smallint | YES |  |  |
| 6 | `Wg` | integer | YES |  |  |
| 7 | `Group` | character varying(255) | YES |  |  |
| 8 | `Usage` | smallint | YES |  |  |
| 9 | `Type` | character varying(5) | YES |  |  |
| 10 | `GarageType` | character varying(2) | YES |  |  |
| 11 | `NamedAge` | character varying(255) | YES |  |  |
| 12 | `MinSI` | integer | YES |  |  |
| 13 | `MaxSI` | integer | YES |  |  |
| 14 | `Split` | integer | YES |  |  |
| 15 | `SI_1` | integer | YES |  |  |
| 16 | `SI_2` | integer | YES |  |  |
| 17 | `SI_3` | integer | YES |  |  |
| 18 | `SI_4` | integer | YES |  |  |
| 19 | `SI_5` | integer | YES |  |  |
| 20 | `Prem_OD_1` | real | YES |  |  |
| 21 | `Prem_OD_2` | real | YES |  |  |
| 22 | `Prem_OD_3` | real | YES |  |  |
| 23 | `Prem_OD_4` | real | YES |  |  |
| 24 | `Prem_OD_5` | real | YES |  |  |
| 25 | `Prem_FT_1` | real | YES |  |  |
| 26 | `Prem_FT_2` | real | YES |  |  |
| 27 | `Prem_FT_3` | real | YES |  |  |
| 28 | `Prem_FT_4` | real | YES |  |  |
| 29 | `Prem_FT_5` | real | YES |  |  |
| 30 | `SI_TPBI_1` | integer | YES |  |  |
| 31 | `SI_TPBI_2` | integer | YES |  |  |
| 32 | `SI_TPBI_3` | integer | YES |  |  |
| 33 | `Prem_TPBI_1` | real | YES |  |  |
| 34 | `Prem_TPBI_2` | real | YES |  |  |
| 35 | `Prem_TPBI_3` | real | YES |  |  |
| 36 | `SI_TPPD_1` | integer | YES |  |  |
| 37 | `SI_TPPD_2` | integer | YES |  |  |
| 38 | `SI_TPPD_3` | integer | YES |  |  |
| 39 | `Prem_TPPD_1` | real | YES |  |  |
| 40 | `Prem_TPPD_2` | real | YES |  |  |
| 41 | `Prem_TPPD_3` | real | YES |  |  |
| 42 | `SI_MV01_1` | integer | YES |  |  |
| 43 | `SI_MV01_2` | integer | YES |  |  |
| 44 | `SI_MV01_3` | integer | YES |  |  |
| 45 | `Prem_MV01_1` | real | YES |  |  |
| 46 | `Prem_MV01_2` | real | YES |  |  |
| 47 | `Prem_MV01_3` | real | YES |  |  |
| 48 | `SI_MV02_1` | integer | YES |  |  |
| 49 | `SI_MV02_2` | integer | YES |  |  |
| 50 | `SI_MV02_3` | integer | YES |  |  |
| 51 | `Prem_MV02_1` | real | YES |  |  |
| 52 | `Prem_MV02_2` | real | YES |  |  |
| 53 | `Prem_MV02_3` | real | YES |  |  |
| 54 | `SI_MV03_1` | integer | YES |  |  |
| 55 | `SI_MV03_2` | integer | YES |  |  |
| 56 | `SI_MV03_3` | integer | YES |  |  |
| 57 | `Prem_MV03_1` | real | YES |  |  |
| 58 | `Prem_MV03_2` | real | YES |  |  |
| 59 | `Prem_MV03_3` | real | YES |  |  |
| 60 | `Sedan` | character varying(255) | YES |  |  |
| 61 | `CC` | character varying(255) | YES |  |  |
| 62 | `SI_Access_1` | integer | YES |  |  |
| 63 | `SI_Access_2` | integer | YES |  |  |
| 64 | `SI_Access_3` | integer | YES |  |  |
| 65 | `Prem_Access_1` | real | YES |  |  |
| 66 | `Prem_Access_2` | real | YES |  |  |
| 67 | `Prem_Access_3` | real | YES |  |  |
| 68 | `BodyType` | character varying(255) | YES |  |  |
| 69 | `Start_date` | timestamp(6) without time zone | YES |  |  |
| 70 | `End_date` | timestamp(6) without time zone | YES |  |  |
| 71 | `CCTV` | integer | YES |  |  |
| 72 | `OIC_Status` | smallint | YES |  |  |
| 73 | `driver_behavior` | integer | YES |  |  |
| 74 | `sc_prem_amt_1` | real | YES |  |  |
| 75 | `sc_prem_amt_2` | real | YES |  |  |
| 76 | `sc_prem_amt_3` | real | YES |  |  |
| 77 | `sc_prem_amt_4` | real | YES |  |  |
| 78 | `sc_prem_amt_5` | real | YES |  |  |
| 79 | `is_active` | boolean | YES |  |  |
| 80 | `version` | integer | YES |  |  |

**Primary key:** _none_

---

## jwt_tokens

`insurverse.jwt_tokens` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.jwt_tokens_id_seq'::regclass)` |  |
| 2 | `username` | character varying(255) | NO |  |  |
| 3 | `token` | text | NO |  |  |
| 4 | `created_at` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 5 | `expire_at` | timestamp without time zone | NO |  |  |

**Primary key:** `id` (jwt_tokens_pkey)

**Constraints:**

- UNIQUE `unique_username`: `UNIQUE (username)`

**Indexes:**

- `idx_jwt_tokens_expire_at`: `CREATE INDEX idx_jwt_tokens_expire_at ON insurverse.jwt_tokens USING btree (expire_at)`
- `idx_jwt_tokens_username`: `CREATE INDEX idx_jwt_tokens_username ON insurverse.jwt_tokens USING btree (username)`
- `jwt_tokens_pkey`: `CREATE UNIQUE INDEX jwt_tokens_pkey ON insurverse.jwt_tokens USING btree (id)`
- `unique_username`: `CREATE UNIQUE INDEX unique_username ON insurverse.jwt_tokens USING btree (username)`

---

## lead_consent

`insurverse.lead_consent` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `lead_no` | character varying(50) | NO |  |  |
| 3 | `consent_id` | uuid | NO |  |  |
| 4 | `date_created` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |

**Primary key:** `id` (lead_consent_pk)

**Foreign keys:**

- `consent_id` → `insurverse.consent_marketing(id)` — lead_consent_consent_marketing_id_fk

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium

**Indexes:**

- `lead_consent_pk`: `CREATE UNIQUE INDEX lead_consent_pk ON insurverse.lead_consent USING btree (id)`

---

## lead_home_coverage

`insurverse.lead_home_coverage` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_home_no` | integer | NO |  |  |
| 2 | `policy_home_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 4 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `create_by` | character varying(50) | YES |  |  |
| 6 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `update_by` | character varying(50) | YES |  |  |
| 8 | `cover_main_si` | numeric(16,4) | YES |  | ทุนประกันความคุ้มครองโครงสร้าง |
| 9 | `flag_furniture` | boolean | YES | `false` | มีความคุ้มครองเฟอร์นิเจอร์หรือไม่ ? |
| 10 | `cover_furniture_si` | numeric(16,4) | YES |  | ทุนประกันความคุ้มครองเฟอร์นิเจอร์ |
| 11 | `cover_main_furniture_si` | numeric(16,4) | YES |  | ทุนประกันรวมความคุ้มครองโครงสร้าง + เฟอร์นิเจอร์ |
| 12 | `cover_main_furniture_prem` | numeric(16,4) | YES |  | เบี้ยประกันรวมความคุ้มครองโครงสร้าง + เฟอร์นิเจอร์ |
| 13 | `cover_loss_and_damage_si` | numeric(16,4) | YES |  | ทุนความสูญเสียหรือความเสียหายต่อเครื่องใช้ไฟฟ้า |
| 14 | `cover_loss_and_damage_prem` | numeric(16,4) | YES |  | เบี้ยความสูญเสียหรือความเสียหายต่อเครื่องใช้ไฟฟ้า |
| 15 | `flag_cover_rental_cost` | boolean | YES | `false` | บ้าน=True, คอนโด=False ค่าเช่าที่อยู่อาศัยชั่วคราวระหว่างซ่อมแซมอาคารที่เสียหายจากความคุ้มครอง |
| 16 | `cover_glass_si` | numeric(16,4) | YES |  | ทุนประกันภัยกระจก |
| 17 | `cover_glass_prem` | numeric(16,4) | YES |  | เบี้ยประกันภัยกระจก |
| 18 | `cover_main_total_amt` | numeric(16,4) | YES |  | เบี้ยประกันหลักรวม |
| 19 | `flag_cover_natural_dis_ex_flood` | boolean | YES | `false` | คุ้มครองหรือไม่? ความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 20 | `cover_natural_dis_ex_flood_si` | numeric(16,4) | YES |  | ทุนความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 21 | `cover_natural_dis_ex_flood_prem` | numeric(16,4) | YES |  | เบี้ยความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 22 | `flag_cover_flood_dis` | boolean | YES | `false` | คุ้มครองหรือไม่? ความเสียหายอันเกิดขึ้นจากภัยจากน้ำท่วม |
| 23 | `cover_flood_dis_si` | numeric(16,4) | YES |  | ทุนความเสียหายอันเกิดขึ้นจากภัยจากน้ำท่วม |
| 24 | `cover_flood_dis_prem` | numeric(16,4) | YES |  | เบี้ยความเสียหายอันเกิดขึ้นจากภัยจากน้ำท่วม |
| 25 | `flag_cover_theft` | boolean | YES | `false` | คุ้มครองหรือไม่? ประกันภัยโจรกรรม |
| 26 | `cover_theft_si` | numeric(16,4) | YES |  | ทุนประกันภัยโจรกรรม |
| 27 | `cover_theft_prem` | numeric(16,4) | YES |  | เบี้ยประกันภัยโจรกรรม |
| 28 | `flag_cover_third_parties` | boolean | YES | `false` | คุ้มครองหรือไม่? ประกันภัยความรับผิดตามกฏหมายต่อบุคคลภายนอก  |
| 29 | `cover_third_parties_si` | numeric(16,4) | YES |  | ทุนประกันภัยความรับผิดตามกฏหมายต่อบุคคลภายนอก |
| 30 | `cover_third_parties_prem` | numeric(16,4) | YES |  | เบี้ยประกันภัยความรับผิดตามกฏหมายต่อบุคคลภายนอก |
| 31 | `cover_addon_total_amt` | numeric(16,4) | YES |  | เบี้ยประกันเสริมรวม |
| 32 | `cover_main_natural_dis_si` | numeric(16,4) | YES |  | ทุนหลักความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 33 | `cover_main_natural_dis_prem` | numeric(16,4) | YES |  | เบี้ยหลักความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |

**Primary key:** `lead_home_no` (lead_home_coverage_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_home_no` → policy_home_premium

**Indexes:**

- `lead_home_coverage_pkey`: `CREATE UNIQUE INDEX lead_home_coverage_pkey ON insurverse.lead_home_coverage USING btree (lead_home_no)`

---

## lead_home_coverage_trans

`insurverse.lead_home_coverage_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_home_no` | integer | NO |  |  |
| 2 | `policy_home_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 4 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `create_by` | character varying(50) | YES |  |  |
| 6 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `update_by` | character varying(50) | YES |  |  |
| 8 | `cover_main_si` | numeric(16,4) | YES |  | ทุนประกันความคุ้มครองโครงสร้าง |
| 9 | `flag_furniture` | boolean | YES | `false` | มีความคุ้มครองเฟอร์นิเจอร์หรือไม่ ? |
| 10 | `cover_furniture_si` | numeric(16,4) | YES |  | ทุนประกันความคุ้มครองเฟอร์นิเจอร์ |
| 11 | `cover_main_furniture_si` | numeric(16,4) | YES |  | ทุนประกันรวมความคุ้มครองโครงสร้าง + เฟอร์นิเจอร์ |
| 12 | `cover_main_furniture_prem` | numeric(16,4) | YES |  | เบี้ยประกันรวมความคุ้มครองโครงสร้าง + เฟอร์นิเจอร์ |
| 13 | `cover_loss_and_damage_si` | numeric(16,4) | YES |  | ทุนความสูญเสียหรือความเสียหายต่อเครื่องใช้ไฟฟ้า |
| 14 | `cover_loss_and_damage_prem` | numeric(16,4) | YES |  | เบี้ยความสูญเสียหรือความเสียหายต่อเครื่องใช้ไฟฟ้า |
| 15 | `flag_cover_rental_cost` | boolean | YES | `false` | บ้าน=True, คอนโด=False ค่าเช่าที่อยู่อาศัยชั่วคราวระหว่างซ่อมแซมอาคารที่เสียหายจากความคุ้มครอง |
| 16 | `cover_glass_si` | numeric(16,4) | YES |  | ทุนประกันภัยกระจก |
| 17 | `cover_glass_prem` | numeric(16,4) | YES |  | เบี้ยประกันภัยกระจก |
| 18 | `cover_main_total_amt` | numeric(16,4) | YES |  | เบี้ยประกันหลักรวม |
| 19 | `flag_cover_natural_dis_ex_flood` | boolean | YES | `false` | คุ้มครองหรือไม่? ความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 20 | `cover_natural_dis_ex_flood_si` | numeric(16,4) | YES |  | ทุนความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 21 | `cover_natural_dis_ex_flood_prem` | numeric(16,4) | YES |  | เบี้ยความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 22 | `flag_cover_flood_dis` | boolean | YES | `false` | คุ้มครองหรือไม่? ความเสียหายอันเกิดขึ้นจากภัยจากน้ำท่วม |
| 23 | `cover_flood_dis_si` | numeric(16,4) | YES |  | ทุนความเสียหายอันเกิดขึ้นจากภัยจากน้ำท่วม |
| 24 | `cover_flood_dis_prem` | numeric(16,4) | YES |  | เบี้ยความเสียหายอันเกิดขึ้นจากภัยจากน้ำท่วม |
| 25 | `flag_cover_theft` | boolean | YES | `false` | คุ้มครองหรือไม่? ประกันภัยโจรกรรม |
| 26 | `cover_theft_si` | numeric(16,4) | YES |  | ทุนประกันภัยโจรกรรม |
| 27 | `cover_theft_prem` | numeric(16,4) | YES |  | เบี้ยประกันภัยโจรกรรม |
| 28 | `flag_cover_third_parties` | boolean | YES | `false` | คุ้มครองหรือไม่? ประกันภัยความรับผิดตามกฏหมายต่อบุคคลภายนอก  |
| 29 | `cover_third_parties_si` | numeric(16,4) | YES |  | ทุนประกันภัยความรับผิดตามกฏหมายต่อบุคคลภายนอก |
| 30 | `cover_third_parties_prem` | numeric(16,4) | YES |  | เบี้ยประกันภัยความรับผิดตามกฏหมายต่อบุคคลภายนอก |
| 31 | `cover_addon_total_amt` | numeric(16,4) | YES |  | เบี้ยประกันเสริมรวม |
| 32 | `cover_main_natural_dis_si` | numeric(16,4) | YES |  | ทุนหลักความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |
| 33 | `cover_main_natural_dis_prem` | numeric(16,4) | YES |  | เบี้ยหลักความเสียหายอันเกิดขึ้นจากภัยจากลมพายุ ภัยจากแผ่นดินไหวหรือภูเขาไฟระเบิดหรือคลี่นใต้น้ำหรือสึนามิ และภัยจากลูกเห็บ |

**Primary key:** `lead_home_no,sf_policy_id` (lead_home_coverage_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_home_no` → policy_home_premium

**Indexes:**

- `lead_home_coverage_trans_pkey`: `CREATE UNIQUE INDEX lead_home_coverage_trans_pkey ON insurverse.lead_home_coverage_trans USING btree (lead_home_no, sf_policy_id)`

---

## lead_home_participant

`insurverse.lead_home_participant` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_home_no` | integer | NO |  |  |
| 2 | `policy_home_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 4 | `owner_title_en` | character varying(255) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาอังกฤษ |
| 5 | `owner_firstname_en` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาอังกฤษ |
| 6 | `owner_lastname_en` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาอังกฤษ |
| 7 | `owner_card_type` | character varying(10) | YES |  | ประเภทบัตรระบุตัวตน I = บัตรประชาชน, P = passport |
| 8 | `owner_card_id` | character varying(20) | YES |  | รหัสระบุตัวตน |
| 9 | `owner_address_th` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาไทย |
| 10 | `owner_address_en` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาอังกฤษ |
| 11 | `owner_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่ผู้เอาประกัน |
| 12 | `owner_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่ผู้เอาประกัน |
| 13 | `owner_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่ผู้เอาประกัน |
| 14 | `owner_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่ผู้เอาประกัน |
| 15 | `owner_phone` | character varying(255) | YES |  | เบอร์ติดต่อผู้เอาประกัน |
| 16 | `owner_country_id` | integer | YES |  | ประเทศที่อยู่ผู้เอาประกัน |
| 17 | `owner_birthdate` | date | YES |  | วันเกิดผู้เอาประกัน |
| 18 | `owner_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาไทย |
| 19 | `owner_firstname_th` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาไทย |
| 20 | `owner_lastname_th` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาไทย |
| 21 | `owner_email` | character varying(255) | YES |  | email ผู้เอาประกัน |
| 22 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 23 | `create_by` | character varying(50) | YES |  |  |
| 24 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 25 | `update_by` | character varying(50) | YES |  |  |
| 26 | `flag_amlo` | character varying(10) | YES |  | ติดปปง หรือไม่ Y = ติดปปง , N = ไม่ติดปปง |
| 27 | `bene_type` | smallint | YES |  | ประเภทผู้รับผลประโยชน์ |
| 28 | `bene_relation` | smallint | YES |  | ความสัมพันธ์ของผู้รับผลประโยชน์ต่อผู้เอาประกัน |
| 29 | `bene_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาไทย |
| 30 | `bene_firstname_th` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาไทย |
| 31 | `bene_lastname_th` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาไทย |
| 32 | `bene_title_en` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 33 | `bene_firstname_en` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 34 | `bene_lastname_en` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาอังกฤษ |
| 35 | `suminsure_rate` | numeric(10,4) | YES | `1.0` | สัดส่วนการรับผลประโยชน์ |

**Primary key:** `lead_home_no` (lead_home_participant_pkey)

**Inferred references (naming convention, NOT enforced FK):** `owner_country_id` → mas_country, `owner_district_id` → district, `owner_province_id` → province, `owner_subdistrict_id` → subdistrict, `policy_home_no` → policy_home_premium

**Indexes:**

- `lead_home_participant_pkey`: `CREATE UNIQUE INDEX lead_home_participant_pkey ON insurverse.lead_home_participant USING btree (lead_home_no)`

---

## lead_home_participant_trans

`insurverse.lead_home_participant_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_home_no` | integer | NO |  |  |
| 2 | `policy_home_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 4 | `owner_title_en` | character varying(255) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาอังกฤษ |
| 5 | `owner_firstname_en` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาอังกฤษ |
| 6 | `owner_lastname_en` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาอังกฤษ |
| 7 | `owner_card_type` | character varying(10) | YES |  | ประเภทบัตรระบุตัวตน I = บัตรประชาชน, P = passport |
| 8 | `owner_card_id` | character varying(20) | YES |  | รหัสระบุตัวตน |
| 9 | `owner_address_th` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาไทย |
| 10 | `owner_address_en` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาอังกฤษ |
| 11 | `owner_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่ผู้เอาประกัน |
| 12 | `owner_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่ผู้เอาประกัน |
| 13 | `owner_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่ผู้เอาประกัน |
| 14 | `owner_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่ผู้เอาประกัน |
| 15 | `owner_phone` | character varying(255) | YES |  | เบอร์ติดต่อผู้เอาประกัน |
| 16 | `owner_country_id` | integer | YES |  | ประเทศที่อยู่ผู้เอาประกัน |
| 17 | `owner_birthdate` | date | YES |  | วันเกิดผู้เอาประกัน |
| 18 | `owner_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาไทย |
| 19 | `owner_firstname_th` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาไทย |
| 20 | `owner_lastname_th` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาไทย |
| 21 | `owner_email` | character varying(255) | YES |  | email ผู้เอาประกัน |
| 22 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 23 | `create_by` | character varying(50) | YES |  |  |
| 24 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 25 | `update_by` | character varying(50) | YES |  |  |
| 26 | `flag_amlo` | character varying(10) | YES |  | ติดปปง หรือไม่ Y = ติดปปง , N = ไม่ติดปปง |
| 27 | `bene_type` | smallint | YES |  | ประเภทผู้รับผลประโยชน์ |
| 28 | `bene_relation` | smallint | YES |  | ความสัมพันธ์ของผู้รับผลประโยชน์ต่อผู้เอาประกัน |
| 29 | `bene_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาไทย |
| 30 | `bene_firstname_th` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาไทย |
| 31 | `bene_lastname_th` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาไทย |
| 32 | `bene_title_en` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 33 | `bene_firstname_en` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 34 | `bene_lastname_en` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาอังกฤษ |
| 35 | `suminsure_rate` | numeric(10,4) | YES | `1.0` | สัดส่วนการรับผลประโยชน์ |

**Primary key:** `lead_home_no,sf_policy_id` (lead_home_participant_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `owner_country_id` → mas_country, `owner_district_id` → district, `owner_province_id` → province, `owner_subdistrict_id` → subdistrict, `policy_home_no` → policy_home_premium

**Indexes:**

- `lead_home_participant_trans_pkey`: `CREATE UNIQUE INDEX lead_home_participant_trans_pkey ON insurverse.lead_home_participant_trans USING btree (lead_home_no, sf_policy_id)`

---

## lead_home_premium

`insurverse.lead_home_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_home_no` | integer | NO |  |  |
| 2 | `policy_startdate` | timestamp without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 3 | `policy_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 4 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 5 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 6 | `payment_channel` | character varying(50) | YES |  |  |
| 7 | `payment_type` | character varying(50) | YES |  |  |
| 8 | `payment_no` | character varying(50) | YES |  |  |
| 9 | `payment_ref1` | character varying(50) | YES |  |  |
| 10 | `payment_ref2` | character varying(50) | YES |  |  |
| 11 | `payment_result` | character varying(50) | YES |  |  |
| 12 | `payment_date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 13 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 14 | `create_by` | character varying(50) | YES |  |  |
| 15 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 16 | `update_by` | character varying(50) | YES |  |  |
| 17 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 18 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 19 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 20 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 21 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 22 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 23 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 24 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 25 | `policy_book` | character varying(50) | YES |  | เลข book |
| 26 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 27 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 28 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 29 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 30 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 31 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 32 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 33 | `deli_flag` | boolean | YES |  |  |
| 34 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 35 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 36 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 37 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 38 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 39 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 40 | `tax_deductions` | boolean | YES |  | ออกเอกสารลดหย่อนภาษีหรือไม่ |
| 41 | `home_building_type_id` | smallint | YES |  | รหัสประเภทอาคาร |
| 42 | `home_building_province_id` | smallint | YES |  | รหัสจังหวัด |
| 43 | `home_material_type_id` | integer | YES |  | รหัสประเภทวัสดุอาคาร |
| 44 | `home_resident_type_id` | smallint | YES |  | รหัสประเภทผู้อยู่อาศัย |
| 45 | `building_address_th` | character varying(500) | YES |  | ที่อยู่อาคารประกัน |
| 46 | `building_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 47 | `building_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่อาคารประกัน |
| 48 | `building_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่อาคารประกัน |
| 49 | `building_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่อาคารประกัน |
| 50 | `building_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่อาคารประกัน |
| 51 | `building_country_id` | integer | YES |  | ประเทศที่อยู่อาคารประกัน |
| 52 | `promo_discount_sum` | numeric(16,4) | YES |  | ส่วนลด บาท สำหรับแสดงผลหน้าจอสรุป |

**Primary key:** `lead_home_no` (lead_home_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `home_building_type_id` → mas_home_building_type, `home_material_type_id` → mas_home_material_type, `home_resident_type_id` → mas_home_resident_type, `promo_trans_id` → promo_code_trans

**Indexes:**

- `lead_home_premium_pkey`: `CREATE UNIQUE INDEX lead_home_premium_pkey ON insurverse.lead_home_premium USING btree (lead_home_no)`

---

## lead_home_premium_tariff

`insurverse.lead_home_premium_tariff` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_home_no` | integer | NO |  |  |
| 2 | `policy_home_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 4 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `create_by` | character varying(50) | YES |  |  |
| 6 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `update_by` | character varying(50) | YES |  |  |
| 8 | `home_premium_tariff_id` | smallint | NO |  | รหัส tariff เบี้ยประกัน Home |
| 9 | `home_building_type_id` | smallint | NO |  | รหัสประเภทอาคาร |
| 10 | `home_coverage_id` | smallint | NO |  | รหัสความคุ้มครองบ้าน |
| 11 | `cover_limit_min` | numeric(16,4) | YES |  | ทุนประกันขั้นต่ำ |
| 12 | `cover_limit_max` | numeric(16,4) | YES |  | ทุนประกันสูงสุด |
| 13 | `cover_limit_split` | numeric(16,4) | YES |  | ช่วงการเลือกทุนประกัน |
| 14 | `flag_cover_si_factor` | boolean | YES |  | เป็นทุนประกันที่ต้องการทุนจากความคุ้มครองอื่น |
| 15 | `cover_si_factor` | numeric(16,4) | YES |  | จำนวนทุนประกันที่ต้องอ้างอิงเพิ่มนำมาคำนวณเบี้ย |
| 16 | `cover_si_limit_min` | numeric(16,4) | YES |  | จำนวนจำกัดทุนประกันขั้นต่ำสุด |
| 17 | `cover_si_limit_max` | numeric(16,4) | YES |  | จำนวนจำกัดทุนประกันขั้นสูงสุด |
| 18 | `si_second_flag` | boolean | YES | `false` | มีคำนวณเบี้ย 2 ขั้นหรือไม่ |
| 19 | `si_first_limit` | numeric(16,4) | YES |  | ความคุ้มครองจำกัดส่วนแรก |
| 20 | `si_first_factor` | numeric(16,4) | YES |  | tariff คำนวณความคุ้มครองส่วนแรก |
| 21 | `si_second_limit` | numeric(16,4) | YES |  | ความคุ้มครองจำกัดส่วนนอกเหนือส่วนแรก |
| 22 | `si_second_factor` | numeric(16,4) | YES |  | tariff คำนวณความคุ้มครองส่วนนอกเหนือส่วนแรก |

**Primary key:** `lead_home_no,home_premium_tariff_id` (lead_home_premium_tariff_pkey)

**Inferred references (naming convention, NOT enforced FK):** `home_building_type_id` → mas_home_building_type, `home_coverage_id` → mas_home_coverage, `home_premium_tariff_id` → mas_home_premium_tariff, `policy_home_no` → policy_home_premium

**Indexes:**

- `lead_home_premium_tariff_pkey`: `CREATE UNIQUE INDEX lead_home_premium_tariff_pkey ON insurverse.lead_home_premium_tariff USING btree (lead_home_no, home_premium_tariff_id)`

---

## lead_info_customer

`insurverse.lead_info_customer` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_info_id` | integer | NO |  |  |
| 2 | `title_name` | character varying(100) | YES |  | คำนำหน้าชื่อ |
| 3 | `first_name` | character varying(255) | YES |  | ชื่อ |
| 4 | `last_name` | character varying(255) | YES |  | นามสกุล |
| 5 | `email` | character varying(255) | YES |  | อีเมล |
| 6 | `mobile` | character varying(255) | YES |  | เบอร์ติดต่อ |
| 7 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(50) | YES |  |  |
| 9 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 10 | `update_by` | character varying(50) | YES |  |  |
| 11 | `sf_lead` | character varying(255) | YES |  | Salesforce SF-Lead |
| 12 | `flag_consent` | character varying(1) | YES |  | Y = ยินยอม, N = ไม่ยินยอม |

**Primary key:** `lead_info_id` (lead_info_customer_pkey)

**Indexes:**

- `lead_info_customer_pkey`: `CREATE UNIQUE INDEX lead_info_customer_pkey ON insurverse.lead_info_customer USING btree (lead_info_id)`

---

## lead_pa_beneficiary

`insurverse.lead_pa_beneficiary` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_pa_no` | integer | NO |  |  |
| 2 | `policy_pa_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 4 | `bene_index` | smallint | NO |  | running no. นับใหม่ตาม lead สำหรับระบุลำดับคนรับผลประโยชน์ |
| 5 | `bene_type` | smallint | YES |  | ประเภทผู้รับผลประโยชน์ |
| 6 | `bene_relation` | smallint | YES |  | ความสัมพันธ์ของผู้รับผลประโยชน์ต่อผู้เอาประกัน |
| 7 | `bene_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาไทย |
| 8 | `bene_firstname_th` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาไทย |
| 9 | `bene_lastname_th` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาไทย |
| 10 | `bene_title_en` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 11 | `bene_firstname_en` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 12 | `bene_lastname_en` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาอังกฤษ |
| 13 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 14 | `create_by` | character varying(50) | YES |  |  |
| 15 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 16 | `update_by` | character varying(50) | YES |  |  |
| 17 | `suminsure_rate` | numeric(10,4) | YES | `1.0` | สัดส่วนการรับผลประโยชน์ |

**Primary key:** `lead_pa_no,bene_index` (lead_pa_beneficiary_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_pa_no` → lead_pa_premium, `policy_pa_no` → policy_pa_premium

**Indexes:**

- `lead_pa_beneficiary_pkey`: `CREATE UNIQUE INDEX lead_pa_beneficiary_pkey ON insurverse.lead_pa_beneficiary USING btree (lead_pa_no, bene_index)`

---

## lead_pa_beneficiary_trans

`insurverse.lead_pa_beneficiary_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_pa_no` | integer | NO |  |  |
| 2 | `policy_pa_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 4 | `bene_index` | smallint | NO |  | running no. นับใหม่ตาม lead สำหรับระบุลำดับคนรับผลประโยชน์ |
| 5 | `bene_type` | smallint | YES |  | ประเภทผู้รับผลประโยชน์ |
| 6 | `bene_relation` | smallint | YES |  | ความสัมพันธ์ของผู้รับผลประโยชน์ต่อผู้เอาประกัน |
| 7 | `bene_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาไทย |
| 8 | `bene_firstname_th` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาไทย |
| 9 | `bene_lastname_th` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาไทย |
| 10 | `bene_title_en` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 11 | `bene_firstname_en` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 12 | `bene_lastname_en` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาอังกฤษ |
| 13 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 14 | `create_by` | character varying(50) | YES |  |  |
| 15 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 16 | `update_by` | character varying(50) | YES |  |  |
| 17 | `suminsure_rate` | numeric(10,4) | YES | `1.0` | สัดส่วนการรับผลประโยชน์ |

**Primary key:** `lead_pa_no,bene_index,sf_policy_id` (lead_pa_beneficiary_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_pa_no` → lead_pa_premium, `policy_pa_no` → policy_pa_premium

**Indexes:**

- `lead_pa_beneficiary_trans_pkey`: `CREATE UNIQUE INDEX lead_pa_beneficiary_trans_pkey ON insurverse.lead_pa_beneficiary_trans USING btree (lead_pa_no, bene_index, sf_policy_id)`

---

## lead_pa_coverage

`insurverse.lead_pa_coverage` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_pa_no` | integer | NO |  |  |
| 2 | `policy_pa_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 4 | `pa_coverage_id` | smallint | NO |  | รหัสความคุ้มครอง PA |
| 5 | `flag_cover_main` | boolean | YES |  | ความคุ้มครองหลักหรือไม่ |
| 6 | `cover_limit_min` | numeric(16,4) | YES |  | ทุนความคุ้มครองต่ำสุด |
| 7 | `cover_limit_max` | numeric(16,4) | YES |  | ทุนความคุ้มครองสูงสุด |
| 8 | `cover_limit_split` | numeric(16,4) | YES |  | ช่วงระหว่างความคุ้มครอง |
| 9 | `cover_dd_limit_min` | numeric(16,4) | YES |  | ทุนแรกเริ่มต่ำสุด |
| 10 | `cover_dd_limit_max` | numeric(16,4) | YES |  | ทุนแรกเริ่มสูงสุด |
| 11 | `cover_si_main` | numeric(16,4) | YES |  | อ้างอิงทุนประกันรวม |
| 12 | `si_cover_amt` | numeric(16,4) | YES |  | ทุนคุ้มครอง |
| 13 | `si_prem_amt` | numeric(16,4) | YES |  | เบี้ยประกันความคุ้มครอง |
| 14 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 15 | `create_by` | character varying(50) | YES |  |  |
| 16 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 17 | `update_by` | character varying(50) | YES |  |  |
| 18 | `si_first_limit` | numeric(16,4) | YES |  | ทุนคุ้มครองสูงสุดขั้นแรก |
| 19 | `si_first_factor` | numeric(16,4) | YES |  | ตัวแปรสำหรับคำนวณเบี้ยขั้นแรก |
| 20 | `si_second_flag` | boolean | YES |  | มีคำนวณเบี้ย 2 ขั้นหรือไม่ |
| 21 | `si_second_limit` | numeric(16,4) | YES |  | ทุนคุ้มครองสูงสุดขั้นที่สอง |
| 22 | `si_second_factor` | numeric(16,4) | YES |  | ตัวแปรสำหรับคำนวณเบี้ยขั้นสอง |

**Primary key:** `lead_pa_no,pa_coverage_id` (lead_pa_coverage_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_pa_no` → lead_pa_premium, `pa_coverage_id` → mas_pa_coverage, `policy_pa_no` → policy_pa_premium

**Indexes:**

- `lead_pa_coverage_pkey`: `CREATE UNIQUE INDEX lead_pa_coverage_pkey ON insurverse.lead_pa_coverage USING btree (lead_pa_no, pa_coverage_id)`

---

## lead_pa_coverage_trans

`insurverse.lead_pa_coverage_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_pa_no` | integer | NO |  |  |
| 2 | `policy_pa_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 4 | `pa_coverage_id` | smallint | NO |  | รหัสความคุ้มครอง PA |
| 5 | `flag_cover_main` | boolean | YES |  | ความคุ้มครองหลักหรือไม่ |
| 6 | `cover_limit_min` | numeric(16,4) | YES |  | ทุนความคุ้มครองต่ำสุด |
| 7 | `cover_limit_max` | numeric(16,4) | YES |  | ทุนความคุ้มครองสูงสุด |
| 8 | `cover_limit_split` | numeric(16,4) | YES |  | ช่วงระหว่างความคุ้มครอง |
| 9 | `cover_dd_limit_min` | numeric(16,4) | YES |  | ทุนแรกเริ่มต่ำสุด |
| 10 | `cover_dd_limit_max` | numeric(16,4) | YES |  | ทุนแรกเริ่มสูงสุด |
| 11 | `cover_si_main` | numeric(16,4) | YES |  | อ้างอิงทุนประกันรวม |
| 12 | `si_cover_amt` | numeric(16,4) | YES |  | ทุนคุ้มครอง |
| 13 | `si_prem_amt` | numeric(16,4) | YES |  | เบี้ยประกันความคุ้มครอง |
| 14 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 15 | `create_by` | character varying(50) | YES |  |  |
| 16 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 17 | `update_by` | character varying(50) | YES |  |  |
| 18 | `si_first_limit` | numeric(16,4) | YES |  | ทุนคุ้มครองสูงสุดขั้นแรก |
| 19 | `si_first_factor` | numeric(16,4) | YES |  | ตัวแปรสำหรับคำนวณเบี้ยขั้นแรก |
| 20 | `si_second_flag` | boolean | YES |  | มีคำนวณเบี้ย 2 ขั้นหรือไม่ |
| 21 | `si_second_limit` | numeric(16,4) | YES |  | ทุนคุ้มครองสูงสุดขั้นที่สอง |
| 22 | `si_second_factor` | numeric(16,4) | YES |  | ตัวแปรสำหรับคำนวณเบี้ยขั้นสอง |

**Primary key:** `lead_pa_no,pa_coverage_id,sf_policy_id` (lead_pa_coverage_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_pa_no` → lead_pa_premium, `pa_coverage_id` → mas_pa_coverage, `policy_pa_no` → policy_pa_premium

**Indexes:**

- `lead_pa_coverage_trans_pkey`: `CREATE UNIQUE INDEX lead_pa_coverage_trans_pkey ON insurverse.lead_pa_coverage_trans USING btree (lead_pa_no, pa_coverage_id, sf_policy_id)`

---

## lead_pa_participant

`insurverse.lead_pa_participant` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_pa_no` | integer | NO |  |  |
| 2 | `policy_pa_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 4 | `owner_index` | smallint | NO |  | running no. นับใหม่ตาม lead สำหรับระบุลำดับคนเอาประกัน |
| 5 | `owner_title_en` | character varying(255) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาอังกฤษ |
| 6 | `owner_firstname_en` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาอังกฤษ |
| 7 | `owner_lastname_en` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาอังกฤษ |
| 8 | `owner_card_type` | character varying(10) | YES |  | ประเภทบัตรระบุตัวตน I = บัตรประชาชน, P = passport |
| 9 | `owner_card_id` | character varying(20) | YES |  | รหัสระบุตัวตน |
| 10 | `owner_address_th` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาไทย |
| 11 | `owner_address_en` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาอังกฤษ |
| 12 | `owner_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่ผู้เอาประกัน |
| 13 | `owner_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่ผู้เอาประกัน |
| 14 | `owner_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่ผู้เอาประกัน |
| 15 | `owner_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่ผู้เอาประกัน |
| 16 | `owner_phone` | character varying(255) | YES |  | เบอร์ติดต่อผู้เอาประกัน |
| 17 | `owner_country_id` | integer | YES |  | ประเทศที่อยู่ผู้เอาประกัน |
| 18 | `owner_birthdate` | date | YES |  | วันเกิดผู้เอาประกัน |
| 19 | `owner_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาไทย |
| 20 | `owner_firstname_th` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาไทย |
| 21 | `owner_lastname_th` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาไทย |
| 22 | `owner_email` | character varying(255) | YES |  | email ผู้เอาประกัน |
| 23 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 24 | `create_by` | character varying(50) | YES |  |  |
| 25 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 26 | `update_by` | character varying(50) | YES |  |  |
| 27 | `flag_amlo` | character varying(10) | YES |  | ติดปปง หรือไม่ Y = ติดปปง , N = ไม่ติดปปง |

**Primary key:** `lead_pa_no,owner_index` (lead_pa_participant_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_pa_no` → lead_pa_premium, `owner_country_id` → mas_country, `owner_district_id` → district, `owner_province_id` → province, `owner_subdistrict_id` → subdistrict, `policy_pa_no` → policy_pa_premium

**Indexes:**

- `lead_pa_participant_pkey`: `CREATE UNIQUE INDEX lead_pa_participant_pkey ON insurverse.lead_pa_participant USING btree (lead_pa_no, owner_index)`

---

## lead_pa_participant_trans

`insurverse.lead_pa_participant_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_pa_no` | integer | NO |  |  |
| 2 | `policy_pa_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 4 | `owner_index` | smallint | NO |  | running no. นับใหม่ตาม lead สำหรับระบุลำดับคนเอาประกัน |
| 5 | `owner_title_en` | character varying(255) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาอังกฤษ |
| 6 | `owner_firstname_en` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาอังกฤษ |
| 7 | `owner_lastname_en` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาอังกฤษ |
| 8 | `owner_card_type` | character varying(10) | YES |  | ประเภทบัตรระบุตัวตน I = บัตรประชาชน, P = passport |
| 9 | `owner_card_id` | character varying(20) | YES |  | รหัสระบุตัวตน |
| 10 | `owner_address_th` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาไทย |
| 11 | `owner_address_en` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาอังกฤษ |
| 12 | `owner_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่ผู้เอาประกัน |
| 13 | `owner_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่ผู้เอาประกัน |
| 14 | `owner_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่ผู้เอาประกัน |
| 15 | `owner_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่ผู้เอาประกัน |
| 16 | `owner_phone` | character varying(255) | YES |  | เบอร์ติดต่อผู้เอาประกัน |
| 17 | `owner_country_id` | integer | YES |  | ประเทศที่อยู่ผู้เอาประกัน |
| 18 | `owner_birthdate` | date | YES |  | วันเกิดผู้เอาประกัน |
| 19 | `owner_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาไทย |
| 20 | `owner_firstname_th` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาไทย |
| 21 | `owner_lastname_th` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาไทย |
| 22 | `owner_email` | character varying(255) | YES |  | email ผู้เอาประกัน |
| 23 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 24 | `create_by` | character varying(50) | YES |  |  |
| 25 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 26 | `update_by` | character varying(50) | YES |  |  |
| 27 | `flag_amlo` | character varying(10) | YES |  | ติดปปง หรือไม่ Y = ติดปปง , N = ไม่ติดปปง |

**Primary key:** `lead_pa_no,owner_index,sf_policy_id` (lead_pa_participant_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_pa_no` → lead_pa_premium, `owner_country_id` → mas_country, `owner_district_id` → district, `owner_province_id` → province, `owner_subdistrict_id` → subdistrict, `policy_pa_no` → policy_pa_premium

**Indexes:**

- `lead_pa_participant_trans_pkey`: `CREATE UNIQUE INDEX lead_pa_participant_trans_pkey ON insurverse.lead_pa_participant_trans USING btree (lead_pa_no, owner_index, sf_policy_id)`

---

## lead_pa_premium

`insurverse.lead_pa_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_pa_no` | integer | NO |  |  |
| 2 | `pa_package_id` | smallint | YES |  | รหัส PA package |
| 3 | `policy_startdate` | timestamp without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 4 | `policy_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 5 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 6 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 7 | `payment_channel` | character varying(50) | YES |  |  |
| 8 | `payment_type` | character varying(50) | YES |  |  |
| 9 | `payment_no` | character varying(50) | YES |  |  |
| 10 | `payment_ref1` | character varying(50) | YES |  |  |
| 11 | `payment_ref2` | character varying(50) | YES |  |  |
| 12 | `payment_result` | character varying(50) | YES |  |  |
| 13 | `payment_date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 14 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 15 | `create_by` | character varying(50) | YES |  |  |
| 16 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 17 | `update_by` | character varying(50) | YES |  |  |
| 18 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 19 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 20 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 21 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 22 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 23 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 24 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 25 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 26 | `policy_book` | character varying(50) | YES |  | เลข book |
| 27 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 28 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 29 | `pa_age_range_id` | smallint | YES |  | รหัสช่วงอายุ |
| 30 | `pa_occupation_id` | smallint | YES |  | รหัสอาชีพ |
| 31 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 32 | `tax_deductions` | boolean | YES |  | ออกเอกสารลดหย่อนภาษีหรือไม่ |
| 33 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 34 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 35 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 36 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 37 | `deli_flag` | boolean | YES |  |  |
| 38 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 39 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 40 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 41 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 42 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 43 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 44 | `pa_question_id_array` | character varying(255) | YES |  | คำถามสุขภาพที่เลือก |
| 45 | `promo_discount_sum` | numeric(16,4) | YES |  | ส่วนลด บาท สำหรับแสดงผลหน้าจอสรุป |

**Primary key:** `lead_pa_no` (lead_pa_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `pa_age_range_id` → mas_pa_age_range, `pa_occupation_id` → mas_pa_occupation, `pa_package_id` → mas_pa_package, `promo_trans_id` → promo_code_trans

**Indexes:**

- `lead_pa_premium_pkey`: `CREATE UNIQUE INDEX lead_pa_premium_pkey ON insurverse.lead_pa_premium USING btree (lead_pa_no)`

---

## lead_ta_package

`insurverse.lead_ta_package` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_ta_no` | integer | NO |  |  |
| 2 | `ta_package_id` | smallint | NO |  | รหัส package |
| 3 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 4 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 5 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 6 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 7 | `is_active` | boolean | YES |  | สถานะความคุ้มครอง |
| 8 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `create_by` | character varying(50) | YES |  |  |
| 10 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 11 | `update_by` | character varying(50) | YES |  |  |
| 12 | `is_addon` | boolean | YES |  | true = addon, false = main |
| 13 | `policy_ta_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 14 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |

**Primary key:** `lead_ta_no,ta_package_id` (lead_ta_package_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_ta_no` → lead_ta_premium, `policy_ta_no` → policy_ta_premium, `ta_package_id` → mas_ta_package

**Indexes:**

- `lead_ta_package_pkey`: `CREATE UNIQUE INDEX lead_ta_package_pkey ON insurverse.lead_ta_package USING btree (lead_ta_no, ta_package_id)`

---

## lead_ta_package_trans

`insurverse.lead_ta_package_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_ta_no` | integer | NO |  |  |
| 2 | `ta_package_id` | smallint | NO |  | รหัส package |
| 3 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 4 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 5 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 6 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 7 | `is_active` | boolean | YES |  | สถานะความคุ้มครอง |
| 8 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `create_by` | character varying(50) | YES |  |  |
| 10 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 11 | `update_by` | character varying(50) | YES |  |  |
| 12 | `is_addon` | boolean | YES |  | true = addon, false = main |
| 13 | `policy_ta_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 14 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |

**Primary key:** `lead_ta_no,ta_package_id,sf_policy_id` (lead_ta_package_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_ta_no` → lead_ta_premium, `policy_ta_no` → policy_ta_premium, `ta_package_id` → mas_ta_package

**Indexes:**

- `lead_ta_package_trans_pkey`: `CREATE UNIQUE INDEX lead_ta_package_trans_pkey ON insurverse.lead_ta_package_trans USING btree (lead_ta_no, ta_package_id, sf_policy_id)`

---

## lead_ta_participant

`insurverse.lead_ta_participant` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_ta_no` | integer | NO |  |  |
| 2 | `policy_ta_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 4 | `owner_index` | smallint | NO |  | running no. นับใหม่ตาม lead สำหรับระบุลำดับคนเอาประกัน |
| 5 | `owner_title_en` | character varying(255) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาอังกฤษ |
| 6 | `owner_firstname_en` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาอังกฤษ |
| 7 | `owner_lastname_en` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาอังกฤษ |
| 8 | `owner_card_type` | character varying(10) | YES |  | ประเภทบัตรระบุตัวตน I = บัตรประชาชน, P = passport |
| 9 | `owner_card_id` | character varying(20) | YES |  | รหัสระบุตัวตน |
| 10 | `owner_address_th` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาไทย |
| 11 | `owner_address_en` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาอังกฤษ |
| 12 | `owner_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่ผู้เอาประกัน |
| 13 | `owner_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่ผู้เอาประกัน |
| 14 | `owner_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่ผู้เอาประกัน |
| 15 | `owner_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่ผู้เอาประกัน |
| 16 | `owner_phone` | character varying(255) | YES |  | เบอร์ติดต่อผู้เอาประกัน |
| 17 | `owner_country_id` | integer | YES |  | ประเทศที่อยู่ผู้เอาประกัน |
| 18 | `owner_state_id` | integer | YES |  |  |
| 19 | `owner_city` | character varying(255) | YES |  |  |
| 20 | `owner_occupation_code` | character varying(50) | YES |  |  |
| 21 | `owner_birthdate` | date | YES |  | วันเกิดผู้เอาประกัน |
| 22 | `travel_reason_text_th` | character varying(500) | YES |  | วัตถุประสงค์การเดินทางภาษาไทย |
| 23 | `travel_reason_text_en` | character varying(500) | YES |  | วัตถุประสงค์การเดินทางภาษาอังกฤษ |
| 24 | `owner_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาไทย |
| 25 | `owner_firstname_th` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาไทย |
| 26 | `owner_lastname_th` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาไทย |
| 27 | `owner_email` | character varying(255) | YES |  | email ผู้เอาประกัน |
| 28 | `bene_type` | smallint | YES |  | ประเภทผู้รับผลประโยชน์ |
| 29 | `bene_relation` | smallint | YES |  | ความสัมพันธ์ของผู้รับผลประโยชน์ต่อผู้เอาประกัน |
| 30 | `bene_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาไทย |
| 31 | `bene_firstname_th` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาไทย |
| 32 | `bene_lastname_th` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาไทย |
| 33 | `bene_title_en` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 34 | `bene_firstname_en` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 35 | `bene_lastname_en` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาอังกฤษ |
| 36 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 37 | `create_by` | character varying(50) | YES |  |  |
| 38 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 39 | `update_by` | character varying(50) | YES |  |  |
| 40 | `flag_amlo` | character varying(10) | YES |  | ติดปปง หรือไม่ Y = ติดปปง , N = ไม่ติดปปง |
| 41 | `travel_reason_id` | smallint | YES |  | รหัสวัตถุประสงค์การเดินทาง |
| 42 | `flag_ref_info_buyer` | boolean | YES | `false` | อ้างอิงข้อมูลผู้ซื้อหรือไม่ true=ใช่, false=ไม่ใช่ |
| 43 | `flag_ref_email_buyer` | boolean | YES | `false` | อ้างอิงอีเมลผู้ซื้อหรือไม่ (ส่งอีเมลกรมธรรม์และใบเสร็จ) true=ใช่, false=ไม่ใช่ |
| 44 | `deli_flag` | boolean | YES | `false` | true = จัดส่งไปรษณีย์, false = Email |
| 45 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 46 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 47 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 48 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 49 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 50 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 51 | `indiv_discount_amt` | numeric(16,4) | YES |  | ต่อบุคคล ส่วนลด |
| 52 | `indiv_perm_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคาสุทธิกก่อนอากรและ vat |
| 53 | `indiv_duty_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคาอากร |
| 54 | `indiv_vat_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคา vat |
| 55 | `indiv_total_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคารวมหลังอากรและ vat |
| 56 | `indiv_promo_discount_sum` | numeric(16,4) | YES |  | ต่อบุคคล ส่วนลด บาท สำหรับแสดงผลหน้าจอสรุป |
| 57 | `indiv_perm_amt_main` | numeric(16,4) | YES |  | ต่อบุคคล ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจหลัก |
| 58 | `indiv_perm_amt_addon` | numeric(16,4) | YES |  | ต่อบุคคล ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจเสริม |
| 59 | `owner_country_code` | integer | YES |  |  |
| 60 | `owner_country_code_id` | integer | YES |  | country_id ของ country code เพื่อsupportประเทศที่ duplicated country_code |

**Primary key:** `lead_ta_no,owner_index` (lead_ta_participant_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `lead_ta_no` → lead_ta_premium, `owner_country_id` → mas_country, `owner_district_id` → district, `owner_province_id` → province, `owner_state_id` → mas_state, `owner_subdistrict_id` → subdistrict, `policy_ta_no` → policy_ta_premium

**Indexes:**

- `lead_ta_participant_pkey`: `CREATE UNIQUE INDEX lead_ta_participant_pkey ON insurverse.lead_ta_participant USING btree (lead_ta_no, owner_index)`

---

## lead_ta_participant_trans

`insurverse.lead_ta_participant_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_ta_no` | integer | NO |  |  |
| 2 | `policy_ta_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 3 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 4 | `owner_index` | smallint | NO |  | running no. นับใหม่ตาม lead สำหรับระบุลำดับคนเอาประกัน |
| 5 | `owner_title_en` | character varying(255) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาอังกฤษ |
| 6 | `owner_firstname_en` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาอังกฤษ |
| 7 | `owner_lastname_en` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาอังกฤษ |
| 8 | `owner_card_type` | character varying(10) | YES |  | ประเภทบัตรระบุตัวตน I = บัตรประชาชน, P = passport |
| 9 | `owner_card_id` | character varying(20) | YES |  | รหัสระบุตัวตน |
| 10 | `owner_address_th` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาไทย |
| 11 | `owner_address_en` | character varying(500) | YES |  | ที่อยู่ผู้เอาประกันภาษาอังกฤษ |
| 12 | `owner_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่ผู้เอาประกัน |
| 13 | `owner_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่ผู้เอาประกัน |
| 14 | `owner_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่ผู้เอาประกัน |
| 15 | `owner_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่ผู้เอาประกัน |
| 16 | `owner_phone` | character varying(255) | YES |  | เบอร์ติดต่อผู้เอาประกัน |
| 17 | `owner_country_id` | integer | YES |  | ประเทศที่อยู่ผู้เอาประกัน |
| 18 | `owner_birthdate` | date | YES |  | วันเกิดผู้เอาประกัน |
| 19 | `travel_reason_text_th` | character varying(500) | YES |  | วัตถุประสงค์การเดินทางภาษาไทย |
| 20 | `travel_reason_text_en` | character varying(500) | YES |  | วัตถุประสงค์การเดินทางภาษาอังกฤษ |
| 21 | `owner_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้เอาประกันภาษาไทย |
| 22 | `owner_firstname_th` | character varying(255) | YES |  | ชื่อผู้เอาประกันภาษาไทย |
| 23 | `owner_lastname_th` | character varying(255) | YES |  | นามสกุลผู้เอาประกันภาษาไทย |
| 24 | `owner_email` | character varying(255) | YES |  | email ผู้เอาประกัน |
| 25 | `bene_type` | smallint | YES |  | ประเภทผู้รับผลประโยชน์ |
| 26 | `bene_relation` | smallint | YES |  | ความสัมพันธ์ของผู้รับผลประโยชน์ต่อผู้เอาประกัน |
| 27 | `bene_title_th` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาไทย |
| 28 | `bene_firstname_th` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาไทย |
| 29 | `bene_lastname_th` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาไทย |
| 30 | `bene_title_en` | character varying(50) | YES |  | คำนำหน้าชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 31 | `bene_firstname_en` | character varying(255) | YES |  | ชื่อผู้รับผลประโยชน์ภาษาอังกฤษ |
| 32 | `bene_lastname_en` | character varying(255) | YES |  | นามสกุลผู้รับผลประโยชน์ภาษาอังกฤษ |
| 33 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 34 | `create_by` | character varying(50) | YES |  |  |
| 35 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 36 | `update_by` | character varying(50) | YES |  |  |
| 37 | `flag_amlo` | character varying(10) | YES |  | ติดปปง หรือไม่ Y = ติดปปง , N = ไม่ติดปปง |
| 38 | `travel_reason_id` | smallint | YES |  | รหัสวัตถุประสงค์การเดินทาง |
| 39 | `flag_ref_info_buyer` | boolean | YES | `false` | อ้างอิงข้อมูลผู้ซื้อหรือไม่ true=ใช่, false=ไม่ใช่ |
| 40 | `flag_ref_email_buyer` | boolean | YES | `false` | อ้างอิงอีเมลผู้ซื้อหรือไม่ (ส่งอีเมลกรมธรรม์และใบเสร็จ) true=ใช่, false=ไม่ใช่ |
| 41 | `deli_flag` | boolean | YES | `false` | true = จัดส่งไปรษณีย์, false = Email |
| 42 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 43 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 44 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 45 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 46 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 47 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 48 | `indiv_discount_amt` | numeric(16,4) | YES |  | ต่อบุคคล ส่วนลด |
| 49 | `indiv_perm_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคาสุทธิกก่อนอากรและ vat |
| 50 | `indiv_duty_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคาอากร |
| 51 | `indiv_vat_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคา vat |
| 52 | `indiv_total_amt` | numeric(16,4) | YES |  | ต่อบุคคล ราคารวมหลังอากรและ vat |
| 53 | `indiv_promo_discount_sum` | numeric(16,4) | YES |  | ต่อบุคคล ส่วนลด บาท สำหรับแสดงผลหน้าจอสรุป |
| 54 | `indiv_perm_amt_main` | numeric(16,4) | YES |  | ต่อบุคคล ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจหลัก |
| 55 | `indiv_perm_amt_addon` | numeric(16,4) | YES |  | ต่อบุคคล ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจเสริม |

**Primary key:** `lead_ta_no,owner_index,sf_policy_id` (lead_ta_participant_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `lead_ta_no` → lead_ta_premium, `owner_country_id` → mas_country, `owner_district_id` → district, `owner_province_id` → province, `owner_subdistrict_id` → subdistrict, `policy_ta_no` → policy_ta_premium

**Indexes:**

- `lead_ta_participant_trans_pkey`: `CREATE UNIQUE INDEX lead_ta_participant_trans_pkey ON insurverse.lead_ta_participant_trans USING btree (lead_ta_no, owner_index, sf_policy_id)`

---

## lead_ta_premium

`insurverse.lead_ta_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `lead_ta_no` | integer | NO |  |  |
| 2 | `ta_package_id` | smallint | YES |  | รหัส TA package |
| 3 | `country_origin_id` | smallint | YES |  |  |
| 4 | `country_main_id` | smallint | YES |  | ประเทศเดินทางหลัก country_id |
| 5 | `country_id_array` | character varying(255) | YES |  | ประเทศเดินทางที่ระบุ กำหนดเป็น Array(counrty_id) |
| 6 | `policy_startdate` | timestamp without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 7 | `policy_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 8 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 9 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 10 | `payment_channel` | character varying(50) | YES |  |  |
| 11 | `payment_type` | character varying(50) | YES |  |  |
| 12 | `payment_no` | character varying(50) | YES |  |  |
| 13 | `payment_ref1` | character varying(50) | YES |  |  |
| 14 | `payment_ref2` | character varying(50) | YES |  |  |
| 15 | `payment_result` | character varying(50) | YES |  |  |
| 16 | `payment_date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 17 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 18 | `create_by` | character varying(50) | YES |  |  |
| 19 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 20 | `update_by` | character varying(50) | YES |  |  |
| 21 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 22 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 23 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 24 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 25 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 26 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 27 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 28 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 29 | `policy_book` | character varying(50) | YES |  | เลข book |
| 30 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 31 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 32 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 33 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 34 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 35 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 36 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 37 | `deli_flag` | boolean | YES |  | true = จัดส่งไปรษณีย์, false = Email |
| 38 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 39 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 40 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 41 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 42 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 43 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 44 | `promo_discount_sum` | numeric(16,4) | YES |  | ส่วนลด บาท สำหรับแสดงผลหน้าจอสรุป |
| 45 | `perm_amt_main` | numeric(16,4) | YES |  | ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจหลัก |
| 46 | `perm_amt_addon` | numeric(16,4) | YES |  | ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจเสริม |
| 47 | `partner_code` | character varying(10) | YES |  | โค้ดพาร์ทเนอร์ |
| 48 | `ta_travel_type_id` | smallint | YES | `1` | รูปแบบประกัน รายเที่ยว,รายปี |
| 49 | `total_insured_persons` | smallint | YES |  | จำนวนรวมบุคคลเอาประกัน ณ วันที่แสดงราคารวมใน lead |

**Primary key:** `lead_ta_no` (lead_ta_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `partner_code` → mas_partner, `promo_trans_id` → promo_code_trans, `ta_package_id` → mas_ta_package, `ta_travel_type_id` → mas_ta_travel_type

**Indexes:**

- `lead_ta_premium_pkey`: `CREATE UNIQUE INDEX lead_ta_premium_pkey ON insurverse.lead_ta_premium USING btree (lead_ta_no)`

---

## log_activity

`insurverse.log_activity` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.log_activity_id_seq'::regclass)` |  |
| 2 | `activity_type_id` | integer | NO |  |  |
| 3 | `detail` | character varying(255) | YES |  |  |
| 4 | `remark` | character varying(255) | YES |  |  |
| 5 | `response` | character varying(255) | YES |  |  |
| 6 | `created_at` | timestamp without time zone | NO |  |  |
| 7 | `created_by` | character varying(50) | NO |  |  |
| 8 | `car_inspect_date` | timestamp without time zone | YES |  |  |

**Primary key:** `id` (log_activity_pkey)

**Foreign keys:**

- `activity_type_id` → `insurverse.activity_type(id)` — fk_activity_type

**Indexes:**

- `log_activity_pkey`: `CREATE UNIQUE INDEX log_activity_pkey ON insurverse.log_activity USING btree (id)`

---

## log_activity_ref

`insurverse.log_activity_ref` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.log_activity_ref_id_seq'::regclass)` |  |
| 2 | `log_activity_id` | integer | NO |  |  |
| 3 | `ref_no` | character varying(50) | NO |  |  |

**Primary key:** `id` (log_activity_ref_pkey)

**Foreign keys:**

- `log_activity_id` → `insurverse.log_activity(id)` — fk_log_activity

**Indexes:**

- `log_activity_ref_pkey`: `CREATE UNIQUE INDEX log_activity_ref_pkey ON insurverse.log_activity_ref USING btree (id)`

---

## log_api_thaibulk

`insurverse.log_api_thaibulk` · kind: table · est. rows: **0**

> log send data to thaibulk

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `create_at` | timestamp without time zone | YES |  |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `ref1` | character varying(255) | YES |  |  |
| 12 | `ref2` | character varying(255) | YES |  |  |
| 13 | `ref3` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## log_calculate_premium

`insurverse.log_calculate_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `json` | character varying(500) | YES |  |  |
| 4 | `job_id` | character varying(100) | YES |  |  |

**Primary key:** `id` (log_sf_policy_copy1_pkey1)

**Indexes:**

- `log_sf_policy_copy1_pkey1`: `CREATE UNIQUE INDEX log_sf_policy_copy1_pkey1 ON insurverse.log_calculate_premium USING btree (id)`

---

## log_cmi_realtime

`insurverse.log_cmi_realtime` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp(6) without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(255) | YES |  |  |
| 12 | `car_act_no` | character varying(255) | YES |  |  |

**Primary key:** `id` (log_iia_policy_copy1_pkey1)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `policy_no` → Policy_Header

**Indexes:**

- `log_iia_policy_copy1_pkey1`: `CREATE UNIQUE INDEX log_iia_policy_copy1_pkey1 ON insurverse.log_cmi_realtime USING btree (id)`

---

## log_email_change

`insurverse.log_email_change` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ref_id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `flag_password_conf` | character varying(1) | YES |  | Y = ยืนยัน password แล้ว , N ยังไม่ยืนยัน |
| 3 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 4 | `prev_email` | character varying(255) | YES |  | email ที่ต้องการเปลี่ยน |
| 5 | `new_email` | character varying(255) | YES |  | email ใหม่ |
| 6 | `otp_ref_id` | character varying(50) | YES |  | อ้างอิง OTP ref_id |
| 7 | `flag_otp_conf` | character varying(1) | YES |  | Y = ยืนยัน OTP แล้ว , N ยังไม่ยืนยัน |
| 8 | `flag_otp_conf_at` | timestamp without time zone | YES |  | เวลาที่ OTP สำเร็จ |

**Primary key:** `ref_id` (log_email_change_pkey)

**Indexes:**

- `log_email_change_pkey`: `CREATE UNIQUE INDEX log_email_change_pkey ON insurverse.log_email_change USING btree (ref_id)`

---

## log_email_renewal

`insurverse.log_email_renewal` · kind: table · est. rows: **110**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `policy_no` | character varying(50) | YES |  |  |
| 4 | `is_send_email` | boolean | YES |  |  |
| 5 | `remark` | text | YES |  |  |
| 6 | `is_complete` | boolean | YES | `false` |  |
| 7 | `is_complete_at` | timestamp without time zone | YES |  |  |
| 8 | `update_at` | timestamp without time zone | YES | `now()` |  |

**Primary key:** `id` (log_email_renewal_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

**Indexes:**

- `log_email_renewal_pkey`: `CREATE UNIQUE INDEX log_email_renewal_pkey ON insurverse.log_email_renewal USING btree (id)`

---

## log_email_resend

`insurverse.log_email_resend` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(50) | YES |  |  |
| 12 | `car_act_no` | character varying(50) | YES |  |  |
| 13 | `sf_policy_id` | character varying(50) | YES |  |  |

**Primary key:** `id` (log_email_resend_pkey)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `policy_no` → Policy_Header

**Indexes:**

- `log_email_resend_pkey`: `CREATE UNIQUE INDEX log_email_resend_pkey ON insurverse.log_email_resend USING btree (id)`

---

## log_emcs_claim

`insurverse.log_emcs_claim` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(255) | YES |  |  |
| 12 | `car_act_no` | character varying(255) | YES |  |  |
| 13 | `ref_claim_no` | character varying(50) | YES |  |  |
| 14 | `e_claim_no` | character varying(50) | YES |  |  |

**Primary key:** `id` (log_emcs_claim_pkey)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `policy_no` → Policy_Header

**Indexes:**

- `log_emcs_claim_pkey`: `CREATE UNIQUE INDEX log_emcs_claim_pkey ON insurverse.log_emcs_claim USING btree (id)`

---

## log_etax_trans

`insurverse.log_etax_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(255) | YES |  |  |
| 12 | `car_act_no` | character varying(255) | YES |  |  |

**Primary key:** `id` (log_sf_policy_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `policy_no` → Policy_Header

**Indexes:**

- `log_sf_policy_copy1_pkey`: `CREATE UNIQUE INDEX log_sf_policy_copy1_pkey ON insurverse.log_etax_trans USING btree (id)`

---

## log_iia_claim

`insurverse.log_iia_claim` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `seq_id` | bigint | YES |  | หมายเลขลำดับการขอเรียกใช้เซอร์วิส ฝั่งทิพยะจะเริ่มต้นนับตั้งแต่ 1, 2, 3, … ไปเรื่อยๆ |
| 12 | `result` | bigint | YES |  | 0 (กรณีทิพยะได้รับข้อมูลครบถ้วน) หรือ 1 (กรณีทิพยะได้ข้อมูลไม่ครบ) |

**Primary key:** `id` (log_iia_policy_copy1_pkey3)

**Indexes:**

- `log_iia_policy_copy1_pkey3`: `CREATE UNIQUE INDEX log_iia_policy_copy1_pkey3 ON insurverse.log_iia_claim USING btree (id)`

---

## log_iia_policy

`insurverse.log_iia_policy` · kind: table · est. rows: **144**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(255) | YES |  |  |
| 12 | `car_act_no` | character varying(255) | YES |  |  |

**Primary key:** `id` (log_iia_policy_pkey)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `policy_no` → Policy_Header

**Indexes:**

- `log_iia_policy_pkey`: `CREATE UNIQUE INDEX log_iia_policy_pkey ON insurverse.log_iia_policy USING btree (id)`

---

## log_iia_policy_trans

`insurverse.log_iia_policy_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(255) | YES |  |  |

**Primary key:** `id` (log_iia_policy_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

**Indexes:**

- `log_iia_policy_trans_pkey`: `CREATE UNIQUE INDEX log_iia_policy_trans_pkey ON insurverse.log_iia_policy_trans USING btree (id)`

---

## log_internal_interface

`insurverse.log_internal_interface` · kind: table · est. rows: **2,328**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `ref1` | character varying(255) | YES |  |  |
| 12 | `ref2` | character varying(255) | YES |  |  |
| 13 | `ref3` | character varying(255) | YES |  |  |

**Primary key:** `id` (log_internal_interface_pkey)

**Indexes:**

- `log_internal_interface_pkey`: `CREATE UNIQUE INDEX log_internal_interface_pkey ON insurverse.log_internal_interface USING btree (id)`

---

## log_mobile

`insurverse.log_mobile` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 3 | `version_app` | character varying(10) | YES |  | application version |
| 4 | `user_id` | character varying(36) | YES |  | รหัสผู้ใช้งาน |
| 5 | `device_brand` | character varying(255) | YES |  | ยี่ห้ออุปกรณ์ |
| 6 | `device_model` | character varying(255) | YES |  | รุ่นอุปกรณ์ |
| 7 | `device_name` | character varying(255) | YES |  | ชื่ออุปกรณ์ |
| 8 | `device_platform` | character varying(255) | YES |  | os ของอุปกรณ์ |
| 9 | `source_type` | character varying(255) | YES |  | ประเภทแหล่งข้อมูล |
| 10 | `remark` | text | YES |  | รายละเอียด |

**Primary key:** `id` (log_mobile_pkey)

**Indexes:**

- `log_mobile_pkey`: `CREATE UNIQUE INDEX log_mobile_pkey ON insurverse.log_mobile USING btree (id)`

---

## log_noti_push

`insurverse.log_noti_push` · kind: table · est. rows: **106**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |

**Primary key:** `id` (log_noti_push_pkey)

**Indexes:**

- `log_noti_push_pkey`: `CREATE UNIQUE INDEX log_noti_push_pkey ON insurverse.log_noti_push USING btree (id)`

---

## log_noti_renewal

`insurverse.log_noti_renewal` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` | วันที่แจ้งเตือน |
| 3 | `policy_no` | character varying(50) | YES |  | เลขกรมธรรม์ |
| 4 | `premium_amt` | numeric | YES |  | เบี้ยประกันกรมธรรม์ก่อน duty vat |
| 5 | `duty_amt` | numeric | YES |  | ค่าอากร |
| 6 | `vat_amt` | numeric | YES |  | ค่า Vat |
| 7 | `total_amt` | numeric | YES |  | เบี้ยที่ลูกค้าต้องชำระ |
| 8 | `msg_html_body` | text | YES |  |  |
| 9 | `msg_sms_body` | text | YES |  |  |
| 10 | `noti_email_at` | timestamp without time zone | YES |  |  |
| 11 | `noti_sms_at` | timestamp without time zone | YES |  |  |
| 12 | `noti_push_at` | timestamp without time zone | YES |  |  |
| 13 | `msg_push_body` | text | YES |  |  |
| 14 | `is_active` | boolean | YES | `true` |  |
| 15 | `msg_html_title` | text | YES |  |  |
| 16 | `is_renewal` | boolean | YES |  | true = สามารถต่ออายุได้ , false = ไม่สามารถต่ออายุได้ไป flow diy |
| 17 | `error_code` | text | YES |  | รหัสข้อผิดพลาด |
| 18 | `return_message` | text | YES |  | รายละเอียดต้องกาแสดงเพิ่มเติม |
| 19 | `noti_code` | character varying(50) | YES |  | mapping สำหรับตรวจสอบว่าเป็นการแจ้งเตือนจากขั้นตอนใด |
| 20 | `remark` | text | YES |  | note เพิ่มเติม |
| 21 | `car_inspection_email_at` | timestamp without time zone | YES |  |  |
| 22 | `car_inspection_sms_at` | timestamp without time zone | YES |  |  |

**Primary key:** `id` (log_noti_renewal_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

**Indexes:**

- `log_noti_renewal_pkey`: `CREATE UNIQUE INDEX log_noti_renewal_pkey ON insurverse.log_noti_renewal USING btree (id)`

---

## log_openapi_interface

`insurverse.log_openapi_interface` · kind: table · est. rows: **455**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO |  |  |
| 2 | `request_id` | character varying(255) | YES |  |  |
| 3 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 4 | `api_name` | character varying(500) | YES |  |  |
| 5 | `api_url` | character varying(2000) | YES |  |  |
| 6 | `api_method` | character varying(255) | YES |  |  |
| 7 | `request_header` | character varying(5000) | YES |  |  |
| 8 | `request_body` | text | YES |  |  |
| 9 | `response_status` | smallint | YES |  |  |
| 10 | `response_body` | text | YES |  |  |
| 11 | `remark` | text | YES |  |  |
| 12 | `partner_code` | character varying(10) | YES |  |  |

**Primary key:** `id` (log_openapi_interface_pk)

**Inferred references (naming convention, NOT enforced FK):** `partner_code` → mas_partner

**Indexes:**

- `log_openapi_interface_pk`: `CREATE UNIQUE INDEX log_openapi_interface_pk ON insurverse.log_openapi_interface USING btree (id)`

---

## log_point_expire

`insurverse.log_point_expire` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `result` | boolean | YES |  |  |
| 4 | `msg` | text | YES |  |  |
| 5 | `body` | text | YES |  |  |
| 6 | `remark` | text | YES |  |  |
| 7 | `fn_name` | text | YES |  |  |

**Primary key:** `id` (log_point_expire_pkey)

**Indexes:**

- `log_point_expire_pkey`: `CREATE UNIQUE INDEX log_point_expire_pkey ON insurverse.log_point_expire USING btree (id)`

---

## log_priceza

`insurverse.log_priceza` · kind: table · est. rows: **1**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.log_priceza_id_seq'::regclass)` |  |
| 2 | `c` | character varying(50) | NO |  | priceza timestamp |
| 3 | `t` | character varying(50) | NO |  | type such as purchase |
| 4 | `m` | character varying(50) | NO |  | merchant id |
| 5 | `p` | character varying(50) | NO |  | product type |
| 6 | `v` | character varying(100) | NO |  | perm amount (before vat and duty) |
| 7 | `f` | character varying(10) | NO |  | payment method CC = credit card |
| 8 | `d` | character varying(100) | NO |  | invoice no |
| 9 | `u` | text | NO |  | url |
| 10 | `clickid` | character varying(255) | NO |  | click id  |
| 11 | `createdate` | timestamp without time zone | YES | `now()` | db timestamp |

**Primary key:** `id` (log_priceza_pkey)

**Indexes:**

- `idx_log_priceza_d_t`: `CREATE INDEX idx_log_priceza_d_t ON insurverse.log_priceza USING btree (d, t)`
- `log_priceza_pkey`: `CREATE UNIQUE INDEX log_priceza_pkey ON insurverse.log_priceza USING btree (id)`

---

## log_request_home

`insurverse.log_request_home` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `request_type` | character varying(50) | NO |  | cancel=ยกเลิก,endorse=แก้ไข |
| 4 | `subject` | character varying(500) | YES |  | หัวข้อแจ้งสลักหลัง |
| 5 | `body` | text | YES |  | รายละเอียดการแก้ไข |
| 6 | `request_status` | character varying(50) | YES |  | open=แจ้งขอ,process=ดำเนินการ,approve=อนุมัติ,cancel=ยกเลิก |
| 7 | `iia_request_no` | character varying(50) | YES |  | รหัสอ้างอิง IIA |
| 8 | `remark` | text | YES |  | รายละเอียดอื่นๆ |
| 9 | `policy_home_no` | character varying(50) | YES |  | เลขกรมธรรม์ Home |
| 10 | `update_at` | timestamp without time zone | YES | `now()` |  |
| 11 | `iia_response_at` | timestamp without time zone | YES |  | เวลา IIA อัพเดตล่าสุด |
| 12 | `appr_title` | character varying(50) | YES |  |  |
| 13 | `appr_firstname` | character varying(50) | YES |  |  |
| 14 | `appr_lastname` | character varying(50) | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `policy_home_no` → policy_home_premium

---

## log_request_pa

`insurverse.log_request_pa` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `request_type` | character varying(50) | NO |  | cancel=ยกเลิก,endorse=แก้ไข |
| 4 | `subject` | character varying(500) | YES |  | หัวข้อแจ้งสลักหลัง |
| 5 | `body` | text | YES |  | รายละเอียดการแก้ไข |
| 6 | `request_status` | character varying(50) | YES |  | open=แจ้งขอ,process=ดำเนินการ,approve=อนุมัติ,cancel=ยกเลิก |
| 7 | `iia_request_no` | character varying(50) | YES |  | รหัสอ้างอิง IIA |
| 8 | `remark` | text | YES |  | รายละเอียดอื่นๆ |
| 9 | `policy_pa_no` | character varying(50) | YES |  | เลขกรมธรรม์ PA |
| 10 | `update_at` | timestamp without time zone | YES | `now()` |  |
| 11 | `iia_response_at` | timestamp without time zone | YES |  | เวลา IIA อัพเดตล่าสุด |
| 12 | `appr_title` | character varying(50) | YES |  |  |
| 13 | `appr_firstname` | character varying(50) | YES |  |  |
| 14 | `appr_lastname` | character varying(50) | YES |  |  |

**Primary key:** `id` (log_request_pa_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_pa_no` → policy_pa_premium

**Indexes:**

- `log_request_pa_pkey`: `CREATE UNIQUE INDEX log_request_pa_pkey ON insurverse.log_request_pa USING btree (id)`

---

## log_request_ta

`insurverse.log_request_ta` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `insurverse.uuid_generate_v4()` |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `request_type` | character varying(50) | NO |  | cancel=ยกเลิก,endorse=แก้ไข |
| 4 | `subject` | character varying(500) | YES |  | หัวข้อแจ้งสลักหลัง |
| 5 | `body` | text | YES |  | รายละเอียดการแก้ไข |
| 6 | `request_status` | character varying(50) | YES |  | open=แจ้งขอ,process=ดำเนินการ,approve=อนุมัติ,cancel=ยกเลิก |
| 7 | `iia_request_no` | character varying(50) | YES |  | รหัสอ้างอิง IIA |
| 8 | `remark` | text | YES |  | รายละเอียดอื่นๆ |
| 9 | `policy_ta_no` | character varying(50) | YES |  | เลขกรมธรรม์ TA |
| 10 | `update_at` | timestamp without time zone | YES | `now()` |  |
| 11 | `iia_response_at` | timestamp without time zone | YES |  | เวลา IIA อัพเดตล่าสุด |
| 12 | `appr_title` | character varying(50) | YES |  |  |
| 13 | `appr_firstname` | character varying(50) | YES |  |  |
| 14 | `appr_lastname` | character varying(50) | YES |  |  |

**Primary key:** `id` (log_request_ta_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_ta_no` → policy_ta_premium

**Indexes:**

- `log_request_ta_pkey`: `CREATE UNIQUE INDEX log_request_ta_pkey ON insurverse.log_request_ta USING btree (id)`

---

## log_sf_policy

`insurverse.log_sf_policy` · kind: table · est. rows: **804**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `policy_no` | character varying(255) | YES |  |  |
| 12 | `car_act_no` | character varying(255) | YES |  |  |

**Primary key:** `id` (log_iia_policy_copy1_pkey2)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `policy_no` → Policy_Header

**Indexes:**

- `log_iia_policy_copy1_pkey2`: `CREATE UNIQUE INDEX log_iia_policy_copy1_pkey2 ON insurverse.log_sf_policy USING btree (id)`

---

## log_sf_policy_trans

`insurverse.log_sf_policy_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `policy_no` | character varying(255) | YES |  |  |
| 4 | `car_act_no` | character varying(255) | YES |  |  |
| 5 | `policy_type` | character(1) | YES |  | V= สมัครใจ, C= พรบ |
| 6 | `type` | character varying(2000) | YES |  | ชื่อ Field แบบ Array ที่ต้องการสลักหลัง |
| 7 | `owner_prefix_name` | character varying(50) | YES |  |  |
| 8 | `owner_first_name` | character varying(255) | YES |  |  |
| 9 | `owner_last_name` | character varying(255) | YES |  |  |
| 10 | `owner_address` | character varying(500) | YES |  |  |
| 11 | `owner_province_id` | character varying(255) | YES |  |  |
| 12 | `owner_province_name` | character varying(255) | YES |  |  |
| 13 | `owner_district_id` | character varying(255) | YES |  |  |
| 14 | `owner_district_name` | character varying(255) | YES |  |  |
| 15 | `owner_subdistrict_id` | character varying(255) | YES |  |  |
| 16 | `owner_subdistrict_name` | character varying(255) | YES |  |  |
| 17 | `owner_zipcode` | character varying(10) | YES |  |  |
| 18 | `car_license_no` | character varying(10) | YES |  |  |
| 19 | `car_license_provice` | character varying(255) | YES |  |  |
| 20 | `car_brand` | character varying(255) | YES |  |  |
| 21 | `car_model` | character varying(255) | YES |  |  |
| 22 | `car_cc` | character varying(255) | YES |  |  |
| 23 | `start_date` | character varying(255) | YES |  |  |
| 24 | `end_date` | character varying(255) | YES |  |  |
| 25 | `appr_prefix_name` | character varying(50) | YES |  |  |
| 26 | `appr_first_name` | character varying(255) | YES |  |  |
| 27 | `appr_last_name` | character varying(255) | YES |  |  |
| 28 | `sf_trans_id` | character varying(50) | YES |  |  |
| 29 | `doc_type` | character varying(500) | YES |  | ประเภทเอกสาร รย |
| 30 | `car_serial_no` | character varying(255) | YES |  |  |
| 31 | `effective_date` | character varying(255) | YES |  |  |
| 32 | `owner_birthdate` | character varying(255) | YES |  |  |
| 33 | `owner_card_id` | character varying(255) | YES |  |  |
| 34 | `deli_address` | character varying(500) | YES |  |  |
| 35 | `deli_province_id` | character varying(255) | YES |  |  |
| 36 | `deli_subdistrict_id` | character varying(255) | YES |  |  |
| 37 | `deli_district_id` | character varying(255) | YES |  |  |
| 38 | `deli_zipcode` | character varying(255) | YES |  |  |
| 39 | `bene_type` | character varying(255) | YES |  |  |
| 40 | `bene_firstname` | character varying(255) | YES |  |  |
| 41 | `bene_lastname` | character varying(255) | YES |  |  |
| 42 | `par1_prefix` | character varying(50) | YES |  |  |
| 43 | `par1_firstname` | character varying(255) | YES |  |  |
| 44 | `par1_lastname` | character varying(255) | YES |  |  |
| 45 | `par1_driver_no` | character varying(255) | YES |  |  |
| 46 | `par2_prefix` | character varying(50) | YES |  |  |
| 47 | `par2_firstname` | character varying(255) | YES |  |  |
| 48 | `par2_lastname` | character varying(255) | YES |  |  |
| 49 | `par2_driver_no` | character varying(255) | YES |  |  |
| 50 | `salesforce_id` | character varying(18) | YES |  |  |
| 51 | `car_color` | character varying(255) | YES |  |  |
| 52 | `car_license_type` | character varying(255) | YES |  |  |
| 53 | `appr_status` | character varying(255) | YES |  |  |
| 54 | `appr_comment` | character varying(4000) | YES |  |  |
| 55 | `drive_action` | character varying(255) | YES |  |  |
| 56 | `coverage_detail` | json | YES |  |  |
| 57 | `deli_flag` | character varying(10) | YES |  |  |
| 58 | `status` | character varying(50) | YES |  |  |
| 59 | `car_color_id` | character varying(50) | YES |  |  |
| 60 | `par1_citizen_id` | character varying(20) | YES |  |  |
| 61 | `par2_citizen_id` | character varying(20) | YES |  |  |
| 62 | `bene_title` | character varying(255) | YES |  | คำนำหน้าผู้รับผลประโยชน์ |
| 63 | `par3_prefix` | character varying(50) | YES |  | คำนำหน้าผู้ขับขี่ 3 |
| 64 | `par4_prefix` | character varying(50) | YES |  | คำนำหน้าผู้ขับขี่ 4 |
| 65 | `par3_firstname` | character varying(255) | YES |  | ชื่อผู้ขับขี่ 3 |
| 66 | `par3_lastname` | character varying(255) | YES |  | นามสกุลผู้ขับขี่ 3 |
| 67 | `par3_driver_no` | character varying(255) | YES |  | หมายเลขผู้ขับขี่ 3 |
| 68 | `par3_citizen_id` | character varying(20) | YES |  | หมายเลขบัตรประชาชนผู้ขับขี่ 3 |
| 69 | `par4_firstname` | character varying(255) | YES |  | ชื่อผู้ขับขี่ 4 |
| 70 | `par4_lastname` | character varying(255) | YES |  | นามสกุลผู้ขับขี่ 4 |
| 71 | `par4_driver_no` | character varying(255) | YES |  | หมายเลขผู้ขับขี่ 4 |
| 72 | `par4_citizen_id` | character varying(20) | YES |  | หมายเลขบัตรประชาชนผู้ขับขี่ 4 |
| 73 | `par5_prefix` | character varying(50) | YES |  | คำนำหน้าผู้ขับขี่ 5 |
| 74 | `par5_firstname` | character varying(255) | YES |  | ชื่อผู้ขับขี่ 5 |
| 75 | `par5_lastname` | character varying(255) | YES |  | นามสกุลผู้ขับขี่ 5 |
| 76 | `par5_driver_no` | character varying(255) | YES |  | หมายเลขผู้ขับขี่ 5 |
| 77 | `par5_citizen_id` | character varying(20) | YES |  | หมายเลขบัตรประชาชนผู้ขับขี่ 5 |
| 78 | `sc_premium_amt` | character varying(255) | YES |  | เบี้ยซ่อมศูนย์ |
| 79 | `garage_type` | character varying(50) | YES |  | ประเภทอู่ |
| 80 | `package_id` | character varying(255) | YES |  | รหัสแพ็กเกจประกัน |
| 81 | `par1_occupation` | character varying(255) | YES |  | อาชีพผู้ขับขี่ 1 |
| 82 | `par2_occupation` | character varying(255) | YES |  | อาชีพผู้ขับขี่ 2 |
| 83 | `par3_occupation` | character varying(255) | YES |  | อาชีพผู้ขับขี่ 3 |
| 84 | `par4_occupation` | character varying(255) | YES |  | อาชีพผู้ขับขี่ 4 |
| 85 | `par5_occupation` | character varying(255) | YES |  | อาชีพผู้ขับขี่ 5 |
| 86 | `driver_behavior1` | character varying(255) | YES |  | พฤติกรรมผู้ขับขี่ 1 |
| 87 | `driver_behavior2` | character varying(255) | YES |  | พฤติกรรมผู้ขับขี่ 2 |
| 88 | `driver_behavior3` | character varying(255) | YES |  | พฤติกรรมผู้ขับขี่ 3 |
| 89 | `driver_behavior4` | character varying(255) | YES |  | พฤติกรรมผู้ขับขี่ 4 |
| 90 | `driver_behavior5` | character varying(255) | YES |  | พฤติกรรมผู้ขับขี่ 5 |
| 91 | `driver_consent1` | character varying(255) | YES |  | ยินยอมพฤติกรรมผู้ขับขี่ 1 |
| 92 | `driver_consent2` | character varying(255) | YES |  | ยินยอมพฤติกรรมผู้ขับขี่ 2 |
| 93 | `driver_consent3` | character varying(255) | YES |  | ยินยอมพฤติกรรมผู้ขับขี่ 3 |
| 94 | `driver_consent4` | character varying(255) | YES |  | ยินยอมพฤติกรรมผู้ขับขี่ 4 |
| 95 | `driver_consent5` | character varying(255) | YES |  | ยินยอมพฤติกรรมผู้ขับขี่ 5 |
| 96 | `owner_occupation` | character varying(255) | YES |  | อาชีพเจ้าของกรมธรรม์ |
| 97 | `driver_behavior_summary` | bigint | YES |  | พฤติกรรมผู้ขับขี่ |
| 98 | `driver_behavior_tariff` | real | YES |  | tariff พฤติกรรมผู้ขับขี่ |
| 99 | `driver_behavior_disc` | real | YES |  | ส่วนลดพฤติกรรมผู้ขับขี่ |
| 100 | `driver_birthdate1` | character varying(255) | YES |  | วันเกิดผู้ขับขี่ 1 |
| 101 | `driver_birthdate2` | character varying(255) | YES |  | วันเกิดผู้ขับขี่ 2 |
| 102 | `driver_birthdate3` | character varying(255) | YES |  | วันเกิดผู้ขับขี่ 3 |
| 103 | `driver_birthdate4` | character varying(255) | YES |  | วันเกิดผู้ขับขี่ 4 |
| 104 | `driver_birthdate5` | character varying(255) | YES |  | วันเกิดผู้ขับขี่ 5 |
| 105 | `refund_type` | text | YES |  |  |
| 106 | `par1_driver_license_category` | character varying(20) | YES |  |  |
| 107 | `par2_driver_license_category` | character varying(20) | YES |  |  |
| 108 | `par3_driver_license_category` | character varying(20) | YES |  |  |
| 109 | `par4_driver_license_category` | character varying(20) | YES |  |  |
| 110 | `par5_driver_license_category` | character varying(20) | YES |  |  |

**Primary key:** `id` (log_iia_policy_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `owner_district_id` → district, `owner_province_id` → province, `owner_subdistrict_id` → subdistrict, `package_id` → tqm_package_config, `policy_no` → Policy_Header

**Indexes:**

- `log_iia_policy_copy1_pkey`: `CREATE UNIQUE INDEX log_iia_policy_copy1_pkey ON insurverse.log_sf_policy_trans USING btree (id)`

---

## log_sf_policy_trans_20260810

`insurverse.log_sf_policy_trans_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `create_at` | timestamp(6) without time zone | YES |  |  |
| 3 | `policy_no` | character varying(255) | YES |  |  |
| 4 | `car_act_no` | character varying(255) | YES |  |  |
| 5 | `policy_type` | character(1) | YES |  |  |
| 6 | `type` | character varying(2000) | YES |  |  |
| 7 | `owner_prefix_name` | character varying(50) | YES |  |  |
| 8 | `owner_first_name` | character varying(255) | YES |  |  |
| 9 | `owner_last_name` | character varying(255) | YES |  |  |
| 10 | `owner_address` | character varying(500) | YES |  |  |
| 11 | `owner_province_id` | character varying(255) | YES |  |  |
| 12 | `owner_province_name` | character varying(255) | YES |  |  |
| 13 | `owner_district_id` | character varying(255) | YES |  |  |
| 14 | `owner_district_name` | character varying(255) | YES |  |  |
| 15 | `owner_subdistrict_id` | character varying(255) | YES |  |  |
| 16 | `owner_subdistrict_name` | character varying(255) | YES |  |  |
| 17 | `owner_zipcode` | character varying(10) | YES |  |  |
| 18 | `car_license_no` | character varying(10) | YES |  |  |
| 19 | `car_license_provice` | character varying(255) | YES |  |  |
| 20 | `car_brand` | character varying(255) | YES |  |  |
| 21 | `car_model` | character varying(255) | YES |  |  |
| 22 | `car_cc` | character varying(255) | YES |  |  |
| 23 | `start_date` | character varying(255) | YES |  |  |
| 24 | `end_date` | character varying(255) | YES |  |  |
| 25 | `appr_prefix_name` | character varying(50) | YES |  |  |
| 26 | `appr_first_name` | character varying(255) | YES |  |  |
| 27 | `appr_last_name` | character varying(255) | YES |  |  |
| 28 | `sf_trans_id` | character varying(50) | YES |  |  |
| 29 | `doc_type` | character varying(500) | YES |  |  |
| 30 | `car_serial_no` | character varying(255) | YES |  |  |
| 31 | `effective_date` | character varying(255) | YES |  |  |
| 32 | `owner_birthdate` | character varying(255) | YES |  |  |
| 33 | `owner_card_id` | character varying(255) | YES |  |  |
| 34 | `deli_address` | character varying(500) | YES |  |  |
| 35 | `deli_province_id` | character varying(255) | YES |  |  |
| 36 | `deli_subdistrict_id` | character varying(255) | YES |  |  |
| 37 | `deli_district_id` | character varying(255) | YES |  |  |
| 38 | `deli_zipcode` | character varying(255) | YES |  |  |
| 39 | `bene_type` | character varying(255) | YES |  |  |
| 40 | `bene_firstname` | character varying(255) | YES |  |  |
| 41 | `bene_lastname` | character varying(255) | YES |  |  |
| 42 | `par1_prefix` | character varying(50) | YES |  |  |
| 43 | `par1_firstname` | character varying(255) | YES |  |  |
| 44 | `par1_lastname` | character varying(255) | YES |  |  |
| 45 | `par1_driver_no` | character varying(255) | YES |  |  |
| 46 | `par2_prefix` | character varying(50) | YES |  |  |
| 47 | `par2_firstname` | character varying(255) | YES |  |  |
| 48 | `par2_lastname` | character varying(255) | YES |  |  |
| 49 | `par2_driver_no` | character varying(255) | YES |  |  |
| 50 | `salesforce_id` | character varying(18) | YES |  |  |
| 51 | `car_color` | character varying(255) | YES |  |  |
| 52 | `car_license_type` | character varying(255) | YES |  |  |
| 53 | `appr_status` | character varying(255) | YES |  |  |
| 54 | `appr_comment` | character varying(4000) | YES |  |  |
| 55 | `drive_action` | character varying(255) | YES |  |  |
| 56 | `coverage_detail` | json | YES |  |  |
| 57 | `deli_flag` | character varying(10) | YES |  |  |
| 58 | `status` | character varying(50) | YES |  |  |
| 59 | `car_color_id` | character varying(50) | YES |  |  |
| 60 | `par1_citizen_id` | character varying(20) | YES |  |  |
| 61 | `par2_citizen_id` | character varying(20) | YES |  |  |
| 62 | `bene_title` | character varying(255) | YES |  |  |
| 63 | `par3_prefix` | character varying(50) | YES |  |  |
| 64 | `par4_prefix` | character varying(50) | YES |  |  |
| 65 | `par3_firstname` | character varying(255) | YES |  |  |
| 66 | `par3_lastname` | character varying(255) | YES |  |  |
| 67 | `par3_driver_no` | character varying(255) | YES |  |  |
| 68 | `par3_citizen_id` | character varying(20) | YES |  |  |
| 69 | `par4_firstname` | character varying(255) | YES |  |  |
| 70 | `par4_lastname` | character varying(255) | YES |  |  |
| 71 | `par4_driver_no` | character varying(255) | YES |  |  |
| 72 | `par4_citizen_id` | character varying(20) | YES |  |  |
| 73 | `par5_prefix` | character varying(50) | YES |  |  |
| 74 | `par5_firstname` | character varying(255) | YES |  |  |
| 75 | `par5_lastname` | character varying(255) | YES |  |  |
| 76 | `par5_driver_no` | character varying(255) | YES |  |  |
| 77 | `par5_citizen_id` | character varying(20) | YES |  |  |
| 78 | `sc_premium_amt` | character varying(255) | YES |  |  |
| 79 | `garage_type` | character varying(50) | YES |  |  |
| 80 | `package_id` | character varying(255) | YES |  |  |
| 81 | `par1_occupation` | character varying(255) | YES |  |  |
| 82 | `par2_occupation` | character varying(255) | YES |  |  |
| 83 | `par3_occupation` | character varying(255) | YES |  |  |
| 84 | `par4_occupation` | character varying(255) | YES |  |  |
| 85 | `par5_occupation` | character varying(255) | YES |  |  |
| 86 | `driver_behavior1` | character varying(255) | YES |  |  |
| 87 | `driver_behavior2` | character varying(255) | YES |  |  |
| 88 | `driver_behavior3` | character varying(255) | YES |  |  |
| 89 | `driver_behavior4` | character varying(255) | YES |  |  |
| 90 | `driver_behavior5` | character varying(255) | YES |  |  |
| 91 | `driver_consent1` | character varying(255) | YES |  |  |
| 92 | `driver_consent2` | character varying(255) | YES |  |  |
| 93 | `driver_consent3` | character varying(255) | YES |  |  |
| 94 | `driver_consent4` | character varying(255) | YES |  |  |
| 95 | `driver_consent5` | character varying(255) | YES |  |  |
| 96 | `owner_occupation` | character varying(255) | YES |  |  |
| 97 | `driver_behavior_summary` | bigint | YES |  |  |
| 98 | `driver_behavior_tariff` | real | YES |  |  |
| 99 | `driver_behavior_disc` | real | YES |  |  |
| 100 | `driver_birthdate1` | character varying(255) | YES |  |  |
| 101 | `driver_birthdate2` | character varying(255) | YES |  |  |
| 102 | `driver_birthdate3` | character varying(255) | YES |  |  |
| 103 | `driver_birthdate4` | character varying(255) | YES |  |  |
| 104 | `driver_birthdate5` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## log_sf_policy_trans_request

`insurverse.log_sf_policy_trans_request` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `policy_no` | character varying(255) | YES |  |  |
| 4 | `car_act_no` | character varying(255) | YES |  |  |
| 5 | `policy_type` | character(1) | YES |  | V= สมัครใจ, C= พรบ |
| 6 | `type` | character varying(2000) | YES |  | ชื่อ Field แบบ Array ที่ต้องการสลักหลัง |
| 7 | `owner_prefix_name` | character varying(50) | YES |  |  |
| 8 | `owner_first_name` | character varying(255) | YES |  |  |
| 9 | `owner_last_name` | character varying(255) | YES |  |  |
| 10 | `owner_address` | character varying(500) | YES |  |  |
| 11 | `owner_province_id` | character varying(255) | YES |  |  |
| 12 | `owner_province_name` | character varying(255) | YES |  |  |
| 13 | `owner_district_id` | character varying(255) | YES |  |  |
| 14 | `owner_district_name` | character varying(255) | YES |  |  |
| 15 | `owner_subdistrict_id` | character varying(255) | YES |  |  |
| 16 | `owner_subdistrict_name` | character varying(255) | YES |  |  |
| 17 | `owner_zipcode` | character varying(10) | YES |  |  |
| 18 | `car_license_no` | character varying(10) | YES |  |  |
| 19 | `car_license_province` | character varying(255) | YES |  |  |
| 20 | `car_brand` | character varying(255) | YES |  |  |
| 21 | `car_model` | character varying(255) | YES |  |  |
| 22 | `car_cc` | character varying(255) | YES |  |  |
| 23 | `start_date` | character varying(255) | YES |  |  |
| 24 | `end_date` | character varying(255) | YES |  |  |
| 25 | `appr_prefix_name` | character varying(50) | YES |  |  |
| 26 | `appr_first_name` | character varying(255) | YES |  |  |
| 27 | `appr_last_name` | character varying(255) | YES |  |  |
| 28 | `sf_trans_id` | character varying(50) | YES |  |  |
| 29 | `doc_type` | character varying(500) | YES |  | ประเภทเอกสาร รย |
| 30 | `car_serial_no` | character varying(255) | YES |  |  |
| 31 | `effective_date` | character varying(255) | YES |  |  |
| 32 | `owner_birthdate` | character varying(255) | YES |  |  |
| 33 | `owner_card_id` | character varying(255) | YES |  |  |
| 34 | `deli_address` | character varying(500) | YES |  |  |
| 35 | `deli_province_id` | character varying(255) | YES |  |  |
| 36 | `deli_subdistrict_id` | character varying(255) | YES |  |  |
| 37 | `deli_district_id` | character varying(255) | YES |  |  |
| 38 | `deli_zipcode` | character varying(255) | YES |  |  |
| 39 | `bene_type` | character varying(255) | YES |  |  |
| 40 | `bene_firstname` | character varying(255) | YES |  |  |
| 41 | `bene_lastname` | character varying(255) | YES |  |  |
| 42 | `par1_prefix` | character varying(50) | YES |  |  |
| 43 | `par1_firstname` | character varying(255) | YES |  |  |
| 44 | `par1_lastname` | character varying(255) | YES |  |  |
| 45 | `par1_driver_no` | character varying(255) | YES |  |  |
| 46 | `par2_prefix` | character varying(50) | YES |  |  |
| 47 | `par2_firstname` | character varying(255) | YES |  |  |
| 48 | `par2_lastname` | character varying(255) | YES |  |  |
| 49 | `par2_driver_no` | character varying(255) | YES |  |  |
| 50 | `salesforce_id` | character varying(18) | YES |  |  |
| 51 | `car_color` | character varying(255) | YES |  |  |
| 52 | `car_license_type` | character varying(255) | YES |  |  |
| 53 | `appr_status` | character varying(255) | YES |  |  |
| 54 | `appr_comment` | character varying(4000) | YES |  |  |
| 55 | `drive_action` | character varying(255) | YES |  |  |
| 56 | `source` | character varying(255) | YES |  | PWA หรือ Mobile |
| 57 | `salesforce_id_at` | timestamp without time zone | YES |  | วันที่รับ endorsmentSFId จาก response  |
| 58 | `salesforce_callback_at` | timestamp without time zone | YES |  | วันที่ Callback update appr_status |
| 59 | `deli_flag` | character varying(10) | YES |  |  |
| 60 | `status` | character varying(50) | YES |  |  |
| 61 | `car_color_id` | character varying(50) | YES |  |  |
| 62 | `par1_citizen_id` | character varying(20) | YES |  |  |
| 63 | `par2_citizen_id` | character varying(20) | YES |  |  |
| 64 | `basic_prem_amt` | numeric(16,2) | YES |  |  |
| 65 | `basic_prem_v5_amt` | numeric(16,2) | YES |  |  |
| 66 | `usage` | integer | YES |  |  |
| 67 | `usage_tariff` | numeric(10,4) | YES |  |  |
| 68 | `car_cc_condition` | character varying(255) | YES |  |  |
| 69 | `car_cc_tariff` | numeric(10,4) | YES |  |  |
| 70 | `driver_brithdate_1` | date | YES |  |  |
| 71 | `driver_brithdate_2` | date | YES |  |  |
| 72 | `driver_age` | character varying(255) | YES |  |  |
| 73 | `driver_age_disc` | numeric(16,2) | YES |  |  |
| 74 | `driver_age_tariff` | numeric(10,4) | YES |  |  |
| 75 | `car_year` | character varying(4) | YES |  |  |
| 76 | `car_year_tariff` | numeric(10,4) | YES |  |  |
| 77 | `si_amt` | numeric(16,2) | YES |  |  |
| 78 | `access_have` | boolean | YES |  |  |
| 79 | `access_si_amt` | numeric(16,2) | YES |  |  |
| 80 | `access_name` | text | YES |  |  |
| 81 | `car_group` | character varying(255) | YES |  |  |
| 82 | `car_group_tariff` | numeric(10,4) | YES |  |  |
| 83 | `tpbi_pass_si_amt` | numeric(16,2) | YES |  |  |
| 84 | `tpbi_pass_tariff` | numeric(10,4) | YES |  |  |
| 85 | `tpbi_event_si_amt` | numeric(16,2) | YES |  |  |
| 86 | `tpbi_event_tariff` | numeric(10,4) | YES |  |  |
| 87 | `tppd_si_amt` | numeric(16,2) | YES |  |  |
| 88 | `tppd_tariff` | numeric(10,4) | YES |  |  |
| 89 | `total_ex_mv_amt` | numeric(16,2) | YES |  |  |
| 90 | `premium_v5_od` | numeric(16,2) | YES |  |  |
| 91 | `mv01_si_amt` | numeric(16,2) | YES |  |  |
| 92 | `mv01_prem_amt` | numeric(16,2) | YES |  |  |
| 93 | `mv02_si_amt` | numeric(16,2) | YES |  |  |
| 94 | `mv02_prem_amt` | numeric(16,2) | YES |  |  |
| 95 | `mv03_si_amt` | numeric(16,2) | YES |  |  |
| 96 | `mv03_prem_amt` | numeric(16,2) | YES |  |  |
| 97 | `cctv_have` | boolean | YES |  |  |
| 98 | `cctv_percent` | numeric(10,4) | YES |  |  |
| 99 | `fleet_disc_per` | numeric(10,4) | YES |  |  |
| 100 | `fleet_disc_amt` | numeric(16,2) | YES |  |  |
| 101 | `ncb_disc_per` | numeric(10,4) | YES |  |  |
| 102 | `ncb_disc_amt` | numeric(16,2) | YES |  |  |
| 103 | `other_disc_per` | numeric(10,4) | YES |  |  |
| 104 | `other_disc_amt` | numeric(16,2) | YES |  |  |
| 105 | `extend_enddate` | timestamp without time zone | YES |  |  |
| 106 | `extend_prem_amt` | numeric(16,2) | YES |  |  |
| 107 | `duty_amt` | numeric(16,2) | YES |  |  |
| 108 | `vat_amt` | numeric(16,2) | YES |  |  |
| 109 | `request_body` | text | YES |  |  |
| 110 | `owner_occupation` | character varying(255) | YES |  | อาชีพเจ้าของกรม |
| 111 | `owner_occupation_code` | character varying(50) | YES |  | รหัส อาชีพเจ้าของกรม |
| 112 | `bene_occupation` | character varying(255) | YES |  | อาชีพผู้รับผลประโยชน์ |
| 113 | `bene_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้รับผลประโยชน์ |
| 114 | `par1_occupation` | character varying(255) | YES |  | อาชีพผู้ผู้ขับขี่ 1 |
| 115 | `par1_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้ผู้ขับขี่ 1 |
| 116 | `par1_driver_behavior` | integer | YES |  | ระดับ พฤติกรรมผู้ขับขี่ 1 |
| 117 | `par2_occupation` | character varying(255) | YES |  | อาชีพผู้ผู้ขับขี่ 2 |
| 118 | `par2_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้ผู้ขับขี่ 2 |
| 119 | `par2_driver_behavior` | integer | YES |  | ระดับ พฤติกรรมผู้ขับขี่ 2 |
| 120 | `par3_prefix` | character varying(50) | YES |  | คำนำหน้าชื่อขับขี่ 3 |
| 121 | `par3_prefix_code` | character varying(50) | YES |  | รหัสคำนำหน้าชื่อขับขี่ 3 |
| 122 | `par3_firstname` | character varying(255) | YES |  | ชื่อขับขี่ 3 (ชื่อ) |
| 123 | `par3_lastname` | character varying(255) | YES |  | ชื่อขับขี่ 3 (นามสกุล) |
| 124 | `par3_driver_no` | character varying(255) | YES |  | หมายเลขคนขับขับขี่ 3 |
| 125 | `par3_citizen_id` | character varying(20) | YES |  | รหัสประชาชนผู้ขับขี่ 3 |
| 126 | `par3_occupation` | character varying(255) | YES |  | อาชีพผู้ผู้ขับขี่ 3 |
| 127 | `par3_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้ผู้ขับขี่ 3 |
| 128 | `par3_driver_behavior` | integer | YES |  | ระดับ พฤติกรรมผู้ขับขี่ 3 |
| 129 | `driver_brithdate3` | date | YES |  | วันเกิดคนขับ 3 |
| 130 | `par4_prefix` | character varying(50) | YES |  | คำนำหน้าชื่อขับขี่ 4 |
| 131 | `par4_prefix_code` | character varying(50) | YES |  | รหัสคำนำหน้าชื่อขับขี่ 4 |
| 132 | `par4_firstname` | character varying(255) | YES |  | ชื่อขับขี่ 4 (ชื่อ) |
| 133 | `par4_lastname` | character varying(255) | YES |  | ชื่อขับขี่ 4 (นามสกุล) |
| 134 | `par4_driver_no` | character varying(255) | YES |  | หมายเลขคนขับขับขี่ 4 |
| 135 | `par4_citizen_id` | character varying(20) | YES |  | รหัสประชาชนผู้ขับขี่ 4 |
| 136 | `par4_occupation` | character varying(255) | YES |  | อาชีพผู้ผู้ขับขี่ 4 |
| 137 | `par4_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้ผู้ขับขี่ 4 |
| 138 | `par4_driver_behavior` | integer | YES |  | ระดับ พฤติกรรมผู้ขับขี่ 4 |
| 139 | `driver_brithdate4` | date | YES |  | วันเกิดคนขับ 4 |
| 140 | `par5_prefix` | character varying(50) | YES |  | คำนำหน้าชื่อขับขี่ 5 |
| 141 | `par5_prefix_code` | character varying(50) | YES |  | รหัสคำนำหน้าชื่อขับขี่ 5 |
| 142 | `par5_firstname` | character varying(255) | YES |  | ชื่อขับขี่ 5 (ชื่อ) |
| 143 | `par5_lastname` | character varying(255) | YES |  | ชื่อขับขี่ 5 (นามสกุล) |
| 144 | `par5_driver_no` | character varying(255) | YES |  | หมายเลขคนขับขับขี่ 5 |
| 145 | `par5_citizen_id` | character varying(20) | YES |  | รหัสประชาชนผู้ขับขี่ 5 |
| 146 | `par5_occupation` | character varying(255) | YES |  | อาชีพผู้ผู้ขับขี่ 5 |
| 147 | `par5_occupation_code` | character varying(50) | YES |  | รหัส อาชีพผู้ผู้ขับขี่ 5 |
| 148 | `par5_driver_behavior` | integer | YES |  | ระดับ พฤติกรรมผู้ขับขี่ 5 |
| 149 | `driver_brithdate5` | date | YES |  | วันเกิดคนขับ 5 |
| 150 | `sc_premium_amt` | real | YES |  | เบี้ยประกันซ่อมศูนย์ |
| 151 | `prem_version_` | integer | YES |  | version ของ import price premium |
| 152 | `driver_behavior_consent1` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 1 |
| 153 | `driver_behavior_consent2` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 2 |
| 154 | `driver_behavior_consent3` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 3 |
| 155 | `driver_behavior_consent4` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 4 |
| 156 | `driver_behavior_consent5` | boolean | YES |  | ยินยอมตรวจสอบพฤติกรรมผู้ขับขี่ 5 |
| 157 | `driver_behavior_summary` | integer | YES |  | ระดับพฤติกรรมผู้ขับขี่ ที่นำมาใช้ |
| 158 | `driver_behavior_tariff` | real | YES |  | ระดับพฤติกรรมผู้ขับขี่ tariff |
| 159 | `driver_behavior_disc` | real | YES |  | ส่วนลดระดับพฤติกรรมผู้ขับขี่ |

**Primary key:** `id` (log_sf_policy_trans_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `car_act_no` → Policy_Car_Act_Discount_Premium, `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `owner_district_id` → district, `owner_province_id` → province, `owner_subdistrict_id` → subdistrict, `policy_no` → Policy_Header

**Indexes:**

- `log_sf_policy_trans_copy1_pkey`: `CREATE UNIQUE INDEX log_sf_policy_trans_copy1_pkey ON insurverse.log_sf_policy_trans_request USING btree (id)`

---

## log_tariff_renewal

`insurverse.log_tariff_renewal` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `policy_no` | character varying(50) | YES |  |  |
| 4 | `message` | text | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

---

## log_thaibulk_send

`insurverse.log_thaibulk_send` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `message_id` | character varying(255) | YES |  |  |
| 3 | `template_code` | character varying(100) | YES |  |  |
| 4 | `email_to` | character varying(255) | YES |  |  |
| 5 | `subject` | text | YES |  |  |
| 6 | `content` | text | YES |  |  |
| 7 | `send_status` | character varying(50) | YES |  |  |
| 8 | `error_msg` | text | YES |  |  |
| 9 | `sent_at` | timestamp without time zone | YES |  |  |
| 10 | `ref1` | character varying(255) | YES |  |  |
| 11 | `ref2` | character varying(255) | YES |  |  |
| 12 | `template_name` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## log_workflow_process

`insurverse.log_workflow_process` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `flow_process_id` | bigint | YES |  | รหัส workflow |
| 3 | `request_id` | character varying(255) | YES |  | เลขที่กรมธรรม์ หรือรหัสอ้างอิงอื่นๆ |
| 4 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 5 | `api_name` | character varying(500) | YES |  |  |
| 6 | `api_url` | character varying(2000) | YES |  |  |
| 7 | `api_method` | character varying(255) | YES |  |  |
| 8 | `request_header` | character varying(5000) | YES |  |  |
| 9 | `request_body` | text | YES |  |  |
| 10 | `response_status` | smallint | YES |  |  |
| 11 | `response_body` | text | YES |  |  |
| 12 | `remark` | text | YES |  |  |

**Primary key:** `id` (log_workflow_process_pkey)

**Inferred references (naming convention, NOT enforced FK):** `flow_process_id` → policy_workflow_process

**Indexes:**

- `log_workflow_process_pkey`: `CREATE UNIQUE INDEX log_workflow_process_pkey ON insurverse.log_workflow_process USING btree (id)`

---

## log_yipinsoi

`insurverse.log_yipinsoi` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `api_name` | character varying(500) | YES |  |  |
| 4 | `api_url` | character varying(2000) | YES |  |  |
| 5 | `api_method` | character varying(255) | YES |  |  |
| 6 | `request_header` | character varying(5000) | YES |  |  |
| 7 | `request_body` | text | YES |  |  |
| 8 | `response_status` | smallint | YES |  |  |
| 9 | `response_body` | text | YES |  |  |
| 10 | `remark` | text | YES |  |  |

**Primary key:** `id` (log_yipinsoi_pkey)

**Indexes:**

- `log_yipinsoi_pkey`: `CREATE UNIQUE INDEX log_yipinsoi_pkey ON insurverse.log_yipinsoi USING btree (id)`

---

## loyalty_condition

`insurverse.loyalty_condition` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `loyalty_con_id` | integer | NO |  |  |
| 2 | `loyalty_con_name` | character varying(255) | YES |  | ชื่อเงื่อนไข loyalty |
| 3 | `group_type` | character varying(50) | YES |  | กลุ่มประเภทสินค้า เช่น motor, ta, pa หรือ อื่นๆ |
| 4 | `sub_group_type` | character varying(50) | YES |  | สินค้าที่เข้าเงื่อนไข เช่น 0, 1, 2+, 3+, 3 หรือ s, m, l |
| 5 | `amt_min` | numeric(16,2) | YES |  | จำนวนต่ำสุดที่เข้าเงื่อนไข |
| 6 | `amt_max` | numeric(16,2) | YES |  | จำนวนมากสุดที่เข้าเงื่อนไข |
| 7 | `amt_per_point` | numeric(16,2) | YES |  | จำนวนเงินเงื่อนไขได้รับ point เช่น ซื้อ 100 บาท จะได้ point_earn |
| 8 | `point_earn` | smallint | YES |  | point ที่ได้รับเมื่อครบเงื่อนไข |
| 9 | `effective_startdate` | timestamp without time zone | YES |  | วันที่เริ่มมีผลบังคับ |
| 10 | `effective_enddate` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลบังคับ |
| 11 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 12 | `create_by` | character varying(50) | YES |  |  |
| 13 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 14 | `update_by` | character varying(50) | YES |  |  |
| 15 | `loyalty_con_desc` | character varying(500) | YES |  | คำอธิบาย loyalty |
| 16 | `loyalty_point_type` | character varying(255) | YES |  | ประเภทการได้รับ point เช่น referal, purchase |
| 17 | `point_earn_min` | smallint | YES |  | point น้อยสุดที่ได้รับเมื่อครบเงื่อนไขแบบสะสม |
| 18 | `point_earn_max` | smallint | YES |  | point มากสุดที่ได้รับเมื่อครบเงื่อนไขแบบสะสม |
| 19 | `loyalty_con_status` | character varying(3) | YES | `'ACT'::character varying` | ACT = สถานะใช้งาน หรือ INC = ปิดการใช้งาน  |

**Primary key:** `loyalty_con_id` (loyalty_condition_pkey)

**Indexes:**

- `loyalty_condition_pkey`: `CREATE UNIQUE INDEX loyalty_condition_pkey ON insurverse.loyalty_condition USING btree (loyalty_con_id)`

---

## loyalty_point_trans

`insurverse.loyalty_point_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `point_trans_id` | bigint | NO |  |  |
| 2 | `user_id` | character varying(36) | YES |  | id ใน sec_user |
| 3 | `point` | integer | YES |  | คะแนนที่ได้รับหรือหักออก |
| 4 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `expire_date` | timestamp without time zone | YES |  |  |
| 6 | `remark` | character varying(500) | YES |  | รายละเอียด |
| 7 | `loyalty_con_id` | integer | YES |  | เงื่อนไขได้รับ point |
| 8 | `point_status` | character varying(3) | YES |  | สถานะ point ACT=มีผลใช้งาน, INC=ยกเลิกหรือหมดอายุ |
| 9 | `promo_trans_id` | bigint | YES |  | รหัสธุรกรรมโปรโมชั่น สำหรับการใช้ point |
| 10 | `policy_no` | character varying(255) | YES |  | เลขกรมธรรม์ |
| 11 | `lead_no` | integer | YES |  | Lead No |
| 12 | `referral_code` | character varying(255) | YES |  | อ้างอิง Code |
| 13 | `policy_type` | character varying(50) | YES |  | ประเภทกรมธรรม์ 0,1,2+,3+,3,ta,ph,home |
| 14 | `policy_group` | character varying(50) | YES |  | กลุ่มกรมธรรม์ motor,ta,pa,home |
| 15 | `lead_type` | character varying(50) | YES |  | ประเภท lead mv+mc,mv,mc |

**Primary key:** `point_trans_id` (loyalty_point_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium, `loyalty_con_id` → loyalty_condition, `policy_no` → Policy_Header, `promo_trans_id` → promo_code_trans

**Indexes:**

- `loyalty_point_trans_pkey`: `CREATE UNIQUE INDEX loyalty_point_trans_pkey ON insurverse.loyalty_point_trans USING btree (point_trans_id)`

---

## mas_car_prices

`insurverse.mas_car_prices` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `make` | character varying(50) | YES |  |  |
| 2 | `model` | character varying(50) | YES |  |  |
| 3 | `model_year` | character varying(4) | YES |  |  |
| 4 | `cc` | character varying(20) | YES |  |  |
| 5 | `price` | real | YES |  |  |
| 6 | `create_date` | timestamp without time zone | YES |  |  |
| 7 | `create_by` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## mas_cmi_brand_model

`insurverse.mas_cmi_brand_model` · kind: table · est. rows: **4,493**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `brand_id` | character varying(50) | NO |  |  |
| 2 | `brand_name` | character varying(255) | YES |  |  |
| 3 | `model_id` | character varying(50) | NO |  |  |
| 4 | `model_name` | character varying(255) | YES |  |  |

**Primary key:** `brand_id,model_id` (mas_cmi_brand_model_copy1_pkey)

**Indexes:**

- `mas_cmi_brand_model_copy1_pkey`: `CREATE UNIQUE INDEX mas_cmi_brand_model_copy1_pkey ON insurverse.mas_cmi_brand_model USING btree (brand_id, model_id)`

---

## mas_cmi_color

`insurverse.mas_cmi_color` · kind: table · est. rows: **107**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `color_id` | character varying(50) | NO |  |  |
| 2 | `color_name_th` | character varying(255) | YES |  |  |
| 3 | `color_name_en` | character varying(255) | YES |  |  |

**Primary key:** `color_id` (mas_cmi_color_pkey)

**Indexes:**

- `mas_cmi_color_pkey`: `CREATE UNIQUE INDEX mas_cmi_color_pkey ON insurverse.mas_cmi_color USING btree (color_id)`

---

## mas_cmi_color_7_5_24

`insurverse.mas_cmi_color_7_5_24` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `color_id` | character varying(50) | YES |  |  |
| 2 | `color_name_th` | character varying(255) | YES |  |  |
| 3 | `color_name_en` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## mas_cmi_province

`insurverse.mas_cmi_province` · kind: table · est. rows: **81**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `cmi_prov_id` | character varying(255) | NO |  |  |
| 2 | `name_th` | character varying(255) | YES |  |  |
| 3 | `name_en` | character varying(255) | YES |  |  |
| 4 | `provinceid` | integer | YES |  |  |

**Primary key:** `cmi_prov_id` (mas_cmi_province_pkey)

**Inferred references (naming convention, NOT enforced FK):** `provinceid` → province

**Indexes:**

- `mas_cmi_province_pkey`: `CREATE UNIQUE INDEX mas_cmi_province_pkey ON insurverse.mas_cmi_province USING btree (cmi_prov_id)`

---

## mas_cmi_province_tqm

`insurverse.mas_cmi_province_tqm` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `cmi_prov_id` | character varying(255) | YES |  |  |
| 2 | `name_th` | character varying(255) | YES |  |  |
| 3 | `name_en` | character varying(255) | YES |  |  |
| 4 | `provinceid` | integer | YES |  |  |
| 5 | `tqm_name` | character varying(10) | YES |  |  |

**Primary key:** _none_

---

## mas_country

`insurverse.mas_country` · kind: table · est. rows: **189**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `country_id` | smallint | NO |  |  |
| 2 | `country_code` | smallint | YES |  |  |
| 3 | `country_name_th` | character varying(255) | YES |  |  |
| 4 | `country_name_en` | character varying(255) | YES |  |  |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `update_by` | character varying(50) | YES |  |  |
| 10 | `country_alpha2` | character varying(2) | YES |  |  |

**Primary key:** `country_id` (mas_country_pkey)

**Indexes:**

- `mas_country_pkey`: `CREATE UNIQUE INDEX mas_country_pkey ON insurverse.mas_country USING btree (country_id)`

---

## mas_country_21jan

`insurverse.mas_country_21jan` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `country_id` | smallint | YES |  |  |
| 2 | `country_code` | smallint | YES |  |  |
| 3 | `country_name_th` | character varying(255) | YES |  |  |
| 4 | `country_name_en` | character varying(255) | YES |  |  |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `create_date` | timestamp(6) without time zone | YES |  |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp(6) without time zone | YES |  |  |
| 9 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## mas_country_30032567

`insurverse.mas_country_30032567` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `country_id` | smallint | YES |  |  |
| 2 | `country_code` | smallint | YES |  |  |
| 3 | `country_name_th` | character varying(255) | YES |  |  |
| 4 | `country_name_en` | character varying(255) | YES |  |  |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `create_date` | timestamp without time zone | YES |  |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp without time zone | YES |  |  |
| 9 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## mas_home_building_type

`insurverse.mas_home_building_type` · kind: table · est. rows: **2**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_building_type_id` | smallint | NO |  | รหัสประเภทอาคาร |
| 2 | `building_name_th` | character varying(255) | YES |  | ชื่อประเภทอาคารภาษาไทย |
| 3 | `building_name_en` | character varying(255) | YES |  | ชื่อประเภทอาคารภาษาอังกฤษ |
| 4 | `building_desc_th` | character varying(500) | YES |  | รายละเอียดประเภทอาคารภาษาไทย |
| 5 | `building_desc_en` | character varying(500) | YES |  | รายละเอียดประเภทอาคารภาษาอังกฤษ |
| 6 | `flag_other` | boolean | YES | `false` | เป็นอื่นๆ หรือไม่ |
| 7 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(255) | YES |  |  |
| 9 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 10 | `update_by` | character varying(255) | YES |  |  |
| 11 | `home_building_type_code` | character varying(50) | YES |  | รหัสประเภทอาคาร IIA |
| 12 | `is_active` | boolean | YES | `true` |  |

**Primary key:** `home_building_type_id` (mas_home_building_type_pkey)

**Indexes:**

- `mas_home_building_type_pkey`: `CREATE UNIQUE INDEX mas_home_building_type_pkey ON insurverse.mas_home_building_type USING btree (home_building_type_id)`

---

## mas_home_coverage

`insurverse.mas_home_coverage` · kind: table · est. rows: **11**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_coverage_id` | smallint | NO |  | รหัสความคุ้มครองบ้าน |
| 2 | `coverage_code` | character varying(50) | YES |  | รหัสความคุ้มครอง IIA |
| 3 | `coverage_name_th` | character varying(500) | YES |  | ชื่อกลุ่มความคุ้มครองภาษาไทย |
| 4 | `coverage_name_en` | character varying(500) | YES |  | ชื่อกลุ่มความคุ้มครองภาษาอังกฤษ |
| 5 | `coverage_desc1_th` | text | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาไทย |
| 6 | `coverage_desc1_en` | text | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาอังกฤษ |
| 7 | `flag_cover_main` | boolean | YES | `false` | เป็นความคุ้มครองทุนประกันหลักหรือไม่ |
| 8 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `create_by` | character varying(255) | YES |  |  |
| 10 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 11 | `update_by` | character varying(255) | YES |  |  |
| 12 | `home_coverage_group_id` | smallint | YES |  | รหัสกลุ่มความคุ้มครองบ้าน |
| 13 | `si_merge_group` | smallint | YES |  | เป็นความคุ้มครองที่ต้องรวมกันหรือไม่ |
| 14 | `coverage_desc2_th` | text | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาไทย |
| 15 | `coverage_desc2_en` | text | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาอังกฤษ |
| 16 | `coverage_desc3_th` | text | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาไทย |
| 17 | `coverage_desc3_en` | text | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาอังกฤษ |

**Primary key:** `home_coverage_id` (mas_home_coverage_pkey)

**Inferred references (naming convention, NOT enforced FK):** `home_coverage_group_id` → mas_home_coverage_group

**Indexes:**

- `mas_home_coverage_pkey`: `CREATE UNIQUE INDEX mas_home_coverage_pkey ON insurverse.mas_home_coverage USING btree (home_coverage_id)`

---

## mas_home_coverage_group

`insurverse.mas_home_coverage_group` · kind: table · est. rows: **4**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_coverage_group_id` | smallint | NO |  | รหัสกลุ่มความคุ้มครองบ้าน |
| 2 | `coverage_group_code` | character varying(50) | YES |  | รหัสกลุ่มความคุ้มครอง IIA |
| 3 | `coverage_group_name_th` | character varying(255) | YES |  | ชื่อกลุ่มความคุ้มครองภาษาไทย |
| 4 | `coverage_group_name_en` | character varying(255) | YES |  | ชื่อกลุ่มความคุ้มครองภาษาอังกฤษ |
| 5 | `coverage_group_desc_th` | character varying(500) | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาไทย |
| 6 | `coverage_group_desc_en` | character varying(500) | YES |  | รายละเอียดกลุ่มความคุ้มครองภาษาอังกฤษ |
| 7 | `flag_addon` | boolean | YES |  | เป็นความคุ้มครองเสริมหรือไม่ |
| 8 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `create_by` | character varying(255) | YES |  |  |
| 10 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 11 | `update_by` | character varying(255) | YES |  |  |

**Primary key:** `home_coverage_group_id` (mas_home_coverage_group_pkey)

**Indexes:**

- `mas_home_coverage_group_pkey`: `CREATE UNIQUE INDEX mas_home_coverage_group_pkey ON insurverse.mas_home_coverage_group USING btree (home_coverage_group_id)`

---

## mas_home_material_type

`insurverse.mas_home_material_type` · kind: table · est. rows: **3**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_material_type_id` | smallint | NO |  | รหัสประเภทวัสดุอาคาร |
| 2 | `material_name_th` | character varying(255) | YES |  | ชื่อประเภทวัสดุอาคารภาษาไทย |
| 3 | `material_name_en` | character varying(255) | YES |  | ชื่อประเภทวัสดุอาคารภาษาอังกฤษ |
| 4 | `material_desc_th` | character varying(500) | YES |  | รายละเอียดประเภทวัสดุอาคารภาษาไทย |
| 5 | `material_desc_en` | character varying(500) | YES |  | รายละเอียดประเภทวัสดุอาคารภาษาอังกฤษ |
| 6 | `flag_other` | boolean | YES | `false` | เป็นอื่นๆ หรือไม่ |
| 7 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(255) | YES |  |  |
| 9 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 10 | `update_by` | character varying(255) | YES |  |  |
| 11 | `flag_default` | boolean | YES | `false` | เป็นค่าพื้นฐานหรือไม่ |
| 12 | `home_material_type_code` | character varying(50) | YES |  | รหัสประเภทวัสดุ IIA |
| 13 | `is_active` | boolean | YES | `true` |  |

**Primary key:** `home_material_type_id` (mas_home_material_type_pkey)

**Indexes:**

- `mas_home_material_type_pkey`: `CREATE UNIQUE INDEX mas_home_material_type_pkey ON insurverse.mas_home_material_type USING btree (home_material_type_id)`

---

## mas_home_premium_tariff

`insurverse.mas_home_premium_tariff` · kind: table · est. rows: **18**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_premium_tariff_id` | smallint | NO |  | รหัส tariff เบี้ยประกัน Home |
| 2 | `home_building_type_id` | smallint | NO |  | รหัสประเภทอาคาร |
| 3 | `home_coverage_id` | smallint | NO |  | รหัสความคุ้มครองบ้าน |
| 4 | `cover_limit_min` | numeric(16,4) | YES |  | ทุนประกันขั้นต่ำ |
| 5 | `cover_limit_max` | numeric(16,4) | YES |  | ทุนประกันสูงสุด |
| 6 | `cover_limit_split` | numeric(16,4) | YES |  | ช่วงการเลือกทุนประกัน |
| 7 | `flag_cover_si_factor` | boolean | YES |  | เป็นทุนประกันที่ต้องการทุนจากความคุ้มครองอื่น |
| 8 | `cover_si_factor` | numeric(16,4) | YES |  | จำนวนทุนประกันที่ต้องอ้างอิงเพิ่มนำมาคำนวณเบี้ย |
| 9 | `cover_si_limit_min` | numeric(16,4) | YES |  | จำนวนจำกัดทุนประกันขั้นต่ำสุด |
| 10 | `cover_si_limit_max` | numeric(16,4) | YES |  | จำนวนจำกัดทุนประกันขั้นสูงสุด |
| 11 | `si_second_flag` | boolean | YES | `false` | มีคำนวณเบี้ย 2 ขั้นหรือไม่ |
| 12 | `si_first_limit` | numeric(16,4) | YES |  | ความคุ้มครองจำกัดส่วนแรก |
| 13 | `si_first_factor` | numeric(16,4) | YES |  | tariff คำนวณความคุ้มครองส่วนแรก |
| 14 | `si_second_limit` | numeric(16,4) | YES |  | ความคุ้มครองจำกัดส่วนนอกเหนือส่วนแรก |
| 15 | `si_second_factor` | numeric(16,4) | YES |  | tariff คำนวณความคุ้มครองส่วนนอกเหนือส่วนแรก |
| 16 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 17 | `create_by` | character varying(255) | YES |  |  |
| 18 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 19 | `update_by` | character varying(255) | YES |  |  |

**Primary key:** `home_premium_tariff_id` (mas_home_premium_tariff_pkey)

**Inferred references (naming convention, NOT enforced FK):** `home_building_type_id` → mas_home_building_type, `home_coverage_id` → mas_home_coverage

**Indexes:**

- `mas_home_premium_tariff_pkey`: `CREATE UNIQUE INDEX mas_home_premium_tariff_pkey ON insurverse.mas_home_premium_tariff USING btree (home_premium_tariff_id)`

---

## mas_home_premium_tariff_2

`insurverse.mas_home_premium_tariff_2` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_premium_tariff_id` | smallint | YES |  |  |
| 2 | `home_building_type_id` | smallint | YES |  |  |
| 3 | `home_coverage_id` | smallint | YES |  |  |
| 4 | `cover_limit_min` | numeric | YES |  |  |
| 5 | `cover_limit_max` | numeric | YES |  |  |
| 6 | `cover_limit_split` | numeric | YES |  |  |
| 7 | `flag_cover_si_factor` | boolean | YES |  |  |
| 8 | `cover_si_factor` | numeric | YES |  |  |
| 9 | `cover_si_limit_min` | numeric | YES |  |  |
| 10 | `cover_si_limit_max` | numeric | YES |  |  |
| 11 | `si_second_flag` | boolean | YES |  |  |
| 12 | `si_first_limit` | numeric | YES |  |  |
| 13 | `si_first_factor` | numeric | YES |  |  |
| 14 | `si_second_limit` | numeric | YES |  |  |
| 15 | `si_second_factor` | numeric | YES |  |  |
| 16 | `create_date` | timestamp without time zone | YES |  |  |
| 17 | `create_by` | character varying(255) | YES |  |  |
| 18 | `update_date` | timestamp without time zone | YES |  |  |
| 19 | `update_by` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## mas_home_province

`insurverse.mas_home_province` · kind: table · est. rows: **77**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_province_id` | integer | NO |  |  |
| 2 | `provinceid` | integer | NO |  |  |
| 3 | `flag_cover_flood` | boolean | YES | `true` |  |
| 4 | `is_active` | boolean | YES | `true` |  |

**Primary key:** `home_province_id` (mas_home_province_pkey)

**Inferred references (naming convention, NOT enforced FK):** `provinceid` → province

**Indexes:**

- `mas_home_province_pkey`: `CREATE UNIQUE INDEX mas_home_province_pkey ON insurverse.mas_home_province USING btree (home_province_id)`

---

## mas_home_resident_type

`insurverse.mas_home_resident_type` · kind: table · est. rows: **2**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `home_resident_type_id` | smallint | NO |  | รหัสประเภทผู้อยู่อาศัย |
| 2 | `resident_name_th` | character varying(255) | YES |  | ชื่อประเภทผู้อยู่อาศัยภาษาไทย |
| 3 | `resident_name_en` | character varying(255) | YES |  | ชื่อประเภทผู้อยู่อาศัยภาษาอังกฤษ |
| 4 | `resident_desc_th` | character varying(500) | YES |  | รายละเอียดประเภทผู้อยู่อาศัยภาษาไทย |
| 5 | `resident_desc_en` | character varying(500) | YES |  | รายละเอียดประเภทผู้อยู่อาศัยภาษาอังกฤษ |
| 6 | `flag_other` | boolean | YES | `false` | เป็นอื่นๆ หรือไม่ |
| 7 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(255) | YES |  |  |
| 9 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 10 | `update_by` | character varying(255) | YES |  |  |
| 11 | `flag_default` | boolean | YES | `false` | เป็นค่าพื้นฐานหรือไม่ |
| 12 | `home_resident_type_code` | character varying(50) | YES |  | รหัสประเภทผู้อยู่อาศัย IIA |
| 13 | `is_active` | boolean | YES | `true` |  |

**Primary key:** `home_resident_type_id` (mas_home_resident_type_pkey)

**Indexes:**

- `mas_home_resident_type_pkey`: `CREATE UNIQUE INDEX mas_home_resident_type_pkey ON insurverse.mas_home_resident_type USING btree (home_resident_type_id)`

---

## mas_limite_purchase

`insurverse.mas_limite_purchase` · kind: table · est. rows: **2**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.mas_limite_purchase_id_seq'::regclass)` |  |
| 2 | `period_name` | character varying(100) | NO |  |  |
| 3 | `limite_date` | date | NO |  |  |
| 4 | `active` | boolean | YES | `true` |  |
| 5 | `updated_at` | timestamp with time zone | YES | `CURRENT_TIMESTAMP` |  |

**Primary key:** `id` (mas_limite_purchase_pkey)

**Indexes:**

- `idx_mas_limite_purchase_date`: `CREATE INDEX idx_mas_limite_purchase_date ON insurverse.mas_limite_purchase USING btree (limite_date)`
- `mas_limite_purchase_pkey`: `CREATE UNIQUE INDEX mas_limite_purchase_pkey ON insurverse.mas_limite_purchase USING btree (id)`

**Triggers:** `deactivate_old_limite_purchase` → `public.deactivate_old_entries()`, `update_mas_limite_purchase_updated_at` → `public.update_updated_at_column()`

---

## mas_mv_config

`insurverse.mas_mv_config` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `garage_type` | character varying(2) | YES |  |  |
| 2 | `car_group` | character varying(255) | YES |  |  |
| 3 | `usage` | smallint | YES |  |  |
| 4 | `mv` | character varying(5) | YES |  |  |
| 5 | `target` | character varying(50) | YES |  |  |
| 6 | `cover_prem` | real | YES |  |  |

**Primary key:** _none_

---

## mas_other_description

`insurverse.mas_other_description` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `mas_other_type` | character varying(50) | NO |  |  |
| 2 | `mas_other_code` | character varying(50) | NO |  |  |
| 3 | `mas_product_type` | character varying(50) | YES |  |  |
| 4 | `mas_name_th` | character varying(255) | YES |  |  |
| 5 | `mas_name_en` | character varying(255) | YES |  |  |
| 6 | `mas_desc_th` | character varying(2000) | YES |  |  |
| 7 | `mas_desc_en` | character varying(2000) | YES |  |  |
| 8 | `is_other` | boolean | YES |  |  |
| 9 | `mas_str` | text | YES |  |  |
| 10 | `mas_num` | numeric | YES |  |  |
| 11 | `is_active` | boolean | YES |  |  |

**Primary key:** `mas_other_type,mas_other_code` (mas_other_description_pkey)

**Indexes:**

- `mas_other_description_pkey`: `CREATE UNIQUE INDEX mas_other_description_pkey ON insurverse.mas_other_description USING btree (mas_other_type, mas_other_code)`

---

## mas_pa_age_range

`insurverse.mas_pa_age_range` · kind: table · est. rows: **3**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pa_age_range_id` | smallint | NO |  | รหัสช่วงอายุ PA |
| 2 | `age_range_code` | character varying(50) | YES |  | โค็ด IIA สำหรับช่วงอายุ |
| 3 | `age_range_name_th` | character varying(255) | YES |  | ชื่อช่วงอายุภาษาไทย |
| 4 | `age_range_name_en` | character varying(255) | YES |  | ชื่อช่วงอายุภาษาอังกฤษ |
| 5 | `age_min` | smallint | YES |  | ช่วงอายุต่ำสุด |
| 6 | `age_max` | smallint | YES |  | ช่วงอายุสูงสุด |
| 7 | `is_active` | boolean | YES |  |  |

**Primary key:** `pa_age_range_id` (mas_pa_age_range_pkey)

**Indexes:**

- `mas_pa_age_range_pkey`: `CREATE UNIQUE INDEX mas_pa_age_range_pkey ON insurverse.mas_pa_age_range USING btree (pa_age_range_id)`

---

## mas_pa_coverage

`insurverse.mas_pa_coverage` · kind: table · est. rows: **5**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pa_coverage_id` | smallint | NO |  | รหัสความคุ้มครอง PA |
| 2 | `pa_coverage_code` | character varying(50) | YES |  | รหัสความคุ้มครอง IIA |
| 3 | `coverage_name_th` | character varying(255) | YES |  | ชื่อความคุ้มครองภาษาไทย |
| 4 | `coverage_name_en` | character varying(255) | YES |  | ชื่อความคุ้มครองภาษาอังกฤษ |
| 5 | `coverage_desc1_th` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาไทย |
| 6 | `coverage_desc1_en` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาอังกฤษ |
| 7 | `coverage_doc_name` | character varying(50) | YES |  | ชื่อสำหรับแสดงบนเอกสารตาราง |
| 8 | `flag_cover_main` | boolean | YES |  | ความคุ้มครองหลักหรือไม่ |
| 9 | `cover_limit_min` | numeric(16,4) | YES |  | ทุนความคุ้มครองต่ำสุด |
| 10 | `cover_limit_max` | numeric(16,4) | YES |  | ทุนความคุ้มครองสูงสุด |
| 11 | `cover_limit_split` | numeric(16,4) | YES |  | ช่วงระหว่างความคุ้มครอง |
| 12 | `cover_dd_limit_min` | numeric(16,4) | YES |  | ทุนแรกเริ่มต่ำสุด |
| 13 | `cover_dd_limit_max` | numeric(16,4) | YES |  | ทุนแรกเริ่มสูงสุด |
| 14 | `is_active` | boolean | YES |  |  |
| 15 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 16 | `create_by` | character varying(255) | YES |  |  |
| 17 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 18 | `update_by` | character varying(255) | YES |  |  |
| 19 | `cover_si_main` | numeric(16,4) | YES |  | อ้างอิงทุนประกันรวม |
| 20 | `coverage_desc2_th` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาไทย |
| 21 | `coverage_desc2_en` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาอังกฤษ |
| 22 | `coverage_desc3_th` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาไทย |
| 23 | `coverage_desc3_en` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาอังกฤษ |

**Primary key:** `pa_coverage_id` (mas_pa_coverage_pkey)

**Indexes:**

- `mas_pa_coverage_pkey`: `CREATE UNIQUE INDEX mas_pa_coverage_pkey ON insurverse.mas_pa_coverage USING btree (pa_coverage_id)`

---

## mas_pa_heath_question

`insurverse.mas_pa_heath_question` · kind: table · est. rows: **2**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pa_question_id` | smallint | NO |  | รหัสคำถามสุขภาพ |
| 2 | `question_name_th` | text | YES |  | ชื่อคำถามสุขภาพภาษาไทย |
| 3 | `question_name_en` | text | YES |  | ชื่อคำถามสุขภาพภาษาอังกฤษ |
| 4 | `question_desc_th` | text | YES |  | รายละเอียดคำถามสุขภาพภาษาไทย |
| 5 | `question_desc_en` | text | YES |  | รายละเอียดคำถามสุขภาพภาษาอังกฤษ |
| 6 | `flag_active` | boolean | YES |  |  |
| 7 | `priority` | smallint | YES |  | ลำดับการแสดงผลข้อ 1,2 |

**Primary key:** `pa_question_id` (mas_pa_heath_question_pkey)

**Indexes:**

- `mas_pa_heath_question_pkey`: `CREATE UNIQUE INDEX mas_pa_heath_question_pkey ON insurverse.mas_pa_heath_question USING btree (pa_question_id)`

---

## mas_pa_occupation

`insurverse.mas_pa_occupation` · kind: table · est. rows: **27**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pa_occupation_id` | smallint | NO |  |  |
| 2 | `occupation_code` | character varying(50) | YES |  | รหัสอาชีพสำหรับ IIA |
| 3 | `occupation_name_th` | character varying(255) | YES |  | ชื่ออาชีพภาษาไทย |
| 4 | `occupation_name_en` | character varying(255) | YES |  | ชื่ออาชีพภาษาอังกฤษ |
| 5 | `occupation_desc_th` | character varying(500) | YES |  | รายละเอียดอาชีพภาษาไทย |
| 6 | `occupation_desc_en` | character varying(500) | YES |  | รายละเอียดอาชีพภาษาอังกฤษ |
| 7 | `occupation_doc_name` | character varying(50) | YES |  | ชื่ออาชีพสำหรับแสดงบนเอกสาร |
| 8 | `flag_active` | boolean | YES |  |  |
| 9 | `occupation_factor` | numeric(16,4) | YES |  | ค่าเบี้ยคำนวณ tariff |
| 10 | `flag_coverage` | boolean | YES | `false` | อาชีพคุ้มครอง |

**Primary key:** `pa_occupation_id` (mas_pa_occupation_pkey)

**Indexes:**

- `mas_pa_occupation_pkey`: `CREATE UNIQUE INDEX mas_pa_occupation_pkey ON insurverse.mas_pa_occupation USING btree (pa_occupation_id)`

---

## mas_pa_package

`insurverse.mas_pa_package` · kind: table · est. rows: **4**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pa_package_id` | smallint | NO |  | รหัสแพ็คเกจ PA |
| 2 | `package_code` | character varying(50) | YES |  | รายละเอียด IIA |
| 3 | `package_name_th` | character varying(255) | YES |  | ชื่อแพ็คเกจภาษาไทย |
| 4 | `package_desc_th` | character varying(2000) | YES |  | รายละเอียดแพ็คเกจภาษาไทย |
| 5 | `package_name_en` | character varying(255) | YES |  | ชื่อแพ็คเกจภาษาอังกฤษ |
| 6 | `package_desc_en` | character varying(2000) | YES |  | รายละเอียดแพ็คเกจภาษาอังกฤษ |
| 7 | `coverage_id_array` | character varying(255) | YES |  | รหัสความคุ้มครอง |
| 8 | `flag_debt` | boolean | YES |  | คุ้มครองชำระหนี้หรือไม่ |
| 9 | `url_policy` | text | YES |  | เอกสารกรมธรรม์หลักหน้าตาราง |
| 10 | `url_cover` | text | YES |  | เอกสารกรมธรรม์แนบความคุ้มครอง |
| 11 | `url_condition` | text | YES |  | เอกสารกรมธรรม์เงื่อนไข |
| 12 | `is_active` | boolean | YES |  |  |
| 13 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 14 | `create_by` | character varying(255) | YES |  |  |
| 15 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 16 | `update_by` | character varying(255) | YES |  |  |
| 17 | `url_policy_copy` | text | YES |  | เอกสารกรมธรรม์หลักหน้าตารางสำเนา |

**Primary key:** `pa_package_id` (mas_pa_package_pkey)

**Indexes:**

- `mas_pa_package_pkey`: `CREATE UNIQUE INDEX mas_pa_package_pkey ON insurverse.mas_pa_package USING btree (pa_package_id)`

---

## mas_pa_premium_tariff

`insurverse.mas_pa_premium_tariff` · kind: table · est. rows: **15**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pa_premium_tariff_id` | smallint | NO |  | รหัส tariff เบี้ยประกัน PA |
| 2 | `coverage_id` | smallint | YES |  | รหัสความคุ้มครอง |
| 3 | `age_range_id` | smallint | YES |  | รหัสช่วงอายุ |
| 4 | `occupation_id` | smallint | YES |  | รหัสอาชีพ |
| 5 | `si_first_limit` | numeric(16,4) | YES |  | ทุนคุ้มครองสูงสุดขั้นแรก |
| 6 | `si_first_factor` | numeric(16,4) | YES |  | ตัวแปรสำหรับคำนวณเบี้ยขั้นแรก |
| 7 | `si_second_flag` | boolean | YES |  | มีคำนวณเบี้ย 2 ขั้นหรือไม่ |
| 8 | `si_second_limit` | numeric(16,4) | YES |  | ทุนคุ้มครองสูงสุดขั้นที่สอง |
| 9 | `si_second_factor` | numeric(16,4) | YES |  | ตัวแปรสำหรับคำนวณเบี้ยขั้นสอง |
| 10 | `flag_active` | boolean | YES |  |  |

**Primary key:** `pa_premium_tariff_id` (mas_pa_premium_tariff_pkey)

**Indexes:**

- `mas_pa_premium_tariff_pkey`: `CREATE UNIQUE INDEX mas_pa_premium_tariff_pkey ON insurverse.mas_pa_premium_tariff USING btree (pa_premium_tariff_id)`

---

## mas_partner

`insurverse.mas_partner` · kind: table · est. rows: **2**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `partner_code` | character varying(10) | NO |  | โค้ดพาร์ทเนอร์ และเป็น client_id ให้ open api ด้วย |
| 2 | `partner_name_th` | character varying(50) | YES |  | ชื่อพาร์ทเนอร์ภาษาไทย |
| 3 | `partner_name_en` | character varying(50) | YES |  | ชื่อพาร์ทเนอร์ภาษาอังกฤษ |
| 4 | `is_active` | boolean | YES | `true` | true = active , false = inactive |
| 5 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 6 | `create_by` | character varying(50) | YES |  |  |
| 7 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 8 | `update_by` | character varying(50) | YES |  |  |
| 9 | `client_secret` | character varying(256) | YES |  | client secret สำหรับ open api |
| 10 | `access_token` | text | YES |  | access token ล่าสุด สำหรับ open api |
| 11 | `expires_in` | timestamp without time zone | YES |  | expires in สำหรับ open api |
| 12 | `scope` | character varying(255) | YES |  | scope สำหรับ open api |
| 13 | `access_token_last_at` | timestamp without time zone | YES |  | วันเวลาที่ขอ access token ล่าสุด |

**Primary key:** `partner_code` (mas_partner_pkey)

**Indexes:**

- `mas_partner_pkey`: `CREATE UNIQUE INDEX mas_partner_pkey ON insurverse.mas_partner USING btree (partner_code)`

---

## mas_policy_product

`insurverse.mas_policy_product` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `product_code` | character varying(50) | NO |  |  |
| 2 | `sub_product_code` | character varying(50) | NO |  |  |
| 3 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 4 | `is_active` | boolean | YES |  |  |
| 5 | `product_name_th` | character varying(255) | YES |  |  |
| 6 | `product_name_en` | character varying(255) | YES |  |  |
| 7 | `sub_product_name_th` | character varying(255) | YES |  |  |
| 8 | `sub_product_name_en` | character varying(255) | YES |  |  |
| 9 | `priority` | smallint | YES |  |  |

**Primary key:** `product_code,sub_product_code` (mas_policy_product_pkey)

**Indexes:**

- `mas_policy_product_pkey`: `CREATE UNIQUE INDEX mas_policy_product_pkey ON insurverse.mas_policy_product USING btree (product_code, sub_product_code)`

---

## mas_product_type

`insurverse.mas_product_type` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.mas_product_type_id_seq'::regclass)` |  |
| 2 | `product_type_name` | character varying(50) | NO |  |  |

**Primary key:** `id` (product_type_pkey)

**Indexes:**

- `product_type_pkey`: `CREATE UNIQUE INDEX product_type_pkey ON insurverse.mas_product_type USING btree (id)`

---

## mas_renewal_config

`insurverse.mas_renewal_config` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `trans_startdate` | timestamp without time zone | NO |  |  |
| 3 | `trans_enddate` | timestamp without time zone | NO |  |  |
| 4 | `renewal_type` | character varying(50) | NO |  |  |
| 5 | `renewal_code` | character varying(50) | NO |  |  |
| 6 | `renewal_name` | character varying(255) | YES |  |  |
| 7 | `renewal_desc` | text | YES |  |  |
| 8 | `renewal_mapping` | character varying(255) | YES |  |  |
| 9 | `renewal_num` | numeric | YES |  |  |
| 10 | `renewal_min` | numeric | YES |  |  |
| 11 | `renewal_max` | numeric | YES |  |  |
| 12 | `renewal_bool` | boolean | YES |  |  |
| 13 | `renewal_text` | text | YES |  |  |
| 14 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 15 | `create_by` | character varying(255) | YES |  |  |
| 16 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 17 | `update_by` | character varying(255) | YES |  |  |
| 18 | `is_active` | boolean | YES | `true` |  |
| 19 | `renewal_condition_1` | character varying(255) | YES |  |  |
| 20 | `renewal_condition_2` | character varying(255) | YES |  |  |
| 21 | `renewal_condition_3` | character varying(255) | YES |  |  |

**Primary key:** `id` (mas_config_renewal_pkey)

**Indexes:**

- `mas_config_renewal_pkey`: `CREATE UNIQUE INDEX mas_config_renewal_pkey ON insurverse.mas_renewal_config USING btree (id)`

---

## mas_renewal_ncb

`insurverse.mas_renewal_ncb` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `trans_startdate` | timestamp without time zone | NO |  |  |
| 3 | `trans_enddate` | timestamp without time zone | NO |  |  |
| 4 | `claim_no` | integer | YES |  | ลำดับเรียงลำดับ |
| 5 | `ncb_tier_con` | numeric | YES |  | จำนวนที่ ค่าบวกคือเพิ่มขึ้น 0 คือเท่าเดิม ติดลบคือลดลง |
| 6 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `create_by` | character varying(255) | YES |  |  |
| 8 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 9 | `update_by` | character varying(255) | YES |  |  |
| 10 | `is_active` | boolean | YES | `true` |  |
| 11 | `claim_group` | character varying(50) | YES |  | pure_loss หรือ cosmetic_other |
| 12 | `claim_time_min` | integer | YES |  | จำนวนเคลมขั้นต่ำสุด |
| 13 | `claim_time_max` | integer | YES |  | จำนวนเคลมขั้นสูงสุด |
| 14 | `compensation_rate_min` | numeric | YES |  | อัตราค่าสินไหมแทน (%) ของเบี้ยสุทธิขั้นต่ำสุด |
| 15 | `compensation_rate_max` | numeric | YES |  | อัตราค่าสินไหมแทน (%) ของเบี้ยสุทธิขั้นสูงสุด |

**Primary key:** `id` (mas_renewal_ncb_pkey)

**Indexes:**

- `mas_renewal_ncb_pkey`: `CREATE UNIQUE INDEX mas_renewal_ncb_pkey ON insurverse.mas_renewal_ncb USING btree (id)`

---

## mas_renewal_premium

`insurverse.mas_renewal_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `trans_startdate` | timestamp without time zone | NO |  |  |
| 3 | `trans_enddate` | timestamp without time zone | NO |  |  |
| 4 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `create_by` | character varying(255) | YES |  |  |
| 6 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `update_by` | character varying(255) | YES |  |  |
| 8 | `is_active` | boolean | YES | `true` |  |
| 9 | `car_group` | character varying(255) | YES |  | กลุ่มรถ |
| 10 | `garage_type` | character varying(50) | YES |  | ประเภทการซ่อม |
| 11 | `car_year` | character varying(10) | YES |  | ปีจดทะเบียน |
| 12 | `premium_amt_min` | numeric | YES |  |  |
| 13 | `premium_amt_max` | numeric | YES |  |  |

**Primary key:** `id` (mas_renewal_premium_pkey)

**Indexes:**

- `mas_renewal_premium_pkey`: `CREATE UNIQUE INDEX mas_renewal_premium_pkey ON insurverse.mas_renewal_premium USING btree (id)`

---

## mas_state

`insurverse.mas_state` · kind: table · est. rows: **3,695**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `state_id` | integer | NO |  |  |
| 2 | `country_id` | integer | NO |  |  |
| 3 | `state_code` | character varying(50) | YES |  |  |
| 4 | `state_name_en` | character varying(255) | NO |  |  |
| 5 | `state_name_th` | character varying(255) | YES |  |  |
| 6 | `is_active` | boolean | YES |  |  |
| 7 | `create_date` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 8 | `create_by` | character varying(100) | YES | `'SYSTEM'::character varying` |  |
| 9 | `update_date` | timestamp without time zone | YES |  |  |
| 10 | `update_by` | character varying(100) | YES |  |  |

**Primary key:** `state_id` (mas_state_pkey)

**Inferred references (naming convention, NOT enforced FK):** `country_id` → mas_country

**Indexes:**

- `idx_mas_state_country_id`: `CREATE INDEX idx_mas_state_country_id ON insurverse.mas_state USING btree (country_id)`
- `mas_state_pkey`: `CREATE UNIQUE INDEX mas_state_pkey ON insurverse.mas_state USING btree (state_id)`

---

## mas_ta_coverage

`insurverse.mas_ta_coverage` · kind: table · est. rows: **27**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ta_coverage_id` | smallint | NO |  |  |
| 2 | `coverage_name_th` | character varying(255) | YES |  | ชื่อความคุ้มครองภาษาไทย |
| 3 | `coverage_name_en` | character varying(255) | YES |  | ชื่อความคุ้มครองภาษาอังกฤษ |
| 4 | `coverage_desc_th` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาไทย |
| 5 | `coverage_desc_en` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองภาษาอังกฤษ |
| 6 | `is_active` | boolean | YES |  |  |
| 7 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(50) | YES |  |  |
| 9 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 10 | `update_by` | character varying(50) | YES |  |  |
| 11 | `ta_coverage_code` | character varying(50) | YES |  | รหัสความคุ้มครองจาก IIA |
| 12 | `coverage_desc_th_1` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองที่ 1 ภาษาไทย |
| 13 | `coverage_desc_en_1` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองที่ 1 ภาษาอังกฤษ |
| 14 | `coverage_desc_th_2` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองที่ 2 ภาษาไทย |
| 15 | `coverage_desc_en_2` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองที่ 2 ภาษาอังกฤษ |
| 16 | `coverage_desc_th_3` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองที่ 3 ภาษาไทย |
| 17 | `coverage_desc_en_3` | character varying(2000) | YES |  | รายละเอียดความคุ้มครองที่ 3 ภาษาอังกฤษ |
| 18 | `coverage_condition_url` | text | YES |  |  |
| 19 | `coverage_type_icon` | character varying(255) | YES |  | md = รักษา, si = ทุนประกันทั่วไป |
| 20 | `is_other_coverage_amt` | boolean | YES | `false` | true = เรียกหน่วย min max , false = เรียก coverage si amt ปกติ |

**Primary key:** `ta_coverage_id` (mas_ta_coverage_pkey)

**Indexes:**

- `mas_ta_coverage_pkey`: `CREATE UNIQUE INDEX mas_ta_coverage_pkey ON insurverse.mas_ta_coverage USING btree (ta_coverage_id)`

---

## mas_ta_description

`insurverse.mas_ta_description` · kind: table · est. rows: **22**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `mas_ta_type` | character varying(50) | NO |  |  |
| 2 | `mas_ta_code` | character varying(50) | NO |  |  |
| 3 | `mas_name_th` | character varying(255) | YES |  |  |
| 4 | `mas_name_en` | character varying(255) | YES |  |  |
| 5 | `mas_desc_th` | character varying(2000) | YES |  |  |
| 6 | `mas_desc_en` | character varying(2000) | YES |  |  |
| 7 | `is_other` | boolean | YES |  | กรณีเป็นอื่นๆ เพื่อรับค่าเพิ่ม |

**Primary key:** `mas_ta_type,mas_ta_code` (mas_ta_description_pkey)

**Indexes:**

- `mas_ta_description_pkey`: `CREATE UNIQUE INDEX mas_ta_description_pkey ON insurverse.mas_ta_description USING btree (mas_ta_type, mas_ta_code)`

---

## mas_ta_package

`insurverse.mas_ta_package` · kind: table · est. rows: **16**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ta_package_id` | integer | NO |  |  |
| 2 | `package_name_th` | character varying(255) | YES |  |  |
| 3 | `package_desc_th` | character varying(2000) | YES |  |  |
| 4 | `package_name_en` | character varying(255) | YES |  |  |
| 5 | `package_desc_en` | character varying(2000) | YES |  |  |
| 6 | `plancode` | character varying(255) | YES |  |  |
| 7 | `is_active` | boolean | YES |  | true = active , false = inactive |
| 8 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `create_by` | character varying(50) | YES |  |  |
| 10 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 11 | `update_by` | character varying(50) | YES |  |  |
| 12 | `is_visa` | boolean | YES |  | true = is VISA , false = not VISA |
| 13 | `coverage_url` | text | YES |  | เอกสารแนบความคุ้มครอง |
| 14 | `priority` | smallint | YES |  | ลำดับการแสดงผล |
| 15 | `package_desc_1_th` | text | YES |  |  |
| 16 | `package_desc_1_en` | text | YES |  |  |
| 17 | `package_desc_2_th` | text | YES |  |  |
| 18 | `package_desc_2_en` | text | YES |  |  |
| 19 | `package_desc_3_th` | text | YES |  |  |
| 20 | `package_desc_3_en` | text | YES |  |  |
| 21 | `priority_addon` | smallint | YES |  |  |
| 22 | `is_addon` | boolean | YES | `false` | เป็น package addon หรือไม่ |
| 23 | `is_default` | boolean | YES | `false` | เป็น รายการแสดงพื้นฐานหรือไม่ |
| 24 | `ta_travel_type_id` | smallint | YES | `1` | รูปแบบประกัน รายเที่ยว,รายปี |

**Primary key:** `ta_package_id` (mas_ta_package_pkey)

**Inferred references (naming convention, NOT enforced FK):** `ta_travel_type_id` → mas_ta_travel_type

**Indexes:**

- `mas_ta_package_pkey`: `CREATE UNIQUE INDEX mas_ta_package_pkey ON insurverse.mas_ta_package USING btree (ta_package_id)`

---

## mas_ta_package_coverage

`insurverse.mas_ta_package_coverage` · kind: table · est. rows: **82**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ta_pack_cover_id` | integer | NO |  |  |
| 2 | `ta_package_id` | smallint | NO |  | รหัส TA package |
| 3 | `ta_coverage_id` | smallint | NO |  | รหัส TA coverage |
| 4 | `coverage_si_amt` | numeric(16,2) | YES |  | ทุนความคุ้มครอง |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `update_by` | character varying(50) | YES |  |  |
| 10 | `other_amt_min` | numeric(16,2) | YES |  | จำนวนต่ำสุดชดเชยหรือรักษาหรืออื่นๆ ต่อวัน/เดือน/ปี |
| 11 | `other_amt_max` | numeric(16,2) | YES |  | จำนวนสูงสุดชดเชยหรือรักษาหรืออื่นๆ ต่อวัน/เดือน/ปี |
| 12 | `priority` | smallint | YES |  | ลำดับการแสดงผล |
| 13 | `ta_pack_cover_code` | character varying(50) | YES |  | โค้ดรหัสสำหรับส่ง IIA |
| 14 | `ta_pack_cover_code_min` | character varying(50) | YES |  | โค้ดรหัสสำหรับส่ง IIA ขั้นต่ำ ชดเชยรายวัน |
| 15 | `ta_pack_cover_code_max` | character varying(50) | YES |  | โค้ดรหัสสำหรับส่ง IIA สูงสุด จำนวนไม่เกิน |

**Primary key:** `ta_pack_cover_id` (mas_ta_package_coverage_pkey)

**Inferred references (naming convention, NOT enforced FK):** `ta_coverage_id` → mas_ta_coverage, `ta_package_id` → mas_ta_package

**Indexes:**

- `mas_ta_package_coverage_pkey`: `CREATE UNIQUE INDEX mas_ta_package_coverage_pkey ON insurverse.mas_ta_package_coverage USING btree (ta_pack_cover_id)`

---

## mas_ta_package_coverage_26may2025

`insurverse.mas_ta_package_coverage_26may2025` · kind: table · est. rows: **58** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ta_pack_cover_id` | integer | YES |  |  |
| 2 | `ta_package_id` | smallint | YES |  |  |
| 3 | `ta_coverage_id` | smallint | YES |  |  |
| 4 | `coverage_si_amt` | numeric | YES |  |  |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `create_date` | timestamp without time zone | YES |  |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp without time zone | YES |  |  |
| 9 | `update_by` | character varying(50) | YES |  |  |
| 10 | `other_amt_min` | numeric | YES |  |  |
| 11 | `other_amt_max` | numeric | YES |  |  |
| 12 | `priority` | smallint | YES |  |  |
| 13 | `ta_pack_cover_code` | character varying(50) | YES |  |  |
| 14 | `ta_pack_cover_code_min` | character varying(50) | YES |  |  |
| 15 | `ta_pack_cover_code_max` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## mas_ta_premium

`insurverse.mas_ta_premium` · kind: table · est. rows: **965**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ta_premium_id` | integer | NO |  |  |
| 2 | `ta_package_id` | smallint | NO |  |  |
| 3 | `count_day` | smallint | NO |  |  |
| 4 | `prem_amt` | numeric(16,2) | NO |  |  |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `update_by` | character varying(50) | YES |  |  |
| 10 | `duty_amt` | numeric(16,2) | YES |  |  |
| 11 | `vat_amt` | numeric(16,2) | YES |  |  |
| 12 | `total_amt` | numeric(16,2) | YES |  |  |

**Primary key:** `ta_premium_id` (mas_ta_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `ta_package_id` → mas_ta_package

**Indexes:**

- `mas_ta_premium_pkey`: `CREATE UNIQUE INDEX mas_ta_premium_pkey ON insurverse.mas_ta_premium USING btree (ta_premium_id)`

---

## mas_ta_premium_26may2025

`insurverse.mas_ta_premium_26may2025` · kind: table · est. rows: **905** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ta_premium_id` | integer | YES |  |  |
| 2 | `ta_package_id` | smallint | YES |  |  |
| 3 | `count_day` | smallint | YES |  |  |
| 4 | `prem_amt` | numeric | YES |  |  |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `create_date` | timestamp without time zone | YES |  |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp without time zone | YES |  |  |
| 9 | `update_by` | character varying(50) | YES |  |  |
| 10 | `duty_amt` | numeric | YES |  |  |
| 11 | `vat_amt` | numeric | YES |  |  |
| 12 | `total_amt` | numeric | YES |  |  |

**Primary key:** _none_

---

## mas_ta_travel_type

`insurverse.mas_ta_travel_type` · kind: table · est. rows: **3**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `ta_travel_type_id` | smallint | NO |  | รหัสประเภทการเดินทาง |
| 2 | `mas_name_th` | character varying(255) | YES |  | ชื่อรูปแบบการเดินทางภาษาไทย |
| 3 | `mas_name_en` | character varying(255) | YES |  | ชื่อรูปแบบการเดินทางภาษาอังกฤษ |
| 4 | `mas_desc_th` | character varying(2000) | YES |  | รายละเอียดรูปแบบการเดินทางภาษาไทย |
| 5 | `mas_desc_en` | character varying(2000) | YES |  | รายละเอียดรูปแบบการเดินทางภาษาอังกฤษ |
| 6 | `is_other` | boolean | YES | `false` | กรณีเป็นอื่นๆ เพื่อรับค่าเพิ่ม |
| 7 | `is_group_travel` | boolean | YES | `false` | ลักษณะการเดินทาง true=เดินทางเป็นกลุ่ม, false=บุคคลเดียว |
| 8 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 9 | `create_by` | character varying(50) | YES |  |  |
| 10 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 11 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** `ta_travel_type_id` (mas_ta_travel_type_pkey)

**Indexes:**

- `mas_ta_travel_type_pkey`: `CREATE UNIQUE INDEX mas_ta_travel_type_pkey ON insurverse.mas_ta_travel_type USING btree (ta_travel_type_id)`

---

## mas_tariff

`insurverse.mas_tariff` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `tariff_id` | smallint | NO |  |  |
| 2 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 3 | `create_by` | character varying(50) | YES |  |  |
| 4 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `update_by` | character varying(50) | YES |  |  |
| 6 | `policy_type` | character varying(50) | YES |  | ชั้นประกัน |
| 7 | `tariff_group` | character varying(255) | YES |  | กลุ่ม tariff |
| 8 | `tariff_code` | character varying(255) | YES |  | โค้ด tariff |
| 9 | `tariff_factor` | numeric(10,4) | YES |  | ค่าคำนวณเบี้ย |
| 10 | `tariff_amount` | numeric(16,4) | YES |  | จำนวนของตัวแปร |
| 11 | `tariff_num_min` | numeric(16,4) | YES |  | จำนวนต่ำสุดของตัวแปร |
| 12 | `tariff_num_max` | numeric(16,4) | YES |  | จำนวนสูงสุดของตัวแปร |
| 13 | `tariff_mapping` | character varying(255) | YES |  | ตัวแปรเทียบ |
| 14 | `tariff_remark` | character varying(500) | YES |  | รายละเอียด |

**Primary key:** `tariff_id` (mas_tariff_pkey)

**Constraints:**

- UNIQUE `uq_mas_tariff_driver_behaviour`: `UNIQUE (policy_type, tariff_group, tariff_code, tariff_mapping)`

**Indexes:**

- `mas_tariff_pkey`: `CREATE UNIQUE INDEX mas_tariff_pkey ON insurverse.mas_tariff USING btree (tariff_id)`
- `uq_mas_tariff_driver_behaviour`: `CREATE UNIQUE INDEX uq_mas_tariff_driver_behaviour ON insurverse.mas_tariff USING btree (policy_type, tariff_group, tariff_code, tariff_mapping)`

---

## notification_business_rules

`insurverse.notification_business_rules` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | YES |  |  |
| 2 | `rule_name` | character varying(100) | YES |  |  |
| 3 | `rule_code` | character varying(50) | YES |  |  |
| 4 | `notification_type` | character varying(50) | YES |  |  |
| 5 | `is_active` | boolean | YES |  |  |
| 6 | `created_at` | timestamp without time zone | YES |  |  |
| 7 | `updated_at` | timestamp without time zone | YES |  |  |
| 8 | `created_by` | character varying(100) | YES |  |  |
| 9 | `updated_by` | character varying(100) | YES |  |  |
| 10 | `days_before` | integer | YES |  |  |
| 11 | `enable_email` | boolean | YES |  |  |
| 12 | `enable_sms` | boolean | YES |  |  |
| 13 | `enable_push` | boolean | YES |  |  |
| 14 | `enable_line` | boolean | YES |  |  |
| 15 | `email_template_code` | character varying(100) | YES |  |  |
| 16 | `sms_template_code` | character varying(100) | YES |  |  |
| 17 | `push_template_code` | character varying(100) | YES |  |  |
| 18 | `line_template_code` | character varying(100) | YES |  |  |
| 19 | `conditions` | jsonb | YES |  |  |

**Primary key:** _none_

---

## notification_queue

`insurverse.notification_queue` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | YES |  |  |
| 2 | `queue_type` | character varying(20) | YES |  |  |
| 3 | `channel_type` | character varying(20) | YES |  |  |
| 4 | `template_code` | character varying(100) | YES |  |  |
| 5 | `recipient_data` | jsonb | YES |  |  |
| 6 | `template_data` | jsonb | YES |  |  |
| 7 | `scheduled_at` | timestamp without time zone | YES |  |  |
| 8 | `status` | character varying(20) | YES |  |  |
| 9 | `priority` | integer | YES |  |  |
| 10 | `retry_count` | integer | YES |  |  |
| 11 | `max_retry` | integer | YES |  |  |
| 12 | `retry_delay_seconds` | integer | YES |  |  |
| 13 | `error_message` | text | YES |  |  |
| 14 | `provider_message_id` | character varying(200) | YES |  |  |
| 15 | `created_at` | timestamp without time zone | YES |  |  |
| 16 | `updated_at` | timestamp without time zone | YES |  |  |
| 17 | `sent_at` | timestamp without time zone | YES |  |  |
| 18 | `next_retry_at` | timestamp without time zone | YES |  |  |
| 19 | `reference_id` | character varying(100) | YES |  |  |
| 20 | `reference_type` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## notification_templates_extended

`insurverse.notification_templates_extended` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | YES |  |  |
| 2 | `template_code` | character varying(100) | YES |  |  |
| 3 | `channel_type` | character varying(20) | YES |  |  |
| 4 | `template_name` | character varying(200) | YES |  |  |
| 5 | `subject_template` | text | YES |  |  |
| 6 | `body_template` | text | YES |  |  |
| 7 | `variables` | jsonb | YES |  |  |
| 8 | `provider_code` | character varying(50) | YES |  |  |
| 9 | `is_active` | boolean | YES |  |  |
| 10 | `created_at` | timestamp without time zone | YES |  |  |
| 11 | `updated_at` | timestamp without time zone | YES |  |  |
| 12 | `created_by` | character varying(100) | YES |  |  |
| 13 | `updated_by` | character varying(100) | YES |  |  |

**Primary key:** _none_

---

## otp_daily_requests

`insurverse.otp_daily_requests` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.otp_daily_requests_id_seq'::regclass)` |  |
| 2 | `email` | character varying(255) | NO |  |  |
| 3 | `request_date` | date | NO | `CURRENT_DATE` |  |
| 4 | `request_count` | integer | YES | `1` |  |

**Primary key:** `id` (otp_daily_requests_pkey)

**Constraints:**

- UNIQUE `otp_daily_requests_email_request_date_key`: `UNIQUE (email, request_date)`

**Indexes:**

- `otp_daily_requests_email_request_date_key`: `CREATE UNIQUE INDEX otp_daily_requests_email_request_date_key ON insurverse.otp_daily_requests USING btree (email, request_date)`
- `otp_daily_requests_pkey`: `CREATE UNIQUE INDEX otp_daily_requests_pkey ON insurverse.otp_daily_requests USING btree (id)`

---

## otp_settings

`insurverse.otp_settings` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.otp_settings_id_seq'::regclass)` |  |
| 2 | `setting_key` | character varying(50) | NO |  |  |
| 3 | `setting_value` | character varying(255) | NO |  |  |
| 4 | `description` | text | YES |  |  |
| 5 | `updated_at` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |

**Primary key:** `id` (otp_settings_pkey)

**Constraints:**

- UNIQUE `otp_settings_setting_key_key`: `UNIQUE (setting_key)`

**Indexes:**

- `otp_settings_pkey`: `CREATE UNIQUE INDEX otp_settings_pkey ON insurverse.otp_settings USING btree (id)`
- `otp_settings_setting_key_key`: `CREATE UNIQUE INDEX otp_settings_setting_key_key ON insurverse.otp_settings USING btree (setting_key)`

---

## otp_verification

`insurverse.otp_verification` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.otp_verification_id_seq'::regclass)` |  |
| 2 | `email` | character varying(255) | NO |  |  |
| 3 | `otp` | character varying(10) | NO |  |  |
| 4 | `ref_code` | character varying(50) | NO |  |  |
| 5 | `created_at` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 6 | `expires_at` | timestamp without time zone | NO |  |  |
| 7 | `is_verified` | boolean | YES | `false` |  |
| 8 | `verified_at` | timestamp without time zone | YES |  |  |
| 9 | `attempt_count` | integer | YES | `0` |  |
| 10 | `notification_sent` | boolean | YES | `false` |  |

**Primary key:** `id` (otp_verification_pkey)

**Indexes:**

- `idx_otp_verification_email`: `CREATE INDEX idx_otp_verification_email ON insurverse.otp_verification USING btree (email)`
- `idx_otp_verification_otp`: `CREATE INDEX idx_otp_verification_otp ON insurverse.otp_verification USING btree (otp)`
- `idx_otp_verification_ref_code`: `CREATE INDEX idx_otp_verification_ref_code ON insurverse.otp_verification USING btree (ref_code)`
- `otp_verification_pkey`: `CREATE UNIQUE INDEX otp_verification_pkey ON insurverse.otp_verification USING btree (id)`

---

## payment

`insurverse.payment` · kind: table · est. rows: **1**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `invoice_no` | character varying(15) | NO |  | รหัสอ้างอิง 2C2P |
| 3 | `amount` | numeric(18,4) | NO |  | จำนวนเงินชำระ |
| 4 | `method` | character varying | NO |  | ประเภทชำระ |
| 5 | `description` | text | YES |  | รายละเอียด |
| 6 | `installment` | boolean | NO |  | ผ่อนหรือไม่ |
| 7 | `installment_period` | integer | YES |  | ผ่อนกี่เดือน |
| 8 | `payment_status` | character varying | NO |  | สถานะการชำระ |
| 9 | `customer_id` | character varying | YES |  | รหัสลูกค้า |
| 10 | `token` | text | NO |  |  |
| 11 | `url` | text | NO |  |  |
| 12 | `created_at` | timestamp without time zone | YES |  |  |
| 13 | `updated_at` | timestamp without time zone | YES |  |  |
| 14 | `customer_email` | character varying | YES |  | อีเมลลูกค้า |
| 15 | `lead_no` | integer | NO |  | รหัส lead no สมัครใจ |
| 16 | `remark` | text | YES |  | ความคิดเห็นการชำระเงินเพิ่มเติม |
| 17 | `sales_channel` | character varying(50) | YES |  | ช่องทางขาย |
| 18 | `ref1` | text | YES |  |  |
| 19 | `ref2` | text | YES |  |  |
| 20 | `ref3` | text | YES |  |  |
| 21 | `payment_channel` | character varying(255) | YES |  | ช่องทางชำระ |
| 22 | `is_manual_update` | boolean | YES | `false` | true มากจากเปลี่ยนสถานะเอง |
| 23 | `updated_manual_by` | character varying(255) | YES |  |  |

**Primary key:** `id` (payment_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium

**Indexes:**

- `idx_payment_invoice_no`: `CREATE INDEX idx_payment_invoice_no ON insurverse.payment USING btree (invoice_no)`
- `idx_payment_leadno_created`: `CREATE INDEX idx_payment_leadno_created ON insurverse.payment USING btree (lead_no, created_at DESC)`
- `payment_pkey`: `CREATE UNIQUE INDEX payment_pkey ON insurverse.payment USING btree (id)`

---

## payment_act

`insurverse.payment_act` · kind: table · est. rows: **173**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `invoice_no` | character varying(15) | NO |  | รหัสอ้างอิง 2C2P |
| 3 | `amount` | numeric | NO |  | จำนวนเงินชำระ |
| 4 | `method` | character varying | NO |  | ประเภทชำระ |
| 5 | `description` | text | YES |  | รายละเอียด |
| 6 | `installment` | boolean | NO |  | ผ่อนหรือไม่ |
| 7 | `installment_period` | integer | YES |  | ผ่อนกี่เดือน |
| 8 | `payment_status` | character varying | NO |  | สถานะการชำระ |
| 9 | `customer_id` | character varying | YES |  | รหัสลูกค้า |
| 10 | `token` | text | NO |  |  |
| 11 | `url` | text | NO |  |  |
| 12 | `created_at` | timestamp without time zone | YES |  |  |
| 13 | `updated_at` | timestamp without time zone | YES |  |  |
| 14 | `customer_email` | character varying | YES |  | อีเมลลูกค้า |
| 15 | `act_no` | integer | NO |  | รหัส lead no พรบ |
| 16 | `remark` | text | YES |  | ความคิดเห็นการชำระเงินเพิ่มเติม |
| 17 | `sales_channel` | character varying(50) | YES |  | ช่องทางขาย |
| 18 | `ref1` | text | YES |  |  |
| 19 | `ref2` | text | YES |  |  |
| 20 | `ref3` | text | YES |  |  |
| 21 | `payment_channel` | character varying(255) | YES |  | ช่องทางชำระ |
| 22 | `is_manual_update` | boolean | YES | `false` | true มากจากเปลี่ยนสถานะเอง |
| 23 | `updated_manual_by` | character varying(255) | YES |  |  |

**Primary key:** `id` (payment_act_pkey)

**Indexes:**

- `idx_payment_act_actno_created`: `CREATE INDEX idx_payment_act_actno_created ON insurverse.payment_act USING btree (act_no, created_at DESC)`
- `idx_payment_act_invoice_no`: `CREATE INDEX idx_payment_act_invoice_no ON insurverse.payment_act USING btree (invoice_no)`
- `payment_act_pkey`: `CREATE UNIQUE INDEX payment_act_pkey ON insurverse.payment_act USING btree (id)`

---

## payment_callback

`insurverse.payment_callback` · kind: table · est. rows: **38**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `cb_no` | integer | NO | `nextval('insurverse.pm_callback_cb_no_seq'::regclass)` |  |
| 2 | `json_body` | json | YES |  |  |
| 3 | `data` | json | YES |  |  |
| 4 | `created_at` | timestamp without time zone | YES |  |  |
| 5 | `updated_at` | timestamp without time zone | YES |  |  |
| 6 | `invoice_no` | character varying | YES |  |  |
| 7 | `payment_type` | character varying | YES |  |  |
| 8 | `callback_type` | character varying | YES |  |  |

**Primary key:** `cb_no` (pm_callback_pkey)

**Indexes:**

- `idx_payment_callback_invoiceno_created`: `CREATE INDEX idx_payment_callback_invoiceno_created ON insurverse.payment_callback USING btree (((data ->> 'invoiceNo'::text)), created_at DESC)`
- `pm_callback_pkey`: `CREATE UNIQUE INDEX pm_callback_pkey ON insurverse.payment_callback USING btree (cb_no)`

---

## payment_ta

`insurverse.payment_ta` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `invoice_no` | character varying(15) | NO |  |  |
| 3 | `amount` | numeric | NO |  |  |
| 4 | `method` | character varying | NO |  |  |
| 5 | `description` | text | YES |  |  |
| 6 | `installment` | boolean | NO |  |  |
| 7 | `installment_period` | integer | YES |  |  |
| 8 | `payment_status` | character varying | NO |  |  |
| 9 | `customer_id` | character varying | YES |  |  |
| 10 | `token` | text | NO |  |  |
| 11 | `url` | text | NO |  |  |
| 12 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 13 | `updated_at` | timestamp without time zone | YES |  |  |
| 14 | `customer_email` | character varying | YES |  |  |
| 15 | `lead_ta_no` | integer | NO |  |  |

**Primary key:** `id` (payment_ta_pkey)

**Inferred references (naming convention, NOT enforced FK):** `lead_ta_no` → lead_ta_premium

**Indexes:**

- `idx_payment_ta_invoice_no`: `CREATE INDEX idx_payment_ta_invoice_no ON insurverse.payment_ta USING btree (invoice_no)`
- `idx_payment_ta_leadno_created`: `CREATE INDEX idx_payment_ta_leadno_created ON insurverse.payment_ta USING btree (lead_ta_no, created_at DESC)`
- `payment_ta_pkey`: `CREATE UNIQUE INDEX payment_ta_pkey ON insurverse.payment_ta USING btree (id)`

---

## payment_transaction

`insurverse.payment_transaction` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `invoice_no` | character varying(15) | NO |  |  |
| 3 | `amount` | numeric(18,4) | NO |  |  |
| 4 | `method` | character varying | NO |  |  |
| 5 | `description` | text | YES |  |  |
| 6 | `installment` | boolean | NO |  |  |
| 7 | `installment_period` | integer | YES |  |  |
| 8 | `payment_status` | character varying | NO |  |  |
| 9 | `customer_id` | character varying | YES |  |  |
| 10 | `token` | text | NO |  |  |
| 11 | `url` | text | NO |  |  |
| 12 | `created_at` | timestamp without time zone | YES |  |  |
| 13 | `updated_at` | timestamp without time zone | YES |  |  |
| 14 | `customer_email` | character varying | YES |  |  |
| 15 | `lead_no` | integer | NO |  |  |
| 16 | `lead_type` | character varying | YES |  |  |
| 17 | `user_id` | character varying | YES |  |  |

**Primary key:** `id` (payment_pkey_1)

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium

**Indexes:**

- `idx_payment_txn_invoice_no`: `CREATE INDEX idx_payment_txn_invoice_no ON insurverse.payment_transaction USING btree (invoice_no)`
- `idx_payment_txn_lead_type_created`: `CREATE INDEX idx_payment_txn_lead_type_created ON insurverse.payment_transaction USING btree (lead_no, lead_type, created_at DESC)`
- `payment_pkey_1`: `CREATE UNIQUE INDEX payment_pkey_1 ON insurverse.payment_transaction USING btree (id)`

---

## policy_cache_new

`insurverse.policy_cache_new` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|

**Primary key:** _none_

---

## policy_form_submissions

`insurverse.policy_form_submissions` · kind: table · est. rows: **6**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.policy_form_submissions_id_seq'::regclass)` |  |
| 2 | `order_sn` | character varying(255) | NO |  |  |
| 3 | `form_data` | jsonb | YES |  |  |
| 4 | `form_status` | character varying(50) | YES | `'pending'::character varying` |  |
| 5 | `ip_address` | character varying(50) | YES |  |  |
| 6 | `user_agent` | text | YES |  |  |
| 7 | `error_message` | text | YES |  |  |
| 8 | `api_request_payload` | jsonb | YES |  |  |
| 9 | `api_response_payload` | jsonb | YES |  |  |
| 10 | `created_at` | timestamp with time zone | NO |  |  |
| 11 | `updated_at` | timestamp with time zone | NO |  |  |
| 12 | `completed_at` | timestamp with time zone | YES |  |  |

**Primary key:** `id` (policy_form_submissions_pkey)

**Foreign keys:**

- `order_sn` → `insurverse.callback_logs(order_sn)` — policy_form_submissions_order_sn_fkey

**Indexes:**

- `policy_form_submissions_pkey`: `CREATE UNIQUE INDEX policy_form_submissions_pkey ON insurverse.policy_form_submissions USING btree (id)`

---

## policy_form_templates

`insurverse.policy_form_templates` · kind: table · est. rows: **6**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.policy_form_templates_id_seq'::regclass)` |  |
| 2 | `item_sku` | character varying(100) | NO |  |  |
| 3 | `model_sku` | character varying(100) | YES |  |  |
| 4 | `form_structure` | jsonb | NO |  |  |
| 5 | `required_fields` | jsonb | NO |  |  |
| 6 | `default_values` | jsonb | YES |  |  |
| 7 | `active` | boolean | YES | `true` |  |
| 8 | `created_at` | timestamp with time zone | NO |  |  |
| 9 | `updated_at` | timestamp with time zone | NO |  |  |

**Primary key:** `id` (policy_form_templates_pkey)

**Constraints:**

- UNIQUE `policy_form_templates_item_sku_key`: `UNIQUE (item_sku)`

**Indexes:**

- `policy_form_templates_item_sku_key`: `CREATE UNIQUE INDEX policy_form_templates_item_sku_key ON insurverse.policy_form_templates USING btree (item_sku)`
- `policy_form_templates_pkey`: `CREATE UNIQUE INDEX policy_form_templates_pkey ON insurverse.policy_form_templates USING btree (id)`

---

## policy_home_endorse_detail

`insurverse.policy_home_endorse_detail` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `policy_home_no` | character varying(50) | YES |  |  |
| 3 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 4 | `doc_type` | character varying(500) | YES |  | ประเภทเอกสาร |
| 5 | `sf_policy_id` | character varying(255) | NO |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 6 | `policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 7 | `policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 8 | `receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 9 | `receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 10 | `sf_epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 11 | `sf_etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 12 | `debt_increase_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเพิ่มหนี้ PDF จาก I-NET |
| 13 | `debt_increase_url_copy_ref` | character varying(500) | YES |  |  |
| 14 | `debt_decrease_url_ref` | character varying(500) | YES |  |  |
| 15 | `debt_decrease_url_copy_ref` | character varying(500) | YES |  |  |
| 16 | `policy_book` | character varying(50) | YES |  |  |
| 17 | `policy_quotation_no` | character varying(50) | YES |  |  |
| 18 | `policy_invoice_no` | character varying(50) | YES |  |  |
| 19 | `effective_date` | timestamp without time zone | YES |  |  |
| 20 | `prev_policy_book` | character varying(50) | YES |  |  |
| 21 | `prev_policy_quotation_no` | character varying(50) | YES |  |  |
| 22 | `prev_policy_invoice_no` | character varying(50) | YES |  |  |
| 23 | `prev_sf_policy_id` | character varying(255) | YES |  |  |
| 24 | `is_cancel` | boolean | YES |  |  |
| 25 | `policy_receipt_no` | character varying(50) | YES |  |  |
| 26 | `request_endorse_no` | uuid | YES |  | เลขแจ้งสลักหลังจากแจ้งขอ Endorsement ผ่าน PWA |

**Primary key:** `id` (policy_home_endorse_detail_pk)

**Inferred references (naming convention, NOT enforced FK):** `policy_home_no` → policy_home_premium

**Indexes:**

- `policy_home_endorse_detail_pk`: `CREATE UNIQUE INDEX policy_home_endorse_detail_pk ON insurverse.policy_home_endorse_detail USING btree (id)`

---

## policy_home_premium

`insurverse.policy_home_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_home_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 3 | `policy_status` | character varying(50) | YES |  | ACT = active , INC = inactive |
| 4 | `lead_home_no` | integer | NO |  |  |
| 5 | `policy_startdate` | timestamp without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 6 | `policy_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 7 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 8 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 9 | `payment_channel` | character varying(50) | YES |  |  |
| 10 | `payment_type` | character varying(50) | YES |  |  |
| 11 | `payment_no` | character varying(50) | YES |  |  |
| 12 | `payment_ref1` | character varying(50) | YES |  |  |
| 13 | `payment_ref2` | character varying(50) | YES |  |  |
| 14 | `payment_result` | character varying(50) | YES |  |  |
| 15 | `payment_date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 16 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 17 | `create_by` | character varying(50) | YES |  |  |
| 18 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 19 | `update_by` | character varying(50) | YES |  |  |
| 20 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 21 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 22 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 23 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 24 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 25 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 26 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 27 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 28 | `policy_book` | character varying(50) | YES |  | เลข book |
| 29 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 30 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 31 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 32 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 33 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 34 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 35 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 36 | `deli_flag` | boolean | YES |  |  |
| 37 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 38 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 39 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 40 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 41 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 42 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 43 | `home_building_type_id` | smallint | YES |  | รหัสประเภทอาคาร |
| 44 | `home_building_province_id` | smallint | YES |  | รหัสจังหวัด |
| 45 | `home_material_type_id` | integer | YES |  | รหัสประเภทวัสดุอาคาร |
| 46 | `home_resident_type_id` | smallint | YES |  | รหัสประเภทผู้อยู่อาศัย |
| 47 | `building_address_th` | character varying(500) | YES |  | ที่อยู่อาคารประกัน |
| 48 | `building_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 49 | `building_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่อาคารประกัน |
| 50 | `building_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่อาคารประกัน |
| 51 | `building_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่อาคารประกัน |
| 52 | `building_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่อาคารประกัน |
| 53 | `building_country_id` | integer | YES |  | ประเทศที่อยู่อาคารประกัน |
| 54 | `effective_startdate` | timestamp without time zone | YES |  | วันที่เริ่มต้นมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 55 | `effective_enddate` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 56 | `policy_url_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์ต้นฉบับ |
| 57 | `policy_url_copy_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์สำเนา |
| 58 | `receipt_url_ref` | character varying(500) | YES |  | URL เอกสารใบกำกับภาษีต้นฉบับ |
| 59 | `sf_file_id_policy_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์ต้นฉบับ |
| 60 | `sf_file_id_policy_url_copy` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์สำเนา |
| 61 | `sf_file_id_receipt_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารใบกำกับภาษีต้นฉบับ |
| 62 | `iia_response_code` | character varying(255) | YES |  | IIA Response Code |
| 63 | `iia_response_last_at` | timestamp without time zone | YES |  | IIA Response Lastest Update At |

**Primary key:** `policy_home_no` (policy_home_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `home_building_type_id` → mas_home_building_type, `home_material_type_id` → mas_home_material_type, `home_resident_type_id` → mas_home_resident_type, `promo_trans_id` → promo_code_trans

**Indexes:**

- `policy_home_premium_pkey`: `CREATE UNIQUE INDEX policy_home_premium_pkey ON insurverse.policy_home_premium USING btree (policy_home_no)`

---

## policy_home_premium_trans

`insurverse.policy_home_premium_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_home_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 3 | `policy_status` | character varying(50) | YES |  | ACT = active , INC = inactive |
| 4 | `lead_home_no` | integer | NO |  |  |
| 5 | `policy_startdate` | timestamp without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 6 | `policy_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 7 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 8 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 9 | `payment_channel` | character varying(50) | YES |  |  |
| 10 | `payment_type` | character varying(50) | YES |  |  |
| 11 | `payment_no` | character varying(50) | YES |  |  |
| 12 | `payment_ref1` | character varying(50) | YES |  |  |
| 13 | `payment_ref2` | character varying(50) | YES |  |  |
| 14 | `payment_result` | character varying(50) | YES |  |  |
| 15 | `payment_date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 16 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 17 | `create_by` | character varying(50) | YES |  |  |
| 18 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 19 | `update_by` | character varying(50) | YES |  |  |
| 20 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 21 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 22 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 23 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 24 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 25 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 26 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 27 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 28 | `policy_book` | character varying(50) | YES |  | เลข book |
| 29 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 30 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 31 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 32 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 33 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 34 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 35 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 36 | `deli_flag` | boolean | YES |  |  |
| 37 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 38 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 39 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 40 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 41 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 42 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 43 | `home_building_type_id` | smallint | YES |  | รหัสประเภทอาคาร |
| 44 | `home_building_province_id` | smallint | YES |  | รหัสจังหวัด |
| 45 | `home_material_type_id` | integer | YES |  | รหัสประเภทวัสดุอาคาร |
| 46 | `home_resident_type_id` | smallint | YES |  | รหัสประเภทผู้อยู่อาศัย |
| 47 | `building_address_th` | character varying(500) | YES |  | ที่อยู่อาคารประกัน |
| 48 | `building_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 49 | `building_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่อาคารประกัน |
| 50 | `building_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่อาคารประกัน |
| 51 | `building_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่อาคารประกัน |
| 52 | `building_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่อาคารประกัน |
| 53 | `building_country_id` | integer | YES |  | ประเทศที่อยู่อาคารประกัน |
| 54 | `effective_startdate` | timestamp without time zone | YES |  | วันที่เริ่มต้นมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 55 | `effective_enddate` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 56 | `policy_url_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์ต้นฉบับ |
| 57 | `policy_url_copy_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์สำเนา |
| 58 | `receipt_url_ref` | character varying(500) | YES |  | URL เอกสารใบกำกับภาษีต้นฉบับ |
| 59 | `sf_file_id_policy_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์ต้นฉบับ |
| 60 | `sf_file_id_policy_url_copy` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์สำเนา |
| 61 | `sf_file_id_receipt_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารใบกำกับภาษีต้นฉบับ |
| 62 | `iia_response_code` | character varying(255) | YES |  | IIA Response Code |
| 63 | `iia_response_last_at` | timestamp without time zone | YES |  | IIA Response Lastest Update At |

**Primary key:** `policy_home_no,sf_policy_id` (policy_home_premium_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `home_building_type_id` → mas_home_building_type, `home_material_type_id` → mas_home_material_type, `home_resident_type_id` → mas_home_resident_type, `policy_home_no` → policy_home_premium, `promo_trans_id` → promo_code_trans

**Indexes:**

- `policy_home_premium_trans_pkey`: `CREATE UNIQUE INDEX policy_home_premium_trans_pkey ON insurverse.policy_home_premium_trans USING btree (policy_home_no, sf_policy_id)`

---

## policy_no

`insurverse.policy_no` · kind: table · est. rows: **106**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `policy_no` | character varying | YES |  |  |
| 3 | `created_date` | timestamp without time zone | YES |  |  |
| 4 | `updated_date` | timestamp without time zone | YES |  |  |

**Primary key:** `id` (policy_no_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

**Indexes:**

- `policy_no_pkey`: `CREATE UNIQUE INDEX policy_no_pkey ON insurverse.policy_no USING btree (id)`

---

## policy_optimized_email_list

`insurverse.policy_optimized_email_list` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `email` | character varying(100) | NO |  |  |

**Primary key:** `email` (policy_optimized_email_list_pkey)

**Indexes:**

- `policy_optimized_email_list_pkey`: `CREATE UNIQUE INDEX policy_optimized_email_list_pkey ON insurverse.policy_optimized_email_list USING btree (email)`

---

## policy_overlap_whitelist

`insurverse.policy_overlap_whitelist` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO | `nextval('insurverse.policy_overlap_whitelist_id_seq'::regclass)` |  |
| 2 | `car_serial_no` | character varying(50) | NO |  |  |
| 3 | `reason` | text | NO |  |  |
| 4 | `expired_at` | timestamp without time zone | YES |  |  |
| 5 | `is_active` | boolean | NO | `true` |  |
| 6 | `created_dt` | timestamp without time zone | NO | `CURRENT_TIMESTAMP` |  |
| 7 | `created_by` | character varying(100) | NO |  |  |
| 8 | `updated_dt` | timestamp without time zone | YES |  |  |
| 9 | `updated_by` | character varying(100) | YES |  |  |

**Primary key:** `id` (policy_overlap_whitelist_pkey)

**Indexes:**

- `idx_policy_overlap_whitelist_chassis`: `CREATE INDEX idx_policy_overlap_whitelist_chassis ON insurverse.policy_overlap_whitelist USING btree (upper(TRIM(BOTH FROM car_serial_no))) WHERE is_active`
- `policy_overlap_whitelist_pkey`: `CREATE UNIQUE INDEX policy_overlap_whitelist_pkey ON insurverse.policy_overlap_whitelist USING btree (id)`

---

## policy_pa_endorse_detail

`insurverse.policy_pa_endorse_detail` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `policy_pa_no` | character varying(50) | YES |  |  |
| 3 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 4 | `doc_type` | character varying(500) | YES |  | ประเภทเอกสาร |
| 5 | `sf_policy_id` | character varying(255) | NO |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 6 | `policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 7 | `policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 8 | `receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 9 | `receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 10 | `sf_epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 11 | `sf_etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 12 | `debt_increase_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเพิ่มหนี้ PDF จาก I-NET |
| 13 | `debt_increase_url_copy_ref` | character varying(500) | YES |  |  |
| 14 | `debt_decrease_url_ref` | character varying(500) | YES |  |  |
| 15 | `debt_decrease_url_copy_ref` | character varying(500) | YES |  |  |
| 16 | `policy_book` | character varying(50) | YES |  |  |
| 17 | `policy_quotation_no` | character varying(50) | YES |  |  |
| 18 | `policy_invoice_no` | character varying(50) | YES |  |  |
| 19 | `effective_date` | timestamp without time zone | YES |  |  |
| 20 | `prev_policy_book` | character varying(50) | YES |  |  |
| 21 | `prev_policy_quotation_no` | character varying(50) | YES |  |  |
| 22 | `prev_policy_invoice_no` | character varying(50) | YES |  |  |
| 23 | `prev_sf_policy_id` | character varying(255) | YES |  |  |
| 24 | `is_cancel` | boolean | YES |  |  |
| 25 | `policy_receipt_no` | character varying(50) | YES |  |  |
| 26 | `request_endorse_no` | uuid | YES |  | เลขแจ้งสลักหลังจากแจ้งขอ Endorsement ผ่าน PWA |

**Primary key:** `id` (policy_pa_endorse_detail_pk)

**Inferred references (naming convention, NOT enforced FK):** `policy_pa_no` → policy_pa_premium

**Indexes:**

- `policy_pa_endorse_detail_pk`: `CREATE UNIQUE INDEX policy_pa_endorse_detail_pk ON insurverse.policy_pa_endorse_detail USING btree (id)`

---

## policy_pa_premium

`insurverse.policy_pa_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_pa_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 3 | `policy_status` | character varying(50) | YES |  | ACT = active , INC = inactive |
| 4 | `lead_pa_no` | integer | NO |  |  |
| 5 | `pa_package_id` | smallint | YES |  | รหัส PA package |
| 6 | `policy_startdate` | timestamp without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 7 | `policy_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 8 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 9 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 10 | `payment_channel` | character varying(50) | YES |  |  |
| 11 | `payment_type` | character varying(50) | YES |  |  |
| 12 | `payment_no` | character varying(50) | YES |  |  |
| 13 | `payment_ref1` | character varying(50) | YES |  |  |
| 14 | `payment_ref2` | character varying(50) | YES |  |  |
| 15 | `payment_result` | character varying(50) | YES |  |  |
| 16 | `payment_date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 17 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 18 | `create_by` | character varying(50) | YES |  |  |
| 19 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 20 | `update_by` | character varying(50) | YES |  |  |
| 21 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 22 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 23 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 24 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 25 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 26 | `vat_amt` | numeric(16,4) | YES | `0` | ราคา vat |
| 27 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 28 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 29 | `policy_book` | character varying(50) | YES |  | เลข book |
| 30 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 31 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 32 | `pa_age_range_id` | smallint | YES |  | รหัสช่วงอายุ |
| 33 | `pa_occupation_id` | smallint | YES |  | รหัสอาชีพ |
| 34 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 35 | `tax_deductions` | boolean | YES |  | ออกเอกสารลดหย่อนภาษีหรือไม่ |
| 36 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 37 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 38 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 39 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 40 | `deli_flag` | boolean | YES |  |  |
| 41 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 42 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 43 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 44 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 45 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 46 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 47 | `pa_question_id_array` | character varying(255) | YES |  | คำถามสุขภาพที่เลือก |
| 48 | `effective_startdate` | timestamp without time zone | YES |  | วันที่เริ่มต้นมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 49 | `effective_enddate` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 50 | `policy_url_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์ต้นฉบับ |
| 51 | `policy_url_copy_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์สำเนา |
| 52 | `receipt_url_ref` | character varying(500) | YES |  | URL เอกสารใบกำกับภาษีต้นฉบับ |
| 53 | `sf_file_id_policy_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์ต้นฉบับ |
| 54 | `sf_file_id_policy_url_copy` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์สำเนา |
| 55 | `sf_file_id_receipt_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารใบกำกับภาษีต้นฉบับ |
| 56 | `iia_response_code` | character varying(255) | YES |  | IIA Response Code |
| 57 | `iia_response_last_at` | timestamp without time zone | YES |  | IIA Response Lastest Update At |
| 58 | `tax_deductions_url_ref` | character varying(500) | YES |  | URL เอกสารลดหย่อนภาษีต้นฉบับ |
| 59 | `tax_deductions_url_ref_copy` | character varying(500) | YES |  | URL เอกสารลดหย่อนภาษีสำเนา |
| 60 | `tax_deductions_death_amt` | numeric(16,4) | YES |  | ลดหย่อนภาษีเสียชีวิต |
| 61 | `tax_deductions_medical_amt` | numeric(16,4) | YES |  | ลดหย่อนภาษีรักษาพยาบาล |
| 62 | `tax_deductions_total_amt` | numeric(16,4) | YES |  | ลดหย่อนภาษีรวม |
| 63 | `policy_receipt_no` | character varying(50) | YES |  | เลขที่ใบเสร็จ |
| 64 | `tax_deductions_date` | timestamp without time zone | YES |  | วันที่ออกเอกสารลดหย่อนภาษี |

**Primary key:** `policy_pa_no` (policy_pa_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `lead_pa_no` → lead_pa_premium, `pa_age_range_id` → mas_pa_age_range, `pa_occupation_id` → mas_pa_occupation, `pa_package_id` → mas_pa_package, `promo_trans_id` → promo_code_trans

**Indexes:**

- `policy_pa_premium_pkey`: `CREATE UNIQUE INDEX policy_pa_premium_pkey ON insurverse.policy_pa_premium USING btree (policy_pa_no)`

---

## policy_pa_premium_trans

`insurverse.policy_pa_premium_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_pa_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 3 | `policy_status` | character varying(50) | YES |  | ACT = active , INC = inactive |
| 4 | `lead_pa_no` | integer | NO |  |  |
| 5 | `pa_package_id` | smallint | YES |  | รหัส PA package |
| 6 | `policy_startdate` | timestamp without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 7 | `policy_enddate` | timestamp without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 8 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 9 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 10 | `payment_channel` | character varying(50) | YES |  |  |
| 11 | `payment_type` | character varying(50) | YES |  |  |
| 12 | `payment_no` | character varying(50) | YES |  |  |
| 13 | `payment_ref1` | character varying(50) | YES |  |  |
| 14 | `payment_ref2` | character varying(50) | YES |  |  |
| 15 | `payment_result` | character varying(50) | YES |  |  |
| 16 | `payment_date` | timestamp without time zone | YES |  | วันที่ชำระเงิน |
| 17 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 18 | `create_by` | character varying(50) | YES |  |  |
| 19 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 20 | `update_by` | character varying(50) | YES |  |  |
| 21 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 22 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 23 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 24 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 25 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 26 | `vat_amt` | numeric(16,4) | YES | `0` | ราคา vat |
| 27 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 28 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 29 | `policy_book` | character varying(50) | YES |  | เลข book |
| 30 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 31 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 32 | `pa_age_range_id` | smallint | YES |  | รหัสช่วงอายุ |
| 33 | `pa_occupation_id` | smallint | YES |  | รหัสอาชีพ |
| 34 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 35 | `tax_deductions` | boolean | YES |  | ออกเอกสารลดหย่อนภาษีหรือไม่ |
| 36 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 37 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 38 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 39 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 40 | `deli_flag` | boolean | YES |  |  |
| 41 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 42 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 43 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 44 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 45 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 46 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 47 | `pa_question_id_array` | character varying(255) | YES |  | คำถามสุขภาพที่เลือก |
| 48 | `effective_startdate` | timestamp without time zone | YES |  | วันที่เริ่มต้นมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 49 | `effective_enddate` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 50 | `policy_url_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์ต้นฉบับ |
| 51 | `policy_url_copy_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์สำเนา |
| 52 | `receipt_url_ref` | character varying(500) | YES |  | URL เอกสารใบกำกับภาษีต้นฉบับ |
| 53 | `sf_file_id_policy_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์ต้นฉบับ |
| 54 | `sf_file_id_policy_url_copy` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์สำเนา |
| 55 | `sf_file_id_receipt_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารใบกำกับภาษีต้นฉบับ |
| 56 | `iia_response_code` | character varying(255) | YES |  | IIA Response Code |
| 57 | `iia_response_last_at` | timestamp without time zone | YES |  | IIA Response Lastest Update At |
| 58 | `tax_deductions_url_ref` | character varying(500) | YES |  | URL เอกสารลดหย่อนภาษีต้นฉบับ |
| 59 | `tax_deductions_url_ref_copy` | character varying(500) | YES |  | URL เอกสารลดหย่อนภาษีสำเนา |
| 60 | `tax_deductions_death_amt` | numeric(16,4) | YES |  | ลดหย่อนภาษีเสียชีวิต |
| 61 | `tax_deductions_medical_amt` | numeric(16,4) | YES |  | ลดหย่อนภาษีรักษาพยาบาล |
| 62 | `tax_deductions_total_amt` | numeric(16,4) | YES |  | ลดหย่อนภาษีรวม |
| 63 | `policy_receipt_no` | character varying(50) | YES |  | เลขที่ใบเสร็จ |
| 64 | `tax_deductions_date` | timestamp without time zone | YES |  | วันที่ออกเอกสารลดหย่อนภาษี |

**Primary key:** `policy_pa_no,sf_policy_id` (policy_pa_premium_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `lead_pa_no` → lead_pa_premium, `pa_age_range_id` → mas_pa_age_range, `pa_occupation_id` → mas_pa_occupation, `pa_package_id` → mas_pa_package, `policy_pa_no` → policy_pa_premium, `promo_trans_id` → promo_code_trans

**Indexes:**

- `policy_pa_premium_trans_pkey`: `CREATE UNIQUE INDEX policy_pa_premium_trans_pkey ON insurverse.policy_pa_premium_trans USING btree (policy_pa_no, sf_policy_id)`

---

## policy_participant

`insurverse.policy_participant` · kind: table · est. rows: **162**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `par_id` | integer | NO |  |  |
| 2 | `owner_prefix_name` | character varying(50) | YES |  |  |
| 3 | `owner_first_name` | character varying(255) | YES |  | ผู้เอา กรมธรรม์ |
| 4 | `owner_last_name` | character varying(255) | YES |  |  |
| 5 | `owner_citizen_id` | character varying(20) | YES |  | ผู้เอากรมธรรม์รหัสบัตรประชาชน |
| 6 | `create_date` | timestamp without time zone | YES |  |  |
| 7 | `create_by` | character varying(50) | YES |  |  |
| 8 | `update_date` | timestamp without time zone | YES |  |  |
| 9 | `update_by` | character varying(50) | YES |  |  |
| 10 | `sf_account` | character varying(50) | YES |  |  |
| 11 | `owner_birth_date` | date | YES |  |  |

**Primary key:** `par_id` (policy_participant_pkey)

**Indexes:**

- `policy_participant_pkey`: `CREATE UNIQUE INDEX policy_participant_pkey ON insurverse.policy_participant USING btree (par_id)`

---

## policy_ta_coverage

`insurverse.policy_ta_coverage` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_ta_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 3 | `ta_package_id` | smallint | YES |  | รหัส package |
| 4 | `ta_coverage_id` | smallint | NO |  | รหัสความคุ้มครอง |
| 5 | `coverage_si_amt` | numeric(16,2) | YES |  | ทุนความคุ้มครอง |
| 6 | `is_active` | boolean | YES |  | สถานะความคุ้มครอง |
| 7 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(50) | YES |  |  |
| 9 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 10 | `update_by` | character varying(50) | YES |  |  |
| 11 | `other_amt_min` | numeric(16,2) | YES |  | จำนวนต่ำสุดชดเชยหรือรักษาหรืออื่นๆ ต่อวัน/เดือน/ปี |
| 12 | `other_amt_max` | numeric(16,2) | YES |  | จำนวนสูงสุดชดเชยหรือรักษาหรืออื่นๆ ต่อวัน/เดือน/ปี |

**Primary key:** `policy_ta_no,ta_coverage_id` (policy_ta_coverage_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_ta_no` → policy_ta_premium, `ta_coverage_id` → mas_ta_coverage, `ta_package_id` → mas_ta_package

**Indexes:**

- `policy_ta_coverage_pkey`: `CREATE UNIQUE INDEX policy_ta_coverage_pkey ON insurverse.policy_ta_coverage USING btree (policy_ta_no, ta_coverage_id)`

---

## policy_ta_coverage_trans

`insurverse.policy_ta_coverage_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_ta_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 3 | `ta_package_id` | smallint | YES |  | รหัส package |
| 4 | `ta_coverage_id` | smallint | NO |  | รหัสความคุ้มครอง |
| 5 | `coverage_si_amt` | numeric(16,2) | YES |  | ทุนความคุ้มครอง |
| 6 | `is_active` | boolean | YES |  | สถานะความคุ้มครอง |
| 7 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 8 | `create_by` | character varying(50) | YES |  |  |
| 9 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 10 | `update_by` | character varying(50) | YES |  |  |
| 11 | `other_amt_min` | numeric(16,2) | YES |  | จำนวนต่ำสุดชดเชยหรือรักษาหรืออื่นๆ ต่อวัน/เดือน/ปี |
| 12 | `other_amt_max` | numeric(16,2) | YES |  | จำนวนสูงสุดชดเชยหรือรักษาหรืออื่นๆ ต่อวัน/เดือน/ปี |

**Primary key:** `policy_ta_no,ta_coverage_id,sf_policy_id` (policy_ta_coverage_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_ta_no` → policy_ta_premium, `ta_coverage_id` → mas_ta_coverage, `ta_package_id` → mas_ta_package

**Indexes:**

- `policy_ta_coverage_copy1_pkey`: `CREATE UNIQUE INDEX policy_ta_coverage_copy1_pkey ON insurverse.policy_ta_coverage_trans USING btree (policy_ta_no, ta_coverage_id, sf_policy_id)`

---

## policy_ta_endorse_detail

`insurverse.policy_ta_endorse_detail` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `policy_ta_no` | character varying(50) | YES |  |  |
| 3 | `create_at` | timestamp(6) without time zone | YES | `now()` |  |
| 4 | `doc_type` | character varying(500) | YES |  | ประเภทเอกสาร |
| 5 | `sf_policy_id` | character varying(255) | NO |  | Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง) |
| 6 | `policy_url_ref` | character varying(500) | YES |  | อ้างอิง URL กรมธรรม์ PDF จาก I-NET |
| 7 | `policy_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET |
| 8 | `receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 9 | `receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 10 | `sf_epolicy_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Policy |
| 11 | `sf_etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 12 | `debt_increase_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเพิ่มหนี้ PDF จาก I-NET |
| 13 | `debt_increase_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเพิ่มหนี้ PDF จาก I-NET |
| 14 | `debt_decrease_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบลดหนี้ PDF จาก I-NET |
| 15 | `debt_decrease_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบลดหนี้ PDF จาก I-NET |
| 16 | `policy_book` | character varying(50) | YES |  |  |
| 17 | `policy_quotation_no` | character varying(50) | YES |  |  |
| 18 | `policy_invoice_no` | character varying(50) | YES |  |  |
| 19 | `effective_date` | timestamp(6) without time zone | YES |  | วันที่บังคับใช้ |
| 20 | `prev_policy_book` | character varying(50) | YES |  |  |
| 21 | `prev_policy_quotation_no` | character varying(50) | YES |  |  |
| 22 | `prev_policy_invoice_no` | character varying(50) | YES |  |  |
| 23 | `prev_sf_policy_id` | character varying(255) | YES |  |  |
| 24 | `is_cancel` | boolean | YES |  | TRUE = แจ้งยกเลิก ,FALSE = ไม่ดำเนินการยกเลิก |
| 25 | `request_endorse_no` | uuid | YES |  | เลขแจ้งสลักหลังจากแจ้งขอ Endorsement ผ่าน PWA |

**Primary key:** `id` (Policy_endorse_detail_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_ta_no` → policy_ta_premium

**Indexes:**

- `Policy_endorse_detail_copy1_pkey`: `CREATE UNIQUE INDEX "Policy_endorse_detail_copy1_pkey" ON insurverse.policy_ta_endorse_detail USING btree (id)`

---

## policy_ta_premium

`insurverse.policy_ta_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_ta_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | YES |  | เลขสลักหลัง |
| 3 | `policy_status` | character varying(50) | YES |  | ACT = active , INC = inactive |
| 4 | `lead_ta_no` | integer | NO |  | รหัส Lead TA (รายละเอียดการเลือกก่อนชำระเงิน) |
| 5 | `ta_package_id` | smallint | YES |  | รหัส TA package |
| 6 | `country_main_id` | smallint | YES |  | ประเทศเดินทางหลัก country_id |
| 7 | `country_id_array` | character varying(255) | YES |  | ประเทศเดินทางที่ระบุ กำหนดเป็น Array(counrty_id) |
| 8 | `policy_startdate` | timestamp(6) without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 9 | `policy_enddate` | timestamp(6) without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 10 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 11 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 12 | `payment_channel` | character varying(50) | YES |  |  |
| 13 | `payment_type` | character varying(50) | YES |  |  |
| 14 | `payment_no` | character varying(50) | YES |  |  |
| 15 | `payment_ref1` | character varying(50) | YES |  |  |
| 16 | `payment_ref2` | character varying(50) | YES |  |  |
| 17 | `payment_result` | character varying(50) | YES |  |  |
| 18 | `payment_date` | timestamp(6) without time zone | YES |  | วันที่ชำระเงิน |
| 19 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 20 | `create_by` | character varying(50) | YES |  |  |
| 21 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 22 | `update_by` | character varying(50) | YES |  |  |
| 23 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 24 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 25 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 26 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 27 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 28 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 29 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 30 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 31 | `policy_book` | character varying(50) | YES |  | เลข book |
| 32 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 33 | `effective_startdate` | timestamp without time zone | YES |  | วันที่เริ่มต้นมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 34 | `effective_enddate` | timestamp without time zone | YES |  | วันที่สิ้นสุดมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 35 | `policy_url_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์ต้นฉบับ |
| 36 | `policy_url_copy_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์สำเนา |
| 37 | `receipt_url_ref` | character varying(500) | YES |  | URL เอกสารใบกำกับภาษีต้นฉบับ |
| 38 | `sf_file_id_policy_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์ต้นฉบับ |
| 39 | `sf_file_id_policy_url_copy` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์สำเนา |
| 40 | `sf_file_id_receipt_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารใบกำกับภาษีต้นฉบับ |
| 41 | `iia_response_code` | character varying(255) | YES |  | IIA Response Code |
| 42 | `iia_response_last_at` | timestamp without time zone | YES |  | IIA Response Lastest Update At |
| 43 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 44 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 45 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 46 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 47 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 48 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 49 | `deli_flag` | boolean | YES |  | true = จัดส่งไปรษณีย์, false = Email |
| 50 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 51 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 52 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 53 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 54 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 55 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 56 | `promo_discount_sum` | numeric(16,4) | YES |  | ส่วนลด บาท สำหรับแสดงผลหน้าจอสรุป |
| 57 | `perm_amt_main` | numeric(16,4) | YES |  | ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจหลัก |
| 58 | `perm_amt_addon` | numeric(16,4) | YES |  | ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจเสริม |
| 59 | `partner_code` | character varying(10) | YES |  | โค้ดพาร์ทเนอร์ |
| 60 | `ta_travel_type_id` | smallint | YES | `1` | รูปแบบประกัน รายเที่ยว,รายปี |

**Primary key:** `policy_ta_no` (policy_ta_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `lead_ta_no` → lead_ta_premium, `partner_code` → mas_partner, `promo_trans_id` → promo_code_trans, `ta_package_id` → mas_ta_package, `ta_travel_type_id` → mas_ta_travel_type

**Indexes:**

- `policy_ta_premium_pkey`: `CREATE UNIQUE INDEX policy_ta_premium_pkey ON insurverse.policy_ta_premium USING btree (policy_ta_no)`

---

## policy_ta_premium_trans

`insurverse.policy_ta_premium_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `policy_ta_no` | character varying(50) | NO |  | เลขกรมธรรม์ |
| 2 | `sf_policy_id` | character varying(50) | NO |  | เลขสลักหลัง |
| 3 | `policy_status` | character varying(50) | YES |  | ACT = active , INC = inactive |
| 4 | `lead_ta_no` | integer | NO |  | รหัส Lead TA (รายละเอียดการเลือกก่อนชำระเงิน) |
| 5 | `ta_package_id` | smallint | YES |  | รหัส TA package |
| 6 | `country_main_id` | smallint | YES |  | ประเทศเดินทางหลัก country_id |
| 7 | `country_id_array` | character varying(255) | YES |  | ประเทศเดินทางที่ระบุ กำหนดเป็น Array(counrty_id) |
| 8 | `policy_startdate` | timestamp(6) without time zone | YES |  | เวลาเริ่มต้นเดินทาง/คุ้มครอง UTC+0 |
| 9 | `policy_enddate` | timestamp(6) without time zone | YES |  | เวลาสิ้นสุดเดินทาง/คุ้มครอง UTC+0 |
| 10 | `email` | character varying(255) | YES |  | Email ผู้ซื้อ sec_user |
| 11 | `payment_status` | character varying(50) | YES |  | สถานะการชำระเงิน SUCCESS = ชำระแล้ว , NULL = อื่นๆ |
| 12 | `payment_channel` | character varying(50) | YES |  |  |
| 13 | `payment_type` | character varying(50) | YES |  |  |
| 14 | `payment_no` | character varying(50) | YES |  |  |
| 15 | `payment_ref1` | character varying(50) | YES |  |  |
| 16 | `payment_ref2` | character varying(50) | YES |  |  |
| 17 | `payment_result` | character varying(50) | YES |  |  |
| 18 | `payment_date` | timestamp(6) without time zone | YES |  | วันที่ชำระเงิน |
| 19 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 20 | `create_by` | character varying(50) | YES |  |  |
| 21 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 22 | `update_by` | character varying(50) | YES |  |  |
| 23 | `promo_trans_id` | bigint | YES |  | รหัส Promo code transactions |
| 24 | `promo_discount_per` | numeric(10,4) | YES |  | ส่วนลด % จาก promo code |
| 25 | `promo_discount_amt` | numeric(16,4) | YES |  | ส่วนลด บาท จาก promo code |
| 26 | `perm_amt` | numeric(16,4) | YES |  | ราคาสุทธิกก่อนอากรและ vat |
| 27 | `duty_amt` | numeric(16,4) | YES |  | ราคาอากร |
| 28 | `vat_amt` | numeric(16,4) | YES |  | ราคา vat |
| 29 | `total_amt` | numeric(16,4) | YES |  | ราคารวมหลังอากรและ vat |
| 30 | `policy_quotation_no` | character varying(50) | YES |  | เลขใบแจ้งหนี้ |
| 31 | `policy_book` | character varying(50) | YES |  | เลข book |
| 32 | `policy_invoice_no` | character varying(50) | YES |  | เลขใบกำกับภาษี |
| 33 | `effective_startdate` | timestamp(6) without time zone | YES |  | วันที่เริ่มต้นมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 34 | `effective_enddate` | timestamp(6) without time zone | YES |  | วันที่สิ้นสุดมีผลบังคับใช้ / เท่ากับ policy_startdate จะไม่ตรงเมื่อทำการสลักหลัง |
| 35 | `policy_url_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์ต้นฉบับ |
| 36 | `policy_url_copy_ref` | character varying(500) | YES |  | URL เอกสารกรมธรรม์สำเนา |
| 37 | `receipt_url_ref` | character varying(500) | YES |  | URL เอกสารใบกำกับภาษีต้นฉบับ |
| 38 | `sf_file_id_policy_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์ต้นฉบับ |
| 39 | `sf_file_id_policy_url_copy` | character varying(50) | YES |  | Salesforce file ID URL เอกสารกรมธรรม์สำเนา |
| 40 | `sf_file_id_receipt_url` | character varying(50) | YES |  | Salesforce file ID URL เอกสารใบกำกับภาษีต้นฉบับ |
| 41 | `iia_response_code` | character varying(255) | YES |  | IIA Response Code |
| 42 | `iia_response_last_at` | timestamp(6) without time zone | YES |  | IIA Response Lastest Update At |
| 43 | `affiliate_source` | character varying(255) | YES |  | แหล่งที่มาของ Affilate |
| 44 | `affiliate_code` | character varying(255) | YES |  | โค้ด Affilate |
| 45 | `referal_source` | character varying(255) | YES |  | แหล่งที่มาของ Referal |
| 46 | `referal_code` | character varying(255) | YES |  | โค้ด Referal |
| 47 | `discount_amt` | numeric(16,4) | YES |  | ส่วนลด |
| 48 | `user_id` | character varying(36) | YES |  | รหัส sec_user |
| 49 | `deli_flag` | boolean | YES |  | true = จัดส่งไปรษณีย์, false = Email |
| 50 | `deli_address_th` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาไทย |
| 51 | `deli_address_en` | character varying(500) | YES |  | สถานที่จัดส่งกรมธรรม์ภาษาอังกฤษ |
| 52 | `deli_subdistrict_id` | integer | YES |  | รหัสแขวง/ตำบลที่อยู่จัดส่ง |
| 53 | `deli_district_id` | integer | YES |  | รหัสเขต/อำเภอที่อยู่จัดส่ง |
| 54 | `deli_province_id` | integer | YES |  | รหัสจังหวัดที่อยู่จัดส่ง |
| 55 | `deli_zipcode` | character varying(45) | YES |  | รหัสไปรษณีย์ที่อยู่จัดส่ง |
| 56 | `promo_discount_sum` | numeric(16,4) | YES |  | ส่วนลด บาท สำหรับแสดงผลหน้าจอสรุป |
| 57 | `perm_amt_main` | numeric(16,4) | YES |  | ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจหลัก |
| 58 | `perm_amt_addon` | numeric(16,4) | YES |  | ราคารวมก่อนส่วนลด อากรและ vat แพ็คเกจเสริม |
| 59 | `partner_code` | character varying(10) | YES |  | โค้ดพาร์ทเนอร์ |
| 60 | `ta_travel_type_id` | smallint | YES | `1` | รูปแบบประกัน รายเที่ยว,รายปี |

**Primary key:** `policy_ta_no,sf_policy_id` (policy_ta_premium_copy1_pkey)

**Inferred references (naming convention, NOT enforced FK):** `deli_district_id` → district, `deli_province_id` → province, `deli_subdistrict_id` → subdistrict, `lead_ta_no` → lead_ta_premium, `partner_code` → mas_partner, `policy_ta_no` → policy_ta_premium, `promo_trans_id` → promo_code_trans, `ta_package_id` → mas_ta_package, `ta_travel_type_id` → mas_ta_travel_type

**Indexes:**

- `policy_ta_premium_copy1_pkey`: `CREATE UNIQUE INDEX policy_ta_premium_copy1_pkey ON insurverse.policy_ta_premium_trans USING btree (policy_ta_no, sf_policy_id)`

---

## policy_workflow_process

`insurverse.policy_workflow_process` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `flow_process_id` | bigint | NO |  |  |
| 2 | `flow_process_type` | character varying(50) | YES |  | ประเภท workflow |
| 3 | `request_id` | character varying(50) | YES |  | เลขที่กรมธรรม์ หรือรหัสอ้างอิงอื่นๆ |
| 4 | `flow_status` | character varying(20) | YES |  | สถานะ workflow |
| 5 | `retries` | integer | YES |  | จำนวนครั้งที่พยายามทำซ้ำถ้าล้มเหลว |
| 6 | `remark` | text | YES |  | หมายเหตุ |
| 7 | `ref_1` | character varying(255) | YES |  | อ้างอิงที่ 1 |
| 8 | `ref_2` | character varying(255) | YES |  | อ้างอิงที่ 2 |
| 9 | `ref_3` | character varying(255) | YES |  | อ้างอิงที่ 3 |
| 10 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 11 | `create_by` | character varying(50) | YES |  |  |
| 12 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 13 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** `flow_process_id` (policy_workflow_process_pkey)

**Indexes:**

- `policy_workflow_process_pkey`: `CREATE UNIQUE INDEX policy_workflow_process_pkey ON insurverse.policy_workflow_process USING btree (flow_process_id)`

---

## prefix

`insurverse.prefix` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `prefix_id` | integer | NO |  |  |
| 2 | `prefix_name` | character varying | YES |  |  |

**Primary key:** _none_

---

## promo_code

`insurverse.promo_code` · kind: table · est. rows: **9,261**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_code_id` | integer | NO | `nextval('insurverse.promo_code_promo_code_id_seq'::regclass)` | รหัสโปรโมชั่น |
| 2 | `promo_code_prefix` | character varying(255) | NO |  | โค็ดโปรโมชั่นสำหรับแสดงผล หรือ Prefix code เพื่อ auto |
| 3 | `promo_group_id` | integer | NO |  | รหัสกลุ่มโปรโมชั่น |
| 4 | `promo_code_status` | character varying(3) | NO |  | ACT = ใช้งาน , INT = ปิดการทำงาน |
| 5 | `promo_code_name` | character varying(255) | NO |  | ชื่อกลุ่มโปรโมชั่น |
| 6 | `promo_code_desc` | character varying(2000) | YES |  | รายละเอียดโปรโมชั่น |
| 7 | `promo_code_type` | character varying(50) | NO |  | ประเภทโปรโมชั่น ได้แก่ mass หรือ unique |
| 8 | `number_quota` | integer | YES |  | จำนวนโปรโมชั่น |
| 9 | `number_quota_user` | integer | YES |  | จำนวนการใช้งานได้มากสุดต่อผู้ใช้งาน |
| 10 | `prem_type` | character varying(50) | YES |  | ประเภทสิทธิ์ที่ได้ ได้แก่ percent หรือ amount หรือ premium |
| 11 | `prem_value` | numeric(16,4) | YES |  | มูลค่าเมื่อเลือก prem_type เป็น percent หรือ amount |
| 12 | `prem_prod_code` | character varying(255) | YES |  | รหัสของแถมหรือคูปอง |
| 13 | `prem_prod_qty` | integer | YES |  | จำนวนของแถมหรือคูปอง |
| 14 | `promo_start_date` | timestamp without time zone | YES |  | วันที่โปรโมชั้นเริ่มแสดงผล |
| 15 | `promo_end_date` | timestamp without time zone | YES |  | วันที่โปรโมชั้นสิ้นสุดแสดงผล |
| 16 | `active_start_date` | timestamp without time zone | YES |  | วันที่โปรโมชั้นเริ่มบังคับใช้ |
| 17 | `active_end_date` | timestamp without time zone | YES |  | วันที่โปรโมชั้นสิ้นสุดบังคับใช้ |
| 18 | `promo_code_url` | character varying | YES |  | url สำหรับรูปโปรโมชั้น Thumbnail |
| 19 | `suggest_status` | character varying(3) | YES |  | ACT = ใช้งาน Suggest , INT = ปิดการทำงาน วันที่อ้างอิง promo_start_date |
| 20 | `flag_auto_code` | character varying(1) | YES |  | Y = ออกเลขอัตโนมัติ , N = กำหนดเอง |
| 21 | `auto_length` | integer | YES |  | หลักที่ต้องการ auto running no เข้ารหัส |
| 22 | `prem_prod_name` | character varying(500) | YES |  | ชื่อของแถมหรือคูปอง |
| 23 | `redeem_status` | character varying(3) | YES |  | ACT = ใช้งาน Redeem , INT = ปิดการทำงาน วันที่อ้างอิง promo_start_date |
| 24 | `redeem_point` | integer | YES |  | จำนวน point ที่ต้องใช้แลก |
| 25 | `prem_prod_desc` | character varying(500) | YES |  | รายละเอียดของแถม |
| 26 | `min_amt` | numeric(16,4) | YES |  | ราคาขั้นต่ำ |
| 27 | `cta_label_button` | character varying(255) | YES |  | CTA ชื่อปุ่มสำหรับ Redirect |
| 28 | `cta_url` | character varying | YES |  | CTA URL สำหรับ Redirect |
| 29 | `promo_banner_url` | character varying | YES |  | url สำหรับรูปโปรโมชั้น Banner |
| 30 | `term_condition_desc` | character varying(5000) | YES |  | Term & Condition |
| 31 | `priority` | smallint | YES | `0` | ลำดับการแสดงโปรโมชั่นที่หน้า Home |
| 32 | `product_group_type` | character varying(255) | YES |  | กลุ่มสินค้าเช่น motor หรือ ta |
| 33 | `product_sub_type` | character varying(255) | YES |  | สินค้าเช่น motor คือ 1,2+,3+,3,พรบ หรือ ta คือ s,m,l |
| 34 | `promo_screen_status` | character varying(3) | YES |  | ACT = แสดงผลหน้า Home และใช้ priority เพื่อ sort , INT = ปิดการทำงาน |
| 35 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 36 | `create_by` | character varying(50) | YES |  |  |
| 37 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 38 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** `promo_code_id` (promo_code_pkey)

**Inferred references (naming convention, NOT enforced FK):** `promo_group_id` → promo_group

**Indexes:**

- `promo_code_pkey`: `CREATE UNIQUE INDEX promo_code_pkey ON insurverse.promo_code USING btree (promo_code_id)`

---

## promo_code_16oct

`insurverse.promo_code_16oct` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_code_id` | integer | YES |  |  |
| 2 | `promo_code_prefix` | character varying(255) | YES |  |  |
| 3 | `promo_group_id` | integer | YES |  |  |
| 4 | `promo_code_status` | character varying(3) | YES |  |  |
| 5 | `promo_code_name` | character varying(255) | YES |  |  |
| 6 | `promo_code_desc` | character varying(2000) | YES |  |  |
| 7 | `promo_code_type` | character varying(50) | YES |  |  |
| 8 | `number_quota` | integer | YES |  |  |
| 9 | `number_quota_user` | integer | YES |  |  |
| 10 | `prem_type` | character varying(50) | YES |  |  |
| 11 | `prem_value` | numeric | YES |  |  |
| 12 | `prem_prod_code` | character varying(255) | YES |  |  |
| 13 | `prem_prod_qty` | integer | YES |  |  |
| 14 | `promo_start_date` | timestamp without time zone | YES |  |  |
| 15 | `promo_end_date` | timestamp without time zone | YES |  |  |
| 16 | `active_start_date` | timestamp without time zone | YES |  |  |
| 17 | `active_end_date` | timestamp without time zone | YES |  |  |
| 18 | `promo_code_url` | character varying | YES |  |  |
| 19 | `suggest_status` | character varying(3) | YES |  |  |
| 20 | `flag_auto_code` | character varying(1) | YES |  |  |
| 21 | `auto_length` | integer | YES |  |  |
| 22 | `prem_prod_name` | character varying(500) | YES |  |  |
| 23 | `redeem_status` | character varying(3) | YES |  |  |
| 24 | `redeem_point` | integer | YES |  |  |
| 25 | `prem_prod_desc` | character varying(500) | YES |  |  |
| 26 | `min_amt` | numeric | YES |  |  |
| 27 | `cta_label_button` | character varying(255) | YES |  |  |
| 28 | `cta_url` | character varying | YES |  |  |
| 29 | `promo_banner_url` | character varying | YES |  |  |
| 30 | `term_condition_desc` | character varying(5000) | YES |  |  |
| 31 | `priority` | smallint | YES |  |  |
| 32 | `product_group_type` | character varying(255) | YES |  |  |
| 33 | `product_sub_type` | character varying(255) | YES |  |  |
| 34 | `promo_screen_status` | character varying(3) | YES |  |  |
| 35 | `create_date` | timestamp without time zone | YES |  |  |
| 36 | `create_by` | character varying(50) | YES |  |  |
| 37 | `update_date` | timestamp without time zone | YES |  |  |
| 38 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## promo_code_26_4

`insurverse.promo_code_26_4` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_code_id` | integer | YES |  |  |
| 2 | `promo_code_prefix` | character varying(255) | YES |  |  |
| 3 | `promo_group_id` | integer | YES |  |  |
| 4 | `promo_code_status` | character varying(3) | YES |  |  |
| 5 | `promo_code_name` | character varying(255) | YES |  |  |
| 6 | `promo_code_desc` | character varying(2000) | YES |  |  |
| 7 | `promo_code_type` | character varying(50) | YES |  |  |
| 8 | `number_quota` | integer | YES |  |  |
| 9 | `number_quota_user` | integer | YES |  |  |
| 10 | `prem_type` | character varying(50) | YES |  |  |
| 11 | `prem_value` | numeric | YES |  |  |
| 12 | `prem_prod_code` | character varying(255) | YES |  |  |
| 13 | `prem_prod_qty` | integer | YES |  |  |
| 14 | `promo_start_date` | timestamp without time zone | YES |  |  |
| 15 | `promo_end_date` | timestamp without time zone | YES |  |  |
| 16 | `active_start_date` | timestamp without time zone | YES |  |  |
| 17 | `active_end_date` | timestamp without time zone | YES |  |  |
| 18 | `promo_code_url` | character varying | YES |  |  |
| 19 | `suggest_status` | character varying(3) | YES |  |  |
| 20 | `flag_auto_code` | character varying(1) | YES |  |  |
| 21 | `auto_length` | integer | YES |  |  |
| 22 | `prem_prod_name` | character varying(500) | YES |  |  |
| 23 | `redeem_status` | character varying(3) | YES |  |  |
| 24 | `redeem_point` | integer | YES |  |  |
| 25 | `prem_prod_desc` | character varying(500) | YES |  |  |
| 26 | `min_amt` | numeric | YES |  |  |
| 27 | `cta_label_button` | character varying(255) | YES |  |  |
| 28 | `cta_url` | character varying | YES |  |  |
| 29 | `promo_banner_url` | character varying | YES |  |  |
| 30 | `term_condition_desc` | character varying(5000) | YES |  |  |
| 31 | `priority` | smallint | YES |  |  |
| 32 | `product_group_type` | character varying(255) | YES |  |  |
| 33 | `product_sub_type` | character varying(255) | YES |  |  |
| 34 | `promo_screen_status` | character varying(3) | YES |  |  |
| 35 | `create_date` | timestamp without time zone | YES |  |  |
| 36 | `create_by` | character varying(50) | YES |  |  |
| 37 | `update_date` | timestamp without time zone | YES |  |  |
| 38 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## promo_code_28042025

`insurverse.promo_code_28042025` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_code_id` | integer | YES |  |  |
| 2 | `promo_code_prefix` | character varying(255) | YES |  |  |
| 3 | `promo_group_id` | integer | YES |  |  |
| 4 | `promo_code_status` | character varying(3) | YES |  |  |
| 5 | `promo_code_name` | character varying(255) | YES |  |  |
| 6 | `promo_code_desc` | character varying(2000) | YES |  |  |
| 7 | `promo_code_type` | character varying(50) | YES |  |  |
| 8 | `number_quota` | integer | YES |  |  |
| 9 | `number_quota_user` | integer | YES |  |  |
| 10 | `prem_type` | character varying(50) | YES |  |  |
| 11 | `prem_value` | numeric | YES |  |  |
| 12 | `prem_prod_code` | character varying(255) | YES |  |  |
| 13 | `prem_prod_qty` | integer | YES |  |  |
| 14 | `promo_start_date` | timestamp without time zone | YES |  |  |
| 15 | `promo_end_date` | timestamp without time zone | YES |  |  |
| 16 | `active_start_date` | timestamp without time zone | YES |  |  |
| 17 | `active_end_date` | timestamp without time zone | YES |  |  |
| 18 | `promo_code_url` | character varying | YES |  |  |
| 19 | `suggest_status` | character varying(3) | YES |  |  |
| 20 | `flag_auto_code` | character varying(1) | YES |  |  |
| 21 | `auto_length` | integer | YES |  |  |
| 22 | `prem_prod_name` | character varying(500) | YES |  |  |
| 23 | `redeem_status` | character varying(3) | YES |  |  |
| 24 | `redeem_point` | integer | YES |  |  |
| 25 | `prem_prod_desc` | character varying(500) | YES |  |  |
| 26 | `min_amt` | numeric | YES |  |  |
| 27 | `cta_label_button` | character varying(255) | YES |  |  |
| 28 | `cta_url` | character varying | YES |  |  |
| 29 | `promo_banner_url` | character varying | YES |  |  |
| 30 | `term_condition_desc` | character varying(5000) | YES |  |  |
| 31 | `priority` | smallint | YES |  |  |
| 32 | `product_group_type` | character varying(255) | YES |  |  |
| 33 | `product_sub_type` | character varying(255) | YES |  |  |
| 34 | `promo_screen_status` | character varying(3) | YES |  |  |
| 35 | `create_date` | timestamp without time zone | YES |  |  |
| 36 | `create_by` | character varying(50) | YES |  |  |
| 37 | `update_date` | timestamp without time zone | YES |  |  |
| 38 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## promo_code_30_4

`insurverse.promo_code_30_4` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_code_id` | integer | YES |  |  |
| 2 | `promo_code_prefix` | character varying(255) | YES |  |  |
| 3 | `promo_group_id` | integer | YES |  |  |
| 4 | `promo_code_status` | character varying(3) | YES |  |  |
| 5 | `promo_code_name` | character varying(255) | YES |  |  |
| 6 | `promo_code_desc` | character varying(2000) | YES |  |  |
| 7 | `promo_code_type` | character varying(50) | YES |  |  |
| 8 | `number_quota` | integer | YES |  |  |
| 9 | `number_quota_user` | integer | YES |  |  |
| 10 | `prem_type` | character varying(50) | YES |  |  |
| 11 | `prem_value` | numeric | YES |  |  |
| 12 | `prem_prod_code` | character varying(255) | YES |  |  |
| 13 | `prem_prod_qty` | integer | YES |  |  |
| 14 | `promo_start_date` | timestamp without time zone | YES |  |  |
| 15 | `promo_end_date` | timestamp without time zone | YES |  |  |
| 16 | `active_start_date` | timestamp without time zone | YES |  |  |
| 17 | `active_end_date` | timestamp without time zone | YES |  |  |
| 18 | `promo_code_url` | character varying | YES |  |  |
| 19 | `suggest_status` | character varying(3) | YES |  |  |
| 20 | `flag_auto_code` | character varying(1) | YES |  |  |
| 21 | `auto_length` | integer | YES |  |  |
| 22 | `prem_prod_name` | character varying(500) | YES |  |  |
| 23 | `redeem_status` | character varying(3) | YES |  |  |
| 24 | `redeem_point` | integer | YES |  |  |
| 25 | `prem_prod_desc` | character varying(500) | YES |  |  |
| 26 | `min_amt` | numeric | YES |  |  |
| 27 | `cta_label_button` | character varying(255) | YES |  |  |
| 28 | `cta_url` | character varying | YES |  |  |
| 29 | `promo_banner_url` | character varying | YES |  |  |
| 30 | `term_condition_desc` | character varying(5000) | YES |  |  |
| 31 | `priority` | smallint | YES |  |  |
| 32 | `product_group_type` | character varying(255) | YES |  |  |
| 33 | `product_sub_type` | character varying(255) | YES |  |  |
| 34 | `promo_screen_status` | character varying(3) | YES |  |  |
| 35 | `create_date` | timestamp without time zone | YES |  |  |
| 36 | `create_by` | character varying(50) | YES |  |  |
| 37 | `update_date` | timestamp without time zone | YES |  |  |
| 38 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## promo_code_tep

`insurverse.promo_code_tep` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_code_prefix` | character varying(255) | YES |  |  |
| 2 | `promo_group_id` | integer | YES |  |  |
| 3 | `promo_code_status` | character varying(3) | YES |  |  |
| 4 | `promo_code_name` | character varying(255) | YES |  |  |
| 5 | `promo_code_desc` | character varying(2000) | YES |  |  |
| 6 | `promo_code_type` | character varying(50) | YES |  |  |
| 7 | `number_quota` | integer | YES |  |  |
| 8 | `number_quota_user` | integer | YES |  |  |
| 9 | `prem_type` | character varying(50) | YES |  |  |
| 10 | `prem_value` | numeric | YES |  |  |
| 11 | `prem_prod_code` | character varying(255) | YES |  |  |
| 12 | `prem_prod_qty` | integer | YES |  |  |
| 13 | `promo_start_date` | timestamp without time zone | YES |  |  |
| 14 | `promo_end_date` | timestamp without time zone | YES |  |  |
| 15 | `active_start_date` | timestamp without time zone | YES |  |  |
| 16 | `active_end_date` | timestamp without time zone | YES |  |  |
| 17 | `promo_code_url` | character varying | YES |  |  |
| 18 | `suggest_status` | character varying(3) | YES |  |  |
| 19 | `flag_auto_code` | character varying(1) | YES |  |  |
| 20 | `auto_length` | integer | YES |  |  |
| 21 | `prem_prod_name` | character varying(500) | YES |  |  |
| 22 | `redeem_status` | character varying(3) | YES |  |  |
| 23 | `redeem_point` | integer | YES |  |  |
| 24 | `prem_prod_desc` | character varying(500) | YES |  |  |
| 25 | `min_amt` | numeric | YES |  |  |
| 26 | `cta_label_button` | character varying(255) | YES |  |  |
| 27 | `cta_url` | character varying | YES |  |  |
| 28 | `promo_banner_url` | character varying | YES |  |  |
| 29 | `term_condition_desc` | character varying(5000) | YES |  |  |
| 30 | `priority` | smallint | YES |  |  |
| 31 | `product_group_type` | character varying(255) | YES |  |  |
| 32 | `product_sub_type` | character varying(255) | YES |  |  |
| 33 | `promo_screen_status` | character varying(3) | YES |  |  |
| 34 | `create_date` | timestamp without time zone | YES |  |  |
| 35 | `create_by` | character varying(50) | YES |  |  |
| 36 | `update_date` | timestamp without time zone | YES |  |  |
| 37 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** _none_

---

## promo_code_trans

`insurverse.promo_code_trans` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_trans_id` | bigint | NO |  | รหัสธุรกรรมโปรโมชั่น |
| 2 | `promo_code_id` | integer | NO |  | รหัสโปรโมชั่น |
| 3 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 4 | `create_by` | character varying(50) | YES |  |  |
| 5 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 6 | `update_by` | character varying(50) | YES |  |  |
| 7 | `seq_id` | integer | YES |  | ลำดับธุรกรรมโปรโมชั่น |
| 8 | `promo_code` | character varying(255) | YES |  | โค็ดโปรโมชั่น |
| 9 | `promo_trans_status` | character varying(3) | YES |  | ACT = ใช้งาน , INT = ปิดการทำงาน |
| 10 | `promo_book_by` | character varying(255) | YES |  | email ที่จองโค็ดไว้ |
| 11 | `promo_book_at` | timestamp without time zone | YES |  | เวลาที่จอง |
| 12 | `promo_active_by` | character varying(255) | YES |  | email ที่ใช้งานโค็ด |
| 13 | `promo_active_at` | timestamp without time zone | YES |  | เวลาที่ใช้งานโค็ด |

**Primary key:** `promo_trans_id` (promo_code_trans_pkey)

**Inferred references (naming convention, NOT enforced FK):** `promo_code_id` → promo_code

**Indexes:**

- `promo_code_trans_pkey`: `CREATE UNIQUE INDEX promo_code_trans_pkey ON insurverse.promo_code_trans USING btree (promo_trans_id)`

---

## promo_condition

`insurverse.promo_condition` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_condition_id` | integer | NO |  | รหัสเงื่อนไขโปรโมชั่น |
| 2 | `promo_code_id` | integer | YES |  | รหัสโปรโมชั่น |
| 3 | `seq_id` | integer | YES |  | ลำดับเงื่อนไข |
| 4 | `condition_prefix` | character varying(50) | YES |  | เงื่อนไขเชื่อมเช่น OR หรือ AND |
| 5 | `condition_field` | character varying(255) | YES |  | ชื่อ Field |
| 6 | `condition_sign` | character varying(10) | YES |  | สัญลักษณ์เงื่อนไขเช่น > < = like |
| 7 | `condition_value_prefix` | character varying(50) | YES |  | คำนำหน้า value |
| 8 | `condition_value` | character varying(255) | YES |  | value |
| 9 | `condition_value_suffix` | character varying(50) | YES |  | คำต่อท้าย value |
| 10 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 11 | `create_by` | character varying(50) | YES |  |  |
| 12 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 13 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** `promo_condition_id` (promo_condition_pkey)

**Inferred references (naming convention, NOT enforced FK):** `promo_code_id` → promo_code

**Indexes:**

- `promo_condition_pkey`: `CREATE UNIQUE INDEX promo_condition_pkey ON insurverse.promo_condition USING btree (promo_condition_id)`

---

## promo_group

`insurverse.promo_group` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `promo_group_id` | integer | NO |  | รหัสกลุ่มโปรโมชั่น |
| 2 | `promo_group_name` | character varying(255) | NO |  | ชื่อกลุ่มโปรโมชั่น |
| 3 | `promo_group_desc` | character varying(2000) | YES |  | รายละเอียดกลุ่มโปรโมชั่น |
| 4 | `promo_group_status` | character varying(3) | NO |  | ACT = ใช้งาน , INT = ปิดการทำงาน |
| 5 | `term_condition_desc` | character varying(5000) | YES |  | Term & Condition |
| 6 | `picture_banner_url` | character varying(500) | YES |  | ตำแหน่งเก็บรูป |
| 7 | `promo_group_url` | character varying(500) | YES |  | url สำหรับเข้าดูกลุ่มโปรโมชั้นเพิ่มเติม |
| 8 | `promo_group_code` | character varying(255) | YES |  | โค็ดโปรโมชั่นสำหรับแสดงผล |
| 9 | `promo_start_date` | timestamp without time zone | YES |  | วันที่กลุ่มโปรโมชั้นเริ่มแสดงผล |
| 10 | `promo_end_date` | timestamp without time zone | YES |  | วันที่กลุ่มโปรโมชั้นสิ้นสุดแสดงผล |
| 11 | `active_start_date` | timestamp without time zone | YES |  | วันที่กลุ่มโปรโมชั้นเริ่มบังคับใช้ |
| 12 | `active_end_date` | timestamp without time zone | YES |  | วันที่กลุ่มโปรโมชั้นสิ้นสุดบังคับใช้ |
| 13 | `create_date` | timestamp(6) without time zone | YES | `now()` |  |
| 14 | `create_by` | character varying(50) | YES |  |  |
| 15 | `update_date` | timestamp(6) without time zone | YES | `now()` |  |
| 16 | `update_by` | character varying(50) | YES |  |  |

**Primary key:** `promo_group_id` (promo_group_pkey)

**Indexes:**

- `promo_group_pkey`: `CREATE UNIQUE INDEX promo_group_pkey ON insurverse.promo_group USING btree (promo_group_id)`

---

## province

`insurverse.province` · kind: table · est. rows: **78**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `provinceid` | integer | NO | `nextval('insurverse.province_provinceid_seq'::regclass)` |  |
| 2 | `prcountry` | integer | YES |  |  |
| 3 | `prcode` | character(2) | YES |  |  |
| 4 | `prname` | character varying | YES |  |  |
| 5 | `prnameen` | character varying(150) | YES |  |  |

**Primary key:** `provinceid` (province_pkey)

**Indexes:**

- `province_pkey`: `CREATE UNIQUE INDEX province_pkey ON insurverse.province USING btree (provinceid)`

---

## province_12sep67

`insurverse.province_12sep67` · kind: table · est. rows: **78** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `provinceid` | integer | YES |  |  |
| 2 | `prcountry` | integer | YES |  |  |
| 3 | `prcode` | bpchar | YES |  |  |
| 4 | `prname` | character varying | YES |  |  |
| 5 | `prnameen` | character varying(150) | YES |  |  |

**Primary key:** _none_

---

## province_add

`insurverse.province_add` · kind: table · est. rows: **156** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `provinceid` | integer | YES |  |  |
| 2 | `prcountry` | integer | YES |  |  |
| 3 | `prcode` | bpchar | YES |  |  |
| 4 | `prname` | character varying | YES |  |  |
| 5 | `prnameen` | character varying(150) | YES |  |  |

**Primary key:** _none_

---

## reconcile

`insurverse.reconcile` · kind: table · est. rows: **1,241**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `batch_job_id` | bigint | YES |  |  |
| 3 | `type` | character varying(20) | YES |  |  |
| 4 | `request_type` | character varying(20) | YES |  |  |
| 5 | `policy_no` | character varying(50) | YES |  |  |
| 6 | `sf_policy_no` | character varying(255) | YES |  |  |
| 7 | `claim_no` | character varying(50) | YES |  |  |
| 8 | `pwa_status` | character varying(20) | YES |  |  |
| 9 | `sf_status` | character varying(20) | YES |  |  |
| 10 | `log_iia_policy` | character varying(20) | YES |  |  |
| 11 | `log_iia_policy_error_message` | text | YES |  |  |
| 12 | `iia_status` | character varying(20) | YES |  |  |
| 13 | `iia_error_message` | text | YES |  |  |
| 14 | `iia_final_status` | character varying(20) | YES |  |  |
| 15 | `reconcile_status` | character varying(20) | YES |  |  |
| 16 | `unmatched_reason` | text | YES |  |  |
| 17 | `created_at` | timestamp with time zone | YES |  |  |
| 18 | `updated_at` | timestamp with time zone | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

---

## renew_policy_batches

`insurverse.renew_policy_batches` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | YES |  |  |
| 2 | `original_file_name` | text | YES |  |  |
| 3 | `stored_file_path` | text | YES |  |  |
| 4 | `total_records` | integer | YES |  |  |
| 5 | `success_count` | integer | YES |  |  |
| 6 | `failure_count` | integer | YES |  |  |
| 7 | `status` | character varying(32) | YES |  |  |
| 8 | `requested_by` | text | YES |  |  |
| 9 | `notify_email` | text | YES |  |  |
| 10 | `error_message` | text | YES |  |  |
| 11 | `created_at` | timestamp without time zone | YES |  |  |
| 12 | `updated_at` | timestamp without time zone | YES |  |  |
| 13 | `completed_at` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

---

## renew_policy_records

`insurverse.renew_policy_records` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `batch_id` | uuid | YES |  |  |
| 3 | `policy_no` | character varying(64) | YES |  |  |
| 4 | `policy_type` | character varying(16) | YES |  |  |
| 5 | `mc_policy_no` | character varying(64) | YES |  |  |
| 6 | `policy_enddate` | date | YES |  |  |
| 7 | `owner_name` | text | YES |  |  |
| 8 | `owner_phone` | character varying(32) | YES |  |  |
| 9 | `user_phone` | character varying(32) | YES |  |  |
| 10 | `lead_phone` | character varying(32) | YES |  |  |
| 11 | `car_license` | character varying(32) | YES |  |  |
| 12 | `car_province` | character varying(128) | YES |  |  |
| 13 | `email` | text | YES |  |  |
| 14 | `promo_code_old` | text | YES |  |  |
| 15 | `promo_code_percent_old` | numeric(5,2) | YES |  |  |
| 16 | `car_serial_no` | character varying(64) | YES |  |  |
| 17 | `claim_count` | integer | YES |  |  |
| 18 | `claim_total_amount` | numeric(14,2) | YES |  |  |
| 19 | `premium_amount` | numeric(14,2) | YES |  |  |
| 20 | `card_renew_premium` | numeric(14,2) | YES |  |  |
| 21 | `renew_premium` | numeric(14,2) | YES |  |  |
| 22 | `renew_discount_percent` | numeric(5,2) | YES |  |  |
| 23 | `renew_discount_code` | character varying(32) | YES |  |  |
| 24 | `lead_no` | character varying(128) | YES |  |  |
| 25 | `encrypted_lead_no` | character varying(256) | YES |  |  |
| 26 | `summary_url` | text | YES |  |  |
| 27 | `summary_short_url` | text | YES |  |  |
| 28 | `payment_url` | text | YES |  |  |
| 29 | `payment_short_url` | text | YES |  |  |
| 30 | `payment_invoice_no` | character varying(64) | YES |  |  |
| 31 | `payment_token` | text | YES |  |  |
| 32 | `payment_method` | character varying(32) | YES |  |  |
| 33 | `payment_amount` | numeric(14,2) | YES |  |  |
| 34 | `status` | character varying(32) | YES |  |  |
| 35 | `error_message` | text | YES |  |  |
| 36 | `raw_response` | jsonb | YES |  |  |
| 37 | `created_at` | timestamp without time zone | YES |  |  |
| 38 | `updated_at` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

**Inferred references (naming convention, NOT enforced FK):** `lead_no` → Lead_coverage_premium, `policy_no` → Policy_Header

---

## renew_promocode_percent

`insurverse.renew_promocode_percent` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `code` | character varying(32) | YES |  |  |
| 3 | `discount_percent` | numeric(5,2) | YES |  |  |
| 4 | `min_total_amount` | numeric(14,2) | YES |  |  |
| 5 | `max_total_amount` | numeric(14,2) | YES |  |  |
| 6 | `is_active` | boolean | YES |  |  |
| 7 | `created_at` | timestamp without time zone | YES |  |  |
| 8 | `updated_at` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

---

## renewal_notification

`insurverse.renewal_notification` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `policy_scope` | character varying(20) | NO |  |  |
| 3 | `mc_no` | character varying(50) | YES |  |  |
| 4 | `mv_no` | character varying(50) | YES |  |  |
| 5 | `channel` | character varying(10) | NO |  |  |
| 6 | `value` | character varying(255) | YES |  |  |
| 7 | `days_left` | smallint | NO |  |  |
| 8 | `template_ref` | character varying(100) | NO |  |  |
| 9 | `template_payload` | jsonb | NO |  |  |
| 10 | `policy_enddate` | date | NO |  |  |
| 11 | `send_date` | date | NO |  |  |
| 12 | `status` | character varying(20) | NO | `'PENDING'::character varying` |  |
| 13 | `error_description` | text | YES |  |  |
| 14 | `message_id` | character varying(255) | YES |  |  |
| 15 | `created_at` | timestamp with time zone | NO | `now()` |  |
| 16 | `updated_at` | timestamp with time zone | NO | `now()` |  |

**Primary key:** `id` (renewal_notification_pkey)

**Indexes:**

- `idx_renewal_notification_message_id`: `CREATE INDEX idx_renewal_notification_message_id ON insurverse.renewal_notification USING btree (message_id)`
- `idx_renewal_notification_send_date`: `CREATE INDEX idx_renewal_notification_send_date ON insurverse.renewal_notification USING btree (send_date)`
- `idx_renewal_notification_status`: `CREATE INDEX idx_renewal_notification_status ON insurverse.renewal_notification USING btree (status)`
- `renewal_notification_pkey`: `CREATE UNIQUE INDEX renewal_notification_pkey ON insurverse.renewal_notification USING btree (id)`
- `renewal_notification_unique`: `CREATE UNIQUE INDEX renewal_notification_unique ON insurverse.renewal_notification USING btree (COALESCE(mc_no, ''::character varying), COALESCE(mv_no, ''::character varying), channel, days_left, policy_enddate) WHERE ((status)::text <> 'FAILED'::text)`

---

## renewal_payments

`insurverse.renewal_payments` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.renewal_payments_id_seq'::regclass)` |  |
| 2 | `ref_policy_no` | character varying(255) | NO |  |  |
| 3 | `payment_2c2p_url` | text | NO |  |  |
| 4 | `invoice` | character varying(255) | YES |  |  |
| 5 | `created_at` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 6 | `user_add` | character varying(255) | NO |  |  |

**Primary key:** `id` (renewal_payments_pkey)

**Inferred references (naming convention, NOT enforced FK):** `ref_policy_no` → Policy_Header

**Constraints:**

- UNIQUE `renewal_payments_ref_policy_no_key`: `UNIQUE (ref_policy_no)`

**Indexes:**

- `renewal_payments_pkey`: `CREATE UNIQUE INDEX renewal_payments_pkey ON insurverse.renewal_payments USING btree (id)`
- `renewal_payments_ref_policy_no_key`: `CREATE UNIQUE INDEX renewal_payments_ref_policy_no_key ON insurverse.renewal_payments USING btree (ref_policy_no)`

---

## renewal_template

`insurverse.renewal_template` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `notification_type` | character varying(30) | NO |  |  |
| 3 | `channel` | character varying(10) | NO |  |  |
| 4 | `policy_scope` | character varying(20) | NO |  |  |
| 5 | `days_left` | smallint | NO |  |  |
| 6 | `template_name` | character varying(100) | NO |  |  |
| 7 | `template_code` | character varying(100) | YES |  |  |
| 8 | `subject` | text | YES |  |  |
| 9 | `body` | text | YES |  |  |
| 10 | `placeholders` | text[] | NO | `'{}'::text[]` |  |
| 11 | `is_active` | boolean | NO | `true` |  |
| 12 | `created_at` | timestamp with time zone | NO | `now()` |  |
| 13 | `updated_at` | timestamp with time zone | NO | `now()` |  |

**Primary key:** `id` (renewal_template_pkey)

**Indexes:**

- `renewal_template_pkey`: `CREATE UNIQUE INDEX renewal_template_pkey ON insurverse.renewal_template USING btree (id)`

---

## request_contact

`insurverse.request_contact` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `firstname` | character varying(100) | YES |  |  |
| 3 | `surname` | character varying(100) | YES |  |  |
| 4 | `email` | character varying(100) | YES |  |  |
| 5 | `contact_number` | character varying(20) | YES |  |  |
| 6 | `contact_time_pre` | character varying(50) | YES |  |  |
| 7 | `requested_from` | character varying(50) | YES |  |  |
| 8 | `date_created` | timestamp without time zone | YES |  |  |

**Primary key:** `id` (request_contact_pk)

**Indexes:**

- `request_contact_pk`: `CREATE UNIQUE INDEX request_contact_pk ON insurverse.request_contact USING btree (id)`

---

## reset_password

`insurverse.reset_password` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `user_id` | character varying(36) | YES |  |  |
| 2 | `reference_id` | character varying | YES |  |  |
| 3 | `consumed` | boolean | YES | `false` |  |
| 4 | `expired_at` | timestamp without time zone | YES |  |  |
| 5 | `created_at` | timestamp without time zone | YES |  |  |
| 6 | `type` | character varying | YES |  |  |
| 7 | `email` | character varying | YES |  |  |
| 8 | `phone` | character varying | YES |  |  |
| 9 | `updated_at` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

---

## rtn_json

`insurverse.rtn_json` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `json_body` | json | YES |  |  |

**Primary key:** _none_

---

## running_book_invoice

`insurverse.running_book_invoice` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `book` | character varying(50) | YES |  |  |
| 3 | `invoice_no` | character varying(50) | YES |  |  |
| 4 | `update_date` | timestamp without time zone | YES |  |  |
| 5 | `ref_key` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## running_quotation

`insurverse.running_quotation` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `quotation_no` | character varying(50) | YES |  |  |
| 3 | `update_date` | timestamp without time zone | YES |  |  |
| 4 | `ref_key` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## running_receipt

`insurverse.running_receipt` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | YES |  |  |
| 2 | `receipt_no` | character varying(50) | YES |  |  |
| 3 | `update_date` | timestamp without time zone | YES |  |  |
| 4 | `ref_key` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## sec_group

`insurverse.sec_group` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `group_code` | character varying(50) | NO |  | รหัสกลุ่มผู้ใช้งาน |
| 2 | `group_name` | character varying(50) | YES |  | ชื่อกลุ่มผู้ใช้งาน admin superuser user |
| 3 | `group_desc` | character varying(500) | YES |  | รายละเอียดของกลุ่ม |
| 4 | `group_status` | character varying(50) | YES |  | สถานะกลุ่ม |
| 5 | `create_date` | timestamp without time zone | YES |  |  |
| 6 | `create_user` | character varying(50) | YES |  |  |
| 7 | `update_date` | timestamp without time zone | YES |  |  |
| 8 | `update_user` | character varying(50) | YES |  |  |

**Primary key:** `group_code` (sec_group_pkey)

**Indexes:**

- `sec_group_pkey`: `CREATE UNIQUE INDEX sec_group_pkey ON insurverse.sec_group USING btree (group_code)`

---

## sec_group_menu

`insurverse.sec_group_menu` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `group_code` | character varying(50) | NO |  | รหัสกลุ่ม |
| 2 | `menu_id` | integer | NO |  | รหัสเมนู |
| 3 | `create_date` | timestamp without time zone | YES |  |  |
| 4 | `create_user` | character varying(50) | YES |  |  |
| 5 | `update_date` | timestamp without time zone | YES |  |  |
| 6 | `update_user` | character varying(50) | YES |  |  |

**Primary key:** `group_code,menu_id` (sec_group_menu_pkey)

**Inferred references (naming convention, NOT enforced FK):** `group_code` → sec_group, `menu_id` → sec_menu

**Indexes:**

- `sec_group_menu_pkey`: `CREATE UNIQUE INDEX sec_group_menu_pkey ON insurverse.sec_group_menu USING btree (group_code, menu_id)`

---

## sec_group_user

`insurverse.sec_group_user` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `group_code` | character varying(50) | NO |  | รหัสกลุ่ม |
| 2 | `user_id` | integer | NO |  | รหัสผู้ใช้งาน |
| 3 | `create_date` | timestamp without time zone | YES |  |  |
| 4 | `create_user` | character varying(50) | YES |  |  |
| 5 | `update_date` | timestamp without time zone | YES |  |  |
| 6 | `update_user` | character varying(50) | YES |  |  |

**Primary key:** `group_code,user_id` (sec_group_user_pkey)

**Inferred references (naming convention, NOT enforced FK):** `group_code` → sec_group

**Indexes:**

- `sec_group_user_pkey`: `CREATE UNIQUE INDEX sec_group_user_pkey ON insurverse.sec_group_user USING btree (group_code, user_id)`

---

## sec_menu

`insurverse.sec_menu` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `menu_id` | integer | NO |  | รหัสเมนู |
| 2 | `menu_type` | character varying(50) | YES |  | ประเภทของเมนู (Optional) |
| 3 | `menu_name` | character varying(50) | YES |  | ชื่อเมนู(display) |
| 4 | `menu_desc` | character varying(500) | YES |  | รายละเอียด |
| 5 | `menu_status` | character varying(50) | YES |  | สถานะ ATV, INA |
| 6 | `menu_icon` | character varying(50) | YES |  | รูป icon |
| 7 | `sequences` | double precision | YES |  | ลำดับการแสดงผล |
| 8 | `create_date` | timestamp without time zone | YES |  |  |
| 9 | `create_user` | character varying(50) | YES |  |  |
| 10 | `update_date` | timestamp without time zone | YES |  |  |
| 11 | `update_user` | character varying(50) | YES |  |  |

**Primary key:** `menu_id` (sec_menu_pkey)

**Indexes:**

- `sec_menu_pkey`: `CREATE UNIQUE INDEX sec_menu_pkey ON insurverse.sec_menu USING btree (menu_id)`

---

## sec_menu_scr

`insurverse.sec_menu_scr` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `menu_scr_id` | integer | NO |  | รหัส เมนู+หน้าจอ |
| 2 | `menu_id` | integer | NO |  | รหัส เมนู |
| 3 | `scr_id` | integer | NO |  | รหัส หน้าจอ |
| 4 | `menu_scr_status` | character varying(50) | YES |  | สถานะ |
| 5 | `create_date` | timestamp without time zone | YES |  |  |
| 6 | `create_user` | character varying(50) | YES |  |  |
| 7 | `update_date` | timestamp without time zone | YES |  |  |
| 8 | `update_user` | character varying(50) | YES |  |  |

**Primary key:** `menu_scr_id,menu_id,scr_id` (sec_menu_scr_pkey)

**Inferred references (naming convention, NOT enforced FK):** `menu_id` → sec_menu, `scr_id` → sec_screen

**Indexes:**

- `sec_menu_scr_pkey`: `CREATE UNIQUE INDEX sec_menu_scr_pkey ON insurverse.sec_menu_scr USING btree (menu_scr_id, menu_id, scr_id)`

---

## sec_screen

`insurverse.sec_screen` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `scr_id` | integer | NO |  | รหัสหน้าจอ |
| 2 | `scr_type` | character varying(50) | YES |  | ประเภทหน้าจอ |
| 3 | `scr_name` | character varying(50) | YES |  | ชื่อหน้าจอ |
| 4 | `scr_desc` | character varying(500) | YES |  | รายละเอียดการทำงาน |
| 5 | `scr_status` | character varying(50) | YES |  | สถานะการใช้งาน ATV, INA |
| 6 | `scr_path` | character varying(200) | YES |  | URL, Internal link |
| 7 | `scr_icon` | character varying(50) | YES |  | Icon ของหน้า |
| 8 | `sequences` | double precision | YES |  | ลำดับหน้าจอ (Optional) |
| 9 | `create_date` | timestamp without time zone | YES |  |  |
| 10 | `create_user` | character varying(50) | YES |  |  |
| 11 | `update_date` | timestamp without time zone | YES |  |  |
| 12 | `update_user` | character varying(50) | YES |  |  |

**Primary key:** `scr_id` (sec_screen_pkey)

**Indexes:**

- `sec_screen_pkey`: `CREATE UNIQUE INDEX sec_screen_pkey ON insurverse.sec_screen USING btree (scr_id)`

---

## sec_user

`insurverse.sec_user` · kind: table · est. rows: **3**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `user_id` | character varying(36) | NO |  | รหัสผู้ใช้งาน |
| 2 | `username` | character varying(50) | YES |  |  |
| 3 | `hashpassword` | text | NO |  | password ที่เข้ารหัสแล้ว |
| 4 | `name` | character varying(100) | YES |  |  |
| 5 | `mid_name` | character varying(50) | YES |  |  |
| 6 | `last_name` | character varying(100) | YES |  |  |
| 7 | `email` | character varying(500) | NO |  | Login เข้าระบบ |
| 8 | `reset_status` | integer | YES |  |  |
| 9 | `identification_no` | character varying(50) | YES |  |  |
| 10 | `identity_type` | character varying(50) | YES |  |  |
| 11 | `isonline` | character varying(50) | YES |  |  |
| 12 | `user_type` | character varying(50) | YES |  |  |
| 13 | `accesskey` | character varying(100) | YES |  |  |
| 14 | `user_status` | character varying(50) | YES |  |  |
| 15 | `create_date` | timestamp without time zone | YES |  |  |
| 16 | `create_user` | character varying(50) | YES |  |  |
| 17 | `update_date` | timestamp without time zone | YES |  |  |
| 18 | `update_user` | character varying(50) | YES |  |  |
| 19 | `mobile` | character varying(50) | YES |  | Mobile |
| 20 | `email_verified` | boolean | YES | `false` | t = ยืนยัน email แล้ว , f = ยังไม่ยืนยัน email |
| 21 | `active` | boolean | YES | `false` | ตรวจสอบว่า account ถูกเปิดใช้งานแล้ว  |
| 22 | `mobile_verified` | boolean | YES | `false` | 1 = ยืนยัน mobile แล้ว ,0 = ยังไม่ยืนยัน mobile |
| 23 | `last_login` | timestamp without time zone | YES |  | login ครั้งสุดท้ายเมื่อ |
| 24 | `phone_verified` | boolean | YES | `false` |  |
| 25 | `token` | character varying | YES |  |  |
| 26 | `prefix_name` | character varying | YES |  | คำนำหน้าชื่อ |
| 27 | `user_dob` | date | YES |  | วันเดือนปีเกิด |
| 28 | `sf_account` | character varying(50) | YES |  | accountId Salesforce  |
| 29 | `sf_lead` | character varying(50) | YES |  | leadId Salesforce |
| 30 | `citizen_id` | character varying(20) | YES |  | รหัสบัตรประชาชน |
| 31 | `address` | character varying(30) | YES |  |  |
| 32 | `province_id` | integer | YES |  |  |
| 33 | `subdistrict_id` | integer | YES |  |  |
| 34 | `district_id` | integer | YES |  |  |
| 35 | `zipcode` | character varying(45) | YES |  |  |
| 36 | `countryid` | integer | YES |  |  |
| 37 | `language` | character varying(50) | YES | `'th-th'::character varying` | th-th,en-us |
| 38 | `occupation` | character varying(255) | YES |  | อาชีพ |
| 39 | `occupation_code` | character varying(50) | YES |  | รหัส อาชีพ |

**Primary key:** `email` (sec_user_pkey)

**Inferred references (naming convention, NOT enforced FK):** `countryid` → mas_country, `district_id` → district, `province_id` → province, `subdistrict_id` → subdistrict

**Indexes:**

- `idx_sec_user_email_unique`: `CREATE UNIQUE INDEX idx_sec_user_email_unique ON insurverse.sec_user USING btree (lower((email)::text))`
- `sec_user_pkey`: `CREATE UNIQUE INDEX sec_user_pkey ON insurverse.sec_user USING btree (email)`

---

## sec_user_sso

`insurverse.sec_user_sso` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `user_id` | character varying(36) | NO |  | รหัสผู้ใช้งาน |
| 2 | `create_at` | timestamp without time zone | YES | `now()` |  |
| 3 | `sso_type` | character varying(50) | NO |  | facebook, google, apple |
| 4 | `uid` | character varying(50) | YES |  |  |
| 5 | `prefix_name` | character varying | YES |  | คำนำหน้าชื่อ |
| 6 | `name` | character varying(100) | YES |  |  |
| 7 | `mid_name` | character varying(50) | YES |  |  |
| 8 | `last_name` | character varying(100) | YES |  |  |
| 9 | `email` | character varying(500) | YES |  | Login เข้าระบบ |
| 10 | `mobile` | character varying(50) | YES |  | Mobile |
| 11 | `user_dob` | date | YES |  | วันเดือนปีเกิด |
| 12 | `citizen_id` | character varying(20) | YES |  | รหัสบัตรประชาชน |
| 13 | `address` | character varying(30) | YES |  |  |
| 14 | `province_id` | integer | YES |  |  |
| 15 | `subdistrict_id` | integer | YES |  |  |
| 16 | `district_id` | integer | YES |  |  |
| 17 | `zipcode` | character varying(45) | YES |  |  |
| 18 | `countryid` | integer | YES |  |  |
| 19 | `remark` | text | YES |  |  |
| 20 | `user_info` | text | YES |  |  |
| 21 | `token` | text | YES |  |  |
| 22 | `is_active` | boolean | YES | `true` |  |

**Primary key:** `user_id,sso_type` (sec_user_sso_pkey)

**Inferred references (naming convention, NOT enforced FK):** `countryid` → mas_country, `district_id` → district, `province_id` → province, `subdistrict_id` → subdistrict

**Indexes:**

- `sec_user_sso_pkey`: `CREATE UNIQUE INDEX sec_user_sso_pkey ON insurverse.sec_user_sso USING btree (user_id, sso_type)`

---

## sf_business_hour

`insurverse.sf_business_hour` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `start_time` | time without time zone | YES |  |  |
| 3 | `end_time` | time without time zone | YES |  |  |
| 4 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 5 | `create_by` | character varying(50) | YES |  |  |
| 6 | `update_date` | timestamp without time zone | YES | `now()` |  |
| 7 | `update_by` | character varying(50) | YES |  |  |
| 8 | `is_active` | boolean | YES | `true` |  |
| 9 | `message_th` | text | YES |  |  |
| 10 | `message_en` | text | YES |  |  |

**Primary key:** `id` (sf_business_hour_pkey)

**Indexes:**

- `sf_business_hour_pkey`: `CREATE UNIQUE INDEX sf_business_hour_pkey ON insurverse.sf_business_hour USING btree (id)`

---

## sf_claim

`insurverse.sf_claim` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `survey_report_id` | bigint | NO |  | transaction id |
| 2 | `ref_notify_no` | character varying(20) | NO |  | เลขรับแจ้ง |
| 3 | `ref_claim_no` | character varying(20) | NO |  | เลขที่เคลม |
| 4 | `accident_date` | timestamp without time zone | YES |  | เวลาที่เกิดเหตุ |
| 5 | `accident_place` | character varying(255) | YES |  | สถานที่เกิดเหตุ |
| 6 | `accident_district` | character varying(50) | YES |  | อำเภอเกิดเหตุ |
| 7 | `accident_province` | character varying(50) | YES |  | จังหวัดเกิดเหตุ |
| 8 | `accident_type` | character varying(200) | YES |  | ลักษณะการเกิดเหตุ |
| 9 | `accident_detail` | character varying(255) | YES |  | ข้อมูลการเกิดเหตุ |
| 10 | `accident_cause` | bigint | YES |  | ผลคดี |
| 11 | `accident_call` | character varying(255) | YES |  | ผู้แจ้ง |
| 12 | `accident_call_date` | timestamp without time zone | YES |  | วันที่รับแจ้ง |
| 13 | `accident_assign` | timestamp without time zone | YES |  | วันที่จ่ายงาน |
| 14 | `accident_reach` | timestamp without time zone | YES |  | ถึงที่เกิดเหตุเวลา |
| 15 | `accident_finish` | timestamp without time zone | YES |  | วันที่สำรวจภัยเสร็จ |
| 16 | `police_name` | character varying(255) | YES |  | ชื่อพนักงานสอบสวน |
| 17 | `police_station` | character varying(255) | YES |  | สถานีตำรวจ |
| 18 | `police_comment` | character varying(255) | YES |  | ความคิดเห็นพนักงานสอบสวน |
| 19 | `police_date` | timestamp without time zone | YES |  | วันที่สอบสวน |
| 20 | `book_number` | character varying(255) | YES |  | ประจำวันข้อที่ |
| 21 | `surveyor_name` | character varying(255) | YES |  | ชื่อบริษัทเซอร์เวย์. (DP) |
| 22 | `accident_surveyor` | character varying(255) | YES |  | ผู้ตรวจสอบ (ชื่อพนักงานสำรวจ) |
| 23 | `surveyor_comment` | text | YES |  | ความเห็นรวมของเซอร์เวย์ |
| 24 | `survey_date` | timestamp without time zone | YES |  | วันที่ส่งรายงาน |
| 25 | `remark` | character varying(255) | YES |  | หมายเหตุ |
| 26 | `car_detail` | character varying(32000) | YES |  | รายการรถที่เกิดเหตุ |
| 27 | `injured` | character varying(32000) | YES |  | ผู้บาดเจ็บ/เสียชีวิต |
| 28 | `asset` | character varying(32000) | YES |  | ทรัพย์สิน |
| 29 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 30 | `create_by` | character varying(50) | YES |  |  |
| 31 | `update_date` | timestamp without time zone | YES |  |  |
| 32 | `update_by` | character varying(50) | YES |  |  |
| 33 | `add_on` | numeric(6,0) | YES |  | ครั้งที่การเปิดใบค่าใช้จ่าย (จำนวนรอบ) |
| 34 | `survey_id` | numeric(6,0) | YES |  | หมายเลขบริษัทเซอร์เวย์. (Fix: 9999) |
| 35 | `survey_br_id` | numeric(6,0) | YES |  | หมายเลขสาขาบริษัทเซอร์เวย์ (Fix: 9999) |
| 36 | `pos_status` | numeric(6,0) | YES |  | สถานะของใบเซอร์เวย์ ณ ปัจจุบัน 2 สถานะ 0=Surveyer ปิดงาน ณ สถานที่เกิดเหตุ , 3=เจ้าหน้าที่สินไหมอนุมัติแล้ว |
| 37 | `prb_number` | character varying(30) | YES |  | กรมธรรม์(พรบ.) |
| 38 | `acc_policy_no` | character varying(30) | YES |  | กรมธรรม์เลขที่ |
| 39 | `assured_name` | character varying(200) | YES |  | ผู้เอาประกันภัย |
| 40 | `policy_type` | character varying(150) | YES |  | ประกันประเภท |
| 41 | `policy_start` | timestamp without time zone | YES |  | วันที่เริ่มต้นกรมธรรม์ |
| 42 | `policy_end` | timestamp without time zone | YES |  | วันที่สิ้นสุดกรมธรรม์ |
| 43 | `opo_pay` | numeric(16,2) | YES |  | รับเงินจำนวน (OPO_RESULT=1) |
| 44 | `sr_log_id` | bigint | YES |  | ลำดับ transaction TXN_SURV_REPORT ของฝั่ง EMCS |
| 45 | `seq_id` | bigint | YES |  | หมายเลขลำดับการขอเรียกใช้เซอร์วิส ฝั่งทิพยะจะเริ่มต้นนับตั้งแต่ 1, 2, 3, … ไปเรื่อยๆ |
| 46 | `seq_id_at` | timestamp without time zone | YES |  | วันที่ได้รับ seq_id |
| 47 | `send_sms` | boolean | YES |  |  |
| 48 | `claim_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบรับแจ้ง/เคลม PDF จาก I-NET |
| 49 | `claim_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบรับแจ้ง/เคลม PDF จาก I-NET |
| 50 | `receipt_url_ref` | character varying(500) | YES |  | อ้างอิง URL ใบเสร็จ PDF จาก I-NET |
| 51 | `receipt_url_copy_ref` | character varying(500) | YES |  | อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET |
| 52 | `sf_eclaim_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Claim |
| 53 | `sf_etax_file_id` | character varying(50) | YES |  | SF อ้างอิง File ID สำหรับ E-Tax |
| 54 | `claim_url_ref_tp` | character varying(500) | YES |  |  |
| 55 | `claim_url_copy_ref_tp` | character varying(500) | YES |  |  |
| 56 | `receipt_url_ref_tp` | character varying(500) | YES |  |  |
| 57 | `receipt_url_copy_ref_tp` | character varying(500) | YES |  |  |
| 58 | `sf_eclaim_file_id_tp` | character varying(50) | YES |  |  |
| 59 | `sf_etax_file_id_tp` | character varying(50) | YES |  |  |
| 60 | `cross_result` | smallint | YES |  |  |
| 61 | `cross_result_at` | timestamp without time zone | YES |  |  |
| 62 | `accident_district_id` | integer | YES |  | รหัสอำเภอเกิดเหตุ |
| 63 | `accident_province_id` | integer | YES |  | รหัสจังหวัดเกิดเหต |

**Primary key:** `survey_report_id,ref_notify_no,ref_claim_no` (sf_claim_pkey)

**Indexes:**

- `sf_claim_pkey`: `CREATE UNIQUE INDEX sf_claim_pkey ON insurverse.sf_claim USING btree (survey_report_id, ref_notify_no, ref_claim_no)`

---

## sf_claim_asset

`insurverse.sf_claim_asset` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `record_id` | character varying(255) | NO |  | Unique ID Asset |
| 2 | `index` | numeric(18,0) | YES |  | index number |
| 3 | `asset_name` | character varying(255) | YES |  | ชื่อทรัพย์สิน |
| 4 | `owner_name` | character varying(255) | YES |  | ชื่อเจ้าของ |
| 5 | `tel` | character varying(40) | YES |  | เบอร์โทรเจ้าของ |
| 6 | `address` | character varying(255) | YES |  | ที่อยู่เจ้าของ |
| 7 | `id_card` | character varying(13) | YES |  | เลขที่บัตรประชาชนเจ้าของ |
| 8 | `damage_detail` | character varying(255) | YES |  | รายละเอียดความเสียหาย |
| 9 | `cost` | numeric(18,0) | YES |  | ประมาณค่าเสียหาย |
| 10 | `remark` | character varying(255) | YES |  | หมายเหตุ |
| 11 | `survey_report_id` | bigint | NO |  | transaction id |
| 12 | `ref_notify_no` | character varying(20) | NO |  | เลขรับแจ้ง |
| 13 | `ref_claim_no` | character varying(20) | NO |  | เลขที่เคลม |
| 14 | `sc_id` | bigint | YES |  |  |

**Primary key:** `record_id,survey_report_id,ref_notify_no,ref_claim_no` (sf_claim_asset_pkey)

**Indexes:**

- `sf_claim_asset_pkey`: `CREATE UNIQUE INDEX sf_claim_asset_pkey ON insurverse.sf_claim_asset USING btree (record_id, survey_report_id, ref_notify_no, ref_claim_no)`

---

## sf_claim_attech

`insurverse.sf_claim_attech` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `file_id` | character varying(18) | NO |  |  |
| 2 | `name` | character varying(255) | NO |  |  |
| 3 | `content_type` | character varying(255) | NO |  |  |
| 4 | `description` | character varying(255) | YES |  |  |
| 5 | `body` | character varying(32000) | YES |  | Base64 |
| 6 | `case_id` | character varying(18) | YES |  |  |
| 7 | `claim_number` | character varying(80) | YES |  | Claim Unique ID |
| 8 | `e_claim_id` | character varying(80) | YES |  | Claim Coverage External ID |
| 9 | `surveyor_report_id` | character varying(20) | YES |  | Surveyor Report ID |
| 10 | `item_id` | character varying(30) | YES |  | เลข Unique ID ของรายการที่เสียหาย (Car, Injury, Asset) |
| 11 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 12 | `create_by` | character varying(50) | YES |  |  |
| 13 | `update_date` | timestamp without time zone | YES |  |  |
| 14 | `update_by` | character varying(50) | YES |  |  |
| 15 | `type` | character varying(255) | YES |  |  |
| 16 | `url` | character varying(500) | YES |  |  |
| 17 | `file_type` | character varying(50) | YES |  | ประเภทรูปภาพแบ่งตามหมวด ได้แก่ insured, place, asset1, tp, asset2 |
| 18 | `note_id` | character varying(18) | YES |  | เลข Unique ID ของรายการบันทึกข้อความ |

**Primary key:** `file_id` (Policy_Regis_Evident_copy1_pkey)

**Indexes:**

- `Policy_Regis_Evident_copy1_pkey`: `CREATE UNIQUE INDEX "Policy_Regis_Evident_copy1_pkey" ON insurverse.sf_claim_attech USING btree (file_id)`

---

## sf_claim_backup

`insurverse.sf_claim_backup` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `survey_report_id` | bigint | YES |  |  |
| 2 | `ref_notify_no` | character varying(20) | YES |  |  |
| 3 | `ref_claim_no` | character varying(20) | YES |  |  |
| 4 | `accident_date` | timestamp without time zone | YES |  |  |
| 5 | `accident_place` | character varying(255) | YES |  |  |
| 6 | `accident_district` | character varying(50) | YES |  |  |
| 7 | `accident_province` | character varying(50) | YES |  |  |
| 8 | `accident_type` | character varying(200) | YES |  |  |
| 9 | `accident_detail` | character varying(255) | YES |  |  |
| 10 | `accident_cause` | bigint | YES |  |  |
| 11 | `accident_call` | character varying(255) | YES |  |  |
| 12 | `accident_call_date` | timestamp without time zone | YES |  |  |
| 13 | `accident_assign` | timestamp without time zone | YES |  |  |
| 14 | `accident_reach` | timestamp without time zone | YES |  |  |
| 15 | `accident_finish` | timestamp without time zone | YES |  |  |
| 16 | `police_name` | character varying(255) | YES |  |  |
| 17 | `police_station` | character varying(255) | YES |  |  |
| 18 | `police_comment` | character varying(255) | YES |  |  |
| 19 | `police_date` | timestamp without time zone | YES |  |  |
| 20 | `book_number` | character varying(255) | YES |  |  |
| 21 | `surveyor_name` | character varying(255) | YES |  |  |
| 22 | `accident_surveyor` | character varying(255) | YES |  |  |
| 23 | `surveyor_comment` | text | YES |  |  |
| 24 | `survey_date` | timestamp without time zone | YES |  |  |
| 25 | `remark` | character varying(255) | YES |  |  |
| 26 | `car_detail` | character varying(32000) | YES |  |  |
| 27 | `injured` | character varying(32000) | YES |  |  |
| 28 | `asset` | character varying(32000) | YES |  |  |
| 29 | `create_date` | timestamp without time zone | YES |  |  |
| 30 | `create_by` | character varying(50) | YES |  |  |
| 31 | `update_date` | timestamp without time zone | YES |  |  |
| 32 | `update_by` | character varying(50) | YES |  |  |
| 33 | `add_on` | numeric(6,0) | YES |  |  |
| 34 | `survey_id` | numeric(6,0) | YES |  |  |
| 35 | `survey_br_id` | numeric(6,0) | YES |  |  |
| 36 | `pos_status` | numeric(6,0) | YES |  |  |
| 37 | `prb_number` | character varying(30) | YES |  |  |
| 38 | `acc_policy_no` | character varying(30) | YES |  |  |
| 39 | `assured_name` | character varying(200) | YES |  |  |
| 40 | `policy_type` | character varying(150) | YES |  |  |
| 41 | `policy_start` | timestamp without time zone | YES |  |  |
| 42 | `policy_end` | timestamp without time zone | YES |  |  |
| 43 | `opo_pay` | numeric(16,2) | YES |  |  |
| 44 | `sr_log_id` | bigint | YES |  |  |
| 45 | `seq_id` | bigint | YES |  |  |
| 46 | `seq_id_at` | timestamp without time zone | YES |  |  |
| 47 | `send_sms` | boolean | YES |  |  |
| 48 | `claim_url_ref` | character varying(500) | YES |  |  |
| 49 | `claim_url_copy_ref` | character varying(500) | YES |  |  |
| 50 | `receipt_url_ref` | character varying(500) | YES |  |  |
| 51 | `receipt_url_copy_ref` | character varying(500) | YES |  |  |
| 52 | `sf_eclaim_file_id` | character varying(50) | YES |  |  |
| 53 | `sf_etax_file_id` | character varying(50) | YES |  |  |
| 54 | `claim_url_ref_tp` | character varying(500) | YES |  |  |
| 55 | `claim_url_copy_ref_tp` | character varying(500) | YES |  |  |
| 56 | `receipt_url_ref_tp` | character varying(500) | YES |  |  |
| 57 | `receipt_url_copy_ref_tp` | character varying(500) | YES |  |  |
| 58 | `sf_eclaim_file_id_tp` | character varying(50) | YES |  |  |
| 59 | `sf_etax_file_id_tp` | character varying(50) | YES |  |  |
| 60 | `cross_result` | smallint | YES |  |  |
| 61 | `cross_result_at` | timestamp without time zone | YES |  |  |
| 62 | `accident_district_id` | integer | YES |  |  |
| 63 | `accident_province_id` | integer | YES |  |  |

**Primary key:** _none_

---

## sf_claim_car_detail

`insurverse.sf_claim_car_detail` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `record_id` | character varying(255) | NO |  | Unique ID Car |
| 2 | `index` | numeric(18,0) | YES |  | index number. (รถประกัน=0 , TP = 1,2,…) |
| 3 | `car_register_no` | character varying(10) | YES |  | ทะเบียนรถ |
| 4 | `car_province` | character varying(255) | YES |  | จังหวัดของทะเบียนรถ |
| 5 | `car_brand` | character varying(255) | YES |  | ยี่ห้อ |
| 6 | `car_model` | character varying(255) | YES |  | รุ่น |
| 7 | `car_color` | character varying(255) | YES |  | สี |
| 8 | `chassis_no` | character varying(255) | YES |  | เลขตัวถัง |
| 9 | `engine_no` | character varying(255) | YES |  | เลขเครื่องยนต์ |
| 10 | `driver_gender` | character varying(255) | YES |  | เพศผู้ขับขี่ (ชาย, หญิง) |
| 11 | `driver_name` | character varying(255) | YES |  | ชื่อผู้ขับขี่ |
| 12 | `driver_tel` | character varying(40) | YES |  | เบอร์โทรผู้ขับขี่ |
| 13 | `driver_birthday` | timestamp without time zone | YES |  | วันเกิด |
| 14 | `driver_age` | numeric(18,0) | YES |  | อายุ |
| 15 | `driver_address` | character varying(255) | YES |  | ที่อยู่ผู้ขับขี่ |
| 16 | `driver_license_no` | character varying(13) | YES |  | เลขที่ใบขับขี่ |
| 17 | `driver_license_type` | character varying(255) | YES |  | ประเภทใบขับขี่ |
| 18 | `driver_license_place` | character varying(255) | YES |  | จังหวัดที่ออกใบขับขี่ |
| 19 | `driver_license_expired` | timestamp without time zone | YES |  | วันหมดอายุใบขับขี่ |
| 20 | `driver_id_card` | character varying(13) | YES |  | เลขที่บัตรประชาชน |
| 21 | `opo_recovery` | numeric(18,0) | YES |  | เรียกร้องค่าเสียหายจากคู่กรณี |
| 22 | `total_damage_cost` | numeric(18,0) | YES |  | ค่าประมาณการความเสียหายรวม |
| 23 | `damage_list` | character varying(32000) | YES |  | รายการชิ้นส่วนที่เสียหาย |
| 24 | `survey_report_id` | bigint | NO |  | transaction id |
| 25 | `ref_notify_no` | character varying(20) | NO |  | เลขรับแจ้ง |
| 26 | `ref_claim_no` | character varying(20) | NO |  | เลขที่เคลม |
| 27 | `driver_license_start` | timestamp without time zone | YES |  | ออกให้วันที่ |
| 28 | `driver_relation` | character varying(50) | YES |  | ความสัมพันธ์กับเจ้าของรถ |
| 29 | `have_insurance` | character varying(50) | YES |  | มีประกันภัยของที่ไหน (เฉพาะ TYPE >= 1) |
| 30 | `policy_no` | character varying(30) | YES |  | กรมธรรม์ (เฉพาะ TYPE >= 1) |
| 31 | `claim_no` | character varying(30) | YES |  | หมายเลขเคลมที่ (เฉพาะ TYPE >= 1) |
| 32 | `policy_type` | character varying(255) | YES |  | ประกันประเภท (เฉพาะ TYPE >= 1) |
| 33 | `sc_id` | bigint | YES |  |  |
| 34 | `car_province_id` | integer | YES |  |  |

**Primary key:** `record_id,survey_report_id,ref_notify_no,ref_claim_no` (claim_car_detail_pkey)

**Inferred references (naming convention, NOT enforced FK):** `policy_no` → Policy_Header

**Indexes:**

- `claim_car_detail_pkey`: `CREATE UNIQUE INDEX claim_car_detail_pkey ON insurverse.sf_claim_car_detail USING btree (record_id, survey_report_id, ref_notify_no, ref_claim_no)`

---

## sf_claim_coverage

`insurverse.sf_claim_coverage` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `claim_id` | character varying(20) | NO |  | เลขเคลม |
| 2 | `policy_number` | character varying(20) | YES |  | เลขกรมธรรม์ |
| 3 | `status` | character varying(50) | YES |  | Status ของ Claim อยู่ใน Level ไหนบน IIA |
| 4 | `claim_type` | character varying(255) | YES |  | Claim Type. eg.PURELOSS, Cosmetic, Other (เฉพาะรถประกัน) |
| 5 | `responsibility` | character varying(255) | YES |  | ถูก/ผิด |
| 6 | `payment_type` | character varying(255) | YES |  | รูปแบบการปิดจ่าย |
| 7 | `total_loss_reserve` | numeric(16,2) | YES |  | ค่าประมาณการ |
| 8 | `total_loss_settlement` | numeric(16,2) | YES |  | ยอดเงินที่จ่ายออกไป |
| 9 | `total_recovery` | numeric(16,2) | YES |  | ยอดเงินที่เก็บได้จากคู่กรณี |
| 10 | `create_date` | timestamp without time zone | YES | `now()` |  |
| 11 | `create_by` | character varying(50) | YES |  |  |
| 12 | `update_date` | timestamp without time zone | YES |  |  |
| 13 | `update_by` | character varying(50) | YES |  |  |
| 14 | `sf_response_code` | character varying(1000) | YES |  | Salesforce return code |
| 15 | `sf_response_at` | timestamp without time zone | YES |  | Salesforce return datetime |

**Primary key:** `claim_id` (sf_claim_reserve_adjust_pkey)

**Indexes:**

- `sf_claim_reserve_adjust_pkey`: `CREATE UNIQUE INDEX sf_claim_reserve_adjust_pkey ON insurverse.sf_claim_coverage USING btree (claim_id)`

---

## sf_claim_coverage_item

`insurverse.sf_claim_coverage_item` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `claim_id` | character varying(20) | NO |  | เลขเคลม |
| 2 | `coverage_id` | character varying(20) | NO |  | หมายเลข Unique ของทรัพย์สินภายใน Claim |
| 3 | `item_no` | integer | YES |  | ลำดับที่ |
| 4 | `coverage_type` | character varying(50) | YES |  | ประเภทของการเบิก |
| 5 | `emcs_status` | character varying(50) | YES |  | สถานะการซ่อม |
| 6 | `emcs_adjust_status` | character varying(50) | YES |  | สถานะการคุมราคา (เสนอราคา, ยังไม่เสนอราคา, รออนุมัติ, อนุมัติ, ไม่อนุมัติ) |
| 7 | `repairer_code` | character varying(255) | YES |  | car_detail รหัสอู่ |
| 8 | `repairer_name` | character varying(255) | YES |  | car_detail ชื่ออู่ |
| 9 | `originator_code` | character varying(255) | YES |  | car_detail รหัสร้านกระจก |
| 10 | `originator_name` | character varying(255) | YES |  | car_detail ชื่อร้านกระจก |
| 11 | `car_license` | character varying(255) | YES |  | car_detail ทะเบียนรถ |
| 12 | `policy_number` | character varying(255) | YES |  | car_detail เลขที่ ก/ธ |
| 13 | `claim_number` | character varying(255) | YES |  | car_detail เลขที่สินไหม |
| 14 | `image_part` | character varying(1000) | YES |  | car_detail รูปรับรถ |
| 15 | `firstname` | character varying(255) | YES |  | injury_detail ชื่อ |
| 16 | `lastname` | character varying(255) | YES |  | injury_detail นามสกุล |
| 17 | `citizen_id` | character varying(18) | YES |  | injury_detail เลขบัตรประชาชน |
| 18 | `name` | character varying(255) | YES |  | property_detail ชื่อทรัพย์สิน |
| 19 | `owner_firstname` | character varying(255) | YES |  | property_detail ชื่อเจ้าของ |
| 20 | `owner_lastname` | character varying(255) | YES |  | property_detail นามสกุลเจ้าของ |
| 21 | `owner_citizen_id` | character varying(18) | YES |  | property_detail เลขบัตรประชาชนเจ้าของ |
| 22 | `rep_comment` | character varying(3000) | YES |  | car_detail ความคิดเห็นอู่ |
| 23 | `ins_comment` | character varying(6000) | YES |  | car_detail ความคิดเห็นบริษัทประกัน |
| 24 | `image_part_url` | character varying(500) | YES |  | car_detail รูปรับรถ url |
| 25 | `sf_file_id` | character varying(50) | YES |  | SF file ID |
| 26 | `rep_bring_date` | timestamp without time zone | YES |  | car_detail วันที่นำรถมาซ่อม (REP_BRING_DATE) |
| 27 | `get_car_back_date` | timestamp without time zone | YES |  | car_detail วันที่รับรถ (GET_CAR_BACK_DATE) |
| 28 | `e_claim_id` | character varying(20) | YES |  | eClaim |
| 29 | `invoice_path` | character varying(1000) | YES |  | car_detail ใบกำกับภาษี/ใบแจ้งหนี้/ใบเสร็จ เลขที่ |
| 30 | `invoice_path_url` | character varying(500) | YES |  | car_detail รูปใบกำกับภาษี/ใบแจ้งหนี้/ใบเสร็จ เลขที่ |
| 31 | `sf_file_id_inv` | character varying(50) | YES |  | SF file ID invoice_path_url |

**Primary key:** `claim_id,coverage_id` (sf_claim_reserve_adjuct_item_pkey)

**Indexes:**

- `sf_claim_reserve_adjuct_item_pkey`: `CREATE UNIQUE INDEX sf_claim_reserve_adjuct_item_pkey ON insurverse.sf_claim_coverage_item USING btree (claim_id, coverage_id)`

---

## sf_claim_ibilling

`insurverse.sf_claim_ibilling` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `survey_report_id` | bigint | NO |  | transaction id |
| 2 | `ref_notify_no` | character varying(20) | NO |  | เลขรับแจ้ง |
| 3 | `ref_claim_no` | character varying(20) | NO |  | เลขที่เคลม |
| 4 | `survey_fee` | numeric(18,0) | YES |  | ค่าบริการเซอร์เวย์ เสนอ |
| 5 | `insurance_fee` | numeric(18,0) | YES |  | ค่าบริการประกัน อนุมัติ |
| 6 | `survey_transportation` | numeric(18,0) | YES |  | ค่าเดินทาง/ค่าพาหนะเซอร์เวย์ เสนอ |
| 7 | `insurance_transportation` | numeric(18,0) | YES |  | ค่าเดินทาง/ค่าพาหนะประกัน อนุมัติ |
| 8 | `survey_other` | numeric(18,0) | YES |  | ค่าใช้จ่ายอื่นๆซอร์เวย์ เสนอ |
| 9 | `insurance_other` | numeric(18,0) | YES |  | ค่าใช้จ่ายอื่นๆประกัน อนุมัติ |
| 10 | `other_description` | character varying(255) | YES |  | ค่าใช้จ่ายอื่นๆ |
| 11 | `billing_no` | character varying(255) | YES |  | เลขที่ใบแจ้งหนี้ |
| 12 | `billing_date` | timestamp without time zone | YES |  | วันที่วางบิล |
| 13 | `survey_claim` | numeric(18,0) | YES |  | ค่าเรียกร้องเซอร์เวย์ อนุมัติ |
| 14 | `insurance_claim` | numeric(18,0) | YES |  | ค่าเรียกร้องประกัน อนุมัติ |
| 15 | `survey_daily` | numeric(18,0) | YES |  | ค่าคัดประจำวันเซอร์เวย์ เสนอ |
| 16 | `insurance_daily` | numeric(18,0) | YES |  | ค่าคัดประจำวันประกัน อนุมัติ |
| 17 | `send_date` | timestamp without time zone | YES |  | วันที่เสนอราคา |
| 18 | `send_by` | character varying(255) | YES |  | ชื่อผู้เสนอราคา |
| 19 | `approve_date` | timestamp without time zone | YES |  | วันที่อนุมัติ |
| 20 | `approve_by` | character varying(255) | YES |  | ชื่อผู้อนุมัติ |
| 21 | `create_date` | timestamp without time zone | YES |  |  |
| 22 | `create_by` | character varying(50) | YES |  |  |
| 23 | `update_date` | timestamp without time zone | YES |  |  |
| 24 | `update_by` | character varying(50) | YES |  |  |
| 25 | `si_id` | integer | NO |  | หมายเลข Auto Gen ของ ค่าใช้จ่าย |

**Primary key:** `survey_report_id,ref_notify_no,ref_claim_no` (claim_ibilling_pkey)

**Indexes:**

- `claim_ibilling_pkey`: `CREATE UNIQUE INDEX claim_ibilling_pkey ON insurverse.sf_claim_ibilling USING btree (survey_report_id, ref_notify_no, ref_claim_no)`

---

## sf_claim_injured

`insurverse.sf_claim_injured` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `record_id` | character varying(255) | NO |  | Unique ID Injury |
| 2 | `index` | numeric(18,0) | YES |  | index number |
| 3 | `gender` | character varying(255) | YES |  | เพศ |
| 4 | `name` | character varying(255) | YES |  | ชื่อ |
| 5 | `tel` | character varying(40) | YES |  | เบอร์โทร |
| 6 | `id_card` | character varying(13) | YES |  | เลขที่บัตรประชาชน |
| 7 | `address` | character varying(255) | YES |  | ที่อยู่ |
| 8 | `birthday` | timestamp without time zone | YES |  | วันเกิด |
| 9 | `age` | numeric(18,0) | YES |  | อายุ |
| 10 | `person_type` | character varying(255) | YES |  | ประเภทผู้บาดเจ็บ  01 = “ผู้ขับขี่ – รถประกัน”   02 = “ผู้ขับขี่ - รถคู่กรณี”   03 = “ผู้โดยสาร - รถประกัน”  04 = “ผู้โดยสาร - รถคู่กรณี”  ประเภทผู้บาดเจ็บ |
| 11 | `person_type_text` | character varying(255) | YES |  | ประเภทผู้บาดเจ็บ |
| 12 | `car_register_no` | character varying(255) | YES |  | ทะเบียนรถ (ถ้าเป็นบุคคลที่อยู่ในรถ) |
| 13 | `wounded_type` | character varying(255) | YES |  | ลักษณะอาการบาดเจ็บ |
| 14 | `wounded_type_text` | character varying(255) | YES |  | ลักษณะอาการบาดเจ็บ |
| 15 | `injured_detail` | character varying(255) | YES |  | อาการบาดเจ็บ |
| 16 | `hospital_name` | character varying(255) | YES |  | โรงพยาบาลที่เข้ารักษา |
| 17 | `cost` | numeric(18,0) | YES |  | ประมาณค่ารักษา |
| 18 | `remark` | character varying(255) | YES |  | หมายเหตุ |
| 19 | `survey_report_id` | bigint | NO |  | transaction id |
| 20 | `ref_notify_no` | character varying(20) | NO |  | เลขรับแจ้ง |
| 21 | `ref_claim_no` | character varying(20) | NO |  | เลขที่เคลม |
| 22 | `inj_id` | bigint | YES |  |  |

**Primary key:** `record_id,survey_report_id,ref_notify_no,ref_claim_no` (sf_claim_injured_pkey)

**Indexes:**

- `sf_claim_injured_pkey`: `CREATE UNIQUE INDEX sf_claim_injured_pkey ON insurverse.sf_claim_injured USING btree (record_id, survey_report_id, ref_notify_no, ref_claim_no)`

---

## sf_claim_pay

`insurverse.sf_claim_pay` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pay_id` | character varying(20) | YES |  |  |
| 2 | `sr_id` | character varying(20) | YES |  |  |
| 3 | `srref_id` | character varying(255) | YES |  |  |
| 4 | `add_no` | numeric(18,0) | YES |  |  |
| 5 | `survey_id` | character varying(255) | YES |  |  |
| 6 | `surveyor_name` | character varying(255) | YES |  |  |
| 7 | `ref_claim_no` | character varying(255) | NO |  | เลขที่เคลม |
| 8 | `acc_claim_ref_no` | character varying(255) | YES |  |  |
| 9 | `acc_policy_no` | character varying(255) | YES |  |  |
| 10 | `car_reg_no` | character varying(255) | YES |  |  |
| 11 | `unit_price` | numeric(16,2) | YES |  |  |
| 12 | `inc_vat` | numeric(18,0) | YES |  |  |
| 13 | `send_date` | character varying(255) | YES |  |  |
| 14 | `check_date` | character varying(255) | YES |  |  |
| 15 | `checkr_id` | character varying(255) | YES |  |  |
| 16 | `approve_id` | character varying(255) | YES |  |  |
| 17 | `acc_date` | character varying(255) | YES |  |  |
| 18 | `acc_call_date` | character varying(255) | YES |  |  |
| 19 | `pos_status` | numeric(18,0) | YES |  | Fix 25 |
| 20 | `vendor` | character varying(255) | YES |  |  |
| 21 | `survey_report_id` | bigint | NO |  | transaction id |
| 22 | `ref_notify_no` | character varying(20) | NO |  | เลขรับแจ้ง |

**Primary key:** `survey_report_id,ref_notify_no,ref_claim_no` (sf_claim_pay_pkey)

**Indexes:**

- `sf_claim_pay_pkey`: `CREATE UNIQUE INDEX sf_claim_pay_pkey ON insurverse.sf_claim_pay USING btree (survey_report_id, ref_notify_no, ref_claim_no)`

---

## sf_file_attach

`insurverse.sf_file_attach` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `file_id` | character varying(18) | NO |  | Attachment Unique ID |
| 2 | `name` | character varying(255) | NO |  | Name of the attached file. Maximum size is 255 characters. Label is File Name. |
| 3 | `content_type` | character varying(255) | NO |  | https://en.wikipedia.org/wiki/Media_type |
| 4 | `description` | character varying(255) | YES |  | File Description |
| 5 | `body` | character varying(32000) | YES |  | Required. Encoded file data. |
| 6 | `case_id` | character varying(18) | YES |  |  |
| 7 | `create_date` | timestamp without time zone | YES |  |  |
| 8 | `create_by` | character varying(50) | YES |  |  |
| 9 | `update_date` | timestamp without time zone | YES |  |  |
| 10 | `update_by` | character varying(50) | YES |  |  |
| 11 | `url` | character varying(500) | YES |  |  |
| 12 | `chat_id` | character varying | YES |  | External Token |

**Primary key:** _none_

---

## shopee_app_access_token

`insurverse.shopee_app_access_token` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.shopee_app_access_token_id_seq'::regclass)` |  |
| 2 | `refresh_token` | character varying(255) | YES |  |  |
| 3 | `access_token` | character varying(255) | YES |  |  |
| 4 | `expire_in` | integer | YES | `0` |  |
| 5 | `request_id` | character varying(255) | YES |  |  |
| 6 | `partner_id` | integer | YES | `0` |  |
| 7 | `shop_id` | integer | YES | `0` |  |
| 8 | `is_refresh_token` | boolean | YES | `false` |  |
| 9 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 10 | `updated_at` | timestamp without time zone | YES | `now()` |  |
| 11 | `delflag` | boolean | YES | `false` |  |

**Primary key:** `id` (shopee_app_access_token_pkey)

**Indexes:**

- `idx_shopee_app_access_token_access_token`: `CREATE INDEX idx_shopee_app_access_token_access_token ON insurverse.shopee_app_access_token USING btree (access_token)`
- `idx_shopee_app_access_token_refresh_token`: `CREATE INDEX idx_shopee_app_access_token_refresh_token ON insurverse.shopee_app_access_token USING btree (refresh_token)`
- `shopee_app_access_token_pkey`: `CREATE UNIQUE INDEX shopee_app_access_token_pkey ON insurverse.shopee_app_access_token USING btree (id)`

---

## shopee_app_authorized

`insurverse.shopee_app_authorized` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.shopee_app_authorized_id_seq'::regclass)` |  |
| 2 | `code` | character varying(255) | YES |  |  |
| 3 | `shop_id` | character varying(255) | YES |  |  |
| 4 | `state` | character varying(10) | YES |  |  |
| 5 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 6 | `updated_at` | timestamp without time zone | YES | `now()` |  |
| 7 | `delflag` | boolean | YES | `false` |  |

**Primary key:** `id` (shopee_app_authorized_pkey)

**Indexes:**

- `shopee_app_authorized_pkey`: `CREATE UNIQUE INDEX shopee_app_authorized_pkey ON insurverse.shopee_app_authorized USING btree (id)`

---

## shopee_product_form

`insurverse.shopee_product_form` · kind: table · est. rows: **57**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `category` | character varying(255) | YES |  |  |
| 3 | `sub_catagory` | character varying(255) | YES |  |  |
| 4 | `productname` | character varying(255) | YES |  |  |
| 5 | `sub_productname` | character varying(255) | YES |  |  |
| 6 | `parance_sku` | character varying(255) | YES |  |  |
| 7 | `sub_sku` | character varying(255) | YES |  |  |
| 8 | `claim_price` | numeric(8,2) | YES |  |  |
| 9 | `price` | numeric(8,2) | YES |  |  |
| 10 | `discount` | numeric(8,2) | YES |  |  |
| 11 | `listing_test` | boolean | YES |  |  |
| 12 | `link_test` | character varying(255) | YES |  |  |
| 13 | `link` | character varying(255) | YES |  |  |
| 14 | `status` | character varying(50) | YES |  |  |
| 15 | `created_at` | timestamp without time zone | YES |  |  |
| 16 | `updated_at` | timestamp without time zone | YES |  |  |
| 17 | `sms_temp` | text | YES |  |  |
| 18 | `si_limit` | integer | YES |  |  |
| 19 | `insurance_class` | character varying(50) | YES |  |  |
| 20 | `product_type` | character varying(50) | YES | `'MC'::character varying` |  |
| 21 | `include_act` | boolean | YES | `false` |  |

**Primary key:** _none_

**Indexes:**

- `idx_shopee_product_form_product_type`: `CREATE INDEX idx_shopee_product_form_product_type ON insurverse.shopee_product_form USING btree (product_type)`

---

## subdistrict

`insurverse.subdistrict` · kind: table · est. rows: **7,469**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `subdistrictid` | integer | NO | `nextval('insurverse.subdistrict_subdistrictid_seq'::regclass)` |  |
| 2 | `sddistrict` | integer | NO |  |  |
| 3 | `sdprovince` | integer | NO |  |  |
| 4 | `sdcountry` | integer | NO |  |  |
| 5 | `sdcode` | character(6) | NO |  |  |
| 6 | `sdlat` | numeric(16,13) | NO |  |  |
| 7 | `sdlong` | numeric(16,13) | NO |  |  |
| 8 | `sdname` | character varying(150) | NO |  |  |
| 9 | `sdnameen` | character varying(150) | YES |  |  |

**Primary key:** `subdistrictid` (subdistrict_pkey)

**Indexes:**

- `subdistrict_pkey`: `CREATE UNIQUE INDEX subdistrict_pkey ON insurverse.subdistrict USING btree (subdistrictid)`

---

## subdistrict_10jan

`insurverse.subdistrict_10jan` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `subdistrictid` | integer | YES |  |  |
| 2 | `sddistrict` | integer | YES |  |  |
| 3 | `sdprovince` | integer | YES |  |  |
| 4 | `sdcountry` | integer | YES |  |  |
| 5 | `sdcode` | bpchar | YES |  |  |
| 6 | `sdlat` | numeric | YES |  |  |
| 7 | `sdlong` | numeric | YES |  |  |
| 8 | `sdname` | character varying(150) | YES |  |  |
| 9 | `sdnameen` | character varying(150) | YES |  |  |

**Primary key:** _none_

---

## subdistrict_12sep67

`insurverse.subdistrict_12sep67` · kind: table · est. rows: **7,468** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `subdistrictid` | integer | YES |  |  |
| 2 | `sddistrict` | integer | YES |  |  |
| 3 | `sdprovince` | integer | YES |  |  |
| 4 | `sdcountry` | integer | YES |  |  |
| 5 | `sdcode` | bpchar | YES |  |  |
| 6 | `sdlat` | numeric | YES |  |  |
| 7 | `sdlong` | numeric | YES |  |  |
| 8 | `sdname` | character varying(150) | YES |  |  |
| 9 | `sdnameen` | character varying(150) | YES |  |  |

**Primary key:** _none_

---

## subdistrict_add

`insurverse.subdistrict_add` · kind: table · est. rows: **7,660** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `subdistrictid` | integer | YES |  |  |
| 2 | `sddistrict` | integer | YES |  |  |
| 3 | `sdprovince` | integer | YES |  |  |
| 4 | `sdcountry` | integer | YES |  |  |
| 5 | `sdcode` | bpchar | YES |  |  |
| 6 | `sdlat` | numeric | YES |  |  |
| 7 | `sdlong` | numeric | YES |  |  |
| 8 | `sdname` | character varying(150) | YES |  |  |
| 9 | `sdnameen` | character varying(150) | YES |  |  |

**Primary key:** _none_

---

## sys_param

`insurverse.sys_param` · kind: table · est. rows: **159**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `dom_code` | character varying(50) | NO |  |  |
| 2 | `sub_dom_code` | character varying(50) | NO |  |  |
| 3 | `para_code` | character varying(50) | NO |  |  |
| 4 | `para_name` | character varying(255) | YES |  |  |
| 5 | `para_desc` | text | YES |  |  |
| 6 | `para_value` | numeric(18,6) | YES |  |  |
| 7 | `para_str` | character varying(255) | YES |  |  |
| 8 | `para_date` | timestamp without time zone | YES |  |  |
| 9 | `para_min` | numeric(18,6) | YES |  |  |
| 10 | `para_max` | numeric(18,6) | YES |  |  |
| 11 | `para_status` | character varying(50) | YES |  | ATV ใช้งาน INV ไม่ใช้งาน (Filter out from list) |
| 12 | `reate_date` | timestamp without time zone | YES |  |  |
| 13 | `create_by` | character varying(50) | YES |  |  |
| 14 | `update_date` | timestamp without time zone | YES |  |  |
| 15 | `update_by` | character varying(50) | YES |  |  |
| 16 | `para_bool` | boolean | YES | `false` |  |
| 17 | `para_name_en` | character varying(255) | YES |  |  |

**Primary key:** `dom_code,sub_dom_code,para_code` (Sys_Param_pkey)

**Inferred references (naming convention, NOT enforced FK):** `dom_code` → Sys_Domain

**Indexes:**

- `Sys_Param_pkey`: `CREATE UNIQUE INDEX "Sys_Param_pkey" ON insurverse.sys_param USING btree (dom_code, sub_dom_code, para_code)`

---

## sys_param_20260810

`insurverse.sys_param_20260810` · kind: table · est. rows: **0** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `dom_code` | character varying(50) | YES |  |  |
| 2 | `sub_dom_code` | character varying(50) | YES |  |  |
| 3 | `para_code` | character varying(50) | YES |  |  |
| 4 | `para_name` | character varying(255) | YES |  |  |
| 5 | `para_desc` | text | YES |  |  |
| 6 | `para_value` | numeric(18,6) | YES |  |  |
| 7 | `para_str` | character varying(255) | YES |  |  |
| 8 | `para_date` | timestamp without time zone | YES |  |  |
| 9 | `para_min` | numeric(18,6) | YES |  |  |
| 10 | `para_max` | numeric(18,6) | YES |  |  |
| 11 | `para_status` | character varying(50) | YES |  |  |
| 12 | `reate_date` | timestamp without time zone | YES |  |  |
| 13 | `create_by` | character varying(50) | YES |  |  |
| 14 | `update_date` | timestamp without time zone | YES |  |  |
| 15 | `update_by` | character varying(50) | YES |  |  |
| 16 | `para_bool` | boolean | YES |  |  |
| 17 | `para_name_en` | character varying(255) | YES |  |  |

**Primary key:** _none_

---

## tbl_blacklist

`insurverse.tbl_blacklist` · kind: table · est. rows: **47**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `blacklist_id` | character varying(20) | NO |  |  |
| 2 | `insurance_type` | character varying(200) | NO |  |  |
| 3 | `entity_type` | character varying(30) | NO |  |  |
| 4 | `entity_value` | character varying(200) | NO |  |  |
| 5 | `additional_entity_value` | jsonb | YES |  |  |
| 6 | `note` | text | YES |  |  |
| 7 | `reason` | text | YES |  |  |
| 8 | `expired_at` | timestamp without time zone | YES |  |  |
| 9 | `request_id` | character varying(20) | NO |  |  |
| 10 | `created_dt` | timestamp without time zone | NO | `CURRENT_TIMESTAMP` |  |
| 11 | `updated_dt` | timestamp without time zone | YES |  |  |
| 12 | `created_by` | character varying(100) | NO |  |  |
| 13 | `updated_by` | character varying(100) | YES |  |  |

**Primary key:** `blacklist_id` (tbl_blacklist_pkey)

**Foreign keys:**

- `request_id` → `insurverse.tbl_blacklist_request(request_id)` — tbl_blacklist_request_id_fkey

**Indexes:**

- `idx_tbl_blacklist_expired_at`: `CREATE INDEX idx_tbl_blacklist_expired_at ON insurverse.tbl_blacklist USING btree (expired_at)`
- `idx_tbl_blacklist_identity`: `CREATE INDEX idx_tbl_blacklist_identity ON insurverse.tbl_blacklist USING btree (entity_type, entity_value)`
- `tbl_blacklist_pkey`: `CREATE UNIQUE INDEX tbl_blacklist_pkey ON insurverse.tbl_blacklist USING btree (blacklist_id)`

---

## tbl_blacklist_request

`insurverse.tbl_blacklist_request` · kind: table · est. rows: **47**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `request_id` | character varying(20) | NO |  |  |
| 2 | `action` | character varying(10) | NO |  |  |
| 3 | `insurance_type` | character varying(200) | NO |  |  |
| 4 | `entity_type` | character varying(30) | NO |  |  |
| 5 | `entity_value` | character varying(200) | NO |  |  |
| 6 | `additional_entity_value` | jsonb | YES |  |  |
| 7 | `expired_at` | timestamp without time zone | YES |  |  |
| 8 | `status` | character varying(20) | NO |  |  |
| 9 | `reason` | text | NO |  |  |
| 10 | `reject_reason` | text | YES |  |  |
| 11 | `note` | text | YES |  |  |
| 12 | `blacklist_id` | character varying(20) | YES |  |  |
| 13 | `decided_at` | timestamp without time zone | YES |  |  |
| 14 | `created_dt` | timestamp without time zone | NO | `CURRENT_TIMESTAMP` |  |
| 15 | `updated_dt` | timestamp without time zone | YES |  |  |
| 16 | `created_by` | character varying(100) | NO |  |  |
| 17 | `updated_by` | character varying(100) | YES |  |  |

**Primary key:** `request_id` (tbl_blacklist_request_pkey)

**Inferred references (naming convention, NOT enforced FK):** `blacklist_id` → tbl_blacklist

**Indexes:**

- `idx_tbl_blacklist_request_identity`: `CREATE INDEX idx_tbl_blacklist_request_identity ON insurverse.tbl_blacklist_request USING btree (entity_type, entity_value)`
- `idx_tbl_blacklist_request_status`: `CREATE INDEX idx_tbl_blacklist_request_status ON insurverse.tbl_blacklist_request USING btree (status)`
- `tbl_blacklist_request_pkey`: `CREATE UNIQUE INDEX tbl_blacklist_request_pkey ON insurverse.tbl_blacklist_request USING btree (request_id)`

---

## temp_claims

`insurverse.temp_claims` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | character varying(18) | NO |  |  |
| 2 | `name` | character varying(50) | YES |  |  |
| 3 | `claim_no` | character varying(50) | YES |  |  |
| 4 | `accident_call_date` | timestamp with time zone | YES |  |  |
| 5 | `created_date` | timestamp with time zone | YES |  |  |

**Primary key:** `id` (temp_claims_pkey)

**Indexes:**

- `temp_claims_pkey`: `CREATE UNIQUE INDEX temp_claims_pkey ON insurverse.temp_claims USING btree (id)`

---

## temp_otp

`insurverse.temp_otp` · kind: table · est. rows: **118**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO | `nextval('insurverse.temp_otp_id_seq'::regclass)` |  |
| 2 | `email` | character varying | YES |  |  |
| 3 | `otp` | character varying(6) | YES |  |  |
| 4 | `ref_id` | character varying | YES |  |  |
| 5 | `active` | boolean | YES | `false` | ถูกใช้แล้ว |
| 6 | `created_at` | timestamp without time zone | YES |  |  |
| 7 | `updated_at` | timestamp without time zone | YES |  |  |
| 8 | `expired_at` | timestamp without time zone | YES |  |  |
| 9 | `count` | integer | YES | `0` | นับจำนวนครั้งที่ OTP ผิด |
| 10 | `phone` | character varying(10) | YES |  |  |
| 11 | `disable_flag` | boolean | YES | `false` | ถูกปิดใช้งานเมื่อมีการ Generate OTP Phone ใหม่ |
| 12 | `product` | character varying(6) | YES |  |  |

**Primary key:** `id` (temp_otp_pkey)

**Indexes:**

- `temp_otp_pkey`: `CREATE UNIQUE INDEX temp_otp_pkey ON insurverse.temp_otp USING btree (id)`

---

## thaibulk_configs

`insurverse.thaibulk_configs` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | uuid | NO | `gen_random_uuid()` |  |
| 2 | `owner` | character varying(100) | NO |  |  |
| 3 | `value` | jsonb | NO |  |  |
| 4 | `is_active` | boolean | YES | `true` |  |
| 5 | `created_at` | timestamp with time zone | NO | `now()` |  |
| 6 | `created_by` | character varying(255) | NO | `'SYSTEM'::character varying` |  |
| 7 | `updated_at` | timestamp with time zone | NO | `now()` |  |
| 8 | `updated_by` | character varying(255) | NO | `'SYSTEM'::character varying` |  |

**Primary key:** `id` (thaibulk_configs_pkey)

**Indexes:**

- `thaibulk_configs_pkey`: `CREATE UNIQUE INDEX thaibulk_configs_pkey ON insurverse.thaibulk_configs USING btree (id)`

---

## thaibulk_events

`insurverse.thaibulk_events` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | bigint | NO |  |  |
| 2 | `message_id` | character varying(255) | YES |  |  |
| 3 | `recipient` | character varying(255) | YES |  |  |
| 4 | `status` | character varying(60) | YES |  |  |
| 5 | `reason` | text | YES |  |  |
| 6 | `click_url` | text | YES |  |  |
| 7 | `created_at` | timestamp with time zone | YES | `now()` |  |
| 8 | `updated_at` | timestamp with time zone | YES | `now()` |  |

**Primary key:** `id` (thaibulk_events_pkey)

**Indexes:**

- `idx_thaibulk_events_message_id`: `CREATE INDEX idx_thaibulk_events_message_id ON insurverse.thaibulk_events USING btree (message_id)`
- `thaibulk_events_pkey`: `CREATE UNIQUE INDEX thaibulk_events_pkey ON insurverse.thaibulk_events USING btree (id)`

---

## thaibulk_templates

`insurverse.thaibulk_templates` · kind: table · est. rows: **0**

> template for subject use in api thaibulk

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `template_code` | character varying(100) | YES |  |  |
| 3 | `template_name` | character varying(255) | YES |  |  |
| 4 | `subject_template` | text | YES |  |  |
| 5 | `body_template` | text | YES |  |  |
| 6 | `is_active` | boolean | YES |  |  |
| 7 | `created_at` | timestamp without time zone | YES |  |  |

**Primary key:** `id` (thaibulk_templates_pk)

**Indexes:**

- `thaibulk_templates_pk`: `CREATE UNIQUE INDEX thaibulk_templates_pk ON insurverse.thaibulk_templates USING btree (id)`

---

## thaibulk_webhook_logs

`insurverse.thaibulk_webhook_logs` · kind: table · est. rows: **0**

> webhook logs for data send from thaibulk to microservice

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | YES |  |  |
| 2 | `message_id` | character varying(255) | YES |  |  |
| 3 | `recipient` | text | YES |  |  |
| 4 | `status` | text | YES |  |  |
| 5 | `reason` | text | YES |  |  |
| 6 | `click_url` | text | YES |  |  |
| 7 | `created_at` | timestamp without time zone | YES |  |  |
| 8 | `updated_at` | timestamp without time zone | YES |  |  |

**Primary key:** _none_

---

## tqm_allow_process

`insurverse.tqm_allow_process` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `api_name` | character varying(50) | NO |  |  |
| 2 | `status` | character varying(15) | NO |  |  |

**Primary key:** `api_name` (tqm_allow_process_pk)

**Indexes:**

- `tqm_allow_process_pk`: `CREATE UNIQUE INDEX tqm_allow_process_pk ON insurverse.tqm_allow_process USING btree (api_name)`

---

## tqm_car_inspect_result

`insurverse.tqm_car_inspect_result` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `request_id` | character varying(100) | NO |  |  |
| 2 | `status` | character varying(20) | YES |  |  |
| 3 | `inspect_detail` | text | YES |  |  |
| 4 | `inspect_date` | date | YES |  |  |
| 5 | `car_detail` | text | YES |  |  |
| 6 | `car_color` | character varying(50) | YES |  |  |
| 7 | `car_license` | character varying(20) | YES |  |  |
| 8 | `car_province` | character varying(100) | YES |  |  |
| 9 | `car_band` | character varying(50) | YES |  |  |
| 10 | `car_model` | character varying(50) | YES |  |  |
| 11 | `car_year` | integer | YES |  |  |
| 12 | `have_accessory` | boolean | YES |  |  |
| 13 | `image_detail_json` | json | YES |  |  |

**Primary key:** `request_id` (tqm_car_inspect_result_pkey)

**Indexes:**

- `tqm_car_inspect_result_pkey`: `CREATE UNIQUE INDEX tqm_car_inspect_result_pkey ON insurverse.tqm_car_inspect_result USING btree (request_id)`

---

## tqm_car_license_provice

`insurverse.tqm_car_license_provice` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `pv_code` | character varying(4) | NO |  |  |
| 2 | `pv_name` | character varying(64) | NO |  |  |
| 3 | `pv_id` | smallint | NO |  |  |

**Primary key:** `pv_code` (tqm_car_license_provice_pkey)

**Indexes:**

- `tqm_car_license_provice_pkey`: `CREATE UNIQUE INDEX tqm_car_license_provice_pkey ON insurverse.tqm_car_license_provice USING btree (pv_code)`

---

## tqm_car_mapping

`insurverse.tqm_car_mapping` · kind: table · est. rows: **0**

> Car mapping table for TQM system

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  | Primary key auto-increment |
| 2 | `brand_code` | character varying(10) | NO |  | Brand code identifier |
| 3 | `brand` | character varying(50) | NO |  | Brand name |
| 4 | `model_code` | character varying(20) | NO |  | Model code identifier |
| 5 | `model` | character varying(100) | NO |  | Model name |
| 6 | `vehicle_type` | character varying(5) | NO |  | Vehicle type (PS=Passenger, SV=SUV, etc.) |
| 7 | `isv_brand` | character varying(50) | NO |  | ISV brand mapping |
| 8 | `isv_model` | character varying(20) | NO |  | ISV model mapping |
| 9 | `isv_cc` | character varying(10) | NO |  | Engine displacement category |
| 10 | `created_at` | timestamp with time zone | YES | `CURRENT_TIMESTAMP` |  |
| 11 | `updated_at` | timestamp with time zone | YES | `CURRENT_TIMESTAMP` |  |

**Primary key:** `id` (tqm_car_mapping_pkey)

**Indexes:**

- `idx_tqm_car_mapping_brand_code`: `CREATE INDEX idx_tqm_car_mapping_brand_code ON insurverse.tqm_car_mapping USING btree (brand_code)`
- `idx_tqm_car_mapping_isv_brand`: `CREATE INDEX idx_tqm_car_mapping_isv_brand ON insurverse.tqm_car_mapping USING btree (isv_brand)`
- `idx_tqm_car_mapping_model_code`: `CREATE INDEX idx_tqm_car_mapping_model_code ON insurverse.tqm_car_mapping USING btree (model_code)`
- `idx_tqm_car_mapping_vehicle_type`: `CREATE INDEX idx_tqm_car_mapping_vehicle_type ON insurverse.tqm_car_mapping USING btree (vehicle_type)`
- `tqm_car_mapping_pkey`: `CREATE UNIQUE INDEX tqm_car_mapping_pkey ON insurverse.tqm_car_mapping USING btree (id)`

**Triggers:** `update_tqm_car_mapping_updated_at` → `insurverse.update_updated_at_column()`

---

## tqm_cargroup

`insurverse.tqm_cargroup` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | character varying(255) | NO |  |  |
| 2 | `is_deleted` | boolean | YES |  |  |
| 3 | `create_by` | character varying(255) | YES |  |  |
| 4 | `create_date` | timestamp without time zone | YES |  |  |
| 5 | `update_by` | character varying(255) | YES |  |  |
| 6 | `update_date` | timestamp without time zone | YES |  |  |
| 7 | `car_group_code` | character varying(50) | YES |  |  |
| 8 | `car_group_name` | character varying(255) | YES |  |  |
| 9 | `is_active` | boolean | YES |  |  |
| 10 | `remark` | text | YES |  |  |
| 11 | `row_number` | bigint | YES |  |  |

**Primary key:** _none_

---

## tqm_district

`insurverse.tqm_district` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `province_code` | character varying(3) | NO |  |  |
| 2 | `district_code` | character varying(3) | NO |  |  |
| 3 | `district_name` | character varying(100) | NO |  |  |
| 4 | `full_code` | character varying(6) | NO |  |  |
| 5 | `district_id` | integer | YES |  |  |

**Primary key:** `full_code` (tqm_district_pk)

**Inferred references (naming convention, NOT enforced FK):** `district_id` → district

**Indexes:**

- `tqm_district_pk`: `CREATE UNIQUE INDEX tqm_district_pk ON insurverse.tqm_district USING btree (full_code)`

---

## tqm_endorse_document_status

`insurverse.tqm_endorse_document_status` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `endorse_detail_id` | integer | NO |  |  |
| 2 | `status` | character varying(50) | NO |  | - "SUCCESS"- "INSPECTED" - "WAITING_DOCUMENT" - "WAITING_CMI" - "DOCUMENTED" - "DATA_PROBLEM" - "INSPECTION_PROBLEM" - "REJECTED" - "SUCCESS" |
| 3 | `created_at` | timestamp without time zone | YES | `now()` |  |
| 4 | `updated_at` | timestamp without time zone | YES |  |  |

**Primary key:** `endorse_detail_id` (tqm_request_status_copy1_pkey)

**Indexes:**

- `tqm_request_status_copy1_pkey`: `CREATE UNIQUE INDEX tqm_request_status_copy1_pkey ON insurverse.tqm_endorse_document_status USING btree (endorse_detail_id)`

---

## tqm_group_premium

`insurverse.tqm_group_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `level_name` | character varying(100) | NO |  |  |
| 3 | `repair_type` | character varying(100) | NO |  |  |
| 4 | `group_code` | character varying(50) | NO |  |  |
| 5 | `package_code` | character varying(50) | NO |  |  |
| 6 | `car_year_min` | integer | NO |  |  |
| 7 | `car_year_max` | integer | NO |  |  |
| 8 | `brand` | character varying(50) | NO |  |  |
| 9 | `model` | character varying(100) | NO |  |  |
| 10 | `created_at` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 11 | `updated_at` | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |  |
| 12 | `created_by` | character varying(50) | YES |  |  |
| 13 | `updated_by` | character varying(50) | YES |  |  |
| 14 | `is_vehicle_need_inspection` | boolean | YES |  |  |

**Primary key:** `id` (tqm_group_premium_pkey)

**Inferred references (naming convention, NOT enforced FK):** `group_code` → sec_group

**Constraints:**

- UNIQUE `unique_group_package_brand_model`: `UNIQUE (group_code, package_code, brand, model)`

**Indexes:**

- `tqm_group_premium_brand_model_index`: `CREATE INDEX tqm_group_premium_brand_model_index ON insurverse.tqm_group_premium USING btree (brand, model)`
- `tqm_group_premium_group_code_index`: `CREATE INDEX tqm_group_premium_group_code_index ON insurverse.tqm_group_premium USING btree (group_code)`
- `tqm_group_premium_package_code_index`: `CREATE INDEX tqm_group_premium_package_code_index ON insurverse.tqm_group_premium USING btree (package_code)`
- `tqm_group_premium_pkey`: `CREATE UNIQUE INDEX tqm_group_premium_pkey ON insurverse.tqm_group_premium USING btree (id)`
- `unique_group_package_brand_model`: `CREATE UNIQUE INDEX unique_group_package_brand_model ON insurverse.tqm_group_premium USING btree (group_code, package_code, brand, model)`

---

## tqm_lead_cmi

`insurverse.tqm_lead_cmi` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `insurance_company_code` | character(3) | YES |  |  |
| 2 | `policy_number` | character varying(40) | YES |  |  |
| 3 | `code_tqm` | character varying(10) | YES |  |  |
| 4 | `insure_prefix` | character varying(30) | YES |  |  |
| 5 | `insure_name` | character varying(100) | YES |  |  |
| 6 | `insure_surname` | character varying(50) | YES |  |  |
| 7 | `corp_status` | character varying(10) | YES |  |  |
| 8 | `citizen_id` | character varying(13) | YES |  |  |
| 9 | `insure_branch` | character varying(10) | YES |  |  |
| 10 | `address_no` | character varying(30) | YES |  |  |
| 11 | `address_group` | character varying(50) | YES |  |  |
| 12 | `address_building` | character varying(50) | YES |  |  |
| 13 | `address_path` | character varying(50) | YES |  |  |
| 14 | `address_by_street` | character varying(50) | YES |  |  |
| 15 | `address_street` | character varying(50) | YES |  |  |
| 16 | `address_area` | character varying(50) | YES |  |  |
| 17 | `district` | character varying(50) | YES |  |  |
| 18 | `district_type` | character varying(50) | YES |  |  |
| 19 | `province_name` | character varying(25) | YES |  |  |
| 20 | `zip_code` | character varying(5) | YES |  |  |
| 21 | `policy_date` | character varying(10) | YES |  |  |
| 22 | `policy_start_time` | character varying(6) | YES |  |  |
| 23 | `expiry_date` | character varying(10) | NO |  |  |
| 24 | `car_usage` | character varying(10) | YES |  |  |
| 25 | `get_car_brand` | character varying(15) | YES |  |  |
| 26 | `car_model` | character varying(55) | YES |  |  |
| 27 | `byte_des_eng` | character varying(15) | YES |  |  |
| 28 | `car_seat` | numeric(2,0) | YES |  |  |
| 29 | `car_cc` | numeric(6,0) | YES |  |  |
| 30 | `car_weight` | numeric(6,0) | YES |  |  |
| 31 | `plate_id` | character varying(8) | YES |  |  |
| 32 | `province_abb` | character varying(10) | YES |  |  |
| 33 | `chasis_id` | character varying(30) | YES |  |  |
| 34 | `engine_id` | character varying(30) | YES |  |  |
| 35 | `receipt_year` | character varying(2) | YES |  |  |
| 36 | `receipt_no` | character varying(13) | YES |  |  |
| 37 | `symbol_year` | character varying(10) | YES |  |  |
| 38 | `serial_number` | character varying(13) | NO |  |  |
| 39 | `contract_date` | character varying(10) | YES |  |  |
| 40 | `policy_issue_date` | character varying(10) | YES |  |  |
| 41 | `cover_per_person` | numeric(15,2) | YES |  |  |
| 42 | `cover_per_time` | numeric(15,2) | YES |  |  |
| 43 | `cover_per_body` | numeric(15,2) | YES |  |  |
| 44 | `cover_per_life` | numeric(15,2) | YES |  |  |
| 45 | `amount` | numeric(15,2) | YES |  |  |
| 46 | `vat` | numeric(15,2) | YES |  |  |
| 47 | `duty` | numeric(15,2) | YES |  |  |
| 48 | `net_amount` | numeric(15,2) | YES |  |  |
| 49 | `insure_period` | character varying(10) | YES |  |  |
| 50 | `insure_type` | character varying(10) | YES |  |  |
| 51 | `reference_id` | character varying(20) | NO |  |  |
| 52 | `car_year` | character varying(4) | YES |  |  |
| 53 | `birth_date` | character varying(10) | YES |  |  |
| 54 | `supplier_date` | character varying(10) | NO |  |  |
| 55 | `book_no` | character varying(25) | NO |  |  |
| 56 | `invoice_no` | character varying(25) | NO |  |  |
| 57 | `quotation_no` | character varying(25) | NO |  |  |
| 58 | `issue_date` | character varying(10) | YES |  |  |

**Primary key:** `reference_id` (tqm_lead_cmi_pkey)

**Indexes:**

- `tqm_lead_cmi_pkey`: `CREATE UNIQUE INDEX tqm_lead_cmi_pkey ON insurverse.tqm_lead_cmi USING btree (reference_id)`

---

## tqm_lead_vmi

`insurverse.tqm_lead_vmi` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `sale_book_code` | character varying(15) | NO |  |  |
| 2 | `code_tqm` | character varying(10) | YES |  |  |
| 3 | `serial_number` | character varying(40) | YES |  |  |
| 4 | `renew_old_policy_id` | character varying(40) | YES |  |  |
| 5 | `sale_type` | character varying(1) | YES |  |  |
| 6 | `corp_status` | character varying(1) | YES |  |  |
| 7 | `insure_prefix` | character varying(30) | YES |  |  |
| 8 | `insure_name` | character varying(100) | YES |  |  |
| 9 | `insure_surname` | character varying(50) | YES |  |  |
| 10 | `citizen_id` | character varying(30) | YES |  |  |
| 11 | `birth_date` | date | YES |  |  |
| 12 | `age` | numeric(3,0) | YES |  |  |
| 13 | `occupation_id` | character varying(2) | YES |  |  |
| 14 | `job_name` | character varying(30) | YES |  |  |
| 15 | `customer_citizen_id` | character varying(30) | YES |  |  |
| 16 | `address_no` | character varying(30) | YES |  |  |
| 17 | `address_group` | character varying(30) | YES |  |  |
| 18 | `address_building` | character varying(50) | YES |  |  |
| 19 | `address_path` | character varying(50) | YES |  |  |
| 20 | `address_by_street` | character varying(50) | YES |  |  |
| 21 | `address_street` | character varying(50) | YES |  |  |
| 22 | `address_area` | character varying(50) | YES |  |  |
| 23 | `district` | character varying(50) | YES |  |  |
| 24 | `district_type` | character varying(50) | YES |  |  |
| 25 | `province_name` | character varying(25) | YES |  |  |
| 26 | `zip_code` | character varying(5) | YES |  |  |
| 27 | `nominee_prefix_nominee` | character varying(250) | YES |  |  |
| 28 | `policy_date` | date | NO |  |  |
| 29 | `expiry_date` | date | NO |  |  |
| 30 | `contract_supplier_date` | date | YES |  |  |
| 31 | `is_printed` | character varying(1) | YES |  |  |
| 32 | `supplier_date` | date | YES |  |  |
| 33 | `previous_insurance_company` | character varying(100) | YES |  |  |
| 34 | `old_policy_id` | character varying(40) | YES |  |  |
| 35 | `insure_level_code` | character varying(2) | YES |  |  |
| 36 | `insure_level_name` | character varying(10) | YES |  |  |
| 37 | `insure_level_type` | character varying(10) | YES |  |  |
| 38 | `package` | character varying(50) | YES |  |  |
| 39 | `car_usage` | character varying(10) | YES |  |  |
| 40 | `car_brand` | character varying(15) | YES |  |  |
| 41 | `car_model` | character varying(55) | YES |  |  |
| 42 | `body_type` | character varying(20) | YES |  |  |
| 43 | `car_color` | character varying(15) | YES |  |  |
| 44 | `plate_id` | character varying(8) | YES |  |  |
| 45 | `province_abb` | character varying(2) | YES |  |  |
| 46 | `chasis_id` | character varying(30) | YES |  |  |
| 47 | `engine_id` | character varying(30) | YES |  |  |
| 48 | `car_year` | character varying(4) | YES |  |  |
| 49 | `car_seat` | numeric(2,0) | YES |  |  |
| 50 | `car_cc` | numeric(6,0) | YES |  |  |
| 51 | `car_weight` | numeric(6,0) | YES |  |  |
| 52 | `car_gear` | character varying(1) | YES |  |  |
| 53 | `car_group` | character varying(1) | YES |  |  |
| 54 | `car_age` | numeric(2,0) | YES |  |  |
| 55 | `car_option_1` | character varying(1) | YES |  |  |
| 56 | `car_option_other` | text | YES |  |  |
| 57 | `car_option_value_more` | numeric(15,2) | YES |  |  |
| 58 | `car_option_flag` | character varying(1) | YES |  |  |
| 59 | `car_option` | text | YES |  |  |
| 60 | `car_option_value` | numeric(15,2) | YES |  |  |
| 61 | `driver_flag` | character varying(1) | YES |  |  |
| 62 | `driver_1_prefix` | character varying(30) | YES |  |  |
| 63 | `driver_1_name` | character varying(40) | YES |  |  |
| 64 | `driver_1_surname` | character varying(30) | YES |  |  |
| 65 | `driver_1_birth_date` | date | YES |  |  |
| 66 | `driver_1_age` | numeric(3,0) | YES |  |  |
| 67 | `driver_1_license_id` | character varying(17) | YES |  |  |
| 68 | `driver_1_license_type` | character varying(1) | YES |  |  |
| 69 | `driver_1_license_date` | date | YES |  |  |
| 70 | `driver_1_license_issue` | character varying(25) | YES |  |  |
| 71 | `driver_1_license_expiry` | date | YES |  |  |
| 72 | `driver_2_prefix` | character varying(30) | YES |  |  |
| 73 | `driver_2_name` | character varying(40) | YES |  |  |
| 74 | `driver_2_surname` | character varying(30) | YES |  |  |
| 75 | `driver_2_birth_date` | date | YES |  |  |
| 76 | `driver_2_age` | numeric(3,0) | YES |  |  |
| 77 | `driver_2_license_id` | character varying(17) | YES |  |  |
| 78 | `driver_2_license_type` | character varying(1) | YES |  |  |
| 79 | `driver_2_license_date` | date | YES |  |  |
| 80 | `driver_2_license_issue` | character varying(25) | YES |  |  |
| 81 | `driver_2_license_expiry` | date | YES |  |  |
| 82 | `cover` | numeric(15,2) | YES |  |  |
| 83 | `cover_deduct_2` | numeric(15,2) | YES |  |  |
| 84 | `car_lost_cover_ext` | numeric(15,2) | YES |  |  |
| 85 | `fire_car_cover_ext` | numeric(15,2) | YES |  |  |
| 86 | `cover_v3rd` | numeric(15,2) | YES |  |  |
| 87 | `cover_v3rd_time` | numeric(15,2) | YES |  |  |
| 88 | `cover_v3rd_asset` | numeric(15,2) | YES |  |  |
| 89 | `cover_deduct_1` | numeric(15,2) | YES |  |  |
| 90 | `cover_driver_count` | numeric(2,0) | YES |  |  |
| 91 | `cover_passenger` | numeric(3,0) | YES |  |  |
| 92 | `cover_accd` | numeric(15,2) | YES |  |  |
| 93 | `cover_medd` | numeric(15,2) | YES |  |  |
| 94 | `cover_legal` | numeric(15,2) | YES |  |  |
| 95 | `standard_premium` | numeric(15,2) | YES |  |  |
| 96 | `amt_mv` | numeric(15,2) | YES |  |  |
| 97 | `fleet_disc_perc` | numeric(6,2) | YES |  |  |
| 98 | `fleet_disc_amt` | numeric(15,2) | YES |  |  |
| 99 | `ncb_disc_perc` | numeric(6,2) | YES |  |  |
| 100 | `ncb_disc_amt` | numeric(15,2) | YES |  |  |
| 101 | `other_disc_perc` | numeric(6,2) | YES |  |  |
| 102 | `other_disc_amt` | numeric(15,2) | YES |  |  |
| 103 | `amount` | numeric(15,2) | YES |  | เบี้ยสุทธิ |
| 104 | `vat` | numeric(15,2) | YES |  |  |
| 105 | `duty` | numeric(15,2) | YES |  |  |
| 106 | `net_amount` | numeric(15,2) | YES |  | เบี่ยรวม |
| 107 | `tax_address_prefix` | character varying(30) | YES |  |  |
| 108 | `tax_address_name` | character varying(100) | YES |  |  |
| 109 | `tax_address_surname` | character varying(50) | YES |  |  |
| 110 | `tax_address_no` | character varying(30) | YES |  |  |
| 111 | `tax_address_group` | character varying(5) | YES |  |  |
| 112 | `tax_address_building` | character varying(50) | YES |  |  |
| 113 | `tax_address_path` | character varying(50) | YES |  |  |
| 114 | `tax_address_by_street` | character varying(50) | YES |  |  |
| 115 | `tax_address_street` | character varying(50) | YES |  |  |
| 116 | `tax_address_area` | character varying(50) | YES |  |  |
| 117 | `tax_district` | character varying(50) | YES |  |  |
| 118 | `tax_district_type` | character varying(50) | YES |  |  |
| 119 | `tax_province_name` | character varying(25) | YES |  |  |
| 120 | `tax_zip_code` | character varying(5) | YES |  |  |
| 121 | `check_holiday_lmg` | date | YES |  |  |
| 122 | `invoice_number` | character varying(15) | YES |  |  |
| 123 | `byte_des` | character varying(50) | YES |  |  |
| 124 | `department_code` | character varying(10) | YES |  |  |
| 125 | `take_photo_branch` | character varying(50) | YES |  |  |
| 126 | `phone` | character varying(250) | YES |  |  |
| 127 | `policy_number` | character varying(40) | YES |  |  |
| 128 | `charger_cover` | numeric(15,2) | YES |  |  |
| 129 | `charger_number` | character varying(16) | YES |  |  |
| 130 | `charger_price` | numeric(15,2) | YES |  |  |
| 131 | `charger_brand` | character varying(32) | YES |  |  |
| 132 | `charger_model` | character varying(32) | YES |  |  |
| 133 | `charger_remark` | character varying(100) | YES |  |  |
| 134 | `battery_number` | character varying(16) | YES |  |  |
| 135 | `battery_price` | numeric(15,2) | YES |  |  |
| 136 | `battery_brand` | character varying(32) | YES |  |  |
| 137 | `battery_model` | character varying(32) | YES |  |  |
| 138 | `battery_date` | date | YES |  |  |
| 139 | `battery_remark` | character varying(100) | YES |  |  |
| 140 | `car_price` | numeric(15,2) | YES |  |  |
| 141 | `car_hp` | numeric(15,0) | YES |  |  |
| 142 | `driver_prefix_1` | character varying(30) | YES |  |  |
| 143 | `driver_name_1` | character varying(30) | YES |  |  |
| 144 | `driver_surname_1` | character varying(40) | YES |  |  |
| 145 | `driver_birth_date_1` | date | YES |  |  |
| 146 | `driver_gender_1` | character varying(1) | YES |  |  |
| 147 | `driver_citizen_id_1` | character varying(32) | YES |  |  |
| 148 | `driver_license_id_1` | character varying(32) | YES |  |  |
| 149 | `driver_occupation_1` | character varying(32) | YES |  |  |
| 150 | `driver_prefix_2` | character varying(30) | YES |  |  |
| 151 | `driver_name_2` | character varying(30) | YES |  |  |
| 152 | `driver_surname_2` | character varying(40) | YES |  |  |
| 153 | `driver_birth_date_2` | date | YES |  |  |
| 154 | `driver_gender_2` | character varying(1) | YES |  |  |
| 155 | `driver_citizen_id_2` | character varying(32) | YES |  |  |
| 156 | `driver_license_id_2` | character varying(32) | YES |  |  |
| 157 | `driver_occupation_2` | character varying(32) | YES |  |  |
| 158 | `driver_prefix_3` | character varying(30) | YES |  |  |
| 159 | `driver_name_3` | character varying(30) | YES |  |  |
| 160 | `driver_surname_3` | character varying(40) | YES |  |  |
| 161 | `driver_birth_date_3` | date | YES |  |  |
| 162 | `driver_gender_3` | character varying(1) | YES |  |  |
| 163 | `driver_citizen_id_3` | character varying(32) | YES |  |  |
| 164 | `driver_license_id_3` | character varying(32) | YES |  |  |
| 165 | `driver_occupation_3` | character varying(32) | YES |  |  |
| 166 | `driver_prefix_4` | character varying(30) | YES |  |  |
| 167 | `driver_name_4` | character varying(30) | YES |  |  |
| 168 | `driver_surname_4` | character varying(40) | YES |  |  |
| 169 | `driver_birth_date_4` | date | YES |  |  |
| 170 | `driver_gender_4` | character varying(1) | YES |  |  |
| 171 | `driver_citizen_id_4` | character varying(32) | YES |  |  |
| 172 | `driver_license_id_4` | character varying(32) | YES |  |  |
| 173 | `driver_occupation_4` | character varying(32) | YES |  |  |
| 174 | `driver_prefix_5` | character varying(30) | YES |  |  |
| 175 | `driver_name_5` | character varying(30) | YES |  |  |
| 176 | `driver_surname_5` | character varying(40) | YES |  |  |
| 177 | `driver_birth_date_5` | date | YES |  |  |
| 178 | `driver_gender_5` | character varying(1) | YES |  |  |
| 179 | `driver_citizen_id_5` | character varying(32) | YES |  |  |
| 180 | `driver_license_id_5` | character varying(32) | YES |  |  |
| 181 | `driver_occupation_5` | character varying(32) | YES |  |  |
| 182 | `access_para_code` | character varying(100) | YES |  |  |
| 183 | `car_option_not_covered` | character varying(100) | YES |  |  |

**Primary key:** `sale_book_code` (tqm_lead_vmi_pk)

**Indexes:**

- `tqm_lead_vmi_pk`: `CREATE UNIQUE INDEX tqm_lead_vmi_pk ON insurverse.tqm_lead_vmi USING btree (sale_book_code)`

---

## tqm_notification_job

`insurverse.tqm_notification_job` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `sale_book_code` | character varying(20) | NO |  |  |
| 2 | `policy_type` | character varying(10) | YES |  |  |
| 3 | `type` | character varying(30) | YES |  |  |
| 4 | `notify_status` | character varying(20) | YES |  |  |
| 5 | `detail` | character varying(5000) | YES |  |  |
| 6 | `created_date` | timestamp with time zone | YES | `now()` |  |
| 7 | `updated_date` | timestamp with time zone | YES |  |  |

**Primary key:** `sale_book_code` (tqm_notification_job_pk)

**Indexes:**

- `tqm_notification_job_pk`: `CREATE UNIQUE INDEX tqm_notification_job_pk ON insurverse.tqm_notification_job USING btree (sale_book_code)`

---

## tqm_package_config

`insurverse.tqm_package_config` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `package_id` | character varying(255) | NO |  |  |
| 2 | `package_code` | character varying(50) | YES |  |  |
| 3 | `is_vehicle_need_inspection` | boolean | YES |  |  |
| 4 | `create_by` | character varying(255) | YES |  |  |
| 5 | `create_date` | timestamp without time zone | YES |  |  |
| 6 | `update_by` | character varying(255) | YES |  |  |
| 7 | `update_date` | timestamp without time zone | YES |  |  |
| 8 | `repair_type` | character varying(20) | YES |  |  |
| 9 | `start_date` | date | YES |  |  |
| 10 | `end_date` | date | YES |  |  |

**Primary key:** `package_id` (tqm_package_config_pk)

**Indexes:**

- `tqm_package_config_pk`: `CREATE UNIQUE INDEX tqm_package_config_pk ON insurverse.tqm_package_config USING btree (package_id)`

---

## tqm_premium

`insurverse.tqm_premium` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO |  |  |
| 2 | `iia_mv_package_id` | integer | YES |  |  |
| 3 | `car_participant` | integer | YES |  |  |
| 4 | `group` | character varying(50) | YES |  |  |
| 5 | `package` | character varying(50) | YES |  |  |
| 6 | `cc` | character varying(50) | YES |  |  |
| 7 | `year` | integer | YES |  |  |
| 8 | `si` | numeric | YES |  |  |
| 9 | `basic_premium` | numeric | YES |  |  |
| 10 | `tariff_usage` | numeric | YES |  |  |
| 11 | `tariff_size` | numeric | YES |  |  |
| 12 | `tariff_age` | numeric | YES |  |  |
| 13 | `tariff_si` | numeric | YES |  |  |
| 14 | `tariff_group` | numeric | YES |  |  |
| 15 | `tpbi_p` | numeric | YES |  |  |
| 16 | `tppd` | numeric | YES |  |  |
| 17 | `tpbi_e` | numeric | YES |  |  |
| 18 | `total_amt_exclude_mv` | numeric | YES |  |  |
| 19 | `mv_01` | numeric | YES |  |  |
| 20 | `mv_02` | numeric | YES |  |  |
| 21 | `mv_03` | numeric | YES |  |  |
| 22 | `si_mv_01` | numeric | YES |  |  |
| 23 | `si_mv_02` | numeric | YES |  |  |
| 24 | `si_mv_03` | numeric | YES |  |  |
| 25 | `total_amt_mv` | numeric | YES |  |  |
| 26 | `before_discount_amt` | numeric | YES |  |  |
| 27 | `fleet_disc_perc` | numeric | YES |  |  |
| 28 | `fleet_disc_amt` | numeric | YES |  |  |
| 29 | `ncb_disc_perc` | numeric | YES |  |  |
| 30 | `ncb_disc_amt` | numeric | YES |  |  |
| 31 | `other_disc_perc` | numeric | YES |  |  |
| 32 | `other_disc_amt` | numeric | YES |  |  |
| 33 | `perm_amt` | numeric | YES |  |  |
| 34 | `duty_amt` | numeric | YES |  |  |
| 35 | `vat_amt` | numeric | YES |  |  |
| 36 | `total_amt` | numeric | YES |  |  |
| 37 | `deduct` | numeric | YES |  |  |
| 38 | `sc_premium_amt` | numeric | YES |  |  |

**Primary key:** `id` (tqm_premium_pkey)

**Constraints:**

- UNIQUE `uq_group_package_si`: `UNIQUE ("group", package, year, si, cc)`

**Indexes:**

- `tqm_premium_pkey`: `CREATE UNIQUE INDEX tqm_premium_pkey ON insurverse.tqm_premium USING btree (id)`
- `uq_group_package_si`: `CREATE UNIQUE INDEX uq_group_package_si ON insurverse.tqm_premium USING btree ("group", package, year, si, cc)`

---

## tqm_province

`insurverse.tqm_province` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `province_code` | character varying(3) | NO |  |  |
| 2 | `province_name` | character varying(100) | NO |  |  |
| 3 | `province_id` | integer | NO |  |  |

**Primary key:** `province_code` (tqm_province_pkey)

**Inferred references (naming convention, NOT enforced FK):** `province_id` → province

**Indexes:**

- `tqm_province_pkey`: `CREATE UNIQUE INDEX tqm_province_pkey ON insurverse.tqm_province USING btree (province_code)`

---

## tqm_request_status

`insurverse.tqm_request_status` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `sale_book_code` | character varying(100) | NO |  |  |
| 2 | `type` | character varying(50) | NO |  |  |
| 3 | `insurance_type` | character varying(50) | NO |  | CMI,VMI |
| 4 | `status` | character varying(50) | NO |  |  - "WAITING_INSPECTION" - "INSPECTED" - "WAITING_DOCUMENT" - "WAITING_CMI" - "DOCUMENTED" - "DATA_PROBLEM" - "INSPECTION_PROBLEM" - "REJECTED" - "SUCCESS" |
| 5 | `update_dt` | timestamp without time zone | YES | `now()` |  |

**Primary key:** `sale_book_code,insurance_type` (tqm_request_status_pkey)

**Indexes:**

- `tqm_request_status_pkey`: `CREATE UNIQUE INDEX tqm_request_status_pkey ON insurverse.tqm_request_status USING btree (sale_book_code, insurance_type)`

---

## tqm_salutation

`insurverse.tqm_salutation` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `code` | character varying(8) | NO |  |  |
| 2 | `prefix` | character varying(64) | NO |  |  |

**Primary key:** `code` (tqm_salutation_pkey)

**Indexes:**

- `tqm_salutation_pkey`: `CREATE UNIQUE INDEX tqm_salutation_pkey ON insurverse.tqm_salutation USING btree (code)`

---

## tqm_sub_district

`insurverse.tqm_sub_district` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `province_code` | character varying(3) | NO |  |  |
| 2 | `district_code` | character varying(3) | NO |  |  |
| 3 | `subdistrict_code` | character varying(10) | NO |  |  |
| 4 | `subdistrict_name` | character varying(100) | NO |  |  |
| 5 | `subdistrict_id` | integer | YES |  |  |

**Primary key:** `subdistrict_code` (tqm_sub_district_pk)

**Inferred references (naming convention, NOT enforced FK):** `subdistrict_id` → subdistrict

**Indexes:**

- `tqm_sub_district_pk`: `CREATE UNIQUE INDEX tqm_sub_district_pk ON insurverse.tqm_sub_district USING btree (subdistrict_code)`

---

## user_confirm

`insurverse.user_confirm` · kind: table · est. rows: **0**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `id` | integer | NO | `nextval('insurverse.user_confirm_id_seq'::regclass)` |  |
| 2 | `customer_id` | uuid | NO |  |  |
| 3 | `active` | boolean | YES | `false` |  |
| 4 | `type` | character varying | YES |  |  |
| 5 | `ref_id` | character varying | YES |  |  |
| 6 | `updated_at` | timestamp without time zone | YES |  |  |
| 7 | `created_at` | timestamp without time zone | YES |  |  |
| 8 | `expired_at` | timestamp without time zone | YES |  |  |
| 9 | `otp` | character varying(6) | YES |  |  |

**Primary key:** `id` (user_confirm_pkey)

**Indexes:**

- `user_confirm_pkey`: `CREATE UNIQUE INDEX user_confirm_pkey ON insurverse.user_confirm USING btree (id)`

---

## zipcode

`insurverse.zipcode` · kind: table · est. rows: **7,470**

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `zipcode_id` | integer | NO | `nextval('insurverse.zipcode_zipcode_id_seq'::regclass)` |  |
| 2 | `provinceid` | integer | NO |  |  |
| 3 | `districtid` | integer | NO |  |  |
| 4 | `subdistrictid` | integer | NO |  |  |
| 5 | `zcno` | character(5) | NO |  |  |

**Primary key:** `zipcode_id` (zipcode_pkey)

**Inferred references (naming convention, NOT enforced FK):** `districtid` → district, `provinceid` → province, `subdistrictid` → subdistrict

**Indexes:**

- `zipcode_pkey`: `CREATE UNIQUE INDEX zipcode_pkey ON insurverse.zipcode USING btree (zipcode_id)`

---

## zipcode_12sep67

`insurverse.zipcode_12sep67` · kind: table · est. rows: **7,468** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `zipcode_id` | integer | YES |  |  |
| 2 | `provinceid` | integer | YES |  |  |
| 3 | `districtid` | integer | YES |  |  |
| 4 | `subdistrictid` | integer | YES |  |  |
| 5 | `zcno` | bpchar | YES |  |  |

**Primary key:** _none_

---

## zipcode_add

`insurverse.zipcode_add` · kind: table · est. rows: **22,288** · *(snapshot/backup copy?)*

| # | Column | Type | Null | Default | Comment |
|---|---|---|---|---|---|
| 1 | `zipcode_id` | integer | YES |  |  |
| 2 | `provinceid` | integer | YES |  |  |
| 3 | `districtid` | integer | YES |  |  |
| 4 | `subdistrictid` | integer | YES |  |  |
| 5 | `zcno` | bpchar | YES |  |  |

**Primary key:** _none_
