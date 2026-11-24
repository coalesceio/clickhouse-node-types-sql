@id("cfebd98e-7f80-56bf-89e5-e97db476ff69")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_DT3_KEY`          @id("kxExDT3") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bxExDT3") @isBusinessKey,
    `val`              AS `val`                 @id("vxExDT3") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sxExDT3") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fxExDT3") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cxExDT3") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uxExDT3") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(3)) AS `SYSTEM_END_DATE` @id("exExDT3") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
