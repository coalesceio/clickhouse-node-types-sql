@id("ddd298ac-1c44-5061-8019-27f07e0592a2")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_NOW_MT_KEY`          @id("kNOWxMT") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bNOWxMT") @isBusinessKey,
    `val`              AS `val`                 @id("vNOWxMT") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sNOWxMT") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fNOWxMT") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cNOWxMT") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uNOWxMT") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("eNOWxMT") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
