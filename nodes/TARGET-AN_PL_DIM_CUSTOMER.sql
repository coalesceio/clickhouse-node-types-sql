@id("9af8ed53-681a-48bd-a8fd-8b4a472e777b")
@nodeType("SQLDimension")
@description("AN pipeline - Dimension: customer SCD Type 2 (change tracking on name, segment, status)")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@settings("index_granularity = 8192")
@querySettings("max_threads = 4", "max_memory_usage = 20000000000")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", false)
@tests("SELECT `c_custkey` FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `c_custkey` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()             AS `customer_key`        @id("and01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key"),
    `w`.`c_custkey`              AS `c_custkey`           @id("and02") @isBusinessKey @notNull @zeroKey("4294967295") @description("Customer business key") @not_null,
    `w`.`customer_name`          AS `customer_name`       @id("and03") @isChangeTracking @notNull @zeroKey("'Unknown Customer'") @description("Customer name (SCD2)") @empty,
    `w`.`segment`                AS `segment`             @id("and04") @isChangeTracking @notNull @description("Customer segment (SCD2)") @accepted_values("'RETAIL', 'CORPORATE', 'SMB', 'UNKNOWN'"),
    `w`.`status`                 AS `status`              @id("and05") @isChangeTracking @notNull @description("Customer status (SCD2)"),
    `w`.`market_segment`         AS `market_segment`      @id("and06") @notNull @description("Market segment (updated in place)"),
    `w`.`balance`                AS `balance`             @id("and07") @notNull @zeroKey("0.00") @description("Account balance (updated in place)") @min_max("-1000", "100000"),
    `w`.`is_active`              AS `is_active`           @id("and08") @notNull @description("Active flag (updated in place)"),
    `w`.`signup_date`            AS `signup_date`         @id("and09") @notNull @zeroKey("toDate('1970-01-01')") @description("Signup date"),
    `w`.`customer_attr_hash`     AS `customer_attr_hash`  @id("and10") @description("Attribute hash from the Work node"),
    1                            AS `SYSTEM_VERSION`      @id("and11") @isSystemVersion @notNull,
    'Y'                          AS `SYSTEM_CURRENT_FLAG` @id("and12") @isSystemCurrentFlag @notNull @accepted_values("'Y', 'N'"),
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("and13") @isSystemEndDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("and14") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("and15") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_PL_WRK_CUSTOMER') }} `w`
