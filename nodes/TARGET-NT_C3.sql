@id("9a700000-0000-4000-8000-000000000003")
@nodeType("SQLWork")
SELECT
    CAST(1 AS UInt32)     AS `lit`,
    `n_Nationkey` + 0     AS `expr`,
    concat(`n_Name`, 'x') AS `str_expr`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
