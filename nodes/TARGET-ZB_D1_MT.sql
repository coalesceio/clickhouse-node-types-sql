@id("ba04511f-e90f-4716-9f98-a2bd0220f2d3")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4() AS `ZB_D1_MT_KEY` @id("c00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k`             AS `k`             @id("c00001") @isBusinessKey,
    `attr`          AS `attr`          @id("c00002"),
    `last_Modified` AS `last_Modified` @id("c00003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZB_SRC') }} `ZB_SRC`
