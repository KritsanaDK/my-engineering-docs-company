# P1 — DB schema comparison: Prod dump (2026-09-24) vs UAT-ISV live (2026-09-28)

Read-only. UAT-ISV extracted with SELECT-only catalog queries (search_path empty → schema-qualified like pg_dump), written in the same layout/format as `prod/` to `scratchpad/uatisv_schema/`. Scope: schema `insurverse`, excluding extension-owned functions.

Method: functions rebuilt pg_dump-style (`pg_get_function_arguments/result`, attributes, `prosrc`, pg_dump dollar-quote rule) → header + body compared after normalisation (CRLF→LF, rtrim, drop `--`/OWNER/GRANT lines); 87/88 matching functions are also byte-identical after rtrim. Views = `pg_get_viewdef`, triggers = `pg_get_triggerdef` (byte-identical where same). Tables compared structurally: column type (`format_type`), NOT NULL, default, identity, constraints (`pg_get_constraintdef`, whitespace-normalised), non-constraint indexes (`pg_get_indexdef`). Sequences: existence + type/start/increment/min/max/cache/cycle (current values ignored). Prod sequences = unowned `sequences/*.sql` + identity + `CREATE SEQUENCE` inside `tables/*.sql`.

## 1. Summary

| Category | Prod | UAT-ISV | Same | Different | Only Prod | Only UAT-ISV |
|---|---|---|---|---|---|---|
| Tables | 252 | 302 | 138 | 114 (98 = timestamp/time precision only; 16 with other diffs) | 0 | 50 |
| functions+procedures | 92 | 132 | 88 | 4 | 0 | 40 |
| views | 2 | 2 | 1 | 1 | 0 | 0 |
| triggers | 4 | 5 | 4 | 0 | 0 | 1 |
| types | 1 | 1 | 1 | 0 | 0 | 0 |
| sequences (existence+definition) | 102 | 114 | 47 | 55 | 0 | 12 |

(`policy_cache_new` is a zero-column table on both sides; counted as Same.)

### Confirmation of 2026-09-24 replacements

`fn_policy_to_car_act`, `fn_policy_quatationno_iia`, `fn_policy_renewal` (now 3 args, like Prod) — **identical to Prod** (byte-identical after rtrim). Also identical: `fn_lead_to_car_act(bigint)` (normalised; only dollar-tag spelling differs in raw export), `fn_lead_to_car_act(integer)`, `fn_policy_invoiceno_iia`, `fn_policy_invoiceno_iia_type`.

## 2. Different functions / views / triggers

| Object | Kind | What differs | Behaviour? |
|---|---|---|---|
| `fn_address_clean_dist.sql` | function | UAT body has an extra blank line after every line (CRLF-style double newlines). `diff -w -B` = empty → **cosmetic**. | No |
| `fn_policy_endorse_coverage.text_text_text_text_text_text_text.sql` | function | (7-text-arg overload) one line indentation (`RTN_JSON = …` has an extra leading space). **cosmetic**. | No |
| `fn_policy_my_policy_search.sql` | function | 1584 lines re-indented (tabs/spaces); `diff -w -B` = empty → **cosmetic**. | No |
| `fn_update_promo_active.sql` | function | DECLARE block indentation only (70 lines); `diff -w -B` = empty → **cosmetic**. | No |
| `v_lead_policy_product` | view | CTE `latest_payment` (DISTINCT ON lead_no): Prod orders `payment.lead_no, CASE WHEN upper(payment_status)='SUCCESS' THEN 0 ELSE 1 END, created_at DESC, id DESC`; UAT-ISV only `lead_no, created_at DESC`. | **Yes** — Prod prefers the SUCCESS payment (deterministic tie-break on id); UAT-ISV picks the newest payment even if failed/pending. |

Triggers: all 4 Prod triggers identical. Types: `consent_accept_status_enum` identical.

## 3. Tables — differences other than precision

98 tables differ **only** by `timestamp(6)`/`timestamptz(6)`/`time(6)` on Prod vs no typmod on UAT-ISV (393 columns; UAT-ISV has 699 timestamp cols without typmod). Default precision is 6 anyway → **no behaviour change**.

