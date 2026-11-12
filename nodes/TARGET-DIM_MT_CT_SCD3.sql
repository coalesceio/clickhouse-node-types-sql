@id("7b2468c1-95fa-4132-bc4a-94b07b95d15c")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                                    AS "DIM_MT_CT_SCD3_KEY"     @id("40aaae") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "DIM_Nation_CT_SCD2_KEY"                            AS "DIM_Nation_CT_SCD2_KEY" @id("db5ed9"),
    "n_Nationkey"                                       AS "n_Nationkey"            @id("887a5d"),
    "n_Name"                                            AS "n_Name"                 @id("39cef6"),
    "n_Regionkey"                                       AS "n_Regionkey"            @id("67a7e4"),
    "n_Comment"                                         AS "n_Comment"              @id("5e4cb8"),
    "last_Modified"                                     AS "last_Modified"          @id("dda5c3"),
    "SYSTEM_VERSION"                                    AS "SYSTEM_VERSION"         @id("941e74"),
    "SYSTEM_CURRENT_FLAG"                               AS "SYSTEM_CURRENT_FLAG"    @id("5526c8"),
    "SYSTEM_CREATE_DATE"                                AS "SYSTEM_CREATE_DATE"     @id("6d1ab9"),
    "SYSTEM_UPDATE_DATE"                                AS "SYSTEM_UPDATE_DATE"     @id("1023fd"),
    "SYSTEM_END_DATE"                                   AS "SYSTEM_END_DATE"        @id("a5e803"),
    1                                                   AS "SYSTEM_VERSION"         @id("e9d32f") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG"    @id("decae9") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"     @id("4fe51d") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"     @id("ffd082") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"        @id("372bd1") @isSystemEndDate
FROM {{ ref('TARGET', 'DIM_MT_CT_SCD2') }} "DIM_MT_CT_SCD2"