@id("0e1f0a00-0000-4000-8000-000000000111")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`updated_at`    AS `updated_at`,
    `r`.`region_name`   AS `region_name`,
    `r`.`valid_from`    AS `valid_from`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
ASOF LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r`
  ON `r`.`region_id` = `c`.`region_id` AND toDateTime(`c`.`updated_at`) >= `r`.`valid_from`
