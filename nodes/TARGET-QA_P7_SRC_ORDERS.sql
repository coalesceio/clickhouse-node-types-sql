@id("0e1f0a00-0000-4000-8000-000000000702")
@nodeType("SQLWork")
@description("P7 source: order lines, round 2")
SELECT
    CAST(`c1` AS UInt32) AS `order_id`, CAST(`c2` AS UInt8) AS `line_no`, CAST(`c3` AS UInt32) AS `cust_id`,
    CAST(`c4` AS UInt32) AS `qty`, CAST(`c5` AS Decimal(12, 2)) AS `amount`, CAST(`c6` AS DateTime64(3)) AS `order_ts`
FROM values('c1 UInt32, c2 UInt8, c3 UInt32, c4 UInt32, c5 Decimal(12, 2), c6 DateTime64(3)',
    (500, 1, 1, 2, 25.00, '2026-11-02 09:00:00'),
    (500, 2, 1, 1, 5.50, '2026-11-02 09:00:00'),
    (501, 1, 2, 3, 30.00, '2026-11-03 09:00:00'),
    (501, 1, 2, 3, 30.00, '2026-11-03 09:00:00'),
    (503, 1, 4, 4, 40.00, '2026-10-28 09:00:00'),
    (504, 1, 5, 2, 18.00, '2026-11-11 09:00:00'),
    (505, 1, 99, 1, 7.00, '2026-11-11 09:00:00'))
