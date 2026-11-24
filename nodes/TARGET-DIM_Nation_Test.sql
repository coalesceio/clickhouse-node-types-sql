@id("d1ae3e99-9e31-46c3-b992-4ba724614854")
@nodeType("SQLDimension")
@optimize
SELECT
    generateUUIDv4()                                    AS "DIM_Nation_Test_KEY" @id("88720f") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"         @id("5550d8") @isBusinessKey,
    "n_Name"                                            AS "n_Name"              @id("ea220e") @isChangeTracking,
    "n_Regionkey"                                       AS "n_Regionkey"         @id("4d4c9e"),
    "n_Comment"                                         AS "n_Comment"           @id("bf5770"),
    "last_Modified"                                     AS "last_Modified"       @id("7a8c81"),
    1                                                   AS "SYSTEM_VERSION"      @id("09c9bf") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("78fcc5") @isSystemCurrentFlag,
    now64(6)                                            AS "SYSTEM_CREATE_DATE"  @id("39a584") @isSystemCreateDate,
    now64(6)                                            AS "SYSTEM_UPDATE_DATE"  @id("b614c2") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("d57b28") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"