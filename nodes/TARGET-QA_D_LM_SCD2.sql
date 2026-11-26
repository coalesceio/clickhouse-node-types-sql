@id("0e1f0a00-0000-4000-8000-000000000304")
@nodeType("SQLDimension")
@engine("MergeTree()")
@mergeStrategy("LASTMODIFIED")
@orderBy("`cust_id`", "`SYSTEM_VERSION`")
SELECT
    generateUUIDv4() AS `QA_D_LM_SCD2_KEY` @id("a4d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("a4d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("a4d002"),
    `s`.`city`        AS `city`        @id("a4d003"),
    `s`.`tier`        AS `tier`        @id("a4d004"),
    `s`.`updated_at`  AS `updated_at`  @id("a4d005") @lastModifiedTracking(2),
    1                                                   AS `SYSTEM_VERSION`      @id("a4d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("a4d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("a4d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a4d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a4d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
