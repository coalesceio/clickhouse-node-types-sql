@id("0e1f0a00-0000-4000-8000-000000000145")
@nodeType("SQLWork")
@writeMode("append")
@tests("SELECT 1 FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} WHERE `cust_name` IS NULL", false, "Before")
SELECT `c`.`cust_id` AS `cust_id` FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
