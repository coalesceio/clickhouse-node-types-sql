@id("163934c3-dd57-5260-a62d-5157f9320212")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_DT_KEY`          @id("kDxExDT") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bDxExDT") @isBusinessKey,
    `val`              AS `val`                 @id("vDxExDT") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sDxExDT") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fDxExDT") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cDxExDT") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uDxExDT") @isSystemUpdateDate @notNull,
    toDateTime(4294967295) AS `SYSTEM_END_DATE` @id("eDxExDT") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
