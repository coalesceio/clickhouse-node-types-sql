@id("0e1f0a00-0000-4000-8000-000000000605")
@nodeType("SQLWork")
@description("get_hash edge cases")
SELECT
    `s`.`cust_id`                                       AS `cust_id`    @inHash("H1", 1) @inHash("H2", 2) @inHash("H3", 1),
    `s`.`cust_name`                                     AS `cust_name`  @inHash("H1", 2) @inHash("H2", 1),
    CAST(`s`.`city` AS LowCardinality(String))          AS `city_lc`    @inHash("H1", 3),
    `s`.`updated_at`                                    AS `updated_at` @inHash("H1", 4),
    CAST(`s`.`code` AS FixedString(2))                  AS `code`       @inHash("H3", 2),
    {{ get_hash('H1') }}                                AS `h1_sha1`,
    {{ get_hash('H1', 'sha224') }}                      AS `h1_sha224`,
    {{ get_hash('H1', 'SHA384') }}                      AS `h1_sha384`,
    {{ get_hash('H1', 'SHA512') }}                      AS `h1_sha512`,
    {{ get_hash('H1', 'md5', '') }}                     AS `h1_md5_nodelim`,
    {{ get_hash('H2', delimiter='|') }}                 AS `h2_pipe`,
    {{ get_hash('H3', 'sipHash64') }}                   AS `h3_sip`,
    lower(hex(SHA1(ifNull(toString(`s`.`cust_id`), 'null') || '||' || ifNull(toString(`s`.`cust_name`), 'null') || '||' || ifNull(toString(CAST(`s`.`city` AS LowCardinality(String))), 'null') || '||' || ifNull(toString(`s`.`updated_at`), 'null')))) AS `h1_expected`
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
