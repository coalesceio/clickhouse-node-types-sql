@id("12d2ddc3-7518-4783-94fd-273af3f6c819")
@nodeType("SQLWork")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `n_Comment` AS `n_Comment`,
     `last_Modified` AS `last_Modified`,
     `SYSTEM_CREATE_DATE` AS `SYSTEM_CREATE_DATE`,
     `SYSTEM_UPDATE_DATE` AS `SYSTEM_UPDATE_DATE`
FROM {{ ref('TARGET', 'FCT_RMT_LM') }} `FCT_RMT_LM`