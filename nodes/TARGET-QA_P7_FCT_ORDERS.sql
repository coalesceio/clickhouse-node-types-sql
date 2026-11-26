@id("0e1f0a00-0000-4000-8000-000000000707")
@nodeType("SQLFact")
@description("P7 order fact: change tracking, customer key lookup with zero key fallback")
@orderBy("`order_id`", "`line_no`")
@partitionBy("toYYYYMM(`order_ts`)")
@tests("SELECT 1 FROM {{ this }} f LEFT ANTI JOIN {{ ref('TARGET', 'QA_P7_DIM_CUST') }} d ON d.`DIM_CUST_KEY` = f.`cust_key`", false, "After")
SELECT
    `o`.`order_id`        AS `order_id`            @id("7c0001") @isBusinessKey,
    `o`.`line_no`         AS `line_no`             @id("7c0002") @isBusinessKey,
    coalesce(`d`.`DIM_CUST_KEY`, toUUID('00000000-0000-0000-0000-000000000000')) AS `cust_key` @id("7c0003") @notNull,
    coalesce(`d`.`region_id`, 0) AS `region_id`       @id("7c0004"),
    `o`.`qty`             AS `qty`                 @id("7c0005"),
    `o`.`amount`          AS `amount`              @id("7c0006"),
    `o`.`order_ts`        AS `order_ts`            @id("7c0007"),
    now64(6)                AS `SYSTEM_CREATE_DATE`  @id("7c0093") @isSystemCreateDate,
    now64(6)                AS `SYSTEM_UPDATE_DATE`  @id("7c0094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_P7_STG_ORDERS') }} `o`
LEFT JOIN {{ ref('TARGET', 'QA_P7_DIM_CUST') }} `d` ON `d`.`cust_id` = `o`.`cust_id` AND `d`.`SYSTEM_CURRENT_FLAG` = 'Y'
