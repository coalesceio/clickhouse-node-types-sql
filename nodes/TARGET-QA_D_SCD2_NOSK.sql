@id("0e1f0a00-0000-4000-8000-00000000030a")
@nodeType("SQLDimension")

SELECT
    `s`.`cust_id`     AS `cust_id`     @id("b1d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("b1d002"),
    `s`.`city`        AS `city`        @id("b1d003") @isChangeTracking,
    `s`.`tier`        AS `tier`        @id("b1d004"),
    `s`.`updated_at`  AS `updated_at`  @id("b1d005"),
    1                                                   AS `SYSTEM_VERSION`      @id("b1d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b1d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("b1d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b1d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b1d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
