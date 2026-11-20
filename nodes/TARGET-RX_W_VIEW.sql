@id("c8d07dda-0e12-5cf9-9f10-b56a8fced70d")
@nodeType("SQLWork")
@materializationType("view")
@description("Monthly net sales by customer region and market segment")
SELECT
    `dc`.`region_name`                AS `region_name`,
    `dc`.`c_mktsegment`               AS `c_mktsegment`,
    toStartOfMonth(`f`.`o_orderdate`) AS `order_month`,
    count()                           AS `line_count`,
    sum(`f`.`net_amount`)             AS `net_sales`
FROM {{ ref('TARGET', 'RX_F_LOOKUP') }} `f`
INNER JOIN {{ ref('TARGET', 'RX_H_DIM_CUSTOMER') }} `dc` ON `dc`.`customer_key` = `f`.`customer_key`
GROUP BY `dc`.`region_name`, `dc`.`c_mktsegment`, toStartOfMonth(`f`.`o_orderdate`)
