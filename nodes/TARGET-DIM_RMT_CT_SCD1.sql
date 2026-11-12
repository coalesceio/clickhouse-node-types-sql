@id("ef85305c-545c-4ed6-9443-240b3771d899")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@optimize
SELECT
    generateUUIDv4()                                    AS "DIM_Nation_Test_KEY" @id("63180e") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"         @id("59494e") @isBusinessKey @zeroKey(-1),
    "n_Name"                                            AS "n_Name"              @id("797487"),
    "n_Regionkey"                                       AS "n_Regionkey"         @id("2c75f9") @zeroKey("10"),
    "n_Comment"                                         AS "n_Comment"           @id("4898e6"),
    "last_Modified"                                     AS "last_Modified"       @id("907054"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("c2d651") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("0c38c8") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"