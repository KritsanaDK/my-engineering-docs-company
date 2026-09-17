-- =============================================================================
-- Function: insurverse.trg_fn_sync_pcad_from_ph
-- OID: 25151
-- Identity Arguments: ()
-- Returns: trigger
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.trg_fn_sync_pcad_from_ph()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	BEGIN
		IF NEW."Car_Act_No" IS NOT NULL AND NEW."Car_Act_No" <> '' THEN
			UPDATE insurverse."Policy_Car_Act_Discount_Premium"
			SET 
				"Policy_No" = NEW."Policy_No",
				"email" = NEW."email",
				"Policy_url_ref" = CASE WHEN "Policy_url_ref" IS NULL OR "Policy_url_ref" = '' THEN COALESCE(NEW."Policy_url_ref", 'https://storage.googleapis.com/insurverse-storage-uat/1757663417640197470_cvuk858tawqy2ktf.pdf') ELSE "Policy_url_ref" END,
				"Policy_url_copy_ref" = CASE WHEN "Policy_url_copy_ref" IS NULL OR "Policy_url_copy_ref" = '' THEN COALESCE(NEW."Policy_url_copy_ref", 'https://storage.googleapis.com/insurverse-storage-uat/1757663417640197470_cvuk858tawqy2ktf.pdf') ELSE "Policy_url_copy_ref" END,
				"Receipt_url_ref" = CASE WHEN "Receipt_url_ref" IS NULL OR "Receipt_url_ref" = '' THEN COALESCE(NEW."Receipt_url_ref", 'https://storage.googleapis.com/insurverse-storage-uat/1757663427854059915_ytf5nvor204cq4i0.pdf') ELSE "Receipt_url_ref" END,
				"Receipt_url_copy_ref" = CASE WHEN "Receipt_url_copy_ref" IS NULL OR "Receipt_url_copy_ref" = '' THEN COALESCE(NEW."Receipt_url_copy_ref", 'https://storage.googleapis.com/insurverse-storage-uat/1757663427854059915_ytf5nvor204cq4i0.pdf') ELSE "Receipt_url_copy_ref" END
			WHERE "Car_Act_No" = NEW."Car_Act_No";
		END IF;
		RETURN NEW;
	END;
	$function$
