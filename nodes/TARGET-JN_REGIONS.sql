@id("e63a2aa5-4dd2-468a-a868-ca92fdaccddd")
@nodeType("SQLWork")
SELECT
    CAST(number + 1 AS UInt32)                               AS `region_id` @notNull,
    CAST(arrayElement(['North', 'South'], number + 1) AS String) AS `region_name` @notNull
FROM numbers(2)