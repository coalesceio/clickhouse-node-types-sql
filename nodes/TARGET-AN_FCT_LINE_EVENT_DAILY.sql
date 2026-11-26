@id("497dac89-3778-41be-8f26-29c2e2dc5a93")
@nodeType("SQLFact")
@description("AN line events - Fact: line events per day, event type and ship mode, SCD Type 1 on (event_date, event_type, ship_mode), with the AN_DIM_SHIP_MODE surrogate key lookup")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@partitionBy("toYear(`event_date`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000", "max_bytes_in_join = 10000000000")
@optimize
@tests("SELECT `event_date`, `event_type`, `ship_mode` FROM {{ this }} FINAL GROUP BY `event_date`, `event_type`, `ship_mode` HAVING count() > 1", false, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `ship_mode_sk` NOT IN (SELECT `ship_mode_sk` FROM {{ ref('TARGET', 'AN_DIM_SHIP_MODE') }} FINAL)", true, "After")
SELECT
    `w`.`event_date`                  AS `event_date`         @id("afe01") @isBusinessKey @notNull @description("Event date") @not_null,
    `w`.`event_type`                  AS `event_type`         @id("afe02") @isBusinessKey @notNull @description("SHIP, COMMIT or RECEIPT") @accepted_values("'SHIP', 'COMMIT', 'RECEIPT'"),
    `w`.`ship_mode`                   AS `ship_mode`          @id("afe03") @isBusinessKey @notNull @description("Shipping mode") @not_null,
    coalesce(`d`.`ship_mode_sk`, toUUID('00000000-0000-0000-0000-000000000000'))
                                      AS `ship_mode_sk`       @id("afe04") @notNull @description("Ship mode surrogate key from AN_DIM_SHIP_MODE; zero key when unresolved") @not_null,
    count()                           AS `line_count`         @id("afe05") @notNull @description("Line items with this event on the day") @min_value("1"),
    uniqExact(`w`.`l_orderkey`)       AS `order_count`        @id("afe06") @notNull @description("Distinct orders") @min_value("1"),
    uniqExact(`w`.`supplier_key`)     AS `supplier_count`     @id("afe07") @notNull @description("Distinct suppliers") @min_value("1"),
    sum(`w`.`quantity`)               AS `total_quantity`     @id("afe08") @notNull @description("Total quantity") @min_value("0"),
    sum(`w`.`net_amount`)             AS `total_net_amount`   @id("afe09") @notNull @description("Total net amount") @min_value("0"),
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_CREATE_DATE` @id("afe10") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_UPDATE_DATE` @id("afe11") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINE_EVENTS') }} `w`
LEFT JOIN {{ ref('TARGET', 'AN_DIM_SHIP_MODE') }} `d`
  ON `d`.`ship_mode` = `w`.`ship_mode`
GROUP BY `w`.`event_date`, `w`.`event_type`, `w`.`ship_mode`, `d`.`ship_mode_sk`
