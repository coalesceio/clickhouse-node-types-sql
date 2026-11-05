@id("ea421f75-18bf-49ab-a9f0-9ffe0b1d5f46")
@nodeType("SQLWork")
SELECT
     `DIM_RMT_TESTS_SCD2_KEY` AS `DIM_RMT_TESTS_SCD2_KEY`,
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
FROM {{ ref('TARGET', 'DIM_RMT_TESTS_SCD2') }} `DIM_RMT_TESTS_SCD2`