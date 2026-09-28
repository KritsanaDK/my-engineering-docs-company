--
-- PostgreSQL database dump
--

\restrict H9fgB4eGopescMQ1Xt8PbGxq9Yl08Idd5kQhKVtukU1Ada3WhseKOebgnfX9cgJ

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Policy_Car_Act_Discount_Premium; Type: TABLE; Schema: insurverse; Owner: -
--

CREATE TABLE insurverse."Policy_Car_Act_Discount_Premium" (
    "Car_Act_No" character varying(50) NOT NULL,
    "Policy_No" character varying(50),
    "Brand" character varying(255),
    "Model" character varying(255),
    "Year" character varying(255),
    "Doors" smallint,
    "Seat" smallint,
    "Wg" integer,
    "Group" character varying(255),
    "Type" character varying(50),
    "Sedan" character varying(255),
    "BodyType" character varying(255),
    "Start_date" timestamp without time zone,
    "End_date" timestamp without time zone,
    "Create_date" timestamp without time zone,
    "Create_by" character varying(50),
    "Update_date" timestamp without time zone,
    "Update_by" character varying(50),
    "Payment_status" character varying(50),
    "Payment_channel" character varying(50),
    "Payment_type" character varying(50),
    "Payment_No" character varying(50),
    "Payment_Ref1" character varying(50),
    "Payment_Ref2" character varying(50),
    "Payment_result" character varying(50),
    "Recept_no" character varying(50),
    "Tax_No" character varying(50),
    "Flex_field1" character varying(255),
    "Flex_field2" character varying(255),
    "Flex_field3" character varying(255),
    "Policy_Quatation_No" character varying(50),
    "Policy_Invoice_No" character varying(50),
    "IIA_Ref_no" character varying(50),
    prefix_name character varying(50),
    first_name character varying(255),
    last_name character varying(255),
    birth_date date,
    citizen_id character varying(13),
    province_id integer,
    subdistrict_id integer,
    district_id integer,
    zipcode character varying(45),
    countryid integer,
    phone character varying(45),
    "IsKYC" character varying(50),
    "KYC_id" character varying(50),
    "KYC_date" timestamp without time zone,
    "Occupation" character varying(255),
    "Remark" character varying(255),
    "Car_Comp_Code" character varying(50),
    "Premium" numeric,
    "Discount" numeric,
    "Net_Premium" numeric,
    "Stamp" numeric,
    "Vat" numeric,
    "Total" numeric,
    "CC" character varying(255),
    "Car_license_no" character varying(50),
    "Car_license_provice" character varying(50),
    "Car_serial_no" character varying(50),
    "Effective_Startdate" timestamp without time zone NOT NULL,
    "Effective_Enddate" timestamp without time zone,
    cmi_reference_number character varying(50),
    cmi_receive_number character varying(50),
    cmi_endorse_ref_number character varying(50),
    cmi_endorse_receive_number character varying(50),
    cmi_update_date timestamp without time zone,
    "Comp_Code" character varying(255),
    "Policy_book" character varying(50),
    "Deli_Addr_line1" character varying(255),
    "Deli_Addr_line2" character varying(255),
    "Deli_Addr_line3" character varying(255),
    "Deli_province_id" integer,
    "Deli_subdistrict_id" integer,
    "Deli_district_id" integer,
    "Deli_zipcode" character varying(45),
    "Deli_countryid" integer,
    "Car_license_type" character varying(50),
    "Policy_Ref_no" character varying(50),
    "Policy_QR_code" character varying(255),
    "Car_color" character varying(255),
    "Lead_No" integer,
    "Policy_url_ref" character varying(500),
    "Policy_Barcode" character varying(50),
    "Policy_url_copy_ref" character varying(500),
    address character varying(255),
    email character varying(255),
    "Bene_Type" character varying(50),
    "Bene_Title" character varying(50),
    "Bene_Firstname" character varying(255),
    "Bene_Midname" character varying(255),
    "Bene_Lastname" character varying(255),
    "Bene_ID_card" character varying(50),
    "Receipt_url_ref" character varying(500),
    "Receipt_url_copy_ref" character varying(500),
    "SF_Epolicy_file_id" character varying(50),
    "SF_Etax_file_id" character varying(50),
    "Payment_date" timestamp without time zone,
    "IIA_Lot_No" character varying(20),
    "Flag_Deli" character(1),
    "SF_Policy_id" character varying(255),
    "Car_Act_Lead_No" bigint,
    "Policy_Status" character varying(50),
    "Appr_prefix_name" character varying(50),
    "Appr_first_name" character varying(255),
    "Appr_last_name" character varying(255),
    cmi_status character varying(255),
    "Change_Perm_Amt" numeric,
    "Change_Duty_Amt" numeric,
    "Change_Vat_Amt" numeric,
    "Change_Total_Amt" numeric,
    par_id integer,
    promo_trans_id bigint,
    promo_discount_per numeric(10,4),
    promo_discount_amt numeric(16,4),
    no_cancel_flag character varying(1),
    no_cancel_reason character varying(500),
    no_cancel_at timestamp without time zone,
    "Extend_Start" timestamp without time zone,
    "Extend_End" timestamp without time zone,
    extend_amt numeric(16,4),
    mas_premium numeric,
    mas_discount numeric,
    mas_net_premium numeric,
    mas_stamp numeric,
    mas_vat numeric,
    mas_total numeric,
    ref_policy_no character varying(50),
    partner_code character varying(10),
    occupation_code character varying(50),
    oic_version character varying(20),
    hp integer,
    "engineType" character varying(3) DEFAULT 'ICE'::character varying NOT NULL,
    customer_id character varying(100),
    CONSTRAINT "Policy_Car_Act_Discount_Premium_hp_check" CHECK (((hp >= 1) AND (hp <= 9999)))
);


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_Act_No"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_Act_No" IS 'รหัส พรบ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_No"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_No" IS 'รหัสกรมธรรม์';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Start_date"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Start_date" IS 'วันเริ่มคุ้มครอง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."End_date"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."End_date" IS 'วันสิ้นสุดคุ้มครอง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Payment_status"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Payment_status" IS 'สถานะจ่าย';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Payment_channel"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Payment_channel" IS 'ช่องทางจ่าย';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Payment_type"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Payment_type" IS 'ประเภทจ่าย';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Payment_No"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Payment_No" IS 'หมายเลขสำคัญจ่าย';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_Quatation_No"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_Quatation_No" IS 'Ref. ใบเสนอราคา';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_Invoice_No"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_Invoice_No" IS 'Ref. ใบเสร็จ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."IIA_Ref_no"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."IIA_Ref_no" IS 'Ref. IIA';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".prefix_name; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".prefix_name IS 'ปร 01 ผู้เอาประกัน';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".first_name; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".first_name IS 'ปร 01 ผู้เอาประกัน';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".last_name; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".last_name IS 'ปร 01 ผู้เอาประกัน';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".birth_date; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".birth_date IS 'ปร 01 ผู้เอาประกัน';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Occupation"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Occupation" IS 'อาชีพ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Remark"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Remark" IS 'หมายเหตุ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_Comp_Code"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_Comp_Code" IS 'Code การใช้รถ ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_license_no"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_license_no" IS 'รย 17 ป้ายเลขทะเบียน';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_license_provice"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_license_provice" IS 'รย 17 จังหวัด ที่จด';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_serial_no"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_serial_no" IS 'รย 17 ตัวถังรถ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".cmi_reference_number; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".cmi_reference_number IS 'รหัสอ้างอิง CMI Realtime';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".cmi_receive_number; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".cmi_receive_number IS 'รหัสรับ CMI Realtime';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".cmi_endorse_ref_number; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".cmi_endorse_ref_number IS 'รหัสอ้างอิงสลักหลัง CMI Realtime';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".cmi_endorse_receive_number; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".cmi_endorse_receive_number IS 'รหัสรับสลักหลัง CMI Realtime';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".cmi_update_date; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".cmi_update_date IS 'วันที่เวลาส่งข้อมูล CMI Realtime';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Comp_Code"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Comp_Code" IS 'ชื่อย่อบริษัท ISV (Default)';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_book"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_book" IS 'เล่มที่กรมธรรม์';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Deli_Addr_line1"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Deli_Addr_line1" IS 'ที่อยู่จัดส่ง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_license_type"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_license_type" IS '[Policy]-[Car_license_type] ป้ายแดง จดทะเบียน';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_Ref_no"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_Ref_no" IS 'Ref. อ้างอิง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_QR_code"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_QR_code" IS 'วันคุ้มครองกรมธรรม์ + ตัวเลขตัวถัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_color"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_color" IS 'สีรถ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_url_ref"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_url_ref" IS 'อ้างอิง URL กรมธรรม์ PDF จาก I-NET';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_Barcode"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_Barcode" IS 'ISV Barcode บนกรมธรรม์';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_url_copy_ref"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_url_copy_ref" IS 'อ้างอิง URL สำเนากรมธรรม์ PDF จาก I-NET';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".address; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".address IS 'ปร 01 ผู้เอาประกัน';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Bene_Type"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Bene_Type" IS 'รย 24 ไฟแนนซ์ บุคคล';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Bene_Title"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Bene_Title" IS 'ที่อยู่ผู้รับผลประโยชน์';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Bene_ID_card"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Bene_ID_card" IS 'หมายเลขเอกสารผู้รับผลประโยชน์';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Receipt_url_ref"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Receipt_url_ref" IS 'อ้างอิง URL ใบเสร็จ PDF จาก I-NET';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Receipt_url_copy_ref"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Receipt_url_copy_ref" IS 'อ้างอิง URL สำเนาใบเสร็จ PDF จาก I-NET';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."SF_Epolicy_file_id"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."SF_Epolicy_file_id" IS 'SF อ้างอิง File ID สำหรับ E-Policy';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."SF_Etax_file_id"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."SF_Etax_file_id" IS 'SF อ้างอิง File ID สำหรับ E-Tax';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."IIA_Lot_No"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."IIA_Lot_No" IS 'IIA Lot no.';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Flag_Deli"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Flag_Deli" IS 'y = จัดส่งรูปเล่มกรมธรรม์, n = ไม่จัดส่งรูปเล่มกรมธรรม์';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."SF_Policy_id"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."SF_Policy_id" IS 'Ref. SF-Policy Transaction ID (สำหรับกรณีสลักหลัง)';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Car_Act_Lead_No"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Car_Act_Lead_No" IS 'รหัส Lead พรบ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Policy_Status"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Policy_Status" IS 'ACT, INC รย 11 ยกเลิกหลังเริ่มคุ้มครอง/ยกเลิกยังไม่เริ่มคุ้มครอง // ประกันชั้น 2+3+ รยภ 00 ยกเลิก';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Appr_prefix_name"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Appr_prefix_name" IS 'คำนำหน้าผู้อนุมัติกรณีสลักหลังหรืออื่นๆ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Appr_first_name"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Appr_first_name" IS 'ชื่อผู้อนุมัติกรณีสลักหลังหรืออื่นๆ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Appr_last_name"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Appr_last_name" IS 'นามสกุลผู้อนุมัติกรณีสลักหลังหรืออื่นๆ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".cmi_status; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".cmi_status IS 'สถานะ success = สำเร็จ, dup = ซ้ำ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Change_Perm_Amt"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Change_Perm_Amt" IS 'ส่วนต่างเบี้ยประกันสุทธิ หลังการสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Change_Duty_Amt"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Change_Duty_Amt" IS 'ส่วนต่างอากรแสตมป์ หลังการสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Change_Vat_Amt"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Change_Vat_Amt" IS 'ส่วนต่างภาษีมูลค่าเพิ่ม หลังการสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Change_Total_Amt"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Change_Total_Amt" IS 'ส่วนต่างเบี้ยประกันรวม หลังการสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Extend_Start"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Extend_Start" IS 'รย 05 ขยายระเวลาคุ้มครองเริ่มต้น';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium"."Extend_End"; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium"."Extend_End" IS 'รย 05 ขยายระเวลาคุ้มครองสิ้นสุด';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".extend_amt; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".extend_amt IS 'ค่าเบี้ยเพิ่มกรณีสลักหลังขยายวันคุ้มครอง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".mas_premium; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".mas_premium IS 'ราคาเบี้ยเต็มจาก master data รองรับสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".mas_discount; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".mas_discount IS 'ราคาส่วนลดจาก master data รองรับสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".mas_net_premium; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".mas_net_premium IS 'ราคาหลังหักส่วนลดจาก master data รองรับสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".mas_stamp; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".mas_stamp IS 'ราคาอากรจาก master data รองรับสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".mas_vat; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".mas_vat IS 'ราคาภาษีจาก master data รองรับสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".mas_total; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".mas_total IS 'ราคารวมจาก master data รองรับสลักหลัง';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".ref_policy_no; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".ref_policy_no IS 'อ้างอิงเลขกรมธรรม์เดิมสำหรับต่อกรมธรรม์';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".partner_code; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".partner_code IS 'รหัส partner';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".occupation_code; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".occupation_code IS 'รหัส อาชีพ';


