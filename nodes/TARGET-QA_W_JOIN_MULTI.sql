@id("0e1f0a00-0000-4000-8000-000000000112")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`                                                           AS `cust_id`,
    `r`.`region_name`                                                       AS `region_name`,
    `r2`.`region_name`                                                      AS `next_region_name`,
    CAST((SELECT max(`region_id`) FROM {{ ref('TARGET', 'QA_W_SRC_REGION') }}) AS UInt32) AS `max_region`,
    `c`.`balance` * 2                                                       AS `double_balance`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r2` ON `r2`.`region_id` = `c`.`region_id` + 1
WHERE `c`.`cust_id` IN (SELECT `cust_id` FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} WHERE `balance` >= 0)
