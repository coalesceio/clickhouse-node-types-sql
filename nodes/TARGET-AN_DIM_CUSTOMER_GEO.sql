@id("1230ce4c-e89e-4fa0-adad-71916aca2314")
@nodeType("SQLDimension")
@description("AN line events - Dimension: customer geography, SCD Type 2 (new version on nation, region or market segment change)")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@settings("index_granularity = 8192")
@querySettings("max_threads = 4")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", false)
@tests("SELECT `c_custkey` FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `c_custkey` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()          AS `customer_geo_sk`     @id("adg01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key"),
    `w`.`c_custkey`           AS `c_custkey`           @id("adg02") @isBusinessKey @notNull @zeroKey("4294967295") @description("Customer business key") @not_null,
    `w`.`customer_name`       AS `customer_name`       @id("adg03") @notNull @zeroKey("'Unknown Customer'") @description("Customer name (updated in place)"),
    `w`.`nation_key`          AS `nation_key`          @id("adg04") @isChangeTracking @notNull @zeroKey("4294967295") @description("Nation key (SCD2)"),
    `w`.`region_key`          AS `region_key`          @id("adg05") @isChangeTracking @notNull @zeroKey("4294967295") @description("Region key (SCD2)"),
    `w`.`region_name`         AS `region_name`         @id("adg06") @isChangeTracking @notNull @description("Region name (SCD2)") @accepted_values("'AFRICA', 'AMERICA', 'ASIA', 'EUROPE', 'MIDDLE EAST', 'UNKNOWN'"),
    `w`.`market_segment`      AS `market_segment`      @id("adg07") @isChangeTracking @notNull @description("Market segment (SCD2)") @accepted_values("'AUTOMOBILE', 'BUILDING', 'FURNITURE', 'HOUSEHOLD', 'MACHINERY', 'UNKNOWN'"),
    `w`.`account_balance`     AS `account_balance`     @id("adg08") @notNull @zeroKey("0.00") @description("Account balance (updated in place)"),
    1                         AS `SYSTEM_VERSION`      @id("adg09") @isSystemVersion @notNull,
    'Y'                       AS `SYSTEM_CURRENT_FLAG` @id("adg10") @isSystemCurrentFlag @notNull @accepted_values("'Y', 'N'"),
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("adg11") @isSystemEndDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("adg12") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("adg13") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_CUSTOMER_REGION') }} `w`
