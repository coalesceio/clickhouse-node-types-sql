@id("0b42485c-d2b3-4c92-b1bb-9a3d5c6f8680")
@nodeType("SQLWork")
@description("Table desc")
@orderBy("intHash32(`n_Nationkey`)", "n_Name", "toYYYYMM(`last_Modified`)","n_Regionkey + 1")
@primaryKey("intHash32(`n_Nationkey`)", "n_Name")
SELECT
     `n_Nationkey` AS `n_Nationkey` @notNull @inHash("GH_COL", 1),
     `n_Name` AS `n_Name` @defaultValue("'<value>'"),
     `n_Regionkey` AS `n_Regionkey` @description("<text>"),
     `n_Comment` AS `n_Comment` @notNull @defaultValue("'<value>'") @description("<text>"),
     `last_Modified` AS  `last_Modified`,
     {{ get_hash("GH_COL") }} AS "GH_COL"
FROM {{ ref('TARGET', 'Nation_Test') }} `Nation_Test`