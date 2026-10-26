@id("37fb7653-cf01-4c32-9e71-dd204de605c5")
@nodeType("SQLWork")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `n_Comment` AS `n_Comment`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('TARGET', 'Nation_Test') }} `Nation_Test`