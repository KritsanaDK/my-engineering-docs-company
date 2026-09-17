# [03] Attribute Coverage Spec

- **Category**: `data_dictionary`
- **Source Sheet**: `Attribute Coverage Spec`
- **Total Rows Parsed**: `11`

## Raw & Structured Data Specification

### Attribute for each Coverage Spec

| Coverage Name | Attribute Name | Attribute Code | Data Type | Description |
| --- | --- | --- | --- | --- |
| Bodily Injury & Property Damage | BI Limit Liability per Person | autoBIPDLimit.autoBILimClm | Decimal | ความเสียหายต่อชีวิต ร่างกาย หรืออนามัย  เฉพาะส่วนเกินวงเงินสูงสุดตาม พรบ.  ต่อคน |
|  | BI Limit Liability per Accident | autoBIPDLimit.autoBILimClmCov | Decimal | ความเสียหายต่อชีวิต ร่างกาย หรืออนามัย  เฉพาะส่วนเกินวงเงินสูงสุดตาม พรบ.  ต่อครั้ง |
|  | Limit of Liability of property Damage | autoBIPDLimit.autoPDLimClm | Decimal | ความรับผิดต่อบุคคลภายนอก ที่เป็น Property Damage |
| Collision | Collision Deductible | autoCollDedClmCov | Decimal | ทุนประกันสำหรับความเสียหายต่อรถยนต์ต่อครั้ง |
| Comprehensive | Comprehensive Deductible | autoCompDedClmCov | Decimal | coverage สำหรับผู้ขับขี่เมื่อเกิดการสูญเสียชีวิต อวัยวะ ทุพพลภาพ ถาวร |
| Medical Payments | Med Pay Person Limit | autoMedPayLimClmCov | Decimal | ค่ารักษาพยาบาลต่อคน |
| Uninsured Motorist | UM Limit | autoUMLimit | Decimal | ค่า Coverage ของบุคคลภายนอก สำหรับ ทุพพลภาพ ถาวร |
| Medical Payments | Rental Limit | autoRentalLimClmCov | Decimal | ค่าเช่ารถต่อวัน |
|  | Number of Days | autoRentalDays |  | จำนวนวันที่ให้เช่ารถ |
