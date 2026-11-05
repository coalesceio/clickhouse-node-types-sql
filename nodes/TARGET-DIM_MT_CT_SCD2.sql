@id("0524257f-b72f-479a-b255-6326ceccbfa7")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()                                    AS "DIM_Nation_CT_SCD2_KEY" @id("522e0b") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"            @id("84b95f") @isBusinessKey,
    "n_Name"                                            AS "n_Name"                 @id("0faed4") @isChangeTracking,
    "n_Regionkey"                                       AS "n_Regionkey"            @id("75993f"),
    "n_Comment"                                         AS "n_Comment"              @id("982ca2"),
    "last_Modified"                                     AS "last_Modified"          @id("43895a"),
    1                                                   AS "SYSTEM_VERSION"         @id("45cb50") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG"    @id("29f5f5") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"     @id("b488c1") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"     @id("53b236") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"        @id("2fa30b") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
