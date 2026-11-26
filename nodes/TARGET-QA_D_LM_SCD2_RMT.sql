@id("0e1f0a00-0000-4000-8000-000000000306")
@nodeType("SQLDimension")
@engine("replacingmergetree")
@mergeStrategy("lastModified")
@optimize
SELECT
    generateUUIDv4() AS `QA_D_LM_SCD2_RMT_KEY` @id("a6d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("a6d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("a6d002"),
    `s`.`city`        AS `city`        @id("a6d003"),
    `s`.`tier`        AS `tier`        @id("a6d004"),
    `s`.`updated_at`  AS `updated_at`  @id("a6d005") @lastModifiedTracking(2),
    1                                                   AS `SYSTEM_VERSION`      @id("a6d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("a6d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("a6d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a6d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a6d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
