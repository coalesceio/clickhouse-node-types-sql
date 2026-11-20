@id("96943c49-4ed6-552f-afcd-cf287ccf5373")
@nodeType("SQLWork")
@writeMode("append")
@description("Table description")
SELECT DISTINCT
    `n_Nationkey`                      AS `n_Nationkey`,
    `n_Name`                           AS `n_Name`,
    `n_Regionkey`                      AS `n_Regionkey`,
    `last_Modified`                    AS `L_M`            @freshness(7, "DAY")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
