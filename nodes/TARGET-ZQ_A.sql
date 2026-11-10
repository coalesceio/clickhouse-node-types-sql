@id("7d2b0e51-0000-4000-8000-00000000000a")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@tests("SELECT 1 FROM {{ this }} WHERE `ZQ_A_KEY` = toUUID('00000000-0000-0000-0000-000000000000') SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZQ_A_KEY` = toUUID('00000000-0000-0000-0000-000000000000') SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4()                     AS `ZQ_A_KEY`         @id("e00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                        AS `n_Nationkey`        @id("e00001") @isBusinessKey,
    `n_Name`                             AS `n_Name`             @id("e00002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("e00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("e00009") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
