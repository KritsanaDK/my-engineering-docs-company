-- =============================================================================
-- Function: insurverse.fn_claim_status_history
-- OID: 18458
-- Identity Arguments: (in_user_id text)
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_claim_status_history(in_user_id text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE RTN_JSON TEXT;
	BEGIN
  with set_para as (select
"in_user_id" as user_id -- claim_all_1234 = show all for test
)
select json_build_object(
-- ### claim_request ###
'claim_request',(select json_agg("claim_request")
from (select *
from (
-- ### claim_request - mv ###
select "policy"."Policy_No" as "policy_no",
"policy"."Car_license_no" as "car_license_no",
cast("policy"."Car_license_provice" as integer) as "car_license_province_id",
(select "prname" from insurverse."province" WHERE "province"."provinceid"="policy"."Car_license_provice") as "car_license_province",
"request"."ref_notify_no","request"."accident_date" + interval '7HOUR' as "accident_date"
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Header" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."claim_request" as "request"
on "policy"."Policy_No"="request"."acc_policy_no"
left join insurverse."sf_claim" as "claim"
on "request"."acc_policy_no"="claim"."acc_policy_no"
and "request"."ref_notify_no"="claim"."ref_notify_no" -- (2023-11-29)
where "claim"."acc_policy_no" is null
union 
-- ### claim_request - mc ###
select "policy"."Car_Act_No" as "policy_no",
"policy"."Car_license_no" as "car_license_no",
cast("policy"."Car_license_provice" as integer) as "car_license_province_id",
(select "prname" from insurverse."province" WHERE cast("province"."provinceid" as integer)=cast("policy"."Car_license_provice" as integer)) as "car_license_province",
"request"."ref_notify_no","request"."accident_date" + interval '7HOUR' as "accident_date"
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Car_Act_Discount_Premium" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."claim_request" as "request"
on "policy"."Car_Act_No"="request"."acc_policy_no"
left join insurverse."sf_claim" as "claim"
on "request"."acc_policy_no"="claim"."acc_policy_no"
and "request"."ref_notify_no"="claim"."ref_notify_no" -- (2023-11-29)
where "claim"."acc_policy_no" is null
) as "request" order by "accident_date" desc) as "claim_request"),
-- ### claim_status ###
'claim_status',(select json_agg("claim_status")
from (select *
from (
-- ### claim_status - claim_request - mv ###
select "policy"."Policy_No" as "policy_no",
"policy"."Car_license_no" as "car_license_no",
cast("policy"."Car_license_provice" as integer) as "car_license_province_id",
(select "prname" from insurverse."province" WHERE "province"."provinceid"="policy"."Car_license_provice") as "car_license_province",
"request"."ref_notify_no","request"."accident_date" + interval '7HOUR' as "accident_date",
null as "claim_url_ref",null as "claim_url_ref_tp",
'' as "ref_claim_no",
cast((select json_build_object(
'request_date',null,
'approve_date',null,
'rep_bring_date',null,
'get_car_back_date',null
)) as text) as "claim_tracking"
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Header" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."claim_request" as "request"
on "policy"."Policy_No"="request"."acc_policy_no"
left join insurverse."sf_claim" as "claim"
on "request"."acc_policy_no"="claim"."acc_policy_no"
and "request"."ref_notify_no"="claim"."ref_notify_no" -- (2023-11-29)
where "claim"."acc_policy_no" is null
union 
-- ### claim_status - claim_request - mc ###
select "policy"."Car_Act_No" as "policy_no",
"policy"."Car_license_no" as "car_license_no",
cast("policy"."Car_license_provice" as integer) as "car_license_province_id",
(select "prname" from insurverse."province" WHERE cast("province"."provinceid" as integer)=cast("policy"."Car_license_provice" as integer)) as "car_license_province",
"request"."ref_notify_no","request"."accident_date" + interval '7HOUR' as "accident_date",
null as "claim_url_ref",null as "claim_url_ref_tp",
'' as "ref_claim_no",
cast((select json_build_object(
'request_date',null,
'approve_date',null,
'rep_bring_date',null,
'get_car_back_date',null
)) as text) as "claim_tracking"
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Car_Act_Discount_Premium" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."claim_request" as "request"
on "policy"."Car_Act_No"="request"."acc_policy_no"
left join insurverse."sf_claim" as "claim"
on "request"."acc_policy_no"="claim"."acc_policy_no"
and "request"."ref_notify_no"="claim"."ref_notify_no" -- (2023-11-29)
where "claim"."acc_policy_no" is null
UNION
-- ### claim_status - mv ###
select "policy"."Policy_No" as "policy_no",
"policy"."Car_license_no" as "car_license_no",
cast("policy"."Car_license_provice" as integer) as "car_license_province_id",
(select "prname" from insurverse."province" WHERE "province"."provinceid"="policy"."Car_license_provice") as "car_license_province",
"claim"."ref_notify_no","claim"."accident_date" + interval '7HOUR' as "accident_date",
"claim"."claim_url_ref","claim"."claim_url_ref_tp",
"claim"."ref_claim_no",
cast((select json_build_object(
'request_date',"claim"."accident_date" + interval '7HOUR',
'approve_date',"cover"."create_date" + interval '7HOUR',
'rep_bring_date',"item"."rep_bring_date" + interval '7HOUR',
'get_car_back_date',"item"."get_car_back_date" + interval '7HOUR'
)) as text) as "claim_tracking"
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Header" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."sf_claim" as "claim"
on "policy"."Policy_No"="claim"."acc_policy_no"
left join insurverse."sf_claim_coverage" as "cover"
on "claim"."ref_claim_no"="cover"."claim_id" -- (2023-12-12)
and "claim"."acc_policy_no"="cover"."policy_number" -- (2023-12-12)
left join insurverse."sf_claim_coverage_item" as "item"
on "cover"."claim_id"="item"."claim_id" and "item"."coverage_type"='IV'
union 
-- ### claim_status - mc ###
select "policy"."Car_Act_No" as "policy_no",
"policy"."Car_license_no" as "car_license_no",
cast("policy"."Car_license_provice" as integer) as "car_license_province_id",
(select "prname" from insurverse."province" WHERE cast("province"."provinceid" as integer)=cast("policy"."Car_license_provice" as integer)) as "car_license_province",
"claim"."ref_notify_no","claim"."accident_date" + interval '7HOUR' as "accident_date",
"claim"."claim_url_ref","claim"."claim_url_ref_tp",
"claim"."ref_claim_no",
cast((select json_build_object(
'request_date',"claim"."accident_date" + interval '7HOUR',
'approve_date',"cover"."create_date" + interval '7HOUR',
'rep_bring_date',"item"."rep_bring_date" + interval '7HOUR',
'get_car_back_date',"item"."get_car_back_date" + interval '7HOUR'
)) as text) as "claim_tracking"
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Car_Act_Discount_Premium" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."sf_claim" as "claim"
on "policy"."Car_Act_No"="claim"."acc_policy_no"
left join insurverse."sf_claim_coverage" as "cover"
on "claim"."ref_claim_no"="cover"."claim_id" -- (2023-12-12)
and "claim"."acc_policy_no"="cover"."policy_number" -- (2023-12-12)
left join insurverse."sf_claim_coverage_item" as "item"
on "cover"."claim_id"="item"."claim_id" and "item"."coverage_type"='IV'
) as "status" order by "accident_date" desc) as "claim_status"),
-- ### claim_history ###
'claim_history',(select json_agg("claim_history")
from (select *
from (
-- ### claim_history - mv ###
select "policy"."Policy_No" as "policy_no",
case when "cover"."status"='CL' then 'close'
when "cover"."status"='CC' then 'cancel'
else 'open' end as "claim_card_status",
"claim"."ref_notify_no","claim"."accident_date" + interval '7HOUR' as "accident_date",
"claim"."ref_claim_no",
case when "claim"."accident_cause" is null then 4
when "claim"."accident_cause" is not null then "claim"."accident_cause"
else 4
end as "accident_cause" -- เป็นฝ่ายประมาท (1=ผู้ขับขี่รถประกัน, 2=ผู้ขับขี่รถคู่กรณี, 3=ประมาททั้งสองฝ่าย, 4=รอสรุปผลคดี)
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Header" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."sf_claim" as "claim"
on "policy"."Policy_No"="claim"."acc_policy_no"
left join insurverse."sf_claim_coverage" as "cover"
on "claim"."ref_claim_no"="cover"."claim_id" -- (2023-12-12)
and "claim"."acc_policy_no"="cover"."policy_number" -- (2023-12-12)
left join insurverse."sf_claim_coverage_item" as "item"
on "cover"."claim_id"="item"."claim_id" and "item"."coverage_type"='IV'
union 
-- ### claim_history - mc ###
select "policy"."Car_Act_No" as "policy_no",
case when "cover"."status"='CL' then 'close'
when "cover"."status"='CC' then 'cancel'
else 'open' end as "claim_card_status",
"claim"."ref_notify_no","claim"."accident_date" + interval '7HOUR' as "accident_date",
"claim"."ref_claim_no",
case when "claim"."accident_cause" is null then 4
when "claim"."accident_cause" is not null then "claim"."accident_cause"
else 4 end as "accident_cause" -- เป็นฝ่ายประมาท (1=ผู้ขับขี่รถประกัน, 2=ผู้ขับขี่รถคู่กรณี, 3=ประมาททั้งสองฝ่าย, 4=รอสรุปผลคดี)
from set_para
inner join insurverse."sec_user" as "user"
on "set_para"."user_id"="user"."user_id"
or "set_para"."user_id" = 'claim_all_1234'
inner join insurverse."Policy_Car_Act_Discount_Premium" as "policy"
on "user"."email"="policy"."email"
inner join insurverse."sf_claim" as "claim"
on "policy"."Car_Act_No"="claim"."acc_policy_no"
left join insurverse."sf_claim_coverage" as "cover"
on "claim"."ref_claim_no"="cover"."claim_id" -- (2023-12-12)
and "claim"."acc_policy_no"="cover"."policy_number" -- (2023-12-12)
left join insurverse."sf_claim_coverage_item" as "item"
on "cover"."claim_id"="item"."claim_id" and "item"."coverage_type"='IV'
) as "history" order by "accident_date" desc) as "claim_history")
)
INTO RTN_JSON;

RETURN RTN_JSON;

END
$function$
