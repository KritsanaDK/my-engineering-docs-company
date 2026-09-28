-- UAT-ISV ONLY. Replace insurverse."Imp_Price_Premium" with UAT's full copy (decision 2026-09-25, option ก).
-- Run: psql <uat-isv> -v ON_ERROR_STOP=1 run via 02_run.sh <csv> (psql does not expand variables inside \copy)
-- One transaction: backup -> clear -> load -> verify; any error rolls everything back.
\set ON_ERROR_STOP on
BEGIN;
SELECT pg_advisory_xact_lock(hashtext('job10_imp_price_premium'));
DO $$ BEGIN
  IF coalesce(host(inet_server_addr()),'') NOT IN ('136.85.102.224','10.242.0.6') THEN
    RAISE EXCEPTION 'job10: not UAT-ISV (server %)', inet_server_addr();
  END IF;
END $$;
DROP TABLE IF EXISTS insurverse._bk10_imp_price_premium;
CREATE TABLE insurverse._bk10_imp_price_premium AS TABLE insurverse."Imp_Price_Premium";
SELECT 'backup rows', count(*) FROM insurverse._bk10_imp_price_premium;
TRUNCATE insurverse."Imp_Price_Premium";
\copy insurverse."Imp_Price_Premium" from '__CSV__' with (format csv, header true)
SELECT 'loaded rows', count(*), 'active', count(*) FILTER (WHERE is_active) FROM insurverse."Imp_Price_Premium";
DO $$ BEGIN
  IF (SELECT count(*) FROM insurverse."Imp_Price_Premium") <> 363862 THEN RAISE EXCEPTION 'job10: row count mismatch, rolling back'; END IF;
END $$;
COMMIT;
