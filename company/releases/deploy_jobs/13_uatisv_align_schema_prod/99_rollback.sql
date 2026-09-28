-- Rollback 13_uatisv_align_schema_prod (UAT-ISV). Restores the pre-job state.
-- View: re-apply the saved definition first:  psql ... -f backup/backup_v_lead_policy_product_<TS>.sql  (CREATE VIEW -> use CREATE OR REPLACE VIEW)
\set ON_ERROR_STOP on
BEGIN;
ALTER TABLE insurverse.iia_commission    ALTER COLUMN id DROP DEFAULT;
ALTER TABLE insurverse.tqm_car_mapping   ALTER COLUMN id DROP DEFAULT;
ALTER TABLE insurverse.tqm_group_premium ALTER COLUMN id DROP DEFAULT;
ALTER TABLE insurverse.tqm_premium       ALTER COLUMN id DROP DEFAULT;
ALTER TABLE insurverse.shopee_product_form
  ALTER COLUMN category DROP DEFAULT, ALTER COLUMN category DROP NOT NULL,
  ALTER COLUMN claim_price DROP DEFAULT, ALTER COLUMN claim_price DROP NOT NULL,
  ALTER COLUMN price DROP DEFAULT, ALTER COLUMN price DROP NOT NULL,
  ALTER COLUMN discount DROP DEFAULT, ALTER COLUMN discount DROP NOT NULL,
  ALTER COLUMN listing_test DROP DEFAULT, ALTER COLUMN listing_test DROP NOT NULL,
  ALTER COLUMN link_test DROP DEFAULT, ALTER COLUMN link_test DROP NOT NULL,
  ALTER COLUMN link DROP DEFAULT, ALTER COLUMN link DROP NOT NULL,
  ALTER COLUMN status DROP DEFAULT, ALTER COLUMN status DROP NOT NULL,
  ALTER COLUMN sms_temp DROP DEFAULT, ALTER COLUMN sms_temp DROP NOT NULL;
DROP INDEX IF EXISTS insurverse.idx_pcadp_car_act_lead_no;
COMMIT;
