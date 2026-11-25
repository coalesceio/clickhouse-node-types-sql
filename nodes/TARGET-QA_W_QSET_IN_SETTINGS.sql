@id("0e1f0a00-0000-4000-8000-000000000143")
@nodeType("SQLWork")
@settings("max_threads = 4")
SELECT `c`.`cust_id` AS `cust_id` FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
