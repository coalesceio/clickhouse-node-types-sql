@id("a9cc48a0-5104-4711-9886-b60c3c9ce138")
@nodeType("SQLDimension")
@mergeStrategy("lastModified")
SELECT
    generateUUIDv4()                                    AS "DIM_Nation_LM_SCD2_KEY" @id("795242") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                                       AS "n_Nationkey"            @id("63f766") @isBusinessKey,
    "n_Name"                                            AS "n_Name"                 @id("1c76ac"),
    "n_Regionkey"                                       AS "n_Regionkey"            @id("72800a"),
    "n_Comment"                                         AS "n_Comment"              @id("cedcb6"),
    "last_Modified"                                     AS "last_Modified"          @id("3a8951") @lastModifiedTracking(2),
    1                                                   AS "SYSTEM_VERSION"         @id("3cc947") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG"    @id("08c3b0") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"     @id("b8955f") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"     @id("a34fd4") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"        @id("56beb0") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
