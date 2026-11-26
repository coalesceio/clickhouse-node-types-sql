@id("f7b58d77-f4f7-43a2-adf4-95f828ce0983")
@nodeType("SQLWork")
@description("AN line events - Work table: customer JOIN region, using the TPC-H nation-to-region mapping on c_nationkey")
@materializationType("table")
@writeMode("truncateInsert")
@orderBy("`c_custkey`")
@settings("index_granularity = 8192")
@querySettings("max_threads = 4")
@tests("SELECT `c_custkey` FROM {{ this }} GROUP BY `c_custkey` HAVING count() > 1", false, "After")
SELECT
    `c`.`c_custkey`                                   AS `c_custkey`       @id("acr01") @notNull @description("Customer business key") @not_null @uniqueness,
    trimBoth(`c`.`c_name`)                            AS `customer_name`   @id("acr02") @notNull @description("Customer name") @empty,
    `c`.`c_nationkey`                                 AS `nation_key`      @id("acr03") @notNull @description("Nation key (TPC-H 0-24)") @min_max("0", "24"),
    `r`.`r_regionkey`                                 AS `region_key`      @id("acr04") @notNull @description("Region key (TPC-H 0-4)") @min_max("0", "4"),
    trimBoth(toStringCutToZero(`r`.`r_name`))         AS `region_name`     @id("acr05") @notNull @description("Region name") @accepted_values("'AFRICA', 'AMERICA', 'ASIA', 'EUROPE', 'MIDDLE EAST'"),
    trimBoth(toStringCutToZero(`c`.`c_mktsegment`))   AS `market_segment`  @id("acr06") @notNull @description("Market segment") @accepted_values("'AUTOMOBILE', 'BUILDING', 'FURNITURE', 'HOUSEHOLD', 'MACHINERY'"),
    `c`.`c_acctbal`                                   AS `account_balance` @id("acr07") @notNull @description("Account balance")
FROM {{ ref('SRC', 'customer') }} `c`
INNER JOIN {{ ref('SRC', 'region') }} `r`
  ON `r`.`r_regionkey` = transform(`c`.`c_nationkey`,
       CAST([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24] AS Array(UInt32)),
       CAST([0, 1, 1, 1, 4, 0, 3, 3, 2, 2, 4, 4, 2, 4, 0, 0, 0, 1, 2, 3, 4, 2, 3, 3, 1] AS Array(UInt32)),
       toUInt32(4294967295))
