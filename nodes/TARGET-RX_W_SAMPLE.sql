@id("1c1d33ac-f455-5932-bca3-6ac4716be05d")
@nodeType("SQLWork")
@orderBy("intHash32(`n_Nationkey`)", "`n_Name`", "toYYYYMM(`L_M_1`)")
@primaryKey("intHash32(`n_Nationkey`)", "`n_Name`")
@partitionBy("toYYYYMM(`L_M_1`)")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1")  -- runs After the load (default), continueOnFailure=true (default)
@tests("SELECT 1 FROM {{ ref('SRC', 'Nation_Test') }} WHERE `n_Regionkey` IS NULL", true, "Before")  -- runs Before the load, continueOnFailure=true
@description("Table description")
@preSQL("DELETE FROM {{ this }} WHERE `L_M_1` < now() - INTERVAL 90 DAY")
@postSQL("INSERT INTO {{ ref('TARGET', 'RX_H_LOAD_LOG') }} (`table_name`, `load_ts`) VALUES ('WRK_NATION', now())")
SELECT
    `n_Nationkey`                      AS `n_Nationkey`    @notNull @not_null @uniqueness @min_value(0) @max_value(100) @accepted_values("1, 2, 3") @inHash("GH_COL1", 2),
    `n_Name`                           AS `n_Name`         @notNull @empty @accepted_values("'ALGERIA', 'ARGENTINA'") @inHash("GH_COL1", 1),
    `n_Regionkey`                      AS `n_Regionkey`    @min_max(0, 4) @notNull @defaultValue("20"),
    `n_Comment`                        AS `n_Comment`      @rejected_values("'NA'"),
    `last_Modified`                    AS `L_M_1`          @freshness(7, "DAY") @relative_time("<=", "L_M_2") @description("timestamp column"),
    `last_Modified`                    AS `L_M_2`,
    {{ get_hash('GH_COL1') }}          AS `GH_COL1`        @description("Hash Column")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
