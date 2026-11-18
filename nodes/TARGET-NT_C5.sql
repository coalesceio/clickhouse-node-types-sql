@id("9a700000-0000-4000-8000-000000000005")
@nodeType("SQLWork")
SELECT `n_Nationkey` AS `k`, `n_Name` AS `v` FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
UNION ALL
SELECT `n_Nationkey` AS `k`, NULL AS `v` FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
