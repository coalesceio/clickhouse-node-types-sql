@id("5556325a-b631-585b-b253-5ae6675e13ad")
@nodeType("SQLWork")
@description("SCD Type 1 as a Work node: append changed rows, Post-SQL keeps the latest row per key")
@writeMode("append")
@orderBy("`emp_id`")
@postSQL("DELETE FROM {{ this }} WHERE (`emp_id`, `update_date`) NOT IN (SELECT `emp_id`, max(`update_date`) FROM {{ this }} GROUP BY `emp_id`) SETTINGS transform_null_in = 1")
WITH `cur` AS (
    SELECT `emp_id`, `name`, `manager_id`, 1 AS `row_exists` FROM {{ this }}
)
SELECT
    `s`.`emp_id`                       AS `emp_id`,
    `s`.`name`                         AS `name`,
    `s`.`manager_id`                   AS `manager_id`,
    CAST(now64(6) AS DateTime64(6))    AS `update_date`
FROM {{ ref('SRC', 'sp_org') }} `s`
LEFT JOIN `cur` `t` ON `t`.`emp_id` = `s`.`emp_id`
WHERE ifNull(`t`.`row_exists`, 0) = 0
   OR isDistinctFrom(`s`.`name`, `t`.`name`)
   OR isDistinctFrom(`s`.`manager_id`, `t`.`manager_id`)
