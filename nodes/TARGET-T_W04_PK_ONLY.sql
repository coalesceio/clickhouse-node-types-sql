@id("ea484e87-3896-4613-8f7e-b57328d2c3f8")
@nodeType("SQLWork")
@primaryKey("n_Regionkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
