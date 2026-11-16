@id("665a682e-f2d5-4c2e-8bd9-79143388dde4")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
@engine("MergeTree")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
SELECT
    `k`                                  AS `k`                  @id("b10001"),
    `attr`                               AS `attr`               @id("b10002"),
    CAST(now64(6) AS DateTime64(6))      AS `load_ts`            @id("b10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b10004") @isSystemCreateDate
FROM {{ ref('TARGET', 'ZA_SRC') }} `ZA_SRC`
