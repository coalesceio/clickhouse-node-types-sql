@id("605e5f12-037a-4eda-be54-2a6c73147020")
@nodeType("SQLDimension")
@description("AN pipeline - Dimension: supplier activity, SCD Type 1 with last-modified tracking on last_receipt_date")
@materializationType("table")
@writeMode("append")
@mergeStrategy("lastModified")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1970-01-01 00:00:00")
@tests("SELECT `supplier_id` FROM {{ this }} FINAL GROUP BY `supplier_id` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()                   AS `supplier_sk`        @id("ads01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key"),
    `w`.`supplier_key`               AS `supplier_id`        @id("ads02") @isBusinessKey @notNull @zeroKey("4294967295") @description("Supplier business key (l_suppkey)") @not_null @uniqueness,
    count()                            AS `line_count`         @id("ads03") @notNull @description("Number of line items supplied") @min_value("0"),
    uniqExact(`w`.`l_orderkey`)        AS `order_count`        @id("ads04") @notNull @description("Number of distinct orders supplied") @min_value("0"),
    sum(`w`.`quantity`)                AS `total_quantity`     @id("ads05") @notNull @description("Total quantity supplied") @min_value("0"),
    sum(`w`.`net_amount`)              AS `total_net_amount`   @id("ads06") @notNull @description("Total net amount") @min_value("0"),
    countIf(`w`.`ship_date` > `w`.`commit_date`) AS `late_line_count` @id("ads07") @notNull @description("Line items shipped after their commit date") @min_value("0"),
    min(`w`.`ship_date`)               AS `first_ship_date`    @id("ads08") @notNull @description("First ship date"),
    max(`w`.`receipt_date`)            AS `last_receipt_date`  @id("ads09") @lastModifiedTracking(1) @notNull @description("Latest receipt date; a newer value overwrites the row (SCD1)") @relative_time(">=", "first_ship_date"),
    CAST(now64(6) AS DateTime64(6))    AS `SYSTEM_CREATE_DATE` @id("ads10") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6))    AS `SYSTEM_UPDATE_DATE` @id("ads11") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
GROUP BY `w`.`supplier_key`
