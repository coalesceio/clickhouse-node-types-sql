@id("ba2e3379-a5ce-4c23-be38-d3b158516c12")
@nodeType("SQLDimension")
@preSQL("SELECT count() FROM {{ this }} FINAL")
@postSQL("SELECT count() FROM {{ this }}")
@tests("SELECT 1 FROM {{ this }} WHERE `n_Nationkey` IS NULL", true, "Before")
@tests("SELECT `n_Nationkey` FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `n_Nationkey` HAVING count() > 1", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `n_Nationkey` HAVING count() > 1 SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4()                                    AS "DIM_RMT_TESTS_SCD2_KEY" @id("618b1f") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @not_null @uniqueness,
    "n_Nationkey"                                       AS "n_Nationkey"            @id("c7da07") @isBusinessKey @not_null,
    "n_Name"                                            AS "n_Name"                 @id("65fd86") @isChangeTracking @not_null @empty,
    "n_Regionkey"                                       AS "n_Regionkey"            @id("a49e9f") @min_max(0, 4),
    "n_Comment"                                         AS "n_Comment"              @id("dcc0f9"),
    "last_Modified"                                     AS "last_Modified"          @id("219eb6"),
    1                                                   AS "SYSTEM_VERSION"         @id("df5f8e") @isSystemVersion @min_value(1),
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG"    @id("4816c0") @isSystemCurrentFlag @accepted_values("'Y', 'N'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"     @id("bdea2b") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"     @id("1a164d") @isSystemUpdateDate @notNull @freshness(1, "DAY"),
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"        @id("bb241c") @isSystemEndDate @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
