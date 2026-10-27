@id("ca414c74-b15e-49aa-a2b5-6d72b888666d")
@nodeType("SQLWork")
@orderBy("n_Nationkey")
@primaryKey("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
