@id("0e1f0a00-0000-4000-8000-000000000129")
@nodeType("SQLWork")
SELECT
    `c`.`segment`       AS `segment`,
    `c`.`cust_id`       AS `cust_id`,
    `c`.`balance`       AS `balance`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
ORDER BY `c`.`segment`, `c`.`balance` DESC
LIMIT 1 BY `c`.`segment`
