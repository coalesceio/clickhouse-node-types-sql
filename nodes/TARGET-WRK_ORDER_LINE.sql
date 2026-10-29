@id("a1810ea1-beb0-44a0-84b3-d358c57d2da5")
@nodeType("SQLWork")
@writeMode("truncateInsert")
SELECT
    `o`.`o_orderkey`                                       AS `o_orderkey`     @notNull @not_null @uniqueness,
    `o`.`o_custkey`                                        AS `o_custkey`      @notNull,
    `o`.`o_orderstatus`                                    AS `o_orderstatus`  @notNull @accepted_values("'O'", "'F'", "'P'"),
    `o`.`o_orderdate`                                      AS `o_orderdate`    @notNull,
    `o`.`o_orderpriority`                                  AS `o_orderpriority`,
    `o`.`o_clerk`                                          AS `o_clerk`,
    `o`.`o_shippriority`                                   AS `o_shippriority`,
    SUM(`l`.`l_extendedprice` * (1 - `l`.`l_discount`))    AS `net_revenue`    @notNull @min_value(0),
    SUM(`l`.`l_quantity`)                                  AS `total_quantity` @notNull @min_value(0),
    COUNT(*)                                               AS `line_count`     @notNull @min_value(1),
    MAX(`l`.`l_shipdate`)                                  AS `last_ship_date`
FROM {{ ref('SRC', 'orders') }} `o`
JOIN {{ ref('TARGET', 'WRK_LINEITEM') }} `l` ON `o`.`o_orderkey` = `l`.`l_orderkey`
GROUP BY
    `o`.`o_orderkey`,
    `o`.`o_custkey`,
    `o`.`o_orderstatus`,
    `o`.`o_orderdate`,
    `o`.`o_orderpriority`,
    `o`.`o_clerk`,
    `o`.`o_shippriority`
