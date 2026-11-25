@id("0e1f0a00-0000-4000-8000-000000000150")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`segment`       AS `cust_id`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
