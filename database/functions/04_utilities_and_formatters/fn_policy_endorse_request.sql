-- =============================================================================
-- Function: insurverse.fn_policy_endorse_request
-- OID: 18618
-- Identity Arguments: ("in_insurancePolicyId" text, "in_carLicenseProvinceId" text, "in_deliProvinceId" text, "in_deliDistrictId" text, "in_deliSubdistrictId" text, "in_carLicenseType" text, "in_par1Prefix" text, "in_par2Prefix" text, "in_accessHave" text, "in_carCc" text, "in_driveAction" text, "in_driverBirthdate1" text, "in_driverBirthdate2" text, "in_carYear" text, "in_cctvHave" text, "in_extendEnddate" text, "in_accessName" text, "in_accessNameCode" text, "in_accessSiAmt" numeric)
-- Returns: TABLE("insurancePolicyId" character varying, "carLicenseProvinceId" text, "carLicenseProvince" character varying, "deliProvinceId" text, "deliProvince" character varying, "deliDistrictId" text, "deliDistrict" character varying, "deliSubdistrictId" text, "deliSubdistrict" character varying, "carLicenseTypeCode" character varying, "par1PrefixCode" character varying, "par2PrefixCode" character varying, "carBrand" character varying, "carModel" character varying, "basicPremAmt" numeric, "basicPremV5Amt" numeric, usage smallint, "usageTariff" numeric, "carCcCondition" character varying, "carCCTariff" numeric, "driverAge" character varying, "driverAgeDisc" numeric, "driverAgeTariff" numeric, "carYearTariff" numeric, "siAmt" numeric, "carGroup" character varying, "carGroupTariff" numeric, "tpbiPassSIAmt" numeric, "tpbiPassTariff" numeric, "tpbiEventSIAmt" numeric, "tpbiEventTariff" numeric, "tppdSIAmt" numeric, "tppdTariff" numeric, "totalExMvAmt" numeric, "mv01SIAmt" numeric, "mv01PremAmt" numeric, "mv02SIAmt" numeric, "mv02PremAmt" numeric, "mv03SIAmt" numeric, "mv03PremAmt" numeric, "cctvPercent" integer, "fleetDiscPer" numeric, "fleetDiscAmt" numeric, "ncbDiscPer" numeric, "ncbDiscAmt" numeric, "otherDiscPer" numeric, "otherDiscAmt" numeric, "extendPremAmt" numeric, "dutyAmt" numeric, "vatAmt" numeric, "premiumV5Od" numeric, "cctvHave" boolean, "accessHave" boolean, "accessName" text, "accessNameCode" text, "accessSiAmt" numeric)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_endorse_request("in_insurancePolicyId" text, "in_carLicenseProvinceId" text, "in_deliProvinceId" text, "in_deliDistrictId" text, "in_deliSubdistrictId" text, "in_carLicenseType" text, "in_par1Prefix" text, "in_par2Prefix" text, "in_accessHave" text, "in_carCc" text, "in_driveAction" text, "in_driverBirthdate1" text, "in_driverBirthdate2" text, "in_carYear" text, "in_cctvHave" text, "in_extendEnddate" text, "in_accessName" text, "in_accessNameCode" text, "in_accessSiAmt" numeric)
 RETURNS TABLE("insurancePolicyId" character varying, "carLicenseProvinceId" text, "carLicenseProvince" character varying, "deliProvinceId" text, "deliProvince" character varying, "deliDistrictId" text, "deliDistrict" character varying, "deliSubdistrictId" text, "deliSubdistrict" character varying, "carLicenseTypeCode" character varying, "par1PrefixCode" character varying, "par2PrefixCode" character varying, "carBrand" character varying, "carModel" character varying, "basicPremAmt" numeric, "basicPremV5Amt" numeric, usage smallint, "usageTariff" numeric, "carCcCondition" character varying, "carCCTariff" numeric, "driverAge" character varying, "driverAgeDisc" numeric, "driverAgeTariff" numeric, "carYearTariff" numeric, "siAmt" numeric, "carGroup" character varying, "carGroupTariff" numeric, "tpbiPassSIAmt" numeric, "tpbiPassTariff" numeric, "tpbiEventSIAmt" numeric, "tpbiEventTariff" numeric, "tppdSIAmt" numeric, "tppdTariff" numeric, "totalExMvAmt" numeric, "mv01SIAmt" numeric, "mv01PremAmt" numeric, "mv02SIAmt" numeric, "mv02PremAmt" numeric, "mv03SIAmt" numeric, "mv03PremAmt" numeric, "cctvPercent" integer, "fleetDiscPer" numeric, "fleetDiscAmt" numeric, "ncbDiscPer" numeric, "ncbDiscAmt" numeric, "otherDiscPer" numeric, "otherDiscAmt" numeric, "extendPremAmt" numeric, "dutyAmt" numeric, "vatAmt" numeric, "premiumV5Od" numeric, "cctvHave" boolean, "accessHave" boolean, "accessName" text, "accessNameCode" text, "accessSiAmt" numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    WITH set_para AS (
        SELECT
            "in_insurancePolicyId" AS "insurancePolicyId",
            "in_carLicenseProvinceId" AS "carLicenseProvinceId",
            "in_deliProvinceId" AS "deliProvinceId",
            "in_deliDistrictId" AS "deliDistrictId",
            "in_deliSubdistrictId" AS "deliSubdistrictId",
            "in_carLicenseType" AS "carLicenseType",
            "in_par1Prefix" AS "par1Prefix",
            "in_par2Prefix" AS "par2Prefix",
            "in_accessHave" AS "accessHave",
            "in_carCc" AS "carCc",
            "in_driveAction" AS "driveAction",
            "in_driverBirthdate1" AS "driverBirthdate1",
            "in_driverBirthdate2" AS "driverBirthdate2",
            "in_carYear" AS "carYear",
            "in_cctvHave" AS "cctvHave",
            "in_extendEnddate" AS "extendEnddate",
            "in_accessName" AS "accessName",
            "in_accessNameCode" AS "accessNameCode",
            "in_accessSiAmt" AS "accessSiAmt"
    )
    SELECT
        CAST("fi"."insurancePolicyId" AS VARCHAR),
        CAST("fi"."carLicenseProvinceId" AS TEXT),
        CAST("fi"."carLicenseProvince" AS VARCHAR),
        CAST("fi"."deliProvinceId" AS TEXT),
        CAST("fi"."deliProvince" AS VARCHAR),
        CAST("fi"."deliDistrictId" AS TEXT),
        CAST("fi"."deliDistrict" AS VARCHAR),
        CAST("fi"."deliSubdistrictId" AS TEXT),
        CAST("fi"."deliSubdistrict" AS VARCHAR),
        CAST("fi"."carLicenseTypeCode" AS VARCHAR),
        CAST("fi"."par1PrefixCode" AS VARCHAR),
        CAST("fi"."par2PrefixCode" AS VARCHAR),
        CAST("fi"."carBrand" AS VARCHAR),
        CAST("fi"."carModel" AS VARCHAR),
        CAST("fi"."basicPremAmt" AS NUMERIC),
        CAST("fi"."basicPremV5Amt" AS NUMERIC),
        CAST("fi"."usage" AS SMALLINT),
        CAST("fi"."usageTariff" AS NUMERIC),
        CAST("fi"."carCcCondition" AS VARCHAR),
        CAST("fi"."carCCTariff" AS NUMERIC),
        CAST("fi"."driverAge" AS VARCHAR),
        CAST("fi"."driverAgeDisc" AS NUMERIC),
        CAST("fi"."driverAgeTariff" AS NUMERIC),
        CAST("fi"."carYearTariff" AS NUMERIC),
        CAST("fi"."siAmt" AS NUMERIC),
        CAST("fi"."carGroup" AS VARCHAR),
        CAST("fi"."carGroupTariff" AS NUMERIC),
        CAST("fi"."tpbiPassSIAmt" AS NUMERIC),
        CAST("fi"."tpbiPassTariff" AS NUMERIC),
        CAST("fi"."tpbiEventSIAmt" AS NUMERIC),
        CAST("fi"."tpbiEventTariff" AS NUMERIC),
        CAST("fi"."tppdSIAmt" AS NUMERIC),
        CAST("fi"."tppdTariff" AS NUMERIC),
        CAST("fi"."totalExMvAmt" AS NUMERIC),
        CAST("fi"."mv01SIAmt" AS NUMERIC),
        CAST("fi"."mv01PremAmt" AS NUMERIC),
        CAST("fi"."mv02SIAmt" AS NUMERIC),
        CAST("fi"."mv02PremAmt" AS NUMERIC),
        CAST("fi"."mv03SIAmt" AS NUMERIC),
        CAST("fi"."mv03PremAmt" AS NUMERIC),
        CAST("fi"."cctvPercent" AS INTEGER),
        CAST("fi"."fleetDiscPer" AS NUMERIC),
        CAST("fi"."fleetDiscAmt" AS NUMERIC),
        CAST("fi"."ncbDiscPer" AS NUMERIC),
        CAST("fi"."ncbDiscAmt" AS NUMERIC),
        CAST("fi"."otherDiscPer" AS NUMERIC),
        CAST("fi"."otherDiscAmt" AS NUMERIC),
        CAST("fi"."extendPremAmt" AS NUMERIC),
        CAST("fi"."dutyAmt" AS NUMERIC),
        CAST("fi"."vatAmt" AS NUMERIC),
        CAST("fi"."premiumV5Od" AS NUMERIC),
        CAST("fi"."cctvHave" AS BOOL),
        CAST("fi"."accessHave" AS BOOL),
        CAST("fi"."accessName" AS TEXT),
        CAST("fi"."accessNameCode" AS TEXT),
        CAST("fi"."accessSiAmt" AS NUMERIC)
    FROM
    (
        -- mv financial
        SELECT
            "policy"."Policy_No" AS "insurancePolicyId",
            "set_para"."carLicenseProvinceId",
            (
                SELECT "prname"
                FROM insurverse."province"
                WHERE CAST("set_para"."carLicenseProvinceId" AS INT) = CAST("province"."provinceid" AS INT)
            ) AS "carLicenseProvince",
            "set_para"."deliProvinceId",
            (
                SELECT "prname"
                FROM insurverse."province"
                WHERE CAST("set_para"."deliProvinceId" AS INT) = CAST("province"."provinceid" AS INT)
            ) AS "deliProvince",
            "set_para"."deliDistrictId",
            (
                SELECT "diname"
                FROM insurverse."district"
                WHERE CAST("set_para"."deliDistrictId" AS INT) = CAST("district"."districtid" AS INT)
            ) AS "deliDistrict",
            "set_para"."deliSubdistrictId",
            (
                SELECT "sdname"
                FROM insurverse."subdistrict"
                WHERE CAST("set_para"."deliSubdistrictId" AS INT) = CAST("subdistrict"."subdistrictid" AS INT)
            ) AS "deliSubdistrict",
            (
                SELECT "para_code"
                FROM insurverse.sys_param
                WHERE dom_code = 'Policy'
                    AND sub_dom_code = 'Car_license_type'
                    AND para_name = "set_para"."carLicenseType"
            ) AS "carLicenseTypeCode",
            (
                SELECT "para_code"
                FROM insurverse.sys_param
                WHERE dom_code = 'Title'
                    AND para_name = "set_para"."par1Prefix"
            ) AS "par1PrefixCode",
            (
                SELECT "para_code"
                FROM insurverse.sys_param
                WHERE dom_code = 'Title'
                    AND para_name = "set_para"."par2Prefix"
            ) AS "par2PrefixCode",
            CASE
                WHEN "set_para"."accessHave" IS NULL THEN "policy"."Brand"
                ELSE NULL
            END AS "carBrand",
            CASE
                WHEN "set_para"."accessHave" IS NULL THEN "policy"."Model"
                ELSE NULL
            END AS "carModel",
            "prem"."Basic_Premium" AS "basicPremAmt",
            CASE
                WHEN "prem"."basic_premium_v5" IS NOT NULL THEN "prem"."basic_premium_v5"
                ELSE
                    CASE
                        WHEN "set_para"."accessHave" IS NOT NULL THEN COALESCE(
                            (
                                SELECT COALESCE("tariff_amount", 0)
                                FROM insurverse.mas_tariff
                                WHERE tariff_group = 'motor'
                                    AND (
                                        (
                                            "set_para"."accessHave" = 'Y'
                                            AND "tariff_code" = 'base_v5_in_access'
                                        )
                                        OR (
                                            "set_para"."accessHave" != 'Y'
                                            AND "tariff_code" = 'base_v5_ex_access'
                                        )
                                    )
                                    AND "policy_type" = "policy"."Type"
                            ),
                            0
                        )
                        ELSE COALESCE(
                            (
                                SELECT COALESCE("tariff_amount", 0)
                                FROM insurverse.mas_tariff
                                WHERE tariff_group = 'motor'
                                    AND (
                                        (
                                            "prem"."Flag_Access" = 'Y'
                                            AND "tariff_code" = 'base_v5_in_access'
                                        )
                                        OR (
                                            "prem"."Flag_Access" != 'Y'
                                            AND "tariff_code" = 'base_v5_ex_access'
                                        )
                                    )
                                    AND "policy_type" = "policy"."Type"
                            ),
                            0
                        )
                    END
            END AS "basicPremV5Amt",
            "policy"."Usage" AS "usage",
            (
                SELECT "tariff_factor"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'usage'
                    AND LOWER("tariff_mapping") = CAST("prem"."Usage" AS TEXT)
            ) AS "usageTariff",
            (
                SELECT "tariff_mapping"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'size'
                    AND CAST("set_para"."carCc" AS NUMERIC) BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
            ) AS "carCcCondition",
            (
                SELECT "tariff_factor"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'size'
                    AND CAST("set_para"."carCc" AS NUMERIC) BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
            ) AS "carCCTariff",
            (
                CASE
                    WHEN NULLIF("policy"."oic_version", '') IS NOT NULL THEN NULL
                    ELSE (
                        SELECT "tariff_mapping"
                        FROM insurverse."mas_tariff"
                        WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                            AND "mas_tariff"."tariff_group" = 'motor'
                            AND "mas_tariff"."tariff_code" = 'driver_name'
                            AND "set_para"."driveAction" IS NOT NULL
                            AND (
                                -- 0 "driverBirthdate1" is null and "driverBirthdate2" is null
                                (
                                    ("set_para"."driverBirthdate1" IS NULL OR "set_para"."driverBirthdate1" = '')
                                    AND ("set_para"."driverBirthdate2" IS NULL OR "set_para"."driverBirthdate2" = '')
                                    AND "mas_tariff"."tariff_mapping" = 'Unnamed'
                                )
                                OR
                                -- 1 "driverBirthdate1" is not null and "driverBirthdate2" is null
                                (
                                    "set_para"."driverBirthdate1" IS NOT NULL AND "set_para"."driverBirthdate1" != ''
                                    AND ("set_para"."driverBirthdate2" IS NULL OR "set_para"."driverBirthdate2" = '')
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                                OR
                                -- 2 "driverBirthdate1" is null and "driverBirthdate2" is not null
                                (
                                    ("set_para"."driverBirthdate1" IS NULL OR "set_para"."driverBirthdate1" = '')
                                    AND "set_para"."driverBirthdate2" IS NOT NULL AND "set_para"."driverBirthdate2" != ''
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                                OR
                                -- 3 "driverBirthdate1" is not null and "driverBirthdate2" is not null and "driverBirthdate1" >= "driverBirthdate2"
                                (
                                    "set_para"."driverBirthdate1" IS NOT NULL AND "set_para"."driverBirthdate1" != ''
                                    AND "set_para"."driverBirthdate2" IS NOT NULL AND "set_para"."driverBirthdate2" != ''
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC) >=
                                    CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                                OR
                                -- 4 "driverBirthdate1" is not null and "driverBirthdate2" is not null and "driverBirthdate1" < "driverBirthdate2"
                                (
                                    "set_para"."driverBirthdate1" IS NOT NULL AND "set_para"."driverBirthdate1" != ''
                                    AND "set_para"."driverBirthdate2" IS NOT NULL AND "set_para"."driverBirthdate2" != ''
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC) <
                                    CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                            ) LIMIT 1
                    )
                END
            ) AS "driverAge",
            --NULL AS "driverAge",
            CASE
                WHEN NULLIF("policy"."oic_version", '') IS NOT NULL THEN NULL
                WHEN "set_para"."driveAction" IS NULL THEN "prem"."Driver_Discount"
                ELSE NULL
            END AS "driverAgeDisc",
            (
                CASE
                    WHEN NULLIF("policy"."oic_version", '') IS NOT NULL THEN NULL
                    ELSE (
                        SELECT "tariff_factor"
                        FROM insurverse."mas_tariff"
                        WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                            AND "mas_tariff"."tariff_group" = 'motor'
                            AND "mas_tariff"."tariff_code" = 'driver_name'
                            AND "set_para"."driveAction" IS NOT NULL
                            AND (
                                -- 0 "driverBirthdate1" is null and "driverBirthdate2" is null
                                (
                                    ("set_para"."driverBirthdate1" IS NULL OR "set_para"."driverBirthdate1" = '')
                                    AND ("set_para"."driverBirthdate2" IS NULL OR "set_para"."driverBirthdate2" = '')
                                    AND "mas_tariff"."tariff_mapping" = 'Unnamed'
                                )
                                OR
                                -- 1 "driverBirthdate1" is not null and "driverBirthdate2" is null
                                (
                                    "set_para"."driverBirthdate1" IS NOT NULL AND "set_para"."driverBirthdate1" != ''
                                    AND ("set_para"."driverBirthdate2" IS NULL OR "set_para"."driverBirthdate2" = '')
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                                OR
                                -- 2 "driverBirthdate1" is null and "driverBirthdate2" is not null
                                (
                                    ("set_para"."driverBirthdate1" IS NULL OR "set_para"."driverBirthdate1" = '')
                                    AND "set_para"."driverBirthdate2" IS NOT NULL AND "set_para"."driverBirthdate2" != ''
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                                OR
                                -- 3 "driverBirthdate1" is not null and "driverBirthdate2" is not null and "driverBirthdate1" >= "driverBirthdate2"
                                (
                                    "set_para"."driverBirthdate1" IS NOT NULL AND "set_para"."driverBirthdate1" != ''
                                    AND "set_para"."driverBirthdate2" IS NOT NULL AND "set_para"."driverBirthdate2" != ''
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC) >=
                                    CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                                OR
                                -- 4 "driverBirthdate1" is not null and "driverBirthdate2" is not null and "driverBirthdate1" < "driverBirthdate2"
                                (
                                    "set_para"."driverBirthdate1" IS NOT NULL AND "set_para"."driverBirthdate1" != ''
                                    AND "set_para"."driverBirthdate2" IS NOT NULL AND "set_para"."driverBirthdate2" != ''
                                    AND "mas_tariff"."tariff_mapping" != 'Unnamed'
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC) <
                                    CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate2" AS DATE)) AS NUMERIC)
                                    AND CAST(EXTRACT(YEAR FROM "prem"."Payment_Date") - EXTRACT(YEAR FROM CAST("set_para"."driverBirthdate1" AS DATE)) AS NUMERIC)
                                    BETWEEN "mas_tariff"."tariff_num_min" AND "mas_tariff"."tariff_num_max"
                                )
                            ) LIMIT 1
                    )
                END
            ) AS "driverAgeTariff",
            (
                SELECT "tariff_factor"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'vehicle_age'
                    AND (EXTRACT(YEAR FROM "prem"."Payment_Date") - CAST("set_para"."carYear" AS INT) + 1) >= "mas_tariff"."tariff_num_min"
                    AND (EXTRACT(YEAR FROM "prem"."Payment_Date") - CAST("set_para"."carYear" AS INT) + 1) <= "mas_tariff"."tariff_num_max"
                LIMIT 1
            ) AS "carYearTariff",
            "prem"."SI_Limit" AS "siAmt",
            "prem"."Group" AS "carGroup",
            (
                SELECT "tariff_factor"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'vehicle_group'
                    AND LOWER("tariff_mapping") = LOWER("prem"."Group")
            ) AS "carGroupTariff",
            "prem"."SI_TPBI_Limit" AS "tpbiPassSIAmt",
            (
                SELECT "tariff_factor"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'vehicle_tpbi'
                    AND "prem"."SI_TPBI_Limit" >= "mas_tariff"."tariff_num_min"
                    AND "prem"."SI_TPBI_Limit" <= "mas_tariff"."tariff_num_max"
                LIMIT 1
            ) AS "tpbiPassTariff",
            (
                SELECT "tariff_num_min"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'vehicle_tpbi_e'
                    AND "mas_tariff"."tariff_remark" = 'fix'
                LIMIT 1
            ) AS "tpbiEventSIAmt",
            (
                SELECT "tariff_factor"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'vehicle_tpbi_e'
                    AND "mas_tariff"."tariff_remark" = 'fix'
                LIMIT 1
            ) AS "tpbiEventTariff",
            "prem"."SI_TPPD_Limit" AS "tppdSIAmt",
            (
                SELECT "tariff_factor"
                FROM insurverse."mas_tariff"
                WHERE REPLACE("policy"."Type", '+', '') = "mas_tariff"."policy_type"
                    AND "mas_tariff"."tariff_group" = 'motor'
                    AND "mas_tariff"."tariff_code" = 'vehicle_tppd'
                    AND "prem"."SI_TPPD_Limit" >= "mas_tariff"."tariff_num_min"
                    AND "prem"."SI_TPPD_Limit" <= "mas_tariff"."tariff_num_max"
                LIMIT 1
            ) AS "tppdTariff",
            "prem"."SI_MV01_Limit" AS "mv01SIAmt",
            "prem"."SI_MV02_Limit" AS "mv02SIAmt",
            "prem"."SI_MV03_Limit" AS "mv03SIAmt",
            NULL AS "totalExMvAmt",
            NULL AS "mv01PremAmt",
            NULL AS "mv02PremAmt",
            NULL AS "mv03PremAmt",
            CASE
                WHEN "set_para"."cctvHave" IS NOT NULL AND "set_para"."cctvHave" != 'N' THEN "prem"."CCTV"
                ELSE 0
            END AS "cctvPercent",
            "prem"."Fleet_Disc_perc" AS "fleetDiscPer",
            "prem"."NCB_Disc_perc" AS "ncbDiscPer",
            "prem"."Other_Disc_perc" AS "otherDiscPer",
            NULL AS "fleetDiscAmt",
            NULL AS "ncbDiscAmt",
            NULL AS "otherDiscAmt",
            NULL AS "extendPremAmt",
            NULL AS "dutyAmt",
            NULL AS "vatAmt",
            NULL AS "premiumV5Od",
            CASE
                WHEN "set_para"."cctvHave" IS NULL THEN NULL
                ELSE CAST("set_para"."cctvHave" AS BOOL)
            END AS "cctvHave",
            CASE
                WHEN "set_para"."accessHave" IS NULL THEN CASE
                    WHEN UPPER("prem"."Flag_Access") = 'Y' THEN TRUE
                    ELSE FALSE
                END
                ELSE CAST("set_para"."accessHave" AS BOOL)
            END AS "accessHave",
            CASE
                WHEN "set_para"."accessName" IS NULL THEN CAST((
                    SELECT jsonb_agg(elements) AS result_array
                    FROM (
                        SELECT unnest(string_to_array(insurverse.fn_display_access("prem"."Access_para_code"), ',')) AS elements
                    ) AS subquery
                ) AS TEXT)
                ELSE CAST("set_para"."accessName" AS TEXT)
            END AS "accessName",
            CASE
                WHEN "set_para"."accessNameCode" IS NULL THEN "prem"."Access_para_code"
                ELSE CAST("set_para"."accessNameCode" AS TEXT)
            END AS "accessNameCode",
            CASE
                WHEN "set_para"."accessSiAmt" IS NULL THEN COALESCE("prem"."SI_Access_Limit", 0)
                ELSE CAST("set_para"."accessSiAmt" AS NUMERIC)
            END AS "accessSiAmt"
        FROM
            set_para
        INNER JOIN
            insurverse."Policy_Header" AS "policy" ON "set_para"."insurancePolicyId" = "policy"."Policy_No"
        INNER JOIN
            insurverse."Policy_coverage_premium" AS "prem" ON "policy"."Policy_No" = "prem"."Policy_No"
        WHERE
            ("set_para"."accessHave" IS NOT NULL OR "set_para"."driveAction" IS NOT NULL OR "set_para"."cctvHave" IS NOT NULL OR "set_para"."carYear" IS NOT NULL OR "set_para"."extendEnddate" IS NOT NULL)

        UNION

        -- mv non financial
        SELECT
            "policy"."Policy_No" AS "insurancePolicyId",
            "set_para"."carLicenseProvinceId",
            (
                SELECT "prname"
                FROM insurverse."province"
                WHERE CAST("set_para"."carLicenseProvinceId" AS INT) = CAST("province"."provinceid" AS INT)
            ) AS "carLicenseProvince",
            "set_para"."deliProvinceId",
            (
                SELECT "prname"
                FROM insurverse."province"
                WHERE CAST("set_para"."deliProvinceId" AS INT) = CAST("province"."provinceid" AS INT)
            ) AS "deliProvince",
            "set_para"."deliDistrictId",
            (
                SELECT "diname"
                FROM insurverse."district"
                WHERE CAST("set_para"."deliDistrictId" AS INT) = CAST("district"."districtid" AS INT)
            ) AS "deliDistrict",
            "set_para"."deliSubdistrictId",
            (
                SELECT "sdname"
                FROM insurverse."subdistrict"
                WHERE CAST("set_para"."deliSubdistrictId" AS INT) = CAST("subdistrict"."subdistrictid" AS INT)
            ) AS "deliSubdistrict",
            (
                SELECT "para_code"
                FROM insurverse.sys_param
                WHERE dom_code = 'Policy'
                    AND sub_dom_code = 'Car_license_type'
                    AND para_name = "set_para"."carLicenseType"
            ) AS "carLicenseTypeCode",
            NULL AS "par1PrefixCode",
            NULL AS "par2PrefixCode",
            NULL AS "carBrand",
            NULL AS "carModel",
            NULL AS "basicPremAmt",
            NULL AS "basicPremV5Amt",
            NULL AS "usage",
            NULL AS "usageTariff",
            NULL AS "carCcCondition",
            NULL AS "carCCTariff",
            NULL AS "driverAge",
            NULL AS "driverAgeDisc",
            NULL AS "driverAgeTariff",
            NULL AS "carYearTariff",
            NULL AS "siAmt",
            NULL AS "carGroup",
            NULL AS "carGroupTariff",
            NULL AS "tpbiPassSIAmt",
            NULL AS "tpbiPassTariff",
            NULL AS "tpbiEventSIAmt",
            NULL AS "tpbiEventTariff",
            NULL AS "tppdSIAmt",
            NULL AS "tppdTariff",
            NULL AS "mv01SIAmt",
            NULL AS "mv02SIAmt",
            NULL AS "mv03SIAmt",
            NULL AS "totalExMvAmt",
            NULL AS "mv01PremAmt",
            NULL AS "mv02PremAmt",
            NULL AS "mv03PremAmt",
            NULL AS "cctvPercent",
            NULL AS "fleetDiscPer",
            NULL AS "fleetDiscAmt",
            NULL AS "ncbDiscPer",
            NULL AS "ncbDiscAmt",
            NULL AS "otherDiscPer",
            NULL AS "otherDiscAmt",
            NULL AS "extendPremAmt",
            NULL AS "dutyAmt",
            NULL AS "vatAmt",
            NULL AS "premiumV5Od",
            NULL AS "cctvHave",
            NULL AS "accessHave",
            NULL AS "accessName",
            NULL AS "accessNameCode",
            NULL AS "accessSiAmt"
        FROM
            set_para
        INNER JOIN
            insurverse."Policy_Header" AS "policy" ON "set_para"."insurancePolicyId" = "policy"."Policy_No"
        INNER JOIN
            insurverse."Policy_coverage_premium" AS "prem" ON "policy"."Policy_No" = "prem"."Policy_No"
        WHERE
            ("set_para"."accessHave" IS NULL AND "set_para"."driveAction" IS NULL AND "set_para"."cctvHave" IS NULL AND "set_para"."carYear" IS NULL AND "set_para"."extendEnddate" IS NULL)

        UNION

        -- mc non financial
        SELECT
            "policy"."Car_Act_No" AS "insurancePolicyId",
            "set_para"."carLicenseProvinceId",
            (
                SELECT "prname"
                FROM insurverse."province"
                WHERE CAST("set_para"."carLicenseProvinceId" AS INT) = CAST("province"."provinceid" AS INT)
            ) AS "carLicenseProvince",
            "set_para"."deliProvinceId",
            (
                SELECT "prname"
                FROM insurverse."province"
                WHERE CAST("set_para"."deliProvinceId" AS INT) = CAST("province"."provinceid" AS INT)
            ) AS "deliProvince",
            "set_para"."deliDistrictId",
            (
                SELECT "diname"
                FROM insurverse."district"
                WHERE CAST("set_para"."deliDistrictId" AS INT) = CAST("district"."districtid" AS INT)
            ) AS "deliDistrict",
            "set_para"."deliSubdistrictId",
            (
                SELECT "sdname"
                FROM insurverse."subdistrict"
                WHERE CAST("set_para"."deliSubdistrictId" AS INT) = CAST("subdistrict"."subdistrictid" AS INT)
            ) AS "deliSubdistrict",
            (
                SELECT "para_code"
                FROM insurverse.sys_param
                WHERE dom_code = 'Policy'
                    AND sub_dom_code = 'Car_license_type'
                    AND para_name = "set_para"."carLicenseType"
            ) AS "carLicenseTypeCode",
            NULL AS "par1PrefixCode",
            NULL AS "par2PrefixCode",
            NULL AS "carBrand",
            NULL AS "carModel",
            NULL AS "basicPremAmt",
            NULL AS "basicPremV5Amt",
            NULL AS "usage",
            NULL AS "usageTariff",
            NULL AS "carCcCondition",
            NULL AS "carCCTariff",
            NULL AS "driverAge",
            NULL AS "driverAgeDisc",
            NULL AS "driverAgeTariff",
            NULL AS "carYearTariff",
            NULL AS "siAmt",
            NULL AS "carGroup",
            NULL AS "carGroupTariff",
            NULL AS "tpbiPassSIAmt",
            NULL AS "tpbiPassTariff",
            NULL AS "tpbiEventSIAmt",
            NULL AS "tpbiEventTariff",
            NULL AS "tppdSIAmt",
            NULL AS "tppdTariff",
            NULL AS "mv01SIAmt",
            NULL AS "mv02SIAmt",
            NULL AS "mv03SIAmt",
            CASE
                WHEN "set_para"."extendEnddate" IS NOT NULL THEN CAST("policy"."Net_Premium" AS TEXT)
                ELSE NULL
            END AS "totalExMvAmt",
            NULL AS "mv01PremAmt",
            NULL AS "mv02PremAmt",
            NULL AS "mv03PremAmt",
            NULL AS "cctvPercent",
            NULL AS "fleetDiscPer",
            NULL AS "fleetDiscAmt",
            NULL AS "ncbDiscPer",
            NULL AS "ncbDiscAmt",
            NULL AS "otherDiscPer",
            NULL AS "otherDiscAmt",
            NULL AS "extendPremAmt",
            NULL AS "dutyAmt",
            NULL AS "vatAmt",
            NULL AS "premiumV5Od",
            NULL AS "cctvHave",
            NULL AS "accessHave",
            NULL AS "accessName",
            NULL AS "accessNameCode",
            NULL AS "accessSiAmt"
        FROM
            set_para
        INNER JOIN
            insurverse."Policy_Car_Act_Discount_Premium" AS "policy" ON "set_para"."insurancePolicyId" = "policy"."Car_Act_No"
    ) AS "fi";
END;
$function$
