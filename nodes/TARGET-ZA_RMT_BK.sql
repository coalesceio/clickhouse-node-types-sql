@id("4bd5bfc6-dd52-44fa-a331-36a90435ea79")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
SELECT
    `k`                                  AS `k`                  @id("b10001") @isBusinessKey,
    `attr`                               AS `attr`               @id("b10002"),
    CAST(now64(6) AS DateTime64(6))      AS `load_ts`            @id("b10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b10004") @isSystemCreateDate
FROM {{ ref('TARGET', 'ZA_SRC') }} `ZA_SRC`