--
-- Name: COLUMN "Policy_Car_Act_Discount_Premium".oic_version; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse."Policy_Car_Act_Discount_Premium".oic_version IS 'เวอร์ชั่นของ oic';


--
-- Name: iia_commission; Type: TABLE; Schema: insurverse; Owner: -
--

CREATE TABLE insurverse.iia_commission (
    id integer NOT NULL,
    agn1groupno integer DEFAULT 1,
    agn1brcode character varying(10) DEFAULT '000'::character varying,
    agn1entityid integer,
    agn1code character varying(20),
    agn1level character(1) DEFAULT 'B'::bpchar,
    agn1masterflag character(1) DEFAULT 'Y'::bpchar,
    agncommrate1 numeric(5,2),
    agnshare1 integer DEFAULT 100,
    customergroupid integer,
    outletcode character varying(10) DEFAULT '08'::character varying,
    departmentid integer,
    ovtype1 integer DEFAULT 6,
    description1 character varying(255),
    adjcommrate1 numeric(5,2),
    aobrcode character varying(10) DEFAULT '000'::character varying,
    aoentityid integer,
    agn1groupbrcode character varying(10) DEFAULT '000'::character varying,
    agn1groupid integer,
    partner_code character varying(50),
    policy_type character varying(50),
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(50),
    updated_by character varying(50),
    CONSTRAINT chk_adjcommrate1 CHECK (((adjcommrate1 >= (0)::numeric) AND (adjcommrate1 <= (100)::numeric))),
    CONSTRAINT chk_agn1level CHECK ((agn1level = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar]))),
    CONSTRAINT chk_agn1masterflag CHECK ((agn1masterflag = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))),
    CONSTRAINT chk_agncommrate1 CHECK (((agncommrate1 >= (0)::numeric) AND (agncommrate1 <= (100)::numeric)))
);


