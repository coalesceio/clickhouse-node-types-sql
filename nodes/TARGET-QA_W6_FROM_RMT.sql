@id("0e1f0a00-0000-4000-8000-000000000601")
@nodeType("SQLWork")
@description("downstream table load reading the RMT upstream")
SELECT
    `u`.`cust_id`       AS `cust_id`,
    `u`.`city`          AS `city`,
    `u`.`load_marker`   AS `load_marker`
FROM {{ ref('TARGET', 'QA_D6_RMT_UP') }} `u`
