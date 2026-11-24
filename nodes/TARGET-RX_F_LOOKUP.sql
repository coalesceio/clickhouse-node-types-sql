@id("717a3eea-87f1-5c5c-9782-5910baa46a60")
@nodeType("SQLFact")
@engine("MergeTree")
@description("Order line fact with customer and part keys; unmatched members point at the zero-key record")
@orderBy("`l_orderkey`", "`l_linenumber`")
@partitionBy("toYYYYMM(`o_orderdate`)")
SELECT
    `ol`.`l_orderkey`        AS `l_orderkey`         @id("fo0001") @isBusinessKey @notNull,
    `ol`.`l_linenumber`      AS `l_linenumber`       @id("fo0002") @isBusinessKey @notNull,
    coalesce(`dc`.`customer_key`, toUUID('00000000-0000-0000-0000-000000000000')) AS `customer_key` @id("fo0003") @notNull,
    coalesce(`dp`.`part_key`, toUUID('00000000-0000-0000-0000-000000000000'))     AS `part_key`     @id("fo0004") @notNull,
    `ol`.`o_orderdate`       AS `o_orderdate`        @id("fo0006") @notNull,
    `ol`.`net_amount`        AS `net_amount`         @id("fo0011"),
    now64(6)                             AS `SYSTEM_CREATE_DATE` @id("fo0013") @isSystemCreateDate,
    now64(6)                             AS `SYSTEM_UPDATE_DATE` @id("fo0014") @isSystemUpdateDate
FROM {{ ref('TARGET', 'RX_H_WRK_ORDER_LINE') }} `ol`
LEFT JOIN {{ ref('TARGET', 'RX_H_DIM_CUSTOMER') }} `dc` ON `dc`.`c_custkey` = `ol`.`o_custkey` AND `dc`.`SYSTEM_CURRENT_FLAG` = 'Y'
LEFT JOIN {{ ref('TARGET', 'RX_H_DIM_PART') }} `dp` ON `dp`.`p_partkey` = `ol`.`l_partkey`
