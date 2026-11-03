@id("f8472f97-2521-45bf-8add-dd6f1c1e5d5e")
@nodeType("SQLFact")
@orderBy("o_orderkey")
@writeMode("truncateInsert")
@mergeStrategy("changeTracking")
@description("Fact sample")
SELECT
    "wol"."o_orderkey"                   AS "o_orderkey"        @id("c30001") @isBusinessKey @notNull @not_null,
    "dc"."DIM_CUSTOMER_KEY"              AS "DIM_CUSTOMER_KEY"  @id("c30002") @notNull @not_null @inHash("ORDER_HASH",1),
    "wol"."o_orderstatus"                AS "o_orderstatus"     @id("c30003") @notNull @accepted_values("'O'", "'F'", "'P'") @inHash("ORDER_HASH",2),
    "wol"."o_orderdate"                  AS "o_orderdate"       @id("c30004") @notNull @defaultValue("20261013") @inHash("ORDER_HASH",3),
    "wol"."o_orderpriority"              AS "o_orderpriority"   @id("c30005") @inHash("ORDER_HASH",4),
    "wol"."o_clerk"                      AS "o_clerk"           @id("c30006") @inHash("ORDER_HASH",5),
    "wol"."o_shippriority"               AS "o_shippriority"    @id("c30007") @inHash("ORDER_HASH",6),
    "wol"."net_revenue"                  AS "net_revenue"       @id("c30008") @notNull @min_value(0) @inHash("ORDER_HASH",7),
    "wol"."total_quantity"               AS "total_quantity"    @id("c30009") @notNull @min_value(0) @inHash("ORDER_HASH", 8),
    "wol"."line_count"                   AS "line_count"        @id("c3000a") @notNull @min_value(1) @inHash( "ORDER_HASH",9),
    "wol"."last_ship_date"               AS "last_ship_date"    @id("c3000b") @inHash("ORDER_HASH", 10),
    {{ get_hash('ORDER_HASH','MD5') }}         AS "ORDER_HASH"        @id("c3000e") ,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("c3000c") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("c3000d") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDER_LINE') }} "wol"
JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} "dc"
    ON "wol"."o_custkey" = "dc"."c_custkey" AND "dc"."SYSTEM_CURRENT_FLAG" = 'Y'
