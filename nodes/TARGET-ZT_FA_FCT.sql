@id("0186f3b2-e64b-4e76-a7bf-b720a8f86d27")
@nodeType("SQLFact")
@engine("ReplacingMergeTree")
@mergeStrategy("changeTracking")
SELECT
    `o_orderkey`                             AS `o_orderkey`         @id("1d26c9") @isBusinessKey @notNull,
    `o_custkey`                              AS `o_custkey`          @id("2e8310"),
    `o_orderstatus`                          AS `o_orderstatus`      @id("ac58e5"),
    `o_totalprice`                           AS `o_totalprice`       @id("847d6b"),
    `o_orderdate`                            AS `o_orderdate`        @id("b54475"),
    now64(6)                                 AS "SYSTEM_CREATE_DATE" @id("836ff1") @isSystemCreateDate,
    now64(6)                                 AS "SYSTEM_UPDATE_DATE" @id("f1c2a9") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_orders') }} `rx_orders`
