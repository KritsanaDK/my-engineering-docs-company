-- =============================================================================
-- WS9.5 BigQuery Schema Migration & View Aliases (Thai -> English)
-- BigQuery Dataset: insurverse_analytics
-- =============================================================================

-- 1. Create Compatibility View mapping legacy Thai column names to English standard names
CREATE OR REPLACE VIEW `insurverse_analytics.v_policy_daily_english` AS
SELECT
  -- Legacy Thai Name Aliases to Standard English Column Names
  `ชื่อ` AS first_name,
  `นามสกุล` AS last_name,
  `เบอร์โทรศัพท์` AS mobile_phone,
  `เลขตัวถัง` AS car_serial_no,
  `ทะเบียนรถ` AS car_license_no,
  `วันหมดอายุ` AS expiration_date,
  `เลขที่กรมธรรม์` AS policy_no,
  `เลขที่ใบเสร็จ` AS receipt_no,
  `เบี้ยประกันรวม` AS total_premium,
  `สถานะกรมธรรม์` AS policy_status,
  `วันที่สร้าง` AS created_at
FROM `insurverse_analytics.policy_daily_lastversion`;
