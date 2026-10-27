@id("ed668c26-6556-4093-b39a-981dd2760dad")
@nodeType("SQLWork")
@orderBy("n_Nationkey")
@primaryKey("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
