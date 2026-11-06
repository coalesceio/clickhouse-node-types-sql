@id("464f622e-1c1e-43e4-a125-8c3918cc496c")
@nodeType("SQLDimension")
@materializationType("view")
@optimize
SELECT
    generateUUIDv4()                AS "ZP_DIM_VIEW_KEY"  @id("6e3ce9") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_Nationkey"                   AS "n_Nationkey"        @id("8996e0") @isBusinessKey,
    "n_Name"                        AS "n_Name"             @id("b606d0"),
    "n_Regionkey"                   AS "n_Regionkey"        @id("ef70bb"),
    "last_Modified"                 AS "last_Modified"      @id("ab666d"),
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_CREATE_DATE" @id("a630f3") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_UPDATE_DATE" @id("355265") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZP_SRC') }} `ZP_SRC`
