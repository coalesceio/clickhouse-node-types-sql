@id("f52b11a7-4462-5197-9b83-0890a5012fd2")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_DT9_KEY`          @id("kxExDT9") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bxExDT9") @isBusinessKey,
    `val`              AS `val`                 @id("vxExDT9") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sxExDT9") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fxExDT9") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cxExDT9") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uxExDT9") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(9)) AS `SYSTEM_END_DATE` @id("exExDT9") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
