@id("5b52001a-d074-4e7e-83b8-58d78b1e8508")
@nodeType("SQLDimension")
@description("AN pipeline - Dimension: customer SCD Type 2 (new version on address, phone, nation or market segment change)")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@settings("index_granularity = 8192")
@querySettings("max_threads = 4", "max_memory_usage = 20000000000")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", false)
@tests("SELECT `c_custkey` FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `c_custkey` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()          AS `customer_key`        @id("adc01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key"),
    `w`.`c_custkey`           AS `c_custkey`           @id("adc02") @isBusinessKey @notNull @zeroKey("4294967295") @description("Customer business key") @not_null,
    `w`.`customer_name`       AS `customer_name`       @id("adc03") @notNull @zeroKey("'Unknown Customer'") @description("Customer name (updated in place)") @empty,
    `w`.`address`             AS `address`             @id("adc04") @isChangeTracking @notNull @description("Address (SCD2)"),
    `w`.`nation_key`          AS `nation_key`          @id("adc05") @isChangeTracking @notNull @zeroKey("4294967295") @description("Nation key (SCD2)"),
    `w`.`phone`               AS `phone`               @id("adc06") @isChangeTracking @notNull @description("Phone (SCD2)"),
    `w`.`market_segment`      AS `market_segment`      @id("adc07") @isChangeTracking @notNull @description("Market segment (SCD2)") @accepted_values("'AUTOMOBILE', 'BUILDING', 'FURNITURE', 'HOUSEHOLD', 'MACHINERY', 'UNKNOWN'"),
    `w`.`account_balance`     AS `account_balance`     @id("adc08") @notNull @zeroKey("0.00") @description("Account balance (updated in place)"),
    `w`.`comment`             AS `comment`             @id("adc09") @description("Customer comment (updated in place)"),
    1                         AS `SYSTEM_VERSION`      @id("adc10") @isSystemVersion @notNull,
    'Y'                       AS `SYSTEM_CURRENT_FLAG` @id("adc11") @isSystemCurrentFlag @notNull @accepted_values("'Y', 'N'"),
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("adc12") @isSystemEndDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("adc13") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("adc14") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_CUSTOMER') }} `w`
