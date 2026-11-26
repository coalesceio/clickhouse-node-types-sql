@id("0e1f0a00-0000-4000-8000-000000000305")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `cust_id` HAVING count() > 1", true, "After")
@postSQL("SELECT count() FROM {{ this }}")
SELECT
    generateUUIDv4() AS `QA_D_CT_SCD2_RMT_KEY` @id("a5d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("a5d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("a5d002"),
    `s`.`city`        AS `city`        @id("a5d003") @isChangeTracking,
    `s`.`tier`        AS `tier`        @id("a5d004") @isBusinessKey,
    `s`.`updated_at`  AS `updated_at`  @id("a5d005"),
    1                                                   AS `SYSTEM_VERSION`      @id("a5d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("a5d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("a5d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a5d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a5d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
