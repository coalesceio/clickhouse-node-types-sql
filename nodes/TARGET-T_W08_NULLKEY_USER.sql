@id("561c9661-f526-43d1-8c07-18f7f11576b6")
@nodeType("SQLWork")
@orderBy("n_Nationkey")
@settings("allow_nullable_key = 0")
SELECT
     toInt64(`n_Nationkey`) AS `n_Nationkey` @notNull,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
