@id("be3edad7-1add-488d-85cc-71b509e1364e")
@nodeType("SQLWork")
@materializationType("view")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
