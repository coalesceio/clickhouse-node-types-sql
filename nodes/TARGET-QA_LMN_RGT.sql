@id("0e1f0a00-0000-4000-8000-0000000003a1")
@nodeType("SQLWork")
@description("QA lastModified NULL test right side of LEFT JOIN: not Nullable")
SELECT
    CAST(`c1` AS UInt32)          AS `cust_id`,
    CAST(`c2` AS DateTime64(3))   AS `rgt_lm`,
    CAST(`c3` AS UInt32)          AS `rgt_ver`
FROM values('c1 UInt32, c2 DateTime64(3), c3 UInt32',
    (1, '2026-11-03 10:00:00', 7),
    (2, '2026-11-01 10:00:00', 5),
    (3, '2026-11-02 10:00:00', 6))
