@id("ab837f30-21b1-4433-91ad-2af107311780")
@nodeType("SQLWork")
@orderBy("n_Nationkey", "n_Regionkey", "c_new")
@primaryKey("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`,
     `n_Regionkey` * 10 AS `c_new`,
     `n_Name` AS `c_new2`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
