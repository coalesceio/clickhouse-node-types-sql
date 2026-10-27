@id("ab837f30-21b1-4433-91ad-2af107311780")
@nodeType("SQLWork")
@orderBy("n_Nationkey", "n_Regionkey")
@primaryKey("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
