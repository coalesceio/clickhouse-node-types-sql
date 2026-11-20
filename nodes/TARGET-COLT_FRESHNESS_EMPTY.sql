@id("e0f3608b-e581-5df5-a09e-c41a0fbd3c33")
@nodeType("SQLWork")
@description("@freshness on an empty table: fails")
SELECT
    CAST(now() AS DateTime)                                                                      AS `f_empty_table` @freshness(1, "DAY")
FROM numbers(5)
WHERE number > 100
