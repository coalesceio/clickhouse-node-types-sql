@id("75fdf296-1474-44b2-8564-df3a19f1670f")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
SELECT
    `k`                                  AS `k`                  @id("b10001"),
    `attr`                               AS `attr`               @id("b10002"),
    CAST(now64(6) AS DateTime64(6))      AS `load_ts`            @id("b10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b10004") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("b10005") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZA_SRC') }} `ZA_SRC`
