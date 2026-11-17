@id("7e700000-0000-4000-8000-000000000005")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@ttl("`SYSTEM_UPDATE_DATE` + INTERVAL 1 YEAR")
@tests("SELECT 1 WHERE (SELECT count() FROM system.tables WHERE concat(char(96), database, char(96), char(46), char(96), name, char(96)) = '{{ this }}' AND position(engine_full, 'TTL') > 0) = 0", true, "After")
SELECT
    generateUUIDv4()  AS `TT_DIM1_KEY` @id("d70000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k`               AS `k`           @id("d70001") @isBusinessKey @notNull @zeroKey("999999"),
    `name`            AS `name`        @id("d70002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d70008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d70009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'TT_SRC') }}
