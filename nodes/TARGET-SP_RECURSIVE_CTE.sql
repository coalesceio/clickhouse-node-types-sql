@id("4f06555c-8721-594d-b366-a6e895aea5ed")
@nodeType("SQLWork")
@description("Hierarchy with WITH RECURSIVE: every employee with level and path")
WITH RECURSIVE `tree` AS (
    SELECT `emp_id`, `name`, 1 AS `lvl`, CAST(`name` AS String) AS `path`
    FROM {{ ref('SRC', 'sp_org') }}
    WHERE `manager_id` IS NULL
    UNION ALL
    SELECT `o`.`emp_id`, `o`.`name`, `t`.`lvl` + 1, concat(`t`.`path`, ' > ', `o`.`name`)
    FROM {{ ref('SRC', 'sp_org') }} `o`
    INNER JOIN `tree` `t` ON `o`.`manager_id` = `t`.`emp_id`
)
SELECT
    `emp_id`   AS `emp_id`,
    `name`     AS `name`,
    `lvl`      AS `lvl`,
    `path`     AS `path`
FROM `tree`
