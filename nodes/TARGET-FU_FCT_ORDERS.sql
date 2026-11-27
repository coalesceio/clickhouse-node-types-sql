@id("887b0a55-f2b6-403d-8d82-85dcd114b7e3")
@nodeType("SQLFact")
@description("Order fact with customer and nation surrogate keys; unmatched customers point at the zero key record")
@mergeStrategy("changeTracking")
@orderBy("`order_id`")
@partitionBy("toYYYYMM(`order_date`)")
@tests("SELECT 1 FROM {{ this }} WHERE `customer_key` = toUUID('00000000-0000-0000-0000-000000000000') HAVING count() <> 33", true, "After")
@tests("SELECT `f`.`order_id` FROM {{ this }} `f` LEFT ANTI JOIN (SELECT `FU_DIM_CUSTOMER_KEY` FROM {{ ref('TARGET', 'FU_DIM_CUSTOMER') }} FINAL) `d` ON `d`.`FU_DIM_CUSTOMER_KEY` = `f`.`customer_key`", true, "After")
SELECT
    `o`.`order_id`                                                                         AS `order_id`           @id("c3f001") @isBusinessKey @notNull,
    coalesce(`dc`.`FU_DIM_CUSTOMER_KEY`, toUUID('00000000-0000-0000-0000-000000000000'))   AS `customer_key`       @id("c3f002") @notNull,
    coalesce(`dn`.`FU_DIM_NATION_KEY`, toUUID('00000000-0000-0000-0000-000000000000'))     AS `nation_key`         @id("c3f003") @notNull,
    `o`.`order_date`                                                                       AS `order_date`         @id("c3f004") @notNull,
    `o`.`amount`                                                                           AS `amount`             @id("c3f005") @min_value("0"),
    `o`.`order_status`                                                                     AS `order_status`       @id("c3f006"),
    now64(6)                                                                               AS `SYSTEM_CREATE_DATE` @id("c3f007") @isSystemCreateDate,
    now64(6)                                                                               AS `SYSTEM_UPDATE_DATE` @id("c3f008") @isSystemUpdateDate
FROM {{ ref('TARGET', 'FU_STG_ORDERS') }} `o`
LEFT JOIN {{ ref('TARGET', 'FU_DIM_CUSTOMER') }} `dc` ON `dc`.`customer_id` = `o`.`customer_id` AND `dc`.`SYSTEM_CURRENT_FLAG` = 'Y'
LEFT JOIN {{ ref('TARGET', 'FU_DIM_NATION') }} `dn` ON `dn`.`n_Nationkey` = `dc`.`nation_key`
