@id("9d4b6f8e-0a2c-4e5d-9f7b-3c9d5a1e7f40")
@nodeType("SQLDimension")
@description("Geo scenario 3 - Point column pt is the business key, nm is the change tracking column, SCD Type 2")
@orderBy("pt", "SYSTEM_VERSION")
@mergeStrategy("changeTracking")
SELECT
    generateUUIDv4()                               AS "DIM_GEO_S3_bk_KEY"    @id("c30001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "pt"                                           AS "pt"                   @id("c30002") @isBusinessKey @notNull,
    "id"                                           AS "id"                   @id("c30003"),
    "nm"                                           AS "nm"                   @id("c30004") @isChangeTracking,
    "pg"                                           AS "pg"                   @id("c30005"),
    toUInt32(1)                                    AS "SYSTEM_VERSION"       @id("c30006") @isSystemVersion @notNull,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"  @id("c30007") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"   @id("c30008") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"   @id("c30009") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE" @id("c30010") @isSystemEndDate
FROM {{ ref('SRC', 'geo_src') }} "geo_src"
