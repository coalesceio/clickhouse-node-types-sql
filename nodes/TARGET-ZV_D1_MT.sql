@id("a05c0e51-0000-4000-8000-0000000000c3")
@nodeType("SQLDimension")
@engine("MergeTree")
@zeroKey("00000000-0000-0000-0000-000000000001", "'NA'")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZV_D1_MT_KEY` = toUUID('00000000-0000-0000-0000-000000000000') SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZV_D1_MT_KEY` = toUUID('00000000-0000-0000-0000-000000000001') SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `ZV_D1_MT_KEY` NOT IN (toUUID('00000000-0000-0000-0000-000000000000'), toUUID('00000000-0000-0000-0000-000000000001')) AND trimRight(toString(`n_Name`), char(0)) != 'NA' SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
SELECT
    generateUUIDv4()                     AS `ZV_D1_MT_KEY`         @id("h00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                        AS `n_Nationkey`        @id("h00001") @isBusinessKey,
    `n_Name`                             AS `n_Name`             @id("h00002"),
    1                                                   AS `SYSTEM_VERSION`      @id("h00010") @isSystemVersion,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("h00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("h00009") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
