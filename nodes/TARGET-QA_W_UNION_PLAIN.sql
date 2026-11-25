@id("0e1f0a00-0000-4000-8000-000000000144")
@nodeType("SQLWork")
SELECT `c`.`segment` AS `segment` FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
UNION
SELECT `r`.`region_name` AS `segment` FROM {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r`
