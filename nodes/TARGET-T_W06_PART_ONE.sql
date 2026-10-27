@id("2814234c-8f14-4f34-b9a7-a7073c4cbd81")
@nodeType("SQLWork")
@partitionBy("n_Regionkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
