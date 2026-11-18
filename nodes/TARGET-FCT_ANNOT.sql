@id("7e700000-0000-4000-8000-000000000010")
@nodeType("SQLFact")
@description("Annotation retention test: every table annotation")
@engine("MergeTree")
@mergeStrategy("lastModified")
@writeMode("append")
@partitionBy("toYYYYMM(`d`)")
@orderBy("`k`", "`d`")
@primaryKey("`k`")
@settings("index_granularity = 4096", "merge_with_ttl_timeout = 3600", "min_bytes_for_wide_part = 0")
@ttl("`d` + INTERVAL 10 YEAR")
@querySettings("max_threads = 2", "max_block_size = 4096")
@optimize
@preSQL("SELECT 1")
@postSQL("SELECT 2")
@tests("SELECT 1 FROM {{ this }} GROUP BY `k` HAVING count() > 1", true, "After")
SELECT
    `k`                                   AS `k`                  @id("e70001") @isBusinessKey @notNull @description("business key") @not_null @uniqueness,
    `name`                                AS `name`               @id("e70002") @notNull @defaultValue("'UNKNOWN'") @description("name column") @inHash("GH_ANNOT", 1) @empty,
    `d`                                   AS `d`                  @id("e70003") @lastModifiedTracking @notNull @description("last modified date"),
    `s`                                   AS `s`                  @id("e70004") @defaultValue("'n/a'") @inHash("GH_ANNOT", 2),
    toUInt8(`k` % 3)                      AS `status`             @id("e70005") @notNull @defaultValue("0") @accepted_values("0, 1, 2") @min_max(0, 2),
    {{ get_hash('GH_ANNOT', 'cityHash64') }} AS `GH_ANNOT`        @id("e70006") @description("hash of name and s"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS `SYSTEM_CREATE_DATE` @id("e70008") @isSystemCreateDate @notNull,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS `SYSTEM_UPDATE_DATE` @id("e70009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'TT_SRC') }}
