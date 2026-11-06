@id("51073659-502a-4b14-a188-8a401a24fbbb")
@nodeType("SQLDimension")
@partitionBy("`n_Regionkey`")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `n_Nationkey` HAVING count() > 1 SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT count() FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `SYSTEM_CURRENT_FLAG` = 'Y'), 0)))", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT min(`SYSTEM_VERSION`) FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `SYSTEM_CURRENT_FLAG` = 'Y'), 0)))", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT max(`SYSTEM_VERSION`) FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `SYSTEM_CURRENT_FLAG` = 'Y'), 0)))", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT max(`SYSTEM_VERSION`) FROM {{ this }} FINAL WHERE `n_Nationkey` = 1), 0)))", true, "After")
SELECT
    generateUUIDv4()                                    AS "ZP_DIM_SCD2_KEY"     @id("a7d0ca") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"         @id("b9bccf") @isBusinessKey,
    "n_Name"                                            AS "n_Name"              @id("b2a763") @isChangeTracking,
    "n_Regionkey"                                       AS "n_Regionkey"         @id("2b5fe1") @isChangeTracking,
    "last_Modified"                                     AS "last_Modified"       @id("4b9512"),
    1                                                   AS "SYSTEM_VERSION"      @id("15e6b9") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("57b41e") @isSystemCurrentFlag,
    CAST(now64(6) AS DateTime64(6))                     AS "SYSTEM_CREATE_DATE"  @id("2fac28") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6))                     AS "SYSTEM_UPDATE_DATE"  @id("5543db") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("db1e23") @isSystemEndDate
FROM {{ ref('TARGET', 'ZP_SRC') }} `ZP_SRC`
