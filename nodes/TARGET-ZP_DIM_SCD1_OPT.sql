@id("abf13fd8-6403-43ac-b433-47ff9abcad26")
@nodeType("SQLDimension")
@partitionBy("`n_Regionkey`")
@optimize
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} FINAL GROUP BY `n_Nationkey` HAVING count() > 1", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1 SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `n_Regionkey` = {{ parameters.test_ver | default(1) }} % 2", true, "After")
SELECT
    generateUUIDv4()                AS "ZP_DIM_SCD1_OPT_KEY" @id("03bfb8") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                   AS "n_Nationkey"         @id("8f879a") @isBusinessKey,
    "n_Name"                        AS "n_Name"              @id("73f567"),
    "n_Regionkey"                   AS "n_Regionkey"         @id("40cca9"),
    "last_Modified"                 AS "last_Modified"       @id("c8143e"),
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_CREATE_DATE"  @id("ed144e") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_UPDATE_DATE"  @id("ef2a4e") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZP_SRC') }} `ZP_SRC`
