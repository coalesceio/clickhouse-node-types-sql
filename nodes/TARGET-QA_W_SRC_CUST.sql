@id("0e1f0a00-0000-4000-8000-000000000101")
@nodeType("SQLWork")
@description("QA controllable customer source")
@orderBy("`cust_id`")
SELECT
    CAST(`c1` AS UInt32)              AS `cust_id`,
    CAST(`c2` AS Nullable(String))    AS `cust_name`,
    CAST(`c3` AS Nullable(UInt32))    AS `region_id`,
    CAST(`c4` AS Decimal(12, 2))      AS `balance`,
    CAST(`c5` AS DateTime64(3))       AS `updated_at`,
    CAST(`c6` AS String)              AS `segment`
FROM values('c1 UInt32, c2 Nullable(String), c3 Nullable(UInt32), c4 Decimal(12, 2), c5 DateTime64(3), c6 String',
    (1, 'Alice', 1, 100.50, '2026-11-20 10:00:00', 'RETAIL'),
    (2, 'Bob', 2, -20.00, '2026-11-21 10:00:00', 'CORPORATE'),
    (3, NULL, 99, 0, '2026-11-22 10:00:00', 'RETAIL'),
    (4, 'Dave', NULL, 5000, '2026-11-23 10:00:00', 'SMB'),
    (5, '  ', 3, 12.34, '2026-11-24 10:00:00', ''))
