@id("e11962aa-8dd7-58e9-b25a-983ec21681d1")
@nodeType("SQLWork")
SELECT
    CAST(number + 1 AS UInt32)                  AS `id`  @id("ed0001"),
    concat('v', toString(number))               AS `val` @id("ed0002")
FROM numbers(3)
