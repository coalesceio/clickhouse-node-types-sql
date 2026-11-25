@id("0e1f0a00-0000-4000-8000-000000000172")
@nodeType("SQLWork")
@materializationType("view")
WITH `j` AS (
    SELECT `c`.`cust_id` AS `cust_id`, `r`.`region_name` AS `region_name`
    FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
    LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
)
SELECT
    `cust_id`       AS `cust_id`,
    `region_name`   AS `region_name`
FROM `j`
