-- 09 / 00 — PRECHECK (read-only). Safe to run any time on UAT-ISV (and on UAT for comparison).
-- psql "<uat-isv conn>" -v ON_ERROR_STOP=1 -f 00_precheck_readonly.sql
BEGIN READ ONLY;

-- 1) schema guard: the columns 02_sync.sql populates must exist with these types (80 cols, identical names+types on UAT and UAT-ISV 2026-09-25)
SELECT count(*) AS ipp_cols,
       md5(string_agg(column_name||':'||data_type, ',' ORDER BY column_name)) AS ipp_cols_md5
FROM information_schema.columns
WHERE table_schema='insurverse' AND table_name='Imp_Price_Premium';
-- expected 2026-09-25 (both envs): 80 | 1794e180dd145fbe8eade0328123b3aa

SELECT column_name, data_type FROM information_schema.columns
WHERE table_schema='insurverse' AND table_name='sys_param'
  AND column_name IN ('dom_code','sub_dom_code','para_code','para_value','para_str','update_date','update_by');
-- expected 7 rows

-- 2) global counts (2026-09-25: UAT-ISV 130000 / 31926 active ; UAT 363862 / 87444 active)
SELECT count(*) AS ipp_total, count(*) FILTER (WHERE is_active) AS ipp_active FROM insurverse."Imp_Price_Premium";
SELECT count(*) AS idp_total FROM insurverse."Imp_Discount_Premium";   -- 23665 ISV / 23739 UAT

-- 3) smoke cars: active premium groups (the key premium-service loadPremium builds = Type_GarageType_driver_behavior)
SELECT "Brand","Model","Year", count(*) AS active_rows,
       string_agg(DISTINCT "Type"||'_'||"GarageType"||'_'||coalesce(driver_behavior::text,''), ',') AS groups
FROM insurverse."Imp_Price_Premium"
WHERE is_active AND ("Brand","Model","Year") IN (('Toyota','Yaris','2024'),('Mitsubishi','Attrage','2021'),('Jeep','Wrangler','2010'))
GROUP BY 1,2,3 ORDER BY 1,2,3;
-- before sync (UAT-ISV): only Toyota Yaris 2024 | 4 | 3_G_0,3_G_1
-- after sync / UAT     : Jeep Wrangler 2010 4 (3_G_*), Mitsubishi Attrage 2021 16, Toyota Yaris 2024 20 (incl. 1_SC_0)

-- 4) duplicate-active guard: must return 0 rows before AND after the sync
SELECT "Brand","Model","Year","Doors","CC","Usage","Type","GarageType",driver_behavior, count(*)
FROM insurverse."Imp_Price_Premium" WHERE is_active
  AND ("Brand","Model","Year") IN (('Toyota','Yaris','2024'),('Mitsubishi','Attrage','2021'),('Jeep','Wrangler','2010'))
GROUP BY 1,2,3,4,5,6,7,8,9 HAVING count(*) > 1;

-- 5) the exact loadPremium query for the smoke default car (Yaris 2024, 4 doors, <=2000) — must list 1_SC_0 after sync
SELECT ipp."Type"||'_'||ipp."GarageType"||'_'||ipp.driver_behavior AS premium_group_key, ipp.version, idp."Total" AS prem_act
FROM insurverse."Imp_Price_Premium" ipp
JOIN insurverse."Imp_Discount_Premium" idp ON ipp."Brand"=idp."Brand" AND ipp."Model"=idp."Model" AND ipp."Year"=idp."Year"
 AND ipp."Doors"=idp."Doors" AND ipp."Usage"=CAST(insurverse.fn_comp_to_usage(idp."Comp_Code") AS SMALLINT)
WHERE ipp."Brand"='Toyota' AND ipp."Model"='Yaris' AND ipp."Year"='2024' AND ipp."Doors"=4 AND ipp."CC"='<=2000' AND ipp.is_active
ORDER BY 1;

-- 6) duty / vat config read by go-echo-pa-service, go-echo-home-service, premium-service TA and fn_policy_renewal
--    duty = CEIL(prem * para_value / 100)   → 0.004 gives 1 THB, 0.4 gives 0.4 %
SELECT dom_code, sub_dom_code, para_code, para_value, para_str, para_status
FROM insurverse.sys_param WHERE dom_code='purchase' AND sub_dom_code IN ('duty','vat');
-- 2026-09-25: UAT-ISV duty_per 0.004000 ; UAT duty_per 0.400000 (vat_per 7 on both)

-- 7) backup tables of this job (exist only after 01_backup.sql was run)
SELECT to_regclass('insurverse._bk09_imp_price_premium') AS bk_ipp, to_regclass('insurverse._bk09_sys_param') AS bk_sys_param;

ROLLBACK;
