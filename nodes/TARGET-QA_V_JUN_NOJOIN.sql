@id("0e1f0a00-0000-4000-8000-000000000174")
@nodeType("SQLWork")
@materializationType("view")
@joinUseNulls
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
