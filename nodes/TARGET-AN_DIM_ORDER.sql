@id("8e9a3c99-1861-4140-9d37-755e1937a46c")
@nodeType("SQLDimension")
@description("AN pipeline - Dimension: order status history, SCD Type 2 with last-modified tracking on last_receipt_date")
@materializationType("table")
@writeMode("append")
@mergeStrategy("lastModified")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1970-01-01 00:00:00")
@tests("SELECT `order_id` FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `order_id` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()                     AS `order_sk`            @id("ado01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key, new on every version"),
    `w`.`l_orderkey`                     AS `order_id`            @id("ado02") @isBusinessKey @notNull @zeroKey("4294967295") @description("Order business key (l_orderkey)") @not_null,
    multiIf(countIf(`w`.`line_status` = 'F') = count(), 'F',
            countIf(`w`.`line_status` = 'O') = count(), 'O',
            'P')                         AS `order_status`        @id("ado03") @notNull @description("F all lines fulfilled, O all open, P partly fulfilled") @accepted_values("'F', 'O', 'P', 'UNKNOWN'"),
    count()                              AS `line_count`          @id("ado04") @notNull @description("Line items on the order") @min_max("0", "7"),
    countIf(`w`.`line_status` = 'F')     AS `fulfilled_line_count` @id("ado05") @notNull @description("Line items with line status F") @min_value("0"),
    countIf(`w`.`return_flag` = 'R')     AS `returned_line_count` @id("ado06") @notNull @description("Line items with return flag R") @min_value("0"),
    sum(`w`.`gross_amount`)              AS `order_gross_amount`  @id("ado07") @notNull @description("Sum of line gross amounts") @min_value("0"),
    min(`w`.`ship_date`)                 AS `first_ship_date`     @id("ado08") @notNull @description("First ship date"),
    max(`w`.`receipt_date`)              AS `last_receipt_date`   @id("ado09") @lastModifiedTracking(2) @notNull @description("Latest receipt date; a newer value expires the current version and inserts a new one (SCD2)") @relative_time(">=", "first_ship_date"),
    1                                    AS `SYSTEM_VERSION`      @id("ado10") @isSystemVersion @notNull @min_value("1"),
    'Y'                                  AS `SYSTEM_CURRENT_FLAG` @id("ado11") @isSystemCurrentFlag @notNull @accepted_values("'Y', 'N'"),
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("ado12") @isSystemEndDate @notNull,
    CAST(now64(6) AS DateTime64(6))      AS `SYSTEM_CREATE_DATE`  @id("ado13") @isSystemCreateDate @notNull @relative_time("<=", "SYSTEM_END_DATE"),
    CAST(now64(6) AS DateTime64(6))      AS `SYSTEM_UPDATE_DATE`  @id("ado14") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
GROUP BY `w`.`l_orderkey`
