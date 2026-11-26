@id("0e1f0a00-0000-4000-8000-000000000409")
@nodeType("SQLFact")
@description("fact with dim key lookups; unmatched -> zero key")
@orderBy("`order_id`", "`line_no`")
@partitionBy("toYYYYMM(`updated_at`)")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c9e001") @isBusinessKey,
    `f`.`line_no`     AS `line_no`     @id("c9e002") @isBusinessKey,
    coalesce(`d`.`QA_D_CT_SCD2_KEY`, toUUID('00000000-0000-0000-0000-000000000000')) AS `cust_key` @id("c9e003") @notNull,
    coalesce(`z`.`QA_D_ZEROKEY_KEY`, toUUID('11111111-1111-1111-1111-111111111111')) AS `cust_key_zk` @id("c9e004") @notNull,
    coalesce(`d`.`city`, 'UNKNOWN') AS `city` @id("c9e005"),
    `f`.`amount`      AS `amount`      @id("c9e006"),
    `f`.`updated_at`  AS `updated_at`  @id("c9e007"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c9e090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("c9e091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
LEFT JOIN {{ ref('TARGET', 'QA_D_CT_SCD2') }} `d` ON `d`.`cust_id` = `f`.`cust_id` AND `d`.`SYSTEM_CURRENT_FLAG` = 'Y'
LEFT JOIN {{ ref('TARGET', 'QA_D_ZEROKEY') }} `z` ON `z`.`cust_id` = `f`.`cust_id`
