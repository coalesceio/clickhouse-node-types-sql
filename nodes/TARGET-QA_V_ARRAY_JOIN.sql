@id("0e1f0a00-0000-4000-8000-000000000171")
@nodeType("SQLWork")
@materializationType("view")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `tag`               AS `tag`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT ARRAY JOIN ['a', 'b'] AS `tag`
