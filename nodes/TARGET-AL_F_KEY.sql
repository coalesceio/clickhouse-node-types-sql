@id("a1000000-0000-4000-8000-000000000018")
@nodeType("SQLFact")
@tests("SELECT 1 WHERE (SELECT count() FROM {{ this }}) = 0", true, "Before")
SELECT
    CAST(`k` AS UInt64) AS `k` @id("b00001") @isBusinessKey,
    `name` AS `name` @id("b00002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b00032") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("b00033") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
