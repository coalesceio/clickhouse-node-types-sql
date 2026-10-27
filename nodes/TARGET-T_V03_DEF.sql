@id("dad313f1-23f5-4de9-aa50-c2307948e266")
@nodeType("SQLWork")
@materializationType("view")
@description("View whose definition changes")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
