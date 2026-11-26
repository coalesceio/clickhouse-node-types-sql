@id("0e1f0a00-0000-4000-8000-000000000230")
@nodeType("SQLWork")
@orderBy("`cust_id`")
@partitionBy("`segment`")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`segment`       AS `segment`,
    `c`.`balance`       AS `balance`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
