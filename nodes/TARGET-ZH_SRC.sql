@id("d1d1d1d1-0000-4000-8000-000000000001")
@nodeType("SQLWork")
SELECT
    CAST(number AS UInt32)                                                         AS `a`,
    CAST(if(number = 1, NULL, concat('x', toString(number))) AS Nullable(String)) AS `b`,
    CAST(toDate('2026-01-01') + number AS Date)                                    AS `c`
FROM numbers(3)
