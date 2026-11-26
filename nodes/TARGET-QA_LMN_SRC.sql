@id("0e1f0a00-0000-4000-8000-0000000003a0")
@nodeType("SQLWork")
@description("QA lastModified NULL test source: lm is Nullable")
SELECT
    CAST(`c1` AS UInt32)                       AS `cust_id`,
    CAST(`c2` AS String)                       AS `city`,
    CAST(`c3` AS Nullable(DateTime64(3)))      AS `lm`
FROM values('c1 UInt32, c2 String, c3 Nullable(DateTime64(3))',
    (1, 'Pune2',   '2026-11-03 10:00:00'),
    (2, 'Mumbai2', NULL),
    (3, 'Delhi2',  '2026-11-01 10:00:00'),
    (4, 'Chennai2', '2026-11-01 10:00:00'))
