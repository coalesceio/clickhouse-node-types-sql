@id("8e3c0e51-0000-4000-8000-0000000000a2")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@tests("SELECT 1 FROM {{ this }} WHERE `ZR_D2_KEY` = toUUID('00000000-0000-0000-0000-000000000000') SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZR_D2_KEY` = toUUID('00000000-0000-0000-0000-000000000000') SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4()                     AS `ZR_D2_KEY`         @id("f00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                        AS `n_Nationkey`        @id("f00001") @isBusinessKey,
    `n_Name`                             AS `n_Name`             @id("f00002") @isChangeTracking,
    1                                                   AS `SYSTEM_VERSION`      @id("f00010") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("f00011") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("f00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("f00009") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("f00012") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
