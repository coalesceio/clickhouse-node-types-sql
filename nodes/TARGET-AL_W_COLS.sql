@id("a1000000-0000-4000-8000-000000000002")
@nodeType("SQLWork")
@tests("SELECT 1 WHERE (SELECT countIf(`name2` LIKE 'NAME_%') FROM {{ this }}) = 0", true, "Before")
@tests("SELECT 1 WHERE (SELECT count() FROM {{ this }}) = 0", true, "Before")
SELECT
    CAST(`k` AS UInt64) AS `k`         @id("b00001"),
    `name`              AS `name2`     @id("b00002"),
    `d`                 AS `d`         @id("b00003") @defaultValue("now()"),
    toNullable(`s`)     AS `s`         @id("b00004"),
    'x'                 AS `cmt`       @id("b00006") @description("new comment"),
    `k` * 10            AS `added`     @id("b00007"),
    'y'                 AS `added_def` @id("b00008") @defaultValue("'y'")
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
