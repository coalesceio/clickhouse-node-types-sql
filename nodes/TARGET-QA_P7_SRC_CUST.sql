@id("0e1f0a00-0000-4000-8000-000000000700")
@nodeType("SQLWork")
@description("P7 source: customers, round 2")
@orderBy("`cust_id`")
SELECT
    CAST(`c1` AS UInt32) AS `cust_id`, CAST(`c2` AS Nullable(String)) AS `cust_name`, CAST(`c3` AS UInt32) AS `region_id`,
    CAST(`c4` AS String) AS `segment`, CAST(`c5` AS String) AS `city`, CAST(`c6` AS DateTime64(3)) AS `updated_at`
FROM values('c1 UInt32, c2 Nullable(String), c3 UInt32, c4 String, c5 String, c6 DateTime64(3)',
    (1, '  alice ', 1, 'RETAIL', 'Pune', '2026-11-01 10:00:00'),
    (2, 'Bob', 2, 'CORPORATE', 'Delhi', '2026-11-10 10:00:00'),
    (3, 'Cara Ltd', 3, 'SMB', 'Goa', '2026-11-01 10:00:00'),
    (4, 'Dan', 9, 'RETAIL', 'Pune', '2026-11-01 10:00:00'),
    (5, 'Eve', 1, 'SMB', 'Chennai', '2026-11-10 10:00:00'))
