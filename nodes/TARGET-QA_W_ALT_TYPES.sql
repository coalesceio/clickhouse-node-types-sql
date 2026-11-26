@id("0e1f0a00-0000-4000-8000-000000000206")
@nodeType("SQLWork")
SELECT
    CAST(`c1` AS UInt32)                AS `id`,
    CAST(`c2` AS UInt64)                AS `u32_to_u64`,
    CAST(`c3` AS UInt32)                AS `str_to_u32`,
    CAST(`c4` AS Nullable(UInt32))      AS `str_to_nullable_u32`,
    CAST(`c2` AS String)                AS `u32_to_str`,
    CAST(`c5` AS DateTime64(3))         AS `date_to_dt64`,
    CAST(`c6` AS Decimal(18, 4))        AS `dec_scale_up`,
    CAST(`c7` AS LowCardinality(String)) AS `str_to_lc`,
    CAST(`c8` AS Nullable(UInt32))      AS `nullable_to_notnull_def`    @notNull @defaultValue("0"),
    CAST(`c2` AS Nullable(UInt32))      AS `notnull_to_nullable`,
    CAST(`c9` AS Decimal(10, 2))        AS `float_to_dec`
FROM values('c1 UInt32, c2 UInt32, c3 String, c4 Nullable(String), c5 Date, c6 Decimal(12, 2), c7 String, c8 Nullable(UInt32), c9 Float64',
    (1, 10, '10', 'ALGERIA', '2026-11-01', 12.34, 'A', NULL, 1.25),
    (2, 20, '20', '42', '2026-11-02', 5.5, 'B', 7, 2.5))
