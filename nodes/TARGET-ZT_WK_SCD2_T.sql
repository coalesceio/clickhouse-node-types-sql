@id("e6b05513-7cb1-5b23-ad30-32a763fa2975")
@nodeType("SQLWork")
@description("SCD Type 2 as a Work node: append new versions and expired copies, Post-SQL keeps the latest copy per key and version")
@writeMode("append")
@orderBy("`emp_id`", "`version`")
@postSQL("DELETE FROM {{ this }} WHERE (`emp_id`, `version`, `update_date`) NOT IN (SELECT `emp_id`, `version`, max(`update_date`) FROM {{ this }} GROUP BY `emp_id`, `version`) SETTINGS transform_null_in = 1")
WITH `cur` AS (
    SELECT `emp_id`, `name`, `manager_id`, `version`, `valid_from`, 1 AS `row_exists`
    FROM {{ this }}
    WHERE `is_current` = 1
),
`chg` AS (
    SELECT
        `s`.`emp_id`                      AS `emp_id`,
        `s`.`name`                        AS `name`,
        `s`.`manager_id`                  AS `manager_id`,
        ifNull(`t`.`row_exists`, 0)       AS `ex`,
        `t`.`version`                     AS `old_version`,
        `t`.`name`                        AS `old_name`,
        `t`.`manager_id`                  AS `old_manager_id`,
        `t`.`valid_from`                  AS `old_valid_from`
    FROM {{ ref('SRC', 'sp_org') }} `s`
    LEFT JOIN `cur` `t` ON `t`.`emp_id` = `s`.`emp_id`
    WHERE ifNull(`t`.`row_exists`, 0) = 0
       OR isDistinctFrom(`s`.`name`, `t`.`name`)
       OR isDistinctFrom(`s`.`manager_id`, `t`.`manager_id`)
),
`out_rows` AS (
    SELECT `emp_id`, `name`, `manager_id`, if(`ex` = 1, `old_version` + 1, 1) AS `version`, 1 AS `is_current`,
           now64(6) AS `valid_from`, toDateTime64('2299-12-31 23:59:59.999999', 6) AS `valid_to`
    FROM `chg`
    UNION ALL
    SELECT `emp_id`, `old_name`, `old_manager_id`, `old_version`, 0,
           `old_valid_from`, now64(6) - toIntervalMicrosecond(1)
    FROM `chg` WHERE `ex` = 1
)
SELECT
    CAST(`emp_id` AS UInt32)                 AS `emp_id`     @notNull,
    CAST(`name` AS String)                   AS `name`,
    CAST(`manager_id` AS Nullable(UInt32))   AS `manager_id`,
    CAST(`version` AS UInt32)                AS `version`    @notNull,
    CAST(`is_current` AS UInt8)              AS `is_current` @notNull,
    CAST(`valid_from` AS DateTime64(6))      AS `valid_from`,
    CAST(`valid_to` AS DateTime64(6))        AS `valid_to`   @notNull,
    CAST(now64(6) AS DateTime64(6))          AS `update_date`
FROM `out_rows`
