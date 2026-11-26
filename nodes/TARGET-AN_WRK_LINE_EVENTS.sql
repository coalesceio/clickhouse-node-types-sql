@id("1822e151-081c-4f22-aae0-c91385aaa050")
@nodeType("SQLWork")
@description("AN line events - Work table: UNION ALL of the ship, commit and receipt dates of each line item, one row per line item and event")
@materializationType("table")
@writeMode("truncateInsert")
@orderBy("`event_date`", "`event_type`", "`l_orderkey`", "`l_linenumber`")
@partitionBy("toYear(`event_date`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000")
@tests("SELECT `l_orderkey`, `l_linenumber`, `event_type` FROM {{ this }} GROUP BY `l_orderkey`, `l_linenumber`, `event_type` HAVING count() > 1", false, "After")
WITH `events` AS (
    SELECT `l_orderkey`, `l_linenumber`, `l_partkey`, `l_suppkey`, `l_shipmode`, `l_quantity`, `l_extendedprice`, `l_discount`,
           'SHIP'    AS `event_type`, `l_shipdate`    AS `event_date`
    FROM {{ ref('SRC', 'lineitem') }}
    UNION ALL
    SELECT `l_orderkey`, `l_linenumber`, `l_partkey`, `l_suppkey`, `l_shipmode`, `l_quantity`, `l_extendedprice`, `l_discount`,
           'COMMIT'  AS `event_type`, `l_commitdate`  AS `event_date`
    FROM {{ ref('SRC', 'lineitem') }}
    UNION ALL
    SELECT `l_orderkey`, `l_linenumber`, `l_partkey`, `l_suppkey`, `l_shipmode`, `l_quantity`, `l_extendedprice`, `l_discount`,
           'RECEIPT' AS `event_type`, `l_receiptdate` AS `event_date`
    FROM {{ ref('SRC', 'lineitem') }}
)
SELECT
    `e`.`l_orderkey`                                         AS `l_orderkey`   @id("ale01") @notNull @description("Order key") @not_null,
    `e`.`l_linenumber`                                       AS `l_linenumber` @id("ale02") @notNull @description("Line number within the order") @min_max("1", "7"),
    `e`.`l_partkey`                                          AS `part_key`     @id("ale03") @notNull @description("Part key"),
    `e`.`l_suppkey`                                          AS `supplier_key` @id("ale04") @notNull @description("Supplier key"),
    trimBoth(toStringCutToZero(`e`.`l_shipmode`))            AS `ship_mode`    @id("ale05") @notNull @description("Shipping mode") @accepted_values("'AIR', 'REG AIR', 'RAIL', 'SHIP', 'TRUCK', 'MAIL', 'FOB'"),
    CAST(`e`.`event_type` AS String)                         AS `event_type`   @id("ale06") @notNull @description("SHIP, COMMIT or RECEIPT") @accepted_values("'SHIP', 'COMMIT', 'RECEIPT'"),
    `e`.`event_date`                                         AS `event_date`   @id("ale07") @notNull @description("Date of the event") @not_null,
    `e`.`l_quantity`                                         AS `quantity`     @id("ale08") @notNull @description("Quantity") @min_max("1", "50"),
    CAST(`e`.`l_extendedprice` * (1 - `e`.`l_discount`) AS Decimal(18, 4))
                                                             AS `net_amount`   @id("ale09") @notNull @description("extended_price * (1 - discount)") @min_value("0")
FROM `events` `e`
