@id("6e545e5a-716f-4d20-b65f-6737c68ea8aa")
@nodeType("SQLFact")
@description("AN pipeline - Fact: one row per order, SCD Type 1 on l_orderkey; only orders with a newer last_receipt_date are reloaded")
@materializationType("table")
@writeMode("append")
@mergeStrategy("lastModified")
@partitionBy("toYear(`first_ship_date`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000", "max_bytes_in_join = 10000000000")
@optimize
@tests("SELECT `order_id` FROM {{ this }} FINAL GROUP BY `order_id` HAVING count() > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `order_sk` NOT IN (SELECT `order_sk` FROM {{ ref('TARGET', 'AN_DIM_ORDER') }} FINAL)", true, "After")
SELECT
    `w`.`l_orderkey`                  AS `order_id`            @id("afo01") @isBusinessKey @notNull @description("Order business key (l_orderkey)") @not_null @uniqueness,
    coalesce(`d`.`order_sk`, toUUID('00000000-0000-0000-0000-000000000000'))
                                      AS `order_sk`            @id("afo02") @notNull @description("Current AN_DIM_ORDER version; zero key when unresolved") @not_null,
    count()                           AS `line_count`          @id("afo03") @notNull @description("Line items on the order") @min_max("1", "7"),
    sum(`w`.`quantity`)               AS `total_quantity`      @id("afo04") @notNull @description("Total quantity") @min_value("0"),
    sum(`w`.`extended_price`)         AS `total_extended_price` @id("afo05") @notNull @description("Total extended price") @min_value("0"),
    sum(`w`.`extended_price` - `w`.`net_amount`) AS `total_discount_amount` @id("afo06") @notNull @description("Total discount given") @min_value("0"),
    sum(`w`.`net_amount`)             AS `total_net_amount`    @id("afo07") @notNull @description("Total net amount") @min_value("0"),
    sum(`w`.`gross_amount`)           AS `total_gross_amount`  @id("afo08") @notNull @description("Total gross amount") @min_value("0"),
    countIf(`w`.`ship_date` > `w`.`commit_date`) AS `late_line_count` @id("afo09") @notNull @description("Line items shipped after their commit date") @min_value("0"),
    countIf(`w`.`return_flag` = 'R')  AS `returned_line_count` @id("afo10") @notNull @description("Line items with return flag R") @min_value("0"),
    min(`w`.`ship_date`)              AS `first_ship_date`     @id("afo11") @notNull @description("First ship date"),
    max(`w`.`receipt_date`)           AS `last_receipt_date`   @id("afo12") @lastModifiedTracking @notNull @description("Latest receipt date; a newer value reloads the order") @relative_time(">=", "first_ship_date"),
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_CREATE_DATE`  @id("afo13") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_UPDATE_DATE`  @id("afo14") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
LEFT JOIN {{ ref('TARGET', 'AN_DIM_ORDER') }} `d`
  ON `d`.`order_id` = `w`.`l_orderkey` AND `d`.`SYSTEM_CURRENT_FLAG` = 'Y'
GROUP BY `w`.`l_orderkey`, `d`.`order_sk`
