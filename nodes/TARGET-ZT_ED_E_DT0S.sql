@id("7f3c2a10-0004-4c1e-9a11-0000000000d0")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_DT0S_KEY`          @id("zkxExDT0") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("zbxExDT0") @isBusinessKey,
    `val`              AS `val`                 @id("zvxExDT0") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("zsxExDT0") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("zfxExDT0") @isSystemCurrentFlag,
    now64(0) AS `SYSTEM_CREATE_DATE`  @id("zcxExDT0") @isSystemCreateDate,
    now64(0) AS `SYSTEM_UPDATE_DATE`  @id("zuxExDT0") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(0)) AS `SYSTEM_END_DATE` @id("zexExDT0") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
