@id("9a700000-0000-4000-8000-000000000001")
@nodeType("SQLWork")
@orderBy("`n_Nationkey`")
SELECT
    `n_Nationkey` AS `n_Nationkey`,
    `n_Name`      AS `n_Name`,
    `n_Comment`   AS `n_Comment`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
