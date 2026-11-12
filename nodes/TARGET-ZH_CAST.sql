@id("d1d1d1d1-0000-4000-8000-000000000003")
@nodeType("SQLWork")
@tests("SELECT 1 FROM {{ this }} WHERE `h_cast` != `h_colon` OR toString(`h_cast`) != lower(hex(MD5(concat(ifNull(toString(`a`), 'null'), '||', ifNull(toString(`b`), 'null')))))", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE length(`h_cast`) != 32 OR length(`h_sha256`) != 64 OR length(`h_raw`) != 16", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE toTypeName(`h_cast`) NOT LIKE '%FixedString(32)%' OR toTypeName(`h_colon`) NOT LIKE '%FixedString(32)%' OR toTypeName(`h_city`) NOT LIKE '%UInt64%'", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `h_raw` != MD5(concat(ifNull(toString(`a`), 'null'), '||', ifNull(toString(`b`), 'null')))", true, "After")
SELECT
    `a`                                                     AS `a` @inHash("H", 1),
    `b`                                                     AS `b` @inHash("H", 2),
    CAST({{ get_hash('H', 'MD5') }} AS FixedString(32))     AS `h_cast`,
    {{ get_hash('H', 'MD5') }}::FixedString(32)             AS `h_colon`,
    {{ get_hash('H', 'SHA256') }}::FixedString(64)          AS `h_sha256`,
    {{ get_hash('H', 'cityHash64') }}::UInt64               AS `h_city`,
    CAST(MD5(concat(ifNull(toString(`a`), 'null'), '||', ifNull(toString(`b`), 'null'))) AS FixedString(16)) AS `h_raw`
FROM {{ ref('TARGET', 'ZH_SRC') }} `ZH_SRC`
