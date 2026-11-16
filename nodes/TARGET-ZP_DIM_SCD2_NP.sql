@id("e62eb49c-af6a-4d1d-8924-15ddd97ea54a")
@nodeType("SQLDimension")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `n_Nationkey` HAVING count() > 1 SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT count() FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `SYSTEM_CURRENT_FLAG` = 'Y'), 0)))", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT min(`SYSTEM_VERSION`) FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `SYSTEM_CURRENT_FLAG` = 'Y'), 0)))", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT max(`SYSTEM_VERSION`) FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `SYSTEM_CURRENT_FLAG` = 'Y'), 0)))", true, "After")
@tests("SELECT 1 FROM numbers(toUInt64(ifNull((SELECT max(`SYSTEM_VERSION`) FROM {{ this }} FINAL WHERE `n_Nationkey` = 1), 0)))", true, "After")
SELECT
    generateUUIDv4()                                    AS "ZP_DIM_SCD2_NP_KEY"  @id("60f648") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"         @id("629cb4") @isBusinessKey,
    "n_Name"                                            AS "n_Name"              @id("604187") @isChangeTracking,
    "n_Regionkey"                                       AS "n_Regionkey"         @id("162010") @isChangeTracking,
    "last_Modified"                                     AS "last_Modified"       @id("6ef148"),
    1                                                   AS "SYSTEM_VERSION"      @id("21f24c") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("288a68") @isSystemCurrentFlag,
    CAST(now64(6) AS DateTime64(6))                     AS "SYSTEM_CREATE_DATE"  @id("88e70b") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6))                     AS "SYSTEM_UPDATE_DATE"  @id("5bc006") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("e69519") @isSystemEndDate
FROM {{ ref('TARGET', 'ZP_SRC') }} `ZP_SRC`
