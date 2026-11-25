@id("0e1f0a00-0000-4000-8000-000000000113")
@nodeType("SQLWork")
SELECT
    `cust_id`           AS `cust_id`,
    `region_id`         AS `region_id`,
    `region_name`       AS `region_name`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
INNER JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` USING (`region_id`)
