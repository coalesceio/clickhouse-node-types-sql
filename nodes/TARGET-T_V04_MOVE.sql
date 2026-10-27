@id("be3edad7-1add-488d-85cc-71b509e1364e")
@nodeType("SQLWork")
@materializationType("view")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
