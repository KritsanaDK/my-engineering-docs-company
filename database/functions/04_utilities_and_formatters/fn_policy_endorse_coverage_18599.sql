-- =============================================================================
-- Function: insurverse.fn_policy_endorse_coverage
-- OID: 18599
-- Identity Arguments: (in_policy_no text, in_brand text, in_model text, in_year text, in_group text, in_cc text, in_named_age text, in_driver_behavior text, in_prem_version text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_endorse_coverage(in_policy_no text, in_brand text, in_model text, in_year text, in_group text, in_cc text, in_named_age text, in_driver_behavior text, in_prem_version text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
RTN_STATUS BOOLEAN DEFAULT TRUE;
RTN_JSON TEXT; FLAG_NOTMAPPING BOOL DEFAULT FALSE;
SYS_POLICY_NO TEXT;
SYS_CHK_MAS BOOL DEFAULT FALSE;
SYS_CHK_CC BOOL DEFAULT FALSE;
SYS_CHK_NAMEDAGE BOOL DEFAULT FALSE;
SYS_CHK_GROUP BOOL DEFAULT FALSE;
BEGIN

WITH set_para as (SELECT 
"in_policy_no" as "policy_no",
"in_brand" as "brand",
"in_model" as "model",
"in_year" as "year",
"in_group" as "group",
NULLIF("in_cc", '') as "cc",
NULLIF("in_named_age", '') as "named_age",
NULLIF("in_driver_behavior", '') as "driver_behavior",
NULLIF("in_prem_version", '') as "version"
)
SELECT "policy"."Policy_No",
CASE WHEN (
	SELECT COUNT(*) as "count_mas"
	FROM insurverse."Imp_Price_Premium" as "ipp_mas"
	WHERE "ipp_mas"."Brand"="set_para"."brand" AND "ipp_mas"."Model"="set_para"."model"
	AND "ipp_mas"."Year"="set_para"."year" AND "policy"."Type"="ipp_mas"."Type" 
	LIMIT 1

) > 0 THEN TRUE ELSE FALSE END as "chk_mas",
/*
CASE WHEN (
	SELECT COUNT(*) as "count_cc"
	FROM insurverse."Imp_Price_Premium" as "ipp_mas"
	WHERE "ipp_mas"."Brand"="set_para"."brand" AND "ipp_mas"."Model"="set_para"."model"
	AND "ipp_mas"."Year"="set_para"."year" AND "policy"."Type"="ipp_mas"."Type"
	AND "ipp_mas"."CC"="set_para"."cc" 
	LIMIT 1
) > 0 THEN TRUE ELSE FALSE END as "chk_cc",
*/
true as "chk_cc",
/*CASE WHEN (
	SELECT COUNT(*) as "count_namedage"
	FROM insurverse."Imp_Price_Premium" as "ipp_mas"
	WHERE "ipp_mas"."Brand"="set_para"."brand" AND "ipp_mas"."Model"="set_para"."model"
	AND "ipp_mas"."Year"="set_para"."year" AND "policy"."Type"="ipp_mas"."Type" 
	AND "ipp_mas"."NamedAge"="set_para"."named_age"
	LIMIT 1
) > 0 THEN TRUE ELSE FALSE END as "chk_namedage",
*/
true as "chk_namedage",
CASE WHEN (
	SELECT COUNT(*) as "count_group"
	FROM insurverse."Imp_Price_Premium" as "ipp_mas"
	WHERE "ipp_mas"."Brand"="set_para"."brand" AND "ipp_mas"."Model"="set_para"."model"
	AND "ipp_mas"."Year"="set_para"."year" AND "policy"."Type"="ipp_mas"."Type" 
	AND "ipp_mas"."Group"="set_para"."group"
	LIMIT 1
) > 0 THEN TRUE ELSE FALSE END as "chk_group"
FROM set_para
INNER JOIN insurverse."Policy_Header" as "policy"
ON "set_para"."policy_no"="policy"."Policy_No"
LIMIT 1
INTO SYS_POLICY_NO,SYS_CHK_MAS,SYS_CHK_CC,SYS_CHK_NAMEDAGE,SYS_CHK_GROUP;

IF SYS_POLICY_NO IS NOT NULL AND SYS_CHK_MAS = TRUE AND SYS_CHK_CC = TRUE AND SYS_CHK_NAMEDAGE = TRUE AND SYS_CHK_GROUP = TRUE THEN
WITH set_para as (SELECT 
"in_policy_no" as "policy_no",
"in_brand" as "brand",
"in_model" as "model",
"in_year" as "year",
"in_group" as "group",
NULLIF("in_cc", '') as "cc",
NULLIF("in_named_age", '') as "named_age",
NULLIF("in_driver_behavior", '') as "driver_behavior",
NULLIF("in_prem_version", '') as "version"
),
cover_data AS (
    SELECT 'SI' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					unnest(array["SI_1","SI_2","SI_3","SI_4","SI_5"]) as "si"
					FROM (SELECT DISTINCT "SI_1","SI_2","SI_3","SI_4","SI_5"
					FROM insurverse."Imp_Price_Premium" as "ipp"
					INNER JOIN insurverse."Policy_Header" as "policy"
						ON "ipp"."Type"="policy"."Type"
						AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
						AND "ipp"."GarageType"="policy"."GarageType"
					INNER JOIN set_para
					ON "ipp"."Brand"="set_para"."brand" AND "ipp"."Model"="set_para"."model"
					AND "ipp"."Year"="set_para"."year" AND "ipp"."Group"="set_para"."group"
					--AND "ipp"."CC"="set_para"."cc" 
					--AND "ipp"."NamedAge"="set_para"."named_age"
					AND ( 
						(
							"set_para"."version" is null 
							AND "ipp"."version" is null
						)
						OR ( 
							"set_para"."version" is not null 
							AND "ipp"."version" is not null
							AND "set_para"."driver_behavior" is not null
							AND "ipp"."driver_behavior" is not null
							AND "ipp"."version" = "set_para"."version"::int 
							AND "ipp"."driver_behavior" = "set_para"."driver_behavior"::int
						)
					)
					LIMIT 1
					) as "si"
				) item
		) as "possibleValue"
    UNION ALL
    SELECT 'Access' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					unnest(array["SI_Access_1","SI_Access_2","SI_Access_3"]) as "si"
					FROM (SELECT DISTINCT "SI_Access_1","SI_Access_2","SI_Access_3"
					FROM insurverse."Imp_Price_Premium" as "ipp"
					INNER JOIN insurverse."Policy_Header" as "policy"
						ON "ipp"."Type"="policy"."Type"
						AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					INNER JOIN set_para
					ON "ipp"."Brand"="set_para"."brand" AND "ipp"."Model"="set_para"."model"
					AND "ipp"."Year"="set_para"."year" AND "ipp"."Group"="set_para"."group"
					--AND "ipp"."CC"="set_para"."cc" 
					--AND "ipp"."NamedAge"="set_para"."named_age"
					AND ( 
						(
							"set_para"."version" is null 
							AND "ipp"."version" is null
						)
						OR ( 
							"set_para"."version" is not null 
							AND "ipp"."version" is not null
							AND "set_para"."driver_behavior" is not null
							AND "ipp"."driver_behavior" is not null
							AND "ipp"."version" = "set_para"."version"::int 
							AND "ipp"."driver_behavior" = "set_para"."driver_behavior"::int
						)
					)
					LIMIT 1
					) as "si"
				) item
		) as "possibleValue"
		UNION ALL
    SELECT 'TPPD' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					unnest(array["SI_TPPD_1","SI_TPPD_2","SI_TPPD_3"]) as "si",
					unnest(array[(SELECT "tariff_factor" FROM insurverse."mas_tariff" WHERE "policy_type"=REPLACE("Type",'+','') AND "tariff_group"='motor' AND "tariff_code"='vehicle_tppd' AND "tariff_num_min"="SI_TPPD_1" LIMIT 1),
												(SELECT "tariff_factor" FROM insurverse."mas_tariff" WHERE "policy_type"=REPLACE("Type",'+','') AND "tariff_group"='motor' AND "tariff_code"='vehicle_tppd'  AND "tariff_num_min"="SI_TPPD_2" LIMIT 1),
												(SELECT "tariff_factor" FROM insurverse."mas_tariff" WHERE "policy_type"=REPLACE("Type",'+','') AND "tariff_group"='motor' AND "tariff_code"='vehicle_tppd'  AND "tariff_num_min"="SI_TPPD_3" LIMIT 1)]
												) as "tariff"
					FROM (SELECT DISTINCT "SI_TPPD_1","SI_TPPD_2","SI_TPPD_3","policy"."Type"
					FROM insurverse."Imp_Price_Premium" as "ipp"
					INNER JOIN insurverse."Policy_Header" as "policy"
						ON "ipp"."Type"="policy"."Type"
						AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					INNER JOIN set_para
					ON "ipp"."Brand"="set_para"."brand" AND "ipp"."Model"="set_para"."model"
					AND "ipp"."Year"="set_para"."year" AND "ipp"."Group"="set_para"."group"
					--AND "ipp"."CC"="set_para"."cc" 
					--AND "ipp"."NamedAge"="set_para"."named_age"
					AND ( 
						(
							"set_para"."version" is null 
							AND "ipp"."version" is null
						)
						OR ( 
							"set_para"."version" is not null 
							AND "ipp"."version" is not null
							AND "set_para"."driver_behavior" is not null
							AND "ipp"."driver_behavior" is not null
							AND "ipp"."version" = "set_para"."version"::int 
							AND "ipp"."driver_behavior" = "set_para"."driver_behavior"::int
						)
					)
					LIMIT 1
					) as "si"
				) item
		) as "possibleValue"
		UNION ALL
    SELECT 'TPBI' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					unnest(array["SI_TPBI_1","SI_TPBI_2","SI_TPBI_3"]) as "si",
					unnest(array[(SELECT "tariff_factor" FROM insurverse."mas_tariff" WHERE "policy_type"=REPLACE("Type",'+','') AND "tariff_group"='motor' AND "tariff_code"='vehicle_tpbi' AND "tariff_num_min"="SI_TPBI_1" LIMIT 1),
												(SELECT "tariff_factor" FROM insurverse."mas_tariff" WHERE "policy_type"=REPLACE("Type",'+','') AND "tariff_group"='motor' AND "tariff_code"='vehicle_tpbi'  AND "tariff_num_min"="SI_TPBI_2" LIMIT 1),
												(SELECT "tariff_factor" FROM insurverse."mas_tariff" WHERE "policy_type"=REPLACE("Type",'+','') AND "tariff_group"='motor' AND "tariff_code"='vehicle_tpbi'  AND "tariff_num_min"="SI_TPBI_3" LIMIT 1)]
												) as "tariff"
					FROM (SELECT DISTINCT "SI_TPBI_1","SI_TPBI_2","SI_TPBI_3","policy"."Type"
					FROM insurverse."Imp_Price_Premium" as "ipp"
					INNER JOIN insurverse."Policy_Header" as "policy"
						ON "ipp"."Type"="policy"."Type"
						AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					INNER JOIN set_para
					ON "ipp"."Brand"="set_para"."brand" AND "ipp"."Model"="set_para"."model"
					AND "ipp"."Year"="set_para"."year" AND "ipp"."Group"="set_para"."group"
					--AND "ipp"."CC"="set_para"."cc" 
					--AND "ipp"."NamedAge"="set_para"."named_age"
					AND ( 
						(
							"set_para"."version" is null 
							AND "ipp"."version" is null
						)
						OR ( 
							"set_para"."version" is not null 
							AND "ipp"."version" is not null
							AND "set_para"."driver_behavior" is not null
							AND "ipp"."driver_behavior" is not null
							AND "ipp"."version" = "set_para"."version"::int 
							AND "ipp"."driver_behavior" = "set_para"."driver_behavior"::int
						)
					)
					LIMIT 1
					) as "si"
				) item
		) as "possibleValue"
		UNION ALL
    SELECT 'TPBI_E' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					"tariff_mapping" as "si",
					"tariff_factor" as "tariff"
					FROM (SELECT DISTINCT "tariff_mapping","tariff_factor"
					FROM insurverse."mas_tariff" as "tariff"
					INNER JOIN insurverse."Policy_Header" as "policy"
					CROSS JOIN set_para as "set_para"
					ON "tariff"."policy_type"=REPLACE("policy"."Type",'+','')
					AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					AND "tariff_group"='motor' AND "tariff_code"='vehicle_tpbi_e'
					and ( 
						("set_para"."version" is null and "tariff_mapping" = '10000000')
						or ("set_para"."version" is not null and "tariff_mapping" = '20000000')
					)
					LIMIT 1
					) as "si"
				) item
		) as "possibleValue"
		UNION ALL
    SELECT 'MV01' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					unnest(array["SI_MV01_1","SI_MV01_2","SI_MV01_3"]) as "si"
					FROM (SELECT DISTINCT "SI_MV01_1","SI_MV01_2","SI_MV01_3"
					FROM insurverse."Imp_Price_Premium" as "ipp"
					INNER JOIN insurverse."Policy_Header" as "policy"
						ON "ipp"."Type"="policy"."Type"
						AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					INNER JOIN set_para
					ON "ipp"."Brand"="set_para"."brand" AND "ipp"."Model"="set_para"."model"
					AND "ipp"."Year"="set_para"."year" AND "ipp"."Group"="set_para"."group"
					--AND "ipp"."CC"="set_para"."cc" 
					--AND "ipp"."NamedAge"="set_para"."named_age"
					AND ( 
						(
							"set_para"."version" is null 
							AND "ipp"."version" is null
						)
						OR ( 
							"set_para"."version" is not null 
							AND "ipp"."version" is not null
							AND "set_para"."driver_behavior" is not null
							AND "ipp"."driver_behavior" is not null
							AND "ipp"."version" = "set_para"."version"::int 
							AND "ipp"."driver_behavior" = "set_para"."driver_behavior"::int
						)
					)
					) as "si"
				) item
		) as "possibleValue"
		UNION ALL
    SELECT 'MV02' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					unnest(array["SI_MV02_1","SI_MV02_2","SI_MV02_3"]) as "si"
					FROM (SELECT DISTINCT "SI_MV02_1","SI_MV02_2","SI_MV02_3"
					FROM insurverse."Imp_Price_Premium" as "ipp"
					INNER JOIN insurverse."Policy_Header" as "policy"
						ON "ipp"."Type"="policy"."Type"
						AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					INNER JOIN set_para
					ON "ipp"."Brand"="set_para"."brand" AND "ipp"."Model"="set_para"."model"
					AND "ipp"."Year"="set_para"."year" AND "ipp"."Group"="set_para"."group"
					--AND "ipp"."CC"="set_para"."cc" 
					--AND "ipp"."NamedAge"="set_para"."named_age"
					AND ( 
						(
							"set_para"."version" is null 
							AND "ipp"."version" is null
						)
						OR ( 
							"set_para"."version" is not null 
							AND "ipp"."version" is not null
							AND "set_para"."driver_behavior" is not null
							AND "ipp"."driver_behavior" is not null
							AND "ipp"."version" = "set_para"."version"::int 
							AND "ipp"."driver_behavior" = "set_para"."driver_behavior"::int
						)
					)
					LIMIT 1
					) as "si"
				) item
		) as "possibleValue"
		UNION ALL
    SELECT 'MV03' AS "coverageCode", (SELECT json_agg("item")
		FROM (SELECT
					unnest(array["SI_MV03_1","SI_MV03_2","SI_MV03_3"]) as "si"
					FROM (SELECT DISTINCT "SI_MV03_1","SI_MV03_2","SI_MV03_3"
					FROM insurverse."Imp_Price_Premium" as "ipp"
					INNER JOIN insurverse."Policy_Header" as "policy"
						ON "ipp"."Type"="policy"."Type"
						AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					INNER JOIN set_para
					ON "ipp"."Brand"="set_para"."brand" AND "ipp"."Model"="set_para"."model"
					AND "ipp"."Year"="set_para"."year" AND "ipp"."Group"="set_para"."group"
					--AND "ipp"."CC"="set_para"."cc" 
					--AND "ipp"."NamedAge"="set_para"."named_age"
					AND ( 
						(
							"set_para"."version" is null 
							AND "ipp"."version" is null
						)
						OR ( 
							"set_para"."version" is not null 
							AND "ipp"."version" is not null
							AND "set_para"."driver_behavior" is not null
							AND "ipp"."driver_behavior" is not null
							AND "ipp"."version" = "set_para"."version"::int 
							AND "ipp"."driver_behavior" = "set_para"."driver_behavior"::int
						)
					)
					LIMIT 1
					) as "si"
				) item
		) as "possibleValue"
)
SELECT json_build_object(
'success',true,
'message','',
'coverageList',(
SELECT json_agg(cover_data)
FROM cover_data
), -- coverageList
'si_detail',
(SELECT json_agg("item")
			FROM (SELECT
				"tariff_num_min" as "si",
				"tariff_factor" as "tariff"
				FROM (SELECT DISTINCT "tariff_num_min","tariff_factor"
				FROM insurverse.mas_tariff
				INNER JOIN insurverse."Policy_Header" as "policy"
					ON "mas_tariff"."policy_type"=REPLACE("policy"."Type",'+','')
					AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					AND "tariff_group"='motor' AND "tariff_code"='vehicle_si'
				) as "tariff"
				ORDER BY "tariff_num_min"
			) item
),
'si_base_v5_detail',
(SELECT json_agg("item")
			FROM (SELECT
				"tariff_num_min" as "si",
				"tariff_factor" as "tariff"
				FROM (SELECT DISTINCT "tariff_num_min","tariff_factor"
				FROM insurverse.mas_tariff
				INNER JOIN insurverse."Policy_Header" as "policy"
					ON "mas_tariff"."policy_type"="policy"."Type"
					AND "policy"."Policy_No"=(SELECT "policy_no" FROM set_para)
					AND "tariff_group"='motor' AND "tariff_code"='vehicle_base_v5'
				) as "tariff"
				ORDER BY "tariff_num_min"
			) item
)
) as "json_body" -- 1
	INTO RTN_JSON;

	SELECT CASE WHEN tbl->'coverageList' IS NULL THEN FALSE ELSE TRUE END
  FROM CAST(RTN_JSON AS JSON) as "tbl"
	LIMIT 1
	INTO RTN_STATUS;
	
	IF RTN_JSON IS NOT NULL THEN
		SELECT CASE WHEN tbl->'coverageList'->0->>'possibleValue' IS NULL THEN FALSE ELSE TRUE END
		FROM CAST(RTN_JSON as JSON) as "tbl"
		LIMIT 1
		INTO RTN_STATUS;
	END IF;
	
	IF RTN_STATUS = FALSE THEN
		RTN_JSON = NULL;
	END IF;
	
ELSE
	IF SYS_POLICY_NO IS NULL THEN
		RTN_JSON = '{"success" : false,"message" : "Policy number is not found."}';
	END IF;
	IF SYS_CHK_MAS = FALSE THEN
		RTN_JSON = '{"success" : false,"message" : "Master premium is not found."}';
	ELSIF SYS_CHK_CC = FALSE AND SYS_CHK_MAS = TRUE THEN
		RTN_JSON = '{"success" : false,"message" : "CC premium is not found."}';
	ELSIF SYS_CHK_NAMEDAGE = FALSE AND SYS_CHK_MAS = TRUE THEN
		RTN_JSON = '{"success" : false,"message" : "NamedAge Premium is not found."}';
	ELSIF SYS_CHK_GROUP = FALSE AND SYS_CHK_MAS = TRUE THEN
		RTN_JSON = '{"success" : false,"message" : "Car Group Premium is not found."}';
	END IF;
END IF;
	
	
	RETURN RTN_JSON;
END
$function$
