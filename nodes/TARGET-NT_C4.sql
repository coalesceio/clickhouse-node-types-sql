@id("9a700000-0000-4000-8000-000000000004")
@nodeType("SQLWork")
WITH u AS (
    SELECT `n_Nationkey` AS `k`, `n_Name` AS `v` FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
    UNION ALL
    SELECT `n_Nationkey` AS `k`, NULL AS `v` FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
)
SELECT `k` AS `k`, `v` AS `v` FROM u
