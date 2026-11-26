@id("99160ded-ee32-59e4-976f-d0161be1ee1e")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_DT0_KEY`          @id("kxExDT0") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bxExDT0") @isBusinessKey,
    `val`              AS `val`                 @id("vxExDT0") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sxExDT0") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fxExDT0") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cxExDT0") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uxExDT0") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(0)) AS `SYSTEM_END_DATE` @id("exExDT0") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
