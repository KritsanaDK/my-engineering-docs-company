-- Read-only. Compulsory policies whose data fails OIC's mandatory-field rules and must be fixed by hand
-- (code will not alter or default them: fix/fx-02-fiber-policy holds them back instead).
-- Run on Prod by someone with access; fix the source data, then resubmit to CMI.
select "Car_Act_No", partner_code,
       case when char_length("Car_Comp_Code") > 5 then 'vehicleTypeCode too long: '||"Car_Comp_Code" end as vehicle_type,
       case when coalesce("Car_license_provice",'') in ('','0') then 'province empty' end as province,
       case when coalesce(trim("Car_license_no"),'') = '' then 'plate empty' end as plate,
       case when coalesce(trim("Car_serial_no"),'') = '' then 'chassis empty' end as chassis
from insurverse."Policy_Car_Act_Discount_Premium"
where "Policy_Status" = 'ACT'
  and (char_length("Car_Comp_Code") > 5 or coalesce("Car_license_provice",'') in ('','0')
       or coalesce(trim("Car_license_no"),'') = '' or coalesce(trim("Car_serial_no"),'') = '')
order by "Car_Act_No";
