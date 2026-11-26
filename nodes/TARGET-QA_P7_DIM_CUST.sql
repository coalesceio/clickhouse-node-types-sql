@id("0e1f0a00-0000-4000-8000-000000000705")
@nodeType("SQLDimension")
@description("P7 customer dimension, SCD2 on segment / city, zero key")
@zeroKey("00000000-0000-0000-0000-000000000000")
@orderBy("`cust_id`", "`SYSTEM_VERSION`")
@primaryKey("`cust_id`")
@tests("SELECT `cust_id` FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `cust_id` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()        AS `DIM_CUST_KEY`        @id("7a0000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`         AS `cust_id`             @id("7a0001") @isBusinessKey @zeroKey("0"),
    `s`.`cust_name`       AS `cust_name`           @id("7a0002"),
    `s`.`segment`         AS `segment`             @id("7a0003") @isChangeTracking,
    `s`.`city`            AS `city`                @id("7a0004") @isChangeTracking,
    `s`.`region_id`       AS `region_id`           @id("7a0005"),
    1                       AS `SYSTEM_VERSION`      @id("7a0090") @isSystemVersion,
    'Y'                     AS `SYSTEM_CURRENT_FLAG` @id("7a0091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("7a0092") @isSystemEndDate,
    now64(6)                AS `SYSTEM_CREATE_DATE`  @id("7a0093") @isSystemCreateDate,
    now64(6)                AS `SYSTEM_UPDATE_DATE`  @id("7a0094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_P7_STG_CUST') }} `s`
