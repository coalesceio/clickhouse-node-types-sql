@id("9f4c0e51-0000-4000-8000-0000000000b2")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000001", "'NA'")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZM_D2_RMT_KEY` = toUUID('00000000-0000-0000-0000-000000000000') AND trimRight(toString(`n_Name`), char(0)) = 'NA' SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZM_D2_RMT_KEY` = toUUID('00000000-0000-0000-0000-000000000001') AND trimRight(toString(`n_Name`), char(0)) = 'NA' SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZM_D2_RMT_KEY` NOT IN (toUUID('00000000-0000-0000-0000-000000000000'), toUUID('00000000-0000-0000-0000-000000000001')) AND trimRight(toString(`n_Name`), char(0)) != 'NA' SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZM_D2_RMT_KEY` IN (toUUID('00000000-0000-0000-0000-000000000000'), toUUID('00000000-0000-0000-0000-000000000001')) AND trimRight(toString(`n_Name`), char(0)) != 'NA' SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4()                     AS `ZM_D2_RMT_KEY`         @id("g00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                        AS `n_Nationkey`        @id("g00001") @isBusinessKey,
    `n_Name`                             AS `n_Name`             @id("g00002") @isChangeTracking,
    1                                                   AS `SYSTEM_VERSION`      @id("g00010") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("g00011") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("g00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("g00009") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("g00012") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
