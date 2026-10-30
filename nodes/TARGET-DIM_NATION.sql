@id("c7688ad2-0683-42c0-b6b1-264399735a9c")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                         AS "DIM_nation_KEY"      @id("a0c09a") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n_nationkey"                            AS "n_nationkey"         @id("0baa06") @isBusinessKey,
    "n_name"                                 AS "n_name"              @id("23bbe9"),
    "n_regionkey"                            AS "n_regionkey"         @id("45d0a9"),
    "n_comment"                              AS "n_comment"           @id("60f839"),
    1                                        AS "SYSTEM_VERSION"      @id("309214") @isSystemVersion,
    'Y'                                      AS "SYSTEM_CURRENT_FLAG" @id("64ebdf") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_CREATE_DATE"  @id("55ab3f") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS "SYSTEM_UPDATE_DATE"  @id("8c7e0f") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS "SYSTEM_END_DATE"     @id("41db77") @isSystemEndDate
FROM {{ ref('SRC', 'WRK_nation') }} "WRK_nation"