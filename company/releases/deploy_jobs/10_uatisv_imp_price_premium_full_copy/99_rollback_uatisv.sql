-- UAT-ISV ONLY. Restore insurverse."Imp_Price_Premium" from the job-10 backup.
\set ON_ERROR_STOP on
BEGIN;
DO $$ BEGIN
  IF coalesce(host(inet_server_addr()),'') NOT IN ('136.85.102.224','10.242.0.6') THEN
    RAISE EXCEPTION 'job10: not UAT-ISV (server %)', inet_server_addr();
  END IF;
END $$;
TRUNCATE insurverse."Imp_Price_Premium";
INSERT INTO insurverse."Imp_Price_Premium" SELECT * FROM insurverse._bk10_imp_price_premium;
SELECT 'restored rows', count(*) FROM insurverse."Imp_Price_Premium";
COMMIT;
