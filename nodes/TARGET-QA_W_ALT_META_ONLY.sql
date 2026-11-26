@id("0e1f0a00-0000-4000-8000-000000000222")
@nodeType("SQLWork")
@writeMode("append")
@preSQL("SELECT 1")
@tests("SELECT 1 FROM {{ this }} WHERE `cust_id` = 0")
SELECT
    `c`.`cust_id`       AS `cust_id`        @uniqueness,
    `c`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
