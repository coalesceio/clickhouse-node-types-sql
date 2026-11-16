@id("ce000000-0000-4000-8000-000000000002")
@nodeType("SQLWork")
WITH `src` AS (SELECT * FROM {{ ref('TARGET', 'CT_SRC') }}),
`regions` AS (SELECT CAST(number AS UInt32) AS `region_id`, concat('REGION_', toString(number)) AS `region_name` FROM numbers(3))
SELECT
    `src`.`cust_id`                          AS `cust_id`,
    `src`.`name`                             AS `name`,
    `src`.`amount`                           AS `amount`,
    `src`.`last_Modified`                    AS `last_Modified`,
    CAST(`regions`.`region_name` AS String)  AS `region_name`,
    `src`.`segment`                          AS `segment`
FROM `src`
LEFT JOIN `regions` ON `src`.`region` = `regions`.`region_id`
