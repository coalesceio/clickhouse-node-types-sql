@id("c8aa8bdc-4ae3-4765-9590-f1da3b8df95d")
@nodeType("SQLDimension")
@materializationType("view")
SELECT
    generateUUIDv4()                         AS "T_D02_DIM_VIEW_KEY"  @id("d2a001") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                            AS "n_Nationkey"         @id("d2a002") @isBusinessKey,
    "n_Name"                                 AS "n_Name"              @id("d2a003"),
    "n_Regionkey"                            AS "n_Regionkey"         @id("d2a004"),
    1                                        AS "SYSTEM_VERSION"      @id("d2a005") @isSystemVersion,
    'Y'                                      AS "SYSTEM_CURRENT_FLAG" @id("d2a006") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_CREATE_DATE"  @id("d2a007") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_UPDATE_DATE"  @id("d2a008") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS "SYSTEM_END_DATE"     @id("d2a009") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"
