@id("8f3166a0-047b-40e8-9f97-11d1a772e425")
@nodeType("SQLFact")
@description("AN pipeline - periodic snapshot Fact (plain insert): each run appends line-item counts and amounts by ship mode and line status")
@materializationType("table")
@writeMode("append")
@orderBy("`snapshot_at`", "`ship_mode`", "`line_status`")
@primaryKey("`snapshot_at`", "`ship_mode`")
@partitionBy("toYYYYMM(`snapshot_at`)")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_bytes_before_external_group_by = 10000000000")
@tests("SELECT 1 FROM {{ this }} HAVING countIf(`snapshot_at` = (SELECT max(`snapshot_at`) FROM {{ this }})) = 0", false, "After")
@tests("SELECT `snapshot_at`, `ship_mode`, `line_status` FROM {{ this }} GROUP BY `snapshot_at`, `ship_mode`, `line_status` HAVING count() > 1", true, "After")
SELECT
    CAST(now64(6) AS DateTime64(6))   AS `snapshot_at`        @id("afp01") @notNull @description("Load time of the snapshot; the same for every row of one run") @freshness(1, "DAY"),
    `w`.`ship_mode`                 AS `ship_mode`          @id("afp02") @notNull @description("Shipping mode") @accepted_values("'AIR', 'REG AIR', 'RAIL', 'SHIP', 'TRUCK', 'MAIL', 'FOB'"),
    `w`.`line_status`               AS `line_status`        @id("afp03") @notNull @description("Line status") @accepted_values("'O', 'F'"),
    count()                           AS `line_count`         @id("afp04") @notNull @description("Line items") @min_value("1"),
    uniqExact(`w`.`l_orderkey`)       AS `order_count`        @id("afp05") @notNull @description("Distinct orders") @min_value("1"),
    countIf(`w`.`ship_date` > `w`.`commit_date`) AS `late_line_count` @id("afp06") @notNull @description("Line items shipped after their commit date") @min_value("0"),
    sum(`w`.`quantity`)               AS `total_quantity`     @id("afp07") @notNull @description("Total quantity") @min_value("0"),
    sum(`w`.`net_amount`)             AS `total_net_amount`   @id("afp08") @notNull @description("Total net amount") @min_value("0"),
    sum(`w`.`gross_amount`)           AS `total_gross_amount` @id("afp09") @notNull @description("Total gross amount") @min_value("0"),
    CAST(now64(6) AS DateTime64(6))   AS `SYSTEM_CREATE_DATE` @id("afp10") @isSystemCreateDate @notNull @description("Insert time, written as computed")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
GROUP BY `w`.`ship_mode`, `w`.`line_status`
