-- =============================================================================
-- Function: insurverse.fn_sf_policy_endorse_detail
-- OID: 28472
-- Identity Arguments: (in_policy_no text, policy_type text, rtn_doc_type text, in_policy_trans_id text, in_change_total_amt numeric, effective_date timestamp without time zone)
-- Returns: text
-- Language: plpgsql
-- Categorization: 02_operations_and_crm
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE FUNCTION insurverse.fn_sf_policy_endorse_detail(in_policy_no text, policy_type text, rtn_doc_type text, in_policy_trans_id text, in_change_total_amt numeric, effective_date timestamp without time zone)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	rtn record;
	SYS_BOOK_NO TEXT; SYS_INVOICE_NO TEXT; SYS_QUA_NO TEXT;
	PREV_BOOK_NO TEXT; PREV_INVOICE_NO TEXT; PREV_QUA_NO TEXT; PREV_SF_POLICY_ID TEXT;
	RTN_MSG TEXT;
BEGIN
	
	RTN_MSG = 'success';
	IF in_change_total_amt is null THEN
		in_change_total_amt = 0;
	END IF;
	IF in_policy_no IS NOT NULL AND in_policy_no != '' THEN
		IF policy_type IS NOT NULL AND policy_type != '' AND policy_type != 'F' THEN
			IF rtn_doc_type IS NOT NULL AND rtn_doc_type != '' THEN
				FOR rtn IN SELECT unnest(string_to_array(rtn_doc_type, ',')) as "doc_t"
				LOOP
					SYS_BOOK_NO = null;
					SYS_INVOICE_NO = null;
					SYS_QUA_NO = null;
					IF (in_change_total_amt IS NULL OR in_change_total_amt=0 OR CAST("rtn" as TEXT) like '%_t%') 
					AND CAST("rtn" as TEXT) not like '%_11%' AND CAST("rtn" as TEXT) not like '%_nt%'
					THEN
						RTN_MSG = "rtn";
						SYS_BOOK_NO = insurverse.fn_policy_book_iia();
						SYS_INVOICE_NO = insurverse.fn_policy_invoiceno_iia();
						SYS_QUA_NO = insurverse.fn_policy_quatationno_iia_endorse("in_policy_no");
					ELSIF (in_change_total_amt < 0 AND CAST("rtn" as TEXT) not like '%_nt%' 
					AND CAST("rtn" as TEXT) not like '%_t%') OR CAST("rtn" as TEXT) like '%_11%' THEN
						SYS_BOOK_NO = insurverse.fn_policy_book_de_debt_iia();
						SYS_INVOICE_NO = insurverse.fn_policy_invoiceno_de_debt_iia();
						SYS_QUA_NO = insurverse.fn_policy_quatationno_de_debt_iia();
					ELSIF in_change_total_amt > 0 AND CAST("rtn" as TEXT) not like '%_nt' 
					AND CAST("rtn" as TEXT) not like '%_t%' THEN
						SYS_BOOK_NO = insurverse.fn_policy_book_in_debt_iia();
						SYS_INVOICE_NO = insurverse.fn_policy_invoiceno_in_debt_iia();
						SYS_QUA_NO = insurverse.fn_policy_quatationno_in_debt_iia();
					END IF;
					
					IF policy_type = 'V' THEN
						SELECT "SF_Policy_id","Policy_book","Policy_Invoice_No","Policy_Quatation_No"
						FROM insurverse."Policy_endorse_detail"
						WHERE "Policy_No"=in_policy_no AND "SF_Policy_id" != in_policy_trans_id
						AND "SF_Policy_id" IS NOT NULL AND "Policy_book" IS NOT NULL
						AND "Policy_Invoice_No" IS NOT NULL AND "Policy_Quatation_No" IS NOT NULL
						ORDER BY create_at DESC LIMIT 1
						INTO PREV_SF_POLICY_ID,PREV_BOOK_NO,PREV_INVOICE_NO,PREV_QUA_NO;
						
						IF PREV_SF_POLICY_ID IS NULL OR PREV_SF_POLICY_ID = '' THEN
							SELECT "SF_Policy_id","Policy_book","Policy_Invoice_No","Policy_Quatation_No"
							FROM insurverse."Policy_Header_Trans"
							WHERE "Policy_No"=in_policy_no AND "SF_Policy_id" != in_policy_trans_id
							AND "SF_Policy_id" IS NOT NULL AND "Policy_book" IS NOT NULL
							AND "Policy_Invoice_No" IS NOT NULL AND "Policy_Quatation_No" IS NOT NULL
							ORDER BY "Create_date" ASC LIMIT 1
							INTO PREV_SF_POLICY_ID,PREV_BOOK_NO,PREV_INVOICE_NO,PREV_QUA_NO;
						END IF;
					
						INSERT INTO insurverse."Policy_endorse_detail"
						("Policy_No","doc_type","SF_Policy_id","Policy_book","Policy_Quatation_No","Policy_Invoice_No","effective_date",
						"prev_SF_Policy_id","prev_Policy_book","prev_Policy_Invoice_No","prev_Policy_Quatation_No","Change_Total_Amt")
						VALUES (in_policy_no,rtn.doc_t,in_policy_trans_id,
						SYS_BOOK_NO,SYS_QUA_NO,SYS_INVOICE_NO,"effective_date",
						PREV_SF_POLICY_ID,PREV_BOOK_NO,PREV_INVOICE_NO,PREV_QUA_NO,in_change_total_amt);
						
					ELSIF policy_type = 'C' THEN 
						SELECT "SF_Policy_id","Policy_book","Policy_Invoice_No","Policy_Quatation_No"
						FROM insurverse."Policy_endorse_detail"
						WHERE "Car_Act_No"=in_policy_no AND "SF_Policy_id" != in_policy_trans_id
						ORDER BY create_at DESC LIMIT 1
						INTO PREV_SF_POLICY_ID,PREV_BOOK_NO,PREV_INVOICE_NO,PREV_QUA_NO;
						
						IF PREV_SF_POLICY_ID IS NULL OR PREV_SF_POLICY_ID = '' THEN
							SELECT "SF_Policy_id","Policy_book","Policy_Invoice_No","Policy_Quatation_No"
							FROM insurverse."Policy_Car_Act_Discount_Premium_Trans"
							WHERE "Car_Act_No"=in_policy_no AND "SF_Policy_id" != in_policy_trans_id
							ORDER BY "Create_date" ASC LIMIT 1
							INTO PREV_SF_POLICY_ID,PREV_BOOK_NO,PREV_INVOICE_NO,PREV_QUA_NO;
						END IF;
						
						INSERT INTO insurverse."Policy_endorse_detail"
						("Car_Act_No","doc_type","SF_Policy_id","Policy_book","Policy_Quatation_No","Policy_Invoice_No","effective_date",
						"prev_SF_Policy_id","prev_Policy_book","prev_Policy_Invoice_No","prev_Policy_Quatation_No","Change_Total_Amt")
						VALUES (in_policy_no,rtn.doc_t,in_policy_trans_id,
						SYS_BOOK_NO,SYS_QUA_NO,SYS_INVOICE_NO,"effective_date",
						PREV_SF_POLICY_ID,PREV_BOOK_NO,PREV_INVOICE_NO,PREV_QUA_NO,in_change_total_amt);
					END IF;
					
				END LOOP;
			END IF;
		END IF;
	END IF;
	RETURN RTN_MSG;
END
$function$
