@id("7cf6adfe-d397-5088-8ff3-affbcbc95c03")
@nodeType("SQLWork")
@description("Top 2 sales per region (LIMIT n BY)")
SELECT
    `s`.`region`     AS `region`,
    `s`.`product`    AS `product`,
    `s`.`sale_date`  AS `sale_date`,
    `s`.`amount`     AS `amount`
FROM {{ ref('SRC', 'sp_sales') }} `s`
ORDER BY `s`.`region`, `s`.`amount` DESC, `s`.`sale_date`
LIMIT 2 BY `s`.`region`
