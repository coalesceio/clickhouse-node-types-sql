@id("b1a00001-0000-4000-8000-000000000031")
@nodeType("SQLWork")
@materializationType("view")
@description("Monthly net sales by customer region and market segment")
SELECT
     `dc`.`region_name` AS `region_name`,
     `dc`.`c_mktsegment` AS `c_mktsegment`,
     toStartOfMonth(`f`.`o_orderdate`) AS `order_month`,
     count() AS `line_count`,
     sum(`f`.`net_amount`) AS `net_sales`
FROM {{ ref('TARGET', 'FCT_ORDER_LINE') }} `f`
INNER JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc` ON `dc`.`customer_key` = `f`.`customer_key`
WHERE `f`.`o_orderstatus` != ''
GROUP BY `dc`.`region_name`, `dc`.`c_mktsegment`, toStartOfMonth(`f`.`o_orderdate`)