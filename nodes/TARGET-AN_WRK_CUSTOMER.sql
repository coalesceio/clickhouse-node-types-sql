@id("82bc162c-93a5-47c7-94c1-929b26de23bc")
@nodeType("SQLWork")
@description("AN pipeline - Work view: customer with FixedString padding removed and text trimmed")
@materializationType("view")
@final
@querySettings("max_threads = 4")
SELECT
    `c`.`c_custkey`                               AS `c_custkey`       @id("awc01") @notNull @description("Customer business key") @not_null @uniqueness,
    trimBoth(`c`.`c_name`)                        AS `customer_name`   @id("awc02") @notNull @description("Customer name") @empty,
    trimBoth(`c`.`c_address`)                     AS `address`         @id("awc03") @notNull @description("Customer address"),
    `c`.`c_nationkey`                             AS `nation_key`      @id("awc04") @notNull @description("Nation key (TPC-H 0-24)") @min_max("0", "24"),
    trimBoth(toStringCutToZero(`c`.`c_phone`))    AS `phone`           @id("awc05") @notNull @description("Phone number") @empty,
    `c`.`c_acctbal`                               AS `account_balance` @id("awc06") @notNull @description("Account balance") @min_max("toDecimal64('-999.99', 2)", "toDecimal64('9999.99', 2)"),
    trimBoth(toStringCutToZero(`c`.`c_mktsegment`)) AS `market_segment` @id("awc07") @notNull @description("Market segment") @accepted_values("'AUTOMOBILE', 'BUILDING', 'FURNITURE', 'HOUSEHOLD', 'MACHINERY'"),
    `c`.`c_comment`                               AS `comment`         @id("awc08") @description("Customer comment")
FROM {{ ref('SRC', 'customer') }} `c`
