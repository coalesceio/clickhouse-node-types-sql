@id("ea39418b-83a9-4bb6-b789-905e44746a64")
@nodeType("SQLDimension")
@description("AN line events - Dimension: ship mode, SCD Type 1 with last-modified tracking on last_event_date")
@materializationType("table")
@writeMode("append")
@mergeStrategy("lastModified")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1970-01-01 00:00:00")
@tests("SELECT `ship_mode` FROM {{ this }} FINAL GROUP BY `ship_mode` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()                         AS `ship_mode_sk`       @id("adm01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key"),
    `w`.`ship_mode`                          AS `ship_mode`          @id("adm02") @isBusinessKey @notNull @description("Shipping mode business key") @not_null @uniqueness,
    countIf(`w`.`event_type` = 'SHIP')       AS `line_count`         @id("adm03") @notNull @description("Line items shipped with this mode") @min_value("0"),
    min(`w`.`event_date`)                    AS `first_event_date`   @id("adm04") @notNull @description("First event date for this mode"),
    max(`w`.`event_date`)                    AS `last_event_date`    @id("adm05") @lastModifiedTracking(1) @notNull @description("Latest event date; a newer value overwrites the row (SCD1)") @relative_time(">=", "first_event_date"),
    CAST(now64(6) AS DateTime64(6))          AS `SYSTEM_CREATE_DATE` @id("adm06") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6))          AS `SYSTEM_UPDATE_DATE` @id("adm07") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINE_EVENTS') }} `w`
GROUP BY `w`.`ship_mode`
