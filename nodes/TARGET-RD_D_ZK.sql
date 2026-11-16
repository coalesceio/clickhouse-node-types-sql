@id("5d000000-0000-4000-8000-000000000013")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` < toDateTime('{{ parameters.cutoff | default('2000-01-01 00:00:00') }}') SETTINGS final = 1", true, "After")
SELECT
    generateUUIDv4() AS `RD_D_ZK_KEY` @id("r00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k` AS `k` @id("r00001") @isBusinessKey,
    1 AS `SYSTEM_VERSION` @id("r00006") @isSystemVersion,
    `name` AS `name` @id("r00002"),
    `region` AS `region` @id("r00003"),
    `amount` AS `amount` @id("r00004"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("r00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("r00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'RD_SRC') }} `RD_SRC`
