@id("7e700000-0000-4000-8000-000000000006")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@optimize
@ttl("`SYSTEM_END_DATE` + INTERVAL 1 YEAR")
@tests("SELECT 1 WHERE (SELECT count() FROM system.tables WHERE concat(char(96), database, char(96), char(46), char(96), name, char(96)) = '{{ this }}' AND position(engine_full, 'TTL') > 0) = 0", true, "After")
@tests("SELECT 1 WHERE (SELECT count() FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y') < 7", true, "After")
SELECT
    generateUUIDv4()  AS `TT_DIM2_KEY` @id("a70000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k`               AS `k`           @id("a70001") @isBusinessKey @notNull @zeroKey("999999"),
    `name`            AS `name`        @id("a70002") @isChangeTracking,
    1                 AS `SYSTEM_VERSION`      @id("a70010") @isSystemVersion,
    'Y'               AS `SYSTEM_CURRENT_FLAG` @id("a70011") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("a70008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("a70009") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("a70012") @isSystemEndDate @notNull
FROM {{ ref('TARGET', 'TT_SRC') }}
