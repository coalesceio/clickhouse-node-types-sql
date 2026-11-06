@id("a902815e-4b82-4108-9765-a696a73704d0")
@nodeType("SQLDimension")
@partitionBy("`n_Nationkey` % 2")
@optimize
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1 SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `n_Regionkey` = {{ parameters.test_ver | default(1) }} % 2", true, "After")
SELECT
    generateUUIDv4()                AS "ZP_DIM_STABLE_KEY"  @id("6e3ce9") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                   AS "n_Nationkey"        @id("8996e0") @isBusinessKey,
    "n_Name"                        AS "n_Name"             @id("b606d0"),
    "n_Regionkey"                   AS "n_Regionkey"        @id("ef70bb"),
    "last_Modified"                 AS "last_Modified"      @id("ab666d"),
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_CREATE_DATE" @id("a630f3") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_UPDATE_DATE" @id("355265") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZP_SRC') }} `ZP_SRC`
