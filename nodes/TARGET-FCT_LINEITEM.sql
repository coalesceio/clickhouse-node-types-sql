@id("a1c2e4d6-3b5f-4a7c-9d1e-6f8b2a0c5e37")
@nodeType("SQLFact")
@orderBy("l_orderkey", "l_linenumber")
@mergeStrategy("lastModified")
@description("Line-item grain fact loaded incrementally off l_shipdate, one row per order line")
SELECT
    "l_orderkey"                          AS "l_orderkey"        @id("e50001") @isBusinessKey @notNull @not_null @description("Order key, part of the line item business key"),
    "l_linenumber"                        AS "l_linenumber"      @id("e50002") @isBusinessKey @notNull @not_null @description("Line number within the order, part of the business key"),
    "l_shipdate"                          AS "l_shipdate"        @id("e5000b") @notNull @lastModifiedTracking @relative_time("<=", "l_receiptdate") @description("Ship date; drives the lastModified incremental load"),
    "l_partkey"                           AS "l_partkey"         @id("e50003") @notNull @not_null @description("Part key for this line item"),
    "l_suppkey"                           AS "l_suppkey"         @id("e50004") @notNull @not_null @description("Supplier key for this line item"),
    "l_quantity"                          AS "l_quantity"        @id("e50005") @notNull @min_value(0) @max_value(50) @description("Quantity ordered on this line"),
    "l_extendedprice"                     AS "l_extendedprice"   @id("e50006") @notNull @min_value(0) @description("Extended price before discount and tax"),
    "l_discount"                          AS "l_discount"        @id("e50007") @notNull @min_max(0, 1) @description("Discount fraction applied to the extended price"),
    "l_tax"                               AS "l_tax"             @id("e50008") @notNull @min_max(0, 1) @description("Tax fraction applied to the line"),
    "l_returnflag"                        AS "l_returnflag1"      @id("e50009") @notNull @accepted_values("'A'", "'N'", "'R'") @description("Return status flag for the line item"),
    "l_linestatus"                        AS "l_linestatus"      @id("e5000a") @notNull @accepted_values("'O'", "'F'") @description("Order line status: O (open) or F (filled)"),
    "l_commitdate"                        AS "l_commitdate"      @id("e5000c") @notNull @description("Date the line item was committed to ship"),
    "l_receiptdate"                       AS "l_receiptdate"     @id("e5000d") @notNull @description("Date the line item was received"),
    "l_shipinstruct"                      AS "l_shipinstruct"    @id("e5000e") @empty @description("Shipping instructions for this line"),
    "l_shipmode"                          AS "l_shipmode"        @id("e5000f") @empty @description("Shipping mode used for this line"),
    'hi'                                  AS "n_col"             @id("e5000g") @description("Placeholder test column, not sourced from lineitem"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_CREATE_DATE" @id("e50010") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_UPDATE_DATE" @id("e50011") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_LINEITEM') }} "lineitem"
