@id("b8538d37-da20-51c2-8b64-204c2f29b579")
@nodeType("SQLWork")
@orderBy("`n_Nationkey`", "`n_Name`", "toYYYYMM(`last_Modified`)")
@primaryKey("`n_Nationkey`", "`n_Name`")
@partitionBy("toYYYYMM(`last_Modified`)")
@settings("index_granularity = 8192", "min_bytes_for_wide_part = 0")
@querySettings("max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000", "max_threads = 8", "max_block_size = 65536")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1", false, "After")  -- runs After the load, continueOnFailure=false
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Comment` HAVING count() > 1", true, "Before")  -- runs Before the load, continueOnFailure=true
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Comment` HAVING count() > 1", false)  -- runs After the load (default), continueOnFailure=false
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Comment` HAVING count() > 1")  -- runs After the load (default), continueOnFailure=true (default)
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Name` HAVING count() > 1")
@tests("SELECT ""n_Nationkey"" FROM {{ ref('SRC', 'Nation_Test') }} GROUP BY ""n_Nationkey"" HAVING count() > 1", false, "Before")
@preSQL(' SELECT 1 FROM {{ this }} GROUP BY "n_Name" HAVING count() > 1 ')
@preSQL("DELETE FROM {{ this }} WHERE `last_Modified` < today() - 90")
@postSQL("INSERT INTO {{ ref('TARGET', 'RX_H_LOAD_LOG') }} (`table_name`, `load_ts`) VALUES ('WRK_NATION', now())")
SELECT
    `n_Nationkey`   AS `n_Nationkey`   @id("110e75"),
    `n_Name`        AS `n_Name`,
    `n_Comment`     AS `n_Comment`,
    `last_Modified` AS `last_Modified`,
    CAST(`n_Regionkey` AS UInt32) AS `dv_num` @defaultValue("20"),
    CAST(`n_Comment` AS String) AS `dv_str` @defaultValue("'NA'"),
    generateUUIDv4() AS `dv_uuid` @defaultValue("generateUUIDv4()")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
