@id("63998130-952f-4a74-adc3-abb1deb937d0")
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