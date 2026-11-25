@id("0e1f0a00-0000-4000-8000-000000000115")
@nodeType("SQLWork")
SELECT
    `c`.`segment`                       AS `segment`,
    `c`.`region_id`                     AS `region_id`,
    sum(`c`.`balance`)                  AS `sum_balance`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
GROUP BY ROLLUP(`c`.`segment`, `c`.`region_id`)
