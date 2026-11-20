@id("2e627deb-058c-5c90-aa09-268728942651")
@nodeType("SQLWork")
@description("Median, p90 and approximate distinct count per region")
SELECT
    `s`.`region`                              AS `region`,
    quantile(0.5)(`s`.`amount`)               AS `median_amount`,
    quantile(0.9)(`s`.`amount`)               AS `p90_amount`,
    uniq(`s`.`product`)                       AS `approx_products`,
    groupArray(3)(`s`.`product`)              AS `sample_products`
FROM {{ ref('SRC', 'sp_sales') }} `s`
GROUP BY `s`.`region`
