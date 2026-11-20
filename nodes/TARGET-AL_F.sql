@id("a1000000-0000-4000-8000-000000000017")
@nodeType("SQLFact")
@mergeStrategy("lastModified")
@settings("index_granularity = 4096")
@tests("SELECT 1 WHERE (SELECT count() FROM {{ this }}) = 0", true, "Before")
SELECT
    `k`    AS `k`    @id("b00001") @isBusinessKey,
    `name` AS `name` @id("b00002"),
    `d`    AS `d`    @id("b00003") @lastModifiedTracking,
    `k` + 100 AS `x` @id("b00010"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b00032") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("b00033") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
