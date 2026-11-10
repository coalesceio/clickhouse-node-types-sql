@id("18185db9-04df-48bc-bec4-8fca19250c27")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
WITH `s` AS (SELECT * FROM {{ ref('TARGET', 'ZA_SRC') }})
SELECT
    `k`                                  AS `k`                  @id("b20001"),
    `attr`                               AS `attr`               @id("b20002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b20004") @isSystemCreateDate
FROM `s`
