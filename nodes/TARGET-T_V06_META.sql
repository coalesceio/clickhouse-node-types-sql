@id("e6e5a644-45e2-4584-83d6-fa0ab4be167a")
@nodeType("SQLWork")
@materializationType("view")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
