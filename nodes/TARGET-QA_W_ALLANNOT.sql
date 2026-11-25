@id("0e1f0a00-0000-4000-8000-000000000103")
@nodeType("SQLWork")
@orderBy("`cust_id`", "`segment`", "toYYYYMM(`updated_at`)")
@primaryKey("`cust_id`", "`segment`")
@partitionBy("toYYYYMM(`updated_at`)")
@settings("index_granularity = 4096", "min_bytes_for_wide_part = 0")
@querySettings("max_threads = 2", "max_block_size = 4096")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} GROUP BY `cust_id` HAVING count() > 1")
@tests("SELECT 1 FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} WHERE `cust_name` IS NULL", true, "Before")
@tests("SELECT 1 FROM {{ this }} WHERE `cust_id` > 1000", false, "After")
@description("QA all annotations - Work, it's quoted")
@preSQL("SELECT 1")
@preSQL("DELETE FROM {{ this }} WHERE `cust_id` = 999")
@postSQL("ALTER TABLE {{ this }} UPDATE `cust_label` = 'post' WHERE `cust_id` = 5 SETTINGS mutations_sync = 2")
SELECT
    `c`.`cust_id`       AS `cust_id`      @notNull @not_null @uniqueness @min_value("1") @max_value("100") @accepted_values("1, 2, 3, 4, 5") @inHash("GH_A", 2) @description("customer id"),
    `c`.`cust_name`     AS `cust_name`    @empty @not_null @inHash("GH_A", 1) @inHash("GH_B", 1) @description("name with 'quote'"),
    `c`.`region_id`     AS `region_id`    @defaultValue("0") @min_max("0", "4") @rejected_values("99"),
    `c`.`balance`       AS `balance`      @min_max("-1000", "100000") @inHash("GH_B", 2),
    `c`.`segment`       AS `segment`      @notNull @accepted_values("'RETAIL'", "'CORPORATE'") @accepted_values("'SMB'"),
    `c`.`updated_at`    AS `updated_at`   @freshness(30, "DAY") @relative_time("<=", "loaded_at"),
    now64(3)            AS `loaded_at`,
    'x'                 AS `cust_label`   @defaultValue("'NA'"),
    {{ get_hash('GH_A') }}                                   AS `hash_sha1`,
    {{ get_hash('GH_A', 'MD5') }}                            AS `hash_md5`,
    {{ get_hash('GH_B', algo='SHA256', delimiter='~') }}     AS `hash_sha256`,
    {{ get_hash('GH_B', 'cityHash64') }}                     AS `hash_city`,
    toUInt64({{ get_hash('GH_B', 'xxHash64', '') }})         AS `hash_xx_num`,
    {{ get_hash('NOPE') }}                                   AS `hash_empty`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
