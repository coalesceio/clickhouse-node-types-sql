@id("0e1f0a00-0000-4000-8000-000000000203")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`cust_name`     AS `cust_name`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
