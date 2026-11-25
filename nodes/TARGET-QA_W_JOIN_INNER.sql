@id("0e1f0a00-0000-4000-8000-000000000105")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`cust_name`     AS `cust_name`,
    `r`.`region_name`   AS `region_name`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
INNER JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
