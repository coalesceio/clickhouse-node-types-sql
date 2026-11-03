@id("e3d73faf-a497-43f3-8cb9-7b2eb60ecec0")
@nodeType("SQLFact")
@orderBy("o_orderkey")
@mergeStrategy("changeTracking")
@description("Order-grain fact with line-item rollups (revenue, quantity, line count) and the owning customer's current dimension key")
SELECT
    "wol"."o_orderkey"                   AS "o_orderkey"        @id("c30001") @isBusinessKey @notNull @not_null @uniqueness @description("Order key, the business key for this fact"),
    "dc"."DIM_CUSTOMER_KEY"              AS "DIM_CUSTOMER_KEY"  @id("c30002") @notNull @not_null @description("Surrogate key of the customer's current dimension row"),
    CAST("wol"."o_orderstatus" AS STRING)                AS "o_orderstatus"     @id("c30003") @notNull @accepted_values("'O'", "'F'", "'P'") @description("Order status: O (open), F (filled), or P (partial)"),
    "wol"."o_orderdate"                  AS "o_orderdate"       @id("c30004") @notNull @relative_time("<=", "last_ship_date") @description("Date the order was placed"),
    "wol"."o_orderpriority"              AS "o_orderpriority"   @id("c30005") @empty @description("Order priority code"),
    "wol"."o_clerk"                      AS "o_clerk"           @id("c30006") @empty @description("Clerk who processed the order"),
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
