@id("dd4c2456-b154-4183-bc09-3f7d7034dd21")
@nodeType("SQLWork")
@orderBy("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
