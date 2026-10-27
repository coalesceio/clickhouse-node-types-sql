@id("cce6d364-5834-4733-9e8a-fdbcfa4f6320")
@nodeType("SQLWork")
@orderBy("n_Nationkey", "n_Name")
@primaryKey("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
