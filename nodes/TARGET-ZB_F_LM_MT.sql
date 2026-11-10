@id("1959a949-0cf8-4327-990f-88a5370394b3")
@nodeType("SQLFact")
@engine("MergeTree")
@mergeStrategy("lastModified")
SELECT
    `k`             AS `k`             @id("c00001") @isBusinessKey,
    `attr`          AS `attr`          @id("c00002"),
    `last_Modified` AS `last_Modified` @id("c00003") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZB_SRC') }} `ZB_SRC`
