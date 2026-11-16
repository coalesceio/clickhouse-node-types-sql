@id("71dd2b3b-1aa8-480e-be36-3a85013b7496")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
SELECT
    `k`                                  AS `k`                  @id("b10001"),
    `attr`                               AS `attr`               @id("b10002"),
    CAST(now64(6) AS DateTime64(6))      AS `load_ts`            @id("b10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b10004") @isSystemCreateDate
FROM {{ ref('TARGET', 'ZA_SRC') }} `ZA_SRC`
