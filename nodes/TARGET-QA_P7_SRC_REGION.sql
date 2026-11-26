@id("0e1f0a00-0000-4000-8000-000000000701")
@nodeType("SQLWork")
@description("P7 source: regions, round 2")
SELECT CAST(`c1` AS UInt32) AS `region_id`, CAST(`c2` AS String) AS `region_name`
FROM values('c1 UInt32, c2 String', (1, 'EMEA'), (2, 'APAC-East'), (3, 'AMER'))
