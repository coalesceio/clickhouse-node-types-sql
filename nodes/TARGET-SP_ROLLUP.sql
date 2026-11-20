@id("8347b990-b83f-59db-9301-17be545772a2")
@nodeType("SQLWork")
@description("Subtotals and grand total with GROUP BY ROLLUP")
SELECT
    `s`.`region`        AS `region`,
    `s`.`product`       AS `product`,
    sum(`s`.`amount`)   AS `amount`
FROM {{ ref('SRC', 'sp_sales') }} `s`
GROUP BY ROLLUP(`s`.`region`, `s`.`product`)
