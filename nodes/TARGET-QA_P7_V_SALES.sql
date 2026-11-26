@id("0e1f0a00-0000-4000-8000-000000000708")
@nodeType("SQLWork")
@materializationType("view")
@final
@description("P7 sales view: fact with current customer and region")
SELECT
    `f`.`order_id`        AS `order_id`,
    `f`.`line_no`         AS `line_no`,
    `d`.`cust_id`         AS `cust_id`,
    `d`.`cust_name`       AS `cust_name`,
    `d`.`segment`         AS `segment`,
    `r`.`region_name`     AS `region_name`,
    `f`.`amount`          AS `amount`
FROM {{ ref('TARGET', 'QA_P7_FCT_ORDERS') }} `f`
LEFT JOIN {{ ref('TARGET', 'QA_P7_DIM_CUST') }} `d` ON `d`.`DIM_CUST_KEY` = `f`.`cust_key`
LEFT JOIN {{ ref('TARGET', 'QA_P7_DIM_REGION') }} `r` ON `r`.`region_id` = `f`.`region_id`
