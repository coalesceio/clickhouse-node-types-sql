@id("0e1f0a00-0000-4000-8000-000000000118")
@nodeType("SQLWork")
WITH `u` AS (
    SELECT `cust_id` AS `id`, `segment` AS `label` FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }}
    UNION ALL
    SELECT `region_id` AS `id`, `region_name` AS `label` FROM {{ ref('TARGET', 'QA_W_SRC_REGION') }}
)
SELECT
    `id`        AS `id`,
    `label`     AS `label`
FROM `u`