| Table | Differences (Prod → UAT-ISV) |
|---|---|
| `Imp_Discount_Premium` | col `coverage_years` only in uat-isv (smallint) |
| `Lead_coverage_premium` | col `Lead_No` default None -> nextval('insurverse.seq_lead_no'::regclass) |
| `Policy_Car_Act_Discount_Premium` | index `idx_pcadp_car_act_lead_no` missing on uat-isv |
| `Policy_Header` | col `Effective_Startdate` type timestamp(0) without time zone -> timestamp without time zone; col `Effective_Enddate` type timestamp(0) without time zone -> timestamp without time zone |
| `Policy_Header_Trans` | col `Effective_Startdate` type timestamp(0) without time zone -> timestamp without time zone; col `Effective_Enddate` type timestamp(0) without time zone -> timestamp without time zone |
| `Policy_coverage_premium` | col `first_name` only in uat-isv (character varying(255)); col `last_name` only in uat-isv (character varying(255)); col `email` only in uat-isv (character varying(255)); col `phone` only in uat-isv (character varying(255)); col `Policy_book` only in uat-isv (character varying(255)); col `Policy_Quatation_No` only in uat-isv (character varying(255)); col `Policy_Invoice_No` only in uat-isv (character varying(255)); col `ref_policy_no` only in uat-isv (character varying(255)); col `renewal_mc_startdate` only in uat-isv (timestamp without time zone); col `renewal_mc_enddate` only in uat-isv (timestamp without time zone) |
| `consent_accept` | index `IDX_consent_accept_identifier` only in uat-isv |
| `email_logs` | constraint `email_logs_status_check` def differs |
| `email_webhooks` | constraint `email_webhooks_status_check` def differs |
| `iia_commission` | col `id` default nextval('insurverse.iia_commission_id_seq'::regclass) -> None |
| `sec_user` | index `idx_sec_user_email_unique` only in uat-isv |
| `shopee_product_form` | col `category` NOT NULL True -> False; col `category` default ''::character varying -> None; col `claim_price` NOT NULL True -> False; col `claim_price` default 0 -> None; col `price` NOT NULL True -> False; col `price` default 0 -> None; col `discount` NOT NULL True -> False; col `discount` default 0 -> None; col `listing_test` NOT NULL True -> False; col `listing_test` default false -> None; col `link_test` NOT NULL True -> False; col `link_test` default ''::character varying -> None; col `link` NOT NULL True -> False; col `link` default ''::character varying -> None; col `status` NOT NULL True -> False; col `status` default 'active'::character varying -> None; col `sms_temp` NOT NULL True -> False; col `sms_temp` default ''::text -> None |
| `tqm_car_mapping` | col `id` default nextval('insurverse.tqm_car_mapping_id_seq'::regclass) -> None |
| `tqm_group_premium` | col `id` default nextval('insurverse.tqm_group_premium_id_seq'::regclass) -> None |
| `tqm_package_config` | col `start_date` only in uat-isv (date); col `end_date` only in uat-isv (date) |
| `tqm_premium` | col `id` default nextval('insurverse.tqm_premium_id_seq'::regclass) -> None |

Notes: `timestamp(0)` → `timestamp` on `Policy_Header`/`Policy_Header_Trans`.`Effective_Start/Enddate` is a real difference (Prod rounds to seconds). `email_logs_status_check`/`email_webhooks_status_check` differ only in cast spelling (`ARRAY[...]::text[]` vs per-element casts) — same allowed values, cosmetic. `Lead_coverage_premium.Lead_No` has `DEFAULT nextval(seq_lead_no)` only on UAT-ISV. `iia_commission.id`, `tqm_car_mapping.id`, `tqm_group_premium.id`, `tqm_premium.id` lack the Prod `nextval` default on UAT-ISV (inserts without id would fail there). `shopee_product_form` lacks 9 NOT NULL + defaults. Index `idx_pcadp_car_act_lead_no` (Policy_Car_Act_Discount_Premium) missing on UAT-ISV.

## 4. Sequences (definition only)

| Kind of difference | Count | Examples |
|---|---|---|
| type integer -> bigint (+START) | 15 | `activity_type_id_seq`, `jwt_tokens_id_seq`, `log_activity_id_seq`, `log_activity_ref_id_seq`, `log_priceza_id_seq`, `otp_daily_requests_id_seq`, `otp_settings_id_seq`, `otp_verification_id_seq`, `pm_callback_cb_no_seq`, `policy_form_submissions_id_seq` … (+5 more, total 15) |
| START WITH only | 8 | `callback_logs_id_seq`, `imp_price_premium_ver_seq`, `seq_blacklist_id`, `seq_blacklist_request_id`, `temp_otp_id_seq`, `tqm_car_mapping_id_seq`, `tqm_group_premium_id_seq`, `tqm_premium_id_seq` (total 8) |
| type bigint -> integer | 20 | `claim_request_attach_id_seq`, `district_districtid_seq1`, `emcs_getimage_ar_emcs_ar_id_seq`, `hbdisv_event_id_seq`, `lead_home_premium_lead_home_no_seq`, `lead_info_customer_lead_info_id_seq`, `lead_pa_premium_lead_pa_no_seq`, `lead_ta_premium_lead_ta_no_seq`, `loyalty_condition_loyalty_con_id_seq`, `mas_home_province_home_province_id_seq` … (+10 more, total 20) |
| type integer -> bigint | 4 | `district_districtid_seq`, `province_provinceid_seq`, `shopee_app_access_token_id_seq`, `subdistrict_subdistrictid_seq` (total 4) |
| type bigint -> smallint | 8 | `mas_home_building_type_home_building_type_id_seq`, `mas_home_coverage_group_home_coverage_group_id_seq`, `mas_home_material_type_home_material_type_id_seq`, `mas_home_premium_tariff_home_premium_tariff_id_seq`, `mas_home_resident_type_home_resident_type_id_seq`, `mas_pa_package_pa_package_id_seq`, `mas_ta_travel_type_ta_travel_type_id_seq`, `mas_tariff_tariff_id_seq` (total 8) |

