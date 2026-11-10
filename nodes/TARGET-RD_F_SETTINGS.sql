@id("5d000000-0000-4000-8000-000000000014")
@nodeType("SQLFact")
@engine("MergeTree")
@settings("min_bytes_for_wide_part = 0")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
SELECT
    `k` AS `k` @id("r00001") @isBusinessKey,
    `name` AS `name` @id("r00002"),
    `region` AS `region` @id("r00003"),
    `amount` AS `amount` @id("r00004"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("r00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("r00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'RD_SRC') }} `RD_SRC`
