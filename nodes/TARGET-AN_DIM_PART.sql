@id("5a4149f7-1beb-4042-ac44-c435cf279601")
@nodeType("SQLDimension")
@description("AN pipeline - Dimension: part with retail price history, SCD Type 2 on an explicit ReplacingMergeTree")
@materializationType("table")
@engine("ReplacingMergeTree")
@writeMode("append")
@mergeStrategy("changeTracking")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1970-01-01 00:00:00")
@tests("SELECT `part_id` FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `part_id` HAVING count() > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'N' AND `SYSTEM_END_DATE` >= `SYSTEM_UPDATE_DATE`", true, "After")
SELECT
    generateUUIDv4()                  AS `part_sk`             @id("adp01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key, new on every version"),
    `w`.`part_key`                    AS `part_id`             @id("adp02") @isBusinessKey @notNull @zeroKey("4294967295") @description("Part business key (l_partkey)") @not_null,
    CAST(round(avg(`w`.`extended_price` / `w`.`quantity`), 2) AS Decimal(12, 2))
                                      AS `retail_price`        @id("adp03") @isChangeTracking @notNull @zeroKey("0.00") @description("Retail price (extended_price / quantity); a change creates a new version (SCD2)") @min_value("0"),
    uniqExact(`w`.`supplier_key`)     AS `supplier_count`      @id("adp04") @notNull @description("Distinct suppliers shipping the part (updated in place)") @min_value("0"),
    count()                           AS `line_count`          @id("adp05") @notNull @description("Line items for the part (updated in place)") @min_value("0"),
    min(`w`.`ship_date`)              AS `first_ship_date`     @id("adp06") @notNull @description("First ship date (updated in place)"),
    max(`w`.`ship_date`)              AS `last_ship_date`      @id("adp07") @notNull @description("Latest ship date (updated in place)") @relative_time(">=", "first_ship_date"),
    1                                 AS `SYSTEM_VERSION`      @id("adp08") @isSystemVersion @notNull @min_value("1"),
    'Y'                               AS `SYSTEM_CURRENT_FLAG` @id("adp09") @isSystemCurrentFlag @notNull @accepted_values("'Y', 'N'"),
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("adp10") @isSystemEndDate @notNull,
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_CREATE_DATE`  @id("adp11") @isSystemCreateDate @notNull @relative_time("<=", "SYSTEM_END_DATE"),
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_UPDATE_DATE`  @id("adp12") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
WHERE `w`.`quantity` > 0
GROUP BY `w`.`part_key`
