-- UAT-ISV ONLY — undo 01_seed_tqm_master_uatisv.sql (both tables were empty before the seed).
BEGIN;
DELETE FROM insurverse.tqm_allow_process WHERE api_name IN ('/policy/tqm/cmi','/policy/tqm/vmi','/policy/tqm/vmi/ftp');
DELETE FROM insurverse.tqm_car_license_provice;
COMMIT;
