@id("61d8c251-df3d-5768-88b7-6fe0bf598382")
@nodeType("SQLWork")
@description("Point-in-time price for each sale (ASOF JOIN)")
SELECT
    `s`.`product`       AS `product`,
    `s`.`sale_date`     AS `sale_date`,
    `s`.`amount`        AS `amount`,
    `p`.`price`         AS `price_at_sale`,
    `p`.`valid_from`    AS `price_valid_from`
FROM {{ ref('SRC', 'sp_sales') }} `s`
ASOF LEFT JOIN {{ ref('SRC', 'sp_prices') }} `p`
  ON `p`.`product` = `s`.`product` AND toDateTime(`s`.`sale_date`) >= `p`.`valid_from`
WHERE `s`.`region` = 'EU'
