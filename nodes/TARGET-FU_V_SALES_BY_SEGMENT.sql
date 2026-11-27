@id("df551a19-3cf5-4d45-8184-607f3ea5699f")
@nodeType("SQLWork")
@materializationType("view")
@final
@joinUseNulls
@description("Monthly sales by customer segment and region")
SELECT
    CAST(`dc`.`segment` AS Nullable(String))      AS `segment`,
    CAST(`dn`.`region_name` AS Nullable(String))  AS `region_name`,
    toStartOfMonth(`f`.`order_date`)  AS `order_month`,
    count()                           AS `order_count`,
    sum(`f`.`amount`)                 AS `net_sales`
FROM {{ ref('TARGET', 'FU_FCT_ORDERS') }} `f`
LEFT JOIN {{ ref('TARGET', 'FU_DIM_CUSTOMER') }} `dc` ON `dc`.`FU_DIM_CUSTOMER_KEY` = `f`.`customer_key`
LEFT JOIN {{ ref('TARGET', 'FU_DIM_NATION') }} `dn` ON `dn`.`FU_DIM_NATION_KEY` = `f`.`nation_key`
GROUP BY `dc`.`segment`, `dn`.`region_name`, toStartOfMonth(`f`.`order_date`)
