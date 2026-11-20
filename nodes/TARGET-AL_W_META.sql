@id("a1000000-0000-4000-8000-000000000003")
@nodeType("SQLWork")
@description("v2 description")
@settings("index_granularity_bytes = 10485760")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} WHERE `k` > 1000", true, "After")
@tests("SELECT 1 WHERE (SELECT count() FROM {{ this }}) = 0", true, "Before")
SELECT
    `k`    AS `k`    @id("b00001"),
    `name` AS `name` @id("b00002"),
    `d`    AS `d`    @id("b00003")
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