--
-- Name: TABLE iia_commission; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON TABLE insurverse.iia_commission IS 'Commission table for IIA system';


--
-- Name: COLUMN iia_commission.id; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.id IS 'Primary key - auto increment';


--
-- Name: COLUMN iia_commission.agn1groupno; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1groupno IS 'Agent group number - default = 1';


--
-- Name: COLUMN iia_commission.agn1brcode; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1brcode IS 'Agent branch code - default = 000';


--
-- Name: COLUMN iia_commission.agn1entityid; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1entityid IS 'Agent entity ID - TQM UAT=6028, PROD=63345';


--
-- Name: COLUMN iia_commission.agn1code; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1code IS 'Agent code - TQM UAT=B6028, PROD=B63345';


--
-- Name: COLUMN iia_commission.agn1level; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1level IS 'Agent level - TQM = B';


--
-- Name: COLUMN iia_commission.agn1masterflag; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1masterflag IS 'Agent master flag - TQM = Y';


--
-- Name: COLUMN iia_commission.agncommrate1; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agncommrate1 IS 'Agent commission rate (%) - TQM com-rate';


--
-- Name: COLUMN iia_commission.agnshare1; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agnshare1 IS 'Agent share - TQM = 100';


--
-- Name: COLUMN iia_commission.customergroupid; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.customergroupid IS 'Customer group ID - TQM UAT=8, PROD=22';


