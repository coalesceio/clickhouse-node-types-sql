@id("0b42485c-d2b3-4c92-b1bb-9a3d5c6f8680")
@nodeType("SQLWork")
@description("Table desc")
@materializationType("table")
@orderBy("intHash32(`n_Nationkey`)", "n_Name", "toYYYYMM(`last_Modified`)","n_Regionkey + 1")
@primaryKey("intHash32(`n_Nationkey`)", "n_Name")
@partitionBy("toYYYYMM(`last_Modified`)")
@settings("index_granularity = 8192")
@writeMode("truncateInsert")
@tests("SELECT 1 WHERE 1 = 0", true, "Before")
@tests("SELECT 1 WHERE 1 = 0", true, "After")
@preSQL("SELECT 1")
@postSQL("SELECT 1")
-- @disableTests
SELECT
     `n_Nationkey` AS `n_Nationkey` @notNull @inHash("GH_COL", 1) @not_null @uniqueness @min_max("0", "100") @min_value("0"),
     `n_Name` AS `n_Name` @defaultValue("'<value>'") @empty @rejected_values("'UNKNOWN'", "'N/A'"),
     `n_Regionkey` AS `n_Regionkey` @description("<text>") @accepted_values("0, 1, 2") @accepted_values("3", "4") @max_value("4"),
     `n_Comment` AS `n_Comment` @notNull @defaultValue("'<value>'") @description("<text>"),
     `last_Modified` AS  `last_Modified` @freshness(1, "YEAR") @relative_time("<=", "last_Modified"),
     {{ get_hash("GH_COL") }} AS "GH_COL"
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
