@id("8e3e9f8b-78b5-4fcb-89b9-b52760f7b426")
@nodeType("SQLWork")
SELECT
    CAST(number + 1 AS UInt32)                       AS `customer_id` @notNull,
    CAST(arrayElement([1, 2, 9], number + 1) AS UInt32) AS `region_id` @notNull
FROM numbers(3)