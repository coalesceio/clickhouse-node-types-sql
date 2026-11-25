@id("0e1f0a00-0000-4000-8000-000000000173")
@nodeType("SQLWork")
@materializationType("view")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `r`.`region_name`   AS `region_name`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
SETTINGS join_use_nulls = 1
