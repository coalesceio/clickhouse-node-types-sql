@id("0e1f0a00-0000-4000-8000-000000000102")
@nodeType("SQLWork")
@description("QA controllable region lookup")
SELECT
    CAST(`c1` AS UInt32)    AS `region_id`,
    CAST(`c2` AS String)    AS `region_name`,
    CAST(`c3` AS DateTime)  AS `valid_from`
FROM values('c1 UInt32, c2 String, c3 DateTime',
    (1, 'EMEA', '2026-01-01 00:00:00'),
    (2, 'APAC', '2026-01-01 00:00:00'),
    (3, 'AMER', '2026-01-01 00:00:00'),
    (4, 'NOCUST', '2026-01-01 00:00:00'))
