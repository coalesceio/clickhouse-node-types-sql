@id("4bf791c9-aa99-4b0a-b8c0-6cfab6071e1b")
@nodeType("SQLWork")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `n_Comment` AS `n_Comment`,
     `last_Modified` AS `last_Modified`,
     `SYSTEM_CREATE_DATE` AS `SYSTEM_CREATE_DATE`,
     `SYSTEM_UPDATE_DATE` AS `SYSTEM_UPDATE_DATE`
FROM {{ ref('TARGET', 'FCT_RMT_CT') }} `FCT_RMT_CT`