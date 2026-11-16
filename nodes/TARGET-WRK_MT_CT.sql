@id("81cce864-c9b8-4585-bda1-a45e34ca088f")
@nodeType("SQLWork")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `n_Comment` AS `n_Comment`,
     `last_Modified` AS `last_Modified`,
     `SYSTEM_CREATE_DATE` AS `SYSTEM_CREATE_DATE`,
     `SYSTEM_UPDATE_DATE` AS `SYSTEM_UPDATE_DATE`
FROM {{ ref('TARGET', 'FCT_MT_CT') }} `FCT_MT_CT`