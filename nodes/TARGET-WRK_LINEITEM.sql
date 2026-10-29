@id("f0a25bda-6553-4f5f-9cf7-8b938c7d7b42")
@nodeType("SQLWork")
@writeMode("truncateInsert")
SELECT
    `l_orderkey`     AS `l_orderkey`    @notNull @not_null,
    `l_partkey`      AS `l_partkey`     @notNull,
    `l_suppkey`      AS `l_suppkey`     @notNull,
    `l_linenumber`   AS `l_linenumber`  @notNull,
    `l_quantity`     AS `l_quantity`    @notNull @min_value(0),
    `l_extendedprice` AS `l_extendedprice` @notNull @min_value(0),
    `l_discount`     AS `l_discount`    @notNull @min_max(0, 1),
    `l_tax`          AS `l_tax`         @notNull @min_max(0, 1),
    `l_returnflag`   AS `l_returnflag`  @notNull @accepted_values("'A'", "'N'", "'R'"),
    `l_linestatus`   AS `l_linestatus`  @notNull @accepted_values("'O'", "'F'"),
    `l_shipdate`     AS `l_shipdate`    @notNull @relative_time("<=", "l_receiptdate"),
    `l_commitdate`   AS `l_commitdate`  @notNull @relative_time("<=", "l_receiptdate"),
    `l_receiptdate`  AS `l_receiptdate` @notNull,
    `l_shipinstruct` AS `l_shipinstruct`,
    `l_shipmode`     AS `l_shipmode`,
    `l_comment`      AS `l_comment`
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
