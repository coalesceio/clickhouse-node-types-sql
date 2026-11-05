@id("a1d9cf22-49a3-4438-bc32-fc6deb6d8c04")
@nodeType("SQLWork")
SELECT
     `DIM_Nation_LM_SCD2_KEY` AS `DIM_Nation_LM_SCD2_KEY`,
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `n_Comment` AS `n_Comment`,
     `last_Modified` AS `last_Modified`,
     `SYSTEM_VERSION` AS `SYSTEM_VERSION`,
     `SYSTEM_CURRENT_FLAG` AS `SYSTEM_CURRENT_FLAG`,
     `SYSTEM_CREATE_DATE` AS `SYSTEM_CREATE_DATE`,
     `SYSTEM_UPDATE_DATE` AS `SYSTEM_UPDATE_DATE`,
     `SYSTEM_END_DATE` AS `SYSTEM_END_DATE`
FROM {{ ref('TARGET', 'DIM_RMT_LM_SCD2') }} `DIM_RMT_LM_SCD2`