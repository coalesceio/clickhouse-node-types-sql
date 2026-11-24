@id("25a85978-9b67-575e-9fdd-9f1512dc9d98")
@nodeType("SQLFact")
@engine("MergeTree")
@mergeStrategy("allColumnMatch")
@orderBy("`ps_partkey`", "`ps_suppkey`")
SELECT
    `ps_partkey`                             AS `ps_partkey`         @id("1e0001") @notNull,
    `ps_suppkey`                             AS `ps_suppkey`         @id("1e0002") @notNull,
    `ps_availqty`                            AS `ps_availqty`        @id("1e0003"),
    now64(6)                                 AS `SYSTEM_CREATE_DATE` @id("1e0008") @isSystemCreateDate
FROM {{ ref('SRC', 'rx_partsupp') }} `partsupp`
