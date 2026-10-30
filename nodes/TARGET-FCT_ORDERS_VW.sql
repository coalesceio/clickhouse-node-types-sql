@id("2da19972-8dcd-418b-a906-ff8490dfef00")
@nodeType("SQLFact")
@orderBy("o_orderkey")
@materializationType("view")
@mergeStrategy("changeTracking")
SELECT
    "wol"."o_orderkey"                   AS "o_orderkey"        @id("c30001") @isBusinessKey @notNull @not_null,
    "dc"."DIM_CUSTOMER_KEY"              AS "DIM_CUSTOMER_KEY"  @id("c30002") @notNull @not_null,
    "wol"."o_orderstatus"                AS "o_orderstatus"     @id("c30003") @notNull @accepted_values("'O'", "'F'", "'P'"),
    "wol"."o_orderdate"                  AS "o_orderdate"       @id("c30004") @notNull,
    "wol"."o_orderpriority"              AS "o_orderpriority"   @id("c30005"),
    "wol"."o_clerk"                      AS "o_clerk"           @id("c30006"),
    "wol"."o_shippriority"               AS "o_shippriority"    @id("c30007"),
    "wol"."net_revenue"                  AS "net_revenue"       @id("c30008") @notNull @min_value(0),
    "wol"."total_quantity"               AS "total_quantity"    @id("c30009") @notNull @min_value(0),
    "wol"."line_count"                   AS "line_count"        @id("c3000a") @notNull @min_value(1),
    "wol"."last_ship_date"               AS "last_ship_date"    @id("c3000b"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("c3000c") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("c3000d") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDER_LINE') }} "wol"
JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} "dc"
    ON "wol"."o_custkey" = "dc"."c_custkey" AND "dc"."SYSTEM_CURRENT_FLAG" = 'Y'
