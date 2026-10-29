@id("b1a00001-0000-4000-8000-000000000021")
@nodeType("SQLFact")
@description("Order line fact with customer, part and supplier keys; unmatched members point at the zero-key record")
@orderBy("l_orderkey", "l_linenumber")
@partitionBy("toYYYYMM(o_orderdate)")
SELECT
     `ol`.`l_orderkey` AS `l_orderkey` @id("fo0001") @isBusinessKey @notNull,
     `ol`.`l_linenumber` AS `l_linenumber` @id("fo0002") @isBusinessKey @notNull,
     coalesce(`dc`.`customer_key`, toUUID('00000000-0000-0000-0000-000000000000')) AS `customer_key` @id("fo0003") @notNull,
     coalesce(`dp`.`part_key`, toUUID('00000000-0000-0000-0000-000000000000')) AS `part_key` @id("fo0004") @notNull,
     coalesce(`ds`.`supplier_key`, toUUID('00000000-0000-0000-0000-000000000000')) AS `supplier_key` @id("fo0005") @notNull,
     `ol`.`o_orderdate` AS `o_orderdate` @id("fo0006") @notNull,
     `ol`.`o_orderstatus` AS `o_orderstatus` @id("fo0007"),
     `ol`.`l_quantity` AS `l_quantity` @id("fo0008"),
     `ol`.`l_extendedprice` AS `l_extendedprice` @id("fo0009"),
     `ol`.`l_discount` AS `l_discount` @id("fo0010"),
     `ol`.`net_amount` AS `net_amount` @id("fo0011"),
     `ol`.`l_shipdate` AS `l_shipdate` @id("fo0012"),
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("fo0013") @isSystemCreateDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("fo0014") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDER_LINE') }} `ol`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc` ON `dc`.`c_custkey` = `ol`.`o_custkey` AND `dc`.`SYSTEM_CURRENT_FLAG` = 'Y'
LEFT JOIN {{ ref('TARGET', 'DIM_PART') }} `dp` ON `dp`.`p_partkey` = `ol`.`l_partkey`
LEFT JOIN {{ ref('TARGET', 'DIM_SUPPLIER') }} `ds` ON `ds`.`s_suppkey` = `ol`.`l_suppkey`
WHERE `ol`.`l_quantity` > 0