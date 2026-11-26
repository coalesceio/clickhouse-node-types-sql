@id("0e1f0a00-0000-4000-8000-000000000400")
@nodeType("SQLWork")
@description("QA controllable fact source, data set 2")
SELECT
    CAST(`c1` AS UInt32)             AS `order_id`,
    CAST(`c2` AS UInt8)              AS `line_no`,
    CAST(`c3` AS UInt32)             AS `cust_id`,
    CAST(`c4` AS Nullable(UInt32))   AS `qty`,
    CAST(`c5` AS Decimal(12, 2))     AS `amount`,
    CAST(`c6` AS String)             AS `status`,
    CAST(`c7` AS DateTime64(3))      AS `updated_at`
FROM values('c1 UInt32, c2 UInt8, c3 UInt32, c4 Nullable(UInt32), c5 Decimal(12, 2), c6 String, c7 DateTime64(3)',
    (100, 1, 1, 2, 20.00, 'SHIPPED', '2026-11-05 10:00:00'),
    (100, 2, 1, 4, 5.50, 'OPEN', '2026-11-01 10:00:00'),
    (101, 1, 2, 1, 0, 'OPEN', '2026-11-05 10:00:00'),
    (103, 1, 5, 7, 70, 'OPEN', '2026-11-05 10:00:00'))
