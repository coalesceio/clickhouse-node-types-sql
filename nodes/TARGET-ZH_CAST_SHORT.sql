@id("d1d1d1d1-0000-4000-8000-000000000004")
@nodeType("SQLWork")
SELECT
    `a`                                         AS `a` @inHash("H", 1),
    {{ get_hash('H', 'MD5') }}::FixedString(16) AS `h_too_short`
FROM {{ ref('TARGET', 'ZH_SRC') }} `ZH_SRC`
