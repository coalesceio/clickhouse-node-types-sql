@id("45ef0b45-c186-5fef-b0e8-207443510de1")
@nodeType("SQLDimension")
@engine("MergeTree")
SELECT
    generateUUIDv4()   AS `ZT_ED_E_D_KEY`          @id("kEDxExD") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `id`               AS `id`                  @id("bEDxExD") @isBusinessKey,
    `val`              AS `val`                 @id("vEDxExD") @isChangeTracking,
    1                  AS `SYSTEM_VERSION`      @id("sEDxExD") @isSystemVersion,
    'Y'                AS `SYSTEM_CURRENT_FLAG` @id("fEDxExD") @isSystemCurrentFlag,
    now64(6) AS `SYSTEM_CREATE_DATE`  @id("cEDxExD") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE`  @id("uEDxExD") @isSystemUpdateDate @notNull,
    toDate('2149-06-06') AS `SYSTEM_END_DATE` @id("eEDxExD") @isSystemEndDate
FROM {{ ref('TARGET', 'ZT_ED_SRC') }}
