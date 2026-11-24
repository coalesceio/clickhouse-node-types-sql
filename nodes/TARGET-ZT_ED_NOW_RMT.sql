@id("509f3a4e-8bfb-58e1-8eaf-bfc295ca958f")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_NOW_RMT_KEY`          @id("kOWxRMT") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bOWxRMT") @isBusinessKey,
    `val`              AS `val`                 @id("vOWxRMT") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sOWxRMT") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fOWxRMT") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cOWxRMT") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uOWxRMT") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("eOWxRMT") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
