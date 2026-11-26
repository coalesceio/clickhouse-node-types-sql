@id("0e1f0a00-0000-4000-8000-000000000221")
@nodeType("SQLWork")
@materializationType("view")
@tests("SELECT 1 FROM {{ this }} WHERE `cust_id` = 0")
SELECT
    `c`.`cust_id`       AS `cust_id`        @not_null,
    `c`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
