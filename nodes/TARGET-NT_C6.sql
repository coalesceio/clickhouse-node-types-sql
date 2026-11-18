@id("9a700000-0000-4000-8000-000000000006")
@nodeType("SQLWork")
SELECT
    `n_Nationkey` AS `n_Nationkey` @notNull,
    `n_Comment`   AS `n_Comment`   @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
