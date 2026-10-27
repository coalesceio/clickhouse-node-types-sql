@id("1a8b6a49-f6b5-4561-8d2d-22b48423eba8")
@nodeType("SQLFact")
@orderBy("n_Nationkey")
SELECT
     `n_Nationkey` AS `n_Nationkey` @id("f1a001"),
     `n_Name` AS `n_Name_renamed` @id("f1a002"),
     `n_Regionkey` AS `n_Regionkey` @id("f1a003"),
     `last_Modified` AS `last_Modified` @id("f1a004")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
