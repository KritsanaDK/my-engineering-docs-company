-- DBeaver version of 02_align.sql WITHOUT the view (#5 already applied 2026-09-28). Run with Execute SQL Script (Alt+X). UAT-ISV only.
BEGIN;
-- #6a id defaults (Prod: DEFAULT nextval(...)); sequence moved to MAX(id)+1, never hardcoded
ALTER TABLE insurverse.iia_commission    ALTER COLUMN id SET DEFAULT nextval('insurverse.iia_commission_id_seq'::regclass);
ALTER TABLE insurverse.tqm_car_mapping   ALTER COLUMN id SET DEFAULT nextval('insurverse.tqm_car_mapping_id_seq'::regclass);
ALTER TABLE insurverse.tqm_group_premium ALTER COLUMN id SET DEFAULT nextval('insurverse.tqm_group_premium_id_seq'::regclass);
ALTER TABLE insurverse.tqm_premium       ALTER COLUMN id SET DEFAULT nextval('insurverse.tqm_premium_id_seq'::regclass);
SELECT setval('insurverse.iia_commission_id_seq',    COALESCE((SELECT MAX(id) FROM insurverse.iia_commission), 0) + 1, false);
SELECT setval('insurverse.tqm_car_mapping_id_seq',   COALESCE((SELECT MAX(id) FROM insurverse.tqm_car_mapping), 0) + 1, false);
SELECT setval('insurverse.tqm_group_premium_id_seq', COALESCE((SELECT MAX(id) FROM insurverse.tqm_group_premium), 0) + 1, false);
SELECT setval('insurverse.tqm_premium_id_seq',       COALESCE((SELECT MAX(id) FROM insurverse.tqm_premium), 0) + 1, false);

-- #6b shopee_product_form: Prod NOT NULL + defaults (precheck 2026-09-28: 57 rows, 0 NULL in all 9 columns)
ALTER TABLE insurverse.shopee_product_form
  ALTER COLUMN category     SET DEFAULT ''::character varying, ALTER COLUMN category     SET NOT NULL,
  ALTER COLUMN claim_price  SET DEFAULT 0,                     ALTER COLUMN claim_price  SET NOT NULL,
  ALTER COLUMN price        SET DEFAULT 0,                     ALTER COLUMN price        SET NOT NULL,
  ALTER COLUMN discount     SET DEFAULT 0,                     ALTER COLUMN discount     SET NOT NULL,
  ALTER COLUMN listing_test SET DEFAULT false,                 ALTER COLUMN listing_test SET NOT NULL,
  ALTER COLUMN link_test    SET DEFAULT ''::character varying, ALTER COLUMN link_test    SET NOT NULL,
  ALTER COLUMN link         SET DEFAULT ''::character varying, ALTER COLUMN link         SET NOT NULL,
  ALTER COLUMN status       SET DEFAULT 'active'::character varying, ALTER COLUMN status SET NOT NULL,
  ALTER COLUMN sms_temp     SET DEFAULT ''::text,              ALTER COLUMN sms_temp     SET NOT NULL;

-- #6c index present on Prod
CREATE INDEX IF NOT EXISTS idx_pcadp_car_act_lead_no ON insurverse."Policy_Car_Act_Discount_Premium" USING btree ("Car_Act_Lead_No") WHERE ("Car_Act_Lead_No" IS NOT NULL);

COMMIT;
