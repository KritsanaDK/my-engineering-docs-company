-- =============================================================================
-- Function: insurverse.fn_policy_renewal_ncb
-- OID: 18740
-- Identity Arguments: (in_policy_no text)
-- Returns: TABLE(rtn_success boolean, rtn_ncb_tier integer, rtn_error_code text, rtn_msg text, rtn_policy_no text)
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_policy_renewal_ncb(in_policy_no text)
 RETURNS TABLE(rtn_success boolean, rtn_ncb_tier integer, rtn_error_code text, rtn_msg text, rtn_policy_no text)
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	RTN_SUCCESS BOOL; RTN_MSG TEXT; RTN_ERROR_CODE TEXT;
	RTN_NCB_TIER INTEGER;
	RTN_POLICY_NO TEXT;
	COUNT_MAS_PURE INTEGER;
	COUNT_MAS_COS_O INTEGER;
	SYS_CUR_DATE TIMESTAMP;
	SYS_PREMIUM_AMT NUMERIC;
	SYS_CLAIM_AMT NUMERIC;
	SYS_CLAIM_RATE NUMERIC;
	SYS_PURE_LOSS_COUNT INTEGER;
	SYS_COSMETIC_OTHER_COUNT INTEGER;
	MAP_PURE_LOSS TEXT;
	MAP_COSMETIC TEXT;
	MAP_OTHER TEXT;
	BEGIN
		/*
		select rtn_policy_no,rtn_success,rtn_ncb_tier,rtn_error_code,rtn_msg
		from insurverse.fn_policy_renewal_ncb('MV-0023-H-000491');
		*/
		
		-- ERROR_CODE
		-- ER001 = Policy Number is not found.
		-- ER002 = Premium Amount is equal 0.
		-- ER101 = Pure loss NCB master data is not found.
		-- ER102 = Cosmetic and other NCB master data is not found.
		RTN_SUCCESS = true;
		
		-- set MAPPING claim_type
		MAP_PURE_LOSS = 'PURELOSS';
		MAP_COSMETIC = 'COSMETIC';
		MAP_OTHER = 'OTHER';
		RTN_MSG = '';
		
		-- check policy_no
		select "Policy_No"
		from insurverse."Policy_Header"
		where "Policy_No"="in_policy_no"
		into RTN_POLICY_NO;
		
		if RTN_POLICY_NO is null THEN
			RTN_SUCCESS = false;
			RTN_ERROR_CODE = 'ER001';
			RTN_MSG = 'Policy Number is not found.';
			return QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO;
			return;
		end if;
		
		-- check log_noti_renewal
		select "create_at"
		from insurverse."log_noti_renewal" 
		where "policy_no"="in_policy_no"
		order by "id" desc
		limit 1
		into SYS_CUR_DATE;
		
		-- set SYS_CUR_DATE is null = now()
		IF SYS_CUR_DATE IS NULL THEN SYS_CUR_DATE = now(); END IF;
		
		-- query permium_amt (exclude duty & vat)
		select "Perm_Amt"
		from insurverse."Policy_coverage_premium"
		where "Policy_No"="in_policy_no"
		into SYS_PREMIUM_AMT;
		
		-- query claim_amt (wrong side)
		SELECT sum("total_loss_reserve")
		from insurverse."sf_claim_coverage"
		where "policy_number"="in_policy_no" and "responsibility" != 'ฝ่ายถูก'
		into SYS_CLAIM_AMT;
		
		-- set SYS_PREMIUM_AMT is null = 0
		IF SYS_PREMIUM_AMT IS NULL THEN SYS_PREMIUM_AMT = 0; END IF;
		
		-- set SYS_CLAIM_AMT is null = SYS_CLAIM_RATE = 0
		IF SYS_CLAIM_AMT IS NULL THEN SYS_CLAIM_RATE = 0; END IF;
		
		-- cal SYS_CLAIM_RATE
		IF SYS_PREMIUM_AMT != 0 THEN
			SYS_CLAIM_RATE =  (SYS_CLAIM_AMT * 100) / SYS_PREMIUM_AMT;
		ELSE
			RTN_SUCCESS = false;
			RTN_ERROR_CODE = 'ER002';
			RTN_MSG = 'Premium Amount is equal 0.';
			return QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO;
			return;
		END IF;
		
		-- check master data
		with set_para as (select "in_policy_no" as "policy_no", SYS_CUR_DATE as "cur_date")
		select count(*)
		from "set_para"
		inner join insurverse.mas_renewal_ncb as "rn_ncb"
		on "set_para"."cur_date" between "rn_ncb"."trans_startdate" and "rn_ncb"."trans_enddate"
		and "rn_ncb"."claim_group"='pure_loss'
		into COUNT_MAS_PURE;
		
		with set_para as (select "in_policy_no" as "policy_no", SYS_CUR_DATE as "cur_date")
		select count(*)
		from "set_para"
		inner join insurverse.mas_renewal_ncb as "rn_ncb"
		on "set_para"."cur_date" between "rn_ncb"."trans_startdate" and "rn_ncb"."trans_enddate"
		and "rn_ncb"."claim_group"='cosmetic_other'
		into COUNT_MAS_COS_O;
		
		IF COUNT_MAS_PURE IS NULL OR COUNT_MAS_PURE = 0 THEN
			RTN_SUCCESS = false;
			RTN_ERROR_CODE = 'ER101';
			RTN_MSG = 'Pure loss NCB master data is not found.';
			return QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO;
			return;
		END IF;
		
		IF COUNT_MAS_COS_O IS NULL OR COUNT_MAS_COS_O = 0 THEN
			RTN_SUCCESS = false;
			RTN_ERROR_CODE = 'ER102';
			RTN_MSG = 'Cosmetic and other NCB master data is not found.';
			return QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO;
			return;
		END IF;
		
		-- query pure_loss
		with set_para as (select "in_policy_no" as "policy_no", SYS_CUR_DATE as "cur_date")
		select count(*)
		from set_para
		inner join 
		(select "claim_group"
		from "set_para"
		inner join insurverse.mas_renewal_ncb as "rn_ncb"
		on "set_para"."cur_date" between "rn_ncb"."trans_startdate" and "rn_ncb"."trans_enddate"
		group by "claim_group"
		) as "rn_ncb"
		on "rn_ncb"."claim_group"='pure_loss'
		inner join insurverse.sf_claim_coverage as "claim_c"
		on "claim_c"."claim_type" in (MAP_PURE_LOSS)
		and "claim_c"."responsibility" != 'ฝ่ายถูก'
		and "claim_c"."policy_number" = "set_para"."policy_no"
		INTO SYS_PURE_LOSS_COUNT;
		
		-- set SYS_PURE_LOSS_COUNT is null = 0
		IF SYS_PURE_LOSS_COUNT IS NULL THEN SYS_PURE_LOSS_COUNT = 0; END IF;
		
		-- query cosmetic_other
		with set_para as (select "in_policy_no" as "policy_no", SYS_CUR_DATE as "cur_date")
		select count(*)
		from set_para
		inner join 
		(select "claim_group"
		from "set_para"
		inner join insurverse.mas_renewal_ncb as "rn_ncb"
		on "set_para"."cur_date" between "rn_ncb"."trans_startdate" and "rn_ncb"."trans_enddate"
		group by "claim_group"
		) as "rn_ncb"
		on "rn_ncb"."claim_group"='cosmetic_other'
		inner join insurverse.sf_claim_coverage as "claim_c"
		on "claim_c"."claim_type" in (MAP_COSMETIC,MAP_OTHER)
		and "claim_c"."responsibility" != 'ฝ่ายถูก'
		and "claim_c"."policy_number" = "set_para"."policy_no"
		INTO SYS_COSMETIC_OTHER_COUNT;
		
		-- set SYS_COSMETIC_OTHER_COUNT is null = 0
		IF SYS_COSMETIC_OTHER_COUNT IS NULL THEN SYS_COSMETIC_OTHER_COUNT = 0; END IF;
		
		-- set pure_loss + cosmetic_other = cosmetic_other
		if SYS_PURE_LOSS_COUNT > 0 and SYS_COSMETIC_OTHER_COUNT > 0 THEN
			SYS_COSMETIC_OTHER_COUNT = SYS_COSMETIC_OTHER_COUNT + SYS_PURE_LOSS_COUNT;
			SYS_PURE_LOSS_COUNT = 0;
		END IF;
		
		--RTN_MSG = RTN_MSG || ' - SYS_CLAIM_RATE : ' || SYS_CLAIM_RATE;
		--RTN_MSG = RTN_MSG || ' - SYS_PURE_LOSS_COUNT : ' || SYS_PURE_LOSS_COUNT || ' - SYS_COSMETIC_OTHER_COUNT : ' || SYS_COSMETIC_OTHER_COUNT;
		
		-- query ncb_tier
		with set_para as (select SYS_CUR_DATE as "cur_date")
		select "ncb_tier_con"
		from "set_para"
		inner join insurverse."mas_renewal_ncb" as "rn_ncb"
		on "set_para"."cur_date" between "rn_ncb"."trans_startdate" and "rn_ncb"."trans_enddate"
		and (("rn_ncb"."claim_group"='pure_loss' and SYS_PURE_LOSS_COUNT between "rn_ncb"."claim_time_min" and "rn_ncb"."claim_time_max")
		or ("rn_ncb"."claim_group"='cosmetic_other' and SYS_COSMETIC_OTHER_COUNT between "rn_ncb"."claim_time_min" and "rn_ncb"."claim_time_max"))
		and ROUND(SYS_CLAIM_RATE,2) between "rn_ncb"."compensation_rate_min" and "rn_ncb"."compensation_rate_max"
		into RTN_NCB_TIER;
		
		if RTN_NCB_TIER IS NULL and SYS_PURE_LOSS_COUNT = 0 and SYS_COSMETIC_OTHER_COUNT = 0 THEN
			with set_para as (select SYS_CUR_DATE as "cur_date")
			select "rn_config"."renewal_num"
			from "set_para"
			inner join insurverse."mas_renewal_config" as "rn_config"
			on "set_para"."cur_date" between "rn_config"."trans_startdate" and "rn_config"."trans_enddate"
			and "rn_config"."renewal_type"='tariff' and "rn_config"."renewal_code"='add_ncb'
			into RTN_NCB_TIER;
			
			IF RTN_NCB_TIER IS NULL THEN
				RTN_NCB_TIER = 0;
			END IF;
		END IF;
		
		return QUERY SELECT RTN_SUCCESS,RTN_NCB_TIER,RTN_ERROR_CODE,RTN_MSG,RTN_POLICY_NO;
END
$function$
