@id("2ad39cdb-4898-5890-9e46-7fa400581cab")
@nodeType("SQLFact")
@engine("MergeTree")
@mergeStrategy("lastModified")
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                             AS `o_orderkey`         @id("1c0001") @isBusinessKey @notNull,
    `o_orderstatus`                          AS `o_orderstatus`      @id("1c0002"),
    `updated_at`                             AS `updated_at`         @id("1c0003") @lastModifiedTracking,
    now64(6)                                 AS `SYSTEM_CREATE_DATE` @id("1c0008") @isSystemCreateDate,
    now64(6)                                 AS `SYSTEM_UPDATE_DATE` @id("1c0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_orders') }} `orders`
