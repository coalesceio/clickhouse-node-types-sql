@id("0e1f0a00-0000-4000-8000-00000000030b")
@nodeType("SQLDimension")
@engine("MergeTree")
@orderBy("`cust_id`", "`SYSTEM_VERSION`")
SELECT
    cityHash64(`s`.`cust_id`, now64(6)) AS `NUM_KEY` @id("b2d000") @isSurrogateKey,
    `s`.`cust_id`     AS `cust_id`     @id("b2d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("b2d002"),
    `s`.`city`        AS `city`        @id("b2d003") @isChangeTracking,
    `s`.`tier`        AS `tier`        @id("b2d004"),
    `s`.`updated_at`  AS `updated_at`  @id("b2d005"),
    1                                                   AS `SYSTEM_VERSION`      @id("b2d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b2d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("b2d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b2d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b2d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
