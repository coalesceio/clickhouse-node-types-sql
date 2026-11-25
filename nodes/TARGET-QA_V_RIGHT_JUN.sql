@id("0e1f0a00-0000-4000-8000-000000000175")
@nodeType("SQLWork")
@materializationType("view")
@joinUseNulls
SELECT
    `c`.`cust_id`                               AS `cust_id`    @notNull,
    `c`.`cust_name`                             AS `cust_name`,
    `r`.`region_id`                             AS `region_id`,
    CAST(`r`.`region_name` AS Nullable(String)) AS `region_name`,
    [`r`.`region_id`]                           AS `region_arr`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
RIGHT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
