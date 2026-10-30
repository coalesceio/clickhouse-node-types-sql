@id("8c3a5e7d-9f1b-4d4c-8e6a-2b8c4f0d6e39")
@nodeType("SQLDimension")
@description("Geo scenario 2 - geo columns are non-tracking (updated in place), nm is the change tracking column, SCD Type 2")
@orderBy("id", "SYSTEM_VERSION")
@mergeStrategy("changeTracking")
SELECT
    generateUUIDv4()                               AS "DIM_GEO_S2_nontrack_KEY" @id("b20001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                           AS "id"                      @id("b20002") @isBusinessKey @notNull,
    "nm"                                           AS "nm"                      @id("b20003") @isChangeTracking,
    "pt"                                           AS "pt"                      @id("b20004"),
    "rg"                                           AS "rg"                      @id("b20005"),
    "ls"                                           AS "ls"                      @id("b20006"),
    "mls"                                          AS "mls"                     @id("b20007"),
    "pg"                                           AS "pg"                      @id("b20008"),
    "mpg"                                          AS "mpg"                     @id("b20009"),
    toUInt32(1)                                    AS "SYSTEM_VERSION"          @id("b20010") @isSystemVersion @notNull,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"     @id("b20011") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"      @id("b20012") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"      @id("b20013") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"    @id("b20014") @isSystemEndDate
FROM {{ ref('SRC', 'geo_src') }} "geo_src"
