@id("2f4ef6c0-75a2-5746-afc3-93423920a29f")
@nodeType("SQLWork")
@description("Dynamic pivot: one Map column keyed by product, so new products need no new column")
SELECT
    `s`.`region`                                            AS `region`,
    CAST(sumMap(map(`s`.`product`, `s`.`amount`)) AS Map(String, Decimal(38, 2))) AS `amount_by_product`,
    groupUniqArray(`s`.`product`)                           AS `products`
FROM {{ ref('SRC', 'sp_sales') }} `s`
GROUP BY `s`.`region`
