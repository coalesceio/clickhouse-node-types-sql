@id("0e1f0a00-0000-4000-8000-00000000030d")
@nodeType("SQLDimension")
@writeMode("append")
@mergeStrategy("lastModified")
SELECT
    generateUUIDv4() AS `QA_D_TRUNC_SCD2_KEY` @id("b4d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("b4d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("b4d002"),
    `s`.`city`        AS `city`        @id("b4d003"),
    `s`.`tier`        AS `tier`        @id("b4d004"),
    `s`.`updated_at`  AS `updated_at`  @id("b4d005") @lastModifiedTracking(2),
    1                                                   AS `SYSTEM_VERSION`      @id("b4d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b4d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("b4d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b4d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b4d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
