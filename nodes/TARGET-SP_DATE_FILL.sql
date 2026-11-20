@id("a6ff1ca4-369a-5b76-a425-25539450bc61")
@nodeType("SQLWork")
@description("Daily totals with missing days filled in (ORDER BY ... WITH FILL)")
SELECT
    `s`.`sale_date`            AS `sale_date`,
    sum(`s`.`amount`)          AS `amount`
FROM {{ ref('SRC', 'sp_sales') }} `s`
WHERE `s`.`region` = 'EU' AND `s`.`product` = 'A'
GROUP BY `s`.`sale_date`
ORDER BY `sale_date` WITH FILL STEP 1
