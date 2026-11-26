@id("7f3c2a10-0004-4c1e-9a11-0000000000c1")
@nodeType("SQLWork")
SELECT
    CAST(number + 1 AS UInt32)               AS `a_id`   @id("cj0a01"),
    concat('a', toString(number + 1))        AS `a_name` @id("cj0a02")
FROM numbers(3)
