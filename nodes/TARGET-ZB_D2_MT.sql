@id("1b65fb74-89e2-471e-a823-08ac4202930c")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4() AS `ZB_D2_MT_KEY` @id("c00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k`             AS `k`             @id("c00001") @isBusinessKey,
    `attr`          AS `attr`          @id("c00002") @isChangeTracking,
    `last_Modified` AS `last_Modified` @id("c00003"),
    1                                                   AS `SYSTEM_VERSION`      @id("c00010") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("c00011") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("c00012") @isSystemEndDate
FROM {{ ref('TARGET', 'ZB_SRC') }} `ZB_SRC`
