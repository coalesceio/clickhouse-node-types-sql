@id("0e1f0a00-0000-4000-8000-000000000121")
@nodeType("SQLWork")
SELECT `c`.`region_id` AS `region_id` FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c` WHERE `c`.`region_id` IS NOT NULL
INTERSECT DISTINCT
SELECT `r`.`region_id` FROM {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r`
