@id("0e1f0a00-0000-4000-8000-000000000110")
@nodeType("SQLWork")
WITH `semi` AS (
    SELECT `c`.`cust_id` AS `cust_id`, 'SEMI' AS `kind`
    FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
    LEFT SEMI JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
),
`anti` AS (
    SELECT `c`.`cust_id` AS `cust_id`, 'ANTI' AS `kind`
    FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
    LEFT ANTI JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
),
`both_sets` AS (
    SELECT `cust_id`, `kind` FROM `semi`
    UNION ALL
    SELECT `cust_id`, `kind` FROM `anti`
)
SELECT
    `cust_id`   AS `cust_id`,
    `kind`      AS `kind`
FROM `both_sets`
