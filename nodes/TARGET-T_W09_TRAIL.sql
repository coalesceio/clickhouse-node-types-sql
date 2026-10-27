@id("ed668c26-6556-4093-b39a-981dd2760dad")
@nodeType("SQLWork")
@orderBy("n_Nationkey", "n_Regionkey")
@primaryKey("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
