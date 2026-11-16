@id("460de765-eaec-4a9f-a42a-4b9b2777c45d")
@nodeType("SQLFact")
@mergeStrategy("lastModified")
SELECT
    `k`             AS `k`             @id("c00001") @isBusinessKey,
    `attr`          AS `attr`          @id("c00002"),
    `last_Modified` AS `last_Modified` @id("c00003") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZB_SRC') }} `ZB_SRC`
