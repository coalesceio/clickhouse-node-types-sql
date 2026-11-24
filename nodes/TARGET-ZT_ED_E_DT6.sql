@id("04d1ee0d-3fc5-5571-aa65-b27de3f369c7")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_DT6_KEY`          @id("kxExDT6") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bxExDT6") @isBusinessKey,
    `val`              AS `val`                 @id("vxExDT6") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sxExDT6") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fxExDT6") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cxExDT6") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uxExDT6") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("exExDT6") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
