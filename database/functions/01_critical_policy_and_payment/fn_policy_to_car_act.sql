-- =============================================================================
-- Function: insurverse.fn_policy_to_car_act
-- OID: 28535
-- Identity Arguments: (policy_no text)
-- Returns: TABLE(car_act_no text, rtn_policy_no text)
-- Language: plpgsql
-- Categorization: 01_critical_policy_and_payment
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_to_car_act(policy_no text)
 RETURNS TABLE(car_act_no text, rtn_policy_no text)
 LANGUAGE plpgsql
AS $function$
    /*
    EXAMPLE :
    SELECT "car_act_no", "rtn_policy_no"
    FROM fn_policy_to_car_act('MV-0023-C-001735')
    */
    DECLARE
    SYS_POLICY_NO_IN_AND_UP TEXT; SYS_LEAD_NO INT; SYS_MONTH_ARRAY TEXT[];
    SYS_START_DATE TIMESTAMP; SYS_END_DATE TIMESTAMP;
    SYS_CAR_ACT_NO TEXT; SYS_EFFECTIVE_STARTDATE TIMESTAMP;
    MC_NO_LAST INT; MC_NO_MOD INT; MC_NO TEXT; MC_NO_PREFIX TEXT; SYS_EXISTS BOOLEAN;
    MC_BRAND TEXT; MC_MODEL TEXT; MC_YEAR TEXT;
    MC_DOOR INT; MC_SEAT INT; MC_WG INT; MC_USAGE SMALLINT;
    MC_GROUP TEXT; MC_TYPE TEXT; MC_SEDAN TEXT; MC_BODYTYPE TEXT;
    MC_PAYMENT_STATUS TEXT; MC_PAYMENT_CHANNEL TEXT; MC_PAYMENT_TYPE TEXT; MC_PAYMENT_NO TEXT;
    MC_PAYMENT_REF1 TEXT; MC_PAYMENT_REF2 TEXT; MC_PAYMENT_RESULT TEXT;
    MC_RECEPT_NO TEXT; MC_TAX_NO TEXT; MC_FLEX_FIELD1 TEXT; MC_FLEX_FIELD2 TEXT; MC_FLEX_FIELD3 TEXT;
    MC_FIRST_NAME TEXT; MC_LAST_NAME TEXT; MC_EMAIL TEXT; MC_PHONE TEXT;
    MC_FLAG_CA TEXT;
    MC_POLICY_BOOK TEXT; MC_POLICY_QUA_NO TEXT; MC_POLICY_INC_NO TEXT;
    MC_REF_POLICY_NO TEXT; MC_RENEWAL_MC_STARTDATE TIMESTAMP; MC_RENEWAL_MC_ENDDATE TIMESTAMP;
    IC_COMP_CODE TEXT; IC_PREMIUM DECIMAL(18,2); IC_DISCOUNT DECIMAL(18,2); IC_NET_PREMIUM DECIMAL(18,2);
    IC_STAMP DECIMAL(18,2); IC_VAT DECIMAL(18,2); IC_TOTAL DECIMAL(18,2);
    FIX_PREMIUM DECIMAL(18,2); FIX_DISCOUNT DECIMAL(18,2); FIX_NET_PREMIUM DECIMAL(18,2);
    FIX_STAMP DECIMAL(18,2); FIX_VAT DECIMAL(18,2); FIX_TOTAL DECIMAL(18,2);
    PH_EMAIL TEXT; PH_OWNER_PREFIX_NAME TEXT; PH_OWNER_FIRST_NAME TEXT; PH_OWNER_LAST_NAME TEXT; PH_OWBER_BIRTH_DATE DATE;
    PH_OWNER_CITIZEN_ID TEXT; PH_OWNER_PHONE TEXT; PH_OWNER_OCCUPATION TEXT; PH_OWNER_ADDRESS TEXT;
    PH_OWNER_SUBDISTRICT_ID INT; PH_OWNER_DISTRICT_ID INT; PH_OWNER_PROVINCE_ID INT; PH_OWNER_ZIPCODE TEXT;
    PH_CC TEXT; PH_CAR_LINCENSE_NO TEXT; PH_CAR_LICENSE_PROVINCE TEXT; PH_CAR_SERIAL_NO TEXT; PH_CAR_LICENSE_TYPE TEXT; PH_CAR_COLOR TEXT;
    PH_FLAG_DELI TEXT; PH_DELI_ADDR_LINE1 TEXT; PH_DELI_ADDR_LINE2 TEXT; PH_DELI_ADDR_LINE3 TEXT;
    PH_DELI_SUBDISTRICT_ID INT; PH_DELI_DISTRICT_ID INT; PH_DELI_PROVINCE_ID INT; PH_DELI_ZIPCODE TEXT; PH_DELI_COUNTRY_ID INT;
    PH_BENE_TYPE TEXT; PH_BENE_TITLE TEXT; PH_BENE_FRISTNAME TEXT; PH_BENE_MIDNAME TEXT; PH_BENE_LASTNAME TEXT; PH_BENE_ID_CARD TEXT;
    PH_IIA_LOT TEXT;
    PM_PAYMENT_DATE TIMESTAMP;
    MC_PREM_ACT NUMERIC; MC_PREM_TOTAL NUMERIC;
    PH_PARTNER_CODE TEXT;
    BEGIN

    SYS_START_DATE = CURRENT_TIMESTAMP; -- UPDATE FROM Personal Form
    SYS_END_DATE = (CURRENT_DATE - INTERVAL '1 DAY') + INTERVAL '1 YEAR' + INTERVAL '16 HOUR' + INTERVAL '30 MINUTE'; -- UPDATE FROM Personal Form
    SYS_MONTH_ARRAY := array ['A','B','C','D','E','F','G','H','I','J','K','L'];
    MC_NO_PREFIX = 'MC-00' || TO_CHAR(now()+ INTERVAL '7 HOUR','yy') || '-' || SYS_MONTH_ARRAY[CAST(TO_CHAR(now()+ INTERVAL '7 HOUR','mm') AS INT)];

    SELECT "Lead_No"
    FROM insurverse."Policy_coverage_premium"
    WHERE "Policy_No"=policy_no
    ORDER BY "Effective_Startdate" DESC
    LIMIT 1
    INTO SYS_LEAD_NO;

    -- MC_NO is allocated further down, under the advisory lock, and only when a
    -- compulsory policy is actually inserted.

    SELECT "Brand","Model","Year","Doors","Seat","Wg",
    "Group","Type","Sedan","BodyType","Usage",
    "Payment_status","Payment_channel","Payment_type","Payment_No",
    "Payment_Ref1","Payment_Ref2","Payment_result",
    "Recept_no","Tax_No","Flex_field1","Flex_field2","Flex_field3",
    "FirstName","LastName","Email","Mobile",
    "Flag_Car_Act", -- UPDATE FROM Personal Form
    "Policy_book_act","Policy_Quatation_No_act","Policy_Invoice_No_act",
    "Prem_ACT",
    "ref_policy_no","renewal_mc_startdate","renewal_mc_enddate"
    FROM insurverse."Lead_coverage_premium"
    WHERE "Lead_No"=SYS_LEAD_NO
    INTO MC_BRAND,MC_MODEL,MC_YEAR,MC_DOOR,MC_SEAT,MC_WG,
    MC_GROUP,MC_TYPE,MC_SEDAN,MC_BODYTYPE,MC_USAGE,
    MC_PAYMENT_STATUS,MC_PAYMENT_CHANNEL,MC_PAYMENT_TYPE,MC_PAYMENT_NO,
    MC_PAYMENT_REF1,MC_PAYMENT_REF2,MC_PAYMENT_RESULT,
    MC_RECEPT_NO,MC_TAX_NO,MC_FLEX_FIELD1,MC_FLEX_FIELD2,MC_FLEX_FIELD3,
    MC_FIRST_NAME,MC_LAST_NAME,MC_EMAIL,MC_PHONE,
    MC_FLAG_CA,
    MC_POLICY_BOOK,MC_POLICY_QUA_NO,MC_POLICY_INC_NO,
    MC_PREM_ACT,
    MC_REF_POLICY_NO,MC_RENEWAL_MC_STARTDATE,MC_RENEWAL_MC_ENDDATE;

    IF MC_REF_POLICY_NO IS NOT NULL AND MC_REF_POLICY_NO != '' THEN
        SELECT "Car_Act_No"
        FROM insurverse."Policy_Header"
        WHERE "Policy_No"=MC_REF_POLICY_NO
        INTO MC_REF_POLICY_NO;
    END IF;

    IF MC_FLAG_CA IS NOT NULL AND (MC_FLAG_CA='Y' OR MC_FLAG_CA='y') THEN

        SELECT "Comp_Code","Premium","Discount","Net_Premium","Stamp","Vat","Total"
        FROM insurverse."Imp_Discount_Premium"
        WHERE "Brand"=MC_BRAND AND "Model"=MC_MODEL AND "Year"=MC_YEAR
        AND "BodyType"=MC_BODYTYPE AND "Doors"=MC_DOOR
        INTO IC_COMP_CODE,IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,
        IC_STAMP,IC_VAT,IC_TOTAL;

        IF MC_PREM_ACT != IC_TOTAL THEN
            MC_PREM_TOTAL = null;
            SELECT "Premium","Discount","Net_Premium","Stamp","Vat","Total","Total"
            FROM insurverse."Policy_Car_Act_Discount_Premium"
            WHERE "Total"=MC_PREM_ACT
            ORDER BY "Create_date" DESC
            LIMIT 1
            INTO FIX_PREMIUM,FIX_DISCOUNT,FIX_NET_PREMIUM,FIX_STAMP,FIX_VAT,FIX_TOTAL,MC_PREM_TOTAL;

            IF MC_PREM_TOTAL IS NOT NULL THEN
                IC_PREMIUM = FIX_PREMIUM;
                IC_DISCOUNT = FIX_DISCOUNT;
                IC_NET_PREMIUM = FIX_NET_PREMIUM;
                IC_STAMP = FIX_STAMP;
                IC_VAT = FIX_VAT;
                IC_TOTAL = FIX_TOTAL;
            END IF;
        END IF;

        SELECT "email","Owner_prefix_name","Owner_first_name","Owner_last_name","Owner_birth_date",
        "Owner_citizen_id","Owner_phone","Owner_occupation","Owner_address",
        "Owner_subdistrict_id","Owner_district_id","Owner_province_id","Owner_zipcode",
        "CC","Car_license_no","Car_license_provice","Car_serial_no","Car_license_type","Car_color",
        "Flag_Deli","Deli_Addr_line1","Deli_Addr_line2","Deli_Addr_line3",
        "Deli_subdistrict_id","Deli_district_id","Deli_province_id","Deli_zipcode","Deli_countryid",
        "Bene_Type","Bene_Title","Bene_Firstname","Bene_Midname","Bene_Lastname","Bene_ID_card",
        "IIA_Lot_No","partner_code"
        FROM insurverse."Policy_Header"
        WHERE "Policy_No"=policy_no
        ORDER BY "Effective_Startdate" DESC
        LIMIT 1
        INTO PH_EMAIL,PH_OWNER_PREFIX_NAME,PH_OWNER_FIRST_NAME,PH_OWNER_LAST_NAME,PH_OWBER_BIRTH_DATE,
        PH_OWNER_CITIZEN_ID,PH_OWNER_PHONE,PH_OWNER_OCCUPATION,PH_OWNER_ADDRESS,
        PH_OWNER_SUBDISTRICT_ID,PH_OWNER_DISTRICT_ID,PH_OWNER_PROVINCE_ID,PH_OWNER_ZIPCODE,
        PH_CC,PH_CAR_LINCENSE_NO,PH_CAR_LICENSE_PROVINCE,PH_CAR_SERIAL_NO,PH_CAR_LICENSE_TYPE,PH_CAR_COLOR,
        PH_FLAG_DELI,PH_DELI_ADDR_LINE1,PH_DELI_ADDR_LINE2,PH_DELI_ADDR_LINE3,
        PH_DELI_SUBDISTRICT_ID,PH_DELI_DISTRICT_ID,PH_DELI_PROVINCE_ID,PH_DELI_ZIPCODE,PH_DELI_COUNTRY_ID,
        PH_BENE_TYPE,PH_BENE_TITLE,PH_BENE_FRISTNAME,PH_BENE_MIDNAME,PH_BENE_LASTNAME,PH_BENE_ID_CARD,
        PH_IIA_LOT,PH_PARTNER_CODE;

        SELECT "updated_at"
        FROM insurverse."payment"
        WHERE "lead_no"=SYS_LEAD_NO AND "payment_status"='SUCCESS'
        INTO PM_PAYMENT_DATE;

        -- fn_lead_to_car_act(bigint) allocates from the same MC- month prefix and holds
        -- this same lock, so the two allocators now queue behind each other. Taken before
        -- the existence check so two concurrent calls for one policy cannot both insert.
        PERFORM pg_advisory_xact_lock(hashtext(MC_NO_PREFIX));

        SYS_POLICY_NO_IN_AND_UP = '';
        SELECT "Policy_No","Effective_Startdate","Car_Act_No"
        FROM insurverse."Policy_Car_Act_Discount_Premium"
        WHERE "Policy_No"=policy_no
        ORDER BY "Effective_Startdate" DESC
        LIMIT 1
        INTO SYS_POLICY_NO_IN_AND_UP,SYS_EFFECTIVE_STARTDATE,SYS_CAR_ACT_NO;

        IF SYS_POLICY_NO_IN_AND_UP IS NULL OR SYS_POLICY_NO_IN_AND_UP = '' THEN

            -- same allocation as fn_lead_to_car_act(bigint): MAX()+1, then step past any
            -- number that is already taken (the check hits the Car_Act_No primary key)
            EXECUTE
            'SELECT COALESCE(CAST(SUBSTR("Car_Act_No",11,5) AS INT),0)
            FROM insurverse."Policy_Car_Act_Discount_Premium"
            WHERE "Car_Act_No" LIKE ''' || MC_NO_PREFIX || '%''' ||
            'ORDER BY "Car_Act_No" DESC
            LIMIT 1'
            INTO MC_NO_LAST;

            IF MC_NO_LAST IS NULL THEN
                MC_NO_LAST = 0;
            END IF;

            LOOP
                MC_NO_LAST = MC_NO_LAST + 1;
                MC_NO_MOD = MOD(MC_NO_LAST, 8);
                MC_NO = MC_NO_PREFIX || '-' || regexp_replace(TO_CHAR(MC_NO_LAST, '00000'), '[^\w]+', '') || MC_NO_MOD;

                EXECUTE 'SELECT EXISTS (SELECT 1 FROM insurverse."Policy_Car_Act_Discount_Premium" WHERE "Car_Act_No" = $1)'
                INTO SYS_EXISTS
                USING MC_NO;

                EXIT WHEN NOT SYS_EXISTS;
            END LOOP;

            INSERT INTO insurverse."Policy_Car_Act_Discount_Premium"
            ("Car_Act_No","Policy_No","Effective_Startdate","Effective_Enddate","Start_date","End_date","Create_date",
            "Brand","Model","Year","Doors","Seat","Wg",
            "Group","Type","Sedan","BodyType",
            "Payment_status","Payment_channel","Payment_type","Payment_No",
            "Payment_Ref1","Payment_Ref2","Payment_result",
            "Recept_no","Tax_No","Flex_field1","Flex_field2","Flex_field3",
            "prefix_name","first_name","last_name","email","phone","birth_date",
            "Car_Comp_Code","Premium","Discount","Net_Premium","Stamp","Vat","Total",
            "Comp_Code","Lead_No",
            "citizen_id","Occupation","address",
            "subdistrict_id","district_id","province_id","zipcode",
            "CC","Car_license_no","Car_license_provice","Car_serial_no","Car_license_type","Car_color",
            "Flag_Deli","Deli_Addr_line1","Deli_Addr_line2","Deli_Addr_line3",
            "Deli_subdistrict_id","Deli_district_id","Deli_province_id","Deli_zipcode","Deli_countryid",
            "Bene_Type","Bene_Title","Bene_Firstname","Bene_Midname","Bene_Lastname","Bene_ID_card",
            "Policy_Barcode","Payment_date",
            "Policy_Quatation_No","Policy_book","Policy_Invoice_No","IIA_Lot_No",
            "Policy_Status",
            "mas_premium","mas_discount","mas_net_premium","mas_stamp","mas_vat","mas_total",
            "ref_policy_no","partner_code"
            )
            VALUES(MC_NO,policy_no, CURRENT_TIMESTAMP,SYS_END_DATE,SYS_START_DATE,SYS_END_DATE,CURRENT_TIMESTAMP,
            MC_BRAND,MC_MODEL,MC_YEAR,MC_DOOR,MC_SEAT,MC_WG,
            MC_GROUP,MC_TYPE,MC_SEDAN,MC_BODYTYPE,
            MC_PAYMENT_STATUS,MC_PAYMENT_CHANNEL,MC_PAYMENT_TYPE,MC_PAYMENT_NO,
            MC_PAYMENT_REF1,MC_PAYMENT_REF2,MC_PAYMENT_RESULT,
            MC_RECEPT_NO,MC_TAX_NO,MC_FLEX_FIELD1,MC_FLEX_FIELD2,MC_FLEX_FIELD3,
            PH_OWNER_PREFIX_NAME,PH_OWNER_FIRST_NAME,PH_OWNER_LAST_NAME,PH_EMAIL,PH_OWNER_PHONE,PH_OWBER_BIRTH_DATE,
            IC_COMP_CODE,IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,IC_STAMP,IC_VAT,IC_TOTAL,
            'ISV',SYS_LEAD_NO,
            PH_OWNER_CITIZEN_ID,PH_OWNER_OCCUPATION,PH_OWNER_ADDRESS,
            PH_OWNER_SUBDISTRICT_ID,PH_OWNER_DISTRICT_ID,PH_OWNER_PROVINCE_ID,PH_OWNER_ZIPCODE,
            PH_CC,PH_CAR_LINCENSE_NO,PH_CAR_LICENSE_PROVINCE,PH_CAR_SERIAL_NO,PH_CAR_LICENSE_TYPE,PH_CAR_COLOR,
            PH_FLAG_DELI,PH_DELI_ADDR_LINE1,PH_DELI_ADDR_LINE2,PH_DELI_ADDR_LINE3,
            PH_DELI_SUBDISTRICT_ID,PH_DELI_DISTRICT_ID,PH_DELI_PROVINCE_ID,PH_DELI_ZIPCODE,PH_DELI_COUNTRY_ID,
            PH_BENE_TYPE,PH_BENE_TITLE,PH_BENE_FRISTNAME,PH_BENE_MIDNAME,PH_BENE_LASTNAME,PH_BENE_ID_CARD,
            insurverse.fn_policy_barcode(),PM_PAYMENT_DATE,
            MC_POLICY_QUA_NO,MC_POLICY_BOOK,MC_POLICY_INC_NO,PH_IIA_LOT,
            'ACT',
            IC_PREMIUM,IC_DISCOUNT,IC_NET_PREMIUM,IC_STAMP,IC_VAT,IC_TOTAL,
            MC_REF_POLICY_NO,PH_PARTNER_CODE
            );

            UPDATE insurverse."Policy_Header"
            SET "Car_Act_No"=MC_NO
            WHERE "Policy_No"=policy_no;

        ELSE

            UPDATE insurverse."Policy_Car_Act_Discount_Premium"
            SET "Brand"=MC_BRAND,"Model"=MC_MODEL,"Year"=MC_YEAR,"Doors"=MC_DOOR,"Seat"=MC_SEAT,"Wg"=MC_WG,
            "Group"=MC_GROUP,"Type"=MC_TYPE,"Sedan"=MC_SEDAN,"BodyType"=MC_BODYTYPE,
            "Payment_status"=MC_PAYMENT_STATUS,"Payment_channel"=MC_PAYMENT_CHANNEL,"Payment_type"=MC_PAYMENT_TYPE,"Payment_No"=MC_PAYMENT_NO,
            "Payment_Ref1"=MC_PAYMENT_REF1,"Payment_Ref2"=MC_PAYMENT_REF2,"Payment_result"=MC_PAYMENT_RESULT,
            "Recept_no"=MC_RECEPT_NO,"Tax_No"=MC_TAX_NO,"Flex_field1"=MC_FLEX_FIELD1,"Flex_field2"=MC_FLEX_FIELD2,"Flex_field3"=MC_FLEX_FIELD3,
            "prefix_name"=PH_OWNER_PREFIX_NAME,"first_name"=PH_OWNER_FIRST_NAME,"last_name"=PH_OWNER_LAST_NAME,"email"=PH_EMAIL,"phone"=PH_OWNER_PHONE,"birth_date"=PH_OWBER_BIRTH_DATE,
            "Car_Comp_Code"=IC_COMP_CODE,"Premium"=IC_PREMIUM,"Discount"=IC_DISCOUNT,"Net_Premium"=IC_NET_PREMIUM,"Stamp"=IC_STAMP,"Vat"=IC_VAT,"Total"=IC_TOTAL,
            "Comp_Code"='ISV',"Lead_No"=SYS_LEAD_NO,
            "citizen_id"=PH_OWNER_CITIZEN_ID,"Occupation"=PH_OWNER_OCCUPATION,"address"=PH_OWNER_ADDRESS,
            "subdistrict_id"=PH_OWNER_SUBDISTRICT_ID,"district_id"=PH_OWNER_DISTRICT_ID,"province_id"=PH_OWNER_PROVINCE_ID,"zipcode"=PH_OWNER_ZIPCODE,
            "CC"=PH_CC,"Car_license_no"=PH_CAR_LINCENSE_NO,"Car_license_provice"=PH_CAR_LICENSE_PROVINCE,"Car_serial_no"=PH_CAR_SERIAL_NO,"Car_license_type"=PH_CAR_LICENSE_TYPE,"Car_color"=PH_CAR_COLOR,
            "Flag_Deli"=PH_FLAG_DELI,"Deli_Addr_line1"=PH_DELI_ADDR_LINE1,"Deli_Addr_line2"=PH_DELI_ADDR_LINE2,"Deli_Addr_line3"=PH_DELI_ADDR_LINE3,
            "Deli_subdistrict_id"=PH_DELI_SUBDISTRICT_ID,"Deli_district_id"=PH_DELI_DISTRICT_ID,"Deli_province_id"=PH_DELI_PROVINCE_ID,"Deli_zipcode"=PH_DELI_ZIPCODE,"Deli_countryid"=PH_DELI_COUNTRY_ID,
            "Bene_Type"=PH_BENE_TYPE,"Bene_Title"=PH_BENE_TITLE,"Bene_Firstname"=PH_BENE_FRISTNAME,"Bene_Midname"=PH_BENE_MIDNAME,"Bene_Lastname"=PH_BENE_LASTNAME,"Bene_ID_card"=PH_BENE_ID_CARD,
            "Payment_date"=PM_PAYMENT_DATE,
            "IIA_Lot_No"=PH_IIA_LOT
            WHERE "Policy_No"=policy_no AND "Car_Act_No"=SYS_CAR_ACT_NO;

            UPDATE insurverse."Policy_Header"
            SET "Car_Act_No"=SYS_CAR_ACT_NO
            WHERE "Policy_No"=policy_no;

            MC_NO=SYS_CAR_ACT_NO;

        END IF;
    ELSE
        MC_NO = '';

    END IF;

    RETURN QUERY SELECT MC_NO,policy_no;
END $function$
