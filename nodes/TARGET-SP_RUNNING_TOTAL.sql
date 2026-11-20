@id("0001c744-86cf-5a2c-98bd-feb04351c5e5")
@nodeType("SQLWork")
@description("Running total, 3-row moving average and rank per region")
SELECT
    `s`.`region`                                                                                              AS `region`,
    `s`.`sale_date`                                                                                           AS `sale_date`,
    `s`.`amount`                                                                                              AS `amount`,
    sum(`s`.`amount`) OVER (PARTITION BY `s`.`region` ORDER BY `s`.`sale_date`, `s`.`product` ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS `running_total`,
    avg(`s`.`amount`) OVER (PARTITION BY `s`.`region` ORDER BY `s`.`sale_date`, `s`.`product` ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)  AS `moving_avg_3`,
    dense_rank() OVER (PARTITION BY `s`.`region` ORDER BY `s`.`amount` DESC)                                  AS `amount_rank`
FROM {{ ref('SRC', 'sp_sales') }} `s`
