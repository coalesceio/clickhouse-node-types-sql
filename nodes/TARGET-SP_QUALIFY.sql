@id("f6f331af-ce16-579f-a050-a68f06cbc36d")
@nodeType("SQLWork")
@description("Latest sale per region and product with QUALIFY row_number()")
SELECT
    `s`.`region`     AS `region`,
    `s`.`product`    AS `product`,
    `s`.`sale_date`  AS `sale_date`,
    `s`.`amount`     AS `amount`
FROM {{ ref('SRC', 'sp_sales') }} `s`
QUALIFY row_number() OVER (PARTITION BY `s`.`region`, `s`.`product` ORDER BY `s`.`sale_date` DESC) = 1
