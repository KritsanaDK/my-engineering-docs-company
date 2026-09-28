-- UAT-ISV ONLY. Restore duty_per from the job-11 backup.
\set ON_ERROR_STOP on
BEGIN;
DO $$ BEGIN
  IF coalesce(host(inet_server_addr()),'') NOT IN ('136.85.102.224','10.242.0.6') THEN RAISE EXCEPTION 'job11: not UAT-ISV'; END IF;
END $$;
UPDATE insurverse.sys_param s SET para_value = b.para_value FROM insurverse._bk11_sys_param_duty b
 WHERE s.dom_code='purchase' AND s.sub_dom_code='duty' AND s.para_code='duty_per';
SELECT para_value FROM insurverse.sys_param WHERE dom_code='purchase' AND sub_dom_code='duty' AND para_code='duty_per';
COMMIT;
