@id("a1000000-0000-4000-8000-000000000015")
@nodeType("SQLWork")
@materializationType("view")
SELECT
    `k`    AS `k`    @id("b00001"),
    `name` AS `name` @id("b00002"),
    `d`    AS `d`    @id("b00003")
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