None of these change numbering logic (increment/min/max/cache/cycle are identical everywhere except the type-driven max); `START WITH` only matters on reset.

## 5. Only-in lists

**Only in Prod:** tables 0, functions 0, views 0, triggers 0, sequences 0, types 0.

**Tables only in UAT-ISV:** `Act_Renewal_Reminder`, `Imp_Discount_Premium_bak_20260630`, `Imp_Price_Premium_20251118`, `Imp_Price_Premium_bak_20260630`, `Policy_Car_Act_Discount_Premium_8aug`, `SequelizeMeta`, `_bk10_imp_price_premium`, `_bk11_sys_param_duty`, `act`, `api_payload_logs`, `batch_payment_errors`, `callback_logs_prod`, `cs_impersonation`, `district_12sep67`, `district_add`, `imp_discount_premium`, `imp_discount_premium_020925`, `imp_discount_premium_040226`, `imp_discount_premium_160226`, `imp_discount_premium_20260703`, `imp_price_premium_020925`, `imp_price_premium_040226`, `imp_price_premium_160226`, `mas_car_prices`, `mas_cmi_color_7_5_24`, `mas_cmi_province_tqm`, `mas_country_30032567`, `mas_home_premium_tariff_2`, `mas_mv_config`, `mas_ta_package_coverage_26may2025`, `mas_ta_premium_26may2025`, `notification_business_rules`, `notification_queue`, `notification_templates_extended`, `promo_code_16oct`, `promo_code_26_4`, `promo_code_28042025`, `promo_code_30_4`, `promo_code_tep`, `province_12sep67` … (+10 more, total 50)

**Functions only in UAT-ISV:** `01-12-2025-fn_sf_policy_endorse_financial(…)`, `deactivate_old_entries()`, `fn_blacklist_email(p_email character varying, p_reason character varying)`, `fn_check_daily_otp_requests(p_email character varying)`, `fn_check_next_invoice_no(p_prefix text)`, `fn_cleanup_expired_otp()`, `fn_create_otp(…)`, `fn_format_utc_timestamp_th(p_timestamp timestamp without time zone)`, `fn_generate_random_otp(…)`, `fn_get_otp_setting(…)`, `fn_policy_invoiceno_gen(…)`, `fn_policy_my_policy2(in_email text)`, `fn_policy_my_policy_Bckup_4Aug(in_email text)`, `fn_policy_my_policy_address(in_email text)`, `fn_policy_my_policy_bckup_4aug(in_email text)`, `fn_policy_my_policy_bk20260722(in_email text)`, `fn_policy_my_policy_search_optimized_bk20251202(…)`, `fn_policy_my_policy_search_optimized_bk20260721(…)`, `fn_policy_my_policy_search_optimized_bk20260722(…)`, `fn_policy_package_iia_bak1(in_usage text, in_type text)`, `fn_policy_quotationno_credit_gen(…)`, `fn_policy_quotationno_debit_gen(…)`, `fn_policy_quotationno_gen(in_is_test boolean, in_ref_key character varying)`, `fn_policy_receiptno_gen(in_is_test boolean, in_ref_key character varying)`, `fn_policy_renewal_bk(…)`, `fn_policy_renewal_noti_bk()`, `fn_policy_renewal_test(…)`, `fn_policy_renewal_test_noti(…)`, `fn_policy_trans_history_caract_backup_30sep(car_act_no text)`, `fn_policy_trans_history_caract_backup_4Aug(car_act_no text)`, `fn_promo_promotion_list_backup_25_sep(…)`, `fn_sf_policy_endorse_financial(…)`, `fn_update_daily_otp_requests(p_email character varying)`, `fn_verify_otp(p_email character varying, p_otp character varying)`, `get_notification_channels(…)`, `get_notification_rules(…)`, `old_fn_sf_policy_endorse_financial(…)`, `test_jane()`, `trg_fn_sync_pcad_from_ph()`, `uuid_generate_v4()` (total 40)

**Triggers only in UAT-ISV:** `Policy_Header.trg_sync_pcad_from_ph` (total 1)

**Sequences only in UAT-ISV:** `Act_Renewal_Reminder_id_seq`, `api_payload_logs_id_seq`, `batch_payment_errors_id_seq`, `log_api_thaibulk_id_seq`, `log_thaibulk_send_id_seq`, `product_type_id_seq`, `renew_policy_records_id_seq`, `renew_promocode_percent_id_seq`, `seq_car_act_lead_no`, `shopee_product_form_id_seq`, `thaibulk_templates_id_seq`, `thaibulk_webhook_logs_id_seq` (total 12)

## 6. Artifacts
- UAT-ISV export: `scratchpad/uatisv_schema/{functions,tables,triggers,views,types,sequences}` (case-collision files suffixed .1/.2 like prod)
- Raw catalog JSON: `scratchpad/uatisv_raw/`; comparison script `scratchpad/cmp.py`; results `scratchpad/cmp_result.json`

