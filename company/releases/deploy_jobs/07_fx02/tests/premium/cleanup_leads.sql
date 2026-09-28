-- Removes motor leads created by concurrent_save_lead.py on UAT-ISV (run only with approval).
-- Preview first:
select count(*), min("Lead_No"), max("Lead_No") from insurverse."Lead_coverage_premium"
 where lower("Email") like 'kritsana.w.os+fx02-%@horixon-t8.com';
-- delete from insurverse."Lead_coverage_premium" where lower("Email") like 'kritsana.w.os+fx02-%@horixon-t8.com';
