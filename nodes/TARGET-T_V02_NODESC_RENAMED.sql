@id("dbd22254-a58c-496d-958c-1e5130be8d88")
@nodeType("SQLWork")
@materializationType("view")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
