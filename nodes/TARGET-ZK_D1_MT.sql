@id("6c1a0e51-0000-4000-8000-000000000001")
@nodeType("SQLDimension")
@engine("MergeTree")
@zeroKey("00000000-0000-0000-0000-000000000000", "'N/A'")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_D1_MT_KEY` = toUUID('00000000-0000-0000-0000-000000000000') SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZK_D1_MT_KEY` = toUUID('00000000-0000-0000-0000-000000000000') AND trimRight(toString(`n_Name`), char(0)) = 'N/A' SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4()                     AS `ZK_D1_MT_KEY`         @id("d00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                        AS `n_Nationkey`        @id("d00001") @isBusinessKey,
    `n_Name`                             AS `n_Name`             @id("d00002"),
    `n_Regionkey`                        AS `n_Regionkey`        @id("d00003"),
    `last_Modified`                      AS `last_Modified`      @id("d00004"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("d00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("d00009") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
