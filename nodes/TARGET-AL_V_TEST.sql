@id("a1000000-0000-4000-8000-000000000014")
@nodeType("SQLWork")
@materializationType("view")
@tests("SELECT 1 FROM {{ this }} WHERE `k` > 1000", true, "After")
SELECT
    `k`    AS `k`    @id("b00001"),
    `name` AS `name` @id("b00002"),
    `d`    AS `d`    @id("b00003")
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
