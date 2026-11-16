@id("5d000000-0000-4000-8000-000000000007")
@nodeType("SQLFact")
@engine("MergeTree")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` < toDateTime('{{ parameters.cutoff | default('2000-01-01 00:00:00') }}') SETTINGS final = 1", true, "After")
SELECT
    `k` AS `k` @id("r00001") @isBusinessKey,
    `name` AS `cust_name` @id("r00002"),
    CAST(`amount` AS Decimal(12, 2)) AS `amount` @id("r00004"),
    CAST(`amount` * 2 AS Decimal(12, 2)) AS `amount2` @id("r00005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("r00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("r00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'RD_SRC') }} `RD_SRC`
