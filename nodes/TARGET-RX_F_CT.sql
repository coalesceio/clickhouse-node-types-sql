@id("f7a024aa-0f30-5147-aa76-0fdbd870c4bd")
@nodeType("SQLFact")
@engine("MergeTree")
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                             AS `o_orderkey`         @id("1b0001") @isBusinessKey @notNull,
    `o_orderstatus`                          AS `o_orderstatus`      @id("1b0002"),
    `o_totalprice`                           AS `o_totalprice`       @id("1b0003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("1b0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("1b0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_orders') }} `orders`
