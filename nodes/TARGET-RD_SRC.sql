@id("5d000000-0000-4000-8000-000000000000")
@nodeType("SQLWork")
SELECT
    CAST(number AS UInt32) AS `k`,
    CAST(concat('NAME_', toString(number)) AS String) AS `name`,
    CAST(number % 2 AS UInt32) AS `region`,
    CAST(number * 10.5 AS Decimal(10, 2)) AS `amount`
FROM numbers(5)
