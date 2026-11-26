@id("0e1f0a00-0000-4000-8000-000000000207")
@nodeType("SQLWork")
SELECT
    CAST(`c1` AS UInt32)                AS `id`,
    CAST(`c2` AS String)                AS `str_bad_to_u32`,
    CAST(`c3` AS Nullable(UInt32))      AS `nullable_to_notnull_nodef` @notNull @defaultValue("0")
FROM values('c1 UInt32, c2 String, c3 Nullable(UInt32)', (1, 'n/a', NULL), (2, '5', 3))
