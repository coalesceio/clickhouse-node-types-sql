@id("7e700000-0000-4000-8000-000000000003")
@nodeType("SQLWork")
@ttl("`d` + INTERVAL 1 YEAR")
@tests("SELECT 1 WHERE (SELECT count() FROM system.tables WHERE concat(char(96), database, char(96), char(46), char(96), name, char(96)) = '{{ this }}' AND position(engine_full, 'TTL') > 0) = 0", true, "After")
SELECT
    `k` AS `k` @id("b70001") @notNull,
    `d` AS `d` @id("b70002") @notNull
FROM {{ ref('TARGET', 'TT_SRC') }}
