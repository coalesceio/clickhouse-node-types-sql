@id("5a8e71b0-930c-5c5a-9e26-29dbe66edc7a")
@nodeType("SQLFact")
@engine("MergeTree")
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                             AS `o_orderkey`         @id("1a0001"),
    `o_custkey`                              AS `o_custkey`          @id("1a0002"),
    `o_totalprice`                           AS `o_totalprice`       @id("1a0003"),
    now64(6)                                 AS `SYSTEM_CREATE_DATE` @id("1a0008") @isSystemCreateDate
FROM {{ ref('SRC', 'rx_orders') }} `orders`
