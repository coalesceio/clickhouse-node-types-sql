@id("61e94dd9-67b3-4cd5-8bbf-e86323b6e47e")
@nodeType("SQLFact")
@description("AN pipeline - Fact: supplier activity per ship month, SCD Type 1 on (supplier_id, ship_month); any changed measure reloads the row")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@partitionBy("toYear(`ship_month`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000", "max_bytes_in_join = 10000000000")
@optimize
@tests("SELECT `supplier_id`, `ship_month` FROM {{ this }} FINAL GROUP BY `supplier_id`, `ship_month` HAVING count() > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `supplier_sk` NOT IN (SELECT `supplier_sk` FROM {{ ref('TARGET', 'AN_DIM_SUPPLIER') }} FINAL)", true, "After")
SELECT
    `w`.`supplier_key`                AS `supplier_id`         @id("afm01") @isBusinessKey @notNull @description("Supplier business key (l_suppkey)") @not_null,
    toStartOfMonth(`w`.`ship_date`)   AS `ship_month`          @id("afm02") @isBusinessKey @notNull @description("First day of the ship month") @not_null @min_max("toDate('1990-01-01')", "today()"),
    coalesce(`d`.`supplier_sk`, toUUID('00000000-0000-0000-0000-000000000000'))
                                      AS `supplier_sk`         @id("afm03") @notNull @description("Supplier surrogate key from AN_DIM_SUPPLIER; zero key when unresolved") @not_null,
    count()                           AS `line_count`          @id("afm04") @notNull @description("Line items shipped in the month") @min_value("1"),
    uniqExact(`w`.`l_orderkey`)       AS `order_count`         @id("afm05") @notNull @description("Distinct orders") @min_value("1"),
    uniqExact(`w`.`part_key`)         AS `part_count`          @id("afm06") @notNull @description("Distinct parts shipped") @min_value("1"),
    sum(`w`.`quantity`)               AS `total_quantity`      @id("afm07") @notNull @description("Total quantity") @min_value("0"),
    sum(`w`.`net_amount`)             AS `total_net_amount`    @id("afm08") @notNull @description("Total net amount") @min_value("0"),
    sum(`w`.`gross_amount`)           AS `total_gross_amount`  @id("afm09") @notNull @description("Total gross amount") @min_value("0"),
    countIf(`w`.`ship_date` > `w`.`commit_date`) AS `late_line_count` @id("afm10") @notNull @description("Line items shipped after their commit date") @min_value("0"),
    countIf(`w`.`return_flag` = 'R')  AS `returned_line_count` @id("afm11") @notNull @description("Line items with return flag R") @min_value("0"),
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_CREATE_DATE`  @id("afm12") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_UPDATE_DATE`  @id("afm13") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
LEFT JOIN {{ ref('TARGET', 'AN_DIM_SUPPLIER') }} `d`
  ON `d`.`supplier_id` = `w`.`supplier_key`
GROUP BY `w`.`supplier_key`, toStartOfMonth(`w`.`ship_date`), `d`.`supplier_sk`
