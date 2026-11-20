@id("73991a85-efb3-5f67-bf02-7b291fca86ac")
@nodeType("SQLWork")
@description("GROUPING SETS: totals by region and by product in one query")
SELECT
    `s`.`region`        AS `region`,
    `s`.`product`       AS `product`,
    sum(`s`.`amount`)   AS `amount`
FROM {{ ref('SRC', 'sp_sales') }} `s`
GROUP BY GROUPING SETS ((`s`.`region`), (`s`.`product`))
