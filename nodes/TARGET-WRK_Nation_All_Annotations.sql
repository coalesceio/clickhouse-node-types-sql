@id("f3937fff-b932-49b8-aa5e-ce2485e7369b")
@nodeType("SQLWork")
@description("Work node exercising every SQLWork annotation")
@materializationType("table")
@orderBy("intHash32(`n_Nationkey`)", "n_Name", "toYYYYMM(`last_Modified`)", "n_Regionkey + 1")
@primaryKey("intHash32(`n_Nationkey`)", "n_Name")
@partitionBy("toYYYYMM(`last_Modified`)")
@settings("index_granularity = 8192", "min_bytes_for_wide_part = 0")
@writeMode("truncateInsert")
@disableTests(false)
@tests("SELECT 1 WHERE 1 = 0", true, "Before")
@tests("SELECT 1 WHERE 1 = 0", false, "After")
@preSQL("SELECT 1")
@preSQL("SELECT 2")
@postSQL("SELECT 1")
@postSQL("SELECT 2")
SELECT
     `n_Nationkey` AS `n_Nationkey` @description("Nation key") @notNull @inHash("GH_COL", 1) @not_null @uniqueness @min_max("0", "100") @min_value("0") @max_value("100"),
     `n_Name` AS `n_Name` @description("Nation name") @notNull @defaultValue("'UNKNOWN'") @inHash("GH_COL", 2) @not_null @empty @rejected_values("'UNKNOWN'", "'N/A'"),
     `n_Regionkey` AS `n_Regionkey` @description("Region key") @defaultValue("0") @accepted_values("0, 1, 2") @accepted_values("3", "4") @min_value("0") @max_value("4"),
     `n_Comment` AS `n_Comment` @description("Free-text comment") @defaultValue("''") @rejected_values("'N/A'"),
     `last_Modified` AS `last_Modified` @description("Last modified time") @freshness(1, "YEAR") @relative_time("<=", "LOAD_TS") @min_value("'1990-01-01 00:00:00'"),
     now64(3) AS `LOAD_TS` @description("Load timestamp") @notNull @relative_time(">=", "last_Modified"),
     {{ get_hash("GH_COL") }} AS `GH_COL` @description("Hash of n_Nationkey + n_Name")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
