@id("0e1f0a00-0000-4000-8000-0000000003b0")
@nodeType("SQLWork")
@writeMode("apend")
@description("QA bad writeMode on Work (typo of append)")
SELECT CAST(`c1` AS UInt32) AS `id`, CAST(`c2` AS String) AS `name`
FROM values('c1 UInt32, c2 String', (1, 'a'), (2, 'b'))
