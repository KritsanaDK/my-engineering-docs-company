--
-- PostgreSQL database dump
--

\restrict 1OnGRzcCtPRp9pxqzNoFCFhtfC8ktH1IOwkqeoFmXtmBbNcylshphCpWMofdZ3r

-- Dumped from database version 17.11
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: v_lead_policy_product; Type: VIEW; Schema: insurverse; Owner: -
--

CREATE VIEW insurverse.v_lead_policy_product AS
 WITH latest_payment AS (
         SELECT DISTINCT ON (payment.lead_no) payment.id,
            payment.invoice_no,
            payment.amount,
            payment.method,
            payment.description,
            payment.installment,
            payment.installment_period,
            payment.payment_status,
            payment.customer_id,
            payment.token,
            payment.url,
            payment.created_at,
            payment.updated_at,
            payment.customer_email,
            payment.lead_no,
            payment.remark,
            payment.sales_channel,
            payment.ref1,
            payment.ref2,
            payment.ref3,
            payment.payment_channel,
            payment.is_manual_update,
            payment.updated_manual_by
           FROM insurverse.payment
          ORDER BY payment.lead_no, payment.created_at DESC
        ), latest_payment_act AS (
         SELECT DISTINCT ON (payment_act.act_no) payment_act.id,
            payment_act.invoice_no,
            payment_act.amount,
            payment_act.method,
            payment_act.description,
            payment_act.installment,
            payment_act.installment_period,
            payment_act.payment_status,
            payment_act.customer_id,
            payment_act.token,
            payment_act.url,
            payment_act.created_at,
            payment_act.updated_at,
            payment_act.customer_email,
            payment_act.act_no,
            payment_act.remark,
            payment_act.sales_channel,
            payment_act.ref1,
            payment_act.ref2,
            payment_act.ref3,
            payment_act.payment_channel,
            payment_act.is_manual_update,
            payment_act.updated_manual_by
           FROM insurverse.payment_act
          ORDER BY payment_act.act_no, payment_act.created_at DESC
        ), latest_payment_ta AS (
         SELECT DISTINCT ON (payment_ta.lead_ta_no) payment_ta.id,
            payment_ta.invoice_no,
            payment_ta.amount,
            payment_ta.method,
            payment_ta.description,
            payment_ta.installment,
            payment_ta.installment_period,
            payment_ta.payment_status,
            payment_ta.customer_id,
            payment_ta.token,
            payment_ta.url,
            payment_ta.created_at,
            payment_ta.updated_at,
            payment_ta.customer_email,
            payment_ta.lead_ta_no
           FROM insurverse.payment_ta
          ORDER BY payment_ta.lead_ta_no, payment_ta.created_at DESC
        ), latest_payment_transaction AS (
         SELECT DISTINCT ON (payment_transaction.lead_no, payment_transaction.lead_type) payment_transaction.id,
            payment_transaction.invoice_no,
            payment_transaction.amount,
            payment_transaction.method,
            payment_transaction.description,
            payment_transaction.installment,
            payment_transaction.installment_period,
            payment_transaction.payment_status,
            payment_transaction.customer_id,
            payment_transaction.token,
            payment_transaction.url,
            payment_transaction.created_at,
            payment_transaction.updated_at,
            payment_transaction.customer_email,
            payment_transaction.lead_no,
            payment_transaction.lead_type,
            payment_transaction.user_id
           FROM insurverse.payment_transaction
          ORDER BY payment_transaction.lead_no, payment_transaction.lead_type, payment_transaction.created_at DESC
        ), location_code AS (
         SELECT sd.subdistrictid,
            sd.sdname,
            d.diname,
            pv.prname
           FROM ((insurverse.subdistrict sd
             JOIN insurverse.district d ON ((sd.sddistrict = d.districtid)))
             JOIN insurverse.province pv ON ((d.diprovince = pv.provinceid)))
        ), payment_callback AS (
         SELECT DISTINCT ON ((pc.data ->> 'invoiceNo'::text)) pc.cb_no,
            pc.json_body,
            pc.data,
            pc.created_at,
            pc.updated_at,
            pc.invoice_no,
            pc.payment_type,
            pc.callback_type
           FROM insurverse.payment_callback pc
          ORDER BY (pc.data ->> 'invoiceNo'::text), pc.created_at DESC
        )
 SELECT to_char((lmv."Create_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS lead_date,
    to_char((pmv."Create_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS issue_date,
    ('MVL'::text || lpad((lmv."Lead_No")::text, 8, '0'::text)) AS lead_no,
    pmv."Policy_No" AS policy_no,
        CASE
            WHEN (pmv."Car_Act_No" IS NULL) THEN '-'::character varying
            ELSE pmv."Car_Act_No"
        END AS ref_policy_no,
        CASE
            WHEN ((pmv."Policy_Status" IS NULL) AND (pmv."Policy_No" IS NULL)) THEN 'Fulfillment'::text
            WHEN ((pmv."Policy_Status")::text = 'ACT'::text) THEN 'Active'::text
            WHEN ((pmve.doc_type)::text ~~ '%_11'::text) THEN 'Canceled'::text
            WHEN (pmv."Policy_Startdate" > CURRENT_DATE) THEN 'Waiting'::text
            WHEN (pmv."Policy_Enddate" < CURRENT_DATE) THEN 'Expired'::text
            ELSE '-'::text
        END AS policy_status,
    'Voluntary Motor'::text AS product,
    ('ชั้น '::text || (lmv."Type")::text) AS plan,
    pmv."Car_license_no" AS car_license_no,
    pnmv.partner_name_th AS channel,
    to_char((pmv."Policy_Startdate" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS start_date,
    to_char((pmv."Policy_Enddate" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS end_date,
    COALESCE(promv.promo_code, '-'::character varying) AS promo_code,
    pmv."Policy_url_ref" AS policy_document,
    pmv."Policy_url_copy_ref" AS policy_document_copy,
    pmv."Receipt_url_ref" AS receipt_document,
    pmv."Receipt_url_copy_ref" AS receipt_document_copy,
    COALESCE(NULLIF(concat_ws(' '::text, pmv."Owner_first_name", pmv."Owner_last_name"), ''::text), '-'::text) AS insured_name,
    COALESCE(NULLIF(concat_ws(' '::text, concat_ws(''::text, pmv."Owner_prefix_name", pmv."Owner_first_name"), pmv."Owner_last_name"), ''::text), '-'::text) AS insured_fullname,
    pmv."Owner_citizen_id" AS insured_card_id,
    to_char((pmv."Owner_birth_date" + '07:00:00'::interval), 'dd/mm/yyyy'::text) AS insured_birthdate,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM lmv."Mobile"), ''::text) <> ''::text) THEN concat("substring"(replace((lmv."Mobile")::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((lmv."Mobile")::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((lmv."Mobile")::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS insured_phone,
        CASE
            WHEN (pmv."Flag_Deli" = 'Y'::bpchar) THEN 'จัดส่งรูปเล่มกรมธรรม์'::text
            ELSE 'ไม่จัดส่งรูปเล่มกรมธรรม์'::text
        END AS insured_policy_delivery_option,
        CASE
            WHEN (pmv."Policy_No" IS NOT NULL) THEN pmv.email
            ELSE lmv."Email"
        END AS insured_email,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, pmv."Owner_address", cloc.sdname, cloc.diname, cloc.prname, pmv."Owner_zipcode")), ''::text), '-'::text) AS insured_contact_address,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, pmv."Deli_Addr_line1", pmv."Deli_Addr_line2", pmv."Deli_Addr_line3", dloc.sdname, dloc.diname, dloc.prname, pmv."Deli_zipcode")), ''::text), '-'::text) AS insured_delivery_address,
    concat_ws(' '::text, u.name, u.last_name) AS customer_name,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM u.mobile), ''::text) <> ''::text) THEN concat("substring"(replace((u.mobile)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS customer_phone,
        CASE
            WHEN ((pmv."Bene_Type")::text = 'person'::text) THEN 'ผู้ประเอาประกัน'::text
            WHEN ((pmv."Bene_Type")::text = 'financial'::text) THEN 'บริษัทไฟแนนซ์'::text
            ELSE '-'::text
        END AS beneficiary_type,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, pmv."Bene_Title", pmv."Bene_Firstname"), pmv."Bene_Midname", pmv."Bene_Lastname")), ''::text), '-'::text) AS beneficiary_name,
    '-'::text AS beneficiary_relation,
    '-'::text AS beneficiary_contact,
        CASE
            WHEN ((paycmv.callback_type)::text = 'OTHER'::text) THEN 'FAIL'::character varying
            ELSE paycmv.callback_type
        END AS payment_status,
    (paycmv.data ->> 'respDesc'::text) AS payment_remark,
    paymv.method AS payment_method,
    (paycmv.data ->> 'agentCode'::text) AS bank,
    COALESCE(NULLIF(to_char(lmv."Perm_Amt", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS premium,
    COALESCE(NULLIF(to_char(lmv."Vat_Amt", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS vat,
    COALESCE(NULLIF(to_char(lmv."Duty_Amt", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS duty,
    COALESCE(NULLIF(to_char(lmv."Discount", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS discount,
    COALESCE(NULLIF(to_char(lmv."Total_Amt", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS total_amount,
    paymv.invoice_no,
    lmv."Policy_Invoice_No" AS tax_invoice_no,
    lmv."Policy_book" AS book_no,
    '-'::text AS tax_deduction,
    to_char((paycmv.created_at + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS payment_date,
    lmv."Policy_Quatation_No" AS quotation_no,
    (paycmv.data ->> 'userDefined3'::text) AS payment_2c2p_email,
    COALESCE(NULLIF(lpad("right"((paycmv.data ->> 'cardNo'::text), 4), length((paycmv.data ->> 'cardNo'::text)), 'X'::text), ''::text), '-'::text) AS card_no,
    (paycmv.data ->> 'monthlyPayment'::text) AS monthly_payment,
    (paymv.installment_period)::character(1) AS installment_period
   FROM ((((((((((insurverse."Lead_coverage_premium" lmv
     LEFT JOIN insurverse."Policy_coverage_premium" p ON ((p."Lead_No" = lmv."Lead_No")))
     LEFT JOIN insurverse."Policy_Header" pmv ON (((p."Policy_No")::text = (pmv."Policy_No")::text)))
     LEFT JOIN insurverse."Policy_endorse_detail" pmve ON ((((pmv."Policy_No")::text = (pmve."Policy_No")::text) AND ((pmve.doc_type)::text ~~ '%_11'::text))))
     JOIN latest_payment paymv ON ((lmv."Lead_No" = paymv.lead_no)))
     JOIN payment_callback paycmv ON (((paymv.invoice_no)::text = (paycmv.data ->> 'invoiceNo'::text))))
     LEFT JOIN insurverse.mas_partner pnmv ON (((pmv.partner_code)::text = (pnmv.partner_code)::text)))
     LEFT JOIN insurverse.promo_code_trans promv ON ((lmv.promo_trans_id = promv.promo_trans_id)))
     LEFT JOIN location_code dloc ON ((pmv."Deli_subdistrict_id" = dloc.subdistrictid)))
     LEFT JOIN location_code cloc ON ((pmv."Owner_subdistrict_id" = cloc.subdistrictid)))
     LEFT JOIN insurverse.sec_user u ON (((lmv."Email")::text = (u.email)::text)))
UNION
 SELECT to_char((lmc."Create_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS lead_date,
    to_char((pmc."Create_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS issue_date,
    ('MVL'::text || lpad((lmc."Lead_No")::text, 8, '0'::text)) AS lead_no,
    pmc."Car_Act_No" AS policy_no,
    pmc."Policy_No" AS ref_policy_no,
        CASE
            WHEN ((pmc."Policy_Status" IS NULL) AND (pmc."Policy_No" IS NULL)) THEN 'Fulfillment'::text
            WHEN ((pmc."Policy_Status")::text = 'ACT'::text) THEN 'Active'::text
            WHEN ((pmce.doc_type)::text ~~ '%_11'::text) THEN 'Canceled'::text
            WHEN (pmc."Start_date" > CURRENT_DATE) THEN 'Waiting'::text
            WHEN (pmc."End_date" < CURRENT_DATE) THEN 'Expired'::text
            ELSE '-'::text
        END AS policy_status,
    'Compulsory Motor'::text AS product,
        CASE
            WHEN ((lmc."Type")::text = '0'::text) THEN '-'::text
            ELSE ('ชั้น '::text || (lmc."Type")::text)
        END AS plan,
    pmc."Car_license_no" AS car_license_no,
    pnmv.partner_name_th AS channel,
    to_char((pmc."Start_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS start_date,
    to_char((pmc."End_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS end_date,
    promv.promo_code,
    pmc."Policy_url_ref" AS policy_document,
    pmc."Policy_url_copy_ref" AS policy_document_copy,
    pmc."Receipt_url_ref" AS receipt_document,
    pmc."Receipt_url_copy_ref" AS receipt_document_copy,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, pmc.first_name, pmc.last_name)), ''::text), '-'::text) AS insured_name,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, pmc.prefix_name, pmc.first_name), pmc.last_name)), ''::text), '-'::text) AS insured_fullname,
    pmc.citizen_id AS insured_card_id,
    to_char((pmc.birth_date + '07:00:00'::interval), 'dd/mm/yyyy'::text) AS insured_birthdate,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM pmc.phone), ''::text) <> ''::text) THEN concat("substring"(replace((pmc.phone)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((pmc.phone)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((pmc.phone)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS insured_phone,
        CASE
            WHEN (pmc."Flag_Deli" = 'Y'::bpchar) THEN 'จัดส่งรูปเล่มกรมธรรม์'::text
            ELSE 'ไม่จัดส่งรูปเล่มกรมธรรม์'::text
        END AS insured_policy_delivery_option,
        CASE
            WHEN (pmc."Car_Act_No" IS NOT NULL) THEN pmc.email
            ELSE lmc."Email"
        END AS insured_email,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, pmc.address, cloc.sdname, cloc.diname, cloc.prname, pmc.zipcode)), ''::text), '-'::text) AS insured_contact_address,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, pmc."Deli_Addr_line1", pmc."Deli_Addr_line2", pmc."Deli_Addr_line3", dloc.sdname, dloc.diname, dloc.prname, pmc."Deli_zipcode")), ''::text), '-'::text) AS insured_delivery_address,
    concat_ws(' '::text, u.name, u.last_name) AS customer_name,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM u.mobile), ''::text) <> ''::text) THEN concat("substring"(replace((u.mobile)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS customer_phone,
    pmc."Bene_Type" AS beneficiary_type,
    COALESCE(NULLIF(concat_ws(' '::text, concat_ws(''::text, pmc."Bene_Title", pmc."Bene_Firstname"), pmc."Bene_Midname", pmc."Bene_Lastname"), ''::text), '-'::text) AS beneficiary_name,
    '-'::text AS beneficiary_relation,
    '-'::text AS beneficiary_contact,
        CASE
            WHEN ((paycmc.callback_type)::text = 'OTHER'::text) THEN 'FAILED'::character varying
            ELSE paycmc.callback_type
        END AS payment_status,
    (paycmc.data ->> 'respDesc'::text) AS payment_remark,
    paymc.method AS payment_method,
    (paycmc.data ->> 'agentCode'::text) AS bank,
    COALESCE(NULLIF(to_char(pmc."Premium", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS premium,
    COALESCE(NULLIF(to_char(pmc."Vat", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS vat,
    COALESCE(NULLIF(to_char(pmc."Stamp", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS duty,
    COALESCE(NULLIF(to_char(pmc."Discount", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS discount,
    COALESCE(NULLIF(to_char(pmc."Total", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS total_amount,
    paymc.invoice_no,
    lmc."Policy_Invoice_No" AS tax_invoice_no,
    lmc."Policy_book" AS book_no,
    '-'::text AS tax_deduction,
    to_char((paycmc.created_at + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS payment_date,
    lmc."Policy_Quatation_No" AS quotation_no,
    (paycmc.data ->> 'userDefined3'::text) AS payment_2c2p_email,
    COALESCE(NULLIF(lpad("right"((paycmc.data ->> 'cardNo'::text), 4), length((paycmc.data ->> 'cardNo'::text)), 'X'::text), ''::text), '-'::text) AS card_no,
    (paycmc.data ->> 'monthlyPayment'::text) AS monthly_payment,
    (paymc.installment_period)::character(1) AS installment_period
   FROM (((((((((insurverse."Policy_Car_Act_Discount_Premium" pmc
     JOIN insurverse."Lead_coverage_premium" lmc ON ((lmc."Lead_No" = pmc."Lead_No")))
     LEFT JOIN insurverse."Policy_endorse_detail" pmce ON ((((pmc."Car_Act_No")::text = (pmce."Car_Act_No")::text) AND ((pmce.doc_type)::text ~~ '%_11'::text))))
     JOIN latest_payment paymc ON ((lmc."Lead_No" = paymc.lead_no)))
     JOIN payment_callback paycmc ON (((paymc.invoice_no)::text = (paycmc.data ->> 'invoiceNo'::text))))
     LEFT JOIN insurverse.mas_partner pnmv ON (((pmc.partner_code)::text = (pnmv.partner_code)::text)))
     LEFT JOIN insurverse.promo_code_trans promv ON ((pmc.promo_trans_id = promv.promo_trans_id)))
     LEFT JOIN location_code dloc ON ((pmc."Deli_subdistrict_id" = dloc.subdistrictid)))
     LEFT JOIN location_code cloc ON ((pmc.subdistrict_id = cloc.subdistrictid)))
     LEFT JOIN insurverse.sec_user u ON (((pmc.email)::text = (u.email)::text)))
UNION
 SELECT to_char((lmc."Create_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS lead_date,
    to_char((pmc."Create_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS issue_date,
    ('MCL'::text || lpad((lmc."Car_Act_Lead_No")::text, 8, '0'::text)) AS lead_no,
    pmc."Car_Act_No" AS policy_no,
    '-'::character varying AS ref_policy_no,
        CASE
            WHEN ((pmc."Policy_Status" IS NULL) AND (pmc."Policy_No" IS NULL)) THEN 'Fulfillment'::text
            WHEN ((pmc."Policy_Status")::text = 'ACT'::text) THEN 'Active'::text
            WHEN ((pmce.doc_type)::text ~~ '%_11'::text) THEN 'Canceled'::text
            WHEN (pmc."Start_date" > CURRENT_DATE) THEN 'Waiting'::text
            WHEN (pmc."End_date" < CURRENT_DATE) THEN 'Expired'::text
            ELSE '-'::text
        END AS policy_status,
    'Compulsory Motor'::text AS product,
        CASE
            WHEN ((lmc."Type")::text = '0'::text) THEN '-'::text
            ELSE ('ชั้น '::text || (lmc."Type")::text)
        END AS plan,
    lmc."Car_license_no" AS car_license_no,
    pnmv.partner_name_th AS channel,
    to_char((pmc."Start_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS start_date,
    to_char((pmc."End_date" + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS end_date,
    promv.promo_code,
    pmc."Policy_url_ref" AS policy_document,
    pmc."Policy_url_copy_ref" AS policy_document_copy,
    pmc."Receipt_url_ref" AS receipt_document,
    pmc."Receipt_url_copy_ref" AS receipt_document_copy,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lmc.first_name, lmc.last_name)), ''::text), '-'::text) AS insured_name,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, lmc.prefix_name, lmc.first_name), lmc.last_name)), ''::text), '-'::text) AS insured_fullname,
    lmc.citizen_id AS insured_card_id,
    to_char((lmc.birth_date + '07:00:00'::interval), 'dd/mm/yyyy'::text) AS insured_birthdate,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM lmc.phone), ''::text) <> ''::text) THEN concat("substring"(replace((lmc.phone)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((lmc.phone)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((lmc.phone)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS insured_phone,
        CASE
            WHEN (lmc."Flag_Deli" = 'Y'::bpchar) THEN 'จัดส่งรูปเล่มกรมธรรม์'::text
            ELSE 'ไม่จัดส่งรูปเล่มกรมธรรม์'::text
        END AS insured_policy_delivery_option,
        CASE
            WHEN (pmc."Car_Act_No" IS NOT NULL) THEN pmc.email
            ELSE lmc.email
        END AS insured_email,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, COALESCE(NULLIF((pmc.address)::text, ''::text), (lmc.address)::text), cloc.sdname, cloc.diname, cloc.prname, COALESCE(NULLIF((pmc.zipcode)::text, ''::text), (lmc.zipcode)::text))), ''::text), '-'::text) AS insured_contact_address,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, COALESCE(NULLIF((pmc."Deli_Addr_line1")::text, ''::text), (lmc."Deli_Addr_line1")::text), COALESCE(NULLIF((pmc."Deli_Addr_line2")::text, ''::text), (lmc."Deli_Addr_line2")::text), COALESCE(NULLIF((pmc."Deli_Addr_line3")::text, ''::text), (lmc."Deli_Addr_line3")::text), dloc.sdname, dloc.diname, dloc.prname, COALESCE(NULLIF((pmc."Deli_zipcode")::text, ''::text), (lmc."Deli_zipcode")::text))), ''::text), '-'::text) AS insured_delivery_address,
    concat_ws(' '::text, u.name, u.last_name) AS customer_name,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM u.mobile), ''::text) <> ''::text) THEN concat("substring"(replace((u.mobile)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS customer_phone,
    pmc."Bene_Type" AS beneficiary_type,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, pmc."Bene_Title", pmc."Bene_Firstname"), pmc."Bene_Midname", pmc."Bene_Lastname")), ''::text), '-'::text) AS beneficiary_name,
    '-'::text AS beneficiary_relation,
    '-'::text AS beneficiary_contact,
        CASE
            WHEN ((paycmc.callback_type)::text = 'OTHER'::text) THEN 'FAILED'::character varying
            ELSE paycmc.callback_type
        END AS payment_status,
    (paycmc.data ->> 'respDesc'::text) AS payment_remark,
    paymc.method AS payment_method,
    (paycmc.data ->> 'agentCode'::text) AS bank,
    COALESCE(NULLIF(to_char(lmc."Premium", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS premium,
    COALESCE(NULLIF(to_char(lmc."Vat", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS vat,
    COALESCE(NULLIF(to_char(lmc."Stamp", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS duty,
    COALESCE(NULLIF(to_char(lmc."Discount", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS discount,
    COALESCE(NULLIF(to_char(lmc."Total", 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS total_amount,
    paymc.invoice_no,
    lmc."Policy_Invoice_No" AS tax_invoice_no,
    lmc."Policy_book" AS book_no,
    '-'::text AS tax_deduction,
    to_char((paycmc.created_at + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS payment_date,
    lmc."Policy_Quatation_No" AS quotation_no,
    (paycmc.data ->> 'userDefined3'::text) AS payment_2c2p_email,
    COALESCE(NULLIF(lpad("right"((paycmc.data ->> 'cardNo'::text), 4), length((paycmc.data ->> 'cardNo'::text)), 'X'::text), ''::text), '-'::text) AS card_no,
    (paycmc.data ->> 'monthlyPayment'::text) AS monthly_payment,
    (paymc.installment_period)::character(1) AS installment_period
   FROM (((((((((insurverse."Lead_Car_Act_Discount_Premium" lmc
     LEFT JOIN insurverse."Policy_Car_Act_Discount_Premium" pmc ON ((lmc."Car_Act_Lead_No" = pmc."Car_Act_Lead_No")))
     LEFT JOIN insurverse."Policy_endorse_detail" pmce ON ((((pmc."Car_Act_No")::text = (pmce."Car_Act_No")::text) AND ((pmce.doc_type)::text ~~ '%_11'::text))))
     JOIN latest_payment_act paymc ON ((lmc."Car_Act_Lead_No" = paymc.act_no)))
     JOIN payment_callback paycmc ON (((paymc.invoice_no)::text = (paycmc.data ->> 'invoiceNo'::text))))
     LEFT JOIN insurverse.mas_partner pnmv ON (((pmc.partner_code)::text = (pnmv.partner_code)::text)))
     LEFT JOIN insurverse.promo_code_trans promv ON ((pmc.promo_trans_id = promv.promo_trans_id)))
     LEFT JOIN location_code dloc ON ((COALESCE(pmc."Deli_subdistrict_id", lmc."Deli_subdistrict_id") = dloc.subdistrictid)))
     LEFT JOIN location_code cloc ON ((COALESCE(pmc.subdistrict_id, lmc.subdistrict_id) = cloc.subdistrictid)))
     LEFT JOIN insurverse.sec_user u ON (((lmc.email)::text = (u.email)::text)))
UNION
 SELECT to_char((lta.create_date + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS lead_date,
    to_char((pta.create_date + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS issue_date,
    ('TAL'::text || lpad((lta.lead_ta_no)::text, 8, '0'::text)) AS lead_no,
    pta.policy_ta_no AS policy_no,
    '-'::character varying AS ref_policy_no,
        CASE
            WHEN ((pta.policy_status IS NULL) AND (pta.policy_ta_no IS NULL)) THEN 'Fulfillment'::text
            WHEN ((pta.policy_status)::text = 'ACT'::text) THEN 'Active'::text
            WHEN ptae.is_cancel THEN 'Canceled'::text
            WHEN (pta.policy_startdate > CURRENT_DATE) THEN 'Waiting'::text
            WHEN (pta.policy_enddate < CURRENT_DATE) THEN 'Expired'::text
            ELSE '-'::text
        END AS policy_status,
    'Travel Insurance'::text AS product,
    mtp.sub_product_name_th AS plan,
    '-'::character varying AS car_license_no,
    pnmv.partner_name_th AS channel,
    to_char((pta.policy_startdate + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS start_date,
    to_char((pta.policy_enddate + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS end_date,
    COALESCE(promv.promo_code, '-'::character varying) AS promo_code,
    pta.policy_url_ref AS policy_document,
    pta.policy_url_copy_ref AS policy_document_copy,
    pta.receipt_url_ref AS receipt_document,
    pta.receipt_url_ref AS receipt_document_copy,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, ltap.owner_firstname_th, ltap.owner_lastname_th)), ''::text), '-'::text) AS insured_name,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, ltap.owner_title_th, ltap.owner_firstname_th), ltap.owner_lastname_th)), ''::text), '-'::text) AS insured_fullname,
    ltap.owner_card_id AS insured_card_id,
    to_char((ltap.owner_birthdate + '07:00:00'::interval), 'dd/mm/yyyy'::text) AS insured_birthdate,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM ltap.owner_phone), ''::text) <> ''::text) THEN concat("substring"(replace((ltap.owner_phone)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((ltap.owner_phone)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((ltap.owner_phone)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS insured_phone,
        CASE
            WHEN lta.deli_flag THEN 'จัดส่งรูปเล่มกรมธรรม์'::text
            ELSE 'ไม่จัดส่งรูปเล่มกรมธรรม์'::text
        END AS insured_policy_delivery_option,
        CASE
            WHEN (pta.email IS NOT NULL) THEN pta.email
            ELSE lta.email
        END AS insured_email,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, ltap.owner_address_th, cloc.sdname, cloc.diname, cloc.prname, ltap.owner_zipcode)), ''::text), '-'::text) AS insured_contact_address,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lta.deli_address_th, dloc.sdname, dloc.diname, dloc.prname, lta.deli_zipcode)), ''::text), '-'::text) AS insured_delivery_address,
    concat_ws(' '::text, u.name, u.last_name) AS customer_name,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM u.mobile), ''::text) <> ''::text) THEN concat("substring"(replace((u.mobile)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS customer_phone,
    bene_type.mas_name_th AS beneficiary_type,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, ltap.bene_title_th, ltap.bene_firstname_th), ltap.bene_lastname_th)), ''::text), '-'::text) AS beneficiary_name,
    bene_relation.mas_name_th AS beneficiary_relation,
    '-'::text AS beneficiary_contact,
        CASE
            WHEN ((paycta.callback_type)::text = 'OTHER'::text) THEN 'FAIL'::character varying
            ELSE paycta.callback_type
        END AS payment_status,
    (paycta.data ->> 'respDesc'::text) AS payment_remark,
    payta.method AS payment_method,
    (paycta.data ->> 'agentCode'::text) AS bank,
    COALESCE(NULLIF(to_char(lta.perm_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS premium,
    COALESCE(NULLIF(to_char(lta.vat_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS vat,
    COALESCE(NULLIF(to_char(lta.duty_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS duty,
    COALESCE(NULLIF(to_char(lta.discount_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS discount,
    COALESCE(NULLIF(to_char(lta.total_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS total_amount,
    payta.invoice_no,
    lta.policy_invoice_no AS tax_invoice_no,
    lta.policy_book AS book_no,
    '-'::text AS tax_deduction,
    to_char((paycta.created_at + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS payment_date,
    lta.policy_quotation_no AS quotation_no,
    (paycta.data ->> 'userDefined3'::text) AS payment_2c2p_email,
    COALESCE(NULLIF(lpad("right"((paycta.data ->> 'cardNo'::text), 4), length((paycta.data ->> 'cardNo'::text)), 'X'::text), ''::text), '-'::text) AS card_no,
    (paycta.data ->> 'monthlyPayment'::text) AS monthly_payment,
    (payta.installment_period)::character(1) AS installment_period
   FROM (((((((((((((insurverse.lead_ta_premium lta
     LEFT JOIN insurverse.policy_ta_premium pta ON ((pta.lead_ta_no = lta.lead_ta_no)))
     LEFT JOIN insurverse.lead_ta_participant ltap ON (((ltap.lead_ta_no = lta.lead_ta_no) AND ((pta.policy_ta_no)::text = (ltap.policy_ta_no)::text))))
     LEFT JOIN insurverse.policy_ta_endorse_detail ptae ON ((((pta.policy_ta_no)::text = (ptae.policy_ta_no)::text) AND (ptae.is_cancel IS NOT NULL))))
     JOIN latest_payment_ta payta ON ((lta.lead_ta_no = payta.lead_ta_no)))
     JOIN payment_callback paycta ON (((payta.invoice_no)::text = (paycta.data ->> 'invoiceNo'::text))))
     LEFT JOIN insurverse.mas_partner pnmv ON (((pta.partner_code)::text = (pnmv.partner_code)::text)))
     LEFT JOIN insurverse.promo_code_trans promv ON ((pta.promo_trans_id = promv.promo_trans_id)))
     LEFT JOIN insurverse.mas_policy_product mtp ON ((((lta.ta_package_id)::text = (mtp.sub_product_code)::text) AND ((mtp.product_code)::text = 'ta'::text))))
     LEFT JOIN location_code dloc ON ((lta.deli_subdistrict_id = dloc.subdistrictid)))
     LEFT JOIN location_code cloc ON ((ltap.owner_subdistrict_id = cloc.subdistrictid)))
     LEFT JOIN insurverse.mas_ta_description bene_type ON ((((ltap.bene_type)::character(1) = (bene_type.mas_ta_code)::bpchar) AND ((bene_type.mas_ta_type)::text = 'bene_type'::text))))
     LEFT JOIN insurverse.mas_ta_description bene_relation ON ((((ltap.bene_relation)::character(1) = (bene_relation.mas_ta_code)::bpchar) AND ((bene_relation.mas_ta_type)::text = 'bene_relation'::text))))
     LEFT JOIN insurverse.sec_user u ON (((lta.email)::text = (u.email)::text)))
UNION
 SELECT to_char((lpa.create_date + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS lead_date,
    to_char((ppa.create_date + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS issue_date,
    ('PAL'::text || lpad((lpa.lead_pa_no)::text, 8, '0'::text)) AS lead_no,
    ppa.policy_pa_no AS policy_no,
    '-'::character varying AS ref_policy_no,
        CASE
            WHEN ((ppa.policy_status IS NULL) AND (ppa.policy_pa_no IS NULL)) THEN 'Fulfillment'::text
            WHEN ((ppa.policy_status)::text = 'ACT'::text) THEN 'Active'::text
            WHEN ppae.is_cancel THEN 'Canceled'::text
            WHEN (ppa.policy_startdate > CURRENT_DATE) THEN 'Waiting'::text
            WHEN (ppa.policy_enddate < CURRENT_DATE) THEN 'Expired'::text
            ELSE '-'::text
        END AS policy_status,
    'Personal Accident'::text AS product,
    mpp.package_name_th AS plan,
    '-'::character varying AS car_license_no,
    '-'::character varying AS channel,
    to_char((ppa.policy_startdate + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS start_date,
    to_char((ppa.policy_enddate + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS end_date,
    promv.promo_code,
    ppa.policy_url_ref AS policy_document,
    ppa.policy_url_copy_ref AS policy_document_copy,
    ppa.receipt_url_ref AS receipt_document,
    ppa.receipt_url_ref AS receipt_document_copy,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lpap.owner_firstname_th, lpap.owner_lastname_th)), ''::text), '-'::text) AS insured_name,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, lpap.owner_title_th, lpap.owner_firstname_th), lpap.owner_lastname_th)), ''::text), '-'::text) AS insured_fullname,
    lpap.owner_card_id AS insured_card_id,
    to_char((lpap.owner_birthdate + '07:00:00'::interval), 'dd/mm/yyyy'::text) AS insured_birthdate,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM lpap.owner_phone), ''::text) <> ''::text) THEN concat("substring"(replace((lpap.owner_phone)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((lpap.owner_phone)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((lpap.owner_phone)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS insured_phone,
        CASE
            WHEN lpa.deli_flag THEN 'จัดส่งรูปเล่มกรมธรรม์'::text
            ELSE 'ไม่จัดส่งรูปเล่มกรมธรรม์'::text
        END AS insured_policy_delivery_option,
        CASE
            WHEN (ppa.email IS NOT NULL) THEN ppa.email
            ELSE lpa.email
        END AS insured_email,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lpap.owner_address_th, cloc.sdname, cloc.diname, cloc.prname, lpap.owner_zipcode)), ''::text), '-'::text) AS insured_contact_address,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lpa.deli_address_th, dloc.sdname, dloc.diname, dloc.prname, lpa.deli_zipcode)), ''::text), '-'::text) AS insured_delivery_address,
    concat_ws(' '::text, u.name, u.last_name) AS customer_name,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM u.mobile), ''::text) <> ''::text) THEN concat("substring"(replace((u.mobile)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((u.mobile)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS customer_phone,
    bene_type.mas_name_th AS beneficiary_type,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, bpa.bene_title_th, bpa.bene_firstname_th), bpa.bene_lastname_th)), ''::text), '-'::text) AS beneficiary_name,
    bene_relation.mas_name_th AS beneficiary_relation,
    '-'::text AS beneficiary_contact,
        CASE
            WHEN ((paycpa.callback_type)::text = 'OTHER'::text) THEN 'FAIL'::character varying
            ELSE paycpa.callback_type
        END AS payment_status,
    (paycpa.data ->> 'respDesc'::text) AS payment_remark,
    paypa.method AS payment_method,
    (paycpa.data ->> 'agentCode'::text) AS bank,
    COALESCE(NULLIF(to_char(lpa.perm_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS premium,
    COALESCE(NULLIF(to_char(lpa.vat_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS vat,
    COALESCE(NULLIF(to_char(lpa.duty_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS duty,
    COALESCE(NULLIF(to_char(lpa.discount_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS discount,
    COALESCE(NULLIF(to_char(lpa.total_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS total_amount,
    paypa.invoice_no,
    lpa.policy_invoice_no AS tax_invoice_no,
    lpa.policy_book AS book_no,
        CASE
            WHEN (ppa.tax_deductions_total_amt > (0)::numeric) THEN 'Yes'::text
            WHEN (ppa.tax_deductions_total_amt = (0)::numeric) THEN 'No'::text
            ELSE 'N/A'::text
        END AS tax_deduction,
    to_char((paycpa.created_at + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS payment_date,
    lpa.policy_quotation_no AS quotation_no,
    (paycpa.data ->> 'userDefined3'::text) AS payment_2c2p_email,
    COALESCE(NULLIF(lpad("right"((paycpa.data ->> 'cardNo'::text), 4), length((paycpa.data ->> 'cardNo'::text)), 'X'::text), ''::text), '-'::text) AS card_no,
    (paycpa.data ->> 'monthlyPayment'::text) AS monthly_payment,
    (paypa.installment_period)::character(1) AS installment_period
   FROM (((((((((((((insurverse.lead_pa_premium lpa
     LEFT JOIN insurverse.policy_pa_premium ppa ON ((ppa.lead_pa_no = lpa.lead_pa_no)))
     JOIN insurverse.lead_pa_participant lpap ON ((lpap.lead_pa_no = lpa.lead_pa_no)))
     LEFT JOIN insurverse.lead_pa_beneficiary bpa ON ((lpa.lead_pa_no = bpa.lead_pa_no)))
     LEFT JOIN insurverse.policy_pa_endorse_detail ppae ON ((((ppa.policy_pa_no)::text = (ppae.policy_pa_no)::text) AND (ppae.is_cancel IS NOT NULL))))
     JOIN latest_payment_transaction paypa ON (((lpa.lead_pa_no = paypa.lead_no) AND ((paypa.lead_type)::text = 'pa'::text))))
     JOIN payment_callback paycpa ON (((paypa.invoice_no)::text = (paycpa.data ->> 'invoiceNo'::text))))
     LEFT JOIN insurverse.promo_code_trans promv ON ((ppa.promo_trans_id = promv.promo_trans_id)))
     LEFT JOIN insurverse.mas_pa_package mpp ON ((lpa.pa_package_id = mpp.pa_package_id)))
     LEFT JOIN location_code dloc ON ((lpa.deli_subdistrict_id = dloc.subdistrictid)))
     LEFT JOIN location_code cloc ON ((lpap.owner_subdistrict_id = cloc.subdistrictid)))
     LEFT JOIN insurverse.mas_ta_description bene_type ON ((((bpa.bene_type)::character(1) = (bene_type.mas_ta_code)::bpchar) AND ((bene_type.mas_ta_type)::text = 'bene_type'::text))))
     LEFT JOIN insurverse.mas_ta_description bene_relation ON ((((bpa.bene_relation)::character(1) = (bene_relation.mas_ta_code)::bpchar) AND ((bene_relation.mas_ta_type)::text = 'bene_relation'::text))))
     LEFT JOIN insurverse.sec_user u ON (((lpa.email)::text = (u.email)::text)))
UNION
 SELECT to_char((lha.create_date + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS lead_date,
    to_char((pha.create_date + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS issue_date,
    ('HAL'::text || lpad((lhap.lead_home_no)::text, 8, '0'::text)) AS lead_no,
    pha.policy_home_no AS policy_no,
    '-'::character varying AS ref_policy_no,
        CASE
            WHEN ((pha.policy_status IS NULL) AND (pha.policy_home_no IS NULL)) THEN 'Fulfillment'::character varying
            WHEN ((pha.policy_status)::text = 'ACT'::text) THEN 'Active'::character varying
            WHEN phae.is_cancel THEN 'Canceled'::character varying
            WHEN (pha.policy_startdate > CURRENT_DATE) THEN 'Waiting'::character varying
            WHEN (pha.policy_enddate < CURRENT_DATE) THEN 'Expired'::character varying
            ELSE pha.policy_status
        END AS policy_status,
    'Home/Condo Insurance'::text AS product,
    '-'::text AS plan,
    '-'::character varying AS car_license_no,
    '-'::character varying AS channel,
    to_char((pha.policy_startdate + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS start_date,
    to_char((pha.policy_enddate + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS end_date,
    promv.promo_code,
    pha.policy_url_ref AS policy_document,
    pha.policy_url_copy_ref AS policy_document_copy,
    pha.receipt_url_ref AS receipt_document,
    pha.receipt_url_ref AS receipt_document_copy,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lhap.owner_firstname_th, lhap.owner_lastname_th)), ''::text), '-'::text) AS insured_name,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, lhap.owner_title_th, lhap.owner_firstname_th), lhap.owner_lastname_th)), ''::text), '-'::text) AS insured_fullname,
    lhap.owner_card_id AS insured_card_id,
    to_char((lhap.owner_birthdate + '07:00:00'::interval), 'dd/mm/yyyy'::text) AS insured_birthdate,
        CASE
            WHEN (COALESCE(TRIM(BOTH FROM lhap.owner_phone), ''::text) <> ''::text) THEN concat("substring"(replace((lhap.owner_phone)::text, '-'::text, ''::text), 1, 3), '-', "substring"(replace((lhap.owner_phone)::text, '-'::text, ''::text), 4, 3), '-', "substring"(replace((lhap.owner_phone)::text, '-'::text, ''::text), 7, 4))
            ELSE NULL::text
        END AS insured_phone,
        CASE
            WHEN lha.deli_flag THEN 'จัดส่งรูปเล่มกรมธรรม์'::text
            ELSE 'ไม่จัดส่งรูปเล่มกรมธรรม์'::text
        END AS insured_policy_delivery_option,
        CASE
            WHEN (pha.email IS NOT NULL) THEN pha.email
            ELSE lha.email
        END AS insured_email,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lhap.owner_address_th, cloc.sdname, cloc.diname, cloc.prname, lhap.owner_zipcode)), ''::text), '-'::text) AS insured_contact_address,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, lha.deli_address_th, dloc.sdname, dloc.diname, dloc.prname, lha.deli_zipcode)), ''::text), '-'::text) AS insured_delivery_address,
    concat_ws(' '::text, u.name, u.last_name) AS customer_name,
    u.mobile AS customer_phone,
    bene_type.mas_name_th AS beneficiary_type,
    COALESCE(NULLIF(TRIM(BOTH FROM concat_ws(' '::text, concat_ws(''::text, lhap.bene_title_th, lhap.bene_firstname_th), lhap.bene_lastname_th)), ''::text), '-'::text) AS beneficiary_name,
    bene_relation.mas_name_th AS beneficiary_relation,
    '-'::text AS beneficiary_contact,
        CASE
            WHEN ((paycha.callback_type)::text = 'OTHER'::text) THEN 'FAIL'::character varying
            ELSE paycha.callback_type
        END AS payment_status,
    (paycha.data ->> 'respDesc'::text) AS payment_remark,
    payha.method AS payment_method,
    (paycha.data ->> 'agentCode'::text) AS bank,
    COALESCE(NULLIF(to_char(lha.perm_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS premium,
    COALESCE(NULLIF(to_char(lha.vat_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS vat,
    COALESCE(NULLIF(to_char(lha.duty_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS duty,
    COALESCE(NULLIF(to_char(lha.discount_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS discount,
    COALESCE(NULLIF(to_char(lha.total_amt, 'FM999,999,999.00'::text), '.00'::text), '-'::text) AS total_amount,
    payha.invoice_no,
    pha.policy_invoice_no AS tax_invoice_no,
    pha.policy_book AS book_no,
    '-'::text AS tax_deduction,
    to_char((paycha.created_at + '07:00:00'::interval), 'dd/mm/yyyy hh24:mi:ss'::text) AS payment_date,
    lha.policy_quotation_no AS quotation_no,
    (paycha.data ->> 'userDefined3'::text) AS payment_2c2p_email,
    COALESCE(NULLIF(lpad("right"((paycha.data ->> 'cardNo'::text), 4), length((paycha.data ->> 'cardNo'::text)), 'X'::text), ''::text), '-'::text) AS card_no,
    (paycha.data ->> 'monthlyPayment'::text) AS monthly_payment,
    (payha.installment_period)::character(1) AS installment_period
   FROM (((((((((((insurverse.lead_home_premium lha
     LEFT JOIN insurverse.lead_home_participant lhap ON ((lha.lead_home_no = lhap.lead_home_no)))
     LEFT JOIN insurverse.policy_home_premium pha ON ((pha.lead_home_no = lha.lead_home_no)))
     LEFT JOIN insurverse.policy_home_endorse_detail phae ON ((((pha.policy_home_no)::text = (phae.policy_home_no)::text) AND (phae.is_cancel IS NOT NULL))))
     JOIN latest_payment_transaction payha ON (((lha.lead_home_no = payha.lead_no) AND ((payha.lead_type)::text = 'home'::text))))
     JOIN payment_callback paycha ON (((payha.invoice_no)::text = (paycha.data ->> 'invoiceNo'::text))))
     LEFT JOIN insurverse.promo_code_trans promv ON ((pha.promo_trans_id = promv.promo_trans_id)))
     LEFT JOIN location_code dloc ON ((lha.deli_subdistrict_id = dloc.subdistrictid)))
     LEFT JOIN location_code cloc ON ((lhap.owner_subdistrict_id = cloc.subdistrictid)))
     LEFT JOIN insurverse.mas_ta_description bene_type ON ((((lhap.bene_type)::character(1) = (bene_type.mas_ta_code)::bpchar) AND ((bene_type.mas_ta_type)::text = 'bene_type'::text))))
     LEFT JOIN insurverse.mas_ta_description bene_relation ON ((((lhap.bene_relation)::character(1) = (bene_relation.mas_ta_code)::bpchar) AND ((bene_relation.mas_ta_type)::text = 'bene_relation'::text))))
     LEFT JOIN insurverse.sec_user u ON (((lha.email)::text = (u.email)::text)));


--
-- PostgreSQL database dump complete
--

\unrestrict 1OnGRzcCtPRp9pxqzNoFCFhtfC8ktH1IOwkqeoFmXtmBbNcylshphCpWMofdZ3r

