@id("0e1f0a00-0000-4000-8000-000000000127")
@nodeType("SQLWork")
@disableTests
@tests("SELECT 1", false, "Before")
SELECT
    `c`.`cust_id`       AS `cust_id`    @not_null @accepted_values("999"),
    `c`.`cust_name`     AS `cust_name`  @not_null
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
