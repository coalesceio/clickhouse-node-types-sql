@id("59adeb9f-f84d-4a0c-8191-90ef1860a107")
@nodeType("SQLFact")
@materializationType("view")
SELECT
     `n_Nationkey` AS `n_Nationkey` @id("f2a001"),
     `n_Name` AS `n_Name` @id("f2a002"),
     `n_Regionkey` AS `n_Regionkey` @id("f2a003")
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
