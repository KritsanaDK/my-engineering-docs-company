-- 09 / 01 — BACKUP (writes 2 small tables on UAT-ISV). NOT RUN YET. UAT-ISV ONLY.
-- psql "<uat-isv conn>" -v ON_ERROR_STOP=1 -f 01_backup.sql
-- Snapshots exactly what 02_sync.sql can touch, so 99_rollback.sql can restore it byte-for-byte.
-- Fails (on purpose) if a backup from an earlier run already exists — drop it only after you are sure it is not needed.
\set ON_ERROR_STOP on
SELECT (host(inet_server_addr()) IN ('136.85.102.224','10.242.0.6')) AS is_uatisv \gset
\if :is_uatisv
\else
  \echo 'ABORT: server is not the UAT-ISV Cloud SQL instance.'
  \quit
\endif
BEGIN;

CREATE TABLE insurverse._bk09_imp_price_premium AS
SELECT now() AS bk_at, t.*
FROM insurverse."Imp_Price_Premium" t
WHERE (t."Brand", t."Model", t."Year") IN (('Toyota','Yaris','2024'),('Mitsubishi','Attrage','2021'),('Jeep','Wrangler','2010'));
-- expected 2026-09-25: 17 rows (Yaris 2024 only; 4 active)

CREATE TABLE insurverse._bk09_sys_param AS
SELECT now() AS bk_at, s.*
FROM insurverse.sys_param s
WHERE s.dom_code='purchase' AND s.sub_dom_code='duty' AND s.para_code='duty_per';
-- expected 1 row, para_value 0.004000

SELECT (SELECT count(*) FROM insurverse._bk09_imp_price_premium) AS bk_ipp_rows,
       (SELECT count(*) FROM insurverse._bk09_sys_param)         AS bk_sys_param_rows;
COMMIT;
