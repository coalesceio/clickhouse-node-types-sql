@id("ef4b629d-aa81-48ec-8524-9ef09cc568ab")
@nodeType("SQLDimension")
@description("Customer dimension, SCD Type 2 on segment and nation, ReplacingMergeTree")
@engine("ReplacingMergeTree")
@mergeStrategy("changeTracking")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@tests("SELECT `customer_id` FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `customer_id` HAVING count() > 1", false, "After")
@tests("SELECT `customer_id` FROM {{ ref('TARGET', 'FU_STG_CUSTOMER') }} GROUP BY `customer_id` HAVING count() > 1", false, "Before")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `SYSTEM_VERSION` = 2 HAVING count() <> 20", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `phone` = '' AND `SYSTEM_CURRENT_FLAG` = 'Y' AND `SYSTEM_CREATE_DATE` > toDateTime64(0, 6)", true, "After")
SELECT
    generateUUIDv4()                                     AS `FU_DIM_CUSTOMER_KEY` @id("b2d001") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c`.`customer_id`                                    AS `customer_id`         @id("b2d002") @isBusinessKey @notNull,
    `c`.`customer_name`                                  AS `customer_name`       @id("b2d003") @isChangeTracking,
    `c`.`email`                                          AS `email`               @id("b2d004"),
    `c`.`phone`                                          AS `phone`               @id("b2d00d"),
    `c`.`segment`                                        AS `segment`             @id("b2d005") @isChangeTracking,
    `c`.`nation_key`                                     AS `nation_key`          @id("b2d006"),
    `n`.`nation_name`                                    AS `nation_name`         @id("b2d007"),
    1                                                    AS `SYSTEM_VERSION`      @id("b2d008") @isSystemVersion,
    'Y'                                                  AS `SYSTEM_CURRENT_FLAG` @id("b2d009") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))  AS `SYSTEM_END_DATE`     @id("b2d00a") @isSystemEndDate,
    now64(6)                                             AS `SYSTEM_CREATE_DATE`  @id("b2d00b") @isSystemCreateDate,
    now64(6)                                             AS `SYSTEM_UPDATE_DATE`  @id("b2d00c") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'FU_STG_CUSTOMER') }} `c`
LEFT JOIN {{ ref('TARGET', 'FU_STG_NATION') }} `n` ON `n`.`n_Nationkey` = `c`.`nation_key`
