@id("0e1f0a00-0000-4000-8000-000000000220")
@nodeType("SQLWork")
@materializationType("view")
@description("view desc after")
SELECT
    `c`.`cust_id`       AS `cust_id`        @description("col desc before"),
    `c`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
