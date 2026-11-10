@id("5d000000-0000-4000-8000-000000000001")
@nodeType("SQLWork")
SELECT
    `k` AS `k`,
    `name` AS `name`,
    `region` AS `region`
FROM {{ ref('TARGET', 'RD_SRC') }} `RD_SRC`
