@id("4d68ba6f-253c-44b8-a9a5-e77a9c3a0a79")
@nodeType("SQLWork")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `n_Comment` AS `n_Comment`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`