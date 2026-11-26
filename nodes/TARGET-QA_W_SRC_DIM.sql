@id("0e1f0a00-0000-4000-8000-000000000300")
@nodeType("SQLWork")
@description("QA controllable dimension source, data set 4")
SELECT
    CAST(`c1` AS UInt32)                AS `cust_id`,
    CAST(`c2` AS Nullable(String))      AS `cust_name`,
    CAST(`c3` AS String)                AS `city`,
    CAST(`c4` AS String)                AS `tier`,
    CAST(`c5` AS DateTime64(3))         AS `updated_at`,
    CAST(`c6` AS Nullable(UInt32))      AS `alt_key`,
    CAST(`c7` AS FixedString(2))        AS `code`
FROM values('c1 UInt32, c2 Nullable(String), c3 String, c4 String, c5 DateTime64(3), c6 Nullable(UInt32), c7 FixedString(2)',
    (1, 'Alice', 'Pune', 'GOLD', '2026-11-06 10:00:00', 101, 'AB'),
    (2, NULL, 'Mumbai', 'GOLD', '2026-11-01 10:00:00', 102, 'CD'),
    (3, 'Cara', 'Delhi', 'BRONZE', '2026-10-01 10:00:00', NULL, 'EF'),
    (5, 'Eve', 'Chennai', 'SILVER', '2026-11-05 10:00:00', 105, 'IJ'))
