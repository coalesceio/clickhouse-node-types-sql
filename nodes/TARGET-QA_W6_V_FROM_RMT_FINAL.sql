@id("0e1f0a00-0000-4000-8000-000000000603")
@nodeType("SQLWork")
@materializationType("view")
@final
SELECT
    `u`.`cust_id`       AS `cust_id`,
    `u`.`load_marker`   AS `load_marker`
FROM {{ ref('TARGET', 'QA_D6_RMT_UP') }} `u`
