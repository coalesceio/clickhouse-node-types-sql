@id("7e700000-0000-4000-8000-000000000011")
@nodeType("SQLDimension")
@description("Annotation retention test v2 (clone and swap, package engine)")
@mergeStrategy("changeTracking")
@partitionBy("toYYYYMM(`SYSTEM_CREATE_DATE`)")
@settings("index_granularity = 4096", "min_bytes_for_wide_part = 0")
@querySettings("max_block_size = 4096")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", false)
@preSQL("SELECT 1")
@postSQL("SELECT 2")
@tests("SELECT 1 FROM {{ this }} FINAL GROUP BY `k`, `SYSTEM_VERSION` HAVING count() > 1", true, "After")
SELECT
    generateUUIDv4()                         AS `DIM_ANNOT_KEY`       @id("e80001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("surrogate key"),
    `k`                                      AS `k`                   @id("e80002") @isBusinessKey @notNull @zeroKey("999999") @description("business key") @not_null,
    `name`                                   AS `name`                @id("e80003") @isChangeTracking @notNull @defaultValue("'UNKNOWN'") @inHash("GH_DIM", 1) @empty,
    `s`                                      AS `s`                   @id("e80004") @defaultValue("'n/a'") @inHash("GH_DIM", 2) @description("plain attribute"),
    `d`                                      AS `d`                   @id("e80005") @notNull @min_value("toDateTime('1970-01-01 00:00:00')"),
    {{ get_hash('GH_DIM', 'SHA256') }}       AS `GH_DIM`              @id("e80006") @description("hash of name and s"),
    1                                        AS `SYSTEM_VERSION`      @id("e80010") @isSystemVersion @notNull,
    'Y'                                      AS `SYSTEM_CURRENT_FLAG` @id("e80011") @isSystemCurrentFlag @accepted_values("'Y', 'N'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE`  @id("e80012") @isSystemCreateDate @notNull,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE`  @id("e80013") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("e80014") @isSystemEndDate @notNull
FROM {{ ref('TARGET', 'TT_SRC') }} `TT_SRC`
