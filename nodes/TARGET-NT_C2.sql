@id("9a700000-0000-4000-8000-000000000002")
@nodeType("SQLWork")
SELECT
    `a`.`n_Nationkey` AS `n_Nationkey`,
    `b`.`n_Name`      AS `b_Name`
FROM {{ ref('SRC', 'Nation_Test') }} `a`
LEFT JOIN {{ ref('SRC', 'Nation_Test') }} `b` ON `a`.`n_Nationkey` = `b`.`n_Regionkey`
