@id("c9e2a7b4-1f5d-4e8a-b6c3-7d9f0e2a4b85")
@nodeType("SQLFact")
@orderBy("l_shipdate", "l_orderkey", "l_linenumber")
@writeMode("append")
@description("Plain-insert event log of lineitem shipments, no merge")
SELECT
    "l_orderkey"                           AS "l_orderkey"        @id("fa0001") @notNull @not_null,
    "l_linenumber"                         AS "l_linenumber"      @id("fa0002") @notNull @not_null,
    "l_partkey"                            AS "l_partkey"         @id("fa0003") @notNull @not_null,
    "l_suppkey"                            AS "l_suppkey"         @id("fa0004") @notNull @not_null,
    "l_quantity"                           AS "l_quantity"        @id("fa0005") @notNull @min_value(0),
    "l_extendedprice"                      AS "l_extendedprice"   @id("fa0006") @notNull @min_value(0),
    "l_shipdate"                           AS "l_shipdate"        @id("fa0007") @notNull,
    "l_shipmode"                           AS "l_shipmode"        @id("fa0008"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)   AS "SYSTEM_CREATE_DATE" @id("fa0009") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)   AS "SYSTEM_UPDATE_DATE" @id("fa000a") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_LINEITEM') }} "lineitem"
