@id("9032b4f9-2b6c-4309-8367-f9691f13f5eb")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
SELECT
    generateUUIDv4()                                    AS "DIM_region_KEY"      @id("56ced9") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "r_regionkey"                                       AS "r_regionkey"         @id("bcde52") @isBusinessKey,
    "r_name"                                            AS "r_name"              @id("e08977"),
    "r_comment"                                         AS "r_comment"           @id("119371"),
    1                                                   AS "SYSTEM_VERSION"      @id("489853") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("35a9a1") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("df6bc4") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("71ac94") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("3b5cd6") @isSystemEndDate
FROM {{ ref('SRC', 'region') }} "region"