--
-- Name: COLUMN iia_commission.outletcode; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.outletcode IS 'Outlet code - TQM = 08';


--
-- Name: COLUMN iia_commission.departmentid; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.departmentid IS 'Department ID';


--
-- Name: COLUMN iia_commission.ovtype1; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.ovtype1 IS 'Override type - TQM = 6';


--
-- Name: COLUMN iia_commission.description1; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.description1 IS 'Description field';


--
-- Name: COLUMN iia_commission.adjcommrate1; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.adjcommrate1 IS 'Adjusted commission rate (%) - TQM adjust com-rate';


--
-- Name: COLUMN iia_commission.aobrcode; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.aobrcode IS 'AO branch code - default = 000';


--
-- Name: COLUMN iia_commission.aoentityid; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.aoentityid IS 'AO entity ID - TQM UAT=13, PROD=60257';


--
-- Name: COLUMN iia_commission.agn1groupbrcode; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1groupbrcode IS 'Agent group branch code - TQM = 000';


--
-- Name: COLUMN iia_commission.agn1groupid; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.agn1groupid IS 'Agent group ID - TQM group id';


--
-- Name: COLUMN iia_commission.partner_code; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.partner_code IS 'Partner code - e.g., TQM';


--
-- Name: COLUMN iia_commission.policy_type; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.policy_type IS 'MC,MV';


