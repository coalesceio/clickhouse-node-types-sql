@id("3ef30fe4-0bea-45fb-850e-c52251c83fdc")
@nodeType("SQLFact")
@description("AN pipeline - Fact: orders with the current customer surrogate key (SCD1 on o_orderkey, newer updated_at only)")
@materializationType("table")
@writeMode("append")
@mergeStrategy("lastModified")
@partitionBy("toYYYYMM(`order_date`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 4", "max_memory_usage = 20000000000", "max_bytes_in_join = 10000000000")
@optimize
@tests("SELECT `o_orderkey` FROM {{ this }} FINAL WHERE `customer_key` NOT IN (SELECT `customer_key` FROM {{ ref('TARGET', 'AN_PL_DIM_CUSTOMER') }} FINAL)", true, "After")
SELECT
    `o`.`o_orderkey`             AS `o_orderkey`          @id("anf01") @isBusinessKey @notNull @description("Order business key") @not_null @uniqueness,
    coalesce(`d`.`customer_key`, toUUID('00000000-0000-0000-0000-000000000000'))
                                 AS `customer_key`        @id("anf02") @notNull @description("Customer surrogate key; zero key when unresolved"),
    `o`.`o_custkey`              AS `c_custkey`           @id("anf03") @notNull @description("Customer business key from the order"),
    `o`.`o_orderstatus`          AS `order_status`        @id("anf04") @notNull @defaultValue("'O'") @description("Order status") @accepted_values("'O', 'F', 'P'"),
    `o`.`o_orderdate`            AS `order_date`          @id("anf05") @notNull @description("Order date") @min_max("toDate('1990-01-01')", "today()"),
    CAST(coalesce(`o`.`o_totalprice`, 0) AS Decimal(12, 2))
                                 AS `total_price`         @id("anf06") @notNull @defaultValue("0.00") @description("Order total; 0 when missing") @min_value("0"),
    `o`.`o_comment`              AS `order_comment`       @id("anf07") @description("Order comment"),
    `o`.`updated_at`             AS `updated_at`          @id("anf08") @lastModifiedTracking @notNull @description("Source last-modified timestamp"),
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("anf09") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("anf10") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('SRC', 'rx_orders') }} `o`
LEFT JOIN {{ ref('TARGET', 'AN_PL_DIM_CUSTOMER') }} `d`
  ON `d`.`c_custkey` = `o`.`o_custkey` AND `d`.`SYSTEM_CURRENT_FLAG` = 'Y'
