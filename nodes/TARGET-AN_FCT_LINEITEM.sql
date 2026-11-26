@id("a767bdd2-07de-45d4-b2fa-ad47b821d528")
@nodeType("SQLFact")
@description("AN pipeline - Fact: line items, SCD Type 1 on (l_orderkey, l_linenumber)")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@partitionBy("toYYYYMM(`ship_date`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `gross_amount` < `net_amount`", true, "After")
SELECT
    `w`.`l_orderkey`          AS `l_orderkey`         @id("afl01") @isBusinessKey @notNull @description("Order key") @not_null,
    `w`.`l_linenumber`        AS `l_linenumber`       @id("afl02") @isBusinessKey @notNull @description("Line number") @not_null,
    `w`.`part_key`            AS `part_key`           @id("afl03") @notNull @description("Part key"),
    `w`.`supplier_key`        AS `supplier_key`       @id("afl04") @notNull @description("Supplier key"),
    `w`.`quantity`            AS `quantity`           @id("afl05") @notNull @description("Quantity") @min_value("0"),
    `w`.`extended_price`      AS `extended_price`     @id("afl06") @notNull @description("Extended price"),
    `w`.`discount`            AS `discount`           @id("afl07") @notNull @description("Discount rate"),
    `w`.`tax`                 AS `tax`                @id("afl08") @notNull @description("Tax rate"),
    `w`.`net_amount`          AS `net_amount`         @id("afl09") @notNull @description("Net amount") @min_value("0"),
    `w`.`gross_amount`        AS `gross_amount`       @id("afl10") @notNull @description("Gross amount") @min_value("0"),
    `w`.`return_flag`         AS `return_flag`        @id("afl11") @notNull @description("Return flag") @accepted_values("'R', 'A', 'N'"),
    `w`.`line_status`         AS `line_status`        @id("afl12") @notNull @description("Line status") @accepted_values("'O', 'F'"),
    `w`.`ship_date`           AS `ship_date`          @id("afl13") @notNull @description("Ship date"),
    `w`.`commit_date`         AS `commit_date`        @id("afl14") @notNull @description("Commit date"),
    `w`.`receipt_date`        AS `receipt_date`       @id("afl15") @notNull @description("Receipt date") @relative_time(">=", "ship_date"),
    dateDiff('day', `w`.`ship_date`, `w`.`receipt_date`) AS `days_in_transit` @id("afl16") @notNull @description("Days from ship to receipt") @min_value("0"),
    CAST(`w`.`ship_date` > `w`.`commit_date` AS Bool) AS `is_late_shipment` @id("afl17") @notNull @description("Shipped after the commit date"),
    `w`.`ship_mode`           AS `ship_mode`          @id("afl18") @notNull @description("Shipping mode"),
    `w`.`ship_instruct`       AS `ship_instruct`      @id("afl19") @notNull @description("Shipping instruction"),
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("afl20") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("afl21") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