--
-- Name: COLUMN iia_commission.created_date; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.created_date IS 'Record creation date';


--
-- Name: COLUMN iia_commission.updated_date; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.updated_date IS 'Record last update date';


--
-- Name: COLUMN iia_commission.created_by; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.created_by IS 'User who created the record';


--
-- Name: COLUMN iia_commission.updated_by; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.iia_commission.updated_by IS 'User who last updated the record';


--
-- Name: shopee_product_form; Type: TABLE; Schema: insurverse; Owner: -
--

CREATE TABLE insurverse.shopee_product_form (
    id integer,
    category character varying(255),
    sub_catagory character varying(255),
    productname character varying(255),
    sub_productname character varying(255),
    parance_sku character varying(255),
    sub_sku character varying(255),
    claim_price numeric(8,2),
    price numeric(8,2),
    discount numeric(8,2),
    listing_test boolean,
    link_test character varying(255),
    link character varying(255),
    status character varying(50),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    sms_temp text,
    si_limit integer,
    insurance_class character varying(50),
    product_type character varying(50) DEFAULT 'MC'::character varying,
    include_act boolean DEFAULT false
);

ALTER TABLE ONLY insurverse.shopee_product_form REPLICA IDENTITY FULL;


--
-- Name: tqm_car_mapping; Type: TABLE; Schema: insurverse; Owner: -
--

