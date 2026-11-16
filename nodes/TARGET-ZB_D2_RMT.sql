@id("f9bf711b-3a02-4d7e-b28c-6046d993c0bf")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4() AS `ZB_D2_RMT_KEY` @id("c00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k`             AS `k`             @id("c00001") @isBusinessKey,
    `attr`          AS `attr`          @id("c00002") @isChangeTracking,
    `last_Modified` AS `last_Modified` @id("c00003"),
    1                                                   AS `SYSTEM_VERSION`      @id("c00010") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("c00011") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("c00012") @isSystemEndDate
FROM {{ ref('TARGET', 'ZB_SRC') }} `ZB_SRC`
