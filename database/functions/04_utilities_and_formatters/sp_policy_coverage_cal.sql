-- =============================================================================
-- Function: insurverse.sp_policy_coverage_cal
-- OID: 19008
-- Identity Arguments: (IN policy_no character varying)
-- Returns: None
-- Language: plpgsql
-- Categorization: 04_utilities_and_formatters
-- Extracted: 2026-09-17 15:03:07
-- Source DB: UAT-ISV (136.85.102.224:5432 / insurverse)
-- Governance: AGENTS.md Rule 3 Mandatory DB Function Backup
-- =============================================================================

CREATE OR REPLACE PROCEDURE insurverse.sp_policy_coverage_cal(IN policy_no character varying)
 LANGUAGE plpgsql
AS $procedure$
 
 DECLARE 
 E_ANS text;
 D_ENDDATE timestamp DEFAULT '2099-01-01 00:00:00.000000';
 H_EFFECTIVE_STARTDATE timestamp;
 H_POLICY_ENDDATE timestamp;
 P_SI_ANS int;
 P_SI_TPBI_ANS int;
 P_SI_TPPD_ANS int;
 P_SI_MV01_ANS int;
 P_SI_MV02_ANS int;
 P_SI_MV03_ANS int;
 P_SI_ACCESS_ANS int;
 P_SI_LIMIT numeric(18,0);
 P_SI_TPBI_LIMIT numeric(18,0);
 P_SI_TPPD_LIMIT numeric(18,0);
 P_SI_MV01_LIMIT numeric(18,0);
 P_SI_MV02_LIMIT numeric(18,0);
 P_SI_MV03_LIMIT numeric(18,0);
 P_SI_ACCESS_LIMIT numeric(18,0);
 P_OD_AMT numeric(18,0);
 P_FT_AMT numeric(18,0);
 P_SI_TPBI_AMT numeric(18,0);
 P_SI_TPPD_AMT numeric(18,0);
 P_SI_MV01_AMT numeric(18,0);
 P_SI_MV02_AMT numeric(18,0);
 P_SI_MV03_AMT numeric(18,2);
 P_SI_ACCESS_AMT numeric(18,2);
 BEGIN
 
 SELECT "Effective_Startdate","Policy_Enddate"
 FROM "Policy_Header"
 WHERE "Policy_No"=policy_no
 INTO H_EFFECTIVE_STARTDATE,H_POLICY_ENDDATE;
 
 SELECT "SI_Ans","SI_TPBI_Ans","SI_TPPD_Ans",
 "SI_MV01_Ans","SI_MV02_Ans","SI_MV03_Ans",
 "SI_Access_Ans"
 FROM "Policy_coverage_premium"
 WHERE "Policy_No"=policy_no
 INTO P_SI_ANS,P_SI_TPBI_ANS,P_SI_TPPD_ANS,
 P_SI_MV01_ANS,P_SI_MV02_ANS,P_SI_MV03_ANS,
 P_SI_ACCESS_ANS;
 
 E_ANS = '"SI_' || P_SI_ANS ||'", "Prem_OD_' || P_SI_ANS ||'", "Prem_FT_' || P_SI_ANS || '"';
 IF P_SI_TPBI_ANS IS NOT NULL OR P_SI_TPBI_ANS != 0 THEN
	E_ANS = E_ANS || ',"SI_TPBI_' || P_SI_TPBI_ANS ||'", "Prem_TPBI_' || P_SI_TPBI_ANS ||'"';
 ELSE 
  E_ANS = E_ANS || ',0,0';
 END IF;
 IF P_SI_TPPD_ANS IS NOT NULL OR P_SI_TPPD_ANS != 0 THEN
  E_ANS = E_ANS || ',"SI_TPPD_' || P_SI_TPPD_ANS ||'", "Prem_TPPD_' || P_SI_TPPD_ANS ||'"';
 ELSE 
  E_ANS = E_ANS || ',0,0';
 END IF;
 IF P_SI_MV01_ANS IS NOT NULL OR P_SI_MV01_ANS != 0 THEN
  E_ANS = E_ANS || ',"SI_MV01_' || P_SI_MV01_ANS ||'", "Prem_MV01_' || P_SI_MV01_ANS ||'"';
 ELSE 
  E_ANS = E_ANS || ',0,0';
 END IF;
 IF P_SI_MV02_ANS IS NOT NULL OR P_SI_MV02_ANS != 0 THEN
  E_ANS = E_ANS || ',"SI_MV02_' || P_SI_MV02_ANS ||'", "Prem_MV02_' || P_SI_MV02_ANS ||'"';
 ELSE 
  E_ANS = E_ANS || ',0,0';
 END IF;
 IF P_SI_MV03_ANS IS NOT NULL OR P_SI_MV03_ANS != 0 THEN
  E_ANS = E_ANS || ',"SI_MV03_' || P_SI_MV03_ANS ||'", "Prem_MV03_' || P_SI_MV03_ANS ||'"';
 ELSE 
  E_ANS = E_ANS || ',0,0';
 END IF;
 IF P_SI_ACCESS_ANS IS NOT NULL OR P_SI_ACCESS_ANS != 0 THEN
  E_ANS = E_ANS || ',"SI_Access_' || P_SI_ACCESS_ANS ||'", "Prem_Access_' || P_SI_ACCESS_ANS ||'"';
 ELSE 
  E_ANS = E_ANS || ',0,0';
 END IF;
 
 EXECUTE
 'SELECT ' || E_ANS || '
 FROM "Policy_coverage_premium"
 WHERE "Policy_No"=''' || policy_no || ''''
 INTO P_SI_LIMIT,P_OD_AMT,P_FT_AMT,
 P_SI_TPBI_LIMIT,P_SI_TPBI_AMT,
 P_SI_TPPD_LIMIT,P_SI_TPPD_AMT,
 P_SI_MV01_LIMIT,P_SI_MV01_AMT,
 P_SI_MV02_LIMIT,P_SI_MV02_AMT,
 P_SI_MV03_LIMIT,P_SI_MV03_AMT,
 P_SI_ACCESS_LIMIT,P_SI_ACCESS_AMT;
 
 UPDATE "Policy_coverage_premium"
 SET "Effective_Enddate"=D_ENDDATE,
 "SI_Start"=H_EFFECTIVE_STARTDATE,"SI_End"=H_POLICY_ENDDATE,"SI_OIC_disct_perc"=0,"SI_Limit"=P_SI_LIMIT,
 "OD_Start"=H_EFFECTIVE_STARTDATE,"OD_End"=H_POLICY_ENDDATE,"OD_OIC_disct_perc"=0,"OD_Amt"=P_OD_AMT,
 "FT_Start"=H_EFFECTIVE_STARTDATE,"FT_End"=H_POLICY_ENDDATE,"FT_OIC_disct_perc"=0,"FT_Amt"=P_FT_AMT,
 "SI_TPBI_Start"=H_EFFECTIVE_STARTDATE,"SI_TPBI_End"=D_ENDDATE,"SI_TPBI_OIC_disct_perc"=0,"SI_TPBI_Amt"=P_SI_TPBI_AMT,"SI_TPBI_Limit"=P_SI_TPBI_LIMIT,
 "SI_TPPD_Start"=H_EFFECTIVE_STARTDATE,"SI_TPPD_End"=D_ENDDATE,"SI_TPPD_OIC_disct_perc"=0,"SI_TPPD_Amt"=P_SI_TPPD_AMT,"SI_TPPD_Limit"=P_SI_TPPD_LIMIT,
 "SI_MV01_Start"=H_EFFECTIVE_STARTDATE,"SI_MV01_End"=D_ENDDATE,"SI_MV01_OIC_disct_perc"=0,"SI_MV01_Amt"=P_SI_MV01_AMT,"SI_MV01_Limit"=P_SI_MV01_LIMIT,
 "SI_MV02_Start"=H_EFFECTIVE_STARTDATE,"SI_MV02_End"=D_ENDDATE,"SI_MV02_OIC_disct_perc"=0,"SI_MV02_Amt"=P_SI_MV02_AMT,"SI_MV02_Limit"=P_SI_MV02_LIMIT,
 "SI_MV03_Start"=H_EFFECTIVE_STARTDATE,"SI_MV03_End"=D_ENDDATE,"SI_MV03_OIC_disct_perc"=0,"SI_MV03_Amt"=P_SI_MV03_AMT,"SI_MV03_Limit"=P_SI_MV03_LIMIT,
 "SI_Access_Start"=H_EFFECTIVE_STARTDATE,"SI_Access_End"=D_ENDDATE,"SI_Access_OIC_disct_perc"=0,"SI_Access_Amt"=P_SI_ACCESS_AMT,"SI_Access_Limit"=P_SI_ACCESS_LIMIT
WHERE "Policy_No"=policy_no;


END
$procedure$
