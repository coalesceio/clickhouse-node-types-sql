@id("0e1f0a00-0000-4000-8000-000000000302")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@mergeStrategy("changeTracking")
SELECT
    generateUUIDv4() AS `QA_D_CT_SCD2_KEY` @id("a2d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("a2d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("a2d002"),
    `s`.`city`        AS `city`        @id("a2d003") @isChangeTracking,
    `s`.`tier`        AS `tier`        @id("a2d004"),
    `s`.`updated_at`  AS `updated_at`  @id("a2d005"),
    1                                                   AS `SYSTEM_VERSION`      @id("a2d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("a2d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("a2d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a2d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a2d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
