@id("7e700000-0000-4000-8000-000000000002")
@nodeType("SQLWork")
@orderBy("`k`")
@ttl("`d2` + INTERVAL 300 DAY")
@postSQL("OPTIMIZE TABLE {{ this }} FINAL")
@tests("SELECT 1 WHERE (SELECT count() FROM system.tables WHERE concat(char(96), database, char(96), char(46), char(96), name, char(96)) = '{{ this }}' AND position(engine_full, 'TTL') > 0) = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `d2` < now() - INTERVAL 300 DAY", true, "After")
SELECT `k` AS `k` @notNull, `name` AS `name`, `d` AS `d2` @notNull
FROM {{ ref('TARGET', 'TT_SRC') }}
