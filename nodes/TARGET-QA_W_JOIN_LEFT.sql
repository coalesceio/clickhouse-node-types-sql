@id("0e1f0a00-0000-4000-8000-000000000104")
@nodeType("SQLWork")
@description("QA LEFT JOIN null handling")
SELECT
    `c`.`cust_id`                                   AS `cust_id`,
    `c`.`region_id`                                 AS `region_id`,
    `r`.`region_name`                               AS `region_name`,
    `r`.`region_name`                               AS `region_name_def`    @defaultValue("'UNKNOWN'"),
    CAST(`r`.`region_name` AS Nullable(String))     AS `region_name_null`,
    coalesce(`r`.`region_name`, 'UNKNOWN')          AS `region_name_clean`,
    `r`.`region_id`                                 AS `r_region_id`,
    `r`.`valid_from`                                AS `r_valid_from`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
