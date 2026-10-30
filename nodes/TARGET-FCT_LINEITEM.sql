@id("a1c2e4d6-3b5f-4a7c-9d1e-6f8b2a0c5e37")
@nodeType("SQLFact")
@orderBy("l_orderkey", "l_linenumber")
@mergeStrategy("lastModified")
SELECT
    "l_orderkey"                          AS "l_orderkey"        @id("e50001") @isBusinessKey @notNull @not_null,
    "l_linenumber"                        AS "l_linenumber"      @id("e50002") @isBusinessKey @notNull @not_null,
    "l_shipdate"                          AS "l_shipdate"        @id("e5000b") @notNull @lastModifiedTracking,
    "l_partkey"                           AS "l_partkey"         @id("e50003") @notNull @not_null,
    "l_suppkey"                           AS "l_suppkey"         @id("e50004") @notNull @not_null,
    "l_quantity"                          AS "l_quantity"        @id("e50005") @notNull @min_value(0),
    "l_extendedprice"                     AS "l_extendedprice"   @id("e50006") @notNull @min_value(0),
    "l_discount"                          AS "l_discount"        @id("e50007") @notNull @min_max(0, 1),
    "l_tax"                               AS "l_tax"             @id("e50008") @notNull @min_max(0, 1),
    "l_returnflag"                        AS "l_returnflag"      @id("e50009") @notNull @accepted_values("'A'", "'N'", "'R'"),
    "l_linestatus"                        AS "l_linestatus"      @id("e5000a") @notNull @accepted_values("'O'", "'F'"),
    "l_commitdate"                        AS "l_commitdate"      @id("e5000c") @notNull,
    "l_receiptdate"                       AS "l_receiptdate"     @id("e5000d") @notNull,
    "l_shipinstruct"                      AS "l_shipinstruct"    @id("e5000e"),
    "l_shipmode"                          AS "l_shipmode"        @id("e5000f"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_CREATE_DATE" @id("e50010") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_UPDATE_DATE" @id("e50011") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_LINEITEM') }} "lineitem"
