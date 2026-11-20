@id("6542e546-8e2a-4f86-adee-9aa3eae87597")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()                                    AS "DIM_Nation_Test_KEY" @id("854077") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"         @id("454046") @isBusinessKey,
    "n_Name"                                            AS "n_Name"              @id("a3f1b4"),
    "n_Regionkey"                                       AS "n_Regionkey"         @id("610cfb"),
    "n_Comment"                                         AS "n_Comment"           @id("1548cb") ,
    "last_Modified"                                     AS "last_Modified"       @id("b5d395"),
    1                                                   AS "SYSTEM_VERSION"      @id("5f5b32") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("fc47ea") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("32c3da") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("26f9e8") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("4a3275") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"