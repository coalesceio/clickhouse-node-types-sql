@id("b1a00001-0000-4000-8000-000000000004")
@nodeType("SQLWork")
@description("Order lines (orderkey <= 500) with order header and net amount")
@orderBy("l_orderkey", "l_linenumber")
WITH `ord` AS (
    SELECT `o_orderkey`, `o_custkey`, `o_orderdate`, `o_orderstatus`
    FROM {{ ref('SRC', 'orders') }}
    WHERE `o_orderkey` <= 500
)
SELECT
     `l`.`l_orderkey` AS `l_orderkey` @notNull,
     `l`.`l_linenumber` AS `l_linenumber` @notNull,
     `ord`.`o_custkey` AS `o_custkey`,
     `l`.`l_partkey` AS `l_partkey`,
     `l`.`l_suppkey` AS `l_suppkey`,
     `ord`.`o_orderdate` AS `o_orderdate`,
     CAST(replaceAll(toString(`ord`.`o_orderstatus`), '\0', '') AS String) AS `o_orderstatus`,
     `l`.`l_quantity` AS `l_quantity`,
     `l`.`l_extendedprice` AS `l_extendedprice`,
     `l`.`l_discount` AS `l_discount`,
     `l`.`l_tax` AS `l_tax`,
     CAST(`l`.`l_extendedprice` * (1 - `l`.`l_discount`) * (1 + `l`.`l_tax`) AS Decimal(18, 4)) AS `net_amount`,
     `l`.`l_shipdate` AS `l_shipdate`
FROM {{ ref('SRC', 'lineitem') }} `l`
INNER JOIN `ord` ON `l`.`l_orderkey` = `ord`.`o_orderkey`
WHERE `l`.`l_orderkey` <= 500