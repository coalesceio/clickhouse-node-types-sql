@id("bfb9af9f-ad7e-4e64-b725-dca6d84d734e")
@nodeType("SQLWork")
SELECT
     `l_orderkey` AS `l_orderkey`,
     `l_partkey` AS `l_partkey`,
     `l_suppkey` AS `l_suppkey`,
     `l_linenumber` AS `l_linenumber`,
     `l_quantity` AS `l_quantity`,
     `l_extendedprice` AS `l_extendedprice`,
     `l_discount` AS `l_discount`,
     `l_tax` AS `l_tax`,
     `l_returnflag` AS `l_returnflag`,
     `l_linestatus` AS `l_linestatus`,
     `l_shipdate` AS `l_shipdate`,
     `l_commitdate` AS `l_commitdate`,
     `l_receiptdate` AS `l_receiptdate`,
     `l_shipinstruct` AS `l_shipinstruct`,
     `l_shipmode` AS `l_shipmode`,
     `l_comment` AS `l_comment`
FROM {{ ref('SRC', 'lineitem') }} `lineitem`
ORDER BY `l_orderkey` desc
LIMIT 2 BY `l_orderkey`