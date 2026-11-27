@id("0e1f0a00-0000-4000-8000-0000000003b3")
@nodeType("SQLWork")
@description("QA uniqueness with NULLs: n2 has two NULLs, n1 one NULL, s has two empty strings")
SELECT
    CAST(`c1` AS UInt32)            AS `id`  @uniqueness,
    CAST(`c2` AS Nullable(UInt32))  AS `n1`  @uniqueness,
    CAST(`c3` AS Nullable(String))  AS `n2`  @uniqueness,
    CAST(`c4` AS String)            AS `s`   @uniqueness
FROM values('c1 UInt32, c2 Nullable(UInt32), c3 Nullable(String), c4 String',
    (1, 10,   'x',  'p'),
    (2, NULL, NULL, ''),
    (3, 30,   NULL, ''),
    (4, 40,   'y',  'q'))
