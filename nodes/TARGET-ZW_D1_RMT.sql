@id("b16c0e51-0000-4000-8000-0000000000d1")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000001", "'N/A'")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZW_D1_RMT_KEY` = toUUID('00000000-0000-0000-0000-000000000001') SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZW_D1_RMT_KEY` != toUUID('00000000-0000-0000-0000-000000000001') SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `n_Nationkey` = -1 SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4()                     AS `ZW_D1_RMT_KEY`         @id("k00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    CAST(`n_Nationkey` AS Int32)         AS `n_Nationkey`        @id("k00001") @isBusinessKey @zeroKey("-1"),
    `n_Name`                             AS `n_Name`             @id("k00002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("k00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("k00009") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
