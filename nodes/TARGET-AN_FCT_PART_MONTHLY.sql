@id("aac36045-9310-43c3-a0dd-af0a08ab5df9")
@nodeType("SQLFact")
@description("AN pipeline - Fact: part sales per ship month on an explicit ReplacingMergeTree; SCD Type 1 on (part_id, ship_month) by the default changeTracking strategy")
@materializationType("table")
@engine("ReplacingMergeTree")
@writeMode("append")
@partitionBy("toYear(`ship_month`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000", "max_bytes_in_join = 10000000000")
@optimize
@tests("SELECT `part_id`, `ship_month` FROM {{ this }} FINAL GROUP BY `part_id`, `ship_month` HAVING count() > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `part_sk` NOT IN (SELECT `part_sk` FROM {{ ref('TARGET', 'AN_DIM_PART') }} FINAL)", true, "After")
SELECT
    `w`.`part_key`                    AS `part_id`             @id("afq01") @isBusinessKey @notNull @description("Part business key (l_partkey)") @not_null,
    toStartOfMonth(`w`.`ship_date`)   AS `ship_month`          @id("afq02") @isBusinessKey @notNull @description("First day of the ship month") @not_null @min_max("toDate('1990-01-01')", "today()"),
    coalesce(`d`.`part_sk`, toUUID('00000000-0000-0000-0000-000000000000'))
                                      AS `part_sk`             @id("afq03") @notNull @description("Current AN_DIM_PART version; zero key when unresolved") @not_null,
    count()                           AS `line_count`          @id("afq04") @notNull @description("Line items shipped in the month") @min_value("1"),
    uniqExact(`w`.`supplier_key`)     AS `supplier_count`      @id("afq05") @notNull @description("Distinct suppliers shipping the part in the month") @min_value("1"),
    sum(`w`.`quantity`)               AS `total_quantity`      @id("afq06") @notNull @description("Total quantity") @min_value("0"),
    sum(`w`.`extended_price`)         AS `total_extended_price` @id("afq07") @notNull @description("Total extended price") @min_value("0"),
    sum(`w`.`net_amount`)             AS `total_net_amount`    @id("afq08") @notNull @description("Total net amount") @min_value("0"),
    sum(`w`.`gross_amount`)           AS `total_gross_amount`  @id("afq09") @notNull @description("Total gross amount") @min_value("0"),
    countIf(`w`.`return_flag` = 'R')  AS `returned_line_count` @id("afq10") @notNull @description("Line items with return flag R") @min_value("0"),
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_CREATE_DATE`  @id("afq11") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_UPDATE_DATE`  @id("afq12") @isSystemUpdateDate @notNull @description("ReplacingMergeTree version column: the latest copy wins") @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
LEFT JOIN {{ ref('TARGET', 'AN_DIM_PART') }} `d`
  ON `d`.`part_id` = `w`.`part_key` AND `d`.`SYSTEM_CURRENT_FLAG` = 'Y'
GROUP BY `w`.`part_key`, toStartOfMonth(`w`.`ship_date`), `d`.`part_sk`
