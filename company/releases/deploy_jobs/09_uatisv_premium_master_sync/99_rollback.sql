-- 09 / 99 — ROLLBACK (writes UAT-ISV). NOT RUN YET. UAT-ISV ONLY.
-- psql "<uat-isv conn>" -v ON_ERROR_STOP=1 -f 99_rollback.sql
-- Restores the three smoke cars' Imp_Price_Premium rows and sys_param duty_per exactly as snapshotted by 01_backup.sql.
-- Rows of these cars written after the backup by anyone else (e.g. a premium upload) are also removed — check first.
\set ON_ERROR_STOP on
SELECT (host(inet_server_addr()) IN ('136.85.102.224','10.242.0.6')) AS is_uatisv,
       (to_regclass('insurverse._bk09_imp_price_premium') IS NOT NULL
        AND to_regclass('insurverse._bk09_sys_param') IS NOT NULL) AS backup_present \gset
\if :is_uatisv
\else
  \echo 'ABORT: server is not the UAT-ISV Cloud SQL instance.'
  \quit
\endif
\if :backup_present
\else
  \echo 'ABORT: backup tables insurverse._bk09_* not found — nothing to restore from.'
  \quit
\endif

BEGIN;
SELECT pg_advisory_xact_lock(hashtext('deploy_job_09_imp_price_premium'));

-- A) Imp_Price_Premium: replace the three car-years with the backup (backup had 17 rows on 2026-09-25)
DELETE FROM insurverse."Imp_Price_Premium"
WHERE ("Brand","Model","Year") IN (('Toyota','Yaris','2024'),('Mitsubishi','Attrage','2021'),('Jeep','Wrangler','2010'));

INSERT INTO insurverse."Imp_Price_Premium"
SELECT (jsonb_populate_record(NULL::insurverse."Imp_Price_Premium", to_jsonb(b) - 'bk_at')).*
FROM insurverse._bk09_imp_price_premium b;

-- B) sys_param duty_per back to the snapshotted value
UPDATE insurverse.sys_param s
   SET para_value = b.para_value, para_str = b.para_str, update_date = b.update_date, update_by = b.update_by
  FROM insurverse._bk09_sys_param b
 WHERE s.dom_code = b.dom_code AND s.sub_dom_code = b.sub_dom_code AND s.para_code = b.para_code;

-- verify: counts must equal the backup
SELECT (SELECT count(*) FROM insurverse."Imp_Price_Premium"
         WHERE ("Brand","Model","Year") IN (('Toyota','Yaris','2024'),('Mitsubishi','Attrage','2021'),('Jeep','Wrangler','2010'))) AS ipp_now,
       (SELECT count(*) FROM insurverse._bk09_imp_price_premium) AS ipp_backup,
       (SELECT para_value FROM insurverse.sys_param WHERE dom_code='purchase' AND sub_dom_code='duty' AND para_code='duty_per') AS duty_per_now;
COMMIT;

-- After a successful rollback (and once nobody needs the snapshot):
--   DROP TABLE insurverse._bk09_imp_price_premium; DROP TABLE insurverse._bk09_sys_param;
