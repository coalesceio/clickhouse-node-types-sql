@id("2da19972-8dcd-418b-a906-ff8490dfef00")
@nodeType("SQLFact")
@orderBy("o_orderkey")
@materializationType("view")
@mergeStrategy("changeTracking")
@description("View variant of FCT_ORDERS exposing the same order-grain rollups without materializing a table")
SELECT
    "wol"."o_orderkey"                   AS "o_orderkey"        @id("c30001") @isBusinessKey @notNull @not_null @description("Order key, the business key for this fact"),
    "dc"."DIM_CUSTOMER_KEY"              AS "DIM_CUSTOMER_KEY"  @id("c30002") @notNull @not_null @description("Surrogate key of the customer's current dimension row"),
    "wol"."o_orderstatus"                AS "o_orderstatus"     @id("c30003") @notNull @accepted_values("'O'", "'F'", "'P'") @description("Order status: O (open), F (filled), or P (partial)"),
    "wol"."o_orderdate"                  AS "o_orderdate"       @id("c30004") @notNull @description("Date the order was placed"),
    "wol"."o_orderpriority"              AS "o_orderpriority"   @id("c30005") @description("Order priority code"),
    "wol"."o_clerk"                      AS "o_clerk"           @id("c30006") @description("Clerk who processed the order"),
    "wol"."o_shippriority"               AS "o_shippriority"    @id("c30007") @description("Shipping priority for the order"),
    "wol"."net_revenue"                  AS "net_revenue"       @id("c30008") @notNull @min_value(0) @description("Net revenue rolled up from the order's line items"),
    "wol"."total_quantity"               AS "total_quantity"    @id("c30009") @notNull @min_value(0) @description("Total quantity rolled up from the order's line items"),
    "wol"."line_count"                   AS "line_count"        @id("c3000a") @notNull @min_value(1) @description("Number of line items on the order"),
    "wol"."last_ship_date"               AS "last_ship_date"    @id("c3000b") @description("Latest ship date among the order's line items"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("c3000c") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("c3000d") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDER_LINE') }} "wol"
JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} "dc"
    ON "wol"."o_custkey" = "dc"."c_custkey" AND "dc"."SYSTEM_CURRENT_FLAG" = 'Y'
