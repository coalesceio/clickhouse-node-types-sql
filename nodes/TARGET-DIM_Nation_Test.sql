@id("ef85305c-545c-4ed6-9443-240b3771d899")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000003", "'NA-1'", "1900-01-01 00:00:00", true)
SELECT
    generateUUIDv4()                                    AS "DIM_Nation_Test_KEY" @id("63180e") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"         @id("59494e") @isBusinessKey,
    "n_Name"                                            AS "n_Name"              @id("797487"),
    "n_Regionkey"                                       AS "n_Regionkey"         @id("2c75f9") @isChangeTracking @zeroKey("10"),
    "n_Comment"                                         AS "n_Comment"           @id("4898e6"),
    "last_Modified"                                     AS "last_Modified"       @id("907054"),
    1                                                   AS "SYSTEM_VERSION"      @id("dd69d1") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("3790e4") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("c2d651") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("0c38c8") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("4a0b14") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"