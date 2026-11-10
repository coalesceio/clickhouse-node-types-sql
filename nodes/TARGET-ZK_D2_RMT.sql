@id("6c1a0e51-0000-4000-8000-000000000003")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'N/A'")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_D2_RMT_KEY` = toUUID('00000000-0000-0000-0000-000000000000') SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_D2_RMT_KEY` = toUUID('00000000-0000-0000-0000-000000000000') AND trimRight(toString(`n_Name`), char(0)) = 'N/A' SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4()                     AS `ZK_D2_RMT_KEY`         @id("d00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                        AS `n_Nationkey`        @id("d00001") @isBusinessKey,
    `n_Name`                             AS `n_Name`             @id("d00002") @isChangeTracking,
    `n_Regionkey`                        AS `n_Regionkey`        @id("d00003"),
    `last_Modified`                      AS `last_Modified`      @id("d00004"),
    1                                                   AS `SYSTEM_VERSION`      @id("d00010") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("d00011") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d00009") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("d00012") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
