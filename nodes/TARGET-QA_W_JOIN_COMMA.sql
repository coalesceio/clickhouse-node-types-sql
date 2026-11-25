@id("0e1f0a00-0000-4000-8000-000000000109")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `r`.`region_name`   AS `region_name`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`, {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r`
WHERE `r`.`region_id` = `c`.`region_id`