CREATE TABLE insurverse.tqm_car_mapping (
    id integer NOT NULL,
    brand_code character varying(10) NOT NULL,
    brand character varying(50) NOT NULL,
    model_code character varying(20) NOT NULL,
    model character varying(100) NOT NULL,
    vehicle_type character varying(5) NOT NULL,
    isv_brand character varying(50) NOT NULL,
    isv_model character varying(20) NOT NULL,
    isv_cc character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE tqm_car_mapping; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON TABLE insurverse.tqm_car_mapping IS 'Car mapping table for TQM system';


--
-- Name: COLUMN tqm_car_mapping.id; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.id IS 'Primary key auto-increment';


--
-- Name: COLUMN tqm_car_mapping.brand_code; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.brand_code IS 'Brand code identifier';


--
-- Name: COLUMN tqm_car_mapping.brand; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.brand IS 'Brand name';


--
-- Name: COLUMN tqm_car_mapping.model_code; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.model_code IS 'Model code identifier';


--
-- Name: COLUMN tqm_car_mapping.model; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.model IS 'Model name';


--
-- Name: COLUMN tqm_car_mapping.vehicle_type; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.vehicle_type IS 'Vehicle type (PS=Passenger, SV=SUV, etc.)';


--
-- Name: COLUMN tqm_car_mapping.isv_brand; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.isv_brand IS 'ISV brand mapping';


--
-- Name: COLUMN tqm_car_mapping.isv_model; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.isv_model IS 'ISV model mapping';


--
-- Name: COLUMN tqm_car_mapping.isv_cc; Type: COMMENT; Schema: insurverse; Owner: -
--

COMMENT ON COLUMN insurverse.tqm_car_mapping.isv_cc IS 'Engine displacement category';


--
-- Name: tqm_group_premium; Type: TABLE; Schema: insurverse; Owner: -
--

CREATE TABLE insurverse.tqm_group_premium (
    id integer NOT NULL,
    level_name character varying(100) NOT NULL,
    repair_type character varying(100) NOT NULL,
    group_code character varying(50) NOT NULL,
    package_code character varying(50) NOT NULL,
    car_year_min integer NOT NULL,
    car_year_max integer NOT NULL,
    brand character varying(50) NOT NULL,
    model character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(50),
    updated_by character varying(50),
    is_vehicle_need_inspection boolean
);


--
-- Name: tqm_premium; Type: TABLE; Schema: insurverse; Owner: -
--

CREATE TABLE insurverse.tqm_premium (
    id integer NOT NULL,
    iia_mv_package_id integer,
    car_participant integer,
    "group" character varying(50),
    package character varying(50),
    cc character varying(50),
    year integer,
    si numeric,
    basic_premium numeric,
    tariff_usage numeric,
    tariff_size numeric,
    tariff_age numeric,
    tariff_si numeric,
    tariff_group numeric,
    tpbi_p numeric,
    tppd numeric,
    tpbi_e numeric,
    total_amt_exclude_mv numeric,
    mv_01 numeric,
    mv_02 numeric,
    mv_03 numeric,
    si_mv_01 numeric,
    si_mv_02 numeric,
    si_mv_03 numeric,
    total_amt_mv numeric,
    before_discount_amt numeric,
    fleet_disc_perc numeric,
    fleet_disc_amt numeric,
    ncb_disc_perc numeric,
    ncb_disc_amt numeric,
    other_disc_perc numeric,
    other_disc_amt numeric,
    perm_amt numeric,
    duty_amt numeric,
    vat_amt numeric,
    total_amt numeric,
    deduct numeric,
    sc_premium_amt numeric
);


--
-- Name: Policy_Car_Act_Discount_Premium Car_Act_Discount_Premium_pkey; Type: CONSTRAINT; Schema: insurverse; Owner: -
--

ALTER TABLE ONLY insurverse."Policy_Car_Act_Discount_Premium"
    ADD CONSTRAINT "Car_Act_Discount_Premium_pkey" PRIMARY KEY ("Car_Act_No");


--
-- Name: iia_commission iia_commission_pkey; Type: CONSTRAINT; Schema: insurverse; Owner: -
--

ALTER TABLE ONLY insurverse.iia_commission
    ADD CONSTRAINT iia_commission_pkey PRIMARY KEY (id);


--
-- Name: tqm_car_mapping tqm_car_mapping_pkey; Type: CONSTRAINT; Schema: insurverse; Owner: -
--

ALTER TABLE ONLY insurverse.tqm_car_mapping
    ADD CONSTRAINT tqm_car_mapping_pkey PRIMARY KEY (id);


--
-- Name: tqm_group_premium tqm_group_premium_pkey; Type: CONSTRAINT; Schema: insurverse; Owner: -
--

ALTER TABLE ONLY insurverse.tqm_group_premium
    ADD CONSTRAINT tqm_group_premium_pkey PRIMARY KEY (id);


--
-- Name: tqm_premium tqm_premium_pkey; Type: CONSTRAINT; Schema: insurverse; Owner: -
--

ALTER TABLE ONLY insurverse.tqm_premium
    ADD CONSTRAINT tqm_premium_pkey PRIMARY KEY (id);


--
-- Name: tqm_group_premium unique_group_package_brand_model; Type: CONSTRAINT; Schema: insurverse; Owner: -
--

ALTER TABLE ONLY insurverse.tqm_group_premium
    ADD CONSTRAINT unique_group_package_brand_model UNIQUE (group_code, package_code, brand, model);


--
-- Name: tqm_premium uq_group_package_si; Type: CONSTRAINT; Schema: insurverse; Owner: -
--

ALTER TABLE ONLY insurverse.tqm_premium
    ADD CONSTRAINT uq_group_package_si UNIQUE ("group", package, year, si, cc);


--
-- Name: idx_iia_commission_agn1code; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_iia_commission_agn1code ON insurverse.iia_commission USING btree (agn1code);


--
-- Name: idx_iia_commission_agn1entityid; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_iia_commission_agn1entityid ON insurverse.iia_commission USING btree (agn1entityid);


--
-- Name: idx_iia_commission_created_date; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_iia_commission_created_date ON insurverse.iia_commission USING btree (created_date);


--
-- Name: idx_iia_commission_customergroupid; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_iia_commission_customergroupid ON insurverse.iia_commission USING btree (customergroupid);


--
-- Name: idx_iia_commission_partner_code; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_iia_commission_partner_code ON insurverse.iia_commission USING btree (partner_code);


--
-- Name: idx_pcadp_lead_no; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_pcadp_lead_no ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Lead_No");


--
-- Name: idx_pcadp_pair_lookup; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_pcadp_pair_lookup ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Car_license_no", "Car_serial_no") WHERE ((("Policy_Status")::text = 'ACT'::text) AND ("Policy_No" IS NULL) AND ("Car_serial_no" IS NOT NULL) AND (("Car_serial_no")::text <> ''::text));


--
-- Name: idx_pcadp_policy_no; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_pcadp_policy_no ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Policy_No");


--
-- Name: idx_pcadp_ref_policy_no; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_pcadp_ref_policy_no ON insurverse."Policy_Car_Act_Discount_Premium" USING btree (ref_policy_no);


--
-- Name: idx_shopee_product_form_product_type; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_shopee_product_form_product_type ON insurverse.shopee_product_form USING btree (product_type);


--
-- Name: idx_tqm_car_mapping_brand_code; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_tqm_car_mapping_brand_code ON insurverse.tqm_car_mapping USING btree (brand_code);


--
-- Name: idx_tqm_car_mapping_isv_brand; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_tqm_car_mapping_isv_brand ON insurverse.tqm_car_mapping USING btree (isv_brand);


--
-- Name: idx_tqm_car_mapping_model_code; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_tqm_car_mapping_model_code ON insurverse.tqm_car_mapping USING btree (model_code);


--
-- Name: idx_tqm_car_mapping_vehicle_type; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX idx_tqm_car_mapping_vehicle_type ON insurverse.tqm_car_mapping USING btree (vehicle_type);


--
-- Name: tqm_group_premium_brand_model_index; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX tqm_group_premium_brand_model_index ON insurverse.tqm_group_premium USING btree (brand, model);


--
-- Name: tqm_group_premium_group_code_index; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX tqm_group_premium_group_code_index ON insurverse.tqm_group_premium USING btree (group_code);


--
-- Name: tqm_group_premium_package_code_index; Type: INDEX; Schema: insurverse; Owner: -
--

CREATE INDEX tqm_group_premium_package_code_index ON insurverse.tqm_group_premium USING btree (package_code);


--
-- Name: iia_commission update_iia_commission_updated_date; Type: TRIGGER; Schema: insurverse; Owner: -
--

CREATE TRIGGER update_iia_commission_updated_date BEFORE UPDATE ON insurverse.iia_commission FOR EACH ROW EXECUTE FUNCTION insurverse.update_updated_date_column();


--
-- Name: tqm_car_mapping update_tqm_car_mapping_updated_at; Type: TRIGGER; Schema: insurverse; Owner: -
--

CREATE TRIGGER update_tqm_car_mapping_updated_at BEFORE UPDATE ON insurverse.tqm_car_mapping FOR EACH ROW EXECUTE FUNCTION insurverse.update_updated_at_column();


--
-- PostgreSQL database dump complete
--

\unrestrict H9fgB4eGopescMQ1Xt8PbGxq9Yl08Idd5kQhKVtukU1Ada3WhseKOebgnfX9cgJ

