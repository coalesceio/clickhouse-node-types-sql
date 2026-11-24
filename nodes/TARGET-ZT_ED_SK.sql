@id("7f3c2a10-0004-4c1e-9a11-0000000000d1")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_SK_KEY`          @id("qkNOWxMT") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("qbNOWxMT") @isBusinessKey,
    `val`              AS `val`                 @id("qvNOWxMT") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("qsNOWxMT") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("qfNOWxMT") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("qcNOWxMT") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("quNOWxMT") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("qeNOWxMT") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
