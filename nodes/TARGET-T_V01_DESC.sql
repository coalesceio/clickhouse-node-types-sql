@id("d013d49b-2f74-475d-beaa-34862610a58f")
@nodeType("SQLWork")
@materializationType("table")
@description("View description changed")
SELECT
     `n_Nationkey` AS `n_Nationkey` @description("Nation key"),
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
