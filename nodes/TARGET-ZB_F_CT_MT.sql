@id("25eef856-2609-4610-8ba7-20338486817c")
@nodeType("SQLFact")
@engine("MergeTree")
@mergeStrategy("changeTracking")
SELECT
    `k`             AS `k`             @id("c00001") @isBusinessKey,
    `attr`          AS `attr`          @id("c00002"),
    `last_Modified` AS `last_Modified` @id("c00003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZB_SRC') }} `ZB_SRC`
