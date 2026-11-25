@id("e3747b52-2711-491e-a01d-53e239746054")
@nodeType("SQLWork")
@description("AN pipeline - Work: cleansed customers staged from rx_customer")
@materializationType("table")
@writeMode("truncateInsert")
@orderBy("`c_custkey`", "`updated_at`")
@primaryKey("`c_custkey`")
@settings("index_granularity = 8192", "min_bytes_for_wide_part = 0")
@querySettings("max_threads = 4", "max_block_size = 65536")
@tests("SELECT 1 FROM {{ ref('SRC', 'rx_customer') }} HAVING count() = 0", true, "Before")
@tests("SELECT `c_custkey` FROM {{ this }} GROUP BY `c_custkey` HAVING count() > 1", false, "After")
SELECT
    `c`.`c_custkey`              AS `c_custkey`          @id("anw01") @notNull @description("Customer business key") @not_null,
    trimBoth(`c`.`c_name`)       AS `customer_name`      @id("anw02") @notNull @description("Customer name, trimmed") @empty @inHash("GH_CUSTOMER_ATTR", 1),
    `c`.`segment`                AS `segment`            @id("anw03") @notNull @defaultValue("'UNKNOWN'") @description("Customer segment") @accepted_values("'RETAIL', 'CORPORATE', 'SMB'") @inHash("GH_CUSTOMER_ATTR", 2),
    `c`.`c_mktsegment`           AS `market_segment`     @id("anw04") @notNull @description("Market segment") @inHash("GH_CUSTOMER_ATTR", 3),
    `c`.`status`                 AS `status`             @id("anw05") @notNull @description("Customer status") @rejected_values("'DELETED'", "'TEST'"),
    `c`.`balance`                AS `balance`            @id("anw06") @notNull @defaultValue("0.00") @description("Account balance") @min_max("-1000", "100000"),
    `c`.`is_active`              AS `is_active`          @id("anw07") @notNull @description("Active flag"),
    `c`.`signup_date`            AS `signup_date`        @id("anw08") @notNull @description("Signup date") @min_max("toDate('2000-01-01')", "today()"),
    `c`.`created_at`             AS `created_at`         @id("anw09") @notNull @description("Source create timestamp"),
    `c`.`updated_at`             AS `updated_at`         @id("anw10") @notNull @description("Source update timestamp") @relative_time(">=", "created_at"),
    {{ get_hash('GH_CUSTOMER_ATTR', 'SHA256') }} AS `customer_attr_hash` @id("anw11") @description("SHA256 of customer_name, segment, market_segment")
FROM {{ ref('SRC', 'rx_customer') }} `c`
