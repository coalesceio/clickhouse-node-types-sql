@id("0e1f0a00-0000-4000-8000-000000000214")
@nodeType("SQLWork")
@orderBy("`cust_id`", "`segment`")
@primaryKey("`cust_id`")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
