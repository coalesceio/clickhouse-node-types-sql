@id("6cb0dd4c-6341-5bbe-b7a7-861f9ad4f964")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_D32_KEY`          @id("kxExD32") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bxExD32") @isBusinessKey,
    `val`              AS `val`                 @id("vxExD32") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sxExD32") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fxExD32") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cxExD32") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uxExD32") @isSystemUpdateDate @notNull,
    CAST('2299-12-31' AS Date32) AS `SYSTEM_END_DATE` @id("exExD32") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
