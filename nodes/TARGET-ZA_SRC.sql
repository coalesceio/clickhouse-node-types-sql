@id("cf8ee1c7-aed4-4160-86a3-f19e6200b2c8")
@nodeType("SQLWork")
SELECT
    CAST(if(number = 3, 2, number) AS UInt32)                                          AS `k`,
    CAST(if(number = 1, NULL, concat('v', toString(if(number = 3, 2, number)))) AS Nullable(String)) AS `attr`
FROM numbers(4)
