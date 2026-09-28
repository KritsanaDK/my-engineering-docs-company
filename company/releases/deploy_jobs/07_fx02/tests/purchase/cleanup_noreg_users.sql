-- UAT-ISV ONLY. Remove sec_user rows auto-registered by the fix/fx-02-purchase E2E (NOREG test emails).
-- Review the SELECT first; run the DELETE only after approval.
SELECT user_id, email, create_date, sf_account
FROM insurverse.sec_user
WHERE email LIKE 'kritsana.w.os+fx02-noreg-%@horixon-t8.com'
ORDER BY create_date;

-- BEGIN;
-- DELETE FROM insurverse.sec_user WHERE email LIKE 'kritsana.w.os+fx02-noreg-%@horixon-t8.com';
-- COMMIT;
