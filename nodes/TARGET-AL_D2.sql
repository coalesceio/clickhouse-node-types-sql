@id("a1000000-0000-4000-8000-000000000016")
@nodeType("SQLDimension")
@tests("SELECT 1 WHERE (SELECT count() FROM {{ this }}) = 0", true, "Before")
SELECT
    generateUUIDv4() AS `AL_D2_KEY` @id("b00020") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `k`    AS `k`    @id("b00001") @isBusinessKey,
    `name` AS `name` @id("b00002") @isChangeTracking @description("tracked name"),
    `s`    AS `s2`   @id("b00004"),
    `d`    AS `d_new` @id("b00003"),
    1   AS `SYSTEM_VERSION`      @id("b00030") @isSystemVersion,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("b00031") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("b00032") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("b00033") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("b00034") @isSystemEndDate
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
