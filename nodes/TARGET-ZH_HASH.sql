@id("d1d1d1d1-0000-4000-8000-000000000002")
@nodeType("SQLWork")
@tests("SELECT 1 FROM {{ this }} WHERE NOT match(`h_cityHash64`, '^[0-9]+$') OR NOT match(`h_xxHash64`, '^[0-9]+$') OR NOT match(`h_xxh3`, '^[0-9]+$') OR NOT match(`h_CRC32`, '^[0-9]+$')", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE NOT match(`h_javaHash`, '^-?[0-9]+$')", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE NOT match(`h_MD4`, '^[0-9a-f]+$')", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE NOT match(`h_sipHash128`, '^[0-9a-f]+$') OR NOT match(`h_RIPEMD160`, '^[0-9a-f]+$') OR NOT match(`h_BLAKE3`, '^[0-9a-f]+$')", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `h2_quote_delim` != lower(hex(MD5(concat(toString(`c`), char(39), '|', ifNull(`b`, 'null')))))", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `b` IS NULL AND `h_MD5` != lower(hex(MD5(concat(toString(`a`), '||null||', toString(`c`)))))", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `h_MD5` != lower(hex(MD5(concat(ifNull(toString(`a`), 'null'), '||', ifNull(toString(`b`), 'null'), '||', ifNull(toString(`c`), 'null')))))", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `h_SHA256` != lower(hex(SHA256(concat(ifNull(toString(`a`), 'null'), '||', ifNull(toString(`b`), 'null'), '||', ifNull(toString(`c`), 'null')))))", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `h_sha256` != `h_SHA256` OR `h_md5` != `h_MD5`", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE toString(`h_cityHash64`) != toString(cityHash64(concat(ifNull(toString(`a`), 'null'), '||', ifNull(toString(`b`), 'null'), '||', ifNull(toString(`c`), 'null'))))", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `h2_nodelim` != lower(hex(MD5(concat(toString(`c`), ifNull(`b`, 'null')))))", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE length(`h_MD5`) != 32 OR length(`h_SHA1`) != 40 OR length(`h_SHA256`) != 64 OR length(`h_SHA512`) != 128", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `h_empty_group` IS NOT NULL", true, "After")
SELECT
    `a` AS `a` @inHash("H", 1),
    `b` AS `b` @inHash("H", 2) @inHash("H2", 2),
    `c` AS `c` @inHash("H", 3) @inHash("H2", 1),
    {{ get_hash('H', 'MD5') }} AS `h_MD5`,
    {{ get_hash('H', 'SHA1') }} AS `h_SHA1`,
    {{ get_hash('H', 'SHA224') }} AS `h_SHA224`,
    {{ get_hash('H', 'SHA256') }} AS `h_SHA256`,
    {{ get_hash('H', 'SHA384') }} AS `h_SHA384`,
    {{ get_hash('H', 'SHA512') }} AS `h_SHA512`,
    {{ get_hash('H', 'sha256') }} AS `h_sha256`,
    {{ get_hash('H', 'md5') }} AS `h_md5`,
    {{ get_hash('H', 'cityHash64') }} AS `h_cityHash64`,
    {{ get_hash('H', 'xxHash64') }} AS `h_xxHash64`,
    {{ get_hash('H', 'sipHash64') }} AS `h_sipHash64`,
    {{ get_hash('H', 'farmHash64') }} AS `h_farmHash64`,
    {{ get_hash('H', 'murmurHash3_64') }} AS `h_murmurHash3_64`,
    {{ get_hash('H', 'xxh3') }} AS `h_xxh3`,
    {{ get_hash('H', 'halfMD5') }} AS `h_halfMD5`,
    {{ get_hash('H', 'wyHash64') }} AS `h_wyHash64`,
    {{ get_hash('H', 'javaHash') }} AS `h_javaHash`,
    {{ get_hash('H', 'CRC32') }} AS `h_CRC32`,
    {{ get_hash('H', 'sipHash128') }} AS `h_sipHash128`,
    {{ get_hash('H', 'MD4') }} AS `h_MD4`,
    {{ get_hash('H', 'RIPEMD160') }} AS `h_RIPEMD160`,
    {{ get_hash('H', 'BLAKE3') }} AS `h_BLAKE3`,
    {{ get_hash('H2', 'MD5', '') }} AS `h2_nodelim`,
    {{ get_hash('H2', 'MD5', "'|") }} AS `h2_quote_delim`,
    {{ get_hash('NONE', 'MD5') }} AS `h_empty_group`
FROM {{ ref('TARGET', 'ZH_SRC') }} `ZH_SRC`
