@id("7457371f-164a-46ac-a4cb-67e8f12fff39")
@nodeType("SQLWork")
@description("AN pipeline - Work table: line items with net, tax and gross amounts")
@materializationType("table")
@writeMode("truncateInsert")
@orderBy("`l_orderkey`", "`l_linenumber`")
@primaryKey("`l_orderkey`")
@partitionBy("toYYYYMM(`ship_date`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_block_size = 65536")
@tests("SELECT 1 FROM {{ ref('SRC', 'lineitem') }} HAVING count() = 0", true, "Before")
@tests("SELECT `l_orderkey`, `l_linenumber` FROM {{ this }} GROUP BY `l_orderkey`, `l_linenumber` HAVING count() > 1", false, "After")
SELECT distinct
    `l`.`l_orderkey`                                   AS `l_orderkey`      @id("awl01") @notNull @description("Order key") @not_null @inHash("GH_LINE_KEY", 1),
    `l`.`l_linenumber`                                 AS `l_linenumber`    @id("awl02") @notNull @description("Line number within the order") @min_max("1", "7") @inHash("GH_LINE_KEY", 2),
    `l`.`l_partkey`                                    AS `part_key`        @id("awl03") @notNull @description("Part key"),
    `l`.`l_suppkey`                                    AS `supplier_key`    @id("awl04") @notNull @description("Supplier key"),
    `l`.`l_quantity`                                   AS `quantity`        @id("awl05") @notNull @description("Quantity") @min_max("1", "50"),
    `l`.`l_extendedprice`                              AS `extended_price`  @id("awl06") @notNull @description("Extended price") @min_value("0"),
    `l`.`l_discount`                                   AS `discount`        @id("awl07") @notNull @description("Discount rate") @min_max("0", "toDecimal64('0.10', 2)"),
    `l`.`l_tax`                                        AS `tax`             @id("awl08") @notNull @description("Tax rate") @min_max("0", "toDecimal64('0.08', 2)"),
    CAST(`l`.`l_extendedprice` * (1 - `l`.`l_discount`) AS Decimal(18, 4))
                                                       AS `net_amount`      @id("awl09") @notNull @description("extended_price * (1 - discount)") @min_value("0"),
    CAST(`l`.`l_extendedprice` * (1 - `l`.`l_discount`) * (1 + `l`.`l_tax`) AS Decimal(18, 4))
                                                       AS `gross_amount`    @id("awl10") @notNull @description("net_amount * (1 + tax)") @min_value("0"),
    CAST(toStringCutToZero(`l`.`l_returnflag`) AS FixedString(1))  AS `return_flag`     @id("awl11") @notNull @description("Return flag") @accepted_values("'R', 'A', 'N'"),
    CAST(toStringCutToZero(`l`.`l_linestatus`) AS FixedString(1))  AS `line_status`     @id("awl12") @notNull @description("Line status") @accepted_values("'O', 'F'"),
    `l`.`l_shipdate`                                   AS `ship_date`       @id("awl13") @notNull @description("Ship date"),
    `l`.`l_commitdate`                                 AS `commit_date`     @id("awl14") @notNull @description("Commit date"),
    `l`.`l_receiptdate`                                AS `receipt_date`    @id("awl15") @notNull @description("Receipt date") @relative_time(">=", "ship_date"),
    trimBoth(toStringCutToZero(`l`.`l_shipinstruct`))  AS `ship_instruct`   @id("awl16") @notNull @description("Shipping instruction") @accepted_values("'DELIVER IN PERSON', 'COLLECT COD', 'NONE', 'TAKE BACK RETURN'"),
    trimBoth(toStringCutToZero(`l`.`l_shipmode`))      AS `ship_mode`       @id("awl17") @notNull @description("Shipping mode") @accepted_values("'AIR', 'REG AIR', 'RAIL', 'SHIP', 'TRUCK', 'MAIL', 'FOB'"),
    `l`.`l_comment`                                    AS `comment`         @id("awl18") @description("Line comment"),
    {{ get_hash('GH_LINE_KEY', 'cityHash64') }}        AS `line_hash`       @id("awl19") @description("cityHash64 of l_orderkey, l_linenumber")
FROM {{ ref('SRC', 'lineitem') }} `l`
