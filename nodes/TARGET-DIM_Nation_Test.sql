@id("591745d7-c000-4a93-b19b-327eb6f9fd70")
@nodeType("SQLDimension")
@orderBy("n_Nationkey", "SYSTEM_VERSION")
@mergeStrategy("lastModified")
SELECT
    generateUUIDv4()                         AS "DIM_Nation_Test_KEY" @id("f8e055") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                            AS "n_Nationkey"         @id("4fdd08") @isBusinessKey,
    "n_Name"                                 AS "n_Name"              @id("1dcbf7"),
    "n_Regionkey"                            AS "n_Regionkey"         @id("5db1aa"),
    "n_Comment"                              AS "n_Comment"           @id("e5f61a"),
    "last_Modified"                          AS "last_Modified"       @id("15ef53") @lastModifiedTracking(2),
    1                                        AS "SYSTEM_VERSION"      @id("cdab35") @isSystemVersion,
    'Y'                                      AS "SYSTEM_CURRENT_FLAG" @id("e5e916") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_CREATE_DATE"  @id("2538b2") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_UPDATE_DATE"  @id("6b90e8") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS "SYSTEM_END_DATE"     @id("d9a32f") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"