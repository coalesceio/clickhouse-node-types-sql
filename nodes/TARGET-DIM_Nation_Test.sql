@id("5c5a1653-7084-4ade-82eb-7a3e0c0be231")
@nodeType("SQLDimension")
SELECT
    0                                        AS "DIM_Nation_Test_KEY" @id("ee53d2") @isSurrogateKey,
    "n_Nationkey"                            AS "n_Nationkey"         @id("e2850c") @isBusinessKey,
    "n_Name"                                 AS "n_Name"              @id("5f0828"),
    "n_Regionkey"                            AS "n_Regionkey"         @id("eff8df"),
    "n_Comment"                              AS "n_Comment"           @id("d0f3d5"),
    "last_Modified"                          AS "last_Modified"       @id("ffa661"),
    1                                        AS "SYSTEM_VERSION"      @id("84a9a7") @isSystemVersion,
    'Y'                                      AS "SYSTEM_CURRENT_FLAG" @id("1758f4") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_CREATE_DATE"  @id("4ac60a") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_UPDATE_DATE"  @id("047f7d") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS "SYSTEM_END_DATE"     @id("a34272") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"