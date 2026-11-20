@id("90d53194-e10f-574b-9d14-58b81953aa7f")
@nodeType("SQLWork")
@description("Pivot: one column per product with sumIf (ClickHouse has no PIVOT keyword)")
SELECT
    `s`.`region`                                  AS `region`,
    toStartOfMonth(`s`.`sale_date`)               AS `sale_month`,
    sumIf(`s`.`amount`, `s`.`product` = 'A')      AS `amount_a`,
    sumIf(`s`.`amount`, `s`.`product` = 'B')      AS `amount_b`,
    sumIf(`s`.`amount`, `s`.`product` = 'C')      AS `amount_c`,
    sum(`s`.`amount`)                             AS `amount_total`
FROM {{ ref('SRC', 'sp_sales') }} `s`
GROUP BY `s`.`region`, toStartOfMonth(`s`.`sale_date`)
