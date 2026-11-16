@id("db40148b-86e1-41e0-b81d-faed5541795b")
@nodeType("SQLDimension")
@partitionBy("`n_Regionkey`")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} FINAL GROUP BY `n_Nationkey` HAVING count() > 1", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1 SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL SETTINGS do_not_merge_across_partitions_select_final = 1", true, "After")
@tests("SELECT DISTINCT _partition_id FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `n_Regionkey` = {{ parameters.test_ver | default(1) }} % 2", true, "After")
SELECT
    generateUUIDv4()                AS "ZP_DIM_SCD1_KEY"    @id("3863ad") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                   AS "n_Nationkey"        @id("2b1b1a") @isBusinessKey,
    "n_Name"                        AS "n_Name"             @id("861cd7"),
    "n_Regionkey"                   AS "n_Regionkey"        @id("30e08c"),
    "last_Modified"                 AS "last_Modified"      @id("569d08"),
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_CREATE_DATE" @id("f637ea") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_UPDATE_DATE" @id("13661d") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZP_SRC') }} `ZP_SRC`
