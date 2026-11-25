@id("0e1f0a00-0000-4000-8000-000000000117")
@nodeType("SQLWork")
SELECT DISTINCT
    `c`.`segment`       AS `segment`,
    `c`.`region_id`     AS `region_id`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
