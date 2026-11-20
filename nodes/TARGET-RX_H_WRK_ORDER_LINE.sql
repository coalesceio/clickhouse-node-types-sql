@id("24e57576-72b8-5441-8a92-557243ee28c4")
@nodeType("SQLWork")
SELECT `o_orderkey` AS `l_orderkey`, CAST(1 AS UInt32) AS `l_linenumber`, `o_custkey` AS `o_custkey`, CAST(`o_orderkey` % 40 + 1 AS UInt32) AS `l_partkey`, `o_orderdate` AS `o_orderdate`, coalesce(`o_totalprice`, 0) AS `net_amount`
FROM {{ ref('SRC', 'rx_orders') }} `o`
