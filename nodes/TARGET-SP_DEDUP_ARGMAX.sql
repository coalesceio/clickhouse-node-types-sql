@id("d3e76803-8eae-5591-9b06-bda64a198800")
@nodeType("SQLWork")
@description("Latest value per key with argMax (no window)")
SELECT
    `s`.`region`                           AS `region`,
    `s`.`product`                          AS `product`,
    max(`s`.`sale_date`)                   AS `last_sale_date`,
    argMax(`s`.`amount`, `s`.`sale_date`)  AS `last_amount`
FROM {{ ref('SRC', 'sp_sales') }} `s`
GROUP BY `s`.`region`, `s`.`product`
