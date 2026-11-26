@id("0e1f0a00-0000-4000-8000-000000000237")
@nodeType("SQLWork")
@materializationType("view")
SELECT
    `u`.`cust_id`       AS `cust_id`,
    `u`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_ORD_UP_ADDCOL') }} `u`
