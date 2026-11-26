@id("7f3c2a10-0004-4c1e-9a11-0000000000c3")
@nodeType("SQLWork")
SELECT
    'PROD'                                   AS `cfg_env`  @id("cj0c01"),
    CAST(1.10 AS Decimal(5, 2))              AS `cfg_rate` @id("cj0c02")
FROM numbers(1)
