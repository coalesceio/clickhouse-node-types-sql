@id("d81a6a13-bb08-4be0-85de-25a87a38220e")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4() AS `ZB_D1_RMT_KEY` @id("c00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k`             AS `k`             @id("c00001") @isBusinessKey,
    `attr`          AS `attr`          @id("c00002"),
    `last_Modified` AS `last_Modified` @id("c00003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZB_SRC') }} `ZB_SRC`
