@id("7e700000-0000-4000-8000-000000000004")
@nodeType("SQLFact")
@ttl("toDateTime(`s`) + INTERVAL 1 YEAR")
@tests("SELECT 1 WHERE (SELECT count() FROM system.tables WHERE concat(char(96), database, char(96), char(46), char(96), name, char(96)) = '{{ this }}' AND position(engine_full, 'TTL') > 0) = 0", true, "After")
SELECT
    `k` AS `k` @id("c70001") @isBusinessKey @notNull,
    `s` AS `s` @id("c70002") @notNull,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c70008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c70009") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'TT_SRC') }}
