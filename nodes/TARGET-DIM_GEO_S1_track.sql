@id("7b2f4d6c-8e0a-4c3b-9d5f-1a7b3e9c5d28")
@nodeType("SQLDimension")
@description("Geo scenario 1 - every geo column is a change tracking column, SCD Type 2, with zero key")
@orderBy("id", "SYSTEM_VERSION")
@mergeStrategy("changeTracking")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
SELECT
    generateUUIDv4()                               AS "DIM_GEO_S1_track_KEY" @id("a10001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                           AS "id"                   @id("a10002") @isBusinessKey @notNull,
    "nm"                                           AS "nm"                   @id("a10003"),
    "pt"                                           AS "pt"                   @id("a10004") @isChangeTracking,
    "rg"                                           AS "rg"                   @id("a10005") @isChangeTracking,
    "ls"                                           AS "ls"                   @id("a10006") @isChangeTracking,
    "mls"                                          AS "mls"                  @id("a10007") @isChangeTracking,
    "pg"                                           AS "pg"                   @id("a10008") @isChangeTracking,
    "mpg"                                          AS "mpg"                  @id("a10009") @isChangeTracking,
    toUInt32(1)                                    AS "SYSTEM_VERSION"       @id("a10010") @isSystemVersion @notNull,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"  @id("a10011") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"   @id("a10012") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"   @id("a10013") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE" @id("a10014") @isSystemEndDate
FROM {{ ref('SRC', 'geo_src') }} "geo_src"
