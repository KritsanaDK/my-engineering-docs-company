-- UAT-ISV ONLY. sys_param purchase/duty/duty_per 0.004 -> 0.4 (decision 2026-09-25).
-- duty = CEIL(prem * duty_per / 100): 0.4 = 0.4% = stamp duty 1 THB per 250 THB (same as UAT; smoke 5.08 rule).
-- 0.004 made every PA/HI duty 1 THB. Also read by premium-service TA and fn_policy_renewal.
\set ON_ERROR_STOP on
BEGIN;
DO $$ BEGIN
  IF coalesce(host(inet_server_addr()),'') NOT IN ('136.85.102.224','10.242.0.6') THEN
    RAISE EXCEPTION 'job11: not UAT-ISV (server %)', inet_server_addr();
  END IF;
END $$;
CREATE TABLE IF NOT EXISTS insurverse._bk11_sys_param_duty AS
  SELECT now() AS backup_at, * FROM insurverse.sys_param WHERE dom_code='purchase' AND sub_dom_code='duty' AND para_code='duty_per';
SELECT 'backup', para_value FROM insurverse._bk11_sys_param_duty;
UPDATE insurverse.sys_param SET para_value = 0.4
 WHERE dom_code='purchase' AND sub_dom_code='duty' AND para_code='duty_per';
SELECT 'now', para_value FROM insurverse.sys_param WHERE dom_code='purchase' AND sub_dom_code='duty' AND para_code='duty_per';
COMMIT;
