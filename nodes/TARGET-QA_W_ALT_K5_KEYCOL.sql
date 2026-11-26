@id("0e1f0a00-0000-4000-8000-000000000212")
@nodeType("SQLWork")
@orderBy("`cust_id`", "`seg`")
@primaryKey("`cust_id`")
SELECT
    `c`.`cust_id`       AS `cust_id`        @id("k5a001"),
    `c`.`segment`       AS `seg`            @id("k5a002"),
    `c`.`balance`       AS `balance`        @id("k5a003")
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
